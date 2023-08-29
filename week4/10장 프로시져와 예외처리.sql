/*

PL/SQL�� C�� JAVA�� ���� ������ ���� ���ø����̼� ���� ������ ����Ǵ� ���� �ƴ϶� 
�����ͺ��̽� ���� �ʿ��� ����ȴٴ� �� �ֽ��ϴ�. �����Ϳ� ���� ����� ���� ��ġ�ϰ� 
�����Ƿ� ���ø����̼� ������ �����͸� �ְ� �޴� �� ������ ��Ʈ��ũ Ʈ������ �ּ�ȭ�ȴٴ� ������ �ֽ��ϴ�.

1. �⺻���� 

  ���(Block) ������� 
  �̸���         : ����� ��Ī( ������ ���� �͸� ����� �ȴ�.)
  �����         : ����, ���, Ŀ������ ���� (������ ���� �����ݷ�(;) 
                  ������ ����� ���ٸ� ���� ����
  �����         : ������ ó���ϴ� �κ�
  ����ó���� 

  ���(Block) ���� (�Լ�,���ν���,��Ű��)
  �̸��� �ִ� ��ϰ� 
  ���� ������� ���� (�͸� ���)

  ------------------------ �̸� �ִ� ���
  �̸�
  IS
   �����
  BEGIN
   �����
  EXCEPTIOPN
   ���� ó����
  END;
  ------------------------
  ------------------------ �̸� ���� ���
  DECLARE
   �����
  BEGIN
   �����
  EXCEPTIOPN
   ���� ó����
  END;
  ------------------------


----------------------------------------------------------------------------------
*/


/*
 �Լ�
 ������Ʈ ���ݿ� �°� �پ��� �Լ��� ���� �����Ͽ� ���.   
 �Լ��� ��ȯ���� ������ SQL, PL/SQL ��� ��밡�� �ϴ�. 


 CREATE OR REPLACE FUNCTION �Լ��̸�(�Ű�����1, �Ű�����2, ....n ) 
 CREATE OR REPLACE FUNCTION �Լ��̸�     <-- �Ű������� ������ 


 -------------------------------------------------------------
 CREATE OR REPLACE FUNCTION �Լ��̸�(�Ű�����1 Ÿ��, �Ű�����2 Ÿ��, ....n) 
 RETURN ������Ÿ��;    ��ȯ�� �������� Ÿ��

 IS
  ����, ��� ����
 BEGIN
  ����� 

  RETURN ��ȯ��;

 [EXCEPTION ����ó����]

 END;
 --------------------------------------------------------------
 �Լ� ȣ��  
 �Ű����� ������   �Լ��� or   �Լ���()
 �Ű����� ������   �Լ���(�Ű�����1, �Ű�����2,...  n)

*/


/*
 ���ν���   
 ������ ���ν������ �θ�
 
*/
CREATE OR REPLACE PROCEDURE my_new_job_proc   -- <-- ���ν��� �̸�
          ( p_job_id    IN JOBS.JOB_ID%TYPE,
            p_job_title IN JOBS.JOB_TITLE%TYPE,
            p_min_sal   IN JOBS.MIN_SALARY%TYPE,
            p_max_sal   IN JOBS.MAX_SALARY%TYPE )   --<-- �Ű����� ����
IS

BEGIN
	
	INSERT INTO JOBS ( job_id, job_title, min_salary, max_salary, create_date, update_date)
	          VALUES ( p_job_id, p_job_title, p_min_sal, p_max_sal, SYSDATE, SYSDATE);
	COMMIT;
END ;            

-- ���ν��� ����
-- SELECT ���� ��� �Ұ�.
EXEC my_new_job_proc ('SM_JOB1', 'Sample JOB1', 1000, 5000);   -- ���Ἲ ������������ ����


SELECT *
  FROM jobs
 WHERE job_id = 'SM_JOB1';
 
EXEC my_new_job_proc ('SM_JOB1', 'Sample JOB1', 1000, 5000); 
 
DROP PROCEDURE my_new_job_proc;

 
-- OUT, IN OUT �Ű����� ���


CREATE OR REPLACE PROCEDURE my_parameter_test_proc (
               p_var1        VARCHAR2,
               p_var2 OUT    VARCHAR2,
               p_var3 IN OUT VARCHAR2 )
IS

