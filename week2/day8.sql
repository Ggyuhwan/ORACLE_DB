/* INNER JOIN 내부조인(동등조인)
*/
SELECT *
FROM 학생;
SELECT*
FROM 수강내역;

SELECT 학생.학번
        ,학생.이름
        ,학생.전공
        ,수강내역.수강내역번호
        ,수강내역.과목번호
        ,과목.과목이름
        ,과목.학점
FROM 학생 ,수강내역, 과목
WHERE 학생.학번 = 수강내역.학번
AND 수강내역.과목번호 = 과목.과목번호
AND 학생.이름 ='최숙경';

--최숙경의 수강 총학점을 출력하시오
SELECT 학생.학번
    ,학생.이름
    ,SUM(학점) AS 수강학점
FROM 학생 ,수강내역, 과목
WHERE 학생.학번 = 수강내역.학번
AND 수강내역.과목번호 = 과목.과목번호
AND 학생.이름 ='최숙경'
GROUP BY 학생.이름
        ,학생.학번;
        
/* OUTER JOIN 외부조인
어느 한쪽에 null 값을 포함시켜야 할때
(보통은 마스터테이블은 무조건 포함시켜야하며 아웃터조인을함)
*/
SELECT *
FROM 학생 ,수강내역                     -- null을 포함시킬 테이블쪽
WHERE 학생.학번 = 수강내역.학번(+) --(+) <-- 한쪽에만 쓸 수 있음
AND 학생.이름 = '양지운';

-- 학생의 수강이력 건수를 출력하시오
-- 모든학생 출력 null이면 0으로

SELECT 학생.학번
    ,학생.이름
    ,COUNT(수강내역.수강내역번호) AS 수강내역건수
    ,SUM(NVL(과목.학점,0))AS 총학점
FROM 학생 ,수강내역, 과목 a                     
WHERE 학생.학번 = 수강내역.학번(+)
AND 수강내역.과목번호 = 과목.과목번호(+)
GROUP BY 학생.학번,학생.이름
ORDER BY 3 DESC;

SELECT* 
FROM 학생, 수강내역
WHERE 학생.학번 = 수강내역.학번(+);
        
SELECT 학생.학번
    ,학생.이름
    ,학생.전공
    ,수강내역.수강내역번호
    ,수강내역.과목번호
    ,(SELECT 과목이름       -- 스칼라 서브쿼리 (단일행 사용가능)
    FROM 과목
    WHERE 과목번호 = 수강내역.과목번호) AS 과목이름
FROM 학생 ,수강내역, 과목
WHERE 학생.학번 = 수강내역.학번
AND 수강내역.과목번호 = 과목.과목번호
AND 학생.이름 ='최숙경';       
  
  /* 학생의 전공별 인원수를 출력하시오 */
SELECT 전공
,COUNT(*) as 학생수
FROM 학생
GROUP BY 전공
ORDER BY 2 DESC;
--평균 평점 이상인 친구
SELECT 학번 
    ,이름
    ,평점
FROM 학생
WHERE 평점 >=(SELECT AVG(평점)
            FROM 학생)    --중첩 서브쿼리
ORDER BY 3 DESC ;
--평점 높은친구
SELECT 학번 
    ,이름
    ,평점
FROM 학생
WHERE 평점 =(SELECT MAX(평점)
            FROM 학생)
ORDER BY 3 DESC ;

SELECT 학생.학번
    ,학생.이름
    ,학생.전공
    ,교수.교수이름
    ,학생.평점
FROM 학생, 교수
WHERE 평점 >= (SELECT AVG(평점)
FROM 학생)
AND 학생.전공 = 교수.전공;
--수강내역이 없는 학생은?
SELECT *
FROM 학생
WHERE 학번 NOT IN (SELECT 학번
FROM 수강내역);
/* 인라인 뷰 (FROM 절)
SELECT 문의 질의 결과를 마치 데이블처럼 사용
*/
SELECT *
FROM (SELECT ROWNUM as rnum ,
        학번, 이름, 전공
FROM 학생) a  -- SELECT문을 테이블처럼 사용
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

/* 학생중에 평점 높은 5명만 출력하시오 */
SELECT 이름
    ,전공
    ,평점
    ,A.RNUM
FROM (SELECT ROWNUM as rnum ,이름,전공,평점
FROM 학생) a
WHERE a.rnum BETWEEN 1 AND 5
ORDER BY 3 DESC;
-- 정답
SELECT rownum as 순위
        ,a.*
FROM ( SELECT 이름
,평점
FROM 학생
ORDER BY 평점 DESC) 
a
WHERE rownum <=5;
--특정 출력
SELECT *
FROM (SELECT rownum as 순위
        ,a.*
FROM ( SELECT 이름
    ,평점
    FROM 학생
    ORDER BY 평점 DESC) a
    )
WHERE 순위 = 2;
--member, cart, prod 를 사용하여
--고객별 카트사용횟수, 상품품목건수, 상품구매수량, 총구매금액을 출력하시오
--구매이력이 없다면 0 <- 으로 출력되도록

select count(distinct cart_no)  -- 중복제거
    , count(*)
from cart
where cart_member = 'a001';


SELECT member.mem_id
      ,member.mem_name
      ,COUNT(distinct cart.cart_no) as 카트사용횟수 
      ,COUNT(cart.cart_member) as 상품품목건수
      ,SUM (NVL(cart.cart_qty,0)) as 상품구매수량
      ,sum(NVL(cart.cart_qty * prod.prod_sale,0))
FROM member,cart,prod
WHERE member.mem_id = cart.cart_member(+)
AND cart.cart_prod = prod.prod_id(+)
GROUP BY member.mem_id,member.MEM_NAME
ORDER BY 6 DESC;

SELECT member.mem_id
      ,member.mem_name
      ,COUNT(distinct cart.cart_no) as 카트사용횟수
      ,COUNT(cart.cart_member) as 상품품목건수
      ,SUM(cart.cart_qty) as 상품구매수량
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
      ,COUNT(distinct cart.cart_no) as 카트사용횟수
      ,COUNT(cart.cart_member) as 상품품목건수
      ,SUM(cart.cart_qty) as 상품구매수량
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
      ,COUNT(distinct cart.cart_no) as 카트사용횟수
      ,COUNT(cart.cart_member) as 상품품목건수
      ,SUM(cart.cart_qty) as 상품구매수량
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
