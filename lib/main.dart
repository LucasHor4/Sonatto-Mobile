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

  int limite = 4;
  late int sLimite;

  List<String> visualisadorDeProdutos = ['Ver mais', 'Ver menos'];
  int visualisadorDeProdutosVar = 0;

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
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'Lançamentos',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.lerp(
                      FontWeight.bold,
                      FontWeight.bold,
                      1,
                    ),
                    fontFamily: 'BowlbyOneSC',
                  ),
                ),
              ),

              const SizedBox(height: 10),

              FutureBuilder<List<ProdutoClass>>(
                future: produtos,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Center(child: Text('Erro ao carregar dados'));
                  } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    final produtosList = snapshot.data!;
                    final exibidos =
                        produtosList.take(produtosList.length).toList();
                    delimitadorDeQuant() {
                      if (limite == 4) {
                        return limite;
                      } else if (limite == 0) {
                        sLimite = produtosList.length;
                        return sLimite;
                      } else {
                        return limite;
                      }
                    }

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GridView.builder(
                        physics:
                            const NeverScrollableScrollPhysics(), // evita conflito
                        shrinkWrap: true,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 8,
                              crossAxisSpacing: 8,
                              childAspectRatio: 0.73,
                            ),
                        itemCount: delimitadorDeQuant(),
                        itemBuilder: (context, index) {
                          final p = exibidos[index];
                          var navProdMain = produtosList[index].IdProduto - 1;

                          return CardProd(
                            nome: p.NomeProduto,
                            marca: p.MarcaProduto,
                            imagem: 'img/${p.ImagemURL}',
                            preco: p.Preco,
                            navMain: navProdMain,
                          );
                        },
                      ),
                    );
                  } else {
                    return const Center(
                      child: Text('Nenhum produto encontrado'),
                    );
                  }
                },
              ),

              IconButton(
                onPressed: () {
                  setState(() {
                    if (limite == 4) {
                      limite = 0;
                      visualisadorDeProdutosVar = 1;
                    } else if (limite == 0) {
                      limite = 4;
                      visualisadorDeProdutosVar = 0;
                    }
                  });
                },
                icon: Column(
                  children: [
                    Text(visualisadorDeProdutos[visualisadorDeProdutosVar]),
                    Divider(
                      color: Colors.grey,
                      thickness: 2,
                      indent: 10,
                      endIndent: 1,
                    ),
                  ],
                ),
                // icon:
              ),

              const SizedBox(height: 40),

              const Padding(
                padding: EdgeInsets.all(16),
                child: Text('Footer da página'),
              ),
            ],
          ),
        ),
      ),
      routes: {'/produtospage': (context) => const Produtos()},
    );
  }
}
