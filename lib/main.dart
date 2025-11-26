import 'package:flutter/material.dart';
import 'package:mobile_sonatto/produtos.dart';
import 'package:mobile_sonatto/cardProduto.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'classes/clProduto.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/services.dart';

void main() {
  runApp(Main());
}
// flutter clean
// flutter pub get
// flutter build apk --release

class Main extends StatefulWidget {
  // const Main({super.key});
  final String? vaiParaHome;

  Main({this.vaiParaHome});

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToSection();
    });
  }

  final homeKey = GlobalKey();
  final ScrollController scrollController = ScrollController();

  void _scrollToSection() {
    BuildContext? target;

    switch (widget.vaiParaHome) {
      case "home":
        target = homeKey.currentContext;
        break;
    }

    if (target != null) {
      Scrollable.ensureVisible(
        target,
        duration: Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    }
  }

  String filtro = '';
  String filtroCat = '';
  String firstUppercase(String s) {
    if (s == null || s.isEmpty) {
      return s;
    }
    return s[0].toUpperCase() + s.substring(1);
  }
  bool catButtonIs = true;
  bool srcButtonIs = true;
  bool pesquisa = false;
  bool categoria = false;
  bool srcCateg = false;
  bool visibilidadeOnSubmit = true;
  bool visibilidadeOnSubmitPesquisaDeuCerto = true;
  bool TpesquisaFCategoria = true;

  List<String> tiposDeProd = [
    'Guitarra',
    'Bateria',
    'Saxofone',
    'Baixo',
    'Gaita',
    'Piano',
  ];
  List<String> categoriasProd = ['Sopro', 'Cordas', 'Percussão', 'Teclas'];

  Widget item(String nome) {
    return Row(
      children: [
        Text('+', style: TextStyle(fontSize: 30)),
        TextButton(
          onPressed: () {},
          child: Text(nome, style: TextStyle(color: Colors.black)),
        ),
      ],
    );
  }

  Widget item2(String nome) {
    return Row(
      children: [
        Text('♪', style: TextStyle(color: Colors.black)),
        TextButton(
          onPressed: () {},
          child: Text(nome, style: TextStyle(color: Colors.black)),
        ),
      ],
    );
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
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Image.asset('img/sonatto_logo.png', width: 200, height: 400),
        ),
        body: SafeArea(
          child: FutureBuilder<List<ProdutoClass>>(
            future: produtos,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Erro ao carregar dados: ${snapshot.error}'),
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('Nenhum produto encontrado'));
              }

              var produtosListFiltrado =
                  snapshot.data!
                      .where(
                        (p) => p.NomeProduto.toLowerCase().contains(filtro),
                      )
                      .toList();
              var produtosListFiltroCategoria =
                  snapshot.data!
                      .where(
                        (p) => p.Categoria.toLowerCase().contains(filtroCat),
                      )
                      .toList();
              if (produtosListFiltrado.isEmpty) {
                return Center(
                  child: Text(
                    'Sem resultados para ${filtro}.',
                    style: TextStyle(fontSize: 18),
                  ),
                );
              }
              final produtosList = snapshot.data!;
              final lancamentos = produtosList.toList();
              final maisVendidos = produtosList.toList();
              maisVendidos.sort((a, b) => b.Avaliacao.compareTo(a.Avaliacao));

              final randomizados = (produtosList.toList()..shuffle());
              return CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Stack(
                      children: [
                        Center(
                          key: homeKey,
                          child: Image.asset(
                            'img/violaoBackground.png',
                            width: double.infinity,
                            height: 400,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned.fill(
                          top: 10,
                          bottom: 200,
                          child: Align(
                            alignment: Alignment.center,
                            child: ClipRect(
                              child: BackdropFilter(
                                filter: ImageFilter.blur(
                                  sigmaX: 15,
                                  sigmaY: 15,
                                ),
                                child: Container(
                                  height: 700,
                                  color: Colors.white.withOpacity(0.1),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 12,
                                  ),
                                  child: Column(
                                    spacing: 10,
                                    children: [
                                      Text(
                                        'Descubra o instrumento que\nmais parece com você',
                                        textAlign: TextAlign.start,
                                        softWrap: true,
                                        style: GoogleFonts.aoboshiOne(
                                          fontSize: 25,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                          shadows: [
                                            Shadow(
                                              color: Colors.black.withOpacity(
                                                0.4,
                                              ),
                                              blurRadius: 6,
                                              offset: const Offset(1, 2),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Text(
                                        'Navegue por uma quantidade imensa de produtos meticulosamente selecionados e projetados para explorar as suas individualidades e cativar o seu senso de estilo.',
                                        textAlign: TextAlign.start,
                                        softWrap: true,
                                        style: GoogleFonts.aoboshiOne(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                          shadows: [
                                            Shadow(
                                              color: Colors.black.withOpacity(
                                                0.4,
                                              ),
                                              blurRadius: 6,
                                              offset: const Offset(1, 2),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        //animação dos itens
                        Positioned(
                          bottom: 40,
                          left: 0,
                          right: 0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: const [
                              ContadorAnimado(
                                valorFinal: 200,
                                duracao: 3,
                                descricao: 'Marcas internacionais',
                              ),
                              ContadorAnimado(
                                valorFinal: 2000,
                                duracao: 3.5,
                                descricao: 'Produtos',
                              ),
                              ContadorAnimado(
                                valorFinal: 30000,
                                duracao: 4,
                                descricao: 'Clientes satisfeitos',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  SliverToBoxAdapter(
                    child: Container(
                      decoration: BoxDecoration(color: Colors.black),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Image.asset(
                            'img/fender.png',
                            width: 60,
                            height: 55,
                            fit: BoxFit.fitWidth,
                          ),
                          Image.asset(
                            'img/roland.png',
                            width: 60,
                            height: 55,
                            fit: BoxFit.fitWidth,
                          ),
                          Image.asset(
                            'img/gibson.png',
                            width: 60,
                            height: 55,
                            fit: BoxFit.fitWidth,
                          ),
                          Image.asset(
                            'img/pearl.png',
                            width: 60,
                            height: 55,
                            fit: BoxFit.fitWidth,
                          ),
                          Image.asset(
                            'img/yamaha.png',
                            width: 60,
                            height: 55,
                            fit: BoxFit.fitWidth,
                          ),
                        ],
                      ),
                    ),
                  ),

                  //Parte que vai aparecer apenas quando der enter na pesquisa
                  (!visibilidadeOnSubmit == true)
                      ? SliverToBoxAdapter(
                        child: Center(
                          child: Text(
                            (TpesquisaFCategoria == true)
                                ? 'Resultado para:${filtro}'
                                : '${firstUppercase(filtroCat)}',
                            style: GoogleFonts.anton(
                              fontSize: 40,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      )
                      : SliverToBoxAdapter(child: SizedBox()),

                  (!visibilidadeOnSubmit == true)
                      ? SliverPadding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 8,
                        ),
                        sliver: SliverGrid(
                          delegate: SliverChildBuilderDelegate((
                            context,
                            index,
                          ) {
                            final p =
                                (TpesquisaFCategoria == true)
                                    ? produtosListFiltrado[index]
                                    : produtosListFiltroCategoria[index];
                            return CardProd(
                              nome: p.NomeProduto,
                              marca: p.MarcaProduto,
                              imagem:
                                  p.Imagens.isEmpty
                                      ? 'https://via.placeholder.com/200'
                                      : p.Imagens.first,
                              preco: p.Preco,
                              navMain: p.IdProduto - 1,
                            );
                          }, childCount: (TpesquisaFCategoria == true) ?
                          produtosListFiltrado.length : produtosListFiltroCategoria.length),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 8,
                                crossAxisSpacing: 8,
                                childAspectRatio: 0.57,
                              ),
                        ),
                      )
                      : SliverToBoxAdapter(child: SizedBox()),

                  //acaba aqui
                  (visibilidadeOnSubmit == true)
                      ? SliverToBoxAdapter(
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
                      )
                      : SliverToBoxAdapter(child: SizedBox()),

                  (visibilidadeOnSubmit == true)
                      ? SliverPadding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 8,
                        ),
                        sliver: SliverGrid(
                          delegate: SliverChildBuilderDelegate((
                            context,
                            index,
                          ) {
                            final p = lancamentos[index];
                            return Visibility(
                              visible: visibilidadeOnSubmit,
                              child: CardProd(
                                nome: p.NomeProduto,
                                marca: p.MarcaProduto,
                                imagem:
                                    p.Imagens.isEmpty
                                        ? 'https://via.placeholder.com/200'
                                        : p.Imagens.first,
                                preco: p.Preco,
                                navMain: p.IdProduto - 1,
                              ),
                            );
                          }, childCount: limite1.clamp(0, lancamentos.length)),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 8,
                                crossAxisSpacing: 8,
                                childAspectRatio: 0.57,
                              ),
                        ),
                      )
                      : SliverToBoxAdapter(child: SizedBox()),

                  (visibilidadeOnSubmit == true)
                      ? SliverToBoxAdapter(
                        child: Center(
                          child: Visibility(
                            visible: visibilidadeOnSubmit,
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
                      )
                      : SliverToBoxAdapter(child: SizedBox()),

                  (visibilidadeOnSubmit == true)
                      ? SliverToBoxAdapter(
                        child: Visibility(
                          visible: visibilidadeOnSubmit,
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
                      )
                      : SliverToBoxAdapter(child: SizedBox()),

                  (visibilidadeOnSubmit == true)
                      ? SliverPadding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 8,
                        ),
                        sliver: SliverGrid(
                          delegate: SliverChildBuilderDelegate((
                            context,
                            index,
                          ) {
                            final p = maisVendidos[index];
                            return Visibility(
                              visible: visibilidadeOnSubmit,
                              child: CardProd(
                                nome: p.NomeProduto,
                                marca: p.MarcaProduto,
                                imagem:
                                    p.Imagens.isEmpty
                                        ? 'https://via.placeholder.com/200'
                                        : p.Imagens.first,
                                preco: p.Preco,
                                navMain: p.IdProduto - 1,
                              ),
                            );
                          }, childCount: limite2.clamp(0, maisVendidos.length)),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 8,
                                crossAxisSpacing: 8,
                                childAspectRatio: 0.57,
                              ),
                        ),
                      )
                      : SliverToBoxAdapter(child: SizedBox()),

                  (visibilidadeOnSubmit == true)
                      ? SliverToBoxAdapter(
                        child: Visibility(
                          visible: visibilidadeOnSubmit,
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
                      )
                      : SliverToBoxAdapter(child: SizedBox()),

                  (visibilidadeOnSubmit == true)
                      ? SliverToBoxAdapter(
                        child: Visibility(
                          visible: visibilidadeOnSubmit,
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
                      )
                      : SliverToBoxAdapter(child: SizedBox()),

                  (visibilidadeOnSubmit == true)
                      ? SliverPadding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 8,
                        ),
                        sliver: SliverGrid(
                          delegate: SliverChildBuilderDelegate((
                            context,
                            index,
                          ) {
                            final p = randomizados[index];
                            return Visibility(
                              visible: visibilidadeOnSubmit,
                              child: CardProd(
                                nome: p.NomeProduto,
                                marca: p.MarcaProduto,
                                imagem:
                                    p.Imagens.isEmpty
                                        ? 'https://via.placeholder.com/200'
                                        : p.Imagens.first,
                                preco: p.Preco,
                                navMain: p.IdProduto - 1,
                              ),
                            );
                          }, childCount: randomizados.length),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 8,
                                crossAxisSpacing: 8,
                                childAspectRatio: 0.57,
                              ),
                        ),
                      )
                      : SliverToBoxAdapter(child: SizedBox()),

                  SliverToBoxAdapter(child: SizedBox(height: 80)),
                ],
              );
            },
          ),
        ),
        persistentFooterButtons: [
          (srcCateg == false)
              ? Visibility(
                visible: pesquisa,
                child: Column(
                  children: [
                    Center(
                      child:
                          (visibilidadeOnSubmitPesquisaDeuCerto == true)
                              ? Text(
                                'Sugestão de pesquisa',
                                style: TextStyle(fontSize: 30),
                              )
                              : SizedBox(),
                    ),
                    Padding(
                      padding: EdgeInsetsGeometry.only(
                        right: 300,
                        top: 1,
                        bottom: 10,
                      ),
                      child: Padding(
                        padding: EdgeInsetsGeometry.only(left: 50),
                        child:
                            (visibilidadeOnSubmitPesquisaDeuCerto == true)
                                ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Builder(
                                      builder: (context) {
                                        return GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              filtro =
                                                  tiposDeProd[0].toLowerCase();
                                              visibilidadeOnSubmitPesquisaDeuCerto =
                                                  false;
                                            });
                                          },
                                          child: item(tiposDeProd[0]),
                                        );
                                      },
                                    ),
                                    Builder(
                                      builder: (context) {
                                        return GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              filtro =
                                                  tiposDeProd[1].toLowerCase();
                                              visibilidadeOnSubmitPesquisaDeuCerto =
                                                  false;
                                            });
                                          },
                                          child: item(tiposDeProd[1]),
                                        );
                                      },
                                    ),
                                    Builder(
                                      builder: (context) {
                                        return GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              filtro =
                                                  tiposDeProd[2].toLowerCase();
                                              visibilidadeOnSubmitPesquisaDeuCerto =
                                                  false;
                                            });
                                          },
                                          child: item(tiposDeProd[2]),
                                        );
                                      },
                                    ),
                                    Builder(
                                      builder: (context) {
                                        return GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              filtro =
                                                  tiposDeProd[3].toLowerCase();
                                              visibilidadeOnSubmitPesquisaDeuCerto =
                                                  false;
                                            });
                                          },
                                          child: item(tiposDeProd[3]),
                                        );
                                      },
                                    ),
                                    Builder(
                                      builder: (context) {
                                        return GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              filtro =
                                                  tiposDeProd[4].toLowerCase();
                                              visibilidadeOnSubmitPesquisaDeuCerto =
                                                  false;
                                            });
                                          },
                                          child: item(tiposDeProd[4]),
                                        );
                                      },
                                    ),
                                    Builder(
                                      builder: (context) {
                                        return GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              filtro =
                                                  tiposDeProd[5].toLowerCase();
                                              visibilidadeOnSubmitPesquisaDeuCerto =
                                                  false;
                                            });
                                          },
                                          child: item(tiposDeProd[5]),
                                        );
                                      },
                                    ),
                                  ],
                                )
                                : SizedBox(),
                      ),
                    ),
                    (visibilidadeOnSubmitPesquisaDeuCerto == true)
                        ? Padding(
                          padding: EdgeInsetsGeometry.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom,
                          ),
                          child: TextField(
                            decoration: const InputDecoration(
                              labelText: "Buscar produto...",
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (valor) {
                              setState(() {
                                filtro = valor.toLowerCase();
                              });
                            },
                            onSubmitted: (value) {
                              setState(() {
                                visibilidadeOnSubmitPesquisaDeuCerto = false;
                              });
                            },
                          ),
                        )
                        : SizedBox(),
                  ],
                ),
              )
              : Visibility(
                visible: categoria,
                child: Column(
                  children: [
                    Center(
                      child: Text('Categorias', style: TextStyle(fontSize: 24)),
                    ),
                    Padding(
                      padding: EdgeInsetsGeometry.only(
                        right: 300,
                        top: 1,
                        bottom: 10,
                      ),
                      child: Padding(
                        padding: EdgeInsetsGeometry.only(left: 50),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Builder(
                              builder: (context) {
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      filtroCat =
                                          categoriasProd[0].toLowerCase();
                                      visibilidadeOnSubmitPesquisaDeuCerto =
                                          false;
                                      TpesquisaFCategoria = false;
                                      categoria = false;
                                    });
                                  },
                                  child: item(categoriasProd[0]),
                                );
                              },
                            ),
                            Builder(
                              builder: (context) {
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      filtroCat =
                                          categoriasProd[1].toLowerCase();
                                      visibilidadeOnSubmitPesquisaDeuCerto =
                                          false;
                                      TpesquisaFCategoria = false;
                                      categoria = false;
                                    });
                                  },
                                  child: item(categoriasProd[1]),
                                );
                              },
                            ),
                            Builder(
                              builder: (context) {
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      filtroCat =
                                          categoriasProd[2].toLowerCase();
                                      visibilidadeOnSubmitPesquisaDeuCerto =
                                          false;
                                      TpesquisaFCategoria = false;
                                      categoria = false;
                                    });
                                  },
                                  child: item(categoriasProd[2]),
                                );
                              },
                            ),
                            Builder(
                              builder: (context) {
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      filtroCat =
                                          categoriasProd[3].toLowerCase();
                                      visibilidadeOnSubmitPesquisaDeuCerto =
                                          false;
                                      TpesquisaFCategoria = false;
                                      categoria = false;
                                    });
                                  },
                                  child: item(categoriasProd[3]),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
        ],
        bottomNavigationBar: Container(
          height: 65,
          color: Colors.black,
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 20,
            children: [
              Builder(
                builder: (context) {
                  return GestureDetector(
                    onTap: (catButtonIs == true) ? () {
                      setState(() {
                        pesquisa = false;
                        categoria = !categoria;
                        srcCateg = true;
                        TpesquisaFCategoria = false;
                        visibilidadeOnSubmit = !visibilidadeOnSubmit;
                        visibilidadeOnSubmitPesquisaDeuCerto = true;
                        filtroCat = '';
                        filtro = '';
                        srcButtonIs = !srcButtonIs;
                      });
                    } : null,
                    child: Image.asset(
                      'img/MusicNoteList.png',
                      width: 120,
                      height: 100,
                    ),
                  );
                },
              ),

              Builder(
                builder: (context) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context, rootNavigator: true).push(
                        MaterialPageRoute(
                          builder: (context) => Main(vaiParaHome: "home"),
                        ),
                      );
                      Scrollable.ensureVisible(
                        homeKey.currentContext!,
                        duration: Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                      );
                    },
                    child: Icon(Icons.home, size: 60, color: Colors.white),
                  );
                },
              ),

              GestureDetector(
                onTap: (srcButtonIs == true) ? () {
                  setState(() {
                    pesquisa = !pesquisa;
                    categoria = false;
                    srcCateg = false;
                    TpesquisaFCategoria = true;
                    visibilidadeOnSubmit = !visibilidadeOnSubmit;
                    visibilidadeOnSubmitPesquisaDeuCerto = true;
                    filtroCat = '';
                    filtro = '';
                    catButtonIs = !catButtonIs;
                  });
                } : null,
                child: Image.asset('img/Search.png', width: 120, height: 100),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//configurando animação
class ContadorAnimado extends StatefulWidget {
  final int valorFinal;
  final double duracao;
  final String descricao;

  const ContadorAnimado({
    super.key,
    required this.valorFinal,
    required this.duracao,
    required this.descricao,
  });

  @override
  State<ContadorAnimado> createState() => _ContadorAnimadoState();
}

class _ContadorAnimadoState extends State<ContadorAnimado>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: (widget.duracao * 1000).toInt()),
    );

    _animation = IntTween(
      begin: 0,
      end: widget.valorFinal,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${_animation.value}+',
              style: GoogleFonts.aoboshiOne(
                fontSize: 27,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              widget.descricao,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(fontSize: 11, color: Colors.white70),
            ),
          ],
        );
      },
    );
  }
}
