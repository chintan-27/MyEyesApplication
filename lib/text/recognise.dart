import 'dart:io';

import 'api.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:image_picker/image_picker.dart';
import 'package:my_eyes/tts.dart';

class TextRecognitionWidget extends StatefulWidget {
  const TextRecognitionWidget({
    Key? key,
  }) : super(key: key);

  @override
  _TextRecognitionWidgetState createState() => _TextRecognitionWidgetState();
}

class _TextRecognitionWidgetState extends State<TextRecognitionWidget> {
  String _text = '';
  File? image;
  bool _loading = false;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text(
            'Text Recognition',
          ),
        ),
        body: _loading
            ? Container(
                alignment: Alignment.center,
                child: const CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      image == null
                          ? Expanded(
                              child: GestureDetector(
                                onTap: pickImage,
                                child: SizedBox(
                                  height: double.infinity,
                                  width: double.infinity,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Text(
                                        'Click anywhere to open the Camera',
                                        style: TextStyle(
                                          fontSize: 20,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          : SingleChildScrollView(
                              child: GestureDetector(
                                onTap: () => Navigator.of(context)
                                    .pushNamedAndRemoveUntil(
                                        '/', (Route<dynamic> route) => false),
                                child: Column(
                                  children: [
                                    Container(
                                      child: Image.file(image!),
                                      constraints: BoxConstraints(
                                        maxHeight:
                                            MediaQuery.of(context).size.height *
                                                0.7,
                                        maxWidth:
                                            MediaQuery.of(context).size.width *
                                                0.8,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      _text,
                                      style: const TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
              ),
      );

  Future pickImage() async {
    final file = await ImagePicker().pickImage(source: ImageSource.camera);
    setImage(File(file!.path));
    scanText();
  }

  Future scanText() async {
    setState(() {
      _loading = true;
    });
    final text = await FirebaseMLApi.recogniseText(image!);
    setState(() {
      _text = text;
      _loading = false;
    });
    if (_text != "") {
      speak(_text + "Click anywhere to start again.");
      print(_text);
    }
  }

  void setImage(File newImage) {
    setState(() {
      image = newImage;
    });
  }
}
