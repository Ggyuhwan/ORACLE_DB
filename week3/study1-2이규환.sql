
----------6�� ���� ---------------------------------------------------
 -- ��ü ��ǰ�� '��ǰ�̸�', '��ǰ����' �� ������������ ���Ͻÿ� 
-----------------------------------------------------------------------------
SELECT i.PRODUCT_NAME
,sum(i.price * o.quantity) as ��ǰ����
FROM ITEM i, ORDER_INFO o
WHERE i.ITEM_ID = o.ITEM_ID
GROUP BY i.PRODUCT_NAME
ORDER BY 2 DESC;
--- ������ Ǯ��
SELECT 
i.PRODUCT_NAME
,SUM(o.sales) as ��ǰ����
FROM ITEM i, ORDER_INFO o
WHERE i.ITEM_ID = o.ITEM_ID
GROUP BY o.item_id,i.PRODUCT_NAME
ORDER BY 2 DESC;
---------- 7�� ���� ---------------------------------------------------
-- ����ǰ�� ���� ������� ���Ͻÿ� 
-- �����, SPECIAL_SET, PASTA, PIZZA, SEA_FOOD, STEAK, SALAD_BAR, SALAD, SANDWICH, WINE, JUICE
----------------------------------------------------------------------------
SELECT substr(o.RESERV_NO,1,6) as �����
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
-----������ Ǯ��
SELECT substr(a.reserv_date,1,6) as �����
        ,SUM(DECODE(b.item_id,'M0001',b.sales,0)) SOECIAL_SET
        ,SUM(DECODE(b.item_id,'M0002',b.sales,0)) as PASTA
        ,SUM(DECODE(b.item_id,'M0003',b.sales,0)) as PIZZA
        ,SUM(DECODE(b.item_id,'M0004',b.sales,0)) as SEA_FOOD
     
FROM reservation a ,order_info b
WHERE a.reserv_no = b.reserv_no
GROUP BY substr(a.reserv_date,1,6);
SELECT *
FROM order_info;

---------- 8�� ���� ---------------------------------------------------
-- ���� �¶���_���� ��ǰ ������� �Ͽ��Ϻ��� �����ϱ��� ������ ����Ͻÿ� 
-- ��¥, ��ǰ��, �Ͽ���, ������, ȭ����, ������, �����, �ݿ���, ������� ������ ���Ͻÿ� 
----------------------------------------------------------------------------
--TO_CHAR(SYSDATE, 'DAY')  TO_CHAR(O.RESERV_NO,'DAY')
SELECT TO_CHAR(TO_DATE(SUBSTR(RESERV_NO,1,8),'YYYYMMDD'),'DAY')
FROM ORDER_INFO;
desc ORDER_INFO;
SELECT substr(o.RESERV_NO,1,6) as �����
        ,i.product_name
        ,NVL(SUM(DECODE(TO_CHAR(TO_DATE(SUBSTR(RESERV_NO,1,8),'YYYYMMDD'),'DAY'),'�Ͽ���',o.sales)),0)as �Ͽ���  
        ,NVL(SUM(DECODE(TO_CHAR(TO_DATE(SUBSTR(RESERV_NO,1,8),'YYYYMMDD'),'DAY'),'������',o.sales)),0)as ������ 
        ,NVL(SUM(DECODE(TO_CHAR(TO_DATE(SUBSTR(RESERV_NO,1,8),'YYYYMMDD'),'DAY'),'ȭ����',o.sales)),0)as ȭ���� 
        ,NVL(SUM(DECODE(TO_CHAR(TO_DATE(SUBSTR(RESERV_NO,1,8),'YYYYMMDD'),'DAY'),'������',o.sales)),0)as ������ 
        ,NVL(SUM(DECODE(TO_CHAR(TO_DATE(SUBSTR(RESERV_NO,1,8),'YYYYMMDD'),'DAY'),'�����',o.sales)),0)as ����� 
        ,NVL(SUM(DECODE(TO_CHAR(TO_DATE(SUBSTR(RESERV_NO,1,8),'YYYYMMDD'),'DAY'),'�ݿ���',o.sales)),0)as �ݿ��� 
        ,NVL(SUM(DECODE(TO_CHAR(TO_DATE(SUBSTR(RESERV_NO,1,8),'YYYYMMDD'),'DAY'),'�����',o.sales)),0)as ����� 
