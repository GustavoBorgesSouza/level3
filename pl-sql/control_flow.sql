CREATE TABLE TABELA1 (
    COL1 VARCHAR2(18)
);

INSERT INTO TABELA1 VALUES (
    'Campo com 18 bytes'
);

SET SERVEROUTPUT ON

DECLARE
    V_COL1 VARCHAR2(18);
BEGIN
    SELECT
        COL1 INTO V_COL1
    FROM
        TABELA1;
    DBMS_OUTPUT.PUT_LINE ('Valor = ' || V_COL1);
END;
/   


TRUNCATE TABLE tabela1;

ALTER TABLE tabela1
MODIFY col1 VARCHAR2(30);

INSERT INTO tabela1
    VALUES ('Tamanho alterado para 30 bytes');

SET SERVEROUTPUT ON

DECLARE
    v_col1 VARCHAR2(18);
BEGIN
    SELECT col1 INTO v_col1
    FROM tabela1;
    DBMS_OUTPUT.PUT_LINE ('Valor = ' || v_col1);
END;
/

-- ORA-06502: PL/SQL: numeric or value error: character string buffer too small
-- ORA-06512: at line 4
-- v_col1 é varchar(18) e a coluna é varchar(30)

--  % TYPE usa o tipo da tabela para o tipo da variável

DECLARE
    v_col1 tabela1.col1%TYPE;
BEGIN
    SELECT col1 INTO v_col1
    FROM tabela1;
    DBMS_OUTPUT.PUT_LINE ('Valor = ' || v_col1);
END;


SET SERVEROUTPUT ON
DECLARE 
    v_col1 TABELA1.COL1%TYPE;
    v_tamanho NUMBER(3);
BEGIN
    SELECT LENGTH(COL1), COL1 INTO v_tamanho, v_col1
    FROM TABELA1;

    IF v_tamanho > 25 THEN
        DBMS_OUTPUT.PUT_LINE( 'Texto = ' || v_col1);
    ELSE
        DBMS_OUTPUT.PUT_LINE('Texto menor ou igual a 25');
    END IF;
END;
/

SET SERVEROUTPUT ON
DECLARE 
    v_col1 TABELA1.COL1%TYPE;
    v_tamanho NUMBER(3);
BEGIN
    SELECT LENGTH(COL1), COL1 INTO v_tamanho, v_col1
    FROM TABELA1;

    IF v_tamanho > 25 THEN
        DBMS_OUTPUT.PUT_LINE( 'Texto = ' || v_col1);
    ELSIF v_tamanho > 20 THEN
        DBMS_OUTPUT.PUT_LINE('Texto maior que 20');
    ELSIF v_tamanho > 15 THEN
        DBMS_OUTPUT.PUT_LINE('Texto maior que 15');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Texto menor ou igual a 15');
    END IF;
END;    
/

--  AND OR

DECLARE 
    v_tamanho NUMBER(3);
BEGIN
    SELECT LENGTH(COL1) INTO v_tamanho
    FROM TABELA1;

    IF v_tamanho > 25 AND TO_CHAR(SYSDATE, 'YYYY') > 1999 THEN
    DBMS_OUTPUT.PUT_LINE('Maior que 25 e século 21 ou mais');
    END IF;
END;
/

DECLARE 
    v_tamanho NUMBER(3);
BEGIN
    SELECT LENGTH(COL1) INTO v_tamanho
    FROM TABELA1;

    IF v_tamanho > 25 OR TO_CHAR(SYSDATE, 'YYYY') > 1999 THEN
    DBMS_OUTPUT.PUT_LINE('Maior que 25 OU século 21 ou mais');
    END IF;
END;
/

--  ESTRUTURAS DE REPETIÇAO
-- LOOP BASICO, FOR E WHILE

-- BASICO
-- LOOP                                  
--  conjunto de instruções;
--   EXIT [WHEN condição]; 
-- END LOOP;

DECLARE
    v_contador NUMBER(2) :=1; 
BEGIN   
    LOOP
        INSERT INTO tabela1
        VALUES ('Inserindo texto numero ' || v_contador);
        v_contador := v_contador + 1;   
    EXIT WHEN v_contador > 10;   
    END LOOP;
END;
/

-- FOR
-- FOR contador in [REVERSE] limite_inferior..limite_superior LOOP  
--   conjunto de instruções;
--   . . .
-- END LOOP;

BEGIN
    FOR i IN 1..10 LOOP
        INSERT INTO TABELA1
        VALUES ('Inserindo texto numero' || i);
    END LOOP;
END;
/

--  WHILE
-- WHILE condição LOOP
--   conjunto de instruções;
--     . . .
-- END LOOP;

DECLARE
    v_contador NUMBER(2) :=1; 
BEGIN   
    WHILE v_contador <= 10 LOOP
        INSERT INTO tabela1
        VALUES ('Inserindo texto numero ' || v_contador);
        v_contador := v_contador + 1;   
    END LOOP;
END;
/

-- nested loops

BEGIN   
    FOR i IN 1..3 LOOP
        FOR j IN 1..5 LOOP
            INSERT INTO tabela1
            VALUES ('Inserindo texto numero ' || i || j);
        END LOOP;
    END LOOP;
END;
/

SELECT * FROM TABELA1;