DROP database IF EXISTS db_sistemaChamados;

CREATE database IF NOT EXISTS db_sistemaChamados;

USE db_sistemaChamados;

CREATE TABLE IF NOT EXISTS TB_Equipe(
	cod_equipe INT PRIMARY KEY,
    nome_equipe VARCHAR(255)
);

INSERT INTO TB_Equipe VALUES (1, "NIVEL 1");
INSERT INTO TB_Equipe VALUES (2, "NIVEL 2");

CREATE TABLE IF NOT EXISTS TB_Tecnico(
	cod_tecnico INT PRIMARY KEY,
    nome_tecnico VARCHAR(255),
    cod_equipe int,
    FOREIGN KEY (cod_equipe) REFERENCES TB_Equipe(cod_equipe)
);

INSERT INTO TB_Tecnico VALUES (1, "JOÃO", 01);
INSERT INTO TB_Tecnico VALUES (2, "CLEBER", 01);
INSERT INTO TB_Tecnico VALUES (3, "RONALDO", 02);

CREATE TABLE IF NOT EXISTS TB_Regiao(
	cod_regiao INT PRIMARY KEY,
    nome_regiao VARCHAR(255)
);

INSERT INTO TB_Regiao VALUES (1, "BARREIRINHA");
INSERT INTO TB_Regiao VALUES (2, "CAMPO COMPRIDO");
INSERT INTO TB_Regiao VALUES (3, "ÁGUA VERDE");

CREATE TABLE IF NOT EXISTS TB_Empresa(
	cod_empresa INT PRIMARY KEY,
    nome_empresa VARCHAR(255),
    cod_regiao INT,
    FOREIGN KEY (cod_regiao) REFERENCES TB_Regiao(cod_regiao)
);

INSERT INTO TB_Empresa VALUES (1, "CARTÓRIO DA BARREIRINHA", 1);
INSERT INTO TB_Empresa VALUES (2, "CONTABILIDADE CC", 2);
INSERT INTO TB_Empresa VALUES (3, "RUMO INVERSO ÁGUA VERDE", 3);

CREATE TABLE IF NOT EXISTS TB_Setor(
	cod_setor INT PRIMARY KEY,
    nome_setor VARCHAR(255)
);

INSERT INTO TB_Setor VALUES (1, "ADMINISTRATIVO");
INSERT INTO TB_Setor VALUES (2, "RECURSOS HUMANOS");
INSERT INTO TB_Setor VALUES (3, "RECEPÇÃO");

CREATE TABLE IF NOT EXISTS TB_setor_empresa(
	cod_setor INT,
    cod_empresa INT,
    FOREIGN KEY (cod_setor) REFERENCES TB_Setor(cod_setor),
    FOREIGN KEY (cod_empresa) REFERENCES TB_Empresa(cod_empresa),
    PRIMARY KEY(cod_setor, cod_empresa)
);

INSERT INTO TB_setor_empresa VALUES (1, 1);
INSERT INTO TB_setor_empresa VALUES (1, 2);
INSERT INTO TB_setor_empresa VALUES (1, 3);
INSERT INTO TB_setor_empresa VALUES (2, 1);
INSERT INTO TB_setor_empresa VALUES (2, 2);
INSERT INTO TB_setor_empresa VALUES (3, 1);

CREATE TABLE IF NOT EXISTS TB_Colaborador(
	cod_colab INT PRIMARY KEY,
    nome_colab VARCHAR(255),
    cod_setor INT,
    cod_empresa INT,
    FOREIGN KEY (cod_setor, cod_empresa) REFERENCES TB_setor_empresa(cod_setor, cod_empresa)
);


INSERT INTO TB_Colaborador VALUES (1, "RODOLFO", 02, 02);
INSERT INTO TB_Colaborador VALUES (2, "CLEVERSON", 01, 03);
INSERT INTO TB_Colaborador VALUES (3, "FERNANDA", 03, 01);
INSERT INTO TB_Colaborador VALUES (4, "RONALDO", 02, 01);

CREATE TABLE IF NOT EXISTS TB_Dispositivo(
	id_dispositivo INT PRIMARY KEY,
    tipo_dispositivo VARCHAR(255),
    cod_colab INT,
    FOREIGN KEY (cod_colab) REFERENCES TB_Colaborador(cod_colab)
);

