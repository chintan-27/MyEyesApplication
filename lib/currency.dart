import 'package:flutter/material.dart';
import 'package:my_eyes/text/api.dart';
import "package:tflite/tflite.dart";
// ignore: import_of_legacy_library_into_null_safe
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'tts.dart';

class currency extends StatefulWidget {
  @override
  _currencyState createState() => _currencyState();
}

class _currencyState extends State<currency> {
  File? _image;
  List? _outputs;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    // _loading = true;
    speak(
        'Try to capture the notes one by one. Click anywhere to open the camera.');
    // loadModel().then((value) {
    //   setState(() {
    //     _loading = false;
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Currency Recognition',
        ),
      ),
      body: _loading
          ? Container(
              alignment: Alignment.center,
              child: const CircularProgressIndicator(),
            )
          : Container(
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
                      : GestureDetector(
                          onTap: () => Navigator.of(context)
                              .pushNamedAndRemoveUntil(
                                  '/', (Route<dynamic> route) => false),
                          child: Column(
                            children: [
                              Container(
                                child: Image.file(File(_image!.path)),
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
                                "You got ${_outputs![0]}.",
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
    final text = await FirebaseMLApi.currencyDetection(_image!);
    setState(() {
      _loading = false;
      _outputs = [text];
    });

    speak(text);
    // classifyImage(File(image.path));
  }

//   classifyImage(File image) async {
//     var output = await Tflite.runModelOnImage(
//       path: image.path,
//       numResults: 2,
//       threshold: 0.5,
//       imageMean: 127.5,
//       imageStd: 127.5,
//     );
//     setState(() {
//       _loading = false;
//       _outputs = output!;
//     });
//     if (_outputs != null) {
//       speak(
//           "You got ${_outputs![0]["label"].toString().substring(2)} rupees.  Click anywhere to start again.");
//     }
//   }

//   loadModel() async {
//     await Tflite.loadModel(
//       model: "assets/model_unquant.tflite",
//       labels: "assets/labels.txt",
//     );
//   }

//   @override
//   void dispose() {
//     Tflite.close();
//     super.dispose();
//   }
}
