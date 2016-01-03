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
			outerFn(); //"local" 출력

			
			//JavaScript의 모든 함수가 클로져라는 말은, 즉 자바스크립트의 모든 함수는 그 함수의 지역 변수가 아닌 것들을 위한 참조 환경을 함께 가진다는 의미이다.  			
			/* 전역 변수 상에서 z가 "global"로 정의 되어 있음에도 불구하고, "local"이 출력되는 이유는 클로져 innerFn(다시한번, JavaScript의 모든 함수는 클로져이다.)의 유효 범위 체인 상에서는 innerFn을 호출한 outerFn이 어휘적인(Lexical) 유효범위로서 포함되며, 전역 객체들(가령 전역 "global"값이 지정된 z 전역 변수) 보다 우선시 되기 때문이다. 만약 위의 코드에서 4번째 줄이 없었다면, 실행의 결과로 "global"이 출력 될 것이다. 

			클로져의 가장 핵심적인 개념은 어휘적인(Lexical) 유효 범위다. 함수가 실행될 때는 함수가 실행되는 위치가 아닌, 함수가 정의 될 당시의 유효범위에서 실행된다.

			어휘적인 유효 범위라는 것은 바로 아래의 예를 보면 알 수 있다. 중첩된 함수가 밖으로 꺼내어질(export) 때 어휘적인 유효 범위로 인한 가장 명확한 특성이 발생한다.
			
			*/
			function outerFn(outerText) {
			    var innerText = "first" + outerText ;
			    return function() {return innerText};
			}
			var execution = outerFn("second");
			var result = execution();
			
			/* function outerFn은 실행 되면, function() {return innerText}라는 함수를 리턴한다. 즉 위의 코드에서 execution이라는 변수에는 function() {return innerText}라는 함수가 할당 되는 것이다. 

			그렇다면 위의 코드를 실행하면 어떤 결과가 나타날까? 
			얼핏 생각했을 때, innerText라는 변수는 outerFn 함수 내에서만 존재하는 변수이다. 따라서 outerFn의 실행이 끝나고 7번 행에서 innerText를 return하는 함수를 실행 할 때에는 해당 변수가 존재하지 않을 것이다. 때문에 7번행에서 존재하지 않는 변수를 리턴하려 하면서 "undefined"예외가 발생 할 것 같다. 하지만 실제로는 "first second"라는 값이 result에 할당되며 코드의 실행이 끝난다.  */
			
			
			
 </script>
</head>
<body>

</body>
</html>