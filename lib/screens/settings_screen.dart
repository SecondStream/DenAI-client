import 'dart:async';

import 'package:den_ai/application/config.dart';
import 'package:den_ai/application/routes.dart';
import 'package:den_ai/blocs/app_status/app_status_bloc.dart';
import 'package:den_ai/extensions/navigation_ext.dart';
import 'package:den_ai/extensions/responsive_context.dart';
import 'package:den_ai/extensions/snackbar_ext.dart';
import 'package:den_ai/managers/lore_vector_storage.dart';
import 'package:den_ai/models/models.dart';
import 'package:den_ai/widgets/app_drawer.dart';
import 'package:den_ai/widgets/dialogs/confirmation_dialog.dart';
import 'package:den_ai/widgets/dialogs/edit_provider_dialog.dart';
import 'package:den_ai/widgets/model_selector.dart';
import 'package:den_ai/widgets/status_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:den_ai/blocs/settings/settings_bloc.dart';
import 'package:den_ai/application/l10n.dart';
import 'package:get_it/get_it.dart';
import 'package:url_launcher/url_launcher.dart';

class ModelView {
  final ModelType type;
  final String name;
  final bool handInputName;

  const ModelView({required this.type, required this.name, this.handInputName = false});

  factory ModelView.fromModel(Model model) {
    return ModelView(type: model.type, name: model.name, handInputName: model.handInputName);
  }

  factory ModelView.fromInfo(ModelType type, ModelInfo model) {
    return ModelView(type: type, name: model.name, handInputName: false);
  }

