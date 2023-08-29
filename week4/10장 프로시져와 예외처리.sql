/*

PL/SQL이 C나 JAVA에 비해 유리한 점은 애플리케이션 서버 측에서 수행되는 것이 아니라 
데이터베이스 엔진 쪽에서 수행된다는 데 있습니다. 데이터와 가장 가까운 곳에 위치하고 
있으므로 애플리케이션 서버로 데이터를 주고 받는 데 따르는 네트워크 트래픽이 최소화된다는 장점이 있습니다.

1. 기본구조 

  블록(Block) 구성요소 
  이름부         : 블록의 명칭( 생략할 때는 익명 블록이 된다.)
  선언부         : 변수, 상수, 커서등의 선언 (구문의 끝은 세미콜론(;) 
                  변수나 상수가 없다면 생략 가능
  실행부         : 로직을 처리하는 부분
  예외처리부 

  블록(Block) 종류 (함수,프로시저,패키지)
  이름이 있는 블록과 
  없는 블록으로 구분 (익명 블록)

  ------------------------ 이름 있는 블록
  이름
  IS
   선언부
  BEGIN
   실행부
  EXCEPTIOPN
   예외 처리부
  END;
  ------------------------
  ------------------------ 이름 없는 블록
  DECLARE
   선언부
  BEGIN
   실행부
  EXCEPTIOPN
   예외 처리부
  END;
  ------------------------


----------------------------------------------------------------------------------
*/


/*
 함수
 프로젝트 성격에 맞게 다양한 함수를 직접 구현하여 사용.   
 함수는 반환값이 있으며 SQL, PL/SQL 모두 사용가능 하다. 


 CREATE OR REPLACE FUNCTION 함수이름(매개변수1, 매개변수2, ....n ) 
 CREATE OR REPLACE FUNCTION 함수이름     <-- 매개변수가 없을때 


 -------------------------------------------------------------
 CREATE OR REPLACE FUNCTION 함수이름(매개변수1 타입, 매개변수2 타입, ....n) 
 RETURN 데이터타입;    반환할 데이터의 타입

 IS
  변수, 상수 선언
 BEGIN
  실행부 

  RETURN 반환값;

 [EXCEPTION 예외처리부]

 END;
 --------------------------------------------------------------
 함수 호출  
 매개변수 없을때   함수명 or   함수명()
 매개변수 있을때   함수명(매개변수1, 매개변수2,...  n)

*/


/*
 프로시저   
 스토어드 프로시저라고도 부름
 
*/
CREATE OR REPLACE PROCEDURE my_new_job_proc   -- <-- 프로시저 이름
          ( p_job_id    IN JOBS.JOB_ID%TYPE,
            p_job_title IN JOBS.JOB_TITLE%TYPE,
            p_min_sal   IN JOBS.MIN_SALARY%TYPE,
            p_max_sal   IN JOBS.MAX_SALARY%TYPE )   --<-- 매개변수 정의
IS

BEGIN
	
	INSERT INTO JOBS ( job_id, job_title, min_salary, max_salary, create_date, update_date)
	          VALUES ( p_job_id, p_job_title, p_min_sal, p_max_sal, SYSDATE, SYSDATE);
	COMMIT;
END ;            

-- 프로시저 실행
-- SELECT 절에 사용 불가.
EXEC my_new_job_proc ('SM_JOB1', 'Sample JOB1', 1000, 5000);   -- 무결성 제약조건으로 오류


SELECT *
  FROM jobs
 WHERE job_id = 'SM_JOB1';
 
EXEC my_new_job_proc ('SM_JOB1', 'Sample JOB1', 1000, 5000); 
 
DROP PROCEDURE my_new_job_proc;

 
-- OUT, IN OUT 매개변수 사용


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
 1.사용자 정의 예외
-------------------------------------------------------------------------------------------------------------------------------------
   시스템 예외 이외에 사용자가 직접 예외를 정의 
   개발자가 직접 예외를 정의하는 방법.
-------------------------------------------------------------------------------------------------------------------------------------
[1] 사용자 예외 정의방법 
 (1) 예외 정의 : 사용자_정의_예외명 EXCEPTION;
 (2) 예외발생시키기 : RAISE 사용자_정의_예외명;
                    시스템 예외는 해당 예외가 자동으로 검출 되지만, 사용자 정의 예외는 직접 예외를 발생시켜야 한다.
                  RAISE 예외명 형태로 사용한다.
 (3) 발생된 예외 처리 : EXCEPTION WHEN 사용자_정의_예외명 THEN ..
