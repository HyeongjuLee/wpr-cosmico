<!--#include virtual = "/_lib/strFunc.asp" -->
<!--#include virtual = "/_lib/strFuncJoin.asp"-->
<!--#include virtual = "/_include/document.asp"-->
</head>
<body>
<%
	PAGE_SETTING = "MEMBERSHIP"


	If DK_MEMBER_LEVEL > 0 Then Response.Redirect "/index.asp"
	If Not checkRef(houUrl &"/common/joinStep04.asp") Then Call ALERTS("잘못된 접근입니다.","go","joinStep01.asp")

	S_SellMemTF = 0

'####################################################################
'########## ▣ 기존데이터 받아오기 시작 ▣
'####################################################################
	MotherSite			= strHostA' Trim(getRequest("MotherSite",False)
	intIDX				= pRequestTF("intIDX",True)
	TempDataNum			= pRequestTF("dataNum",True)

	Agree01				= pRequestTF("agree01",True)
	Agree02				= pRequestTF("agree02",True)
	Agree03				= pRequestTF("agree03",True)

'	centerName			= pRequestTF("centerName",True)
'	centerCode			= pRequestTF("centerCode",True)

	strBankCode			= pRequestTF("strBankCode",True)
	strBankNum			= pRequestTF("strBankNum",True)
	strBankOwner		= pRequestTF("strBankOwner",True)

'####################################################################
'########## ▣ 회원정보 받아오기 시작 ▣
'####################################################################
	If CS_AUTO_WEBID_TF <> "T" Then		'웹아이디 직접입력
		strUserID		= pRequestTF("strID",True)
		strUserID_sms	= strUserID
		strUserID_OUT	= strUserID
		idcheck			= pRequestTF("idcheck",True)
		chkID			= pRequestTF("chkID",True)
	End If

	strPass			= pRequestTF("strPass",True)
	strPass2		= pRequestTF("strPass2",True)

	'#### ▣ 회원부가정보 ▣ ####
	isSex			= pRequestTF("isSex",True)
'	isViewID		= pRequestTF("isViewID",True)

	strZip			= pRequestTF("strZip",True)
	strADDR1		= pRequestTF("strADDR1",True)
	strADDR2		= pRequestTF("strADDR2",True)

	strMobile		= pRequestTF("strMobile",False)
	strTel			= pRequestTF("strTel",False)

	strEmail		= pRequestTF("strEmail",True)

	strBirth1		= pRequestTF("birthyy",True)
	strBirth2		= pRequestTF("birthmm",True)
	strBirth3		= pRequestTF("birthdd",True)

	isSolar			= pRequestTF("isSolar",True)

'	isMailing		= pRequestTF("sendemail",False)
'	isSMS			= pRequestTF("sendsms",False)

	joinType		= pRequestTF("joinType",False)



	'##### 비필수값 데이터 변경 & 필수값 데이터 합치기
	strBirth	= ""


	If strBirth1 <> "" And strBirth2 <> "" And strBirth3 <> "" Then strBirth = strBirth1 &"-"& strBirth2 &"-"& strBirth3

	If Not IsDate(strBirth) Then strBirth = ""
'	If isSMS = "" Then isSMS = "T"
'	If isMailing = "" Then isMailing = "T"

	If isSex = "" Then isSex = "M"
'	If isViewID = "" Then isViewID = "N"


