ALTER SESSION SET "_ORACLE_SCRIPT"=true;
-- spring �� ��������
CREATE USER jdbc IDENTIFIED BY jdbc;
-- id: jdbc pw: jdbc
GRANT CONNECT, RESOURCE TO jdbc;
-- ���� ����
GRANT UNLIMITED TABLESPACE TO jdbc;
-- ���̺� �����̽� ���Ѽ��� 
-------------------------------------------------------------------
-- jdbc���� ȸ�� ���̺� ����
CREATE TABLE member(
    mem_id VARCHAR2(100) PRIMARY KEY
    ,mem_pw VARCHAR2(100)
    ,mem_nm VARCHAR2(100)
);
INSERT INTO member (mem_id, mem_pw, mem_nm)
VALUES ('admin', 'admin', '������');
COMMIT;

SELECT *
FROM MEMBER;