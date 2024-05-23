import 'dart:convert';

import 'package:form_app/main.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class Authentication {
  static Future<Map<String, dynamic>> login(
    String username,
    String password, {
    http.Client? client,
  }) async {
    Response response;
    final pathSignIn = Uri.parse('https://dummyjson.com/auth/login');

    if (client != null) {
      response = await client.post(
        pathSignIn,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      );
    } else {
      response = await http.post(
        pathSignIn,
        body: {
          // 'username': formData.email,
          // 'password': formData.password,
          'username': username,
          'password': password,
        },
      );

      final header = response.headers;
      final request = response.request;
      final statusCode = response.statusCode;
      final body = jsonDecode(response.body);

      alice.onHttpResponse(response);
      logger.w(header);
      logger.i("statusCode: $statusCode");
      logger.f(request);
      logger.d(body);
    }

    if (response.statusCode == 200) {
      return {
        "data": json.decode(response.body),
        "code": response.statusCode,
      };
    } else {
      throw Exception('Failed to login');
    }
  }
}