BEGIN
	 DBMS_OUTPUT.PUT_LINE('p_var1 value = ' || p_var1);
	 DBMS_OUTPUT.PUT_LINE('p_var2 value = ' || p_var2);
	 DBMS_OUTPUT.PUT_LINE('p_var3 value = ' || p_var3);
	 
	 p_var2 := 'B2';
	 p_var3 := 'C2';
	
END;               


DECLARE 
   v_var1 VARCHAR2(10) := 'A';
   v_var2 VARCHAR2(10) := 'B';
   v_var3 VARCHAR2(10) := 'C';
BEGIN
	 my_parameter_test_proc (v_var1, v_var2, v_var3);
	 
	 DBMS_OUTPUT.PUT_LINE('v_var2 value = ' || v_var2);
	 DBMS_OUTPUT.PUT_LINE('v_var3 value = ' || v_var3);
END;


/*
-------------------------------------------------------------------------------------------------------------------------------------
 1.����� ���� ����
-------------------------------------------------------------------------------------------------------------------------------------
   �ý��� ���� �̿ܿ� ����ڰ� ���� ���ܸ� ���� 
   �����ڰ� ���� ���ܸ� �����ϴ� ���.
-------------------------------------------------------------------------------------------------------------------------------------
[1] ����� ���� ���ǹ�� 
 (1) ���� ���� : �����_����_���ܸ� EXCEPTION;
 (2) ���ܹ߻���Ű�� : RAISE �����_����_���ܸ�;
                    �ý��� ���ܴ� �ش� ���ܰ� �ڵ����� ���� ������, ����� ���� ���ܴ� ���� ���ܸ� �߻����Ѿ� �Ѵ�.
                  RAISE ���ܸ� ���·� ����Ѵ�.
 (3) �߻��� ���� ó�� : EXCEPTION WHEN �����_����_���ܸ� THEN ..
*/
    CREATE OR REPLACE PROCEDURE ch10_ins_emp_proc ( 
                      p_emp_name       employees.emp_name%TYPE,
                      p_department_id  departments.department_id%TYPE )
    IS
       vn_employee_id  employees.employee_id%TYPE;
       vd_curr_date    DATE := SYSDATE;
       vn_cnt          NUMBER := 0;
       ex_invalid_depid EXCEPTION; -- (1) �߸��� �μ���ȣ�� ��� ���� ����
    BEGIN
	     -- �μ����̺��� �ش� �μ���ȣ �������� üũ
	     SELECT COUNT(*)
	       INTO vn_cnt
	       FROM departments
	      WHERE department_id = p_department_id;
	     IF vn_cnt = 0 THEN
	        RAISE ex_invalid_depid; -- (2) ����� ���� ���� �߻�
	     END IF;
	     -- employee_id�� max ���� +1
	     SELECT MAX(employee_id) + 1
	       INTO vn_employee_id
	       FROM employees; 
	     -- ����ڿ���ó�� �����̹Ƿ� ��� ���̺� �ּ��� �����͸� �Է���
	     INSERT INTO employees ( employee_id, emp_name, hire_date, department_id )
                  VALUES ( vn_employee_id, p_emp_name, vd_curr_date, p_department_id );
       COMMIT;        
          
    EXCEPTION WHEN ex_invalid_depid THEN --(3) ����� ���� ���� ó������ 
                   DBMS_OUTPUT.PUT_LINE('�ش� �μ���ȣ�� �����ϴ�');
              WHEN OTHERS THEN
                   DBMS_OUTPUT.PUT_LINE(SQLERRM);              
    END;                	

EXEC ch10_ins_emp_proc ('ȫ�浿', 999);



/*
--[2]�ý��� ���ܿ� �̸� �ο��ϱ�----------------------------------------------------------------------------------------------
 �ý��� ���ܿ��� ZERO_DIVIDE, INVALID_NUMBER .... �Ͱ��� ���ǵ� ���ܰ� �ִ� ������ �̵�ó�� ���ܸ��� �ο��� ���� 
 �ý��� ���� �� �ؼҼ��̰� �������� �����ڵ常 �����Ѵ�. �̸��� ���� �ڵ忡 �̸� �ο��ϱ�.

	1.����� ���� ���� ���� 
	2.����� ���� ���ܸ�� �ý��� ���� �ڵ� ���� (PRAGMA EXCEPTION_INIT(����� ���� ���ܸ�, �ý���_����_�ڵ�)

		/*
		   PRAGMA �����Ϸ��� ����Ǳ� ���� ó���ϴ� ��ó���� ���� 
		   PRAGMA EXCEPTION_INIT(���ܸ�, ���ܹ�ȣ)
		   ����� ���� ���� ó���� �� �� ���Ǵ°����� 
		   Ư�� ���ܹ�ȣ�� ����ؼ� �����Ϸ��� �� ���ܸ� ����Ѵٴ� ���� �˸��� ���� 
		   (�ش� ���ܹ�ȣ�� �ش�Ǵ� �ý��� ������ �߻�) 
		
	3.�߻��� ���� ó��:EXCEPTION WHEN ����� ���� ���ܸ� THEN ....
*/