FROM ITEM i, ORDER_INFO o
WHERE i.ITEM_ID = o.ITEM_ID
and i.product_name='SPECIAL_SET'
GROUP BY substr(o.RESERV_NO,1,6),i.product_name
ORDER BY 1;
---------������ Ǯ��
SELECT  �����
    , ��ǰ�̸�
    , SUM(DECODE(����, '�Ͽ���', sales, 0)) as �Ͽ���
    , SUM(DECODE(����, '������', sales, 0)) as �Ͽ���
    from(
            SELECT SUBSTR(a.reserv_date,1,6)  AS �����
                ,c.product_desc             AS ��ǰ�̸�
                ,TO_CHAR(TO_DATE(a.reserv_date),'day') AS ����
                ,b.sales
            FROM reservation a, order_info b, item c
            WHERE a.reserv_no = b.reserv_no
            AND b.item_id = c.item_id
            AND c.product_desc = '�¶���_�����ǰ'
            )
GROUP BY �����,��ǰ�̸�;


-- ,(SELECT PRODUCT_NAME
--                            FROM ITEM
--                            WHERE PRODUCT_NAME = 'SPECIAL_SET')as ��ǰ��

---------- 9�� ���� ----------------------------------------------------
--�����̷��� �ִ� ���� �ּ�, �����ȣ, �ش����� ������ ����Ͻÿ�
----------------------------------------------------------------------------
select a.address_detail,count(a.address_detail)
from address a, customer b
where a.zip_code = b.zip_code
group by a.address_detail
order by 2 desc;

select a.ADDRESS_DETAIL as �ּ�
,count(DISTINCT((CUSTOMER_NAME))) as ī����
from address a, reservation b , customer c
where a.zip_code = c.zip_code 
and b.customer_id = c.customer_id
and b.cancel = 'N'
group by a.ADDRESS_DETAIL 
ORDER BY 2 DESC;
-----------------������ Ǯ��
SELECT t2.address_detail as �ּ�
        ,count(*)       as ȸ���� 
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
-- ���� ����(branch) �湮Ƚ���� �湮���� ���� ���
-- �湮Ƚ�� 4�� �̻��� �� ��� (������Ұ� ����)


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
        ,count(b.branch) as �湮Ƚ��
        , sum(b.visitor_cnt) as �湮����
        FROM customer a, reservation b
        WHERE a.CUSTOMER_ID = b.CUSTOMER_ID
        AND b.CANCEL = 'N'
        group by a.CUSTOMER_ID,a.customer_name,b.branch
        order by 4 desc, 5 desc)
WHERE rownum <=1;
-- ���� �湮�� ���� �� ���� �׵��� ������ ǰ�� �ջ�ݾ��� ����Ͻÿ�
--W1338910
SELECT reserv_no
FROM reservation
WHERE cancel = 'N'
AND customer_id ='W1338910';
--�����̷��հ�
SELECT (SELECT product_name FROM item WHERE item_id = a.item_id) as category
     , SUM(a.sales) as �����հ�
FROM order_info a
WHERE a.reserv_no IN (SELECT reserv_no 
                        FROM reservation 
                        WHERE cancel = 'N'
                        AND customer_id =(SELECT customer_id
                                            FROM (
                                                    SELECT a.customer_id , a.customer_name, b.branch
                                                         , COUNT(b.branch) as �湮Ƚ��
                                                         , SUM(b.visitor_cnt) as �湮����
                                                    FROM customer a, reservation b
                                                    WHERE a.customer_id = b.customer_id
                                                    AND b.cancel = 'N'
                                                    GROUP BY a.customer_id, a.customer_name, b.branch
                                                    ORDER BY 4 DESC, 5 DESC
                                                   )
                                            WHERE rownum <=1 )
                        )
GROUP BY a.item_id;

--������ Ǯ��
select  *
from(select *
from (SELECT a.customer_id
     , a.customer_name
     , b.branch
     , COUNT(b.branch)    as �����湮Ƚ��
     , SUM(b.visitor_cnt) as �湮����
FROM customer a, reservation b
WHERE a.customer_id = b.customer_id
AND   b.cancel = 'N'
GROUP BY a.customer_id, a.customer_name, b.branch
--HAVING COUNT(b.branch) >= 4
ORDER BY 4 DESC, 5 DESC) c
where c.�����湮Ƚ�� >= 4)
where rownum = 1;

