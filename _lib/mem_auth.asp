<%

	'▣ 바이럴 추천입력 http://xxx.webpro.kr/?vid="&DKRS_WebID&"
	vID = gRequestTF("vid",False)
	If vID <> "" Then
		MOB_PATH_IS = ""
		If Left(ThisPageURL,3) = "/m/" Then MOB_PATH_IS = "/m"
		If Len(vID) > 20 Then
			Call ALERTS(LNG_ALERT_WRONG_ACCESS,"GO",MOB_PATH_IS&"/index.asp")
		End If
	End If


	If isCOOKIES_TYPE_LOGIN = "T" Then	'COOKIE방식

		'바이럴 추천입력
		If vID <> "" Then
			Set objEncrypter = Server.CreateObject ("Hyeongryeol.StringEncrypter")
				objEncrypter.Key = con_EncryptKey
				objEncrypter.InitialVector = con_EncryptKeyIV
				'If vID	<> "" Then Response.Cookies(COOKIES_NAME)("DK_MEMBER_VOTER_ID") = objEncrypter.Encrypt(vID)		'추천인아이디(다나,2016-03-17)
			Set objEncrypter = Nothing
		End If


		'세션 변수선언
		DK_SES_MEMBER_IDX = SESSION.sessionid

		If DK_BUSINESS_CNT = "" Or ISNULL(DK_BUSINESS_CNT) Or ISEMPTY(DK_BUSINESS_CNT) Then DK_BUISINESS_CNT = 0

		'If Request.Cookies(COOKIES_NAME)("DKMEMBERID") = NULL Then Request.Cookies(COOKIES_NAME)("DKMEMBERID") = ""

		DK_MEMBER_ID		 = Request.Cookies(COOKIES_NAME)("DKMEMBERID")
		DK_MEMBER_NAME		 = Request.Cookies(COOKIES_NAME)("DKMEMBERNAME")
		DK_MEMBER_LEVEL		 = Request.Cookies(COOKIES_NAME)("DKMEMBERLEVEL")
		DK_MEMBER_TYPE		 = Request.Cookies(COOKIES_NAME)("DKMEMBERTYPE")
		DK_MEMBER_ID1		 = Request.Cookies(COOKIES_NAME)("DKMEMBERID1")
		DK_MEMBER_ID2		 = Request.Cookies(COOKIES_NAME)("DKMEMBERID2")
		DK_MEMBER_WEBID		 = Request.Cookies(COOKIES_NAME)("DKMEMBERWEBID")
		DK_BUSINESS_CNT		 = Request.Cookies(COOKIES_NAME)("DKBUSINESSCNT")
		DK_MEMBER_STYPE		 = Request.Cookies(COOKIES_NAME)("DKCSMEMTYPE")
		DK_MEMBER_NATIONCODE = Request.Cookies(COOKIES_NAME)("DKCSNATIONCODE")
		DK_MEMBER_VOTER_ID	 = Request.Cookies(COOKIES_NAME)("DK_MEMBER_VOTER_ID")

		Set objEncrypter = Server.CreateObject ("Hyeongryeol.StringEncrypter")
			objEncrypter.Key = con_EncryptKey
			objEncrypter.InitialVector = con_EncryptKeyIV

			If DK_MEMBER_ID			<> "" Then DK_MEMBER_ID			= objEncrypter.Decrypt(DK_MEMBER_ID)			'아이디
			If DK_MEMBER_NAME		<> "" Then DK_MEMBER_NAME		= objEncrypter.Decrypt(DK_MEMBER_NAME)
			If DK_MEMBER_LEVEL		<> "" Then DK_MEMBER_LEVEL		= objEncrypter.Decrypt(DK_MEMBER_LEVEL)
			If DK_MEMBER_TYPE		<> "" Then DK_MEMBER_TYPE		= objEncrypter.Decrypt(DK_MEMBER_TYPE)
			If DK_MEMBER_ID1		<> "" Then DK_MEMBER_ID1		= objEncrypter.Decrypt(DK_MEMBER_ID1)
			If DK_MEMBER_ID2		<> "" Then DK_MEMBER_ID2		= objEncrypter.Decrypt(DK_MEMBER_ID2)
			If DK_MEMBER_WEBID		<> "" Then DK_MEMBER_WEBID		= objEncrypter.Decrypt(DK_MEMBER_WEBID)
			If DK_BUSINESS_CNT		<> "" Then DK_BUSINESS_CNT		= objEncrypter.Decrypt(DK_BUSINESS_CNT)
			If DK_MEMBER_STYPE		<> "" Then DK_MEMBER_STYPE		= objEncrypter.Decrypt(DK_MEMBER_STYPE)			'Sell_Mem_TF
			If DK_MEMBER_NATIONCODE <> "" Then DK_MEMBER_NATIONCODE = objEncrypter.Decrypt(DK_MEMBER_NATIONCODE)	'국가코드
			If DK_MEMBER_VOTER_ID	<> "" Then DK_MEMBER_VOTER_ID	= objEncrypter.Decrypt(DK_MEMBER_VOTER_ID) 		'추천인아이디(다나)

			If DK_MEMBER_LEVEL <> "" Then DK_MEMBER_LEVEL = CInt(DK_MEMBER_LEVEL)
			If DK_BUSINESS_CNT <> "" Then DK_BUSINESS_CNT = CDbl(DK_BUSINESS_CNT)

		Set objEncrypter = Nothing

		'PRINT DK_MEMBER_ID
		'PRINT DK_BUSINESS_CNT
		'Response.End


	Else	'SESSION방식


		'바이럴 추천입력
		If vID <> "" Then
			SESSION("DK_MEMBER_VOTER_ID") = vID
		End If


		'세션 변수선언
		DK_SES_MEMBER_IDX = SESSION.sessionid

		If DK_BUSINESS_CNT = "" Or ISNULL(DK_BUSINESS_CNT) Or ISEMPTY(DK_BUSINESS_CNT) Then DK_BUISINESS_CNT = 0

		DK_MEMBER_ID			= SESSION("DK_MEMBER_ID")
		DK_MEMBER_NAME			= SESSION("DK_MEMBER_NAME")
		DK_MEMBER_LEVEL			= SESSION("DK_MEMBER_LEVEL")
		DK_MEMBER_TYPE			= SESSION("DK_MEMBER_TYPE")
		DK_MEMBER_ID1			= SESSION("DK_MEMBER_ID1")
		DK_MEMBER_ID2			= SESSION("DK_MEMBER_ID2")
		DK_MEMBER_WEBID			= SESSION("DK_MEMBER_WEBID")
		DK_BUSINESS_CNT			= SESSION("DK_BUSINESS_CNT")
		DK_MEMBER_STYPE			= SESSION("DK_MEMBER_STYPE")
		DK_MEMBER_NATIONCODE    = SESSION("DK_MEMBER_NATIONCODE")
		DK_MEMBER_VOTER_ID      = SESSION("DK_MEMBER_VOTER_ID")
		'DK_MEMBER_DOMAIN = SESSION("DK_MEMBER_DOMAIN")


		If DK_MEMBER_LEVEL <> "" Then DK_MEMBER_LEVEL = CInt(DK_MEMBER_LEVEL)
		If DK_BUSINESS_CNT <> "" Then DK_BUSINESS_CNT = CDbl(DK_BUSINESS_CNT)


	End If

