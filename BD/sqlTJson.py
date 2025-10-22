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

# Consulta para trazer produtos e suas imagens (várias por produto)
query = """
SELECT 
    p.IdProduto,
    p.NomeProduto,
    p.Marca,
    p.Preco,
    p.Descricao,
    p.Avaliacao,
    i.UrlImagem
FROM tbProduto AS p
LEFT JOIN tbImgProduto AS ip ON p.IdProduto = ip.IdProduto
LEFT JOIN tbImagens AS i ON ip.IdImagem = i.IdImagem
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
            "Avaliacao": float(row["Avaliacao"]),
            "Imagens": []
        }
    if row["UrlImagem"]:
        produtos[id_prod]["Imagens"].append(row["UrlImagem"])

# Converter para lista e gerar JSON
lista_produtos = list(produtos.values())
df = pd.DataFrame(lista_produtos)
df.to_json('Produtos.json', orient='records', force_ascii=False, indent=4)

# Mostrar no terminal
print(json.dumps(lista_produtos, indent=4, ensure_ascii=False))

cursor.close()
conn.close()