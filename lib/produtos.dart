import 'package:flutter/material.dart';

void produtos() {
  runApp(const Produtos());
}

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
        
        
      ),
      
    );
    
  }


}