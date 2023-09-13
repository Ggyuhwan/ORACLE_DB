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

CREATE TABLE board(
    board_no    NUMBER(10)     PRIMARY KEY
    ,board_title VARCHAR2(1000)
    ,board_content VARCHAR2(4000)
    ,mem_id         VARCHAR2(100)
    ,create_date    DATE DEFAULT SYSDATE
    ,update_date    DATE DEFAULT SYSDATE
    );
ALTER TABLE board 
ADD CONSTRAINT fk_board FOREIGN KEY(mem_id) REFERENCES member(mem_id);

INSERT INTO board(  board_no, board_title, board_content, mem_id)
VALUES((SELECT NVL(MAX(board_no),0) +1
FROM board)
    ,'공지사항'
    ,'첫번째 글'
    ,'USA');
SELECT a.board_no
    , a.board_title
    , a.board_content
    , b.mem_id
    , b.mem_nm
    , a.create_date
    , a.update_date
FROM board a, member b
WHERE a.mem_id = b.mem_id
ORDER BY a.update_date DESC;

SELECT NVL(MAX(board_no),0) +1
FROM board;
commit;
