import 'package:flutter/material.dart';
import 'package:invertexto/service/invertexto_service.dart';

class ValidaEmail extends StatefulWidget {
  const ValidaEmail({super.key});

  @override
  State<ValidaEmail> createState() => _ValidaEmail();
}

class _ValidaEmail extends State<ValidaEmail> {
  String? campo;
  String? resultado;
  final apiService = Invertextoservice();

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(
        backgroundColor: Colors.black,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/imgs/logo.png',
              fit: BoxFit.contain,
              height: 40,
            ),
          ],
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back, color: Colors.white),
        ),
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            TextField(
              decoration: InputDecoration(
                labelText: "Digite um email",
                labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder()
              ),
              keyboardType: TextInputType.number,
              style: TextStyle(color: Colors.white, fontSize: 18),
              onSubmitted: ((value){
                setState(() {
                  campo = value;
                });
              }),
            ),
            Expanded(
              child: FutureBuilder(
                future: apiService.validaEmail(campo),
                builder: (context, snapshot){
                  switch(snapshot.connectionState){
                    case ConnectionState.waiting:
                    case ConnectionState.none:
                      return Container(
                        width: 200,
                        height: 200,
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          strokeWidth: 5.0,
                        ),
                      );
                    default:
                      if(snapshot.hasError){
                        return Container();
                      }else{
                        return exibeResultado(context, snapshot);
                      }
                  }
                }))
          ]),
      ),
    );
  }

  Widget exibeResultado(BuildContext context, AsyncSnapshot snapshot){
  var dados = snapshot.data;

  return Padding(
    padding: const EdgeInsets.only(top: 10.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start, // Alinha o texto à esquerda
      children: [
        _buildLinhaResultado("E-mail:", dados["email"]),
        _buildLinhaResultado("Formato válido:", dados["valid_format"] ? "Sim" : "Não"),
        _buildLinhaResultado("MX Válido:", dados["valid_mx"] ? "Sim" : "Não"),
        _buildLinhaResultado("Descartável:", dados["disposable"] ? "Sim" : "Não"),
      ],
    ),
  );
}

Widget _buildLinhaResultado(String label, dynamic valor) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 2.0),
    child: Text(
      "$label $valor",
      style: const TextStyle(color: Colors.white, fontSize: 16),
    ),
  );
}
}