import 'package:den_ai/application/config.dart';
import 'package:den_ai/blocs/lorebook_form/lorebook_form_bloc.dart';
import 'package:den_ai/extensions/navigation_ext.dart';
import 'package:den_ai/screens/persona_form_screen.dart';
import 'package:den_ai/widgets/persona_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:den_ai/application/l10n.dart';
import 'package:den_ai/models/models.dart';

class LorebookFormScreen extends StatefulWidget {
  final Lorebook? lorebook;

  const LorebookFormScreen({super.key, this.lorebook});

  @override
  State<LorebookFormScreen> createState() => _LorebookFormScreenState();
}

class _LorebookFormScreenState extends PersonaFormScreenState<LorebookFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _aboutController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.lorebook?.name);
    _aboutController = TextEditingController(text: widget.lorebook?.about);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _aboutController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEditing = widget.lorebook != null;
    final loc = AppLocalization.of(context);

    return BlocProvider<LorebookFormBloc>(
      create: (context) => LorebookFormBloc(GetIt.instance.get()),
      child: Scaffold(
        appBar: AppBar(
          title: Text(isEditing ? loc.lorebookFormTitleEdit : loc.lorebookFormTitleCreate),
        ),
        body: BlocConsumer<LorebookFormBloc, LorebookFormState>(
          listener: (context, state) {
            if (state is LorebookFormSuccessState || state is LorebookFormDeleteSuccessState) {
              context.pop(true);
            }
          },
          builder: (context, state) {
            if (state is LorebookFormLoadingState) {
              return const Center(child: CircularProgressIndicator());
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(child: _buildAvatarPicker(context, theme)),
                    const SizedBox(height: 24),

                    _buildTextField(
                      controller: _nameController,
                      label: loc.lorebookNameLabel,
                      hint: loc.lorebookNameHint,
                      validator: (v) => v!.trim().isEmpty ? loc.validationCharName : null,
                    ),
                    _buildTextField(
                      controller: _aboutController,
                      label: loc.lorebookAboutLabel,
                      hint: loc.lorebookAboutHint,
                      maxLines: 6,
                    ),
                    const SizedBox(height: 24),

                    if (state is LorebookFormErrorState)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Text(
                          AppLocalization.of(context).getError(state.errType, state.error),
                          style: const TextStyle(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                      ),

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
                                loc.deleteButton,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              onPressed: () {
                                context.read<LorebookFormBloc>().add(
                                  DeleteLorebookEvent(widget.lorebook!.id),
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
                              isEditing ? loc.saveButton : loc.createButton,
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
          },
        ),
      ),
    );
  }

  Widget _buildAvatarPicker(BuildContext context, ThemeData theme) {
    final lorebook = widget.lorebook;
    final avatarUrl =
        selectedAvatarFile?.path ?? lorebook?.getAvatar(AppConfig.of(context).baseUrl);
    return InkWell(
      onTap: () => handleAvatarClick(context, lorebook),
      borderRadius: BorderRadius.circular(60),
      child: PersonaAvatar.form(avatarUrl, currentCropData ?? lorebook?.getCropData()),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextFormField(
        controller: controller,
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
    context.read<LorebookFormBloc>().add(
      SubmitLorebookFormEvent(
        id: widget.lorebook?.id,
        name: _nameController.text.trim(),
        about: _aboutController.text.trim(),
        cropData: currentCropData,
        coverFile: selectedAvatarFile,
      ),
    );
  }
}
