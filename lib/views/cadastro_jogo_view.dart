// Importa a biblioteca para trabalhar com dados binários (Uint8List), usada para guardar a imagem em memória
import 'dart:typed_data';
// Importa os componentes visuais padrão do Flutter (botões, textos, inputs, cores, etc.)
import 'package:flutter/material.dart';
// Importa o pacote externo que abre a galeria do celular ou o explorador de arquivos no PC
import 'package:image_picker/image_picker.dart';
// Importa a nossa classe modelo 'Jogo' para podermos criar ou editar um objeto desse tipo
import '../models/jogo.dart';

// Define a tela como StatefulWidget porque ela muda de estado (textos digitados, dropdowns selecionados, imagem carregada)
class CadastroJogoView extends StatefulWidget {
  // Variável opcional (o '?' indica que pode ser nula). Se vier preenchida, a tela entra em modo de EDIÇÃO; se vier nula, modo de CADASTRO
  final Jogo? jogoParaEditar;

  // Construtor da tela: recebe a chave padrão (super.key) e, opcionalmente, o jogo para editar
  const CadastroJogoView({super.key, this.jogoParaEditar});

  // Cria o objeto de estado (_CadastroJogoScreenState) que vai controlar a lógica e as mudanças dessa tela
  @override
  State<CadastroJogoView> createState() => _CadastroJogoViewState();
}

// Classe que guarda o estado (dados mutáveis) e a interface da tela de cadastro
class _CadastroJogoViewState extends State<CadastroJogoView> {
  // Chave global que identifica o formulário e permite chamar a validação de todos os campos de uma vez
  final _formKey = GlobalKey<FormState>();

  // Controladores que capturam e manipulam o texto digitado em cada campo de texto
  final _nomeController = TextEditingController();
  final _generoController = TextEditingController();
  final _devController = TextEditingController();
  final _classificacaoController = TextEditingController();
  final _dataController = TextEditingController();

  // Variáveis que guardam a opção escolhida nos menus suspensos (dropdowns) e os bytes da imagem (todos podem começar nulos)
  String? _avaliacaoSelecionada;
  String? _plataformaSelecionada;
  Uint8List? _imagemBytes;

  // Listas fixas com as opções disponíveis nos menus suspensos de Avaliação e Plataforma
  final List<String> _opcoesAvaliacao = ['10', '9', '8', '7', '6', '5', '4', '3', '2', '1'];
  final List<String> _opcoesPlataforma = ['PC', 'PS5', 'PS4', 'Xbox Series', 'Switch', 'Mobile'];

  // Método do ciclo de vida do Flutter: roda automaticamente UMA única vez assim que a tela é aberta
  @override
  void initState() {
    super.initState();
    // Verifica se a tela recebeu um jogo para editar (acessado via 'widget.')
    if (widget.jogoParaEditar != null) {
      // Cria um apelido 'j' garantindo ao Dart (com '!') que o objeto não é nulo
      final j = widget.jogoParaEditar!;
      // Preenche os controladores de texto com os dados atuais do jogo
      _nomeController.text = j.nome;
      _generoController.text = j.genero;
      _devController.text = j.desenvolvedora;
      _classificacaoController.text = j.classificacao;
      _dataController.text = j.dataLancamento;
      // Verifica se a avaliação/plataforma salva existe na lista de opções antes de selecionar (evita erro no dropdown)
      _avaliacaoSelecionada = _opcoesAvaliacao.contains(j.avaliacao) ? j.avaliacao : null;
      _plataformaSelecionada = _opcoesPlataforma.contains(j.plataforma) ? j.plataforma : null;
      // Carrega a capa que o jogo já tinha
      _imagemBytes = j.imagemBytes;
    }
  }

  // Método do ciclo de vida: roda quando a tela é fechada, liberando a memória RAM usada pelos controladores de texto
  @override
  void dispose() {
    _nomeController.dispose();
    _generoController.dispose();
    _devController.dispose();
    _classificacaoController.dispose();
    _dataController.dispose();
    super.dispose();
  }

  // Função assíncrona (async) porque precisa esperar o usuário escolher uma imagem no dispositivo
  Future<void> _selecionarImagem() async {
    // Instancia o seletor de imagens
    final picker = ImagePicker();
    // Abre a galeria/arquivos e aguarda (await) o usuário selecionar um arquivo (pode ser nulo se ele cancelar)
    final XFile? arquivo = await picker.pickImage(source: ImageSource.gallery);

    // Se o usuário realmente escolheu uma imagem
    if (arquivo != null) {
      // Lê o arquivo e converte para bytes (Uint8List), o que garante compatibilidade tanto na Web quanto no Mobile
      final bytes = await arquivo.readAsBytes();
      // setState avisa o Flutter para redesenhar a tela agora que a imagem foi carregada
      setState(() {
        _imagemBytes = bytes;
      });
    }
  }

