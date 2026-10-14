import 'package:den_ai/models/chat.dart';
import 'package:den_ai/models/settings_base.dart';

class PromptRenderer {
  static String getSystemContent({
    required SettingsBase settings,
    required Chat chat,
    required String? summary,
  }) {
    final char = chat.char;
    final String charName = char.name;
    final String userName = chat.userCard?.name ?? "User";

    String renderPromptW(String text) {
      return renderPrompt(text, charName: charName, userName: userName);
    }

    final String trimmedAppearance = char.appearance.trim();
    final String trimmedPersonality = char.personality.trim();
    final String trimmedScenario = char.scenario.trim();
    final String trimmedSummary = summary?.trim() ?? "";

    String instructions = char.prompt.trim().isNotEmpty ? renderPromptW(char.prompt) : "";
    if (settings.globalSystemPrompt.trim().isNotEmpty) {
      if (instructions.isNotEmpty) instructions += "\n";
      instructions += renderPromptW(settings.globalSystemPrompt);
    }

    StringBuffer sb = StringBuffer();

    sb.writeln('[YOUR ROLES & IDENTITY:');
    sb.writeln('Name: $charName');
    if (trimmedAppearance.isNotEmpty) {
      sb.writeln('Physical Appearance & Lore: ${renderPromptW(trimmedAppearance)}');
    }
    if (trimmedPersonality.isNotEmpty) {
      sb.writeln('Personality/Traits: ${renderPromptW(trimmedPersonality)}');
    }
    sb.write(']');

    if (chat.userCard != null) {
      final String trimmedUserDesc = chat.userCard!.description.trim();
      sb.writeln('\n\n[THE USER / YOUR INTERACTION PARTNER:');
      sb.writeln('Name: $userName');
      if (trimmedUserDesc.isNotEmpty) {
        sb.writeln('Description/Bio: ${renderPromptW(trimmedUserDesc)}');
      }
      sb.write(']');
    }

    if (trimmedScenario.isNotEmpty) {
      sb.writeln('\n\n[SCENARIO & CONTEXT:');
      sb.writeln(renderPromptW(trimmedScenario));
      sb.write(']');
    }

    if (trimmedSummary.isNotEmpty) {
      sb.writeln('\n\n[THE STORY LOG SO FAR (PAST EVENTS):');
      sb.writeln(trimmedSummary);
      sb.write(']');
    }

    if (instructions.trim().isNotEmpty) {
      sb.writeln('\n\n[IMPORTANT SYSTEM INSTRUCTIONS & BEHAVIOR RULES:');
      sb.writeln(instructions);
      sb.write(']');
    }

    return cleanWhitespace(sb.toString());
  }

  static String renderNames(String text, {required String charName, required String userName}) {
    return text
        .replaceAll("{{char}}", charName)
        .replaceAll("{{CHAR}}", charName)
        .replaceAll("{{user}}", userName)
        .replaceAll("{{USER}}", userName);
  }

  static String removeComments(String text) {
    String cleanText = text.replaceAll(RegExp(r'/\*.*?\*/', dotAll: true), '');
    return cleanText;
  }

  static String renderMessage(String text, {required String charName, required String userName}) {
    if (text.isEmpty) return "";
    final cleanText = removeComments(text);
    return renderNames(cleanText, charName: charName, userName: userName);
  }

  static String renderPrompt(String text, {required String charName, required String userName}) {
    if (text.isEmpty) return "";
    final processedText = renderMessage(text, charName: charName, userName: userName);
    return fixBrackets(processedText);
  }

  static String fixBrackets(String text) {
    if (text.isEmpty) return "";

    final List<String> resultBackward = <String>[];
    int balance = 0;
    int bkt = 0;

    for (final char in text.split('').reversed) {
      switch (char) {
        case "[":
          if (balance <= 0) continue;
          balance--;
          break;
        case "]":
          balance++;
          break;
        case "(":
          if (bkt <= 0) continue;
          bkt--;
          break;
        case ")":
          bkt++;
          break;
        default:
          break;
      }
      resultBackward.add(char);
    }

    final String textBackward = resultBackward.reversed.join('');

    if (balance == 0 && bkt == 0) {
      return cleanWhitespace(textBackward);
    }

    final List<String> resultForward = <String>[];
    balance = 0;
    bkt = 0;

    for (final char in textBackward.split('')) {
      switch (char) {
        case "]":
          if (balance <= 0) continue;
          balance--;
          break;
        case "[":
          balance++;
          break;
        case ")":
          if (bkt <= 0) continue;
          bkt--;
          break;
        case "(":
          bkt++;
          break;
        default:
          break;
      }
      resultForward.add(char);
    }

    return cleanWhitespace(resultForward.join(''));
  }

  static String cleanWhitespace(String text) {
    String clean = text.trim();
    clean = clean.replaceAll(RegExp(r'[\r\n]{3,}'), '\n\n');
    return clean.replaceAll('\r\n', '\n');
  }
}
