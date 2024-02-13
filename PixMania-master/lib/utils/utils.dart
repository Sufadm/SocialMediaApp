import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
//pic an image from gallery/camera

pickImage(ImageSource imageSource) async {
  ImagePicker imagePicker = ImagePicker();

  XFile? file = await imagePicker.pickImage(source: imageSource);
  if (file != null) {
    return file.readAsBytes();
  }
}

// for displaying snackbars
showSnackBar(BuildContext context, String text) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(text),
    ),
  );
}
