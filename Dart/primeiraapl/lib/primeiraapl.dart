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