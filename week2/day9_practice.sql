/*
 STUDY ������ create_table ��ũ��Ʈ�� �����Ͽ� 
 ���̺� ������ 1~ 5 �����͸� ����Ʈ�� �� 
 �Ʒ� ������ ����Ͻÿ� 
 (������ ���� ��¹��� �̹��� ����)
*/
-----------1�� ���� ---------------------------------------------------
--1988�� ���� ������� ������ �ǻ�,�ڿ��� ���� ����Ͻÿ� (� ������ ���)
---------------------------------------------------------------------
-----------2�� ���� ---------------------------------------------------
--�������� ��� ���� �̸�, ��ȭ��ȣ�� ����Ͻÿ� 
---------------------------------------------------------------------
----------3�� ���� ---------------------------------------------------
--CUSTOMER�� �ִ� ȸ���� ������ ȸ���� ���� ����Ͻÿ� (���� NULL�� ����)
---------------------------------------------------------------------
----------4-1�� ���� ---------------------------------------------------
-- ���� ���� ����(ó�����)�� ���ϰ� �Ǽ��� ����Ͻÿ� 
---------------------------------------------------------------------
----------4-2�� ���� ---------------------------------------------------
-- ���� �ο����� ����Ͻÿ� 
---------------------------------------------------------------------
----------5�� ���� ---------------------------------------------------
--���� ���� ��� �Ǽ��� ����Ͻÿ� (���� �� ���� ���)
---------------------------------------------------------------------
SELECT *
FROM ADDRESS;
SELECT *
FROM CUSTOMER;
SELECT substr (birth,1,4)
,job
FROM customer
WHERE job = '�ڿ���'
AND substr(birth,1,4) >= 1988
UNION
SELECT substr (birth,1,4)
,job
FROM customer
WHERE job = '�ǻ�'
AND substr(birth,1,4) >= 1988;
desc customer;
SELECT job,
to_char(to_date(birth),'yyyy')
FROM customer
where job in ('�ڿ���','�ǻ�')
and substr(birth,1,4) >= 1988;



-----------2�� ���� ---------------------------------------------------
--�������� ��� ���� �̸�, ��ȭ��ȣ�� ����Ͻÿ� 
---------------------------------------------------------------------
SELECT a.address_detail
,c.zip_code
,a.zip_code
,c.customer_name
,c.phone_number
FROM address a, customer c
WHERE a.zip_code = c.zip_code
AND a.address_detail = '������';
----------3�� ���� ---------------------------------------------------
--CUSTOMER�� �ִ� ȸ���� ������ ȸ���� ���� ����Ͻÿ� (���� NULL�� ����)
---------------------------------------------------------------------
select job
,count (job) as ������ȸ����
FROM customer
WHERE job is not null  --  is not null : null �� ����
GROUP BY job
ORDER BY 2 DESC;
----------4-1�� ���� ---------------------------------------------------
-- ���� ���� ����(ó�����)�� ���ϰ� �Ǽ��� ����Ͻÿ� 
---------------------------------------------------------------------
select rownum, e.*
from(
        SELECT  to_char(to_date(first_reg_date),'day')
        ,count(to_char(to_date(first_reg_date),'day'))
        FROM customer
        group by to_char(to_date(first_reg_date),'day') 
        )e
where rownum = 1;

--(DECODE(cust_gender,'M',1)) as ����;


--,SUM(DECODE (cust_gender,'M',1)) as ����
-- nvl(sex_code,'�̵��')
----------4-2�� ���� ---------------------------------------------------
-- ���� �ο����� ����Ͻÿ� 
---------------------------------------------------------------------
SELECT 
NVL(DECODE(sex_code,'M','����','F','����','','�̵��'),'�հ�') AS ����
,count(nvl(sex_code,0)) as ������
FROM customer
group by  ROLLUP (DECODE(sex_code,'M','����','F','����','','�̵��'));

select nvl(gender,'�հ�') ,count (*)
from (
         select DECODE(sex_code,'M','����','F','����','','�̵��') as gender
        from customer
        )
group by  ROLLUP(gender);

-- grouping_id group by ������ �׷�ȭ�� ������ ��,
--                          ���� �÷��� ���� ���� ��Ż�� ���� �����ϱ� ���� �Լ�
SELECT CASE WHEN sex_code ='M' THEN '����'
            WHEN sex_code ='F' THEN '����'
            WHEN sex_code IS NULL AND groupid = 0 THEN '�̵��'
            ELSE '�հ�'
            END as gender
            ,cnt
FROM (SELECT sex_code
    ,grouping_id(sex_code) as groupid
    ,count (*) as cnt
    FROM customer
    GROUP BY ROLLUP(sex_code));

--WHere sex_code in ('M','F')
----------5�� ���� ---------------------------------------------------
--���� ���� ��� �Ǽ��� ����Ͻÿ� (���� �� ���� ���)
---------------------------------------------------------------------
--,count(to_char(to_date(first_reg_date),'day'))
 SELECT 
 to_char(to_date(RESERV_DATE),'MONTH') AS ����
 ,COUNT(CANCEL) AS ��ҰǼ�
 FROM RESERVATION
 WHERE CANCEL = 'Y'
 GROUP BY  to_char(to_date(RESERV_DATE),'MONTH')
 ORDER BY 2 DESC;

--������ ��� �ȵȰǼ� ���� �⵵���� ���

SELECT 
 to_char(to_date(RESERV_DATE),'YYYY')
 ,COUNT(CANCEL) AS ��ҰǼ�
 FROM RESERVATION
  WHERE CANCEL = 'Y'
   GROUP BY  to_char(to_date(RESERV_DATE),'YYYY')
 ORDER BY 2 DESC;
