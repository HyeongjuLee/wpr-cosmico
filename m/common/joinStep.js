/* 한글 */

function toggle_ee(ids) {
	var divID = '#'+ids;
	$(divID).toggle();
}

function chkjFrm02(f) {
	/*
	var f = document.jFrm02;
	if ($("input[name=agreement]:checked").val() != 'T')
	{
		alert("약관에 동의하셔야합니다");
		return false;
	}
	*/
	var f = document.agreeFrm;

	if (f.agree01.checked == false) {
		alert("사이트 이용약관에 대한 동의가 필요합니다.");
		f.agree01.focus();
		return false;
	}

	if (f.agree02.checked == false) {
		alert("개인정보 취급방침에 대한 동의가 필요합니다.");
		f.agree02.focus();
		return false;
	}

	if (f.agree03.checked == false) {
		alert("사업자회원 가입약관에 대한 동의가 필요합니다.");
		f.agree03.focus();
		return false;
	}

	f.submit();
}