/* 23.08.24 ����Ǯ��
�μ��� ������ salary�� ������� ������ ����Ͻÿ�
*/
SELECT *
FROM (
     SELECT emp_name
    ,salary
    ,department_id
    ,RANK() OVER(PARTITION BY department_id ORDER BY salary DESC) as rnk
    FROM employees
    )
WHERE rnk = 1;
---- �л� �� ������ ������ ���� ���� �л��� ������ ����Ͻÿ�
SELECT *
FROM(
        SELECT A.*
        ,RANK() OVER(PARTITION BY A.���� ORDER BY A.���� DESC) AS rnk
        ,RANK() OVER (ORDER BY A.���� DESC) AS ALL_rnk
        ,COUNT(*) OVER() AS ��ü�л���
        ,AVG(A.����) OVER() AS ��ü���
        FROM �л� A
        )
WHERE RNK = 1; 

/*
 �ο�ս� ���� ���谪 ����
 PARTITION BY �׷�ȿ��� WINDOW ���� Ȱ���Ͽ� ���� ���踦 �� �� ����.
 AVG,SUM,MAX,MIN,COUNT,RANK,DENSE_RANK,LAG,ROW_NUMBER...
 PARTITION BY �� : ��� ��� �׷�
 ORDER BY     �� : ��� �׷쿡���� ����
 WINDOW       �� : ��Ƽ������ ���ҵ� �׷쿡 ���� �� ���� �׷����� ����
*/
-- CART, PROD ��ǰ�� prod_sale �հ��� ���� 10�� ��ǰ�� ����Ͻÿ�
--��ǰ�� �հ� ����,�м�

-- ��ũ�� �Ⱦ��� Ǭ��
SELECT *
FROM(
        SELECT A.cart_prod    --��ǰ���̵�
                ,B.prod_name  --��ǰ�̸�
                ,sum(b.prod_sale*A.cart_qty) AS �հ�
        FROM     CART A
                ,PROD B
        WHERE A.cart_prod = B.prod_id
        GROUP BY A.cart_prod,B.prod_name
        ORDER BY 3 DESC
        )
WHERE ROWNUM BETWEEN 1 AND 10;   -- BETWEEN 1~10 ����
-- ��ũ�� ���� Ǭ��
SELECT *
FROM(
        SELECT A.cart_prod    --��ǰ���̵�
        ,B.prod_name  --��ǰ�̸�
        ,sum(b.prod_sale*A.cart_qty) AS �հ�
        ,RANK() OVER (ORDER BY sum(b.prod_sale*A.cart_qty) DESC) AS ALL_rnk
FROM     CART A
         ,PROD B
WHERE A.cart_prod = B.prod_id
GROUP BY A.cart_prod,B.prod_name
)
WHERE ALL_rnk <= 10; --ALL_RNK �� 10 ������
---------������ Ǯ��
SELECT *
FROM(
    SELECT c.*
        , RANK() OVER(ORDER BY sale_sum DESC) as rnk
    FROM(   SELECT A.cart_prod   
                    ,B.prod_name 
                    ,sum(B.prod_sale * a.cart_qty) as sale_sum
            FROM     CART A
                    ,PROD B
            WHERE A.cart_prod = B.prod_id
            GROUP BY a.cart_prod, b.prod_name
        ) C
    )
WHERE RNK  <= 10;
-- �����Լ� + �м��Լ� (ǥ���Ŀ� �°� ����ϸ��)
SELECT *
FROM(
        SELECT A.cart_prod   
              ,B.prod_name 
              --,sum(B.prod_sale * a.cart_qty)
               ,RANK() OVER(ORDER BY sum(B.prod_sale * a.cart_qty)DESC) as RNK
        FROM     CART A, PROD B
        WHERE A.cart_prod = B.prod_id
        GROUP BY a.cart_prod, b.prod_name
        )
WHERE RNK <=10;
/*
    NTILE(expr) ��Ƽ�Ǻ��� expr ��õ� ����ŭ ������ ����� ��ȯ
    NTILE(3) 1 ~ 3 �� ���� ��ȯ(�����ϴ� ���� ��Ŷ �� �����)
    NTILE(4) -> 100/4 -> 25% �� ���� ����
*/
SELECT emp_name, salary, department_id
        ,NTILE(2) OVER(PARTITION BY department_id ORDER BY salary DESC) group_num
        ,COUNT(*) OVER(PARTITION BY department_id) AS �μ�������
FROM employees
WHERE department_id IN(30,60);
--��ü ������ �޿��� 10������ ���������� 1������ ���ϴ� ������ ��ȸ�Ͻÿ�
SELECT emp_name, salary
        ,NTILE(10) OVER(ORDER BY salary DESC) AS ����
FROM employees;
CREATE TABLE temp_team AS
SELECT nm,mbti
    ,NTILE(6) OVER(ORDER BY DBMS_RANDOM.VALUE ) AS TEAM --DBMS_RANDOM = �����Լ�
FROM tb_info;

SELECT ROUND(DBMS_RANDOM.VALUE(),2) AS "0~1" -- ���� ��������
        ,ROUND(DBMS_RANDOM.VALUE() * 10) AS "0~10" --���� ��������
