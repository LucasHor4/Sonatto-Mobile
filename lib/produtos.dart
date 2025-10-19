import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/services.dart';
import 'classes/clProduto.dart';
import 'package:mobile_sonatto/cardProduto.dart';

class Produtos extends StatefulWidget {
  const Produtos({super.key});

  @override
  State<Produtos> createState() => ProdutosState();
}

class ProdutosState extends State<Produtos> {
  late Future<List<ProdutoClass>> produtos;

  Future<List<ProdutoClass>> readJson() async {
    final String response = await rootBundle.loadString('BD/Produtos.json');
    Iterable data = json.decode(response);
    return List<ProdutoClass>.from(
      data.map((model) => ProdutoClass.fromJson(model)),
    );
  }

  final List<String> imagens = [
    'img/tela-preta.png',
    'img/tela-preta.png',
    'img/tela-preta.png',
    'img/tela-preta.png',
    'img/tela-preta.png',
  ];

  int avaliacao = 1; // controla a nota (1 a 5), enquanto não vem do BD
  int coresDisponiveis = 4; // controla as cores disponíveis
  int _indiceAtual = 0;
  List<Color> CoresProduto = [
    Colors.black,
    Colors.red,
    Colors.blue,
    Colors.purple,
  ];

  final CarouselSliderController _controller = CarouselSliderController();

  @override
  void initState() {
    super.initState();
    produtos = readJson(); // Inicializa o Future para carregar os dados
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: Colors.white,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Image.asset('img/sonatto_logo.png', width: 200, height: 400),
        ),
        body: Center(
          child: ListView(
            children: [
              // Carousel para passar as imagens
              CarouselSlider.builder(
                options: CarouselOptions(
                  height: 500,
                  enlargeCenterPage: false,
                  viewportFraction: 1,
                  autoPlay: true,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _indiceAtual = index;
                    });
                  },
                ),
                itemCount: imagens.length,
                carouselController: _controller,
                itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) =>
                    Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
                      color: Colors.blueGrey,
                    ),
                  ),
                  child: Stack(
                    children: [
                      Image.asset(
                        imagens[itemIndex].toString(),
                        width: double.infinity,
                      ),
                      Positioned(
                        top: 8,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${itemIndex + 1}/${imagens.length}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: imagens.asMap().entries.map((entry) {
                  return GestureDetector(
                    onTap: () => _controller.animateToPage(entry.key),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: _indiceAtual == entry.key ? 12 : 8,
                      height: _indiceAtual == entry.key ? 12 : 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _indiceAtual == entry.key
                            ? Colors.blueAccent
                            : Colors.grey,
                      ),
                    ),
                  );
                }).toList(),
              ),
              const Text("Avaliação do produto:", style: TextStyle(fontSize: 25)),
              Row(
                children: [
                  // Estrelas com borda
                  Row(
                    children: List.generate(5, (index) {
                      return Stack(
                        alignment: Alignment.center,
                        children: [
                          Icon(
                            Icons.star,
                            color: index < avaliacao
                                ? Colors.yellow
                                : Colors.grey,
                            size: 42,
                          ),
                          const Icon(
                            Icons.star_border,
                            color: Colors.black,
                            size: 42,
                          ),
                        ],
                      );
                    }),
                  ),
                ],
              ),
              const Text('Descrição:', style: TextStyle(fontSize: 40)),
              // Usando o FutureBuilder para esperar os dados
              FutureBuilder<List<ProdutoClass>>(
                future: produtos,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Center(child: Text('Erro ao carregar dados'));
                  } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    ProdutoClass produto = snapshot.data![navProd]; // aqui defino o produto a ser pego
                    return Container(
                      margin: EdgeInsets.only(
                        left: 50,
                        right: 50,
                      ),
                      padding: const EdgeInsets.all(18),
                      width: 400,
                      height: 300,
                      decoration: const BoxDecoration(color: Color(0xFFD9D9D9)),
                      child: Text(
                        produto.Descricao,
                        style: const TextStyle(fontSize: 20),
                      ),
                    );
                  } else {
                    return const Center(child: Text('Nenhum produto encontrado'));
                  }
                },
              ),
            ],
          ),
        ),
        backgroundColor: Colors.white,
      ),
    );
  }
}