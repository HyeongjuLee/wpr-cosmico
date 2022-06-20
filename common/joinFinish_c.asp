<!--#include virtual = "/_lib/strFunc.asp" -->
<!--#include virtual = "/_lib/strFuncJoin.asp"-->
<!--#include virtual = "/_include/document.asp"-->
</head>
<body>
<%
	PAGE_SETTING = "MEMBERSHIP"

	If DK_MEMBER_LEVEL > 0 Then Response.Redirect "/index.asp"

	Select Case UCase(LANG)
		Case "KR"
	'		If Not checkRef(houUrl &"/common/joinStep_n03c.asp") Then Call alerts("잘못된 접근입니다.","go","/common/joinStep01.asp")
		Case Else
			Call alerts(LNG_ALERT_WRONG_ACCESS,"back","")
	End Select


		gather			= pRequestTF("gather",False)
		agreement		= pRequestTF("agreement",False)
		company			= pRequestTF("company",False)


		If agreement <> "T" Then Call ALERTS("이용약관에 동의하셔야합니다.","go","/common/joinStep01.asp")
		If gather <> "T" Then Call ALERTS("개인정보 수집 및 이용에 동의하셔야합니다.","go","/common/joinStep01.asp")
		If company <> "T" Then Call ALERTS("사업자회원 가입약관에 동의하셔야합니다.","go","/common/joinStep01.asp")


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
		strADDR1		= pRequestTF("straddr1",False)
		strADDR2		= pRequestTF("straddr2",False)

		strEmail		= pRequestTF("strEmail",True)
		'strEmail1		= pRequestTF("mailh",False)
		'strEmail2		= pRequestTF("mailt",False)

		isSex			= pRequestTF("isSex",True)

		strMobile1		= pRequestTF("mob_num1",False)
		strMobile2		= pRequestTF("mob_num2",False)
		strMobile3		= pRequestTF("mob_num3",False)

		strTel1			= pRequestTF("tel_num1",False)
		strTel2			= pRequestTF("tel_num2",False)
		strTel3			= pRequestTF("tel_num3",False)

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

		SponID1			= pRequestTF("SponID1",False)
		SponID2			= pRequestTF("SponID2",False)
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



		If NominChk		= "" Or NominChk = "F"	Then Call ALERTS("추천인이 등록되지 않았습니다","BACK","")
		If SponIDChk	= "" Or SponIDChk = "F"	Then Call ALERTS("후원인이 등록되지 않았습니다","BACK","")


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
			M_Name_First = DKRS("M_Name_First")
			M_Name_Last	 = DKRS("M_Name_Last")
		Else
			Call ALERTS("CS회원정보 로드에 실패하였습니다.다시 시도해주세요.","go","/common/joinStep01.asp")
		End If
		Call closeRS(DKRS)

	' 후원라인체크
		arrParams1 = Array(_
			Db.makeParam("@MBID",adVarChar,adParamInput,20,SponID1), _
			Db.makeParam("@MBID2",adInteger,adParamInput,0,SponID2) _
		)
		ThisDownLeg = Db.execRsData("DKP_DOWNLEG_CHECK",DB_PROC,arrParams1,DB3)
		If ThisDownLeg = "F" Then
			Call ALERTS("선택하신 후원인의 하선 인원수를 초과합니다. 확인후 다시 시도해 주세요.","back","joinStep01.asp")
		End If


	' 값 처리
		If strName = ""			Then Call ALERTS("이름을 입력해 주세요.","back","")
		If M_Name_First = ""	Then Call ALERTS("이름을 입력해 주세요!","back","")
		If M_Name_Last = ""		Then Call ALERTS("성을 입력해 주세요!","back","")
		If strUserID = ""		Then Call ALERTS("아이디를 입력해 주세요.","back","")
		If idcheck <> "T"		Then Call ALERTS("아이디 중복체크를 해주세요.","back","")


		If Not checkID(strUserID, 4, 20)	Then Call ALERTS("아이디는 영문 혹은 숫자 4자~20자리로 해주세요.","back","")
		If chkID <> strUserID				Then Call ALERTS("중복확인한 아이디와 입력된 아이디가 일치하지 않습니다.","back","")
		If strUserID = strPass				Then Call ALERTS("아이디와 비밀번호를 동일하게 사용할 수 없습니다.","back","")
		If checkID_CSID(strUserID)			Then Call ALERTS(LNG_JS_ID_FORM_CHECK_02 & LNG_notAllowedCSID,"back","")

		If Not checkPass(strPass, 6, 20)	Then Call ALERTS("비밀번호는 영문, 숫자,특수문자 혼합 6자~20자로 해주세요.","back","")
		If strPass <> strPass2				Then Call ALERTS("비밀번호와 비밀번호 확인란이 일치하지 않습니다.","back","")

		'If strEmail1 = "" Or strEmail2 = ""	Then Call ALERTS("이메일 주소를 입력하셔야합니다.","back","")
		If strMobile1 = "" Or strMobile2 = "" Or strMobile3 = "" Then Call ALERTS("핸드폰 번호를 입력하셔야합니다.","back","")

	' 값 병합

		strTel = ""
		strBirth = ""
		strMobile = ""

		strMobile = strMobile1 & strMobile2 & strMobile3		'신버전
		If strTel1 <> "" And strTel2 <> "" And strTel3 <> "" Then strTel = strTel1 & strTel2 & strTel3
		If strBirth1 <> "" And strBirth2 <> "" And strBirth3 <> "" Then strBirth = strBirth1 &"-"& strBirth2 &"-"& strBirth3
		'strEmail = strEmail1 & "@" & strEmail2


		If Not IsDate(strBirth) Then strBirth = ""
		If isSMS = "" Then isSMS = "T"
		If isMailing = "" Then isMailing = "T"

		If isSex = "" Then isSex = "M"

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
	Sfile.WriteLine "strUserID : " & strUserID
	Sfile.WriteLine "1_NominID1 : " & NominID1
	Sfile.WriteLine "1_NominID2 : " & NominID2
	Sfile.WriteLine "1_NominWebID : " & NominWebID
	Sfile.WriteLine "1_NominChk : " & NominChk
	Sfile.WriteLine "SponID1 : " & SponID1
	Sfile.WriteLine "SponID2 : " & SponID2
	Sfile.WriteLine "SponLine : " & SponLine

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
					If strEmail		<> "" Then strEmail		= objEncrypter.Encrypt(LCase(strEmail))
					'If strUserID	<> "" Then strUserID	= objEncrypter.Encrypt(strUserID)		'CS WebID
					If strPass		<> "" Then strPass		= objEncrypter.Encrypt(strPass)
				End If
			Set objEncrypter = Nothing
		End If



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


	' ▣ CS 주민번호 중복 체크 ▣
	'	SQL = " SELECT COUNT(*) FROM [tbl_MemberInfo] WHERE [cpno] = ?  "
	'	arrParams = Array(_
	'		Db.makeParam("@cpno",adVarChar,adParamInput,100,strSSH) _
	'	)
	'	SSHCOUNT = CInt(Db.execRsData(SQL,DB_TEXT,arrParams,Db3))
	'	If SSHCOUNT > 0 Then Call alerts("이미 CS에 가입된 주민등록번호 입니다","go","/common/joinStep01.asp")

	'▣ CS 이름 + 생년월일 중복체크(탈퇴회원 중복대상제외'→ 전체회원중복체크)
		'SQL = "SELECT COUNT([mbid]) FROM [tbl_memberinfo] WHERE [M_Name] = ? And [BirthDay] = ? And [BirthDay_M] = ? And [BirthDay_D] = ? And [LeaveCheck] = 1"
		SQL = "SELECT COUNT([mbid]) FROM [tbl_memberinfo] WHERE [M_Name] = ? And [BirthDay] = ? And [BirthDay_M] = ? And [BirthDay_D] = ? "		'→ 전체회원중복체크
		arrParams = Array(_
			Db.makeParam("@M_Name",adVarWchar,adParamInput,100,strName), _
			Db.makeParam("@BirthDay",adVarchar,adParamInput,4,strBirth1), _
			Db.makeParam("@BirthDay_M",adVarchar,adParamInput,2,strBirth2), _
			Db.makeParam("@BirthDay_D",adVarchar,adParamInput,2,strBirth3) _
		)
		DbCheckMember = CInt(Db.execRsData(SQL,DB_TEXT,arrParams,DB3))
		If DbCheckMember > 0 Then
			Sfile.WriteLine "FAILE : 동일한 이름과 생년월일"
			Call alerts("동일한 이름과 생년월일로 등록된 회원이 존재합니다.본인이 회원가입을 하지 않았다면 본사로 문의해주세요.!","go","joinStep01.asp")
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

