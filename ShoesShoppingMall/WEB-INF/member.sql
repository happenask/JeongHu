create table member(
id						varchar2(20) ,
password				varchar2(30) not null,
name					varchar2(20) not null,
register_number1		char(6) not null,
register_number2		char(7) not null,
tel						varchar2(20) not null,
member_level			varchar2(20) not null,
mileage					number,
zipcode					varchar2(10) not null,
address			varchar2(100) not null,
member_num				number,
constraint member_pk primary key(member_num)
);
create sequence member_seq

drop table member;
create sequence member_number;
drop sequence member_number;

select member_number.nextval from dual

select * from(
	select * from model
	order by model_num desc
) where rownum <= 12
