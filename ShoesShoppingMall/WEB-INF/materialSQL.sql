create table material(
	material_id varchar2(20),
	material_name varchar2(20) not null,
	material_type varchar2(20) not null,
	material_spec varchar2(20),
	material_supply varchar2(30) not null,
	material_price number,
	material_quantity number not null,
	constraint material_pk primary key(material_id)
)
drop table category
create table category(
	product_category varchar2(20) not null,
	category_heel varchar2(20)not null,
	category_leather varchar2(20),
	category_acc varchar2(20),
	constraint category_pk primary key(product_category)
)




create table supplier(
	supplier_name varchar2(20) not null,
	supplier_address varchar2(100) not null,
	supplier_tel varchar2(20) not null,
	supplier_message varchar2(100)
)

alter table category
drop column category_acc2;

drop table product
create table product(
	product_id varchar2(20),
	product_price varchar2(20) not null,
	product_heel varchar2(20),
	product_leather varchar2(20),
	product_acc1 varchar2(20),
	product_acc2 varchar2(20),
	product_size number(3),
	product_message varchar2(100),
	constraint product_pk primary key(product_id),
	constraint heel_fk foreign key(product_heel) references material(material_id),
	constraint leather_fk foreign key(product_leather) references material(material_id),
	constraint acc1_fk foreign key(product_acc1) references material(material_id),
	constraint acc2_fk foreign key(product_acc2) references material(material_id)
)


create table model(
	model_num number,
	model_heel varchar2(20),
	model_leather varchar2(20),
	model_price number,
	model_name varchar2(20),
	model_type varchar2(20)

)
drop table model



INSERT INTO supplier (supplier_name, supplier_address, supplier_tel, supplier_message) VALUES('가죽상회', '경기도 성남시 분당구', '031-333-4444', '동물가죽 판매하는곳');
INSERT INTO supplier (supplier_name, supplier_address, supplier_tel, supplier_message) VALUES('소가죽집', '강원도 산골시 소많은동', '033-666-8888', '산골 소많은 하는곳');
INSERT INTO supplier (supplier_name, supplier_address, supplier_tel, supplier_message) VALUES('제주가죽', '제주도 어쩌고 저쩌고 가죽동네', '066-322-2222', '말 가죽 판매하는곳');
INSERT INTO supplier (supplier_name, supplier_address, supplier_tel, supplier_message) VALUES('하이힐', '서울시 마포구 무슨동 어느공장', '02-777-8282', '하이힐 직구 가능한곳');
INSERT INTO supplier (supplier_name, supplier_address, supplier_tel, supplier_message) VALUES('로우힐', '서울시 서초구 강남동 그곳빌딩', '02-111-4321', ' ');
INSERT INTO supplier (supplier_name, supplier_address, supplier_tel, supplier_message) VALUES('악세S', '부산시 남포동 어쩌동', '051-5555-4321', '리본계열');
INSERT INTO supplier (supplier_name, supplier_address, supplier_tel, supplier_message) VALUES('A세서리', '충청도 어디지역 어디마을 그곳공장', '044-991-4321', '끈 장식');

INSERT INTO category (PRODUCT_category, category_heel, category_leather, category_acc) values('FLAT','3CM','SNAKESKIN','RIBBON');
INSERT INTO category (PRODUCT_category, category_heel, category_leather, category_acc) values('PUMPS','4CM','COWHIDE','KORSAGE');
INSERT INTO category (PRODUCT_category, category_heel, category_leather, category_acc) values('SANDAL','5CM','SHEEPSKIN','BUTTON');
INSERT INTO category (PRODUCT_category, category_heel, category_leather, category_acc) values('SLINGBACK','6CM','CALF','SYMBOL');
INSERT INTO category (PRODUCT_category, category_heel, category_leather, category_acc) values('MULE','7CM','suede','');
INSERT INTO category (PRODUCT_category, category_heel, category_leather, category_acc) values('BOOTS','8CM','','');
INSERT INTO category (PRODUCT_category, category_heel, category_leather, category_acc) values('WEDGE','9CM','','');



select * from MATERIAL

