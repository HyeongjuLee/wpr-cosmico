<!--#include virtual="/_lib/strFunc.asp" -->
<%
	On Error Resume Next

	kakaoID = pRequestTF2("uid",True)
	strID = kakaoID


	If DK_MEMBER_LEVEL > 0 Then
		PRINT "{""statusCode"":""9998"",""message"":"""&server.urlencode("FAIL")&""",""result"":""이미 로그인되어있는 회원입니다.""}"
		Response.End
	End If

	arrParams = Array(_
		Db.makeParam("@WebID",adVarWChar,adParamInput,100,strID) _
	)
	Set DKRS = Db.execRs("[DKSP_MEMBER_LOGIN_FOR_SNS]",DB_PROC,arrParams,DB3)

'	print backURLs
'	response.End

	isUser = False
	If Not DKRS.BOF And Not DKRS.EOF Then
		isUser = True

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
			'올리브 카이 승인회원 체크(2018-01-12)
			'Member_Okay_TF	= DKRS("Member_Okay_TF")
			'Member_Okay_ID	= DKRS("Member_Okay_ID")
			'Member_Okay_Time= DKRS("Member_Okay_Time")


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
				Call ALERTS("We are sorry. The country code is not valid.","back","")
			End If



		' 셀러 관련 로그인 체크

		If memState = "0" Then
			PRINT "{""statusCode"":""9997"",""message"":"""&server.urlencode("FAIL")&""",""result"":"""&LNG_MEMBER_LOGINOK_ALERT11&"""}"
			Response.End
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
			PRINT "{""statusCode"":""0000"",""message"":"""&server.urlencode("OK1")&""",""result"":""""}"
			Response.End
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
			PRINT "{""statusCode"":""0000"",""message"":"""&server.urlencode("OK2")&""",""result"":""""}"
			Response.End
		End If



	Else
		PRINT "{""statusCode"":""9999"",""message"":"""&server.urlencode("FAIL")&""",""result"":"""&LNG_MEMBER_LOGINOK_ALERT14&"""}"
		Response.End
	End If





%>