import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/jogo.dart';

class CadastroJogoScreen extends StatefulWidget {
  final Jogo? jogoParaEditar;

  const CadastroJogoScreen({super.key, this.jogoParaEditar});

  @override
  State<CadastroJogoScreen> createState() => _CadastroJogoScreenState();
}

class _CadastroJogoScreenState extends State<CadastroJogoScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nomeController = TextEditingController();
  final _generoController = TextEditingController();
  final _devController = TextEditingController();
  final _classificacaoController = TextEditingController();
  final _dataController = TextEditingController();

  String? _avaliacaoSelecionada;
  String? _plataformaSelecionada;
  Uint8List? _imagemBytes;

  final List<String> _opcoesAvaliacao = ['10', '9', '8', '7', '6', '5', '4', '3', '2', '1'];
  final List<String> _opcoesPlataforma = ['PC', 'PS5', 'PS4', 'Xbox Series', 'Switch', 'Mobile'];

  @override
  void initState() {
    super.initState();
    // Se veio um jogo para editar, preenche todos os campos automaticamente
    if (widget.jogoParaEditar != null) {
      final j = widget.jogoParaEditar!;
      _nomeController.text = j.nome;
      _generoController.text = j.genero;
      _devController.text = j.desenvolvedora;
      _classificacaoController.text = j.classificacao;
      _dataController.text = j.dataLancamento;
      _avaliacaoSelecionada = _opcoesAvaliacao.contains(j.avaliacao) ? j.avaliacao : null;
      _plataformaSelecionada = _opcoesPlataforma.contains(j.plataforma) ? j.plataforma : null;
      _imagemBytes = j.imagemBytes;
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _generoController.dispose();
    _devController.dispose();
    _classificacaoController.dispose();
    _dataController.dispose();
    super.dispose();
  }

  Future<void> _selecionarImagem() async {
    final picker = ImagePicker();
    final XFile? arquivo = await picker.pickImage(source: ImageSource.gallery);

    if (arquivo != null) {
      final bytes = await arquivo.readAsBytes();
      setState(() {
        _imagemBytes = bytes;
      });
    }
  }

  void _salvar() {
    if (_formKey.currentState!.validate()) {
      final jogoSalvo = Jogo(
        nome: _nomeController.text.trim(),
        genero: _generoController.text.trim(),
        desenvolvedora: _devController.text.trim(),
        avaliacao: _avaliacaoSelecionada!,
        plataforma: _plataformaSelecionada!,
        classificacao: _classificacaoController.text.trim(),
        dataLancamento: _dataController.text.trim(),
        imagemBytes: _imagemBytes,
      );

      Navigator.pop(context, jogoSalvo);
    }
  }

  InputDecoration _estiloCampo(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.white, fontSize: 16),
      filled: true,
      fillColor: const Color(0xFF4A4A4A).withOpacity(0.78),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      enabledBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide.none,
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(
          color: Color(0xFF8A2BE2),
          width: 2.0,
        ),
      ),
      errorBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(
          color: Colors.redAccent,
          width: 1.5,
        ),
      ),
      focusedErrorBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(
          color: Colors.redAccent,
          width: 2.0,
        ),
      ),
      errorStyle: const TextStyle(
        color: Colors.redAccent,
        fontSize: 12,
      ),
    );
  }

  Widget _campoRetangular(String hint, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: TextFormField(
        controller: controller,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.white, fontSize: 16),
        decoration: _estiloCampo(hint),
        validator: (valor) {
          if (valor == null || valor.trim().isEmpty) {
            return 'Preencha o campo "$hint"';
          }
          return null;
        },
      ),
    );
  }

  Widget _dropdownRetangular({
    required String hint,
    required String? valor,
    required List<String> itens,
    required ValueChanged<String?> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: DropdownButtonFormField<String>(
        value: valor,
        isExpanded: true,
        dropdownColor: const Color(0xFF333333),
        icon: const Icon(Icons.arrow_drop_down, color: Colors.white70),
        decoration: _estiloCampo(hint).copyWith(
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        ),
        hint: Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 24),
            child: Text(
              hint,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ),
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
        onChanged: onChanged,
        validator: (val) {
          if (val == null || val.isEmpty) {
            return 'Selecione uma opção para "$hint"';
          }
          return null;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final editando = widget.jogoParaEditar != null;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
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
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Text(
                      editando ? 'Editar Jogo' : 'Cadastro de Jogos',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    const SizedBox(height: 28),

                    _campoRetangular('Nome do Jogo', _nomeController),
                    _campoRetangular('Gênero', _generoController),
                    _campoRetangular('Desenvolvedora', _devController),

                    _dropdownRetangular(
                      hint: 'Avaliação',
                      valor: _avaliacaoSelecionada,
                      itens: _opcoesAvaliacao,
                      onChanged: (v) => setState(() => _avaliacaoSelecionada = v),
                    ),

                    _dropdownRetangular(
                      hint: 'Plataforma',
                      valor: _plataformaSelecionada,
                      itens: _opcoesPlataforma,
                      onChanged: (v) => setState(() => _plataformaSelecionada = v),
                    ),

                    _campoRetangular('Classificação Indicativa', _classificacaoController),
                    _campoRetangular('Data de Lançamento', _dataController),

                    // Upload de Imagem (Opcional)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 18),
                      child: InkWell(
                        onTap: _selecionarImagem,
                        child: Container(
                          height: _imagemBytes != null ? 90 : 48,
                          width: double.infinity,
                          color: const Color(0xFF4A4A4A).withOpacity(0.78),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: _imagemBytes != null
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.memory(
                                        _imagemBytes!,
                                        width: 64,
                                        height: 64,
                                        fit: BoxFit.cover,
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

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 130,
                          height: 44,
                          child: OutlinedButton(
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
                        const SizedBox(width: 16),
                        SizedBox(
                          width: 140,
                          height: 44,
                          child: OutlinedButton(
                            onPressed: _salvar,
                            style: OutlinedButton.styleFrom(
                              backgroundColor: Colors.black54,
                              foregroundColor: Colors.white,
                              side: const BorderSide(color: Colors.white70),
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.zero,
                              ),
                            ),
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