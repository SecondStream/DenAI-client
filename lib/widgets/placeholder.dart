import 'package:flutter/material.dart';

class EmptyPlaceholder extends StatelessWidget {
  final IconData icon;
  final String label;

  const EmptyPlaceholder({super.key, required this.icon, required this.label});
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 75,
            color: theme.hintColor,
          ),
          SizedBox(height: 10),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(color: theme.hintColor),
          ),
        ],
      ),
    );
  }

}