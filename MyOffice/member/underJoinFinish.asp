<!--#include virtual = "/_lib/strFunc.asp" -->
<!--#include virtual = "/_lib/strFuncJoin.asp"-->
<!--#include virtual = "/_include/document.asp"-->
</head>
<body>
<%
	Call ONLY_BUSINESS_MEMBER(DK_MEMBER_LEVEL,2)
	Call ONLY_CS_MEMBER()

	pT = gRequestTF("pt",False)
	If pt = "" Then pt = ""

	If pT = "shop" Then
		PAGE_SETTING = "SHOP_MEMBERSHIP"
		ptshop = "/shop"
	Else
		PAGE_SETTING = "MEMBERSHIP"
		ptshop = ""
	End If


	If Not checkRef(houUrl &"/myoffice/member/underJoin02.asp") Then Call ALERTS(LNG_ALERT_WRONG_ACCESS,"back","")

	If CDbl(DKRSG_Down_Month_Count) < 100 Then Call ALERTS(LNG_JS_NO_DUPLICATE_MEMBER_JOIN,"back","")		'gng 다구좌등록 (= 후원 소실적 누적PV 라인 인원 50명 이상)


		gather			= pRequestTF("gather",False)
		agreement		= pRequestTF("agreement",False)
		company			= pRequestTF("company",False)


		If agreement <> "T" Then Call ALERTS(LNG_JS_POLICY01,"back","")
		If gather <> "T" Then Call ALERTS(LNG_JS_POLICY02,"back","")
		If company <> "T" Then Call ALERTS(LNG_JS_POLICY03,"back","")


	' 값 받아오기
		MotherSite		= strHostA' Trim(getRequest("MotherSite",False)
		dataNum			= pRequestTF("dataNum",True)