INSERT INTO material (material_id, material_name, material_type, material_spec, material_supply, material_price, material_quantity) VALUES('g-01',  '소가죽A', 'LEATHER', '적갈색', '소가죽집', 23000, 320);
INSERT INTO material (material_id, material_name, material_type, material_spec, material_supply, material_price, material_quantity) VALUES('g-02',  '소가죽B', 'LEATHER', '검은색', '소가죽집', 20000, 200);
INSERT INTO material (material_id, material_name, material_type, material_spec, material_supply, material_price, material_quantity) VALUES('g-03',  '소가죽C', 'LEATHER', '황색', '가죽상회', 17000, 220);
INSERT INTO material (material_id, material_name, material_type, material_spec, material_supply, material_price, material_quantity) VALUES('g-04',  '인조가죽A', 'LEATHER', '빨간색', '제주가죽', 10000, 400);
INSERT INTO material (material_id, material_name, material_type, material_spec, material_supply, material_price, material_quantity) VALUES('g-05',  '인조가죽B', 'LEATHER', '검은색', '가죽상회', 13000, 320);
INSERT INTO material (material_id, material_name, material_type, material_spec, material_supply, material_price, material_quantity) VALUES('g-06',  '토끼가죽A', 'LEATHER', '흰색', '가죽상회', 15000, 200);
INSERT INTO material (material_id, material_name, material_type, material_spec, material_supply, material_price, material_quantity) VALUES('h-01',  '통굽', 'HEEL', '5cm', '로우힐', 23000, 320);
INSERT INTO material (material_id, material_name, material_type, material_spec, material_supply, material_price, material_quantity) VALUES('h-02',  '통굽', 'HEEL', '7cm', '로우힐', 20000, 200);
INSERT INTO material (material_id, material_name, material_type, material_spec, material_supply, material_price, material_quantity) VALUES('h-03',  '얇은힐', 'HEEL', '5cm', '히이힐', 37000, 220);
INSERT INTO material (material_id, material_name, material_type, material_spec, material_supply, material_price, material_quantity) VALUES('h-04',  '얇은힐', 'HEEL', '6cm', '히이힐', 38000, 400);
INSERT INTO material (material_id, material_name, material_type, material_spec, material_supply, material_price, material_quantity) VALUES('h-05',  '얇은힐', 'HEEL', '7cm', '히이힐', 38000, 320);
INSERT INTO material (material_id, material_name, material_type, material_spec, material_supply, material_price, material_quantity) VALUES('h-06',  '낮은힐', 'HEEL', '3cm', '로우힐', 15000, 200);
INSERT INTO material (material_id, material_name, material_type, material_spec, material_supply, material_price, material_quantity) VALUES('Ar-01',  '나비리본', 'ACC', 'R-Red', '악세A', 20000, 200);
INSERT INTO material (material_id, material_name, material_type, material_spec, material_supply, material_price, material_quantity) VALUES('Ar-02',  '나비리본', 'ACC', 'R-BLACK', '악세A', 37000, 220);
INSERT INTO material (material_id, material_name, material_type, material_spec, material_supply, material_price, material_quantity) VALUES('Ar-03',  '나비리본', 'ACC', 'S-WHITE', '악세A', 38000, 400);
INSERT INTO material (material_id, material_name, material_type, material_spec, material_supply, material_price, material_quantity) VALUES('Ar-04',  '별장식', 'ACC', 'RUBE', '악세A', 38000, 320);
INSERT INTO material (material_id, material_name, material_type, material_spec, material_supply, material_price, material_quantity) VALUES('Ar-05',  '별장식', 'ACC', 'DIAMOND', '악세A', 150000, 5);
INSERT INTO material (material_id, material_name, material_type, material_spec, material_supply, material_price, material_quantity) VALUES('As-01',  '끈장식', 'ACC', 'BLACK-2cm', 'A세서리', 12000, 220);
INSERT INTO material (material_id, material_name, material_type, material_spec, material_supply, material_price, material_quantity) VALUES('As-02',  '끈장식', 'ACC', 'BLACK-1cm', 'A세서리', 12000, 400);
INSERT INTO material (material_id, material_name, material_type, material_spec, material_supply, material_price, material_quantity) VALUES('As-03',  '리본끈', 'ACC', 'L', 'A세서리', 18000, 320);
INSERT INTO material (material_id, material_name, material_type, material_spec, material_supply, material_price, material_quantity) VALUES('As-04',  '리본끈', 'ACC', 'M', 'A세서리', 180000, 50);
INSERT INTO material (material_id, material_name, material_type, material_spec, material_supply, material_price, material_quantity) VALUES('As-05',  '리본끈', 'ACC', 'S', 'A세서리', 18000, 55);

select 	material_id, material_name, material_type, material_spec, material_supply, material_price, material_quantity,supplier_name, supplier_address, supplier_tel, supplier_message from material, supplier where material_type = 'HEEL' and material_supply=supplier_name(+) 