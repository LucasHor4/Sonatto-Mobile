-- Apaga e recria o banco
DROP DATABASE dbSonatto;
CREATE DATABASE dbSonatto;
USE dbSonatto;

-- Tabela de Usuario
CREATE TABLE tbUsuario (
    IdUsuario INT PRIMARY KEY AUTO_INCREMENT,
    Email VARCHAR(50) NOT NULL,
    Nome VARCHAR(100) NOT NULL,
    Senha VARCHAR(100) NOT NULL,
    CPF VARCHAR(11) NOT NULL UNIQUE,
    Endereco VARCHAR(150) NOT NULL,
    Telefone VARCHAR(11) NOT NULL
);

-- Tabela Nivel de acesso
CREATE TABLE tbNivelAcesso(
	idNivel INT PRIMARY KEY AUTO_INCREMENT,
    NomeNivel VARCHAR(50) NOT NULL
);
INSERT INTO tbNivelAcesso(NomeNivel)
VALUES
	('Nive l'),
	('Nivel 2'),
	('Nivel 3');

-- Tabela Nivel de referenciamento Nivel de acesso
CREATE TABLE tbUsuNivel(
	IdUsuario INT,
    IdNivel INT,
    PRIMARY KEY (IdUsuario, IdNivel),
  	CONSTRAINT fk_IdUsuario FOREIGN KEY(IdUsuario) REFERENCES tbUsuario(IdUsuario),
    CONSTRAINT fk_IdNivel FOREIGN KEY(IdNivel) REFERENCES tbNivelAcesso(IdNivel)
);

-- Tabela de Produto
CREATE TABLE tbProduto(
    IdProduto INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    NomeProduto VARCHAR(100) NOT NULL,
    Descricao VARCHAR(2500) NOT NULL,
    Preco DECIMAL(8,2) NOT NULL CHECK(Preco > 0),
	Marca VARCHAR(100) NOT NULL,
    Avaliacao DECIMAL (2,1) NOT NULL
);

-- Tabela de Imagens dos Produtos
CREATE TABLE tbImagens(
	IdImagem int auto_increment primary key,
    UrlImagem varchar(255)
);

-- Tabela Relacionamento Imagens e Produtos
CREATE TABLE tbImgProduto(
	IdImagem INT,
    IdProduto INT,
    PRIMARY KEY (IdImagem, IdProduto),
    CONSTRAINT fk_IdProduto FOREIGN KEY(IdProduto) REFERENCES tbProduto(IdProduto),
    CONSTRAINT fk_IdImagens FOREIGN KEY(IdImagem) REFERENCES tbImagens(IdImagem)
);

-- Tabela de Estoque
CREATE TABLE tbEstoque(
    IdEstoque INT PRIMARY KEY AUTO_INCREMENT,
    IdProduto INT NOT NULL,
    QtdEstoque INT NOT NULL,
    Disponibilidade BIT NOT NULL,
    CONSTRAINT fk_IdEstoque_IdProduto FOREIGN KEY(IdProduto) REFERENCES tbProduto(IdProduto)
);


-- Tabela de Venda
CREATE TABLE tbVenda(
    IdVenda INT PRIMARY KEY AUTO_INCREMENT,
    IdUsuario INT NOT NULL,
    TipoPag VARCHAR(50) NOT NULL,
    QtdTotal INT NOT NULL,
    ValorTotal DECIMAL(8,2) NOT NULL,
    CONSTRAINT fk_idVenda_IdUsuario FOREIGN KEY(IdUsuario) REFERENCES tbUsuario(IdUsuario)
);

-- Tabela de ItemVenda
CREATE TABLE tbItemVenda(
    IdVenda INT NOT NULL,
    IdProduto INT NOT NULL,
    PrecoUni DECIMAL(8,2),
    Qtd INT NOT NULL,
    PRIMARY KEY(IdVenda, IdProduto),
    CONSTRAINT fk_IdItemVenda_IdVenda FOREIGN KEY(IdVenda) REFERENCES tbVenda(IdVenda),
    CONSTRAINT fk_IdItemVenda_IdProduto FOREIGN KEY(IdProduto) REFERENCES tbProduto(IdProduto)
);

-- Tabela de Nota Fiscal
CREATE TABLE tbNotaFiscal(
    NumNotaFiscal INT PRIMARY KEY AUTO_INCREMENT,
    IdVenda INT NOT NULL UNIQUE,
    DataEmissao DATE NOT NULL,
    Numero VARCHAR(20) NOT NULL UNIQUE,
    PrecoTotal DECIMAL(8,2) NOT NULL,
    CONSTRAINT fk_IdNotaFiscal_IdVenda FOREIGN KEY(IdVenda) REFERENCES tbVenda(IdVenda)
);

-- IN => Valor de entrada
-- OUT => Valor de saída
-- procedure para criar usuario