*/
    CREATE OR REPLACE PROCEDURE ch10_ins_emp_proc ( 
                      p_emp_name       employees.emp_name%TYPE,
                      p_department_id  departments.department_id%TYPE )
    IS
       vn_employee_id  employees.employee_id%TYPE;
       vd_curr_date    DATE := SYSDATE;
       vn_cnt          NUMBER := 0;
       ex_invalid_depid EXCEPTION; -- (1) 잘못된 부서번호일 경우 예외 정의
    BEGIN
	     -- 부서테이블에서 해당 부서번호 존재유무 체크
	     SELECT COUNT(*)
	       INTO vn_cnt
	       FROM departments
	      WHERE department_id = p_department_id;
	     IF vn_cnt = 0 THEN
	        RAISE ex_invalid_depid; -- (2) 사용자 정의 예외 발생
	     END IF;
	     -- employee_id의 max 값에 +1
	     SELECT MAX(employee_id) + 1
	       INTO vn_employee_id
	       FROM employees; 
	     -- 사용자예외처리 예제이므로 사원 테이블에 최소한 데이터만 입력함
	     INSERT INTO employees ( employee_id, emp_name, hire_date, department_id )
                  VALUES ( vn_employee_id, p_emp_name, vd_curr_date, p_department_id );
       COMMIT;        
          
    EXCEPTION WHEN ex_invalid_depid THEN --(3) 사용자 정의 예외 처리구간 
                   DBMS_OUTPUT.PUT_LINE('해당 부서번호가 없습니다');
              WHEN OTHERS THEN
                   DBMS_OUTPUT.PUT_LINE(SQLERRM);              
    END;                	

EXEC ch10_ins_emp_proc ('홍길동', 999);



/*
--[2]시스템 예외에 이름 부여하기----------------------------------------------------------------------------------------------
 시스템 예외에는 ZERO_DIVIDE, INVALID_NUMBER .... 와같이 정의된 예외가 있다 하지만 이들처럼 예외명이 부여된 것은 
 시스템 예외 중 극소수이고 나머지는 예외코드만 존재한다. 이름이 없는 코드에 이름 부여하기.

	1.사용자 정의 예외 선언 
	2.사용자 정의 예외명과 시스템 예외 코드 연결 (PRAGMA EXCEPTION_INIT(사용자 정의 예외명, 시스템_예외_코드)

		/*
		   PRAGMA 컴파일러가 실행되기 전에 처리하는 전처리기 역할 
		   PRAGMA EXCEPTION_INIT(예외명, 예외번호)
		   사용자 정의 예외 처리를 할 때 사용되는것으로 
		   특정 예외번호를 명시해서 컴파일러에 이 예외를 사용한다는 것을 알리는 역할 
		   (해당 예외번호에 해당되는 시스템 에러시 발생) 
		
	3.발생된 예외 처리:EXCEPTION WHEN 사용자 정의 예외명 THEN ....
*/

CREATE OR REPLACE PROCEDURE ch10_ins_emp_proc ( 
                  p_emp_name       employees.emp_name%TYPE,
                  p_department_id  departments.department_id%TYPE,
                  p_hire_month  VARCHAR2  )
IS
   vn_employee_id  employees.employee_id%TYPE;
   vd_curr_date    DATE := SYSDATE;
   vn_cnt          NUMBER := 0;
   ex_invalid_depid EXCEPTION; -- 잘못된 부서번호일 경우 예외 정의
   ex_invalid_month EXCEPTION; -- 잘못된 입사월인 경우 예외 정의
   PRAGMA EXCEPTION_INIT (ex_invalid_month, -1843); -- 예외명과 예외코드 연결
BEGIN
	 -- 부서테이블에서 해당 부서번호 존재유무 체크
	 SELECT COUNT(*)
	   INTO vn_cnt
	   FROM departments
	 WHERE department_id = p_department_id;
	 IF vn_cnt = 0 THEN
	    RAISE ex_invalid_depid; -- 사용자 정의 예외 발생
	 END IF;
	 -- 입사월 체크 (1~12월 범위를 벗어났는지 체크)
	 IF SUBSTR(p_hire_month, 5, 2) NOT BETWEEN '01' AND '12' THEN
	    RAISE ex_invalid_month; -- 사용자 정의 예외 발생
	 END IF;
	 -- employee_id의 max 값에 +1
	 SELECT MAX(employee_id) + 1
	   INTO vn_employee_id
	   FROM employees;
	 -- 사용자예외처리 예제이므로 사원 테이블에 최소한 데이터만 입력함
	 INSERT INTO employees ( employee_id, emp_name, hire_date, department_id )
              VALUES ( vn_employee_id, p_emp_name, TO_DATE(p_hire_month || '01'), p_department_id );
   COMMIT;              
