import 'package:flutter/material.dart';
import 'package:my_eyes/text/api.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'tts.dart';

class ColorWidget extends StatefulWidget {
  const ColorWidget({Key? key}) : super(key: key);

  @override
  _ColorWidgetState createState() => _ColorWidgetState();
}

class _ColorWidgetState extends State<ColorWidget> {
  File? _image;
  String? _outputs;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    // _loading = true;
    speak('Click anywhere to open the camera and take a photo');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Color Recognition',
        ),
      ),
      body: _loading
          ? Container(
              alignment: Alignment.center,
              child: const CircularProgressIndicator(),
            )
          : SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _image == null
                      ? Expanded(
                          child: GestureDetector(
                            onTap: pickImage,
                            child: Container(
                              height: double.infinity,
                              width: double.infinity,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Center(
                                    child: Text(
                                      'Click anywhere to open the Camera',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      : GestureDetector(
                          onTap: () => Navigator.of(context)
                              .pushNamedAndRemoveUntil(
                                  '/', (Route<dynamic> route) => false),
                          child: Column(
                            children: [
                              Container(
                                child: Image.file(_image!),
                                constraints: BoxConstraints(
                                  maxHeight:
                                      MediaQuery.of(context).size.height * 0.7,
                                  maxWidth:
                                      MediaQuery.of(context).size.width * 0.8,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                "This seems to be $_outputs",
                                style: const TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                ],
              ),
            ),
    );
  }

  pickImage() async {
    var image = await ImagePicker().pickImage(source: ImageSource.camera);
    if (image == null) return null;
    setState(() {
      _loading = true;
      _image = File(image.path);
    });
    classifyImage(File(image.path));
  }

  classifyImage(File image) async {
    setState(() {
      _loading = true;
    });
    var output = await FirebaseMLApi.objectDetection(image);
    setState(() {
      _loading = false;
      _outputs = output;
    });
    if (_outputs != null) {
      speak("This seems to be $_outputs. Click anywhere to start again.");
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
