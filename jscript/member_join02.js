<!--




function nameChk(f) {
	if (chkEmpty(f.name)) {
		alert("이름을 입력해 주세요.");
		f.name.focus();
		return false;
	}

	var objItem;
	for (var i=1; i<=2; i++) {
		objItem = eval('f.ssh'+i);
		if (chkEmpty(objItem)) {
			alert("주민등록번호를 입력해 주세요.");
			objItem.focus();
			return false;
		}
	}

	if (!checkSSH(f.ssh1, f.ssh2)) return false;

	f.target = "hidden";
	f.action = "joincheck.asp";

}


function allCheckAgree() {


}


function checkAgree() {
	var f = document.jfrm;
	var g = document.nfrm;


	if (f.agree01.checked == false)
	{
		alert("사이트 이용약관에 동의하셔야합니다.");
		f.agree01.focus();
		return false;
	}
/*
	if (f.agree02.checked == false)
	{
		alert("전자금융거래 이용약관에 동의하셔야합니다.");
		f.agree02.focus();
		return false;
	}
*/
	if (f.agree03.checked == false)
	{
		alert("개인정보보호정책에 동의하셔야합니다.");
		f.agree03.focus();
		return false;
	}


	if (chkEmpty(g.name)) {
		alert("이름을 입력해 주세요.");
		g.name.focus();
		return false;
	}

	var objItem;
	for (var i=1; i<=2; i++) {
		objItem = eval('g.ssh'+i);
		if (chkEmpty(objItem)) {
			alert("주민등록번호를 입력해 주세요.");
			objItem.focus();
			return false;
		}
	}

	if (!checkSSH(g.ssh1, g.ssh2)) return false;

	

	
	if (chkEmpty(f.name)) {
		alert("가입확인을 해주세요.");
		g.name.focus();
		return false;
	}

	var objItem;
	for (var i=1; i<=2; i++) {
		objItem = eval('f.ssh'+i);
		if (chkEmpty(objItem)) {
			alert("가입확인을 해주세요.");
			g.ssh1.focus();
			return false;
		}
	}
	
	
	if (!checkSSH(f.ssh1, f.ssh2)) return false;


	if (f.name.value != g.name.value)
	{
			alert("가입확인한 이름과 현재 기입된 이름이 틀립니다.");
			g.name.focus();
			return false;
	}
	if (f.ssh1.value != g.ssh1.value && f.ssh2.value != g.ssh2.value)
	{
			alert("가입확인한 주민번호가 변경되었습니다. 가입확인을 다시 해주세요.");
			g.ssh1.value='';
			g.ssh2.value='';
			g.ssh1.focus();
			return false;
	}
	f.submit();

}


//-->
