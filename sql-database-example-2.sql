-- INIT database
CREATE TABLE Produto (
  Id_Produto INT,
  Nome VARCHAR(100),
  Cor VARCHAR(50),
  Tamanho VARCHAR(255),
  PRIMARY KEY(Id_Produto)
);

CREATE TABLE Periodo (
  Data Date,
  Dia INT,
  Mes VARCHAR(50),
  Ano INT,
  Dia_Semana VARCHAR(50),
  PRIMARY KEY(Data)
);

CREATE TABLE Cliente (
  Id_Cliente INT,
  Nome VARCHAR(100),
  Endereco VARCHAR(255),
  Data_Nascimento Date,
  PRIMARY KEY(Id_Cliente)
);

CREATE TABLE Venda (
  Id_Produto INT,
  Data Date,
  Id_Cliente INT,
  Quantidade INT,
  Valor_Unitario DECIMAL(10,2),
  PRIMARY KEY(Id_Produto, Data, Id_Cliente),
  FOREIGN KEY(Id_Produto) REFERENCES Produto(Id_Produto),
  FOREIGN KEY(Data) REFERENCES Periodo(Data),
  FOREIGN KEY(Id_Cliente) REFERENCES Cliente(Id_Cliente)
);

-- Produto
INSERT INTO Produto(Id_Produto, Nome, Cor, Tamanho) VALUES (100, "Camisa", "Vermelha", "GG");
INSERT INTO Produto(Id_Produto, Nome, Cor, Tamanho) VALUES (200, "Calca", "Verde", "G");
INSERT INTO Produto(Id_Produto, Nome, Cor, Tamanho) VALUES (300, "Bone", "Vermelha", "M");

-- Periodo
INSERT INTO Periodo(Data, Dia, Mes, Ano, Dia_Semana) VALUES ("2008-04-25", 25, "Abril", 2008, "Terca-feira");
INSERT INTO Periodo(Data, Dia, Mes, Ano, Dia_Semana) VALUES ("2008-06-27", 27, "Junho", 2008, "Terca-feira");
INSERT INTO Periodo(Data, Dia, Mes, Ano, Dia_Semana) VALUES ("2009-04-25", 25, "Abril", 2009, "Quarta-feira");

-- Cliente
INSERT INTO Cliente(Id_Cliente, Nome, Endereco, Data_Nascimento) VALUES (10, "Tupanzinho", "Rua Fulano, 358, Madalena", "1967-03-24");
INSERT INTO Cliente(Id_Cliente, Nome, Endereco, Data_Nascimento) VALUES (20, "Didi", "Rua Cicrano, 358, Torre", "1977-03-24");
INSERT INTO Cliente(Id_Cliente, Nome, Endereco, Data_Nascimento) VALUES (30, "Garrincha", "Rua Beltrano, 358, Caxanga", "1987-03-24");

-- Venda
INSERT INTO Venda(Id_Produto, Data, Id_Cliente, Quantidade, Valor_Unitario) VALUES (100, "2008-04-25", 10, 50, 4.50);
INSERT INTO Venda(Id_Produto, Data, Id_Cliente, Quantidade, Valor_Unitario) VALUES (200, "2008-06-27", 20, 60, 5.50);
INSERT INTO Venda(Id_Produto, Data, Id_Cliente, Quantidade, Valor_Unitario) VALUES (300, "2009-04-25", 30, 50, 8.50);

/* Consulta 1 - Dia da semana com o maior valor total de vendas no ano de 2008 */
SELECT P.Dia
FROM Periodo P
JOIN Venda V
ON P.Data = V.Data
WHERE V.Data REGEXP "^2008" AND (V.Quantidade * V.Valor_Unitario) = (SELECT MAX(V.Quantidade * V.Valor_Unitario)
                                                                     FROM Venda V
                                                                     WHERE V.Data REGEXP "^2008");

/* Consulta 2 - Nomes dos clientes que já compraram produtos da cor “Vermelha” com tamanhos distintos */
SELECT C.Nome FROM Cliente C
JOIN (SELECT DISTINCT P.Tamanho, V.Id_Cliente FROM Produto P
      JOIN Venda V
      ON P.Id_Produto = V.Id_Produto
      WHERE P.Cor = "Vermelha") AS VP
ON C.Id_Cliente = VP.Id_Cliente;