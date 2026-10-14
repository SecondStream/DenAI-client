class MessageTags {
  static const String urlMarker = '{url}';
  static const String imgTemplate = '\n![x200]($urlMarker)\n';
  static const String img = '[img]';
  static const String imgXmlStart = '<attached_image>';
  static const String imgXmlEnd = '</attached_image>';
}

class TokenLimits {
  static const int templateTokens = 3;
  static const int summaryTokens = 500;
}

class DefaultSettings {
  static const int singleSettingsId = 1;
}
