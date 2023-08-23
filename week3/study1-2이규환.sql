
----------6�� ���� ---------------------------------------------------
 -- ��ü ��ǰ�� '��ǰ�̸�', '��ǰ����' �� ������������ ���Ͻÿ� 
-----------------------------------------------------------------------------
SELECT i.PRODUCT_NAME
,sum(i.price * o.quantity) as ��ǰ����
FROM ITEM i, ORDER_INFO o
WHERE i.ITEM_ID = o.ITEM_ID
GROUP BY i.PRODUCT_NAME
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