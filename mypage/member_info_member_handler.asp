<!--#include virtual = "/_lib/strFunc.asp" -->
<%
	pT = gRequestTF("pt",False)
	If pt = "" Then pt = ""

	If pT = "shop" Then
		PAGE_SETTING = "SHOP_MYPAGE"
		ptshop = "?pt=shop"
	Else
		PAGE_SETTING = "MYPAGE"
		ptshop = ""
	End If


	Call ONLY_MEMBER(DK_MEMBER_LEVEL)


%>
<!--#include virtual = "/_lib/strFuncJoin.asp"-->
<!--#include virtual = "/_include/document.asp"-->
</head>
<body>
<%

	If Not checkRef(houUrl &"/mypage/member_info.asp") Then Call alerts(LNG_ALERT_WRONG_ACCESS,"go","/mypage/member_info.asp")

	' 값 받아오기
		strPass			= pRequestTF("strPass",True)

		isChgPass		= pRequestTF("isChgPass",False)
		newPass			= pRequestTF("newPass",False)
		newPass2		= pRequestTF("newPass2",False)


		strMobile1		= pRequestTF("mob_num1",False)
		strMobile2		= pRequestTF("mob_num2",False)
		strMobile3		= pRequestTF("mob_num3",False)

		strZip			= pRequestTF("strzip",False)
		strADDR1		= pRequestTF("straddr1",False)
		strADDR2		= pRequestTF("straddr2",False)

		strEmail1		= pRequestTF("mailh",False)
		strEmail2		= pRequestTF("mailt",False)

		isViewID		= pRequestTF("isViewID",True)

		strTel1			= pRequestTF("tel_num1",False)
		strTel2			= pRequestTF("tel_num2",False)
		strTel3			= pRequestTF("tel_num3",False)

		strBirth1		= pRequestTF("birthyy",False)
		strBirth2		= pRequestTF("birthmm",False)
		strBirth3		= pRequestTF("birthdd",False)
		isSolar			= pRequestTF("isSolar",False)

		isMailing		= pRequestTF("sendemail",False)
		isSMS			= pRequestTF("sendsms",False)


	' 값 처리

		If DK_MEMBER_ID = strPass			Then Call ALERTS(LNG_JS_PASSWORD_FORM_CHECK2,"back","")


		'If Not checkPass(strPass, 4, 20)	Then Call ALERTS(LNG_JS_PASSWORD_FORM_CHECK,"back","")


		If isChgPass = "T" Then
			If Not checkPass(newPass, 6, 20)	Then Call ALERTS(LNG_MYPAGE_INFO_MEMBER_HANDLER_ALERT04,"back","")
		End If


'		If Len(strPass) < 6 Or Len(strPass) > 20 Then Call ALERTS(LNG_JS_PASSWORD_FORM_CHECK,"back","")
'		If strEmail1 = "" Or strEmail2 = ""	Then Call ALERTS(LNG_JS_EMAIL,"back","")
'		If strMobile1 = "" Or strMobile2 = "" Or strMobile3 = "" Then Call ALERTS(LNG_JS_MOBILE,"back","")

	' 값 병합

		strTel = ""
		strBirth = ""
		strMobile = ""

		strMobile = strMobile1 &"-"& strMobile2 &"-"& strMobile3
		If strTel1 <> "" And strTel2 <> "" And strTel3 <> "" Then strTel = strTel1 &"-"& strTel2 &"-"& strTel3
		If strBirth1 <> "" And strBirth2 <> "" And strBirth3 <> "" Then strBirth = strBirth1 &"-"& strBirth2 &"-"& strBirth3
		strEmail = strEmail1 & "@" & strEmail2


		If Not IsDate(strBirth) Then strBirth = ""
		If isSMS = "" Then isSMS = "T"
		If isMailing = "" Then isMailing = "T"

		If isViewID = "" Then isViewID = "N"


		If DKCONF_SITE_ENC = "T" Then
			Set objEncrypter = Server.CreateObject("Hyeongryeol.StringEncrypter")
				objEncrypter.Key = con_EncryptKey
				objEncrypter.InitialVector = con_EncryptKeyIV

				If strADDR1			<> "" Then strADDR1		= objEncrypter.Encrypt(strADDR1)
				If strADDR2			<> "" Then strADDR2		= objEncrypter.Encrypt(strADDR2)
				If strTel			<> "" Then strTel		= objEncrypter.Encrypt(strTel)
				If strMobile		<> "" Then strMobile	= objEncrypter.Encrypt(strMobile)

				If DKCONF_ISCSNEW = "T" Then	'▣CS신버전 암/복호화 추가
					If strEmail		<> "" Then strEmail		= objEncrypter.Encrypt(strEmail)
					If strPass		<> "" Then strPass		= objEncrypter.Encrypt(strPass)
					If newPass		<> "" Then newPass		= objEncrypter.Encrypt(newPass)
					If chgPass		<> "" Then chgPass		= objEncrypter.Encrypt(chgPass)
				End If

			Set objEncrypter = Nothing
		End If

		If isChgPass = "F" Or isChgPass = "" Or IsNull(isChgPass) Then
			chgPass = strPass
		ElseIf isChgPass = "T" Then
			chgPass = newPass
		End If

		SQL = "SELECT [strPass] FROM [DK_MEMBER] WHERE [strUserID] = ?"
		arrParams = Array(_
			Db.makeParam("@strUserID",adVarChar,adParamInput,30,DK_MEMBER_ID) _
		)
		oriPass = Db.execRsData(SQL,DB_TEXT,arrParams,Nothing)


