import 'package:den_ai/application/l10n.dart';
import 'package:den_ai/consts/consts.dart';
import 'package:den_ai/extensions/navigation_ext.dart';
import 'package:flutter/material.dart';
import 'package:den_ai/models/models.dart';

class EditProviderDialog extends StatefulWidget {
  final Provider? provider;

  const EditProviderDialog({super.key, required this.provider});

  static Future<ProviderIn?> open(BuildContext context, {Provider? provider}) {
    return showDialog<ProviderIn>(
      context: context,
      builder: (context) => EditProviderDialog(provider: provider),
    );
  }

  @override
  State<EditProviderDialog> createState() => _EditProviderDialogState();
}

class _EditProviderDialogState extends State<EditProviderDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _urlController;
  late final TextEditingController _keyController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.provider?.name ?? '');
    _urlController = TextEditingController(text: widget.provider?.url ?? '');
    _keyController = TextEditingController(text: widget.provider?.key ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loc = AppLocalization.of(context);

    return AlertDialog(
      backgroundColor: theme.scaffoldBackgroundColor,
      title: Row(
        children: [
          Icon(
            widget.provider == null ? Icons.playlist_add : Icons.edit_note,
            color: theme.colorScheme.primary,
            size: 22,
          ),
          const SizedBox(width: 10),
          Text(widget.provider == null ? 'Добавление провайдера' : 'Изменение провайдера'),
        ],
      ),
      content: SizedBox(
        width: 600,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                decoration: InputDecoration(
                  labelText: 'Название',
                  hintText: 'Любое для удобства',
                  hintStyle: TextStyle(color: Colors.grey.shade600),
                  fillColor: theme.cardColor,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.all(16),
                ),
                validator: (v) => v == null || v.trim().isEmpty ? 'Введите название' : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _urlController,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                decoration: InputDecoration(
                  labelText: 'Адрес API',
                  hintText: 'https://youprovider.com/api/v1',
                  hintStyle: TextStyle(color: Colors.grey.shade600),
                  fillColor: theme.cardColor,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.all(16),
                ),
                validator: (v) => v == null || v.trim().isEmpty ? 'Введите адрес API' : null,
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _keyController,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                decoration: InputDecoration(
                  labelText: 'Ключ API',
                  hintText: 'sk-XXXXXXXXXXXXXXXXXXXXXXXXXXX',
                  hintStyle: TextStyle(color: Colors.grey.shade600),
                  fillColor: theme.cardColor,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.all(16),
                ),
                validator: (v) => v == null || v.trim().isEmpty ? 'Введите ключ API' : null,
              ),
            ],
          ),
        ),
      ),
      actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (widget.provider != null && widget.provider!.id != DefaultSettings.singleSettingsId)
              TextButton(
                onPressed: () {
                  context.pop(ProviderIn(id: -1, name: '', url: '', key: ''));
                },
                child: Text(
                  loc.delete,
                  style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                ),
              )
            else
              const SizedBox.shrink(),
            Row(
              children: [
                TextButton(
                  onPressed: () => context.pop(),
                  child: Text(
                    loc.cancel,
                    style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      context.pop(
                        ProviderIn(
                          id: widget.provider?.id,
                          name: _nameController.text.trim(),
                          url: _urlController.text.trim(),
                          key: _keyController.text.trim(),
                        ),
                      );
                    }
                  },
                  child: Text(loc.save, style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
