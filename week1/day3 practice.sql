-- 1998�⵵~2001 �Ϻ��� ��� ����� ���� ū 1999 ������ 
-- ��� ������� '���', '�����'�� ����Ͻÿ�
SELECT *
FROM sales;
SELECT *
FROM customers;
SELECT country_id, country_name
FROM countries;

 with  t1  as(select 
    avg(a.amount_sold )as �����
        from sales a, customers b, countries c
        where a.cust_id = b.cust_id
        and b.country_id = c.country_id
        and country_name ='Japan')
        
, t2 as (select a.sales_month as ��,
    avg(a.amount_sold ) as �����
        from sales a, customers b, countries c
        where a.cust_id = b.cust_id
        and b.country_id = c.country_id
        and country_name ='Japan'
       group by a.sales_month
       order by 1 desc)
    select t2.�� ,t2.�����
    from t1,t2
    where t2.����� < t1.�����;
   
       
        --and to_char(sales_date,'yyyy') = '1980';