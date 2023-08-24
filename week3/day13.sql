SELECT a.*
        ,count (*) over() as ��ü�Ǽ�
FROM �л� a;

SELECT emp_name
        , department_id
        ,ROW_NUMBER() OVER( PARTITION BY department_id ORDER BY emp_name) as dep_row
       
FROM employees;

-- RANK(), DENSE_RANK()  
SELECT mem_id
        ,mem_name
        ,mem_job
        ,mem_mileage
        ,RANK() OVER( PARTITION BY mem_job ORDER BY mem_mileage DESC) as mem_rank
        ,DENSE_RANK() OVER( PARTITION BY mem_job ORDER BY mem_mileage DESC) as mem_DENSE_rank
FROM member;

SELECT emp_name
        ,salary
        ,department_id
        ,RANK() OVER(PARTITION BY department_id ORDER BY salary DESC) as rnak
        ,DENSE_RANK() OVER(PARTITION BY department_id ORDER BY salary DESC) as DENSE_rnak
FROM employees;
-- �μ��� salary �� ���� ū ������ ����Ͻÿ�
select *
from (
        SELECT emp_name
                ,salary
                ,department_id
                ,RANK() OVER(PARTITION BY department_id ORDER BY salary DESC) as rnak2
        FROM employees
        ) a
where a.rnak2 = 1;

select*
from(SELECT job_id
,salary
,RANK() OVER(PARTITION BY job_id ORDER BY salary DESC) as rnak2
FROM employees)
where rnak2 = 1;