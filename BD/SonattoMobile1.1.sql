drop database dbSonattoMobile;
create database dbSonattoMobile;
use dbSonattoMobile;

create table tbProduto(
idProduto int primary key not null auto_increment,
NomeProduto varchar(100) not null,
MarcaProduto varchar(100) not null,
Preco decimal(8,2) not null check(Preco>0),
Descricao varchar(100) not null,
ImagemURL varchar(255) not null
);

insert into tbProduto(NomeProduto, MarcaProduto, Preco, Descricao, ImagemURL) value ('Teste', 'Marca teste', 123.45,'Teste de arma', 'teste.png');
insert into tbProduto(NomeProduto, MarcaProduto, Preco, Descricao, ImagemURL) value ('Palheta', 'Marca teste1', 15.99,'Palha + planeta = Palheta.', 'teste.png');
insert into tbProduto(NomeProduto, MarcaProduto, Preco, Descricao, ImagemURL) value ('Bateria', 'Marca teste2', 400.00,'Tu dum paa.', 'teste.png');
insert into tbProduto(NomeProduto, MarcaProduto, Preco, Descricao, ImagemURL) value ('Guitarra', 'Marca teste3', 490.20,'Dammmm.', 'teste.png');
insert into tbProduto(NomeProduto, MarcaProduto, Preco, Descricao, ImagemURL) value ('Microfone', 'Marca teste4', 200.20,'Yoooooooo.', 'teste.png');