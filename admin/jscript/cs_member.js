

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

	if (f.mbid.value == "" || f.mbid2.value == "")
	{
		alert("CS회원번호는 필수값입니다.");
		return false;
	}
/*
	if (f.strPass.value == "")
	{
		alert("비밀번호는 필수값입니다.");
		f.strPass.focus();
		return false;
	}
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
*/
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


	if (confirm("정보를 수정 하시겠습니까?")) {
		f.target = "_self";
		f.action = "cs_member_infoHandler.asp";
		f.submit();
	}
}






function goMemberInfo(mid,mid2) {
	var f = document.frm;
	f.mid.value = mid;
	f.mid2.value = mid2;
	f.action = 'cs_member_info.asp';
	f.submit();

}
