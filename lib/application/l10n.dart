import 'package:flutter/material.dart';

class AppLocalization {
  final Locale locale;

  AppLocalization(this.locale);

  static AppLocalization of(BuildContext context) {
    return Localizations.of<AppLocalization>(context, AppLocalization)!;
  }

  static const Map<String, Map<String, String>> _localizedValues = {
    'en': {
      // --- Базовые сообщения ---
      'err_load_chats': 'Failed to load chat list.',
      'err_load_chat': 'Failed to load chat.',
      'err_load_characters': 'Failed to load character list.',
      'err_load_character': 'Failed to load character.',
      'err_export_character': 'Error exporting character.',
      'err_save_character': 'Error saving character.',
      'err_send_message': 'Error sending message.',
      'err_load_user_cards': 'Failed to load user cards list.',
      'err_save_user_card': 'Error saving user card.',
      'err_update_card': 'Error updating card.',
      'err_switch_message': 'Error switching message.',
      'err_edit_message': 'Error editing message.',
      'err_save_message': 'Error saving message.',
      'errRemoveMessage': 'Error deleting message.',
      'err_save_summary': 'Error saving history.',
      'err_load_settings': 'Failed to load settings.',
      'err_save_settings': 'Error saving settings.',
      'err_delete_chat': 'Error deleting chat.',
      'err_save_lorebook': 'Error saving lorebook.',
      'err_delete_lorebook': 'Error deleting lorebook.',
      'err_load_lore_entries': 'Failed to load entries list.',
      'error_network': 'Network error. Check your connection.',
      'error_unknown': 'An unknown error occurred.',
      'edit_text': 'Edit text',
      'cancel': 'Cancel',
      'save': 'Save',
      'delete': 'Delete',
      'no': 'No',
      'yes': 'Yes',
      'ready': 'Ready',
      'create_button': 'Create',
      // --- Меню ---
      'my_chats': 'My chats',
      'characters': 'Characters',
      'my_cards': 'My profiles',
      'settings': 'Settings',
      // --- Экран чата ---
      'chat_title': 'Chat with Character',
      'new_chat_tooltip': 'Start New Chat',
      'history_tooltip': 'Edit history',
      'character_typing': 'Character is typing...',
      'character_named_thinking': '{name} is thinking...',
      'select_chat': 'Select Chat',
      'change_role_button': 'Change Role',
      'select_role_button': 'Select Role',
      'write_something': 'Write something...',
      'select_role_text': 'Select a role for roleplay',
      'no_roles_text': 'You have no created roles yet.',
      'start_new_chat': 'Start a new chat?',
      'confirm_new_chat': 'Do you really want to start a new chat with the character?',
      'delete_chat': 'Delete Current Chat',
      'remove_message_title': 'Delete message?',
      'remove_message_alert':
          'Are you sure you want to delete the message?\nThe correspondence history after this message will also be deleted.',
      'empty_history': 'The story is still empty...',
      'history_subtitle':
          'A condensed history of your messages.\nYou can correct facts, fix AI issues, or add new lore details.',
      'history_title': 'Results of history',
      'attach_image': 'Attach an image',
      //  --- Экран списка чатов ---
      'chats_list_title': 'My AI Companions',
      'add_chat_button': '+',
      'no_chats':
          'You don\'t have any active chats yet.\nPress \'+\' at the top to select a character!',
      'no_last_message': 'No messages',
      'delete_chat_tooltip': 'Delete chat',
      'delete_chat_dialog_title': 'Deleting the chat',
      'delete_chat_dialog_message':
          'Are you sure you want to permanently delete the chat?\nAll chat history will be permanently deleted.',
      // --- Экран персонажей ---
      'characters_title': 'Choose Companion',
      'add_character_button': '+',
      'no_characters_message': 'The tavern is empty.\nClick \'+\' above to create a character.',
      'edit_prompts': 'Edit character prompts',
      'chat': 'Chat',
      // --- Экран создания персонажа ---
      'character_form_title_create': 'Create Character',
      'character_form_title_edit': 'Edit AI',
      'char_name_label': 'Character Name',
      'char_name_hint': 'For example: Felicity',
      'greeting_label': 'Starting Greeting',
      'greeting_hint': 'A line the bot will start the chat with',
      'appearance_label': 'Appearance',
      'appearance_hint': 'Describe face, clothing, race',
      'personality_label': 'Personality',
      'personality_hint': 'Character traits, speech style, fears',
      'scenario_label': 'Scenario',
      'scenario_hint': 'What situation or room you are in',
      'prompt_label': 'System Prompt / Instructions',
      'prompt_hint': 'Rules for LLM. For example: Always reply in English',
      'delete_button': 'Delete',
      'save_button': 'Save Changes',
      'char_create_button': 'Create Character',
      'validation_сhar_name': 'Enter a name',
      'avatar_label': 'Avatar',
      'background_label': 'Background image',
      'select_background': 'Select a background image',

      // --- Экран списка профилей ---
      'user_cards_title': 'My Roles (Profiles)',
      'add_user_card_button': '+',
      'no_user_cards_message':
          'Your wardrobe is empty...\nPress \'+\' at the top to create your profile!',
      'default_status': 'Default',
      'additional_status': 'Additional',

      // --- Форма профиля игрока ---
      'user_card_form_title_create': 'Create Player Profile',
      'user_card_form_title_edit': 'Edit Role',
      'card_name_label': 'Your Name/Nickname in this Role',
      'card_name_hint': 'For example: Ivan, Mage Arthur',
      'description_label': 'Character Description (Appearance, Lore, Race)',
      'description_hint': 'Describe yourself to the AI: Summoned familiar, wears a ring, human',
      'default_switch_title': 'Use as Default',
      'default_switch_subtitle': 'This role will be automatically selected for all new chats',
      'card_create_button': 'Create Profile',

      // --- Экран настроек ---
      'global_settings_title': 'General AI settings',
      'section_ollama_tokenizer': 'Selecting a model and tokenizer',
      'section_context_window': 'Context window size',
      'section_sampling_params': 'Sampling Parameters',
      'section_system_prompt': 'Global System Instructions',
      'label_main_model': 'Primary Text Model',
      'label_vision_model': 'Vision Model',
      'label_tokenizer': 'Local Tokenizer Dictionary',
      'label_provider': 'Provider',
      'label_context_limit': 'Context Token Limit',
      'label_context_size': '{num} tokens',
      'label_temperature': 'Temperature',
      'label_min_p': 'Min P',
      'label_top_p': 'Top P',
      'label_repeat_penalty': 'Repetition Penalty',
      'hint_system_prompt': 'Enter instructions that will be mixed into all chats...',
      'button_save_settings': 'Save Settings',
      'message_settings_saved': 'Settings saved successfully!',
      // --- Экраны книг ---
      'lorebooks': 'Lorebooks',
      'lorebooks_title': 'Lorebooks',
      'no_lorebooks_message':
          'You don\'t have any books...\nClick the \'+\' button above to create a new one.',
      'lorebook_form_title_create': 'Creation of a lorebook',
      'lorebook_form_title_edit': 'Editing the lorebook',
      'lorebook_name_label': 'The name of the lorebook',
      'lorebook_name_hint': 'For example: The World of Magic',
      'lorebook_about_label': 'Lorebook Description',
      'lorebook_about_hint': 'Describe the book',
      'loading_chronicles': 'Loading knowledge books...',
      'no_lorebook_entries':
          'There are no entries in this book yet.\nClick the "+" above to add content!',
      'lorebook_entry_number': '#',
      'title_add_lorebook_entry': 'Registering Knowledge Book Entry',
      'title_edit_lorebook_entry': 'Editing Knowledge Book Entry',
      'lore_hint_title': 'Knowledge block title (e.g., Water Magic)',
      'lore_hint_content': 'Description, facts, historical data, and information...',
      'lore_error_title_empty': 'Enter the knowledge book entry title',
      'lore_error_content_empty': 'Fill in the knowledge content',
      'lore_action_delete_entry': 'Delete entry',
      'lorebook_selection_title': 'Connecting Knowledge Bases',
      'no_lorebooks_warning':
          'No knowledge books have been created in the system yet.\nFirst, create a book in the Knowledge Book Manager.',
      'char_lorebooks': 'Knowledge Bases (Local RAG)',
      'char_lorebooks_count': 'Connected: {num} pcs.',
      'char_no_lorebooks_count': 'No connected books',

      // --- Окна ---
      'crop_avatar_title': 'Setting up an avatar',
      'replace_avatar_hint': 'Change your avatar image',

      'export': 'Export',
      'import': 'Import',
      'export_ext': 'Card V2',
      'import_ext': 'PNG/JSON',
    },
    'ru': {
      // --- Базовые сообщения ---
      'err_load_chats': 'Не удалось загрузить список чатов.',
      'err_load_chat': 'Не удалось загрузить чат.',
      'err_load_characters': 'Не удалось загрузить список персонажей.',
      'err_load_character': 'Не удалось загрузить персонажа.',
      'err_export_character': 'При экспорте персонажа возникла ошибка.',
      'err_save_character': 'При сохранении персонажа возникла ошибка.',
      'err_send_message': 'При отправке сообщения возникла ошибка.',
      'err_load_user_cards': 'При загрузке списка профилей возникла ошибка.',
      'err_save_user_card': 'Ошибка сохранения профиля.',
      'err_update_card': 'При обновлении карточки возникла ошибка.',
      'err_switch_message': 'При переключении сообщения возникла ошибка.',
      'err_edit_message': 'При редактировании сообщения возникла ошибка.',
      'err_save_message': 'При сохранении сообщения возникла ошибка.',
      'errRemoveMessage': 'При удалении сообщения возникла ошибка.',
      'err_save_summary': 'Ошибка при сохранении истории.',
      'err_load_settings': 'Ошибка при загрузке настроек.',
      'err_save_settings': 'Ошибка при сохранении настроек.',
      'err_delete_chat': 'При удалении чата возникла ошибка.',
      'err_save_lorebook': 'Ошибка сохранения книги знаний.',
      'err_delete_lorebook': 'Ошибка удаления книги знаний.',
      'err_load_lore_entries': 'Ошибка при загрузке записей.',
      'error_network': 'Ошибка сети. Проверьте подключение.',
      'error_unknown': 'Произошла неизвестная ошибка.',
      'edit_text': 'Редактировать текст',
      'cancel': 'Отмена',
      'save': 'Сохранить',
      'delete': 'Удалить',
      'no': 'Нет',
      'yes': 'Да',
      'ready': 'Готово',
      'create_button': 'Создать',
      // --- Меню ---
      'my_chats': 'Мои чаты',
      'characters': 'Персонажи',
      'my_cards': 'Мои профили',
      'settings': 'Настройки',
      // --- Экран чата ---
      'chat_title': 'Чат с персонажем',
      'new_chat_tooltip': 'Начать новый чат',
      'history_tooltip': 'Редактировать историю',
      'character_typing': 'Персонаж отвечает...',
      'character_named_thinking': '{name} думает...',
      'select_chat': 'Выберите чат',
      'change_role_button': 'Сменить роль',
      'select_role_button': 'Выбрать роль',
      'write_something': 'Напишите что-нибудь...',
      'select_role_text': 'Выберите роль для отыгрыша',
      'no_roles_text': 'У вас еще нет созданных ролей.',
      'start_new_chat': 'Начать новый чат?',
      'confirm_new_chat': 'Вы действительно хотите начать новый чат с персонажем?',
      'delete_chat': 'Удалить текущий чат',
      'remove_message_title': 'Удалить сообщение?',
      'remove_message_alert':
          'Вы уверены, что хотите удалить сообщение?\nИстория переписки после этого сообщения так же будет удалена.',
      'empty_history': 'История пока пуста...',
      'history_subtitle':
          'Сжатая история ваших сообщений.\nВы можете скорректировать факты, исправить косяки ИИ или вписать новые детали лора.',
      'history_title': 'Итоги истории',
      'attach_image': 'Прикрепить изображение',
      //  --- Экран списка чатов ---
      'chats_list_title': 'Мои ИИ-Компаньоны',
      'add_chat_button': '+',
      'no_chats': 'У вас еще нет активных чатов.\nНажмите \'+\' сверху, чтобы выбрать персонажа.',
      'no_last_message': 'Нет сообщений',
      'delete_chat_tooltip': 'Удалить чат.',
      'delete_chat_dialog_title': 'Удаление чата',
      'delete_chat_dialog_message':
          'Вы уверены, что хотите навсегда удалить чат?\nВся история переписки будут безвозвратно стёрты.',
      // --- Экран персонажей ---
      'characters_title': 'Выбор Компаньона',
      'add_character_button': '+',
      'no_characters_message':
          'В таверне пока пусто.\nНажмите \'+\' сверху, чтобы создать персонажа.',
      'edit_prompts': 'Редактировать промпты персонажа',
      'chat': 'Общаться',
      // --- Экран создания персонажа ---
      'character_form_title_create': 'Создать Персонажа',
      'character_form_title_edit': 'Редактировать ИИ',
      'char_name_label': 'Имя персонажа',
      'char_name_hint': 'Например: Felicity',
      'greeting_label': 'Стартовое приветствие (Greeting)',
      'greeting_hint': 'Реплика, с которой бот сам начнет чат',
      'appearance_label': 'Внешность (Appearance)',
      'appearance_hint': 'Опишите лицо, одежду, расу',
      'personality_label': 'Характер (Personality)',
      'personality_hint': 'Черты характера, манера речи, страхи',
      'scenario_label': 'Сценарий (Scenario)',
      'scenario_hint': 'В какой ситуации или комнате вы находитесь',
      'prompt_label': 'Системный Промпт / Инструкция',
      'prompt_hint': 'Правила для LLM. Например: Always reply in English',
      'delete_button': 'Удалить',
      'save_button': 'Сохранить изменения',
      'char_create_button': 'Создать персонажа',
      'validation_сhar_name': 'Введите имя',
      'avatar_label': 'Аватар',
      'background_label': 'Фоновое изображение',
      'select_background': 'Выбрать фоновое изображение',

      // --- Экран списка профилей ---
      'user_cards_title': 'Мои Роли (Профили)',
      'add_user_card_button': '+',
      'no_user_cards_message':
          'В вашей гардеробной ролей пока пусто...\nНажмите \'+\' сверху, чтобы создать свой профиль.',
      'default_status': 'По умолчанию',
      'additional_status': 'Дополнительная',

      // --- Форма профиля игрока ---
      'user_card_form_title_create': 'Создать Профиль Игрока',
      'user_card_form_title_edit': 'Редактировать Роль',
      'card_name_label': 'Твое Имя/Ник в этой роли',
      'card_name_hint': 'Например: Иван, Маг Артур',
      'description_label': 'Описание твоего персонажа (Внешность, лор, раса)',
      'description_hint': 'Опишите себя для ИИ: Призванный фамильяр, носит кольцо, человек',
      'default_switch_title': 'Использовать по умолчанию',
      'default_switch_subtitle': 'Эта роль будет автоматически выбираться для всех новых чатов',
      'card_create_button': 'Создать профиль',

      // --- Экран настроек ---
      'global_settings_title': 'Общие настройки ИИ',
      'section_ollama_tokenizer': 'Выбор модели и токенизатора',
      'section_context_window': 'Размер контекстного окна',
      'section_sampling_params': 'Параметры сэмплинга',
      'section_system_prompt': 'Глобальные системные инструкции',
      'label_main_model': 'Основная текстовая модель',
      'label_vision_model': 'Vision модель',
      'label_tokenizer': 'Локальный словарь токенизатора',
      'label_provider': 'Провайдер',
      'label_context_limit': 'Лимит токенов контекста',
      'label_context_size': '{num} tokens',
      'label_temperature': 'Temperature',
      'label_min_p': 'Min P',
      'label_top_p': 'Top P',
      'label_repeat_penalty': 'Repetition Penalty',
      'hint_system_prompt': 'Введите инструкции, которые будут подмешиваться ко всем чатам...',
      'button_save_settings': 'Сохранить настройки',
      'message_settings_saved': 'Настройки успешно сохранены!',

      // --- Экраны книг ---
      'lorebooks': 'Книги знаний',
      'lorebooks_title': 'Книги знаний',
      'no_lorebooks_message': 'У вас нет книг...\nНажмите \'+\' сверху, чтобы создать новую.',
      'lorebook_form_title_create': 'Создание книги знаний',
      'lorebook_form_title_edit': 'Редактирование книги знаний',
      'lorebook_name_label': 'Название книги знаний',
      'lorebook_name_hint': 'Например: Мир магии',
      'lorebook_about_label': 'Описание книги',
      'lorebook_about_hint': 'Опишите книгу',
      'loading_chronicles': 'Загрузка книг знаний...',
      'no_lorebook_entries':
          'В этой книге еще нет записей.\nНажмите на «+» сверху, чтобы добавить контент!',
      'lorebook_entry_number': '#',
      'title_add_lorebook_entry': 'Регистрация записи в книге знаний',
      'title_edit_lorebook_entry': 'Редактирование записи в книге знаний',
      'lore_hint_title': 'Название информационного блока (например: Магия воды)',
      'lore_hint_content': 'Описание, факты, исторические справки и информация...',
      'lore_error_title_empty': 'Введите название записи',
      'lore_error_content_empty': 'Заполните контент записи',
      'lore_action_delete_entry': 'Удалить запись',
      'lorebook_selection_title': 'Подключение баз знаний',
      'no_lorebooks_warning':
          'В системе еще не создано ни одной книги знаний.\nСначала создайте книгу в Менеджере книг знаний.',
      'char_lorebooks': 'Базы знаний (Локальная информация)',
      'char_lorebooks_count': 'Подключено: {num} шт.',
      'char_no_lorebooks_count': 'Нет подключенных книг',

      // --- Окна ---
      'crop_avatar_title': 'Настройка аватара',
      'replace_avatar_hint': 'Заменить изображение аватара',

      'export': 'Экспорт',
      'import': 'Импорт',
      'export_ext': 'Card V2',
      'import_ext': 'PNG/JSON',
    },
  };

