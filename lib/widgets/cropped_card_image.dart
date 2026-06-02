import 'dart:io';
import 'package:flutter/material.dart';
import 'package:den_ai/models/models.dart';

class CroppedCardImage extends StatefulWidget {
  final String imageUrl;
  final CropData? cropData;

  const CroppedCardImage({super.key, required this.imageUrl, this.cropData});

  @override
  State<CroppedCardImage> createState() => _CroppedCardImageState();
}

class _CroppedCardImageState extends State<CroppedCardImage> {
  double _imageAspect = 1.0;
  bool _isAspectInitialized = false;
  late ImageProvider _imageProvider;

  @override
  void initState() {
    super.initState();
    _initImageProvider();
    _calculateAspect();
  }

  @override
  void didUpdateWidget(CroppedCardImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.imageUrl != widget.imageUrl) {
      _initImageProvider();
      _calculateAspect();
    }
  }

  void _initImageProvider() {
    _imageProvider = widget.imageUrl.startsWith('http')
        ? NetworkImage(widget.imageUrl)
        : FileImage(File(widget.imageUrl));
  }

  void _calculateAspect() {
    if (widget.cropData == null) {
      setState(() => _isAspectInitialized = true);
      return;
    }

    _imageProvider
        .resolve(const ImageConfiguration())
        .addListener(
          ImageStreamListener((ImageInfo info, bool _) {
            if (!mounted) return;
            setState(() {
              _imageAspect = info.image.width / info.image.height;
              _isAspectInitialized = true;
            });
          }),
        );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (!_isAspectInitialized) {
      return Container(
        color: theme.cardColor,
        child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
      );
    }

    if (widget.cropData == null) {
      return Image(
        image: _imageProvider,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (context, error, stackTrace) =>
            const Icon(Icons.broken_image, color: Colors.grey),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final double viewWidth = constraints.maxWidth;
        final double viewHeight = constraints.maxHeight;
        final crop = widget.cropData!;

        double targetImageWidth;
        double targetImageHeight;

        if (_imageAspect > 1.0) {
          targetImageWidth = viewWidth / crop.w;
          targetImageHeight = targetImageWidth / _imageAspect;
        } else {
          targetImageHeight = viewHeight / crop.h;
          targetImageWidth = targetImageHeight * _imageAspect;
        }

        return Stack(
          children: [
            Positioned(
              left: -crop.l * targetImageWidth,
              top: -crop.t * targetImageHeight,
              width: targetImageWidth,
              height: targetImageHeight,
              child: Image(
                image: _imageProvider,
                fit: BoxFit.fill,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.broken_image, color: Colors.grey),
              ),
            ),
          ],
        );
      },
    );
  }
}