'####################################################################
'########## ▣ 사업자회원관련 정보 받아오기 시작 ▣
'####################################################################
	businessCode		= pRequestTF("businessCode",False)

	NominID1			= pRequestTF("NominID1",True)
	NominID2			= pRequestTF("NominID2",True)
	NominWebID			= pRequestTF("NominWebID",False)
	NominChk			= pRequestTF("NominChk",True)

	SponID1				= pRequestTF("SponID1",False)
	SponID2				= pRequestTF("SponID2",False)
	SponIDWebID			= pRequestTF("SponIDWebID",False)
	SponIDChk			= pRequestTF("SponIDChk",False)

	''If businessCode = "" Then Call ALERTS(LNG_JS_CENTER,"BACK","")
	If NominChk		= "" Or NominChk = "F"	Then Call ALERTS("추천인이 등록되지 않았습니다","BACK","")
	'If SponIDChk	= "" Or SponIDChk = "F"	Then Call ALERTS("후원인이 등록되지 않았습니다","BACK","")

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
Dim  Fso : Set  Fso=CreateObject("Scripting.FileSystemObject")
Dim LogPath : LogPath = Server.MapPath ("/logings/joins/memJoins_") & Replace(Date(),"-","") & ".log"
Dim Sfile : Set  Sfile = Fso.OpenTextFile(LogPath,8,true)

Sfile.WriteLine "Date : " & now()
Sfile.WriteLine "Domain : " & Request.ServerVariables("HTTP_HOST")
Sfile.WriteLine "Browser : " & Request.ServerVariables("HTTP_USER_AGENT")
Sfile.WriteLine "Referer : " & Request.ServerVariables("HTTP_REFERER")
Sfile.WriteLine "strUserID : " & strUserID
Sfile.WriteLine "1_NominID1 : " & NominID1
Sfile.WriteLine "1_NominID2 : " & NominID2
Sfile.WriteLine "1_NominWebID : " & NominWebID
Sfile.WriteLine "1_NominChk : " & NominChk


	If businessCode = "" Or businessCode = "unknown" Then businessCode = ""
	'If NominID1 ="" Or NominID2 = "" Or NominWebID = "" Or NominChk = "F" Then
	If NominID1 ="" Or NominID2 = "" Or NominChk = "F" Then
		NominID1 = "**"
		NominID2 = 0
		NominWebID = ""
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



'####################################################################
'########## ▣ 기존 정보체크 시작 ▣
'####################################################################

	birthYYMMDD	= Right(strBirth1,2)&strBirth2&strBirth3			'생년월일체크 YYMMDD


	If Agree01 <> "T" Then Call ALERTS("잘못된 접근입니다.","go","joinStep01.asp")
	If Agree02 <> "T" Then Call ALERTS("잘못된 접근입니다.","go","joinStep01.asp")
	If Agree03 <> "T" Then Call ALERTS("잘못된 접근입니다.","go","joinStep01.asp")

	arrParams = Array(_
		Db.makeParam("@TempDataNum",adVarChar,adParamInput,50,TempDataNum),_
		Db.makeParam("@intIDX",adInteger,adParamInput,0,intIDX)_
	)
	Set DKRS = Db.execRs("DKP_MEMBER_JOIN_BANK_VIEW2",DB_PROC,arrParams,DB3)

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
		DKRS_M_Name_First		= DKRS("M_Name_First")		'이름
		DKRS_M_Name_Last		= DKRS("M_Name_Last")		'성
	Else
		Call ALERTS("데이터베이스에 없는 데이터입니다. 다시 시도해주세요.","BACK","")
	End If
	Call closeRs(DKRS)

	'템프테이블 데이터 복호화후 비교
	Set objEncrypter = Server.CreateObject("Hyeongryeol.StringEncrypter")
		objEncrypter.Key = con_EncryptKey
		objEncrypter.InitialVector = con_EncryptKeyIV
		If DKRS_strBankNum		<> "" Then DKRS_strBankNum	= objEncrypter.Decrypt(DKRS_strBankNum)
		If DKRS_strSSH1			<> "" Then DKRS_strSSH1		= objEncrypter.Decrypt(DKRS_strSSH1)
		If DKRS_strSSH2			<> "" Then DKRS_strSSH2		= objEncrypter.Decrypt(DKRS_strSSH2)
	Set objEncrypter = Nothing

	If CInt(DKRS_intIDX)	<>	CInt(intIDX)		Then Call ALERTS("데이터에 변조가 있었습니다.다시 진행해주세요.12","go","joinStep01.asp")
	If DKRS_strBankCode		<>	strBankCode			Then Call ALERTS("데이터에 변조가 있었습니다.다시 진행해주세요.6","go","joinStep01.asp")
	If DKRS_strBankNum		<>	strBankNum			Then Call ALERTS("데이터에 변조가 있었습니다.다시 진행해주세요.7","go","joinStep01.asp")
	If DKRS_strBankOwner	<>	strBankOwner		Then Call ALERTS("데이터에 변조가 있었습니다.다시 진행해주세요.8","go","joinStep01.asp")

	If DKRS_TempDataNum		<>	TempDataNum			Then Call ALERTS("데이터에 변조가 있었습니다.다시 진행해주세요.11","go","joinStep01.asp")
	If DKRS_strSSH1			<>	birthYYMMDD			Then Call ALERTS("데이터에 변조가 있었습니다.다시 진행해주세요.12","go","joinStep01.asp")
	If DKRS_strSSH2			<>	birthYYMMDD			Then Call ALERTS("데이터에 변조가 있었습니다.다시 진행해주세요.13","go","joinStep01.asp")

