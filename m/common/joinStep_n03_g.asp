<!--#include virtual = "/_lib/strFunc.asp"-->
<!--#include virtual="/_lib/md5.asp" -->
<%
	PAGE_SETTING = "JOIN"
	view = 3
	sview = 1
	ISSUBTOP = "T"

	IS_LANGUAGESELECT = "F"
	NO_MEMBER_REDIRECT = "F"

	If DK_MEMBER_LEVEL > 0 Then Response.Redirect "/index.asp"

	'▣판매원,소비자 통합
	S_SellMemTF = pRequestTF("S_SellMemTF",True)
	sns_authID = pRequestTF("sns_authID",False) : If sns_authID = "" Then sns_authID = ""

	CENTER_SELECT_TF = "T"		'센터선택 기본값
	Select Case S_SellMemTF
		Case 0
			If NICE_MOBILE_CONFIRM_TF = "T" OR NICE_BANK_CONFIRM_TF = "T" Then Call ALERTS(LNG_MEMBER_LOGINOK_ALERT02,"BACK","")
			sview = 2
			LNG_TEXT_BUSINESS_MEMBER = LNG_TEXT_BUSINESS_MEMBER
			IF CS_NOMIN_CENTER_0_TF = "T" Then CENTER_SELECT_TF = "F"
		Case 1
			sview = 1
			LNG_TEXT_BUSINESS_MEMBER = LNG_TEXT_NORMAL_MEMBER
			IF CS_NOMIN_CENTER_1_TF = "T" Then CENTER_SELECT_TF = "F"
		Case Else
			Call ALERTS(LNG_MEMBER_LOGINOK_ALERT02,"BACK","")
	End Select


'	Select Case UCase(LANG)
'		Case "KR","MN"
			If Not checkRef(houUrl &"/m/common/joinStep_n02_g.asp") Then Call alerts(LNG_ALERT_WRONG_ACCESS,"go","/m/common/joinStep01.asp")
