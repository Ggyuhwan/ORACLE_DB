SELECT department_id
    -- level 가상열로서  트리 내에서 어떤 단계인지 나타내는 정수값
    ,LPAD (' ',3* (level-1)) || department_name as 부서명
    ,parent_id
    ,level
FROM departments
START WITH parent_id IS NULL                -- 시작
CONNECT BY PRIOR department_id = parent_id; -- 계층을 어떻게 연결할지 (조건)
-- departments 테이블에 230 IT헬프데스크 하위 부서로
--                          IT원격팀
SELECT MAX(department_id) +10
FROM departments;

INSERT INTO departments (DEPARTMENT_ID,DEPARTMENT_NAME,PARENT_ID)
VALUES (280,'IT원격팀',230);

SELECT department_id
    ,LPAD (' ',3* (level-1)) || department_name as 부서명
    ,level
FROM departments
START WITH parent_id IS NULL             
CONNECT BY PRIOR department_id = parent_id; 

/* 계층형 쿼리에서 정렬을 하려면 SIBLINGS BY 를 추가해야함. */
SELECT department_id
    ,LPAD (' ',3* (level-1)) || department_name as 부서명
    ,parent_id
    ,level
FROM departments
START WITH parent_id IS NULL                
CONNECT BY PRIOR department_id = parent_id
ORDER SIBLINGS BY department_name; --SIBLINGS 사용시에는 실제 컬럼으로만 정렬가능

