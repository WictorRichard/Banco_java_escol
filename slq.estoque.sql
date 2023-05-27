CREATE DATABASE estoque1;
use estoque1;

CREATE TABLE produto(
id_produto INT(11)  NOT NULL AUTO_INCREMENT,
`status` CHAR(1) NOT NULL DEFAULT 'A',
descricao VARCHAR(50) NULL DEFAULT NULL,
estoque_minimo INT(11) NULL DEFAULT NULL,
estoque_maximo INT(11) NULL DEFAULT NULL,
PRIMARY KEY(id_produto));

CREATE TABLE entrada_produto(
id_entrada INT(11) NOT NULL AUTO_INCREMENT,
id_produto INT(11) NULL DEFAULT NULL,
quantidade INT(11) NULL DEFAULT NULL,
valor_unitario  DECIMAL(9,2) NULL DEFAULT '0.00',
data_entrada DATE NULL DEFAULT NULL,
PRIMARY KEY(id_entrada));


CREATE TABLE estoque(
id_estoque INT(11) NOT NULL AUTO_INCREMENT,
id_produto INT(11) NULL DEFAULT NULL,
quantidade INT(11) NULL DEFAULT NULL,
valor_unitario DECIMAL(9,2) NULL DEFAULT  '0.00',
PRIMARY KEY(id_estoque));


CREATE TABLE saida_produto(
id_saida INT(11) NOT NULL AUTO_INCREMENT,
id_produto INT(11) NULL DEFAULT NULL,
quantidade INT(11) NULL DEFAULT NULL,
data_saida DATE NULL DEFAULT NULL,
valor_unitario DECIMAL(9,2) NULL DEFAULT '0.00',
PRIMARY KEY(id_saida));

DELIMITER //
CREATE PROCEDURE SP_AtualizarEstoque(id_prod int ,quantidade_comprada int,valor_uni DECIMAL(9,2))

BEGIN

DECLARE contador INT(11);

SELECT COUNT(*) INTO contador FROM estoque WHERE id_produto = id_prod;

IF contador > 0  THEN

 UPDATE estoque SET quantidade=quantidade + quantidade_comprada,valor_unitario = valor_uni WHERE id_produto = id_prod;
 
 ELSE
 
 INSERT INTO estoque(id_produto,quantiade,valor_unitario) VALUES (id_prod,quantidade_comprada,valor_uni);
 
 END IF;
 
 END // 
 DELIMITER ;
 
 
 DELIMITER //
 
 CREATE TRIGGER TRG_EntradaProduto_AI AFTER INSERT ON entrada_produto
 FOR EACH ROW
 
 BEGIN
 CALL SP_AtualizaEstoque(new.id_produto,new.quantidade,new.valor_unitario);
 END //
 
 DELIMITER ;
 
 
 DELIMITER //
CREATE TRIGGER TRG_EntradaProduto_AU AFTER UPDATE ON entrada_produto

FOR EACH ROW

BEGIN
      CALL SP_AtualizaEstoque (new.id_produto, new.quantidade - old.quantidade, new.valor_unitario);
END //

DELIMITER ;


DELIMITER //
CREATE TRIGGER TRG_SaidaProduto_AI AFTER INSERT ON saida_produto

FOR EACH ROW

BEGIN
      CALL SP_AtualizaEstoque (new.id_produto, new.quantidade * -1, new.valor_unitario);
END //

DELIMITER ;


DELIMITER //

CREATE TRIGGER TRG_SaidaProduto_AU AFTER UPDATE ON saida_produto

FOR EACH ROW

BEGIN
      CALL SP_AtualizaEstoque (new.id_produto, old.quantidade - new.quantidade, new.valor_unitario);
END //

DELIMITER ;


DELIMITER //
CREATE TRIGGER TRG_SaidaProduto_AD AFTER DELETE ON saida_produto

FOR EACH ROW

BEGIN
      CALL SP_AtualizaEstoque (old.id_produto, old.quantidade, old.valor_unitario);
END //

DELIMITER ;

drop database estoque1;








