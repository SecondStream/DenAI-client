import 'package:den_ai/application/config.dart';
import 'package:den_ai/extensions/navigation_ext.dart';
import 'package:den_ai/screens/persona_form_screen.dart';
import 'package:den_ai/widgets/persona_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:den_ai/application/l10n.dart';
import 'package:den_ai/models/models.dart';
import '../blocs/user_card_form/user_card_form_bloc.dart';

class UserCardFormScreen extends StatefulWidget {
  final UserCard? card;

  const UserCardFormScreen({super.key, this.card});

  @override
  State<UserCardFormScreen> createState() => _UserCardFormScreenState();
}

class _UserCardFormScreenState extends PersonaFormScreenState<UserCardFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late bool _isDefault;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.card?.name);
    _descriptionController = TextEditingController(text: widget.card?.description);
    _isDefault = widget.card?.isDefault ?? false;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEditing = widget.card != null;
    final loc = AppLocalization.of(context);

    return BlocProvider<UserCardFormBloc>(
      create: (context) => UserCardFormBloc(GetIt.instance.get()),
      child: Scaffold(
        appBar: AppBar(
          title: Text(isEditing ? loc.userCardFormTitleEdit : loc.userCardFormTitleCreate),
        ),
        body: BlocConsumer<UserCardFormBloc, UserCardFormState>(
          listener: (context, state) {
            if (state is UserCardFormSuccessState || state is UserCardFormDeleteSuccessState) {
              context.pop(true);
            }
          },
          builder: (context, state) {
            if (state is UserCardFormLoadingState) {
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
                      label: loc.cardNameLabel,
                      hint: loc.cardNameHint,
                      validator: (v) => v!.trim().isEmpty ? loc.validationCharName : null,
                    ),
                    _buildTextField(
                      controller: _descriptionController,
                      label: loc.descriptionLabel,
                      hint: loc.descriptionHint,
                      maxLines: 6,
                    ),
                    SwitchListTile(
                      title: Text(loc.defaultSwitchTitle),
                      subtitle: Text(
                        loc.defaultSwitchSubtitle,
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                      value: _isDefault,
                      activeThumbColor: theme.colorScheme.primary,
                      onChanged: (bool value) {
                        setState(() {
                          _isDefault = value;
                        });
                      },
                    ),
                    const SizedBox(height: 24),

                    if (state is UserCardFormErrorState)
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
                                context.read<UserCardFormBloc>().add(
                                  DeleteUserCardEvent(widget.card!.id),
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
                              isEditing ? loc.saveButton : loc.cardCreateButton,
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
    final card = widget.card;
    final avatarUrl = selectedAvatarFile?.path ?? card?.getAvatar(AppConfig.of(context).baseUrl);
    return InkWell(
      onTap: () => handleAvatarClick(context, card),
      borderRadius: BorderRadius.circular(60),
      child: PersonaAvatar.form(avatarUrl, currentCropData ?? card?.getCropData()),
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
    context.read<UserCardFormBloc>().add(
      SubmitUserCardFormEvent(
        id: widget.card?.id,
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        isDefault: _isDefault,
        cropData: currentCropData,
        avatarFile: selectedAvatarFile,
      ),
    );
  }
}
