


	function allCheckAgree() {
		if (document.getElementById("allAgree").checked == true)
		{
			document.getElementById("agree01Chk").checked = true;
			document.getElementById("agree02Chk").checked = true;
			document.getElementById("agree03Chk").checked = true;
			//document.getElementById("agree33Chk").checked = true;
			//document.getElementById("agree04Chk").checked = true;
		} else if (document.getElementById("allAgree").checked == false)	{
			document.getElementById("agree01Chk").checked = false;
			document.getElementById("agree02Chk").checked = false;
			document.getElementById("agree03Chk").checked = false;
			//document.getElementById("agree33Chk").checked = false;
			//document.getElementById("agree04Chk").checked = false;
		}
	}


	function chkAgree(f) {

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

	}

	function chkCenterCode(f) {
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

		if (f.ajaxTF.value != "T")
		{
			alert("센터코드를 확인하지 않았거나 올바르지 않은 센터코드입니다.")
			return false;
		} else {
			if(!chkNull(f.centerName, "\'센터\'를 선택해 주세요")) return false;
			if(!chkNull(f.centerCode, "\'센터코드\'를 입력해 주세요")) return false;
			if(!chkNull(f.centerNameChk, "\'센터코드\' 확인을 해주세요.")) return false;
			if(!chkNull(f.centerCodeChk, "\'센터코드\' 확인을 해주세요.")) return false;
			if (f.centerCodeChk.value != f.centerCode.value || f.centerNameChk.value != f.centerName.value)
			{
				alert("확인하신 센터코드와 현재 입력된 센터코드가 틀립니다. 센터코드확인를 다시 해주세요.")
				return false;
			}

		}

	}


