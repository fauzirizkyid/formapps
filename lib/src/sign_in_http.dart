// Copyright 2020, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:form_app/main.dart';
import 'package:form_app/src/validator/validator.dart';
import 'package:http/http.dart' as http;
import 'package:json_annotation/json_annotation.dart';

part 'sign_in_http.g.dart';

@JsonSerializable()
class FormData {
  String? email;
  String? password;

  FormData({
    this.email,
    this.password,
  });

  factory FormData.fromJson(Map<String, dynamic> json) =>
      _$FormDataFromJson(json);

  Map<String, dynamic> toJson() => _$FormDataToJson(this);
}

class SignInHttpDemo extends StatefulWidget {
  final http.Client? httpClient;

  const SignInHttpDemo({
    this.httpClient,
    super.key,
  });

  @override
  State<SignInHttpDemo> createState() => _SignInHttpDemoState();
}

class _SignInHttpDemoState extends State<SignInHttpDemo> {
  FormData formData = FormData();

  final _signInFormKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String? _emailError;
  String? _passwordError;

  @override
  void initState() {
    _emailController.addListener(_emailValidation);
    _passwordController.addListener(_validatePassword);
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _emailValidation() {
    final email = _emailController.text;

    if (email.length > 1) {
      setState(() {
        _emailError = validateEmail(email);
      });
    }
  }

  void _validatePassword() {
    final password = _passwordController.text;

    if (password.length > 1) {
      setState(() {
        _passwordError = validatePassword(password);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign in Form'),
      ),
      body: Form(
        key: _signInFormKey,
        child: Scrollbar(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                ...[
                  TextFormField(
                    controller: _emailController,
                    autofocus: true,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      filled: true,
                      hintText: 'Your email address',
                      labelText: 'Email',
                      errorText: _emailError,
                    ),
                    validator: validateEmail,
                    onChanged: (value) {
                      formData.email = value;
                    },
                  ),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      filled: true,
                      labelText: 'Password',
                      errorText: _passwordError,
                    ),
                    obscureText: true,
                    validator: validatePassword,
                    onChanged: (value) {
                      formData.password = value;
                    },
                  ),
                  TextButton(
                    child: const Text('Sign in'),
                    onPressed: () async {
                      if (_signInFormKey.currentState!.validate()) {
                        final response = await http.post(
                          Uri.parse('https://dummyjson.com/auth/login'),
                          body: {
                            // 'username': formData.email,
                            // 'password': formData.password,
                            'username': 'kminchelle',
                            'password': '0lelplR',
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
                        logger.e(body);

                        _showDialog(
                          switch (response.statusCode) {
                            200 => 'Successfully signed in.',
                            400 => '${body['message']}',
                            401 => 'Unable to sign in.',
                            _ => 'Something went wrong. Please try again.'
                          },
                        );
                      }

                      // Use a JSON encoded string to send
                      // var result = await widget.httpClient!.post(
                      //   Uri.parse('https://dummyjson.com/auth/login'),
                      //   body: json.encode(formData.toJson()),
                      //   headers: {'content-type': 'application/json'},
                      // );
                    },
                  ),
                ].expand(
                  (widget) => [
                    widget,
                    const SizedBox(
                      height: 24,
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDialog(String message) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(message),
        actions: [
          TextButton(
            child: const Text('OK'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}