  String contextSize(int tokens) {
    final template = _localizedValues[locale.languageCode]?['label_context_size'] ?? empty;
    return template.replaceAll('{num}', tokens.toString());
  }

  String charThinking(String name) {
    final template = _localizedValues[locale.languageCode]?['character_named_thinking'] ?? empty;
    return template.replaceAll('{name}', name);
  }

  String charLorebookCount(int count) {
    final template = _localizedValues[locale.languageCode]?['char_lorebooks_count'] ?? empty;
    return template.replaceAll('{num}', count.toString());
  }

  String get empty => '';
  String get chatPlaceholder => _localizedValues[locale.languageCode]?['chat_placeholder'] ?? empty;
  String get sendButton => _localizedValues[locale.languageCode]?['send_button'] ?? empty;
  String get noMessages => _localizedValues[locale.languageCode]?['no_messages'] ?? empty;
  String get errorNetwork => _localizedValues[locale.languageCode]?['error_network'] ?? empty;
  String get errorEmptyMessage =>
      _localizedValues[locale.languageCode]?['error_empty_message'] ?? empty;
  String get errorTooLong => _localizedValues[locale.languageCode]?['error_too_long'] ?? empty;
  String get typingIndicator => _localizedValues[locale.languageCode]?['typing_indicator'] ?? empty;
  String get errorUnknown => _localizedValues[locale.languageCode]?['error_unknown'] ?? empty;
  String get characterFormTitleCreate =>
      _localizedValues[locale.languageCode]?['character_form_title_create'] ?? empty;
  String get characterFormTitleEdit =>
      _localizedValues[locale.languageCode]?['character_form_title_edit'] ?? empty;
  String get avatarLabel => _localizedValues[locale.languageCode]?['avatar_label'] ?? empty;
  String get backgroundLabel => _localizedValues[locale.languageCode]?['background_label'] ?? empty;
  String get selectBackground =>
      _localizedValues[locale.languageCode]?['select_background'] ?? empty;

