import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class Produtos extends StatefulWidget {
  const Produtos({super.key});

  @override
  State<Produtos> createState() => ProdutosState();
}

class ProdutosState extends State<Produtos> {
  final List<String> imagens = ['img/sonatto_logo.png', 'img/tela-preta.png'];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Image.asset('img/sonatto_logo.png', width: 200, height: 400),
        ),
        body: Center(
          child: CarouselSlider.builder(
            options: CarouselOptions(autoPlay: false),
            itemCount: imagens.length,
            itemBuilder:
                (BuildContext context, int itemIndex, int pageViewIndex) =>
                    Container(child: Image.asset(imagens[itemIndex].toString())),
          ),
        ),
      ),
    );
  }
}
