-- SELECT [ coluna, ] funçao_de_grupo (coluna)
--    FROM tabela
-- [ WHERE condição ]
--    [ GROUP BY coluna ]
--      [ HAVING condiçao ]
--   [  ORDER BY coluna [, coluna, ...]

-- A clausula GROUP BY deve vir antes do ORDER BY e APÓS o WHERE.A lista de colunas que se quer agrupar deve corresponder %C3%A0 mesma sequ%C3%AAncia da cl%C3%A1usula GROUP BY. 

-- FUNÇÕES DE GRUPO 
-- COUNT() 	Retorna número de linhas afetadas pelo comando.
--  COUNT:
-- COUNT(*) -> num de linhas/registros da tablea. inclui duplicadas e nulas
-- COUNT(coluna) -> num de linhas não nulas da coluna

-- EXEMPLO – FUNÇÃO COUNT (*)
SELECT COUNT(*) FROM T_SIP_DEPARTAMENTO;
-- EXEMPLO – FUNÇÃO COUNT (coluna)
SELECT COUNT(DT_TERMINO) FROM T_SIP_PROJETO;

-- EXEMPLO – FUNÇÃO COUNT (*) e validação de NULO
SELECT COUNT(CD_PROJETO)
  FROM T_SIP_PROJETO
 WHERE DT_TERMINO IS NOT NULL;

-- DISTINCT = no duplicates
-- EXEMPLO – FUNÇÃO COUNT (coluna) e cláusula DISTINCT
SELECT COUNT(DISTINCT CD_PROJETO)
  FROM T_SIP_IMPLANTACAO ;

-- SUM() 	Retorna a somatória do valor das colunas especificadas.
-- EXEMPLO – FUNÇÃO SUM (coluna) 
SELECT SUM(VL_SALARIO_MENSAL) FROM T_SIP_FUNCIONARIO;

-- AVG() 	Retorna a média aritimética dos valores das colunas.
-- EXEMPLO – FUNÇÃO AVG (coluna) 
SELECT AVG(VL_SALARIO_MENSAL) FROM T_SIP_FUNCIONARIO;

-- MIN() 	Retorna o menor valor da coluna de um grupo de linhas.
-- EXEMPLO – FUNÇÃO MIN (coluna) 
SELECT MIN(VL_SALARIO_MENSAL) FROM T_SIP_FUNCIONARIO;

-- MAX() 	Retorna o maior valor da coluna de um grupo de linhas.
-- EXEMPLO – FUNÇÃO MAX (coluna) 
SELECT MAX(VL_SALARIO_MENSAL) FROM T_SIP_FUNCIONARIO;

-- STDDEV() 	Retorna o desvio padrão da coluna.\
-- EXEMPLO – FUNÇÃO STDDEV (coluna) 
SELECT STDDEV(VL_SALARIO_MENSAL) FROM T_SIP_FUNCIONARIO;

-- VARIANCE() 	Retorna a variância da coluna.
-- EXEMPLO – FUNÇÃO VARIANCE (coluna) 
SELECT VARIANCE(VL_SALARIO_MENSAL) FROM T_SIP_FUNCIONARIO;



-- GROUP BY

-- EXEMPLO – GROUP BY 
SELECT NR_MATRICULA, NM_DEPENDENTE,
       COUNT(CD_DEPENDENTE) "QTDE. DEPENDENTES"
  FROM T_SIP_DEPENDENTE
    GROUP BY NR_MATRICULA, NM_DEPENDENTE;

-- EXEMPLO – GROUP BY COM FUNÇÃO DE GRUPO
  SELECT CD_DEPTO,
   COUNT(NR_MATRICULA) "QTDE. FUNCIONARIOS NO DEPTO",
   SUM(VL_SALARIO_MENSAL) "TOTAL SALARIO POR DEPTO",
   ROUND(AVG(VL_SALARIO_MENSAL),2) "MEDIA SALARIAL POR DEPTO"
    FROM T_SIP_FUNCIONARIO
GROUP BY CD_DEPTO
ORDER BY CD_DEPTO;

-- EXEMPLO – GROUP BY COM VÁRIAS TABELAS
SELECT F.NM_FUNCIONARIO       "FUNCIONARIO" ,
       D.NR_MATRICULA         "MATRICULA"   , 
       COUNT(D.NR_MATRICULA)  "QTDE. DEPENDENTES"
  FROM T_SIP_FUNCIONARIO F INNER JOIN T_SIP_DEPENDENTE D
       ON (F.NR_MATRICULA = D.NR_MATRICULA)
    GROUP BY F.NM_FUNCIONARIO, D.NR_MATRICULA;


-- EXEMPLO – GROUP BY COM HAVING
  SELECT CD_DEPTO,
   COUNT(NR_MATRICULA) "QTDE. FUNCIONARIO NO DEPTO",
   SUM(VL_SALARIO_MENSAL) "TOTAL SALARIO POR DEPTO",
   ROUND(AVG(VL_SALARIO_MENSAL),2) "MEDIA SALARIAL POR DEPTO"
    FROM T_SIP_FUNCIONARIO
GROUP BY CD_DEPTO
HAVING   SUM(VL_SALARIO_MENSAL) > 10000;
-- WHERE NÃO PODE SER USADO COM FUNÇÕES DE GRUPO. TEM QUE SER HAVING

-- CASE CONDITIONALS    

-- CASE 
--      WHEN <CONDIÇÃO 1> THEN <VALOR 1>
--      WHEN <CONDIÇÃO 2> THEN <VALOR 2>
--      WHEN <CONDIÇÃO 3> THEN <VALOR 3>
--      .
--      .
--      .
--      ELSE <VALOR 4>
-- END

-- EXEMPLO – INSTRUÇÃO CASE
SELECT
        NM_PROJETO,
        DT_TERMINO,
CASE
  WHEN DT_TERMINO IS NULL THEN 'EM ANDAMENTO'
  ELSE 'FINALIZADO'
END STATUS_PROJETO
  FROM T_SIP_PROJETO
ORDER BY NM_PROJETO;