'		Call ResRW(MotherSite	,"MotherSite")
'		Call ResRW(strUserID	,"strUserID")
'		Call ResRW(strPass		,"strPass")
'		Call ResRW(strName		,"strName")
'		Call ResRW(strNickName	,"strNickName")
'		Call ResRW(strMobile	,"strMobile")
'		Call ResRW(strEmail		,"strEmail")
'		Call ResRW(strZip		,"strZip")
'		Call ResRW(straddr1		,"straddr1")
'		Call ResRW(straddr2		,"straddr2")
'		Call ResRW(isViewID		,"isViewID")
'		Call ResRW(strTel		,"strTel")
'		Call ResRW(isSMS		,"isSMS")
'		Call ResRW(isMailing	,"isMailing")
'		Call ResRW(strBirth		,"strBirth")
'		Call ResRW(isSolar		,"isSolar")
'		Call ResRW(isSex		,"isSex")
'		Call ResRW(oriPass		,"oriPass")
'		Call ResRW(chgPass		,"chgPass")

		If oriPass <> strPass Then Call alerts(LNG_MYPAGE_INFO_MEMBER_HANDLER_ALERT07,"back","")

'	response.End

		arrParams = Array(_
			Db.makeParam("@strUserID",adVarChar,adParamInput,20,DK_MEMBER_ID),_
			Db.makeParam("@strPass",adVarChar,adParamInput,150,chgPass),_

			Db.makeParam("@strMobile",adVarChar,adParamInput,150,strMobile),_
			Db.makeParam("@strEmail",adVarChar,adParamInput,500,strEmail),_

			Db.makeParam("@strZip",adVarChar,adParamInput,10,strZip),_
			Db.makeParam("@strADDR1",adVarWChar,adParamInput,512,straddr1),_
			Db.makeParam("@strADDR2",adVarWChar,adParamInput,512,straddr2),_

			Db.makeParam("@isViewID",adChar,adParamInput,1,isViewID),_

			Db.makeParam("@strTel",adVarChar,adParamInput,100,strTel),_
			Db.makeParam("@isSMS",adChar,adParamInput,1,isSMS),_
			Db.makeParam("@isMailing",adChar,adParamInput,1,isMailing),_

			Db.makeParam("@strBirth",adDBTimeStamp,adParamInput,16,strBirth),_
			Db.makeParam("@isSolar",adChar,adParamInput,1,isSolar),_

			Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
		)
		Call Db.exec("HJP_MEMBER_MODIFY",DB_PROC,arrParams,Nothing)


		OUTPUT_VALUE = arrParams(UBound(arrParams))(4)
		Select Case OUTPUT_VALUE
			Case "ERROR"		: Call ALERTS(LNG_MYPAGE_INFO_MEMBER_HANDLER_ALERT08,"BACK","")
			Case "FINISH"		: Call ALERTS(LNG_JS_MODIFY_COMPLETED,"go","/mypage/member_info.asp"&ptshop)
			Case Else			: Call ALERTS(LNG_ALERT_UNEXPECTED_ERROR,"BACK","")
		End Select

%>
