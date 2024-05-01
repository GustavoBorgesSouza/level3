-- exception example

SET SERVEROUTPUT ON

DECLARE
   cinco NUMBER := 5;
BEGIN
  dbms_output.put_line(cinco / (cinco - cinco) );
END;
/


-- ERROR at line 1:
-- ORA-01476: divisor is equal to zero
-- ORA-06512: at line 4

--  TRATAMENTO DE EXCEPTIONS

-- EXCEPTION
-- WHEN exceção1 [OR exceção2 …] THEN
--   comando1;
--   comando2;
--   …
-- [WHEN exceção3 [OR exceção4 …] THEN
--   comando1;
--   comando2;
--   …]
-- [WHEN OTHERS THEN
--   comando1;
--   comando2;
--   …]

SET SERVEROUTPUT ON

DECLARE
    cinco   NUMBER := 5;
BEGIN
    dbms_output.put_line(cinco / (cinco - cinco) );
EXCEPTION
    WHEN zero_divide THEN
        dbms_output.put_line('Divisao por zero');
    WHEN OTHERS THEN
        dbms_output.put_line('Erro imprevisto');
END;
/

-- sending errors to table
CREATE TABLE erros(   
    usuario  VARCHAR2(30),
    data     DATE,
    cod_erro NUMBER,
    msg_erro VARCHAR2(100)
);

SET SERVEROUTPUT ON

DECLARE
    cod   erros.cod_erro%TYPE;
    msg   erros.msg_erro%TYPE;    
    cinco NUMBER := 5; 
BEGIN    
    DBMS_OUTPUT.PUT_LINE (cinco / ( cinco - cinco )); 
EXCEPTION    
    WHEN ZERO_DIVIDE THEN
        cod := SQLCODE;
        msg := SUBSTR(SQLERRM, 1, 100);
        insert into erros values (USER, SYSDATE, cod, msg);    
    WHEN OTHERS THEN         
        DBMS_OUTPUT.PUT_LINE ('Erro imprevisto');
END;
/

SELECT * FROM erros;

-- CREATING YOUR EXCEPTIONS
DECLARE
    e_meu_erro EXCEPTION;
    emprec   emp%rowtype;

    CURSOR cursor_emp IS 
        SELECT empno,ename  
        FROM emp
        WHERE empno = 1111;
BEGIN
    OPEN cursor_emp;
    LOOP
        FETCH cursor_emp 
        INTO emprec.deptno,emprec.sal;
        IF cursor_emp%notfound THEN
            RAISE e_meu_erro;
        END IF;
        dbms_output.put_line('Codigo : ' || emprec.empno);
        dbms_output.put_line('Nome   : ' || emprec.ename);
        EXIT WHEN cursor_emp%notfound;
    END LOOP;
EXCEPTION
    WHEN e_meu_erro THEN
        dbms_output.put_line('Codigo nao cadastrado');
        ROLLBACK;
END;
/

-- ""OVERRIDE"" ORACLE EXCEPTION    
-- PRAGMA EXCEPTION_INIT(nome_exceção, código_Oracle_erro);
-- /

DECLARE
    e_meu_erro EXCEPTION;
    PRAGMA exception_init ( e_meu_erro,-2292 );
BEGIN
    DELETE FROM dept
    WHERE deptno = 10;
    COMMIT;
EXCEPTION
    WHEN e_meu_erro THEN
        dbms_output.put_line('Integridade Referencial Violada');
        ROLLBACK;
END;
/

-- RAISE_APPLICATION_ERROR (numero_erro,	mensagem [, {TRUE | FALSE}]);
-- número_erro é um número especificado pelo usuário para a exceção entre -20000 e -20999.

-- mensagem é a mensagem especificada pelo usuario para a exceçao. Trata-se de uma string de caracte-
-- res com até 2.048 bytes.

-- TRUE | FALSE é um parâmetro Booleano opcional (Se TRUE, o erro sera colocado na pilha de erros ante-
-- riores. Se FALSE, o default, o erro substituirá todos os erros anteriores.)

-- O procedimento RAISE_APPLICATION_ERROR pode ser usado tanto na seção de exceção quanto na se-
-- ção executável.

DECLARE
    cinco   NUMBER := 5;
BEGIN
    dbms_output.put_line(cinco / (cinco - cinco) );
EXCEPTION
    WHEN zero_divide THEN
        raise_application_error(-20901,'Erro aritmetico. Reveja o programa');
    WHEN OTHERS THEN
        dbms_output.put_line('Erro imprevisto');
END;
/
-- ERROR at line 133:
-- ORA-20901: Erro aritmetico. Reveja o programa
-- ORA-06512: at line 7

DECLARE
    e_meu_erro EXCEPTION;
    PRAGMA exception_init ( e_meu_erro,-2292 );
BEGIN
    DELETE FROM dept
    WHERE deptno = 33;
    IF SQL%notfound THEN
        raise_application_error(-20901,'Departamento Inexistente');
        ROLLBACK;
    END IF;
    COMMIT;
EXCEPTION
    WHEN e_meu_erro THEN
        dbms_output.put_line('Integridade Referencial Violada');
        ROLLBACK;
END;
/
-- ERROR at line 148:
-- ORA-20901: Departamento Inexistente
-- ORA-06512: at line 8

DECLARE
    cod     erros.cod_erro%TYPE;
    msg     erros.msg_erro%TYPE;
    cinco   NUMBER := 5;
BEGIN
    BEGIN
        DELETE FROM dept
        WHERE deptno = 10;
    EXCEPTION
        WHEN zero_divide THEN
            dbms_output.put_line('Erro no bloco interno');
    END;
    dbms_output.put_line(cinco / (cinco - cinco) );
EXCEPTION
    WHEN OTHERS THEN
        cod := sqlcode;
        msg := substr(sqlerrm,1,100);
        INSERT INTO erros VALUES ( user,SYSDATE,cod,msg);
END;
/

SELECT * FROM erros;