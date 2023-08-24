
----------6번 문제 ---------------------------------------------------
 -- 전체 상품별 '상품이름', '상품매출' 을 내림차순으로 구하시오 
-----------------------------------------------------------------------------
SELECT i.PRODUCT_NAME
,sum(i.price * o.quantity) as 상품매출
FROM ITEM i, ORDER_INFO o
WHERE i.ITEM_ID = o.ITEM_ID
GROUP BY i.PRODUCT_NAME
ORDER BY 2 DESC;
--- 선생님 풀이
SELECT 
i.PRODUCT_NAME
,SUM(o.sales) as 상품매출
FROM ITEM i, ORDER_INFO o
WHERE i.ITEM_ID = o.ITEM_ID
GROUP BY o.item_id,i.PRODUCT_NAME
ORDER BY 2 DESC;
---------- 7번 문제 ---------------------------------------------------
-- 모든상품의 월별 매출액을 구하시오 
-- 매출월, SPECIAL_SET, PASTA, PIZZA, SEA_FOOD, STEAK, SALAD_BAR, SALAD, SANDWICH, WINE, JUICE
----------------------------------------------------------------------------
SELECT substr(o.RESERV_NO,1,6) as 매출월
        ,SUM(DECODE(i.PRODUCT_NAME,'SPECIAL_SET',o.sales))as SPECIAL_SET
        ,SUM(DECODE(i.PRODUCT_NAME,'PASTA',o.sales)) as PASTA
        ,NVL(SUM(DECODE(i.PRODUCT_NAME,'PIZZA',o.sales)),0) as PIZZA
        ,NVL(SUM(DECODE(i.PRODUCT_NAME,'SEA_FOOD',o.sales)),0)as SEA_FOOD
        ,SUM(DECODE(i.PRODUCT_NAME,'STEAK',o.sales))as STEAK
        ,NVL(SUM(DECODE(i.PRODUCT_NAME,'SALAD_BAR',o.sales)),0)as SALAD_BAR
        ,NVL(SUM(DECODE(i.PRODUCT_NAME,'SALAD',o.sales)),0)as SALAD
        ,SUM(DECODE(i.PRODUCT_NAME,'SANDWICH',o.sales))as SANDWICH
        ,NVL(SUM(DECODE(i.PRODUCT_NAME,'WINE',o.sales)),0)as WINE
        ,SUM(DECODE(i.PRODUCT_NAME,'JUICE',o.sales))as JUICE
FROM ITEM i, ORDER_INFO o
WHERE i.ITEM_ID = o.ITEM_ID
GROUP BY substr(o.RESERV_NO,1,6)
ORDER BY 1;
-----선생님 풀이
SELECT substr(a.reserv_date,1,6) as 매출월
        ,SUM(DECODE(b.item_id,'M0001',b.sales,0)) SOECIAL_SET
        ,SUM(DECODE(b.item_id,'M0002',b.sales,0)) as PASTA
        ,SUM(DECODE(b.item_id,'M0003',b.sales,0)) as PIZZA
        ,SUM(DECODE(b.item_id,'M0004',b.sales,0)) as SEA_FOOD
     
FROM reservation a ,order_info b
WHERE a.reserv_no = b.reserv_no
GROUP BY substr(a.reserv_date,1,6);
SELECT *
FROM order_info;

---------- 8번 문제 ---------------------------------------------------
-- 월별 온라인_전용 상품 매출액을 일요일부터 월요일까지 구분해 출력하시오 
-- 날짜, 상품명, 일요일, 월요일, 화요일, 수요일, 목요일, 금요일, 토요일의 매출을 구하시오 
----------------------------------------------------------------------------
--TO_CHAR(SYSDATE, 'DAY')  TO_CHAR(O.RESERV_NO,'DAY')
SELECT TO_CHAR(TO_DATE(SUBSTR(RESERV_NO,1,8),'YYYYMMDD'),'DAY')
FROM ORDER_INFO;
desc ORDER_INFO;
SELECT substr(o.RESERV_NO,1,6) as 매출월
        ,i.product_name
        ,NVL(SUM(DECODE(TO_CHAR(TO_DATE(SUBSTR(RESERV_NO,1,8),'YYYYMMDD'),'DAY'),'일요일',o.sales)),0)as 일요일  
        ,NVL(SUM(DECODE(TO_CHAR(TO_DATE(SUBSTR(RESERV_NO,1,8),'YYYYMMDD'),'DAY'),'월요일',o.sales)),0)as 월요일 
        ,NVL(SUM(DECODE(TO_CHAR(TO_DATE(SUBSTR(RESERV_NO,1,8),'YYYYMMDD'),'DAY'),'화요일',o.sales)),0)as 화요일 
        ,NVL(SUM(DECODE(TO_CHAR(TO_DATE(SUBSTR(RESERV_NO,1,8),'YYYYMMDD'),'DAY'),'수요일',o.sales)),0)as 수요일 
        ,NVL(SUM(DECODE(TO_CHAR(TO_DATE(SUBSTR(RESERV_NO,1,8),'YYYYMMDD'),'DAY'),'목요일',o.sales)),0)as 목요일 
        ,NVL(SUM(DECODE(TO_CHAR(TO_DATE(SUBSTR(RESERV_NO,1,8),'YYYYMMDD'),'DAY'),'금요일',o.sales)),0)as 금요일 
        ,NVL(SUM(DECODE(TO_CHAR(TO_DATE(SUBSTR(RESERV_NO,1,8),'YYYYMMDD'),'DAY'),'토요일',o.sales)),0)as 토요일 
