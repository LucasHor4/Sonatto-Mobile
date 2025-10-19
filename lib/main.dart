import 'package:flutter/material.dart';
import 'package:mobile_sonatto/produtos.dart';
import 'package:mobile_sonatto/cardProduto.dart';
import 'classes/clProduto.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

void main() {
  runApp(const Main());
}

class Main extends StatefulWidget {
  const Main({super.key});

  @override
  State<Main> createState() => MainState();
}

class MainState extends State<Main> {
  late Future<List<ProdutoClass>> produtos;

  final int limite;

  MainState({
    this.limite = 4, // limite padrão
  });

  @override
  void initState() {
    super.initState();
    produtos = readJson();
  }

  Future<List<ProdutoClass>> readJson() async {
    final String response = await rootBundle.loadString('BD/Produtos.json');
    Iterable data = json.decode(response);
    return List<ProdutoClass>.from(
      data.map((model) => ProdutoClass.fromJson(model)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: FutureBuilder<List<ProdutoClass>>(
          future: produtos,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Text('Erro ao carregar dados'));
            } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              final produtosList = snapshot.data!;
              final exibidos = produtosList.take(limite).toList();
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // dois por linha
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: exibidos.length,
                  itemBuilder: (context, index) {
                    final p = exibidos[index];
                    var navProdMain = produtosList[index].IdProduto - 1;

                    return CardProd(
                      nome: p.NomeProduto,
                      marca: p.MarcaProduto,
                      imagem: p.ImagemURL,
                      preco: p.Preco,
                      navMain: navProdMain,
                    );
                  },
                ),
              );
            } else {
              return const Center(child: Text('Nenhum produto encontrado'));
            }
          },
        ),
      ),
      routes: {
        '/produtospage': (context) => const Produtos(),
      },
    );
  }
}