FROM DUAL;

CREATE TABLE tb_sample as
SELECT ROWNUM as seq
        ,'2023' || LPAD(CEIL(ROWNUM/1000),2,'0') AS MONTH
        ,ROUND(DBMS_RANDOM.VALUE(100,1000)) AS AMT
FROM DUAL
CONNECT BY LEVEL <= 12000;
SELECT *
FROM TB_SAMPLE;

SELECT DBMS_RANDOM.STRING('U',5)--���ĺ� �빮�� 5�ڸ� ��������
    ,DBMS_RANDOM.STRING('L',5)--�ҹ���
    ,DBMS_RANDOM.STRING('A',5)--��ҹ���
    ,DBMS_RANDOM.STRING('X',5)--���ĺ� �빮�� & ����
    ,DBMS_RANDOM.STRING('P',5)--���ĺ� �빮�� & ���� & Ư������
FROM DUAL;

/* �־��� �׷�� ������ ���� row�� �ִ� ���� �����Ҷ� ���
   LAG(expr, offset, default_value) ����ο��� �� ����
   LEAD(expr, offset, default_value) ����ο��� �� ����
   */
SELECT emp_name, department_id, salary
    ,LAG(emp_name, 1, '�������') OVER(PARTITION BY department_id
                                    ORDER BY salary DESC) as emp_lag
    ,LEAD(emp_name, 1, '���峷��') OVER(PARTITION BY department_id
                                    ORDER BY salary DESC) as emp_lEAD
FROM employees;

/*
    �л��� ������ �������� �Ѵܰ� ���� �л��� ������ ���̸� ����Ͻÿ�
    ���� �̸� ����  �����л��̸�          ���������� ����
    1�� �ؼ� 4.5    ����                  0
    2�� �浿 4.3    �ؼ�                 0.2
    3�� ���� 3.0    �浿                 1.3  
    LGA(emp_name,1,'�������') �Ű����� 1,3�� Ÿ���� ���ƾ���
*/
desc �л�;
SELECT �̸�
        ,ROUND(����,2) AS ������
        ,LAG(�̸�,1,'����')OVER(ORDER BY ���� DESC) AS �����л�
        ,ROUND(LAG(����,1,����) OVER(ORDER BY ���� DESC) -����,2) AS ��������
FROM �л�;

CREATE TABLE bbs(
bbs_no	NUMBER PRIMARY KEY
,parent_no	NUMBER
,bbs_title	VARCHAR2(1000) DEFAULT NULL --����� ��� NULL
,bbs_content VARCHAR2(4000) NOT NULL	
,author_id  VARCHAR2(100)
,create_dt  TIMESTAMP DEFAULT CURRENT_TIMESTAMP -- ����� ������ �ð�
,update_dt  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
,CONSTRAINT fk_prent FOREIGN KEY(parent_no) REFERENCES bbs(bbs_no) 
ON DELETE CASCADE --�Խñ��� no�� �����ϰ� ���� ������ ������ ���� ����
,CONSTRAINT fk_user FOREIGN KEY(author_id) 
REFERENCES tb_user(user_id) ON DELETE CASCADE --���� Ż��� ���� ����
);
--�Խñ۹�ȣ ������
CREATE SEQUENCE bbs_seq START WITH 1 INCREMENT BY 1;

INSERT INTO bbs(bbs_no, bbs_title, bbs_content, author_id)
VALUES(bbs_seq.NEXTVAL, '��������', '������ �ݿ��� �Դϴ�.!!!', 'a001');

INSERT INTO bbs(bbs_no, bbs_title, bbs_content, author_id)
VALUES(bbs_seq.NEXTVAL, '�Խñ�1', '�Խñ� 1 �Դϴ�', 'b001');

INSERT INTO bbs(bbs_no, parent_no, bbs_content, author_id)
VALUES(bbs_seq.NEXTVAL, 62, '�� �������̿���...', 'x001');
drop table bbs;

SELECT* FROM bbs;

SELECT bbs_no,parent_no,level, bbs_title, bbs_content, author_id,create_dt
    ,update_dt 
FROM bbs
START WITH parent_no IS NULL             
CONNECT BY PRIOR bbs_no = parent_no; 

SElECT*
FROM tb_user;

SELECT *
FROM user_tab_columns
WHERE table_name = 'TB_USER';

SELECT user_id
        ,user_nm
        ,user_pw
        ,user_mileage
FROM tb_user
WHERE user_id = 'a001';

INSERT INTO tb_user (user_id, user_nm, user_pw, create_dt)
VALUES (?,?,?, SYSDATE);

SELECT rownum as rnum 
,count(*) OVER() as all_cnt
,a.*
FROM(
    SELECT bbs_no
          ,bbs_title
          ,author_id
          ,TO_CHAR(update_dt,'YYMMDD HH24:MI:SS') as update_dt
    FROM bbs
    WHERE parent_no IS NULL
    ORDER  BY update_dt DESC
    ) a
;
desc bbs;
desc tb_user;