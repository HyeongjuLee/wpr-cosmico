function loginChk(f){

	var values = $("input[name=memberType]:checked").val();

	if ($("input[name=memberType]:checked").length == 0)
	{
		alert("로그인 타입을 선택해주세요");
		return false;
	}

	if (f.memberIDS.value == '')
	{
		alert("아이디를 입력해주세요");
		f.memberIDS.focus();
		return false;
	}
	if (f.memberPWD.value == '')
	{
		alert("패스워드를 입력해주세요");
		f.memberPWD.focus();
		return false;
	}

}


function checkMemType(){
	var values = $("input[name=memberType]:checked").val();
	if (values == 'N')
	{
		$("#login_alert").css({"display":"block"});
	} else {
		$("#login_alert").css({"display":"none"});
	}
}