'		strName			= pRequestTF("strName",True)
		strUserID		= pRequestTF("strID",True)
		strUserID_OUT	= strUserID

		strPass			= pRequestTF("strPass",True)
		strPass2		= pRequestTF("strPass2",True)

		idcheck			= pRequestTF("idcheck",True)
		chkID			= pRequestTF("chkID",True)

		strZip			= pRequestTF("strzip",False)
		strADDR1		= pRequestTF("strADDR1",False)
		strADDR2		= pRequestTF("strADDR2",False)

		''strEmail1		= pRequestTF("mailh",False)
		''strEmail2		= pRequestTF("mailt",False)
		strEmail		= pRequestTF("strEmail",False)

		isSex			= pRequestTF("isSex",True)

		strMobile		= pRequestTF("strMobile",False)

		strTel			= pRequestTF("strTel",False)


		strBirth1		= pRequestTF("birthyy",False)
		strBirth2		= pRequestTF("birthmm",False)
		strBirth3		= pRequestTF("birthdd",False)
		isSolar			= pRequestTF("isSolar",False)

		isMailing		= pRequestTF("sendemail",False)
		isSMS			= pRequestTF("sendsms",False)

		joinType		= pRequestTF("joinType",False)

		businessCode	= pRequestTF("businessCode",True)

		NominID1		= pRequestTF("NominID1",True)
		NominID2		= pRequestTF("NominID2",True)
		NominWebID		= pRequestTF("NominWebID",False)
		NominChk		= pRequestTF("NominChk",True)

		SponID1			= pRequestTF("SponID1",True)
		SponID2			= pRequestTF("SponID2",True)
		SponIDWebID		= pRequestTF("SponIDWebID",False)
		SponIDChk		= pRequestTF("SponIDChk",True)


		bankCode	 = pRequestTF("bankCode",False)
		bankOwner	 = pRequestTF("bankOwner",False)
		bankNumber	 = pRequestTF("bankNumber",False)


	'▣열우물 판매원구분(개인/사업자 2018-07-04)
	'	Bus_FLAG	 = pRequestTF("Bus_FLAG",False)
	'	Bus_Name	 = pRequestTF("Bus_Name",False)
	'	Bus_Number	 = pRequestTF("Bus_Number",False)
	'	If Bus_FLAG = "T" Then
	'		Bus_FLAG	= "Y"
	'		Bus_Name	= Bus_Name
	'		Bus_Number	= Bus_Number
	'		If Len(Bus_Number) < 10 Then Call ALERTS("정확한 사업자번호 10자리를 입력해 주세요.","BACK","")
	'	Else
	'		Bus_FLAG	= ""
	'		Bus_Name	= ""
	'		Bus_Number	= ""
	'	End If



		If NominChk		= "" Or NominChk = "F"	Then Call ALERTS(LNG_JS_VOTER,"BACK","")
		If SponIDChk	= "" Or SponIDChk = "F"	Then Call ALERTS(LNG_JS_SPONSOR,"BACK","")


		'국가정보
		''R_NationCode = Trim(pRequestTF("cnd",True))
		R_NationCode = DK_MEMBER_NATIONCODE		'소속 국가코드
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



		TempData1 = Left(dataNum,16)
		TempData2 = Right(dataNum,16)

		arrParams = Array(_
			Db.makeParam("@dataNum",adVarChar,adParamInput,50,dataNum) _
		)
		Set DKRS = Db.execRs("DKP_MEMBER_DATA",DB_PROC,arrParams,DB3)

		If Not DKRS.BOF And Not DKRS.EOF Then
			strName = DKRS(1)
			strSSH1 = DKRS(2)
			strSSH2 = DKRS(3)
		Else
			Call ALERTS(LNG_JOINFINISH_U_ALERT07,"BACK","")
		End If
		Call closeRS(DKRS)

	' 후원라인체크
		arrParams1 = Array(_
			Db.makeParam("@MBID",adVarChar,adParamInput,20,SponID1), _
			Db.makeParam("@MBID2",adInteger,adParamInput,0,SponID2) _
		)
		ThisDownLeg = Db.execRsData("DKP_DOWNLEG_CHECK",DB_PROC,arrParams1,DB3)
		If ThisDownLeg = "F" Then
			Call ALERTS(LNG_JOINFINISH_U_ALERT08,"back","")
		End If


	' 값 처리
		If strName = ""			Then Call ALERTS(LNG_JS_NAME,"back","")
		If strUserID = ""		Then Call ALERTS(LNG_JS_ID,"back","")
		If idcheck <> "T"		Then Call ALERTS(LNG_JS_ID_DOUBLE_CHECK,"back","")


		If Not checkID(strUserID, 4, 20)	Then Call ALERTS(LNG_JS_ID_FORM_CHECK,"back","")
		If chkID <> strUserID				Then Call ALERTS(LNG_JS_ID_DOUBLE_CHECK,"back","")
		If strUserID = strPass				Then Call ALERTS(LNG_JS_PASSWORD_FORM_CHECK2,"back","")

		If Not checkPass(strPass, 6, 20)	Then Call ALERTS(LNG_JS_PASSWORD_FORM_CHECK,"back","")
		If strPass <> strPass2				Then Call ALERTS(LNG_JS_PASSWORD_CHECK,"back","")

	''	If strEmail1 = "" Or strEmail2 = ""	Then Call ALERTS(LNG_JS_EMAIL,"back","")
	''	If strMobile = "" Then Call ALERTS(LNG_JS_MOBILE,"back","")

	' 값 병합
		''strTel = ""
		strBirth = ""
		''strMobile = ""

		''strMobile = strMobile1 & strMobile2 & strMobile3		'신버전
	''	If strTel1 <> "" And strTel2 <> "" And strTel3 <> "" Then strTel = strTel1 & strTel2 & strTel3
		If strBirth1 <> "" And strBirth2 <> "" And strBirth3 <> "" Then strBirth = strBirth1 &"-"& strBirth2 &"-"& strBirth3
	''	strEmail = strEmail1 & "@" & strEmail2


		If Not IsDate(strBirth) Then strBirth = ""
		If isSMS = "" Then isSMS = "T"
		If isMailing = "" Then isMailing = "T"

		If isSex = "" Then isSex = "M"

