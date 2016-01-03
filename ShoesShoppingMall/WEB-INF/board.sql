테이블 - 게시판(board)
속성
no 		: 		number - primary key :글번호
title		: 		varchar2(150) - not null :글제목
writer 	:		varchar2(30) - not null : 글 작성자
content	:		varchar2(4000) - not null : 글내용
writedate : 	varchar2(14)	- not null : 글작성(수정) 일시 ()yyyyMMddHHmmss)
viewcount : 	number  - not null : 조회수(최초입력 : 0, 조회시마다 1씩 증가)
---------답변과 관련된 속성----------
refamily		: 	number - not null : 원본글 기준으로 그 답변 글들을 묶은 그룹 번호
												  기준글(최초 원본글) - 새로운 값(글번호)
												  답변글 : 답변하는 글의 refamily값
restep 		: 	number - not null : 같은 refamily 묶인 글들사이에서의 정렬 순서
												  기준글 : 0
												  답변글 : 답변하는 글의 restep값 + 1
relevel 		: 	number - not null : 답변 레벨
												  기준글 : 0
												  답변글 : 답변하는 글의 relevel + 1												  
시퀀스-게시판 글번호를 위한 자동증가 시퀀스
이름 : board_no_seq : 0~무한대, 1씩 증가
----------------------쿼리---------------------------
drop table board;
purge recyclebin;
create table board(
	no number,
	title varchar2(150) not null,
	writer varchar2(30) not null,
	content varchar2(4000) not null,
	writedate varchar2(14) not null,
	viewcount number not null,
	refamily number not null,
	restep number not null,
	relevel number not null,
	fileName varchar2(30),
	constraint board_pk primary key(no)
)
;

create table porder(
	order_id varchar2(30),
	order_member number,
	order_product varchar2(30),
	order_date varchar2(30),
	order_zipcode varchar2(30),
	order_address varchar2(30),
	order_level number,
	order_msg varchar2(30)
);



create sequence board_no_seq
nocache

create sequence board_no_seq
nocache

create sequence model_number
nocache

create sequence product_number 
nocache

						  
					  
												  
												  
												  
												  