CREATE OR REPLACE PROCEDURE ch10_ins_emp_proc ( 
                  p_emp_name       employees.emp_name%TYPE,
                  p_department_id  departments.department_id%TYPE,
                  p_hire_month  VARCHAR2  )
IS
   vn_employee_id  employees.employee_id%TYPE;
   vd_curr_date    DATE := SYSDATE;
   vn_cnt          NUMBER := 0;
   ex_invalid_depid EXCEPTION; -- �߸��� �μ���ȣ�� ��� ���� ����
   ex_invalid_month EXCEPTION; -- �߸��� �Ի���� ��� ���� ����
   PRAGMA EXCEPTION_INIT (ex_invalid_month, -1843); -- ���ܸ�� �����ڵ� ����
BEGIN
	 -- �μ����̺��� �ش� �μ���ȣ �������� üũ
	 SELECT COUNT(*)
	   INTO vn_cnt
	   FROM departments
	 WHERE department_id = p_department_id;
	 IF vn_cnt = 0 THEN
	    RAISE ex_invalid_depid; -- ����� ���� ���� �߻�
	 END IF;
	 -- �Ի�� üũ (1~12�� ������ ������� üũ)
	 IF SUBSTR(p_hire_month, 5, 2) NOT BETWEEN '01' AND '12' THEN
	    RAISE ex_invalid_month; -- ����� ���� ���� �߻�
	 END IF;
	 -- employee_id�� max ���� +1
	 SELECT MAX(employee_id) + 1
	   INTO vn_employee_id
	   FROM employees;
	 -- ����ڿ���ó�� �����̹Ƿ� ��� ���̺� �ּ��� �����͸� �Է���
	 INSERT INTO employees ( employee_id, emp_name, hire_date, department_id )
              VALUES ( vn_employee_id, p_emp_name, TO_DATE(p_hire_month || '01'), p_department_id );
   COMMIT;              
EXCEPTION WHEN ex_invalid_depid THEN -- ����� ���� ���� ó��
               DBMS_OUTPUT.PUT_LINE('�ش� �μ���ȣ�� �����ϴ�');
          WHEN ex_invalid_month THEN -- �Ի�� ����� ���� ����
               DBMS_OUTPUT.PUT_LINE(SQLCODE);
               DBMS_OUTPUT.PUT_LINE(SQLERRM);
               DBMS_OUTPUT.PUT_LINE('1~12�� ������ ��� ���Դϴ�');               
          WHEN OTHERS THEN
               DBMS_OUTPUT.PUT_LINE(SQLERRM);              	
END;    
EXEC ch10_ins_emp_proc ('ȫ�浿', 110, '201314');
/*
 [3].����� ���ܸ� �ý��� ���ܿ� ���ǵ� ���ܸ��� ���----------------------------------------------------------------------------------------------
      RAISE ����� ���� ���� �߻��� 
      ����Ŭ���� ���� �Ǿ� �ִ� ���ܸ� �߻� ��ų�� �ִ�. 
*/
CREATE OR REPLACE PROCEDURE ch10_raise_test_proc ( p_num NUMBER)
IS
BEGIN
	IF p_num <= 0 THEN
	   RAISE INVALID_NUMBER;
  END IF;
  DBMS_OUTPUT.PUT_LINE(p_num);
EXCEPTION WHEN INVALID_NUMBER THEN
               DBMS_OUTPUT.PUT_LINE('����� �Է¹��� �� �ֽ��ϴ�');
          WHEN OTHERS THEN
               DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;
EXEC ch10_raise_test_proc (-10);   