  String get charNameLabel => _localizedValues[locale.languageCode]?['char_name_label'] ?? empty;
  String get charNameHint => _localizedValues[locale.languageCode]?['char_name_hint'] ?? empty;
  String get greetingLabel => _localizedValues[locale.languageCode]?['greeting_label'] ?? empty;
  String get greetingHint => _localizedValues[locale.languageCode]?['greeting_hint'] ?? empty;
  String get appearanceLabel => _localizedValues[locale.languageCode]?['appearance_label'] ?? empty;
  String get appearanceHint => _localizedValues[locale.languageCode]?['appearance_hint'] ?? empty;
  String get personalityLabel =>
      _localizedValues[locale.languageCode]?['personality_label'] ?? empty;
  String get personalityHint => _localizedValues[locale.languageCode]?['personality_hint'] ?? empty;
  String get scenarioLabel => _localizedValues[locale.languageCode]?['scenario_label'] ?? empty;
  String get scenarioHint => _localizedValues[locale.languageCode]?['scenario_hint'] ?? empty;
  String get promptLabel => _localizedValues[locale.languageCode]?['prompt_label'] ?? empty;
  String get promptHint => _localizedValues[locale.languageCode]?['prompt_hint'] ?? empty;
  String get deleteButton => _localizedValues[locale.languageCode]?['delete_button'] ?? empty;
  String get saveButton => _localizedValues[locale.languageCode]?['save_button'] ?? empty;
  String get charCreateButton =>
      _localizedValues[locale.languageCode]?['char_create_button'] ?? empty;
  String get userCardsTitle => _localizedValues[locale.languageCode]?['user_cards_title'] ?? empty;
  String get addUserCardButton =>
      _localizedValues[locale.languageCode]?['add_user_card_button'] ?? empty;
  String get noUserCardsMessage =>
      _localizedValues[locale.languageCode]?['no_user_cards_message'] ?? empty;
  String get defaultStatus => _localizedValues[locale.languageCode]?['default_status'] ?? empty;
  String get additionalStatus =>
      _localizedValues[locale.languageCode]?['additional_status'] ?? empty;
  String get userCardFormTitleCreate =>
      _localizedValues[locale.languageCode]?['user_card_form_title_create'] ?? empty;
  String get userCardFormTitleEdit =>
      _localizedValues[locale.languageCode]?['user_card_form_title_edit'] ?? empty;
  String get cardNameLabel => _localizedValues[locale.languageCode]?['card_name_label'] ?? empty;
  String get cardNameHint => _localizedValues[locale.languageCode]?['card_name_hint'] ?? empty;
  String get descriptionLabel =>
      _localizedValues[locale.languageCode]?['description_label'] ?? empty;
  String get descriptionHint => _localizedValues[locale.languageCode]?['description_hint'] ?? empty;
  String get defaultSwitchTitle =>
      _localizedValues[locale.languageCode]?['default_switch_title'] ?? empty;
  String get defaultSwitchSubtitle =>
      _localizedValues[locale.languageCode]?['default_switch_subtitle'] ?? empty;
  String get cardCreateButton =>
      _localizedValues[locale.languageCode]?['card_create_button'] ?? empty;
  String get validationCharName =>
      _localizedValues[locale.languageCode]?['validation_сhar_name'] ?? empty;
  String get charactersTitle => _localizedValues[locale.languageCode]?['characters_title'] ?? empty;
  String get addCharacterButton =>
      _localizedValues[locale.languageCode]?['add_character_button'] ?? empty;
  String get noCharactersMessage =>
      _localizedValues[locale.languageCode]?['no_characters_message'] ?? empty;
  String get editPrompts => _localizedValues[locale.languageCode]?['edit_prompts'] ?? empty;
  String get chat => _localizedValues[locale.languageCode]?['chat'] ?? empty;
  String get chatsListTitle => _localizedValues[locale.languageCode]?['chats_list_title'] ?? empty;
  String get addChatButton => _localizedValues[locale.languageCode]?['add_chat_button'] ?? empty;
  String get noChats => _localizedValues[locale.languageCode]?['no_chats'] ?? empty;
  String get noLastMessage => _localizedValues[locale.languageCode]?['no_last_message'] ?? empty;
  String get chatTitle => _localizedValues[locale.languageCode]?['chat_title'] ?? empty;
  String get deleteChatTooltip =>
      _localizedValues[locale.languageCode]?['delete_chat_tooltip'] ?? empty;
  String get deleteChatDialogTitle =>
      _localizedValues[locale.languageCode]?['delete_chat_dialog_title'] ?? empty;
  String get deleteChatDialogMessage =>
      _localizedValues[locale.languageCode]?['delete_chat_dialog_message'] ?? empty;
  String get newChatTooltip => _localizedValues[locale.languageCode]?['new_chat_tooltip'] ?? empty;
  String get historyTooltip => _localizedValues[locale.languageCode]?['history_tooltip'] ?? empty;
  String get characterTyping => _localizedValues[locale.languageCode]?['character_typing'] ?? empty;
  String get selectChat => _localizedValues[locale.languageCode]?['select_chat'] ?? empty;
  String get changeRoleButton =>
      _localizedValues[locale.languageCode]?['change_role_button'] ?? empty;
  String get selectRoleButton =>
      _localizedValues[locale.languageCode]?['select_role_button'] ?? empty;
  String get writeSomething => _localizedValues[locale.languageCode]?['write_something'] ?? empty;
  String get selectRoleText => _localizedValues[locale.languageCode]?['select_role_text'] ?? empty;
  String get noRolesText => _localizedValues[locale.languageCode]?['no_roles_text'] ?? empty;
  String get startNewChat => _localizedValues[locale.languageCode]?['start_new_chat'] ?? empty;
  String get confirmNewChat => _localizedValues[locale.languageCode]?['confirm_new_chat'] ?? empty;
  String get deleteChat => _localizedValues[locale.languageCode]?['delete_chat'] ?? empty;
  String get editText => _localizedValues[locale.languageCode]?['edit_text'] ?? empty;
  String get cancel => _localizedValues[locale.languageCode]?['cancel'] ?? empty;
  String get save => _localizedValues[locale.languageCode]?['save'] ?? empty;
  String get delete => _localizedValues[locale.languageCode]?['delete'] ?? empty;
  String get no => _localizedValues[locale.languageCode]?['no'] ?? empty;
  String get yes => _localizedValues[locale.languageCode]?['yes'] ?? empty;
  String get ready => _localizedValues[locale.languageCode]?['ready'] ?? empty;
  String get myChats => _localizedValues[locale.languageCode]?['my_chats'] ?? empty;
  String get characters => _localizedValues[locale.languageCode]?['characters'] ?? empty;
  String get myCards => _localizedValues[locale.languageCode]?['my_cards'] ?? empty;
  String get settings => _localizedValues[locale.languageCode]?['settings'] ?? empty;
  String get removeMessageTitle =>
      _localizedValues[locale.languageCode]?['remove_message_title'] ?? empty;
  String get removeMessageAlert =>
      _localizedValues[locale.languageCode]?['remove_message_alert'] ?? empty;
  String get emptyHistory => _localizedValues[locale.languageCode]?['empty_history'] ?? empty;
  String get historySubtitle => _localizedValues[locale.languageCode]?['history_subtitle'] ?? empty;
  String get historyTitle => _localizedValues[locale.languageCode]?['history_title'] ?? empty;
  String get attachImage => _localizedValues[locale.languageCode]?['attach_image'] ?? empty;
  String get globalSettingsTitle =>
      _localizedValues[locale.languageCode]?['global_settings_title'] ?? empty;
  String get sectionOllamaTokenizer =>
      _localizedValues[locale.languageCode]?['section_ollama_tokenizer'] ?? empty;
  String get sectionContextWindow =>
      _localizedValues[locale.languageCode]?['section_context_window'] ?? empty;
  String get sectionSamplingParams =>
      _localizedValues[locale.languageCode]?['section_sampling_params'] ?? empty;
  String get sectionSystemPrompt =>
      _localizedValues[locale.languageCode]?['section_system_prompt'] ?? empty;
  String get labelMainModel => _localizedValues[locale.languageCode]?['label_main_model'] ?? empty;
  String get labelVisionModel =>
      _localizedValues[locale.languageCode]?['label_vision_model'] ?? empty;
  String get labelTokenizer => _localizedValues[locale.languageCode]?['label_tokenizer'] ?? empty;
  String get labelProvider => _localizedValues[locale.languageCode]?['label_provider'] ?? empty;
  String get labelContextLimit =>
      _localizedValues[locale.languageCode]?['label_context_limit'] ?? empty;
  String get labelTemperature =>
      _localizedValues[locale.languageCode]?['label_temperature'] ?? empty;
  String get labelMinP => _localizedValues[locale.languageCode]?['label_min_p'] ?? empty;
  String get labelTopP => _localizedValues[locale.languageCode]?['label_top_p'] ?? empty;
  String get labelRepeatPenalty =>
      _localizedValues[locale.languageCode]?['label_repeat_penalty'] ?? empty;
  String get hintSystemPrompt =>
      _localizedValues[locale.languageCode]?['hint_system_prompt'] ?? empty;
  String get buttonSettingsSaved =>
      _localizedValues[locale.languageCode]?['button_save_settings'] ?? empty;
  String get messageSettingsSaved =>
      _localizedValues[locale.languageCode]?['message_settings_saved'] ?? empty;
  String get cropAvatarTitle =>
      _localizedValues[locale.languageCode]?['crop_avatar_title'] ?? empty;
  String get replaceAvatarHint =>
      _localizedValues[locale.languageCode]?['replace_avatar_hint'] ?? empty;
  String get lorebooks => _localizedValues[locale.languageCode]?['lorebooks'] ?? empty;
  String get lorebooksTitle => _localizedValues[locale.languageCode]?['lorebooks_title'] ?? empty;
  String get noLorebooksMessage =>
      _localizedValues[locale.languageCode]?['no_lorebooks_message'] ?? empty;
  String get lorebookFormTitleEdit =>
      _localizedValues[locale.languageCode]?['lorebook_form_title_edit'] ?? empty;
  String get lorebookFormTitleCreate =>
      _localizedValues[locale.languageCode]?['lorebook_form_title_create'] ?? empty;
  String get lorebookNameLabel =>
      _localizedValues[locale.languageCode]?['lorebook_name_label'] ?? empty;
  String get lorebookNameHint =>
      _localizedValues[locale.languageCode]?['lorebook_name_hint'] ?? empty;
  String get lorebookAboutLabel =>
      _localizedValues[locale.languageCode]?['lorebook_about_label'] ?? empty;
  String get lorebookAboutHint =>
      _localizedValues[locale.languageCode]?['lorebook_about_hint'] ?? empty;
  String get createButton => _localizedValues[locale.languageCode]?['create_button'] ?? empty;
  String get loadingChronicles =>
      _localizedValues[locale.languageCode]?['loading_chronicles'] ?? empty;
  String get noLorebookEntries =>
      _localizedValues[locale.languageCode]?['no_lorebook_entries'] ?? empty;
  String get lorebookEntryNumber =>
      _localizedValues[locale.languageCode]?['lorebook_entry_number'] ?? empty;
  String get titleAddLorebookEntry =>
      _localizedValues[locale.languageCode]?['title_add_lorebook_entry'] ?? empty;
  String get titleEditLorebookEntry =>
      _localizedValues[locale.languageCode]?['title_edit_lorebook_entry'] ?? empty;
  String get loreHintTitle => _localizedValues[locale.languageCode]?['lore_hint_title'] ?? empty;
  String get loreHintContent =>
      _localizedValues[locale.languageCode]?['lore_hint_content'] ?? empty;
  String get loreErrorTitleEmpty =>
      _localizedValues[locale.languageCode]?['lore_error_title_empty'] ?? empty;
  String get loreErrorContentEmpty =>
      _localizedValues[locale.languageCode]?['lore_error_content_empty'] ?? empty;
  String get loreActionDeleteEntry =>
      _localizedValues[locale.languageCode]?['lore_action_delete_entry'] ?? empty;
  String get lorebookSelectionTitle =>
      _localizedValues[locale.languageCode]?['lorebook_selection_title'] ?? empty;
  String get noLorebooksWarning =>
      _localizedValues[locale.languageCode]?['no_lorebooks_warning'] ?? empty;
  String get charLorebooks => _localizedValues[locale.languageCode]?['char_lorebooks'] ?? empty;
  String get charNoLorebooks =>
      _localizedValues[locale.languageCode]?['char_no_lorebooks_count'] ?? empty;

