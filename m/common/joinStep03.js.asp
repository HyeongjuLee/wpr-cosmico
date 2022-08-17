<script type="text/javascript">

	$(document).ready(function(){
		<%If DK_MEMBER_VOTER_ID = "" Then%>
			$("input[name=voter]").val("");
		<%End IF%>
		$("input[name=sponsor]").val("");
	});


	//계좌중복체크
	function join_bankCheck() {
		var f = document.cfrm;
		if(!chkNull(f.bankCode, "은행을 선택해 주세요")) return false;
		if(!chkNull(f.bankNumber, "계좌번호를 입력해 주세요")) return false;
		if (f.bankNumber.value.length < 10) {
			alert("정확한 계좌번호를 입력해주세요.");
			f.bankNumber.focus();
			return false;
		}
		if(!chkNull(f.bankOwner, "예금주를 입력해 주세요")) return false;

		$.ajax({
			type: "POST"
			,async : false
      ,url: "/common/ajax_bankCheck.asp"
			,data: {
				"bankCode" : f.bankCode.value,
				"bankNumber" : f.bankNumber.value
			}
			,success: function(jsonData) {
				//console.log(jsonData);
				var json = $.parseJSON(jsonData);

				if (json.result == "success")	{
					if (json.emailCheck == "T") {
						alertTxt(json.message, "#bankCheckTXT", "T");
						$("input[name=bankCheck]").val("T");
						$("input[name=bankCodeCHK]").val($("select[name=bankCode]").val());
						$("input[name=bankNumberCHK]").val($("input[name=bankNumber]").val());
					}else{
						alertTxt(json.message, "#bankCheckTXT", "F");
						$("input[name=bankCheck]").val("F");
						$("input[name=bankCodeCHK]").val("");
						$("input[name=bankNumberCHK]").val("");
					}
				}
			}
			,error:function(jsonData) {
				alert("<%=LNG_AJAX_ERROR_MSG%> "+jsonData.status+" "+jsonData.statusText+" "+jsonData.responseText);
			}
		});
	}

	function join_MobileCheck() {
		var f = document.cfrm;

		if (chkEmpty(f.strMobile)) {
			alert2("<%=LNG_JS_MOBILE%>", "#mobileCheckTXT", "F");
			f.strMobile.focus();
			return false;
		}
		if (!chkMob(f.strMobile.value)) {
			alert2("<%=LNG_JS_MOBILE_FORM_CHECK%>", "#mobileCheckTXT", "F");
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
				alert("<%=LNG_AJAX_ERROR_MSG%> "+jsonData.status+" "+jsonData.statusText+" "+jsonData.responseText);
			}
		});

	}

	function join_emailCheck() {
		var f = document.cfrm;
		if (f.strEmail.value == '')
		{
			alert2("<%=LNG_JS_EMAIL%>", "#emailCheckTXT", "F");
			f.strEmail.focus();
			return false;
		}
		if (!checkEmail(f.strEmail.value)) {
			alert2("<%=LNG_JS_EMAIL_CONFIRM%>", "#emailCheckTXT", "F");
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
			//alert("<%=LNG_JS_ID%>");
			alert2("<%=LNG_JS_ID%>", "#idCheck", "F");
			return false;
		}
		/*
		if (/(\w)\1\1/.test(ids.value)){
			alert("<%=LNG_JS_ID_FORM_CHECK_01%>");
			//alert("동일 숫자나 영문은 3번이상 연속으로 사용할 수 없습니다.");
			return false;
		}
		if (ids.value.search('te')>-1 || ids.value.search('TE')>-1) {
			alert("<%=LNG_JS_ID_FORM_CHECK_02%>");
			//alert('아이디에 te는 포함할 수 없습니다.')
			return false;
		}
		*/
		if (!checkID(ids.value.trim(), 4, 20)){
			alert2("<%=LNG_JS_ID_FORM_CHECK%>", "#idCheck", "F");
			ids.focus();
			return false;
		}
		createRequest();
		var url = '/common/ajax_idcheck.asp?ids='+ids.value;			//PC공통
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

	//SSN check
	function join_SSNcheck() {
		var ids = document.cfrm.strSSH;
		if (ids.value == '')
		{
			alert("<%=LNG_JOINSTEP03_U_JS30%>");
			ids.focus();
			return false;
		}
		if (ids.value.stripspace().length < 9) {
			alert("<%=LNG_JOINSTEP03_U_JS29%>");
			ids.focus();
			return false;
		}
		createRequest();
		var url = '/common/ajax_SSNcheck.asp?ids='+ids.value;
		request.open("GET",url,true);
		request.onreadystatechange = function ChgContent() {
			if(request.readyState == 4){    // 요청응답상태가 4인지 확인해주고
				if(request.status == 200){     // HTTP상태가 완료인지 체크해줍니다.
					var newContent = request.responseText;
					document.getElementById("SSNCheck").innerHTML = newContent;
				}
			}
		}
		request.send(null);
	}


	function openzip() {
		openPopup("/m/common/pop_Zipcode.asp", "Zipcodes");
	}
	function vote_idcheck() {
		openPopup("/m/common/pop_voter.asp", "vote_idcheck");
	}
	function spon_idcheck() {
		openPopup("/m/common/pop_sponsor.asp", "spon_idcheck");
	}
	function family_idcheck() {
		openPopup("/m/common/pop_family.asp", "pop_family");
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
		if (f.agree01.value != 'T')
		{
			alert("<%=LNG_JS_POLICY01%>");
			document.location.href = '/common/joinStep01.asp';
			return false;
		}
		if (f.agree02.value != 'T')
		{
			alert("<%=LNG_JS_POLICY02%>");
			document.location.href = '/common/joinStep01.asp';
			return false;
		}
		<%If S_SellMemTF = 0 Then%>
			if (f.agree03.value != 'T')
			{
				alert("<%=LNG_JS_POLICY03%>");
				document.location.href = '/common/joinStep01.asp';
				return false;
			}
		<%End If%>

		<%If UCase(Lang) <> "KR" Then%>
			/*
			//한국 외 국가 도시선택
			if (chkEmpty(f.CityCode)) {
				alert("<%=LNG_JOIN_SELECT_CITY%>");
				f.CityCode.focus();
				return false;
			}
			*/

			//개인식별번호 필수
			if (f.strSSH.value == "")
			{
				alert("<%=LNG_JOINSTEP03_U_JS30%>");
				f.strSSH.focus();
				return false;
			} else {

				if (f.strSSH.value != "")
				{
					if (f.strSSH.value.stripspace().length < 9) {
						alert("<%=LNG_JOINSTEP03_U_JS29%>");
						f.strSSH.focus();
						return false;
					}
					if (f.SSNcheck.value == 'F'){
						alert("<%=LNG_JOINSTEP03_U_JS31%>");
						f.strSSH.focus();
						return false;
					}
					if (f.strSSH.value != f.chkSSN.value){
						alert2("<%=LNG_JOINSTEP03_U_JS32%>", "#SSNCheck", "F");
						f.strSSH.focus();
						return false;
					}
				}
			}
			//여권번호 선택입력
			/*
			if (f.Passport_Number.value != "")
			{
				if (f.Passport_Number.value.stripspace().length < 9) {
					alert("<%=LNG_JS_PASSPORT_NUMBER_CORRECTLY%>");
					f.Passport_Number.focus();
					return false;
				}
				if (f.Passport_Numbercheck.value == 'F'){
					alert("<%=LNG_JS_PASSPORT_NUMBER_AVAILE%>");
					f.Passport_Number.focus();
					return false;
				}
				if (f.Passport_Number.value != f.chkPassport_Number.value){
					alert("<%=LNG_JS_PASSPORT_NUMBER_CHANGED%>");
					$("#Passport_Numbercheck").text("<%=LNG_JS_DUPLICATION_CHECK%>").css({"color":"red","font-weight":"bold"});
					f.Passport_Number.focus();
					return false;
				}
			}
			*/

		<%
		End If
		%>

		//영문이름 / 성 추가(2018-06-28)  선택(2018-12-17~)
		/*
		if (chkEmpty(f.E_name)) {
			alert("<%=LNG_JS_FAMILY_NAME%> [<%=LNG_TEXT_ENGLISH_LETTER%>]");
			f.E_name.focus();
			return false;
		}
		if (chkEmpty(f.E_name_Last)) {
			alert("<%=LNG_JS_GIVEN_NAME%> [<%=LNG_TEXT_ENGLISH_LETTER%>]");
			f.E_name_Last.focus();
			return false;
		}
		*/
		if (chkEmpty(f.Na_Code)) {
			alert("<%=LNG_SUBTITLE_SELECT_NATION_STITLE%>");
			f.Na_Code.focus();
			return false;
		}

		<%If CS_AUTO_WEBID_TF <> "T" Then%>
			<%If snsToken = "" Then%>

				if (f.strID.value == "")
				{
					alert2("<%=LNG_JS_ID%>", "#idCheck", "F");
					f.strID.focus();
					return false;
				} else {
					/*
					if (/(\w)\1\1/.test(f.strID.value)){
						alert("<%=LNG_JS_ID_FORM_CHECK_01%>");
						//alert("동일 숫자나 영문은 3번이상 연속으로 사용할 수 없습니다.");
						return false;
					}
					if (f.strID.value.search('te')>-1 || f.strID.value.search('TE')>-1) {
						alert("<%=LNG_JS_ID_FORM_CHECK_02%>");
						//alert('아이디에 te는 포함할 수 없습니다.')
						return false;
					}
					*/
					if (!checkID(f.strID.value, 4, 20)){
						alert2("<%=LNG_JS_ID_FORM_CHECK%>", "#idCheck", "F");
						f.strID.focus();
						return false;
					}
					if (f.idcheck.value == 'F'){
						alert2("<%=LNG_JS_ID_DOUBLE_CHECK%>", "#idCheck", "F");
						f.strID.focus();
						return false;
					}
					if (f.strID.value != f.chkID.value){
						alert2("<%=LNG_JS_ID_DOUBLE_CHECK2%>", "#idCheck", "F");
						f.strID.focus();
						return false;
					}
				}

			<%End IF%>
		<%End IF%>

		<%If snsToken = "" Then%>
			if (chkEmpty(f.strPass)) {
				alert("<%=LNG_JS_PASSWORD%>");
				f.strPass.focus();
				return false;
			}
			if (!checkPass(f.strPass.value, 6, 20) || !checkEngNum(f.strPass.value)){
				alert("<%=LNG_JS_PASSWORD_FORM_CHECK%>");
				f.strPass.focus();
				return false;
			}
			<%If CS_AUTO_WEBID_TF <> "T" Then%>
			if (f.idcheck.value == f.strPass.value){
				alert("<%=LNG_JS_PASSWORD_FORM_CHECK2%>");
				f.strPass.focus();
				return false;
			}
			<%End IF%>
			if (chkEmpty(f.strPass2)) {
				alert("<%=LNG_JS_PASSWORD_CONFIRM%>");
				f.strPass2.focus();
				return false;
			}
			if (f.strPass.value != f.strPass2.value){
				alert("<%=LNG_JS_PASSWORD_CHECK%>");
				f.strPass2.focus();
				return false;
			}
		<%End If%>

		<%If CENTER_SELECT_TF = "T" Then%>
			if (chkEmpty(f.businessCode)) {
				alert("<%=LNG_JS_CENTER%>");
				f.businessCode.focus();
				return false;
			}
		<%End IF%>

		<%IF S_SellMemTF = 0 Then%>
		if (f.NominCom.value == 'F') {
			if (chkEmpty(f.voter) || chkEmpty(f.NominID1) || chkEmpty(f.NominID2) || f.NominChk.value == 'F') {
				alert("<%=LNG_JS_VOTER%>");
				$("#popVoter").click();
				f.voter.focus();
				return false;
			}
		}
		<%End IF%>

		<%if 1 = 2 then%>
		if (chkEmpty(f.sponsor) || chkEmpty(f.SponID1) || chkEmpty(f.SponID2) || f.SponIDChk.value == 'F') {
			alert("<%=LNG_JS_SPONSOR%>");
			$("#popSponsor").click();
			f.sponsor.focus();
			return false;
		}
		<%End IF%>

		<%If S_SellMemTF = 0 Then 'COSMICO 판매원 계좌정보%>
			//if (f.bankCode.value != "" || f.bankNumber.value != "" ) {
				if (f.bankCheck.value != "T") {
					alert("계좌번호 중복체크를 해주세요.")
					f.bankCode.focus();
					return false;
				} else {
					if (f.bankCode.value != f.bankCodeCHK.value || f.bankNumber.value != f.bankNumberCHK.value) {
						alert("계좌번호 중복체크 입력정보가 변경되었습니다. 중복체크를 다시 해주세요.");
						$("#bankCheckTXT").text("본인인증시의 입력정보와 현재 입력된 정보가 틀립니다");
						f.bankCode.focus();
						return false;
					}
				}
			//}
		<%End if%>

		<%If NICE_BANK_CONFIRM_TF = "T" Then%>		//'계좌인증 사용 시
			if (f.ajaxTF.value != "T") {
				alert("계좌 본인인증을 해주세요.")
				f.bankCode.focus();
				return false;
			} else {

				if (f.strBankCodeCHK.value != f.bankCode.value || f.strBankNumCHK.value != f.bankNumber.value || f.strBankOwnerCHK.value != f.bankOwner.value || f.birthYYCHK.value != f.birthYY.value || f.birthMMCHK.value != f.birthMM.value || f.birthDDCHK.value != f.birthDD.value)
				{
					alert("본인인증시의 입력정보와 현재 입력된 정보가 틀립니다. 본인인증을 다시 해주세요.");
					$("#result_text").text("본인인증시의 입력정보와 현재 입력된 정보가 틀립니다").addClass("red2").removeClass("blue2");
					f.bankCode.focus();
					return false;
				}
			}
		<%End If%>

		<%IF S_SellMemTF = 0 Then		'COSMICO%>
			if (chkEmpty(f.strZip) || chkEmpty(f.strADDR1)) {
				alert("<%=LNG_JS_ADDRESS1%>");
				$("#pop_postcode").click();
				f.strADDR1.focus();
				return false;
			}
			if (chkEmpty(f.strADDR2)) {
				alert("<%=LNG_JS_ADDRESS2%>");
				f.strADDR2.focus();
				return false;
			}
		<%End If%>


		if (chkEmpty(f.strMobile)) {
			<%IF S_SellMemTF = 0 Then		'COSMICO%>
				alert2("<%=LNG_JS_MOBILE%>", "#mobileCheckTXT", "F");
				f.strMobile.focus();
				return false;
			<%End If%>
		} else {
			<%If UCase(Lang) = "KR" Then%>
				if (!chkMob(f.strMobile.value)) {
					alert2("<%=LNG_JS_MOBILE_FORM_CHECK%>", "#mobileCheckTXT", "F");
					f.strMobile.focus();
					return false;
				}
			<%Else%>
				if (f.strMobile.value.length < 10) {
					alert2("<%=LNG_JS_MOBILE_FORM_CHECK%>", "#mobileCheckTXT", "F");
					f.strMobile.focus();
					return false;
				}
			<%End If%>

			<%If NICE_MOBILE_CONFIRM_TF <> "T" And DKRSM_sMobileNo = "" Then%>
				if (f.mobileCheck.value == 'F'){
					alert2("<%=LNG_JS_MOBILE_DOUBLE_CHECK%>", "#mobileCheckTXT", "F");
					f.strMobile.focus();
					return false;
				}
				if (f.strMobile.value != f.chkMobile.value){
					alert2("<%=LNG_JS_MOBILE_DOUBLE_CHECK2%>", "#mobileCheckTXT", "F");
					$("input[name=mobileCheck]").val("F");
					f.strMobile.focus();
					return false;
				}
			<%End If%>
		}

		<%If snsToken = "" Then%>
			if (!chkEmpty(f.strTel)) {
				if (!chkTel(f.strTel.value)) {
					alert2("정확한 전화번호를 입력해 주세요", "#mobileCheckTXT", "F");
					f.strTel.focus();
					return false;
				}
			}
		<%End If%>

		if (f.strEmail.value == "") {
			<%IF S_SellMemTF = 0 Then		'COSMICO 이메일 선택%>
				/*
				alert2("<%=LNG_JS_EMAIL%>", "#emailCheckTXT", "F");
				f.strEmail.focus();
				return false;
				*/
			<%End If%>
		} else {

			if (!checkEmail(f.strEmail.value)) {
				alert2("<%=LNG_JS_EMAIL_CONFIRM%>", "#emailCheckTXT", "F");
				f.strEmail.focus();
				return false;
			}
			if (f.emailCheck.value == 'F'){
				alert2("<%=LNG_JS_EMAIL_DOUBLE_CHECK%>", "#emailCheckTXT", "F");
				f.strEmail.focus();
				return false;
			}
			if (f.strEmail.value != f.chkEmail.value){
				alert2("<%=LNG_JS_EMAIL_DOUBLE_CHECK2%>", "#emailCheckTXT", "F");
				f.strEmail.focus();
				return false;
			}

		}

		if (chkEmpty(f.birthYY) || chkEmpty(f.birthMM) || chkEmpty(f.birthDD)) {
			alert("<%=LNG_JS_BIRTH%>");
			f.birthYY.focus();
			return false;
		}

		if (confirm("<%=LNG_JOINSTEP03_U_STITLE04%>")) {
			f.target = "_self";
			return;
		} else {
			return false;
		}
	}

	function RefreshImage(valImageId) {
		var objImage = document.getElementById(valImageId)
		if (objImage == undefined) {
			return;
		}
		var now = new Date();
		objImage.src = objImage.src.split('?')[0] + '?x=' + now.toUTCString();
	}


	function vote_company() {
		document.cfrm.NominCom.value = 'T';
		document.cfrm.NominID1.value = '';
		document.cfrm.NominID2.value = '';
		document.cfrm.NominWebID.value = '';
		document.cfrm.voter.value = '없음';
		document.cfrm.NominChk.value = 'F';
	}
	function vote_cancel() {
		document.cfrm.NominID1.value = '';
		document.cfrm.NominID2.value = '';
		document.cfrm.NominWebID.value = '';
		document.cfrm.voter.value = '';
		document.cfrm.NominChk.value = 'F';
	}
	function spon_company()	{
		document.cfrm.SponID1.value = '**';
		document.cfrm.SponID2.value = 0;
		document.cfrm.SponIDWebID.value = 'admin';
		document.cfrm.sponsor.value = '본사';
		document.cfrm.SponIDChk.value = 'T';
	}
	function spon_cancel()
	{
		document.cfrm.SponID1.value = '';
		document.cfrm.SponID2.value = '';
		document.cfrm.SponIDWebID.value = '';
		document.cfrm.sponsor.value = '';
		document.cfrm.SponIDChk.value = 'F';
	}

	//계좌인증
	function ajax_accountChk() {
		var f = document.cfrm;
		if(!chkNull(f.bankCode, "은행을 선택해 주세요")) return false;
		if(!chkNull(f.bankNumber, "계좌번호를 입력해 주세요")) return false;
		if(!chkNull(f.bankOwner, "예금주를 입력해 주세요")) return false;
		if (chkEmpty(f.birthYY) || chkEmpty(f.birthMM) || chkEmpty(f.birthDD)) {
			alert("생년월일을 입력해 주세요.");
			f.birthYY.focus();
			return;
		}
		if (!checkMinorBirth(f.birthYY, f.birthMM , f.birthDD)) return;		// 미성년자체크(생년월일)

		$.ajax({
			type: "POST"
			,url: "/common/ajax_Bank_Confirm.asp"
			,data: {
				"birthYY"		: f.birthYY.value
				,"birthMM"		: f.birthMM.value
				,"birthDD"		: f.birthDD.value
				,"strBankCode"	: f.bankCode.value
				,"strBankNum"	: f.bankNumber.value
				,"strBankOwner"	: f.M_Name_Last.value+f.M_Name_First.value
				,"M_Name_First"	: f.M_Name_First.value
				,"M_Name_Last"	: f.M_Name_Last.value
			}
			,success: function(data) {
				var obj = $.parseJSON(data);
				alert(obj.message);
				if (obj.statusCode == '0000')	{
					$("#result_text").text(obj.message).addClass("blue2").removeClass("red2");
					$("input[name=strBankCodeCHK").val(obj.strBankCodeCHK)
					$("input[name=strBankNumCHK").val(obj.strBankNumCHK)
					$("input[name=strBankOwnerCHK").val(obj.strBankOwnerCHK)
					$("input[name=birthYYCHK").val(obj.birthYYCHK)
					$("input[name=birthMMCHK").val(obj.birthMMCHK)
					$("input[name=birthDDCHK").val(obj.birthDDCHK)
					$("input[name=TempDataNum").val(obj.TempDataNum)
					$("input[name=ajaxTF").val("T")
				} else {
					$("#result_text").text(obj.message).addClass("red2").removeClass("blue2");
					$("input[name=ajaxTF").val("F")
				}
			}
			,error:function(data) {
				var obj = $.parseJSON(data);
				alert(obj.message);
			}
		});

	}

</script>