'로그기록생성
Dim  Fso : Set  Fso=CreateObject("Scripting.FileSystemObject")
Dim LogPath : LogPath = Server.MapPath ("/logings/joins/UmemJoins_") & Replace(Date(),"-","") & ".log"
Dim Sfile : Set  Sfile = Fso.OpenTextFile(LogPath,8,true)

	Sfile.WriteLine "Date : " & now()
	Sfile.WriteLine "Domain : " & Request.ServerVariables("HTTP_HOST")
	Sfile.WriteLine "Browser : " & Request.ServerVariables("HTTP_USER_AGENT")
	Sfile.WriteLine "Referer : " & Request.ServerVariables("HTTP_REFERER")
	Sfile.WriteLine "idcheck : " & idcheck
	Sfile.WriteLine "strName : " & strName
	Sfile.WriteLine "strUserID : " & strUserID
	Sfile.WriteLine "1_NominID1 : " & NominID1
	Sfile.WriteLine "1_NominID2 : " & NominID2
	Sfile.WriteLine "1_NominWebID : " & NominWebID
	Sfile.WriteLine "1_NominChk : " & NominChk




	' CS 관련 정보 입력
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
		strSSH = Dec_strSSH1 & Dec_strSSH2

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
					If strEmail		<> "" Then strEmail		= objEncrypter.Encrypt(strEmail)
					'If strUserID	<> "" Then strUserID	= objEncrypter.Encrypt(strUserID)		'CS WebID
					If strPass		<> "" Then strPass		= objEncrypter.Encrypt(strPass)
				End If
			Set objEncrypter = Nothing
		End If


	' ▣ 웹 주민번호 중복 체크 ▣
	'	SQL = "SELECT COUNT([strUserID]) " & _
	'			" FROM [DK_MEMBER_ADDINFO] WHERE [strSSH1] = ? AND [strSSH2] = ? "
	'	arrParams = Array(_
	'		Db.makeParam("@strSSH1",adVarchar,adParamInput,50,Dec_strSSH1), _
	'		Db.makeParam("@strSSH2",adVarchar,adParamInput,50,Dec_strSSH2) _
	'	)
	'	WebDBJoinCnt = Db.execRsData(SQL,DB_TEXT,arrParams,Nothing)
	'	If WebDBJoinCnt > 0 Then Call alerts("이미 웹에 가입된 주민등록번호 입니다 다시 한번 확인해주세요.","BACK","")

	' ▣ CS 주민번호 중복 체크 ▣
	'	SQL = " SELECT COUNT(*) FROM [tbl_MemberInfo] WHERE [cpno] = ?  "
	'	arrParams = Array(_
	'		Db.makeParam("@cpno",adVarChar,adParamInput,100,strSSH) _
	'	)
	'	SSHCOUNT = CInt(Db.execRsData(SQL,DB_TEXT,arrParams,Db3))
	'	If SSHCOUNT > 0 Then Call alerts("이미 CS에 가입된 주민등록번호 입니다","BACK","")

	'▣ CS 이름 + 생년월일 중복체크(탈퇴회원 중복대상제외'→ 전체회원중복체크)
		'SQL = "SELECT COUNT([mbid]) FROM [tbl_memberinfo] WHERE [M_Name] = ? And [BirthDay] = ? And [BirthDay_M] = ? And [BirthDay_D] = ? And [LeaveCheck] = 1"
		SQL = "SELECT COUNT([mbid]) FROM [tbl_memberinfo] WHERE [M_Name] = ? And [BirthDay] = ? And [BirthDay_M] = ? And [BirthDay_D] = ? "		'→ 전체회원중복체크
		SQL = SQL & "  AND NOT ( mbid = ? AND mbid2 = ?)"																					'	본인제외
		arrParams = Array(_
			Db.makeParam("@M_Name",adVarWchar,adParamInput,100,strName), _
			Db.makeParam("@BirthDay",adVarchar,adParamInput,4,strBirth1), _
			Db.makeParam("@BirthDay_M",adVarchar,adParamInput,2,strBirth2), _
			Db.makeParam("@BirthDay_D",adVarchar,adParamInput,2,strBirth3), _
				Db.makeParam("@mbid1",adVarChar,adParamInput,20,DK_MEMBER_ID1), _
				Db.makeParam("@mbid2",adInteger,adParamInput,0,DK_MEMBER_ID2) _
		)
		DbCheckMember = CInt(Db.execRsData(SQL,DB_TEXT,arrParams,DB3))

		'If DbCheckMember > 0 Then
		If DbCheckMember >= 2 Then
			'Sfile.WriteLine "FAILE : 동일한 이름과 생년월일"
			'Call alerts("동일한 이름과 생년월일로 등록된 회원이 존재합니다.본인이 회원가입을 하지 않았다면 본사로 문의해주세요.!","BACK","")
			'Call alerts(LNG_JS_ALREADY_REGISTERED_MEMBER2,"BACK","")

			Sfile.WriteLine "FAILE : 다구좌 회원등록 최대인원 초과"
			Call alerts(LNG_JS_OVER_DUPLICATE_MEMBER,"BACK","")	'다구좌 회원등록 최대인원을 초과하였습니다
		End If

		CS_BirthDay = strBirth1 & strBirth2 & strBirth3

		If isSolar = "S" Then
			CS_BirthDayTF = 1			'양력
		Else
			CS_BirthDayTF = 2			'음력
		End If


		nowTime = Now
		RegTime = Right("0000"&Year(nowTime),4) & Right("00"&Month(nowTime),2) & Right("00"&Day(nowTime),2)
		Recordtime = Left(nowTime,10) & " "& Right("00"&Hour(nowTime),2) &":"&Right("00"&Minute(nowTime),2) &":"&Right("00"&Second(nowTime),2)


	'	Call ResRW(MotherSite	,"MotherSite")
	'	Call ResRW(strName		,"strName")
	'	Call ResRW(strEmail		,"strEmail")
	'	Call ResRW(strSSH		,"strSSH")
	'	Call ResRW(strZip		,"strZip")
	'
	'	Call ResRW(strADDR1		,"strADDR1")
	'	Call ResRW(strADDR2		,"strADDR1")
	'	Call ResRW(strTel		,"strTel")
	'	Call ResRW(strMobile	,"strMobile")
	'
	'	Call ResRW(Recordtime	,"Recordtime")
	'	Call ResRW(RegTime		,"RegTime")
	'
	'	Call ResRW(SponID1		,"SponID1")
	'	Call ResRW(SponID2		,"SponID2")
	'	Call ResRW(SponIDWebID	,"SponIDWebID")
	'	Call ResRW(SponIDChk	,"SponIDChk")
	'
	'	Call ResRW(NominID1		,"NominID1")
	'	Call ResRW(NominID2		,"NominID2")
	'	Call ResRW(NominWebID	,"NominWebID")
	'	Call ResRW(NominChk		,"NominChk")
	'
	'	Call ResRW(strUserID	,"strUserID_E")
	'	Call ResRW(strPass		,"strPass_E")
	'
	'	Call ResRW(bankCode		,"bankCode")
	'	Call ResRW(bankOwner	,"bankOwner")
	'	Call ResRW(bankNumber	,"bankNumber")
	'	Call ResRW(businessCode	,"businessCode")
	'
	'	Call ResRW(strBirth		,"strBirth")
	'	Call ResRW(isSolar		,"isSolar")
	'	Call ResRW(strSSH1		,"strSSH1")
	'	Call ResRW(strSSH2		,"strSSH2")
	'	Call ResRW(strSSH		,"strSSH")
	'
	'	Call ResRW(strNickName	,"strNickName")
	'	Call ResRW(isViewID		,"isViewID")
	'	Call ResRW(isSMS		,"isSMS")
	'	Call ResRW(isMailing	,"isMailing")
	'	Call ResRW(isSex		,"isSex")
	'	Call ResRW(joinType		,"joinType")
	'
	'	Call ResRW(Bus_FLAG		,"Bus_FLAG")
	'	Call ResRW(Bus_Name		,"Bus_Name")
	'	Call ResRW(Bus_Number	,"Bus_Number")
	'	Response.End



	''	R_NationCode = "KR"

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


			'	Db.makeParam("@Bus_FLAG",adVarChar,adParamInput,1,Bus_FLAG), _
			'	Db.makeParam("@Bus_Name",adVarWChar,adParamInput,30,Bus_Name), _
			'	Db.makeParam("@Bus_Number",adVarWChar,adParamInput,30,Bus_Number), _
	   '▣▣ [다국어] 사업자회원가입 INPUT - CS DB ONLY!!▣▣
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

			Db.makeParam("@THISMEMID1",adVarChar,adParamOutput,20,""), _
			Db.makeParam("@THISMEMID2",adInteger,adParamOutput,0,0), _
			Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,11,"") _
		)
		Call Db.exec("DKP_MEMBER_UNDER_JOIN_CS_GLOBAL",DB_PROC,arrParams,DB3)
		''Call Db.exec("DKP_MEMBER_JOIN_CS_GLOBAL",DB_PROC,arrParams,DB3)
		THISMEMID1 = arrParams(UBound(arrParams)-2)(4)
		THISMEMID2 = arrParams(UBound(arrParams)-1)(4)
		OUTPUT_VALUE = arrParams(UBound(arrParams))(4)


	Sfile.WriteLine "THISMEMID1 : " & THISMEMID1
	Sfile.WriteLine "THISMEMID2 : " & THISMEMID2
	Sfile.WriteLine "OUTPUT_VALUE : " & OUTPUT_VALUE