'		Call ResRW(strNickName	,"strNickName")
'		Call ResRW(isViewID		,"isViewID")
'		Call ResRW(isSMS		,"isSMS")
'		Call ResRW(isMailing	,"isMailing")
'		Call ResRW(isSex		,"isSex")
'		Call ResRW(joinType		,"joinType")

'		Call ResRW(Bus_FLAG		,"Bus_FLAG")
'		Call ResRW(Bus_Name		,"Bus_Name")
'		Call ResRW(Bus_Number	,"Bus_Number")

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

%>
<%
	'후원인 체크 : 추천인의 후원산하 여부 2021-08-17
	If (NominID1 <> "" And NominID2 > 0) And (SponID1 <> "" And SponID2 > 0) And 1=2 Then
		SFV_COUNT = 0
		arrParams = Array(_
			Db.makeParam("@MBID",adVarChar,adParamInput,20,NominID1), _
			Db.makeParam("@MBID2",adInteger,adParamInput,0,NominID2), _
			Db.makeParam("@SponID1",adVarChar,adParamInput,20,SponID1), _
			Db.makeParam("@SponID2",adInteger,adParamInput,0,SponID2) _
		)
		SFV_COUNT = Db.execRsData("HJP_MEMBER_SEARCH_SPON_FROM_VOTER_COUNT",DB_PROC,arrParams,DB3)
		IF Cdbl(SFV_COUNT) < 1 Then Call ALERTS("후원인은 추천인의 후원산하에서 선택할 수 있습니다.","back","")
	End If
