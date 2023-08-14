-- 집계 함수
SELECT mbti,
COUNT(*) as cnt
FROM tb_info
GROUP BY mbti
ORDER BY 2 DESC;

SELECT hobby
,COUNT(*) as cnt
FROM tb_info
GROUP BY hobby
ORDER BY 2 DESC;

/* 집계함수 대상 데이터를 특정 그룹으로 묶은 다음 그룹에 대한
총합, 평균, 최댓값, 최솟값 등을 구하는 함수.
COUNT(expr) 로우 수를 반환하는 집계함수.
*/
SELECT COUNT(*)                  -- null포함
,COUNT (department_id)          -- default ALL
,COUNT(ALL department_id)       -- 중복포함 null X
,COUNT(DISTINCT department_id)  -- 중복제거
,COUNT(employee_id)
FROM employees;

SELECT department_id 
,SUM(salary)            --합계
,ROUND(AVG(salary),2)   --평균 (ROUND 소수점 자릿수)
,MAX(salary)            --최대
,MIN(salary)            --최소
FROM  employees
GROUP BY department_id
ORDER BY 1;
-- 50번 부서의 최대, 최소 급여를 출력하시오
SELECT MIN(salary)
,MAX(salary)
FROM employees
WHERE department_id =50;

-- member 테이블을 활용하여
-- 회원의 직업별 회원수를 출력하시오
-- 정렬(회원수 내림차순)
SELECT MEM_JOB AS 직업
,COUNT(mem_job) AS 회원수
FROM member
GROUP BY mem_job
ORDER BY 2 DESC; --내림차순
--2013년도 기간별 총 대출잔액
SELECT period
, SUM(loan_jan_amt) as 총잔액
FROM kor_loan_status
WHERE period LIKE '2013%'
GROUP BY period
ORDER BY 1 ;
desc kor_loan_status;
--2013년도 지역별 총 대출잔액
SELECT region
,SUM (loan_jan_amt) AS 총잔액
FROM kor_loan_status
WHERE period LIKE '2013%'
GROUP BY region
ORDER BY 1;
--2013년도 지역별, 대출종류별 총 대출잔액
--select  절에 오는 컬럼은 집계함수를 제외하고
--group by 절에 포함되어야함.
SELECT region
,gubun
,SUM (loan_jan_amt) AS 총잔액
FROM kor_loan_status
WHERE period LIKE '2013%'
GROUP BY region, gubun
ORDER BY 1;
--년도별, 지역별 대출의 총 합계
SELECT SUBSTR (period,1 , 4) AS 년도
,region
,SUM (loan_jan_amt)  AS 총잔액
FROM kor_loan_status
GROUP BY SUBSTR (period, 1, 4),region
ORDER BY 2;
-- employees 직원들의 입사 년도별 직원수를 출력하시오
desc employees;
--  그룹핑 대상의 데이터에 대해 검색조건을 쓰려면
-- HAVING 사용
-- 입사직원이 10명 이상인 년도와 직원수

-- **** select 문 실행순서 !중요!
-- from > where > group by > having > select > order by
SELECT 
TO_CHAR(hire_date,'YYYY') as 입사년도
,COUNT(employee_id) as 직원수
FROM employees
GROUP BY TO_CHAR(hire_date,'YYYY')
HAVING COUNT(employee_id) >=10
ORDER BY 1;

-- member 테이블을 활용하여
-- 직업별 마일리지 평균금액을 구하시오(소수점 2째 자리까지 반올림하여 출력)
-- 1. 정렬 평균마일리지 내림차순
-- 2. 평균 마일리지가 3000이상인 데이터만 출력
desc member;
SELECT 
mem_job
,ROUND (AVG(MEM_MILEAGE),2) as avg_mileage
FROM member
GROUP BY (mem_job)
HAVING ROUND (AVG(MEM_MILEAGE),2) >=3000
ORDER BY 2 DESC;
-----------------------------
--직업별 마일리지의 합계 마일리지 전체합계를 출력하시오
SELECT NVL(mem_job,'합계') as 직업
,COUNT (mem_id) as 회원수
,SUM (mem_mileage) as 합계
FROM member
GROUP BY ROLLUP(mem_job);   -- 롤업 말아올린다라는 뜻으로
                            -- 집계결과의 합을 출력함.
-- products 상품테이블의 카테고리별 상품수와 전체 상품 수를 출력하시오
SELECT NVL(prod_category,'합계') as 카테고리
,prod_subcategory as 서브카테고리
,COUNT (prod_name)as 상품수
FROM products
GROUP BY ROLLUP (prod_category, prod_subcategory);

SELECT SUBSTR (period,1 , 4) AS 년도
,region
,SUM (loan_jan_amt)  AS 총잔액
FROM kor_loan_status
GROUP BY ROLLUP (SUBSTR (period, 1, 4),region)
ORDER BY 1;
SELECT cust_id
,cust_name
,cust_gender
,cust_year_of_birth
FROM customers;
-- 년도별 회원수를 출력하시오 단(남, 녀 구분하여서)
SELECT cust_year_of_birth
,COUNT(cust_gender)
,SUM(DECODE(cust_gender,'M',1)) as 남자
FROM customers
GROUP BY cust_year_of_birth
ORDER BY 1;
--HAVING COUNT(cust_gender)='M';
--정답 코드
SELECT cust_year_of_birth
,SUM(DECODE (cust_gender,'M',1)) as 남자
,SUM(DECODE (cust_gender,'F',1)) as 여자
FROM customers
GROUP BY ROLLUP (cust_year_of_birth)
ORDER BY 1;

SELECT
NVL(region,'총계')
,SUM(DECODE(SUBSTR (period,1 , 4),'2011',loan_jan_amt)) AS 년도2011
,SUM(DECODE(SUBSTR (period,1 , 4),'2012',loan_jan_amt)) AS 년도2012
,SUM(DECODE(SUBSTR (period,1 , 4),'2013',loan_jan_amt)) AS 년도2013
FROM kor_loan_status
GROUP BY ROLLUP (region);

SELECT
SUM(DECODE(SUBSTR (period,1 , 4),'2011',loan_jan_amt)) AS 년도2011
,SUM(DECODE(SUBSTR (period,1 , 4),'2012',loan_jan_amt)) AS 년도2012
,SUM(DECODE(SUBSTR (period,1 , 4),'2013',loan_jan_amt)) AS 년도2013
FROM kor_loan_status;

SELECT
gubun
,SUM(DECODE(SUBSTR(period,1,4),'2011',loan_jan_amt)) AS 년2011
,SUM(DECODE(SUBSTR(period,1,4),'2012',loan_jan_amt)) AS 년2012
,SUM(DECODE(SUBSTR(period,1,4),'2013',loan_jan_amt)) AS 년2013

FROM kor_loan_status
GROUP BY gubun;