/*
[4].���ܸ� �߻���ų �� �ִ� ���� ���ν��� ----------------------------------------------------------------------------------------------
  RAISE_APPLICATOIN_ERROR(�����ڵ�, ���� �޼���);
  ���� �ڵ�� �޼����� ����ڰ� ���� ����  -20000 ~ -20999 ������ �� ��밡�� 
   �ֳĸ� ����Ŭ���� �̹� ����ϰ� �ִ� ���ܵ��� �� ��ȣ ������ ������� �ʰ� �ֱ� ������)
*/
CREATE OR REPLACE PROCEDURE ch10_raise_test_proc ( p_num NUMBER)
IS
BEGIN
	IF p_num <= 0 THEN
	   RAISE_APPLICATION_ERROR (-20000, '����� �Է¹��� �� �ִ� ���Դϴ�!');
	END IF;  
  DBMS_OUTPUT.PUT_LINE(p_num);
EXCEPTION WHEN OTHERS THEN
               DBMS_OUTPUT.PUT_LINE(SQLCODE);
               DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;
EXEC ch10_raise_test_proc (-10);               




/*
  Ʈ����� Transaction '�ŷ�'
  ���࿡�� �Աݰ� ����� �ϴ� �� �ŷ��� ���ϴ� �ܾ�� 
  ���α׷��� �� ����Ŭ���� ���ϴ� Ʈ����ǵ� �� ���信�� �����Ѱ� 

  A ���� (��� �Ͽ� �۱�) -> B ���� 
  �۱� �߿� ������ �߻� 
  A ���� ���¿��� ���� ���������� 
  B ���� ���¿� �Աݵ��� ����.

  ������ �ľ��Ͽ� A���� ��� ��� or ��ݵ� ��ŭ B �������� �ٽ� �۱�
  but � �������� �ľ��Ͽ� ó���ϱ⿡�� ���� �������� �ִ�. 

  �׷��� ���� �ذ�å -> �ŷ��� ���������� ��� ���� �Ŀ��� �̸� ������ �ŷ��� ����, 
                 �ŷ� ���� ���� ������ �߻����� ���� �� �ŷ��� ó������ ������ �ŷ��� �ǵ�����. 

  �ŷ��� �������� Ȯ���ϴ� ����� �ٷ� Ʈ�����
*/


-- COMMIT �� ROLLBACK

CREATE TABLE ch10_sales (
       sales_month   VARCHAR2(8),
       country_name  VARCHAR2(40),
       prod_category VARCHAR2(50),
       channel_desc  VARCHAR2(20),
       sales_amt     NUMBER );
       
-- (1) commit ���� ------------------------------------------------------------------------------------------------

CREATE OR REPLACE PROCEDURE iud_ch10_sales_proc 
            ( p_sales_month ch10_sales.sales_month%TYPE )
IS

BEGIN
	INSERT INTO ch10_sales (sales_month, country_name, prod_category, channel_desc, sales_amt)
	SELECT A.SALES_MONTH, 
       C.COUNTRY_NAME, 
       D.PROD_CATEGORY,
       E.CHANNEL_DESC,
       SUM(A.AMOUNT_SOLD)
  FROM SALES A, CUSTOMERS B, COUNTRIES C, PRODUCTS D, CHANNELS E
 WHERE A.SALES_MONTH = p_sales_month
   AND A.CUST_ID = B.CUST_ID
   AND B.COUNTRY_ID = C.COUNTRY_ID
   AND A.PROD_ID = D.PROD_ID
   AND A.CHANNEL_ID = E.CHANNEL_ID
 GROUP BY A.SALES_MONTH, 
         C.COUNTRY_NAME, 
       D.PROD_CATEGORY,
       E.CHANNEL_DESC;

 --COMMIT;
 --ROLLBACK;

END;            

EXEC iud_ch10_sales_proc ( '199901');



-- sqlplus �����Ͽ� ��ȸ 
-- �Ǽ��� 0
SELECT COUNT(*)
FROM ch10_sales ;

TRUNCATE TABLE ch10_sales;

-- (2) ���� ������ �� ----------------------------------------------------------------------------------------------


ALTER TABLE ch10_sales ADD CONSTRAINTS pk_ch10_sales PRIMARY KEY(sales_month, country_name, prod_category, channel_desc);
-- �������� ���� �� �׽�Ʈ 

CREATE OR REPLACE PROCEDURE iud_ch10_sales_proc 
            ( p_sales_month ch10_sales.sales_month%TYPE )
