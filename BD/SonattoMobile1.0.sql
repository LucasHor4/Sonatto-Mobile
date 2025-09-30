-- drop database dbSonattoMobile;
create database dbSonattoMobile;
use dbSonattoMobile;

create table tbProduto(
IdProduto int primary key not null auto_increment,
NomeProduto varchar(100) not null,
Preco decimal(8,2) not null check(Preco>0),
Descricao varchar(100) not null,
ImagemURL varchar(255) not null
);

insert into tbProduto(NomeProduto, Preco, Descricao, ImagemURL) value ('Teste', 123.45,'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa', 'teste.png');