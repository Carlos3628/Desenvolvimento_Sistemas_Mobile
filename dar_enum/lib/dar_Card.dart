import 'enum.dart';

class Carta {
  final Naipe naipe;
  final Valor valor;

  Carta(this.naipe, this.valor);

  @override
  String toString() {
    return "${_getNomeValor(valor)} de ${_getNomeNaipe(naipe)}";
  }

  String _getNomeNaipe(Naipe n) {
    switch (n) {
      case Naipe.copas: return "Copas";
      case Naipe.ouro: return "Ouros";
      case Naipe.espada: return "Espadas";
      case Naipe.paus: return "Paus";
    }
  }

  String _getNomeValor(Valor v) {
    switch (v) {
      case Valor.as: return "Ás";
      case Valor.dois: return "2";
      default: return v.name; 
    }
  }
}