CREATE TABLE ex1_1(
val1 VARCHAR2(10)
,val2 NUMBER
,val3 DATE
);
INSERT INTO ex1_1 (val1,val2,val3)
VALUES('HI',101,SYSDATE);
INSERT INTO ex1_1 (val3,val2)
VALUES(SYSDATE, 11);
INSERT INTO ex1_1
VALUES('HELLO',99,SYSDATE);

SELECT SUBSTR('ABCD EFG',1,4)
,SUBSTR('AAAAABBBB',5)
,SUBSTR('123456',3,3) --null
FROM dual;
SELECT cust_name
,cust_email
,INSTR(cust_email,'.') as com
,SUBSTR (cust_email,1,INSTR(cust_email,'.')-1)as id  
,SUBSTR (cust_email,INSTR(cust_email,'.')+1)as id  
FROM customers;

SELECT nm
,mbti
,CASE WHEN SUBSTR(MBTI,1,1) = 'I' THEN 'A'
ELSE 'B'
END AS ABC
,CASE WHEN SUBSTR(MBTI,2,1) = 'S' THEN 'A'
ELSE 'B'
END AS DEF

FROM tb_info;



