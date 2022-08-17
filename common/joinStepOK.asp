<!--#include virtual = "/_lib/strFunc.asp" -->
<!--#include virtual = "/_lib/strFuncJoin.asp"-->
<!--#include virtual = "/_lib/KISA_SHA256.asp"-->
<%
	NO_MEMBER_REDIRECT = "F"
%>
<!--#include virtual = "/_include/document.asp"-->
</head>
<body>
<%
	PAGE_SETTING = "MEMBERSHIP"

	If DK_MEMBER_LEVEL > 0 Then Response.Redirect "/index.asp"

	'▣글로벌, 판매원, 소비자 통합
	S_SellMemTF = pRequestTF("S_SellMemTF",True)
	Select Case S_SellMemTF
		Case 0

		Case 1
			'소지바 계좌인증 X
			NICE_BANK_CONFIRM_TF = "F"
		Case Else
			Call ALERTS(LNG_MEMBER_LOGINOK_ALERT02,"BACK","")
	End Select

	'외국인 휴대전화F, 계좌인증F 초기화
	If UCase(DK_MEMBER_NATIONCODE) <> "KR" Then
		NICE_MOBILE_CONFIRM_TF = "F"
		NICE_BANK_CONFIRM_TF = "F"
	End If


	'국가정보
''	R_NationCode = Trim(pRequestTF("cnd",True))
	R_NationCode = Trim(pRequestTF("Na_Code",True))

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

	'◆언어선택 치환명령 추가
	DK_MEMBER_NATIONCODE 	= R_NationCode
	LANG 					= R_NationCode

'	Select Case UCase(LANG)
'		Case "KR","MN"
			If Not checkRef(houUrl &"/common/joinStep03.asp") Then Call alerts(LNG_ALERT_WRONG_ACCESS,"go","/common/joinStep01.asp")
'		Case Else
'			Call alerts(LNG_ALERT_WRONG_ACCESS,"back","")
'	End Select


		agree01 = pRequestTF("agree01",False)
		agree02 = pRequestTF("agree02",False)
		agree03 = pRequestTF("agree03",False)

		If agree01 = "" Then agree01 = "F"
		If agree02 = "" Then agree02 = "F"
		If agree03 = "" Then agree03 = "F"

		If agree01 <> "T" Then Call ALERTS(LNG_JS_POLICY01,"back","")
		If agree02 <> "T" Then Call ALERTS(LNG_JS_POLICY02,"back","")
		If S_SellMemTF = 0 Then
			If agree03 <> "T" Then Call ALERTS(LNG_JS_POLICY03,"back","")
		End If


	' 값 받아오기
		MotherSite		= strHostA' Trim(getRequest("MotherSite",False)
		dataNum			= pRequestTF("dataNum",True)


		E_name			= pRequestTF("E_name",False)		'영문이름
		E_name_Last		= pRequestTF("E_name_Last",False)	'영문성
		For_Kind_TF		= pRequestTF("For_Kind_TF",True)	'외국인 체크(한국 0 그 외 국가 1)

		'####################################################################
		'########## ▣ SNS 관련 ▣
		'####################################################################
			'sns_authID		= pRequestTF("sns_authID",False)	: If sns_authID = "" Then sns_authID = ""
			snsType		= pRequestTF("snsType", False)
			snsToken	= pRequestTF("snsToken", False)
			If snsToken <> "" Then
				'snsToken = SHA256_Encrypt(snsToken)

				'▣SNS 위변조 검증
				arrParams = Array(_
					Db.makeParam("@sessionIDX",adVarChar,adParamInput,50,DK_SES_MEMBER_IDX),_
					Db.makeParam("@snsType",adVarChar,adParamInput,10,snsType),_
					Db.makeParam("@snsToken",adVarWChar,adParamInput,100,snsToken),_
					Db.makeParam("@hostIP",adVarChar,adParamInput,50,getUserIP) _
				)
				SNS_FAKE_CHECK_CNT = Db.execRsData("HJP_SNS_MODULATION_CHECK_CNT",DB_PROC,arrParams,DB3)

				If Int(SNS_FAKE_CHECK_CNT) < 1 Then
					Call ALERTS("Data modulation! (SNS)","go","/common/joinStep01.asp")
				End If
			End If


		'▣한국외
		If UCase(Lang) <> "KR" Then

			strSSH			= pRequestTF("strSSH",False)
			Passport_Number	= UCase(pRequestTF("Passport_Number",False))


		''	'외국회원 여권번호 체크
		''	If Passport_Number <> "" Then
		''		Passport_Numbercheck= pRequestTF("Passport_Numbercheck",True)
		''		chkPassport_Number	= pRequestTF("chkPassport_Number",True)
		''
		''		If Passport_Numbercheck <> "T"		Then Call ALERTS(LNG_JS_PASSPORT_NUMBER_AVAILE,"back","")
		''		If chkPassport_Number <> Passport_Number	Then Call ALERTS(LNG_JS_PASSPORT_NUMBER_CHANGED,"back","")
		''
		''		'CS Passport_Number : 암호화 & 비교
		''		Set objEncrypter = Server.CreateObject("Hyeongryeol.StringEncrypter")
		''			objEncrypter.Key = con_EncryptKey
		''			objEncrypter.InitialVector = con_EncryptKeyIV
		''
		''			If Passport_Number <> "" Then Passport_Number = objEncrypter.Encrypt(Passport_Number)
		''
		''		Set objEncrypter = Nothing
		''
		''		SQL = "SELECT COUNT([mbid]) " & _
		''				" FROM [tbl_memberinfo] WHERE [Passport_Number] = ?"
		''		arrParams = Array(_
		''			Db.makeParam("@Passport_Number",adVarchar,adParamInput,100,Passport_Number) _
		''		)
		''		PSP_CNT = Db.execRsData(SQL,DB_TEXT,arrParams,DB3)
		''
		''		If PSP_CNT  > 0 Then  Call ALERTS("This Passport Number is not available, please enter the another Number.","back","")
		''
		''	End If

		''	CityCode	= pRequestTF("CityCode",False)

		Else
			strSSH			= ""
			Passport_Number	= ""
			CityCode		= ""
		End If

	'	Call ResRW(For_Kind_TF	,"For_Kind_TF")
	'	Call ResRW(CityCode	,"CityCode")
	'	Call ResRW(strSSH	,"strSSH")
	'	Call ResRW(Passport_Number	,"Passport_Number")


		'strName			= pRequestTF("strName",True)
		If CS_AUTO_WEBID_TF <> "T" Then		'웹아이디 직접입력
			If snsToken = "" Then
				strUserID		= pRequestTF("strID",True)
				strUserID_OUT	= strUserID
				idcheck			= pRequestTF("idcheck",True)
				chkID			= pRequestTF("chkID",True)
			End IF
		End IF

		If snsToken <> "" Then
			strPass			= pRequestTF("strPass",False)
			strPass2		= pRequestTF("strPass2",False)
		Else
			strPass			= pRequestTF("strPass",True)
			strPass2		= pRequestTF("strPass2",True)
		End If

		strZip			= pRequestTF("strZip",False)
		strADDR1		= pRequestTF("strADDR1",False)
		strADDR2		= pRequestTF("strADDR2",False)

		strEmail		= pRequestTF("strEmail",False)

		isSex			= pRequestTF("isSex",True)

		strMobile		= pRequestTF("strMobile",False)
			mobileCheck		= pRequestTF("mobileCheck",False)
			chkMobile		= pRequestTF("chkMobile",False)

		strTel			= pRequestTF("strTel",False)

		strBirth1		= pRequestTF("birthyy",True)
		strBirth2		= pRequestTF("birthmm",True)
		strBirth3		= pRequestTF("birthdd",True)
		isSolar			= pRequestTF("isSolar",False)

		isMailing		= pRequestTF("sendemail",False)
		isSMS			= pRequestTF("sendsms",False)

		joinType		= pRequestTF("joinType",False)

		businessCode	= pRequestTF("businessCode",False)

		SponID1			= pRequestTF("SponID1",False)
		SponID2			= pRequestTF("SponID2",False)
		SponIDWebID		= pRequestTF("SponIDWebID",False)
		SponIDChk		= pRequestTF("SponIDChk",False)

		bankCode	 = pRequestTF("bankCode",False)
		bankOwner	 = pRequestTF("bankOwner",False)
		bankNumber	 = pRequestTF("bankNumber",False)

	''	SponLine	 = pRequestTF("SponLine",False )
	''	'▣ 선택한 라인번호 중복체크 ▣
	''	arrParams = Array(_
	''		Db.makeParam("@SAVEID",adVarChar,adParamInput,20,SponID1),_
	''		Db.makeParam("@SAVEID2",adInteger,adParamInput,0,SponID2),_
	''		Db.makeParam("@LINECNT",adSmallInt,adParamInput,0,SponLine)_
	''	)
	''	LINECOUNT = Int(Db.execRsData("HJP_LINENCT_CHECK",DB_PROC,arrParams,DB3))
	''
	''	If LINECOUNT > 0 Then Call ALERTS(LNG_JS_ALREADY_REGISTERED_LINE,"back","")
	''	'If LINECOUNT > 0 Then Call ALERTS("이미 등록된 라인입니다. 다시 한번 확인해주세요","back","")


	'추가 데이터 추천인 & 후원인 관련 S
		NominCom = pRequestTF("NominCom",True)

		If NominCom = "F" Then
			NominID1		= pRequestTF("NominID1",False)
			NominID2		= pRequestTF("NominID2",False)
			NominWebID		= pRequestTF("NominWebID",False)
			NominChk		= pRequestTF("NominChk",False)
		Else
			SQL999 = "SELECT TOP(1) mbid,mbid2 FROM [DKT_BASE_VOTER] WHERE [isUse] = 'T' ORDER BY [intIDX] DESC"
			Set DKRS999 = Db.execRs(SQL999,DB_TEXT,Nothing,DB3)

			If Not DKRS999.BOF And Not DKRS999.EOF Then
				NominID1		= DKRS999(0)
				NominID2		= DKRS999(1)
				NominWebID		= ""
				NominChk		= "T"
			Else
				NominID1		= ""
				NominID2		= ""
				NominWebID		= ""
				NominChk		= "F"
			End If
		End If
	'추가 데이터 추천인 & 후원인  관련 E

		arrParams = Array(_
			Db.makeParam("@dataNum",adVarChar,adParamInput,50,dataNum) _
		)
		Set DKRS = Db.execRs("DKP_MEMBER_DATA",DB_PROC,arrParams,DB3)

		If Not DKRS.BOF And Not DKRS.EOF Then
			strName = DKRS(1)
			strSSH1 = DKRS(2)
			strSSH2 = DKRS(3)
			M_Name_First = DKRS("M_Name_First")
			M_Name_Last	 = DKRS("M_Name_Last")
		Else
			Call ALERTS(LNG_JOINFINISH_U_ALERT07,"go","/common/joinStep01.asp")
		End If
		Call closeRS(DKRS)


