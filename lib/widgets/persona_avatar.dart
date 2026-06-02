import 'package:den_ai/application/config.dart';
import 'package:den_ai/models/models.dart';
import 'package:den_ai/widgets/cropped_avatar.dart';
import 'package:flutter/material.dart';

class PersonaAvatar extends StatelessWidget {
  final double size;
  final IconData? icon;
  final double? iconSize;
  final Color? backgroundColor;
  final Color? iconColor;
  final String? Function(String)? _getAvatarUrl;
  final CropData? Function()? _getCropData;

  final String? _avatarUrl;
  final CropData? _cropData;

  PersonaAvatar(
    Persona? persona, {
    Key? key,
    double size = 44,
    IconData? icon,
    double? iconSize,
    Color? backgroundColor,
    Color? iconColor,
  }) : this._internal(
         key: key,
         size: size,
         icon: icon,
         iconSize: iconSize,
         backgroundColor: backgroundColor,
         iconColor: iconColor,
         getAvatarUrl: persona?.getAvatar,
         getCropData: persona?.getCropData,
       );

  factory PersonaAvatar.form(String? avatarUrl, CropData? cropData) {
    return PersonaAvatar._internal(
      size: 120,
      iconSize: 40,
      icon: Icons.add_a_photo,
      iconColor: Colors.grey,
      avatarUrl: avatarUrl,
      cropData: cropData,
    );
  }

  const PersonaAvatar._internal({
    super.key,
    required this.size,
    this.icon,
    this.iconSize,
    this.backgroundColor,
    this.iconColor,
    String? Function(String)? getAvatarUrl,
    CropData? Function()? getCropData,
    String? avatarUrl,
    CropData? cropData,
  }) : _getAvatarUrl = getAvatarUrl,
       _getCropData = getCropData,
       _avatarUrl = avatarUrl,
       _cropData = cropData;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final avatarUrl = _avatarUrl ?? _getAvatarUrl?.call(AppConfig.of(context).baseUrl);
    final cropData = _cropData ?? _getCropData?.call();
    return avatarUrl == null
        ? CircleAvatar(
            radius: size * .5,
            backgroundColor: backgroundColor ?? theme.colorScheme.primary.withValues(alpha: 0.15),
            child: Icon(
              icon ?? Icons.person,
              size: iconSize ?? size * .7,
              color: iconColor ?? Colors.grey,
            ),
          )
        : CroppedAvatar(imageUrl: avatarUrl, cropData: cropData, size: size);
  }
}
