--1.��ѯs_emp����нˮ��ߵ�����Ա����Ϣ������нˮ��������
SELECT *
FROM (
  SELECT *
  FROM s_emp
  ORDER BY salary DESC
)
WHERE rownum<=3;

--2.�г�ƽ��нˮС��1400�����в��ŵ�ƽ��нˮ������
select dept_id,avg(salary),count(*)
from s_emp
group by dept_id
having avg(salary)<1400;


--3.�鿴н�ʴ���ChangԱ��н�ʵ�Ա������Ϣ
select *
from s_emp
where salary>(
  select salary
  from s_emp
  where last_name ='Chang'
)
and last_name!='Chang';

--4.�鿴н�ʴ���ChangԱ��н�ʻ������ڲ�����3�������µ�Ա������Ϣ
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

--5.��ѯ���������͵�5�������ţ�������
select *
from (
  select id,TOTAL
  from s_ord
  order by total
)
where ROWNUM<=5;

--6.���Ҹ����ŵ�ƽ�����ʣ������ֶβ��ű�ţ���������ƽ������
select d.id,d.name,avg(salary)
from s_emp e,s_dept d
where e.dept_id=d.id
GROUP by d.id,d.name;

--7.�鿴н�ʸ���ChangԱ������н�ʵ�Ա����Ϣ
select *
from s_emp
where salary>(
  select e2.salary
  from s_emp e1,s_emp e2
  where e1.MANAGER_ID=e2.id
  and e1.last_name ='Chang'
);

--8.�鿴н�ʴ���Chang��������ƽ�����ʵ�Ա����Ϣ
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

--9.�鿴ChangԱ�����ڲ�������Ա��н���ܺ�
select *
from s_emp
where dept_id=(
  select d.id
  from s_emp e,s_dept d,s_region r
  where e.DEPT_ID=d.id and d.REGION_ID=r.id 
  and e.last_name ='Chang'
);


--10.ͳ�Ʋ���11�ź�12��Ա������Ŀͻ�������
select e.first_name,count(*)
from s_emp e,s_customer c
where c.SALES_REP_ID=e.id
and e.id !=11
and e.id!=12
GROUP by e.id,e.first_name;