'		Case Else
'			Call alerts(LNG_ALERT_WRONG_ACCESS,"back","")
'	End Select


	strName		 = Trim(pRequestTF("name",True))
	M_Name_Last	 = Trim(pRequestTF("M_Name_Last",True))		'성
	M_Name_First = Trim(pRequestTF("M_Name_First",True))	'이름
	For_Kind_TF  = Trim(pRequestTF("For_Kind_TF",True))

	birthYY	= Trim(pRequestTF("birthYY",True))
	birthMM	= Trim(pRequestTF("birthMM",True))
	birthDD	= Trim(pRequestTF("birthDD",True))
	'strSSH1 = Trim(pRequestTF("ssh1",True))
	'strSSH2 = Trim(pRequestTF("ssh2",True))
	strSSH1  = Right(birthYY,2)&birthMM&birthDD
	strSSH2  = "0000000"

	If UCase(Lang) = "KR" Then
		strName		= Replace(strName," ","")			'KR 이름공백제거
	End If
	M_Name_First	= Replace(M_Name_First," ","")		'KR 이름
	M_Name_Last		= Replace(M_Name_Last," ","")		'KR 성

	agreement = pRequestTF("agreement",False)
	gather = pRequestTF("gather",False)
	company = pRequestTF("company",False)

	If agreement = "" Then agreement = "F"
	If gather = "" Then gather = "F"

	agreement = "T"
	gather	  = "T"
	company	  = "T"

	If agreement <> "T" Then Call ALERTS(LNG_JS_POLICY01,"back","")
	If gather <> "T" Then Call ALERTS(LNG_JS_POLICY02,"back","")
	If company <> "T" Then Call ALERTS(LNG_JS_POLICY03,"back","")

	'주민번호 암호화입력

	Set objEncrypter = Server.CreateObject("Hyeongryeol.StringEncrypter")
		objEncrypter.Key = con_EncryptKey
		objEncrypter.InitialVector = con_EncryptKeyIV
		If strSSH1		<> "" Then Enc_strSSH1		= objEncrypter.Encrypt(strSSH1)
		If strSSH2		<> "" Then Enc_strSSH2		= objEncrypter.Encrypt(strSSH2)
	Set objEncrypter = Nothing


	Set XTEncrypt = new XTclsEncrypt
	'RChar = XTEncrypt.MD5(RandomChar(10))
	RChar = makeMemTempNum&RandomChar(10)

	'▣DKP_MEMBER_JOIN_TEMP 확인!
	arrParams = Array(_
		Db.makeParam("@strName",adVarWChar,adParamInput,100,strName),_
		Db.makeParam("@strSSH1",adVarChar,adParamInput,50,Enc_strSSH1),_
		Db.makeParam("@strSSH2",adVarChar,adParamInput,50,Enc_strSSH2),_
		Db.makeParam("@TempDataNum",adVarChar,adParamInput,50,RChar),_
		Db.makeParam("@M_Name_First",adVarWChar,adParamInput,20,M_Name_First),_
		Db.makeParam("@M_Name_Last",adVarWChar,adParamInput,20,M_Name_Last),_
		Db.makeParam("@Idnum",adInteger,adParamOutput,0,0) _
	)
	Call Db.exec("HJP_MEMBER_JOIN_TEMP",DB_PROC,arrParams,DB3)
	'Call Db.exec("DKP_MEMBER_JOIN_TEMP",DB_PROC,arrParams,DB3)


	If DK_MEMBER_VOTER <> "" Then
		arrParams = Array(_
			Db.makeParam("@strUserID",adVarChar,adParamInput,20,DK_MEMBER_VOTER) _
		)
		VOTERCHK = Db.execRsData("DKP_JOIN_VOTER_CHK",DB_PROC,arrParams,Nothing)
		If VOTERCHK > 0 Then
			LINKVOTER = "T"
		End If
	End If



	If DK_MEMBER_VOTER_ID <> "" Then
		Set objEncrypter = Server.CreateObject ("Hyeongryeol.StringEncrypter")
			objEncrypter.Key = con_EncryptKey
			objEncrypter.InitialVector = con_EncryptKeyIV
			'DK_MEMBER_VOTER_ID	 = objEncrypter.Encrypt(DK_MEMBER_VOTER_ID)


		SQLVI = "SELECT [MBID],[MBID2],[M_NAME],[WebID] FROM [tbl_MemberInfo] WHERE [webID] = ? "
		arrParamsVI = Array(_
			Db.makeParam("@WebID",adVarWChar,adParamInput,100,DK_MEMBER_VOTER_ID) _
		)
		Set DKRSVI = Db.execRs(SQLVI,DB_TEXT,arrParamsVI,DB3)
		If Not DKRSVI.BOF And Not DKRSVI.EOF Then
			DKRSVI_MBID1		= DKRSVI("MBID")
			DKRSVI_MBID2		= DKRSVI("MBID2")
			DKRSVI_MNAME		= DKRSVI("M_NAME")
			DKRSVI_CHECK		= "T"
			DKRSVI_WEBID		= DKRSVI("WebID")
			'DKRSVI_WEBID		= objEncrypter.DEcrypt(DKRSVI_WEBID)
		Else
			DKRSVI_MBID1		= ""
			DKRSVI_MBID2		= ""
			DKRSVI_MNAME		= ""
			DKRSVI_CHECK		= "F"
			DKRSVI_WEBID		= ""
		End If

		Set objEncrypter = Nothing
	End If


	Select Case Left(strSSH2,1)
		Case "1"
			birthYY = "19"
			isSex = "M"
		Case "2"
			birthYY = "19"
			isSex = "F"
		Case "3"
			birthYY = "20"
			isSex = "M"
		Case "4"
			birthYY = "20"
			isSex = "F"
	End Select

'	birthYYYY = birthYY & Left(strSSH1,2)
'	birthMM = Mid(strSSH1,3,2)
'	birthDD = Right(strSSH1,2)
	birthYYYY = birthYY
	birthMM = birthMM
	birthDD = birthDD

	'국가정보
	R_NationCode = Trim(pRequestTF("cnd",True))
	arrParams = Array(_
		Db.makeParam("@nationCode",adVarChar,adParamInput,20,R_NationCode) _
	)
	Set DKRS = Db.execRs("DKP_MEMBER_JOIN_CHK_NATION",DB_PROC,arrParams,DB3)
	If Not DKRS.BOF And Not DKRS.EOF Then
		DKRS_nationNameEn	= DKRS("nationNameEn")
		DKRS_nationCode		= DKRS("nationCode")
		DKRS_className		= DKRS("className")
	Else
		Call ALERTS("We are sorry. The country code is not valid.","back","")
	End If

	'회원구분
	Select Case For_Kind_TF
		Case "0"
			For_Kind_TF_TEXT = LNG_JOIN_LOCAL
		Case "1"
			For_Kind_TF_TEXT = LNG_JOIN_FOREIGNER
		Case "2"
			For_Kind_TF_TEXT = LNG_JOIN_BUISNESSMAN

			If UCase(Lang) = "KR" Then 	Call alerts(LNG_ALERT_WRONG_ACCESS,"back","")	'한국회원 법인사업자 등록 불가
	End Select
