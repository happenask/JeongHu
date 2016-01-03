<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>Insert title here</title>
<script type="text/javascript">

function init() {
	  var name = "Mozilla";
	  function displayName() {
	    alert(name);
	  }
	  displayName();
	}
	init();
	
	
	
	function makeFunc() {
		  var name = "Mozilla";
		  function displayName() {
		    alert(name);
		  }
		  return displayName;
		}

		var myFunc = makeFunc();
		myFunc();
		
		
		
		function makeAdder(x) {
			  return function(y) {
			    return x + y;
			  };
			}

			var add5 = makeAdder(5);
			var add10 = makeAdder(10);

			print(add5(2));  // 7
			
			document.write(add10(2)); // 12
			
			
			
			var z = "global";
			function outerFn() {
			    var z = "local";
			    function innerFn()
			    {
			            alert(z);
			    }
			    innerFn();
			}
			outerFn(); //"local" ���

			
			//JavaScript�� ��� �Լ��� Ŭ������� ����, �� �ڹٽ�ũ��Ʈ�� ��� �Լ��� �� �Լ��� ���� ������ �ƴ� �͵��� ���� ���� ȯ���� �Բ� �����ٴ� �ǹ��̴�.  			
			/* ���� ���� �󿡼� z�� "global"�� ���� �Ǿ� �������� �ұ��ϰ�, "local"�� ��µǴ� ������ Ŭ���� innerFn(�ٽ��ѹ�, JavaScript�� ��� �Լ��� Ŭ�����̴�.)�� ��ȿ ���� ü�� �󿡼��� innerFn�� ȣ���� outerFn�� ��������(Lexical) ��ȿ�����μ� ���ԵǸ�, ���� ��ü��(���� ���� "global"���� ������ z ���� ����) ���� �켱�� �Ǳ� �����̴�. ���� ���� �ڵ忡�� 4��° ���� �����ٸ�, ������ ����� "global"�� ��� �� ���̴�. 

			Ŭ������ ���� �ٽ����� ������ ��������(Lexical) ��ȿ ������. �Լ��� ����� ���� �Լ��� ����Ǵ� ��ġ�� �ƴ�, �Լ��� ���� �� ����� ��ȿ�������� ����ȴ�.

			�������� ��ȿ ������� ���� �ٷ� �Ʒ��� ���� ���� �� �� �ִ�. ��ø�� �Լ��� ������ ��������(export) �� �������� ��ȿ ������ ���� ���� ��Ȯ�� Ư���� �߻��Ѵ�.
			
			*/
			function outerFn(outerText) {
			    var innerText = "first" + outerText ;
			    return function() {return innerText};
			}
			var execution = outerFn("second");
			var result = execution();
			
			/* function outerFn�� ���� �Ǹ�, function() {return innerText}��� �Լ��� �����Ѵ�. �� ���� �ڵ忡�� execution�̶�� �������� function() {return innerText}��� �Լ��� �Ҵ� �Ǵ� ���̴�. 

			�׷��ٸ� ���� �ڵ带 �����ϸ� � ����� ��Ÿ����? 
			���� �������� ��, innerText��� ������ outerFn �Լ� �������� �����ϴ� �����̴�. ���� outerFn�� ������ ������ 7�� �࿡�� innerText�� return�ϴ� �Լ��� ���� �� ������ �ش� ������ �������� ���� ���̴�. ������ 7���࿡�� �������� �ʴ� ������ �����Ϸ� �ϸ鼭 "undefined"���ܰ� �߻� �� �� ����. ������ �����δ� "first second"��� ���� result�� �Ҵ�Ǹ� �ڵ��� ������ ������.  */
			
			
			
 </script>
</head>
<body>

</body>
</html>