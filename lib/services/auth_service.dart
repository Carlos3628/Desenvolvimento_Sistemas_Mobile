// Importa a classe modelo 'Usuario' para podermos armazenar e consultar objetos desse tipo
import '../models/usuario.dart';

// Classe de serviço que centraliza toda a lógica de autenticação e cadastro de usuários
class AuthService {
  // Lista privada ('_') e estática ('static') que guarda os usuários na memória enquanto o app estiver aberto
  // Por ser 'static', os dados são compartilhados entre todas as telas sem precisar instanciar a classe
  static final List<Usuario> _usuarios = [];

  // Método que verifica se já existe algum usuário cadastrado com o mesmo ID de Login
  static bool existeLogin(String login) {
    // O método '.any()' percorre a lista e retorna 'true' assim que encontrar um item que satisfaça a condição
    return _usuarios.any(
      // Compara o login salvo com o digitado em letras minúsculas (.toLowerCase) e sem espaços extras (.trim)
      (u) => u.login.toLowerCase() == login.trim().toLowerCase(),
    );
  }

  // Método que tenta cadastrar um novo usuário e retorna 'true' (sucesso) ou 'false' (login já existe)
  static bool cadastrar(Usuario usuario) {
    // Antes de salvar, verifica se o login já está em uso
    if (existeLogin(usuario.login)) {
      // Se já existir, bloqueia o cadastro retornando 'false'
      return false;
    }
    // Se não existir, adiciona o novo usuário na lista em memória
    _usuarios.add(usuario);
    // Retorna 'true' confirmando que o cadastro foi concluído
    return true;
  }

  // Método que valida se o ID de Login e a Senha informados na tela de login correspondem a um usuário registrado
  static bool autenticar(String login, String senha) {
    // Retorna 'true' apenas se existir um usuário na lista com o mesmo login (ignorando maiúsculas) E a mesma senha exata
    return _usuarios.any(
      (u) =>
          u.login.toLowerCase() == login.trim().toLowerCase() &&
          u.senha == senha,
    );
  }
}