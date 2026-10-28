import 'dart:io';
import 'package:flutter/material.dart';

class LocalRoundedImage extends StatelessWidget {
  final String imagePath;
  final double? width;
  final double? height;
  final double borderRadius;

  const LocalRoundedImage({
    super.key,
    required this.imagePath,
    this.width,
    this.height,
    this.borderRadius = 12.0,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: width,
      height: height,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Image(
          image: FileImage(File(imagePath)),
          fit: BoxFit.fill,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return const Center(child: CircularProgressIndicator());
          },
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: theme.hintColor,
              child: Icon(Icons.broken_image, color: theme.hintColor),
            );
          },
        ),
      ),
    );
  }
}
