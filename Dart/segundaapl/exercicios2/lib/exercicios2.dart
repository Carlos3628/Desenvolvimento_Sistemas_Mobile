void Exers(){
  List<String> frutas = ["Banana", "Maca", "Manga", "Goiaba", "Melancia"];
  print(frutas);
  print(frutas[2]);
  frutas.add("Laranja");
  print(frutas);
  frutas.remove("Maca");
  print(frutas);

  for(int i = 0; i < frutas.length; i++){
    print(frutas[i].toUpperCase());
  }

  frutas.forEach((fruta) {print(fruta.toLowerCase());});

  List<String> frutasComA = frutas.where((fruta) { return fruta.toLowerCase().startsWith('a');}).toList();
  print(frutasComA);

  Map<double, String> precosFrutas = {
    5.32 : frutas[0], 2.56 : frutas[1], 7.89 : frutas[2], 3.54 : frutas[3], 9.25 : frutas[4]
  };
  print(precosFrutas);

  print("\n--- Lista de Preços ---");
  precosFrutas.forEach((preco, nome) {
    print("Fruta: $nome | Preço: R\$ ${preco.toStringAsFixed(2)}");
  });

  var filtrarPares = (List<int> numeros) {
    return numeros.where((n) => n % 2 == 0).toList();
  };

  List<int> listaNumeros = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
  print("\nNúmeros pares: ${filtrarPares(listaNumeros)}");

  enum Pessoa {
  ana("Ana", 25),
  joao("João", 17),
  caio("Caio", 12),
  beatriz("Beatriz", 19);

  final String nome;
  final int idade;
    
  const Pessoa(this.nome, this.idade);
}

void verificarMaioridade() {
  print("\n--- Pessoas Maiores de Idade ---");
  
  for (var pessoa in Pessoa.values) {
    if (pessoa.idade >= 18) {
      print("${pessoa.nome} tem ${pessoa.idade} anos.");
    }
  }
}
}
