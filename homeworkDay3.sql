--1.�г����а���ְλ��sal����Ա�������������ڵĲ��š��������ִ�Сд��
SELECT E.FIRST_NAME "Ա������",D.NAME "���ڲ���",E.TITLE "ְλ"
FROM S_EMP E,S_DEPT D
WHERE LOWER(E.TITLE) LIKE '%sal%' AND E.DEPT_ID=D.ID;

--2.�г����пͻ�������,�����Ӧ�����۵�first_name,Ҫ��û�����۵Ŀͻ�Ҳ��ʾ����,���Ұ������ֽ������.
SELECT C.NAME "�ͻ�����",E.FIRST_NAME "��������"
FROM S_CUSTOMER C,S_EMP E
WHERE C.SALES_REP_ID=E.ID(+)
ORDER BY C.NAME DESC;

--3.�ҳ�û����ɵ�Ա��������ɵ���13��Ա�����������ż���ɣ�������Ϊ�գ���ʾ0
SELECT E.FIRST_NAME "����",D.NAME "����",NVL(E.COMMISSION_PCT,0)
FROM S_EMP E, S_DEPT D
WHERE (E.COMMISSION_PCT IS NULL OR E.COMMISSION_PCT<13)AND E.DEPT_ID=D.ID;

--4.�������в���idΪ41��Ա����last_name,����id,������������
SELECT E.LAST_NAME "Ա����",D.ID "����ID",D.NAME "������",R.NAME "����"
FROM S_DEPT D,S_EMP E,S_REGION R
WHERE R.ID=D.REGION_ID AND E.DEPT_ID=D.ID AND D.ID=41;

--5.��������нˮ����1500Ա����last_name,salary,������������нˮ��������
SELECT E.LAST_NAME,E.SALARY,D.NAME
FROM S_EMP E,S_DEPT D
WHERE E.SALARY>1500 AND E.DEPT_ID=D.ID
ORDER BY E.SALARY;

--6.�г���ְʱ���������쵼������Ա����������Ա��id��������
SELECT worker.first_name,worker.start_date "Ա����ְʱ��",manager.start_date "�쵼��ְʱ��"
FROM s_emp worker,s_emp manager
WHERE worker.manager_id=manager.id
AND manager.start_date>worker.start_date
AND manager.start_date<SYSDATE
AND worker.start_date<SYSDATE
ORDER BY worker.id;

--7.����s_emp���е�ǰ3����¼
SELECT *
FROM s_emp
WHERE ROWNUM<=3;

--8.����s_emp����4~6����¼
SELECT *
FROM s_emp
WHERE ROWNUM<=6
MINUS
SELECT *
FROM s_emp
WHERE ROWNUM<4;

--9.�г�ÿ������Ա�������������нˮ��ƽ��нˮ�����нˮ
SELECT d.name "����",MIN(e.salary) "���нˮ",MAX(e.salary) "���нˮ",
TRUNC(AVG(e.salary),2) "ƽ��нˮ",COUNT(e.dept_id)"����Ա������"
FROM s_dept d,s_emp e
WHERE e.dept_id=d.id
GROUP BY d.name;

--10.�г�ƽ��нˮС��1400�����в��ŵ�ƽ��нˮ������
SELECT d.name "����",TRUNC(AVG(e.salary),2) "ƽ��нˮ",COUNT(e.dept_id)"����Ա������"
FROM s_dept d,s_emp e
WHERE e.dept_id=d.id
GROUP BY d.name
HAVING AVG(e.salary)<1400;

--11.���������ÿһ��Ա�����ʶ�����1200�Ĳ�����,��������͹���,ƽ������,���Ұ��ղ�����������.
SELECT d.name "����",MIN(e.salary) "���нˮ",
TRUNC(AVG(e.salary),2) "ƽ��нˮ",COUNT(e.dept_id)"����Ա������"
FROM s_dept d,s_emp e
WHERE e.dept_id=d.id
GROUP BY d.name
HAVING MIN(e.salary)>1200
ORDER BY d.name;

--12.����Ա�����ʸ������쵼���ʵ�����Ա��
SELECT worker.first_name,worker.salary "Ա������",manager.salary "�쵼����"
FROM s_emp worker,s_emp manager
WHERE worker.manager_id=manager.id
AND manager.salary<worker.salary
ORDER BY worker.id;
