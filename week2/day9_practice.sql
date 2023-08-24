/*
 STUDY 계정에 create_table 스크립트를 실해하여 
 테이블 생성후 1~ 5 데이터를 임포트한 뒤 
 아래 문제를 출력하시오 
 (문제에 대한 출력물은 이미지 참고)
*/
-----------1번 문제 ---------------------------------------------------
--1988년 이후 출생자의 직업이 의사,자영업 고객을 출력하시오 (어린 고객부터 출력)
---------------------------------------------------------------------
-----------2번 문제 ---------------------------------------------------
--강남구에 사는 고객의 이름, 전화번호를 출력하시오 
---------------------------------------------------------------------
----------3번 문제 ---------------------------------------------------
--CUSTOMER에 있는 회원의 직업별 회원의 수를 출력하시오 (직업 NULL은 제외)
---------------------------------------------------------------------
----------4-1번 문제 ---------------------------------------------------
-- 가장 많이 가입(처음등록)한 요일과 건수를 출력하시오 
---------------------------------------------------------------------
----------4-2번 문제 ---------------------------------------------------
-- 남녀 인원수를 출력하시오 
---------------------------------------------------------------------
----------5번 문제 ---------------------------------------------------
--월별 예약 취소 건수를 출력하시오 (많은 달 부터 출력)
---------------------------------------------------------------------
SELECT *
FROM ADDRESS;
SELECT *
FROM CUSTOMER;
SELECT substr (birth,1,4)
,job
FROM customer
WHERE job = '자영업'
AND substr(birth,1,4) >= 1988
UNION
SELECT substr (birth,1,4)
,job
FROM customer
WHERE job = '의사'
AND substr(birth,1,4) >= 1988;
desc customer;
SELECT job,
to_char(to_date(birth),'yyyy')
FROM customer
where job in ('자영업','의사')
and substr(birth,1,4) >= 1988;



-----------2번 문제 ---------------------------------------------------
--강남구에 사는 고객의 이름, 전화번호를 출력하시오 
---------------------------------------------------------------------
SELECT a.address_detail
,c.zip_code
,a.zip_code
,c.customer_name
,c.phone_number
FROM address a, customer c
WHERE a.zip_code = c.zip_code
AND a.address_detail = '강남구';
----------3번 문제 ---------------------------------------------------
--CUSTOMER에 있는 회원의 직업별 회원의 수를 출력하시오 (직업 NULL은 제외)
---------------------------------------------------------------------
select job
,count (job) as 직업별회원수
FROM customer
WHERE job is not null  --  is not null : null 값 제외
GROUP BY job
ORDER BY 2 DESC;
----------4-1번 문제 ---------------------------------------------------
-- 가장 많이 가입(처음등록)한 요일과 건수를 출력하시오 
---------------------------------------------------------------------
select rownum, e.*
from(
        SELECT  to_char(to_date(first_reg_date),'day')
        ,count(to_char(to_date(first_reg_date),'day'))
        FROM customer
        group by to_char(to_date(first_reg_date),'day') 
        )e
where rownum = 1;

--(DECODE(cust_gender,'M',1)) as 남자;


--,SUM(DECODE (cust_gender,'M',1)) as 남자
-- nvl(sex_code,'미등록')
----------4-2번 문제 ---------------------------------------------------
-- 남녀 인원수를 출력하시오 
---------------------------------------------------------------------
SELECT 
NVL(DECODE(sex_code,'M','남자','F','여자','','미등록'),'합계') AS 젠더
,count(nvl(sex_code,0)) as 성별합
FROM customer
group by  ROLLUP (DECODE(sex_code,'M','남자','F','여자','','미등록'));

select nvl(gender,'합계') ,count (*)
from (
         select DECODE(sex_code,'M','남자','F','여자','','미등록') as gender
        from customer
        )
group by  ROLLUP(gender);

-- grouping_id group by 절에서 그룹화를 진행할 때,
--                          여러 컬럼에 대한 서브 토탈을 쉽게 구별하기 위한 함수
SELECT CASE WHEN sex_code ='M' THEN '남자'
            WHEN sex_code ='F' THEN '여자'
            WHEN sex_code IS NULL AND groupid = 0 THEN '미등록'
            ELSE '합계'
            END as gender
            ,cnt
FROM (SELECT sex_code
    ,grouping_id(sex_code) as groupid
    ,count (*) as cnt
    FROM customer
    GROUP BY ROLLUP(sex_code));

--WHere sex_code in ('M','F')
----------5번 문제 ---------------------------------------------------
--월별 예약 취소 건수를 출력하시오 (많은 달 부터 출력)
---------------------------------------------------------------------
--,count(to_char(to_date(first_reg_date),'day'))
 SELECT 
 to_char(to_date(RESERV_DATE),'MONTH') AS 달합
 ,COUNT(CANCEL) AS 취소건수
 FROM RESERVATION
 WHERE CANCEL = 'Y'
 GROUP BY  to_char(to_date(RESERV_DATE),'MONTH')
 ORDER BY 2 DESC;

--연별로 취소 안된건수 많은 년도부터 출력

SELECT 
 to_char(to_date(RESERV_DATE),'YYYY')
 ,COUNT(CANCEL) AS 취소건수
 FROM RESERVATION
  WHERE CANCEL = 'Y'
   GROUP BY  to_char(to_date(RESERV_DATE),'YYYY')
 ORDER BY 2 DESC;
