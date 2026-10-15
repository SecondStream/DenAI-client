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
  static const String summarizePrompt = """
You are an advanced roleplay story summarizer.
Task: Update the existing story log summary with the new events from the chat logs provided below.
Keep the output extremely dense with facts, chronological, and brief. Focus on plot progression, character names, and key choices.
Write the summary strictly in English.
CRITICAL RULES:
1. Do not include any introductory phrases, greetings, or conclusions (e.g., NO 'Here is the summary...').
2. Start writing the summary content immediately from the first character.
3. Use a bullet-point list format for maximum density.

Summarize the lines of conversation provided, combining with the previous summary if it exists.
{{previous_summary}}
{{new_messages}}
New summary:
""";
  static const int minLenForLore = 5;
}
