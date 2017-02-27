--1.列出所有包含职位‘sal’的员工姓名及其所在的部门。（不区分大小写）
SELECT E.FIRST_NAME "员工姓名",D.NAME "所在部门",E.TITLE "职位"
FROM S_EMP E,S_DEPT D
WHERE LOWER(E.TITLE) LIKE '%sal%' AND E.DEPT_ID=D.ID;

--2.列出所有客户的名字,及其对应的销售的first_name,要求没有销售的客户也显示出来,并且按照名字降序输出.
SELECT C.NAME "客户名字",E.FIRST_NAME "销售名字"
FROM S_CUSTOMER C,S_EMP E
WHERE C.SALES_REP_ID=E.ID(+)
ORDER BY C.NAME DESC;

--3.找出没有提成的员工或者提成低于13的员工姓名，部门及提成，如果提成为空，显示0
SELECT E.FIRST_NAME "姓名",D.NAME "部门",NVL(E.COMMISSION_PCT,0)
FROM S_EMP E, S_DEPT D
WHERE (E.COMMISSION_PCT IS NULL OR E.COMMISSION_PCT<13)AND E.DEPT_ID=D.ID;

--4.查找所有部门id为41的员工的last_name,部门id,部门名，区域
SELECT E.LAST_NAME "员工姓",D.ID "部门ID",D.NAME "部门名",R.NAME "区域"
FROM S_DEPT D,S_EMP E,S_REGION R
WHERE R.ID=D.REGION_ID AND E.DEPT_ID=D.ID AND D.ID=41;

--5.查找所有薪水大于1500员工的last_name,salary,部门名并按照薪水升序排序
SELECT E.LAST_NAME,E.SALARY,D.NAME
FROM S_EMP E,S_DEPT D
WHERE E.SALARY>1500 AND E.DEPT_ID=D.ID
ORDER BY E.SALARY;

--6.列出入职时间早于其领导的所有员工，并按照员工id升序排序。
SELECT worker.first_name,worker.start_date "员工入职时间",manager.start_date "领导入职时间"
FROM s_emp worker,s_emp manager
WHERE worker.manager_id=manager.id
AND manager.start_date>worker.start_date
AND manager.start_date<SYSDATE
AND worker.start_date<SYSDATE
ORDER BY worker.id;

--7.查找s_emp表中的前3条记录
SELECT *
FROM s_emp
WHERE ROWNUM<=3;

--8.查找s_emp表中4~6条记录
SELECT *
FROM s_emp
WHERE ROWNUM<=6
MINUS
SELECT *
FROM s_emp
WHERE ROWNUM<4;

--9.列出每个部门员工的数量，最低薪水，平均薪水，最高薪水
SELECT d.name "部门",MIN(e.salary) "最低薪水",MAX(e.salary) "最高薪水",
TRUNC(AVG(e.salary),2) "平均薪水",COUNT(e.dept_id)"部门员工数量"
FROM s_dept d,s_emp e
WHERE e.dept_id=d.id
GROUP BY d.name;

--10.列出平均薪水小于1400的所有部门的平均薪水及人数
SELECT d.name "部门",TRUNC(AVG(e.salary),2) "平均薪水",COUNT(e.dept_id)"部门员工数量"
FROM s_dept d,s_emp e
WHERE e.dept_id=d.id
GROUP BY d.name
HAVING AVG(e.salary)<1400;

--11.查出部门中每一个员工工资都高于1200的部门名,及部门最低工资,平均工资,并且按照部门升序排序.
SELECT d.name "部门",MIN(e.salary) "最低薪水",
TRUNC(AVG(e.salary),2) "平均薪水",COUNT(e.dept_id)"部门员工数量"
FROM s_dept d,s_emp e
WHERE e.dept_id=d.id
GROUP BY d.name
HAVING MIN(e.salary)>1200
ORDER BY d.name;

--12.查找员工工资高于其领导工资的所有员工
SELECT worker.first_name,worker.salary "员工工资",manager.salary "领导工资"
FROM s_emp worker,s_emp manager
WHERE worker.manager_id=manager.id
AND manager.salary<worker.salary
ORDER BY worker.id;
