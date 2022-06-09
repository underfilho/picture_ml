import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';

const url = 'https://api-drawing-recognizer.herokuapp.com/analyze-image';

class Api {
  Future<String?> recognizeImage(String filePath) async {
    final formData = FormData.fromMap({
      'image': MultipartFile.fromBytes(
        await File.fromUri(Uri.parse(filePath)).readAsBytes(),
        filename: 'image',
        contentType: MediaType("image", "jpg"),
      )
    });

    final response = await Dio().post(url, data: formData);

    if (response.statusCode == 200) {
      final body = response.data;
      return body['message'];
    } else {
      throw Exception();
    }
  }
}
