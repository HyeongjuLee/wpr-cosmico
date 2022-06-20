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


// 왼쪽 플로팅 변경

function chgCounsel(mode){

	createRequest();

	var url = '/ajax/chgCounsel.asp?mode='+mode;

	request.open("GET",url,true);
	request.onreadystatechange = ChgContent;    // 함수 뒤에 ()를 빼야합니다!!
	request.send(null);
 }

function ChgContent() {

	if(request.readyState == 4){    // 요청응답상태가 4인지 확인해주고
		if(request.status == 200){     // HTTP상태가 완료인지 체크해줍니다.

			var newContent = request.responseText;

			document.getElementById("chgCounsel").innerHTML = newContent;

    }

  }

}




function chgNewContent(pgs,pg,cc,hid,vm) {
	createRequest();

	var url = '/ajax/chgNewContent.asp?pgs='+pgs+'&pg='+pg+'&cc='+cc+'&nc='+hid+'&vm='+vm;

	request.open("GET",url,true);
	request.onreadystatechange = function ChgContent() {
		if(request.readyState == 4){    // 요청응답상태가 4인지 확인해주고
			if(request.status == 200){     // HTTP상태가 완료인지 체크해줍니다.
				var newContent = request.responseText;
				document.getElementById(hid).innerHTML = newContent;
		}
	  }
	}
	request.send(null);
}



function chkDomain(doms) {
	createRequest();

	var url = '/ajax/checkDomain.asp?domain='+doms;

	request.open("GET",url,true);
	request.onreadystatechange = function ChgContent() {
		if(request.readyState == 4){    // 요청응답상태가 4인지 확인해주고
			if(request.status == 200){     // HTTP상태가 완료인지 체크해줍니다.
				var newContent = request.responseText;
				document.getElementById("viewDomain").innerHTML = newContent;
		}
	  }
	}
	request.send(null);
}
function checkVoter(ids) {
	createRequest();

	var url = '/ajax/checkVoter.asp?ids='+ids;

	request.open("GET",url,true);
	request.onreadystatechange = function ChgContent() {
		if(request.readyState == 4){    // 요청응답상태가 4인지 확인해주고
			if(request.status == 200){     // HTTP상태가 완료인지 체크해줍니다.
				var newContent = request.responseText;
				document.getElementById("viewVoter").innerHTML = newContent;
		}
	  }
	}
	request.send(null);
}

function chgIndexBBS(bname) {
	createRequest();

	var url = '/ajax/chgIndexBBS.asp?bname='+bname;

	request.open("GET",url,true);
	request.onreadystatechange = function ChgContent() {
		if(request.readyState == 4){    // 요청응답상태가 4인지 확인해주고
			if(request.status == 200){     // HTTP상태가 완료인지 체크해줍니다.
				var newContent = request.responseText;
				document.getElementById("chgIndexContent").innerHTML = newContent;
		}
	  }
	}
	request.send(null);
}

function qnaPageGo(page,pidx) {
	createRequest();

	var url = '/ajax/chgQnaPage.asp?page='+page+'&goodsIDX='+pidx;

	request.open("GET",url,true);
	request.onreadystatechange = function ChgContent() {
		if(request.readyState == 4){    // 요청응답상태가 4인지 확인해주고
			if(request.status == 200){     // HTTP상태가 완료인지 체크해줍니다.
				var newContent = request.responseText;
				document.getElementById("detailQna").innerHTML = newContent;
		}
	  }
	}
	request.send(null);
}
function ReviewPageGo(page,pidx) {
	createRequest();

	var url = '/ajax/chgReviewPage.asp?page2='+page+'&goodsIDX='+pidx;

	request.open("GET",url,true);
	request.onreadystatechange = function ChgContent() {
		if(request.readyState == 4){    // 요청응답상태가 4인지 확인해주고
			if(request.status == 200){     // HTTP상태가 완료인지 체크해줍니다.
				var newContent = request.responseText;
				document.getElementById("detailReview").innerHTML = newContent;
		}
	  }
	}
	request.send(null);
}
function checkVoters(ids) {
	createRequest();

	var url = '/ajax/checkVoters.asp?ids='+ids;

	request.open("GET",url,true);
	request.onreadystatechange = function ChgContent() {
		if(request.readyState == 4){    // 요청응답상태가 4인지 확인해주고
			if(request.status == 200){     // HTTP상태가 완료인지 체크해줍니다.
				var newContent = request.responseText;
				document.getElementById("resultField").innerHTML = newContent;
		}
	  }
	}
	request.send(null);
}


function srNoticeAjax(page,srname) {
	createRequest();

	var url = '/showroom/inNotice.asp?page='+page+'&srname='+srname;

	request.open("GET",url,true);
	request.onreadystatechange = function ChgContent() {
		if(request.readyState == 4){    // 요청응답상태가 4인지 확인해주고
			if(request.status == 200){     // HTTP상태가 완료인지 체크해줍니다.
				var newContent = request.responseText;
				document.getElementById("srNotice").innerHTML = newContent;
		}
	  }
	}
	request.send(null);
}


function srTotalPg(page,pidx,ajax,tpl) {
	createRequest();

	var url = '/showroom/'+ajax+'.asp?page='+page+'&srname='+pidx;
	
	request.open("GET",url,true);
	request.onreadystatechange = function ChgContent() {
		if(request.readyState == 4){    // 요청응답상태가 4인지 확인해주고
			if(request.status == 200){     // HTTP상태가 완료인지 체크해줍니다.
				var newContent = request.responseText;
				document.getElementById(tpl).innerHTML = newContent;
		}
	  }
	}
	request.send(null);
}


function chgVisit(ids) {
	createRequest();

	var url = '/showroom/viewVisit.asp?ids='+ids;

	request.open("GET",url,true);
	request.onreadystatechange = function ChgContent() {
		if(request.readyState == 4){    // 요청응답상태가 4인지 확인해주고
			if(request.status == 200){     // HTTP상태가 완료인지 체크해줍니다.
				var newContent = request.responseText;
				document.getElementById("visitContent").innerHTML = newContent;
		}
	  }
	}
	request.send(null);
}

function closeVisit() {
	document.getElementById("visitContent").innerHTML = '<p class="tcenter userFullWidth" style="width:100%;padding:10px 0px;background-color:#eee;">이미지를 클릭해주세요.</p>';

}

//-->