-- drop procedure sp_CadastroUsu
DELIMITER $$
CREATE PROCEDURE sp_CadastroUsu(
    IN vEmail VARCHAR(50),
    IN vNome VARCHAR(100),
    IN vSenha VARCHAR(100),
    IN vCPF VARCHAR(11),
    IN vEndereco VARCHAR(150),
    IN vTelefone VARCHAR(11),
    OUT vIdCli INT
)
BEGIN
	INSERT INTO tbUsuario (Email, Nome, Senha, CPF, Endereco, Telefone)
    VALUES (vEmail, vNome, vSenha, vCPF, vEndereco, vTelefone);

    SET vIdCli = LAST_INSERT_ID();
END $$
DELIMITER ;
-- call da procedure de cadastro:
CALL sp_CadastroUsu(
    'arthur@gmail.com',
    'Arthur dos Santos Reimberg',
    'art123',
    '12345678901',
    'Rua Algum Lugar, Número 42',
    '11945302356',
    @vIdCli
);

CALL sp_CadastroUsu(
    'lucas@gmail.com',
    'Lucas Hora',
    'luc123',
    '12345678912',
    'Rua Algum Lugar, Número 40',
    '11945302359',
    @vIdCli
);
SELECT @vIdCli AS IdUsuarioCadastrado;

-- procedure adicionar nivel de acesso
DELIMITER $$
CREATE PROCEDURE sp_AdicionarNivel(
	vUsuId INT,
    vNivelId INT
)
BEGIN
	INSERT INTO tbUsuNivel(IdUsuario, IdNivel)
    VALUES(vUsuId, vNivelId);
END$$

DELIMITER ;

CALL sp_AdicionarNivel(1, 2)



-- Procedure Cadastrar Produto
-- drop procedure sp_CadastrarProduto
DELIMITER $$
CREATE PROCEDURE sp_CadastrarProduto(
	vNomeProduto VARCHAR(100),
    vPreco DECIMAL(8,2),
    vDescricao varchar(2500),
    vMarca VARCHAR(100),
    vAvaliacao DECIMAL(2,1),
    vQtdEstoque INT,
    vUrlImagem varchar(255)
)
BEGIN
	DECLARE vIdProduto INT;
    DECLARE vIdImagem INT;
    
	-- Salva a Imagem do produto
    INSERT INTO tbImagens(UrlImagem)
    VALUES(vUrlImagem);
    SET vIdImagem = LAST_INSERT_ID();
    
    -- Salva os valores do produto
	INSERT INTO tbProduto(NomeProduto, Descricao, Preco, Marca, Avaliacao)
    VALUES(vNomeProduto, vDescricao, vPreco, vMarca, vAvaliacao);
    SET vIdProduto = LAST_INSERT_ID();
    
    -- Salvar o relacionamento da imagem com o produto
    INSERT INTO tbImgProduto(IdImagem, IdProduto)
    VALUES(vIdImagem, vIdProduto);
    
    -- Salva a quantidade em estoque
    INSERT INTO tbEstoque(IdProduto, QtdEstoque, Disponibilidade)
    VALUES(vIdProduto, vQtdEstoque, true);
    
END $$
DELIMITER ;

-- Produto 1 
CALL sp_CadastrarProduto(
	'Bateria Exemplo', 
    2000.99,
    'Bateria vendida pela loja y, 
    com as especificaçoes a seguir: xxxxxxxxxxxxxxxxxxx, xxxxxxxxxxxxxxx, xxxxxxxxxxxx' ,
    'Marca Exemplo', 
    4.5, 
    20, 
    'img.png/teste-url-bateria'
);

-- Produto 2
CALL sp_CadastrarProduto(
	'Guitarra Exemplo', 
    1000.99,
    'guitarra vendida pela loja y, 
    com as especificaçoes a seguir: xxxxxxxxxxxxxxxxxxx, xxxxxxxxxxxxxxx, xxxxxxxxxxxx' ,
    'Marca Exemplo', 
    4.5, 
    20, 
    'img.png/teste-url-guitarra'
);

-- Buscar ProdutoS
create view vw_ExibirProdutos as
SELECT 
	p.IdProduto,p.NomeProduto,
	p.Descricao,
	p.Preco,
    p.Marca,
    p.avaliacao,
    i.UrlImagem,
    e.Disponibilidade
FROM tbProduto AS p 
INNER JOIN tbImgProduto AS ip
	ON p.IdProduto = ip.IdProduto
INNER JOIN tbImagens AS i
	ON ip.IdImagem = i.IdImagem
INNER JOIN tbEstoque AS e
	ON p.IdProduto = e.IdProduto
WHERE e.Disponibilidade = TRUE;

SELECT * FROM vw_ExibirProdutos;
SELECT * FROM TBUSUARIO;


-- drop procedure sp_GerarVenda
DELIMITER $$

