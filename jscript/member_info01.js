<!--
function join_idcheck() {
	var f = document.cfrm;

	if (chkEmpty(f.strID)) {
		alert("아이디를 입력해 주세요.");
		f.strID.focus();
		return;
	}

	if (!checkID(f.strID.value.trim(), 4, 20)){
		alert("아이디는 영문 혹은 숫자 4자~20자리로 해주세요.");
		f.strID.focus();
		return;
	}

	openPopup("/hiddens.asp", "asidcheck", 300, 200, "left=350, top=350");

	f.target = "asidcheck";
	f.action = "/common/pop_idCheck.asp";
	f.submit();
}

function vote_idcheck() {
	openPopup("/common/pop_voter.asp", "vote_idcheck", 100, 100, "left=200, top=200");
}
function spon_idcheck() {
	openPopup("/common/pop_Sponsor.asp", "spon_idcheck", 100, 100, "left=200, top=200");
}

function join_votercheck() {
	var f = document.cfrm;

	if (chkEmpty(f.strVoter)) {
		alert("추천인 아이디를 입력해 주세요.");
		f.strVoter.focus();
		return;
	}

	if (!checkID(f.strVoter.value.trim(), 1, 20)){
		alert("추천인 아이디는 영문 혹은 숫자 4자~20자리로 해주세요.");
		f.strVoter.focus();
		return;
	}

	checkVoters(f.strVoter.value);
}


function openzip() {
	openPopup("/common/pop_Zipcode.asp", "Zipcodes", 100, 100, "left=200, top=200");
}
function submitChk() {
	var f = document.cfrm;
	var objItem;

	if (chkEmpty(f.dataNum)) {
		alert("데이터값이 없습니다. 다시 시도해주세요.");
		f.strID.focus();
		return false;
	}


	if (chkEmpty(f.strID)) {
		alert("아이디를 입력해 주세요.");
		f.strID.focus();
		return false;
	}

	if (!checkID(f.strID.value, 4, 12)){
		alert("아이디는 영문 혹은 숫자 4자~12자리로 해주세요.");
		f.strID.focus();
		return false;
	}

	if (f.idcheck.value != f.strID.value){
		alert("아이디 중복확인을 해주세요.");
		f.strID.focus();
		return false;
	}

	if (chkEmpty(f.strPass)) {
		alert("비밀번호를 입력해 주세요.");
		f.strPass.focus();
		return false;
	}

	if (!checkPass(f.strPass.value, 4, 20) || !checkEngNum(f.strPass.value)){
		alert("비밀번호는 영문, 숫자 혼합 4자~15자로 해주세요.");
		f.strPass.focus();
		return false;
	}

	if (f.idcheck.value == f.strPass.value){
		alert("비밀번호는 아이디와 동일하게 할 수 없습니다.");
		f.strPass.focus();
		return false;
	}

	if (chkEmpty(f.strPass2)) {
		alert("비밀번호 확인을 입력해 주세요.");
		f.strPass2.focus();
		return false;
	}

	if (f.strPass.value != f.strPass2.value){
		alert("비밀번호를 다시 확인해 주세요.");
		f.strPass2.focus();
		return false;
	}
/*
	if (chkEmpty(f.strPass3)) {
		alert("2차 비밀번호를 입력해 주세요.");
		f.strPass3.focus();
		return false;
	}

	if (!checkPass(f.strPass.value, 4, 20) || !checkEngNum(f.strPass.value)){
		alert("2차 비밀번호는 영문, 숫자 혼합 4자~15자로 해주세요.");
		f.strPass.focus();
		return false;
	}

	if (f.idcheck.value == f.strPass.value){
		alert("2차 비밀번호는 아이디와 동일하게 할 수 없습니다.");
		f.strPass.focus();
		return false;
	}

	if (chkEmpty(f.strPass2)) {
		alert("2차 비밀번호 확인을 입력해 주세요.");
		f.strPass2.focus();
		return false;
	}

	if (f.strPass.value != f.strPass2.value){
		alert("2차 비밀번호를 다시 확인해 주세요.");
		f.strPass2.focus();
		return false;
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
*/
	if (chkEmpty(f.birthYY) || chkEmpty(f.birthMM) || chkEmpty(f.birthDD)) {
		alert("생년월일을 입력해 주세요.");
		f.birthYY.focus();
		return false;
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



	if (chkEmpty(f.voter) || chkEmpty(f.voter_mbid) || chkEmpty(f.voter_mbid2) || f.voter_check.value != f.voter.value) {
		f.voter.value = 'admin'
		f.voter_mbid.value = 'dr'
		f.voter_mbid2.value = '1'
		f.voter_check.value = 'admin'

	}
	if (chkEmpty(f.voter) || chkEmpty(f.voter_mbid) || chkEmpty(f.voter_mbid2) || f.voter_check.value != f.voter.value) {
		alert("추천인검색을 통해서 추천인을 선택 해주세요.");
		f.voter.focus();
		return false;
	}


	if (chkEmpty(f.sponsor) || chkEmpty(f.sponsor_mbid) || chkEmpty(f.sponsor_mbid2) || f.sponsor_check.value != f.sponsor.value) {
		f.sponsor.value = 'admin'
		f.sponsor_mbid.value = 'dr'
		f.sponsor_mbid2.value = '1'
		f.sponsor_check.value = 'admin'
	}




	if (chkEmpty(f.sponsor) || chkEmpty(f.sponsor_mbid) || chkEmpty(f.sponsor_mbid2) || f.sponsor_check.value != f.sponsor.value) {
		alert("후원인검색을 통해서 후원인을 선택 해주세요.");
		f.sponsor.focus();
		return false;
	}
*/





	if (confirm("회원가입을 하시겠습니까?")) {
		f.target = "_self";
		f.action = "member_info01Ok.asp";
		f.submit();
	}
}











//-->