'	DK_MEMBER_ID	 = "test"
'	DK_MEMBER_ID1	 = "kr"
'	DK_MEMBER_ID2	 = "12120012"
'	DK_MEMBER_WEBID	 = "test"
'	DK_MEMBER_NAME	 = "테스트012"
'	DK_MEMBER_LEVEL  = 1
'	DK_MEMBER_TYPE	 = "COMPANY"
'	DK_MEMBER_DOMAIN = "www"
'	DK_BUSINESS_CNT  = 0



'	Set StrCipher = Nothing

'	PRINT DK_MEMBER_ID
'	PRINT DK_MEMBER_NAME
'	PRINT DK_MEMBER_LEVEL
'	PRINT DK_MEMBER_TYPE
'	PRINT DK_MEMBER_DOMAIN


	'상단 버튼 초기화
	ADMIN_ROOT = ""
	MEMBER_ROOT = ""

	DK_MEMBER_IDX = DK_SES_MEMBER_IDX
	' 비회원 변수 대입
		If DK_MEMBER_ID = "" Or IsNull(DK_MEMBER_ID) = True Then

			DK_MEMBER_ID	 = "GUEST"
			DK_MEMBER_ID1	 = ""
			DK_MEMBER_ID2	 = ""
			DK_MEMBER_WEBID  = ""
			DK_MEMBER_TYPE	 = "GUEST"
			DK_MEMBER_NAME   = "GUEST"
			DK_MEMBER_LEVEL  = 0
			DK_MEMBER_DOMAIN = strHostA
			DK_BUSINESS_CNT  = 0
			DK_MEMBER_STYPE  = 9
			DK_MEMBER_NATIONCODE = UCase(Lang)		'다국어 비로그인시 쇼핑몰상품 List (로그인상태 = 회원의 국가

		End If


	If webproIP = "T" Then
	'	Call ResRW(DK_MEMBER_ID,"DK_MEMBER_ID")
	'	Call ResRW(DK_MEMBER_ID1,"DK_MEMBER_ID1")
	'	Call ResRW(DK_MEMBER_ID2,"DK_MEMBER_ID2")
	'	Call ResRW(DK_MEMBER_WEBID,"DK_MEMBER_WEBID")
	'	Call ResRW(DK_MEMBER_LEVEL,"DK_MEMBER_LEVEL")
	'	Call ResRW(DK_MEMBER_TYPE,"DK_MEMBER_TYPE")
	'	Call ResRW(DK_MEMBER_NATIONCODE,"DK_MEMBER_NATIONCODE")
	End if

		'EncryptText = obj.Encrypt(PlainText,key1,key2)
'	Response.cookies("ilovekt").Domain = "ilovekt.co.kr"
'	Response.cookies("ilovekt")("id") = StrCipher.Encrypt("333",EncTypeKey1,EncTypeKey2)

'	If getUserIP <> "112.154.152.228" Then Call ALERTS("요청하신 URL에 해당하는 현재 최종점검 중입니다.\n OPEN 예정시간 : 8월 8일 14:00","back","")


%>