EXCEPTION WHEN ex_invalid_depid THEN -- 사용자 정의 예외 처리
               DBMS_OUTPUT.PUT_LINE('해당 부서번호가 없습니다');
          WHEN ex_invalid_month THEN -- 입사월 사용자 정의 예외
               DBMS_OUTPUT.PUT_LINE(SQLCODE);
               DBMS_OUTPUT.PUT_LINE(SQLERRM);
               DBMS_OUTPUT.PUT_LINE('1~12월 범위를 벗어난 월입니다');               
          WHEN OTHERS THEN
               DBMS_OUTPUT.PUT_LINE(SQLERRM);              	
END;    
EXEC ch10_ins_emp_proc ('홍길동', 110, '201314');
/*
 [3].사용자 예외를 시스템 예외에 정의된 예외명을 사용----------------------------------------------------------------------------------------------
      RAISE 사용자 정의 예외 발생시 
      오라클에서 정의 되어 있는 예외를 발생 시킬수 있다. 
*/
CREATE OR REPLACE PROCEDURE ch10_raise_test_proc ( p_num NUMBER)
IS
BEGIN
	IF p_num <= 0 THEN
	   RAISE INVALID_NUMBER;
  END IF;
  DBMS_OUTPUT.PUT_LINE(p_num);
EXCEPTION WHEN INVALID_NUMBER THEN
               DBMS_OUTPUT.PUT_LINE('양수만 입력받을 수 있습니다');
          WHEN OTHERS THEN
               DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;
EXEC ch10_raise_test_proc (-10);   

/*
[4].예외를 발생시킬 수 있는 내장 프로시저 ----------------------------------------------------------------------------------------------
  RAISE_APPLICATOIN_ERROR(예외코드, 예외 메세지);
  예외 코드와 메세지를 사용자가 직접 정의  -20000 ~ -20999 번까지 만 사용가능 
   왜냐면 오라클에서 이미 사용하고 있는 예외들이 위 번호 구간은 사용하지 않고 있기 때문에)
*/
CREATE OR REPLACE PROCEDURE ch10_raise_test_proc ( p_num NUMBER)
IS
BEGIN
	IF p_num <= 0 THEN
	   RAISE_APPLICATION_ERROR (-20000, '양수만 입력받을 수 있단 말입니다!');
	END IF;  
  DBMS_OUTPUT.PUT_LINE(p_num);
EXCEPTION WHEN OTHERS THEN
               DBMS_OUTPUT.PUT_LINE(SQLCODE);
               DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;
EXEC ch10_raise_test_proc (-10);               




/*
  트랜잭션 Transaction '거래'
  은행에서 입금과 출금을 하는 그 거래를 말하는 단어로 
  프로그래밍 언어나 오라클에서 말하는 트랜잭션도 이 개념에서 차용한것 

  A 은행 (출금 하여 송금) -> B 은행 
  송금 중에 오류가 발생 
  A 은행 계좌에서 돈이 빠져나가고 
  B 은행 계좌에 입금되지 않음.

  오류를 파악하여 A계좌 출금 취소 or 출금된 만큼 B 은행으로 다시 송금
  but 어떤 오류인지 파악하여 처리하기에는 많은 문제점이 있다. 

  그래서 나온 해결책 -> 거래가 성공적으로 모두 끝난 후에야 이를 완전한 거래로 승인, 
                 거래 도중 뭔가 오류가 발생했을 때는 이 거래를 처음부터 없었던 거래로 되돌린다. 

  거래의 안정성을 확보하는 방법이 바로 트랜잭션
*/


-- COMMIT 과 ROLLBACK

CREATE TABLE ch10_sales (
       sales_month   VARCHAR2(8),
       country_name  VARCHAR2(40),
       prod_category VARCHAR2(50),
       channel_desc  VARCHAR2(20),
       sales_amt     NUMBER );
       
-- (1) commit 없음 ------------------------------------------------------------------------------------------------

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



-- sqlplus 접속하여 조회 
-- 건수가 0
SELECT COUNT(*)
FROM ch10_sales ;

TRUNCATE TABLE ch10_sales;

-- (2) 오류 생겼을 시 ----------------------------------------------------------------------------------------------


