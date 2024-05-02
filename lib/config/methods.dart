import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:galaxy_satwa/config/theme.dart';
import 'package:image_picker/image_picker.dart';

Future<XFile?> selectImage() async {
  XFile? selectedImage =
      await ImagePicker().pickImage(source: ImageSource.gallery);
  return selectedImage;
}

Future<File?> selectImageGalery() async {
  var resultGambar = await FilePicker.platform.pickFiles(type: FileType.image);
  File imageFile = File(resultGambar!.files.single.path.toString());

  return imageFile;
}

Future<XFile?> openCamera() async {
  XFile? selectedImage =
      await ImagePicker().pickImage(source: ImageSource.camera);
  return selectedImage;
}

// File? _fileFile;
Future<FilePickerResult?> selectFile() async {
  FilePickerResult? resultFile = await FilePicker.platform.pickFiles(
      // type: FileType.custom, allowedExtensions: ['jpg', 'png', 'pdf']);
      type: FileType.custom,
      allowedExtensions: ['pdf']);
  return resultFile;
}
