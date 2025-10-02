class ProdutoClass {
  late int idProduto;
  late String NomeProduto;
  late int ValorUnitario;
  late String Descricao;
  late String ImagemURL;

  ProdutoClass(){
    idProduto = 0;
    NomeProduto = "";
    ValorUnitario = 0;
    Descricao = "";
    ImagemURL = "";
  }

  ProdutoClass.v(
    this.idProduto,
    this.NomeProduto,
    this.ValorUnitario,
    this.Descricao,
    this.ImagemURL,
  );

  ProdutoClass.fromJson(Map<String, dynamic> json)
    : idProduto = json['idProduto'] as int,
      NomeProduto = json['NomeProduto'] as String,
      ValorUnitario = json['Preco'] as int,
      Descricao = json['Descricao'] as String,
      ImagemURL = json['ImagemURL'] as String;

  Map<String, dynamic> toJson() => {
    'idProduto': idProduto,
    'NomeProduto': NomeProduto,
    'Preco': ValorUnitario,
    'Descricao': Descricao,
    'ImagemURL': ImagemURL,
  };
}
