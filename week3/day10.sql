/* 뷰 VIEW 337p
  하나 이상의 테이블을 연결해 마치 테이블인 것 처럼 사용하는 객체
  실제 데이터는 뷰를 구성하는 테이블에 담겨 있지만 테이블처럼 사용가능
  사용 목적 :1. 자주 사용하는 복잡한 SQL문을 매번 작성할 필요 없이 뷰로 만들어 사용
            2. 데이터 보안 측면(몇몇 컬럼과 데이터만 공새가능 원천 테이블 감출 수 있음.)
*/
CREATE OR REPLACE view emp_dept AS --뷰 생성 구문
SELECT a.employee_id
        ,a.department_id
        ,b.department_name
FROM employees a, departments b
WHERE a.department_id = b.department_id;
--system 계정에서 java 계정에 뷰를 만들 수 있는 권한 부여
GRANT CREATE VIEW TO JAVA; -- system 계정에서 실행
SELECT *
FROM emp_dept;

-- 다른계정에 emp_dept 뷰를 조회할수있는 권한 부여
GRANT SELECT ON emp_dept TO study; --java 계정에서 실행

SELECT *
FROM java.emp_dept; -- study계정에서 조회 다른 계정에서 조회할때는 스키마(계정).뷰 or 테이블

/* 뷰 특징
    - 단순 뷰(테이블 1개로 생성)
    - 그룹함수 사용불가
    - dinstinct 사용불가
    - insert/update/delete 사용가능
    * 복합 뷰(테이블 여러개로 생성)
    - 그룹 함수 사용가능
    - dinstinct 사용가능
    - insert/update/delete 불가능
    */
-- 뷰 삭제
DROP VIEW emp_date ; -- 생성한 계정에서 실행

/* 시노님 synonim : 동의어란 뜻으로 객체 각자의 고유한 이름에 대한 동의어를 만드는것
    public synoim : 모든 사용자 접근
    private synoim : 특정 사용자만 접근
    시노님 생성시 public 을 생략하면 private 시노님으로 생성됨
    public 시노님의 생성삭제는 DBA권한있는 사용자만 가능
    사용목적 :1.보안측면 계정명과 같은 중요한 정보를 숨기기 위해 별칭을 만듬
            2.개발편의성 실재 테이블의 정보가 변경되어도 별칭으로 사용을 했다면
            코드 수정을 안해도됨.
*/
--시노님 생성 권한 부여
GRANT CREATE SYNONYM to java; -- system 계정에서 권한부여
CREATE OR REPLACE SYNONYM empl FOR employees;
SELECT*
FROM empl;
GRANT SELECT ON empl TO study; --동의어로 테이블을 조회할 수 있는 권한부여
SELECT*
FROM java.empl;
-- public synonim dba 권한이 있어야함
CREATE OR REPLACE PUBLIC SYNONYM empl2 FOR java.employees; -- system 계정에서 생성
SELECT *
FROM empl2; --어떤 계정에서도 조회가능(public 이기때문)
            -- 각 계정에서는 해당 테이블이 어느 계정에 있는지 알 수 없음.(보안)
-- dba 권한 public synonym 삭제 가능
DROP PUBLIC SYNONYM empl2;

/* 시퀀스 SEQUENCE : 규칙에 따라 자동 순번을 반환하는 객체 
    사용목적 : pk 로 사용할 데이터가 없을경우 시퀀스를 만들어서 사용
            ex ) 게시판의 게시글번호 (1로 시작하여 ~~ 999 증가)
    시퀀스명.CURRVAL --현재 시퀀스값
    시퀀스명.NEXTVAL --다음 시퀀스값
*/
CREATE SEQUENCE my_seq1
INCREMENT BY 1  --증강숫자
START WITH   1  --시작숫자
MINVALUE     1  --최소값
MAXVALUE     10 --최댓값
NOCYCLE         --최대나 최소값에 도달하면 생성중지 디폴트(nocycle)
NOCACHE;        --메모리에 시퀀스 값을 미리 할당하지 않음 디폴트(nocache)
SELECT
my_seq1.NEXTVAL
--my_seq1.CURRVAL
FROM dual;
DROP SEQUENCE my_seq1;
CREATE TABLE temp_tb(
seq NUMBER
,dt TIMESTAMP DEFAULT SYSTIMESTAMP
);
INSERT INTO temp_tb(seq) VALUES(my_seq1.NEXTVAL);
SELECT*
FROM temp_tb;

SELECT *
FROM temp_tb;

SELECT NVL(MAX(seq),0)+1
FROM temp_tb;
INSERT INTO temp_tb(seq) VALUES((SELECT NVL(MAX(seq),0)+1
                                    FROM temp_tb));
SELECT *
FROM temp_tb;          
SELECT  to_char(sysdate, 'yyyymmdd') || lpad (NVL(MAX(seq),0)+1 ,4, '0')
FROM temp_tb;

/* MERGE문 oracle 10g 부터 사용가능
    특정 조건에 따라 INSERT or UPDATE DELETE 사용시
*/
-- 현대인의건강 과목이 있다면 학정을 3으로
--                  없다면 생성
SELECT *
FROM 과목;
INSERT INTO 과목(과목번호, 과목이름, 학점) VALUES(509,'현대인의건강',2);
MERGE INTO 과목 a
USING dual                  --비교대상테이블( dual은 into테이블과 같을때)
ON(a.과목이름 = '현대인의건강')
WHEN MATCHED THEN           --ON의 조건이 만족할때
UPDATE SET a.학점 = 3
WHEN NOT MATCHED THEN       --ON의 조건에 만족하지 않을떄
INSERT(a.과목번호, a.과목이름, a.학점)
VALUES(509, '현대인의건강', 2);

/* SELECT 문 정확 and 속도*/
SELECT a.employee_id
        ,(SELECT emp_name
          FROM employees
          WHERE employee_id = a.employee_id)
        ,a.cust_id
        ,(SELECT cust_name
          FROM customers
          WHERE cust_id= a.cust_id)
FROM sales a
GROUP BY a.cust_id , a.employee_id;

-- 2000년도 판매왕을 출력하시오
--employees, sales 테이블 사용 판매금액(amount_sold) 판매수량(quantity_sold)
SELECT *
FROM (
        SELECT  e.*
        FROM( SELECT  e.emp_name
                ,e.EMPLOYEE_ID
                ,SUM (s.AMOUNT_SOLD)
                ,count (s.QUANTITY_SOLD)
                
                FROM employees e, sales s
                WHERE e.EMPLOYEE_ID = s.EMPLOYEE_ID
                GROUP BY e.emp_name,SUBSTR(s.SALES_MONTH,1,4) 
                ,e.EMPLOYEE_ID
                HAVING SUBSTR(s.SALES_MONTH,1,4) = '2000'
                ) e
                ORDER BY 4 DESC
        )
WHERE rownum <=1;
    
DESC SALES;

SELECT  e.emp_name
        ,e.EMPLOYEE_ID
        ,SUM (s.AMOUNT_SOLD)
        ,count (s.QUANTITY_SOLD)
        
        FROM employees e, sales s
        WHERE e.EMPLOYEE_ID = s.EMPLOYEE_ID
        GROUP BY e.emp_name,SUBSTR(s.SALES_MONTH,1,4) 
        ,e.EMPLOYEE_ID
        HAVING SUBSTR(s.SALES_MONTH,1,4) = '2000'
        ORDER BY 3 DESC;