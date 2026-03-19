import '../lib/enum.dart';
import '../lib/dar_Card.dart';
import '../lib/baralho.dart';

void main() {
  Baralho meuBaralho = Baralho();

  print("--- Iniciando o Jogo ---");
  print("Cartas no baralho: ${meuBaralho.cartasRestantes()}");

  print("Embaralhando...");
  meuBaralho.embaralhar();

  print("\nSua mão inicial:");
  for (int i = 1; i <= 5; i++) {
    Carta? cartaComprada = meuBaralho.comprar();
    
    if (cartaComprada != null) {
      print("Carta $i: $cartaComprada");
    } else {
      print("O baralho está vazio!");
    }
  }

  print("\n--- Status Final ---");
  print("Cartas restantes no baralho: ${meuBaralho.cartasRestantes()}");
}
