/* PL/SQL 집합적 언어와 절차적 언어의 특징을 모두 사용하기 위함.
    DB내부에서 수행되기 떄문에 속도와 안전성이 높음.
*/ -- 기본 단위를 블록(Block)이라고 하며 이름부, 선언부, 실행부로 구성됨.
--  이름부는 블록의 명칭이 오는데 생략할 때는  익명 블록이 된다.

DECLARE  -- 이름 없음
    vi_num NUMBER := 1;
BEGIN  -- BEGIN 열고 END 로 닫기
    vi_num := 100; -- := 할당의 의미
    DBMS_OUTPUT.PUT_LINE(vi_num); -- 콘솔 프린트
END;
-- 실행은 영역을 선택 후 실행

DECLARE
    vs_emp_name VARCHAR2(80);
    vs_dep_name departments.department_name%TYPE; -- 테이블에 있는 타입과 사이즈
BEGIN
    SELECT a.emp_name, b.department_name
    INTO vs_emp_name, vs_dep_name
    FROM employees a, departments b
    WHERE a.department_id = b.department_id
    AND a.employee_id = 100;
    DBMS_OUTPUT.PUT_LINE(vs_emp_name || ':' || vs_dep_name);
END;

-- IF문
DECLARE
    vn_user_num NUMBER := TO_NUMBER(:userNm); -- 바인드
    vn_com_num NUMBER := 10;
BEGIN
    IF vn_user_num > vn_com_num THEN -- 조건1
        DBMS_OUTPUT.PUT_LINE('user 숫자다 더 큼');
    ELSIF vn_user_num = vn_com_num THEN -- 조건2 
        DBMS_OUTPUT.PUT_LINE('같음');
    ELSE
        DBMS_OUTPUT.PUT_LINE('user 숫자다 더 작음');
    END IF; -- IF  로 열고 END IF 로 닫음.
END;

-- 선언이 필요 없으면 BEGIN
BEGIN 
    DBMS_OUTPUT.PUT_LINE('3 * 3 = ' || 3 * 3);
END;
/*
    신입생이 들어왔습니다.^^
    기존학번의 가장 높은 학번을 찾아 +1 을 하여 학번을 생성 후
    학생테이블에 저장해주세요.
    만약 올해 첫 학생이라면  해당 년도에 000001 을 붙여서 학번을 생성.
    1. 올해년도
    2. 학번의 MAX값
    3. 2.학번의 앞자리 4자리와 올해년도 비교
    4. 조건문
    5. INSERT
*/
SELECT TO_CHAR(SYSDATE,'YYYYMMDD')
FROM dual;
SELECT MAX(학번)
FROM 학생;
DECLARE
    vs_nm 학생.이름%TYPE        := :nm;
    vs_subject 학생.전공%TYPE   := :sub;
    vn_year VARCHAR2(4)        := TO_CHAR(SYSDATE,'YYYY');
    vn_max_num NUMBER;
    vn_make_num NUMBER;
BEGIN
    SELECT MAX(학번)
    INTO vn_max_num
    FROM 학생;
    IF vn_year = SUBSTR(vn_max_num,1,4) THEN
        vn_make_num := vn_max_num + 1;
    ELSE
        vn_make_num := TO_NUMBER(vn_year || '000001');
    END IF;
    INSERT INTO 학생(학번, 이름, 전공)
    VALUES (vn_make_num, vs_nm, vs_subject);
    COMMIT;
END;

SELECT *
FROM 학생;

/*
    LOOP 문
    단순 LOOP문은 EXIT(탈출조건) 필수
    WHILE 은 시작에 조건이 true 이면 LOOP진입
    FOR 은 IN 초깃값...최대값 1씩 초깃값에서 최대값까지 증가
*/
DECLARE
    vn_gugudan NUMBER := 3;
    vn_i NUMBER       := 1;
