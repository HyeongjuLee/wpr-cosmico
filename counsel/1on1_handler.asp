<!--#include virtual = "/_lib/strFunc.asp"-->
<!--#include file = "1on1_config.asp"-->
<%

	Call noCache

	MaxFileAbort = 15 * 1024 * 1024 ' 최대파일 크기 업로드 거부(각 파일 별 공통 사항 / 하단의 파일 업로드 사이즈중 가장 큰 값으로 설정)


	Set Upload = Server.CreateObject("TABSUpload4.Upload")
	Upload.CodePage = 65001
	Upload.MaxBytesToAbort = MaxFileAbort
	Upload.Start REAL_PATH("Temps")

	MaxDataSize1 = 5 * 1024 * 1024 ' 실제 Data1의 업로드 시킬 파일 사이즈
	MaxDataSize2 = 5 * 1024 * 1024 ' 실제 Data2의 업로드 시킬 파일 사이즈
	MaxDataSize3 = 5 * 1024 * 1024 ' 실제 Data3의 업로드 시킬 파일 사이즈





	If Not checkRef(houUrl &"/counsel/1on1.asp") Then Call alerts(LNG_ALERT_WRONG_ACCESS,"back","")


%>
<!--#include virtual = "/_include/document.asp"-->
</head>
<body>
<!--#include virtual = "/_include/header.asp"-->
<%
	strUserID		= DK_MEMBER_ID
	strName			= DK_MEMBER_NAME
	strWebID		= DK_MEMBER_WEBID
	category1		= upfORM("Cate1",True)
	category2		= upfORM("Cate2",True)
	strEmail		= upfORM("strEmail",False)
	strMobile		= upfORM("strMobile",True)
	strSubject		= upfORM("strSubject",True)
	strContent		= upfORM("strContent",True)

	'txtCaptcha		= upfORM("txtCaptcha",True)
	isSmsSend		= upfORM("isSmsSend",False)
	isMailSend		= upfORM("isMailSend",False)

	If isSmsSend = "" Then isSmsSend = "F"
	If isMailSend = "" Then isMailSend = "F"

	If Left(category2,3) <> category1 Then Call ALERTS(LNG_ALERT_WRONG_ACCESS,"BACK","")


'	strEmail = "dlkjsdklsjd@paran.com"
	'If EmailCheck(strEmail) = False Then Call ALERTS(LNG_JS_EMAIL_CONFIRM&"1","BACK","")

	Set objEncrypter = Server.CreateObject ("Hyeongryeol.StringEncrypter")
		objEncrypter.Key = con_EncryptKey
		objEncrypter.InitialVector = con_EncryptKeyIV
		'If strName		<> "" Then strName		= objEncrypter.Encrypt(strName)
		If strEmail		<> "" Then strEmail		= objEncrypter.Encrypt(strEmail)
		If strMobile	<> "" Then strMobile	= objEncrypter.Encrypt(strMobile)

	Set objEncrypter = Nothing
	'strData1 = ""
	'strData2 = ""
	'strData3 = ""
	strData1 = FN_FILEUPLOAD("strData1","F",MaxDataSize1,REAL_PATH2("/uploadData/counselData1"),"")
	strData2 = FN_FILEUPLOAD("strData2","F",MaxDataSize2,REAL_PATH2("/uploadData/counselData2"),"")
	strData3 = FN_FILEUPLOAD("strData3","F",MaxDataSize3,REAL_PATH2("/uploadData/counselData3"),"")

	arrParams = Array(_
		Db.makeParam("@strCate",adVarChar,adParamInput,40,category2), _
		Db.makeParam("@strUserID",adVarChar,adParamInput,20,strUserID), _
		Db.makeParam("@strName",adVarWChar,adParamInput,200,strName), _
		Db.makeParam("@strEmail",adVarWChar,adParamInput,200,strEmail), _
		Db.makeParam("@strMobile",adVarWChar,adParamInput,200,strMobile), _

		Db.makeParam("@strSubject",adVarWChar,adParamInput,200,strSubject), _
		Db.makeParam("@strContent",adVarWChar,adParamInput,MAX_LENGTH,strContent), _

		Db.makeParam("@regIP",adVarChar,adParamInput,30,getUserIP), _
		Db.makeParam("@isSmsSend",adChar,adParamInput,1,isSmsSend), _
		Db.makeParam("@isMailSend",adChar,adParamInput,1,isMailSend), _
		Db.makeParam("@strNation",adVarChar,adParamInput,10,LANG), _

		Db.makeParam("@strData1",adVarWChar,adParamInput,100,strData1), _
		Db.makeParam("@strData2",adVarWChar,adParamInput,100,strData2), _
		Db.makeParam("@strData3",adVarWChar,adParamInput,100,strData3), _

		Db.makeParam("@strWebID",adVarChar,adParamInput,20,strWebID), _


		Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
	)
	Call Db.exec("DKSP_COUNSEL_1ON1_INSERT",DB_PROC,arrParams,Nothing)
	OUTPUT_VALUE = arrParams(UBound(arrParams))(4)

	Select Case OUTPUT_VALUE
		Case "ERROR" : Call ALERTS(DBERROR,"BACK","")
		Case "FINISH" : Call ALERTS(DBFINISH,"GO","1on1_list.asp")
		Case Else : Call ALERTS(DBUNDEFINED,"back","")
	End Select


%>
<!--#include virtual = "/_include/copyright.asp"-->
