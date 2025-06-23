import 'package:flutter/material.dart';
import 'package:conversor/screens/splash_screen.dart'; // Importa a tela principal

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Conversor de Moedas',
      // O tema foi movido para um arquivo separado para melhor organização
      theme: ThemeData(
        primarySwatch: Colors.amber,
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.amber,
        ).copyWith(secondary: Colors.amberAccent),
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
        inputDecorationTheme: const InputDecorationTheme(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.amber),
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.amberAccent),
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          labelStyle: TextStyle(color: Colors.black54),
          hintStyle: TextStyle(color: Colors.grey),
        ),
      ),
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