%>
<%
	If NICE_MOBILE_CONFIRM_TF = "T" Then

	'#####################################
	'	NICE 본인인증(핸드폰)
	'#####################################
		SESSION_dataNum		= SESSION("dataNum")
		sResponseNumber		= SESSION("sResponseNumber")
		sRequestNumber		= SESSION("REQ_SEQ")

		'Call ResRW(SESSION("dataNum"),"SESSION(dataNum)")
		'Call ResRW(SESSION("sResponseNumber"),"SESSION(sResponseNumber)")
		'Call ResRW(SESSION("REQ_SEQ"),"SESSION(REQ_SEQ)")

		arrParamsM = Array(_
			Db.makeParam("@TempDataNum",adVarChar,adParamInput,50,SESSION_dataNum), _
			Db.makeParam("@sRequestNumber",adVarChar,adParamInput,30,sRequestNumber), _
			Db.makeParam("@sResponseNumber",adVarChar,adParamInput,24,sResponseNumber) _
		)
		Set DKRSM = Db.execRs("DKSP_MEMBER_JOIN_TEMP_VIEW",DB_PROC,arrParamsM,Nothing)
		If Not DKRSM.BOF And Not DKRSM.EOF Then
			DKRSM_intIDX			= DKRSM("intIDX")
			DKRSM_TempDataNum		= DKRSM("TempDataNum")
			DKRSM_sType				= DKRSM("sType")
			DKRSM_sCipherTime		= DKRSM("sCipherTime")
			DKRSM_sRequestNumber	= DKRSM("sRequestNumber")
			DKRSM_sResponseNumber	= DKRSM("sResponseNumber")
			DKRSM_sAuthType			= DKRSM("sAuthType")
			DKRSM_sName				= DKRSM("sName")
			DKRSM_sGender			= DKRSM("sGender")				'0:여성 / 1:남성
			DKRSM_sBirthDate		= DKRSM("sBirthDate")
			DKRSM_sNationalInfo		= DKRSM("sNationalInfo")		'0:내국인 / 1:외국인
			DKRSM_sDupInfo			= DKRSM("sDupInfo")				'중복가입 확인값 (DI_64 byte)
			DKRSM_sConnInfo			= DKRSM("sConnInfo")
			DKRSM_sMobileNo			= DKRSM("sMobileNo")
			DKRSM_sMobileCo			= DKRSM("sMobileCo")
			DKRSM_regTime			= DKRSM("regTime")
		Else
			Call ALERTS("인증데이터가 존재하지 않습니다. 인증을 다시 시도해주세요.","GO", MOB_PATH&"/common/joinStep01.asp")
		End If
		Call closeRs(DKRSM)

		Set objEncrypter = Server.CreateObject("Hyeongryeol.StringEncrypter")
			objEncrypter.Key = con_EncryptKey
			objEncrypter.InitialVector = con_EncryptKeyIV
			On Error Resume Next
				If DKRSM_sMobileNo	<> "" Then Dec_DKRSM_sMobileNo	= objEncrypter.Decrypt(DKRSM_sMobileNo)
			On Error GoTo 0
		Set objEncrypter = Nothing

		If Len(DKRSM_sBirthDate) = 8  Then
			strBirthYY = Left(DKRSM_sBirthDate,4)
			strBirthMM = Mid(DKRSM_sBirthDate,5,2)
			strBirthDD = Right(DKRSM_sBirthDate,2)
		Else
			Call ALERTS("생년월일 데이터가 존재하지 않습니다. 본인인증을 다시 하셔야합니다.","GO", MOB_PATH&"/common/joinStep01.asp")
		End If

		If strName	<>	DKRSM_sName			Then Call ALERTS("데이터에 변조가 있었습니다.다시 진행해주세요. - M01","gGO", MOB_PATH&"/common/joinStep01.asp")
		If strBirth1	<>	strBirthYY			Then Call ALERTS("데이터에 변조가 있었습니다.다시 진행해주세요. - M02","GO", MOB_PATH&"/common/joinStep01.asp")
		If strBirth2	<>	strBirthMM			Then Call ALERTS("데이터에 변조가 있었습니다.다시 진행해주세요. - M03","GO", MOB_PATH&"/common/joinStep01.asp")
		If strBirth3	<>	strBirthDD			Then Call ALERTS("데이터에 변조가 있었습니다.다시 진행해주세요. - M04","GO", MOB_PATH&"/common/joinStep01.asp")
		If strMobile	<>	Dec_DKRSM_sMobileNo	Then Call ALERTS("데이터에 변조가 있었습니다.다시 진행해주세요. - M05", "GO", MOB_PATH&"/common/joinStep01.asp")
	End If

