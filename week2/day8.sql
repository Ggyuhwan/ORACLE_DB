/* INNER JOIN ��������(��������)
*/
SELECT *
FROM �л�;
SELECT*
FROM ��������;

SELECT �л�.�й�
        ,�л�.�̸�
        ,�л�.����
        ,��������.����������ȣ
        ,��������.�����ȣ
        ,����.�����̸�
        ,����.����
FROM �л� ,��������, ����
WHERE �л�.�й� = ��������.�й�
AND ��������.�����ȣ = ����.�����ȣ
AND �л�.�̸� ='�ּ���';

--�ּ����� ���� �������� ����Ͻÿ�
SELECT �л�.�й�
    ,�л�.�̸�
    ,SUM(����) AS ��������
FROM �л� ,��������, ����
WHERE �л�.�й� = ��������.�й�
AND ��������.�����ȣ = ����.�����ȣ
AND �л�.�̸� ='�ּ���'
GROUP BY �л�.�̸�
        ,�л�.�й�;
        
/* OUTER JOIN �ܺ�����
��� ���ʿ� null ���� ���Խ��Ѿ� �Ҷ�
(������ ���������̺��� ������ ���Խ��Ѿ��ϸ� �ƿ�����������)
*/
SELECT *
FROM �л� ,��������                     -- null�� ���Խ�ų ���̺���
WHERE �л�.�й� = ��������.�й�(+) --(+) <-- ���ʿ��� �� �� ����
AND �л�.�̸� = '������';

-- �л��� �����̷� �Ǽ��� ����Ͻÿ�
-- ����л� ��� null�̸� 0����

SELECT �л�.�й�
    ,�л�.�̸�
    ,COUNT(��������.����������ȣ) AS ���������Ǽ�
    ,SUM(NVL(����.����,0))AS ������
FROM �л� ,��������, ���� a                     
WHERE �л�.�й� = ��������.�й�(+)
AND ��������.�����ȣ = ����.�����ȣ(+)
GROUP BY �л�.�й�,�л�.�̸�
ORDER BY 3 DESC;

SELECT* 
FROM �л�, ��������
WHERE �л�.�й� = ��������.�й�(+);
        
SELECT �л�.�й�
    ,�л�.�̸�
    ,�л�.����
    ,��������.����������ȣ
    ,��������.�����ȣ
    ,(SELECT �����̸�       -- ��Į�� �������� (������ ��밡��)
    FROM ����
    WHERE �����ȣ = ��������.�����ȣ) AS �����̸�
FROM �л� ,��������, ����
WHERE �л�.�й� = ��������.�й�
AND ��������.�����ȣ = ����.�����ȣ
AND �л�.�̸� ='�ּ���';       
  
  /* �л��� ������ �ο����� ����Ͻÿ� */
SELECT ����
,COUNT(*) as �л���
FROM �л�
GROUP BY ����
ORDER BY 2 DESC;
--��� ���� �̻��� ģ��
SELECT �й� 
    ,�̸�
    ,����
FROM �л�
WHERE ���� >=(SELECT AVG(����)
            FROM �л�)    --��ø ��������
ORDER BY 3 DESC ;
--���� ����ģ��
SELECT �й� 
    ,�̸�
    ,����
FROM �л�
WHERE ���� =(SELECT MAX(����)
            FROM �л�)
ORDER BY 3 DESC ;

SELECT �л�.�й�
    ,�л�.�̸�
    ,�л�.����
    ,����.�����̸�
    ,�л�.����
FROM �л�, ����
WHERE ���� >= (SELECT AVG(����)
FROM �л�)
AND �л�.���� = ����.����;
--���������� ���� �л���?
SELECT *
FROM �л�
WHERE �й� NOT IN (SELECT �й�
FROM ��������);
/* �ζ��� �� (FROM ��)
SELECT ���� ���� ����� ��ġ ���̺�ó�� ���
*/
SELECT *
FROM (SELECT ROWNUM as rnum ,
        �й�, �̸�, ����
FROM �л�) a  -- SELECT���� ���̺�ó�� ���
WHERE a.rnum BETWEEN 2 AND 5;
select *
from (
        SELECT ROWNUM as rnum
                ,a.*
        FROM (
                SELECT employee_id
                    ,emp_name
                    ,salary
                FROM employees
                WHERE emp_name LIKE 'K%'
                ORDER BY emp_name
                ) a
        )
