import 'dart:async';

import 'package:path/path.dart';
import 'package:async/async.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FirebaseMLApi {
  static Future<String> recogniseText(File imageFile) async {
    if (imageFile == null) {
      return 'No selected image';
    } else {
      var stream =
          http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
      var length = await imageFile.length();
      var uri = Uri.parse("https://extract-text-image.herokuapp.com/upload");
      var request = http.MultipartRequest("POST", uri);
      var multipartFile = http.MultipartFile('file', stream, length,
          filename: basename(imageFile.path));
      request.files.add(multipartFile);
      var response = await request.send();
      final respstr = await response.stream.bytesToString();
      String text = "";
      final body = json.decode(respstr);
      if (body['success']) {
        text = body['response']['text'];
      } else {
        text = body['message'];
      }

      return text;
    }
  }

  static Future<String> currencyDetection(File imageFile) async {
    if (imageFile == null) {
      return 'No selected image';
    } else {
      var stream =
          http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
      var length = await imageFile.length();
      var uri = Uri.parse("http://192.168.0.5:5000/currencydetection");
      var request = http.MultipartRequest("POST", uri);
      var multipartFile = http.MultipartFile('file', stream, length,
          filename: basename(imageFile.path));
      request.files.add(multipartFile);
      var response = await request.send();
      final respstr = await response.stream.bytesToString();
      String text = "";
      final body = json.decode(respstr);
      if (body['success']) {
        text = body['prediction'];
      } else {
        text = body['message'];
      }

      return text;
    }
  }

  static Future<String> objectDetection(File imageFile) async {
    if (imageFile == null) {
      return 'No selected image';
    } else {
      var stream =
          http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
      var length = await imageFile.length();
      var uri = Uri.parse("http://192.168.0.5:5000/objectdetection");
      var request = http.MultipartRequest("POST", uri);
      var multipartFile = http.MultipartFile('file', stream, length,
          filename: basename(imageFile.path));
      request.files.add(multipartFile);
      var response = await request.send();
      final respstr = await response.stream.bytesToString();
      String text = "";
      final body = json.decode(respstr);
      if (body['success']) {
        text = body['prediction'];
      } else {
        text = body['message'];
      }

      return text;
    }
  }

//   static extractText(VisionText visionText) {
//     String text = '';

//     for (TextBlock block in visionText.blocks) {
//       for (TextLine line in block.lines) {
//         for (TextElement word in line.elements) {
//           text = text + word.text + ' ';
//         }
//         text = text + '\n';
//       }
//     }

//     return text;
//   }
}
