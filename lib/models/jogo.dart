import 'dart:typed_data';

class Jogo {
  final String nome;
  final String genero;
  final String desenvolvedora;
  final String avaliacao;
  final String plataforma;
  final String classificacao;
  final String dataLancamento;
  final Uint8List? imagemBytes;

  Jogo({
    required this.nome,
    required this.genero,
    required this.desenvolvedora,
    required this.avaliacao,
    required this.plataforma,
    required this.classificacao,
    required this.dataLancamento,
    this.imagemBytes,
  });
}