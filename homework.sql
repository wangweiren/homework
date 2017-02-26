--�û���t_user
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

--��Ʒ����t_product_category(���������С��𣬱���ʳƷ(�����)��ʳƷ�еķ�����(С���))
CREATE TABLE t_product_category(
id NUMBER(9),
name VARCHAR2(30) CONSTRAINT t_product_category_nn NOT NULL,
parent_id NUMBER(9),
CONSTRAINT t_product_category_id_pk PRIMARY KEY(id),
CONSTRAINT t_product_category_name_uk UNIQUE(name),
CONSTRAINT t_pro_cate_parent_id_fk FOREIGN KEY(parent_id) REFERENCES t_product_category(id)
);

--1.�봴����Ʒ��,�ֱ���û��������Ʒ���һ���Ĳ�������(����䱣���,���浽�ű���)
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
--����û�
INSERT INTO t_user VALUEs(1,'Anny','123456','Anny@163.com',13635428865,'�Ϻ��л��������·5��');
INSERT INTO t_user VALUEs(2,'Vector','123789','Vector@163.com',13635424356,'�Ϻ��л��������·6��');
INSERT INTO t_user VALUEs(3,'Tom','456789','Vector@163.com',13635429944,'�Ϻ��л��������·3��');
INSERT INTO t_user VALUEs(4,'Jame','145679','Jame@163.com',13635425664,'');
--������
INSERT INTO t_product_category VALUES(1,'ͼ��',1);
INSERT INTO t_product_category VALUES(2,'��ѧ�������鼮',1);
INSERT INTO t_product_category VALUES(3,'�������鼮',1);
INSERT INTO t_product_category VALUES(4,'ʳƷ',4);
INSERT INTO t_product_category VALUES(5,'����',4);
INSERT INTO t_product_category VALUES(6,'��ʳƷ',4);
INSERT INTO t_product_category VALUES(7,'�ٻ�',7);
INSERT INTO t_product_category VALUES(8,'�Ҿ�',7);
INSERT INTO t_product_category VALUES(9,'����',7);
--�����Ʒ
INSERT INTO t_product VALUES(1,'java���ľ�','��Java��������Ӱ�����ͼ�ֵ�ĵ�����֮һ',119.00,3,1,2);
INSERT INTO t_product VALUES(2,'��ʱ�䵱������','��һ��ʱ�������鼮',59.00,10,1,3);
INSERT INTO t_product VALUES(3,'����','�����������ۣ�Ӫ���ḻ',15.00,100,4,5);
INSERT INTO t_product VALUES(4,'�ɿ�������','���������ζ��',10.00,10,4,6);
INSERT INTO t_product VALUES(5,'���Ƶ緹��','����ҵ�ζ��',299.00,3,7,8);
INSERT INTO t_product VALUES(6,'vivox7','������ѡ��',2229.00,10,7,9);
INSERT INTO t_product VALUES(7,'�����±���','�������ζ��',4.00,20,4,6);

--2.��ѯÿһ���û���������Ϣ.
SELECT * FROM T_USER;

--3.��ӡ��ÿһ����Ʒ��,���ۼ����,��ʽҪ������:��Ʒ��:***,����:***,���:***
SELECT name "��Ʒ����",price "���ۣ�",stock "��棺"
FROM T_PRODUCT;

--4.��ѯÿһ���û���������Ϣ,�����ַΪ��,����ʾΪ��δ��д
SELECT id,name,password,email,mobile,NVL(address ,'��δ��д')
FROM T_USER;

--5.��ѯ���е��۴���5����Ʒ��,�۸�
SELECT name,price
FROM T_PRODUCT
WHERE price>5;

--6.��ѯ�����2��10֮��(����2,10)��������Ʒ��,���
SELECT name,stock
FROM T_PRODUCT
WHERE STOCK BETWEEN 2 AND 10;

--7.��ѯ���е���Ʒ��,�۸�,�����ռ۸���������
SELECT name,price
FROM T_PRODUCT
ORDER BY price ASC;