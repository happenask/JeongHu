<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>

<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>Insert title here</title>
<script>
		var array = ['사과','바나나','딸기'];
		
		var product = {
			 제품명: '7D 건조망고',
			 유형 : '당절임',
			 원산지: '필리핀'
				
		};
		alert(product.제품명);
		alert(product.원산지);
		
		var object = {
			'with space':273	
		};
		
		//문자열을 식별자로 사용할 때는 반드시 대괄호 로 호출해야한다. 그 차이를 확인해 보자
		
		alert(object['with space']);
		
		
		//객체와 반복문
		
		
		var output = '';
		for(var key in product){
			output +=key+':'+product[key]+'\n';
		}
		alert(output);
		
		// in 키워드와 with 키워드
		alert('제품명' in product); //있을면 true, 없으면 false
		
		with(product){
			alert('제품명'); // => alert(product.제품명) 과 같다.
			
		}
		
		// 빈객체 생성후 속성 추가 and  제거
		
		var student = {};
		
		student.이름 = '안정후';
		student.취미 = '악기';
		
		// toString() 메서드를 만듭니다.
		student.toString = function(){
			
			var output = '';
			
			output  = '안정후 는 한국에서 제일 멋있는 사람입니다.';
			
			return output;
		}
		
		alert(student) // student.toString() 을 호출 합니다.
		
		
		// 배열에 객체 넣기
		
		var students =[];
		
		students.push({이름:'안정후',나이:'32'});
		students.push({이름:'이찬희',나이:'32'});
		students.push({이름:'김오균',나이:'32'});
		students.push({이름:'김진혁',나이:'32'});
		
		// 객체를 생성하는 함수
		
		function makeStudent(name,korean,math,english){
			var willReturn = {
				이름:name,	
				국어:korean,
				수학:math,
				영어:english,
				
				getSum: function(){
					return this.국어+this.수학+this.영어;
				},
				getAverage: function(){
					return this.getSum/4;
				},
				toString: function(){
					return this.이름+'\t'+this.getSum()+'\t'+this.getAverage();
				}
			};
			
			
			return willReturn;
		}
		
		//생성자 함수를 이용해서 객체 만들기 생성자 함수는 new 키워드를 사용해 객체를 생성할 수 있는 함수
		function Student(name,korean,math,english){ //생성자 함수는 일반적으로 대문자로 시작한다.
			this.이름=name;	
			this.국어=korean;
			this.수학=math;
			this.영어=english;
				
				this.getSum=function(){
					return this.국어+this.수학+this.영어;
				};
				this.getAverage= function(){
					return this.getSum/4;
				};
				this.toString= function(){
					return this.이름+'\t'+this.getSum()+'\t'+this.getAverage();
				};
		}
		
		var student = new Student('안정후',96,98,92);
		
		//프로토타입 (도대체 생성자 함수를 사용하면 무엇이 좋을까??)
		//생성자 함수를 사용해 생성된 객체가 공통으로 가지는 공간 불필요한 메모리 낭비를 방지하기 위해서..
			function Student(name,korean,math,english){ //생성자 함수는 일반적으로 대문자로 시작한다.
				this.이름=name;	
				this.국어=korean;
				this.수학=math;
				this.영어=english;
				
				
		}
		
			Student.prototype.getSum = function(){};
			Student.prototype.getAverage = function(){};
			
			//캡슐화
			
			function Rectangle(w, h) {

			    var width = w; //캡슐화  외부에서 사용금지
			    var height = h; //캡슐화 외부에서 사용금지
			
			
			    this.getWidth = function () {
			        return width;
			    };
			    this.getHeight = function () {
			        return height;
			    };
			
			    this.setWidth = function (value) {
			        if (value < 0) {
			            throw '음수를 입력 할 수 없습니다.';
			        } else {
			            width = value;
			        }
			
			    };
			
			    this.setHeight = function (value) {
			        if (value < 0) {
			            throw '음수를 입력 할 수 없습니다.';
			        } else {
			            height = value;
			        }
			
			    };
			
			
			}
			
			Rectangle.prototype.getArea = function () {
			    return this.getWidth() * this.getHeight();
			};
			
			var rectangle = new Rectangle(10, 10);
			
			rectangle.setWidth(2);
			
			//출력합니다.
			alert('AREA' + rectangle.getArea());
			
			function Square(length){
			     this.base = Rectangle;
			    this.base(length,length);
			}
			
			Square.prototype = Rectangle.prototype;
			var rectangle2 = new Rectangle(10,10);
			var square     = new Square(5);
			//출력합니다.
			
			alert(rectangle2.getArea()+':'+square.getArea());
							
		
</script>
</head>
<body>

</body>
</html>