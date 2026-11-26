// Importa os componentes visuais do Flutter
import 'package:flutter/material.dart';
// Importa utilitários de formatação de entrada (usado para aceitar só números no telefone)
import 'package:flutter/services.dart';
// Importa o modelo Usuario para instanciar o novo usuário
import '../models/usuario.dart';
// Importa o AuthService para salvar o usuário e checar duplicidade
import '../services/auth_service.dart';

class CadastroUsuarioView extends StatefulWidget {
  const CadastroUsuarioView({super.key});

  @override
  State<CadastroUsuarioView> createState() => _CadastroUsuarioViewState();
}

class _CadastroUsuarioViewState extends State<CadastroUsuarioView> {
  // Chave global que controla e dispara a validação de todos os campos do formulário
  final _formKey = GlobalKey<FormState>();

  // Controladores para cada campo de texto da tela
  final _loginController = TextEditingController();
  final _emailController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _senhaController = TextEditingController();
  final _confirmarSenhaController = TextEditingController();

  // Libera os controladores da memória ao sair da tela
  @override
  void dispose() {
    _loginController.dispose();
    _emailController.dispose();
    _telefoneController.dispose();
    _senhaController.dispose();
    _confirmarSenhaController.dispose();
    super.dispose();
  }

  // Função executada ao clicar em "Cadastrar"
  void _cadastrar() {
    // Só continua se TODOS os validators dos campos retornarem null (sem erros)
    if (_formKey.currentState!.validate()) {
      // Cria o objeto Usuario com os dados digitados
      final novoUsuario = Usuario(
        login: _loginController.text.trim(),
        email: _emailController.text.trim(),
        telefone: _telefoneController.text.trim(),
        senha: _senhaController.text,
      );

      // Envia para o AuthService; retorna 'false' se o ID de Login já estiver em uso
      final sucesso = AuthService.cadastrar(novoUsuario);

      if (!sucesso) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Esse ID de Login já está cadastrado!'),
            backgroundColor: Colors.redAccent,
          ),
        );
        return; // Para a execução sem fechar a tela
      }

      // Exibe confirmação verde e volta para a tela de login
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Usuário cadastrado com sucesso! Faça login para entrar.'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context); // Fecha a tela de cadastro e retorna ao Login
    }
  }

  // Método auxiliar que padroniza o visual branco em pílula dos inputs
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
          // Mesmo fundo da tela de login para manter identidade visual
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
                // Form agrupa os TextFormFields para validação conjunta
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Logo da serpente um pouco menor para acomodar os 5 campos
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

                      // Campo: ID de Login (obrigatório, mínimo 3 caracteres)
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

                      // Campo: E-mail (validado com expressão regular - Regex)
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress, // Abre teclado com '@' no celular
                        style: const TextStyle(color: Colors.black87, fontSize: 14),
                        decoration: _estiloInput('E-mail...'),
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return 'Informe seu e-mail';
                          }
                          // Regex que verifica o padrão texto@dominio.extensao
                          final emailRegex = RegExp(
                            r'^[\w\.-]+@([\w-]+\.)+[\w-]{2,4}$',
                          );
                          if (!emailRegex.hasMatch(val.trim())) {
                            return 'Digite um e-mail válido (ex: nome@email.com)';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 14),

                      // Campo: Telefone (só aceita números e exige 10 ou 11 dígitos)
                      TextFormField(
                        controller: _telefoneController,
                        keyboardType: TextInputType.phone, // Abre teclado numérico no celular
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly, // Bloqueia letras e símbolos
                          LengthLimitingTextInputFormatter(11), // Trava em no máximo 11 dígitos
                        ],
                        style: const TextStyle(color: Colors.black87, fontSize: 14),
                        decoration: _estiloInput('Telefone (com DDD)...'),
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return 'Informe seu telefone';
                          }
                          if (val.length < 10 || val.length > 11) {
                            return 'O telefone deve ter 10 ou 11 dígitos (com DDD)';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 14),

                      // Campo: Senha (mínimo 6 caracteres)
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

                      // Campo: Confirmar Senha (verifica se é idêntica à senha acima)
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

                      // Link para voltar ao Login sem cadastrar
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