<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>

<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>Insert title here</title>
<script>
		var array = ['���','�ٳ���','����'];
		
		var product = {
			 ��ǰ��: '7D ��������',
			 ���� : '������',
			 ������: '�ʸ���'
				
		};
		alert(product.��ǰ��);
		alert(product.������);
		
		var object = {
			'with space':273	
		};
		
		//���ڿ��� �ĺ��ڷ� ����� ���� �ݵ�� ���ȣ �� ȣ���ؾ��Ѵ�. �� ���̸� Ȯ���� ����
		
		alert(object['with space']);
		
		
		//��ü�� �ݺ���
		
		
		var output = '';
		for(var key in product){
			output +=key+':'+product[key]+'\n';
		}
		alert(output);
		
		// in Ű����� with Ű����
		alert('��ǰ��' in product); //������ true, ������ false
		
		with(product){
			alert('��ǰ��'); // => alert(product.��ǰ��) �� ����.
			
		}
		
		// ��ü ������ �Ӽ� �߰� and  ����
		
		var student = {};
		
		student.�̸� = '������';
		student.��� = '�Ǳ�';
		
		// toString() �޼��带 ����ϴ�.
		student.toString = function(){
			
			var output = '';
			
			output  = '������ �� �ѱ����� ���� ���ִ� ����Դϴ�.';
			
			return output;
		}
		
		alert(student) // student.toString() �� ȣ�� �մϴ�.
		
		
		// �迭�� ��ü �ֱ�
		
		var students =[];
		
		students.push({�̸�:'������',����:'32'});
		students.push({�̸�:'������',����:'32'});
		students.push({�̸�:'�����',����:'32'});
		students.push({�̸�:'������',����:'32'});
		
		// ��ü�� �����ϴ� �Լ�
		
		function makeStudent(name,korean,math,english){
			var willReturn = {
				�̸�:name,	
				����:korean,
				����:math,
				����:english,
				
				getSum: function(){
					return this.����+this.����+this.����;
				},
				getAverage: function(){
					return this.getSum/4;
				},
				toString: function(){
					return this.�̸�+'\t'+this.getSum()+'\t'+this.getAverage();
				}
			};
			
			
			return willReturn;
		}
		
		//������ �Լ��� �̿��ؼ� ��ü ����� ������ �Լ��� new Ű���带 ����� ��ü�� ������ �� �ִ� �Լ�
		function Student(name,korean,math,english){ //������ �Լ��� �Ϲ������� �빮�ڷ� �����Ѵ�.
			this.�̸�=name;	
			this.����=korean;
			this.����=math;
			this.����=english;
				
				this.getSum=function(){
					return this.����+this.����+this.����;
				};
				this.getAverage= function(){
					return this.getSum/4;
				};
				this.toString= function(){
					return this.�̸�+'\t'+this.getSum()+'\t'+this.getAverage();
				};
		}
		
		var student = new Student('������',96,98,92);
		
		//������Ÿ�� (����ü ������ �Լ��� ����ϸ� ������ ������??)
		//������ �Լ��� ����� ������ ��ü�� �������� ������ ���� ���ʿ��� �޸� ���� �����ϱ� ���ؼ�..
			function Student(name,korean,math,english){ //������ �Լ��� �Ϲ������� �빮�ڷ� �����Ѵ�.
				this.�̸�=name;	
				this.����=korean;
				this.����=math;
				this.����=english;
				
				
		}
		
			Student.prototype.getSum = function(){};
			Student.prototype.getAverage = function(){};
			
			//ĸ��ȭ
			
			function Rectangle(w, h) {

			    var width = w; //ĸ��ȭ  �ܺο��� ������
			    var height = h; //ĸ��ȭ �ܺο��� ������
			
			
			    this.getWidth = function () {
			        return width;
			    };
			    this.getHeight = function () {
			        return height;
			    };
			
			    this.setWidth = function (value) {
			        if (value < 0) {
			            throw '������ �Է� �� �� �����ϴ�.';
			        } else {
			            width = value;
			        }
			
			    };
			
			    this.setHeight = function (value) {
			        if (value < 0) {
			            throw '������ �Է� �� �� �����ϴ�.';
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
			
			//����մϴ�.
			alert('AREA' + rectangle.getArea());
			
			function Square(length){
			     this.base = Rectangle;
			    this.base(length,length);
			}
			
			Square.prototype = Rectangle.prototype;
			var rectangle2 = new Rectangle(10,10);
			var square     = new Square(5);
			//����մϴ�.
			
			alert(rectangle2.getArea()+':'+square.getArea());
							
		
</script>
</head>
<body>

</body>
</html>