INSERT INTO TB_Dispositivo VALUES (1, "IMPRESSORA", 1);
INSERT INTO TB_Dispositivo VALUES (2, "MOUSE", 2);
INSERT INTO TB_Dispositivo VALUES (3, "CÂMERA", 3);
INSERT INTO TB_Dispositivo VALUES (4, "COMPUTADOR", 1);

CREATE TABLE IF NOT EXISTS TB_Chamado(
	cod_chamado INT PRIMARY KEY,
    urgencia_chamado INT,
    titulo_chamado VARCHAR(255),
    status_chamado VARCHAR(255),
    dataAbertura_chamado DATE,
    descricao_chamado VARCHAR(255),
    tipo_chamado VARCHAR(255)
);

INSERT INTO TB_Chamado VALUES (1, 1, "PROBLEMA DE CÂMERA", "ABERTO","2022/05/23", "ESTOU COM PROBLEMAS PARA MOSTRAR MINHA CARA NA CÂMERA", "PROBLEMA");
INSERT INTO TB_Chamado VALUES (2, 4, "INSTALAÇÃO DE IMPRESSORA", "ABERTO", "2022/05/20", "PRECISO QUE INSTALEM A MINHA IMPRESSORA", "REQUISIÇÃO");
INSERT INTO TB_Chamado VALUES (3, 3, "TROCA DE MOUSE", "FECHADO", "2022/03/18", "PRECISO TROCAR DE MOUSE, ESSE TÁ RUIM", "PROBLEMA");
INSERT INTO TB_Chamado VALUES (4, 5, "MEU PC NÃO LIGA", "ABERTO", "2022/05/25", "MEU PC DEU TELA AZUL E AGORA NÃO LIGA :C", "PROBLEMA");

CREATE TABLE IF NOT EXISTS TB_tecnico_chamado(
	cod_chamado INT,
    cod_tecnico INT,
    FOREIGN KEY (cod_chamado) REFERENCES TB_Chamado(cod_chamado),
    FOREIGN KEY (cod_tecnico) REFERENCES TB_Tecnico(cod_tecnico),
    PRIMARY KEY(cod_chamado, cod_tecnico)
);

INSERT INTO TB_tecnico_chamado VALUES (1, 2);
INSERT INTO TB_tecnico_chamado VALUES (2, 1);
INSERT INTO TB_tecnico_chamado VALUES (3, 3);
INSERT INTO TB_tecnico_chamado VALUES (4, 1);

CREATE TABLE IF NOT EXISTS TB_colab_chamado(
	cod_chamado INT,
    cod_colab INT,
    FOREIGN KEY (cod_chamado) REFERENCES TB_Chamado(cod_chamado),
    FOREIGN KEY (cod_colab) REFERENCES TB_Colaborador(cod_colab),
    PRIMARY KEY(cod_chamado, cod_colab)
);

INSERT INTO TB_colab_chamado VALUES (1, 3);
INSERT INTO TB_colab_chamado VALUES (2, 1);
INSERT INTO TB_colab_chamado VALUES (3, 2);
INSERT INTO TB_colab_chamado VALUES (4, 1);

# 1 - Quantos chamados foram abertos esse mês?  
select count(*) 
	from tb_chamado c
    where c.dataAbertura_chamado > curdate()-30;
    
# 2 - Quantos funcionários pertecem a quais setores por nome
select s.nome_setor, count(*)
	from tb_colaborador colab, tb_setor s
    where colab.cod_setor = s.cod_setor
    group by s.cod_setor;

# 3 – Quantas requisições foram abertas esse mês? 
select count(*)
	from tb_chamado c
    where c.dataAbertura_chamado > curdate()-30
    and c.tipo_chamado = "REQUISIÇÃO";
    

# 4 - Quantos chamados foram abertos para o setor Z?
select count(*) 
	from tb_setor s, tb_colaborador c, tb_colab_chamado cc
    where s.cod_setor = c.cod_setor
    and c.cod_colab = cc.cod_colab
    and s.cod_setor = 2;
    
# 5 - O maior tipo de chamados aberto (requisição ou problema).
select c.tipo_chamado, count(c.tipo_chamado)
	from tb_chamado c
    group by c.tipo_chamado
    limit 1;
    
# 6 – Quantos dispositivos cada colaborador coordena    
select colab.nome_colab, count(d.id_dispositivo)
	from tb_colaborador colab, tb_dispositivo d
    where d.cod_colab = colab.cod_colab
    group by colab.nome_colab;

# 7 - Quantos técnicos tem na equipe de N1?    
select e.nome_equipe, count(*)
	from tb_equipe e, tb_tecnico t
    where e.cod_equipe = t.cod_equipe
    and e.cod_equipe = 1;

