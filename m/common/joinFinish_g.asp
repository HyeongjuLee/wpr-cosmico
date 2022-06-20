<!--#include virtual = "/_lib/strFunc.asp" -->
<!--#include virtual = "/_lib/strFuncJoin.asp"-->
<%
	NO_MEMBER_REDIRECT = "F"
%>
<!--#include virtual="/m/_include/document.asp" -->
</head>
<body>
<%
	PAGE_SETTING = "JOIN"

	'▣글로벌, 판매원, 소비자 통합
	S_SellMemTF = pRequestTF("S_SellMemTF",True)
	Select Case S_SellMemTF
		Case 0
			If NICE_MOBILE_CONFIRM_TF = "T" OR NICE_BANK_CONFIRM_TF = "T" Then Call ALERTS(LNG_MEMBER_LOGINOK_ALERT02,"BACK","")
		Case 1
		Case Else
			Call ALERTS(LNG_MEMBER_LOGINOK_ALERT02,"BACK","")
	End Select

	If DK_MEMBER_LEVEL > 0 Then Response.Redirect "/m/index.asp"


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
			If Not checkRef(houUrl &"/m/common/joinStep_n03_g.asp") Then Call alerts(LNG_ALERT_WRONG_ACCESS,"go","/m/common/joinStep01.asp")
'		Case Else
'			Call alerts(LNG_ALERT_WRONG_ACCESS,"back","")
'	End Select


		gather			= pRequestTF("gather",False)
		agreement		= pRequestTF("agreement",False)
		company			= pRequestTF("company",False)


		If agreement <> "T" Then Call ALERTS(LNG_JS_POLICY01,"go","/m/common/joinStep01.asp")
		If gather <> "T" Then Call ALERTS(LNG_JS_POLICY02,"go","/m/common/joinStep01.asp")
		If company <> "T" Then Call ALERTS(LNG_JS_POLICY03,"go","/m/common/joinStep01.asp")





	' 값 받아오기
		MotherSite		= strHostA' Trim(getRequest("MotherSite",False)
		dataNum			= pRequestTF("dataNum",True)


		E_name			= pRequestTF("E_name",False)		'영문이름
		E_name_Last		= pRequestTF("E_name_Last",False)	'영문성
		For_Kind_TF		= pRequestTF("For_Kind_TF",True)	'외국인 체크(한국 0그 외 국가 1)

	'▣ 값 받아오기 특이사항 s
			sns_authID		= pRequestTF("sns_authID",False)	: If sns_authID = "" Then sns_authID = ""		'SNS 회원가입
	'▣ 값 받아오기 특이사항 e

		'▣한국외
		If UCase(Lang) <> "KR" Then


			strSSH			= pRequestTF("strSSH",True)
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

		''	CityCode	= pRequestTF("CityCode",False)		' ~2018-12-17

		Else
			strSSH			= ""
			Passport_Number	= ""
			CityCode		= ""
		End If

	'	Call ResRW(For_Kind_TF	,"For_Kind_TF")
	'	Call ResRW(CityCode	,"CityCode")
	'	Call ResRW(strSSH	,"strSSH")
	'	Call ResRW(Passport_Number	,"Passport_Number")


