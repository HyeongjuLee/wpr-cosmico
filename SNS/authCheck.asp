<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual = "/_lib/KISA_SHA256.asp"-->
<%
	snsType = pRequestTF_JSON("snsType",True)
	snsToken = pRequestTF_JSON("token",True)
	snsEmail = pRequestTF_JSON("email",False)

	If DK_MEMBER_LEVEL > 0 Then
		PRINT "{""result"":""error"",""resultMsg"":""이미 로그인되어있는 회원입니다"" }" :	Response.End
		Response.End
	End If

	'이메일 기준 가입 중복체크
	If snsEmail <> "" Then
		snsEmail = FN_HR_Encrypt(snsEmail)

		SQL_OL = "SELECT [snsType] FROM [tbl_memberInfo] WITH(NOLOCK) WHERE [snsType] <> ? And ([snsToken] = ? Or [Email] = ?) "
		arrParamsOL = Array(_
			Db.makeParam("@snsType",adVarchar,adParamInput,10,snsType), _
			Db.makeParam("@snsToken",adVarWchar,adParamInput,100,snsEmail), _
			Db.makeParam("@Email",adVarWchar,adParamInput,100,snsEmail) _
		)
		Set HJRS = Db.execRs(SQL_OL,DB_TEXT,arrParamsOL,DB3)
		If Not HJRS.BOF And Not HJRS.EOF Then
			HJRS_snsType	= HJRS("snsType")
			If HJRS_snsType <> "" Then HJRS_snsType = "("&HJRS_snsType&")"
			PRINT "{""result"":""error"",""resultMsg"":""동일 이메일정보로 가입된 회원이 존재합니다. "&HJRS_snsType&"  ""}" :	Response.End
		End If
		Call CloseRS(HJRS)

	End If


	'snsType 변조체크 S
	snsTypeChk = ""
	If InStr(previousURL,"/naver/") > 0 Then snsTypeChk ="naver"
	'If InStr(previousURL,"/kakao/") > 0 Then snsTypeChk ="kakao"

	If snsTypeChk = "naver" Then
		IF CStr(snsType) <> CStr(snsTypeChk) Then PRINT "{""result"":""error"",""resultMsg"":""오류가 발생했습니다.(type modulation)"" }" :	Response.End
	End If
	'snsType 변조체크 E



	If snsToken <> "" Then
		'snsToken = SHA256_Encrypt(snsToken)
		snsToken = FN_HR_Encrypt(snsToken)
	End If



	'카카오 토큰값 이메일 치환
	If snsType = "kakao" Then
		snsToken = snsEmail
	End If


	arrParams = Array(_
		Db.makeParam("@snsType",adVarChar,adParamInput,10,snsType), _
		Db.makeParam("@snsToken",adVarWChar,adParamInput,100,snsToken) _
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

			'▣SNS 위변조 검증 INSERT (HJP_SNS_MODULATION_CHECK_CNT)
			DK_MEMBER_ID1 = ""
			DK_MEMBER_ID2 = 0
			arrParams = Array(_
				Db.makeParam("@sessionIDX",adVarChar,adParamInput,50,DK_SES_MEMBER_IDX),_
				Db.makeParam("@MBID",adVarChar,adParamInput,20,DK_MEMBER_ID1),_
				Db.makeParam("@MBID2",adInteger,adParamInput,0,DK_MEMBER_ID2),_

				Db.makeParam("@strUsePageName",adVarChar,adParamInput,50,Request.ServerVariables("URL")&"?"&Request.ServerVariables("QUERY_STRING")),_
				Db.makeParam("@snsType",adVarChar,adParamInput,10,snsType),_
				Db.makeParam("@snsToken",adVarWChar,adParamInput,100,snsToken),_
				Db.makeParam("@hostIP",adVarChar,adParamInput,50,getUserIP), _

				Db.makeParam("@IDENTITY",adInteger,adParamOutput,0,0), _
				Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
			)
			Call Db.exec("HJP_SNS_CHECK_MERGE",DB_PROC,arrParams,DB3)
			orderTempIDX = arrParams(UBound(arrParams)-1)(4)
			OUTPUT_VALUE = arrParams(UBound(arrParams))(4)

			If OUTPUT_VALUE <> "FINISH" Then
				PRINT "{""result"":""error"",""resultMsg"":""error: output value checke!!""}" : Response.End
			Else
				PRINT "{""result"":""error"",""resultMsg"":""join"",""getId"":"""&snsToken&"""}" : Response.End
			End If



		Response.End
	End If

%>