%>
<!--#include virtual = "/m/_include/document.asp"-->
<!--#include virtual = "/m/_include/jqueryload.asp"-->

<link rel="stylesheet" href="/m/js/icheck/skin/line/_all.css" />
<script type="text/javascript" src="/m/js/check.js"></script>
<script src="/m/js/icheck/icheck.min.js"></script>
<!-- <script type="text/javascript" src="joinStep03_c.js"></script> -->
<script type="text/javascript">

	$(document).ready(function(){
		<%If DK_MEMBER_VOTER_ID = "" Then%>
			$("input[name=voter]").val("");
		<%End IF%>
		$("input[name=sponsor]").val("");
	});

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

	//여권번호 중복체크
	/*
	function join_Passport_Numbercheck() {
		var ids = document.cfrm.Passport_Number;
		if (ids.value == '')
		{
			alert("<%=LNG_JS_PASSPORT_NUMBER%>");
			ids.focus();
			return false;
		}
		if (ids.value.stripspace().length < 9) {
			alert("<%=LNG_JS_PASSPORT_NUMBER_CORRECTLY%>.");
			ids.focus();
			return false;
		}
		createRequest();
		var url = '/common/ajax_Passport_Numbercheck.asp?ids='+ids.value;
		request.open("GET",url,true);
		request.onreadystatechange = function ChgContent() {
			if(request.readyState == 4){    // 요청응답상태가 4인지 확인해주고
				if(request.status == 200){     // HTTP상태가 완료인지 체크해줍니다.
					var newContent = request.responseText;
					document.getElementById("Passport_Numbercheck").innerHTML = newContent;
				}
			}
		}
		request.send(null);
	}
	*/

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
		if (f.agreement.value != 'T')
		{
			alert("<%=LNG_JS_POLICY01%>");
			document.location.href = '/common/joinStep01.asp';
			return false;
		}
		if (f.gather.value != 'T')
		{
			alert("<%=LNG_JS_POLICY02%>");
			document.location.href = '/common/joinStep01.asp';
			return false;
		}
	<%If S_SellMemTF = 0 Then%>
		if (f.company.value != 'T')
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

		<%If CENTER_SELECT_TF = "T" Then%>
			if (chkEmpty(f.businessCode)) {
				alert("<%=LNG_JS_CENTER%>");
				f.businessCode.focus();
				return false;
			}
		<%End IF%>

		<%IF S_SellMemTF = 0 Then%>
		if (f.NominCom.value == 'F')
		{
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
		if (chkEmpty(f.strMobile)) {
			alert("<%=LNG_JS_MOBILE%>");
			f.strMobile.focus();
			return false;
		} else {
			if (!chkMob(f.strMobile.value)) {
				alert2("<%=LNG_JS_MOBILE_FORM_CHECK%>", "#mobileCheckTXT", "F");
				f.strMobile.focus();
				return false;
			}
			if (f.mobileCheck.value == 'F'){
				alert2("<%=LNG_JS_MOBILE_DOUBLE_CHECK%>", "#mobileCheckTXT", "F");
				f.strMobile.focus();
				return false;
			}
			if (f.strMobile.value != f.chkMobile.value){
				alert("<%=LNG_JS_MOBILE_DOUBLE_CHECK2%>");
				alert2("<%=LNG_JS_MOBILE_DOUBLE_CHECK2%>", "#mobileCheckTXT", "F");
				$("input[name=mobileCheck]").val("F");
				f.strMobile.focus();
				return false;
			}
		}
		<%If UCase(Lang) = "KR" Then%>
			if (!chkMob(f.strMobile.value)) {
				alert2("<%=LNG_JS_MOBILE_FORM_CHECK%>", "#mobileCheckTXT", "F");
				f.strMobile.focus();
				return false;
			}
			if (!chkEmpty(f.strTel)) {
				if (!chkTel(f.strTel.value)) {
					alert2("정확한 전화번호를 입력해 주세요", "#mobileCheckTXT", "F");
					f.strTel.focus();
					return false;
				}
			}
		<%Else%>
			if (f.strMobile.value.length < 10) {
				alert2("<%=LNG_JS_MOBILE_FORM_CHECK%>", "#mobileCheckTXT", "F");
				f.strMobile.focus();
				return false;
			}
		<%End If%>

		if (f.strEmail.value == "")
		{
			alert2("<%=LNG_JS_EMAIL%>", "#emailCheckTXT", "F");
			f.strEmail.focus();
			return false;

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


/*
	function vote_company()
	{
		document.cfrm.NominID1.value = '**';
		document.cfrm.NominID2.value = 0;
		document.cfrm.NominWebID.value = 'admin';
		document.cfrm.voter.value = '본사';
		document.cfrm.NominChk.value = 'T';
	}
*/

	function vote_company()
	{
		document.cfrm.NominCom.value = 'T';
		document.cfrm.NominID1.value = '';
		document.cfrm.NominID2.value = '';
		document.cfrm.NominWebID.value = '';
		document.cfrm.voter.value = '없음';
		document.cfrm.NominChk.value = 'F';
	}
	function vote_cancel()
	{
		document.cfrm.NominID1.value = '';
		document.cfrm.NominID2.value = '';
		document.cfrm.NominWebID.value = '';
		document.cfrm.voter.value = '';
		document.cfrm.NominChk.value = 'F';
	}
	function spon_company()
	{
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

</script>

</head>
<body onunload="">
<!--#include virtual = "/m/_include/header.asp"-->
<div id="join03" class="joinstep">
	<form name="cfrm" method="post" action="joinFinish_g.asp" onsubmit="return chkSubmit(this);">
		<input type="hidden" name="S_SellMemTF" value="<%=S_SellMemTF%>" readonly />
		<input type="hidden" name="cnd" value="<%=R_NationCode%>" readonly />
		<input type="hidden" name="agreement" value="<%=agreement%>" />
		<input type="hidden" name="gather" value="<%=gather%>" />
		<input type="hidden" name="company" value="<%=company%>" />

		<input type="hidden" name="SponID1" value="" readonly="readonly" />
		<input type="hidden" name="SponID2" value="" readonly="readonly" />
		<input type="hidden" name="SponIDWebID" value="" readonly="readonly" />
		<input type="hidden" name="SponIDChk" value="F" readonly="readonly" />
		<input type="hidden" name="dataNum" value="<%=RChar%>" readonly="readonly" />
		<input type="hidden" name="joinType" value="COMPANY" readonly="readonly" />
		<input type="hidden" name="sns_authID" value="<%=sns_authID%>" readonly="readonly" />

		<input type="hidden" name="For_Kind_TF" value="<%=For_Kind_TF%>" readonly="readonly" />

		<input type="hidden" name="NominCom" value="F" readonly="readonly" />

		<%If DKRSVI_WEBID = "" Then%>
			<input type="hidden" name="NominID1" value="" readonly="readonly" />
			<input type="hidden" name="NominID2" value="" readonly="readonly" />
			<input type="hidden" name="NominWebID" value="" readonly="readonly" />
			<input type="hidden" name="NominChk" value="" readonly="readonly" />
		<%Else%>
			<input type="hidden" name="NominID1" value="<%=DKRSVI_MBID1%>" readonly="readonly" />
			<input type="hidden" name="NominID2" value="<%=DKRSVI_MBID2%>" readonly="readonly" />
			<input type="hidden" name="NominWebID" value="<%=DKRSVI_WEBID%>" readonly="readonly" />
			<input type="hidden" name="NominChk" value="<%=DKRSVI_CHECK%>" readonly="readonly" />
		<%End If%>
			<input type="hidden" name="Ho_Mbid" value="" readonly="readonly" />
			<input type="hidden" name="Ho_Mbid2" value="" readonly="readonly" />
			<input type="hidden" name="Ho_WebID" value="" readonly="readonly" />
			<input type="hidden" name="Ho_Chk" value="" readonly="readonly" />

		<div class="wrap">
			<h6><%=LNG_TEXT_MEMBER_BASIC_INFO%></h6>
			<table <%=tableatt%>>
				<col width="80" />
				<col width="*" />

				<input type="hidden" name="Na_Code" value="KR" readonly="readonly" /><%'한국회원만%>
				<!-- <tr class="line">
					<th><%=LNG_SUBTITLE_SELECT_NATION%>&nbsp;<%=starText%></th>
					<td>
						<select name="Na_Code" style="" class="input_select" onchange="insertThisValue2(this);">
							<option value="">::: <%=LNG_SUBTITLE_SELECT_NATION%> :::</option>
							<%
								SQL = "SELECT * FROM [DK_NATION] WITH(NOLOCK) WHERE [Using] = 1 ORDER By [intIDX] ASC "
								arrList = Db.execRsList(SQL,DB_TEXT,Nothing,listLen,DB3)
								If IsArray(arrLisT) Then
									PrevFirstName = "A"
									For i = 0 To listLen
										arr_intIDX			= arrList(0,i)
										arr_nationNameKo	= arrList(1,i)
										arr_nationNameEn	= arrList(2,i)
										arr_nationCode		= arrList(3,i)
										arr_isUse			= arrList(4,i)
										arr_className		= arrList(5,i)

										PRINT TABS(5)& "	<option value="""&arr_nationCode&""" >["&arr_nationCode&"] - "&arr_nationNameEn&" ("&arr_nationNameKo&")&nbsp;&nbsp;&nbsp;</option>"
									Next
								Else
									PRINT TABS(5)& "	<option value="""">No data registed</option>"
								End If
							%>
						</select>
					</td>
				</tr> -->
				<!-- <tr class="line">
					<th>Country Code</th>
					<td><strong>[<%=DKRS_nationCode%>] <%=DKRS_nationNameEn%></strong><br /><span class="">(The country code is based on ISO 3166-1 alpha-2 codes)</span></td>
				</tr> -->
				<%If UCase(Lang) <> "KR" Then	'▣한국외 도시선택%>
					<!-- <tr>
						<th><%=LNG_SUBTITLE_SELECT_CITY%>&nbsp;<%=starText%></th>
						<td>
							<select name="CityCode" style="" class="input_select">
								<option value="">::: <%=LNG_JOIN_SELECT_CITY%> :::</option>
							</select>
						</td>
					</tr> -->
					<tr>
						<th><%=LNG_TEXT_CPNO%>&nbsp;<%=starText_CPNO%></th>
						<td>
							<div style="width:57%;"><input type="text" name="strSSH" class="imes input_text width95a" maxlength="13" onkeyup="javascript:this.value = this.value.toUpperCase();" /></div><div class="tcenter" style="width:3%;"></div><div style="width:40%;"><input type="button" name="" onclick="join_SSNcheck();" class="input_btn width95a" value="<%=LNG_TEXT_DOUBLE_CHECK%>" /></div>
							<div id="SSNCheck" class="summary" style="padding-top:4px;">
								<input type="hidden" name="SSNcheck" value="F" readonly="readonly" />
								<input type="hidden" name="chkSSN" value="" readonly="readonly" />
							</div>
						</td>
					</tr>
					<!-- <tr>
						<th><%=LNG_TEXT_PASSPORT_NUMBER%>&nbsp;<%=starText_PSPT%></th>
						<td>
							<div style="width:57%;"><input type="text" name="Passport_Number" class="imes input_text width95a" maxlength="10" onkeyup="javascript:this.value = this.value.toUpperCase();" /></div><div class="tcenter" style="width:3%;"></div><div style="width:40%;"><input type="button" name="" onclick="join_Passport_Numbercheck();" class="input_btn width95a" value="<%=LNG_TEXT_DOUBLE_CHECK%>" /></div>
							<div id="Passport_Numbercheck" class="summary" style="padding-top:4px;">
								<input type="hidden" name="Passport_Numbercheck" value="F" readonly="readonly" />
								<input type="hidden" name="chkPassport_Number" value="" readonly="readonly" />
							</div>
						</td>
					</tr> -->

				<%End If%>
				<tr class="name">
					<th><%=LNG_TEXT_NAME%></th>
					<td class="tweight"><%=strName%></td>
				</tr>
				<!-- <tr>
					<th><%=LNG_TEXT_ENGLISH_LETTER%>(<%=LNG_TEXT_GIVEN_NAME%>)</th>
					<td colspan="3"><input type="text" name="E_name" class="input_text imes width95a" maxlength="30" placeholder="" /></td>
				</tr><tr>
					<th><%=LNG_TEXT_ENGLISH_LETTER%>(<%=LNG_TEXT_FAMILY_NAME%>)</th>
					<td colspan="3"><input type="text" name="E_name_Last" class="input_text imes width95a" maxlength="30" placeholder="" /></td>
				</tr> -->
				<tr class="id">
					<th><%=LNG_TEXT_ID%>&nbsp;<%=starText%></th>
					<td>
						<%If CS_AUTO_WEBID_TF = "T" Then%>
							<b>아이디는 회원가입 후 발급됩니다.</b>
						<%Else%>
							<div class="inputs">
								<input type="text" name="strID" class="" onkeyup="this.value=this.value.replace(/[^a-zA-Z0-9]/g,'');" value="" />
								<input type="button" class="button" name="" onclick="join_idcheck();" class="" value="<%=LNG_TEXT_DOUBLE_CHECK%>" />
							</div>
							<p id="idCheck" class="summary"><%=LNG_JOINSTEP03_U_TEXT04%>
								<input type="hidden" name="idcheck" value="F" readonly="readonly" />
								<input type="hidden" name="chkID" value="" readonly="readonly" />
							</p>
						<%End If%>
					</td>
				</tr>
				<tr class="password">
					<th><%=LNG_TEXT_PASSWORD%>&nbsp;<%=starText%></th>
					<td>
						<input type="password" name="strPass" class="" maxlength="20" onkeyup="noSpace('strPass');" />
						<p class="summary"><%=LNG_TEXT_PASSWORD_TYPE%></p>
					</td>
				</tr>
				<tr class="password">
					<th><%=LNG_TEXT_PASSWORD_CONFIRM%>&nbsp;<%=starText%></th>
					<td><input type="password" name="strPass2" class="" maxlength="20" onkeyup="noSpace('strPass2');" /></td>
				</tr>
				<%If CENTER_SELECT_TF = "T" Then%>
				<tr class="center">
					<th><%=LNG_TEXT_CENTER%>&nbsp;<%=starText%></th>
					<td>
						<select name="businessCode">
							<option value="">::: <%=LNG_JOINSTEP03_U_TEXT09%> :::</option>
						<%
							SQL = "SELECT * FROM [tbl_Business] WHERE [Na_Code] = '"&R_NationCode&"' AND [U_TF] = 0 ORDER BY [ncode] ASC"
							arrList = Db.execRsList(SQL,DB_TEXT,Nothing,listLen,DB3)
							If IsArray(arrList) Then
								For i = 0 To listLen
									PRINT TABS(5)& "	<option value="""&arrList(0,i)&""">"&arrList(1,i)&"</option>"
								Next
							Else
								PRINT TABS(5)& "	<option value="""">"&LNG_JOINSTEP03_U_TEXT10&"</option>"
							End If
						%>
						</select>
					</td>
				</tr>
				<%End If%>
				<%
					'▣ 소비자 분기
					If S_SellMemTF = 1 Then
						starText_NOMIN		= ""
						starText_SPON		= starText
						starText_ADDRESS1	= starText
						starText_ADDRESS2	= starText
						starText_MOBILE		= starText
					Else
						starText_NOMIN		= starText
						starText_SPON		= starText
						starText_ADDRESS1	= starText
						starText_ADDRESS2	= starText
						starText_MOBILE		= starText
					End If

					'※후원인선택 : 추천인의 후원산하로만(형제라인 지정불가) pop_VoterSFV.asp → pop_SponsorSFV.asp
				%>
				<tr class="voter">
					<th><%=CS_NOMIN%>&nbsp;<%=starText_NOMIN%></th>
					<td>
						<%'#modal dialog%>
						<div class="inputs">
							<input type="text" name="voter" class="" value="<%=DKRSVI_MNAME%>" readonly="readonly" style="background-color:#efefef;" />
							<%If DKRSVI_CHECK <> "T" Then%>
							<a name="modal" id="popVoter" class="button" href="/m/common/pop_voter.asp" title="<%=CS_NOMIN%>&nbsp;<%=LNG_TEXT_SEARCH%>"><%=LNG_TEXT_SEARCH%></a>
							<%End If%>
						</div>
					</td>
				</tr>
				<%If S_SellMemTF = 0 Then%>
				<tr class="spon">
					<th><%=CS_SPON%>&nbsp;<%=starText_SPON%></th>
					<td>
						<%'#modal dialog%>
						<div class="inputs">
							<input type="text" name="sponsor" class="" value="" readonly="readonly" style="background-color:#efefef;" />
							<a name="modal" id="popSponsor" class="button" href="/m/common/pop_sponsor.asp" title="<%=CS_SPON%>&nbsp;<%=LNG_TEXT_SEARCH%>"><%=LNG_TEXT_SEARCH%></a>
						</div>
						<!-- <div style="width:47%;"><input type="text" name="sponsor" class="input_text width95a" readonly="readonly" style="background-color:#efefef;" /></div><div class="tcenter" style="width:3%;"></div><div style="width:25%;"><input type="button" name="" class="input_btn width95a" value="<%=LNG_TEXT_SEARCH%>"  onclick="spon_idcheck();" /></div><div style="width:25%;"><input type="button" class="input_btn width95a" value="<%=LNG_STRFUNCDATA_TEXT06%>" onclick="spon_company();" /></div> -->
						<input type="hidden" name="sponLine" value="" readonly="readonly" />
					</td>
				</tr>
				<%End If%>

				<%If S_SellMemTF = 0 Then%>
				<tr class="bank">
					<th><%=LNG_TEXT_BANKNAME%></th>
					<td>
						<select name="bankCode">
							<option value=""><%=LNG_JOINSTEP03_U_TEXT14%></option>
							<%
								'SQL = "SELECT [ncode],[BankName] FROM [tbl_Bank] ORDER BY [nCode] ASC"
								SQL = "SELECT [ncode],[BankName] FROM [tbl_Bank] WHERE [Na_Code] = '"&R_NationCode&"' ORDER BY [nCode] ASC"
								arrList = Db.execRsList(SQL,DB_TEXT,Nothing,listLen,DB3)
								If IsArray(arrList) Then
									For i = 0 To listLen
										PRINT Tabs(5)& "	<option value="""&arrList(0,i)&""">"&arrList(1,i)&"</option>"
									Next
								Else
									PRINT Tabs(5)& "	<option value="""">"&LNG_JOINSTEP03_U_TEXT15&"</option>"
								End If
							%>
						</select>
					</td>
				</tr>
				<tr>
					<th><%=LNG_TEXT_BANKNUMBER%></th>
					<td><input type="text" name="BankNumber" class="" maxlength="100" <%=onLyKeys3%> /></td>
				</tr><tr>
					<th><%=LNG_TEXT_BANKOWNER%></th>
					<td><input type="text" name="bankOwner" class="" maxlength="100" /></td>
				</tr>
				<%End If%>
			</table>
		</div>
		<div class="wrap">
			<h6><%=LNG_TEXT_MEMBER_ADDITIONAL_INFO%></h6>
			<table <%=tableatt%> class="width100">
				<col width="80" />
				<col width="*" />
				<tr class="radio">
					<th><%=LNG_TEXT_SEX%>&nbsp;<%=starText%></th>
					<td>
						<div class="labels">
							<label class="checkbox"><input type="radio" name="isSex" value="M" checked="checked"/><span><i class="icon-ok"></i><%=LNG_TEXT_MALE%></span></label>
							<label class="checkbox"><input type="radio" name="isSex" value="F" /><span><i class="icon-ok"></i><%=LNG_TEXT_FEMALE%></span></label>
						</div>
					</td>
				</tr>
				<%Select Case UCase(DK_MEMBER_NATIONCODE)%>
					<%Case "KR"%>
						<tr class="address">
							<th><%=LNG_TEXT_ADDRESS1%>&nbsp;<%=starText_ADDRESS1%></th>
							<td>
								<div class="inputs">
									<input type="text" name="strZip" id="strZipDaum" class="readonly" readonly="readonly" style="background-color:#efefef;" maxlength="7" />
									<a name="modal" href="/m/common/pop_postcode.asp" id="pop_postcode" class="button" title="<%=LNG_TEXT_ZIPCODE%>"><%=LNG_TEXT_ZIPCODE%></a>
								</div>
								<input type="text" name="strADDR1" id="strADDR1Daum" class="" style="background-color:#efefef;" maxlength="500" readonly="readonly" />
							</td>
						</tr>
						<tr class="address2">
							<th><%=LNG_TEXT_ADDRESS2%>&nbsp;<%=starText%></th>
							<td><input type="text" name="strADDR2" id="strADDR2Daum" maxlength="500" class="" /></td>
						</tr>
					<%Case "JP"%>
						<tr class="address">
							<th><%=LNG_TEXT_ADDRESS1%>&nbsp;<%=starText%></th>
							<td>
								<div class="inputs">
									<input type="text" name="strZip" class="" readonly="readonly" style="background-color:#efefef;" maxlength="7" />
									<input type="button" name="" class="button" value="<%=LNG_TEXT_ZIPCODE%>"  onclick="openzip_jp;" />
								</div>
								<input type="text" name="strADDR1" class="input_text width95a" style="background-color:#efefef;" maxlength="500" readonly="readonly" />
							</td>
						</tr>
						<tr class="address2">
							<th><%=LNG_TEXT_ADDRESS2%>&nbsp;<%=starText%></th>
							<td><input type="text" name="strADDR2" maxlength="500" class="" /></td>
						</tr>
					<%Case Else%>
						<tr class="address">
							<th><%=LNG_TEXT_ADDRESS1%>&nbsp;<%=starText%></th>
							<td>
								<div><%=LNG_TEXT_ZIPCODE%></div>
								<input type="text" name="strZip" class="" maxlength="7" value="" <%=onLyKeys3%> />
							</td>
						</tr><tr>
							<td><input type="text" name="strADDR1" maxlength="500" /></td>
						</tr><tr>
							<td><input type="text" name="strADDR2" maxlength="500" /></td>
						</tr>
				<%End Select%>
				<tr class="mobile">
					<th><%=LNG_TEXT_MOBILE%>&nbsp;<%=starText_MOBILE%></th>
					<td>
						<div class="inputs">
							<input type="tel" name="strMobile" maxlength="15" class="" <%=onLyKeys%> oninput="maxLengthCheck(this)" />
							<input type="button" name="" onclick="join_MobileCheck();" class="button" value="<%=LNG_TEXT_DOUBLE_CHECK%>" />
						</div>
						<p class="summary" id="mobileCheckTXT"></p>
						<input type="hidden" name="mobileCheck" value="F" readonly="readonly" />
						<input type="hidden" name="chkMobile" value="" readonly="readonly" />
						<p class="summary"><%=LNG_JOINSTEP03_U_TEXT24%></p>
					</td>
				</tr>
				<tr>
					<th><%=LNG_TEXT_TEL%></th>
					<td>
						<input type="tel" name="strTel" maxlength="15" <%=onLyKeys%> oninput="maxLengthCheck(this)" />
					</td>
				</tr>
				<tr>
					<th><%=LNG_TEXT_EMAIL%>&nbsp;<%=starText%></th>
					<td>
						<div class="inputs">
							<input type="email" name="strEmail" value="" maxlength="200" />
							<input type="button" name="" onclick="join_emailCheck();" class="button" value="<%=LNG_TEXT_DOUBLE_CHECK%>" /></div>
						</div>
						<p class="summary tweight" id="emailCheckTXT"></p>
						<input type="hidden" name="emailCheck" value="F" readonly="readonly" />
						<input type="hidden" name="chkEmail" value="" readonly="readonly" />
					</td>
				</tr>
				<tr class="radio birth">
					<th><%=LNG_TEXT_BIRTH%>&nbsp;<%=starText%></th>
					<td>
						<input type="hidden" name="birthYY" value="<%=birthYYYY%>" readonly="readonly" />
						<input type="hidden" name="birthMM" value="<%=birthMM%>" readonly="readonly" />
						<input type="hidden" name="birthDD" value="<%=birthDD%>" readonly="readonly" />
						<div><p><%=birthYYYY%>-<%=birthMM%>-<%=birthDD%></p></div>
						<div class="labels">
							<label class="checkbox">
								<input type="radio" name="isSolar" value="S" checked="checked"/><span><i class="icon-ok"></i><%=LNG_TEXT_SOLAR%></span>
							</label>
							<label class="checkbox">
								<input type="radio" name="isSolar" value="M" /><span><i class="icon-ok"></i><%=LNG_TEXT_LUNAR%></span>
							</label>
						</div>
					</td>
				</tr>
			</table>


			<div class="btnZone">
				<input type="submit" class="promise" onclick="" value="<%=LNG_TEXT_JOIN%>"/>
			</div>

		</div>
	</form>
</div>

<%'▣ 추천/후원인 선택 modal▣%>
<!--#include virtual="/m/_include/modal_config.asp" -->

<!--#include virtual = "/m/_include/copyright.asp"-->