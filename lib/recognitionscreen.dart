
// ignore_for_file: use_super_parameters

import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:text_scanner/utils.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';

class RecognitionScreen extends StatefulWidget {
  const RecognitionScreen({Key? key}) : super(key: key);

  @override
  State<RecognitionScreen> createState() => _RecognitionScreenState();
}

class _RecognitionScreenState extends State<RecognitionScreen> {
  ImageProvider<Object>? pickedImage;
  late CameraController _cameraController;
  late List<CameraDescription> cameras;
  String extractedText = ''; 


  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    cameras = await availableCameras();
    _cameraController = CameraController(cameras[0], ResolutionPreset.medium);
    await _cameraController.initialize();
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  optionDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          children: [
            SimpleDialogOption(
              onPressed: () => pickImage(ImageSource.gallery),
              child: const Text(
                "Gallery",
                style: TextStyle(fontSize: 16.0, color: Colors.black, fontWeight: FontWeight.w800),
              ),
            ),
            SimpleDialogOption(
              onPressed: () => captureImageFromCamera(),
              child: const Text(
                "Camera",
                style: TextStyle(fontSize: 16.0, color: Colors.black, fontWeight: FontWeight.w800),
              ),
            ),
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                "Cancel",
                style: TextStyle(fontSize: 16.0, color: Colors.black, fontWeight: FontWeight.w800),
              ),
            )
          ],
        );
      },
    );
  }

  Future<void> pickImage(ImageSource source) async {
    final image = await ImagePicker().pickImage(source: source);
    if (image != null) {
      setState(() {
        pickedImage = FileImage(File(image.path));
      });
      Navigator.pop(context);
    }
  }

  Future<void> captureImageFromCamera() async {
    final XFile image = await _cameraController.takePicture();
    if (image != null) {
      setState(() {
        pickedImage = FileImage(File(image.path));
      });
      Navigator.pop(context);
    }
  }

  Future<void> extractTextFromImage() async {
  try {
    FirebaseVisionImage visionImage = FirebaseVisionImage.fromFile(
      pickedImage != null
          ? File((pickedImage as FileImage).file.path)
          : File('images/fileadd.png'), // Utilisez l'image par défaut si aucune image n'est sélectionnée
    );

    TextRecognizer textRecognizer = FirebaseVision.instance.textRecognizer();
    VisionText visionText = await textRecognizer.processImage(visionImage);

    String extractedText = '';

    for (TextBlock block in visionText.blocks) {
      for (TextLine line in block.lines) {
        // Utilisez l'interpolation de chaînes et la vérification de null
        extractedText = '${extractedText ?? ''}${line.text} ';
      }
    }


    textRecognizer.close();

    // Mettez à jour l'état pour refléter le texte extrait
    setState(() {
      extractedText = extractedText.trim();
    });

    print('Extracted Text:\n$extractedText');
  } catch (e) {
    print('Error extracting text: $e');
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF8F9FB),
      floatingActionButton: Row(mainAxisSize: MainAxisSize.min, children: [
        FloatingActionButton(
            heroTag: null, child: const Icon(Icons.copy, size: 28), onPressed: () {}),
        const SizedBox(
          width: 10,
        ),
        FloatingActionButton(
            backgroundColor: const Color(0xffEC360E),
            heroTag: null,
            child: const Icon(Icons.reply, size: 28),
            onPressed: () {}),
        FloatingActionButton(
          heroTag: null,
          child: Icon(Icons.copy, size: 28),
          onPressed: () {
            extractTextFromImage();
          },
        ),
      ]),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          child: Column(
            children: [
              const SizedBox(
                height: 55,
              ),
              Text(
                "Text Scanner",
                style: textStyle(16.0, color: Colors.blue, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 30,
              ),
              InkWell(
                onTap: () => optionDialog(context),
                child: Image(
                  image: pickedImage ?? const AssetImage('images/fileadd.png'),
                  width: 256,
                  height: 256,
                  fit: BoxFit.fill,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Text(
                extractedText.isNotEmpty ? extractedText : "Lorem Ipsum",
                style: textStyle(16.0, color: Colors.black.withOpacity(0.6), fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