  // Função executada ao clicar no botão Salvar / Atualizar
  void _salvar() {
    // Aciona o 'validator' de todos os campos dentro do Form; só entra no 'if' se todos estiverem preenchidos corretamente
    if (_formKey.currentState!.validate()) {
      // Cria um novo objeto Jogo com os dados digitados (.trim() remove espaços extras no início e no fim)
      final jogoSalvo = Jogo(
        nome: _nomeController.text.trim(),
        genero: _generoController.text.trim(),
        desenvolvedora: _devController.text.trim(),
        avaliacao: _avaliacaoSelecionada!, // '!' garante que não é nulo pois já passou na validação
        plataforma: _plataformaSelecionada!,
        classificacao: _classificacaoController.text.trim(),
        dataLancamento: _dataController.text.trim(),
        imagemBytes: _imagemBytes, // Pode ser nulo, já que a capa é opcional
      );

      // Fecha a tela atual e devolve o objeto 'jogoSalvo' para a tela anterior (ListaJogosScreen)
      Navigator.pop(context, jogoSalvo);
    }
  }

  // Função auxiliar que centraliza o visual dos campos para evitar repetir código (Clean Code)
  InputDecoration _estiloCampo(String hint) {
    return InputDecoration(
      hintText: hint, // Texto de dica exibido quando o campo está vazio
      hintStyle: const TextStyle(color: Colors.white, fontSize: 16), // Estilo do texto de dica
      filled: true, // Ativa a cor de fundo dentro do campo
      fillColor: const Color(0xFF4A4A4A).withOpacity(0.78), // Cinza escuro translúcido
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14), // Espaçamento interno do texto
      // Borda quando o campo está normal (sem foco): retangular e sem linha
      enabledBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide.none,
      ),
      // Borda quando o usuário clica no campo: retangular com contorno roxo
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(
          color: Color(0xFF8A2BE2),
          width: 2.0,
        ),
      ),
      // Borda quando ocorre erro de validação (campo vazio)
      errorBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(
          color: Colors.redAccent,
          width: 1.5,
        ),
      ),
      // Borda quando o campo tem erro E está selecionado
      focusedErrorBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(
          color: Colors.redAccent,
          width: 2.0,
        ),
      ),
      // Estilo da mensagem de erro exibida abaixo do campo
      errorStyle: const TextStyle(
        color: Colors.redAccent,
        fontSize: 12,
      ),
    );
  }

  // Widget auxiliar reutilizável que constrói cada campo de texto retangular obrigatório
  Widget _campoRetangular(String hint, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18), // Espaçamento abaixo de cada campo
      child: TextFormField(
        controller: controller, // Liga o campo ao seu respectivo controlador
        textAlign: TextAlign.center, // Centraliza o texto digitado
        style: const TextStyle(color: Colors.white, fontSize: 16), // Cor e tamanho do texto digitado
        decoration: _estiloCampo(hint), // Aplica o visual padrão definido acima
        // Regra de validação: se estiver nulo ou vazio, retorna a mensagem de erro; se estiver ok, retorna null
        validator: (valor) {
          if (valor == null || valor.trim().isEmpty) {
            return 'Preencha o campo "$hint"';
          }
          return null;
        },
      ),
    );
  }

  // Widget auxiliar reutilizável que constrói os menus suspensos (Dropdowns) obrigatórios
  Widget _dropdownRetangular({
    required String hint, // Texto padrão antes de escolher
    required String? valor, // Valor selecionado atualmente
    required List<String> itens, // Lista de opções
    required ValueChanged<String?> onChanged, // Função chamada quando o usuário escolhe uma opção
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: DropdownButtonFormField<String>(
        value: valor,
        isExpanded: true, // Faz o dropdown ocupar toda a largura disponível
        dropdownColor: const Color(0xFF333333), // Cor de fundo da lista que abre ao clicar
        icon: const Icon(Icons.arrow_drop_down, color: Colors.white70), // Ícone da setinha à direita
        // Reaproveita o estilo padrão ajustando apenas o padding interno
        decoration: _estiloCampo(hint).copyWith(
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        ),
        // Texto exibido quando nada foi selecionado (o padding à esquerda compensa a seta para ficar centralizado)
        hint: Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 24),
            child: Text(
              hint,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ),
        // Converte cada String da lista em um item clicável (DropdownMenuItem) centralizado
        items: itens.map((item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Center(
              child: Text(
                item,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          );
        }).toList(),
        onChanged: onChanged, // Dispara a atualização do estado ao selecionar
        // Validação: impede salvar se nenhuma opção tiver sido escolhida
        validator: (val) {
          if (val == null || val.isEmpty) {
            return 'Selecione uma opção para "$hint"';
          }
          return null;
        },
      ),
    );
  }

  // Método principal que constrói toda a interface visual da tela
  @override
  Widget build(BuildContext context) {
    // Booleano que facilita saber se estamos editando (true) ou cadastrando um novo jogo (false)
    final editando = widget.jogoParaEditar != null;

    // Scaffold é a estrutura base de uma tela no Flutter
    return Scaffold(
      // Stack permite empilhar widgets um em cima do outro (usado aqui para colocar o conteúdo sobre o fundo degradê)
      body: Stack(
        fit: StackFit.expand, // Faz o Stack ocupar 100% da tela
        children: [
          // Camada 1 (Fundo): Container com gradiente radial vermelho escuro para preto
          Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.topCenter,
                radius: 1.2,
                colors: [
                  Color(0xFF4A0707),
                  Color(0xFF120202),
                ],
              ),
            ),
          ),
          // Camada 2 (Conteúdo): SafeArea evita que o conteúdo fique escondido atrás do notch/barra de status do celular
          SafeArea(
            // SingleChildScrollView permite rolar a tela verticalmente (essencial quando o teclado do celular abre)
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
              // Form agrupa todos os campos e conecta eles à _formKey para validação
              child: Form(
                key: _formKey,
                // Column organiza os elementos um embaixo do outro
                child: Column(
                  children: [
                    // Título dinâmico: muda o texto dependendo se está editando ou cadastrando
                    Text(
                      editando ? 'Editar Jogo' : 'Cadastro de Jogos',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    const SizedBox(height: 28), // Espaço vazio vertical

                    // Chamada dos campos de texto usando nossa função auxiliar
                    _campoRetangular('Nome do Jogo', _nomeController),
                    _campoRetangular('Gênero', _generoController),
                    _campoRetangular('Desenvolvedora', _devController),

                    // Dropdown de Avaliação: ao mudar, atualiza a variável dentro do setState
                    _dropdownRetangular(
                      hint: 'Avaliação',
                      valor: _avaliacaoSelecionada,
                      itens: _opcoesAvaliacao,
                      onChanged: (v) => setState(() => _avaliacaoSelecionada = v),
                    ),

                    // Dropdown de Plataforma
                    _dropdownRetangular(
                      hint: 'Plataforma',
                      valor: _plataformaSelecionada,
                      itens: _opcoesPlataforma,
                      onChanged: (v) => setState(() => _plataformaSelecionada = v),
                    ),

                    // Últimos campos de texto obrigatórios
                    _campoRetangular('Classificação Indicativa', _classificacaoController),
                    _campoRetangular('Data de Lançamento', _dataController),

                    // Área clicável para Upload de Imagem (Opcional)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 18),
                      // InkWell transforma o Container em um botão clicável com efeito visual de toque
                      child: InkWell(
                        onTap: _selecionarImagem, // Chama a função que abre a galeria
                        child: Container(
                          // Se já houver imagem, aumenta a altura para 90px para caber a prévia; senão, mantém 48px
                          height: _imagemBytes != null ? 90 : 48,
                          width: double.infinity, // Largura total
                          color: const Color(0xFF4A4A4A).withOpacity(0.78),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          // Operador ternário: mostra a miniatura se _imagemBytes existir, ou o texto de upload se for nulo
                          child: _imagemBytes != null
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // ClipRRect arredonda os cantos da prévia da imagem
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      // Image.memory renderiza a imagem diretamente dos bytes salvos na memória
                                      child: Image.memory(
                                        _imagemBytes!,
                                        width: 64,
                                        height: 64,
                                        fit: BoxFit.cover, // Corta a imagem proporcionalmente para preencher o quadrado
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    const Text(
                                      'Trocar Imagem',
                                      style: TextStyle(color: Colors.white, fontSize: 15),
                                    ),
                                  ],
                                )
                              : const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.upload_file, color: Colors.white70, size: 20),
                                    SizedBox(width: 10),
                                    Text(
                                      'Adicionar Capa (Opcional)',
                                      style: TextStyle(color: Colors.white, fontSize: 16),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Row coloca os botões Cancelar e Salvar/Atualizar lado a lado
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Botão Cancelar
                        SizedBox(
                          width: 130,
                          height: 44,
                          child: OutlinedButton(
                            // Navigator.pop sem argumentos apenas fecha a tela sem salvar nada
                            onPressed: () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              backgroundColor: Colors.black38,
                              foregroundColor: Colors.white70,
                              side: const BorderSide(color: Colors.white38),
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.zero,
                              ),
                            ),
                            child: const Text('Cancelar', style: TextStyle(fontSize: 15)),
                          ),
                        ),
                        const SizedBox(width: 16), // Espaço horizontal entre os botões
                        // Botão Salvar / Atualizar
                        SizedBox(
                          width: 140,
                          height: 44,
                          child: OutlinedButton(
                            onPressed: _salvar, // Chama a função de validação e salvamento
                            style: OutlinedButton.styleFrom(
                              backgroundColor: Colors.black54,
                              foregroundColor: Colors.white,
                              side: const BorderSide(color: Colors.white70),
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.zero,
                              ),
                            ),
                            // Texto dinâmico do botão
                            child: Text(
                              editando ? 'Atualizar' : 'Salvar',
                              style: const TextStyle(fontSize: 16),
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
        ],
      ),
    );
  }
}