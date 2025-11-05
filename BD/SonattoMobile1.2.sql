-- Tabelas do Ecommerce
DROP DATABASE dbSonatto;
CREATE DATABASE dbSonatto;
USE dbSonatto;

-- Tabela de Produto
CREATE TABLE tbProduto(
    IdProduto INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    NomeProduto VARCHAR(100) NOT NULL,
    Descricao VARCHAR(2500) NOT NULL,
    Preco DECIMAL(8,2) NOT NULL CHECK(Preco > 0),
	Marca VARCHAR(100) NOT NULL,
    Categoria VARCHAR(100) NOT NULL,
    Avaliacao DECIMAL (2,1) NOT NULL
);

-- Tabela de Imagens dos Produtos
CREATE TABLE tbImagens(
	IdImagem INT AUTO_INCREMENT PRIMARY KEY,
    IdProduto INT,
    UrlImagem varchar(255),
    CONSTRAINT fk_ImgIdProduto FOREIGN KEY(IdProduto) REFERENCES tbProduto(IdProduto)
);

-- Tabela de Estoque
CREATE TABLE tbEstoque(
    IdEstoque INT PRIMARY KEY AUTO_INCREMENT,
    IdProduto INT NOT NULL,
    QtdEstoque INT NOT NULL,
    Disponibilidade BIT NOT NULL,
    CONSTRAINT fk_IdEstoque_IdProduto FOREIGN KEY(IdProduto) REFERENCES tbProduto(IdProduto)
);


-- Procedures 

-- IN => Valor de entrada
-- OUT => Valor de saída
-- procedure para criar usuario
-- drop procedure sp_CadastroUsu

-- Procedure Cadastrar Produto
-- drop procedure sp_CadastrarProduto
DELIMITER $$
CREATE PROCEDURE sp_CadastrarProduto(
	vNomeProduto VARCHAR(100),
    vPreco DECIMAL(8,2),
    vDescricao varchar(2500),
    vMarca VARCHAR(100),
    vAvaliacao DECIMAL(2,1),
    vCategoria VARCHAR(100),
    vQtdEstoque INT
)
BEGIN
	DECLARE vIdProduto INT;
    
    -- Salva os valores do produto
	INSERT INTO tbProduto(NomeProduto, Descricao, Preco, Marca, Categoria,Avaliacao)
    VALUES(vNomeProduto, vDescricao, vPreco, vMarca, vCategoria,vAvaliacao);
    SET vIdProduto = LAST_INSERT_ID();

    -- Salva a quantidade em estoque
    INSERT INTO tbEstoque(IdProduto, QtdEstoque, Disponibilidade)
    VALUES(vIdProduto, vQtdEstoque, true);
    
END $$
DELIMITER ;
-- Produto 1 
/*
CALL sp_CadastrarProduto(
	'Bateria Exemplo', 
    2000.99,
    'Bateria vendida pela loja y, 
    com as especificaçoes a seguir: xxxxxxxxxxxxxxxxxxx, xxxxxxxxxxxxxxx, xxxxxxxxxxxx' ,
    'Marca Exemplo', 
    4.5,
    'Percussão',
    20
);
-- Produto 2 
CALL sp_CadastrarProduto(
	'Guitarra Exemplo', 
    1500.00,
    'Guitarra vendida pela loja y, 
    com as especificaçoes a seguir: xxxxxxxxxxxxxxxxxxx, xxxxxxxxxxxxxxx, xxxxxxxxxxxx' ,
    'Marca Exemplo', 
    4.5,
    'Cordas',
    20
);
*/


DELIMITER $$
CREATE PROCEDURE sp_AdicionarImagens( 
	vIdProduto INT,
    vImagemUrl VARCHAR(255)
)
BEGIN
    INSERT INTO tbImagens(IdProduto,UrlImagem)
    VALUES(vIdProduto,vImagemUrl);
END $$
DELIMITER ;

-- CALL sp_AdicionarImagens(1,'www.imagem.url.com.br3');