ALTER TABLE ch10_sales ADD CONSTRAINTS pk_ch10_sales PRIMARY KEY(sales_month, country_name, prod_category, channel_desc);
-- 제약조건 설정 후 테스트 

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

 -- 다 처리되고 오류가 없을시 커밋 
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
   
   ex_invalid_depid EXCEPTION; -- 잘못된 부서번호일 경우 예외 정의
   PRAGMA EXCEPTION_INIT ( ex_invalid_depid, -20000); -- 예외명과 예외코드 연결

   ex_invalid_month EXCEPTION; -- 잘못된 입사월인 경우 예외 정의
   PRAGMA EXCEPTION_INIT ( ex_invalid_month, -1843); -- 예외명과 예외코드 연결
   
   v_err_code error_log.error_code%TYPE;
   v_err_msg  error_log.error_message%TYPE;
   v_err_line error_log.error_line%TYPE;
BEGIN
 -- 부서테이블에서 해당 부서번호 존재유무 체크
 SELECT COUNT(*)
   INTO vn_cnt
   FROM departments
  WHERE department_id = p_department_id;
	  
 IF vn_cnt = 0 THEN
    RAISE ex_invalid_depid; -- 사용자 정의 예외 발생
 END IF;

-- 입사월 체크 (1~12월 범위를 벗어났는지 체크)
 IF SUBSTR(p_hire_month, 5, 2) NOT BETWEEN '01' AND '12' THEN
    RAISE ex_invalid_month; -- 사용자 정의 예외 발생
 END IF;

 -- employee_id의 max 값에 +1
 SELECT MAX(employee_id) + 1
   INTO vn_employee_id
   FROM employees;
 
-- 사용자예외처리 예제이므로 사원 테이블에 최소한 데이터만 입력함
INSERT INTO employees ( employee_id, emp_name, hire_date, department_id )
            VALUES ( vn_employee_id, p_emp_name, TO_DATE(p_hire_month || '01'), p_department_id );              
 COMMIT;

EXCEPTION WHEN ex_invalid_depid THEN -- 사용자 정의 예외 처리
               v_err_code := SQLCODE;
               v_err_msg  := '해당 부서가 없습니다';
               v_err_line := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
               ROLLBACK;
               error_log_proc ( 'ch10_ins_emp2_proc', v_err_code, v_err_msg, v_err_line); 
          WHEN ex_invalid_month THEN -- 입사월 사용자 정의 예외 처리
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
-- 잘못된 부서
EXEC ch10_ins_emp2_proc ('HONG', 100 , '201413'); -- 잘못된 월


SELECT *
FROM  error_log ;

delete error_log;
commit;

/*
    SAVEPOINT 
    보통 ROLLBACK을 명시하면 INSERT, DELETE, UPDATE, MERGE 
    작업 전체가 취소되는데 전체가 아닌 특정 부분에서 트랜잭션을 취소시킬 수 있다. 
    이렇게 하려면 취소하려는 지점을 명시한 뒤, 그 지점까지 작업을 취소하는 
    식으로 사용하는데 이 지점을 SAVEPOINT라고 한다. 
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
	
	--기존 데이터 삭제
	DELETE ch10_sales
	 WHERE sales_month  = p_sales_month
	   AND country_name = p_country_name;
	      
	-- 신규로 월, 국가를 매개변수로 받아 INSERT 
	-- DELETE를 수행하므로 PRIMARY KEY 중복이 발생치 않음
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
       
 -- SAVEPOINT 확인을 위한 UPDATE

  -- 현재시간에서 초를 가져와 숫자로 변환한 후 * 10 (매번 초는 달라지므로 성공적으로 실행 시 이 값은 매번 달라짐)
 UPDATE ch10_sales
    SET sales_amt = 10 * to_number(to_char(sysdate, 'ss'))
  WHERE sales_month  = p_sales_month
	   AND country_name = p_country_name;
	   
 -- SAVEPOINT 지정      

 SAVEPOINT mysavepoint;      
 
 
 -- ch10_country_month_sales 테이블에 INSERT
 -- 중복 입력 시 PRIMARY KEY 중복됨
 INSERT INTO ch10_country_month_sales 
       SELECT sales_month, country_name, SUM(sales_amt)
         FROM ch10_sales
        WHERE sales_month  = p_sales_month
	        AND country_name = p_country_name
	      GROUP BY sales_month, country_name;         
       
 COMMIT;

EXCEPTION WHEN OTHERS THEN
               DBMS_OUTPUT.PUT_LINE(SQLERRM);
               ROLLBACK TO mysavepoint; -- SAVEPOINT 까지만 ROLLBACK
               COMMIT; -- SAVEPOINT 이전까지는 COMMIT

	
END;   

TRUNCATE TABLE ch10_sales;

EXEC iud_ch10_sales_proc ( '199901', 'Italy');

SELECT DISTINCT sales_amt
FROM ch10_sales;



EXEC iud_ch10_sales_proc ( '199901', 'Italy');

SELECT DISTINCT sales_amt
FROM ch10_sales;


