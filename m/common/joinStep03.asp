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

	snsType = pRequestTF("snsType",False) : If snsType = "" Then snsType = ""
	snsToken = pRequestTF("snsToken",False) : If snsToken = "" Then snsToken = ""
	snsName = pRequestTF("snsName", False)	: If snsName = "" Then snsName = ""
	snsEmail = pRequestTF("snsEmail", False)	: If snsEmail = "" Then snsEmail = ""
	snsBirthday = pRequestTF("snsBirthday", False)	: If snsBirthday = "" Then snsBirthday = ""
	snsBirthyear = pRequestTF("snsBirthyear", False)	: If snsBirthyear = "" Then snsBirthyear = ""
	snsGender = pRequestTF("snsGender", False)	: If snsGender = "" Then snsGender = ""
	snsMobile = pRequestTF("snsMobile", False)	: If snsMobile = "" Then snsMobile = "" Else snsMobile = Replace(snsMobile,"-","") End If


	CENTER_SELECT_TF = "T"		'센터선택 기본값
	Select Case S_SellMemTF
		Case 0
			sview = 2
			LNG_TEXT_BUSINESS_MEMBER = LNG_TEXT_BUSINESS_MEMBER
			IF CS_NOMIN_CENTER_0_TF = "T" Then CENTER_SELECT_TF = "F"
		Case 1
			sview = 1
			LNG_TEXT_BUSINESS_MEMBER = LNG_TEXT_NORMAL_MEMBER
			IF CS_NOMIN_CENTER_1_TF = "T" Then CENTER_SELECT_TF = "F"

			If NICE_MOBILE_CONFIRM_TF = "T" Then
				NICE_MOBILE_CONFIRM_TF = NICE_MOBILE_CONFIRM_SOBIJA	'소비자회원 핸드폰인증
			End If

			NICE_BANK_CONFIRM_TF = "F"

		Case Else
			Call ALERTS(LNG_MEMBER_LOGINOK_ALERT02,"BACK","")
	End Select

	'외국인 휴대전화F, 계좌인증F 초기화
	If UCase(DK_MEMBER_NATIONCODE) <> "KR" Then
		NICE_MOBILE_CONFIRM_TF = "F"
		NICE_BANK_CONFIRM_TF = "F"
	End If

'	Select Case UCase(LANG)
'		Case "KR","MN"
			If Not checkRef(houUrl &"/m/common/joinStep02.asp") Then Call alerts(LNG_ALERT_WRONG_ACCESS,"go","/m/common/joinStep01.asp")
'		Case Else
'			Call alerts(LNG_ALERT_WRONG_ACCESS,"back","")
'	End Select

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

	agree01 = pRequestTF("agree01",False)
	agree02 = pRequestTF("agree02",False)
	agree03 = pRequestTF("agree03",False)
	agree04 = pRequestTF("agree04",False)

	If agree01 = "" Then agree01 = "F"
	If agree02 = "" Then agree02 = "F"
	If agree03 = "" Then agree03 = "F"
	If agree04 = "" Then agree04 = "F"

	If agree01 <> "T" Then Call ALERTS(LNG_JS_POLICY01,"back","")
	If agree02 <> "T" Then Call ALERTS(LNG_JS_POLICY02,"back","")
	If S_SellMemTF = 0 Then
		If agree03 <> "T" Then Call ALERTS(LNG_JS_POLICY03,"back","")
	End If
	If agree04 <> "T" Then Call ALERTS(LNG_JS_POLICY04,"back","")