/*
	function ajax_centerCode() {
		createRequest();
		var url = 'joinStep02_ajax.asp';
		var f = document.jfrm;

		if (f.centerName.value == '')
		{
			alert("센터를 선택해주세요");
			return;
		}

		if (f.centerCode.value == '')
		{
			alert("센터등록코드를 입력해주세요");
			f.centerCode.focus();
			return;
		}

		postParams = "centerName=" + f.centerName.value;
		postParams += "&centerCode=" + f.centerCode.value;

		request.open("POST",url,true);
		request.onreadystatechange = function ChgContent() {
			if(request.readyState == 4){    // 요청응답상태가 4인지 확인해주고
				if(request.status == 200){     // HTTP상태가 완료인지 체크해줍니다.
					var newContent = request.responseText;
					//var newContentSplit = newContent.split("||")
					//alert(newContent);
					document.getElementById("result_text").innerHTML = newContent;
					//alert(document.getElementById("innerMask").innerHTML);
				} else {
					alert("ajax오류!");
				}
			  }
			}
		request.setRequestHeader("Content-Type","application/x-www-form-urlencoded;charset=utf-8");
		request.send(postParams);
		return;
	}
*/
/***************************************************
JOIN STEP 03. JAVASCRIPT
***************************************************/

	function ajax_accountChk() {
		createRequest();
		var url = 'joinStep03_ajax.asp';
		var f = document.jfrm;
		/*
		if (f.centerName.value == '')
		{
			alert("센터값이 없습니다.");
			document.location.href = "joinStep01.asp";
			return;
		}

		if (f.centerCode.value == '')
		{
			alert("센터등록코드를 입력해주세요");
			document.location.href = "joinStep01.asp";
			return;
		}
		*/


		if (f.strBankCode.value == '')
		{
			alert("은행을 선택해주세요.");
			f.strBankCode.focus();
			return;
		}

		if (f.strBankNum.value == '')
		{
			alert("계좌번호를 입력해주세요");
			f.strBankNum.focus();
			return;
		}
		/*
		if (f.strBankOwner.value == '')
		{
			alert("예금주를 입력해주세요.");
			f.strBankOwner.focus();
			return;
		}
		if( /[\s]/g.test( f.strBankOwner.value) == true){
			alert('공백은 사용할 수 없습니다. ')
			f.strBankOwner.value=f.strBankOwner.value.replace(/(\s*)/g,'');
			return;
		}
		if (!checkkorText(f.strBankOwner.value,2)) {
			alert("정확한 예금주명을 입력해 주세요!!");
			f.strBankOwner.focus();
			return false;
		}
		if (!checkSCharNum(f.strBankOwner.value)) {
			alert("특수문자나 숫자는 입력할 수 없습니다.");
			f.strBankOwner.value="";
			f.strBankOwner.focus();
			return false;
		}
		*/
		if (f.M_Name_Last.value == '')
		{
			alert("예금주 성을 입력해주세요.");
			f.M_Name_Last.focus();
			return false;
		}
		if( /[\s]/g.test( f.M_Name_Last.value) == true){
			alert('공백은 사용할 수 없습니다. ')
			f.M_Name_Last.value=f.M_Name_Last.value.replace(/(\s*)/g,'');
			return false;
		}
		/*
		if (!checkkorText(f.M_Name_Last.value,1)) {
			alert("정확한 예금주(성)을 입력해 주세요.");
			f.M_Name_Last.focus();
			return false;
		}
		*/
		if (!checkSCharNum(f.M_Name_Last.value)) {
			alert("특수문자나 숫자는 입력할 수 없습니다.");
			f.M_Name_Last.value="";
			f.M_Name_Last.focus();
			return false;
		}

		if (f.M_Name_First.value == '')
		{
			alert("예금주 이름을 입력해주세요.");
			f.M_Name_First.focus();
			return false;
		}
		if( /[\s]/g.test( f.M_Name_First.value) == true){
			alert('공백은 사용할 수 없습니다!')
			f.M_Name_First.value=f.M_Name_First.value.replace(/(\s*)/g,'');
			return false;
		}
		/*
		if (!checkkorText(f.M_Name_First.value,1)) {
			alert("정확한 예금주(이름)을 입력해 주세요!");
			f.M_Name_First.focus();
			return false;
		}
		*/
		if (!checkSCharNum(f.M_Name_First.value)) {
			alert("특수문자나 숫자는 입력할 수 없습니다!");
			f.M_Name_First.value="";
			f.M_Name_First.focus();
			return false;
		}

		//핸드폰인증기능 사용 (인증된 이름과 비교)
		if (f.NICE_BANK_WITH_MOBILE_USE.value == 'T') {
			if (f.strBankOwner.value != f.M_Name_Last.value+f.M_Name_First.value)	{
				alert("정확한 본인의 이름을 입력해주세요!!!");
				f.M_Name_First.focus();
				return false;
			}
		}

		if (chkEmpty(f.birthYY) || chkEmpty(f.birthMM) || chkEmpty(f.birthDD)) {
			alert("생년월일을 입력해 주세요.");
			f.birthYY.focus();
			return;
		}

		if (!checkMinorBirth(f.birthYY, f.birthMM , f.birthDD)) return;		// 미성년자체크(생년월일)


		postParams = "centerName=" + f.centerName.value;
		postParams += "&centerCode=" + f.centerCode.value;
		postParams += "&birthYY=" + f.birthYY.value;
		postParams += "&birthMM=" + f.birthMM.value;
		postParams += "&birthDD=" + f.birthDD.value;
		postParams += "&strBankCode=" + f.strBankCode.value;
		postParams += "&strBankNum=" + f.strBankNum.value;
		postParams += "&strBankOwner=" + f.M_Name_Last.value+f.M_Name_First.value;
		postParams += "&M_Name_First=" + f.M_Name_First.value;
		postParams += "&M_Name_Last=" + f.M_Name_Last.value;

		document.getElementById("loadings").style.visibility="visible";;
		request.open("POST",url,true);
		request.onreadystatechange = function ChgContent() {
			if(request.readyState == 4){    // 요청응답상태가 4인지 확인해주고
				if(request.status == 200){     // HTTP상태가 완료인지 체크해줍니다.
					var newContent = request.responseText;
					//var newContentSplit = newContent.split("||")
					//alert(newContent);
					document.getElementById("result_text").innerHTML = newContent;
					document.getElementById("loadings").style.visibility="hidden";

					//alert(document.getElementById("innerMask").innerHTML);
				} else {
					document.getElementById("loadings").style.visibility="hidden";
					document.getElementById("result_text").innerHTML = "ajax오류!";
				}
			  }
			}
		request.setRequestHeader("Content-Type","application/x-www-form-urlencoded;charset=utf-8");
		request.send(postParams);
		return;
	}



	function chkAccountFrm(f) {
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


		if (f.ajaxTF.value != "T")
		{
			alert("계좌본인인증을 해주세요.")
			return false;
		} else {
			/*
			if(!chkNull(f.centerName, "\'센터\'를 선택해 주세요")) return false;
			if(!chkNull(f.centerCode, "\'센터코드\'를 입력해 주세요")) return false;
			*/
			if(!chkNull(f.strBankCode, "\'은행\'을 선택해 주세요")) return false;
			if(!chkNull(f.strBankNum, "\'계좌번호\'를 입력해 주세요")) return false;
			//if(!chkNull(f.strBankOwner, "\'예금주\'를 입력해 주세요")) return false;
			if(!chkNull(f.M_Name_First, "\'예금주 이름\'을 입력해 주세요")) return false;
			if(!chkNull(f.M_Name_Last, "\'예금주 성\'을 입력해 주세요")) return false;

			/*
			if (!checkkorText(f.strBankOwner.value,2)) {
				alert("정확한 예금주명을 입력해 주세요!!");
				f.strBankOwner.focus();
				return false;
			}
			if (!checkSCharNum(f.strBankOwner.value)) {
				alert("특수문자나 숫자는 입력할 수 없습니다.");
				f.strBankOwner.value="";
				f.strBankOwner.focus();
				return false;
			}
			*/
			if (!checkkorText(f.M_Name_Last.value,1)) {
				alert("정확한 예금주(성)을 입력해 주세요.");
				f.M_Name_Last.focus();
				return false;
			}
			if (!checkSCharNum(f.M_Name_Last.value)) {
				alert("특수문자나 숫자는 입력할 수 없습니다.");
				f.M_Name_Last.value="";
				f.M_Name_Last.focus();
				return false;
			}
			if (!checkkorText(f.M_Name_First.value,1)) {
				alert("정확한 예금주(이름)을 입력해 주세요!");
				f.M_Name_First.focus();
				return false;
			}
			if (!checkSCharNum(f.M_Name_First.value)) {
				alert("특수문자나 숫자는 입력할 수 없습니다!");
				f.M_Name_First.value="";
				f.M_Name_First.focus();
				return false;
			}

			//핸드폰인증된 이름과 비교
			if (f.NICE_BANK_WITH_MOBILE_USE.value == 'T') {
				if (f.strBankOwner.value != f.M_Name_Last.value+f.M_Name_First.value)	{
					alert("정확한 본인의 이름을 입력해주세요!!");
					f.M_Name_First.focus();
					return false;
				}
			}

			if(!chkNull(f.TempDataNum, "\'데이터베이스 입력 오류\'")) return false;

			if (chkEmpty(f.birthYY) || chkEmpty(f.birthMM) || chkEmpty(f.birthDD)) {
				alert("생년월일을 입력해 주세요.");
				f.birthYY.focus();
				return false;
			}
			if (!checkMinorBirth(f.birthYY, f.birthMM , f.birthDD)) return;		// 미성년자체크(생년월일)

			$("input[name=strBankOwner]").val(f.M_Name_Last.value+f.M_Name_First.value);

			if (f.strBankCodeCHK.value != f.strBankCode.value || f.strBankNumCHK.value != f.strBankNum.value || f.strBankOwnerCHK.value != f.strBankOwner.value || f.birthYYCHK.value != f.birthYY.value || f.birthMMCHK.value != f.birthMM.value || f.birthDDCHK.value != f.birthDD.value)
			{
				alert("본인인증시의 입력정보와 현재 입력된 정보가 틀립니다. 본인인증을 다시 해주세요.")
				return false;
			}

		}


		if (f.strBankCode.value == '')
		{
			alert("은행을 선택해주세요.");
			return false;
		}

		if (f.strBankNum.value == '')
		{
			alert("계좌번호를 입력해주세요");
			f.strBankNum.focus();
			return false;
		}
		/*
		if (f.strBankOwner.value == '')
		{
			alert("예금주를 입력해주세요");
			f.strBankOwner.focus();
			return false;
		}
		if( /[\s]/g.test( f.strBankOwner.value) == true){
			alert('공백은 사용할 수 없습니다. ')
			f.strBankOwner.value=f.strBankOwner.value.replace(/(\s*)/g,'');
			return false;
		}
		if (!checkkorText(f.strBankOwner.value,2)) {
			alert("정확한 예금주명을 입력해 주세요!!");
			f.strBankOwner.focus();
			return false;
		}
		if (!checkSCharNum(f.strBankOwner.value)) {
			alert("특수문자나 숫자는 입력할 수 없습니다.");
			f.strBankOwner.value="";
			f.strBankOwner.focus();
			return false;
		}
		*/
		if (f.M_Name_Last.value == '')
		{
			alert("예금주 성을 입력해주세요.");
			f.M_Name_Last.focus();
			return;
		}
		if( /[\s]/g.test( f.M_Name_Last.value) == true){
			alert('공백은 사용할 수 없습니다. ')
			f.M_Name_Last.value=f.M_Name_Last.value.replace(/(\s*)/g,'');
			return;
		}
		if (!checkkorText(f.M_Name_Last.value,1)) {
			alert("정확한 예금주(성)을 입력해 주세요.");
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
			alert("예금주 이름을 입력해주세요.");
			f.M_Name_First.focus();
			return;
		}
		if( /[\s]/g.test( f.M_Name_First.value) == true){
			alert('공백은 사용할 수 없습니다!')
			f.M_Name_First.value=f.M_Name_First.value.replace(/(\s*)/g,'');
			return;
		}
		if (!checkkorText(f.M_Name_First.value,1)) {
			alert("정확한 예금주(이름)을 입력해 주세요!");
			f.M_Name_First.focus();
			return false;
		}
		if (!checkSCharNum(f.M_Name_First.value)) {
			alert("특수문자나 숫자는 입력할 수 없습니다!");
			f.M_Name_First.value="";
			f.M_Name_First.focus();
			return false;
		}

		// checkSSH :	jscript/check.js
	}

