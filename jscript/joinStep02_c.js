<!--

function nameChk(f) {
	if (chkEmpty(f.name)) {
		alert("이름을 입력해 주세요.");
		f.name.focus();
		return false;
	}
	if( /[\s]/g.test( f.name.value) == true){
		alert('공백은 사용할 수 없습니다. ')
		f.name.value=f.name.value.replace(/(\s*)/g,'');
		return false;
	}
//	if (f.name.value.stripspace().length < 2) {
//		alert("정확한 이름을 입력해 주세요.");
//		f.name.focus();
//		return false;
//	}

	if (!checkkorText(f.name.value,2)) {
		alert("정확한 한글 이름을 입력해 주세요.");
		f.name.focus();
		return false;
	}
	if (!checkSCharNum(f.name.value)) {
		alert("특수문자나 숫자는 입력할 수 없습니다.");
		f.name.value="";
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
	f.action = "joincheck_c.asp";

}


function allCheckAgree() {
	if (document.getElementById("allAgree").checked == true)
	{
		document.getElementById("agree01Chk").checked = true;
		document.getElementById("agree02Chk").checked = true;
		document.getElementById("agree03Chk").checked = true;
//		document.getElementById("agree04Chk").checked = true;
	} else if (document.getElementById("allAgree").checked == false)	{
		document.getElementById("agree01Chk").checked = false;
		document.getElementById("agree02Chk").checked = false;
		document.getElementById("agree03Chk").checked = false;
//		document.getElementById("agree04Chk").checked = false;
	}
}


function checkAgree() {
	var f = document.agreeFrm;
	var g = document.nfrm;


		if (f.agreement.checked == false)
		{
			alert("이용약관에 동의하셔야합니다.");
			f.agreement.focus();
			return false;
		}
		if (f.company.checked == false)
		{
			alert("사업자회원 가입약관에 동의하셔야합니다.");
			f.company.focus();
			return false;
		}
		if (f.gather.checked == false)
		{
			alert("개인정보 수집 및 이용에 동의하셔야합니다.");
			f.gather.focus();
			return false;
		}


	if (chkEmpty(g.name)) {
		alert("이름을 입력해 주세요..");
		g.name.focus();
		return false;
	}
	if (!checkkorText(g.name.value,2)) {
		alert("정확한 한글 이름을 입력해 주세요");
		g.name.focus();
		return false;
	}
	if( /[\s]/g.test( g.name.value) == true){
		alert('공백은 사용할 수 없습니다. ')
		g.name.value=g.name.value.replace(/(\s*)/g,'');
		return false;
	}
	if (!checkSCharNum(g.name.value)) {
		alert("특수문자나 숫자는 입력할 수 없습니다..");
		g.name.value="";
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
