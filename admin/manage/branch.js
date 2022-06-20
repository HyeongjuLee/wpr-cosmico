function chkDirectBranchFrm(idx) {
	var f = document.directBranchFrm;

	var msg = "위의 내용으로 답변을 저장하시겠습니까?";

	if(confirm(msg)){
		f.intIDX.value = idx;
		f.submit();
	}

}

function chkBranchForm(f) {



	if (chkEmpty(f.mode)) {
		alert("필수값중 모드가 비어있습니다.");
		return false;
	}


	if (f.mode.value == 'MODIFY')
	{
		if (chkEmpty(f.intIDX)) {
			alert("필수값중 고유번호가 비어있습니다.");
			return false;
		}
	}
	if (f.isUse[0].checked == false && f.isUse[1].checked == false)
	{
		alert("지사 표시를 선택하셔야합니다.")
		f.isUse[0].focus();
		return false;
	}

	if (chkEmpty(f.cate1)) {
		alert("지사 위치 1 을 선택해주세요");
		f.cate1.focus();
		return false;
	}
	if (chkEmpty(f.cate2)) {
		alert("지사 위치 2 을 선택해주세요");
		f.cate2.focus();
		return false;
	}




	if (chkEmpty(f.strBranchName)) {
		alert("지사명을 입력하세요");
		f.strBranchName.focus();
		return false;
	}
	if (chkEmpty(f.strBranchOwner)) {
		alert("지사대표자명을 입력하세요..");
		f.strBranchOwner.focus();
		return false;
	}




	for (i=1; i<=2; i++) {
		objItem = eval("f.strBranchTel"+i);
		if (chkEmpty(objItem)) {
			alert("지사연락처를 입력해주세요..");
			objItem.focus();
			return false;
		}
	}

	/*
	for (i=1; i<=3; i++) {
		objItem = eval("f.strBranchFax"+i);
		if (chkEmpty(objItem)) {
			alert("지사 팩스번호를 입력해 주세요.");
			objItem.focus();
			return false;
		}
	}
	*/

	if (chkEmpty(f.strzip)) {
		alert("우편번호를 입력해주세요");
		openzip();
		return false;
	}
	if (chkEmpty(f.straddr1)) {
		alert("주소를 입력해주세요");
		openzip();
		return false;
	}
	if (chkEmpty(f.straddr2)) {
		alert("상세주소를 입력해주세요");
		f.straddr2.focus();
		return false;
	}
	/*
	if (chkEmpty(f.strBranchMapCode)) {
		alert("지도주소를 입력해주세요");
		f.strBranchMapCode.focus();
		return false;
	}
	*/


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



	function branchTempDel(idn) {
		var f = document.branchDFrm;

		var msg = "정말 삭제하시겠습니까? 삭제 후에 복구할 수 없습니다.";

		if(confirm(msg)){
			f.intIDX.value = idn;
			f.submit();
		}




	}


function openzip() {
	openPopup("/common/pop_Zipcode.asp", "Zipcodes", 100, 100, "left=200, top=200");
}




