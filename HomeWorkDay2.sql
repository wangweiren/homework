--一、oracle简介
--1.管理员创建普通用户命令及赋予普通用户创建资源、连接权限的命令为？
CREATE USER VECTOR IDENTIFIED BY VECTOR;
GRANT CONNECT,RESOURCE TO VECTOR;

--2.设置当前会话日期语言为英文的命令？
ALTER SESSION SET NLS_DATE_LANGUAGE=ENGLISH;

--3.读取脚本的命令？假如脚本路径为：e:\aa\my.sql
START E:\aa\my.sql;
@E:\aa\my.sql;
--注:这里说有错误，但是能够运行

--4.显示s_emp的表结构命令？
DESC s_emp;

--二、查询
--名：first_name  姓：last_name
--1.查询所有员工的first_name和last_name,要求查询结果为一列，并且列名为Name
SELECT last_name||'.'||first_name "name"
FROM s_emp;

--2.查看员工的员工id，名字和年薪,年薪列名为annual（注意如果有提成，需要算进去）
SELECT id,last_name||'.'||first_name "name",
salary*(1+NVL(COMMISSION_PCT,0)/100)*12 annual
FROM s_emp;

--3. 查看员工的员工id，全名和职位名称，全名和职位名称合并成一列显示，且格式为：姓 名，职位名称
SELECT id,last_name||'.'||first_name||','||title 
FROM s_emp;

--4. 查看员工工资小于1000的员工id和名字
SELECT id,first_name||'.'||last_name "名字"
FROM s_emp
WHERE salary<1000;

--5. 查看员工号1,3,5,7,9员工的工资
SELECT id,salary
FROM s_emp
WHERE mod(id,2)=1 and id<10;

--6.查看员工名字长度不小于5，且第四个字母为n字母的员工id和工资
SELECT id,salary
FROM s_emp
WHERE LENGTH(FIRST_NAME)>=5 AND FIRST_NAME LIKE '___n%' ;

--7. 查看员工部门为41 或者 44号部门 且工资小于1000的员工id和名字
SELECT id,first_name
from s_emp
WHERE DEPT_ID IN(41,44) AND SALARY <1000;

--8.显示员工姓氏中第三个字母为“a”(不区分大小写)的所有员工的名字和姓氏
SELECT first_name,last_name
FROM s_emp
WHERE LOWER(last_name) LIKE '__a%';

--9.显示员工姓氏中有“a”和“e”的所有员工的姓氏和名字
SELECT first_name,last_name
FROM s_emp
WHERE last_name LIKE '%a%' and last_name LIKE'%e%';

--10.显示在92年1月之后入职的所有员工的姓氏和录用日期,并按照姓氏升序排序
SELECT last_name,start_date
FROM s_emp
WHERE start_date BETWEEN '01-1月-92' and SYSDATE
ORDER BY last_name ASC;
--11.继续完成贯穿里面的内容(贯穿2_添加数据、查询数据.txt)
--用户表：t_user
CREATE TABLE t_user(
id NUMBER(9),
name VARCHAR2(40) CONSTRAINT t_user_name_nn NOT NULL,
password VARCHAR2(30) CONSTRAINT t_uder_password_nn NOT NULL,
email VARCHAR2(50),
mobile VARCHAR2(12),
address VARCHAR2(50),
CONSTRAINT t_user_id_pk PRIMARY KEY(id),
CONSTRAINT t_user_name_uk UNIQUE(name)
);

--商品类别表：t_product_category(包括大类别，小类别，比如食品(大类别)，食品中的方便面(小类别))
CREATE TABLE t_product_category(
id NUMBER(9),
name VARCHAR2(30) CONSTRAINT t_product_category_nn NOT NULL,
parent_id NUMBER(9),
CONSTRAINT t_product_category_id_pk PRIMARY KEY(id),
CONSTRAINT t_product_category_name_uk UNIQUE(name),
CONSTRAINT t_pro_cate_parent_id_fk FOREIGN KEY(parent_id) REFERENCES t_product_category(id)
);

