<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual = "/_lib/md5.asp"-->
<%
'Call WRONG_ACCESS()

	PAGE_SETTING = "MEMBERSHIP"

	ISLEFT = "T"
	ISSUBTOP = "T"
	ISSUBVISUAL = "T"
	IS_LANGUAGESELECT = "F"

	view = 1
	'sview = 6

	If DK_MEMBER_LEVEL > 0 Then Response.Redirect "/index.asp"

	'▣판매원,소비자 통합
	S_SellMemTF = pRequestTF("S_SellMemTF",True)
	Select Case S_SellMemTF
		Case 0
			sview = 6
			LNG_TEXT_BUSINESS_MEMBER = LNG_TEXT_BUSINESS_MEMBER
		Case 1
			sview = 3
			LNG_TEXT_BUSINESS_MEMBER = LNG_TEXT_NORMAL_MEMBER
		Case Else
			Call ALERTS(LNG_MEMBER_LOGINOK_ALERT02,"BACK","")
	End Select


	Select Case UCase(LANG)
		Case "KR"
			If Not checkRef(houUrl &"/common/joinStep_n02_m.asp") Then Call alerts(LNG_ALERT_WRONG_ACCESS,"go","/common/joinStep01.asp")
		Case Else
			Call alerts(LNG_ALERT_WRONG_ACCESS,"back","")
	End Select
%>
<%
'#####################################
'	NICE 본인인증(핸드폰)
'#####################################

	sRequestNO = pRequestTF("sRequestNO",True)

	If session("REQ_SEQ") <> sRequestNO Then Call ALERTS("세션값이 다릅니다. 올바른 경로로 접근하시기 바랍니다","go","/common/joinStep01.asp")


	'▣ 인증 데이터 확인 S
		Set XTEncrypt = new XTclsEncrypt
		'RChar = XTEncrypt.MD5(RandomChar(10))
		RChar = makeMemTempNum&RandomChar(10)

		sResponseNumber = SESSION("sResponseNumber")
		If sResponseNumber = "" Then sResponseNumber = ""

		'PRINT sRequestNO & " <br />"
		'print sResponseNumber
		'Response.End

		SQLM = "SELECT * FROM [DKT_MEMBER_MOBILE_AUTH] WITH(NOLOCK) WHERE [sRequestNumber] = ? AND [sType] = 'JOIN' AND [sResponseNumber] = ?"
		arrParamsM = Array(_
			Db.makeParam("@sRequestNO",adVarChar,adParamInput,30,sRequestNO), _
			Db.makeParam("@sResponseNumber",adVarChar,adParamInput,30,sResponseNumber) _
		)
		Set DKRSM = Db.execRs(SQLM,DB_TEXT,arrParamsM,Nothing)

		If Not DKRSM.BOF And Not DKRSM.EOF Then

			DKRSM_intIDX			= DKRSM("intIDX")
			DKRSM_sType				= DKRSM("sType")
			DKRSM_sCipherTime		= DKRSM("sCipherTime")
			DKRSM_sRequestNumber	= DKRSM("sRequestNumber")
			DKRSM_sResponseNumber	= DKRSM("sResponseNumber")
			DKRSM_sAuthType			= DKRSM("sAuthType")
			DKRSM_sName				= DKRSM("sName")
			DKRSM_sGender			= DKRSM("sGender")
			DKRSM_sBirthDate		= DKRSM("sBirthDate")
			DKRSM_sNationalInfo		= DKRSM("sNationalInfo")
			DKRSM_sDupInfo			= DKRSM("sDupInfo")				'중복가입 확인값 (DI_64 byte)
			DKRSM_sConnInfo			= DKRSM("sConnInfo")
			DKRSM_sMobileNo			= DKRSM("sMobileNo")
			DKRSM_sMobileCo			= DKRSM("sMobileCo")
			DKRSM_regTime			= DKRSM("regTime")

			'NICE 휴대전화 리턴값 신청해야함!!!
			If DKRSM_sMobileNo = "" Then
				Call ALERTS("휴대폰정보가 없습니다..","GO","joinStep01.asp")
			End If



			'CS회원 중복체크
			SQL_CK = "SELECT MBID,MBID2,M_NAME,WebID FROM [tbl_memberInfo] (nolock) WHERE [hptel] = ? AND [hptel] <> '' "
			arrParams_CK = Array(_
				Db.makeParam("@mobileAuth",adVarChar,adParamInput,88,DKRSM_sMobileNo) _
			)
			Set DKRSM = Db.execRs(SQL_CK,DB_TEXT,arrParams_CK,DB3)
			If Not DKRSM.BOF And Not DKRSM.EOF Then
				Call ALERTS("이미 등록된 회원입니다.","GO","/common/member_login.asp")
			Else

				Set objEncrypter = Server.CreateObject("Hyeongryeol.StringEncrypter")
					objEncrypter.Key = con_EncryptKey
					objEncrypter.InitialVector = con_EncryptKeyIV
					On Error Resume Next
						If DKRSM_sMobileNo		<> "" Then DKRSM_sMobileNo		= objEncrypter.Decrypt(DKRSM_sMobileNo)
						If RChar				<> "" Then RChar				= objEncrypter.Encrypt(RChar)
					On Error GoTo 0
				Set objEncrypter = Nothing

				arrParams = Array(_
					Db.makeParam("@TempDataNum",adVarChar,adParamInput,50,RChar), _
					Db.makeParam("@sRequestNO",adVarChar,adParamInput,30,sRequestNO), _
					Db.makeParam("@sResponseNumber",adVarChar,adParamInput,24,sResponseNumber), _
					Db.makeParam("@sDupInfo",adVarChar,adParamInput,64,DKRSM_sDupInfo) _
				)
				Call Db.exec("DKSP_MEMBER_JOIN_TEMP_INSERT",DB_PROC,arrParams,Nothing)
				SESSION("dataNum") = RChar

			End If
		Else
			Call ALERTS("본인인증 데이터가 존재하지 않습니다. 본인인증을 다시 하셔야합니다.","GO","joinStep01.asp")
		End If
		Call closeRs(DKRSM)

		'print RChar
	'▣ 인증 데이터 확인 E


	'Call ResRW(SESSION("dataNum"),"SESSION(dataNum)")
	'Call ResRW(SESSION("sResponseNumber"),"SESSION(sResponseNumber)")
	'Call ResRW(SESSION("REQ_SEQ"),"SESSION(REQ_SEQ)")

