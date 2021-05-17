import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_stock_app/views/LoginPage.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() {
  HttpOverrides.global = new MyHttpOverrides();

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: SafeArea(child: LoginPage()),
  ));
}
