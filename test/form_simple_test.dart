import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

Future signIn(
  String username,
  String password,
) async {
  final response = await http.post(
    Uri.parse('https://dummyjson.com/auth/login'),
    body: {
      // 'username': formData.email,
      // 'password': formData.password,
      'username': username,
      'password': password,
    },
  );

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to Login');
  }
}

void main() {
  group(
    'API Service Test',
    () {
      test('Sucess SignIn', () async {
        //SAMPLE DUMMY - BEGIN/ {message: Success!}
        final result = await signIn('kminchelle', '0lelplR');

        expect(result['username'], 'kminchelle');
        //ACTUAL RESULT - END
      });

      test(
        'Failed SigIn throws an Exception',
        () async {
          expect(
            () async => await signIn('wronguser', 'wrongpass'),
            throwsA(isA<Exception>()),
          );
        },
      );
    },
  );
}