BEGIN
    LOOP
    DBMS_OUTPUT.PUT_LINE(vn_gugudan
                    ||'*' || vn_i || '=' || vn_gugudan*vn_i);
    vn_i := vn_i + 1;
        LOOP
             DBMS_OUTPUT.PUT_LINE(vn_gugudan
                    ||'*' || vn_i || '=' || vn_gugudan*vn_i);
            vn_gugudan := vn_gugudan + 1;
             EXIT WHEN vn_vn_gugudan > 9; --vn_i > 9;
        END LOOP;
        EXIT WHEN vn_i > 9; --탈출조건
    END LOOP;
END;

DECLARE
    vn_gugudan NUMBER := 1;
    vn_i NUMBER       := 1;
BEGIN
    LOOP
    DBMS_OUTPUT.PUT_LINE(vn_gugudan+1||'단');
    vn_gugudan := vn_gugudan + 1; 
        vn_i:=1;
--        CONTINUE WHEN vn_i = 5; -- 해당조건일때 아래건너뜀
        LOOP
             DBMS_OUTPUT.PUT_LINE(vn_gugudan ||'*' || vn_i || '=' || vn_gugudan*vn_i);
             vn_i := vn_i + 1;
             EXIT WHEN vn_i > 9;
        END LOOP;
        EXIT WHEN vn_gugudan > 8; --탈출조건
    END LOOP;
END;

--FOR 문
BEGIN 
    FOR i IN 1..9  --1~9까지 1씩 증가
--    FOR i IN  REVERSE 1..9  --1~9까지 1씩 감소
    LOOP
        DBMS_OUTPUT.PUT_LINE(2 || '*' || '=' || 2 * i);
    END LOOP;
END;

/*
    ORACLE 사용자 정의함수 PL/SQL 로 작성
    오라클 함수는 무조건 리턴값이 1개 있어야함.
*/


-- 학생이름을 입력받아 총수강 학점을 리턴하는 함수를 만드시오
-- input: varchar2, output: number
CREATE OR REPLACE FUNCTION fn_get_hakno (nm VARCHAR2)
RETURN NUMBER
IS      -- 이름있는 블록작성시 선언부는 IS 로 시작
    vn_hakno NUMBER;
BEGIN
    SELECT  
    SUM(C.학점)
    INTO vn_hakno
    FROM 학생 a , 수강내역 b, 과목 c
    WHERE  a.학번 = b.학번
    AND b.과목번호 = c.과목번호
    AND a.이름 = nm;
    RETURN vn_hakno;
END;
SELECT fn_get_hakno(이름),a.*
FROM 학생 a;
--원기형 답
--CREATE OR REPLACE FUNCTION fn_get_grades (nm VARCHAR2)
-- RETURN NUMBER
--IS  --이름있는 블록 작성시 선언부 IS로 시작
-- vn_grades NUMBER;
--BEGIN
--    SELECT sum(학점) 
--        INTO vn_grades
--        FROM 학생,수강내역,과목
--        WHERE 학생.학번 = 수강내역.학번
--     AND 수강내역.과목번호 = 과목.과목번호
--     and 학생.이름 = nm;
--    RETURN vn_grades; 
--END;
--SELECT fn_get_grades(a.이름) as 총학점 --위에 사용자정의함수 만든거 사용방법(내장 함수 처럼 쓰면됨)
--        ,a.*
--FROM 학생 a;
   
   
-- fn_dday('20230829')
-- d-day를 입력받아(YYYYMMDD)
-- 남은날은                 input:20230829 return : 1일 남음
-- 지난날은 음수로 표현       input:20230827 return : 1일 지남
-- 을 수행하는 함수를 작성하시오
-- input: varchar2, output: varcha2
CREATE OR REPLACE FUNCTION fn_dday (nb VARCHAR2)
RETURN VARCHAR2
IS fn_dday VARCHAR2(80);

BEGIN 
    SELECT SYSDATE 
    FROM dual;
    INTO fn_dday
    RETURN fn_dday;
END;

SELECT SYSDATE 
FROM dual;