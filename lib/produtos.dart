import 'package:flutter/material.dart';

class Produtos extends StatefulWidget{
  const  Produtos({super.key});

  @override
  State<Produtos> createState() => ProdutosState();
}

class ProdutosState extends State<Produtos>{

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Image.asset(
            'img/sonatto_logo.png',
            width: 200, height: 400,
            ), 
        ),
        body: Center(

        ),
      ),
    ); 
  }
}