/* PL/SQL ������ ���� ������ ����� Ư¡�� ��� ����ϱ� ����.
    DB���ο��� ����Ǳ� ������ �ӵ��� �������� ����.
*/ -- �⺻ ������ ���(Block)�̶�� �ϸ� �̸���, �����, ����η� ������.
--  �̸��δ� ����� ��Ī�� ���µ� ������ ����  �͸� ����� �ȴ�.

DECLARE  -- �̸� ����
    vi_num NUMBER := 1;
BEGIN  -- BEGIN ���� END �� �ݱ�
    vi_num := 100; -- := �Ҵ��� �ǹ�
    DBMS_OUTPUT.PUT_LINE(vi_num); -- �ܼ� ����Ʈ
END;
-- ������ ������ ���� �� ����

DECLARE
    vs_emp_name VARCHAR2(80);
    vs_dep_name departments.department_name%TYPE; -- ���̺� �ִ� Ÿ�԰� ������
BEGIN
    SELECT a.emp_name, b.department_name
    INTO vs_emp_name, vs_dep_name
    FROM employees a, departments b
    WHERE a.department_id = b.department_id
    AND a.employee_id = 100;
    DBMS_OUTPUT.PUT_LINE(vs_emp_name || ':' || vs_dep_name);
END;

-- IF��
DECLARE
    vn_user_num NUMBER := TO_NUMBER(:userNm); -- ���ε�
    vn_com_num NUMBER := 10;
BEGIN
    IF vn_user_num > vn_com_num THEN -- ����1
        DBMS_OUTPUT.PUT_LINE('user ���ڴ� �� ŭ');
    ELSIF vn_user_num = vn_com_num THEN -- ����2 
        DBMS_OUTPUT.PUT_LINE('����');
    ELSE
        DBMS_OUTPUT.PUT_LINE('user ���ڴ� �� ����');
    END IF; -- IF  �� ���� END IF �� ����.
END;

-- ������ �ʿ� ������ BEGIN
BEGIN 
    DBMS_OUTPUT.PUT_LINE('3 * 3 = ' || 3 * 3);
END;
/*
    ���Ի��� ���Խ��ϴ�.^^
    �����й��� ���� ���� �й��� ã�� +1 �� �Ͽ� �й��� ���� ��
    �л����̺� �������ּ���.
    ���� ���� ù �л��̶��  �ش� �⵵�� 000001 �� �ٿ��� �й��� ����.
    1. ���س⵵
    2. �й��� MAX��
    3. 2.�й��� ���ڸ� 4�ڸ��� ���س⵵ ��
    4. ���ǹ�
    5. INSERT
*/
SELECT TO_CHAR(SYSDATE,'YYYYMMDD')
FROM dual;
SELECT MAX(�й�)
FROM �л�;
DECLARE
    vs_nm �л�.�̸�%TYPE        := :nm;
    vs_subject �л�.����%TYPE   := :sub;
    vn_year VARCHAR2(4)        := TO_CHAR(SYSDATE,'YYYY');
    vn_max_num NUMBER;
    vn_make_num NUMBER;
BEGIN
    SELECT MAX(�й�)
    INTO vn_max_num
    FROM �л�;
    IF vn_year = SUBSTR(vn_max_num,1,4) THEN
        vn_make_num := vn_max_num + 1;
    ELSE
        vn_make_num := TO_NUMBER(vn_year || '000001');
    END IF;
    INSERT INTO �л�(�й�, �̸�, ����)
    VALUES (vn_make_num, vs_nm, vs_subject);
    COMMIT;
END;

SELECT *
FROM �л�;

/*
    LOOP ��
    �ܼ� LOOP���� EXIT(Ż������) �ʼ�
    WHILE �� ���ۿ� ������ true �̸� LOOP����
    FOR �� IN �ʱ갪...�ִ밪 1�� �ʱ갪���� �ִ밪���� ����
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
        EXIT WHEN vn_i > 9; --Ż������
    END LOOP;
END;

DECLARE
    vn_gugudan NUMBER := 1;
    vn_i NUMBER       := 1;
BEGIN
    LOOP
    DBMS_OUTPUT.PUT_LINE(vn_gugudan+1||'��');
    vn_gugudan := vn_gugudan + 1; 
        vn_i:=1;
--        CONTINUE WHEN vn_i = 5; -- �ش������϶� �Ʒ��ǳʶ�
        LOOP
             DBMS_OUTPUT.PUT_LINE(vn_gugudan ||'*' || vn_i || '=' || vn_gugudan*vn_i);
             vn_i := vn_i + 1;
             EXIT WHEN vn_i > 9;
        END LOOP;
        EXIT WHEN vn_gugudan > 8; --Ż������
    END LOOP;
END;

--FOR ��
BEGIN 
    FOR i IN 1..9  --1~9���� 1�� ����
--    FOR i IN  REVERSE 1..9  --1~9���� 1�� ����
    LOOP
        DBMS_OUTPUT.PUT_LINE(2 || '*' || '=' || 2 * i);
    END LOOP;
END;

/*
    ORACLE ����� �����Լ� PL/SQL �� �ۼ�
    ����Ŭ �Լ��� ������ ���ϰ��� 1�� �־����.
*/


-- �л��̸��� �Է¹޾� �Ѽ��� ������ �����ϴ� �Լ��� ����ÿ�
-- input: varchar2, output: number
CREATE OR REPLACE FUNCTION fn_get_hakno (nm VARCHAR2)
RETURN NUMBER
IS      -- �̸��ִ� ����ۼ��� ����δ� IS �� ����
    vn_hakno NUMBER;
BEGIN
    SELECT  
    SUM(C.����)
    INTO vn_hakno
    FROM �л� a , �������� b, ���� c
    WHERE  a.�й� = b.�й�
    AND b.�����ȣ = c.�����ȣ
    AND a.�̸� = nm;
    RETURN vn_hakno;
END;
SELECT fn_get_hakno(�̸�),a.*
FROM �л� a;
--������ ��
--CREATE OR REPLACE FUNCTION fn_get_grades (nm VARCHAR2)
-- RETURN NUMBER
--IS  --�̸��ִ� ��� �ۼ��� ����� IS�� ����
-- vn_grades NUMBER;
--BEGIN
--    SELECT sum(����) 
--        INTO vn_grades
--        FROM �л�,��������,����
--        WHERE �л�.�й� = ��������.�й�
--     AND ��������.�����ȣ = ����.�����ȣ
--     and �л�.�̸� = nm;
--    RETURN vn_grades; 
--END;
--SELECT fn_get_grades(a.�̸�) as ������ --���� ����������Լ� ����� �����(���� �Լ� ó�� �����)
--        ,a.*
--FROM �л� a;
   
   
-- fn_dday('20230829')
-- d-day�� �Է¹޾�(YYYYMMDD)
-- ��������                 input:20230829 return : 1�� ����
-- �������� ������ ǥ��       input:20230827 return : 1�� ����
-- �� �����ϴ� �Լ��� �ۼ��Ͻÿ�
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