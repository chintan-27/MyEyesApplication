import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:my_eyes/text/api.dart';
import 'package:path_provider/path_provider.dart';
import 'package:my_eyes/classifier.dart';
import 'package:my_eyes/classifierpagemodel.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';
import 'tts.dart';

class PageScreen extends StatefulWidget {
  final List<CameraDescription>? cameras;
  const PageScreen({Key? key, required this.cameras}) : super(key: key);

  @override
  State<PageScreen> createState() => _PageScreenState();
}

class _PageScreenState extends State<PageScreen> {
  CameraController? controller;
  late Classifier _classifier;

  var logger = Logger();

  Timer? _t;

  File? _image;

  Image? _imageWidget;

  img.Image? fox;

  Category? category;
  bool clicked = false;

  String tx = "";

  Future<bool> _predict() async {
    img.Image imageInput = img.decodeImage(_image!.readAsBytesSync())!;
    var pred = _classifier.predict(imageInput);
    speak(category!.label);
    setState(() {
      category = pred;
    });
    if (category!.label == "Perfect") {
      return true;
    } else {
      return false;
    }
  }

  Future getImage() async {
    if (controller!.value.isInitialized) {
      final Directory extDir = await getApplicationDocumentsDirectory();
      final String dirPath = '${extDir.path}/media';
      await Directory(dirPath).create(recursive: true);
      final String filePath =
          '$dirPath/${DateTime.now().millisecondsSinceEpoch.toString()}.jpeg';
      XFile fileTaken = await controller!.takePicture();

      setState(() {
        _image = File(fileTaken.path);
      });
      bool res = await _predict();
      return res;
    }
  }

  @override
  void initState() {
    _classifier = ClassifierPageModel();
    controller = CameraController(widget.cameras![0], ResolutionPreset.max);
    controller!.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
    speak("Click to start assistive reader");
    super.initState();
  }

  @override
  Future<void> dispose() async {
    super.dispose();
    controller?.dispose();
    _classifier.close();
    final cacheDir = await getTemporaryDirectory();

    if (cacheDir.existsSync()) {
      cacheDir.deleteSync(recursive: true);
    }
    final appDir = await getApplicationSupportDirectory();

    if (appDir.existsSync()) {
      appDir.deleteSync(recursive: true);
    }
    if (_t != null) {
      _t!.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Camera"),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              clicked
                  ? Center(
                      child: Container(
                        constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height * 0.8,
                          maxWidth: MediaQuery.of(context).size.width * 0.9,
                        ),
                        padding: const EdgeInsets.all(10),
                        child: CameraPreview(controller!),
                      ),
                    )
                  : GestureDetector(
                      onTap: () {
                        setState(() {
                          clicked = true;
                        });
                        const oneSec = Duration(seconds: 5);
                        _t = Timer.periodic(oneSec, (Timer t) async {
                          bool condition = await getImage();
                          if (condition) {
                            t.cancel();
                            setState(() {
                              clicked = false;
                              _imageWidget = Image.file(_image!);
                            });
                            final text =
                                await FirebaseMLApi.recogniseText(_image!);
                            setState(() {
                              tx = text;
                            });
                            speak(text);
                          }
                        });
                      },
                      child: Center(
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.75,
                          width: MediaQuery.of(context).size.width * 0.9,
                          padding: const EdgeInsets.all(10),
                          color: Colors.black,
                          child: clicked ? Container() : _imageWidget,
                        ),
                      ),
                    ),
              Text(
                category != null ? category!.label : '',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                category != null
                    ? 'Confidence: ${category!.score.toStringAsFixed(3)}'
                    : '',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                tx,
                style: const TextStyle(fontSize: 16),
              )
            ],
          ),
        ),
      ),
    );
  }
}
