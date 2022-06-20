<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	PAGE_SETTING = "CUSTOMER"
	ISLEFT = "T"
	ISSUBTOP = "T"
	ISSUBVISUAL = "T"

	view = 5 'gRequestTF("view",True)



%>
<!--#include virtual = "/_include/document.asp"-->
</head>
<body>
<!--#include virtual = "/_include/header.asp"-->
<%
	strName			= pRequestTF("strName",True)
	strEmail		= pRequestTF("strEmail",True)
	strMobile		= pRequestTF("strMobile",True)
	strSubject		= pRequestTF("strSubject",True)
	strContent		= pRequestTF("strContent",True)

'	strEmail = "dlkjsdklsjd@paran.com"
	If EmailCheck(strEmail) = False Then Call ALERTS("이메일 주소가 올바르지 않습니다.","BACK","")

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
		Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,50,"ERROR") _
	)
	Call Db.exec("DKP_COUNSEL2_INSERT",DB_PROC,arrParams,Nothing)
	OUTPUT_VALUE = arrParams(UBound(arrParams))(4)

	Select Case OUTPUT_VALUE
		Case "ERROR" : Call ALERTS(DBERROR,"BACK","")
		Case "FINISH" : Call ALERTS(DBFINISH,"GO","counsel2.asp")
		Case Else : Call ALERTS(DBUNDEFINED,"back","")
	End Select


%>
<!--#include virtual = "/_include/copyright.asp"-->
