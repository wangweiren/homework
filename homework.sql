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
SELECT name "商品名：",price "单价：",stock "库存："
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