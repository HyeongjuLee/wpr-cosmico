<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<!--#include virtual = "/admin/_inc/document.asp"-->
</head>
<body>
<%
'	MaxFileAbort = 150 * 1024 * 1024 ' 최대파일 크기 업로드 거부(각 파일 별 공통 사항 / 하단의 파일 업로드 사이즈중 가장 큰 값으로 설정)
'	MaxDataSize1 = 10 * 1024 * 1024 ' 실제 썸네일의 업로드 시킬 파일 사이즈

'	Set Upload = Server.CreateObject("TABSUpload4.Upload")
'	Upload.CodePage = 65001									'글자 깨질때 추가!!
'	Upload.MaxBytesToAbort = MaxFileAbort
'	Upload.Start REAL_PATH("Temps")

'	strUserID		= upfORM("strUserID",True) ->

	strUserID		= pRequestTF("strUserID",True)
	strName			= pRequestTF("strName",True)
	strPass			= pRequestTF("strPass",True)

	strzip			= pRequestTF("strzip",False)
	straddr1		= pRequestTF("straddr1",False)
	straddr2		= pRequestTF("straddr2",False)

	strTel			= pRequestTF("strTel",False)
'	strTel1			= pRequestTF("tel_num1",False)
'	strTel2			= pRequestTF("tel_num2",False)
'	strTel3			= pRequestTF("tel_num3",False)

	strMobile		= pRequestTF("strMobile",False)
'	strMobile1		= pRequestTF("mob_num1",False)
'	strMobile2		= pRequestTF("mob_num2",False)
'	strMobile3		= pRequestTF("mob_num3",False)

	isSMS			= pRequestTF("sendsms",False)

	strEmail1		= pRequestTF("mailh",False)
	strEmail2		= pRequestTF("mailt",False)
	isMailing		= pRequestTF("sendemail",False)


	strBirth1		= pRequestTF("birthYY",False)
	strBirth2		= pRequestTF("birthMM",False)
	strBirth3		= pRequestTF("birthDD",False)

	isSolar			= pRequestTF("isSolar",True)

	memberType		= pRequestTF("memberType",True)
	intMemLevel		= pRequestTF("intMemLevel",True)
	SAdminSite		= pRequestTF("SAdminSite",False)

	isIDImg			= pRequestTF("isIDImg",False)
'	Org_strFile		= pRequestTF("Org_strFile",False)

'	strTel = ""
'	strMobile = ""

'print straddr1
'response.end


'	strMobile = strMobile1 &"-"& strMobile2 &"-"& strMobile3
'	strTel = strTel1 &"-"& strTel2 &"-"& strTel3


	strEmail = strEmail1 & "@" & strEmail2

	strBirth = strBirth1 &"-"& strBirth2 &"-"& strBirth3

	If Not IsDate(strBirth) Then strBirth = ""
	If isSMS = "" Then isSMS = "T"
	If isMailing = "" Then isMailing = "T"
	If SAdminSite = "" Then SAdminSite = ""

	'imgName = uploadImg("strFile",REAL_PATH("member\ORI"),REAL_PATH("member"),100,25)

'	imgName = upImg("strFile",REAL_PATH("member"))

'	If ImgName = "" Then ImgName = Org_strFile
'	print backword(imgName)

	If DKCONF_SITE_ENC = "T" Then
		Set objEncrypter = Server.CreateObject("Hyeongryeol.StringEncrypter")
			objEncrypter.Key = con_EncryptKey
			objEncrypter.InitialVector = con_EncryptKeyIV
			If straddr1			<> "" Then straddr1		= objEncrypter.Encrypt(straddr1)
			If straddr2			<> "" Then straddr2		= objEncrypter.Encrypt(straddr2)
			If strTel			<> "" Then strTel		= objEncrypter.Encrypt(strTel)
			If strMobile		<> "" Then strMobile	= objEncrypter.Encrypt(strMobile)
			If strSSH			<> "" Then strSSH		= objEncrypter.Encrypt(strSSH)
			If strPass			<> "" Then strPass		= objEncrypter.Encrypt(strPass)

			If DKCONF_ISCSNEW = "T" Then	''▣CS신버전 암/복호화 추가
				If strEmail		<> "" Then strEmail		= objEncrypter.Encrypt(strEmail)
			End If

		Set objEncrypter = Nothing
	End If

	arrParams = Array(_
		Db.makeParam("@strUserID",adVarChar,adParamInput,20,strUserID),_
		Db.makeParam("@strPass",adVarChar,adParamInput,150,strPass),_
		Db.makeParam("@strName",adVarChar,adParamInput,30,strName),_

		Db.makeParam("@strBirth",adDBTimeStamp,adParamInput,16,strBirth),_
		Db.makeParam("@isSolar",adChar,adParamInput,1,isSolar),_
		Db.makeParam("@strTel",adVarChar,adParamInput,150,strTel),_
		Db.makeParam("@strMobile",adVarChar,adParamInput,150,strMobile),_
		Db.makeParam("@isSMS",adChar,adParamInput,1,isSMS),_

		Db.makeParam("@strEmail",adVarChar,adParamInput,512,strEmail),_
		Db.makeParam("@isMailing",adChar,adParamInput,1,isMailing),_
		Db.makeParam("@strzip",adVarChar,adParamInput,10,strzip),_
		Db.makeParam("@strADDR1",adVarWChar,adParamInput,512,straddr1),_
		Db.makeParam("@strADDR2",adVarWChar,adParamInput,512,straddr2),_

		Db.makeParam("@intMemLevel",adInteger,adParamInput,0,intMemLevel),_
		Db.makeParam("@memberType",adVarChar,adParamInput,10,memberType),_
		Db.makeParam("@SAdminSite",adVarChar,adParamInput,20,SAdminSite),_
		Db.makeParam("@isIDImg",adChar,adParamInput,1,isIDImg),_

		Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
	)
	Call Db.exec("DKPA_MEMBER_INFO_MODIFY",DB_PROC,arrParams,Nothing)
	OUTPUT_VALUE = arrParams(UBound(arrParams))(4)

'		Db.makeParam("@imgName",adVarChar,adParamInput,512,imgName),_
	Select Case OUTPUT_VALUE
		Case "ERROR" : Call ALERTS(DBERROR,"back","")
		Case "FINISH" : Call ALERTS(DBFINISH,"go","member_list.asp")
	End Select



'	Call ResRW(strUserID,"strUserID")






%>
</body>
</html>
