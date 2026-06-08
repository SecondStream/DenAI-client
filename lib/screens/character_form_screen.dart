import 'dart:io';
import 'package:den_ai/application/config.dart';
import 'package:den_ai/blocs/character_form/character_form_bloc.dart';
import 'package:den_ai/extensions/navigation_ext.dart';
import 'package:den_ai/screens/persona_form_screen.dart';
import 'package:den_ai/tools/file_tool.dart';
import 'package:den_ai/widgets/dialogs/lorebooks_select_dialog.dart';
import 'package:den_ai/widgets/persona_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:den_ai/application/l10n.dart';
import 'package:den_ai/models/models.dart';

class CharacterFormScreen extends StatefulWidget {
  final int? characterId;
  const CharacterFormScreen({super.key, this.characterId});

  @override
  State<CharacterFormScreen> createState() => _CharacterFormScreenState();
}

class _CharacterFormScreenState extends PersonaFormScreenState<CharacterFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _appearanceController;
  late final TextEditingController _personalityController;
  late final TextEditingController _scenarioController;
  late final TextEditingController _greetingController;
  late final TextEditingController _promptController;
  late List<int> _selectedLorebookIds;

  File? _selectedBackgroundFile;
  bool _isFieldsInitialized = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _appearanceController = TextEditingController();
    _personalityController = TextEditingController();
    _scenarioController = TextEditingController();
    _greetingController = TextEditingController();
    _promptController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _appearanceController.dispose();
    _personalityController.dispose();
    _scenarioController.dispose();
    _greetingController.dispose();
    _promptController.dispose();
    super.dispose();
  }

  Future<void> _pickBackground() async {
    final image = await FileTool.pickImage();
    if (image != null) {
      setState(() {
        _selectedBackgroundFile = image;
      });
    }
  }

  void _initializeControllersOnce(Char? char, List<int> initialBookIds) {
    if (_isFieldsInitialized) return;
    if (char != null) {
      _nameController.text = char.name;
      _appearanceController.text = char.appearance;
      _personalityController.text = char.personality;
      _scenarioController.text = char.scenario;
      _greetingController.text = char.greeting;
      _promptController.text = char.prompt;
    }
    _selectedLorebookIds = List<int>.from(initialBookIds);
    _isFieldsInitialized = true;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loc = AppLocalization.of(context);
    final isEditing = widget.characterId != null;

    return BlocProvider<CharacterFormBloc>(
      create: (context) =>
          CharacterFormBloc(GetIt.instance.get(), GetIt.instance.get())
            ..add(InitCharacterFormEvent(widget.characterId)),
      child: Scaffold(
        appBar: AppBar(
          title: Text(isEditing ? loc.characterFormTitleEdit : loc.characterFormTitleCreate),
        ),
        body: BlocConsumer<CharacterFormBloc, CharacterFormState>(
          listener: (context, state) {
            if (state is CharacterFormSuccessState || state is CharacterDeleteSuccessState) {
              context.pop(true);
            }
          },
          builder: (context, state) {
            if (state is CharacterFormLoadedState) {
              _initializeControllersOnce(state.character, state.selectedLorebookIds);
              return SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            children: [
                              Text(
                                loc.avatarLabel,
                                style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
                              ),
                              const SizedBox(height: 8),
                              _buildAvatarPicker(context, theme, state.character),
                            ],
                          ),
                          const SizedBox(width: 24),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  loc.backgroundLabel,
                                  style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
                                ),
                                const SizedBox(height: 8),
                                InkWell(
                                  onTap: _pickBackground,
                                  borderRadius: BorderRadius.circular(16),
                                  child: Container(
                                    height: 120,
                                    decoration: BoxDecoration(
                                      color: theme.colorScheme.primary.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    child: _buildBackgroundPreview(
                                      context,
                                      loc,
                                      theme,
                                      state.character,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      _buildTextField(
                        controller: _nameController,
                        label: loc.charNameLabel,
                        hint: loc.charNameHint,
                        minLines: 1,
                        maxLines: 1,
                        validator: (v) => v!.trim().isEmpty ? loc.validationCharName : null,
                      ),
                      _buildTextField(
                        controller: _greetingController,
                        label: loc.greetingLabel,
                        hint: loc.greetingHint,
                        minLines: 4,
                      ),
                      _buildTextField(
                        controller: _appearanceController,
                        label: loc.appearanceLabel,
                        hint: loc.appearanceHint,
                        minLines: 4,
                      ),
                      _buildTextField(
                        controller: _personalityController,
                        label: loc.personalityLabel,
                        hint: loc.personalityHint,
                        minLines: 4,
                      ),
                      _buildTextField(
                        controller: _scenarioController,
                        label: loc.scenarioLabel,
                        hint: loc.scenarioHint,
                        minLines: 4,
                      ),
                      _buildTextField(
                        controller: _promptController,
                        label: loc.promptLabel,
                        hint: loc.promptHint,
                        minLines: 3,
                      ),

                      _buildLorebookButton(context, loc, theme, state.allLorebooks),

                      const SizedBox(height: 30),

                      Row(
                        children: [
                          if (isEditing) ...[
                            Expanded(
                              flex: 1,
                              child: OutlinedButton.icon(
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.red.shade400,
                                  side: BorderSide(color: Colors.red.shade400, width: 1.5),
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                icon: const Icon(Icons.delete_outline, size: 22),
                                label: Text(
                                  loc.delete,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                onPressed: () {
                                  context.read<CharacterFormBloc>().add(
                                    DeleteCharacterEvent(widget.characterId!),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: 16),
                          ],
                          Expanded(
                            flex: 2,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: theme.colorScheme.primary,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: () => _submitForm(context),
                              child: Text(
                                isEditing ? loc.saveButton : loc.charCreateButton,
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }

            if (state is CharacterFormErrorState) {
              return Center(
                child: Text(
                  AppLocalization.of(context).getError(state.errType, state.error),
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              );
            }

            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  Widget _buildLorebookButton(
    BuildContext context,
    AppLocalization loc,
    ThemeData theme,
    List<Lorebook> allLorebooks,
  ) {
    return InkWell(
      onTap: () async {
        final List<int>? result = await LorebooksSelectDialog.open(
          context,
          allLorebooks,
          _selectedLorebookIds,
        );
        if (result != null) {
          setState(() {
            _selectedLorebookIds = result;
          });
        }
      },
      borderRadius: BorderRadius.circular(12),
      child: Ink(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        decoration: BoxDecoration(color: theme.cardColor, borderRadius: BorderRadius.circular(12)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.library_books_outlined, color: theme.colorScheme.primary, size: 20),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      loc.charLorebooks,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _selectedLorebookIds.isEmpty
                          ? loc.charNoLorebooks
                          : loc.charLorebookCount(_selectedLorebookIds.length),
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
            const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarPicker(BuildContext context, ThemeData theme, Char? character) {
    final char = character;
    final avatarUrl = selectedAvatarFile?.path ?? char?.getAvatar(AppConfig.of(context).baseUrl);
    return InkWell(
      onTap: () => handleAvatarClick(context, character),
      borderRadius: BorderRadius.circular(60),
      child: PersonaAvatar.form(avatarUrl, currentCropData ?? char?.getCropData()),
    );
  }

  Widget _buildBackgroundPreview(
    BuildContext context,
    AppLocalization loc,
    ThemeData theme,
    Char? character,
  ) {
    final char = character;
    final baseUrl = AppConfig.of(context).baseUrl;
    final bgUrl = char?.getBackground(baseUrl);
    if (_selectedBackgroundFile != null) {
      return Image.file(_selectedBackgroundFile!, fit: BoxFit.cover, width: double.infinity);
    }
    if (bgUrl != null) {
      return Image.network(bgUrl, fit: BoxFit.cover, width: double.infinity);
    }
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.wallpaper, size: 32, color: Colors.grey),
          const SizedBox(height: 4),
          Text(loc.selectBackground, style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    int? minLines,
    int? maxLines,
    String? Function(String?)? validator,
  }) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextFormField(
        controller: controller,
        minLines: minLines,
        maxLines: maxLines,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          alignLabelWithHint: true,
          fillColor: theme.cardColor,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.all(16),
        ),
      ),
    );
  }

  void _submitForm(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;
    context.read<CharacterFormBloc>().add(
      SubmitCharacterFormEvent(
        id: widget.characterId,
        name: _nameController.text.trim(),
        appearance: _appearanceController.text.trim(),
        personality: _personalityController.text.trim(),
        scenario: _scenarioController.text.trim(),
        greeting: _greetingController.text.trim(),
        prompt: _promptController.text.trim(),
        cropData: currentCropData,
        avatarFile: selectedAvatarFile,
        backgroundFile: _selectedBackgroundFile,
        lorebookIds: _selectedLorebookIds,
      ),
    );
  }
}
