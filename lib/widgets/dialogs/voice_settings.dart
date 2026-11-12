import 'package:den_ai/application/l10n.dart';
import 'package:den_ai/extensions/navigation_ext.dart';
import 'package:flutter/material.dart';

class VoiceOption {
  final String id;
  final String name;
  final bool isMale;

  const VoiceOption({required this.id, required this.name, required this.isMale});
}

Future<void> showVoiceSettingsModal(
  BuildContext context, {
  required String currentLanguage,
  required String currentVoiceId,
  required Function(String lang, String voiceId) onSave,
}) async {
  final isDesktop = MediaQuery.of(context).size.width > 550;
  final theme = Theme.of(context);
  if (isDesktop) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: theme.scaffoldBackgroundColor,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: VoiceSettingsContent(
            initialLanguage: currentLanguage,
            initialVoiceId: currentVoiceId,
            isDesktop: true,
            onSave: onSave,
          ),
        ),
      ),
    );
  } else {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: theme.scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: VoiceSettingsContent(
          initialLanguage: currentLanguage,
          initialVoiceId: currentVoiceId,
          isDesktop: false,
          onSave: onSave,
        ),
      ),
    );
  }
}

class VoiceSettingsContent extends StatefulWidget {
  final String initialLanguage;
  final String initialVoiceId;
  final bool isDesktop;
  final Function(String lang, String voiceId) onSave;

  const VoiceSettingsContent({
    super.key,
    required this.initialLanguage,
    required this.initialVoiceId,
    required this.isDesktop,
    required this.onSave,
  });

  @override
  State<VoiceSettingsContent> createState() => _VoiceSettingsContentState();
}

class _VoiceSettingsContentState extends State<VoiceSettingsContent> {
  late String _selectedLang;
  late String _selectedVoiceId;
  bool _mobileShowFemale = true;

  final List<VoiceOption> _maleVoices = const [
    VoiceOption(id: '5', name: 'Александр', isMale: true),
    VoiceOption(id: '6', name: 'Дмитрий', isMale: true),
    VoiceOption(id: '7', name: 'Максим', isMale: true),
    VoiceOption(id: '8', name: 'Артём', isMale: true),
    VoiceOption(id: '9', name: 'Виктор', isMale: true),
  ];

  final List<VoiceOption> _femaleVoices = const [
    VoiceOption(id: '0', name: 'Алиса', isMale: false),
    VoiceOption(id: '1', name: 'Елена', isMale: false),
    VoiceOption(id: '2', name: 'София', isMale: false),
    VoiceOption(id: '3', name: 'Виктория', isMale: false),
    VoiceOption(id: '4', name: 'Анна', isMale: false),
  ];

  @override
  void initState() {
    super.initState();
    _selectedLang = widget.initialLanguage;
    _selectedVoiceId = widget.initialVoiceId;
    _mobileShowFemale = _femaleVoices.any((v) => v.id == _selectedVoiceId);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loc = AppLocalization.of(context);
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.record_voice_over, color: theme.colorScheme.primary, size: 22),
                  SizedBox(width: 10),
                  const Text(
                    'Настройки голоса',
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white54),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 12),

          if (loc.locale.languageCode == 'ru') ...[
            // Выбор языка (чипсами, чтобы не плодить выпадающие списки)
            Text('Язык озвучки', style: TextStyle(color: theme.hintColor, fontSize: 13)),
            const SizedBox(height: 8),
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(
                  value: 'ru',
                  label: Text('Русский'),
                  icon: Icon(Icons.language, size: 18),
                ),
                ButtonSegment(
                  value: 'en',
                  label: Text('English'),
                  icon: Icon(Icons.language, size: 18),
                ),
              ],
              selected: {_selectedLang},
              onSelectionChanged: (Set<String> newSelection) {
                setState(() {
                  _selectedLang = newSelection.first;
                });
              },
            ),
            const SizedBox(height: 20),
          ],
          if (widget.isDesktop)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _buildVoiceColumn(theme, 'Женские голоса', _femaleVoices)),
                const SizedBox(width: 16),
                Expanded(child: _buildVoiceColumn(theme, 'Мужские голоса', _maleVoices)),
              ],
            )
          else ...[
            SegmentedButton<bool>(
              segments: const [
                ButtonSegment(value: true, label: Text('Женские (5)')),
                ButtonSegment(value: false, label: Text('Мужские (5)')),
              ],
              selected: {_mobileShowFemale},
              onSelectionChanged: (val) => setState(() => _mobileShowFemale = val.first),
            ),
            const SizedBox(height: 12),
            _buildVoiceColumn(theme, null, _mobileShowFemale ? _femaleVoices : _maleVoices),
          ],
        ],
      ),
    );
  }

  Widget _buildVoiceColumn(ThemeData theme, String? title, List<VoiceOption> voices) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          Text(title, style: TextStyle(color: theme.hintColor, fontSize: 13)),
          const SizedBox(height: 8),
        ],
        ...voices.map((voice) {
          final isSelected = _selectedVoiceId == voice.id;

          return Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: ListTile(
              tileColor: isSelected
                  ? theme.colorScheme.primary.withValues(alpha: 0.35)
                  : theme.cardColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(color: isSelected ? theme.dividerColor : Colors.transparent),
              ),
              dense: true,
              contentPadding: const EdgeInsets.only(left: 12, right: 4),
              title: Text(voice.name, style: const TextStyle(color: Colors.white, fontSize: 13)),
              onTap: () {
                setState(() => _selectedVoiceId = voice.id);
                widget.onSave(_selectedLang, _selectedVoiceId);
                context.pop();
              },
            ),
          );
        }),
      ],
    );
  }
}
