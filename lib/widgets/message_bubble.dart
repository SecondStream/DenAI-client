import 'package:flutter/material.dart';
import 'package:gpt_markdown/custom_widgets/markdown_config.dart';
import 'package:gpt_markdown/gpt_markdown.dart';

class MessageBubble extends StatelessWidget {
  final MessagePosition position;
  final String message;

  const MessageBubble({
    super.key,
    required this.position,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isRight = position == MessagePosition.right;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: isRight
            ? theme.scaffoldBackgroundColor.withValues(alpha: .95)
            : theme.cardColor.withValues(alpha: .95),
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(12),
          topRight: const Radius.circular(12),
          bottomLeft: Radius.circular(isRight ? 12 : 0),
          bottomRight: Radius.circular(isRight ? 0 : 12),
        ),
      ),
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.65,
      ),
      child: GptMarkdown(
        message,
        style: TextStyle(
          color: isRight ? Colors.white70 : Colors.white,
          fontSize: 15,
          height: 1.4,
        ),
        inlineComponents: [
          ATagMd(),
          ImageMd(),
          StrikeMd(),
          BoldMd(),
          CustomItalicComponent(
            italicColor: isRight ? Colors.white38 : Colors.white54,
          ),
          UnderLineMd(),
          SourceTag(),
        ],
      ),
    );
  }
}

enum MessagePosition { left, right }

class CustomItalicComponent extends ItalicMd {
  final Color italicColor;

  CustomItalicComponent({this.italicColor = Colors.grey});

  @override
  RegExp get exp =>
      RegExp(r"(?:(?<!\*)\*(?<!\s)(.+?)(?:(?<!\s)\*(?!\*)|$))", dotAll: true);

  @override
  InlineSpan span(
    BuildContext context,
    String text,
    final GptMarkdownConfig config,
  ) {
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
