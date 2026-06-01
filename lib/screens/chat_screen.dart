import 'package:cached_network_image/cached_network_image.dart';
import 'package:den_ai/application/config.dart';
import 'package:den_ai/application/l10n.dart';
import 'package:den_ai/blocs/chat/chat_bloc.dart';
import 'package:den_ai/consts/consts.dart';
import 'package:den_ai/extensions/navigation_ext.dart';
import 'package:den_ai/models/models.dart';
import 'package:den_ai/tools/file_tool.dart';
import 'package:den_ai/widgets/character_message.dart';
import 'package:den_ai/widgets/user_message.dart';
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
      _scrollController.jumpTo(
        _scrollController.position.maxScrollExtent,
        // duration: const Duration(milliseconds: 100),
        // curve: Curves.easeOut,
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
    final config = AppConfig.of(context);
    return BlocProvider<ChatBloc>(
      create: (context) {
        final bloc = ChatBloc(
          GetIt.instance.get(),
          GetIt.instance.get(),
          GetIt.instance.get(),
          config,
        );
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
          final isActionsBlocked = state is! ChatLoadedState || state.isAiTyping;
          return Scaffold(
            appBar: AppBar(
              title: Text(state is! ChatLoadedState ? loc.chatTitle : state.char.name),
              actions: [
                Tooltip(
                  message: isActionsBlocked ? loc.empty : loc.historyTooltip,
                  child: IconButton(
                    icon: const Icon(Icons.menu_book, color: Colors.white, size: 24),
                    onPressed: isActionsBlocked
                        ? null
                        : () {
                            _showSummaryEditDialog(context, loc, state.summary);
                          },
                  ),
                ),
                Tooltip(
                  message: isActionsBlocked ? loc.empty : loc.newChatTooltip,
                  child: IconButton(
                    icon: const Icon(Icons.add_comment, color: Colors.white, size: 26),
                    onPressed: isActionsBlocked
                        ? null
                        : () {
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
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          image: bgUrl != null
              ? DecorationImage(
                  image: CachedNetworkImageProvider('$baseUrl/$bgUrl'),
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: Stack(
          children: [
            // if (bgUrl != null)
            //   Positioned.fill(
            //     child: BackdropFilter(
            //       filter: ImageFilter.blur(sigmaX: 7, sigmaY: 7),
            //       child: Container(
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
                      return _buildMessageBubble(
                        context,
                        loc,
                        message,
                        state.char,
                        state.userCard,
                        state.isAiTyping,
                        state.messages.last.id == message.id,
                      );
                    },
                  ),
                ),
                _buildInputZone(
                  context,
                  loc,
                  state.userCard,
                  state.availableCards,
                  state.isAiTyping,
                ),
              ],
            ),

            if (state.selectedImageFile != null)
              Positioned(
                left: 112,
                bottom: 76,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      height: 110,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.5),
                            blurRadius: 12,
                            spreadRadius: 2,
                            offset: const Offset(0, 4), // Тень падает вниз
                          ),
                        ],
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Image.file(state.selectedImageFile!, fit: BoxFit.contain),
                    ),

                    Positioned(
                      top: -6,
                      right: -6,
                      child: InkWell(
                        onTap: () {
                          context.read<ChatBloc>().add(SelectImageEvent(null));
                        },
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.black87,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.close, size: 12, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
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
    Char char,
    UserCard? user,
    bool isTyping,
    bool isLastMessage,
  ) {
    final theme = Theme.of(context);
    late Widget messageWidget;
    if (message.role == MessageRole.user) {
      messageWidget = UserMessage(
        message: message,
        card: user,
        onEditMessage: isTyping
            ? null
            : (_) => _showEditMessageDialog(context, loc, theme, message),
        onDeleteMessage: isTyping
            ? null
            : (messageId) => _onDeleteMessage(context, loc, theme, messageId),
      );
    } else {
      messageWidget = CharacterMessage(
        char: char,
        message: message,
        isThinking: isTyping,
        onEditMessage: isTyping
            ? null
            : (_) => _showEditMessageDialog(context, loc, theme, message),

        onSwitchMessage: isTyping
            ? null
            : (messageId, direction) {
                context.read<ChatBloc>().add(
                  SwitchMessageBranchEvent(messageId: messageId, direction: direction),
                );
              },
        onRegenerateMessage: isTyping || !isLastMessage
            ? null
            : (messageId) {
                context.read<ChatBloc>().add(RegenerateLastAiMessageEvent());
              },
      );
    }

    return Padding(padding: const EdgeInsets.symmetric(vertical: 4), child: messageWidget);
  }

  void _showSummaryEditDialog(BuildContext context, AppLocalization loc, String currentSummary) {
    final theme = Theme.of(context);
    final chatBloc = context.read<ChatBloc>();
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
            width: 600,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  loc.historySubtitle,
                  style: TextStyle(color: Colors.grey, fontSize: 13, height: 1.3),
                ),
                const SizedBox(height: 16),

                Flexible(
                  child: TextField(
                    controller: controller,
                    maxLines: 12,
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
            TextButton(
              onPressed: () => dialogContext.pop(),
              child: Text(
                loc.cancel,
                style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              onPressed: () {
                dialogContext.pop();

                final newText = controller.text.trim();
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
              title: Text(loc.removeMessageTitle, textAlign: TextAlign.center),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      loc.removeMessageAlert,
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

  void _showEditMessageDialog(
    BuildContext context,
    AppLocalization loc,
    ThemeData theme,
    Message message,
  ) {
    final chatBloc = context.read<ChatBloc>();

    String editableContent = message.content;
    if (message.imagePath != null && message.imagePath!.isNotEmpty) {
      final regExp = RegExp(r'!\[.*?\]\((.*?)\)');
      final matches = regExp.allMatches(editableContent);

      for (final match in matches) {
        final String extractedUrl = match.group(1) ?? '';
        if (extractedUrl.contains(message.imagePath!)) {
          editableContent = editableContent.replaceRange(match.start, match.end, MessageTags.img);
          break;
        }
      }
    }
    final controller = TextEditingController(text: editableContent);

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
            width: 600,
            child: TextField(
              controller: controller,
              maxLines: null,
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
            TextButton(
              onPressed: () => dialogContext.pop(),
              child: Text(
                loc.cancel,
                style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
              ),
            ),
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
            message: isBlocked ? loc.empty : loc.cancel,
            child: IconButton(
              icon: const Icon(Icons.attach_file, color: Colors.grey, size: 22),
              onPressed: isBlocked ? null : () => _pickImage(context),
            ),
          ),
          const SizedBox(width: 4),
          Tooltip(
            message: isBlocked
                ? loc.empty
                : hasUserCard
                ? loc.changeRoleButton
                : loc.selectRoleButton,
            child: InkWell(
              onTap: isBlocked ? null : () => _showChangeCardDialog(context, loc, availableCards),
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
            onPressed: isBlocked ? null : () => _sendMessage(context),
          ),
        ],
      ),
    );
  }

  Future<void> _pickImage(BuildContext context) async {
    final image = await FileTool.pickImage();
    if (image != null && context.mounted) {
      context.read<ChatBloc>().add(SelectImageEvent(image));
    }
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
                          backgroundImage: avatarUrl == null
                              ? null
                              : CachedNetworkImageProvider(avatarUrl),
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
  RegExp get exp => RegExp(r"(?:(?<!\*)\*(?<!\s)(.+?)(?:(?<!\s)\*(?!\*)|$))", dotAll: true);

  @override
  InlineSpan span(BuildContext context, String text, final GptMarkdownConfig config) {
    final match = exp.firstMatch(text);
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
