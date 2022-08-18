<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	PAGE_SETTING = "MY_LOGIN"
	NO_MEMBER_REDIRECT = "F"
%>
<!--#include virtual = "/m/_include/document.asp"-->
</head>
<body onunload="">

<%

	backURL			= pRequestTF("backURL",False) ' 로그인 후 이동할 장소

	memberType		= pRequestTF("memberType",True) ' 로그인 타입

	memberIDS		= pRequestTF("memberIDS",True)
	memberPWD		= pRequestTF("memberPWD",True)

	memberPWD = backword(memberPWD)
	Set objEncrypter = Server.CreateObject ("Hyeongryeol.StringEncrypter")
		objEncrypter.Key = con_EncryptKey
		objEncrypter.InitialVector = con_EncryptKeyIV
		If backURL	<> "" Then backURL	 = objEncrypter.Decrypt(backURL)
	Set objEncrypter = Nothing

	'test% 아이디회원 접근금지
	If webproIP <> "T" Then
		Select Case Left(LCase(strID),4)
			Case "test"
				Call alerts(LNG_MEMBER_LOGINOK_ALERT14,"back","")
		End Select
	End If

	'print backurl
	'Response.End
	'▣CS신버전 WebID/Password 암/복호화
	If DKCONF_SITE_ENC = "T" And DKCONF_ISCSNEW = "T" Then
		Set objEncrypter = Server.CreateObject ("Hyeongryeol.StringEncrypter")
			objEncrypter.Key = con_EncryptKey
			objEncrypter.InitialVector = con_EncryptKeyIV

			Select Case UCase(memberType)
				Case "N","M"
					If memberPWD	<> "" Then memberPWD	 = objEncrypter.Encrypt(memberPWD)
				Case "I"
					If memberPWD	<> "" Then memberPWD	 = objEncrypter.Encrypt(memberPWD)
					'If memberIDS	<> "" Then memberIDS	 = objEncrypter.Encrypt(memberIDS)
			End Select

		Set objEncrypter = Nothing
	End If




	If InStr(backURL,"joinStep") > 0 Then backURL = "/m/index.asp"
	If InStr(backURL,"joinFinish") > 0 Then backURL = "/m/index.asp"

	If backURL = "" Then backURL = "/m/index.asp"

	Select Case memberType
		Case "I"
			arrParams = Array(_
				Db.makeParam("@strUserID",adVarWChar,adParamInput,100,memberIDS) _
			)
			Set DKRS = Db.execRs("DKP_MEMBER_LOGIN_FOR_ID",DB_PROC,arrParams,DB3)
		Case "N"
			arrMBID = Split(memberIDS,"-")
			If Ubound(arrMBID) < 1 Then Call ALERTS(LNG_MEMBER_LOGINOK_ALERT01,"BACK","")
			'If Ubound(arrMBID) < 1 Then Call ALERTS("아이디가 올바르지 않습니다\n\n아이디는 아이디앞자리-아이디뒷자리 형식입니다.","BACK","")
			memberIDS_S1 = arrMBID(0)
			memberIDS_S2 = arrMBID(1)

			arrParams = Array(_
				Db.makeParam("@MBID1",adVarChar,adParamInput,20,memberIDS_S1), _
				Db.makeParam("@MBID2",adInteger,adParamInput,4,memberIDS_S2) _
			)
			Set DKRS = Db.execRs("DKP_MEMBER_LOGIN_FOR_NUM",DB_PROC,arrParams,DB3)

		Case Else : Call ALERTS(LNG_MEMBER_LOGINOK_ALERT02,"BACK","")
		'Case Else : Call ALERTS("로그인 정보가 올바르지 않습니다.","BACK","")
	End Select


	isUser = False
	If Not DKRS.BOF And Not DKRS.EOF Then
		isUser = True
		Select Case memberType
			Case "M"
				mbid1			= ""
				mbid2			= ""
				WebID			= ""
				memID			= DKRS("strUserID")
				memSite			= DKRS("MotherSite")
				memPass			= DKRS("strPass")
				memName			= DKRS("strName")
				memLevel		= DKRS("intMemLevel")
				memType			= DKRS("memberType")
				SAdminSite		= DKRS("SAdminSite")
				memState		= DKRS("strState")
				BusinessBossCnt = 0
				Sell_Mem_TF		= "9"
				Na_Code			= UCase(Lang)
				BusinessBossCnt = 0
			Case "I"
				mbid1			= DKRS("mbid")
				mbid2			= DKRS("mbid2")
				WebID			= DKRS("webid")
				memID			= "CS_"&DKRS("mbid")&"_"&DKRS("mbid2")
				'memID			= "CS_"&DKRS("webid")
				memSite			= "CS"
				memPass			= DKRS("webpassword")
				memName			= DKRS("m_name")
				'memLevel		= 2
				memType			= "COMPANY"
				SAdminSite		= ""
				memState		= DKRS("leaveCheck")
				Sell_Mem_TF		= DKRS("Sell_Mem_TF")
				Na_Code			= DKRS("Na_Code")

				If Sell_Mem_TF = "1" Then
					memLevel		= 1
				Else
					memLevel		= 2
				End If
			Case "N"
				mbid1			= DKRS("mbid")
				mbid2			= DKRS("mbid2")
				WebID			= DKRS("webid")
				memID			= "CS_"&DKRS("mbid")&"_"&DKRS("mbid2")
				'memID			= "CS_"&DKRS("webid")
				memSite			= "CS"
				memPass			= DKRS("webpassword")
				memName			= DKRS("m_name")
				'memLevel		= 2
				memType			= "COMPANY"
				SAdminSite		= ""
				memState		= DKRS("leaveCheck")
				Sell_Mem_TF		= DKRS("Sell_Mem_TF")
				Na_Code			= DKRS("Na_Code")

				If Sell_Mem_TF = "1" Then
					memLevel		= 1
				Else
					memLevel		= 2
				End If

				If WebID <> "" Then Call ALERTS(LNG_MEMBER_LOGINOK_ALERT03,"BACK","")
				'If WebID <> "" Then Call ALERTS("웹아이디 등록회원은 아이디로만 로그인 할 수 있습니다.","BACK","")


			Case Else : Call ALERTS(LNG_MEMBER_LOGINOK_ALERT02,"back","")
			'Case Else : Call ALERTS("로그인 회원타입이 틀렸습니다","back","")
		End Select
		If IsNull(SAdminSite) Then SAdminSite = ""
	End If
	Call closeRS(DKRS)

	If isUser Then

		'▣CS신버전 WebID/Password 암/복호화
		If DKCONF_SITE_ENC = "T" And DKCONF_ISCSNEW = "T" Then
			Set objEncrypter = Server.CreateObject ("Hyeongryeol.StringEncrypter")
				objEncrypter.Key = con_EncryptKey
				objEncrypter.InitialVector = con_EncryptKeyIV
				'If WebID <> "" Then WebID  = objEncrypter.Decrypt(WebID)
			Set objEncrypter = Nothing
		End If


		'▣ CS 등록 국가정보 확인
		SQL = "SELECT * FROM [DK_NATION] WITH(NOLOCK) WHERE [using] = 1 AND [nationCode] = ?"
		arrParams = Array(_
			Db.makeParam("@nationcode",adVarChar,adParamInput,20,Na_Code) _
		)
		Set HJRS = Db.execRs(SQL,DB_TEXT,arrParams,DB3)
		If Not HJRS.BOF And Not HJRS.EOF Then
			HJRS_nationCode	= HJRS("nationCode")
		Else
			Call ALERTS("We are sorry. The country code is not valid.","back","")
		End If

	'	Select Case UCase(HJRS_nationCode)
	'		CASE "KR","MN"
	'			Na_Code_Domain = Na_Code
	'		Case Else
	'			Na_Code_Domain = "us"
	'	End Select

		'▣소속국가사이트만 로그인가능
	'	'GO_URL_TO = "gng.webpro.kr/m"
	'	GO_URL_TO = "jayjunmongolia.com/m"
	'	GO_URL_TO = LCase(Na_Code_Domain)&"."&GO_URL_TO

	'	If memType <> "ADMIN" Then
	'	''	If (UCase(Lang) <> UCase(Na_Code_Domain)) Then Call ALERTS("소속국가 페이지로 이동합니다.\n\nWill be move to your contry website.","GO","http://"&GO_URL_TO)
	'	End If


		' 셀러 관련 로그인 체크
		If memState = "100" Then Call alerts(LNG_MEMBER_LOGINOK_ALERT05,"back","")
		If memState = "201" Then Call alerts(LNG_MEMBER_LOGINOK_ALERT06,"back","")
		If memState = "301" Then Call alerts(LNG_MEMBER_LOGINOK_ALERT07,"back","")

		If memState = "443" Then Call alerts(LNG_MEMBER_LOGINOK_ALERT08,"back","")
		If memState = "444" Then Call alerts(LNG_MEMBER_LOGINOK_ALERT09,"back","")
		If memState = "445" Then Call alerts(LNG_MEMBER_LOGINOK_ALERT10,"back","")
		If memState = "0" Then Call alerts(LNG_MEMBER_LOGINOK_ALERT11,"back","")

		'If Sell_Mem_TF = "1" Then Call alerts(LNG_MEMBER_LOGINOK_ALERT12,"back","")
		If LCase(memberPWD) <> LCase(memPass) Then Call alerts(LNG_MEMBER_LOGINOK_ALERT13,"back","")

		'방문횟수 증가
		If memberType = "member" Then
			SQL = "UPDATE [DK_MEMBER] SET [intVisit] = [intVisit] + 1 WHERE [strUserID] = ?"
			arrParams = Array( _
				Db.makeParam("@strUserID",adVarChar,adParamInput,20,strID), _
				Db.makeParam("@HostIP",adVarChar,adParamInput,50,getUserIP) _
			)
			Call Db.exec("DKP_MEMBER_LOGIN_LOG",DB_PROC,arrParams,Nothing)
		End If

		'If LCase(memberType) = "N" Or LCase(memberType) = "n" Then
			arrParams = Array(_
				Db.makeParam("@mbid",adVarChar,adParamInput,20,mbid1), _
				Db.makeParam("@mbid2",adInteger,adParamInput,0,mbid2) _
			)
			BusinessBossCnt = Db.execRsData("DKP_BUSINESS_BOSS",DB_PROC,arrParams,DB3)
		'End If
		If BusinessBossCnt = "" Then BusinessBossCnt = 0


		SESSION.TIMEOUT = DK_SESSION_TIMEOUT

		If isCOOKIES_TYPE_LOGIN = "T" Then	'COOKIE방식
			Set objEncrypter = Server.CreateObject ("Hyeongryeol.StringEncrypter")
				objEncrypter.Key = con_EncryptKey
				objEncrypter.InitialVector = con_EncryptKeyIV

				Response.Cookies(COOKIES_NAME).path = "/"
				If memID			<> "" Then Response.Cookies(COOKIES_NAME)("DKMEMBERID")      = objEncrypter.Encrypt(memID)			'아이디
				If memName			<> "" Then Response.Cookies(COOKIES_NAME)("DKMEMBERNAME")    = objEncrypter.Encrypt(memName)
				If memLevel			<> "" Then Response.Cookies(COOKIES_NAME)("DKMEMBERLEVEL")   = objEncrypter.Encrypt(memLevel)
				If memType			<> "" Then Response.Cookies(COOKIES_NAME)("DKMEMBERTYPE")    = objEncrypter.Encrypt(memType)
				If mbid1			<> "" Then Response.Cookies(COOKIES_NAME)("DKMEMBERID1")     = objEncrypter.Encrypt(mbid1)
				If mbid2			<> "" Then Response.Cookies(COOKIES_NAME)("DKMEMBERID2")     = objEncrypter.Encrypt(mbid2)
				If WebID			<> "" Then Response.Cookies(COOKIES_NAME)("DKMEMBERWEBID")   = objEncrypter.Encrypt(WebID)
				If BusinessBossCnt	<> "" Then Response.Cookies(COOKIES_NAME)("DKBUSINESSCNT")   = objEncrypter.Encrypt(BusinessBossCnt)
				If Sell_Mem_TF		<> "" Then Response.Cookies(COOKIES_NAME)("DKCSMEMTYPE")     = objEncrypter.Encrypt(Sell_Mem_TF)
				If Na_Code			<> "" Then Response.Cookies(COOKIES_NAME)("DKCSNATIONCODE")  = objEncrypter.Encrypt(Na_Code)
				'Response.Cookies(COOKIES_NAME).Domain = "."&SITEURL
			Set objEncrypter = Nothing

		Else		'SESSION방식
			SESSION("DK_MEMBER_ID")			= memID
			SESSION("DK_MEMBER_NAME")		= memName
			SESSION("DK_MEMBER_LEVEL")		= memLevel
			SESSION("DK_MEMBER_TYPE")		= memType
			SESSION("DK_MEMBER_ID1")		= mbid1
			SESSION("DK_MEMBER_ID2")		= mbid2
			SESSION("DK_MEMBER_WEBID")		= WebID
			SESSION("DK_BUSINESS_CNT")		= BusinessBossCnt
			SESSION("DK_MEMBER_STYPE")		= Sell_Mem_TF
			SESSION("DK_MEMBER_NATIONCODE")	= Na_Code

			'SESSION("DK_MEMBER_GROUP")		= memGroup
			'SESSION("DK_MEMBER_DOMAIN")	= memSite
		End If


		If LCase(Right(backURLs,17)) = "member_logout.asp" Then backURLs = "/m/index.asp"

		RESPONSE.REDIRECT backURL
		'RESPONSE.REDIRECT "/m/index.asp"


	Else
		Call alerts(LNG_MEMBER_LOGINOK_ALERT14,"back","")
		'Call alerts("등록된 회원이 아닙니다","back","")
	End If

%>

</body>
</html>