<!--
	function join_idcheck() {
		var ids = document.cfrm.strID;
		if (ids.value == '')
		{
			alert("아이디를 입력하셔야합니다.");
			ids.focus();
			return false;
		}

		if (!checkID(ids.value.trim(), 4, 20)){
			alert("아이디는 영문 혹은 숫자 4자~20자리로 해주세요.");
			ids.focus();
			return false;
		}
		createRequest();

		var url = 'ajax_idcheck.asp?ids='+ids.value;

		request.open("GET",url,true);
		request.onreadystatechange = function ChgContent() {
			if(request.readyState == 4){    // 요청응답상태가 4인지 확인해주고
				if(request.status == 200){     // HTTP상태가 완료인지 체크해줍니다.
					var newContent = request.responseText;
					document.getElementById("idCheck").innerHTML = newContent;
				}
			}
		}
		request.send(null);
	}




	function join_NickCheck() {
		var ids = document.cfrm.NickName;
		if (ids.value == '')
		{
			alert("닉네임을 입력하셔야합니다.");
			ids.focus();
			return false;
		}

		createRequest();

		var url = 'ajax_NickNameCheck.asp?ids='+ids.value;

		request.open("GET",url,true);
		request.onreadystatechange = function ChgContent() {
			if(request.readyState == 4){    // 요청응답상태가 4인지 확인해주고
				if(request.status == 200){     // HTTP상태가 완료인지 체크해줍니다.
					var newContent = request.responseText;
					document.getElementById("NickCheck").innerHTML = newContent;
				}
			}
		}
		request.send(null);
	}

//휴대전화	
	function join_MobCheck() {
		var mbs1 = document.cfrm.mob_num1;
		var mbs2 = document.cfrm.mob_num2;
		var mbs3 = document.cfrm.mob_num3;

		for (i=1; i<=3; i++) {
			objItem = eval("mbs"+i);
			if (chkEmpty(objItem)) {
				alert("휴대전화번호를 입력해 주세요.");
				objItem.focus();
				return false;
			}
		}
		createRequest();

		var url = 'ajax_MobCheck.asp?mbs1='+mbs1.value+'&mbs2='+mbs2.value+'&mbs3='+mbs3.value;

		request.open("GET",url,true);
		request.onreadystatechange = function ChgContent() {
			if(request.readyState == 4){    // 요청응답상태가 4인지 확인해주고
				if(request.status == 200){     // HTTP상태가 완료인지 체크해줍니다.
					var newContent = request.responseText;
					document.getElementById("MobCheck").innerHTML = newContent;
				}
			}
		}
		request.send(null);
	}


	function openzip() {
		openPopup("/common/pop_Zipcode.asp", "Zipcodes", 100, 100, "left=200, top=200");
	}
	function vote_idcheck() {
		openPopup("/common/pop_voter.asp", "vote_idcheck", 100, 100, "left=200, top=200");
	}
	function spon_idcheck() {
		openPopup("/common/pop_Sponsor.asp", "spon_idcheck", 100, 100, "left=200, top=200");
	}

function chkSubmit() {
	var f = document.cfrm;
	var objItem;
/*
	if (chkEmpty(f.dataNum)) {
		alert("데이터값이 없습니다. 다시 시도해주세요.");
		f.strID.focus();
		return false;
	}
*/
	if (f.agreement.value != 'T')
	{
		alert("이용약관에 동의하셔야합니다.");
		document.location.href = '/common/joinStep01.asp';
		return false;
	}
	if (f.gather.value != 'T')
	{
		alert("개인정보 수집 및 이용에 동의하셔야합니다.");
		document.location.href = '/common/joinStep01.asp';
		return false;
	}
/*	
	if (f.company.value != 'T')
	{
		alert("사업자회원 약관에 동의하셔야합니다.");
		document.location.href = '/common/joinStep01.asp';
		return false;
	}
*/

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

	if (f.strID.value == "")
	{
		alert("아이디를 입력해주세요");
		f.strID.focus();
		return false;
	} else {
		if (!checkID(f.strID.value, 4, 12)){
			alert("아이디는 영문 혹은 숫자 4자~12자리로 해주세요.");
			f.strID.focus();
			return false;
		}

		if (f.idcheck.value == 'F'){
			alert("아이디 중복확인을 해주세요.");
			f.strID.focus();
			return false;
		}
		if (f.strID.value != f.chkID.value){
			alert("중복확인한 아이디와 현재 등록된 아이디가 틀립니다. 다시한번 아이디 중복확인을 해주세요.");
			f.strID.focus();
			return false;
		}
	}
/*
	if (f.NickName.value == "")
	{
		alert("사용하실 닉네임을 입력해주세요");
		f.NickName.focus();
		return false;
	} else {

		if (f.Nickcheck.value == 'F'){
			alert("닉네임 중복확인을 해주세요.");
			f.NickName.focus();
			return false;
		}
		if (f.NickName.value != f.chkNick.value){
			alert("중복확인한 닉네임와 현재 입력한 닉네임이 틀립니다. 다시한번 닉네임 중복확인을 해주세요.");
			f.NickName.focus();
			return false;
		}
	}
*/
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



	if (chkEmpty(f.voter) || chkEmpty(f.NominID1) || chkEmpty(f.NominID2) || chkEmpty(f.NominWebID) || f.NominChk.value == 'F') {
		alert("추천인을 입력해 주세요.");
		f.voter.focus();
		//vote_idcheck();
		return false;
	}

	if (chkEmpty(f.businessCode)) {
	//	alert("센터를 선택해주세요.");
		alert("센터가 입력되지 않았습니다.\n\n추천인의 센터코드 정보가 없습니다.\n\n본사에 문의해주세요.");
		//f.businessCode.focus();
		return false;
	}
/*
	if (chkEmpty(f.sponsor) || chkEmpty(f.SponID1) || chkEmpty(f.SponID2) || chkEmpty(f.SponIDWebID) || f.SponIDChk.value == 'F') {
		alert("후원인을 입력해 주세요.");
		f.sponsor.focus();
		//spon_idcheck();
		return false;
	}
*/




	if (chkEmpty(f.strzip) || chkEmpty(f.straddr1)) {
		alert("우편번호/주소를 입력해 주세요.");
		f.strzip.focus();
		openzip();
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
	if (f.MobCheck.value == 'F'){
		alert("휴대전화 중복체크를해주세요.");
		f.mob_num1.focus();
		return false;
	}
	//휴대폰 중복체크 이후-- 번호변경 입력시 경고
	if (f.mob_num1.value != f.chkMobNum1.value || f.mob_num2.value != f.chkMobNum2.value || f.mob_num3.value != f.chkMobNum3.value){
		alert("중복확인한 휴대전화와 현재 입력한 휴대전화번호가 틀립니다. \n\n다시한번 휴대전화 중복확인을 해주세요.");
		f.mob_num1.focus();
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

	if (chkEmpty(f.birthYY) || chkEmpty(f.birthMM) || chkEmpty(f.birthDD)) {
		alert("생년월일을 입력해 주세요.");
		f.birthYY.focus();
		return false;
	}



	if (confirm("멤버쉽 회원가입을 하시겠습니까?")) {
		f.target = "_self";
		return;
	} else {
			return false;
	}
}