%>
<%
	If NICE_BANK_CONFIRM_TF = "T" And NICE_MOBILE_CONFIRM_TF <> "T" Then	'계좌인증, 핸드폰인증 X
		ajaxTF	= pRequestTF("ajaxTF",false)
		If ajaxTF <> "T" Then Call ALERTS("본인인증을 확인하셔야합니다.","back","")

		strBankCodeCHK		= pRequestTF("strBankCodeCHK",True)
		strBankNumCHK		= pRequestTF("strBankNumCHK",True)
		strBankOwnerCHK		= pRequestTF("strBankOwnerCHK",True)
		birthYYCHK			= pRequestTF("birthYYCHK",True)
		birthMMCHK			= pRequestTF("birthMMCHK",True)
		birthDDCHK			= pRequestTF("birthDDCHK",True)
		TempDataNum			= pRequestTF("TempDataNum",True)

		bankCode			= pRequestTF("bankCode",True)
		bankNumber		= pRequestTF("bankNumber",True)
		bankOwner		= pRequestTF("bankOwner",True)

		If strBankCodeCHK	<> bankCode		Then Call ALERTS("데이터에 변조가 있었습니다.다시 진행해주세요.1","go","joinStep01.asp")
		If strBankNumCHK	<> bankNumber		Then Call ALERTS("데이터에 변조가 있었습니다.다시 진행해주세요.2","go","joinStep01.asp")
		If strBankOwnerCHK	<> bankOwner		Then Call ALERTS("데이터에 변조가 있었습니다.다시 진행해주세요.3","go","joinStep01.asp")

		If birthYYCHK		<> birthYY		Then Call ALERTS("데이터에 변조가 있었습니다.다시 진행해주세요.6","go","joinStep01.asp")
		If birthMMCHK		<> birthMM		Then Call ALERTS("데이터에 변조가 있었습니다.다시 진행해주세요.6","go","joinStep01.asp")
		If birthDDCHK		<> birthDD		Then Call ALERTS("데이터에 변조가 있었습니다.다시 진행해주세요.6","go","joinStep01.asp")

		birthYYMMDD	= Right(birthYY,2)&birthMM&birthDD			'생년월일체크 YYMMDD

		'▣암호화후 템프테이블데이터와 비교
		Set objEncrypter = Server.CreateObject("Hyeongryeol.StringEncrypter")
			objEncrypter.Key = con_EncryptKey
			objEncrypter.InitialVector = con_EncryptKeyIV
			If birthYYMMDD	<> "" Then Enc_birthYYMMDD		= objEncrypter.Encrypt(birthYYMMDD)			'생년월일 암호화(YYMMDD)
		Set objEncrypter = Nothing

		arrParams = Array(_
			Db.makeParam("@TempDataNum",adVarChar,adParamInput,50,TempDataNum),_
			Db.makeParam("@strSSH1",adChar,adParamInput,50,Enc_birthYYMMDD),_
			Db.makeParam("@strSSH2",adChar,adParamInput,50,Enc_birthYYMMDD)_
		)
		Set DKRS = Db.execRs("DKP_MEMBER_JOIN_BANK_VIEW",DB_PROC,arrParams,DB3)

		If Not DKRS.BOF And Not DKRS.EOF Then
			DKRS_intIDX				= DKRS("intIDX")
			DKRS_TempDataNum		= DKRS("TempDataNum")
			DKRS_strName			= DKRS("strName")
			DKRS_strSSH1			= DKRS("strSSH1")			'생년월일 YYMMDD
			DKRS_strSSH2			= DKRS("strSSH2")			'생년월일 YYMMDD
			DKRS_strCenterName		= DKRS("strCenterName")
			DKRS_strCenterCode		= DKRS("strCenterCode")
			DKRS_strBankCode		= DKRS("strBankCode")
			DKRS_strBankNum			= DKRS("strBankNum")
			DKRS_strBankOwner		= DKRS("strBankOwner")
			DKRS_strOrderNum		= DKRS("strOrderNum")
			DKRS_M_Name_First		= DKRS("M_Name_First")
			DKRS_M_Name_Last		= DKRS("M_Name_Last")
		Else
			Call ALERTS("데이터베이스에 없는 데이터입니다. 다시 시도해주세요.","BACK","")
		End If
		Call closeRs(DKRS)

		'▣템프테이블 데이터 복호화후 비교
		Set objEncrypter = Server.CreateObject("Hyeongryeol.StringEncrypter")
			objEncrypter.Key = con_EncryptKey
			objEncrypter.InitialVector = con_EncryptKeyIV
			If DKRS_strBankNum		<> "" Then DKRS_strBankNum	= objEncrypter.Decrypt(DKRS_strBankNum)
			If DKRS_strSSH1			<> "" Then DKRS_strSSH1		= objEncrypter.Decrypt(DKRS_strSSH1)
			If DKRS_strSSH2			<> "" Then DKRS_strSSH2		= objEncrypter.Decrypt(DKRS_strSSH2)
		Set objEncrypter = Nothing

		If DKRS_strBankCode		<>	bankCode			Then Call ALERTS("데이터에 변조가 있었습니다.다시 진행해주세요.6","go","joinStep01.asp")
		If DKRS_strBankNum		<>	bankNumber			Then Call ALERTS("데이터에 변조가 있었습니다.다시 진행해주세요.7","go","joinStep01.asp")
		If DKRS_strBankOwner	<>	bankOwner		Then Call ALERTS("데이터에 변조가 있었습니다.다시 진행해주세요.8","go","joinStep01.asp")
		If DKRS_TempDataNum		<>	TempDataNum			Then Call ALERTS("데이터에 변조가 있었습니다.다시 진행해주세요.11","go","joinStep01.asp")
		If DKRS_strSSH1			<>	birthYYMMDD			Then Call ALERTS("데이터에 변조가 있었습니다.다시 진행해주세요.12","go","joinStep01.asp")
		If DKRS_strSSH2			<>	birthYYMMDD			Then Call ALERTS("데이터에 변조가 있었습니다.다시 진행해주세요.13","go","joinStep01.asp")

	End If
