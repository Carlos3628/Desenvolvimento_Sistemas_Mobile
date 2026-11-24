import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CadastroUsuarioScreen extends StatefulWidget {
  const CadastroUsuarioScreen({super.key});

  @override
  State<CadastroUsuarioScreen> createState() => _CadastroUsuarioScreenState();
}

class _CadastroUsuarioScreenState extends State<CadastroUsuarioScreen> {
  final _formKey = GlobalKey<FormState>();

  final _loginController = TextEditingController();
  final _emailController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _senhaController = TextEditingController();
  final _confirmarSenhaController = TextEditingController();

  @override
  void dispose() {
    _loginController.dispose();
    _emailController.dispose();
    _telefoneController.dispose();
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
          Image.asset(
            'assets/fundo_login.jpg',
            fit: BoxFit.cover,
          ),

          Container(
            color: Colors.black.withOpacity(0.25),
          ),

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
                      SizedBox(
                        width: 85,
                        height: 85,
                        child: Transform.scale(
                          scale: 1.8,
                          child: Image.asset(
                            'assets/logo_serpente.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),

                      const Text(
                        'Criar Conta',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // ID de Login (mínimo 3 caracteres)
                      TextFormField(
                        controller: _loginController,
                        style: const TextStyle(color: Colors.black87, fontSize: 14),
                        decoration: _estiloInput('ID de Login...'),
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return 'Informe um ID de Login';
                          }
                          if (val.trim().length < 3) {
                            return 'Mínimo de 3 caracteres';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 14),

                      // E-mail com validação por Regex
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        style: const TextStyle(color: Colors.black87, fontSize: 14),
                        decoration: _estiloInput('E-mail...'),
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return 'Informe seu e-mail';
                          }
                          final emailRegex = RegExp(
                            r'^[\w\.-]+@([\w-]+\.)+[\w-]{2,4}$',
                          );
                          if (!emailRegex.hasMatch(val.trim())) {
                            return 'Digite um e-mail válido';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 14),

                      // Telefone (apenas números, 10 ou 11 dígitos com DDD)
                      TextFormField(
                        controller: _telefoneController,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(11),
                        ],
                        style: const TextStyle(color: Colors.black87, fontSize: 14),
                        decoration: _estiloInput('Telefone (com DDD)...'),
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return 'Informe seu telefone';
                          }
                          if (val.length < 10 || val.length > 11) {
                            return 'O telefone deve ter 10 ou 11 dígitos';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 14),

                      // Senha (mínimo 6 caracteres)
                      TextFormField(
                        controller: _senhaController,
                        obscureText: true,
                        style: const TextStyle(color: Colors.black87, fontSize: 14),
                        decoration: _estiloInput('Senha...'),
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return 'Informe uma senha';
                          }
                          if (val.length < 6) {
                            return 'A senha deve ter no mínimo 6 caracteres';
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
                      const SizedBox(height: 22),

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
                      const SizedBox(height: 16),

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