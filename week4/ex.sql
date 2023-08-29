ALTER SESSION SET "_ORACLE_SCRIPT" = TRUE;
CREATE USER java2 IDENTIFIED BY oracle;

GRANT CREATE SESSION TO java2;
GRANT CREATE TABLE TO java2;
GRANT CREATE ANY TABLE TO java2;
GRANT DROP ANY TABLE TO java2;

--3
CREATE TABLE EX_MEM(
    mem_id VARCHAR2(10)  PRIMARY KEY NOT NULL
    ,mem_name VARCHAR2(20) NOT NULL
    ,mem_job VARCHAR2(30)
    ,mem_mileage NUMBER(8,2) DEFAULT 0
    ,mem_reg_date DATE      DEFAULT SYSDATE
 -- ,CONSTRAINT pk_ex_mem PRIMARY KEY (mem_id)  수정해야함
);
ALTER TABLE EX_MEM ADD CONSTRAINT pk_ex_mem PRIMARY KEY (mem_id);
COMMENT ON TABLE EX_MEM IS '임시회원테이블';

COMMENT ON COLUMN EX_MEM.mem_id IS '아이디';
COMMENT ON COLUMN EX_MEM.mem_name IS '회원명';
COMMENT ON COLUMN EX_MEM.mem_job IS '직업';
COMMENT ON COLUMN EX_MEM.mem_mileage IS '마일리지';
COMMENT ON COLUMN EX_MEM.mem_reg_date IS '등록일';
--4
GRANT [system_privilege | role]FROM [user | role | PUBLIC]


ALTER TABLE EX_MEM MODIFY mem_name VARCHAR2(50);
DROP TABLE EX_MEM;
SELECT * 
FROM EX_MEM;
INSERT INTO EX_MEM VALUES('hong', '홍길동', '주부',null,to_date(sysdate,'yyyy.mm.dd hh24:mi'));


CREATE SEQUENCE seq
       INCREMENT BY 1
       START WITH 1000
       MINVALUE 1000
       MAXVALUE 9999
       ;
       SELECT seq.NEXTVAL
  FROM dual;
INSERT INTO EX_MEM VALUES('c001', '신용환', '교사',3500,to_date(sysdate,'yyyy.mm.dd hh24:mi'));
INSERT INTO EX_MEM VALUES('x001', '진현경', '주부',8700,to_date(sysdate,'yyyy.mm.dd hh24:mi'));
INSERT INTO EX_MEM VALUES('p001', '오성순', '공무원',2200,to_date(sysdate,'yyyy.mm.dd hh24:mi'));
INSERT INTO EX_MEM VALUES('h001', '라준호', '회사원',1500,to_date(sysdate,'yyyy.mm.dd hh24:mi'));
INSERT INTO EX_MEM VALUES('i001', '최지현', '공무원',900,to_date(sysdate,'yyyy.mm.dd hh24:mi'));
INSERT INTO EX_MEM VALUES('m001', '박지은', '은행원',1300,to_date(sysdate,'yyyy.mm.dd hh24:mi'));
INSERT INTO EX_MEM VALUES('w001', '김형모', '학생',2700,to_date(sysdate,'yyyy.mm.dd hh24:mi'));
INSERT INTO EX_MEM VALUES('o001', '배인정', '회사원',2600,to_date(sysdate,'yyyy.mm.dd hh24:mi'));
INSERT INTO EX_MEM VALUES('l001', '구길동', '자영업',5300,to_date(sysdate,'yyyy.mm.dd hh24:mi'));
INSERT INTO EX_MEM VALUES('s001', '안은정', '공무원',3200,to_date(sysdate,'yyyy.mm.dd hh24:mi'));

select *
from ex_mem
where mem_name like '김%';

select mem_id
        ,mem_name
        ,mem_job
        ,mem_mileage
FROM member
WHERE mem_job = '주부'
AND   mem_mileage BETWEEN 1000 AND 3000
ORDER BY mem_mileage DESC;

SELECT PROD_ID, PROD_NAME, PROD_SALE
FROM PROD
WHERE PROD_SALE  =23000
OR PROD_SALE=26000
OR PROD_SALE=33000;

SELECT mem_job
        ,count(mem_job)     as mem_cnt
        ,max(mem_mileage)   as max_mlg
        ,avg(mem_mileage)   as avg_mlg
FROM MEMBER
group by mem_job
HAVING  count(mem_job) >= 3;


SELECT mem_id
        ,mem_name
        ,mem_job
        ,mem_mileage
        ,RANK() OVER( PARTITION BY mem_job ORDER BY mem_mileage DESC) as mem_rank
        
FROM member;

SELECT a.mem_id
       ,a.mem_name
       ,A.MEM_JOB
       ,b.cart_prod
       ,b.cart_qty
       FROM member a,cart b
       WHERE a.mem_id = b.cart_member
       and substr(b.cart_no,1,8) = 20050728;
       
       