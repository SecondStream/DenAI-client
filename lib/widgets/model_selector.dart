import 'package:den_ai/application/l10n.dart';
import 'package:den_ai/extensions/responsive_context.dart';
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

  InputDecoration _buildDecoration(
    ThemeData theme, {
    required Widget suffixIcon,
    double rightPadding = 0,
  }) {
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
          style: const TextStyle(color: Colors.white, fontSize: 14),
          decoration: _buildDecoration(
            theme,
            rightPadding: 8,
            suffixIcon: IconButton(
              icon: const Icon(Icons.close, size: 20),
              tooltip: loc.toModelsList,
              onPressed: () {
                final fallbackName = itemNames.contains(modelView.name)
                    ? modelView.name
                    : (itemNames.isNotEmpty ? itemNames.first : null);
                onChanged(modelView.copyWith(name: fallbackName, handInputName: false));
              },
            ),
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
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: itemNames.isEmpty ? null : () => _openSearch(context, itemNames),
        child: InputDecorator(
          decoration: _buildDecoration(
            theme,
            rightPadding: 12,
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (itemNames.isNotEmpty) const Icon(Icons.arrow_drop_down, color: Colors.white70),
                IconButton(
                  icon: Icon(
                    Icons.edit,
                    size: 20,
                    color: itemNames.isEmpty ? theme.colorScheme.primary : null,
                  ),
                  tooltip: loc.toModelManual,
                  onPressed: () {
                    onChanged(modelView.copyWith(name: currentValue ?? '', handInputName: true));
                  },
                ),
              ],
            ),
          ),
          child: Text(
            currentValue ?? (itemNames.isEmpty ? loc.notModels : loc.selectModel),
            style: TextStyle(
              color: currentValue != null ? Colors.white : Colors.white.withValues(alpha: 0.5),
              fontSize: 14,
              fontWeight: currentValue != null ? FontWeight.w500 : FontWeight.normal,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }

  Future<void> _openSearch(BuildContext context, List<String> itemNames) async {
    final isDesktop = context.isDesktop;

    final selected = isDesktop
        ? await showDialog<String>(
            context: context,
            builder: (ctx) => Dialog(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480, maxHeight: 750),
                child: Padding(
                  padding: EdgeInsets.only(left: 10, right: 10, bottom: 16),
                  child: _ModelSearchBody(
                    title: label,
                    items: itemNames,
                    currentValue: modelView.name,
                  ),
                ),
              ),
            ),
          )
        : await showModalBottomSheet<String>(
            context: context,
            isScrollControlled: true,
            useSafeArea: true,
            builder: (ctx) => Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.75),
                child: _ModelSearchBody(
                  title: label,
                  items: itemNames,
                  currentValue: modelView.name,
                ),
              ),
            ),
          );

    if (selected != null) {
      onChanged(modelView.copyWith(name: selected));
    }
  }
}

class _ModelSearchBody extends StatefulWidget {
  final String title;
  final List<String> items;
  final String currentValue;

  const _ModelSearchBody({
    required this.title,
    required this.items,
    required this.currentValue,
  });

  @override
  State<_ModelSearchBody> createState() => _ModelSearchBodyState();
}

class _ModelSearchBodyState extends State<_ModelSearchBody> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final queryTokens = _query.toLowerCase().trim().split(RegExp(r'\s+'));
    final loc = AppLocalization.of(context);
    final filtered = _query.trim().isEmpty
        ? widget.items
        : widget.items.where((item) {
            final lower = item.toLowerCase();
            return queryTokens.every((token) => lower.contains(token));
          }).toList();
    var index = filtered.indexOf(widget.currentValue) - 1;
    if (index < 0) index = 0;
    return SafeArea(
      child: Column(
        children: [
          if (context.isMobile)
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Icon(Icons.webhook, color: theme.colorScheme.primary, size: 22),
                const SizedBox(width: 10),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(widget.title, style: const TextStyle(fontSize: 20, color: Colors.white)),
                      Text(
                        '${filtered.length} / ${widget.items.length}',
                        style: const TextStyle(fontSize: 12, color: Colors.white54),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              controller: _searchController,
              style: const TextStyle(color: Colors.white, fontSize: 14),
              decoration: InputDecoration(
                hintText: loc.searchingModel,
                prefixIcon: const Icon(Icons.search, size: 20),
                suffixIcon: _query.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 18),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _query = '');
                        },
                      )
                    : null,
                fillColor: theme.cardColor,
                filled: true,
                isDense: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (v) => setState(() => _query = v),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Text(loc.nothingFound, style: TextStyle(color: Colors.white54)),
                  )
                : ListView.builder(
                    controller: ScrollController(initialScrollOffset: index * 44),
                    clipBehavior: Clip.hardEdge,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                    itemCount: filtered.length,
                    itemExtent: 44,
                    itemBuilder: (context, index) {
                      final item = filtered[index];
                      final isSelected = item == widget.currentValue;
                      return ListTile(
                        dense: true,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        selected: isSelected,
                        selectedTileColor: theme.colorScheme.primary.withValues(alpha: 0.15),
                        title: Text(
                          item,
                          style: TextStyle(
                            color: isSelected ? theme.colorScheme.primary : Colors.white,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            overflow: TextOverflow.ellipsis,
                          ),
                          maxLines: 1,
                        ),
                        trailing: isSelected
                            ? Icon(Icons.check, size: 18, color: theme.colorScheme.primary)
                            : null,
                        onTap: () => Navigator.of(context).pop(item),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