%>
<%
	'#####################################
	'	NICE 은행 계좌인증
	'#####################################

	If NICE_BANK_CONFIRM_TF = "T" Then

		ajaxTF				= pRequestTF("ajaxTF",True)

		strBankCodeCHK		= pRequestTF("strBankCodeCHK",True)
		strBankNumCHK		= pRequestTF("strBankNumCHK",True)
		strBankOwnerCHK		= pRequestTF("strBankOwnerCHK",True)
		birthYYCHK			= pRequestTF("birthYYCHK",True)
		birthMMCHK			= pRequestTF("birthMMCHK",True)
		birthDDCHK			= pRequestTF("birthDDCHK",True)
		TempDataNum			= pRequestTF("TempDataNum",True)


		If strBankCodeCHK	<> bankCode			Then Call ALERTS("데이터에 변조가 있었습니다.다시 진행해주세요.B01","go","joinStep01.asp")
		If strBankNumCHK	<> bankNumber		Then Call ALERTS("데이터에 변조가 있었습니다.다시 진행해주세요.B02","go","joinStep01.asp")
		If strBankOwnerCHK	<> bankOwner		Then Call ALERTS("데이터에 변조가 있었습니다.다시 진행해주세요.B03","go","joinStep01.asp")
		If birthYYCHK		<> strBirth1		Then Call ALERTS("데이터에 변조가 있었습니다.다시 진행해주세요.B04","go","joinStep01.asp")
		If birthMMCHK		<> strBirth2		Then Call ALERTS("데이터에 변조가 있었습니다.다시 진행해주세요.B05","go","joinStep01.asp")
		If birthDDCHK		<> strBirth3		Then Call ALERTS("데이터에 변조가 있었습니다.다시 진행해주세요.B06","go","joinStep01.asp")

		birthYYMMDD	= Right(strBirth1,2)&strBirth2&strBirth3

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
			DKRS_strSSH1			= DKRS("strSSH1")
			DKRS_strSSH2			= DKRS("strSSH2")
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
		Call CloseRS(DKRS)

		'Call ResRW(birthYYMMDD,"birthYYMMDD")
		'Call ResRW(Enc_birthYYMMDD,"Enc_birthYYMMDD")
		'Call ResRW(strBirth1,"birthYY")
		'Call ResRW(strBirth2,"birthMM")
		'Call ResRW(strBirth3,"birthDD")
		'Call ResRW(strBankCodeCHK,"strBankCodeCHK")
		'Call ResRW(strBankNumCHK,"strBankNumCHK")
		'Call ResRW(strBankOwnerCHK,"strBankOwnerCHK")
		'Call ResRW(DKRS_strSSH1,"DKRS_strSSH1")
		'Call ResRW(DKRS_strSSH2,"DKRS_strSSH2")
		'Call ResRW(DKRS_strBankCode,"DKRS_strBankCode")
		'Call ResRW(DKRS_strBankNum,"DKRS_strBankNum")
		'Call ResRW(DKRS_strBankOwner,"DKRS_strBankOwner")

		'▣템프테이블 데이터 복호화후 비교
		Set objEncrypter = Server.CreateObject("Hyeongryeol.StringEncrypter")
			objEncrypter.Key = con_EncryptKey
			objEncrypter.InitialVector = con_EncryptKeyIV
			If DKRS_strBankNum		<> "" Then DKRS_strBankNum	= objEncrypter.Decrypt(DKRS_strBankNum)
			If DKRS_strSSH1			<> "" Then DKRS_strSSH1		= objEncrypter.Decrypt(DKRS_strSSH1)
			If DKRS_strSSH2			<> "" Then DKRS_strSSH2		= objEncrypter.Decrypt(DKRS_strSSH2)
		Set objEncrypter = Nothing

		If DKRS_strBankCode		<>	bankCode		Then Call ALERTS("데이터에 변조가 있었습니다.다시 진행해주세요.B07","go","joinStep01.asp")
		If DKRS_strBankNum		<>	bankNumber		Then Call ALERTS("데이터에 변조가 있었습니다.다시 진행해주세요.B08","go","joinStep01.asp")
		If DKRS_strBankOwner	<>	bankOwner		Then Call ALERTS("데이터에 변조가 있었습니다.다시 진행해주세요.B09","go","joinStep01.asp")
		If DKRS_TempDataNum		<>	TempDataNum		Then Call ALERTS("데이터에 변조가 있었습니다.다시 진행해주세요.B10","go","joinStep01.asp")
		If DKRS_strSSH1			<>	birthYYMMDD		Then Call ALERTS("데이터에 변조가 있었습니다.다시 진행해주세요.B11","go","joinStep01.asp")
		If DKRS_strSSH2			<>	birthYYMMDD		Then Call ALERTS("데이터에 변조가 있었습니다.다시 진행해주세요.B12","go","joinStep01.asp")

	End If

