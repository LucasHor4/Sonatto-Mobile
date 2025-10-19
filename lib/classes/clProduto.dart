class ProdutoClass {
  late int IdProduto;
  late String NomeProduto;
  late String MarcaProduto;
  late double Preco;
  late String Descricao;
  late String ImagemURL;

  ProdutoClass({
    this.IdProduto = 0,
    this.NomeProduto = "",
    this.MarcaProduto = "",
    this.Preco = 0.0,
    this.Descricao = "",
    this.ImagemURL = "",
  });

ProdutoClass.fromJson(Map<String, dynamic> json)
      : IdProduto = json['IdProduto'] ?? json['idProduto'] ?? 0,
        NomeProduto = json['NomeProduto'] ?? '',
        MarcaProduto = json['MarcaProduto'] ?? '',
        Preco = (json['Preco'] ?? 0).toDouble(),
        Descricao = json['Descricao'] ?? '',
        ImagemURL = json['ImagemURL'] ?? '';

  Map<String, dynamic> toJson() => {
        'IdProduto': IdProduto,
        'NomeProduto': NomeProduto,
        'MarcaProduto': MarcaProduto,
        'Preco': Preco,
        'Descricao': Descricao,
        'ImagemURL': ImagemURL,
      };
}