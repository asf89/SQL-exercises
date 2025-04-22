-- INIT database
CREATE TABLE departamento (
  id_depto INT,
  nome_depto VARCHAR(100),
  PRIMARY KEY(id_depto)
);

CREATE TABLE projeto (
  id_proj INT,
  nome_proj VARCHAR(100),
  local_proj VARCHAR(100),
  id_depto INT,
  PRIMARY KEY(id_proj),
  FOREIGN KEY(id_depto) REFERENCES departamento(id_depto)  
);

CREATE TABLE empregado (
  matricula INT,
  nome VARCHAR(100),
  endereco VARCHAR(100),
  sexo VARCHAR(1),
  data_nasc DATE,
  salario DECIMAL(10,2),
  id_depto INT,
  PRIMARY KEY(matricula),
  FOREIGN KEY(id_depto) REFERENCES departamento(id_depto) 
);

CREATE TABLE especializacao (
  id_esp INT,
  nome_esp VARCHAR(100),
  tipo_esp VARCHAR(100),
  PRIMARY KEY(id_esp)
);

CREATE TABLE gerencia (
  id_depto INT,
  matricula INT,
  data DATE,
  CONSTRAINT pk_gerencia PRIMARY KEY(id_depto, matricula, data),
  FOREIGN KEY(id_depto) REFERENCES departamento(id_depto),
  FOREIGN KEY(matricula) REFERENCES empregado(matricula)
);

CREATE TABLE trabalha (
  matricula INT,
  id_proj INT,
  mes VARCHAR(50),
  horas INT,
  CONSTRAINT pk_trabalha PRIMARY KEY(matricula, id_proj, mes),
  FOREIGN KEY(matricula) REFERENCES empregado(matricula),
  FOREIGN KEY(id_proj) REFERENCES projeto(id_proj)
);

CREATE TABLE possui (
  matricula INT,
  id_esp INT,
  CONSTRAINT pk_possui PRIMARY KEY(matricula, id_esp),
  FOREIGN KEY(matricula) REFERENCES empregado(matricula),
  FOREIGN KEY(id_esp) REFERENCES especializacao(id_esp)
);

-- Table departamento
INSERT INTO departamento(id_depto, nome_depto) VALUES (101, "informatica");
INSERT INTO departamento(id_depto, nome_depto) VALUES (420, "biologia");
INSERT INTO departamento(id_depto, nome_depto) VALUES (130, "direito");

-- Table projeto
INSERT INTO projeto(id_proj, nome_proj, local_proj, id_depto) VALUES (678, "Nemesis", "Rio de Janeiro", 420);
INSERT INTO projeto(id_proj, nome_proj, local_proj, id_depto) VALUES (492, "Lingshan", "Rio de Janeiro", 101);
INSERT INTO projeto(id_proj, nome_proj, local_proj, id_depto) VALUES (310, "Sertao", "Sergipe", 101);

-- Table empregado
INSERT INTO empregado(matricula, nome, endereco, sexo, data_nasc, salario, id_depto) VALUES (2003, "jose da silva", "Rua Fulano, 358", "M", "1976-03-18", 7600.40, 420);
INSERT INTO empregado(matricula, nome, endereco, sexo, data_nasc, salario, id_depto) VALUES (2013, "jose da silva", "Rua Fulano, 358", "M", "1986-03-18", 9600.40, 101);
INSERT INTO empregado(matricula, nome, endereco, sexo, data_nasc, salario, id_depto) VALUES (2023, "joao paulo", "Rua Fulano, 358", "M", "1996-03-18", 3600.40, 420);
INSERT INTO empregado(matricula, nome, endereco, sexo, data_nasc, salario, id_depto) VALUES (2033, "maria candida", "Rua Cicrano, 378", "F", "1956-03-18", 6600.40, 420);

-- Table especializacao
INSERT INTO especializacao(id_esp, nome_esp, tipo_esp) VALUES (1, "Engenharia e Analise de Dados", "Ciencia de Dados");
INSERT INTO especializacao(id_esp, nome_esp, tipo_esp) VALUES (30, "Modelagem Matemática", "Matematica");
INSERT INTO especializacao(id_esp, nome_esp, tipo_esp) VALUES (20, "Engenharia Biológica", "Ciencias Biologicas");

-- Table gerencia
INSERT INTO gerencia(id_depto, matricula, data) VALUES (101, 2003, "2020-04-05");

-- Table trabalha
INSERT INTO trabalha(matricula, id_proj, mes, horas) VALUES (2003, 678, "janeiro", 50);
INSERT INTO trabalha(matricula, id_proj, mes, horas) VALUES (2013, 492, "janeiro", 80);
INSERT INTO trabalha(matricula, id_proj, mes, horas) VALUES (2023, 310, "outubro", 40);
INSERT INTO trabalha(matricula, id_proj, mes, horas) VALUES (2033, 492, "janeiro", 70);
INSERT INTO trabalha(matricula, id_proj, mes, horas) VALUES (2003, 492, "janeiro", 50);

-- Table possui
INSERT INTO possui(matricula, id_esp) VALUES (2003, 1);
INSERT INTO possui(matricula, id_esp) VALUES (2013, 30);
INSERT INTO possui(matricula, id_esp) VALUES (2023, 20);

/* Consulta 1 – Listar os nomes dos empregados e os nomes dos departamentos onde trabalham, que ganham mais do 
 que o maior salário pago a um empregado do departamento de nome igual a 'informatica' */
SELECT E.nome, D.nome_depto FROM empregado E
JOIN departamento D
ON E.id_depto = D.id_depto
WHERE E.salario > (SELECT MAX(E.salario)FROM empregado E 
                   JOIN departamento D
                   ON E.id_depto = D.id_depto
                   WHERE D.nome_depto = "informatica");

/* Consulta 2 - Listar, para cada projeto localizado no 'Rio de Janeiro', o identificador do projeto, o identificador do 
departamento que o controla e a soma das horas trabalhadas pelos empregados no projeto, no mês de janeiro. */
SELECT T.id_proj, P.id_depto, SUM(T.horas) AS horas_trabalhadas_janeiro
FROM trabalha T
JOIN projeto P
ON T.id_proj = P.id_proj
WHERE P.local_proj = "Rio de Janeiro" AND T.mes = "janeiro"
GROUP BY T.id_proj, P.id_depto;

/* Consulta 3 – Listar os identificadores de todos os projetos que envolvam um empregado cujo nome é 'jose da silva'. 
O empregado pode envolver-se no projeto como trabalhador ou como gerente do departamento que controla o projeto. 
Não deve haver repetição na resposta. */
SELECT DISTINCT T.id_proj
FROM trabalha T
JOIN (SELECT E.matricula
      FROM empregado E
      LEFT JOIN gerencia G
      ON E.matricula = G.matricula
      WHERE E.nome = "jose da silva") AS A
ON T.matricula = A.matricula;