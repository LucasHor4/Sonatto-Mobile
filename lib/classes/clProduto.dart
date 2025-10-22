class ProdutoClass {
  late int IdProduto;
  late String NomeProduto;
  late String MarcaProduto;
  late double Preco;
  late String Descricao;
  late List<String> Imagens;

  ProdutoClass({
    this.IdProduto = 0,
    this.NomeProduto = "",
    this.MarcaProduto = "",
    this.Preco = 0.0,
    this.Descricao = "",
    List<String>? Imagens,
  }) : Imagens = Imagens ?? [];

  ProdutoClass.fromJson(Map<String, dynamic> json)
      : IdProduto = json['IdProduto'] ?? json['idProduto'] ?? 0,
        NomeProduto = json['NomeProduto'] ?? '',
        MarcaProduto = json['MarcaProduto'] ?? json['Marca'] ?? '',
        Preco = (json['Preco'] ?? 0).toDouble(),
        Descricao = json['Descricao'] ?? '',
        Imagens = (json['Imagens'] != null)
            ? List<String>.from(json['Imagens'])
            : [];

  Map<String, dynamic> toJson() => {
        'IdProduto': IdProduto,
        'NomeProduto': NomeProduto,
        'MarcaProduto': MarcaProduto,
        'Preco': Preco,
        'Descricao': Descricao,
        'Imagens': Imagens,
      };
}