Sfile.WriteLine chr(13)
Sfile.Close
Set Fso= Nothing
Set objError= Nothing


'	PRINT OUTPUT_VALUE
'	RESPONSE.End
		Select Case OUTPUT_VALUE
			Case "BLOCKID1"		: Call ALERTS(LNG_JOINFINISH_U_ALERT_OUTPUT01,"BACK","")
			Case "BLOCKID2"		: Call ALERTS(LNG_JOINFINISH_U_ALERT_OUTPUT02,"BACK","")
			Case "OVERLAPID"	: Call ALERTS(LNG_JOINFINISH_U_ALERT_OUTPUT03,"BACK","")
			Case "OVERLAP_NB"	: Call ALERTS(LNG_JS_ALREADY_REGISTERED_MEMBER2,"BACK","")
			Case "ERROR"		: Call ALERTS(LNG_JOINFINISH_U_ALERT_OUTPUT05,"BACK","")
			Case "MORESPON"		: Call ALERTS(LNG_JOINFINISH_U_ALERT_OUTPUT06,"BACK","")
			Case "FINISH"		: Call ALERTS(LNG_JOINFINISH_U_ALERT_OUTPUT07&"\n\n"&THISMEMID1&" - "&Fn_MBID2(THISMEMID2)&"","go",""&ptshop&"/myoffice/member/memberVote.asp")
			Case Else	: Call ALERTS(LNG_JOINFINISH_U_ALERT_OUTPUT08,"BACK","")
		End Select
%>

</body>
</html>


