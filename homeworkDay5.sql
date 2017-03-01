--1.查询s_emp表中薪水最高的三个员工信息，并按薪水降序排序
SELECT *
FROM (
  SELECT *
  FROM s_emp
  ORDER BY salary DESC
)
WHERE rownum<=3;

--2.列出平均薪水小于1400的所有部门的平均薪水及人数
select dept_id,avg(salary),count(*)
from s_emp
group by dept_id
having avg(salary)<1400;


--3.查看薪资大于Chang员工薪资的员工的信息
select *
from s_emp
where salary>(
  select salary
  from s_emp
  where last_name ='Chang'
)
and last_name!='Chang';

--4.查看薪资大于Chang员工薪资或者所在部门在3号区域下的员工的信息
select *
from s_emp
where (salary>(
  select salary
  from s_emp
  where last_name ='Chang'
)
or id in(
  select e.id
  from s_emp e,s_dept d,s_region r
  where e.DEPT_ID=d.id and d.REGION_ID=r.id and r.id=3
))
and last_name!='Chang';

--5.查询订单金额最低的5个订单号，订单金额。
select *
from (
  select id,TOTAL
  from s_ord
  order by total
)
where ROWNUM<=5;

--6.查找各部门的平均工资，包含字段部门编号，部门名，平均工资
select d.id,d.name,avg(salary)
from s_emp e,s_dept d
where e.dept_id=d.id
GROUP by d.id,d.name;

--7.查看薪资高于Chang员工经理薪资的员工信息
select *
from s_emp
where salary>(
  select e2.salary
  from s_emp e1,s_emp e2
  where e1.MANAGER_ID=e2.id
  and e1.last_name ='Chang'
);

--8.查看薪资大于Chang所在区域平均工资的员工信息
select *
from s_emp
where salary >(
  select avg(salary)
  from s_emp e,s_dept d,s_region r
  where e.DEPT_ID=d.id and d.REGION_ID=r.id 
  and r.id=(
    select r.id
   from s_emp e,s_dept d,s_region r
   where e.DEPT_ID=d.id and d.REGION_ID=r.id 
   and e.last_name ='Chang'
  )
);

--9.查看Chang员工所在部门其他员工薪资总和
select *
from s_emp
where dept_id=(
  select d.id
  from s_emp e,s_dept d,s_region r
  where e.DEPT_ID=d.id and d.REGION_ID=r.id 
  and e.last_name ='Chang'
);


--10.统计不由11号和12号员工负责的客户的人数
select e.first_name,count(*)
from s_emp e,s_customer c
where c.SALES_REP_ID=e.id
and e.id !=11
and e.id!=12
GROUP by e.id,e.first_name;

