import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
 import 'app_exception.dart';

class ApiHelper {
  getApi({required String url}) async {
    try {
      http.Response response = await http.get(Uri.parse(url),headers: {
        "Authorization": "DL3XsZm6wMxPmo6e2kEZ5aUR4WOUNMYlSGOs7pe6nmCnePMl5LoHsnvc"
      });
      return handleResponse(response: response);
    } on SocketException catch (e) {
      throw FetchDataException(errMsg: e.toString());
    }
  }

  dynamic handleResponse({required http.Response response}) {
    switch (response.statusCode) {
      case 200:
        return jsonDecode(response.body);
      case 400:
        throw BadRequestException(errMsg: response.body.toString());
      case 401:
      case 403:
        throw UnauthorisedException(errMsg: response.body.toString());
      default:
        throw FetchDataException(
          errMsg: "Error occurred with code : ${response.statusCode}",
        );
    }
  }
}