%>
<%

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

			Db.makeParam("@M_Name_First",adVarWChar,adParamInput,100,M_Name_First), _
			Db.makeParam("@M_Name_Last",adVarWChar,adParamInput,100,M_Name_Last), _

			Db.makeParam("@THISMEMID1",adVarChar,adParamOutput,20,""), _
			Db.makeParam("@THISMEMID2",adInteger,adParamOutput,0,0), _
			Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,11,"") _
		)
		Call Db.exec("DKP_MEMBER_JOIN_CS_GLOBAL",DB_PROC,arrParams,DB3)
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



'	PRINT OUTPUT_VALUE
'	RESPONSE.End
		Select Case OUTPUT_VALUE
			Case "BLOCKID1"		: Call ALERTS("사용할 수 없는 아이디를 사용하였습니다.\n\n가입 도중 해당 아이디가 사용불가로 처리되었을 수 있습니다.\n\n다시 시도해주세요.","BACK","")
			Case "BLOCKID2"		: Call ALERTS("사용할 수 없는 닉네임를 사용하였습니다.\n\n가입 도중 해당 닉네임이 사용불가로 처리되었을 수 있습니다.\n\n다시 시도해주세요.","BACK","")
			Case "OVERLAPID"	: Call ALERTS("아이디가 중복되었습니다.\n\n가입 도중 기입하신 아이디로 가입하신 분이 있을 수 있습니다.\n\n다시 시도해주세요.","BACK","")
			Case "OVERLAP_NB"	: Call ALERTS("동일한 이름과 생년월일로 등록된 회원이 존재합니다.본인이 회원가입을 하지 않았다면 본사로 문의해주세요.\n\n다시 시도해주세요.","BACK","")

			Case "ERROR"		: Call ALERTS("회원정보 저장 중 에러가 발생하였습니다. 지속적인 에러 발생 시 고객센터로 연락바랍니다.","BACK","")
			Case "MORESPON"		: Call ALERTS("후원인을 더이상 등록할 수 없는 회원을 후원인으로 지정하였습니다","BACK","")
			Case "FINISH"		: Call ALERTS("회원가입이 완료 되었습니다.\n\n가입회원의 회원번호는 "&THISMEMID1&" - "&Fn_MBID2(THISMEMID2)&" 입니다.","go","/index.asp")
			'Case "FINISH"		: Call ALERTS("회원가입이 완료 되었습니다.\n\n가입회원의 아이디는 "&strUserID_OUT&" 입니다.","go","/index.asp")
			'Case "FINISH"		: Call ALERTS("회원가입이 완료 되었습니다.\n\n가입회원의 웹아이디는 "&THISMEMID1&THISMEMID2&" 입니다.","go","/index.asp")
			Case Else			: Call ALERTS("지정되지 않은 에러가 발생하였습니다. 오류 상황을 고객센터로 연락바랍니다.","BACK","")
		End Select
%>

</body>
</html>