%>

<%

	' 후원라인체크(최상위 제외)
		arrParams1 = Array(_
			Db.makeParam("@MBID",adVarChar,adParamInput,20,SponID1), _
			Db.makeParam("@MBID2",adInteger,adParamInput,0,SponID2) _
		)
		ThisDownLeg = Db.execRsData("DKP_DOWNLEG_CHECK",DB_PROC,arrParams1,DB3)
		If ThisDownLeg = "F" Then
			Call ALERTS(LNG_JOINFINISH_U_ALERT08,"back","joinStep01.asp")
		End If


	' 값 처리
		If strName = ""			Then Call ALERTS(LNG_JS_NAME,"back","")
		If M_Name_First = ""	Then Call ALERTS(LNG_JS_NAME&"("&LNG_TEXT_GIVEN_NAME&")","back","")
		If M_Name_Last = ""		Then Call ALERTS(LNG_JS_NAME&"("&LNG_TEXT_FAMILY_NAME&")","back","")

		If CS_AUTO_WEBID_TF <> "T" Then		'웹아이디 직접입력
			If snsToken = "" Then
				If strUserID = ""		Then Call ALERTS(LNG_JS_ID,"back","")
				If idcheck <> "T"		Then Call ALERTS(LNG_JS_ID_DOUBLE_CHECK,"back","")
				If Not checkID(strUserID, 4, 20)	Then Call ALERTS(LNG_JS_ID_FORM_CHECK,"back","")
				If chkID <> strUserID				Then Call ALERTS(LNG_JS_ID_DOUBLE_CHECK,"back","")
				If strUserID = strPass				Then Call ALERTS(LNG_JS_PASSWORD_FORM_CHECK2,"back","")
			End If
		End If

		If snsToken = "" Then
			If Not checkPass(strPass, 6, 20)	Then Call ALERTS(LNG_JS_PASSWORD_FORM_CHECK,"back","")
			If strPass <> strPass2				Then Call ALERTS(LNG_JS_PASSWORD_CHECK,"back","")
		End If

		If S_SellMemTF = "0" Then 'COSMICO
			''If strEmail = "" Then Call ALERTS(LNG_JS_EMAIL,"back","")			'cosmico 선택 2022-08-17

			If strZip = "" Or strADDR1 = "" Or strADDR2 = "" Then Call ALERTS(LNG_JS_ADDRESS1,"back","")
			If strMobile = "" Then Call ALERTS(LNG_JS_MOBILE,"back","")
			If chkMobile <> strMobile	Then Call ALERTS(LNG_JS_MOBILE_DOUBLE_CHECK2,"back","")
		End If


	' 값 병합
		strBirth = ""

		If strBirth1 <> "" And strBirth2 <> "" And strBirth3 <> "" Then strBirth = strBirth1 &"-"& strBirth2 &"-"& strBirth3
		'strEmail = strEmail1 & "@" & strEmail2


		If Not IsDate(strBirth) Then strBirth = ""
		If isSMS = "" Then isSMS = "T"
		If isMailing = "" Then isMailing = "T"

		If isSex = "" Then isSex = "M"


		If NominID2 = "" Then NominID2 = 0
		If SponID2 = "" Then SponID2 = 0

	' CS 관련 정보 입력
		'▣추천인 센터코드 자동입력
		If NominID1 <> "" And NominID2 > 0 And businessCode = "" Then
			arrParams = Array(_
				Db.makeParam("@mbid",adVarChar,adParamInput,20,NominID1), _
				Db.makeParam("@mbid2",adInteger,adParamInput,0,NominID2) _
			)
			Set DKRS = Db.execRs("HJP_MEMBER_BUSINESSCODE",DB_PROC,arrParams,DB3)
			If Not DKRS.BOF And Not DKRS.EOF Then
				businessCode = DKRS("businesscode")
				Roadcode = DKRS("Roadcode")							'COSMICO 총판
			Else
				businessCode = CONST_CS_MAIN_BUSINESSCODE
				Roadcode = businessCode
			End If
			Call closeRS(DKRS)
		End If


		'▣판매원/소비자
		Select Case S_SellMemTF
			Case 0
				If NominChk	 = "" Or NominChk = "F"	Then Call ALERTS(LNG_JS_VOTER,"BACK","")
				'If SponIDChk = "" Or SponIDChk = "F" Then Call ALERTS(LNG_JS_SPONSOR,"BACK","")
				If businessCode = "" Or Roadcode = "" Then Call ALERTS(LNG_JS_CENTER&"(총판)","BACK","")		'COSMICO
			Case 1
				'If NominChk	 = "" Or NominChk = "F"	Then Call ALERTS(LNG_JS_VOTER,"BACK","")
			Case Else
				Call ALERTS(LNG_MEMBER_LOGINOK_ALERT02,"BACK","")
		End Select



