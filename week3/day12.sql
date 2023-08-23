/* ȸ���� īƮ ���Ƚ���� ���帹�� ���� 
 �������� ���� ������ ����Ͻÿ�(�����̷����ִ�) */
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
WITH T1 as (SELECT a.�̸�, a.�й� , a.�б�
                    , b.����������ȣ, b.�����ȣ
                FROM �л� a, �������� b
                WHERE a.�й� = b.�й�(+)
)
, T2 as (
        SELECT T1.�̸�, T1.�й�, COUNT(T1.����������ȣ) as �����̷°Ǽ�
         FROM T1
         GROUP BY T1.�̸�, T1.�й�
)
, T3 as (
         SELECT T1.�̸�, T1.�й�, SUM(����.����) as ��ü��������
         FROM T1, ����
         WHERE T1.�����ȣ = ����.�����ȣ(+)
         GROUP BY T1.�̸�, T1.�й�
         )
SELECT t1.�й�,t1.�̸�, max(t2.�����̷°Ǽ�), max(t3.��ü��������)
FROM t1, t2, t3
WHERE  t1.�й� = t2.�й�
AND t1.�й� = t3.�й�
GROUP BY t1.�й�, t1.�̸�;

/* WITH ��
 ��Ī���� ����� SELECT���� �ٸ� �������� ������ ����
 �ݺ��Ǵ� ���������� 1���� ����ó�� ��밡��
 ��������� Ʃ�׽� ���� ���
 **����
 -temp ��� �ӽ� ���̺��� ����ؼ� ��ð� �ɸ��� ��������� �����ؼ�
 ������(����)������ �ݺ��ǰ� �Ǽ��� ���� ���̺��� ��ȸ�Ҷ� ������ ����.
 orcle 9���� �̻󿡼� ������.
 -�������� ���� ������ ����.
 **����
 -�޸𸮿� ��ȸ����� �÷����� ����ϱ� ������ ������ ���ɿ� ������ �� �� ����.
 -WITH�� �����ϴ� ������Ʈ�� �ֱ� ������(Ȯ�� �� ���)
*/
--------------------------------------
-- 2000�⵵ ��Ż������ ����� ����� ���� ū ���� 
-- ��� ������� '���', '�����'�� ����Ͻÿ�
--2000 ���¸� ����� ����� ���ϱ�
SELECT cust_id, sales_month, amount_sold
FROM sales;
SELECT cust_id, country_id
FROM customers;
SELECT country_id, country_name
FROM countries;
----------
SELECT a.sales_month
        ,avg(a.amount_sold) as month_avg      -- �� ���ϱ�
FROM sales a,customers b,countries c
WHERE a.cust_id = b.cust_id
AND b.country_id = c.country_id
AND c.country_name = 'Italy'
AND a.sales_month Like '2000%'
GROUP BY a.sales_month;

select *
from(
        SELECT a.sales_month
                ,avg(a.amount_sold) as month_avg      -- �� ���ϱ�
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
---------with �� ����� ���乮��
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

-- ���� �õ��� ����
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
 select ROUND(AVG(amount_sold) )as �Ѹ������
        from sales a,customers b,countries c
        where a.cust_id = b.cust_id
        and b.country_id = c.country_id
        and country_name ='Italy'
        and to_char(sales_date,'yyyy') = '2000'
),a2 as(SELECT a.sales_month as ��,
        ROUND(AVG(amount_sold)) as ������
from sales a,customers b,countries c
where a.cust_id = b.cust_id
        and b.country_id = c.country_id
        and country_name ='Italy'
        and to_char(sales_date,'yyyy') = '2000'
        group by a.sales_month)
select  a2.��, a2.������
from a1,a2
where a2.������ > a1.�Ѹ������
order by 1 ;

