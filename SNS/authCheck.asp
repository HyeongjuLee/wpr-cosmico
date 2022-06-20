<!--#include virtual="/_lib/strFunc.asp" -->
<%
    snsType = pRequestTF_JSON("snsType",True)
	token = pRequestTF_JSON("token",True)

	arrParams = Array(_
        Db.makeParam("@snsType",adVarChar,adParamInput,10,snsType), _
		Db.makeParam("@token",adVarWChar,adParamInput,100,token) _
	)
	Set DKRS = Db.execRs("DKP_MEMBER_LOGIN_FOR_SNS",DB_PROC,arrParams,DB3)

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

        arrParams = Array(_
            Db.makeParam("@mbid",adVarChar,adParamInput,20,mbid1), _
            Db.makeParam("@mbid2",adInteger,adParamInput,0,mbid2) _
        )
        BusinessBossCnt = Db.execRsData("DKP_BUSINESS_BOSS",DB_PROC,arrParams,DB3)

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
		End If

        '회원정보가 있음, 로그인 시킴
        PRINT "{""result"":""success"",""resultMsg"":""success""}"
		Response.End

	Else
        '회원정보가 없음, 회원가입 페이지 이동
		PRINT "{""result"":""error"",""resultMsg"":""error""}"
		Response.End
	End If

%>