'로그기록생성
On Error Resume Next
Dim  Fso : Set  Fso=CreateObject("Scripting.FileSystemObject")
Dim LogPath : LogPath = Server.MapPath ("/logings/joins/memJoins_") & Replace(Date(),"-","") & ".log"
Dim Sfile : Set  Sfile = Fso.OpenTextFile(LogPath,8,true)

	Sfile.WriteLine "Date : " & now()
	Sfile.WriteLine "Domain : " & Request.ServerVariables("HTTP_HOST")
	Sfile.WriteLine "Browser : " & Request.ServerVariables("HTTP_USER_AGENT")
	Sfile.WriteLine "Referer : " & Request.ServerVariables("HTTP_REFERER")
	Sfile.WriteLine "idcheck : " & idcheck
	Sfile.WriteLine "strName : " & strName
	Sfile.WriteLine "M_Name_First : " & M_Name_First
	Sfile.WriteLine "M_Name_Last  : " & M_Name_Last
	Sfile.WriteLine "S_SellMemTF  : " & S_SellMemTF
	Sfile.WriteLine "strUserID : " & strUserID
	Sfile.WriteLine "1_NominID1 : " & NominID1
	Sfile.WriteLine "1_NominID2 : " & NominID2
	Sfile.WriteLine "1_NominWebID : " & NominWebID
	Sfile.WriteLine "1_NominChk : " & NominChk
	Sfile.WriteLine "SponID1 : " & SponID1
	Sfile.WriteLine "SponID2 : " & SponID2
	'Sfile.WriteLine "SponLine : " & SponLine
	Sfile.WriteLine "businessCode : " & businessCode

	' CS 관련 정보 입력
		If businessCode = "" Or businessCode = "unknown" Then businessCode = CONST_CS_MAIN_BUSINESSCODE
		'If NominID1 ="" Or NominID2 = "" Or NominWebID = "" Or NominChk = "F" Then

		If NominCom = "F" Then
			If NominID1 ="" Or NominID2 = "" Or NominChk = "F" Then
				NominID1 = "**"		'메타21
				NominID2 = 0
				NominWebID = ""
			End If

		Else
			If NominID1 ="" Or NominID2 = "" Or NominChk = "F" Then
				NominID1 = "**"
				NominID2 = 0
				NominWebID = ""
			End If
		End If

		'If SponID1 ="" Or SponID2 = "" Or SponIDWebID = "" Or SponIDChk = "F" Then
		If SponID1 ="" Or SponID2 = "" Or SponIDChk = "F" Then
			SponID1 = "**"
			SponID2 = 0
			SponIDWebID = ""
		End If

	Sfile.WriteLine "2_NominID1 : " & NominID1
	Sfile.WriteLine "2_NominID2 : " & NominID2
	Sfile.WriteLine "2_NominWebID : " & NominWebID
	Sfile.WriteLine "2_NominChk : " & NominChk





		strPass = LCase(strPass)
'		Call ResRW(strEmail		,"strEmail")
'		Call ResRW(strUserID	,"strUserID")
'		Call ResRW(strPass		,"strPass")

		Set objEncrypter = Server.CreateObject("Hyeongryeol.StringEncrypter")
			objEncrypter.Key = con_EncryptKey
			objEncrypter.InitialVector = con_EncryptKeyIV
			If strSSH1	<> "" Then Dec_strSSH1	= objEncrypter.Decrypt(strSSH1)
			If strSSH2	<> "" Then Dec_strSSH2	= objEncrypter.Decrypt(strSSH2)
		Set objEncrypter = Nothing


		Select Case isSex
			Case "M"
				If CDbl(strBirth1) < CDbl(2000) Then
					Dec_strSSH2 = "1000000"
				Else
					Dec_strSSH2 = "3000000"
				End If
			Case "F"
				If CDbl(strBirth1) < CDbl(2000) Then
					Dec_strSSH2 = "2000000"
				Else
					Dec_strSSH2 = "4000000"
				End If
		End Select


		'분리된 주민번호 복호화 -> 병합

		If UCase(Lang) <> "KR" Then	'▣한국외 도시선택
			strSSH = strSSH
			strSSH1 = ""
			strSSH2 = ""
		Else
			strSSH = Dec_strSSH1 & Dec_strSSH2
		End If

		'가입메일 전송 용
		Dec_strEmail = strEmail

		If DKCONF_SITE_ENC = "T" Then
			Set objEncrypter = Server.CreateObject("Hyeongryeol.StringEncrypter")
				objEncrypter.Key = con_EncryptKey
				objEncrypter.InitialVector = con_EncryptKeyIV
				If strSSH			<> "" Then strSSH		= objEncrypter.Encrypt(strSSH)			'재암호화
				If strADDR1			<> "" Then strADDR1		= objEncrypter.Encrypt(straddr1)
				If strADDR2			<> "" Then strADDR2		= objEncrypter.Encrypt(straddr2)
				If strTel			<> "" Then strTel		= objEncrypter.Encrypt(strTel)
				If strMobile		<> "" Then strMobile	= objEncrypter.Encrypt(strMobile)
				If bankNumber		<> "" Then bankNumber	= objEncrypter.Encrypt(BankNumber)
				If DKRS_strBankNum	<> "" Then DKRS_strBankNum	= objEncrypter.Encrypt(DKRS_strBankNum)

				If DKCONF_ISCSNEW = "T" Then	''▣CS신버전 암/복호화 추가
					If strEmail			<> "" Then strEmail			= objEncrypter.Encrypt(LCase(strEmail))
					'If strUserID		<> "" Then strUserID		= objEncrypter.Encrypt(strUserID)		'CS WebID
					If strPass			<> "" Then strPass			= objEncrypter.Encrypt(strPass)
				End If
			Set objEncrypter = Nothing
		End If