%>
<%

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

	If DKRSM_sNationalInfo = "1" Then					'외국인 이름+' '+성
		strName = M_Name_Last&" "&M_Name_First
	End If
	'agreement = pRequestTF("agreement",False)
	'gather = pRequestTF("gather",False)
	'company = pRequestTF("company",False)

	'▣ 핸드폰 인증 통과
	agreement = "T"
	gather = "T"
	company = "T"

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

	function join_emailCheck() {
		var f = document.cfrm;
		if (f.strEmail.value == '')
		{
			alert("<%=LNG_JS_EMAIL%>");
			f.strEmail.focus();
			return false;
		}
		if (!checkEmail(f.strEmail.value)) {
			alert("<%=LNG_JS_EMAIL_CONFIRM%>");
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
						$("#emailCheckTXT").text(json.message).addClass("blue2").removeClass("red2");
						$("input[name=emailCheck]").val("T");
						$("input[name=chkEmail]").val($("input[name=strEmail]").val());

					}else{
						$("#emailCheckTXT").text(json.message).addClass("red2").removeClass("blue2");
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
			alert("<%=LNG_JS_ID%>");
			ids.focus();
			return false;
		}
		/*
		if (/(\w)\1\1/.test(ids.value)){
			alert("<%=LNG_JS_ID_FORM_CHECK_01%>");
			//alert("동일 숫자나 영문은 3번이상 연속으로 사용할 수 없습니다.");
			return false;
		}
		*/
		if (checkID_CSID(ids.value.trim())) {
			let notAllowedCSID = '<%=LNG_notAllowedCSID%>'
			alert("<%=LNG_JS_ID_FORM_CHECK_02%> "+ notAllowedCSID);
			ids.value = "";
			ids.focus();
			return false;
		}
		if (!checkID(ids.value.trim(), 4, 20)){
			alert("<%=LNG_JS_ID_FORM_CHECK%>");
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
		var url = 'ajax_Passport_Numbercheck.asp?ids='+ids.value;
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
						alert("<%=LNG_JOINSTEP03_U_JS32%>");
						$("#SSNCheck").text("<%=LNG_JS_DUPLICATION_CHECK%>").css({"color":"red","font-weight":"bold"});
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
		if (f.strID.value == "")
		{
			alert("<%=LNG_JS_ID%>");
			f.strID.focus();
			return false;
		} else {
			if (!checkID(f.strID.value, 4, 20)){
				alert("<%=LNG_JS_ID_FORM_CHECK%>");
				f.strID.focus();
				return false;
			}
			if (f.idcheck.value == 'F'){
				alert("<%=LNG_JS_ID_DOUBLE_CHECK%>");
				f.strID.focus();
				return false;
			}
			if (f.strID.value != f.chkID.value){
				alert("<%=LNG_JS_ID_DOUBLE_CHECK2%>");
				$("#idCheck").text("<%=LNG_JS_DUPLICATION_CHECK%>").css({"color":"red","font-weight":"bold"});
				f.strID.focus();
				return false;
			}
		}
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

		if (f.idcheck.value == f.strPass.value){
			alert("<%=LNG_JS_PASSWORD_FORM_CHECK2%>");
			f.strPass.focus();
			return false;
		}

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



	<%If S_SellMemTF = 0 Then%>		//판매원 추천인 필수, 후원인 필수
		if (chkEmpty(f.businessCode)) {
			alert("<%=LNG_JS_CENTER%>");
			f.businessCode.focus();
			return false;
		}
	<%End IF%>

		if (f.NominCom.value == 'F')
		{
			if (chkEmpty(f.voter) || chkEmpty(f.NominID1) || chkEmpty(f.NominID2) || f.NominChk.value == 'F') {
				alert("<%=LNG_JS_VOTER%>");
				f.voter.focus();
				return false;
			}

		}

		if (chkEmpty(f.sponsor) || chkEmpty(f.SponID1) || chkEmpty(f.SponID2) || f.SponIDChk.value == 'F') {
			alert("<%=LNG_JS_SPONSOR%>");
			f.sponsor.focus();
			return false;
		}


		<%If UCase(DK_MEMBER_NATIONCODE) = "KR" And NICE_BANK_CONFIRM_TF = "T" And S_SellMemTF = 0 Then%>		//'핸폰폰인증 사용 + 계좌인증 사용 시
			if (f.ajaxTF.value != "T")
			{
				alert("계좌 본인인증을 해주세요.")
				return false;
			} else {
				if(!chkNull(f.bankCode, "\'은행\'을 선택해 주세요")) return false;
				if(!chkNull(f.BankNumber, "\'계좌번호\'를 입력해 주세요")) return false;
				if(!chkNull(f.bankOwner, "\'예금주\'를 입력해 주세요")) return false;
				if(!chkNull(f.M_Name_First, "\'예금주 이름\'을 입력해 주세요")) return false;
				if(!chkNull(f.M_Name_Last, "\'예금주 성\'을 입력해 주세요")) return false;
				if(!chkNull(f.TempDataNum, "\'데이터베이스 입력 오류\'")) return false;

				if (chkEmpty(f.birthYY) || chkEmpty(f.birthMM) || chkEmpty(f.birthDD)) {
					alert("생년월일을 입력해 주세요.");
					f.birthYY.focus();
					return false;
				}
				if (!checkMinorBirth(f.birthYY, f.birthMM , f.birthDD)) return false;		// 미성년자체크(생년월일)

				if (f.strBankCodeCHK.value != f.bankCode.value || f.strBankNumCHK.value != f.BankNumber.value || f.strBankOwnerCHK.value != f.bankOwner.value || f.birthYYCHK.value != f.birthYY.value || f.birthMMCHK.value != f.birthMM.value || f.birthDDCHK.value != f.birthDD.value)
				{
					alert("본인인증시의 입력정보와 현재 입력된 정보가 틀립니다. 본인인증을 다시 해주세요.");
					$("#result_text").text("본인인증시의 입력정보와 현재 입력된 정보가 틀립니다").addClass("red2").removeClass("blue2");
					return false;
				}
			}
		<%End If%>

		if (chkEmpty(f.strZip) || chkEmpty(f.strADDR1)) {
			alert("<%=LNG_JS_ADDRESS1%>");
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
		}
		if (f.strMobile.value.length < 10) {
			alert("<%=LNG_JS_MOBILE_FORM_CHECK%>");
			f.strMobile.focus();
			return false;
		}

		if (f.strEmail.value == "")
		{
			alert("<%=LNG_JS_EMAIL%>");
			f.strEmail.focus();
			return false;
		} else {

			if (!checkEmail(f.strEmail.value)) {
				alert("<%=LNG_JS_EMAIL_CONFIRM%>");
				f.strEmail.focus();
				return false;
			}
			/*
			if (f.emailCheck.value == 'F'){
				alert("<%=LNG_JS_EMAIL_DOUBLE_CHECK%>");
				f.strEmail.focus();
				return false;
			}
			if (f.strEmail.value != f.chkEmail.value){
				alert("<%=LNG_JS_EMAIL_DOUBLE_CHECK2%>");
				$("#emailCheckTXT").text("<%=LNG_JS_DUPLICATION_CHECK%>").css({"color":"red"});
				f.strEmail.focus();
				return false;
			}
			*/
		}


		if (chkEmpty(f.birthYY) || chkEmpty(f.birthMM) || chkEmpty(f.birthDD)) {
			alert("<%=LNG_JS_BIRTH%>");
			f.birthYY.focus();
			return false;
		}

		<%If CONST_CS_SIGNATURE_USE_TF = "T" Then%>		//전자서명
		<% If S_SellMemTF = 0 Then%>
			if (chkEmpty(f.signature_file)) {
				alert("전자서명을 입력 후 저장 해 주세요.");
				return false;
			}
		<% End If %>
		<%End If %>

		if (confirm("<%=LNG_JOINSTEP03_U_STITLE04%>")) {
			f.target = "_self";
			$("#loadingPro").show();
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


	function vote_company()
	{
		document.cfrm.NominCom.value = 'T';
		document.cfrm.NominID1.value = '**';
		document.cfrm.NominID2.value = 0;
		document.cfrm.NominWebID.value = 'admin';
		document.cfrm.voter.value = '본사';
		document.cfrm.NominChk.value = 'T';
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

	//계좌인증
	function ajax_accountChk() {
		var f = document.cfrm;

		if (f.bankCode.value == '')
		{
			alert("은행을 선택해주세요.");
			f.bankCode.focus();
			return;
		}
		if (f.BankNumber.value == '')
		{
			alert("계좌번호를 입력해주세요");
			f.BankNumber.focus();
			return;
		}
		if (f.M_Name_Last.value == '')
		{
			alert("예금주 성을 입력해주세요.");
			f.M_Name_Last.focus();
			return false;
		}
		if (f.M_Name_First.value == '')
		{
			alert("예금주 이름을 입력해주세요.");
			f.M_Name_First.focus();
			return false;
		}
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
				,"strBankNum"	: f.BankNumber.value
				,"strBankOwner"	: f.M_Name_Last.value+f.M_Name_First.value
				,"M_Name_First"	: f.M_Name_First.value
				,"M_Name_Last"	: f.M_Name_Last.value
			}
			,success: function(data) {
				var obj = $.parseJSON(data);
				alert(obj.message);
				if (obj.statusCode == '0000')
				{
					$("#result_text").text(obj.message).addClass("blue2").removeClass("red2");
					$("input[name=strBankCodeCHK").val(obj.strBankCodeCHK)
					$("input[name=strBankNumCHK").val(obj.strBankNumCHK)
					$("input[name=strBankOwnerCHK").val(obj.strBankOwnerCHK)
					$("input[name=TempDataNum").val(obj.TempDataNum)
					$("input[name=birthYYCHK").val(obj.birthYYCHK)
					$("input[name=birthMMCHK").val(obj.birthMMCHK)
					$("input[name=birthDDCHK").val(obj.birthDDCHK)
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
<script src="https://spi.maps.daum.net/imap/map_js_init/postcode.v2.js"></script>
<script src="/jscript/daumPostCode.js"></script>
</head>
<body>
<!--#include virtual="/_include/header.asp" -->
<div id="loadingPro" style="position:fixed; z-index:99999; width:100%; height:100%; top:0px; left:0px; background:url(/images_kr/loading_bg70.png) 0 0 repeat; display:none;">
	<div style="position:relative; top:40%; text-align:center;">
		<img src="<%=IMG%>/159.gif" width="80" alt="" />
	</div>
</div>
<div id="joinStep" class="step03">
	<div class="title_area">
		<p class="c_b_title tweight" style=""><%=LNG_TEXT_BUSINESS_MEMBER%> - <%=LNG_JOINSTEP03_U_BTITLE%></p>
		<p class="c_s_title tweight" style=""><%=LNG_JOINSTEP03_U_STITLE01%><span class="red"><%=LNG_JOINSTEP03_U_STITLE02%></span></p>
	</div>

	<form name="cfrm" method="post" action="joinFinish_m.asp" onsubmit="return chkSubmit(this);">
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

		<div class="tableArea">
			<p class="s_title"><%=LNG_TEXT_MEMBER_BASIC_INFO%></p>
			<table <%=tableatt%> class="width100">
				<col width="200" />
				<col width="*" />

				<input type="hidden" name="Na_Code" value="KR" readonly="readonly" /><%'한국회원만%>
				<tr class="line">
					<th><%=LNG_TEXT_NAME%></th>
					<td class="tweight"><%=strName%></td>
				</tr>
				<!-- <tr>
					<th><%=LNG_TEXT_ENGLISH_LETTER%>(<%=LNG_TEXT_GIVEN_NAME%>)</th>
					<td colspan="3"><input type="text" name="E_name" class="input_text imes" maxlength="30" size="24" placeholder="<%=LNG_TEXT_ENGLISH_LETTER%>(<%=LNG_TEXT_GIVEN_NAME%>)" /></td>
				</tr><tr>
					<th><%=LNG_TEXT_ENGLISH_LETTER%>(<%=LNG_TEXT_FAMILY_NAME%>)</th>
					<td colspan="3"><input type="text" name="E_name_Last" class="input_text imes" maxlength="30" size="24" placeholder="<%=LNG_TEXT_ENGLISH_LETTER%>(<%=LNG_TEXT_FAMILY_NAME%>)" /></td>
				</tr> -->
				<tr>
					<th><%=LNG_TEXT_ID%>&nbsp;<%=starText%></th>
					<td>
						<input type="text" name="strID" class="input_text imes vmiddle" maxlength="20" <%=toNoKorText%> placeholder="" />
						<input type="button" class="txtBtn j_medium" onclick="join_idcheck();" value="<%=LNG_TEXT_DOUBLE_CHECK%>"/>
						<span class="summary" id="idCheck"><%=LNG_JOINSTEP03_U_TEXT04%>
							<input type="hidden" name="idcheck" value="F" readonly="readonly" />
							<input type="hidden" name="chkID" value="" readonly="readonly" />
						</span>
					</td>
				</tr>
				<tr>
					<th><%=LNG_TEXT_PASSWORD%>&nbsp;<%=starText%></th>
					<td colspan="3"><input type="password" name="strPass" class="input_text imes" maxlength="20" size="24" onkeyup="noSpace('strPass');" placeholder="" /><span class="summary"><%=LNG_TEXT_PASSWORD_TYPE%></span></td>
				</tr><tr>
					<th><%=LNG_TEXT_PASSWORD_CONFIRM%>&nbsp;<%=starText%></th>
					<td colspan="3"><input type="password" name="strPass2" class="input_text imes" maxlength="20" size="24" onkeyup="noSpace('strPass');" placeholder="" /></td>
				</tr>

				<%If S_SellMemTF = 0 Then%>
				<tr class="line">
					<th><%=LNG_TEXT_CENTER%>&nbsp;<%=starText%></th>
					<td>
						<select name="businessCode" style="width:220px;" class="input_select">
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
					</td>
				</tr>
				<%End If %>

				<%
					'▣소비자 분기
					If S_SellMemTF = 1 Then
						starText_NOMIN		= starText
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
				<%If DKRSVI_CHECK <> "T" Then%>
				<tr>
					<th><%=CS_NOMIN%>&nbsp;<%=starText_NOMIN%></th>
					<td>
					<%'If DKRSVI_WEBID = "" Then%>
						<input type="text" name="voter" class="input_text vmiddle readonly" value="<%=DKRSVI_MNAME%>" maxlength="12" size="24" readonly="readonly" onclick="" placeholder="" />
						<!-- <input type="button" class="txtBtn j_medium" onclick="vote_idcheck();" value="<%=LNG_TEXT_SEARCH%>"/> -->
						<%'#modal dialog%>
						<a name="modal" id="popvoter" href="/common/pop_voter.asp" title="<%=CS_NOMIN%>&nbsp;<%=LNG_TEXT_SEARCH%>"><input type="button" class="txtBtn j_medium" value="<%=LNG_TEXT_SEARCH%>"  /></a>
						<!-- <input type="button" class="txtBtn j_medium" onclick="vote_company();" value="<%=LNG_STRFUNCDATA_TEXT06%>"/> -->

					<%'Else%>
						<!-- <span class="font14px"><%=DKRSVI_MNAME%>(<%=DKRSVI_MBID1%>-<%=DKRSVI_MBID2%>)</span> -->
					<%'End If%>
						<%If S_SellMemTF = 1 Then	'소비자 선택%>
							<!-- <input type="button" class="txtBtn j_medium" onclick="vote_company();" value="<%=LNG_STRFUNCDATA_TEXT06%>"/> -->
						<%End If%>
					</td>
				</tr>
				<%'If S_SellMemTF = 0 Then	'판매원만 선택%>
				<tr>
					<th><%=CS_SPON%>&nbsp;<%=starText_SPON%></th>
					<td>
						<input type="text" name="sponsor" class="input_text vmiddle readonly" maxlength="12" size="24" readonly="readonly" placeholder="" />
						<!-- <input type="button" class="txtBtn j_medium" onclick="spon_idcheck();" value="<%=LNG_TEXT_SEARCH%>" /> -->
						<%'#modal dialog%>
						<a name="modal" id="popSponsor" href="/common/pop_sponsor.asp" title="<%=CS_SPON%>&nbsp;<%=LNG_TEXT_SEARCH%>" ><input type="button" class="txtBtn j_medium" value="<%=LNG_TEXT_SEARCH%>" /></a>
						<!-- <input type="hidden" name="sponLine" value="" readonly="readonly" /> -->
						<!-- <input type="button" class="txtBtn j_medium" onclick="spon_company();" value="<%=LNG_STRFUNCDATA_TEXT06%>"/> -->
					</td>
				</tr>
				<%'End If%>

				<%End If%>

				<%If S_SellMemTF = 0 Then%>
				<tr>
					<th><%=LNG_TEXT_BANKNAME%> / <%=LNG_TEXT_BANKNUMBER%></th>
					<td>
						<select name="bankCode" class="input_select vbottom">
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
						<input type="text" name="BankNumber" class="input_text" maxlength="20" <%=onLyKeys%> />
					</td>
				</tr><tr>
					<th><%=LNG_TEXT_BANKOWNER%></th>
					<td>
						<%If UCase(DK_MEMBER_NATIONCODE) = "KR" And NICE_BANK_CONFIRM_TF = "T" Then '핸폰폰인증 사용 + 계좌인증 사용 시%>
							<span class="tweight"><%=strName%></span>
							<span style="margin-left: 30px;"><input type="button" class="txtBtnC medium green" style="width:100px;	padding:3px 5px 3px 5px;font-size: 14px;" onclick="javascript: ajax_accountChk();" value="계좌 본인인증"/></span>
							<span id="result_text" class="tweight"></span>
							<input type="hidden" name="bankOwner" value="<%=strName%>" readonly="readonly" />
							<input type="hidden" name="M_Name_Last" value="<%=M_Name_Last%>"  readonly="readonly" />
							<input type="hidden" name="M_Name_First" value="<%=M_Name_First%>"  readonly="readonly" />
							<input type="hidden" name="strBankCodeCHK" value="" readonly="readonly" />
							<input type="hidden" name="strBankNumCHK" value="" readonly="readonly" />
							<input type="hidden" name="strBankOwnerCHK" value="" readonly="readonly" />
							<input type="hidden" name="birthYYCHK" value="" readonly="readonly" />
							<input type="hidden" name="birthMMCHK" value="" readonly="readonly" />
							<input type="hidden" name="birthDDCHK" value="" readonly="readonly" />
							<input type="hidden" name="TempDataNum" value="" readonly="readonly" />
							<input type="hidden" name="ajaxTF" value="F" readonly="readonly" />
						<%Else %>
							<input type="text" name="bankOwner" class="input_text vmiddle" />
						<%End If%>
					</td>
				</tr>
				<%End If%>
			</table>
		</div>

		<div class="tableArea">
			<p class="s_title"><%=LNG_TEXT_MEMBER_ADDITIONAL_INFO%></p>
			<table <%=tableatt%> class="width100">
				<col width="200" />
				<col width="*" />
				<tr class="line">
					<th><%=LNG_TEXT_SEX%>&nbsp;<%=starText%></th>
					<td>
						<label><input type="radio" name="isSex" value="M" checked="checked" class="input_radio" /> <%=LNG_TEXT_MALE%></label>
						<label style="margin-left:7px;"><input type="radio" name="isSex" value="F" class="input_radio" /> <%=LNG_TEXT_FEMALE%></label>
					</td>
				</tr>
				<%Select Case UCase(DK_MEMBER_NATIONCODE)%>
					<%Case "KR"%>
					<tr>
						<th><%=LNG_TEXT_ADDRESS1%>&nbsp;<%=starText_ADDRESS1%></th>
						<td>
							<input type="text" name="strZip" id="strZipDaum" class="input_text readonly vmiddle" style="width:60px;" maxlength="7" readonly="readonly" placeholder="" />
							<input type="button" class="txtBtn j_medium" onclick="execDaumPostcode('oris');" value="<%=LNG_TEXT_ZIPCODE%>" />
							<input type="text" name="strADDR1" id="strADDR1Daum" class="input_text readonly vmiddle" style="width:380px;" maxlength="500" readonly="readonly" placeholder="" />
						</td>
					</tr><tr>
						<th><%=LNG_TEXT_ADDRESS2%>&nbsp;<%=starText_ADDRESS2%></th>
						<td><input type="text" class="input_text" name="strADDR2" id="strADDR2Daum" style="width:500px; ime-mode:active;" maxlength="500" placeholder="" /></td>
					</tr>
					<%Case "JP"%>
					<tr>
						<th><%=LNG_TEXT_ADDRESS1%>&nbsp;<%=starText%></th>
						<td>
							<input type="text" name="strZip" class="input_text readonly vmiddle" style="width:60px;" maxlength="7" readonly="readonly" placeholder="" />
							<input type="button" class="txtBtn j_medium" onclick="openzip_jp();" value="<%=LNG_TEXT_ZIPCODE%>" />
							<input type="text" name="strADDR1" class="input_text readonly vmiddle" style="width:380px;" maxlength="500" readonly="readonly" placeholder="" />
						</td>
					</tr><tr>
						<th><%=LNG_TEXT_ADDRESS2%>&nbsp;<%=starText%></th>
						<td><input type="text" class="input_text" name="strADDR2" id="strADDR2Daum" style="width:500px; ime-mode:active;" maxlength="500" placeholder="" /></td>
					</tr>
					<%Case Else%>
					<tr>
						<th><%=LNG_TEXT_ADDRESS1%>&nbsp;<%=starText%></th>
						<td>
							<input type="text" name="strADDR1" id="strADDR1Daum" class="input_text vmiddle imes" style="width:380px;" maxlength="500" placeholder="" />
							<span style="line-height:28px;padding-left:10px;"> (ZipCode) </span><input type="text" name="strZip" id="strZip" class="input_text vmiddle imes" style="width:60px;" value="" maxlength="7" <%=onLyKeys3%> />
						</td>
					</tr><tr>
						<th><%=LNG_TEXT_ADDRESS2%>&nbsp;<%=starText%></th>
						<td><input type="text" class="input_text imes" name="strADDR2" id="strADDR2Daum" style="width:500px;" maxlength="500" placeholder="" /></td>
					</tr>
				<%End Select%>
				<tr>
					<th><%=LNG_TEXT_MOBILE%>&nbsp;<%=starText_MOBILE%></th>
					<td>
						<!-- <input type="text" class="input_text" name="strMobile" style="width:250px;" maxlength="15" <%=onLyKeys%> value="" />
						<span class="summary"><%=LNG_JOINSTEP03_U_TEXT24%></span> -->
						<input type="hidden" name="strMobile" value="<%=DKRSM_sMobileNo%>" readonly="readonly" />
						<%=FN_SPLIT_MOBILE(DKRSM_sMobileNo)%>
					</td>
				</tr><tr>
					<th><%=LNG_TEXT_TEL%></th>
					<td><input type="text" class="input_text" name="strTel" style="width:150px;" maxlength="15" <%=onLyKeys%> value="<%=DKRS_hometel%>" /></td>
				</tr>
				<tr>
					<th><%=LNG_TEXT_EMAIL%>&nbsp;<%=starText%></th>
					<td>
						<input type="text" name="strEmail" class="input_text imes vmiddle" maxlength="512" />
						<p style="margin-top:10px;"><span class="summary"><%=LNG_JOINSTEP03_U_TEXT29%></span></p>
						<!-- <input type="button" class="txtBtn j_medium" onclick="join_emailCheck();" value="<%=LNG_TEXT_DOUBLE_CHECK%>"/>
						<span class="summary tweight" id="emailCheckTXT"></span>
						<input type="hidden" name="emailCheck" value="F" readonly="readonly" />
						<input type="hidden" name="chkEmail" value="" readonly="readonly" /> -->
					</td>
				</tr>
				<tr>
					<th><%=LNG_TEXT_BIRTH%>&nbsp;<%=starText%></th>
					<td>
						<input type="hidden" name="birthYY" value="<%=birthYYYY%>" readonly="readonly" />
						<input type="hidden" name="birthMM" value="<%=birthMM%>" readonly="readonly" />
						<input type="hidden" name="birthDD" value="<%=birthDD%>" readonly="readonly" />
						<%=birthYYYY%>-<%=birthMM%>-<%=birthDD%>
						<label style="margin-left:20px;"><input type="radio" name="isSolar" value="S" checked="checked" class="input_radio" /> <%=LNG_TEXT_SOLAR%></label>
						<label><input type="radio" name="isSolar" value="M" class="input_radio" /> <%=LNG_TEXT_LUNAR%></label>
					</td>
				</tr>
				<%If CONST_CS_SIGNATURE_USE_TF = "T" Then%>
				<% If S_SellMemTF = "0" Then %>
				<tr>
					<th>전자서명 <%=starText%></th>
					<td>
						<canvas id="signature-pad" class="signature-pad" width=400 height=200 style="border:1px solid #ddd;"></canvas>
						<p style="padding-top:5px;"></p>
						<input type="button" id="signture_save" value="저장" class="txtBtn j_medium"/>
						<input type="button" id="signture_clear" value="초기화" class="txtBtn j_medium"/>
					</td>
				</tr>
				<script src="/jscript/signature_pad.min.js"></script>
				<script>
					$(document).ready(function(){
						var canvas = document.getElementById('signature-pad');
						function resizeCanvas() {
							var ratio =  Math.max(window.devicePixelRatio || 1, 1);
							canvas.width = canvas.offsetWidth * ratio;
							canvas.height = canvas.offsetHeight * ratio;
							canvas.getContext("2d").scale(ratio, ratio);
						}

						window.onresize = resizeCanvas;
						resizeCanvas();

						var signaturePad = new SignaturePad(canvas, {
							//backgroundColor: 'rgb(255, 255, 255)' // necessary for saving image as JPEG; can be removed is only saving as PNG or SVG
							backgroundColor: 'rgba(255, 255, 255, 0)',
						});

						$("#signture_save").on('click', function () {
							if (signaturePad.isEmpty()) {
								return alert("전자서명 후 저장을 눌러주세요.");
							}

							var data = signaturePad.toDataURL('image/png');

							$.ajax({
								method : "post",
								url : "signature_save_proc.asp",
								data : {"imageData" : data},
								success: function(xhrData) {
									jsonData = $.parseJSON(xhrData);
									if (jsonData.result == 'success') {
										$("#signature_file").val(jsonData.fileName);
										alert("전자서명이 저장되었습니다.");
										$("#signture_save").css('display', 'none');
										signaturePad.off();
										return false;
									} else {
										alert(jsonData.resultMsg);
										return false;
									}
								},
								error:function(xhrData) {
									alert("서버 통신중 에러가 발생했습니다.");
								}
							});
						});

						$("#signture_clear").on('click', function () {
							signaturePad.clear();
							$("#signture_save").css('display', '');
							$("#signature_file").val('');
							signaturePad.on();
						});
					});
				</script>
				<% End If %>
				<%End If %>
			</table>
		</div>
		<input type="hidden" id="signature_file" name="signature_file" />

		<div class="btnZone tcenter">
			<span><a href="joinStep01.asp" type="button" class="txtBtnC large radius10 gray" style="min-width:140px;"><%=LNG_TEXT_JOIN_CANCEL%></a></span>
			<span class="pL10"><input type="submit" class="txtBtnC large radius10 blue h22" style="width:120px;" value="<%=LNG_TEXT_JOIN%>" /></span>
		</div>
	</form>

</div>


<%'▣ 추천/후원인 선택 modal▣%>
<!--#include virtual="/_include/modal_config.asp" -->

<!--#include virtual="/_include/copyright.asp" -->