'		strName			= pRequestTF("strName",True)
		If CS_AUTO_WEBID_TF <> "T" Then		'웹아이디 직접입력
			strUserID		= pRequestTF("strID",True)
			strUserID_OUT	= strUserID
			idcheck			= pRequestTF("idcheck",True)
			chkID			= pRequestTF("chkID",True)
		End IF

		strPass			= pRequestTF("strPass",True)
		strPass2		= pRequestTF("strPass2",True)

		strZip			= pRequestTF("strZip",False)
		strADDR1		= pRequestTF("strADDR1",False)
		strADDR2		= pRequestTF("strADDR2",False)

		strEmail		= pRequestTF("strEmail",False)

		isSex			= pRequestTF("isSex",True)

		strMobile		= pRequestTF("strMobile",False)
			mobileCheck		= pRequestTF("mobileCheck",True)
			chkMobile		= pRequestTF("chkMobile",True)

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
			Call ALERTS(LNG_JOINFINISH_U_ALERT07,"go","/m/common/joinStep01.asp")
		End If
		Call closeRS(DKRS)

	' 후원라인체크
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
			If strUserID = ""		Then Call ALERTS(LNG_JS_ID,"back","")
			If idcheck <> "T"		Then Call ALERTS(LNG_JS_ID_DOUBLE_CHECK,"back","")
			If Not checkID(strUserID, 4, 20)	Then Call ALERTS(LNG_JS_ID_FORM_CHECK,"back","")
			If chkID <> strUserID				Then Call ALERTS(LNG_JS_ID_DOUBLE_CHECK,"back","")
			If strUserID = strPass				Then Call ALERTS(LNG_JS_PASSWORD_FORM_CHECK2,"back","")
		End If

		If Not checkPass(strPass, 6, 20)	Then Call ALERTS(LNG_JS_PASSWORD_FORM_CHECK,"back","")
		If strPass <> strPass2				Then Call ALERTS(LNG_JS_PASSWORD_CHECK,"back","")

		If strEmail = "" Then Call ALERTS(LNG_JS_EMAIL,"back","")

		If strZip = "" Or strADDR1 = "" Or strADDR2 = "" Then Call ALERTS(LNG_JS_ADDRESS1,"back","")
		If strMobile = "" Then Call ALERTS(LNG_JS_MOBILE,"back","")
		If chkMobile <> strMobile	Then Call ALERTS(LNG_JS_MOBILE_DOUBLE_CHECK2,"back","")

		''If NominChk	= "" Or NominChk = "F"	Then Call ALERTS(LNG_JS_VOTER,"BACK","")
		''If SponIDChk	= "" Or SponIDChk = "F"	Then Call ALERTS(LNG_JS_SPONSOR,"BACK","")

		'▣판매원/소비자
		Select Case S_SellMemTF
			Case 0
				If NominChk	 = "" Or NominChk = "F"	Then Call ALERTS(LNG_JS_VOTER,"BACK","")
				If SponIDChk = "" Or SponIDChk = "F" Then Call ALERTS(LNG_JS_SPONSOR,"BACK","")
			Case 1
				'If NominChk	 = "" Or NominChk = "F"	Then Call ALERTS(LNG_JS_VOTER,"BACK","")
			Case Else
				Call ALERTS(LNG_MEMBER_LOGINOK_ALERT02,"BACK","")
		End Select




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
			Else
				businessCode = CONST_CS_MAIN_BUSINESSCODE
			End If
			Call closeRS(DKRS)
		End If




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
'
'		Call ResRW(NominID1		,"NominID1")
'		Call ResRW(NominID2		,"NominID2")
'		Call ResRW(NominWebID	,"NominWebID")
'		Call ResRW(NominChk		,"NominChk")
'
'		Call ResRW(strUserID	,"strUserID_E")
'		Call ResRW(strPass		,"strPass_E")
'
'		Call ResRW(bankCode		,"bankCode")
'		Call ResRW(bankOwner	,"bankOwner")
'		Call ResRW(bankNumber	,"bankNumber")
'		Call ResRW(businessCode	,"businessCode")
'
'		Call ResRW(strBirth		,"strBirth")
'		Call ResRW(isSolar		,"isSolar")
'		Call ResRW(strSSH1		,"strSSH1")
'		Call ResRW(strSSH2		,"strSSH2")
'		Call ResRW(strSSH		,"strSSH")
'
'		Call ResRW(isSMS		,"isSMS")
'		Call ResRW(isMailing	,"isMailing")
'		Call ResRW(isSex		,"isSex")
'		Call ResRW(joinType		,"joinType")
'
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
		'Call Db.exec("HJP_MEMBER_JOIN_CS_GLOBAL",DB_PROC,arrParams,DB3)
		Call Db.exec("HJP_MEMBER_JOIN_CS_GLOBAL_META21",DB_PROC,arrParams,DB3)			'META21 특이사항(회원번호 생성)

		THISMEMID1 = arrParams(UBound(arrParams)-2)(4)
		THISMEMID2 = arrParams(UBound(arrParams)-1)(4)
		OUTPUT_VALUE = arrParams(UBound(arrParams))(4)


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
			'회원가입 이메일 발송(meta21)
			'Call FnWelComeMail(Dec_strEmail, THISMEMID1&" - "&Right("000000000"&THISMEMID2,MBID2_LEN), "")
			Call FnWelComeMail(Dec_strEmail, THISMEMID1, THISMEMID2, "join2", "")		'이메일 전용

			'회원가입 알림톡 발송(meta21)
			Call FN_PPURIO_MESSAGE(THISMEMID1, THISMEMID2, "join", "at", "", "")

			'회원가입 문자 발송(meta21)
			'Call Fn_MemMessage_Send(THISMEMID1, THISMEMID2, "join")
		End If


		Select Case OUTPUT_VALUE
			Case "BLOCKID1"		: Call ALERTS(LNG_JOINFINISH_U_ALERT_OUTPUT01,"BACK","")
			Case "BLOCKID2"		: Call ALERTS(LNG_JOINFINISH_U_ALERT_OUTPUT02,"BACK","")
			Case "OVERLAPID"	: Call ALERTS(LNG_JOINFINISH_U_ALERT_OUTPUT03,"BACK","")
			Case "OVERLAP_NB"	: Call ALERTS(LNG_JS_ALREADY_REGISTERED_MEMBER2,"BACK","")
			Case "ERROR"		: Call ALERTS(LNG_JOINFINISH_U_ALERT_OUTPUT05,"BACK","")
			Case "MORESPON"		: Call ALERTS(LNG_JOINFINISH_U_ALERT_OUTPUT06,"BACK","")
			'Case "FINISH"		: Call ALERTS(LNG_JOINFINISH_U_ALERT_OUTPUT07&"("&THISMEMID1&" - "&Right("000000000"&THISMEMID2,MBID2_LEN)&")","go","/m/index.asp")
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
