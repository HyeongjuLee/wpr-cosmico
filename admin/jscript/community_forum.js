
function join_idcheck() {
	var f = document.cfrm;

	if (chkEmpty(f.strBoardName)) {
		alert("아이디를 입력해 주세요.");
		f.strBoardName.focus();
		return;
	}

	if (!checkID(f.strBoardName.value.trim(), 3, 20)){
		alert("아이디는 영문 혹은 숫자 4자~20자리로 해주세요.");
		f.strBoardName.focus();
		return;
	}

	openPopup("/hiddens.asp", "asidcheck", 300, 200, "left=350, top=350");

	f.target = "asidcheck";
	f.action = "/common/pop_boardNameCheck.asp";
	f.submit();
}




function submitChk() {
	var f = document.cfrm;
	var objItem;

	if (chkEmpty(f.strBoardName)) {
		alert("아이디를 입력해 주세요.");
		f.strBoardName.focus();
		return false;
	}

	if (!checkID(f.strBoardName.value, 3, 12)){
		alert("아이디는 영문 혹은 숫자 4자~12자리로 해주세요.");
		f.strBoardName.focus();
		return false;
	}

	if (f.idcheck.value != f.strBoardName.value){
		alert("아이디 중복확인을 해주세요.");
		f.strBoardName.focus();
		return false;
	}

	if (chkEmpty(f.strBoardTitle)) {
		alert("게시판 이름을를 입력해 주세요.");
		f.strBoardTitle.focus();
		return false;
	}


	if (chkEmpty(f.strCateCode)) {
		alert("출력하실 메뉴를 선택해 주세요.");
		f.strCateCode.focus();
		return false;
	}







	if (confirm("등록 하시겠습니까? \n\n 등록 후 게시판 설정을 해주세요")) {
		f.target = "_self";
		f.action = "forumHandler.asp";
		f.submit();
	}
}


function submitChkConfig() {
	var f = document.cfrm;
	var objItem;


	if (chkEmpty(f.strBoardTitle)) {
		alert("게시판 이름을를 입력해 주세요.");
		f.strBoardTitle.focus();
		return false;
	}


	if (chkEmpty(f.strCateCode)) {
		alert("출력하실 메뉴를 선택해 주세요.");
		f.strCateCode.focus();
		return false;
	}



		f.target = "_self";
		f.action = "forumHandler.asp";
		f.submit();
}


function submitChkLevel() {

	var f = document.cfrm;

		f.target = "_self";
		f.action = "forumHandler.asp";
		f.submit();
}

function submitChkPoint() {
	var f = document.cfrm;


	
	f.target = "_self";
	f.action = "forumHandler.asp";
	f.submit();

}