--1.请创建商品表,分别给用户、类别、商品添加一定的测试数据(把语句保存好,保存到脚本中)
create table t_product(
id NUMBER(9) CONSTRAINT t_product_id_pk PRIMARY KEY,
name VARCHAR2(40) CONSTRAINT t_product_name_nn NOT NULL,
description VARCHAR2(100),
price NUMBER(9,2) CONSTRAINT t_product_price_nn NOT NULL,
stock NUMBER(10) DEFAULT 0,
cate_id NUMBER(9),
cate_child_id NUMBER(9),
CONSTRAINT t_product_cate_id_fk FOREIGN KEY(cate_id) REFERENCES t_product_category(id),
CONSTRAINT t_pro_cate_child_id_fk FOREIGN KEY(cate_child_id) REFERENCES t_product_category(id)
);
--添加用户
INSERT INTO t_user VALUEs(1,'Anny','123456','Anny@163.com',13635428865,'上海市黄浦区天津路5号');
INSERT INTO t_user VALUEs(2,'Vector','123789','Vector@163.com',13635424356,'上海市黄浦区天津路6号');
INSERT INTO t_user VALUEs(3,'Tom','456789','Vector@163.com',13635429944,'上海市黄浦区天津路3号');
INSERT INTO t_user VALUEs(4,'Jame','145679','Jame@163.com',13635425664,'');
--添加类别
INSERT INTO t_product_category VALUES(1,'图书',1);
INSERT INTO t_product_category VALUES(2,'科学技术类书籍',1);
INSERT INTO t_product_category VALUES(3,'人文类书籍',1);
INSERT INTO t_product_category VALUES(4,'食品',4);
INSERT INTO t_product_category VALUES(5,'生鲜',4);
INSERT INTO t_product_category VALUES(6,'膨化食品',4);
INSERT INTO t_product_category VALUES(7,'百货',7);
INSERT INTO t_product_category VALUES(8,'家居',7);
INSERT INTO t_product_category VALUES(9,'数码',7);
--添加商品
INSERT INTO t_product VALUES(1,'java核心卷','是Java领域最有影响力和价值的的著作之一',119.00,3,1,2);
INSERT INTO t_product VALUES(2,'把时间当做朋友','是一本时间管理的书籍',59.00,10,1,3);
INSERT INTO t_product VALUES(3,'鲢鱼','鲢鱼肉质鲜嫩，营养丰富',15.00,100,4,5);
INSERT INTO t_product VALUES(4,'巧克力蛋糕','充满甜甜的味道',10.00,10,4,6);
INSERT INTO t_product VALUES(5,'虎牌电饭煲','煮出家的味道',299.00,3,7,8);
INSERT INTO t_product VALUES(6,'vivox7','你的最好选择',2229.00,10,7,9);
INSERT INTO t_product VALUES(7,'奥利奥饼干','就是这个味道',4.00,20,4,6);

--2.查询每一个用户的所有信息.
SELECT * FROM T_USER;

--3.打印出每一个商品名,单价及库存,格式要求如下:商品名:***,单价:***,库存:***
SELECT '商品名：'||name|| ',单价：'||price||',库存：'||stock 
FROM T_PRODUCT;

--4.查询每一个用户的所有信息,如果地址为空,则显示为暂未填写
SELECT id,name,password,email,mobile,NVL(address ,'暂未填写')
FROM T_USER;

--5.查询所有单价大于5的商品名,价格
SELECT name,price
FROM T_PRODUCT
WHERE price>5;

--6.查询库存在2到10之间(包括2,10)的所有商品名,库存
SELECT name,stock
FROM T_PRODUCT
WHERE STOCK BETWEEN 2 AND 10;

--7.查询所有的商品名,价格,并按照价格升序排序
SELECT name,price
FROM T_PRODUCT
ORDER BY price ASC;










