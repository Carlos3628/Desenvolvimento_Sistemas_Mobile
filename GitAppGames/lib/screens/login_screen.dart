import 'package:flutter/material.dart';
import 'lista_jogos_screen.dart';
import 'cadastro_usuario_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _loginController = TextEditingController();
  final _senhaController = TextEditingController();

  @override
  void dispose() {
    _loginController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  void _entrar() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const ListaJogosScreen()),
    );
  }

  void _irParaCadastroUsuario() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CadastroUsuarioScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Imagem de fundo
          Image.asset(
            'assets/fundo_login.jpg',
            fit: BoxFit.cover,
          ),

          // Leve escurecimento para destacar o card central
          Container(
            color: Colors.black.withOpacity(0.25),
          ),

          // 2. Card Central Preto com Borda Vermelha
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                width: 320,
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 36),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.88),
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(
                    color: const Color(0xFFD32F2F),
                    width: 2.5,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 3. Logo PNG vermelha ampliada
                    SizedBox(
                      width: 130,
                      height: 130,
                      child: Transform.scale(
                        scale: 1.8,
                        child: Image.asset(
                          'assets/logo_serpente.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    const SizedBox(height: 36),

                    // Campo: ID de Login...
                    SizedBox(
                      height: 44,
                      child: TextField(
                        controller: _loginController,
                        style: const TextStyle(color: Colors.black87, fontSize: 14),
                        decoration: InputDecoration(
                          hintText: 'ID de Login...',
                          hintStyle: const TextStyle(color: Colors.black87, fontSize: 14),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Campo: Senha...
                    SizedBox(
                      height: 44,
                      child: TextField(
                        controller: _senhaController,
                        obscureText: true,
                        style: const TextStyle(color: Colors.black87, fontSize: 14),
                        decoration: InputDecoration(
                          hintText: 'Senha...',
                          hintStyle: const TextStyle(color: Colors.black87, fontSize: 14),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Botão Entrar
                    SizedBox(
                      width: 110,
                      height: 38,
                      child: OutlinedButton(
                        onPressed: _entrar,
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Colors.white, width: 1.2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: EdgeInsets.zero,
                        ),
                        child: const Text(
                          'Entrar',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Link Cadastre-se conectado à nova tela
                    GestureDetector(
                      onTap: _irParaCadastroUsuario,
                      child: const Text(
                        'Cadastre-se',
                        style: TextStyle(
                          color: Color(0xFFD4AF37),
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                          decorationColor: Color(0xFFD4AF37),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}