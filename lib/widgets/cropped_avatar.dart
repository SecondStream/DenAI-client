import 'dart:io';
import 'package:flutter/material.dart';
import 'package:den_ai/models/models.dart';

class CroppedAvatar extends StatefulWidget {
  final String imageUrl;
  final CropData? cropData;
  final double size;
  final bool isCircle;

  const CroppedAvatar({
    super.key,
    required this.imageUrl,
    this.cropData,
    this.size = 44,
    this.isCircle = true,
  });

  @override
  State<CroppedAvatar> createState() => _CroppedAvatarState();
}

class _CroppedAvatarState extends State<CroppedAvatar> {
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
  void didUpdateWidget(CroppedAvatar oldWidget) {
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
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          shape: widget.isCircle ? BoxShape.circle : BoxShape.rectangle,
          color: theme.cardColor,
        ),
        child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
      );
    }

    if (widget.cropData == null) {
      return Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          shape: widget.isCircle ? BoxShape.circle : BoxShape.rectangle,
          color: theme.cardColor,
          image: DecorationImage(image: _imageProvider, fit: BoxFit.cover),
        ),
      );
    }

    final crop = widget.cropData!;
    double targetImageWidth;
    double targetImageHeight;

    if (_imageAspect > 1.0) {
      targetImageWidth = widget.size / crop.w;
      targetImageHeight = targetImageWidth / _imageAspect;
    } else {
      targetImageHeight = widget.size / crop.h;
      targetImageWidth = targetImageHeight * _imageAspect;
    }

    Widget avatarChild = SizedBox(
      width: widget.size,
      height: widget.size,
      child: Stack(
        children: [
          Positioned(
            left: -crop.l * targetImageWidth,
            top: -crop.t * targetImageHeight,
            width: targetImageWidth,
            height: targetImageHeight,
            child: Image(
              image: _imageProvider,
              fit: BoxFit.fill,
              filterQuality: FilterQuality.high,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.broken_image, color: Colors.grey),
            ),
          ),
        ],
      ),
    );

    return widget.isCircle ? ClipOval(child: avatarChild) : avatarChild;
  }
}
