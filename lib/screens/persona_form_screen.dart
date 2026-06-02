import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:den_ai/application/config.dart';
import 'package:den_ai/models/models.dart';
import 'package:den_ai/tools/file_tool.dart';
import 'package:den_ai/widgets/dialogs/image_crop_dialog.dart';
import 'package:flutter/material.dart';

abstract class PersonaFormScreenState<T extends StatefulWidget> extends State<T> {
  File? selectedAvatarFile;
  CropData? currentCropData;

  Future<void> handleAvatarClick(BuildContext context, Persona? persona, {File? newAvatar}) async {
    final baseUrl = AppConfig.of(context).baseUrl;
    final userAvatar = persona?.getAvatar(baseUrl);

    ImageProvider? providerToCrop;
    if (newAvatar != null) {
      providerToCrop = FileImage(newAvatar);
    } else {
      if (selectedAvatarFile != null) {
        providerToCrop = FileImage(selectedAvatarFile!);
      } else if (userAvatar != null) {
        providerToCrop = CachedNetworkImageProvider(userAvatar);
      }
      if (providerToCrop == null) {
        _pickNewAvatarFile(context, persona);
        return;
      }
    }

    final cropData = newAvatar != null ? null : currentCropData ?? persona?.getCropData();

    final result = await AvatarClipperDialog.open(
      context,
      providerToCrop,
      initialCrop: cropData,
      onFilePickRequested: () => _pickNewAvatarFile(context, persona),
    );

    if (result != null) {
      setState(() {
        currentCropData = result;
        if (newAvatar != null) selectedAvatarFile = newAvatar;
      });
    }
  }

  Future<void> _pickNewAvatarFile(BuildContext context, Persona? persona) async {
    final File? image = await FileTool.pickImage();
    if (image != null && mounted) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => handleAvatarClick(context, persona, newAvatar: image),
      );
    }
  }
}
