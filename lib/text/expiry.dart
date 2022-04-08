import 'dart:io';

import 'api.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_eyes/tts.dart';

class Expiry extends StatefulWidget {
  const Expiry({
    Key? key,
  }) : super(key: key);

  @override
  _ExpiryState createState() => _ExpiryState();
}

class _ExpiryState extends State<Expiry> {
  String _text = '';
  File? image;
  bool _loading = false;
  String out = '';

  static DateTime now = new DateTime.now();
  DateTime date = new DateTime(now.year, now.month, now.day);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text(
            'Expiry Date',
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
                        : GestureDetector(
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
                                        MediaQuery.of(context).size.width * 0.8,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  out +
                                      '''
                        Today's Date : ''' +
                                      date.day.toString() +
                                      ' ' +
                                      date.month.toString() +
                                      ' ' +
                                      date.year.toString(),
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontFamily: 'nerko',
                                    fontSize: 30,
                                  ),
                                )
                              ],
                            ),
                          ),
                  ],
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
    if (_text != null) {
      if (_text.contains('Exp Date')) {
        int index = _text.indexOf('Exp');
        var ans = _text.substring(index, index + 17);
        out = ans;
        speak(ans +
            '''And Today's Date ''' +
            date.day.toString() +
            ' ' +
            date.month.toString() +
            ' ' +
            date.year.toString());
      } else if (_text.contains('exp date')) {
        int index = _text.indexOf('exp');
        var ans = _text.substring(index, index + 17);
        out = ans;
        speak(ans +
            '''And Today's Date ''' +
            date.day.toString() +
            ' ' +
            date.month.toString() +
            ' ' +
            date.year.toString());
      } else if (_text.contains('EXP DATE')) {
        int index = _text.indexOf('EXP');
        var ans = _text.substring(index, index + 17);
        out = ans;
        speak(ans +
            '''And Today's Date ''' +
            date.day.toString() +
            ' ' +
            date.month.toString() +
            ' ' +
            date.year.toString());
      } else if (_text.contains('Expiry Date')) {
        int index = _text.indexOf('Expiry Date');
        var ans = _text.substring(index, index + 20);
        out = ans;
        speak(ans +
            '''And Today's Date ''' +
            date.day.toString() +
            ' ' +
            date.month.toString() +
            ' ' +
            date.year.toString());
      } else if (_text.contains('Exp. Date')) {
        int index = _text.indexOf('Exp. Date');
        var ans = _text.substring(index, index + 18);
        out = ans;
        speak(ans +
            '''And Today's Date ''' +
            date.day.toString() +
            ' ' +
            date.month.toString() +
            ' ' +
            date.year.toString() +
            "Click anywhere to start again.");
      } else if (_text.contains('expiry')) {
        int index = _text.indexOf('expiry date');
        var ans = _text.substring(index, index + 20);
        out = ans;
        speak(ans +
            '''And Today's Date ''' +
            date.day.toString() +
            ' ' +
            date.month.toString() +
            ' ' +
            date.year.toString() +
            "Click anywhere to start again.");
      } else if (_text.contains('EXPIRY DATE')) {
        int index = _text.indexOf('EXPIRY DATE');
        var ans = _text.substring(index, index + 20);
        out = ans;
        speak(ans +
            '''And Today's Date ''' +
            date.day.toString() +
            ' ' +
            date.month.toString() +
            ' ' +
            date.year.toString() +
            "Click anywhere to start again.");
      } else if (_text.contains('Exp')) {
        int index = _text.indexOf('Exp');
        var ans = _text.substring(index, index + 12);
        out = ans;
        speak(ans +
            '''And Today's Date ''' +
            date.day.toString() +
            ' ' +
            date.month.toString() +
            ' ' +
            date.year.toString() +
            "Click anywhere to start again.");
      } else if (_text.contains('exp')) {
        int index = _text.indexOf('exp');
        var ans = _text.substring(index, index + 12);
        out = ans;
        speak(ans +
            '''And Today's Date ''' +
            date.day.toString() +
            ' ' +
            date.month.toString() +
            ' ' +
            date.year.toString() +
            "Click anywhere to start again.");
      } else if (_text.contains('EXP')) {
        int index = _text.indexOf('EXP');
        var ans = _text.substring(index, index + 12);
        out = ans;
        speak(ans +
            '''And Today's Date ''' +
            date.day.toString() +
            ' ' +
            date.month.toString() +
            ' ' +
            date.year.toString() +
            "Click anywhere to start again.");
      } else if (_text.contains('Expiry')) {
        int index = _text.indexOf('Expiry');
        var ans = _text.substring(index, index + 15);
        out = ans;
        speak(ans +
            '''And Today's Date ''' +
            date.day.toString() +
            ' ' +
            date.month.toString() +
            ' ' +
            date.year.toString() +
            "Click anywhere to start again.");
      } else if (_text.contains('expiry')) {
        int index = _text.indexOf('expiry');
        var ans = _text.substring(index, index + 15);
        out = ans;
        speak(ans +
            '''And Today's Date ''' +
            date.day.toString() +
            ' ' +
            date.month.toString() +
            ' ' +
            date.year.toString() +
            "Click anywhere to start again.");
      } else if (_text.contains('EXPIRY')) {
        int index = _text.indexOf('EXPIRY');
        var ans = _text.substring(index, index + 15);
        out = ans;
        speak(ans +
            '''And Today's Date ''' +
            date.day.toString() +
            ' ' +
            date.month.toString() +
            ' ' +
            date.year.toString() +
            "Click anywhere to start again.");
      } else {
        speak(
            'No expiry date found. Please try taking another photo from another side or angle. Click anywhere to start again');
        out =
            'No expiry date found. Please try taking another photo from another side or angle.';
      }
    }
  }

  void setImage(File newImage) {
    setState(() {
      image = newImage;
    });
  }
}
