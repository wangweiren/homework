--1.查询每一个职位的职位名,员工数量
SELECT title "职位名：",COUNT(*)"员工数量："
FROM s_emp
GROUP BY title;

--2.查询有客户的销售的first_name,客户的数量
SELECT e.first_name "销售名：",COUNT(*)"客户数量"
from s_emp e,s_customer c
where e.id=c.sales_rep_id
GROUP BY c.sales_rep_id,e.first_name;

--3.查询部门编号大于40的每个部门的人数,平均薪资
SELECT r.name"区域",d.name "部门",COUNT(*)"人数",ROUND(AVG(e.salary),2)"平均薪资"
FROM s_emp e,s_dept d,s_region r
WHERE e.dept_id=d.id
AND d.region_id=r.id
AND d.id>40
GROUP BY r.name,d.name;

--4.查询职位包含sals的所有员工的总人数
SELECT title "职位",COUNT(*)"总人数"
FROM s_emp
WHERE LOWER(title) LIKE '%sal%' 
GROUP BY  title;

--5.查询每个区域的员工数量
SELECT r.name "区域",COUNT(*)
FROM s_emp e,s_region r,s_dept d
WHERE d.region_id=r.id
AND e.dept_id=d.id
GROUP BY r.id,r.name;
