// Copyright 2020, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io' show Platform;

import 'package:alice/alice.dart';
import 'package:flutter/foundation.dart' show kDebugMode, kIsWeb;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:window_size/window_size.dart';

import 'src/autofill.dart';
import 'src/form_widgets.dart';
import 'src/http/mock_client.dart';
import 'src/sign_in_http.dart';
import 'src/validation.dart';

Alice alice = Alice();
Logger logger = Logger();

void main() {
  setupWindow();
  _doCalls();
  runApp(const FormApp());
}

const double windowWidth = 480;
const double windowHeight = 854;

Future<void> _doCalls() async {
  await _doCall1();
  await _doCall2();
  await _doCall3();
  await _doCall4();
  await _doCall5();
}

Future<void> _doCall1() async {
  final response = await http.get(
    Uri.parse('https://jsonplaceholder.typicode.com/posts/1'),
  );
  logger.d(response.request);
  logger.d(response.headers);
  logger.d(response.body);
  alice.onHttpResponse(response);
}

Future<void> _doCall2() async {
  final response = await http.post(
    Uri.parse('https://jsonplaceholder.typicode.com/posts/1/comments?postId=1'),
    body: {
      'title': 'foo',
      'body': 'bar',
      'userId': '1',
    },
  );
  alice.onHttpResponse(response);
}

Future<void> _doCall3() async {
  final response = await http.put(Uri.parse(
      'https://jsonplaceholder.typicode.com/posts/1/comments?postId=1'));
  alice.onHttpResponse(response);
}

Future<void> _doCall4() async {
  final response = await http.patch(
    Uri.parse('https://jsonplaceholder.typicode.com/posts/1'),
    body: {'title': 'foo'},
  );
  alice.onHttpResponse(response);
}

Future<void> _doCall5() async {
  final response = await http.delete(
    Uri.parse('https://jsonplaceholder.typicode.com/posts/1'),
    body: {'title': 'foo'},
  );
  alice.onHttpResponse(response);
}

void setupWindow() {
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    WidgetsFlutterBinding.ensureInitialized();
    setWindowTitle('Form Samples');
    setWindowMinSize(const Size(windowWidth, windowHeight));
    setWindowMaxSize(const Size(windowWidth, windowHeight));
    getCurrentScreen().then((screen) {
      setWindowFrame(Rect.fromCenter(
        center: screen!.frame.center,
        width: windowWidth,
        height: windowHeight,
      ));
    });
  }
}

final demos = [
  Demo(
    name: 'Sign in with HTTP',
    route: 'signin_http',
    builder: (context) => SignInHttpDemo(
      // This sample uses a mock HTTP client.
      httpClient: mockClient,
    ),
  ),
  Demo(
    name: 'Autofill',
    route: 'autofill',
    builder: (context) => const AutofillDemo(),
  ),
  Demo(
    name: 'Form widgets',
    route: 'form_widgets',
    builder: (context) => const FormWidgetsDemo(),
  ),
  Demo(
    name: 'Validation',
    route: 'validation',
    builder: (context) => const FormValidationDemo(),
  ),
];

final router = GoRouter(
  navigatorKey: alice.getNavigatorKey(),
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomePage(),
      routes: [
        for (final demo in demos)
          GoRoute(
            path: demo.route,
            builder: (context, state) => demo.builder(context),
          ),
      ],
    ),
  ],
);

class FormApp extends StatelessWidget {
  const FormApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Form Samples',
      theme: ThemeData(
        colorSchemeSeed: Colors.teal,
      ),
      routerConfig: router,
      builder: (context, child) {
        return Scaffold(
          body: Stack(
            children: [
              child ?? const SizedBox(),
              if (kDebugMode)
                Positioned(
                  bottom: 2,
                  left: 2,
                  child: GestureDetector(
                    child: const Icon(
                      Icons.info_outline,
                      color: Color.fromRGBO(0, 0, 0, 1),
                      size: 24,
                    ),
                    onTap: () async {
                      alice.showInspector();
                    },
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Form Samples'),
      ),
      body: ListView(
        children: [...demos.map((d) => DemoTile(demo: d))],
      ),
    );
  }
}

class DemoTile extends StatelessWidget {
  final Demo? demo;

  const DemoTile({this.demo, super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(demo!.name),
      onTap: () {
        context.go('/${demo!.route}');
      },
    );
  }
}

class Demo {
  final String name;
  final String route;
  final WidgetBuilder builder;

  const Demo({required this.name, required this.route, required this.builder});
}