'	Sfile.WriteLine "strName : " & strName
'	Sfile.WriteLine "M_Name_First : " & M_Name_First
'	Sfile.WriteLine "M_Name_Last  : " & M_Name_Last
'	Sfile.WriteLine "strEmail : " & strEmail
'	Sfile.WriteLine "strZip : " & strZip
'	Sfile.WriteLine "strADDR1 : " & strADDR1
'	Sfile.WriteLine "strADDR2 : " & strADDR2
'	Sfile.WriteLine "strTel : " & strTel
'	Sfile.WriteLine "strMobile : " & strMobile
'	Sfile.WriteLine "Recordtime : " & Recordtime
'	Sfile.WriteLine "RegTime : " & RegTime
'	Sfile.WriteLine "SponID1 : " & SponID1
'	Sfile.WriteLine "SponID2 : " & SponID2
'	Sfile.WriteLine "strUserID : " & strUserID
'	Sfile.WriteLine "strBirth1 : " & strBirth1
'	Sfile.WriteLine "strBirth2 : " & strBirth2
'	Sfile.WriteLine "strBirth3 : " & strBirth3
'	Sfile.WriteLine "CS_BirthDayTF : " & CS_BirthDayTF
'	Sfile.WriteLine "For_Kind_TF : " & For_Kind_TF
'	Sfile.WriteLine "R_NationCode : " & R_NationCode
'	Sfile.WriteLine "isSex : " & isSex
'	Sfile.WriteLine "E_name : " & E_name
'	Sfile.WriteLine "E_name_Last : " & E_name_Last
'	Sfile.WriteLine "Passport_Number : " & Passport_Number
'	Sfile.WriteLine "CityCode : " & CityCode
'	Sfile.WriteLine "SponLine : " & SponLine


	' ▣ CS 외국 개인식별번호 중복 체크 [cpno_Global]
		If UCase(Lang) <> "KR" Then

			If strSSH <> "" Then

				SQL = "SELECT COUNT([mbid]) FROM [tbl_memberinfo] WITH(NOLOCK) WHERE [cpno_Global] = ? AND [Na_Code] = ? "
				arrParams = Array(_
					Db.makeParam("@cpno_Global",adVarChar,adParamInput,100,strSSH), _
					Db.makeParam("@Na_Code",adVarwchar,adParamInput,50,DK_MEMBER_NATIONCODE) _
				)
				SSHCOUNT = CInt(Db.execRsData(SQL,DB_TEXT,arrParams,Db3))
				If SSHCOUNT > 0 Then Call alerts(LNG_JOINFINISH_U_ALERT23,"go","/common/joinStep01.asp")

			End If

		End If

	'▣ CS 이름 + 생년월일 중복체크(탈퇴회원 중복대상제외'→ 전체회원중복체크)
		SQL = "SELECT COUNT([mbid]) FROM [tbl_memberinfo] WITH(NOLOCK) WHERE [M_Name] = ? And [BirthDay] = ? And [BirthDay_M] = ? And [BirthDay_D] = ? "
		arrParams = Array(_
			Db.makeParam("@M_Name",adVarWchar,adParamInput,100,strName), _
			Db.makeParam("@BirthDay",adVarchar,adParamInput,4,strBirth1), _
			Db.makeParam("@BirthDay_M",adVarchar,adParamInput,2,strBirth2), _
			Db.makeParam("@BirthDay_D",adVarchar,adParamInput,2,strBirth3) _
		)
		DbCheckMember = CInt(Db.execRsData(SQL,DB_TEXT,arrParams,DB3))
		If DbCheckMember > 0 Then
			Sfile.WriteLine "FAILE : 동일한 이름과 생년월일"
			Call alerts(LNG_JS_ALREADY_REGISTERED_MEMBER2,"go","joinStep01.asp")
		End If

	'▣ CS 핸드폰 중복체크
	If strMobile <> "" Then
		SQL_MC = "SELECT COUNT([mbid]) FROM [tbl_memberinfo] WITH(NOLOCK) WHERE [hptel] = ? "
		arrParams_MC = Array(_
			Db.makeParam("@hptel",adVarChar,adParamInput,100,strMobile) _
		)
		DbCheckMobile = CInt(Db.execRsData(SQL_MC,DB_TEXT,arrParams_MC,DB3))
		If DbCheckMobile > 0 Then
			Sfile.WriteLine "FAILE : 이미 등록된 핸드폰 번호"
			Call ALERTS("이미 등록된 핸드폰 번호입니다.\n본인이 회원가입을 하지 않았다면 본사로 문의해주세요.!","BACK","")
		End If
	End If

	'▣ 이메일중복체크
	If strEmail <> "" Then
		SQL = "SELECT COUNT([Email]) FROM [tbl_memberinfo] WITH(NOLOCK) WHERE [Email] = ?"
		arrParams = Array(_
			Db.makeParam("@strEmail",adVarWChar,adParamInput,200,strEmail) _
		)
		Email_CNT = Db.execRsData(SQL,DB_TEXT,arrParams,DB3)
		If Email_CNT > 0 Then Call ALERTS(LNG_AJAX_EMAILCHECK_F,"back","")
	End If

	'▣ CS 계좌번호중복체크
	If bankCode <> "" And bankNumber <> "" Then
		SQL = "SELECT COUNT([mbid]) FROM [tbl_memberinfo] WITH(NOLOCK) WHERE [bankcode] = ? AND [bankaccnt] = ?"
		arrParams = Array(_
			Db.makeParam("@strBankCode",adVarChar,adParamInput,10,bankCode), _
			Db.makeParam("@bankaccnt",adVarchar,adParamInput,100,bankNumber) _
		)
		BANKACCNT_COUNT = CInt(Db.execRsData(SQL,DB_TEXT,arrParams,DB3))
		If BANKACCNT_COUNT > 0 Then Call alerts("이미 등록된 계좌정보가 존재합니다!","go","joinStep01.asp")
	End If

	'▣후원인 체크 : 추천인의 후원산하로만(형제라인 지정불가) pop_VoterSFV.asp / pop_SponsorSFV.asp
	If (NominID1 <> "" And NominID2 > 0) And (SponID1 <> "" And SponID2 > 0) And 1=2 Then
		SFV_COUNT = 0
		arrParams = Array(_
			Db.makeParam("@MBID",adVarChar,adParamInput,20,NominID1), _
			Db.makeParam("@MBID2",adInteger,adParamInput,0,NominID2), _
			Db.makeParam("@SponID1",adVarChar,adParamInput,20,SponID1), _
			Db.makeParam("@SponID2",adInteger,adParamInput,0,SponID2) _
		)
		SFV_COUNT = Db.execRsData("HJP_MEMBER_SEARCH_SPON_FROM_VOTER_COUNT",DB_PROC,arrParams,DB3)
		IF Cdbl(SFV_COUNT) < 1 Then
			Sfile.WriteLine "FAILE : 후원인은 추천인의 후원산하에서 선택할 수 있습니다."
			Call ALERTS("후원인은 추천인의 후원산하에서 선택할 수 있습니다.","back","")
		End If
	End If


'Sfile.WriteLine chr(13)
Sfile.Close
Set Fso= Nothing
Set objError= Nothing
On Error GoTo 0



		CS_BirthDay = strBirth1 & strBirth2 & strBirth3

		If isSolar = "S" Then
			CS_BirthDayTF = 1			'양력
		Else
			CS_BirthDayTF = 2			'음력
		End If


		nowTime = Now
		RegTime = Right("0000"&Year(nowTime),4) & Right("00"&Month(nowTime),2) & Right("00"&Day(nowTime),2)
		Recordtime = Left(nowTime,10) & " "& Right("00"&Hour(nowTime),2) &":"&Right("00"&Minute(nowTime),2) &":"&Right("00"&Second(nowTime),2)


'		Call ResRW(MotherSite	,"MotherSite")
'		Call ResRW(strName		,"strName")
'		Call ResRW(strEmail		,"strEmail_E")
'		Call ResRW(strSSH		,"strSSH")
'		Call ResRW(strZip		,"strZip")

'		Call ResRW(strADDR1		,"strADDR1")
'		Call ResRW(strADDR2		,"strADDR1")
'		Call ResRW(strTel		,"strTel")
'		Call ResRW(strMobile	,"strMobile")

'		Call ResRW(Recordtime	,"Recordtime")
'		Call ResRW(RegTime		,"RegTime")

