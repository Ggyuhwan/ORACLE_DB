SELECT *
FROM EMP
WHERE SAL > (SELECT SAL
            FROM EMP
            WHERE ENAME = 'JONES');
            
SELECT * 
FROM EMP
WHERE COMM > (SELECT COMM
                FROM EMP
                WHERE ENAME = 'ALLEN');
                
SELECT * 
FROM EMP
WHERE HIREDATE < (SELECT HIREDATE
                FROM EMP 
                WHERE ENAME = 'SCOTT');

SELECT E.EMPNO, E.ENAME, E.JOB, E.SAL, D.DEPTNO, D.DNAME, D.LOC
FROM EMP E, DEPT D
WHERE E.DEPTNO = D.DEPTNO
AND E.DEPTNO = 20
AND E.SAL > (SELECT AVG(SAL)
            FROM EMP);
            
SELECT *
FROM EMP
WHERE DEPTNO NOT IN (20, 30);
SELECT * 
FROM EMP
WHERE SAL IN (SELECT MAX(SAL)
                FROM EMP
                GROUP BY DEPTNO);
select * 
from emp
where sal = some (select max(sal)
                from emp
                group by deptno);
select e.empno, e.ename
,d.deptno ,d.dname, d.loc
from emp e, dept d
where e.deptno = d.deptno
and sal >= 3000
order by 5;

select e.job,e.empno,e.ename,e.sal
,d.deptno, d.dname
from emp e, dept d
where e. deptno = d.deptno
and e.job = 'SALESMAN';