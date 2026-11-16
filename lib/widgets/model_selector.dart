import 'package:den_ai/application/l10n.dart';
import 'package:den_ai/models/model_info.dart';
import 'package:den_ai/screens/settings_screen.dart';
import 'package:flutter/material.dart';

class ModelSelector extends StatelessWidget {
  final ModelView modelView;
  final List<ModelInfo> items;
  final String label;
  final Function(ModelView value) onChanged;

  const ModelSelector({
    super.key,
    required this.modelView,
    required this.items,
    required this.label,
    required this.onChanged,
  });

  InputDecoration _buildDecoration(ThemeData theme, {required Widget suffixIcon, double rightPadding = 0,}) {
    return InputDecoration(
      labelText: label,
      fillColor: theme.cardColor,
      filled: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      suffixIcon: Padding(
        padding: EdgeInsets.only(right: rightPadding),
        child: suffixIcon,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final List<String> itemNames = items.map((e) => e.name).toList();
    final loc = AppLocalization.of(context);

    if (modelView.handInputName) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: TextFormField(
          key: ValueKey('${modelView.type}_manual'),
          initialValue: modelView.name,
          autofocus: true,
          style: const TextStyle(color: Colors.white, fontSize: 14),
          decoration: _buildDecoration(
            theme,
            suffixIcon: IconButton(
              icon: const Icon(Icons.close, size: 20),
              tooltip: loc.toModelsList,
              onPressed: () {
                final String? fallbackName = itemNames.contains(modelView.name)
                    ? modelView.name
                    : (itemNames.isNotEmpty ? itemNames.first : null);
                onChanged(
                  modelView.copyWith(
                    name: fallbackName,
                    handInputName: false,
                  ),
                );
              },
            ),
            rightPadding: 12
          ),
          validator: (v) {
            if (v == null || v.trim().isEmpty) {
              return loc.modelNameHint;
            }
            return null;
          },
          onChanged: (v) => onChanged(modelView.copyWith(name: v)),
        ),
      );
    }

    final String? currentValue = itemNames.contains(modelView.name)
        ? modelView.name
        : (itemNames.isNotEmpty ? itemNames.first : null);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        key: ValueKey('${modelView.type}_dropdown'),
        initialValue: currentValue,
        onChanged: (v) {
          if (v != null) {
            onChanged(modelView.copyWith(name: v));
          }
        },
        isExpanded: true,
        style: const TextStyle(color: Colors.white, fontSize: 14),
        decoration: _buildDecoration(
          theme,
          suffixIcon: IconButton(
            icon: Icon(
              Icons.edit,
              size: 20,
              color: itemNames.isEmpty ? theme.colorScheme.primary : null,
            ),
            tooltip: loc.toModelManual,
            onPressed: () {
              onChanged(
                modelView.copyWith(
                  name: modelView.name,
                  handInputName: true,
                ),
              );
            },
          ),
        ),
        dropdownColor: theme.cardColor,
        items: items.map((m) {
          return DropdownMenuItem<String>(
            value: m.name,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Text(
                    m.name,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}