IS

BEGIN
	
	INSERT INTO ch10_sales (sales_month, country_name, prod_category, channel_desc, sales_amt)	   
	SELECT A.SALES_MONTH, 
       C.COUNTRY_NAME, 
       D.PROD_CATEGORY,
       E.CHANNEL_DESC,
       SUM(A.AMOUNT_SOLD)
  FROM SALES A, CUSTOMERS B, COUNTRIES C, PRODUCTS D, CHANNELS E
 WHERE A.SALES_MONTH = p_sales_month
   AND A.CUST_ID = B.CUST_ID
   AND B.COUNTRY_ID = C.COUNTRY_ID
   AND A.PROD_ID = D.PROD_ID
   AND A.CHANNEL_ID = E.CHANNEL_ID
 GROUP BY A.SALES_MONTH, 
         C.COUNTRY_NAME, 
       D.PROD_CATEGORY,
       E.CHANNEL_DESC;

 -- �� ó���ǰ� ������ ������ Ŀ�� 
 COMMIT;

EXCEPTION WHEN OTHERS THEN
               DBMS_OUTPUT.PUT_LINE(SQLERRM);
               ROLLBACK;

END;   


---------------------------------------------------------------------------------------------------------------------

CREATE OR REPLACE PROCEDURE ch10_ins_emp2_proc ( 
                  p_emp_name       employees.emp_name%TYPE,
                  p_department_id  departments.department_id%TYPE,
                  p_hire_month     VARCHAR2 )
IS
   vn_employee_id  employees.employee_id%TYPE;
   vd_curr_date    DATE := SYSDATE;
   vn_cnt          NUMBER := 0;
   
   ex_invalid_depid EXCEPTION; -- �߸��� �μ���ȣ�� ��� ���� ����
   PRAGMA EXCEPTION_INIT ( ex_invalid_depid, -20000); -- ���ܸ�� �����ڵ� ����

   ex_invalid_month EXCEPTION; -- �߸��� �Ի���� ��� ���� ����
   PRAGMA EXCEPTION_INIT ( ex_invalid_month, -1843); -- ���ܸ�� �����ڵ� ����
   
   v_err_code error_log.error_code%TYPE;
   v_err_msg  error_log.error_message%TYPE;
   v_err_line error_log.error_line%TYPE;
BEGIN
 -- �μ����̺��� �ش� �μ���ȣ �������� üũ
 SELECT COUNT(*)
   INTO vn_cnt
   FROM departments
  WHERE department_id = p_department_id;
	  
 IF vn_cnt = 0 THEN
    RAISE ex_invalid_depid; -- ����� ���� ���� �߻�
 END IF;

-- �Ի�� üũ (1~12�� ������ ������� üũ)
 IF SUBSTR(p_hire_month, 5, 2) NOT BETWEEN '01' AND '12' THEN
    RAISE ex_invalid_month; -- ����� ���� ���� �߻�
 END IF;

 -- employee_id�� max ���� +1
 SELECT MAX(employee_id) + 1
   INTO vn_employee_id
   FROM employees;
 
-- ����ڿ���ó�� �����̹Ƿ� ��� ���̺� �ּ��� �����͸� �Է���
INSERT INTO employees ( employee_id, emp_name, hire_date, department_id )
            VALUES ( vn_employee_id, p_emp_name, TO_DATE(p_hire_month || '01'), p_department_id );              
 COMMIT;

EXCEPTION WHEN ex_invalid_depid THEN -- ����� ���� ���� ó��
               v_err_code := SQLCODE;
               v_err_msg  := '�ش� �μ��� �����ϴ�';
               v_err_line := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
               ROLLBACK;
               error_log_proc ( 'ch10_ins_emp2_proc', v_err_code, v_err_msg, v_err_line); 
          WHEN ex_invalid_month THEN -- �Ի�� ����� ���� ���� ó��
               v_err_code := SQLCODE;
               v_err_msg  := SQLERRM;
               v_err_line := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
               ROLLBACK;
               error_log_proc ( 'ch10_ins_emp2_proc', v_err_code, v_err_msg, v_err_line); 
          WHEN OTHERS THEN
               v_err_code := SQLCODE;
               v_err_msg  := SQLERRM;
               v_err_line := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
               ROLLBACK;  
               error_log_proc ( 'ch10_ins_emp2_proc', v_err_code, v_err_msg, v_err_line);        	
