function chkDirectBranchFrm(idx) {
	var f = document.directBranchFrm;

	var msg = "위의 내용으로 답변을 저장하시겠습니까?";
	
	if(confirm(msg)){
		f.intIDX.value = idx;
		f.submit();
	}

}

function chkBranchForm(f) {

	if (chkEmpty(f.ShowroomName)) {
		alert("쇼룸아이디를 입력해주세요.");
		f.ShowroomName.focus();
		return false;
	}
	if (chkEmpty(f.ShowroomTitle)) {
		alert("쇼룸명을 입력해주세요.");
		f.ShowroomTitle.focus();
		return false;
	}
	if (f.Domaincheck.value != 'T') {
		alert("쇼룸명 중복체크를 해주세요.");
		f.ShowroomName.focus();
		return false;
	}
	if (f.ShowroomName.value != f.TempDomain.value) {
		alert("중복체크한 쇼룸명과 현재 쇼룸명이 틀립니다.");
		f.ShowroomName.focus();
		return false;
	}
	if (chkEmpty(f.MapImg)) {
		alert("다음지도의 SRC 영역을 입력해주세요.");
		f.MapImg.focus();
		return false;
	}
	if (chkEmpty(f.ContactCar)) {
		alert("우편번호를 입력해주세요");
		f.ContactCar.focus();
		return false;
	}
	if (chkEmpty(f.ContactBus)) {
		alert("은행명을 입력해주세요");
		f.ContactBus.focus();
		return false;
	}
	if (chkEmpty(f.WriteID)) {
		alert("해당 쇼룸의 작성가능 아이디를 입력해주세요.");
		f.WriteID.focus();
		return false;
	}

	if (chkEmpty(f.DeleteID)) {
		alert("해당 쇼룸의 삭제가능 아이디를 입력해주세요.");
		f.DeleteID.focus();
		return false;
	}
	if (chkEmpty(f.ReplyID)) {
		alert("해당 쇼룸의 답변가능 아이디를 입력해주세요.");
		f.ReplyID.focus();
		return false;
	}
}


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




	function join_idcheck() {
		var f = document.pfrm;

		if (chkEmpty(f.ShowroomName)) {
			alert("도메인를 입력해 주세요.");
			f.ShowroomName.focus();
			return;
		}

		if (!checkID(f.ShowroomName.value.trim(), 3, 20)){
			alert("도메인은 영문 혹은 숫자 3자~20자리로 해주세요.");
			f.ShowroomName.focus();
			return;
		}

		chkDomain(f.ShowroomName.value);
	}
	function chkDomain(doms) {
		createRequest();

		var url = '/ajax/checkShowroom.asp?domain='+doms;

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