# 8 - Quantos chamados estão atribuídos ao técnico X?     
select t.nome_tecnico, count(ct.cod_chamado)
	from tb_tecnico t, tb_tecnico_chamado ct
    where t.cod_tecnico = ct.cod_tecnico
    and t.nome_tecnico = 'JOÃO';
 
# 9 - Quantos chamados estão atribuídos a Equipe W?  
select count(c.cod_chamado)
	from tb_chamado c, tb_tecnico_chamado ct, tb_tecnico t
    where c.cod_chamado = ct.cod_chamado
    and t.cod_tecnico = ct.cod_tecnico
    and t.cod_equipe = 1;

# 10 - Região com a maior abertura de chamados.     
select r.nome_regiao, count(c.cod_chamado)
	from tb_chamado c, tb_colaborador colab, tb_colab_chamado cc, tb_empresa e, tb_regiao r
	where c.cod_chamado = cc.cod_chamado
	and colab.cod_colab = cc.cod_colab
	and colab.cod_empresa = e.cod_empresa
	and e.cod_regiao = r.cod_regiao
	group by r.nome_regiao
	order by count(c.cod_chamado) DESC
	limit 1;
    
# 11 - Técnico com maior número de chamados atribuidos.         
select t.nome_tecnico, count(cod_chamado)
	from tb_tecnico t,  tb_tecnico_chamado ct
    where t.cod_tecnico = ct.cod_tecnico
    group by t.nome_tecnico
    limit 1;
    
# 12 – Quantos chamados o técnico X tem aberto a mais de 4 dias?     
select t.nome_tecnico, count(c.cod_chamado)
	from tb_tecnico t, tb_chamado c, tb_tecnico_chamado ct
    where t.cod_tecnico = ct.cod_tecnico
    and c.cod_chamado = ct.cod_chamado
    and c.dataAbertura_chamado <= curdate()-4
    group by t.nome_tecnico;
# 13 - Quantos chamados estão abertos atualmente? 
select count(*)
	from tb_chamado c
    where c.status_chamado = "ABERTO";

# 14 - Quantidade de dispositivos que a empresa tem no momento.     
select e.nome_empresa, count(*)
	from tb_colaborador c, tb_dispositivo d, tb_empresa e
    where d.cod_colab = c.cod_colab
    and c.cod_empresa = e.cod_empresa
    and e.cod_empresa = 2;

# 15 – Quais chamados o Setor x abriu?  
select c.titulo_chamado, s.nome_setor
	from tb_chamado c, tb_setor s, tb_colab_chamado cc, tb_colaborador colab
    where c.cod_chamado = cc.cod_chamado
    and colab.cod_colab = cc.cod_colab
    and s.cod_setor = colab.cod_setor
    and s.nome_setor = "RECURSOS HUMANOS";
    
# 16 - Região que menos abre chamados. 
select r.nome_regiao, count(*)
	from tb_chamado c, tb_colaborador colab, tb_empresa e, tb_regiao r, tb_colab_chamado cc
    where c.cod_chamado = cc.cod_chamado
    and colab.cod_colab = cc.cod_colab
    and colab.cod_empresa = e.cod_empresa
    and e.cod_regiao = r.cod_regiao
    group by r.nome_regiao
    order by count(*) asc
    limit 1;
# 17 - Quantidade de cada chamado aberto por nível. 
select c.urgencia_chamado, count(c.urgencia_chamado)
	from tb_chamado c
    group by c.urgencia_chamado;

# 18 -  Qual a empresa com menor quantidade de setores? 
select e.nome_empresa, count(*)
	from tb_empresa e, tb_setor s, tb_setor_empresa es
    where e.cod_empresa = es.cod_empresa
    and s.cod_setor = es.cod_setor
    group by e.nome_empresa
    order by count(*) asc
    limit 1;
    
# 19 – Quantos chamados com mais de 2 dias em aberto são de nível 5 de urgencia? 
select count(*)
	from tb_chamado c
    where c.urgencia_chamado = 5
    and c.dataAbertura_chamado < curdate()-2;
    
# 20 – Quantos chamados o colaborador V abriu? 
select colab.nome_colab, count(*)
	from tb_chamado c, tb_colaborador colab, tb_colab_chamado cc
    where c.cod_chamado = cc.cod_chamado
    and colab.cod_colab = cc.cod_colab
    and colab.nome_colab = "FERNANDA";

