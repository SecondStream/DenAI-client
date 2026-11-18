import 'dart:convert';

import 'package:den_ai/application/l10n.dart';
import 'package:den_ai/consts/consts.dart';
import 'package:den_ai/extensions/navigation_ext.dart';
import 'package:flutter/material.dart';
import 'package:den_ai/models/models.dart';

class EditProviderDialog extends StatefulWidget {
  final Provider? provider;
  final bool showDragHandle;

  const EditProviderDialog({super.key, required this.provider, this.showDragHandle = false});

  static Future<ProviderIn?> open(BuildContext context, {Provider? provider}) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 550;
    return isDesktop
        ? showDialog<ProviderIn>(
            context: context,
            builder: (context) => Dialog(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: SizedBox(
                width: 500,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: EditProviderDialog(provider: provider),
                ),
              ),
            ),
          )
        : showModalBottomSheet<ProviderIn>(
            context: context,
            isScrollControlled: true,
            useSafeArea: true,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            builder: (ctx) => Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
              child: SizedBox(
                //height: MediaQuery.of(ctx).size.height * 0.7,
                child: EditProviderDialog(provider: provider, showDragHandle: true),
              ),
            ),
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
  late final TextEditingController _addController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.provider?.name ?? '');
    _urlController = TextEditingController(text: widget.provider?.url ?? '');
    _keyController = TextEditingController(text: widget.provider?.key ?? '');
    _addController = TextEditingController(text: widget.provider?.additionalArgs ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _urlController.dispose();
    _keyController.dispose();
    _addController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loc = AppLocalization.of(context);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.showDragHandle)
                Container(
                  margin: const EdgeInsets.only(top: 10, bottom: 8),
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(2),
                  ),
                )
              else
                const SizedBox(height: 20),
              Row(
                children: [
                  Icon(
                    widget.provider == null ? Icons.playlist_add : Icons.edit_note,
                    color: theme.colorScheme.primary,
                    size: 22,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    widget.provider == null ? loc.providerAdding : loc.providerEditing,
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Form(
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
                        labelText: loc.providerNameLabel,
                        hintText: loc.providerNameHint,
                        fillColor: theme.cardColor,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.all(16),
                      ),
                      validator: (v) => v == null || v.trim().isEmpty ? loc.providerNameErr : null,
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
                        labelText: loc.providerUrlLabel,
                        hintText: loc.providerUrlHint,
                        fillColor: theme.cardColor,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.all(16),
                      ),
                      validator: (v) => v == null || v.trim().isEmpty ? loc.providerUrlErr : null,
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
                        labelText: loc.providerKeyLabel,
                        hintText: loc.providerKeyHint,
                        fillColor: theme.cardColor,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.all(16),
                      ),
                      validator: (v) => v == null || v.trim().isEmpty ? loc.providerKeyErr : null,
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _addController,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      minLines: 3,
                      maxLines: 10,
                      decoration: InputDecoration(
                        labelText: loc.providerAddLabel,
                        hintText: loc.providerAddHint,
                        fillColor: theme.cardColor,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.all(16),
                      ),
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return null;
                        }
                        try {
                          jsonDecode(v);
                          return null;
                        } catch (_) {}
                        return loc.providerAddErr;
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (widget.provider != null &&
                      widget.provider!.id != DefaultSettings.singleSettingsId)
                    TextButton(
                      onPressed: () {
                        context.pop(
                          ProviderIn(id: -1, name: '', url: '', key: '', additionalArgs: ''),
                        );
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
                          style: TextStyle(color: theme.hintColor, fontWeight: FontWeight.bold),
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
                                additionalArgs: _addController.text.trim(),
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
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
