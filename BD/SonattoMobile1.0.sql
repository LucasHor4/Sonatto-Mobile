-- drop database dbSonattoMobile;
create database dbSonattoMobile;
use dbSonattoMobile;

create table tbProduto(
idProduto int primary key not null auto_increment,
NomeProduto varchar(100) not null,
Preco decimal(8,2) not null check(Preco>0),
Descricao varchar(100) not null,
ImagemURL varchar(255) not null
);

insert into tbProduto(NomeProduto, Preco, Descricao, ImagemURL) value ('Teste', 123.45,'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa', 'teste.png');
insert into tbProduto(NomeProduto, Preco, Descricao, ImagemURL) value ('Palheta', 15.99,'Palha + etanol = Palheta.', 'teste.png');
insert into tbProduto(NomeProduto, Preco, Descricao, ImagemURL) value ('Bateria', 400.00,'Tu dum paa.', 'teste.png');
insert into tbProduto(NomeProduto, Preco, Descricao, ImagemURL) value ('Guitarra', 490.20,'Dammmm.', 'teste.png');
insert into tbProduto(NomeProduto, Preco, Descricao, ImagemURL) value ('Microfone', 200.20,'Yoooooooo.', 'teste.png');