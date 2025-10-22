import 'package:flutter/material.dart';
import 'package:mobile_sonatto/produtos.dart';
import 'package:mobile_sonatto/cardProduto.dart';
import 'classes/clProduto.dart';
import 'package:google_fonts/google_fonts.dart';
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

  int limite1 = 4;
  int limite2 = 4;

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
    print('JSON carregado: $response');
    return List<ProdutoClass>.from(
      data.map((model) => ProdutoClass.fromJson(model)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: FutureBuilder<List<ProdutoClass>>(
            future: produtos,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                // mostra erro explícito pra ajudar debug
                return Center(
                  child: Text('Erro ao carregar dados: ${snapshot.error}'),
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('Nenhum produto encontrado'));
              }

              final produtosList = snapshot.data!;

              // Seções com limites
              final lancamentos =
                  produtosList.toList(); // aqui você poderia filtrar se quiser
              final maisVendidos = produtosList.toList();
              final randomizados = (produtosList.toList()..shuffle());

              return CustomScrollView(
                slivers: [
                  // --- cabeçalho simples de "Lançamentos"
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Center(
                        child: Text(
                          'Lançamentos',
                          style: GoogleFonts.anton(
                            fontSize: 40,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // --- Grid dos Lançamentos (limite1)
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 8,
                    ),
                    sliver: SliverGrid(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final p = lancamentos[index];
                        return CardProd(
                          nome: p.NomeProduto,
                          marca: p.MarcaProduto,
                          imagem: 'img/${p.Imagens}',
                          preco: p.Preco,
                          navMain: p.IdProduto - 1,
                        );
                      }, childCount: limite1.clamp(0, lancamentos.length)),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 8,
                            crossAxisSpacing: 8,
                            childAspectRatio: 0.73,
                          ),
                    ),
                  ),

                  // botão ver mais/menos para Lançamentos
                  SliverToBoxAdapter(
                    child: Center(
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            if (limite1 == 4) {
                              limite1 = 8;
                            } else {
                              limite1 = 4;
                            }
                          });
                        },
                        child: Column(
                          children: [
                            Text(
                              limite1 == 4 ? 'Ver mais' : 'Ver menos',
                              style: TextStyle(color: Colors.grey),
                            ),
                            Divider(
                              color: Colors.grey,
                              thickness: 2,
                              indent: 10,
                              endIndent: 1,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // --- cabeçalho do "Mais vendidos"
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Center(
                        child: Text(
                          'Mais vendidos',
                          style: GoogleFonts.anton(
                            fontSize: 40,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // --- Grid dos Mais Vendidos (limite2)
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 8,
                    ),
                    sliver: SliverGrid(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final p = maisVendidos[index];
                        return CardProd(
                          nome: p.NomeProduto,
                          marca: p.MarcaProduto,
                          imagem: 'img/${p.Imagens.firstOrNull}',
                          preco: p.Preco,
                          navMain: p.IdProduto - 1,
                        );
                      }, childCount: limite2.clamp(0, maisVendidos.length)),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 8,
                            crossAxisSpacing: 8,
                            childAspectRatio: 0.73,
                          ),
                    ),
                  ),

                  SliverToBoxAdapter(
                    child: Center(
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            if (limite2 == 4) {
                              limite2 = 8;
                            } else {
                              limite2 = 4;
                            }
                          });
                        },
                        child: Column(
                          children: [
                            Text(
                              limite2 == 4 ? 'Ver mais' : 'Ver menos',
                              style: TextStyle(color: Colors.grey),
                            ),
                            Divider(
                              color: Colors.grey,
                              thickness: 2,
                              indent: 10,
                              endIndent: 1,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // --- cabeçalho do "Encontre seu estilo"
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Center(
                        child: Text(
                          'Encontre seu estilo',
                          style: GoogleFonts.anton(
                            fontSize: 40,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // --- Grid randomizado
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 8,
                    ),
                    sliver: SliverGrid(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final p = randomizados[index];
                          return CardProd(
                            nome: p.NomeProduto,
                            marca: p.MarcaProduto,
                            imagem: 'img/${p.Imagens}',
                            preco: p.Preco,
                            navMain: p.IdProduto - 1,
                          );
                        },
                        childCount:
                            randomizados
                                .length, // ou limite se quiser limitar aqui
                      ),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 8,
                            crossAxisSpacing: 8,
                            childAspectRatio: 0.73,
                          ),
                    ),
                  ),

                  // espaço final
                  SliverToBoxAdapter(child: SizedBox(height: 80)),
                ],
              );
            },
          ),
        ),
        bottomNavigationBar: Container(
          height: 60,
          color: Colors.blue,
          alignment: Alignment.center,
          child: const Text('Footer', style: TextStyle(color: Colors.white)),
        ),
      ),
      routes: {'/produtospage': (context) => const Produtos()},
    );
  }
}