'	arrParams = Array(_
'		Db.makeParam("@centerName",adVarChar,adParamInput,20,centerName) _
'	)
'	Set DKRS = Db.execRs("DKP_CENTERCODE_CHECK",DB_PROC,arrParams,Nothing)
'	If Not DKRS.BOF And Not DKRS.BOF Then
'		DKRS_ncode			= DKRS("ncode")
'		DKRS_M_Reg_Code		= DKRS("M_Reg_Code")
'	Else
'		Call ALERTS("센터선택이 잘못되었습니다.","back","")
'	End If
'	Call closeRs(DKRS)

'	If centerName <> DKRS_ncode Then Call ALERTS("센터선택이 잘못되었습니다.","back","")
'	If centerCode <> DKRS_M_Reg_Code Then Call ALERTS("센터코드 입력이 잘못되었습니다..","back","")

%>

<%
	If NICE_BANK_WITH_MOBILE_USE = "T" Then

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

		If DKRS_strName	<>	DKRSM_sName			Then Call ALERTS("데이터에 변조가 있었습니다.다시 진행해주세요. - M01","gGO", MOB_PATH&"/common/joinStep01.asp")
		If strBirth1	<>	strBirthYY			Then Call ALERTS("데이터에 변조가 있었습니다.다시 진행해주세요. - M02","GO", MOB_PATH&"/common/joinStep01.asp")
		If strBirth2	<>	strBirthMM			Then Call ALERTS("데이터에 변조가 있었습니다.다시 진행해주세요. - M03","GO", MOB_PATH&"/common/joinStep01.asp")
		If strBirth3	<>	strBirthDD			Then Call ALERTS("데이터에 변조가 있었습니다.다시 진행해주세요. - M04","GO", MOB_PATH&"/common/joinStep01.asp")
		If strMobile	<>	Dec_DKRSM_sMobileNo	Then Call ALERTS("데이터에 변조가 있었습니다.다시 진행해주세요. - M05", "GO", MOB_PATH&"/common/joinStep01.asp")

	End If

	'response.end
%>
<%

