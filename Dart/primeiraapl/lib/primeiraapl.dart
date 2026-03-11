String Exer1() {
  int A = 5;
  int B = 8;
  int C = 7;
  String mensagem = (A + B) < C ? "Soma menor que $C." : "Soma maior que $C.";
  return mensagem;
}

String Exer2(){
  int A = 10;
  String mensagem = A%2 == 0 ? "$A é par." : "$A é ímpar";
  return mensagem;
}

int Exer3(){
  int A = 3;
  int B = 6;
  int C = A == B ? A + B : A * B;
  return C;
}

void Exer4(){
  int A = 3;
  int B = 6;
  int C = 9;
  List<int> numeros = [A, B, C];
  numeros.sort((x,y) => y.compareTo(x));
  print(numeros);
}

void Exer5(){
  for(int i = 1; i <= 500; i++){
    if(i%3 == 0){
      print(i);
    }
  }
}

void Exer6(){
  for(int i = 100; i <= 200; i++){
    if(i%2 != 0){
      print(i);
    }
  }
}

void Exer7(){
  int N = 3;
  for(int i = 0; i <= 10; i++){
    int tabuada = i * N;
    print("$i x $N = $tabuada");
  }
}

void Exer8(){
  int A = 5;
  int B = A-1;
  int produto = A * B;
  for(int i = B-1; i > 0; i--){
    produto = produto * i;
  }
  print(produto);
}