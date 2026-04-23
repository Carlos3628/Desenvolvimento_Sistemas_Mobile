import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class Serviceanime {
  final String _baseUrl = 'https://api.jikan.moe/v4/anime';

  // Mudamos o retorno para Future<List<dynamic>> para facilitar na UI
  Future<List<dynamic>> procuraAnime(String? valor) async {
    if (valor == null || valor.isEmpty) return [];

    try {
      // AJUSTE 1: Adicionado o 'q=' na query string
      final url = Uri.parse("$_baseUrl?q=$valor"); 
      
      final response = await http.get(url);
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> dadosDecodificados = json.decode(response.body);
        
        // AJUSTE 2: Retornamos apenas a lista que está dentro de 'data'
        return dadosDecodificados['data'] ?? []; 
      } else {
        throw Exception('Erro ${response.statusCode} : ${response.body}');
      }
    } on SocketException {
      throw Exception('Erro de conexão com a internet');
    } catch (e) {
      rethrow;
    }
  }
}