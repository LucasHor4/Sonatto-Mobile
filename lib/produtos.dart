import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
// import 'package:mobile_sonatto/produtos.dart';

class Produtos extends StatefulWidget {
  const Produtos({super.key});

  @override
  State<Produtos> createState() => ProdutosState();
}

class ProdutosState extends State<Produtos> {
  final List<String> imagens = [
    'img/tela-preta.png',
    'img/tela-preta.png',
    'img/tela-preta.png',
    'img/tela-preta.png',
    'img/tela-preta.png',
  ];

  int avaliacao = 1; // controla a nota (1 a 5), enquanto n puxa do BD
  int coresDisponiveis = 4; //  controla as cores disponíveis
  int _indiceAtual = 0;
  List<Color> CoresProduto = [
    Colors.black,
    Colors.red,
    Colors.blue,
    Colors.purple,

  ];

  final CarouselSliderController _controller = CarouselSliderController();

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
              //Carousel para ficar passando as imagens
              CarouselSlider.builder(
                options: CarouselOptions(
                  height: 500, //aqui regula a altura dele
                  enlargeCenterPage:
                      false, //isso se n me engano é para n esticar a imagem
                  viewportFraction:
                      1, //isso faz com que só uma imagem esteja na tela
                  autoPlay: true, //esse cara faz o carousel ficar passando só
                  onPageChanged: (index, reason) {
                    setState(() {
                      _indiceAtual = index;
                    });
                  },
                ),
                itemCount: imagens.length,
                carouselController: _controller, //x!
                itemBuilder:
                    (BuildContext context, int itemIndex, int pageViewIndex) =>
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
                                width: double.infinity, //p cobrir a tela toda
                              ),
                              Positioned(
                                top: 8,
                                left: 8,
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.black54,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    //texto da contagem de imagens
                                    '${itemIndex + 1}/${imagens.length}',
                                    style: TextStyle(
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
                //bolinhas q mudam conforme a pag
                mainAxisAlignment: MainAxisAlignment.center,
                children:
                    imagens.asMap().entries.map((entry) {
                      return GestureDetector(
                        onTap: () => _controller.animateToPage(entry.key),
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          margin: EdgeInsets.symmetric(horizontal: 4),
                          width: _indiceAtual == entry.key ? 12 : 8,
                          height: _indiceAtual == entry.key ? 12 : 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color:
                                _indiceAtual == entry.key
                                    ? Colors.blueAccent
                                    : Colors.grey,
                          ),
                        ),
                      );
                    }).toList(),
              ),
              /**/
              Text("Cores disponíveis", style: TextStyle(fontSize: 25)),
              Row(
                children: [
                  // Quadrados pretos
                  Row(
                    spacing: 7,
                    children: List.generate(coresDisponiveis, (index) {
                      return Icon(Icons.square, color: CoresProduto[index], size: 55);
                    }),
                  ),

                  Spacer(),

                  // Estrelas com borda
                  Row(
                    children: List.generate(5, (index) {
                      return Stack(
                        alignment: Alignment.center,
                        children: [
                          Icon(
                            Icons.star,
                            color:
                                index < avaliacao
                                    ? Colors.yellow
                                    : Colors.grey, // controla a cor
                            size: 42,
                          ),
                          Icon(
                            Icons.star_border,
                            color: Colors.black, // borda preta por cima
                            size: 42,
                          ),
                        ],
                      );
                    }),
                  ),
                ],
              ),
              /* */
              Text("Descrição", style: TextStyle(fontSize: 40)),
              Container(
                margin: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width - 560,
                  right: MediaQuery.of(context).size.width - 560,
                ),
                padding: EdgeInsets.all(18),
                width: 400,
                height: 300,
                decoration: BoxDecoration(color: Color(0xFFD9D9D9)),
                child: /*Descrição do produto*/ Text(
                  'Produto.descricao, Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis bibendum luctus nibh ac imperdiet. Sed vel dolor massa. Praesent nec ligula pretium, blandit libero et, sodales justo. Sed egestas nibh enim, at posuere dolor blandit ...',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.white,
      ),
    );
  }
}
