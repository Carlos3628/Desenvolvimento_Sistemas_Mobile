// Importa os componentes visuais do Flutter
import 'package:flutter/material.dart';
// Importa o modelo Jogo
import '../models/jogo.dart';
// Importa o serviço que centraliza o CRUD dos jogos
import '../services/jogo_service.dart';
// Importa a tela de cadastro/edição de jogos
import 'cadastro_jogo_view.dart';

class ListaJogosView extends StatefulWidget {
  const ListaJogosView({super.key});

  @override
  State<ListaJogosView> createState() => _ListaJogosViewState();
}

class _ListaJogosViewState extends State<ListaJogosView> {
  // CREATE: Abre a tela de cadastro e aguarda o retorno de um novo Jogo
  Future<void> _irParaCadastro() async {
    final novoJogo = await Navigator.push<Jogo>(
      context,
      MaterialPageRoute(builder: (context) => const CadastroJogoView()),
    );

    // Se o usuário salvou (não clicou em cancelar), adiciona no JogoService e atualiza a tela
    if (novoJogo != null) {
      setState(() {
        JogoService.adicionar(novoJogo);
      });
    }
  }

  // UPDATE: Abre a mesma tela de cadastro, mas passando o jogo atual para edição
  Future<void> _editarJogo(int index) async {
    final jogoAtualizado = await Navigator.push<Jogo>(
      context,
      MaterialPageRoute(
        builder: (context) => CadastroJogoView(
          jogoParaEditar: JogoService.jogos[index],
        ),
      ),
    );

    // Se o usuário confirmou a edição, atualiza o registro no JogoService e redesenha a lista
    if (jogoAtualizado != null) {
      setState(() {
        JogoService.atualizar(index, jogoAtualizado);
      });
    }
  }

  // DELETE: Exibe um diálogo de confirmação antes de remover o jogo definitivamente
  void _confirmarExclusao(int index) {
    final nomeJogo = JogoService.jogos[index].nome;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF22272B),
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        title: const Text('Excluir Jogo', style: TextStyle(color: Colors.white)),
        content: Text(
          'Tem certeza que deseja excluir "$nomeJogo" do seu catálogo?',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          // Botão Cancelar: apenas fecha o alerta
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar', style: TextStyle(color: Colors.white70)),
          ),
          // Botão Excluir: chama o JogoService.excluir, atualiza a tela e fecha o alerta
          TextButton(
            onPressed: () {
              setState(() {
                JogoService.excluir(index);
              });
              Navigator.pop(ctx);
            },
            child: const Text('Excluir', style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }

  // READ: Abre um modal com todas as informações do jogo clicado + botões Editar e Excluir
  void _abrirDetalhes(int index) {
    final jogo = JogoService.jogos[index];

    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: const Color(0xFF22272B),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: Color(0xFFD32F2F), width: 1.5),
        ),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400), // Limita a largura em telas grandes (Web)
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Cabeçalho do modal com nome do jogo e botão 'X' para fechar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        jogo.nome,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(ctx),
                      icon: const Icon(Icons.close, color: Colors.white70),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Exibe a capa enviada por upload (Image.memory) ou ícone padrão se não houver capa
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: jogo.imagemBytes != null
                      ? Image.memory(
                          jogo.imagemBytes!,
                          width: 140,
                          height: 140,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          width: 140,
                          height: 140,
                          color: Colors.grey.shade800,
                          child: const Icon(
                            Icons.videogame_asset,
                            color: Colors.white54,
                            size: 54,
                          ),
                        ),
                ),
                const SizedBox(height: 20),

                // Linhas de detalhes usando o widget auxiliar _linhaDetalhe
                _linhaDetalhe('Gênero', jogo.genero),
                _linhaDetalhe('Desenvolvedora', jogo.desenvolvedora),
                _linhaDetalhe('Plataforma', jogo.plataforma),
                _linhaDetalhe('Avaliação', '${jogo.avaliacao} / 10'),
                _linhaDetalhe('Classificação', jogo.classificacao),
                _linhaDetalhe('Lançamento', jogo.dataLancamento),

                const SizedBox(height: 24),

                // Botões de ação (Editar e Excluir) lado a lado
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.pop(ctx); // Fecha o modal de detalhes
                          _editarJogo(index); // Abre a tela de edição
                        },
                        icon: const Icon(Icons.edit, size: 18),
                        label: const Text('Editar'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Colors.white70),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.pop(ctx); // Fecha o modal de detalhes
                          _confirmarExclusao(index); // Abre o alerta de confirmação
                        },
                        icon: const Icon(Icons.delete_outline, size: 18),
                        label: const Text('Excluir'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.redAccent,
                          side: const BorderSide(color: Colors.redAccent),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget auxiliar que formata cada linha "Rótulo: Valor" dentro do modal de detalhes
  Widget _linhaDetalhe(String rotulo, String valor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$rotulo:',
            style: const TextStyle(color: Colors.white60, fontSize: 14),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              valor,
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget auxiliar do botão circular "+" para adicionar novos jogos
  Widget _botaoAdicionar() {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 24),
      child: Center(
        child: InkWell(
          onTap: _irParaCadastro,
          borderRadius: BorderRadius.circular(40),
          child: Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF22272B),
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: const Icon(Icons.add, color: Colors.white, size: 36),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Busca a lista atualizada de jogos diretamente do JogoService
    final jogos = JogoService.jogos;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Fundo degradê vermelho escuro
          Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 1.1,
                colors: [
                  Color(0xFF4A0707),
                  Color(0xFF140303),
                ],
              ),
            ),
          ),
          SafeArea(
            // Se a lista estiver vazia, mostra o aviso centralizado + botão '+'; senão, mostra a lista
            child: jogos.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Nenhum jogo cadastrado ainda.',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _botaoAdicionar(),
                      ],
                    ),
                  )
                // ListView.builder constrói os cards sob demanda (melhor performance)
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 28),
                    itemCount: jogos.length + 1, // +1 para renderizar o botão '+' no final da lista
                    itemBuilder: (context, index) {
                      // Quando chega no último índice, exibe o botão '+'
                      if (index == jogos.length) {
                        return _botaoAdicionar();
                      }

                      final jogo = jogos[index];

                      // Card clicável de cada jogo
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Material(
                          color: const Color(0xFF22272B),
                          child: InkWell(
                            onTap: () => _abrirDetalhes(index), // Abre o modal ao clicar no card
                            child: Container(
                              height: 92,
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // Miniatura da capa à esquerda
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: jogo.imagemBytes != null
                                        ? Image.memory(
                                            jogo.imagemBytes!,
                                            width: 72,
                                            height: 72,
                                            fit: BoxFit.cover,
                                          )
                                        : Container(
                                            width: 72,
                                            height: 72,
                                            color: Colors.grey.shade800,
                                            child: const Icon(
                                              Icons.videogame_asset,
                                              color: Colors.white54,
                                            ),
                                          ),
                                  ),
                                  const SizedBox(width: 16),
                                  // Nome e resumo do jogo à direita
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          jogo.nome,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis, // Coloca '...' se o nome for muito grande
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 19,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          'Gênero: ${jogo.genero} - Ano: ${jogo.dataLancamento} - Desenvolvedora: ${jogo.desenvolvedora}',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 11.5,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}