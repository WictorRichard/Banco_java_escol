create database escol;

use escol;
drop database escol;	
create table aluno (
id bigint not null primary key,
nome VARCHAR (255) NOT NULL,
cpf VARCHAR (255) NOT NULL UNIQUE
);

create user 'Wictor'@'localhost' identified by '4Wictor';
grant select,delete,insert,drop,update,alter on escol.aluno to Wictor;

insert into aluno (id,nome,cpf) values (1,'lucas','7777');
update aluno set nome = 'WICTOR RICHARD',cpf =51115 where id = 1;
select * from aluno;

