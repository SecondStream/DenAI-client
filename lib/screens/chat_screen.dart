import 'package:chat_bot_client/application/config.dart';
import 'package:chat_bot_client/application/l10n.dart';
import 'package:chat_bot_client/blocs/chat/chat_bloc.dart';
import 'package:chat_bot_client/extensions/navigation_ext.dart';
import 'package:chat_bot_client/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:gpt_markdown/custom_widgets/markdown_config.dart';
import 'package:gpt_markdown/gpt_markdown.dart';

class ChatScreenArgs {
  final int? chatId;
  final int? charId;
  ChatScreenArgs({this.chatId, this.charId});
}

class ChatScreen extends StatefulWidget {
  final int? chatId;
  final int? charId;
  ChatScreen({super.key, required ChatScreenArgs args})
    : charId = args.charId,
      chatId = args.chatId;

  @override
  State<StatefulWidget> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 100,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loc = AppLocalization.of(context);
    return BlocProvider<ChatBloc>(
      create: (context) {
        final bloc = ChatBloc(GetIt.instance.get(), GetIt.instance.get(), GetIt.instance.get());
        if (widget.chatId != null) {
          bloc.add(LoadChatHistoryEvent(widget.chatId!));
        } else {
          bloc.add(CheckOrCreateVirtualChatEvent(widget.charId!));
        }
        return bloc;
      },
      child: BlocConsumer<ChatBloc, ChatState>(
        listener: (context, state) {
          if (state is ChatLoadedState) {
            WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text(state is! ChatLoadedState ? loc.chatTitle : state.char.name),
              actions: [
                Tooltip(
                  message: loc.historyTooltip,
                  child: IconButton(
                    icon: const Icon(Icons.menu_book, color: Colors.white, size: 24),
                    onPressed: () {
                      if (state is! ChatLoadedState || state.isAiTyping) return;
                      _showSummaryEditDialog(context, loc, state.summary);
                    },
                  ),
                ),
                Tooltip(
                  message: loc.newChatTooltip,
                  child: IconButton(
                    icon: const Icon(Icons.add_comment, color: Colors.white, size: 26),
                    onPressed: () {
                      if (state is! ChatLoadedState || state.isAiTyping) return;
                      _showNewChatConfirmationDialog(context, loc);
                    },
                  ),
                ),
              ],
            ),
            body: _buildBody(context, loc, theme, state),
          );
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, AppLocalization loc, ThemeData theme, ChatState state) {
    if (state is ChatLoadingState) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state is ChatErrorState) {
      return Center(
        child: Text(
          AppLocalization.of(context).getError(state.errType, state.error),
          style: const TextStyle(color: Colors.red),
        ),
      );
    }

    if (state is ChatLoadedState) {
      final bgUrl = state.background;
      final baseUrl = AppConfig.of(context).baseUrl;
      return Container(
        // 1. Накатываем фоновое изображение
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor, // Если фона нет, останется твоя стильная темнота
          image: bgUrl != null
              ? DecorationImage(
                  image: NetworkImage('$baseUrl/$bgUrl'),
                  fit: BoxFit.cover, // Растягиваем на весь экран чата
                )
              : null,
        ),
        child: Stack(
          children: [
            // 2. Если фон есть, размываем его и накладываем темный фильтр для идеальной читаемости текста
            // if (bgUrl != null)
            //   Positioned.fill(
            //     child: BackdropFilter(
            //       // Степень размытия (сигма 5-7 — идеальный кинематографичный баланс)
            //       filter: ImageFilter.blur(sigmaX: 7, sigmaY: 7),
            //       child: Container(
            //         // Накладываем 40% затемнение сверху, чтобы белый текст баблов не сливался с ярким артом
            //         color: Colors.black.withValues(alpha: 0.4),
            //       ),
            //     ),
            //   ),
            Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: state.messages.length,
                    itemBuilder: (context, index) {
                      final message = state.messages[index];
                      final isUser = message.role == "user";

                      return _buildMessageBubble(
                        context,
                        loc,
                        message,
                        isUser,
                        state.char,
                        state.userCard,
                        state.messages.last.id == message.id,
                        state.isAiTyping,
                      );
                    },
                  ),
                ),

                // if (state.isAiTyping && state.messages.last.content.isEmpty)
                //   Padding(
                //     padding: EdgeInsets.all(8.0),
                //     child: Text(
                //       loc.characterTyping,
                //       style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
                //     ),
                //   ),
                _buildInputZone(
                  context,
                  loc,
                  state.userCard,
                  state.availableCards,
                  state.isAiTyping,
                ),
              ],
            ),
          ],
        ),
      );
    }

    return Center(child: Text(loc.selectChat));
  }

  Widget _buildMessageBubble(
    BuildContext context,
    AppLocalization loc,
    Message message,
    bool isUser,
    Char char,
    UserCard? user,
    bool isLastMessage,
    bool isBlocked,
  ) {
    final theme = Theme.of(context);
    final baseUrl = AppConfig.of(context).baseUrl;

    final String? userAvatar = user?.getAvatar(baseUrl);
    final String? charAvatar = char.getAvatar(baseUrl);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isUser) ...[
            CircleAvatar(
              radius: 25,
              backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.15),
              backgroundImage: charAvatar == null ? null : NetworkImage(charAvatar),
              child: charAvatar == null
                  ? Text(
                      char.name.toUpperCase(),
                      style: const TextStyle(fontSize: 12, color: Colors.white),
                    )
                  : null,
            ),
            const SizedBox(width: 8),
          ],

          Column(
            crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: isUser
                      ? theme.scaffoldBackgroundColor.withValues(alpha: .95)
                      : theme.cardColor.withValues(alpha: .95),
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(12),
                    topRight: const Radius.circular(12),
                    bottomLeft: Radius.circular(isUser ? 12 : 0),
                    bottomRight: Radius.circular(isUser ? 0 : 12),
                  ),
                ),
                constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.65),
                child: SelectionArea(
                  child: GptMarkdown(
                    message.content.isNotEmpty
                        ? message.content
                        : isLastMessage && isBlocked
                        ? loc.characterTyping
                        : '',
                    style: TextStyle(
                      // Базовый цвет текста (для ИИ — мягкий белый, для юзера — чистый белый)
                      color: isUser ? Colors.white70 : Colors.white,
                      fontSize: 15,
                      height: 1.4,
                    ),
                    inlineComponents: [
                      ATagMd(),
                      ImageMd(),
                      StrikeMd(),
                      BoldMd(),
                      CustomItalicComponent(italicColor: isUser ? Colors.white38 : Colors.white54),
                      UnderLineMd(),
                    ],
                  ),
                ),
              ),

              if (message.id > 0) ...[
                // Фейковые сообщения (типа ID -99 или лоадеры) игнорируем
                const SizedBox(height: 4),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 💥 1. БЛОК СВАЙПОВ БОТА (Только для !isUser и если вариантов > 1)
                    if (!isUser && message.totalVariants > 1) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.arrow_left, size: 20, color: Colors.grey),
                              constraints: const BoxConstraints(),
                              padding: EdgeInsets.zero,
                              onPressed: isBlocked
                                  ? null
                                  : () {
                                      context.read<ChatBloc>().add(
                                        SwitchMessageBranchEvent(
                                          messageId: message.id,
                                          direction: "left",
                                        ),
                                      );
                                    },
                            ),
                            const SizedBox(width: 4),
                            Text(
                              "${message.currentIndex} / ${message.totalVariants}",
                              style: TextStyle(
                                color: theme.colorScheme.primary,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 4),
                            IconButton(
                              icon: const Icon(Icons.arrow_right, size: 20, color: Colors.grey),
                              constraints: const BoxConstraints(),
                              padding: EdgeInsets.zero,
                              onPressed: isBlocked
                                  ? null
                                  : () {
                                      context.read<ChatBloc>().add(
                                        SwitchMessageBranchEvent(
                                          messageId: message.id,
                                          direction: "right",
                                        ),
                                      );
                                    },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],

                    // 💥 2. РЕГЕНЕРАЦИЯ БОТА (Только для самого последнего сообщения бота)
                    if (!isUser && isLastMessage) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: IconButton(
                          icon: Icon(Icons.refresh, size: 16, color: theme.colorScheme.primary),
                          constraints: const BoxConstraints(),
                          padding: const EdgeInsets.all(2),
                          onPressed: isBlocked
                              ? null
                              : () {
                                  context.read<ChatBloc>().add(RegenerateLastAiMessageEvent());
                                },
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],

                    // 💥 3. КАНЦЕЛЯРСКИЙ КАРАНДАШ (Редактирование — у ВСЕХ сообщений)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.edit, size: 14, color: Colors.grey),
                        constraints: const BoxConstraints(),
                        padding: const EdgeInsets.all(2),
                        onPressed: isBlocked
                            ? null
                            : () {
                                _showEditMessageDialog(context, loc, message);
                              },
                      ),
                    ),

                    // 💥 4. КОРЗИНА УДАЛЕНИЯ (Только для сообщений ПОЛЬЗОВАТЕЛЯ)
                    if (isUser) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: IconButton(
                          icon: Icon(Icons.delete_outline, size: 14, color: Colors.red.shade400),
                          constraints: const BoxConstraints(),
                          padding: const EdgeInsets.all(2),
                          onPressed: isBlocked
                              ? null
                              : () => _onDeleteMessage(context, loc, theme, message.id),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ],
          ),
          if (isUser) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 25,
              backgroundColor: theme.colorScheme.secondary.withValues(alpha: 0.15),
              backgroundImage: userAvatar == null ? null : NetworkImage(userAvatar),
              child: userAvatar == null
                  ? const Icon(Icons.person, size: 18, color: Colors.grey)
                  : null,
            ),
          ],
        ],
      ),
    );
  }

  void _showSummaryEditDialog(BuildContext context, AppLocalization loc, String currentSummary) {
    final theme = Theme.of(context);
    final chatBloc = context.read<ChatBloc>();

    // Инициализируем контроллер текущим текстом синопсиса из твоего обновленного стейта
    final controller = TextEditingController(text: currentSummary);

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: theme.scaffoldBackgroundColor,
          title: Row(
            children: [
              Icon(Icons.auto_stories, color: theme.colorScheme.primary, size: 22),
              const SizedBox(width: 10),
              Text(loc.historyTitle),
            ],
          ),
          content: SizedBox(
            width: 600, // Делаем окно просторным для десктопного монитора
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  loc.historySubtitle,
                  style: TextStyle(color: Colors.grey, fontSize: 13, height: 1.3),
                ),
                const SizedBox(height: 16),

                // Многострочное поле для редактирования синопсиса
                Flexible(
                  child: TextField(
                    controller: controller,
                    maxLines: 12, // Даем много места под текст
                    minLines: 6,
                    keyboardType: TextInputType.multiline,
                    style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.4),
                    decoration: InputDecoration(
                      hintText: loc.emptyHistory,
                      hintStyle: TextStyle(color: Colors.grey.shade600),
                      fillColor: theme.cardColor,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.all(16),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
          actions: [
            // Кнопка Отмены
            TextButton(
              onPressed: () => dialogContext.pop(),
              child: Text(
                loc.cancel,
                style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
              ),
            ),

            // Кнопка Сохранения хроник
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              onPressed: () {
                dialogContext.pop(); // Закрываем блокнот

                final newText = controller.text.trim();
                // Шлем апдейт в Блок, только если текст реально изменился
                if (newText != currentSummary.trim()) {
                  chatBloc.add(UpdateChatSummaryEvent(newSummary: newText));
                }
              },
              child: Text(loc.save, style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  void _onDeleteMessage(
    BuildContext context,
    AppLocalization loc,
    ThemeData theme,
    int messageId,
  ) async {
    final res = await showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: theme.scaffoldBackgroundColor,
              title: Text("Удалить сообщение?", textAlign: TextAlign.center),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      "Вся история после этого сообщения будет удалена",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
              actions: [
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => dialogContext.pop(false),
                        style: TextButton.styleFrom(minimumSize: Size(double.infinity, 50)),
                        child: Text(
                          loc.no,
                          //style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.primary,
                          foregroundColor: Colors.white,
                          minimumSize: Size(double.infinity, 50),
                        ),
                        onPressed: () => dialogContext.pop(true),
                        child: Text(loc.yes, style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
    if (res == true && context.mounted) {
      context.read<ChatBloc>().add(DeleteMessageEvent(messageId: messageId));
    }
  }

  void _showEditMessageDialog(BuildContext context, AppLocalization loc, Message message) {
    final theme = Theme.of(context);
    final chatBloc = context.read<ChatBloc>();

    // Контроллер подтягивает старый текст
    final controller = TextEditingController(text: message.content);

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: theme.scaffoldBackgroundColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              Icon(Icons.edit_note, color: theme.colorScheme.primary, size: 24),
              const SizedBox(width: 10),
              Text(loc.editText, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
          content: SizedBox(
            width: 600, // Аккуратная десктопная ширина (не огромная и не мелкая)
            child: TextField(
              controller: controller,
              maxLines: null, // Поле будет само расширяться вниз, если текст длинный
              minLines: 2,
              keyboardType: TextInputType.multiline,
              style: const TextStyle(color: Colors.white, fontSize: 15, height: 1.4),
              decoration: InputDecoration(
                fillColor: theme.cardColor,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.all(16),
              ),
            ),
          ),
          actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
          actions: [
            // Кнопка отмены
            TextButton(
              onPressed: () => dialogContext.pop(),
              child: Text(
                loc.cancel,
                style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
              ),
            ),

            // Кнопка сохранения
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              ),
              onPressed: () {
                dialogContext.pop();
                final text = controller.text.trim();

                // Шлем апдейт, только если текст изменился и он не пустой
                if (text.isNotEmpty && text != message.content) {
                  chatBloc.add(EditMessageEvent(messageId: message.id, newContent: text));
                }
              },
              child: Text(loc.save, style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  // ignore: unused_element
  void _showEditMessageDialogOld(BuildContext context, AppLocalization loc, message) {
    final theme = Theme.of(context);
    final chatBloc = context.read<ChatBloc>();
    final controller = TextEditingController(text: message.content);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: theme.scaffoldBackgroundColor,
          title: Text(loc.editText),
          content: TextField(
            controller: controller,
            maxLines: null,
            keyboardType: TextInputType.multiline,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              fillColor: theme.cardColor,
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => context.pop(),
              child: Text(loc.cancel, style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: theme.colorScheme.primary),
              onPressed: () {
                context.pop();
                if (controller.text.trim().isNotEmpty &&
                    controller.text.trim() != message.content) {
                  chatBloc.add(
                    EditMessageEvent(messageId: message.id, newContent: controller.text.trim()),
                  );
                }
              },
              child: Text(
                loc.save,
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildInputZone(
    BuildContext context,
    AppLocalization loc,
    UserCard? userCard,
    List<UserCard>? availableCards,
    bool isBlocked,
  ) {
    final theme = Theme.of(context);
    final hasUserCard = userCard != null;
    final avatarUrl = userCard?.getAvatar(AppConfig.of(context).baseUrl);

    return Container(
      padding: const EdgeInsets.all(12),
      color: theme.appBarTheme.backgroundColor,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Tooltip(
            message: hasUserCard ? loc.changeRoleButton : loc.selectRoleButton,
            child: InkWell(
              onTap: () => isBlocked ? null : _showChangeCardDialog(context, loc, availableCards),
              borderRadius: BorderRadius.circular(22),
              child: Container(
                width: 44,
                height: 44,
                margin: const EdgeInsets.only(bottom: 2),
                decoration: BoxDecoration(shape: BoxShape.circle, color: theme.cardColor),
                clipBehavior: Clip.antiAlias,
                child: !hasUserCard
                    ? const Icon(Icons.account_circle, color: Colors.grey, size: 28)
                    : avatarUrl == null
                    ? const Icon(Icons.person, color: Colors.grey, size: 24)
                    : Image.network(
                        avatarUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.broken_image, color: Colors.grey, size: 24),
                      ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Shortcuts(
              shortcuts: <ShortcutActivator, Intent>{
                const SingleActivator(
                  LogicalKeyboardKey.enter,
                  shift: false,
                  control: false,
                  alt: false,
                ): const SendMessageIntent(),
              },
              child: Actions(
                actions: <Type, Action<Intent>>{
                  SendMessageIntent: CallbackAction<SendMessageIntent>(
                    onInvoke: (SendMessageIntent intent) {
                      if (!isBlocked) _sendMessage(context);
                      return null;
                    },
                  ),
                },
                child: TextField(
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  controller: _textController,
                  style: const TextStyle(color: Colors.white),
                  enabled: !isBlocked,
                  decoration: InputDecoration(
                    hintText: isBlocked ? loc.characterTyping : loc.writeSomething,
                    hintStyle: const TextStyle(color: Colors.grey),
                    fillColor: theme.cardColor,
                    filled: true,
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  ),
                  onSubmitted: (text) => isBlocked ? null : _sendMessage(context),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: Icon(Icons.send, color: isBlocked ? Colors.grey : theme.colorScheme.primary),
            onPressed: () => isBlocked ? null : _sendMessage(context),
          ),
        ],
      ),
    );
  }

  void _showChangeCardDialog(
    BuildContext context,
    AppLocalization loc,
    List<UserCard>? availableCards,
  ) {
    final theme = Theme.of(context);
    final chatBloc = context.read<ChatBloc>();

    if (availableCards == null) chatBloc.add(RequestUserCardsForDialogEvent());
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: theme.scaffoldBackgroundColor,
          title: Text(loc.selectRoleText, textAlign: TextAlign.center),
          content: SizedBox(
            width: 400,
            child: BlocBuilder<ChatBloc, ChatState>(
              bloc: chatBloc,
              builder: (context, dialogState) {
                if (dialogState is! ChatLoadedState) return const SizedBox();

                final cards = dialogState.availableCards;
                if (cards == null) {
                  return const SizedBox(
                    height: 100,
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                if (cards.isEmpty) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Text(loc.noRolesText, textAlign: TextAlign.center),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: cards.length,
                  itemBuilder: (context, index) {
                    final card = cards[index];
                    final isCurrent = dialogState.userCard?.id == card.id;
                    final avatarUrl = card.getAvatar(AppConfig.of(context).baseUrl);

                    return Card(
                      color: isCurrent
                          ? theme.colorScheme.primary.withValues(alpha: 0.2)
                          : theme.cardColor,
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: avatarUrl == null ? null : NetworkImage(avatarUrl),
                          child: card.avatar.isEmpty ? const Icon(Icons.person) : null,
                        ),
                        title: Text(card.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                        trailing: isCurrent
                            ? const Icon(Icons.check_circle, color: Colors.green)
                            : null,
                        onTap: () {
                          dialogContext.pop();
                          chatBloc.add(ChangeUserCardEvent(card.id));
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  void _showNewChatConfirmationDialog(BuildContext context, AppLocalization loc) {
    final theme = Theme.of(context);
    final chatBloc = context.read<ChatBloc>();

    bool deleteCurrent = true;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: theme.scaffoldBackgroundColor,
              title: Text(loc.startNewChat, textAlign: TextAlign.center),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      loc.confirmNewChat,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    title: Text(loc.deleteChat),
                    value: deleteCurrent,
                    activeThumbColor: theme.colorScheme.primary,
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    onChanged: (bool value) {
                      setDialogState(() {
                        deleteCurrent = value;
                      });
                    },
                  ),
                ],
              ),
              actions: [
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => dialogContext.pop(),
                        style: TextButton.styleFrom(minimumSize: Size(double.infinity, 50)),
                        child: Text(
                          loc.no,
                          //style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.primary,
                          foregroundColor: Colors.white,
                          minimumSize: Size(double.infinity, 50),
                        ),
                        onPressed: () {
                          chatBloc.add(StartNewChatSessionEvent(deleteCurrent));
                          dialogContext.pop();
                        },
                        child: Text(loc.yes, style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _sendMessage(BuildContext context) {
    if (_textController.text.trim().isEmpty) return;
    context.read<ChatBloc>().add(SendUserMessageEvent(_textController.text));
    _textController.clear();
  }
}

class SendMessageIntent extends Intent {
  const SendMessageIntent();
}

class CustomItalicComponent extends ItalicMd {
  final Color italicColor;

  CustomItalicComponent({this.italicColor = Colors.grey});

  @override
  // Добавлено: (?:$|...) — если закрывающей звездочки нет,
  // регулярка всё равно захватит текст до конца строки, что идеально для стриминга.
  RegExp get exp => RegExp(r"(?:(?<!\*)\*(?<!\s)(.+?)(?:(?<!\s)\*(?!\*)|$))", dotAll: true);

  @override
  InlineSpan span(BuildContext context, String text, final GptMarkdownConfig config) {
    // Безопасный поиск совпадения без принудительного trim()
    final match = exp.firstMatch(text);

    // Защита от null: если группа пустая, берем весь текст или пустую строку
    final data = match?[1] ?? text.replaceAll('*', '');

    final conf = config.copyWith(
      style: (config.style ?? const TextStyle()).copyWith(
        fontStyle: FontStyle.italic,
        color: italicColor,
      ),
    );

    return TextSpan(text: data, style: conf.style);
  }
}
// class CustomItalicComponent extends InlineMd {
//   final Color italicColor;

//   CustomItalicComponent({this.italicColor = Colors.grey});

//   @override
//   RegExp get exp => RegExp(r'(?<!\*)\*(?!\*)(.*?)(?:(?<!\*)\*(?!\*)|$)');

//   @override
//   InlineSpan span(BuildContext context, String text, GptMarkdownConfig config) {
//     return TextSpan(
//       text: text,
//       style: TextStyle(fontStyle: FontStyle.italic, color: italicColor),
//     );
//   }
// }
