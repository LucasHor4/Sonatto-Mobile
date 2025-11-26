import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:Sonatto/classes/clProduto.dart';
import 'package:Sonatto/produtos.dart';
import 'package:Sonatto/Main.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

var navProd;

class CardProd extends StatelessWidget {
  final String nome;
  final String marca;
  final String imagem;
  final double preco;
  final dynamic navMain;

  CardProd({
    required this.nome,
    required this.marca,
    required this.imagem,
    required this.preco,
    required this.navMain,
  });

  late Future<List<ProdutoClass>> produtos;

  Future<List<ProdutoClass>> readJson() async {
    final String response = await rootBundle.loadString('BD/Produtos.json');
    Iterable data = json.decode(response);
    return List<ProdutoClass>.from(
      data.map((model) => ProdutoClass.fromJson(model)),
    );
  }

  @override
  Widget build(BuildContext context) {
    double tamanhoLateral = MediaQuery.of(context).size.width;

    return Container(
      width: 100,
      height: 950,
      decoration: BoxDecoration(
        border: Border.all(width: 0.1, color: Colors.grey),
        borderRadius: BorderRadius.circular(15),
      ),
      margin: EdgeInsets.only(
        left: tamanhoLateral * 0.02,
        right: tamanhoLateral * 0.02,
        bottom: 10,
      ),
      child: Container(
        width: 200,
        height: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(12)),
          border: Border.all(color: Colors.grey, width: 2),
        ),
        clipBehavior: Clip.hardEdge,
        child: ListView(
          padding: EdgeInsets.only(left: 9, right: 9, bottom: 15, top: 2),
          physics: NeverScrollableScrollPhysics(),
          children: [
            Padding(
              padding: EdgeInsetsGeometry.only(),
              child: Image.network(
                //pra pegar as imagens com os links da net
                imagem,
                fit: BoxFit.contain,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(child: CircularProgressIndicator());
                },
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.broken_image,
                    size: 140,
                    color: Colors.grey,
                  );
                },
                width: MediaQuery.of(context).size.width - 10,
                height: 130,
              ),
            ),

            Text(
              nome,
              textAlign: TextAlign.start,
              maxLines: 2,
              style: GoogleFonts.anton(
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
              // TextStyle(
              //   fontFamily: 'SourceCodePro',
              //   fontSize: 19,
              //   fontWeight: FontWeight.bold,
              // ),
            ),
            Text(
              marca,
              textAlign: TextAlign.start,
              style: GoogleFonts.anton(
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 5),
              child: Text(
                'R\$ ${preco.toStringAsFixed(2)}',
                textAlign: TextAlign.start,
                style: GoogleFonts.anton(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            Container(
              margin: EdgeInsets.only(top: 12, bottom: 1),
              child: TextButton(
                onPressed: () {
                  //mandar para tela do tal produto
                  navProd = navMain;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Produtos(produtoId: navMain),
                    ),
                  );
                },
                style: TextButton.styleFrom(
                  backgroundColor: Color.fromRGBO(60, 60, 67, 1),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text('Veja mais', style: TextStyle(fontSize: 11)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
