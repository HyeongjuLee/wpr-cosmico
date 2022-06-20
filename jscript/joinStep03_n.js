<!--


	function openzip() {
		openPopup("/common/pop_Zipcode.asp", "Zipcodes", 100, 100, "left=200, top=200");
	}


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


	//특정문자로시작하는 아이디제한(CS회원번호앞자리체크)
	function join_idcheck_CSID() {
		var ids = document.cfrm.strID;
		if (ids.value == '')
		{
			alert("아이디를 입력하셔야합니다.");
			ids.focus();
			return false;
		}

		if (checkID_CSID(ids.value.trim())){
			alert("아이디 앞에 특정단어로 시작하는 아이디는 사용할 수 없습니다.\n\n예외처리 단어 : test, cs_");
			ids.value = "";
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

		$.ajax({
			type: "POST"
			,url: "ajax_NickNameCheck.asp"
			,data: {
				 "ids"					: ids.value

			}
			//,contentType: "application/json; charset=utf-8"
			,success: function(data) {
				$("#NickCheck").html(data);
			}
			,error:function(data) {
				loadings();
				alert("ajax 처리 중 에러가 발생하였습니다.ERROR CODE : "+data.status+" "+data.statusText+" "+data.responseText);
			}
		});

	}


	function chkSubmit(f) {

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

		if (!checkPass(f.strPass.value, 6, 20) || !checkEngNum(f.strPass.value)){
			alert("비밀번호는 영문, 숫자 혼합 6자~20자로 해주세요.");
			f.strPass.focus();
			return false;
		}

		if (f.chkID.value == f.strPass.value){
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

		if (chkEmpty(f.birthYY))
		{
			alert("생년월일중 '년도'를 선택해주세요.");
			f.birthYY.focus();
			return false;
		}
		if (chkEmpty(f.birthMM))
		{
			alert("생년월일중 '월'를 선택해주세요.");
			f.birthMM.focus();
			return false;

		}
		if (chkEmpty(f.birthDD))
		{
			alert("생년월일중 '일'를 선택해주세요.");
			f.birthDD.focus();
			return false;

		}
		if (chkEmpty(f.strzip) || chkEmpty(f.straddr1)) {
			alert("우편번호/주소를 입력해 주세요.");
			openzip();
			f.strzip.focus();
			return false;
		}

		if (chkEmpty(f.straddr2)) {
			alert("상세주소를 입력해 주세요.");
			f.straddr2.focus();
			return false;
		}

		for (i=1; i<=3; i++) {
			objItem = eval("f.mob_num"+i);
			if (chkEmpty(objItem)) {
				alert("휴대전화를 입력해 주세요.");
				objItem.focus();
				return false;
			}
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

	if (confirm("회원가입을 하시겠습니까?")) {
		f.target = "_self";
		return;
	} else {
			return false;
	}

}



//-->
