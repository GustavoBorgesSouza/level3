-- %rowtype

SET SERVEROUTPUT ON

DECLARE
    emprec emp%rowtype;
BEGIN
    SELECT *
        INTO emprec
    FROM emp
    WHERE empno = 7876;

    dbms_output.put_line('Codigo   = ' || emprec.empno);
    dbms_output.put_line('Nome     = ' || emprec.ename);
    dbms_output.put_line('Cargo    = ' || emprec.job);
    dbms_output.put_line('Gerente  = ' || emprec.mgr);
    dbms_output.put_line('Data     = ' || emprec.hiredate);
    dbms_output.put_line('Sala     = ' || emprec.sal);
    dbms_output.put_line('Comissao = ' || emprec.comm);
    dbms_output.put_line('Depart.  = ' || emprec.deptno);  
END;
/

-- CURSOR

DECLARE   
    emprec emp%rowtype; 
BEGIN 
SELECT SUM(sal)    
    INTO emprec.sal   
    FROM emp 
    GROUP BY deptno;  
    dbms_output.put_line('Salario = ' || emprec.sal); 
END;
-- ERROR at line 1:
-- ORA-01422: exact fetch returns more than requested number of rows
-- ORA-06512: at line 4

-- Tanto o CURSOR implícito quanto o CURSOR explícito possuem quatro atributos
-- em comum: %FOUND, %ISOPEN, %NOTFOUND e %ROWCOUNT. Esses atributos retornam informações
-- úteis sobre a execução dos comandos.

-- . %FOUND retorna verdadeiro (TRUE), caso alguma linha (tupla) tenha sido afetada.

-- · %ISOPEN retorna verdadeiro (TRUE), caso o CURSOR esteja aberto.

-- · %NOTFOUND retorna verdadeiro (TRUE), caso nao tenha encontrado nenhuma tupla. Caso
-- tenha encontrado, retornará falso (FALSE) até a última tupla.

-- %ROWCOUNT retorna o numero de tuplas manipuladas pelo CURSOR.

-- IMPLICIT CURSOR 

-- Um CURSOR implícito não é declarado e é criado sem a intervenção do usuário para todas as instruções
-- de definição de dados (DDL), manipulação de dados (DML) e instruções SELECT ... INTO que retornam
-- apenas uma linha. Se a sua consulta retornar mais de uma linha dentro do bloco PL/SQL, um erro será
-- gerado. Para corrigir esse erro, você deve declarar um CURSOR. Veja o erro acontecer no exemplo a se-
-- guir:

-- SQL%ROWCOUNT é o CURSOR implícito

BEGIN
    DELETE FROM emp
    WHERE deptno = 10;
    dbms_output.put_line('Linhas apagadas = ' || SQL%ROWCOUNT);
    ROLLBACK;
END;
/

-- EXPLICIT CURSOR
-- CURSOR nome_cursor IS
--         consulta;

DECLARE   
    CURSOR cursor_emp IS 
        SELECT deptno, SUM(sal)             
            FROM emp        
        GROUP BY deptno;
BEGIN
    OPEN cursor_emp;
END;
/


-- FETCHING DATA FROM CURSOR
-- FETCH cursor_name
--     INTO [variável1, variável2, ...|record_name];

DECLARE
    emprec emp%rowtype;   

    CURSOR cursor_emp IS 
        SELECT deptno, SUM(sal)             
            FROM emp        
        GROUP BY deptno;
BEGIN
    OPEN cursor_emp;

    FETCH cursor_emp INTO emprec.deptno, emprec.sal;

    dbms_output.put_line('Departamento: ' || emprec.deptno);
    dbms_output.put_line('Salario     : ' || emprec.sal);
END;
/

-- the above code, gets only one line of code, lets use a loop to get all

DECLARE
    emprec emp%rowtype;   
    CURSOR cursor_emp IS 
        SELECT deptno, SUM(sal)             
            FROM emp        
        GROUP BY deptno;
BEGIN
    OPEN cursor_emp;
        LOOP
            FETCH cursor_emp INTO emprec.deptno, emprec.sal;
            EXIT WHEN cursor_emp%notfound;
            dbms_output.put_line('Departamento: ' || emprec.deptno);
            dbms_output.put_line('Salario     : ' || emprec.sal);
        END LOOP;
    CLOSE cursor_emp;
END;
/

-- FOR LOOPS WITH CURSORS

-- FOR nome_registro IN nome_cursor LOOP
--     Instruções;
-- END LOOP;

DECLARE   
    CURSOR cursor_emp IS          
        SELECT deptno, SUM(sal) soma           
        FROM emp          
    GROUP BY deptno; 
BEGIN    
    FOR emprec IN cursor_emp LOOP        
        dbms_output.put_line('Departamento: ' || emprec.deptno);       
        dbms_output.put_line('Salario     : ' || emprec.soma);    
    END LOOP; 
END; 
/

-- you can do the same without cursors, using subqueries

-- A evolução da linguagem PL/SQL acabou levando a não ser mais necessário declarar um CURSOR expli-
-- citamente na sessão de DECLARE, segundo a Oracle (2016).

-- O CURSOR pode ser substituído por uma subconsulta dentro do LAÇO FOR. Observe que não será pos-
-- sível fazer referencia aos atributos de cursores explícitos se você usar uma subconsulta em um loop FOR
-- de cursor, porque você não poderá dar um nome explícito ao cursor. Veja no exemplo a seguir.

BEGIN    
    FOR emprec IN (SELECT deptno, SUM(sal) soma 
        FROM emp GROUP BY deptno) LOOP        
    dbms_output.put_line('Departamento: ' || emprec.deptno);        
    dbms_output.put_line('Salario     : ' || emprec.soma);    
    END LOOP; 
END; 
/

-- UPDATE WITH CURSORS

DECLARE
    emprec emp%rowtype;   
    CURSOR cursor_emp IS 
        SELECT empno, sal             
            FROM emp
        FOR UPDATE; 
BEGIN
    OPEN cursor_emp;
        LOOP
            FETCH cursor_emp INTO emprec.empno, emprec.sal;
            EXIT WHEN cursor_emp%notfound;

            UPDATE emp
                SET sal = sal * 1.05
            WHERE CURRENT OF cursor_emp;
        END LOOP;
    CLOSE cursor_emp;
END;
/