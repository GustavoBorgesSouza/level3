-- PONTOS DE ATENCAO durante a utilização de subconsultas:

-- A  condição  envolve  uma  operação  de  comparação  entre  uma  coluna  e  o resultado  que  será  retornado  pela  subconsulta.  A  subconsulta  pode  ser construída de acordo com o problema apontado e incluir condições, funções de grupo, várias colunas etc.

-- A subconsulta (consulta interna) é executada antes da consulta principal.

-- A  subconsulta  pode  ser  incluída  nas  instruções  WHERE,HAVING  ou FROM.

-- O operador deve ser adequado ao tipo de retorno da subconsulta, uma vez que o retorno pode ser de uma única linha ou de várias linhas.




-- TIPOS

-- Subconsulta  de  uma  única  linha:são  consultas  que  retornam  somente uma linha da instrução SELECT interna.
-- Nesse tipo de subconsullta são utilizados os operadores relacionais de comparacão = > <> <= ....

-- EXEMPLO – SUBCONSULTA DE UMA ÚNICA LINHA
SELECT NM_FUNCIONARIO,
VL_SALARIO_MENSAL
FROM T_SIP_FUNCIONARIO 
WHERE VL_SALARIO_MENSAL > (
                            SELECT VL_SALARIO_MENSAL
                            FROM T_SIP_FUNCIONARIO 
                            WHERE NR_MATRICULA = 12348
                            );

-- EXEMPLO – SUBCONSULTA DE UMA ÚNICA LINHA,
-- COM FUNÇÕES DE GRUPO
SELECT F.NM_FUNCIONARIO,
F.VL_SALARIO_MENSAL
FROM T_SIP_FUNCIONARIO F
WHERE F.VL_SALARIO_MENSAL < (
                            SELECT AVG(F.VL_SALARIO_MENSAL)
                            FROM T_SIP_FUNCIONARIO F
                            );


-- EXEMPLO – SUBCONSULTA DE UMA ÚNICA LINHA,
-- COM AGRUPAMENTO, FUNÇÕES DE GRUPO E HAVING
SELECT CD_DEPTO,
    MIN(VL_SALARIO_MENSAL)
FROM T_SIP_FUNCIONARIO 
    GROUP BY CD_DEPTO
    HAVING MIN(VL_SALARIO_MENSAL) > (
                                    SELECT MIN(VL_SALARIO_MENSAL)
                                    FROM T_SIP_FUNCIONARIO 
                                    WHERE CD_DEPTO = 3 
                                    );

-- EXEMPLO – SUBCONSULTA DE UMA ÚNICA LINHA,
-- COM CLÁUSULA FROM
SELECT F.NR_MATRICULA ,
        F.NM_FUNCIONARIO , 
        F.DT_ADMISSAO  , 
        RESFUNC.QTDEALOCACAO
FROM   T_SIP_FUNCIONARIO F , 
                        (
                        SELECT  NR_MATRICULA , 
                        COUNT(NR_MATRICULA) QTDEALOCACAO
                        FROM  T_SIP_IMPLANTACAO  
                        GROUP BY  NR_MATRICULA                                  
                        )  RESFUNC                               
WHERE F.NR_MATRICULA = RESFUNC.NR_MATRICULA;



-- MULTI LINES AND COLUMNS SUBQUERIES
-- Subconsulta de várias linhas:são consultas que retornam mais de uma linha de instrução SELECT interna.
-- Subconsulta de várias colunas: são consultas que retornam mais de uma coluna da instrução SELECT interna.


-- Nesse tipo de subconsullta são utilizados os operadores de conjuntos: IN, NOT IN, ANY, ALL

-- EXEMPLO – SUBCONSULTA COM VÁRIAS LINHAS,
-- COM OPERADOR IN
SELECT CD_IMPLANTACAO ,
        CD_PROJETO     , 
        NR_MATRICULA "FUNCIONARIO"
FROM T_SIP_IMPLANTACAO 
WHERE CD_PROJETO IN
            (
            SELECT CD_PROJETO
            FROM T_SIP_PROJETO 
            WHERE TO_CHAR(DT_INICIO,'MM/YYYY') IN('04/2012','10/2013')
            );


-- EXEMPLO – SUBCONSULTA COM VÁRIAS LINHAS,
-- COM OPERADOR NOT IN
SELECT CD_IMPLANTACAO ,
        CD_PROJETO     , 
        NR_MATRICULA "FUNCIONARIO"
FROM T_SIP_IMPLANTACAO 
WHERE CD_PROJETO NOT IN
            (
            SELECT CD_PROJETO
            FROM T_SIP_PROJETO 
            WHERE TO_CHAR(DT_INICIO,'MM/YYYY') IN('04/2012','10/2013')
            );


-- ANY é usado para comparar um valor com qualquer valor presente em uma lista. Devemos colocar um operador =, <>, <, >, <= ou >= antes de ANY na instrução SQL
-- EXEMPLO – SUBCONSULTA COM VÁRIAS LINHAS,
-- COM OPERADOR ANY
SELECT NR_MATRICULA   , 
        NM_FUNCIONARIO , 
        VL_SALARIO_MENSAL
FROM T_SIP_FUNCIONARIO 
WHERE VL_SALARIO_MENSAL < ANY 
                        (
                        SELECT AVG(VL_SALARIO_MENSAL)
                        FROM T_SIP_FUNCIONARIO 
                        GROUP BY CD_DEPTO
                        );


-- EXEMPLO – SUBCONSULTA COM VÁRIAS LINHAS,
-- COM OPERADOR ALL
SELECT NR_MATRICULA   , 
        NM_FUNCIONARIO , 
        VL_SALARIO_MENSAL
FROM T_SIP_FUNCIONARIO 
WHERE VL_SALARIO_MENSAL > ALL 
                        (
                        SELECT AVG(VL_SALARIO_MENSAL)
                        FROM T_SIP_FUNCIONARIO 
                        GROUP BY CD_DEPTO
                        );



-- 
-- 
-- CORRELATED SUBQUERIES
-- É uma subconsulta que referencia uma ou mais colunas na instrução SQL externa (utilizam as mesmas colunas).

-- Nesse tipo de subconsullta são utilizados os operadores de conjuntos: EXISTS, NOT EXISTS

-- EXEMPLO – SUBCONSULTA CORRELACIONADA,
-- COM EXISTS
SELECT F.NR_MATRICULA,
        F.NM_FUNCIONARIO
FROM T_SIP_FUNCIONARIO F
WHERE EXISTS
            (
            SELECT I.NR_MATRICULA
            FROM T_SIP_IMPLANTACAO I
            WHERE F.NR_MATRICULA = I.NR_MATRICULA
            );

-- EXEMPLO – SUBCONSULTA CORRELACIONADA,
-- COM NOT EXISTS
SELECT  F.NR_MATRICULA,
        F.NM_FUNCIONARIO
FROM T_SIP_FUNCIONARIO F
WHERE NOT EXISTS
        (
        SELECT I.NR_MATRICULA
        FROM T_SIP_IMPLANTACAO I
        WHERE F.NR_MATRICULA=I.NR_MATRICULA
        );


-- SUBQUERIES TO CREATRE TABLES 
-- 

-- EXEMPLO – SUBCONSULTA PARA CRIAR TABELAS
DROP TABLE T_TESTE_AULA_ON;

CREATE TABLE T_TESTE_AULA_ON AS 
    SELECT * FROM T_SIP_IMPLANTACAO;

SELECT * FROM T_TESTE_AULA_ON;