%>
<%


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

%>
<%
	If NICE_MOBILE_CONFIRM_TF = "T" Then
		'#####################################
		'	NICE 본인인증(핸드폰)
		'#####################################

		sRequestNO = pRequestTF("sRequestNO",True)

		If session("REQ_SEQ") <> sRequestNO Then Call ALERTS("세션값이 다릅니다. 올바른 경로로 접근하시기 바랍니다","go", MOB_PATH&"/common/joinStep01.asp")

		'▣ 인증 데이터 확인 S
			Set XTEncrypt = new XTclsEncrypt
			'RChar = XTEncrypt.MD5(RandomChar(10))
			mob_RChar = makeMemTempNum&RandomChar(10)		'mob_RChar

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
					Call ALERTS("휴대폰정보가 없습니다..","GO", MOB_PATH&"/common/joinStep01.asp")
				End If

				'CS회원 중복체크
				SQL_CK = "SELECT MBID,MBID2,M_NAME,WebID FROM [tbl_memberInfo] (nolock) WHERE [hptel] = ? AND [hptel] <> '' "
				arrParams_CK = Array(_
					Db.makeParam("@mobileAuth",adVarChar,adParamInput,88,DKRSM_sMobileNo) _
				)
				Set DKRSM = Db.execRs(SQL_CK,DB_TEXT,arrParams_CK,DB3)
				If Not DKRSM.BOF And Not DKRSM.EOF Then
					Call ALERTS("이미 등록된 회원입니다.","GO", MOB_PATH&"/common/member_login.asp")
				Else

					Set objEncrypter = Server.CreateObject("Hyeongryeol.StringEncrypter")
						objEncrypter.Key = con_EncryptKey
						objEncrypter.InitialVector = con_EncryptKeyIV
						On Error Resume Next
							If DKRSM_sMobileNo		<> "" Then DKRSM_sMobileNo		= objEncrypter.Decrypt(DKRSM_sMobileNo)
							If mob_RChar	<> "" Then mob_RChar	= objEncrypter.Encrypt(mob_RChar)
						On Error GoTo 0
					Set objEncrypter = Nothing

					arrParams = Array(_
						Db.makeParam("@TempDataNum",adVarChar,adParamInput,50,mob_RChar), _
						Db.makeParam("@sRequestNO",adVarChar,adParamInput,30,sRequestNO), _
						Db.makeParam("@sResponseNumber",adVarChar,adParamInput,24,sResponseNumber), _
						Db.makeParam("@sDupInfo",adVarChar,adParamInput,64,DKRSM_sDupInfo) _
					)
					Call Db.exec("DKSP_MEMBER_JOIN_TEMP_INSERT",DB_PROC,arrParams,Nothing)
					SESSION("dataNum") = mob_RChar
				End If
			Else
				Call ALERTS("본인인증 데이터가 존재하지 않습니다. 본인인증을 다시 하셔야합니다.","GO", MOB_PATH&"/common/joinStep01.asp")
			End If
			Call closeRs(DKRSM)

			If Len(DKRSM_sBirthDate) = 8  Then
				strBirthYY = Left(DKRSM_sBirthDate,4)
				strBirthMM = Mid(DKRSM_sBirthDate,5,2)
				strBirthDD = Right(DKRSM_sBirthDate,2)
			Else
				Call ALERTS("생년월일 데이터가 존재하지 않습니다. 본인인증을 다시 하셔야합니다.","GO", MOB_PATH&"/common/joinStep01.asp")
			End If

			'성/이름 분리
			If DKRSM_sName <> "" Then
				Call FnNameSeparation(DKRSM_sName, M_Name_Last, M_Name_First)
			End If

		'▣ 인증 데이터 확인 E

		'Call ResRW(SESSION("dataNum"),"SESSION(dataNum)")
		'Call ResRW(SESSION("sResponseNumber"),"SESSION(sResponseNumber)")
		'Call ResRW(SESSION("REQ_SEQ"),"SESSION(REQ_SEQ)")

		'위변조 체크
		IF strName <> DKRSM_sName Then Call ALERTS("데이터에 변조가 있었습니다.다시 진행해주세요_1","go","joinStep01.asp")
		IF birthYY <> strBirthYY Then Call ALERTS("데이터에 변조가 있었습니다.다시 진행해주세요_2","go","joinStep01.asp")
		IF birthMM <> strBirthMM Then Call ALERTS("데이터에 변조가 있었습니다.다시 진행해주세요_2","go","joinStep01.asp")
		IF birthDD <> strBirthDD Then Call ALERTS("데이터에 변조가 있었습니다.다시 진행해주세요_2","go","joinStep01.asp")

	End If
