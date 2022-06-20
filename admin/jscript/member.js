

function bgChg(f,type) {

	if (type=='memo')
	{
		if (f.value =='')
		{
			f.style.backgroundImage = 'url(/images/admin/pop/input_bg.gif)';
			f.style.backgroundRepeat = 'no-repeat';
		}
		
	}
	

}
function bgDel(f) {
	f.style.backgroundImage = '';
}


function chkIn(f) {
	if (f.strMemo.value=='')
	{
		alert("메모의 내용이 비어있습니다.");
		f.strMemo.focus();
		return false;
	}

}

function copyTxt(value,Types) {				

	if (confirm("해당 회원의 "+Types+"는 "+value+"입니다. 복사하시겠습니까?")) {
		window.clipboardData.setData("Text",value);
	}

}


function openzip() {
	openPopup("/common/pop_Zipcode.asp", "Zipcodes", 100, 100, "left=200, top=200");
}


function submitChk() {
	var f = document.cfrm;
	var objItem;

	if (f.strName.value == "")
	{
		alert("이름을 입력해주세요");
		f.strName.focus();
		return false;
	}
	if (!checkkorText(f.strName.value,2)) {
		alert("정확한 한글 이름을 입력해 주세요.");
		f.strName.focus();
		return false;
	}
	if (!checkSCharNum(f.strName.value)) {
		alert("특수문자나 숫자는 입력할 수 없습니다.");
		f.strName.value="";
		f.strName.focus();
		return false;
	}


	if (f.strPass.value == "")
	{
		alert("비밀번호는 필수값입니다.");
		f.strPass.focus();
		return false;
	}
	/*
	if (f.tel_num1.value !== 'no')
	{

		for (i=1; i<=3; i++) {
			objItem = eval("f.tel_num"+i);
			if (chkEmpty(objItem)) {
				alert("전화번호를 입력해 주세요.");
				objItem.focus();
				return false;
			}
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
	*/
	/*
	if (f.mob_num1.value !== 'no')	{
		for (i=1; i<=3; i++) {
			objItem = eval("f.mob_num"+i);
			if (chkEmpty(objItem)) {
				alert("휴대전화를 입력해 주세요.");
				objItem.focus();
				return false;
			}
		}
	}
	*/
	/*
	if (chkEmpty(f.strMobile)) {
		alert("휴대전화를 입력해 주세요.");
		f.strMobile.focus();
		return false;
	}

	if (f.strMobile.value.length < 11) {
		alert("정확한 휴대전화를 입력해 주세요.");
		f.strMobile.focus();
		return false;
	}
	*/

	/*
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
	/*
	if (!checkEmail(f.strEmail.value)) {
		alert("형식에 맞지 않는 이메일 주소입니다.\n\n이메일 주소를 정확하게 입력해 주세요.");
		f.strEmail.focus();
		return false;
	}
	*/
	if (chkEmpty(f.birthYY) || chkEmpty(f.birthMM) || chkEmpty(f.birthDD)) {
		alert("생년월일을 입력해 주세요.");
		f.birthYY.focus();
		return false;
	}

	if (f.isSolar[0].checked == false && f.isSolar[1].checked == false ) {
		alert("양력/음력을 선택해 주세요");
		f.isSolar[0].focus();
		return false;
	}



	if (confirm("정보를 수정 하시겠습니까?")) {
		f.target = "_self";
		f.action = "member_infoHandler.asp";
		f.submit();
	}
}
function submitChkA() {
	var f = document.cfrm;
	var objItem;

	if (chkEmpty(f.strUserID)) {
		alert("아이디를 입력해 주세요.");
		f.strUserID.focus();
		return false;
	}
	if (confirm("해당회원을 로그인금지 회원으로 변경 하시겠습니까?")) {
		f.target = "_self";
		f.mode.value = "ADMIN_LEAVE";
		f.action = "memberHandler.asp";
		f.submit();
	}
}
function submitChkL() {
	var f = document.cfrm;
	var objItem;

	if (chkEmpty(f.strUserID)) {
		alert("아이디를 입력해 주세요.");
		f.strUserID.focus();
		return false;
	}
	if (confirm("회원탈퇴를 승인하시고 탈퇴 회원으로 변경 하시겠습니까?")) {
		f.target = "_self";
		f.mode.value = "leaveok";
		f.action = "memberHandler.asp";
		f.submit();
	}
}

function submitChkB() {
	var f = document.cfrm;
	var objItem;

	if (chkEmpty(f.strUserID)) {
		alert("아이디를 입력해 주세요.");
		f.strUserID.focus();
		return false;
	}
	if (confirm("회원탈퇴를 철회하고 일반회원으로 전환하시겠습니까?")) {
		f.target = "_self";
		f.mode.value = "leaveCancel";
		f.action = "memberHandler.asp";
		f.submit();
	}
}


function submitChkD() {
	var f = document.cfrm;
	var objItem;

	if (chkEmpty(f.strUserID)) {
		alert("아이디를 입력해 주세요.");
		f.strUserID.focus();
		return false;
	}
	if (confirm("회원의 모든 정보(회원정보,로그,게시물등)를 삭제하시겠습니까?\n삭제후에는 복구할 수 없습니다.")) {
		f.target = "_self";
		f.action = "memberHandler.asp";
		f.submit();
	}
}

function chkPoint() {
	var f = document.frmS;
	if (f.types.value=="") {
		alert("포인트 추가/차감 종류를 선택해주세요");
		f.types.focus();
		return false;
	}
	if (chkEmpty(f.intPoint)) {
		alert("포인트 추가/차감 액수를 기입해주세요.");
		f.intPoint.focus();
		return false;
	}
}

function goMemberInfo(mid) {
	var f = document.frm;

	f.mid.value = mid;
	f.action = 'member_info.asp';
	f.submit();

}
