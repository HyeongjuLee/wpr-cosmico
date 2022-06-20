<!--
function checkChgPass(item) {
	var f = document.cfrm;
	var objBody = document.getElementById("bodyPass");

	if (item.checked) {
		objBody.style.display = "";
	} else {
		f.newPass.value = "";
		f.newPass2.value = "";
		objBody.style.display = "none";
	}
}
function openzip() {
	openPopup("/common/pop_Zipcode.asp", "Zipcodes", 100, 100, "left=200, top=200");
}



function submitChk() {
	var f = document.cfrm;
	var objItem;

	if (chkEmpty(f.strPass)) {
		alert("비밀번호를 입력해 주세요.");
		f.strPass.focus();
		return false;
	}

	if (f.isChgPass.checked) {

		if (chkEmpty(f.newPass)) {
			alert("변경하실 비밀번호를 입력해 주세요.");
			f.newPass.focus();
			return false;
		}
		if (!checkPass(f.newPass.value, 4, 20) || !checkEngNum(f.newPass.value)){
			alert("비밀번호는 영문, 숫자 혼합 4자~15자로 해주세요.");
			f.newPass.focus();
			return false;
		}
		if (chkEmpty(f.newPass2)) {
			alert("변경하실 비밀번호 확인을 입력해 주세요.");
			f.newPass2.focus();
			return false;
		}
		if (f.newPass.value != f.newPass2.value) {
			alert("변경하실 비밀번호가 서로 틀립니다.");
			f.newPass.focus();
			return false;
		}
	}

	if (chkEmpty(f.strzip) || chkEmpty(f.straddr1)) {
		alert("우편번호/주소를 입력해 주세요.");
		f.strzip.focus();
		return false;
	}

	if (chkEmpty(f.straddr2)) {
		alert("상세주소를 입력해 주세요.");
		f.straddr2.focus();
		return false;
	}
/*	
	for (i=1; i<=3; i++) {
		objItem = eval("f.tel_num"+i);
		if (chkEmpty(objItem)) {
			alert("전화번호를 입력해 주세요.");
			objItem.focus();
			return false;
		}
	}
*/	
	for (i=1; i<=3; i++) {
		objItem = eval("f.mob_num"+i);
		if (chkEmpty(objItem)) {
			alert("휴대전화를 입력해 주세요.");
			objItem.focus();
			return false;
		}
	}

/*
	if (!checkEmail(f.strEmail.value)) {
		alert("형식에 맞지 않는 이메일 주소입니다.\n\n이메일 주소를 정확하게 입력해 주세요.");
		f.strEmail.focus();
		return false;
	}

	if (chkEmpty(f.birthYY) || chkEmpty(f.birthMM) || chkEmpty(f.birthDD)) {
		alert("생년월일을 입력해 주세요.");
		f.birthYY.focus();
		return false;
	}



	if (chkEmpty(f.mailh)) {
		alert("메일주소의 아이디를 입력해 주세요.");
		f.mailh.focus();
		return false;
	}
	if (chkEmpty(f.mailt)) {
		alert("메일주소를 선택 혹은 직접 입력해 주세요.");
		f.mailt.focus();
		return false;
	}

*/



	if (confirm("회원정보를 수정 하시겠습니까?")) {
		f.target = "_self";
		f.action = "member_infoOk.asp";
		f.submit();
	}
}












//-->
