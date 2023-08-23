
----------6번 문제 ---------------------------------------------------
 -- 전체 상품별 '상품이름', '상품매출' 을 내림차순으로 구하시오 
-----------------------------------------------------------------------------
SELECT i.PRODUCT_NAME
,sum(i.price * o.quantity) as 상품매출
FROM ITEM i, ORDER_INFO o
WHERE i.ITEM_ID = o.ITEM_ID
GROUP BY i.PRODUCT_NAME
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