/* 계층형쿼리 관련 함수 */
SELECT department_id
    ,LPAD (' ',3* (level-1)) || department_name as 부서명 -- || <-문자열 붙이기
    ,parent_id
    ,level
    ,CONNECT_BY_ISLEAF --마지막노드면1, 자식이 있으면0
    ,SYS_CONNECT_BY_PATH(department_name,'|') --루트 노드에서 자신행까지 연결정보
    ,CONNECT_BY_ISCYCLE --무한루프의 원인을 찾을때
    --(자식이 있는데 그자식 로우가 부모이면 1, 아니면 0
FROM departments
START WITH parent_id IS NULL                
CONNECT BY NOCYCLE PRIOR department_id = parent_id
ORDER SIBLINGS BY department_name;
-- 무한루프 걸리도록 수정
UPDATE departments
SET parent_id = 260
WHERE department_id = 30;

SELECT employee_id
        ,emp_name
        ,manager_id
FROM employees
WHERE manager_id IS NULL;
--직원간의 계층관계를 출력하시오
SELECT employee_id
        ,LPAD (' ',3* (level-1)) || emp_name as 직원명
        ,SYS_CONNECT_BY_PATH(emp_name,'>') as 관리관계
        ,level
FROM employees
START WITH manager_id IS NULL               --시작
CONNECT BY PRIOR employee_id = manager_id
ORDER SIBLINGS BY emp_name;
DESC employees;
CREATE TABLE TEST (아이디 NUMBER(6) 
, 이름 VARCHAR2(20)
, 직책  VARCHAR2(20)
, 상위아이디 NUMBER(6));

INSERT INTO TEST (아이디,이름,직책,상위아이디)
VALUES (2,'이사장','사장',NULL)
 ;
 INSERT INTO TEST (아이디,이름,직책,상위아이디)
VALUES (10,'김부장','부장',2)
 ;
 INSERT INTO TEST (아이디,이름,직책,상위아이디)
VALUES (20,'서차장','차장',10)
 ;
 INSERT INTO TEST (아이디,이름,직책,상위아이디)
VALUES (30,'장과장','과장',20)
 ;
 INSERT INTO TEST (아이디,이름,직책,상위아이디)
VALUES (40,'이대리','대리',30)
 ;
 INSERT INTO TEST (아이디,이름,직책,상위아이디)
VALUES (50,'최사원','사원',40)
 ;
  INSERT INTO TEST (아이디,이름,직책,상위아이디)
VALUES (60,'강사원','사원',40)
 ;
  INSERT INTO TEST (아이디,이름,직책,상위아이디)
VALUES (70,'박과장','과장',20)
 ;
  INSERT INTO TEST (아이디,이름,직책,상위아이디)
VALUES (80,'김대리','대리',70)
 ;
  INSERT INTO TEST (아이디,이름,직책,상위아이디)
VALUES (90,'주사원','사원',80)
 ;

 SELECT 이름,LPAD (' ',3* (level-1)) || 직책,level
 FROM TEST
 START WITH 상위아이디 IS NULL --시작
 CONNECT BY PRIOR 아이디 = 상위아이디
 ;
 
 select *
 from test;
 drop table test;
 
SELECT period
    ,SUM(loan_jan_amt) as 대출합계
 FROM kor_loan_status
 WHERE substr(period, 1,4)= 2013
 GROUP BY period;
 /* level 은 가상 열로서(connect by 절과 함계 사용)
  임의의 데이터가 필요할때 많이사용.
*/
-- 2013년 1~ 12월 데이터
SELECT '2013' || LPAD (LEVEL,2,'0') AS 년월
FROM dual
CONNECT BY LEVEL <=12;
-- 2013년 1~ 12월 데이터
SELECT a.년월
        ,NVL(b.대출합계,0) as 대출합계
FROM        (SELECT '2013' || LPAD (LEVEL,2,'0') AS 년월
             FROM dual
             CONNECT BY LEVEL <=12)a
            ,(SELECT period as 년월
            ,SUM(loan_jan_amt) as 대출합계
             FROM kor_loan_status
            WHERE substr(period, 1,4)= 2013
            GROUP BY period)b
WHERE a.년월 = b.년월(+)
ORDER BY 1;
-- 202301~202312
SELECT TO_CHAR(SYSDATE,'YYYY') || LPAD(LEVEL,2,'0') as YEAR
 FROM dual
CONNECT BY LEVEL <=12;
--이번달 1일부터 마지막날까지 출력
--(단 해당 SELECT문을 다음달에 실행시 해당월의 마지막날까지 출력되도록)
SELECT TO_CHAR(SYSDATE,'YYYYMM')|| LPAD(LEVEL,2,'0')   as YEAR
 FROM dual
CONNECT BY LEVEL  <= (SELECT TO_CHAR(LAST_DAY(sysdate),'DD')
                        FROM dual);
--TO_CHAR(LAST_DAY,(SYSDATE),'YYYYMMDD')

SELECT TO_CHAR(LAST_DAY(ADD_MONTHS(TRUNC(SYSDATE, 'MM'), 1) - 1),'YYYYMM') 
    || LPAD(LEVEL,2,'0') as YEAR
FROM dual
CONNECT BY LEVEL <= TO_NUMBER
(TO_CHAR(LAST_DAY(ADD_MONTHS(TRUNC(SYSDATE, 'MM'), 1) - 1),'DD'));

--커넥트 바이 , 외부조인
--MEMBER 회원의 생일(mem_bir)의 월별 회원수를 출력하시오 (모든 월이 나오도록)
DESC MEMBER;
SELECT NVL(a.생일_월,'합계') , count(b.월) as 회원수
FROM        (SELECT  LPAD (LEVEL,2,'0')||'월' AS 생일_월
             FROM dual
             CONNECT BY LEVEL <=12)a,
        (SELECT to_char(MEM_BIR,'MM')||'월' as 월   
            FROM MEMBER
       )b
WHERE a.생일_월 = b.월(+)
GROUP BY rollup (a.생일_월)
ORDER BY 1;

select count (MEM_BIR)
from member;
SELECT to_char(MEM_BIR,'MM') as 월
     , count(*)
FROM MEMBER
GROUP BY to_char(MEM_BIR,'MM');
SELECT count (to_char(substr(MEM_BIR,3,4)))
FROM MEMBER
group by to_char(substr(MEM_BIR,3,4));