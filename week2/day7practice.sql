-- �������� ����
SELECT �����̸�
,����
,SUM(�����ο�)AS �Ѽ����ο�
FROM ����, ���ǳ���
WHERE �����̸� = '�̼���'
AND ����.������ȣ = ���ǳ���.������ȣ
GROUP BY �����̸�,����;
SELECT *
FROM �л�;
SELECT *
FROM ����;

SELECT �̸�
,�����̸�
,ROUND(����,2)
FROM �л�,����
WHERE ���� >=(SELECT AVG(����)
FROM �л�)
AND �л�.���� = ����.����;

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
AND a.mem_name='������';

