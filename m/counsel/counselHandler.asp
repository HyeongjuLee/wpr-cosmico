<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	PAGE_SETTING = "CUSTOMER"
	ISLEFT = "T"
	ISSUBTOP = "T"
	ISSUBVISUAL = "T"

	view = 4 'gRequestTF("view",True)

	If Not checkRef(houUrl &"/m/counsel/counsel.asp") Then Call alerts("잘못된 접근입니다.","back","")


%>
<!--#include virtual = "/_include/document.asp"-->
</head>
<body>
<%
	strName			= pRequestTF("strName",True)
	strEmail		= pRequestTF("strEmail",True)
	strMobile		= pRequestTF("strMobile",True)
	strSubject		= pRequestTF("strSubject",True)
	strContent		= pRequestTF("strContent",True)

	txtCaptcha		= pRequestTF("txtCaptcha",True)
	'CAPTCHA RESULT
	If IsEmpty(Session("ASPCAPTCHA")) Or Trim(Session("ASPCAPTCHA")) = "" Then
		Call ALERTS("보안문자 세션이 종료되었습니다. 다시 시도해주세요.","back","")
		'Call ALERTS("We are sorry. Your CAPTCHA Text SESSION expired. please retry.","back","")
	Else
		txtCaptcha = Replace(txtCaptcha, "i", "I", 1, -1, 1)
		txtCaptcha = Replace(txtCaptcha, "İ", "I", 1, -1, 1)
		txtCaptcha = Replace(txtCaptcha, "ı", "I", 1, -1, 1)
		txtCaptcha = UCase(txtCaptcha)
		If StrComp(txtCaptcha, Trim(Session("ASPCAPTCHA")), 1) <> 0 Then
			Call ALERTS("보안문자가 일치하지 않습니다.","back","")
			'Call ALERTS("We are sorry. Your CAPTCHA Text Not matched. please retry.","back","")
		End If
		Session("ASPCAPTCHA") = vbNullString
		Session.Contents.Remove("ASPCAPTCHA")
	End If
	If strName = "Acunetix" Then Call ALERTS("Wrong Access!!","back","")


'	strEmail = "dlkjsdklsjd@paran.com"
	If EmailCheck(strEmail) = False Then Call ALERTS(LNG_JS_EMAIL_CONFIRM,"BACK","")

	Set objEncrypter = Server.CreateObject ("Hyeongryeol.StringEncrypter")
		objEncrypter.Key = con_EncryptKey
		objEncrypter.InitialVector = con_EncryptKeyIV
		If strEmail		<> "" Then strEmail	= objEncrypter.Encrypt(strEmail)
		If strMobile	<> "" Then strMobile= objEncrypter.Encrypt(strMobile)
	Set objEncrypter = Nothing

	arrParams = Array(_
		Db.makeParam("@strName",adVarWChar,adParamInput,100,strName), _
		Db.makeParam("@strEmail",adVarWChar,adParamInput,512,strEmail), _
		Db.makeParam("@strSubject",adVarWChar,adParamInput,200,strSubject), _
		Db.makeParam("@strMobile",adVarWChar,adParamInput,50,strMobile), _
		Db.makeParam("@strContent",adVarWChar,adParamInput,MAX_LENGTH,strContent), _
		Db.makeParam("@strHostIP",adVarWChar,adParamInput,50,getUserIP()), _
		Db.makeParam("@strNation",adVarChar,adParamInput,10,UCase(LANG)), _
		Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,50,"ERROR") _
	)
	Call Db.exec("DKP_COUNSEL_INSERT",DB_PROC,arrParams,Nothing)
	OUTPUT_VALUE = arrParams(UBound(arrParams))(4)

	Select Case OUTPUT_VALUE
		Case "ERROR" : Call ALERTS(DBERROR,"BACK","")
		Case "FINISH" : Call ALERTS(DBFINISH,"GO","/m/counsel/counsel.asp")
		Case Else : Call ALERTS(DBUNDEFINED,"back","")
	End Select


%>
<!--#include virtual = "/_include/copyright.asp"-->
