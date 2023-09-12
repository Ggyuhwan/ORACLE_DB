/*
�������� TRIM : ����, LTRIM : ����, RTRIM : ������
���ڿ����� ���߱� LPAD : ���ʺ���, RPAD : ������ ����
*/
SELECT LTRIM('  ABC    ')
,RTRIM('  ABC    ')
,TRIM('  ABC    ')
FROM dual;
-- LPAD(1, 5, '0') -> 00001 �Է��� 50�̸� ->00050
SELECT LPAD(123, 5, '0')
,LPAD(12320, 5, '0')
,LPAD(1, 5, '0')
,LPAD(111111, 5, '0') -- ���� ����� ������ 2��° �Ű����� ���� ��ŭ
,RPAD(123, 5, 'A')
FROM dual;
-- ** REPLACE
SELECT REPLACE('���� �ʸ� �𸣴µ� �ʴ� ���� �˰ڴ°�?','����','�ʸ�')REP
,TRANSLATE('���� �ʸ� �𸣴µ� �ʴ� ���� �˰ڴ°�?','����','�ʸ�')TRN --�� ���ھ�
FROM dual;
-- LENGTH ���ڿ�����, LENGTHB ũ��
SELECT 
LENGTHB('���ѹα�') --�ѱ� 1���� 3BYTE
,LENGTH('1234')     
FROM dual;

/* ��¥ �Լ� */
SELECT SYSDATE
,SYSTIMESTAMP --����ð�
FROM dual;
-- ADD_MONTHS �� +-
SELECT ADD_MONTHS(SYSDATE,1)
,ADD_MONTHS(SYSDATE,-1)
FROM dual;
-- LAST_DAY , NEXT_DAY
SELECT LAST_DAY(SYSDATE)
,NEXT_DAY(SYSDATE, '�ݿ���')
,NEXT_DAY(SYSDATE, '�����')
,SYSDATE +1
,SYSDATE -2
FROM dual;
-- �̹��� ���� ���������?
SELECT LAST_DAY(SYSDATE) - SYSDATE AS d_DAYS
,'d-day:'||(LAST_DAY(SYSDATE) - SYSDATE)||'��' AS d_DAYS2
FROM dual;
/* �����Լ�(�Ű����� ������)
 ABS : ���밪
 ROUND �ݿø�
 TRUNC ����
*/
SELECT ABS(-10)
,ABS(10)
,ROUND(10.155, 1)
,ROUND(10.155, 2)
,ROUND(10) -- ����Ʈ 0
,TRUNC(114.999, 1)
FROM dual;
/* MODE(m, m) m�� n���� ���������� ������ ��ȯ */
-- SQRT ������ ��ȯ
SELECT MOD(4, 2) -- %
,MOD(5, 2)
,SQRT(4)
FROM dual;
/* ��ȯ TO_CAHR :����������, TO_NUMBER : ����������, TO_DATE : ��¥������ */
SELECT TO_CHAR(1234566,'999,999,999')
,TO_CHAR(SYSDATE, 'YYYY-MM-DD')
,TO_CHAR(SYSDATE, 'YYYYMMDD')
,TO_CHAR(SYSDATE, 'YYYYMMDD HH:MI:SS') 
,TO_CHAR(SYSDATE, 'YYYYMMDD HH12:MI:SS') 
,TO_CHAR(SYSDATE, 'YYYYMMDD HH24:MI:SS')
,TO_CHAR(SYSDATE, 'DAY') --����
,TO_CHAR(SYSDATE, 'DD') -- ��
,TO_CHAR(SYSDATE, 'D') --���Ϻ� ����(�Ͽ��� =1 ������ =2 ...)
,TO_CHAR(SYSDATE, 'yyyy')
FROM dual;

SELECT TO_DATE('230713', 'YYMMDD')
    --TO_DATE�� ��¥ ������Ÿ������ ����ȯ
    --�Է� ����� �����ϰ� ǥ���ؾ� DATE�� �ٲ�
,TO_DATE('2023 08 12 10:00:00', 'YYYY MM DD HH24:MI:SS')
FROM dual;
CREATE TABLE tb_myday(
title VARCHAR2(200)
,d_day DATE
);
INSERT INTO tb_myday VALUES('������', '20231226');
INSERT INTO tb_myday VALUES('������', '2023.12.26');
INSERT INTO tb_myday VALUES('������', TO_DATE('20231226 18','YYMMDD HH24'));

CREATE TABLE ex5_1(
seq VARCHAR2(100)
,seq2 NUMBER
);SELECT *
FROM tb_MYDAY;

INSERT INTO ex5_1 VALUES('1234','1234');
INSERT INTO ex5_1 VALUES('99','99');
INSERT INTO ex5_1 VALUES('123456','123456');

SELECT *
FROM ex5_1
ORDER BY TO_NUMBER(seq) DESC; --varchar �� ��� Ÿ�Ժ�ȯ�� ����

SELECT *
FROM students;
-- students ���̺��� Ȱ���Ͽ� �й�,�л��̸�,���̸� ����Ͻÿ�
desc customers;
--�Էµ� ���ڸ� ���� ���� 50~ �̻��̸� 20����� �ؼ�
--                  49 ���ϸ� 21����� �ؼ�
SELECT stu_name
,TO_DATE (STU_BIRTH, 'YYMMDD')
,TO_CHAR(TO_DATE(STU_BIRTH, 'YYMMDD'),'YYYY')
,TO_CHAR(TO_DATE(stu_birth,'RRMMDD'),'YYYY')
,TO_CHAR (TO_DATE  (STU_BIRTH,'YYMMDD'),'YYYY')
FROM students;

--employees �� hire_date �÷��� Ȱ���Ͽ� �ټ� ����� ����Ͻÿ�
desc employees;
SELECT emp_name
,TO_CHAR (hire_date,'yyyy')as �Ի�⵵
,TO_CHAR(SYSDATE, 'yyyy') - TO_CHAR (hire_date, 'yyyy') AS �ټӿ���
FROM employees
ORDER BY �ټӿ��� desc ,1;

--null ����
--** NVL(null, ��ȯ��)
SELECT emp_name,salary, commission_pct
, salary * NVL(commission_pct,0)
FROM employees;
-- DECODE ��ȯ (case�� ������)
SELECT cust_id, cust_name
    --  ����,       ��, ������, �׹ۿ�
,DECODE(cust_gender,'M','����','����')as gender
    --  ����,       ��, ������, ��2, ������,�׹ۿ�
,DECODE(cust_gender,'M','����','F','����','??')as gender2
FROM customers;
/*
�����̺�(CUSTOMERS)����
���� ����⵵(cust_year_of_birth)�÷��� �ִ�.
������ �������� �� �÷��� Ȱ���� 30��, 40��, 50�븦 ������ ����ϰ�,
������ ���ɴ�� '��Ÿ'�� ����ϴ� ������ �ۼ��غ���.
*/
desc customers;
SELECT
CUST_NAME
,DECODE(SUBSTR( TO_CHAR(SYSDATE,'YYYY') - TO_CHAR(cust_year_of_birth),1,1),'3','30��','4','40��','5','50��','��Ÿ')as ����
FROM customers
ORDER BY 2;