'		Call ResRW(SponID1		,"SponID1")
'		Call ResRW(SponID2		,"SponID2")
'		Call ResRW(SponIDWebID	,"SponIDWebID")
'		Call ResRW(SponIDChk	,"SponIDChk")

'		Call ResRW(NominID1		,"NominID1")
'		Call ResRW(NominID2		,"NominID2")
'		Response.End
'		Call ResRW(NominWebID	,"NominWebID")
'		Call ResRW(NominChk		,"NominChk")

'		Call ResRW(strUserID	,"strUserID_E")
'		Call ResRW(strPass		,"strPass_E")

'		Call ResRW(bankCode		,"bankCode")
'		Call ResRW(bankOwner	,"bankOwner")
'		Call ResRW(bankNumber	,"bankNumber")
'		Call ResRW(businessCode	,"businessCode")

'		Call ResRW(strBirth		,"strBirth")
'		Call ResRW(isSolar		,"isSolar")
'		Call ResRW(strSSH1		,"strSSH1")
'		Call ResRW(strSSH2		,"strSSH2")
'		Call ResRW(strSSH		,"strSSH")

'		Call ResRW(isSMS		,"isSMS")
'		Call ResRW(isMailing	,"isMailing")
'		Call ResRW(isSex		,"isSex")
'		Call ResRW(joinType		,"joinType")

'		Call ResRW(strName		,"strName")
'		Call ResRW(For_Kind_TF		,"For_Kind_TF")
'		Call ResRW(M_Name_First	,"M_Name_First")
'		Call ResRW(M_Name_Last	,"M_Name_Last")
'		Call ResRW(E_name		,"E_name")
'		Call ResRW(E_name_Last		,"E_name_Last")
'		Call ResRW(Passport_Number	,"Passport_Number")
'		Call ResRW(strSSH1	,"strSSH1")
'		Call ResRW(DK_MEMBER_NATIONCODE	,"DK_MEMBER_NATIONCODE")
'Response.end

		R_NationCode = UCase(Lang)


		'▣국가코드 한국인= 0, 외국인 = 1

		'▣CS성별 치환입력
		Select Case isSex
			Case "M"
				isSex = 1
			Case "F"
				isSex = 2
		End Select

		'외국인 체크(한국 0 그 외 국가 1)
		If R_NationCode = "KR" Then
			For_Kind_TF	= "0"
		Else
			For_Kind_TF	= "1"
		End If
		'KR제외 외국 strSSH = cpno_Global저장!!

		'웹아이디 직접입력 (A : KR-12345678, B : KR12345678, C : 12345678)
		If CS_AUTO_WEBID_TF = "T" Then
			strUserID = AUTO_WEBID_TYPE
		End IF

		If snsToken <> "" Then
			strUserID = ""
			'HJP_MEMBER_JOIN_CS_GLOBAL 수정!!
			'USERIDCNT = .. WHERE [webID] = @WebID AND [webID] <> ''
		End If

			'Db.makeParam("@SponLine",adSmallInt,adParamInput,0,SponLine), _
			'Db.makeParam("@SNSID",adVarWChar,adParamInput,100,sns_authID), _
		arrParams = Array(_
			Db.makeParam("@M_name",adVarWChar,adParamInput,50,strName), _
			Db.makeParam("@Email",adVarWChar,adParamInput,200,strEmail), _
			Db.makeParam("@cpno",adVarChar,adParamInput,100,strSSH), _
			Db.makeParam("@Addcode1",adVarChar,adParamInput,6,Replace(strZip,"-","")), _
			Db.makeParam("@Address1",adVarChar,adParamInput,700,strADDR1), _
			Db.makeParam("@Address2",adVarChar,adParamInput,700,strADDR2), _
			Db.makeParam("@hometel",adVarChar,adParamInput,100,Replace(strTel,"-","")), _
			Db.makeParam("@hptel",adVarChar,adParamInput,100,Replace(strMobile,"-","")), _
			Db.makeParam("@Recordtime",adVarChar,adParamInput,19,Recordtime), _
			Db.makeParam("@Regtime",adVarChar,adParamInput,10,RegTime), _
			Db.makeParam("@SponID1",adVarChar,adParamInput,20,SponID1), _
			Db.makeParam("@SponID2",adInteger,adParamInput,0,SponID2), _
			Db.makeParam("@NominID1",adVarChar,adParamInput,20,NominID1), _
			Db.makeParam("@NominID2",adInteger,adParamInput,0,NominID2), _
			Db.makeParam("@WebID",adVarWChar,adParamInput,100,strUserID), _
			Db.makeParam("@WebPassWord",adVarWChar,adParamInput,100,strPass), _
			Db.makeParam("@bankCode",adVarChar,adParamInput,10,bankCode), _
			Db.makeParam("@bankOwner",adVarWChar,adParamInput,50,bankOwner), _
			Db.makeParam("@bankNumber",adVarChar,adParamInput,200,bankNumber), _
			Db.makeParam("@businessCode",adVarChar,adParamInput,20,businessCode), _
			Db.makeParam("@BirthDay",adVarChar,adParamInput,4,strBirth1), _
			Db.makeParam("@BirthDay_M",adVarChar,adParamInput,2,strBirth2), _
			Db.makeParam("@BirthDay_D",adVarChar,adParamInput,2,strBirth3), _
			Db.makeParam("@BirthDayTF",adSmallInt,adParamInput,0,CS_BirthDayTF), _
			Db.makeParam("@strSSH1",adVarChar,adParamInput,50,strSSH1), _
			Db.makeParam("@strSSH2",adVarChar,adParamInput,50,strSSH2), _

			Db.makeParam("@For_Kind_TF",adSmallInt,adParamInput,0,For_Kind_TF), _
			Db.makeParam("@Country_code",adVarChar,adParamInput,20,R_NationCode), _
			Db.makeParam("@Sex",adSmallInt,adParamInput,0,isSex), _

			Db.makeParam("@M_Name_First",adVarWChar,adParamInput,100,M_Name_First), _
			Db.makeParam("@M_Name_Last",adVarWChar,adParamInput,100,M_Name_Last), _

				Db.makeParam("@S_SellMemTF",adSmallInt,adParamInput,0,S_SellMemTF), _

			Db.makeParam("@THISMEMID1",adVarChar,adParamOutput,20,""), _
			Db.makeParam("@THISMEMID2",adInteger,adParamOutput,0,0), _
			Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,11,"") _
		)
		Call Db.exec("HJP_MEMBER_JOIN_CS_GLOBAL",DB_PROC,arrParams,DB3)

		THISMEMID1 = arrParams(UBound(arrParams)-2)(4)
		THISMEMID2 = arrParams(UBound(arrParams)-1)(4)
		OUTPUT_VALUE = arrParams(UBound(arrParams))(4)

		'COSMICO 총판등록
		If Roadcode <> "" Then
			SQL_RC = "UPDATE [tbl_memberInfo] SET [Roadcode] = ? WHERE [mbid] = ? And [mbid2] = ? "
			arrParams_RC = Array(_
				Db.makeParam("@Roadcode",adVarChar,adParamInput,20,Roadcode), _
				Db.makeParam("@mbid1",adVarChar,adParamInput,20,THISMEMID1), _
				Db.makeParam("@mbid2",adInteger,adParamInput,0,THISMEMID2) _
			)
			Call Db.exec(SQL_RC,DB_TEXT,arrParams_RC,DB3)
		End If

		'SNS 정보입력
		If snsToken <> "" Then
			SQL12 = "UPDATE [tbl_memberInfo] SET [snsType] = ?, [snsToken] = ?  WHERE [mbid] = ? And [mbid2] = ? "
			arrParams12 = Array(_
				Db.makeParam("@snsType",adVarChar,adParamInput,10,snsType), _
				Db.makeParam("@snsToken",adVarWChar,adParamInput,100,snsToken), _
				Db.makeParam("@mbid1",adVarChar,adParamInput,20,THISMEMID1), _
				Db.makeParam("@mbid2",adInteger,adParamInput,0,THISMEMID2) _
			)
			Call Db.exec(SQL12,DB_TEXT,arrParams12,DB3)
		End If

		'로그기록생성2
		On Error Resume Next
		Dim  Fso2 : Set  Fso2=CreateObject("Scripting.FileSystemObject")
		Dim LogPath2 : LogPath2 = Server.MapPath ("/logings/joins/memJoins_") & Replace(Date(),"-","") & ".log"
		Dim Sfile2 : Set  Sfile2 = Fso2.OpenTextFile(LogPath2,8,true)

			Sfile2.WriteLine "strUserID2 : " & strUserID
			Sfile2.WriteLine "THISMEMID1 : " & THISMEMID1
			Sfile2.WriteLine "THISMEMID2 : " & THISMEMID2
			Sfile2.WriteLine "OUTPUT_VALUE : " & OUTPUT_VALUE

		Sfile2.WriteLine chr(13)
		Sfile2.Close
		Set Fso2= Nothing
		Set objError= Nothing
		On Error GoTo 0

		If OUTPUT_VALUE = "FINISH" Then
			'회원가입 이메일 발송( )
			'Call FnWelComeMail(Dec_strEmail, THISMEMID1, THISMEMID2, "join2", "")		'이메일 전용

			'회원가입 알림톡 발송( )
			'Call FN_PPURIO_MESSAGE(THISMEMID1, THISMEMID2, "join", "at", "", "")

			'회원가입 문자 발송( )
			'Call Fn_MemMessage_Send(THISMEMID1, THISMEMID2, "join")

			'핸드폰인증 중복가입 확인값 UPDATE
			If NICE_MOBILE_CONFIRM_TF = "T" Then
				If DKRSM_sDupInfo <> "" Then
					SQLMU = "UPDATE [tbl_memberinfo] SET [mobileAuth] = ? WHERE [mbid] = ? AND [mbid2] = ? "
					arrParamsMU = Array(_
						Db.makeParam("@sDupInfo",adVarWChar,adParamInput,100,DKRSM_sDupInfo), _
						Db.makeParam("@mbid",adVarChar,adParamInput,20,THISMEMID1), _
						Db.makeParam("@mbid2",adInteger,adParamInput,0,THISMEMID2) _
					)
					Call Db.exec(SQLMU,DB_TEXT,arrParamsMU,DB3)
				End If
			End If

			'계좌인증 확인값 UPDATE
			If NICE_BANK_CONFIRM_TF = "T" Then
				If DKRS_strBankNum <> "" Then
					SQLBA = "UPDATE [tbl_memberinfo] SET [Reg_bankaccnt] = ? WHERE [mbid] = ? AND [mbid2] = ? "
					arrParamsBA = Array(_
						Db.makeParam("@bankNumber",adVarChar,adParamInput,200,DKRS_strBankNum), _
						Db.makeParam("@mbid",adVarChar,adParamInput,20,THISMEMID1), _
						Db.makeParam("@mbid2",adInteger,adParamInput,0,THISMEMID2) _
					)
					Call Db.exec(SQLBA,DB_TEXT,arrParamsBA,DB3)
				End If
			End If

		End If


