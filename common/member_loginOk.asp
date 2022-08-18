<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	NO_MEMBER_REDIRECT = "F"
%>
<!--#include virtual = "/_include/document.asp"-->
</head>
<body>
<%



	memberType	= Trim(pRequestTF("memberType",True))
	strID		= Trim(pRequestTF("mem_id",True))
	strPass		= Trim(pRequestTF("mem_pwd",True))
	loginMode	= Trim(pRequestTF("loginMode",False))
	backURLs	= Trim(pRequestTF("backURLs",False))
	pageMode	= Trim(pRequestTF("pageMode",False))

	strPass = backword(strPass)

	Set objEncrypter = Server.CreateObject ("Hyeongryeol.StringEncrypter")
		objEncrypter.Key = con_EncryptKey
		objEncrypter.InitialVector = con_EncryptKeyIV
		If backURLs	<> "" Then backURLs	 = objEncrypter.Decrypt(backURLs)
	Set objEncrypter = Nothing
	'PRINT strPass

	'test% 아이디회원 접근금지
	If webproIP <> "T" Then
		Select Case Left(LCase(strID),4)
			Case "test"
				Call alerts(LNG_MEMBER_LOGINOK_ALERT14,"back","")
		End Select
	End If

	If DKCONF_SITE_ENC = "T" And DKCONF_ISCSNEW = "T" Then
		Set objEncrypter = Server.CreateObject ("Hyeongryeol.StringEncrypter")
			objEncrypter.Key = con_EncryptKey
			objEncrypter.InitialVector = con_EncryptKeyIV

			Select Case LCase(memberType)
				Case "company","member","seller"
					If strPass	<> "" Then strPass	 = objEncrypter.Encrypt(strPass)
				Case "company2"
					If strPass	<> "" Then strPass	 = objEncrypter.Encrypt(strPass)
					'If strID	<> "" Then strID	 = objEncrypter.Encrypt(strID)
			End Select
		Set objEncrypter = Nothing
	End If


	If pageMode = "shop" Then
		If backURLs = "" Or IsNull(backURLs) Then backURLs = "/shop/index.asp"'
	Else
		If backURLs = "" Or IsNull(backURLs) Then backURLs = "/index.asp"
	End If

	Select Case LCase(memberType)
		Case "member"
			arrParams = Array(_
				Db.makeParam("@strID",adVarChar,adParamInput,40,strID) _
			)
			Set DKRS = Db.execRs("DKP_MEMBER_LOGIN",DB_PROC,arrParams,Nothing)

		Case "company"
			arrMBID = Split(strID,"-")
			If Ubound(arrMBID) < 1 Then Call ALERTS(LNG_MEMBER_LOGINOK_ALERT01,"BACK","")
			MBID1 = arrMBID(0)
			MBID2 = arrMBID(1)

			arrParams = Array(_
				Db.makeParam("@MBID1",adVarChar,adParamInput,20,MBID1), _
				Db.makeParam("@MBID2",adInteger,adParamInput,4,MBID2) _
			)
			Set DKRS = Db.execRs("DKP_MEMBER_LOGIN_FOR_NUM",DB_PROC,arrParams,DB3)

		Case "company2"
			arrParams = Array(_
				Db.makeParam("@WebID",adVarWChar,adParamInput,100,strID) _
			)
			Set DKRS = Db.execRs("DKP_MEMBER_LOGIN_FOR_ID",DB_PROC,arrParams,DB3)

		Case "seller"
			arrParams = Array(_
				Db.makeParam("@strID",adVarChar,adParamInput,40,strID) _
			)
			Set DKRS = Db.execRs("DKP_SELLER_LOGIN",DB_PROC,arrParams,Nothing)

		Case Else : Call ALERTS(LNG_MEMBER_LOGINOK_ALERT02,"BACK","")
	End Select


