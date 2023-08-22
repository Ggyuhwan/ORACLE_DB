SELECT department_id
    -- level ���󿭷μ�  Ʈ�� ������ � �ܰ����� ��Ÿ���� ������
    ,LPAD (' ',3* (level-1)) || department_name as �μ���
    ,parent_id
    ,level
FROM departments
START WITH parent_id IS NULL                -- ����
CONNECT BY PRIOR department_id = parent_id; -- ������ ��� �������� (����)
-- departments ���̺� 230 IT��������ũ ���� �μ���
--                          IT������
SELECT MAX(department_id) +10
FROM departments;

INSERT INTO departments (DEPARTMENT_ID,DEPARTMENT_NAME,PARENT_ID)
VALUES (280,'IT������',230);

SELECT department_id
    ,LPAD (' ',3* (level-1)) || department_name as �μ���
    ,level
FROM departments
START WITH parent_id IS NULL             
CONNECT BY PRIOR department_id = parent_id; 

/* ������ �������� ������ �Ϸ��� SIBLINGS BY �� �߰��ؾ���. */
SELECT department_id
    ,LPAD (' ',3* (level-1)) || department_name as �μ���
    ,parent_id
    ,level
FROM departments
START WITH parent_id IS NULL                
CONNECT BY PRIOR department_id = parent_id
ORDER SIBLINGS BY department_name; --SIBLINGS ���ÿ��� ���� �÷����θ� ���İ���

/* ���������� ���� �Լ� */
SELECT department_id
    ,LPAD (' ',3* (level-1)) || department_name as �μ��� -- || <-���ڿ� ���̱�
    ,parent_id
    ,level
    ,CONNECT_BY_ISLEAF --����������1, �ڽ��� ������0
    ,SYS_CONNECT_BY_PATH(department_name,'|') --��Ʈ ��忡�� �ڽ������ ��������
    ,CONNECT_BY_ISCYCLE --���ѷ����� ������ ã����
    --(�ڽ��� �ִµ� ���ڽ� �ο찡 �θ��̸� 1, �ƴϸ� 0
FROM departments
START WITH parent_id IS NULL                
CONNECT BY NOCYCLE PRIOR department_id = parent_id
ORDER SIBLINGS BY department_name;
-- ���ѷ��� �ɸ����� ����
UPDATE departments
SET parent_id = 260
WHERE department_id = 30;

SELECT employee_id
        ,emp_name
        ,manager_id
FROM employees
WHERE manager_id IS NULL;
--�������� �������踦 ����Ͻÿ�
SELECT employee_id
        ,LPAD (' ',3* (level-1)) || emp_name as ������
        ,SYS_CONNECT_BY_PATH(emp_name,'>') as ��������
        ,level
FROM employees
START WITH manager_id IS NULL               --����
CONNECT BY PRIOR employee_id = manager_id
ORDER SIBLINGS BY emp_name;
DESC employees;
CREATE TABLE TEST (���̵� NUMBER(6) 
, �̸� VARCHAR2(20)
, ��å  VARCHAR2(20)
, �������̵� NUMBER(6));

INSERT INTO TEST (���̵�,�̸�,��å,�������̵�)
VALUES (2,'�̻���','����',NULL)
 ;
 INSERT INTO TEST (���̵�,�̸�,��å,�������̵�)
VALUES (10,'�����','����',2)
 ;
 INSERT INTO TEST (���̵�,�̸�,��å,�������̵�)
VALUES (20,'������','����',10)
 ;
 INSERT INTO TEST (���̵�,�̸�,��å,�������̵�)
VALUES (30,'�����','����',20)
 ;
 INSERT INTO TEST (���̵�,�̸�,��å,�������̵�)
VALUES (40,'�̴븮','�븮',30)
 ;
 INSERT INTO TEST (���̵�,�̸�,��å,�������̵�)
VALUES (50,'�ֻ��','���',40)
 ;
  INSERT INTO TEST (���̵�,�̸�,��å,�������̵�)
VALUES (60,'�����','���',40)
 ;
  INSERT INTO TEST (���̵�,�̸�,��å,�������̵�)
VALUES (70,'�ڰ���','����',20)
 ;
  INSERT INTO TEST (���̵�,�̸�,��å,�������̵�)
VALUES (80,'��븮','�븮',70)
 ;
  INSERT INTO TEST (���̵�,�̸�,��å,�������̵�)
VALUES (90,'�ֻ��','���',80)
 ;

 SELECT �̸�,LPAD (' ',3* (level-1)) || ��å,level
 FROM TEST
 START WITH �������̵� IS NULL --����
 CONNECT BY PRIOR ���̵� = �������̵�
 ;
 
 select *
 from test;
 drop table test;
 
SELECT period
    ,SUM(loan_jan_amt) as �����հ�
 FROM kor_loan_status
 WHERE substr(period, 1,4)= 2013
 GROUP BY period;
 /* level �� ���� ���μ�(connect by ���� �԰� ���)
  ������ �����Ͱ� �ʿ��Ҷ� ���̻��.
*/
-- 2013�� 1~ 12�� ������
SELECT '2013' || LPAD (LEVEL,2,'0') AS ���
FROM dual
CONNECT BY LEVEL <=12;
-- 2013�� 1~ 12�� ������
SELECT a.���
        ,NVL(b.�����հ�,0) as �����հ�
FROM        (SELECT '2013' || LPAD (LEVEL,2,'0') AS ���
             FROM dual
             CONNECT BY LEVEL <=12)a
            ,(SELECT period as ���
            ,SUM(loan_jan_amt) as �����հ�
             FROM kor_loan_status
            WHERE substr(period, 1,4)= 2013
            GROUP BY period)b
WHERE a.��� = b.���(+)
ORDER BY 1;
-- 202301~202312
SELECT TO_CHAR(SYSDATE,'YYYY') || LPAD(LEVEL,2,'0') as YEAR
 FROM dual
CONNECT BY LEVEL <=12;
--�̹��� 1�Ϻ��� ������������ ���
--(�� �ش� SELECT���� �����޿� ����� �ش���� ������������ ��µǵ���)
SELECT TO_CHAR(SYSDATE,'YYYYMM')|| LPAD(LEVEL,2,'0')   as YEAR
 FROM dual
CONNECT BY LEVEL  <= (SELECT TO_CHAR(LAST_DAY(sysdate),'DD')
                        FROM dual);
--TO_CHAR(LAST_DAY,(SYSDATE),'YYYYMMDD')

SELECT TO_CHAR(LAST_DAY(ADD_MONTHS(TRUNC(SYSDATE, 'MM'), 1) - 1),'YYYYMM') 
    || LPAD(LEVEL,2,'0') as YEAR
FROM dual
CONNECT BY LEVEL <= TO_NUMBER
(TO_CHAR(LAST_DAY(ADD_MONTHS(TRUNC(SYSDATE, 'MM'), 1) - 1),'DD'));

--Ŀ��Ʈ ���� , �ܺ�����
--MEMBER ȸ���� ����(mem_bir)�� ���� ȸ������ ����Ͻÿ� (��� ���� ��������)
DESC MEMBER;
SELECT NVL(a.����_��,'�հ�') , count(b.��) as ȸ����
FROM        (SELECT  LPAD (LEVEL,2,'0')||'��' AS ����_��
             FROM dual
             CONNECT BY LEVEL <=12)a,
        (SELECT to_char(MEM_BIR,'MM')||'��' as ��   
            FROM MEMBER
       )b
WHERE a.����_�� = b.��(+)
GROUP BY rollup (a.����_��)
ORDER BY 1;

select count (MEM_BIR)
from member;
SELECT to_char(MEM_BIR,'MM') as ��
     , count(*)
FROM MEMBER
GROUP BY to_char(MEM_BIR,'MM');
SELECT count (to_char(substr(MEM_BIR,3,4)))
FROM MEMBER
group by to_char(substr(MEM_BIR,3,4));