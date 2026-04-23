import 'package:animeapi/service/service_anime.dart';
import 'package:flutter/material.dart';

class ProcuraAnime extends StatefulWidget {
  const ProcuraAnime({super.key});

  @override
  State<ProcuraAnime> createState() => _ProcuraAnimeState();
}

class _ProcuraAnimeState extends State<ProcuraAnime> {
  String? campo;
  final apiService = Serviceanime();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/imgs/MyAnimeList.png',
              fit: BoxFit.contain,
              height: 40,
            ),
          ],
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            TextField(
              decoration: const InputDecoration(
                labelText: "Pesquisar Anime", // Ajustado de email para anime
                labelStyle: TextStyle(color: Colors.white),
                prefixIcon: Icon(Icons.search, color: Colors.white), // Lupa visual
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.text, // Ajustado de number para text
              style: const TextStyle(color: Colors.white, fontSize: 18),
              onSubmitted: (value) {
                setState(() {
                  campo = value;
                });
              },
            ),
            Expanded(
              child: FutureBuilder(
                future: (campo == null || campo!.isEmpty) 
                    ? Future.value([]) 
                    : apiService.procuraAnime(campo!),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      );
                    case ConnectionState.none:
                      return const Center(child: Text("Aguardando...", style: TextStyle(color: Colors.white)));
                    default:
                      if (snapshot.hasError) {
                        return const Center(child: Text("Erro ao carregar", style: TextStyle(color: Colors.red)));
                      } else {
                        return exibeResultado(context, snapshot);
                      }
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget exibeResultado(BuildContext context, AsyncSnapshot snapshot) {
  // Extrai a lista de animes dos dados do snapshot; se for nulo, inicializa com uma lista vazia.
  final List animes = snapshot.data ?? [];

  // Verifica se a lista está vazia (caso a busca não retorne nada).
  if (animes.isEmpty) {
    return const Center( // Centraliza o aviso na tela.
      child: Text(
        "Nenhum anime encontrado.",
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  // Retorna uma grade (grid) rolável de itens.
  return GridView.builder(
    padding: const EdgeInsets.only(top: 20), // Adiciona um espaçamento de 20px no topo da lista.
    
    // Define a configuração da grade (2 colunas, espaçamento e proporção).
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,         // Define que teremos 2 itens por linha.
      mainAxisSpacing: 10,       // Espaçamento vertical entre os cards.
      crossAxisSpacing: 10,      // Espaçamento horizontal entre os cards.
      childAspectRatio: 0.7,     // Define a proporção (largura/altura). (estilo poster).
    ),
    
    itemCount: animes.length,    // Informa ao Flutter quantos itens devem ser renderizados.
    
    // Construtor individual para cada item da lista.
    itemBuilder: (context, index) {
      final anime = animes[index]; // Obtém os dados do anime específico para este índice.
      
      return ClipRRect( // Corta as bordas.
        borderRadius: BorderRadius.circular(8), // Deixa os cantos arredondados com raio de 8px.
        
        child: Stack( // Sobrepõe elementos (imagem no fundo, texto por cima).
          children: [
            // Ocupa todo o espaço disponível no card com a imagem.
            Positioned.fill(
              child: Image.network(
                anime['images']['jpg']['large_image_url'], // URL da imagem vinda da API.
                fit: BoxFit.cover, // Faz a imagem preencher o espaço sem distorcer, cortando as sobras.
              ),
            ),
            
            // Posiciona o título na parte inferior do card.
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(8), // Espaçamento interno do texto.
                decoration: const BoxDecoration(
                  // Cria um degradê preto para facilitar a leitura do título sobre a imagem.
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,    // O degradê começa transparente no topo...
                    end: Alignment.bottomCenter, // ...e termina preto na base.
                    colors: [Colors.transparent, Colors.black87],
                  ),
                ),
                child: Text(
                  anime['title'], // Exibe o título do anime.
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2, // Limita o título a no máximo 2 linhas.
                  overflow: TextOverflow.ellipsis, // Se for maior que 2 linhas, adiciona "..."
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}
}