-- 민혁이형 문제
SELECT 교수이름
,전공
,SUM(수강인원)AS 총수강인원
FROM 교수, 강의내역
WHERE 교수이름 = '이소진'
AND 교수.교수번호 = 강의내역.교수번호
GROUP BY 교수이름,전공;
SELECT *
FROM 학생;
SELECT *
FROM 교수;

SELECT 이름
,교수이름
,ROUND(평점,2)
FROM 학생,교수
WHERE 평점 >=(SELECT AVG(평점)
FROM 학생)
AND 학생.전공 = 교수.전공;

select region

,sum(LOAN_JAN_AMT)
FROM kor_loan_status
where period like '2013%'
group by region
ORDER BY 1;

select *
from employees;
select*
from departments;
select a.emp_name
,b.department_name
from employees a, departments b
where a.department_id = b.department_id;

select a.mem_name
,a.mem_id
,b.cart_member
,b.cart_no
,b.cart_prod
,b.cart_qty
,c.prod_name
FROM member a, cart b,prod c
where a.mem_id= b.cart_member
And b.cart_prod = c.prod_id
AND a.mem_name='김은대';