CREATE PROCEDURE sp_GerarVenda(
    IN vIdUsuario INT, 
    IN vTipoPag VARCHAR(50),
    IN vIdProduto INT,
    IN vQtd INT
)
BEGIN
    DECLARE vIdVenda INT;
    DECLARE vPrecoUni DECIMAL(8,2);
    DECLARE vQtdTotal INT;
    DECLARE vValorTotal DECIMAL(8,2);
    DECLARE vQtdAtualProduto INT;
    DECLARE vQtdEstoque INT;

    -- Verifica se o produto existe e está disponível no estoque
    SELECT Preco, QtdEstoque INTO vPrecoUni, vQtdEstoque
    FROM tbProduto AS p
    INNER JOIN tbEstoque AS e ON p.IdProduto = e.IdProduto
    WHERE p.IdProduto = vIdProduto AND e.Disponibilidade = 1;

    IF vPrecoUni IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Produto não encontrado ou indisponível no estoque.';
    END IF;

    -- Ajusta a quantidade de venda para não ultrapassar o estoque
    IF vQtd > vQtdEstoque THEN
        SET vQtd = vQtdEstoque;
    END IF;

    -- Verifica se já existe uma venda aberta para este usuário e tipo de pagamento
    SELECT IdVenda INTO vIdVenda
    FROM tbVenda
    WHERE IdUsuario = vIdUsuario AND TipoPag = vTipoPag
    ORDER BY IdVenda DESC
    LIMIT 1;

    -- Se não existir venda anterior, cria uma nova com valores iniciais zero
    IF vIdVenda IS NULL THEN
        INSERT INTO tbVenda (IdUsuario, TipoPag, QtdTotal, ValorTotal)
        VALUES (vIdUsuario, vTipoPag, 0, 0);

        SET vIdVenda = LAST_INSERT_ID();
    END IF;

    -- Verifica se o produto já está na venda
    SELECT Qtd INTO vQtdAtualProduto
    FROM tbItemVenda
    WHERE IdVenda = vIdVenda AND IdProduto = vIdProduto
    LIMIT 1;

    -- Atualiza ou insere o item, respeitando o estoque
    IF vQtdAtualProduto IS NOT NULL THEN
        IF (vQtdAtualProduto + vQtd) > vQtdEstoque THEN
            SET vQtd = vQtdEstoque - vQtdAtualProduto;
        END IF;

        UPDATE tbItemVenda
        SET Qtd = Qtd + vQtd
        WHERE IdVenda = vIdVenda AND IdProduto = vIdProduto;
    ELSE
        INSERT INTO tbItemVenda (IdVenda, IdProduto, PrecoUni, Qtd)
        VALUES (vIdVenda, vIdProduto, vPrecoUni, vQtd);
    END IF;

    -- Recalcula os totais da venda
    SELECT 
        IFNULL(SUM(Qtd), 0),
        IFNULL(SUM(Qtd * PrecoUni), 0)
    INTO vQtdTotal, vValorTotal
    FROM tbItemVenda
    WHERE IdVenda = vIdVenda;

    UPDATE tbVenda
    SET QtdTotal = vQtdTotal,
        ValorTotal = vValorTotal
    WHERE IdVenda = vIdVenda;

	-- Atualiza apenas o estoque do produto vendido
	UPDATE tbEstoque
	SET QtdEstoque = QtdEstoque - vQtd
	WHERE IdProduto = vIdProduto;

	-- Atualiza a disponibilidade somente para o mesmo produto
	UPDATE tbEstoque
	SET Disponibilidade = IF(QtdEstoque = 0, 0, 1)
	WHERE IdProduto = vIdProduto;

    -- Retorna o resumo da venda
    SELECT 
        vIdVenda AS IdVenda,
        vIdUsuario AS Usuario,
        vTipoPag AS TipoPagamento,
        vQtdTotal AS QtdTotal,
        vValorTotal AS ValorTotal;

END $$

DELIMITER ;

-- Compra 1
call sp_GerarVenda(1,'Pix', 1, 13);
-- Compra 2
call sp_GerarVenda(1,'Pix', 2, 5);
-- Compra 3
call sp_GerarVenda(2, 'Cartão de Débito', 1, 7);
-- Compra 4
call sp_GerarVenda(1,'Cartão de Débito', 2 , 5);

-- Exibição de Vendas
CREATE VIEW vw_VendaDetalhada AS
SELECT 
    v.IdVenda,
    v.IdUsuario,
    u.Nome AS NomeUsuario,
    v.TipoPag,
    iv.IdProduto,
    p.NomeProduto AS NomeProduto,
    iv.PrecoUni,
    iv.Qtd AS QtdItem,
    (iv.PrecoUni * iv.Qtd) AS Subtotal
FROM tbVenda AS v
INNER JOIN tbItemVenda AS iv ON v.IdVenda = iv.IdVenda
INNER JOIN tbProduto AS p ON iv.IdProduto = p.IdProduto
INNER JOIN tbUsuario AS u ON v.IdUsuario = u.IdUsuario
ORDER BY IdVenda DESC;

select * from vw_VendaDetalhada;