%>
<!--#include virtual = "/m/_include/document.asp"-->
<!--#include virtual = "/m/_include/jqueryload.asp"-->
<link rel="stylesheet" href="/m/js/icheck/skin/line/_all.css" />
<script type="text/javascript" src="/m/js/check.js"></script>
<script src="/m/js/icheck/icheck.min.js"></script>
<!--#include file = "joinStep03.js.asp"--><%'JS%>
</head>
<body onunload="">
<!--#include virtual = "/m/_include/header.asp"-->
<div id="join03" class="joinstep">
	<form name="cfrm" method="post" action="joinStepOK.asp" onsubmit="return chkSubmit(this);">
		<input type="hidden" name="S_SellMemTF" value="<%=S_SellMemTF%>" readonly />
		<input type="hidden" name="cnd" value="<%=R_NationCode%>" readonly />
		<input type="hidden" name="agree01" value="<%=agree01%>" />
		<input type="hidden" name="agree02" value="<%=agree02%>" />
		<input type="hidden" name="agree03" value="<%=agree03%>" />

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

		<%If NICE_BANK_CONFIRM_TF = "T" Then	'bank confirm %>
			<input type="hidden" name="bankOwner" value="<%=strName%>" readonly="readonly" />
			<input type="hidden" name="M_Name_Last" value="<%=M_Name_Last%>"  readonly="readonly" />
			<input type="hidden" name="M_Name_First" value="<%=M_Name_First%>"  readonly="readonly" />

			<input type="hidden" name="strBankCodeCHK" value="<%=strBankCodeCHK%>" readonly="readonly" />
			<input type="hidden" name="strBankNumCHK" value="<%=strBankNumCHK%>" readonly="readonly" />
			<input type="hidden" name="strBankOwnerCHK" value="<%=strBankOwnerCHK%>" readonly="readonly" />
			<input type="hidden" name="birthYYCHK" value="<%=birthYYCHK%>" readonly="readonly" />
			<input type="hidden" name="birthMMCHK" value="<%=birthMMCHK%>" readonly="readonly" />
			<input type="hidden" name="birthDDCHK" value="<%=birthDDCHK%>" readonly="readonly" />
			<input type="hidden" name="TempDataNum" value="<%=TempDataNum%>" readonly="readonly" />
			<input type="hidden" name="ajaxTF" value="F" readonly="readonly" />
		<%End If%>

		<%'SNS 가입관련%>
		<input type="hidden" name="snsType" value = "<%=snsType%>" readonly="readonly">
		<input type="hidden" name="snsToken" value = "<%=snsToken%>" readonly="readonly">
		<input type="hidden" name="snsName" value = "<%=snsName%>" readonly="readonly">
		<input type="hidden" name="snsEmail" value = "<%=snsEmail%>" readonly="readonly">
		<input type="hidden" name="snsBirthday" value = "<%=snsBirthday%>" readonly="readonly">
		<input type="hidden" name="snsBirthyear" value = "<%=snsBirthyear%>" readonly="readonly">
		<input type="hidden" name="snsGender" value = "<%=snsGender%>" readonly="readonly">
		<input type="hidden" name="snsMobile" value = "<%=snsMobile%>" readonly="readonly">

		<div class="wrap">
			<h6><%=LNG_TEXT_MEMBER_BASIC_INFO%></h6>
			<table <%=tableatt%> class="width100">
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
				<%If snsToken <> "" Then%>
				<!-- <tr class="id">
					<th><%=LNG_TEXT_ID%>&nbsp;<%=starText%></th>
					<td><b>SNS 회원가입</b></td>
				</tr> -->
				<%Else%>
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
				<%End If%>

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
					'▣소비자 분기
					If S_SellMemTF = 1 Then
						starText_NOMIN		= ""
						starText_SPON		= starText
						starText_ADDRESS1	= ""
						starText_ADDRESS2	= ""
						starText_MOBILE		= ""
						starText_bankNumber		= ""
						starText_bankOwner		= ""
						starText_email		= ""
						bankOwner = ""
					Else
						starText_NOMIN		= starText
						starText_SPON		= starText
						starText_ADDRESS1	= starText
						starText_ADDRESS2	= starText
						starText_MOBILE		= starText
						starText_bankNumber		= starText
						starText_bankOwner		= starText
						starText_email		= ""		'선택 COSMICO 2022-08-17

						If starText_bankNumber <> "" Then
							bankOwner = strName
						End If
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
				<%if 1=2    then 'cosmico%>
				<tr class="spon">
					<th><%=CS_SPON%>&nbsp;<%=starText_SPON%></th>
					<td>
						<%'#modal dialog%>
						<div class="inputs">
							<input type="text" name="sponsor" class="" value="" readonly="readonly" style="background-color:#efefef;" />
							<a name="modal" id="popSponsor" class="button" href="/m/common/pop_sponsor.asp" title="<%=CS_SPON%>&nbsp;<%=LNG_TEXT_SEARCH%>"><%=LNG_TEXT_SEARCH%></a>
						</div>
						<input type="hidden" name="sponLine" value="" readonly="readonly" />
					</td>
				</tr>
				<%End If%>

				<%If S_SellMemTF = 0 Then%>
					<%If NICE_BANK_CONFIRM_TF = "T" And NICE_MOBILE_CONFIRM_TF <> "T" Then%>
						<tr class="bank">
							<th><%=LNG_TEXT_BANKNAME%></th>
							<td>[<%=Fnc_bankname(DKRS_strBankCode)%>] / <%=DKRS_strBankNum%></td>
						</tr>
						<tr>
							<th><%=LNG_TEXT_BANKOWNER%></th>
							<td><%=DKRS_strBankOwner%></td>
						</tr>
					<%Else%>
					<tr class="bank">
						<th><%=LNG_TEXT_BANKNAME%> <%=starText_bankNumber%></th>
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
						<th><%=LNG_TEXT_BANKNUMBER%> <%=starText_bankNumber%></th>
						<td><input type="text" name="bankNumber" class="" maxlength="100" <%=onLyKeys3%> /></td>
					</tr>
					<tr>
						<th><%=LNG_TEXT_BANKOWNER%> <%=starText_bankOwner%></th>
						<td>
							<%If NICE_BANK_CONFIRM_TF = "T" Then%>
								<b><%=strName%></b>
								<input type="button" class="button" onclick="ajax_accountChk();" value="계좌 본인인증"/>
								<p class="summary" id="result_text"></p>
							<%Else%>
								<%If bankOwner <> "" Then%>
									<b><%=bankOwner%></b><%'예금주 고정%>
									<input type="hidden" name="bankOwner" value="<%=bankOwner%>" readonly="readonly" />
									<input type="hidden" name="bankCheck" value="F" readonly="readonly" />
									<input type="hidden" name="bankCodeCHK" value="" readonly="readonly" />
									<input type="hidden" name="bankNumberCHK" value="" readonly="readonly" />
									<input type="button" class="button" onclick="join_bankCheck();" value="<%=LNG_TEXT_DOUBLE_CHECK%>"/>
									<p class="summary" id="bankCheckTXT"></p>
								<%Else%>
									<input type="text" name="bankOwner" class="" maxlength="100" />
								<%End If%>
							<%End If%>
						</td>
					</tr>
					<%End If%>
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
							<label class="checkbox"><input type="radio" name="isSex" value="M" <%=isChecked(snsGender,"M")%> checked="checked"/><span><i class="icon-ok"></i><%=LNG_TEXT_MALE%></span></label>
							<label class="checkbox"><input type="radio" name="isSex" value="F" <%=isChecked(snsGender,"F")%> /><span><i class="icon-ok"></i><%=LNG_TEXT_FEMALE%></span></label>
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
						<%If DKRSM_sMobileNo <> "" Then%>
							<input type="hidden" name="strMobile" value="<%=DKRSM_sMobileNo%>" readonly="readonly" />
							<input type="hidden" name="chkMobile" value="<%=DKRSM_sMobileNo%>" readonly="readonly" />
							<%=FN_SPLIT_MOBILE(DKRSM_sMobileNo)%>
						<%Else%>
							<div class="inputs">
								<input type="tel" name="strMobile" maxlength="15" class="" <%=onLyKeys%> oninput="maxLengthCheck(this)" value="<%=snsMobile%>" />
								<input type="button" name="" onclick="join_MobileCheck();" class="button" value="<%=LNG_TEXT_DOUBLE_CHECK%>" /></div>
							</div>
							<p class="summary" id="mobileCheckTXT"></p>
							<input type="hidden" name="mobileCheck" value="F" readonly="readonly" />
							<input type="hidden" name="chkMobile" value="" readonly="readonly" />
							<p class="summary"><%=LNG_JOINSTEP03_U_TEXT24%></p>
						<%End If%>
					</td>
				</tr>
				<%If snsToken = "" Then%>
				<tr>
					<th><%=LNG_TEXT_TEL%></th>
					<td>
						<input type="tel" name="strTel" maxlength="15" <%=onLyKeys%> oninput="maxLengthCheck(this)" />
					</td>
				</tr>
				<%End If%>
				<tr>
					<th><%=LNG_TEXT_EMAIL%>&nbsp;<%=starText_email%></th>
					<td>
						<div class="inputs">
							<input type="email" name="strEmail" value="<%=snsEmail%>" maxlength="200" />
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