WHERE rnum BETWEEN 1 AND 5 
ORDER BY 4 DESC;

SELECT ROWNUM as rnum
, a.*
FROM employees a
ORDER BY emp_name;

/* �л��߿� ���� ���� 5�� ����Ͻÿ� */
SELECT �̸�
    ,����
    ,����
    ,A.RNUM
FROM (SELECT ROWNUM as rnum ,�̸�,����,����
FROM �л�) a
WHERE a.rnum BETWEEN 1 AND 5
ORDER BY 3 DESC;
-- ����
SELECT rownum as ����
        ,a.*
FROM ( SELECT �̸�
,����
FROM �л�
ORDER BY ���� DESC) 
a
WHERE rownum <=5;
--Ư�� ���
SELECT *
FROM (SELECT rownum as ����
        ,a.*
FROM ( SELECT �̸�
    ,����
    FROM �л�
    ORDER BY ���� DESC) a
    )
WHERE ���� = 2;
--member, cart, prod �� ����Ͽ�
--���� īƮ���Ƚ��, ��ǰǰ��Ǽ�, ��ǰ���ż���, �ѱ��űݾ��� ����Ͻÿ�
--�����̷��� ���ٸ� 0 <- ���� ��µǵ���

select count(distinct cart_no)  -- �ߺ�����
    , count(*)
from cart
where cart_member = 'a001';


SELECT member.mem_id
      ,member.mem_name
      ,COUNT(distinct cart.cart_no) as īƮ���Ƚ�� 
      ,COUNT(cart.cart_member) as ��ǰǰ��Ǽ�
      ,SUM (NVL(cart.cart_qty,0)) as ��ǰ���ż���
      ,sum(NVL(cart.cart_qty * prod.prod_sale,0))
FROM member,cart,prod
WHERE member.mem_id = cart.cart_member(+)
AND cart.cart_prod = prod.prod_id(+)
GROUP BY member.mem_id,member.MEM_NAME
ORDER BY 6 DESC;

SELECT member.mem_id
      ,member.mem_name
      ,COUNT(distinct cart.cart_no) as īƮ���Ƚ��
      ,COUNT(cart.cart_member) as ��ǰǰ��Ǽ�
      ,SUM(cart.cart_qty) as ��ǰ���ż���
      ,sum(cart.cart_qty * prod.prod_sale)
     FROM MEMBER, CART, PROD
WHERE member.mem_id = cart.cart_member(+)
AND cart.cart_prod = prod.prod_id(+)
GROUP BY member.mem_id,member.MEM_NAME
ORDER BY 6 DESC;



select *
from (
        SELECT ROWNUM as rnum
                ,a.mem_name
        FROM (
                SELECT member.mem_id
      ,member.mem_name
      ,COUNT(distinct cart.cart_no) as īƮ���Ƚ��
      ,COUNT(cart.cart_member) as ��ǰǰ��Ǽ�
      ,SUM(cart.cart_qty) as ��ǰ���ż���
      ,sum(cart.cart_qty * prod.prod_sale)
     FROM MEMBER, CART, PROD
WHERE member.mem_id = cart.cart_member(+)
AND cart.cart_prod = prod.prod_id(+)
GROUP BY member.mem_id,member.MEM_NAME
ORDER BY 6 DESC) a
        )
WHERE rnum < 5;



SELECT employee_id
      ,emp_name
      ,salary
FROM employees
WHERE emp_name LIKE 'K%'
ORDER BY emp_name;


 SELECT member.mem_id
      ,member.mem_name
      ,COUNT(distinct cart.cart_no) as īƮ���Ƚ��
      ,COUNT(cart.cart_member) as ��ǰǰ��Ǽ�
      ,SUM(cart.cart_qty) as ��ǰ���ż���
      ,sum(cart.cart_qty * prod.prod_sale)
     FROM MEMBER, CART, PROD
WHERE member.mem_id = cart.cart_member(+)
AND cart.cart_prod = prod.prod_id(+)
GROUP BY member.mem_id,member.MEM_NAME
ORDER BY 6 DESC

/* ANSI OUTER JOIN*/
select a.mem_id
, a.mem_name
,COUNT(DISTINCT b.cart_no)
,COUNT(c.prod_id)
FROM  member a
LEFT OUTER JOIN cart b
ON (a.mem_id = b.cart_member)
LEFT OUTER JOIN prod c
ON(b.cart_prod = c.prod_id)
GROUP BY a.mem_id
,a.mem_name;
