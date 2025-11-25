class ProdutoClass {
late int IdProduto;
  late String NomeProduto;
  late String Categoria;
  late String MarcaProduto;
  late double Preco;
  late String Descricao;
  late List<String> Imagens;
  late double Avaliacao; // ← NOVO: nota de 0.0 a 5.0

  ProdutoClass({
    this.IdProduto = 0,
    this.NomeProduto = "",
    this.Categoria = "",
    this.MarcaProduto = "",
    this.Preco = 0.0,
    this.Descricao = "",
    List<String>? Imagens,
    this.Avaliacao = 4.5, // ← valor padrão
  }) : Imagens = Imagens ?? [];

  ProdutoClass.fromJson(Map<String, dynamic> json)
      : IdProduto = json['IdProduto'] ?? json['idProduto'] ?? 0,
        NomeProduto = json['NomeProduto'] ?? '',
        Categoria = json['Categoria'] ?? '',
        MarcaProduto = json['MarcaProduto'] ?? json['Marca'] ?? '',
        Preco = (json['Preco'] ?? 0).toDouble(),
        Descricao = json['Descricao'] ?? '',
        Imagens = (json['Imagens'] != null)
            ? List<String>.from(json['Imagens'])
            : [],
        Avaliacao = (json['Avaliacao'] ?? 4.5).toDouble();

  Map<String, dynamic> toJson() => {
        'IdProduto': IdProduto,
        'NomeProduto': NomeProduto,
        'Categoria': Categoria,
        'MarcaProduto': MarcaProduto,
        'Preco': Preco,
        'Descricao': Descricao,
        'Imagens': Imagens,
        'Avaliacao': Avaliacao,
      };
}
