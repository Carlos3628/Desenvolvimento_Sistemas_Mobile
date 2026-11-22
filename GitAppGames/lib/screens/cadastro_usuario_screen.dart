import 'package:flutter/material.dart';

class CadastroUsuarioScreen extends StatefulWidget {
  const CadastroUsuarioScreen({super.key});

  @override
  State<CadastroUsuarioScreen> createState() => _CadastroUsuarioScreenState();
}

class _CadastroUsuarioScreenState extends State<CadastroUsuarioScreen> {
  final _formKey = GlobalKey<FormState>();

  final _loginController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _confirmarSenhaController = TextEditingController();

  @override
  void dispose() {
    _loginController.dispose();
    _emailController.dispose();
    _senhaController.dispose();
    _confirmarSenhaController.dispose();
    super.dispose();
  }

  void _cadastrar() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Usuário cadastrado com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    }
  }

  InputDecoration _estiloInput(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.black87, fontSize: 14),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide.none,
      ),
      errorStyle: const TextStyle(
        color: Colors.redAccent,
        fontSize: 11.5,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Mesmo fundo da tela de login
          Image.asset(
            'assets/fundo_login.jpg',
            fit: BoxFit.cover,
          ),

          Container(
            color: Colors.black.withOpacity(0.25),
          ),

          // Card Central Preto com Borda Vermelha
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Container(
                width: 320,
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 30),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.88),
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(
                    color: const Color(0xFFD32F2F),
                    width: 2.5,
                  ),
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Logo da serpente um pouco mais compacta para caber os 4 campos
                      SizedBox(
                        width: 90,
                        height: 90,
                        child: Transform.scale(
                          scale: 1.8,
                          child: Image.asset(
                            'assets/logo_serpente.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      const Text(
                        'Criar Conta',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // ID de Login
                      TextFormField(
                        controller: _loginController,
                        style: const TextStyle(color: Colors.black87, fontSize: 14),
                        decoration: _estiloInput('ID de Login...'),
                        validator: (val) =>
                            val == null || val.trim().isEmpty ? 'Informe um ID de Login' : null,
                      ),
                      const SizedBox(height: 14),

                      // E-mail
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        style: const TextStyle(color: Colors.black87, fontSize: 14),
                        decoration: _estiloInput('E-mail...'),
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return 'Informe seu e-mail';
                          }
                          if (!val.contains('@')) {
                            return 'E-mail inválido';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 14),

                      // Senha
                      TextFormField(
                        controller: _senhaController,
                        obscureText: true,
                        style: const TextStyle(color: Colors.black87, fontSize: 14),
                        decoration: _estiloInput('Senha...'),
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return 'Informe uma senha';
                          }
                          if (val.length < 4) {
                            return 'Mínimo de 4 caracteres';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 14),

                      // Confirmar Senha
                      TextFormField(
                        controller: _confirmarSenhaController,
                        obscureText: true,
                        style: const TextStyle(color: Colors.black87, fontSize: 14),
                        decoration: _estiloInput('Confirmar Senha...'),
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return 'Confirme sua senha';
                          }
                          if (val != _senhaController.text) {
                            return 'As senhas não coincidem';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),

                      // Botão Cadastrar
                      SizedBox(
                        width: 130,
                        height: 38,
                        child: OutlinedButton(
                          onPressed: _cadastrar,
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
                            'Cadastrar',
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),

                      // Link para voltar ao Login
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Text(
                          'Já tem conta? Entrar',
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
          ),
        ],
      ),
    );
  }
}