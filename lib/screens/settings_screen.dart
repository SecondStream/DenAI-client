import 'package:den_ai/models/models.dart';
import 'package:den_ai/widgets/app_drawer.dart';
import 'package:den_ai/widgets/dialogs/edit_provider_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:den_ai/blocs/settings/settings_bloc.dart';
import 'package:den_ai/application/l10n.dart';
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
  String? _selectedEmbeddingModel;
  String? _selectedTokenizer;

  double _maxContext = 8192;
  double _temperature = 0.7;
  double _minP = 0.05;
  double _topP = 0.9;
  double _repeatPenalty = 1.1;

  late final TextEditingController _systemPromptController;
  late final TextEditingController _templateController;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _systemPromptController = TextEditingController();
    _templateController = TextEditingController();
  }

  @override
  void dispose() {
    _systemPromptController.dispose();
    _templateController.dispose();
    super.dispose();
  }

  void _initializeFields(SettingsBase settings) {
    if (_isInitialized) return;
    _selectedModel = settings.modelName;
    _selectedVisionModel = settings.visionModelName;
    _selectedEmbeddingModel = settings.embeddingModelName;
    _selectedTokenizer = settings.tokenizerPath;
    _maxContext = settings.maxContextTokens.toDouble();
    _temperature = settings.temperature;
    _minP = settings.minP;
    _topP = settings.topP;
    _repeatPenalty = settings.repeatPenalty;
    _systemPromptController.text = settings.globalSystemPrompt;
    _templateController.text = settings.template;
    _isInitialized = true;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loc = AppLocalization.of(context);

    return BlocProvider<SettingsBloc>(
      create: (context) =>
          SettingsBloc(GetIt.instance.get(), GetIt.instance.get())..add(LoadAllSettingsEvent()),
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

            final provider = state.providers.firstWhere((e) => e.id == state.settings.provider.id);

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
                          _buildSectionTitle(theme, loc.apiProvider),
                          const SizedBox(height: 16),
                          _buildDropdownProviders(
                            label: loc.labelProvider,
                            value: state.settings.provider.id,
                            items: state.providers,
                            onChanged: (v) {
                              if (v != null && v != state.settings.provider.id) {
                                _isInitialized = false;
                                context.read<SettingsBloc>().add(
                                  UpdateProviderEvent(providerId: v),
                                );
                              }
                            },
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            spacing: 16,
                            children: [
                              Flexible(
                                fit: FlexFit.tight,
                                flex: 8,
                                child: ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: theme.colorScheme.primary,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(vertical: 18),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  icon: const Icon(Icons.edit, size: 22),
                                  label: Text(
                                    loc.change,
                                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                                  ),
                                  onPressed: () => _openEditProvider(context, provider),
                                ),
                              ),
                              Flexible(
                                fit: FlexFit.tight,
                                flex: 15,
                                child: ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: theme.colorScheme.primary,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(vertical: 18),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  icon: const Icon(Icons.api, size: 22),
                                  label: Text(
                                    loc.apiProviderAdd,
                                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                                  ),
                                  onPressed: () => _openEditProvider(context, null),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),
                          _buildSectionTitle(theme, loc.sectionOllamaTokenizer),
                          const SizedBox(height: 16),

                          _buildDropdownModels(
                            label: loc.labelMainModel,
                            value: _selectedModel,
                            items: state.models,
                            onChanged: (v) => setState(() => _selectedModel = v),
                          ),

                          _buildDropdownModels(
                            label: loc.labelVisionModel,
                            value: _selectedVisionModel,
                            items: state.visionModels,
                            onChanged: (v) => setState(() => _selectedVisionModel = v),
                          ),

                          _buildDropdownModels(
                            label: loc.labelEmbeddingModel,
                            value: _selectedEmbeddingModel,
                            items: state.embeddingModels,
                            onChanged: (v) => setState(() => _selectedEmbeddingModel = v),
                          ),

                          _buildDropdownTokenizers(
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
                          Spacer(),

                          // const SizedBox(height: 16),
                          // _buildSectionTitle(theme, loc.sectionSystemTemplate),
                          // const SizedBox(height: 12),
                          // Expanded(
                          //   child: TextField(
                          //     controller: _templateController,
                          //     maxLines: null,
                          //     expands: true,
                          //     style: const TextStyle(
                          //       fontSize: 14,
                          //       height: 1.4,
                          //       color: Colors.white,
                          //     ),
                          //     textAlignVertical: TextAlignVertical.top,
                          //     decoration: InputDecoration(
                          //       hintText: loc.hintSystemTemplate,
                          //       fillColor: theme.cardColor,
                          //       filled: true,
                          //       border: OutlineInputBorder(
                          //         borderRadius: BorderRadius.circular(12),
                          //         borderSide: BorderSide.none,
                          //       ),
                          //       contentPadding: const EdgeInsets.all(16),
                          //     ),
                          //   ),
                          // ),
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
                                  embeddingModelName: _selectedEmbeddingModel!,
                                  tokenizerPath: _selectedTokenizer!,
                                  maxContextTokens: _maxContext.toInt(),
                                  temperature: _temperature,
                                  minP: _minP,
                                  topP: _topP,
                                  repeatPenalty: _repeatPenalty,
                                  globalSystemPrompt: _systemPromptController.text.trim(),
                                  template: _templateController.text.trim(),
                                  provider: state.settings.provider,
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

  Widget _buildDropdownProviders({
    required String label,
    required int? value,
    required List<Provider> items,
    required ValueChanged<int?> onChanged,
  }) {
    final theme = Theme.of(context);
    final List<int> itemIds = items.map((e) => e.id).toList();
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<int>(
        initialValue: itemIds.contains(value) ? value : (itemIds.isNotEmpty ? itemIds.first : null),
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
        items: items.map((m) => DropdownMenuItem<int>(value: m.id, child: Text(m.name))).toList(),
      ),
    );
  }

  Widget _buildDropdownTokenizers({
    required String label,
    required String? value,
    required List<TokenizerInfo> items,
    required ValueChanged<String?> onChanged,
  }) {
    final theme = Theme.of(context);
    final List<String> itemIds = items.map((e) => e.id).toList();
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        initialValue: itemIds.contains(value) ? value : (itemIds.isNotEmpty ? itemIds.first : null),
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
        items: items
            .map((m) => DropdownMenuItem<String>(value: m.id, child: Text(m.displayName)))
            .toList(),
      ),
    );
  }

  Widget _buildDropdownModels({
    required String label,
    required String? value,
    required List<ModelInfo> items,
    required ValueChanged<String?> onChanged,
  }) {
    final theme = Theme.of(context);

    final List<String> itemNames = items.map((e) => e.name).toList();

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        initialValue: itemNames.contains(value)
            ? value
            : (itemNames.isNotEmpty ? itemNames.first : null),
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

        items: items.map((m) {
          return DropdownMenuItem<String>(
            value: m.name,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(m.name, style: const TextStyle(fontWeight: FontWeight.w500)),
                const SizedBox(width: 12),
                Text(
                  m.info,
                  style: TextStyle(
                    color: theme.colorScheme.primary.withValues(alpha: 0.7),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
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

  Future<void> _openEditProvider(BuildContext context, Provider? provider) async {
    final bloc = context.read<SettingsBloc>();
    final res = await EditProviderDialog.open(context, provider: provider);
    if (res != null && context.mounted) {
      final id = res.id;
      if (id != null && res.id! < 0 && provider != null) {
        bloc.add(DeleteProviderEvent(provider.id));
      } else {
        if (provider == null) {
          bloc.add(
            SaveProviderEvent(
              name: res.name,
              url: res.url,
              key: res.key,
              additionalArgs: res.additionalArgs,
            ),
          );
        } else {
          if (provider.name != res.name ||
              provider.url != res.url ||
              provider.key != res.key ||
              res.additionalArgs != provider.additionalArgs) {
            bloc.add(
              SaveProviderEvent(
                id: id,
                name: res.name,
                url: res.url,
                key: res.key,
                additionalArgs: res.additionalArgs,
              ),
            );
          }
        }
      }
    }
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
