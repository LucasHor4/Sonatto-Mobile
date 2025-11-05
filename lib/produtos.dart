import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/services.dart';
import 'classes/clProduto.dart';

class Produtos extends StatefulWidget {
  final int produtoId;
  const Produtos({super.key, required this.produtoId});

  @override
  State<Produtos> createState() => ProdutosState();
}

class ProdutosState extends State<Produtos> {
  late Future<List<ProdutoClass>> produtos;
  int _indiceAtual = 0;
  final CarouselSliderController _controller = CarouselSliderController();

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
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Image.asset('img/sonatto_logo.png', width: 200, height: 400),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: FutureBuilder<List<ProdutoClass>>(
          future: produtos,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError || !snapshot.hasData) {
              return const Center(child: Text('Erro ao carregar produto'));
            }

            final produto = snapshot.data![widget.produtoId];
            final imagens = produto.Imagens;

            return ListView(
              children: [
                CarouselSlider.builder(
                  options: CarouselOptions(
                    height: 500,
                    viewportFraction: 1,
                    autoPlay: true,
                    onPageChanged: (i, _) => setState(() => _indiceAtual = i),
                  ),
                  itemCount: imagens.length,
                  itemBuilder:
                      (context, i, _) => Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.blueGrey),
                        ),
                        child: Stack(
                          children: [
                            Image.network(
                              imagens[i],
                              width: double.infinity,
                              fit: BoxFit.cover,
                              loadingBuilder:
                                  (c, child, progress) =>
                                      progress == null
                                          ? child
                                          : const Center(
                                            child: CircularProgressIndicator(),
                                          ),
                              errorBuilder:
                                  (c, e, s) => const Center(
                                    child: Icon(
                                      Icons.broken_image,
                                      size: 80,
                                      color: Colors.red,
                                    ),
                                  ),
                            ),
                            Positioned(
                              top: 12,
                              left: 12,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black54,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  '${i + 1}/${imagens.length}',
                                  style: const TextStyle(
                                    color: Colors.white,
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
                  children:
                      imagens.asMap().entries.map((e) {
                        return GestureDetector(
                          onTap: () => _controller.animateToPage(e.key),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: _indiceAtual == e.key ? 14 : 8,
                            height: 8,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color:
                                  _indiceAtual == e.key
                                      ? Colors.blueAccent
                                      : Colors.grey,
                            ),
                          ),
                        );
                      }).toList(),
                ),

                const SizedBox(height: 30),

                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      
                      Text(
                        produto.NomeProduto,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 12),

                      
                      Row(
                        children: List.generate(5, (index) {
                          double rating = produto.Avaliacao;
                          double fill = (rating - index).clamp(
                            0.0,
                            1.0,
                          ); // 0.0 a 1.0

                          return SizedBox(
                            width: 40,
                            height: 40,

                            child: Stack(
                              children: [
                                
                                const Icon(
                                  Icons.star,
                                  color: Colors.grey,
                                  size: 36,
                                ),

                                Positioned(
                                  top: 0.1,
                                  child: ClipRect(
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      widthFactor: fill,
                                      child: const Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                        size: 36,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 16),

                      Text(
                        'R\$ ${produto.Preco.toStringAsFixed(2).replaceAll('.', ',')}',
                        style: const TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 24),

                      const Text(
                        'Descrição:',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFFD9D9D9),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          produto.Descricao,
                          style: const TextStyle(fontSize: 17, height: 1.6),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
