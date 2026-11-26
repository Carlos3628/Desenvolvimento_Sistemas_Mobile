// Importa a classe modelo 'Jogo' para manipular a lista de jogos
import '../models/jogo.dart';

// Classe de serviço que gerencia todas as operações de CRUD dos jogos
class JogoService {
  // Lista privada e estática que funciona como o "banco de dados" em memória do catálogo
  static final List<Jogo> _jogos = [];

  // READ (Leitura): getter que devolve a lista de jogos de forma segura (somente leitura) para as telas exibirem
  static List<Jogo> get jogos => List.unmodifiable(_jogos);

  // CREATE (Criação): recebe um novo objeto Jogo e adiciona ao final da lista
  static void adicionar(Jogo jogo) {
    _jogos.add(jogo);
  }

  // UPDATE (Atualização): substitui o jogo na posição 'index' pelos novos dados editados
  static void atualizar(int index, Jogo jogoAtualizado) {
    // Garante que o índice existe na lista antes de tentar alterar (evita erro de índice inválido)
    if (index >= 0 && index < _jogos.length) {
      _jogos[index] = jogoAtualizado;
    }
  }

  // DELETE (Exclusão): remove o jogo da lista pela sua posição ('index')
  static void excluir(int index) {
    // Verifica se o índice é válido antes de remover
    if (index >= 0 && index < _jogos.length) {
      _jogos.removeAt(index);
    }
  }
}