<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<!--#include virtual = "/admin/_inc/document.asp"-->
</head>
<body>
<%

	mbid			= pRequestTF("mbid",True)
	mbid2			= pRequestTF("mbid2",True)

	strPass			= pRequestTF("strPass",False)

	If strPass = "" Then Call ALERTS("CS웹패스워드가 입력되지 않았습니다.","go","cs_member_list.asp")

	strzip			= pRequestTF("strzip",False)
	straddr1		= pRequestTF("straddr1",False)
	straddr2		= pRequestTF("straddr2",False)

	strTel1			= pRequestTF("tel_num1",False)
	strTel2			= pRequestTF("tel_num2",False)
	strTel3			= pRequestTF("tel_num3",False)

	strMobile1		= pRequestTF("mob_num1",False)
	strMobile2		= pRequestTF("mob_num2",False)	
	strMobile3		= pRequestTF("mob_num3",False)

	strEmail1		= pRequestTF("mailh",False)
	strEmail2		= pRequestTF("mailt",False)

	strBirth1		= pRequestTF("birthYY",False)
	strBirth2		= pRequestTF("birthMM",False)
	strBirth3		= pRequestTF("birthDD",False)

	isSolar			= pRequestTF("isSolar",True)

	strTel = ""
	strMobile = ""

	strMobile = strMobile1 &"-"& strMobile2 &"-"& strMobile3
	strTel	  = strTel1 &"-"& strTel2 &"-"& strTel3
	strEmail  = strEmail1 & "@" & strEmail2
	strBirth  = strBirth1 & strBirth2 & strBirth3

'response.end

	If DKCONF_SITE_ENC = "T" Then
		Set objEncrypter = Server.CreateObject("Hyeongryeol.StringEncrypter")
			objEncrypter.Key = con_EncryptKey
			objEncrypter.InitialVector = con_EncryptKeyIV
			If straddr1		<> "" Then straddr1		= objEncrypter.Encrypt(straddr1)
			If straddr2		<> "" Then straddr2		= objEncrypter.Encrypt(straddr2)
			If strTel		<> "" Then strTel		= objEncrypter.Encrypt(strTel)
			If strMobile	<> "" Then strMobile	= objEncrypter.Encrypt(strMobile)
		Set objEncrypter = Nothing
	End If

	arrParams = Array(_
		Db.makeParam("@mbid",adVarChar,adParamInput,20,mbid),_
		Db.makeParam("@mbid2",adInteger,adParamInput,0,mbid2),_
		Db.makeParam("@strPass",adVarChar,adParamInput,32,strPass),_
		Db.makeParam("@strBirth",adVarChar,adParamInput,8,strBirth),_
		Db.makeParam("@isSolar",adInteger,adParamInput,0,isSolar),_

		Db.makeParam("@strTel",adVarChar,adParamInput,100,strTel),_
		Db.makeParam("@strMobile",adVarChar,adParamInput,100,strMobile),_
		Db.makeParam("@strEmail",adVarChar,adParamInput,512,strEmail),_
		Db.makeParam("@strzip",adVarChar,adParamInput,6,Replace(strzip,"-","")),_
		Db.makeParam("@strADDR1",adVarWChar,adParamInput,500,straddr1),_

		Db.makeParam("@strADDR2",adVarWChar,adParamInput,500,straddr2),_
		Db.makeParam("@RecodTime",adVarChar,adParamInput,19,Recordtime),_
		Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
	)
	Call Db.exec("DKPA_MEMBER_INFO_MODIFY",DB_PROC,arrParams,DB3)
	OUTPUT_VALUE = arrParams(UBound(arrParams))(4)


	Select Case OUTPUT_VALUE
		Case "ERROR" : Call ALERTS(DBERROR,"back","")
		Case "FINISH" : Call ALERTS(DBFINISH,"go","cs_member_list.asp")
	End Select





%>
</body>
</html>
