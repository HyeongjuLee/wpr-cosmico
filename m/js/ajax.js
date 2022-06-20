<!--
	var request = null;         // request란 아이는 요청객체를 담을 변수입니다.
	function createRequest(){
		try{

			//XMLHttpRequest는 마이크로소프트의 브라우저를 제외한 모든 브라우져에서 작동합니다.
			request = new XMLHttpRequest();     //XMLHttpRequest란 타입으로 요청객체를 가져올꺼예염
		} catch(trymicrosoft){                      // 근데만약 이 자식이 팅긴다면?!
		try{

	//ActiveXObject는 마이크로소프트의 브라우져에서 지원하는 타입이죠.

	//단! 맥 IE 5 버젼에서 아직 안됩니다.

	//Msxml2.XMLHTTP를 대부분의 I.E에서 지원하지만 몇몇은 지원하지 않아요.
	request = new ActiveXObject("Msxml2.XMLHTTP");       // 다시 가져와야죠
	} catch(othermicrosoft){
	try{

	//몇몇 지원하지 않는 브라우져를 위한 부분입니다.
	request = new ActiveXObject("Microsoft.XMLHTTP");
	} catch(failed){

	// 이렇게 했는데도 계속 팅긴다면 null이겠죠.
	request = null;
	}
	}
	}
	//request가 계속 팅김을 한다면 이렇게 나와주면 되요.
	if(request == null) alert("계속 팅기네! request 객체 오류");

	}
 //>