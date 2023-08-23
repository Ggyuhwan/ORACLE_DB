/* 회원중 카트 사용횟수가 가장많은 고객과 
 가장적은 고객의 정보를 출력하시오(구매이력이있는) */
 SELECT max(cnt)
        ,min(cnt)
 FROM  (SELECT a.mem_id
       ,a.mem_name
       ,count(distinct b.cart_no) cnt
       FROM member a,cart b
       WHERE a.mem_id = b.cart_member
       GROUP BY a.mem_id, a.mem_name);
       
SELECT *
FROM (SELECT a.mem_id
       ,a.mem_name
       ,count(distinct b.cart_no) cnt
       FROM member a,cart b
       WHERE a.mem_id = b.cart_member
       GROUP BY a.mem_id, a.mem_name)
WHERE cnt =1
OR cnt = 8;

--WITH 
WITH T1 AS (SELECT a.mem_id
           ,a.mem_name
           ,count(distinct b.cart_no) cnt
           FROM member a,cart b
           WHERE a.mem_id = b.cart_member
           GROUP BY a.mem_id, a.mem_name
), T2 AS(
            SELECT MAX(T1.cnt) as max_cnt, MIN(T1.cnt) as min_cnt
            FROM T1
)
SELECT T1.mem_id,   T1.mem_name,T1.cnt
FROM T1,T2
WHERE T1.cnt = T2.max_cnt
OR T1.cnt = T2.min_cnt;

WITH A as(
    SELECT *
    FROM member
    )
SELECT *
FROM a;

----------
WITH T1 as (SELECT a.이름, a.학번 , a.학기
                    , b.수강내역번호, b.과목번호
                FROM 학생 a, 수강내역 b
                WHERE a.학번 = b.학번(+)
)
, T2 as (
        SELECT T1.이름, T1.학번, COUNT(T1.수강내역번호) as 수강이력건수
         FROM T1
         GROUP BY T1.이름, T1.학번
)
, T3 as (
         SELECT T1.이름, T1.학번, SUM(과목.학점) as 전체수강학점
         FROM T1, 과목
         WHERE T1.과목번호 = 과목.과목번호(+)
         GROUP BY T1.이름, T1.학번
         )
SELECT t1.학번,t1.이름, max(t2.수강이력건수), max(t3.전체수강학점)
FROM t1, t2, t3
WHERE  t1.학번 = t2.학번
AND t1.학번 = t3.학번
GROUP BY t1.학번, t1.이름;

/* WITH 절
 별칭으로 사용한 SELECT문을 다른 구문에서 참조가 가능
 반복되는 서브쿼리를 1개로 변수처럼 사용가능
 통계쿼리나 튜닝시 많이 사용
 **장점
 -temp 라는 임시 테이블을 사용해서 장시간 걸리는 쿼리결과를 저장해서
 엑세스(접근)때문에 반복되고 건수가 많은 테이블을 조회할때 성능이 좋다.
 orcle 9버전 이상에서 지원함.
 -가독성이 좋음 장점이 있음.
 **단점
 -메모리에 조회결과를 올려놓고 사용하기 때문에 오히려 성능에 문제를 줄 수 있음.
 -WITH를 제한하는 프로젝트도 있기 때문에(확인 후 사용)
*/
--------------------------------------
-- 2000년도 이탈리아의 연평균 매출액 보다 큰 월의 
-- 평균 매출액의 '년월', '매출액'을 출력하시오
--2000 이태리 연평균 매출액 구하기
SELECT cust_id, sales_month, amount_sold
FROM sales;
SELECT cust_id, country_id
FROM customers;
SELECT country_id, country_name
FROM countries;
----------
SELECT a.sales_month
        ,avg(a.amount_sold) as month_avg      -- 값 구하기
FROM sales a,customers b,countries c
WHERE a.cust_id = b.cust_id
AND b.country_id = c.country_id
AND c.country_name = 'Italy'
AND a.sales_month Like '2000%'
GROUP BY a.sales_month;

select *
from(
        SELECT a.sales_month
                ,avg(a.amount_sold) as month_avg      -- 값 구하기
        FROM sales a,customers b,countries c
        WHERE a.cust_id = b.cust_id
        AND b.country_id = c.country_id
        AND c.country_name = 'Italy'
        AND a.sales_month Like '2000%'
        GROUP BY a.sales_month)
where month_avg > (SELECT avg(c.amount_sold)
                    FROM sales c, customers d
                    WHERE c.cust_id = d.cust_id
                    and d.COUNTRY_ID = 52770
                    and SUBSTR(c.SALES_MONTH,1,4) = '2000');
---------with 절 사용한 정답문제
with  T1 as(
        select sales_month
        ,amount_sold 
        from sales,customers,countries
        where sales.cust_id = customers.cust_id
        and customers.country_id = countries.country_id
        and country_name ='Italy'
        and to_char(sales_date,'yyyy') = '2000'
),T2 as (
    SELECT AVG(t1.amount_sold) as year_avg
    FROM T1 
), T3 as (
SELECT t1.sales_month
        ,AVG(T1.amount_sold) as month_avg
        FROM T1
        GROUP BY t1.sales_month
    )

SELECT t3.sales_month
    ,round(t3.month_avg)
FROM t2, t3
WHERE t3.month_avg > t2.year_avg;

-- 내가 시도한 문제
select  *
from (
        SELECT c.SALES_MONTH
              ,round(avg(c.amount_sold))  as month_avg
        FROM sales c, customers d
        WHERE c.cust_id = d.cust_id
        and SUBSTR(c.SALES_MONTH,1,4) = '2000'
        and d.COUNTRY_ID = 52770
        GROUP BY c.SALES_MONTH 
        order by 1
        )
where month_avg > (SELECT avg(c.amount_sold)
                    FROM sales c, customers d
                    WHERE c.cust_id = d.cust_id
                    and d.COUNTRY_ID = 52770
                    and SUBSTR(c.SALES_MONTH,1,4) = '2000')
;
desc sales;

(SELECT avg(c.amount_sold)
FROM sales c, customers d
WHERE c.cust_id = d.cust_id
and d.COUNTRY_ID = 52770
and SUBSTR(c.SALES_MONTH,1,4) = '2000');



with  a1 as(
 select ROUND(AVG(amount_sold) )as 총매출평균
        from sales a,customers b,countries c
        where a.cust_id = b.cust_id
        and b.country_id = c.country_id
        and country_name ='Italy'
        and to_char(sales_date,'yyyy') = '2000'
),a2 as(SELECT a.sales_month as 달,
        ROUND(AVG(amount_sold)) as 월매출
from sales a,customers b,countries c
where a.cust_id = b.cust_id
        and b.country_id = c.country_id
        and country_name ='Italy'
        and to_char(sales_date,'yyyy') = '2000'
        group by a.sales_month)
select  a2.달, a2.월매출
from a1,a2
where a2.월매출 > a1.총매출평균
order by 1 ;

