/* 23.08.24 문제풀이
부서별 직원의 salary가 가장높은 직원을 출력하시오
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
---- 학생 중 전공별 평점이 가장 높은 학생의 정보를 출력하시오
SELECT *
FROM(
        SELECT A.*
        ,RANK() OVER(PARTITION BY A.전공 ORDER BY A.평점 DESC) AS rnk
        ,RANK() OVER (ORDER BY A.평점 DESC) AS ALL_rnk
        ,COUNT(*) OVER() AS 전체학생수
        ,AVG(A.평점) OVER() AS 전체평균
        FROM 학생 A
        )
WHERE RNK = 1; 

/*
 로우손실 없이 집계값 산출
 PARTITION BY 그룹안에서 WINDOW 절을 활용하여 세부 집계를 할 수 있음.
 AVG,SUM,MAX,MIN,COUNT,RANK,DENSE_RANK,LAG,ROW_NUMBER...
 PARTITION BY 절 : 계산 대상 그룹
 ORDER BY     절 : 대상 그룹에대한 정렬
 WINDOW       절 : 파티션으로 분할된 그룹에 대해 더 상세한 그룹으로 분할
*/
-- CART, PROD 물품별 prod_sale 합계의 상위 10등 상품을 출력하시오
--상품별 합계 집계,분석

-- 랭크를 안쓴고 푼것
SELECT *
FROM(
        SELECT A.cart_prod    --상품아이디
                ,B.prod_name  --상품이름
                ,sum(b.prod_sale*A.cart_qty) AS 합계
        FROM     CART A
                ,PROD B
        WHERE A.cart_prod = B.prod_id
        GROUP BY A.cart_prod,B.prod_name
        ORDER BY 3 DESC
        )
WHERE ROWNUM BETWEEN 1 AND 10;   -- BETWEEN 1~10 까지
-- 랭크를 쓰고 푼것
SELECT *
FROM(
        SELECT A.cart_prod    --상품아이디
        ,B.prod_name  --상품이름
        ,sum(b.prod_sale*A.cart_qty) AS 합계
        ,RANK() OVER (ORDER BY sum(b.prod_sale*A.cart_qty) DESC) AS ALL_rnk
FROM     CART A
         ,PROD B
WHERE A.cart_prod = B.prod_id
GROUP BY A.cart_prod,B.prod_name
)
WHERE ALL_rnk <= 10; --ALL_RNK 가 10 이하인
---------선생님 풀이
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
-- 집계함수 + 분석함수 (표현식에 맞게 사용하면됨)
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
    NTILE(expr) 파티션별로 expr 명시된 값만큼 분할한 결과를 반환
    NTILE(3) 1 ~ 3 의 수를 반환(분할하는 수를 버킷 수 라고함)
    NTILE(4) -> 100/4 -> 25% 로 행을 분할
*/
SELECT emp_name, salary, department_id
        ,NTILE(2) OVER(PARTITION BY department_id ORDER BY salary DESC) group_num
        ,COUNT(*) OVER(PARTITION BY department_id) AS 부서직원수
FROM employees
WHERE department_id IN(30,60);
--전체 직원의 급여를 10분위로 나누었을때 1분위에 속하는 직원을 조회하시오
SELECT emp_name, salary
        ,NTILE(10) OVER(ORDER BY salary DESC) AS 분위
FROM employees;
CREATE TABLE temp_team AS
SELECT nm,mbti
    ,NTILE(6) OVER(ORDER BY DBMS_RANDOM.VALUE ) AS TEAM --DBMS_RANDOM = 랜덤함수
FROM tb_info;

SELECT ROUND(DBMS_RANDOM.VALUE(),2) AS "0~1" -- 난수 랜덤생성
        ,ROUND(DBMS_RANDOM.VALUE() * 10) AS "0~10" --난수 랜덤생성
FROM DUAL;

CREATE TABLE tb_sample as
SELECT ROWNUM as seq
        ,'2023' || LPAD(CEIL(ROWNUM/1000),2,'0') AS MONTH
        ,ROUND(DBMS_RANDOM.VALUE(100,1000)) AS AMT
FROM DUAL
CONNECT BY LEVEL <= 12000;
SELECT *
FROM TB_SAMPLE;

SELECT DBMS_RANDOM.STRING('U',5)--알파벳 대문자 5자리 랜덤생성
    ,DBMS_RANDOM.STRING('L',5)--소문자
    ,DBMS_RANDOM.STRING('A',5)--대소문자
    ,DBMS_RANDOM.STRING('X',5)--알파벳 대문자 & 숫자
    ,DBMS_RANDOM.STRING('P',5)--알파벳 대문자 & 숫자 & 특수문자
FROM DUAL;

/* 주어진 그룹과 순서에 따라 row에 있는 값을 참조할때 사용
   LAG(expr, offset, default_value) 선행로우의 값 참조
   LEAD(expr, offset, default_value) 후행로우의 값 참조
   */
SELECT emp_name, department_id, salary
    ,LAG(emp_name, 1, '가장높음') OVER(PARTITION BY department_id
                                    ORDER BY salary DESC) as emp_lag
    ,LEAD(emp_name, 1, '가장낮음') OVER(PARTITION BY department_id
                                    ORDER BY salary DESC) as emp_lEAD
FROM employees;

/*
    학생의 평점을 기준으로 한단계 위의 학생의 평점과 차이를 출력하시오
    순위 이름 평점  상위학생이름          상위평점과 차이
    1등 팽수 4.5    없음                  0
    2등 길동 4.3    팽수                 0.2
    3등 동길 3.0    길동                 1.3  
    LGA(emp_name,1,'가장높음') 매개변수 1,3의 타입이 같아야함
*/
desc 학생;
SELECT 이름
        ,ROUND(평점,2) AS 내평점
        ,LAG(이름,1,'없음')OVER(ORDER BY 평점 DESC) AS 상위학생
        ,ROUND(LAG(평점,1,평점) OVER(ORDER BY 평점 DESC) -평점,2) AS 평점차이
FROM 학생;

CREATE TABLE bbs(
bbs_no	NUMBER PRIMARY KEY
,parent_no	NUMBER
,bbs_title	VARCHAR2(1000) DEFAULT NULL --댓글의 경우 NULL
,bbs_content VARCHAR2(4000) NOT NULL	
,author_id  VARCHAR2(100)
,create_dt  TIMESTAMP DEFAULT CURRENT_TIMESTAMP -- 사용자 세션의 시간
,update_dt  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
,CONSTRAINT fk_prent FOREIGN KEY(parent_no) REFERENCES bbs(bbs_no) 
ON DELETE CASCADE --게시글의 no를 참조하고 참조 데이터 삭제시 같이 삭제
,CONSTRAINT fk_user FOREIGN KEY(author_id) 
REFERENCES tb_user(user_id) ON DELETE CASCADE --유저 탈퇴시 같이 삭제
);
--게시글번호 시퀀스
CREATE SEQUENCE bbs_seq START WITH 1 INCREMENT BY 1;

INSERT INTO bbs(bbs_no, bbs_title, bbs_content, author_id)
VALUES(bbs_seq.NEXTVAL, '공지사항', '오늘은 금요일 입니다.!!!', 'a001');

INSERT INTO bbs(bbs_no, bbs_title, bbs_content, author_id)
VALUES(bbs_seq.NEXTVAL, '게시글1', '게시글 1 입니다', 'b001');

INSERT INTO bbs(bbs_no, parent_no, bbs_content, author_id)
VALUES(bbs_seq.NEXTVAL, 62, '곧 월요일이에요...', 'x001');
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