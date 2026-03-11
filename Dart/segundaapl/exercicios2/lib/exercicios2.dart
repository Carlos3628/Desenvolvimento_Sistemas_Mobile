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
}