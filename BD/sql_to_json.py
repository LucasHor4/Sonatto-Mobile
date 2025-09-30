import re
import json

# Nome do arquivo .sql
sql_file = "produtos.sql"
# Nome do arquivo de saída .json
json_file = "produtos.json"

# Lê o conteúdo do arquivo SQL
with open(sql_file, "r", encoding="utf-8") as f:
    sql_content = f.read()

# Expressão regular para capturar os VALUES
pattern = re.compile(r"VALUES\s*\((.*?)\);", re.IGNORECASE | re.DOTALL)

produtos = []

for match in pattern.findall(sql_content):
    # Remove espaços extras e divide pelos vírgulas
    valores = [v.strip().strip("'") for v in match.split(",")]

    produto = {
        "idProduto": int(valores[0]),
        "NomeProduto": valores[1],
        "ValorUnitario": int(valores[2]),
        "Descricao": valores[3]
    }
    produtos.append(produto)

# Salva em JSON
with open(json_file, "w", encoding="utf-8") as f:
    json.dump(produtos, f, indent=2, ensure_ascii=False)

print(f"Arquivo {json_file} gerado com sucesso!")

#Para rodar esse script use no terminal: 
# python sql_to_json.py