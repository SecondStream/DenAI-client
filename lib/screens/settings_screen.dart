import 'package:chat_bot_client/models/models.dart';
import 'package:chat_bot_client/widgets/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chat_bot_client/blocs/settings/settings_bloc.dart';
import 'package:chat_bot_client/application/l10n.dart';
import 'package:get_it/get_it.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedModel;
  String? _selectedVisionModel;
  String? _selectedTokenizer;

  double _maxContext = 8192;
  double _temperature = 0.7;
  double _minP = 0.05;
  double _topP = 0.9;
  double _repeatPenalty = 1.1;

  late final TextEditingController _systemPromptController;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _systemPromptController = TextEditingController();
  }

  @override
  void dispose() {
    _systemPromptController.dispose();
    super.dispose();
  }

  void _initializeFields(SettingsBase settings) {
    if (_isInitialized) return;
    _selectedModel = settings.modelName;
    _selectedVisionModel = settings.visionModelName;
    _selectedTokenizer = settings.tokenizerPath;
    _maxContext = settings.maxContextTokens.toDouble();
    _temperature = settings.temperature;
    _minP = settings.minP;
    _topP = settings.topP;
    _repeatPenalty = settings.repeatPenalty;
    _systemPromptController.text = settings.globalSystemPrompt;
    _isInitialized = true;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loc = AppLocalization.of(context);

    return BlocProvider<SettingsBloc>(
      create: (context) => SettingsBloc(GetIt.instance.get())..add(LoadAllSettingsEvent()),
      child: Scaffold(
        appBar: AppBar(title: Text(loc.globalSettingsTitle)),
        drawer: AppDrawer(),
        body: BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) {
            if (state is SettingsLoadingState) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is SettingsErrorState) {
              return Center(
                child: Text(
                  loc.getError(state.errType, state.error),
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }
            if (state is! SettingsLoadedState) {
              return SizedBox.shrink();
            }

            _initializeFields(state.settings);

            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildSectionTitle(theme, loc.sectionOllamaTokenizer),
                          const SizedBox(height: 16),

                          _buildDropdown(
                            label: loc.labelMainModel,
                            value: _selectedModel,
                            items: state.models,
                            onChanged: (v) => setState(() => _selectedModel = v),
                          ),

                          _buildDropdown(
                            label: loc.labelVisionModel,
                            value: _selectedVisionModel,
                            items: state.models,
                            onChanged: (v) => setState(() => _selectedVisionModel = v),
                          ),

                          _buildDropdown(
                            label: loc.labelTokenizer,
                            value: _selectedTokenizer,
                            items: state.tokenizers,
                            onChanged: (v) => setState(() => _selectedTokenizer = v),
                          ),

                          const SizedBox(height: 16),
                          _buildSectionTitle(theme, loc.sectionContextWindow),

                          _buildSliderRow(
                            label: loc.labelContextLimit,
                            value: _maxContext,
                            min: 2048,
                            max: 131072,
                            divisions: 126,
                            displayValue: loc.contextSize(_maxContext.toInt()),
                            onChanged: (v) => setState(() => _maxContext = v),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 40),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildSectionTitle(theme, loc.sectionSamplingParams),
                          const SizedBox(height: 12),
                          _buildSliderRow(
                            label: loc.labelTemperature,
                            value: _temperature,
                            min: 0.1,
                            max: 2.0,
                            divisions: 19,
                            displayValue: _temperature.toStringAsFixed(2),
                            onChanged: (v) => setState(() => _temperature = v),
                          ),
                          _buildSliderRow(
                            label: loc.labelMinP,
                            value: _minP,
                            min: 0.01,
                            max: 0.5,
                            divisions: 49,
                            displayValue: _minP.toStringAsFixed(2),
                            onChanged: (v) => setState(() => _minP = v),
                          ),
                          _buildSliderRow(
                            label: loc.labelTopP,
                            value: _topP,
                            min: 0.1,
                            max: 1.0,
                            divisions: 9,
                            displayValue: _topP.toStringAsFixed(2),
                            onChanged: (v) => setState(() => _topP = v),
                          ),
                          _buildSliderRow(
                            label: loc.labelRepeatPenalty,
                            value: _repeatPenalty,
                            min: 1.0,
                            max: 1.5,
                            divisions: 50,
                            displayValue: _repeatPenalty.toStringAsFixed(2),
                            onChanged: (v) => setState(() => _repeatPenalty = v),
                          ),

                          const SizedBox(height: 16),
                          _buildSectionTitle(theme, loc.sectionSystemPrompt),
                          const SizedBox(height: 12),
                          Expanded(
                            child: TextField(
                              controller: _systemPromptController,
                              maxLines: null,
                              expands: true,
                              style: const TextStyle(
                                fontSize: 14,
                                height: 1.4,
                                color: Colors.white,
                              ),
                              textAlignVertical: TextAlignVertical.top,
                              decoration: InputDecoration(
                                hintText: loc.hintSystemPrompt,
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
                          const SizedBox(height: 24),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: theme.colorScheme.primary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 18),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            icon: const Icon(Icons.save_as, size: 22),
                            label: Text(
                              loc.buttonSettingsSaved,
                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                final updatedSettings = SettingsBase(
                                  modelName: _selectedModel!,
                                  visionModelName: _selectedVisionModel!,
                                  tokenizerPath: _selectedTokenizer!,
                                  maxContextTokens: _maxContext.toInt(),
                                  temperature: _temperature,
                                  minP: _minP,
                                  topP: _topP,
                                  repeatPenalty: _repeatPenalty,
                                  globalSystemPrompt: _systemPromptController.text.trim(),
                                );
                                context.read<SettingsBloc>().add(
                                  SaveSettingsEvent(updatedSettings),
                                );
                                ScaffoldMessenger.of(
                                  context,
                                ).showResponse(loc.messageSettingsSaved);
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSectionTitle(ThemeData theme, String title) {
    return Text(
      title,
      style: theme.textTheme.titleMedium?.copyWith(
        color: theme.colorScheme.primary,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List items,
    required ValueChanged<String?> onChanged,
  }) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        initialValue: items.contains(value) ? value : (items.isNotEmpty ? items.first : null),
        onChanged: onChanged,
        style: const TextStyle(color: Colors.white, fontSize: 14),
        decoration: InputDecoration(
          labelText: label,
          fillColor: theme.cardColor,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
        dropdownColor: theme.cardColor,
        items: items.map((m) => DropdownMenuItem<String>(value: m, child: Text(m))).toList(),
      ),
    );
  }

  Widget _buildSliderRow({
    required String label,
    required double value,
    required double min,
    required double max,
    required int divisions,
    required String displayValue,
    required ValueChanged onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
              Text(
                displayValue,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          Slider(value: value, min: min, max: max, divisions: divisions, onChanged: onChanged),
        ],
      ),
    );
  }
}

extension on ScaffoldMessengerState {
  void showResponse(String message) {
    showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green.shade700,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