  ModelView copyWith({String? name, bool? handInputName}) {
    return ModelView(
      type: type,
      name: name ?? this.name,
      handInputName: handInputName ?? this.handInputName,
    );
  }
}

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  late ModelView _selectedModel;
  late ModelView _selectedVisionModel;
  late ModelView _selectedEmbeddingModel;
  String? _selectedTokenizer;

  double _maxContext = 8192;
  double _temperature = 0.7;
  double _minP = 0.05;
  double _topP = 0.9;
  double _repeatPenalty = 1.1;
  bool _embeddingEnabled = true;

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

  void _initializeFields(SettingsBase settings, ActiveModels models) {
    if (_isInitialized) return;
    _selectedTokenizer = settings.tokenizerPath;
    _maxContext = settings.maxContextTokens.toDouble();
    _temperature = settings.temperature;
    _minP = settings.minP;
    _topP = settings.topP;
    _repeatPenalty = settings.repeatPenalty;
    _systemPromptController.text = settings.globalSystemPrompt;
    _templateController.text = settings.template;
    _embeddingEnabled = settings.embeddingEnabled;
    _reInitializeModels(models);
    _isInitialized = true;
  }

  void _reInitializeModels(ActiveModels models) {
    _selectedModel = ModelView.fromModel(models.chat);
    _selectedVisionModel = ModelView.fromModel(models.vision);
    _selectedEmbeddingModel = ModelView.fromModel(models.embedding);
  }

  void _providerChanged(SettingsProviderSaveSuccess state) {
    _reInitializeModels(state.activeModels);
  }

  void _checkModels(SettingsLoadedState state) {
    if (!_selectedModel.handInputName &&
        state.models.indexWhere((m) => m.name == _selectedModel.name) == -1) {
      _selectedModel = ModelView.fromInfo(ModelType.chat, state.models.first);
    }
    if (!_selectedVisionModel.handInputName &&
        state.visionModels.indexWhere((m) => m.name == _selectedVisionModel.name) == -1) {
      _selectedVisionModel = ModelView.fromInfo(ModelType.vision, state.visionModels.first);
    }
    if (!_selectedEmbeddingModel.handInputName &&
        state.embeddingModels.indexWhere((m) => m.name == _selectedEmbeddingModel.name) == -1) {
      _selectedEmbeddingModel = ModelView.fromInfo(
        ModelType.embedding,
        state.embeddingModels.first,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loc = AppLocalization.of(context);

    return BlocProvider<SettingsBloc>(
      create: (context) => SettingsBloc(
        GetIt.instance.get(),
        GetIt.instance.get(),
        GetIt.instance.get(),
        GetIt.instance.get(),
        context.read<AppStatusBloc>(),
        context.notifyBloc,
      )..add(LoadAllSettingsEvent()),
      child: Scaffold(
        appBar: AppBar(
          title: Text(loc.globalSettingsTitle),
          actions: [
            IconButton(
              icon: const Icon(Icons.help_outline, size: 28),
              onPressed: () =>
                  launchUrl(Uri.parse('${AppConfig.of(context).getSiteUrl(loc)}/denai/settings')),
            ),
          ],
        ),
        drawer: AppDrawer(),
        body: BlocConsumer<SettingsBloc, SettingsState>(
          listener: (context, state) {
            if (state is SettingsProviderSaveSuccess) {
              _providerChanged(state);
            } else if (state is SettingsSaveSuccess) {
              context.replace(AppRoutes.home);
            }
          },
          buildWhen: (prev, current) => current is! SettingsProviderSaveSuccess,
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

            _initializeFields(state.settings, state.activeModels);
            _checkModels(state);

            final isMobile = context.isMobile;

            final leftColumnWidgets = [
              SizedBox.shrink(),
              _buildSectionTitle(theme, loc.apiProvider),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildDropdownProviders(
                      theme,
                      label: loc.labelProvider,
                      value: state.settings.provider.id,
                      items: state.providers,
                      onChanged: (v) {
                        if (v != null && v != state.settings.provider.id) {
                          context.read<SettingsBloc>().add(UpdateProviderEvent(providerId: v));
                        }
                      },
                    ),
                  ),
                  SizedBox(width: 10),
                  StatusButton(),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                spacing: 16,
                children: [
                  Flexible(
                    fit: FlexFit.tight,
                    flex: 1,
                    child: ElevatedButton.icon(
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
                    flex: 1,
                    child: ElevatedButton.icon(
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

              Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.only(left: 8),
                // decoration: BoxDecoration(
                //   color: theme.cardColor,
                //   borderRadius: BorderRadius.circular(12),
                // ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Text(
                        loc.useEmbeddingsLabel,
                        textAlign: TextAlign.end,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Switch(
                      value: _embeddingEnabled,
                      onChanged: (val) => setState(() => _embeddingEnabled = val),
                    ),
                  ],
                ),
              ),
              if (_embeddingEnabled)
                _buildDropdownModels(
                  label: loc.labelEmbeddingModel,
                  value: _selectedEmbeddingModel,
                  items: state.embeddingModels,
                  onChanged: (v) => setState(() => _selectedEmbeddingModel = v),
                ),

              _buildDropdownTokenizers(
                theme,
                label: loc.labelTokenizer,
                value: _selectedTokenizer,
                items: state.tokenizers,
                onChanged: (v) => setState(() => _selectedTokenizer = v),
              ),

              const SizedBox(height: 16),
              _buildSectionTitle(theme, loc.sectionContextWindow),

              _buildSliderRow(
                theme,
                label: loc.labelContextLimit,
                value: _maxContext,
                min: 2048,
                max: 131072,
                divisions: 126,
                displayValue: loc.contextSize(_maxContext.toInt()),
                onChanged: (v) => setState(() => _maxContext = v),
              ),
              // Spacer(),

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
              //       contentPadding: const EdgeInsets.all(12),
              //     ),
              //   ),
              // ),
            ];

            final promptField = TextField(
              controller: _systemPromptController,
              maxLines: null,
              minLines: isMobile ? 6 : null,
              expands: !isMobile,
              style: const TextStyle(fontSize: 14, height: 1.4, color: Colors.white),
              textAlignVertical: TextAlignVertical.top,
              decoration: InputDecoration(
                hintText: loc.hintSystemPrompt,
                fillColor: theme.cardColor,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.all(12),
              ),
            );

            final rightColumnWidgets = [
              SizedBox.shrink(),
              _buildSectionTitle(theme, loc.sectionSamplingParams),
              const SizedBox(height: 12),
              _buildSliderRow(
                theme,
                label: loc.labelTemperature,
                value: _temperature,
                min: 0.1,
                max: 2.0,
                divisions: 19,
                displayValue: _temperature.toStringAsFixed(2),
                onChanged: (v) => setState(() => _temperature = v),
              ),
              // _buildSliderRow(
              //   theme,
              //   label: loc.labelMinP,
              //   value: _minP,
              //   min: 0.01,
              //   max: 0.5,
              //   divisions: 49,
              //   displayValue: _minP.toStringAsFixed(2),
              //   onChanged: (v) => setState(() => _minP = v),
              // ),
              _buildSliderRow(
                theme,
                label: loc.labelTopP,
                value: _topP,
                min: 0.1,
                max: 1.0,
                divisions: 9,
                displayValue: _topP.toStringAsFixed(2),
                onChanged: (v) => setState(() => _topP = v),
              ),
              _buildSliderRow(
                theme,
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
              isMobile ? promptField : Expanded(child: promptField),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                icon: const Icon(Icons.save_as, size: 22),
                label: Text(
                  loc.buttonSettingsSaved,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                onPressed: () => _saveSettings(context, loc, state),
              ),
            ];

            return isMobile
                ? SingleChildScrollView(
                    padding: const EdgeInsets.all(24.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ...leftColumnWidgets,
                          const SizedBox(height: 32),
                          ...rightColumnWidgets,
                        ],
                      ),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Form(
                      key: _formKey,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: leftColumnWidgets,
                            ),
                          ),
                          const SizedBox(width: 40),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: rightColumnWidgets,
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

  Widget _buildDropdownProviders(
    ThemeData theme, {
    required String label,
    required int? value,
    required List<Provider> items,
    required ValueChanged<int?> onChanged,
  }) {
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

  Widget _buildDropdownTokenizers(
    ThemeData theme, {
    required String label,
    required String? value,
    required List<TokenizerInfo> items,
    required ValueChanged<String?> onChanged,
  }) {
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
    required ModelView value,
    required List<ModelInfo> items,
    required ValueChanged<ModelView> onChanged,
  }) {
    return ModelSelector(modelView: value, items: items, label: label, onChanged: onChanged);
  }

  Widget _buildSliderRow(
    ThemeData theme, {
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
              Text(label, style: TextStyle(color: theme.hintColor, fontSize: 13)),
              Text(
                displayValue,
                style: TextStyle(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsetsGeometry.symmetric(vertical: 12),
            child: Slider(
              value: value,
              min: min,
              max: max,
              divisions: divisions,
              onChanged: onChanged,
            ),
          ),
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

  Future<void> _saveSettings(
    BuildContext context,
    AppLocalization loc,
    SettingsLoadedState state,
  ) async {
    if (_formKey.currentState!.validate()) {
      // TODO: Different providers
      if ((state.activeModels.embedding.name != _selectedEmbeddingModel.name &&
              _embeddingEnabled) ||
          state.settings.embeddingEnabled != _embeddingEnabled) {
        final bool hasFiles = await LoreVectorStorage.hasVectorFiles();
        if (!context.mounted) return;

        if (hasFiles) {
          final title = state.settings.embeddingEnabled != _embeddingEnabled
              ? loc.confirmEmbeddingsTitle
              : loc.confirmMessageTitle;
          final message = state.settings.embeddingEnabled != _embeddingEnabled
              ? _embeddingEnabled
                    ? loc.confirmEmbeddingsEnable
                    : loc.confirmEmbeddingsDisable
              : loc.confirmMessageText;
          final bool? confirm = await ConfirmationDialog.open(context, title, message);

          if (confirm != true) {
            setState(() {
              _selectedEmbeddingModel = ModelView.fromModel(state.activeModels.embedding);
            });

            return;
          }
        }
      }

      final updatedSettings = SettingsBase(
        modelName: _selectedModel.name,
        visionModelName: _selectedVisionModel.name,
        embeddingModelName: _selectedEmbeddingModel.name,
        tokenizerPath: _selectedTokenizer!,
        maxContextTokens: _maxContext.toInt(),
        temperature: _temperature,
        minP: _minP,
        topP: _topP,
        repeatPenalty: _repeatPenalty,
        globalSystemPrompt: _systemPromptController.text.trim(),
        template: _templateController.text.trim(),
        provider: state.settings.provider,
        embeddingEnabled: _embeddingEnabled,
      );
      if (context.mounted) {
        context.read<SettingsBloc>().add(
          SaveSettingsEvent(
            updatedSettings,
            _selectedModel,
            _selectedVisionModel,
            _selectedEmbeddingModel,
          ),
        );
      }
    }
  }
}
