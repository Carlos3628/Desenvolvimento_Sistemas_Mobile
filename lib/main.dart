import 'package:flutter/material.dart';
import 'views/login_view.dart';

void main() {
  runApp(const CatalogoJogosApp());
}

class CatalogoJogosApp extends StatelessWidget {
  const CatalogoJogosApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Catálogo de Jogos',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: 'sans-serif',
      ),
      home: const LoginView(),
    );
  }
}