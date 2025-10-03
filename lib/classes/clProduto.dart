class ProdutoClass {
  late int IdProduto;
  late String NomeProduto;
  late double Preco;
  late String Descricao;
  late String ImagemURL;

  ProdutoClass({
    this.IdProduto = 0,
    this.NomeProduto = "",
    this.Preco = 0.0,
    this.Descricao = "",
    this.ImagemURL = "",
  });

  ProdutoClass.fromJson(Map<String, dynamic> json)
      : IdProduto = json['IdProduto'] as int,
        NomeProduto = json['NomeProduto'] as String,
        Preco = (json['Preco'] as num).toDouble(),
        Descricao = json['Descricao'] as String,
        ImagemURL = json['ImagemURL'] as String;

  Map<String, dynamic> toJson() => {
        'IdProduto': IdProduto,
        'NomeProduto': NomeProduto,
        'Preco': Preco,
        'Descricao': Descricao,
        'ImagemURL': ImagemURL,
      };
}