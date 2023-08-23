-- 1998년도~2001 일본의 평균 매출액 보다 큰 1999 한정의 
-- 평균 매출액의 '년월', '매출액'을 출력하시오
SELECT *
FROM sales;
SELECT *
FROM customers;
SELECT country_id, country_name
FROM countries;

 with  t1  as(select 
    avg(a.amount_sold )as 년평균
        from sales a, customers b, countries c
        where a.cust_id = b.cust_id
        and b.country_id = c.country_id
        and country_name ='Japan')
        
, t2 as (select a.sales_month as 월,
    avg(a.amount_sold ) as 월평균
        from sales a, customers b, countries c
        where a.cust_id = b.cust_id
        and b.country_id = c.country_id
        and country_name ='Japan'
       group by a.sales_month
       order by 1 desc)
    select t2.월 ,t2.월평균
    from t1,t2
    where t2.월평균 < t1.년평균;
   
       
        --and to_char(sales_date,'yyyy') = '1980';