'####################################################################
'########## ▣ 회원 정보체크 시작 ▣
'####################################################################



	If DKRS_strName = "" Then Call ALERTS("이름이 입력되지 않았습니다.","back","")

	If CS_AUTO_WEBID_TF <> "T" Then		'웹아이디 직접입력
		If strUserID    = "" Then Call alerts("아이디를 입력해 주세요.","back","")
		If idcheck    <> "T" Then Call ALERTS("아이디 중복체크를 해주세요.","back","")
		If Not checkID(strUserID, 4, 20) Then Call ALERTS("아이디는 영문 혹은 숫자 4자~12자리로 해주세요.","back","")
		If chkID <> strUserID				Then Call ALERTS("중복확인한 아이디와 입력된 아이디가 일치하지 않습니다.","back","")
		If strUserID = strPass				Then Call ALERTS("아이디와 비밀번호를 동일하게 사용할 수 없습니다.","back","")
	End If

	If DKRS_strSSH1 = "" Or DKRS_strSSH2 = "" Then Call ALERTS("가입확인에서 입력된 정보(생년월일)가 옳바르지 않습니다. 회원가입 첫페이지로 돌아갑니다.","go","joinStep01.asp")

	If Not checkPass(strPass, 4, 20) Then Call ALERTS("비밀번호는 영문, 숫자 혼합 6자~20자로 해주세요.","back","")
	If strPass <> strPass2 Then Call ALERTS("비밀번호와 비밀번호 확인란이 일치하지 않습니다.","back","")

	If Not checkPass(strPass, 6, 20)	Then Call ALERTS("비밀번호는 영문, 숫자 혼합 6자~20자로 해주세요.","back","")
	If strPass <> strPass2				Then Call ALERTS("비밀번호와 비밀번호 확인란이 일치하지 않습니다.","back","")


	If strEmail = "" Then Call ALERTS(LNG_JS_EMAIL,"back","")

	If strZip = "" Or strADDR1 = "" Or strADDR2 = "" Then Call ALERTS(LNG_JS_ADDRESS1,"back","")
	If strMobile = "" Then Call ALERTS(LNG_JS_MOBILE,"back","")