  String get export =>
      _localizedValues[locale.languageCode]?['export'] ?? empty;
  String get import =>
      _localizedValues[locale.languageCode]?['import'] ?? empty;
  String get exportExt =>
      _localizedValues[locale.languageCode]?['export_ext'] ?? empty;
  String get imortExt =>
      _localizedValues[locale.languageCode]?['import_ext'] ?? empty;

  String getError(ErrType type, Object exception) {
    switch (type) {
      case ErrType.loadChats:
        return _localizedValues[locale.languageCode]?['err_load_chats'] ?? type.name;
      case ErrType.loadChat:
        return _localizedValues[locale.languageCode]?['err_load_chat'] ?? type.name;
      case ErrType.loadCharacters:
        return _localizedValues[locale.languageCode]?['err_load_characters'] ?? type.name;
      case ErrType.loadCharacter:
        return _localizedValues[locale.languageCode]?['err_load_character'] ?? type.name;
      case ErrType.exportCharacter:
        return _localizedValues[locale.languageCode]?['err_export_character'] ?? type.name;
      case ErrType.saveCharacter:
        return _localizedValues[locale.languageCode]?['err_save_character'] ?? type.name;
      case ErrType.sendMessage:
        return _localizedValues[locale.languageCode]?['err_send_message'] ?? type.name;
      case ErrType.loadUserCards:
        return _localizedValues[locale.languageCode]?['err_load_user_cards'] ?? type.name;
      case ErrType.saveUserCard:
        return _localizedValues[locale.languageCode]?['err_save_user_card'] ?? type.name;
      case ErrType.switchMessage:
        return _localizedValues[locale.languageCode]?['err_switch_message'] ?? type.name;
      case ErrType.updateCard:
        return _localizedValues[locale.languageCode]?['err_update_card'] ?? type.name;
      case ErrType.editMessage:
        return _localizedValues[locale.languageCode]?['err_edit_message'] ?? type.name;
      case ErrType.removeMessage:
        return _localizedValues[locale.languageCode]?['err_save_message'] ?? type.name;
      case ErrType.saveSummary:
        return _localizedValues[locale.languageCode]?['err_save_summary'] ?? type.name;
      case ErrType.loadSettings:
        return _localizedValues[locale.languageCode]?['err_load_settings'] ?? type.name;
      case ErrType.saveSettings:
        return _localizedValues[locale.languageCode]?['err_save_settings'] ?? type.name;
      case ErrType.deleteChat:
        return _localizedValues[locale.languageCode]?['err_delete_chat'] ?? type.name;
      case ErrType.saveLorebook:
        return _localizedValues[locale.languageCode]?['err_save_lorebook'] ?? type.name;
      case ErrType.deleteLorebook:
        return _localizedValues[locale.languageCode]?['err_delete_lorebook'] ?? type.name;
      case ErrType.loadLoreEntries:
        return _localizedValues[locale.languageCode]?['err_load_lore_entries'] ?? type.name;
    }
  }
}

typedef GetLocalizedErrorMessage = String Function(ErrType err, Object exception);

enum ErrType {
  loadChats,
  loadChat,
  loadCharacters,
  loadCharacter,
  saveCharacter,
  exportCharacter,
  sendMessage,
  loadUserCards,
  saveUserCard,
  switchMessage,
  updateCard,
  editMessage,
  removeMessage,
  saveSummary,
  loadSettings,
  saveSettings,
  deleteChat,
  saveLorebook,
  deleteLorebook,
  loadLoreEntries,
}

class AppLocalizationDelegate extends LocalizationsDelegate<AppLocalization> {
  const AppLocalizationDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'ru'].contains(locale.languageCode);

  @override
  Future<AppLocalization> load(Locale locale) async {
    return AppLocalization(locale);
  }

  @override
  bool shouldReload(AppLocalizationDelegate old) => false;
}
