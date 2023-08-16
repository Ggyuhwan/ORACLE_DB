SELECT *
FROM employees;

SELECT *
FROM departments;

SELECT employees.emp_name
,departments.department_name
FROM employees, departments
WHERE employees.department_id = departments.department_id;

--���̺� ��Ī
SELECT emp_name -- ��� ���ʿ��� �ִ� �÷��� ��Ī �Ƚᵵ��
,department_name
,a.department_id -- ������ �÷����� �������� ��� ������ ǥ���ؾ���.
FROM employees a, departments b
WHERE a.department_id = b.department_id;

SELECT *
FROM member;
SELECT *
FROM cart;
-- member �����뾾�� īƮ(�����̷�)�̷��� ����Ͻÿ�
SELECT a.mem_name
,a.mem_id
,b.cart_member
,b.cart_no
,b.cart_prod
,b.cart_qty
FROM member a, cart b
WHERE a.mem_id = b.cart_member
AND a.mem_name ='������';

/* ANSI JOIN : American National Standards Institute
                �̱� ǥ�� SQL ��������(������ �� �� �Ⱦ�)*/

SELECT member.mem_name
,member.mem_id
,cart.cart_member
,cart.cart_no
,cart.cart_prod
,cart.cart_qty
FROM member
INNER JOIN cart
ON (member.mem_id = cart.cart_member)
AND member.mem_name ='������';

SELECT a.mem_name
,a.mem_id
,b.cart_member
,b.cart_no
,b.cart_prod
,c.prod_id
,b.cart_qty
,C.prod_name
FROM member a, cart b,PROD C
WHERE a.mem_id = b.cart_member
AND b.cart_prod = c.prod_id
AND a.mem_name ='������';

-- �����뾾�� ������ ��ü ��ǰ�� �հ� �ݾ���?
SELECT a.mem_name
,a.mem_id
,SUM(b.cart_qty * c.prod_sale) as �հ�ݾ�
FROM member a, cart b,PROD C
WHERE a.mem_id = b.cart_member
AND b.cart_prod = c.prod_id
AND a.mem_name ='������'
GROUP BY a.mem_name,a.mem_id;

SELECT member.mem_name
,member.mem_id
,SUM(cart.cart_qty * prod.prod_sale) as �հ�ݾ�
FROM member INNER JOIN cart
ON (member.mem_id = cart.cart_member)
INNER JOIN prod
ON(cart.cart_prod = prod.prod_id)
WHERE member.mem_name = '������'
GROUP BY member.mem_name,member.mem_id;
--employees, jobs ���̺��� Ȱ���Ͽ�
--salary�� 15000 �̻��� ������ ���, �̸�, salary, ���� ���̵�, �������� ����Ͻÿ�
SELECT *
FROM employees;
SELECT *
FROM jobs;
SELECT employees.employee_id
,employees.emp_name
,employees.salary
,employees.job_id
,jobs.job_title
FROM employees, jobs
WHERE employees.job_id = jobs.job_id
AND employees.salary >=15000;

SELECT a.employee_id    --���
,a.emp_name             --�̸�
,a.salary               --����               
,b.job_title            --������ 
FROM employees a        --�������̺�
, jobs b                --�������̺�
WHERE a.job_id = b.job_id
AND a.salary >=15000;

/* �������� (�����ȿ� ����)
 1.��Į�� ��������(select ��)
 2.�ζ��� ��(from ��)
 3.��ø ����(where ��)
 */
 --��Į�� ���������� ������ ��ȯ
 --���� �ڵ尪�� �̸��� �����ö� ���� ���
 --���������� �����������̺��� �� �Ǽ� ��ŭ ���������� ��ȸ�ϱ� ������
 --���������� ���̺��� �Ǽ��� ������ �ڿ��� ���� ����ϰԵ�.
 --(���� ���� ��� ������ �̿��ϴ°� �� ����)
 SELECT a.emp_name
 ,(SELECT department_name
 FROM departments
 WHERE department_id = a.department_id) as dep_name
 ,a.job_id
 ,(SELECT job_title
 FROM jobs
 WHERE job_id = a.job_id)as job_name
 FROM employees a;
 -- ��ø ��������
 -- ��ü ������ ������� ���� ������ ū ������ ���
 SELECT emp_name
 ,salary
 FROM employees
 WHERE salary >= (SELECT AVG(salary)
 FROM employees);
 
 -- ���ÿ� 2���̻��� �÷� ���� ���� �� ��ȸ
 SELECT employee_id, emp_name, job_id
 FROM employees
 WHERE (employee_id, job_id) IN (SELECT employee_id, job_id
 FROM job_history);
 
 SELECT *
 FROM member;
 --cart ��� �̷��� ���� ȸ���� ��ȸ�Ͻÿ�
 SELECT *
 FROM cart;
  SELECT *
 FROM member
 WHERE mem_id NOT IN (SELECT  cart_member
 FROM cart);
 -- member �߿��� ��ü ȸ���� ���ϸ��� ��հ� �̻��� ȸ���� ��ȸ�Ͻÿ�
 SELECT mem_name
 ,mem_job
 ,mem_mileage
 FROM member 
 WHERE mem_mileage >= (SELECT AVG(mem_mileage)
 FROM member)
 ORDER BY 3 DESC;
 
 




