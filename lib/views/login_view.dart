// Importa os componentes visuais padrão do Flutter
import 'package:flutter/material.dart';
// Importa o serviço de autenticação para validar o login e a senha
import '../services/auth_service.dart';
// Importa a tela de listagem de jogos (destino após login bem-sucedido)
import 'lista_jogos_view.dart';
// Importa a tela de cadastro de usuário (destino ao clicar em "Cadastre-se")
import 'cadastro_usuario_view.dart';

// Tela de Login como StatefulWidget porque gerencia controladores de texto
class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  // Controladores que capturam o que o usuário digita nos campos de login e senha
  final _loginController = TextEditingController();
  final _senhaController = TextEditingController();

  // Libera a memória RAM dos controladores quando a tela é destruída
  @override
  void dispose() {
    _loginController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  // Função executada ao clicar no botão "Entrar"
  void _entrar() {
    // Captura o login removendo espaços extras e a senha exata
    final login = _loginController.text.trim();
    final senha = _senhaController.text;

    // Verifica se algum dos dois campos está vazio
    if (login.isEmpty || senha.isEmpty) {
      // Exibe um aviso (SnackBar) na parte inferior da tela
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Preencha o ID de Login e a Senha.'),
          backgroundColor: Colors.orange,
        ),
      );
      return; // Interrompe a execução da função
    }

    // Consulta o AuthService para verificar se o login e a senha existem na lista de usuários
    if (AuthService.autenticar(login, senha)) {
      // pushReplacement substitui a tela de login pela lista de jogos (impede voltar pro login no botão "voltar")
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ListaJogosView()),
      );
    } else {
      // Se as credenciais não baterem, exibe uma mensagem de erro em vermelho
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('ID de Login ou senha incorretos!'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  // Função executada ao clicar no link "Cadastre-se"
  void _irParaCadastroUsuario() {
    // Navigator.push empilha a tela de cadastro por cima da tela de login (permite voltar)
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CadastroUsuarioView()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Stack empilha o fundo, a película escura e o card central um sobre o outro
      body: Stack(
        fit: StackFit.expand, // Ocupa 100% da largura e altura da tela
        children: [
          // Camada 1: Imagem de fundo salva na pasta assets/
          Image.asset(
            'assets/fundo_login.jpg',
            fit: BoxFit.cover, // Cobre toda a tela sem distorcer a imagem
          ),
          // Camada 2: Película preta com 25% de opacidade para melhorar o contraste do card
          Container(
            color: Colors.black.withOpacity(0.25),
          ),
          // Camada 3: Card centralizado
          Center(
            // Permite rolar a tela caso o teclado do celular cubra os campos
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                width: 320, // Largura fixa do card de login
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 36),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.88), // Fundo preto quase opaco
                  borderRadius: BorderRadius.circular(32), // Cantos bem arredondados
                  border: Border.all(
                    color: const Color(0xFFD32F2F), // Borda vermelha
                    width: 2.5,
                  ),
                ),
                // Organiza logo, inputs e botões em coluna vertical
                child: Column(
                  mainAxisSize: MainAxisSize.min, // Ocupa apenas a altura necessária
                  children: [
                    // Caixa da logo da serpente ampliada com Transform.scale
                    SizedBox(
                      width: 130,
                      height: 130,
                      child: Transform.scale(
                        scale: 1.8, // Dá zoom no PNG sem aumentar o espaço ocupado no layout
                        child: Image.asset(
                          'assets/logo_serpente.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    const SizedBox(height: 36), // Espaçamento vertical

                    // Campo de texto: ID de Login
                    SizedBox(
                      height: 44,
                      child: TextField(
                        controller: _loginController, // Liga ao controlador de login
                        style: const TextStyle(color: Colors.black87, fontSize: 14),
                        decoration: InputDecoration(
                          hintText: 'ID de Login...',
                          hintStyle: const TextStyle(color: Colors.black87, fontSize: 14),
                          filled: true,
                          fillColor: Colors.white, // Fundo branco em formato de pílula
                          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Campo de texto: Senha
                    SizedBox(
                      height: 44,
                      child: TextField(
                        controller: _senhaController, // Liga ao controlador de senha
                        obscureText: true, // Esconde os caracteres digitados com bolinhas
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

                    // Botão "Entrar" com fundo preto e borda branca
                    SizedBox(
                      width: 110,
                      height: 38,
                      child: OutlinedButton(
                        onPressed: _entrar, // Chama a função de autenticação
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

                    // GestureDetector torna o texto "Cadastre-se" clicável
                    GestureDetector(
                      onTap: _irParaCadastroUsuario,
                      child: const Text(
                        'Cadastre-se',
                        style: TextStyle(
                          color: Color(0xFFD4AF37), // Cor dourada/amarela
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline, // Sublinhado
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