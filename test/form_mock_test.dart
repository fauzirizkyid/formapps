import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:form_app/src/repository/sign_in_repository.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'mock_dart.mocks.dart';

void main() {
  group(
    'API Service Tests',
    () {
      final client = MockClient();
      final pathSignIn = Uri.parse('https://dummyjson.com/auth/login');

      test('Successful login returns user data', () async {
        final responsePayload = jsonEncode(
          {
            'id': 15,
            'username': 'kminchelle',
            'email': 'kminchelle@qq.com',
            'firstName': 'Jeanne',
            'lastName': 'Halvorson',
            'gender': 'female',
            'image': 'https://robohash.org/Jeanne.png?set=set4',
            'token':
                'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MTUsInVzZXJuYW1lIjoia21pbmNoZWxsZSIsImVtYWlsIjoia21pbmNoZWxsZUBxcS5jb20iLCJmaXJzdE5hbWUiOiJKZWFubmUiLCJsYXN0TmFtZSI6IkhhbHZvcnNvbiIsImdlbmRlciI6ImZlbWFsZSIsImltYWdlIjoiaHR0cHM6Ly9yb2JvaGFzaC5vcmcvSmVhbm5lLnBuZz9zZXQ9c2V0NCIsImlhdCI6MTcxMTIwOTAwMSwiZXhwIjoxNzExMjEyNjAxfQ.F_ZCpi2qdv97grmWiT3h7HcT1prRJasQXjUR4Nk1yo8',
          },
        );

        when(
          client.post(
            pathSignIn,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(
              {
                'username': 'kminchelle',
                'password': '0lelplR',
              },
            ),
          ),
        ).thenAnswer(
          (_) async => http.Response(
            responsePayload,
            200,
          ),
        );

        final result = await Authentication.login(
          'kminchelle',
          '0lelplR',
          client: client,
        );

        expect(result['data']['username'], 'kminchelle');
        expect(result['data']['email'], 'kminchelle@qq.com');
      });

      test(
        'Failed login throws an exception',
        () async {
          when(
            client.post(
              pathSignIn,
              headers: {'Content-Type': 'application/json'},
              body: jsonEncode(
                {
                  'username': 'wronguser',
                  'password': 'wrongpass',
                },
              ),
            ),
          ).thenAnswer(
            (_) async => http.Response(
              'Invalid credentials',
              401,
            ),
          );

          expect(
            () async => await Authentication.login(
              'wronguser',
              'wrongpass',
              client: client,
            ),
            throwsA(isA<Exception>()),
          );
        },
      );
    },
  );
}