'	print backURLs
'	response.End

	isUser = False
	If Not DKRS.BOF And Not DKRS.EOF Then
		isUser = True

		Select Case LCase(memberType)
			Case "member"
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
				Sell_Mem_TF		= "9"
				Na_Code			= UCase(Lang)
				BusinessBossCnt = 0

				If webproIP <> "T" And LCase(memID) = "webpro" Then
					Call ALERTS(LNG_MEMBER_LOGINOK_ALERT13&".11","back","")
				End If

			Case "company"
				mbid1			= DKRS("mbid")
				mbid2			= DKRS("mbid2")
				WebID			= DKRS("webid")
				memID			= "CS_"&DKRS("mbid")&"_"&DKRS("mbid2")
				memSite			= "CS"
				memPass			= DKRS("webpassword")
				memName			= DKRS("m_name")
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


			Case "company2"
				mbid1			= DKRS("mbid")
				mbid2			= DKRS("mbid2")
				WebID			= DKRS("webid")
				memID			= "CS_"&DKRS("mbid")&"_"&DKRS("mbid2")
				memSite			= "CS"
				memPass			= DKRS("webpassword")
				memName			= DKRS("m_name")
				memLevel		= 2
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

			Case "seller"
				mbid1			= ""
				mbid2			= ""
				WebID			= ""
				memID			= DKRS("strShopID")
				memSite			= "www"
				memPass			= DKRS("strPass")
				memName			= DKRS("strComName")
				memLevel		= 1
				memType			= "SELLER"
				SAdminSite		= ""
				memState		= DKRS("sellerState")
				Sell_Mem_TF		= "9"
				Na_Code			= ""
				Na_Code			= UCase(Lang)
				BusinessBossCnt = 0
		End Select


		If IsNull(SAdminSite) Then SAdminSite = ""
	End If
	Call closeRS(DKRS)



	If isUser Then

		If DKCONF_SITE_ENC = "T" And DKCONF_ISCSNEW = "T" Then
			Set objEncrypter = Server.CreateObject ("Hyeongryeol.StringEncrypter")
				objEncrypter.Key = con_EncryptKey
				objEncrypter.InitialVector = con_EncryptKeyIV
				'If WebID <> "" Then WebID  = objEncrypter.Decrypt(WebID)
			Set objEncrypter = Nothing
		End If


		If LCase(memberType) = "company" Or LCase(memberType) = "company2" Then
			arrParams = Array(_
				Db.makeParam("@mbid",adVarChar,adParamInput,20,mbid1), _
				Db.makeParam("@mbid2",adInteger,adParamInput,0,mbid2) _
			)
			BusinessBossCnt = Db.execRsData("DKP_BUSINESS_BOSS",DB_PROC,arrParams,DB3)
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
	'		Call ALERTS("We are sorry. The country code is not valid.","back","")
		End If

	'	Select Case UCase(HJRS_nationCode)
	'		CASE "KR","MN"
	'			Na_Code_Domain = Na_Code
	'		Case Else
	'			Na_Code_Domain = "us"
	'	End Select

	'	'▣소속국가사이트만 로그인가능
	'	'GO_URL_TO = "gng.webpro.kr"
	'	GO_URL_TO = "jayjunmongolia.com"
	'	GO_URL_TO = LCase(Na_Code_Domain)&"."&GO_URL_TO

	'	If memType <> "ADMIN"  Then
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

		'If webproip = "T" Then
		'	Call ResRW(webproip,"webproip")
		'	Call ResRW(strPass,"strPass")
		'	Call ResRW(memPass,"memPass")
		'	Call ResRW(strPAss2,"strPAss2")
		'	Response.End
		'End If

		If strPass <> memPass Then Call alerts(LNG_MEMBER_LOGINOK_ALERT13,"back","")
		'방문횟수 증가
		If memType = "member" Then
			SQL = "UPDATE [DK_MEMBER] SET [intVisit] = [intVisit] + 1 WHERE [strUserID] = ?"
			arrParams = Array( _
				Db.makeParam("@strUserID",adVarChar,adParamInput,20,strID), _
				Db.makeParam("@HostIP",adVarChar,adParamInput,50,getUserIP) _
			)
			Call Db.exec("DKP_MEMBER_LOGIN_LOG",DB_PROC,arrParams,Nothing)
		End If





		'세션 할당 시작
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
			'PRINT Request.cookies(COOKIES_NAME)("DKMEMBERID")
			'PRINT Request.cookies(COOKIES_NAME)("DKMEMBERNAME")
			'PRINT Request.cookies(COOKIES_NAME)("DKMEMBERLEVEL")
			'PRINT Request.cookies(COOKIES_NAME)("DKMEMBERTYPE")
			'PRINT Request.cookies(COOKIES_NAME)("DKMEMBERGROUP")
			'PRINT Request.cookies(COOKIES_NAME)("DKMEMBERDOMAIN")

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


		If LCase(Right(backURLs,17)) = "member_logout.asp" Then backURLs = "/index.asp"

		If loginMode = "page" Then
			RESPONSE.REDIRECT backURLs
			'RESPONSE.REDIRECT "/index.asp"
		Else
			Call ALERTS("","o_relaod","")
		End If
		'RESPONSE.REDIRECT backURLs
		'Call alerts(memName&"님 "&&"로그인 되었습니다.","silentgo",backURLs)

	Else
		Call alerts(LNG_MEMBER_LOGINOK_ALERT14,"back","")
	End If

%>

</body>
</html>
