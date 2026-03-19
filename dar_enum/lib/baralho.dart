import 'dar_Card.dart';
import 'enum.dart';

class Baralho {
  final List<Carta> _cartas = [];

  Baralho() {
    for (var naipe in Naipe.values) {
      for (var valor in Valor.values) {
        _cartas.add(Carta(naipe, valor));
      }
    }
  }

  void embaralhar() {
    _cartas.shuffle();
  }

  Carta? comprar() {
    if (_cartas.isNotEmpty) {
      return _cartas.removeLast();
    }
    return null;
  }

  int cartasRestantes() {
    return _cartas.length;
  }
}