
class Produto {
  final int? idProduto;
  final String? NomeProduto;
  final int? ValorUnitario;
  final String? Descricao;

  Produto.v({
    this.idProduto,
    this.NomeProduto,
    this.ValorUnitario,
    this.Descricao
  });

  Produto.fromJson(Map<String, dynamic> json)
    : idProduto = json['idProduto'] as int,
      NomeProduto = json['NomeProduto'] as String,
      ValorUnitario = json['ValorUnitario'] as int,
      Descricao = json['Descricao'] as String;

  Map<String, dynamic> toJson() => {
    'idProduto': idProduto,
    'NomeProduto': NomeProduto,
    'ValorUnitario': ValorUnitario,
    'Descricao': Descricao,
    
  };
}
