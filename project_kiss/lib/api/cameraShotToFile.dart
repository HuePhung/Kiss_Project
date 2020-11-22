import 'dart:io';
import 'package:test_final/api/firebase_text_api.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CameraShotToFile {
  static Future createFile() async {
    final _picker = ImagePicker();
    PickedFile image = await _picker.getImage(source: ImageSource.camera,
      maxWidth: 600,
    );
    if (image == null) {
      return;
    }
    File fileImage = setFile(File(image.path)); // die Fkt um ein File zu erhalten
    final text = await FirebaseMLApi.recogniseText(fileImage);
    print(text);
  }
  static setFile(File newImage) {
    File _storedImage;
    if (newImage != null) {
      _storedImage = newImage;
      return _storedImage;
    } else {
      print('No image selected.');
    }
  }
}