ALTER SESSION SET "_ORACLE_SCRIPT"=true;
-- spring 쪽 계정생성
CREATE USER jdbc IDENTIFIED BY jdbc;
-- id: jdbc pw: jdbc
GRANT CONNECT, RESOURCE TO jdbc;
-- 권한 설정
GRANT UNLIMITED TABLESPACE TO jdbc;
-- 테이블 스페이스 권한설정 
-------------------------------------------------------------------
-- jdbc계정 회원 테이블 생성
CREATE TABLE member(
    mem_id VARCHAR2(100) PRIMARY KEY
    ,mem_pw VARCHAR2(100)
    ,mem_nm VARCHAR2(100)
);
INSERT INTO member (mem_id, mem_pw, mem_nm)
VALUES ('admin', 'admin', '관리자');
COMMIT;

SELECT *
FROM MEMBER;