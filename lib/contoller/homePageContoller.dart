import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

class HomePageController extends ChangeNotifier {
  File? pickedImage;
  String? generatedText;
  final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

  genaerateText(File inputImage) async {
    try {
      generatedText = null;

      final RecognizedText recognizedText =
          await textRecognizer.processImage(InputImage.fromFile(inputImage));
      String text = recognizedText.text;

      generatedText = text;
      notifyListeners();
    } on Exception catch (e) {
      textRecognizer.close();

      print("exception while text Recognization $e");
    }
    textRecognizer.close();
  }

  pickImage(ImageSource source) async {
    try {
      ImagePicker imagePicker = ImagePicker();

      XFile? img = await imagePicker.pickImage(source: source);

      if (img != null) {
        pickedImage = File(img.path);
        genaerateText(pickedImage!);
        notifyListeners();
      }
    } on Exception catch (e) {
      print("exception while image picking $e");
    }
  }

  removePickedImage(dynamic value){

    pickedImage = value;
    notifyListeners();

  }
}
