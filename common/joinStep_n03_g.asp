<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/_lib/md5.asp" -->
<%
	PAGE_SETTING = "COMMON"

	ISLEFT = "F"
	ISSUBTOP = "T"
	ISSUBVISUAL = "F"
	IS_LANGUAGESELECT = "F"
	NO_MEMBER_REDIRECT = "F"

	view = 4
	sview = 2

	If DK_MEMBER_LEVEL > 0 Then Response.Redirect "/index.asp"

	'▣판매원,소비자 통합
	S_SellMemTF = pRequestTF("S_SellMemTF",True)
	sns_authID = pRequestTF("sns_authID",False) : If sns_authID = "" Then sns_authID = ""

	CENTER_SELECT_TF = "T"		'센터선택 기본값
	Select Case S_SellMemTF
		Case 0
			If NICE_MOBILE_CONFIRM_TF = "T" OR NICE_BANK_CONFIRM_TF = "T" Then Call ALERTS(LNG_MEMBER_LOGINOK_ALERT02,"BACK","")
			sview = 6
			LNG_TEXT_BUSINESS_MEMBER = LNG_TEXT_BUSINESS_MEMBER
			IF CS_NOMIN_CENTER_0_TF = "T" Then CENTER_SELECT_TF = "F"
		Case 1
			sview = 3
			LNG_TEXT_BUSINESS_MEMBER = LNG_TEXT_NORMAL_MEMBER
			IF CS_NOMIN_CENTER_1_TF = "T" Then CENTER_SELECT_TF = "F"
		Case Else
			Call ALERTS(LNG_MEMBER_LOGINOK_ALERT02,"BACK","")
	End Select

'	Select Case UCase(LANG)
'		Case "KR","MN"
			If Not checkRef(houUrl &"/common/joinStep_n02_g.asp") Then Call alerts(LNG_ALERT_WRONG_ACCESS,"go","/common/joinStep01.asp")
			'If Not checkRef(houUrl &"/common/joinStep02.asp") Then Call alerts(LNG_ALERT_WRONG_ACCESS,"go","/common/joinStep01.asp")
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

	If agreement <> "T" Then Call ALERTS(LNG_JS_POLICY01,"back","")
	If gather <> "T" Then Call ALERTS(LNG_JS_POLICY02,"back","")
	If S_SellMemTF = 0 Then
		If company <> "T" Then Call ALERTS(LNG_JS_POLICY03,"back","")
	End If



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
		Db.makeParam("@M_Name_First",adVarWChar,adParamInput,100,M_Name_First),_
		Db.makeParam("@M_Name_Last",adVarWChar,adParamInput,100,M_Name_Last),_
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


		SQLVI = "SELECT [MBID],[MBID2],[M_NAME],[WebID] FROM [tbl_MemberInfo] WITH(NOLOCK) WHERE [webID] = ? "
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


