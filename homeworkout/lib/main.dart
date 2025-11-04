// main.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'auth_screens.dart'; // Impor file screen autentikasi

// Kelas ini diperlukan untuk mengatasi masalah sertifikat SSL saat melakukan panggilan HTTP
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() {
  // Menerapkan HttpOverrides secara global
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Home Workout App',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange, // Tema warna yang energik
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Roboto', // Font yang modern dan mudah dibaca
      ),
      // Layar pertama yang ditampilkan adalah LoginScreen
      home: const LoginScreen(),
    );
  }
}