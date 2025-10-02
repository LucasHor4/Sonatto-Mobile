import mysql.connector
import json
import pandas as pd
conn = mysql.connector.connect(
    host='localhost',
    user='root',
    password='12345678',
    port=3306
)
cursor = conn.cursor()
cursor.execute('use dbSonattoMobile')
cursor.execute('select * from tbProduto')
json_itens = cursor.fetchall()
jsonList = pd.DataFrame(json_itens, columns = ['IdProduto', 'NomeProduto', 'Preco', 'Descricao', 'ImagemURL'])
# Aceitar caracteres especiais no json usando utf-8 =
jsonList.to_json('Produtos.json', orient='records')
print(jsonList)
cursor.close()
conn.close()