%>
<!--#include virtual="/_include/document.asp" -->
<link rel="stylesheet" type="text/css" href="join.css" />
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
			alert2("<%=LNG_JS_ID%>", "#idCheck", "F");
			ids.focus();
			return false;
		}
		/*
		if (/(\w)\1\1/.test(ids.value)){
			alert2("<%=LNG_JS_ID_FORM_CHECK_01%>", "#idCheck", "F");
			//alert("동일 숫자나 영문은 3번이상 연속으로 사용할 수 없습니다.");
			return false;
		}
		if (ids.value.search('te')>-1 || ids.value.search('TE')>-1) {
			alert2("<%=LNG_JS_ID_FORM_CHECK_02%>", "#idCheck", "F");
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

	//SSN check
	function join_SSNcheck() {
		var ids = document.cfrm.strSSH;
		if (ids.value == '')
		{
			alert("Please enter SSN");
			ids.focus();
			return false;
		}
		if (ids.value.stripspace().length < 9) {
			alert("Please enter SSN Number correctly!");
			ids.focus();
			return false;
		}
		createRequest();
		var url = 'ajax_SSNcheck.asp?ids='+ids.value;
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
		openPopup("/common/pop_Zipcode.asp", "Zipcodes", 100, 100, "left=200, top=200");
	}
	function openzip_jp() {
		openPopup("/common/pop_ZipCode_JP.asp", "Zipcodes", 100, 100, "left=200, top=200");		//일본주소
	}
	function vote_idcheck() {
		openPopup("/common/pop_voter.asp", "vote_idcheck", 100, 100, "left=200, top=200");
	}
	function spon_idcheck() {
		openPopup("/common/pop_Sponsor.asp", "spon_idcheck", 100, 100, "left=200, top=200");
	}
	function family_idcheck() {
		openPopup("/common/pop_family.asp", "vote_idcheck", 100, 100, "left=200, top=200");
	}
	/*	testing
	function sponAuto_idcheck() {
		openPopup("/common/pop_sponsor3_line.asp", "spon_idcheck", 100, 100, "left=200, top=200");
	}
	*/

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
				alert2("<%=LNG_JS_ID_FORM_CHECK_01%>", "#idCheck", "F");
				//alert("동일 숫자나 영문은 3번이상 연속으로 사용할 수 없습니다.");
				return false;
			}
			if (f.strID.value.search('te')>-1 || f.strID.value.search('TE')>-1) {
				alert2("<%=LNG_JS_ID_FORM_CHECK_02%>", "#idCheck", "F");
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
		<%End if%>



		<%If S_SellMemTF = 0 Then%>

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
			alert2("<%=LNG_JS_MOBILE%>", "#mobileCheckTXT", "F");
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

	$(function(){
		$('.sub-header').append('<div class="join-header-txt"><p><%=LNG_JOINSTEP03_U_STITLE01%></p><span class="red"><%=LNG_JOINSTEP03_U_STITLE02%></span></div>');
	});

</script>
</head>
<body>
<!--#include virtual="/_include/header.asp" -->
<div id="joinStep" class="common joinStep3">

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
			<article>
				<h6><%=LNG_TEXT_MEMBER_BASIC_INFO%></h6>

				<input type="hidden" name="Na_Code" value="KR" readonly="readonly" /><%'한국회원만%>
				<!-- <tr class="line" >
					<th><%=LNG_SUBTITLE_SELECT_NATION%>&nbsp;<%=starText%></th>
					<td>
						<select name="Na_Code" style="width:260px;" class="input_select" onchange="insertThisValue2(this);">
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
					<th>country code</th>
					<td colspan="3" ><strong class="blue2">[<%=dkrs_nationcode%>] <%=dkrs_classname%></strong> <span class="alert">(the country code is based on iso 3166-1 alpha-2 codes)</span></td>
				</tr> -->
				<%If UCase(Lang) <> "KR" Then	'▣한국외 도시선택%>
					<!-- <tr>
						<th><%=LNG_SUBTITLE_SELECT_CITY%>&nbsp;<%=starText%></th>
						<td>
							<select name="CityCode" style="width:220px;" class="input_select">
								<option value="">::: <%=LNG_JOIN_SELECT_CITY%> :::</option>
							</select>
						</td>
					</tr> -->
					<tr>
						<th><%=LNG_TEXT_CPNO%>&nbsp;<%=starText%></th>
						<td>
							<input type="text" name="strSSH" class="input_text vmiddle imes" maxlength="13" size="50" onkeyup="javascript:this.value = this.value.toUpperCase();" /></span>
							<input type="button" class="txtBtn j_medium" onclick="join_SSNcheck();" value="<%=LNG_TEXT_DOUBLE_CHECK%>"/>
							<span class="summary alert" id="SSNCheck">
								<input type="hidden" name="SSNcheck" value="F" readonly="readonly" />
								<input type="hidden" name="chkSSN" value="" readonly="readonly" />
							</span>
						</td>
					</tr>
					<!-- <tr>
						<th><%=LNG_TEXT_PASSPORT_NUMBER%>&nbsp;<%=starText_PSPT%></th>
						<td>
							<input type="text" name="Passport_Number" class="input_text imes vmiddle" maxlength="10" size="50" onkeyup="javascript:this.value = this.value.toUpperCase();" /></span>
							<input type="button" class="txtBtn j_medium" onclick="join_Passport_Numbercheck();" value="<%=LNG_TEXT_DOUBLE_CHECK%>"/>
							<span class="summary alert" id="Passport_Numbercheck">
								<input type="hidden" name="Passport_Numbercheck" value="F" readonly="readonly" />
								<input type="hidden" name="chkPassport_Number" value="" readonly="readonly" />
							</span>
						</td>
					</tr> -->

				<%End If%>
				<div class="name">
					<h5><%=LNG_TEXT_NAME%></h5>
					<div class="con">
						<b><%=strName%></b>
					</div>
				</div>
				<%If CS_AUTO_WEBID_TF = "T" Then%>
				<div class="name">
					<h5><%=LNG_TEXT_ID%>&nbsp;<%=starText%></h5>
					<div class="con"><b>아이디는 회원가입 후 발급됩니다.</b></div>
				</div>
				<%Else%>
				<div class="id">
					<h5><%=LNG_TEXT_ID%>&nbsp;<%=starText%></h5>
					<div class="con">
						<input type="text" name="strID" class="input_text" maxlength="20" <%=toNoKorText%> placeholder="" />
						<input type="button" class="button" onclick="join_idcheck();" value="<%=LNG_TEXT_DOUBLE_CHECK%>"/>
						<p class="summary" id="idCheck"><%=LNG_JOINSTEP03_U_TEXT04%>
							<input type="hidden" name="idcheck" value="F" readonly="readonly" />
							<input type="hidden" name="chkID" value="" readonly="readonly" />
						</p>
					</div>
				</div>
				<%End If%>
				<div class="password dwrap">
					<div>
						<h5><%=LNG_TEXT_PASSWORD%>&nbsp;<%=starText%></h5>
						<div class="con">
							<input type="password" name="strPass" class="input_text" maxlength="20" size="24" onkeyup="noSpace('strPass');" placeholder="" />
							<p class="summary"><%=LNG_TEXT_PASSWORD_TYPE%></p>
						</div>
					</div>
					<div>
						<h5><%=LNG_TEXT_PASSWORD_CONFIRM%>&nbsp;<%=starText%></h5>
						<div class="con">
							<input type="password" name="strPass2" class="input_text" maxlength="20" size="24" onkeyup="noSpace('strPass2');" placeholder="" />
						</div>
					</div>
				</div>
				<%If CENTER_SELECT_TF = "T" Then%>
				<div class="center">
					<h5><%=LNG_TEXT_CENTER%>&nbsp;<%=starText%></h5>
					<div class="con">
						<select name="businessCode" class="input_select">
							<option value="">::: <%=LNG_JOINSTEP03_U_TEXT09%> :::</option>
							<%
								SQL = "SELECT * FROM [tbl_Business] WITH(NOLOCK) WHERE [Na_Code] = '"&R_NationCode&"' AND [U_TF] = 0 ORDER BY [ncode] ASC"
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
					</div>
				</div>
				<%End If%>

			<%
				'▣소비자 분기
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
				<div class="voter">
					<h5><%=CS_NOMIN%>&nbsp;<%=starText_NOMIN%></h5>
					<div class="con">
						<input type="text" name="voter" class="input_text" value="<%=DKRSVI_MNAME%>" maxlength="12" size="24" readonly="readonly" onclick="" placeholder="" />
						<%'#modal dialog%>
						<%If DKRSVI_CHECK <> "T" Then%>
							<a name="modal" class="button" id="popVoter" href="/common/pop_voter.asp" title="<%=CS_NOMIN%>&nbsp;<%=LNG_TEXT_SEARCH%>"><%=LNG_TEXT_SEARCH%></a>
						<%End If%>
					</div>
				</div>
				<%if 1=2 then%>
					<%If S_SellMemTF = 0 Then%>
					<div class="sponsor">
						<h5><%=CS_SPON%>&nbsp;<%=starText_SPON%></h5>
						<div class="con">
							<input type="text" name="sponsor" class="input_text" maxlength="12" size="24" readonly="readonly" placeholder="" />
							<%'#modal dialog%>
							<a name="modal" class="button" id="popSponsor" href="/common/pop_sponsor.asp" title="<%=CS_SPON%>&nbsp;<%=LNG_TEXT_SEARCH%>"><%=LNG_TEXT_SEARCH%></a>
							<input type="hidden" name="sponLine" value="" readonly="readonly" />
						</div>
					</div>
					<%End If%>
				<%end if%>
				<%If S_SellMemTF = 0 Then%>
				<div class="bank dwrap">
					<div>
						<h5><%=LNG_TEXT_BANKNAME%> / <%=LNG_TEXT_BANKNUMBER%></h5>
						<div class="con">
							<select name="bankCode" class="input_select">
								<option value=""><%=LNG_JOINSTEP03_U_TEXT14%></option>
								<%
									'SQL = "SELECT [ncode],[BankName] FROM [tbl_Bank] WITH(NOLOCK) ORDER BY [nCode] ASC"
									SQL = "SELECT [ncode],[BankName] FROM [tbl_Bank] WITH(NOLOCK) WHERE [Na_Code] = '"&R_NationCode&"' ORDER BY [nCode] ASC"
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
							<input type="text" name="BankNumber" class="input_text" maxlength="50" <%=onLyKeys3%> />
						</div>
					</div>
					<div>
						<h5><%=LNG_TEXT_BANKOWNER%></h5>
						<div class="con">
							<input type="text" name="bankOwner" class="input_text" maxlength="100" />
						</div>
					</div>
				</div>
				<%End If%>
			</article>
			<article>
				<h6><%=LNG_TEXT_MEMBER_ADDITIONAL_INFO%></h6>
				<div class="radio">
					<h5><%=LNG_TEXT_SEX%>&nbsp;<%=starText%></h5>
					<div class="con">
						<label><input type="radio" name="isSex" value="M" checked="checked"/><i class="icon-ok"></i><span><%=LNG_TEXT_MALE%></span></label>
						<label><input type="radio" name="isSex" value="F" /><i class="icon-ok"></i><span><%=LNG_TEXT_FEMALE%></span></label>
					</div>
				</div>
				<%Select Case UCase(DK_MEMBER_NATIONCODE)%>
					<%Case "KR"%>
					<div class="address">
						<h5><%=LNG_TEXT_ADDRESS1%>&nbsp;<%=starText_ADDRESS1%></h5>
						<div class="con">
							<input type="text" name="strZip" id="strZipDaum" class="input_text" maxlength="7" readonly="readonly" placeholder="" />
							<a name="modal" href="/m/common/pop_postcode.asp" id="pop_postcode" title="<%=LNG_TEXT_ZIPCODE%>"><input type="button" class="button" value="<%=LNG_TEXT_ZIPCODE%>"/></a>
							<!-- <input type="button" class="button" onclick="execDaumPostcode('oris');" value="<%=LNG_TEXT_ZIPCODE%>" /> -->
							<input type="text" name="strADDR1" id="strADDR1Daum" class="input_text" maxlength="500" readonly="readonly" placeholder="" />
						</div>
					</div>
					<div class="address2">
						<h5><%=LNG_TEXT_ADDRESS2%>&nbsp;<%=starText_ADDRESS2%></h5>
						<div class="con">
							<input type="text" class="input_text" name="strADDR2" id="strADDR2Daum" style="ime-mode:active;" maxlength="500" placeholder="" />
						</div>
					</div>
					<%Case "JP"%>
					<div class="address">
						<h5><%=LNG_TEXT_ADDRESS1%>&nbsp;<%=starText%></h5>
						<div class="con">
							<input type="text" name="strZip" class="readonly" maxlength="7" readonly="readonly" placeholder="" />
							<input type="button" class="txtBtn j_medium" onclick="openzip_jp();" value="<%=LNG_TEXT_ZIPCODE%>" />
							<input type="text" name="strADDR1" class="readonly" maxlength="500" readonly="readonly" placeholder="" />
						</div>
					</div>
					<div class="address2">
						<h5><%=LNG_TEXT_ADDRESS2%>&nbsp;<%=starText%></h5>
						<div class="con"><input type="text" name="strADDR2" id="strADDR2Daum" style="ime-mode:active;" maxlength="500" placeholder="" /></div>
					</div>
					<%Case Else%>
					<div class="address">
						<h5><%=LNG_TEXT_ADDRESS1%>&nbsp;<%=starText%></h5>
						<div class="con">
							<input type="text" name="strADDR1" id="strADDR1Daum" maxlength="500" placeholder="" />
							<span> (ZipCode) </span>
							<input type="text" name="strZip" id="strZip" value="" maxlength="7" <%=onLyKeys3%> />
						</div>
					</div>
					<div class="address2">
						<h5><%=LNG_TEXT_ADDRESS2%>&nbsp;<%=starText%></h5>
						<div class="con"><input type="text" name="strADDR2" id="strADDR2Daum" maxlength="500" placeholder="" /></div>
					</div>
				<%End Select%>
				<div class="mobile">
					<h5><%=LNG_TEXT_MOBILE%>&nbsp;<%=starText_MOBILE%></h5>
					<div class="con">
						<input type="text" class="input_text" name="strMobile" maxlength="15" <%=onLyKeys%> value="" />
						<input type="button" class="button" onclick="join_MobileCheck();" value="<%=LNG_TEXT_DOUBLE_CHECK%>"/>
						<p class="summary" id="mobileCheckTXT"><%=LNG_JOINSTEP03_U_TEXT24%></p>
						<input type="hidden" name="mobileCheck" value="F" readonly="readonly" />
						<input type="hidden" name="chkMobile" value="" readonly="readonly" />
					</div>
				</div>
				<div class="tel">
					<h5><%=LNG_TEXT_TEL%></h5>
					<div class="con">
						<input type="text" class="input_text" name="strTel" maxlength="15" <%=onLyKeys%> value="<%=DKRS_hometel%>" />
					</div>
				</div>
				<div class="mobile">
					<h5><%=LNG_TEXT_EMAIL%>&nbsp;<%=starText%></h5>
					<div class="con">
						<input type="text" name="strEmail" class="input_text" maxlength="512" />
						<input type="button" class="button" onclick="join_emailCheck();" value="<%=LNG_TEXT_DOUBLE_CHECK%>"/>
						<p class="summary" id="emailCheckTXT"><%=LNG_JOINSTEP03_U_TEXT29%></p>
						<input type="hidden" name="emailCheck" value="F" readonly="readonly" />
						<input type="hidden" name="chkEmail" value="" readonly="readonly" />
					</div>
				</div>
				<div class="radio birth">
					<h5><%=LNG_TEXT_BIRTH%>&nbsp;<%=starText%></h5>
					<div class="con">
						<input type="hidden" name="birthYY" value="<%=birthYYYY%>" readonly="readonly" />
						<input type="hidden" name="birthMM" value="<%=birthMM%>" readonly="readonly" />
						<input type="hidden" name="birthDD" value="<%=birthDD%>" readonly="readonly" />
						<div><p><%=birthYYYY%>-<%=birthMM%>-<%=birthDD%></p></div>
						<label><input type="radio" name="isSolar" value="S" checked="checked"/><i class="icon-ok"></i><span><%=LNG_TEXT_SOLAR%></span></label>
						<label><input type="radio" name="isSolar" value="M" /><i class="icon-ok"></i><span><%=LNG_TEXT_LUNAR%></span></label>
					</div>
				</div>
			</article>

			<div class="btnZone">
				<a href="joinStep01.asp" type="button" class="cancel" data-ripplet><%=LNG_TEXT_JOIN_CANCEL%></a>
				<input type="submit" class="promise" data-ripplet value="<%=LNG_TEXT_JOIN%>" />
			</div>
		</div>

	</form>

</div>

<%'▣ 추천/후원인 선택 modal▣%>
<!--#include virtual="/_include/modal_config.asp" -->

<!--#include virtual="/_include/copyright.asp" -->
