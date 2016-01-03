## 다운로드 사이트 : http://www.zipfinder.co.kr/

drop table zipcode;
CREATE TABLE zipcode(
    zipcode varchar(7) not null,
    sido    varchar(12) not null,
    gugun   varchar(51) not null,
    dong    varchar(156)  default '',
    bunji   varchar(51) default '',
    seq     varchar(5) not null,
    constraint zipcode_pk primary key (seq)
)
--참고 사이트 : http://www.zipfinder.co.kr/zipcode/index.html
--zipcode : 우편번호
--sido : 특별시, 광역시, 도
--gugun : 시, 군, 구
--dong : 읍, 면, 동, 리 , 건물명
--bunji : 번지, 아파트동, 호수
--seq : 데이터 순서
;
sido+' '+gugun+' '+dong
select * from zipcode
ex)select zipcode, sido||' '||gugun||' '||dong from zipcode where dong like '%천호%'