END;


EXEC ch10_ins_emp2_proc ('HONG', 1000, '201401'); 
-- �߸��� �μ�
EXEC ch10_ins_emp2_proc ('HONG', 100 , '201413'); -- �߸��� ��


SELECT *
FROM  error_log ;

delete error_log;
commit;

/*
    SAVEPOINT 
    ���� ROLLBACK�� ����ϸ� INSERT, DELETE, UPDATE, MERGE 
    �۾� ��ü�� ��ҵǴµ� ��ü�� �ƴ� Ư�� �κп��� Ʈ������� ��ҽ�ų �� �ִ�. 
    �̷��� �Ϸ��� ����Ϸ��� ������ ����� ��, �� �������� �۾��� ����ϴ� 
    ������ ����ϴµ� �� ������ SAVEPOINT��� �Ѵ�. 
*/


CREATE TABLE ch10_country_month_sales (
               sales_month   VARCHAR2(8),
               country_name  VARCHAR2(40),
               sales_amt     NUMBER,
               PRIMARY KEY (sales_month, country_name) );
              
CREATE OR REPLACE PROCEDURE iud_ch10_sales_proc 
            ( p_sales_month  ch10_sales.sales_month%TYPE, 
              p_country_name ch10_sales.country_name%TYPE )
IS

BEGIN
	
	--���� ������ ����
	DELETE ch10_sales
	 WHERE sales_month  = p_sales_month
	   AND country_name = p_country_name;
	      
	-- �űԷ� ��, ������ �Ű������� �޾� INSERT 
	-- DELETE�� �����ϹǷ� PRIMARY KEY �ߺ��� �߻�ġ ����
	INSERT INTO ch10_sales (sales_month, country_name, prod_category, channel_desc, sales_amt)	   
	SELECT A.SALES_MONTH, 
       C.COUNTRY_NAME, 
       D.PROD_CATEGORY,
       E.CHANNEL_DESC,
       SUM(A.AMOUNT_SOLD)
  FROM SALES A, CUSTOMERS B, COUNTRIES C, PRODUCTS D, CHANNELS E
 WHERE A.SALES_MONTH  = p_sales_month
   AND C.COUNTRY_NAME = p_country_name
   AND A.CUST_ID = B.CUST_ID
   AND B.COUNTRY_ID = C.COUNTRY_ID
   AND A.PROD_ID = D.PROD_ID
   AND A.CHANNEL_ID = E.CHANNEL_ID
 GROUP BY A.SALES_MONTH, 
         C.COUNTRY_NAME, 
       D.PROD_CATEGORY,
       E.CHANNEL_DESC;
       
 -- SAVEPOINT Ȯ���� ���� UPDATE

  -- ����ð����� �ʸ� ������ ���ڷ� ��ȯ�� �� * 10 (�Ź� �ʴ� �޶����Ƿ� ���������� ���� �� �� ���� �Ź� �޶���)
 UPDATE ch10_sales
    SET sales_amt = 10 * to_number(to_char(sysdate, 'ss'))
  WHERE sales_month  = p_sales_month
	   AND country_name = p_country_name;
	   
 -- SAVEPOINT ����      

 SAVEPOINT mysavepoint;      
 
 
 -- ch10_country_month_sales ���̺� INSERT
 -- �ߺ� �Է� �� PRIMARY KEY �ߺ���
 INSERT INTO ch10_country_month_sales 
       SELECT sales_month, country_name, SUM(sales_amt)
         FROM ch10_sales
        WHERE sales_month  = p_sales_month
	        AND country_name = p_country_name
	      GROUP BY sales_month, country_name;         
       
 COMMIT;

EXCEPTION WHEN OTHERS THEN
               DBMS_OUTPUT.PUT_LINE(SQLERRM);
               ROLLBACK TO mysavepoint; -- SAVEPOINT ������ ROLLBACK
               COMMIT; -- SAVEPOINT ���������� COMMIT

	
END;   

TRUNCATE TABLE ch10_sales;

EXEC iud_ch10_sales_proc ( '199901', 'Italy');

SELECT DISTINCT sales_amt
FROM ch10_sales;



EXEC iud_ch10_sales_proc ( '199901', 'Italy');

SELECT DISTINCT sales_amt
FROM ch10_sales;