/***************************************************
JOIN STEP 03. JAVASCRIPT
***************************************************/

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
			alert("ajax 처리 중 에러가 발생하였습니다.ERROR CODE : "+jsonData.status+" "+jsonData.statusText+" "+jsonData.responseText);
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

	if (!checkID(ids.value.trim(), 4, 20)){
		alert2("아이디는 영문 혹은 숫자 4자~20자리로 해주세요.", "#idCheck", "F");
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


function vote_idcheck() {
	openPopup("/common/pop_voter.asp", "vote_idcheck", 100, 100, "left=200, top=200");
}
function spon_idcheck() {
	openPopup("/common/pop_Sponsor.asp", "spon_idcheck", 100, 100, "left=200, top=200");
}
function spon_idcheck2() {
	openPopup("/common/pop_Sponsor2.asp", "spon_idcheck", 100, 100, "left=200, top=200");
}


function openzip() {
	openPopup("/common/pop_Zipcode.asp", "Zipcodes", 100, 100, "left=200, top=200");
}




function submitChk() {
	var f = document.cfrm;
	var objItem;
	/* 기존데이터 확인 S */
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
		if (f.centerName.value == '')
		{
			alert("센터값이 없습니다. 다시 시도해주세요.");
			document.location.href = "joinStep01.asp";
			return false;
		}
		if (f.centerCode.value == '')
		{
			alert("센터등록코드가 없습니다. 다시 시도해주세요.");
			document.location.href = "joinStep01.asp";
			return false;
		}
	*/

	if (f.strBankCode.value == '')
	{
		alert("은행정보가 없습니다. 다시 시도해주세요.");
		//document.location.href = "joinStep01.asp";
		return false;
	}
	if (f.strBankNum.value == '')
	{
		alert("계좌번호정보가 없습니다. 다시 시도해주세요.");
		//document.location.href = "joinStep01.asp";
		return false;
	}
	if (f.strBankOwner.value == '')
	{
		alert("예금주정보가 없습니다. 다시 시도해주세요.");
		//document.location.href = "joinStep01.asp";
		return false;
	}
	if (chkEmpty(f.dataNum)) {
		alert("데이터값이 없습니다. 다시 시도해주세요.");
		//document.location.href = "joinStep01.asp";
		return false;
	}

	if (f.CS_AUTO_WEBID_TF.value != 'T') {
		if (chkEmpty(f.strID)) {
			alert2("아이디를 입력해 주세요.", "#idCheck", "F");
			f.strID.focus();
			return false;
		}
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

	if (chkEmpty(f.strPass)) {
		alert("비밀번호를 입력해 주세요.");
		f.strPass.focus();
		return false;
	}
	if (!checkPass(f.strPass.value, 4, 20)){
		alert("비밀번호는 영문, 숫자 4자~20자로 해주세요.");
		f.strPass.focus();
		return false;
	}
	if (f.CS_AUTO_WEBID_TF.value != 'T') {
		if (f.strID.value == f.strPass.value){
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
		//openzip();
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
		return;
	}else {
		return false;
	}
}