'####################################################################
'########## ▣ 데이터베이스 체크 시작 ▣
'####################################################################

	'########## ▣ 아이디 중복 체크 ▣
	'	SQL = " SELECT COUNT(*) FROM [tbl_MemberInfo]  WHERE [WebID] = ?"
	'	arrParams = Array(_
	'		Db.makeParam("@strUserID",adVarChar,adParamInput,20,strUserID) _
	'	)
	'	intVoteCnt = CInt(Db.execRsData(SQL,DB_TEXT,arrParams,Nothing))
	'	If Int(intVoteCnt) > 0 Then Call alerts("사용할 수 없는 아이디입니다. 다시 한번 확인해주세요.","back","")

	CS_BirthDay = strBirth1 & strBirth2 & strBirth3

	If isSolar = "S" Then
		CS_BirthDayTF = 1
	Else
		CS_BirthDayTF = 2
	End If

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
	'strSSH = Dec_strSSH1 & Dec_strSSH2
	strSSH = DKRS_strSSH1 & Dec_strSSH2			'계좌인증

	'가입메일 전송 용
	Dec_strEmail = strEmail

	If DKCONF_SITE_ENC = "T" Then
		Set objEncrypter = Server.CreateObject("Hyeongryeol.StringEncrypter")
			objEncrypter.Key = con_EncryptKey
			objEncrypter.InitialVector = con_EncryptKeyIV
			If strSSH			<> "" Then strSSH			= objEncrypter.Encrypt(strSSH)
			If strADDR1			<> "" Then strADDR1			= objEncrypter.Encrypt(straddr1)
			If strADDR2			<> "" Then strADDR2			= objEncrypter.Encrypt(straddr2)
			If strTel			<> "" Then strTel			= objEncrypter.Encrypt(strTel)
			If strMobile		<> "" Then strMobile		= objEncrypter.Encrypt(strMobile)
			If DKRS_strBankNum	<> "" Then DKRS_strBankNum	= objEncrypter.Encrypt(DKRS_strBankNum)

			If DKRS_strSSH1		<> "" Then DKRS_strSSH1		= objEncrypter.Encrypt(DKRS_strSSH1)
			If DKRS_strSSH2		<> "" Then DKRS_strSSH2		= objEncrypter.Encrypt(DKRS_strSSH2)

			If DKCONF_ISCSNEW = "T" Then	''▣CS신버전 암/복호화 추가
				If strEmail		<> "" Then strEmail			= objEncrypter.Encrypt(LCase(strEmail))
				'If strUserID	<> "" Then strUserID		= objEncrypter.Encrypt(strUserID)
				If strPass		<> "" Then strPass			= objEncrypter.Encrypt(strPass)
			End If
		Set objEncrypter = Nothing
	End If


	' ▣ 후원라인체크
		arrParams1 = Array(_
			Db.makeParam("@MBID",adVarChar,adParamInput,20,SponID1), _
			Db.makeParam("@MBID2",adInteger,adParamInput,0,SponID2) _
		)
		ThisDownLeg = Db.execRsData("DKP_DOWNLEG_CHECK",DB_PROC,arrParams1,DB3)
		If ThisDownLeg = "F" Then
			Call ALERTS("선택하신 후원인의 하선 인원수를 초과합니다. 확인후 다시 시도해 주세요.","back","")
		End If


	'▣ CS 이름 + 생년월일 중복체크(탈퇴회원 중복대상제외'→ 전체회원중복체크)
		SQL = "SELECT COUNT([mbid]) FROM [tbl_memberinfo] WITH(NOLOCK) WHERE [M_Name] = ? And [BirthDay] = ? And [BirthDay_M] = ? And [BirthDay_D] = ? "
		arrParams = Array(_
			Db.makeParam("@M_Name",adVarWchar,adParamInput,100,DKRS_strName), _
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
				Call ALERTS("이미 등록된 핸드폰 번호입니다.\n본인이 회원가입을 하지 않았다면 본사로 문의해주세요.!","go","joinStep01.asp")
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
		SQL = "SELECT COUNT([mbid]) FROM [tbl_memberinfo] WITH(NOLOCK) WHERE [bankcode] = ? AND [bankaccnt] = ?"
		arrParams = Array(_
			Db.makeParam("@strBankCode",adVarChar,adParamInput,10,strBankCode), _
			Db.makeParam("@bankaccnt",adVarchar,adParamInput,100,DKRS_strBankNum) _
		)
		BANKACCNT_COUNT = CInt(Db.execRsData(SQL,DB_TEXT,arrParams,DB3))
		If BANKACCNT_COUNT > 0 Then
			Sfile.WriteLine "FAILE : 이미 CS에 등록된 계좌정보가 존재합니다"
			Call alerts("이미 CS에 등록된 계좌정보가 존재합니다!","go","joinStep01.asp")
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

Sfile.WriteLine chr(13)
Sfile.Close
Set Fso= Nothing
Set objError= Nothing

'		Call ResRW(MotherSite		,"MotherSite")
'		Call ResRW(TempDataNum		,"TempDataNum")
'		Call ResRW(Agree01			,"Agree01")
'		Call ResRW(strUserID		,"strUserID")
'		Call ResRW(strPass			,"strPass")
'		Call ResRW(DKRS_strName		,"strName")
'		Call ResRW(strMobile		,"strMobile")
'		Call ResRW(strEmail			,"strEmail")
'		Call ResRW(strZip			,"strZip")
'		Call ResRW(straddr1			,"straddr1")
'		Call ResRW(straddr2			,"straddr2")
'		Call ResRW(strTel			,"strTel")
'		Call ResRW(isSMS			,"isSMS")
'		Call ResRW(isMailing		,"isMailing")
'		Call ResRW(strBirth			,"strBirth")
'		Call ResRW(isSolar			,"isSolar")
'		Call ResRW(isSex			,"isSex")
'		Call ResRW(joinType			,"joinType")
'		Call ResRW(businessCode		,"businessCode")
'		Call ResRW(NominID1			,"NominID1")
'		Call ResRW(NominID2			,"NominID2")
'		Call ResRW(NominWebID		,"NominWebID")
'		Call ResRW(NominChk			,"NominChk")
'		Call ResRW(SponID1			,"SponID1")
'		Call ResRW(SponID2			,"SponID2")
'		Call ResRW(SponIDWebID		,"SponIDWebID")
'		Call ResRW(SponIDChk		,"SponIDChk")
'		Call ResRW(DKRS_strBankCode	,"bankCode")
'		Call ResRW(DKRS_strBankOwner,"bankOwner")
'		Call ResRW(DKRS_strBankNum	,"BankNumber")
'		Call ResRW(DKRS_strSSH1		,"strSSH1")
'		Call ResRW(DKRS_strSSH2		,"strSSH2")
'		Call ResRW(CS_BirthDayTF	,"CS_BirthDayTF")
'		Call ResRW(strSSH			,"strSSH")

'	Response.End


'####################################################################
'########## ▣ 데이터베이스 인풋 시작 ▣
'####################################################################

	nowTime = Now
	RegTime = Right("0000"&Year(nowTime),4) & Right("00"&Month(nowTime),2) & Right("00"&Day(nowTime),2)
	Recordtime = Left(nowTime,10) & " "& Right("00"&Hour(nowTime),2) &":"&Right("00"&Minute(nowTime),2) &":"&Right("00"&Second(nowTime),2)

	DKRS_strBankCode = Right("000"&DKRS_strBankCode,3)

'Response.end
		R_NationCode = "KR"

		'▣국가코드 한국인= 0, 외국인 = 1
		For_Kind_TF = 0
		If R_NationCode = "" Or R_NationCode = "KR" Then
			For_Kind_TF = 0
		Else
			For_Kind_TF = 1
		End If

		'▣CS성별 치환입력
		Select Case isSex
			Case "M"
				isSex = 1
			Case "F"
				isSex = 2
		End Select

		'▣웹아이디 직접입력 (A : KR-12345678, B : KR12345678, C : 12345678)
		If CS_AUTO_WEBID_TF = "T" Then
			strUserID = AUTO_WEBID_TYPE
		End IF

		'▣▣ [다국어] 사업자회원가입 INPUT - CS DB ONLY!!▣▣
		arrParams = Array(_
			Db.makeParam("@M_name",adVarWChar,adParamInput,50,DKRS_strName), _
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
			Db.makeParam("@bankCode",adVarChar,adParamInput,10,DKRS_strBankCode), _
			Db.makeParam("@bankOwner",adVarWChar,adParamInput,50,DKRS_strBankOwner), _
			Db.makeParam("@bankNumber",adVarChar,adParamInput,200,DKRS_strBankNum), _
			Db.makeParam("@businessCode",adVarChar,adParamInput,20,businessCode), _
			Db.makeParam("@BirthDay",adVarChar,adParamInput,4,strBirth1), _
			Db.makeParam("@BirthDay_M",adVarChar,adParamInput,2,strBirth2), _
			Db.makeParam("@BirthDay_D",adVarChar,adParamInput,2,strBirth3), _
			Db.makeParam("@BirthDayTF",adSmallInt,adParamInput,0,CS_BirthDayTF), _
			Db.makeParam("@strSSH1",adVarChar,adParamInput,50,DKRS_strSSH1), _
			Db.makeParam("@strSSH2",adVarChar,adParamInput,50,DKRS_strSSH2), _

			Db.makeParam("@For_Kind_TF",adSmallInt,adParamInput,0,For_Kind_TF), _
			Db.makeParam("@Country_code",adVarChar,adParamInput,20,R_NationCode), _
			Db.makeParam("@Sex",adSmallInt,adParamInput,0,isSex), _

			Db.makeParam("@M_Name_First",adVarWChar,adParamInput,100,DKRS_M_Name_First), _
			Db.makeParam("@M_Name_Last",adVarWChar,adParamInput,100,DKRS_M_Name_Last), _

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


		If OUTPUT_VALUE = "FINISH" Then
			'회원가입 이메일 발송(meta21)
			'Call FnWelComeMail(Dec_strEmail, THISMEMID1&" - "&Right("000000000"&THISMEMID2,MBID2_LEN), "")
			Call FnWelComeMail(Dec_strEmail, THISMEMID1, THISMEMID2, "join2", "")		'이메일 전용

			'회원가입 알림톡 발송(meta21)
			Call FN_PPURIO_MESSAGE(THISMEMID1, THISMEMID2, "join", "at", "", "")

			'회원가입 문자 발송(meta21)
			'Call Fn_MemMessage_Send(THISMEMID1, THISMEMID2, "join")
		End If


'PRINT OUTPUT_VALUE
'RESPONSE.End
	If OUTPUT_VALUE = "FINISH" Then
		If UCase(DK_MEMBER_NATIONCODE) = "KR" And S_SellMemTF = 0 Then

			'계좌인증 확인값 UPDATE
			If DKRS_strBankNum <> "" Then
				SQLBA = "UPDATE [tbl_memberinfo] SET [Reg_bankaccnt] = ? WHERE [mbid] = ? AND [mbid2] = ? "
				arrParamsBA = Array(_
					Db.makeParam("@bankNumber",adVarChar,adParamInput,200,DKRS_strBankNum), _
					Db.makeParam("@mbid",adVarChar,adParamInput,20,THISMEMID1), _
					Db.makeParam("@mbid2",adInteger,adParamInput,0,THISMEMID2) _
				)
				Call Db.exec(SQLBA,DB_TEXT,arrParamsBA,DB3)
			End If

			If NICE_BANK_WITH_MOBILE_USE = "T" Then
				'◆ 핸드폰인증 중복가입 확인값 UPDATE
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

		End If
	End If

	Select Case OUTPUT_VALUE
		Case "BLOCKID1"		: Call ALERTS("사용할 수 없는 아이디를 사용하였습니다.\n\n가입 도중 해당 아이디가 사용불가로 처리되었을 수 있습니다.\n\n다시 시도해주세요.","BACK","")
		Case "BLOCKID2"		: Call ALERTS("사용할 수 없는 닉네임를 사용하였습니다.\n\n가입 도중 해당 닉네임이 사용불가로 처리되었을 수 있습니다.\n\n다시 시도해주세요.","BACK","")
		Case "OVERLAPID"	: Call ALERTS("아이디가 중복되었습니다.\n\n가입 도중 기입하신 아이디로 가입하신 분이 있을 수 있습니다.\n\n다시 시도해주세요.","BACK","")
		Case "OVERLAP_NB"	: Call ALERTS(LNG_JS_ALREADY_REGISTERED_MEMBER2,"BACK","")
		Case "ERROR"		: Call ALERTS("회원정보 저장 중 에러가 발생하였습니다. 지속적인 에러 발생 시 고객센터로 연락바랍니다.","BACK","")
		Case "MORESPON"		: Call ALERTS("후원인을 더이상 등록할 수 없는 회원을 후원인으로 지정하였습니다","BACK","")
		'Case "FINISH"		: Call ALERTS("회원가입이 완료 되었습니다.\n\n가입회원의 회원번호는 "&THISMEMID1&" - "&Fn_MBID2(THISMEMID2)&" 입니다.","go","/index.asp")
		Case "FINISH"
			On Error Resume Next
			Set StrCipher = Server.CreateObject("Hoyasoft.StrCipher")
				THISMEMID1 = Trim(StrCipher.Encrypt(THISMEMID1,EncTypeKey1,EncTypeKey2))
				THISMEMID2 = Trim(StrCipher.Encrypt(THISMEMID2,EncTypeKey1,EncTypeKey2))
			Set StrCipher = Nothing
			On Error GoTo 0
			Call ALERTS("","silentgo","joinStep_Finish.asp?m1="&THISMEMID1&"&m2="&THISMEMID2)

		Case Else			: Call ALERTS("지정되지 않은 에러가 발생하였습니다. 오류 상황을 고객센터로 연락바랍니다.","BACK","")
	End Select
%>

</body>
</html>
