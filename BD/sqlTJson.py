import mysql.connector
import json
import pandas as pd

# Conexão com o banco de dados
conn = mysql.connector.connect(
    host='localhost',
    user='root',
    password='12345678',
    port=3306,
    database='dbSonatto'
)
cursor = conn.cursor(dictionary=True)

# Consulta ajustada: join direto entre tbProduto e tbImagens
query = """
SELECT 
    p.IdProduto,
    p.NomeProduto,
    p.Marca,
    p.Preco,
    p.Descricao,
    p.Categoria,
    p.Avaliacao,
    i.UrlImagem
FROM tbProduto AS p
LEFT JOIN tbImagens AS i ON p.IdProduto = i.IdProduto
ORDER BY p.IdProduto;
"""

cursor.execute(query)
rows = cursor.fetchall()

# Agrupar imagens por produto
produtos = {}
for row in rows:
    id_prod = row['IdProduto']
    if id_prod not in produtos:
        produtos[id_prod] = {
            "IdProduto": id_prod,
            "NomeProduto": row["NomeProduto"],
            "Marca": row["Marca"],
            "Preco": float(row["Preco"]),
            "Descricao": row["Descricao"],
            "Categoria": row["Categoria"],
            "Avaliacao": float(row["Avaliacao"]),
            "Imagens": []
        }
    if row["UrlImagem"]:
        produtos[id_prod]["Imagens"].append(row["UrlImagem"])

# Converter para lista e gerar JSON
lista_produtos = list(produtos.values())

# Gera JSON formatado (bonito e com acentos)
with open('Produtos.json', 'w', encoding='utf-8') as f:
    json.dump(lista_produtos, f, ensure_ascii=False, indent=4)

# Mostrar no terminal
print(json.dumps(lista_produtos, indent=4, ensure_ascii=False))

cursor.close()
conn.close()
