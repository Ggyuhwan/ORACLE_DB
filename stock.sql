-- print(row['itemCode'], row['stockName'], row['closePrice'],row['compareToPreviousClosePrice'])

CREATE TABLE stocks(
    item_code       VARCHAR2(10)
    ,stock_nm       VARCHAR2(100)
    ,close_price    VARCHAR2(100)
    ,compare_close  VARCHAR2(100)
    ,create_dt      DATE default SYSDATE
    );
    
    
INSERT INTO stocks( item_code, stock_nm, close_price,compare_close)
VALUES (:1,:2,:3,:4);

CREATE TABLE md_stocks AS 


select stock_nm, replace(close_price,',','')- replace(compare_close,',','')
from stocks;
select stock_nm, ABS(replace(compare_close,',','') - 2333)
from stocks;
GROUP BY ABS(replace(compare_close,',',''));


select ABS(round(avg(replace(compare_close,',','')),0)) as ∆Ú±’
from stocks;

select distinct(stock_nm),COMPARE_CLOSE,close_price
from stocks
where compare_close >='0'
order by 3 desc;

select stock_nm, replace(close_price,',','')- replace(compare_close,',','')
from stocks
WHERE replace(close_price,',','')- replace(compare_close,',','')>=( SELECT AVG(replace(close_price,',','')- replace(compare_close,',',''))
        FROM STOCKS)
ORDER BY 2;


 SELECT AVG(replace(close_price,',','')- replace(compare_close,',',''))
        FROM STOCKS;

WITH T1 as (SELECT AVG(replace(close_price,',','')- replace(compare_close,',','') )as ∆Ú±’
            FROM STOCKS)
, T2 as (select stock_nm, replace(close_price,',','')- replace(compare_close,',','') as ª©±‚
        from stocks    
        )
select *
from t1,t2
where t2.ª©±‚ > t1.∆Ú±’ 
order by t2.ª©±‚;

WITH T1 as (select ABS(round(avg(replace(compare_close,',','')),0)) 
from stocks
)
, T2 as (
       select ABS(replace(compare_close,',',''))
from stocks
group by compare_close
)

SELECT T1 - T2
FROM T1, T2;
desc stocks;
drop table tb_stock_bbs;
CREATE TABLE TB_stock_bbs(
    item_code VARCHAR2(10)
    ,discussionId VARCHAR2(100)
    ,bbs_title VARCHAR2(1000)
    ,bbs_contents VARCHAR2 (4000)
    ,creatr_date DATE
    ,readCount NUMBER
    ,goodCount NUMBER
    ,badCount  NUMBER
    ,commentCount  NUMBER
    , update_date DATE
    , CONSTRAINT stock_bbs_pk PRIMARY KEY(item_code, discussionId)
    );
MERGE INTO tb_stock_bbs a
USING dual
ON (a.item_code = :1
    and a.discussionId = :2)
WHEN MATCHED THEN
    UPDATE SET a.readCount = :3
                ,a.goodCount = :4
                ,a.badCount = :5
                ,a.commentCount = :6
WHEN NOT MATCHED THEN
    INSERT (a.item_code, a.discussionId, a.bbs_title, a.bbs_contents
    ,a.creatr_date, a.readCount, a.goodCount, a.badCount, a.commentCount, a.update_date)
    VALUES (:7, :8, :9, :10, to_date(:11,'YYYY-MM-DD HH24:MI:SS'), :12, :13, :14, :15, SYSDATE); --≥‚ø˘¿œ Ω√∫–√  ≈∏¿‘ ∏¬√ﬂ±‚

select distinct(STOCK_NM)
from stocks 
where item_code in (select item_code from tb_stock_bbs);

select *
from TB_stock_bbs;
SELECT a.item_code, a.stock_nm, sum(b.readcount), sum(b.goodcount)
        , sum(b.badcount), sum(b.commentcount)
from stocks a, tb_stock_bbs b
where a.item_code = b.item_code
group by a.item_code, a.stock_nm
order by 3 desc;

SELECT *
FROM stocks
WHERE rownum <=5;