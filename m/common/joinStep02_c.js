<!--
//이름, 생년월일 중복체크

function nameChk2(f) {	
	if (f.M_Name_Last.value == '')
	{
		alert("성을 입력해주세요.");
		f.M_Name_Last.focus();
		return false;
	}
	if( /[\s]/g.test( f.M_Name_Last.value) == true){
		alert('공백은 사용할 수 없습니다. ')
		f.M_Name_Last.value=f.M_Name_Last.value.replace(/(\s*)/g,'');
		return false;
	}
	if (!checkkorText(f.M_Name_Last.value,1)) {
		alert("정확한 (성)을 입력해 주세요.");
		f.M_Name_Last.focus();
		return false;
	}
	if (!checkSCharNum(f.M_Name_Last.value)) {
		alert("특수문자나 숫자는 입력할 수 없습니다.");
		f.M_Name_Last.value="";
		f.M_Name_Last.focus();
		return false;
	}

	if (f.M_Name_First.value == '')
	{
		alert("이름을 입력해주세요.");
		f.M_Name_First.focus();
		return false;
	}
	if( /[\s]/g.test( f.M_Name_First.value) == true){
		alert('공백은 사용할 수 없습니다!')
		f.M_Name_First.value=f.M_Name_First.value.replace(/(\s*)/g,'');
		return false;
	}
	if (!checkkorText(f.M_Name_First.value,1)) {
		alert("정확한 (이름)을 입력해 주세요!");
		f.M_Name_First.focus();
		return false;
	}
	if (!checkSCharNum(f.M_Name_First.value)) {
		alert("특수문자나 숫자는 입력할 수 없습니다!");
		f.M_Name_First.value="";
		f.M_Name_First.focus();
		return false;
	}
	if (chkEmpty(f.birthYY) || chkEmpty(f.birthMM) || chkEmpty(f.birthDD)) {
		alert("생년월일을 입력해 주세요.");
		f.birthYY.focus();
		return false;
	}
	if (!checkMinorBirth(f.birthYY, f.birthMM , f.birthDD)) return false;		// 미성년자체크(생년월일)

	f.target = "hidden";
	//f.action = "joinCheck_nc.asp";
	f.action = "/common/joinCheck_nc_g.asp";

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

	if ($("input[name=agreement]:checked").val() != 'T')
	{
		alert("약관에 동의하셔야합니다");
		f.agreement[0].focus();
		return false;
	}

	if (g.M_Name_Last.value == '')
	{
		alert("성을 입력해주세요.");
		g.M_Name_Last.focus();
		return false;
	}
	if( /[\s]/g.test( g.M_Name_Last.value) == true){
		alert('공백은 사용할 수 없습니다. ')
		g.M_Name_Last.value=g.M_Name_Last.value.replace(/(\s*)/g,'');
		return false;
	}
	if (!checkkorText(g.M_Name_Last.value,1)) {
		alert("정확한 (성)을 입력해 주세요.");
		g.M_Name_Last.focus();
		return false;
	}
	if (!checkSCharNum(g.M_Name_Last.value)) {
		alert("특수문자나 숫자는 입력할 수 없습니다.");
		g.M_Name_Last.value="";
		g.M_Name_Last.focus();
		return false;
	}

	if (g.M_Name_First.value == '')
	{
		alert("이름을 입력해주세요.");
		g.M_Name_First.focus();
		return false;
	}
	if( /[\s]/g.test( g.M_Name_First.value) == true){
		alert('공백은 사용할 수 없습니다!')
		g.M_Name_First.value=g.M_Name_First.value.replace(/(\s*)/g,'');
		return false;
	}
	if (!checkkorText(g.M_Name_First.value,1)) {
		alert("정확한 (이름)을 입력해 주세요!");
		g.M_Name_First.focus();
		return false;
	}
	if (!checkSCharNum(g.M_Name_First.value)) {
		alert("특수문자나 숫자는 입력할 수 없습니다!");
		g.M_Name_First.value="";
		g.M_Name_First.focus();
		return false;
	}

	if (chkEmpty(g.birthYY) || chkEmpty(g.birthMM) || chkEmpty(g.birthDD)) {
		alert("생년월일을 입력해 주세요.");
		g.birthYY.focus();
		return false;
	}
	if (!checkMinorBirth(g.birthYY, g.birthMM , g.birthDD)) return false;		// 미성년자체크(생년월일)

	

	if (chkEmpty(f.name)) {
		alert("가입확인을 해주세요.");
		g.name.focus();
		return false;
	}

	if (chkEmpty(f.birthYY) || chkEmpty(f.birthMM) || chkEmpty(f.birthDD)) {
		alert("가입확인을 해주세요.");
		f.birthYY.focus();
		return false;
	}
	if (!checkMinorBirth(f.birthYY, f.birthMM , f.birthDD)) return false;		// 미성년자체크(생년월일)

	//성 + 이름
	$("#nfrm_name").val(g.M_Name_Last.value+g.M_Name_First.value);


	if (f.name.value != g.name.value)
	{
			alert("가입확인한 이름과 현재 기입된 이름이 틀립니다. 가입확인을 다시 해주세요.");
			g.name.focus();
			return false;
	}
	if (f.birthYY.value != g.birthYY.value || f.birthMM.value != g.birthMM.value || f.birthDD.value != g.birthDD.value)
	{
			alert("가입확인한 생년월일이 변경되었습니다. 가입확인을 다시 해주세요.");
			g.birthYY.value='';
			g.birthMM.value='';
			g.birthDD.value='';
			g.birthYY.focus();
			return false;
	}
	f.submit();

}


//-->
