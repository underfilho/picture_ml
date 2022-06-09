import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:picture_ml/app/api.dart';

class HomeController {
  final api = Api();
  final notifierState = ValueNotifier(ViewState.initial);
  ViewState get state => notifierState.value;

  final notifierImage = ValueNotifier<String?>(null);
  String? get imagePath => notifierImage.value;

  String? recognizedImage;

  Future<void> selectImage() async {
    final imagePicker = ImagePicker();

    final image = await imagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 20);
    notifierImage.value = image?.path;
  }

  Future<void> recognizeImage() async {
    notifierState.value = ViewState.loading;

    final response = await api.recognizeImage(imagePath!);
    recognizedImage = response;
    notifierState.value = ViewState.done;
  }

  void deleteImage() => notifierImage.value = null;
}

enum ViewState { initial, loading, done, error }
