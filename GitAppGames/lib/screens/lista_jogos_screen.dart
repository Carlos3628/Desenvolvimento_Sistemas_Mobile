import 'package:flutter/material.dart';
import '../models/jogo.dart';
import 'cadastro_jogo_screen.dart';

class ListaJogosScreen extends StatefulWidget {
  const ListaJogosScreen({super.key});

  @override
  State<ListaJogosScreen> createState() => _ListaJogosScreenState();
}

class _ListaJogosScreenState extends State<ListaJogosScreen> {
  final List<Jogo> _jogos = [];

  // CREATE
  Future<void> _irParaCadastro() async {
    final novoJogo = await Navigator.push<Jogo>(
      context,
      MaterialPageRoute(builder: (context) => const CadastroJogoScreen()),
    );

    if (novoJogo != null) {
      setState(() {
        _jogos.add(novoJogo);
      });
    }
  }

  // UPDATE
  Future<void> _editarJogo(int index) async {
    final jogoAtualizado = await Navigator.push<Jogo>(
      context,
      MaterialPageRoute(
        builder: (context) => CadastroJogoScreen(jogoParaEditar: _jogos[index]),
      ),
    );

    if (jogoAtualizado != null) {
      setState(() {
        _jogos[index] = jogoAtualizado;
      });
    }
  }

  // DELETE (com confirmação)
  void _confirmarExclusao(int index) {
    final nomeJogo = _jogos[index].nome;

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
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar', style: TextStyle(color: Colors.white70)),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _jogos.removeAt(index);
              });
              Navigator.pop(ctx);
            },
            child: const Text('Excluir', style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }

  // READ (Visualizar detalhes ao clicar no card)
  void _abrirDetalhes(int index) {
    final jogo = _jogos[index];

    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: const Color(0xFF22272B),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: Color(0xFFD32F2F), width: 1.5),
        ),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Cabeçalho com botão de fechar
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

                // Capa do jogo
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

                // Todos os detalhes cadastrados
                _linhaDetalhe('Gênero', jogo.genero),
                _linhaDetalhe('Desenvolvedora', jogo.desenvolvedora),
                _linhaDetalhe('Plataforma', jogo.plataforma),
                _linhaDetalhe('Avaliação', '${jogo.avaliacao} / 10'),
                _linhaDetalhe('Classificação', jogo.classificacao),
                _linhaDetalhe('Lançamento', jogo.dataLancamento),

                const SizedBox(height: 24),

                // Botões de Editar e Excluir
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.pop(ctx); // Fecha o modal
                          _editarJogo(index); // Abre a edição
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
                          Navigator.pop(ctx); // Fecha o modal
                          _confirmarExclusao(index); // Pede confirmação
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
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
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
            child: _jogos.isEmpty
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
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 28),
                    itemCount: _jogos.length + 1,
                    itemBuilder: (context, index) {
                      if (index == _jogos.length) {
                        return _botaoAdicionar();
                      }

                      final jogo = _jogos[index];

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Material(
                          color: const Color(0xFF22272B),
                          child: InkWell(
                            onTap: () => _abrirDetalhes(index),
                            child: Container(
                              height: 92,
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
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
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          jogo.nome,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
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