FROM ITEM i, ORDER_INFO o
WHERE i.ITEM_ID = o.ITEM_ID
and i.product_name='SPECIAL_SET'
GROUP BY substr(o.RESERV_NO,1,6),i.product_name
ORDER BY 1;
---------선생님 풀이
SELECT  매출월
    , 상품이름
    , SUM(DECODE(요일, '일요일', sales, 0)) as 일요일
    , SUM(DECODE(요일, '월요일', sales, 0)) as 일요일
    from(
            SELECT SUBSTR(a.reserv_date,1,6)  AS 매출월
                ,c.product_desc             AS 상품이름
                ,TO_CHAR(TO_DATE(a.reserv_date),'day') AS 요일
                ,b.sales
            FROM reservation a, order_info b, item c
            WHERE a.reserv_no = b.reserv_no
            AND b.item_id = c.item_id
            AND c.product_desc = '온라인_전용상품'
            )
GROUP BY 매출월,상품이름;


-- ,(SELECT PRODUCT_NAME
--                            FROM ITEM
--                            WHERE PRODUCT_NAME = 'SPECIAL_SET')as 상품명

---------- 9번 문제 ----------------------------------------------------
--매출이력이 있는 고객의 주소, 우편번호, 해당지역 고객수를 출력하시오
----------------------------------------------------------------------------
select a.address_detail,count(a.address_detail)
from address a, customer b
where a.zip_code = b.zip_code
group by a.address_detail
order by 2 desc;

select a.ADDRESS_DETAIL as 주소
,count(DISTINCT((CUSTOMER_NAME))) as 카운팅
from address a, reservation b , customer c
where a.zip_code = c.zip_code 
and b.customer_id = c.customer_id
and b.cancel = 'N'
group by a.ADDRESS_DETAIL 
ORDER BY 2 DESC;
-----------------선생님 풀이
SELECT t2.address_detail as 주소
        ,count(*)       as 회원수 
FROM (
        SELECT DISTINCT a.customer_id, a.zip_code
        FROM customer a, reservation b, order_info c 
        WHERE a.customer_id = b.customer_id
        AND b.reserv_no = c.reserv_no
    )T1, address T2
WHERE t1.zip_code = t2.zip_code
GROUP BY t1.zip_code,t2.address_detail
ORDER BY 2 DESC;

--------------------------------------------
-- 고객별 지점(branch) 방문횟수와 방문객의 합을 출력
-- 방문횟수 4번 이상한 분 출력 (예약취소건 제외)


select b.CUSTOMER_ID
        ,b.customer_name
        ,a.branch
        ,count(a.branch)
        ,sum(a.VISITOR_CNT)
from RESERVATION a, CUSTOMER b
where a.CUSTOMER_ID = b.CUSTOMER_ID
AND a.CANCEL = 'N'
group by b.CUSTOMER_ID,b.customer_name,a.branch
HAVING COUNT(A.branch) >=4
order by 4 desc;

SELECT customer_id
FROM(
        SELECT a.CUSTOMER_ID, a.customer_name, b.branch
        ,count(b.branch) as 방문횟수
        , sum(b.visitor_cnt) as 방문고객수
        FROM customer a, reservation b
        WHERE a.CUSTOMER_ID = b.CUSTOMER_ID
        AND b.CANCEL = 'N'
        group by a.CUSTOMER_ID,a.customer_name,b.branch
        order by 4 desc, 5 desc)
WHERE rownum <=1;
-- 가장 방문을 많이 한 고객의 그동안 구매한 품목별 합산금액을 출력하시오
--W1338910
SELECT reserv_no
FROM reservation
WHERE cancel = 'N'
AND customer_id ='W1338910';
--구매이력합계
SELECT (SELECT product_name FROM item WHERE item_id = a.item_id) as category
     , SUM(a.sales) as 구매합계
FROM order_info a
WHERE a.reserv_no IN (SELECT reserv_no 
                        FROM reservation 
                        WHERE cancel = 'N'
                        AND customer_id =(SELECT customer_id
                                            FROM (
                                                    SELECT a.customer_id , a.customer_name, b.branch
                                                         , COUNT(b.branch) as 방문횟수
                                                         , SUM(b.visitor_cnt) as 방문고객수
                                                    FROM customer a, reservation b
                                                    WHERE a.customer_id = b.customer_id
                                                    AND b.cancel = 'N'
                                                    GROUP BY a.customer_id, a.customer_name, b.branch
                                                    ORDER BY 4 DESC, 5 DESC
                                                   )
                                            WHERE rownum <=1 )
                        )
GROUP BY a.item_id;

--동현이 풀이
select  *
from(select *
from (SELECT a.customer_id
     , a.customer_name
     , b.branch
     , COUNT(b.branch)    as 지점방문횟수
     , SUM(b.visitor_cnt) as 방문객수
FROM customer a, reservation b
WHERE a.customer_id = b.customer_id
AND   b.cancel = 'N'
GROUP BY a.customer_id, a.customer_name, b.branch
--HAVING COUNT(b.branch) >= 4
ORDER BY 4 DESC, 5 DESC) c
where c.지점방문횟수 >= 4)
where rownum = 1;

