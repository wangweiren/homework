--1.��ѯÿһ��ְλ��ְλ��,Ա������
SELECT title "ְλ����",COUNT(*)"Ա��������"
FROM s_emp
GROUP BY title;

--2.��ѯ�пͻ������۵�first_name,�ͻ�������
SELECT e.first_name "��������",COUNT(*)"�ͻ�����"
from s_emp e,s_customer c
where e.id=c.sales_rep_id
GROUP BY c.sales_rep_id,e.first_name;

--3.��ѯ���ű�Ŵ���40��ÿ�����ŵ�����,ƽ��н��
SELECT r.name"����",d.name "����",COUNT(*)"����",ROUND(AVG(e.salary),2)"ƽ��н��"
FROM s_emp e,s_dept d,s_region r
WHERE e.dept_id=d.id
AND d.region_id=r.id
AND d.id>40
GROUP BY r.name,d.name;

--4.��ѯְλ����sals������Ա����������
SELECT title "ְλ",COUNT(*)"������"
FROM s_emp
WHERE LOWER(title) LIKE '%sal%' 
GROUP BY  title;

--5.��ѯÿ�������Ա������
SELECT r.name "����",COUNT(*)
FROM s_emp e,s_region r,s_dept d
WHERE d.region_id=r.id
AND e.dept_id=d.id
GROUP BY r.id,r.name;