'	PRINT OUTPUT_VALUE
'	RESPONSE.End
		Select Case OUTPUT_VALUE
			Case "BLOCKID1"		: Call ALERTS(LNG_JOINFINISH_U_ALERT_OUTPUT01,"BACK","")
			Case "BLOCKID2"		: Call ALERTS(LNG_JOINFINISH_U_ALERT_OUTPUT02,"BACK","")
			Case "OVERLAPID"	: Call ALERTS(LNG_JOINFINISH_U_ALERT_OUTPUT03,"BACK","")
			Case "OVERLAP_NB"	: Call ALERTS(LNG_JS_ALREADY_REGISTERED_MEMBER2,"BACK","")
			Case "ERROR"		: Call ALERTS(LNG_JOINFINISH_U_ALERT_OUTPUT05,"BACK","")
			Case "MORESPON"		: Call ALERTS(LNG_JOINFINISH_U_ALERT_OUTPUT06,"BACK","")
			'Case "FINISH"		: Call ALERTS(LNG_JOINFINISH_U_ALERT_OUTPUT07&"("&THISMEMID1&" - "&Right("000000000"&THISMEMID2,MBID2_LEN)&")","go","/index.asp")
			Case "FINISH"
				On Error Resume Next
				Set StrCipher = Server.CreateObject("Hoyasoft.StrCipher")
					THISMEMID1 = Trim(StrCipher.Encrypt(THISMEMID1,EncTypeKey1,EncTypeKey2))
					THISMEMID2 = Trim(StrCipher.Encrypt(THISMEMID2,EncTypeKey1,EncTypeKey2))
				Set StrCipher = Nothing
				On Error GoTo 0
				Call ALERTS("","silentgo","joinStep_Finish.asp?m1="&THISMEMID1&"&m2="&THISMEMID2)
			Case Else			: Call ALERTS(LNG_JOINFINISH_U_ALERT_OUTPUT08,"BACK","")
		End Select
%>

</body>
</html>
