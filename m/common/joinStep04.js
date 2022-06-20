

	function join_MobileCheck() {
		var f = document.cfrm;

		if (chkEmpty(f.strMobile)) {
			alert2("휴대전화를 입력해 주세요", "#mobileCheckTXT", "F");
			f.strMobile.focus();
			return false;
		}
		if (!chkMob(f.strMobile.value)) {
			alert2("정확한 휴대전화번호를 입력해 주세요", "#mobileCheckTXT", "F");
			f.strMobile.focus();
			return false;
		}
		$.ajax({
			type: "POST"
			,async : false
			,url: "/common/ajax_mobileCheck.asp"
			,data: {
				"strMobile" : f.strMobile.value
			}
			,success: function(jsonData) {
				var json = $.parseJSON(jsonData);

				if (json.result == "success")
				{
					if (json.mobileCheck == "T") {
						//$("#mobileCheckTXT").text(json.message).addClass("blue2").removeClass("red2");
						alertTxt(json.message, "#mobileCheckTXT", "T");
						$("input[name=mobileCheck]").val("T");
						$("input[name=chkMobile]").val($("input[name=strMobile]").val());

					}else{
						//$("#mobileCheckTXT").text(json.message).addClass("red2").removeClass("blue2");
						alertTxt(json.message, "#mobileCheckTXT", "F");
						$("input[name=mobileCheck]").val("F");
					}
				}
			}
			,error:function(jsonData) {
				alert("ajax 처리 중 에러가 발생하였습니다.ERROR CODE : "+jsonData.status+" "+jsonData.statusText+" "+jsonData.responseText);
			}
		});

	}

	function join_emailCheck() {
		var f = document.cfrm;
		if (f.strEmail.value == '')
		{
			alert2("메일을 입력해 주세요.", "#emailCheckTXT", "F");
			f.strEmail.focus();
			return false;
		}
		if (!checkEmail(f.strEmail.value)) {
			alert2("형식에 맞지 않는 이메일 주소입니다.\n\n이메일 주소를 정확하게 입력해 주세요.", "#emailCheckTXT", "F");
			f.strEmail.focus();
			return false;
		}
		$.ajax({
			type: "POST"
			,async : false
			,url: "/common/ajax_emailCheck.asp"
			,data: {
				"email" : f.strEmail.value
			}
			,success: function(jsonData) {
				//console.log(jsonData);
				var json = $.parseJSON(jsonData);

				if (json.result == "success")
				{
					if (json.emailCheck == "T") {
						//$("#emailCheckTXT").text(json.message).addClass("blue2").removeClass("red2");
						alertTxt(json.message, "#emailCheckTXT", "T");
						$("input[name=emailCheck]").val("T");
						$("input[name=chkEmail]").val($("input[name=strEmail]").val());

					}else{
						//$("#emailCheckTXT").text(json.message).addClass("red2").removeClass("blue2");
						alertTxt(json.message, "#emailCheckTXT", "F");
						$("input[name=emailCheck]").val("F");
					}
				}
			}
			,error:function(jsonData) {
				alert("<%=LNG_AJAX_ERROR_MSG%> "+jsonData.status+" "+jsonData.statusText+" "+jsonData.responseText);
			}

		});

	}

	function join_idcheck() {
		var ids = document.cfrm.strID;
		if (ids.value == '')
		{
			alert2("아이디를 입력하셔야합니다.", "#idCheck", "F");
			ids.focus();
			return false;
		}
		/*
		if (/(\w)\1\1/.test(ids.value)){
			alert("동일 숫자나 영문은 3번이상 연속으로 사용할 수 없습니다.");
			return false;
		}
		if (ids.value.search('dana')>-1 || ids.value.search('DANA')>-1) {
			alert('아이디에 dana는 포함할 수 없습니다.')
			return false;
		}
		if (checkID_CSID(ids.value.trim())){
			alert("아이디 앞에 특정단어로 시작하는 아이디는 사용할 수 없습니다.\n\n예외처리 단어 : te,cs_,dana");
			ids.value = "";
			ids.focus();
			return false;
		}
		*/
		if (!checkID(ids.value.trim(), 4, 20)){
			alert2("아이디는 영문 혹은 숫자 4자~20자리로 해주세요.", "#idCheck", "F");
			ids.focus();
			return false;
		}
		$.ajax({
			type: "POST"
			,url: "joinChk_id.asp"
			,data: {
				"ids"		: ids.value
			}
			//,contentType: "application/json; charset=utf-8"
			,success: function(data) {
				$("#idCheck").html(data);
				//loadings();
				//alert($("."+DivGoods).parent().tagName);
			}
			,error:function(data) {
				alert("ajax 처리 중 에러가 발생하였습니다.ERROR CODE : "+data.status+" "+data.statusText+" "+data.responseText);
			}
		});
	}


	//특정문자로시작하는 아이디제한(CS회원번호앞자리체크)
	function join_idcheck_CSID() {
		var ids = document.cfrm.strID;
		if (ids.value == '')
		{
			alert2("아이디를 입력하셔야합니다.", "#idCheck", "F");
			ids.focus();
			return false;
		}
		/*
		if (checkID_CSID(ids.value.trim())){
			alert("아이디 앞에 특정단어로 시작하는 아이디는 사용할 수 없습니다.\n\n예외처리 단어 : te, cs_");
			ids.value = "";
			ids.focus();
			return false;
		}
		*/
		if (!checkID(ids.value.trim(), 4, 20)){
			alert2("아이디는 영문 혹은 숫자 4자~20자리로 해주세요.", "#idCheck", "F");
			ids.focus();
			return false;
		}

		$.ajax({
			type: "POST"
			,url: "joinChk_id.asp"
			,data: {
				"ids"		: ids.value
			}
			//,contentType: "application/json; charset=utf-8"
			,success: function(data) {
				$("#idCheck").html(data);
				//loadings();
				//alert($("."+DivGoods).parent().tagName);
			}
			,error:function(data) {
				alert("ajax 처리 중 에러가 발생하였습니다.ERROR CODE : "+data.status+" "+data.statusText+" "+data.responseText);
			}
		});
	}


	function openzip() {
		//openPopup("/m/common/pop_Zipcode.asp", "Zipcodes", 0, 0,"");
		openPopup("/m/common/pop_Zipcode.asp", "Zipcodes");
	}
	function vote_idcheck() {
		openPopup("/m/common/pop_voter.asp", "vote_idcheck");
	}
	function spon_idcheck() {
		openPopup("/m/common/pop_sponsor.asp", "spon_idcheck");
	}


	function chkSubmit() {
		var f = document.cfrm;
		var objItem;
		if (chkEmpty(f.dataNum)) {
			alert("데이터값이 없습니다. 다시 시도해주세요.");
			f.strID.focus();
			return false;
		}
		if (f.agree01.value != "T") {
			alert("정상적인 접속이 아니거나 이용약관에 동의하지 않은 상태로 현재 페이지에 접속하셨습니다.");
			document.location.href = "joinStep01.asp";
			return false;
		}
		if (f.agree02.value != "T") {
			alert("정상적인 접속이 아니거나 개인정보 취급방침에 동의하지 않은 상태로 현재 페이지에 접속하셨습니다.");
			document.location.href = "joinStep01.asp";
			return false;
		}
		if (f.agree03.value != "T") {
			alert("정상적인 접속이 아니거나 사업자 회원가입 이용약관에 동의하지 않은 상태로 현재 페이지에 접속하셨습니다.");
			document.location.href = "joinStep01.asp";
			return false;
		}
		/*
		if (f.gather.value != 'T')
		{
			alert("개인정보 수집 및 이용에 동의하셔야합니다.");
			document.location.href = '/common/joinStep01.asp';
			return false;
		}
		if (f.company.value != 'T')
		{
			alert("사업자회원 약관에 동의하셔야합니다.");
			document.location.href = '/common/joinStep01.asp';
			return false;
		}
		*/
		if (f.CS_AUTO_WEBID_TF.value != 'T') {
			if (f.strID.value == "")
			{
				alert2("아이디를 입력해 주세요.", "#idCheck", "F");
				f.strID.focus();
				return false;
			} else {
				if (!checkID(f.strID.value, 4, 20)){
					alert2("아이디는 영문 혹은 숫자 4자~20자리로 해주세요.", "#idCheck", "F");
					f.strID.focus();
					return false;
				}
				if (f.idcheck.value == 'F'){
					alert2("아이디 중복확인을 해주세요.", "#idCheck", "F");
					f.strID.focus();
					return false;
				}
				if (f.strID.value != f.chkID.value){
					alert2("중복확인한 아이디와 현재 등록된 아이디가 틀립니다. 다시한번 아이디 중복확인을 해주세요.", "#idCheck", "F");
					f.strID.focus();
					return false;
				}
			}
		}

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
		if (f.CS_AUTO_WEBID_TF.value != 'T') {
			if (f.idcheck.value == f.strPass.value){
				alert("비밀번호는 아이디와 동일하게 할 수 없습니다.");
				f.strPass.focus();
				return false;
			}
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
		if (f.CENTER_SELECT_TF.value == 'T') {
			if (chkEmpty(f.businessCode)) {
				alert("센터를 선택해주세요.");
				f.businessCode.focus();
				return false;
			}
		}

		if (chkEmpty(f.voter) || chkEmpty(f.NominID1) || chkEmpty(f.NominID2) || f.NominChk.value == 'F') {
			alert("추천인을 입력해 주세요.");
			$("#popVoter").click();
			f.voter.focus();
			return false;
		}
		/*
		if (chkEmpty(f.sponsor) || chkEmpty(f.SponID1) || chkEmpty(f.SponID2) || f.SponIDChk.value == 'F') {
			alert("후원인을 입력해 주세요.");
			$("#popSponsor").click();
			f.sponsor.focus();
			return false;
		}
		*/

		if (chkEmpty(f.strZip) || chkEmpty(f.strADDR1)) {
			alert("우편번호/주소를 입력해 주세요.");
			$("#pop_postcode").click();
			f.strZip.focus();
			return false;
		}

		if (chkEmpty(f.strADDR2)) {
			alert("상세주소를 입력해 주세요.");
			f.strADDR2.focus();
			return false;
		}

		if (f.NICE_BANK_WITH_MOBILE_USE.value != 'T') {
			if (chkEmpty(f.strMobile)) {
				alert("휴대전화를 입력해 주세요");
				f.strMobile.focus();
				return false;
			} else {
				if (!chkMob(f.strMobile.value)) {
					alert2("정확한 휴대전화번호를 입력해 주세요", "#mobileCheckTXT", "F");
					f.strMobile.focus();
					return false;
				}
				if (f.mobileCheck.value == 'F'){
					alert2("핸드폰 중복확인을 해주세요", "#mobileCheckTXT", "F");
					f.strMobile.focus();
					return false;
				}
				if (f.strMobile.value != f.chkMobile.value){
					alert2("중복확인한 핸드폰번호와 현재 등록된 핸드폰번호가 틀립니다. 다시한번 핸드폰 중복확인을 해주세요", "#mobileCheckTXT", "F");
					//alert("중복확인한 핸드폰번호와 현재 등록된 핸드폰번호가 틀립니다. 다시한번 핸드폰 중복확인을 해주세요");
					//$("#mobileCheckTXT").text("중복확인을 해주세요.").addClass("red2").removeClass("blue2");
					$("input[name=mobileCheck]").val("F");
					f.strMobile.focus();
					return false;
				}
			}
		}

		if (!chkEmpty(f.strTel)) {
			if (!chkTel(f.strTel.value)) {
				alert("정확한 전화번호를 입력해 주세요");
				f.strTel.focus();
				return false;
			}
		}

		if (f.strEmail.value == "")
		{
			alert2("이메일을 입력해 주세요.", "#emailCheckTXT", "F");
			f.strEmail.focus();
			return false;

		} else {

			if (!checkEmail(f.strEmail.value)) {
				//alert("형식에 맞지 않는 이메일 주소입니다.\n\n이메일 주소를 정확하게 입력해 주세요.");
				alert2("형식에 맞지 않는 이메일 주소입니다.\n\n이메일 주소를 정확하게 입력해 주세요.", "#emailCheckTXT", "F");
				f.strEmail.focus();
				return false;
			}

			if (f.emailCheck.value == 'F'){
				alert2("이메일 중복확인을 해주세요.", "#emailCheckTXT", "F");
				f.strEmail.focus();
				return false;
			}
			if (f.strEmail.value != f.chkEmail.value){
				//alert("중복확인한 이메일과 현재 등록된 이메일이 다릅니다. 다시한번 이메일 중복확인을 해주세요.");
				alert2("중복확인한 이메일과 현재 등록된 이메일이 다릅니다. 다시한번 이메일 중복확인을 해주세요..", "#emailCheckTXT", "F");
				$("#emailCheckTXT").text("중복확인을 해주세요.").css({"color":"red"});
				f.strEmail.focus();
				return false;
			}

		}


		if (chkEmpty(f.birthYY) || chkEmpty(f.birthMM) || chkEmpty(f.birthDD)) {
			alert("생년월일을 입력해 주세요.");
			f.birthYY.focus();
			return false;
		}


		if (confirm("사업자 회원가입을 하시겠습니까?")) {
			//f.target = "_self";	/* 모바일 삭제처리!! */
			f.submit();
		} else {
			return false;
		}

}



