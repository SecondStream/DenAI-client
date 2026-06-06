import 'package:den_ai/application/l10n.dart';
import 'package:den_ai/extensions/navigation_ext.dart';
import 'package:den_ai/models/models.dart';
import 'package:flutter/material.dart';

class AvatarClipperDialog extends StatefulWidget {
  final ImageProvider imageProvider;
  final CropData? initialCrop;
  final VoidCallback? onFilePickRequested;

  const AvatarClipperDialog({
    super.key,
    required this.imageProvider,
    this.initialCrop,
    this.onFilePickRequested,
  });

  static Future<CropData?> open(
    BuildContext context,
    ImageProvider provider, {
    CropData? initialCrop,
    VoidCallback? onFilePickRequested,
  }) {
    return showDialog<CropData>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AvatarClipperDialog(
        imageProvider: provider,
        initialCrop: initialCrop,
        onFilePickRequested: onFilePickRequested,
      ),
    );
  }

  @override
  State<AvatarClipperDialog> createState() => _AvatarClipperDialogState();
}

class _AvatarClipperDialogState extends State<AvatarClipperDialog> {
  late ImageProvider _currentProvider;
  Offset _circleCenter = const Offset(100, 100);
  double _cropSize = 120.0;

  double _boxWidth = 400.0;
  double _boxHeight = 400.0;
  bool _isSizeInitialized = false;

  @override
  void initState() {
    super.initState();
    _currentProvider = widget.imageProvider;
    _initializeContainerSize(widget.initialCrop);
  }

  void _initializeContainerSize(CropData? savedCrop) {
    _currentProvider
        .resolve(const ImageConfiguration())
        .addListener(
          ImageStreamListener((ImageInfo info, bool _) {
            if (!mounted) return;

            final double imgWidth = info.image.width.toDouble();
            final double imgHeight = info.image.height.toDouble();
            final double aspect = imgWidth / imgHeight;

            setState(() {
              const double maxSize = 350.0;

              if (aspect > 1.0) {
                _boxWidth = maxSize;
                _boxHeight = maxSize / aspect;
              } else {
                _boxWidth = maxSize * aspect;
                _boxHeight = maxSize;
              }

              if (savedCrop != null) {
                _cropSize = savedCrop.w * _boxWidth;
                final double radius = _cropSize / 2;
                final double x = (savedCrop.l * _boxWidth) + radius;
                final double y = (savedCrop.t * _boxHeight) + radius;
                _circleCenter = Offset(x, y);
              } else {
                _cropSize = (_boxWidth < _boxHeight ? _boxWidth : _boxHeight);
                _circleCenter = Offset(_boxWidth / 2, _boxHeight / 2);
              }
              _isSizeInitialized = true;
            });
          }),
        );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loc = AppLocalization.of(context);

    if (!_isSizeInitialized) {
      return const AlertDialog(
        backgroundColor: Colors.transparent,
        content: Center(child: CircularProgressIndicator()),
      );
    }

    final double maxAllowedCropSize = _boxWidth < _boxHeight ? _boxWidth : _boxHeight;

    return AlertDialog(
      backgroundColor: theme.scaffoldBackgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(loc.cropAvatarTitle, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          if (widget.onFilePickRequested != null)
            Tooltip(
              message: loc.replaceAvatarHint,
              child: IconButton(
                icon: Icon(Icons.photo_library, color: theme.colorScheme.primary, size: 22),
                onPressed: () {
                  context.pop();
                  widget.onFilePickRequested!();
                },
              ),
            ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: _boxWidth,
            height: _boxHeight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.black12,
            ),
            clipBehavior: Clip.antiAlias,
            child: GestureDetector(
              onPanUpdate: (details) {
                setState(() {
                  final radius = _cropSize / 2;
                  double newX = (_circleCenter.dx + details.delta.dx).clamp(
                    radius,
                    _boxWidth - radius,
                  );
                  double newY = (_circleCenter.dy + details.delta.dy).clamp(
                    radius,
                    _boxHeight - radius,
                  );
                  _circleCenter = Offset(newX, newY);
                });
              },
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Image(image: _currentProvider, fit: BoxFit.fill),
                  ),
                  Positioned.fill(
                    child: IgnorePointer(
                      child: CustomPaint(
                        painter: FloatingHolePainter(center: _circleCenter, radius: _cropSize / 2),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Slider(
            value: _cropSize.clamp(40.0, maxAllowedCropSize),
            min: 40.0,
            max: maxAllowedCropSize,
            onChanged: (value) {
              setState(() {
                _cropSize = value;
                final radius = _cropSize / 2;
                double newX = _circleCenter.dx.clamp(radius, _boxWidth - radius);
                double newY = _circleCenter.dy.clamp(radius, _boxHeight - radius);
                _circleCenter = Offset(newX, newY);
              });
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => context.pop(),
          child: Text(loc.cancel, style: TextStyle(color: Colors.grey)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: theme.colorScheme.primary),
          onPressed: _submitCrop,
          child: Text(
            loc.ready,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  void _submitCrop() {
    final double radius = _cropSize / 2;
    final double cropLeft = _circleCenter.dx - radius;
    final double cropTop = _circleCenter.dy - radius;

    context.pop(
      CropData(
        l: (cropLeft / _boxWidth).clamp(0.0, 1.0),
        t: (cropTop / _boxHeight).clamp(0.0, 1.0),
        w: (_cropSize / _boxWidth).clamp(0.0, 1.0),
        h: (_cropSize / _boxHeight).clamp(0.0, 1.0),
      ),
    );
  }
}

class FloatingHolePainter extends CustomPainter {
  final Offset center;
  final double radius;
  FloatingHolePainter({required this.center, required this.radius});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.black.withValues(alpha: .7);
    final outerPath = Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    final innerPath = Path()..addOval(Rect.fromCircle(center: center, radius: radius));
    final path = Path.combine(PathOperation.difference, outerPath, innerPath);
    canvas.drawPath(path, paint);

    final borderPaint = Paint()
      ..color = Colors.white.withValues(alpha: .6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawCircle(center, radius, borderPaint);
  }

  @override
  bool shouldRepaint(FloatingHolePainter oldDelegate) =>
      oldDelegate.center != center || oldDelegate.radius != radius;
}
