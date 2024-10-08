import 'dart:convert';

import 'package:hacker_kernel_test/core/failure/server_exception.dart';
import 'package:http/http.dart' as http;

class HttpWrapper {
  static final header = {
    'Content-Type': 'application/json; charset=UTF-8',
  };

  //Get Request
  static Future<http.Response> getRequest(String url) async {
    try {
      final uri = Uri.parse(url);
      final req = await http.get(uri, headers: header);
      return req;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  //Post Request
  static Future<http.Response> postRequest(String url, Object? body) async {
    try {
      final uri = Uri.parse(url);
      final req = await http.post(uri, headers: header, body: jsonEncode(body));
      return req;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
