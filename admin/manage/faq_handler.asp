<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<!--#include virtual = "/admin/_inc/document.asp"-->
<%
	ADMIN_LEFT_MODE = "MANAGE"
	INFO_MODE = "MANAGE1-1"

	strNationCode	= pRequestTF("strNationCode",True)
	strGroup		= pRequestTF("strGroup",True)
	intCate			= pRequestTF("intCate",False)


	Dim PAGE			:	PAGE = Request("PAGE")
	Dim SEARCHTERM		:	SEARCHTERM = Request("SEARCHTERM")
	Dim SEARCHSTR		:	SEARCHSTR = Request("SEARCHSTR")

	If PAGESIZE = "" Then PAGESIZE = 10
	If PAGE = "" Then PAGE = 1


	If SEARCHTERM = "" Or SEARCHSTR = "" Then
		SEARCHTERM = ""
		SEARCHSTR = ""
	End If

	SC_QUERY = ""
	SC_QUERY = SC_QUERY & "PAGE="&PAGE
	SC_QUERY = SC_QUERY & "&sc_Group="&strGroup
	SC_QUERY = SC_QUERY & "&SEARCHTERM="&server.urlencode(SEARCHTERM)
	SC_QUERY = SC_QUERY & "&SEARCHSTR="&server.urlencode(SEARCHSTR)
	SC_QUERY = SC_QUERY & "&Cate="&intCate



%>
</head>
<body>
<%

	MODE		= pRequestTF("MODE",True)

	Select Case MODE
		Case "REGIST"
			strGroup	= pRequestTF("strGroup",True)
			strSubject	= pRequestTF("strSubject",True)
			strContent	= pRequestTF("strContent",True)
			isView		= pRequestTF("isView",True)

			'base64 문자형 이미지 체크
			If checkDataImages(strContent) Then Call ALERTS("문자형이미지(드래그 이미지)는 사용할 수 없습니다.","back","")

			arrParams = Array(_
				Db.makeParam("@intCate",adInteger,adParamInput,0,intCate), _
				Db.makeParam("@strSubject",adVarWChar,adParamInput,100,strSubject), _
				Db.makeParam("@strContent",adVarWChar,adParamInput,MAX_LENGTH,strContent), _
				Db.makeParam("@strNationCode",adVarChar,adParamInput,10,UCase(strNationCode)), _
				Db.makeParam("@strNation",adVarChar,adParamInput,20,strGroup), _
				Db.makeParam("@isView",adChar,adParamInput,1,isView), _
				Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
			)
			Call Db.exec("[DKSP_FAQ_REGIST_ADMIN]",DB_PROC,arrParams,Nothing)
			OUTPUT_VALUE = arrParams(Ubound(arrParams))(4)
			SC_QUERY = SC_QUERY & "&Cate="&intCate
			GO_URL = "faq_regist.asp?"&SC_QUERY

		Case "MODIFY"
			intIDX		= pRequestTF("intIDX",True)
			strSubject	= pRequestTF("strSubject",True)
			strContent	= pRequestTF("strContent",True)
			isView		= pRequestTF("isView",True)
			strGroup	= pRequestTF("strGroup",True)

			'base64 문자형 이미지 체크
			If checkDataImages(strContent) Then Call ALERTS("문자형이미지(드래그 이미지)는 사용할 수 없습니다.","back","")

			arrParams = Array(_
				Db.makeParam("@intIDX",adInteger,adParamInput,0,intIDX), _
				Db.makeParam("@intCate",adInteger,adParamInput,0,intCate), _
				Db.makeParam("@strSubject",adVarWChar,adParamInput,100,strSubject), _
				Db.makeParam("@strContent",adVarWChar,adParamInput,MAX_LENGTH,strContent), _
				Db.makeParam("@isView",adChar,adParamInput,1,isView), _
				Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
			)
			Call Db.exec("[DKSP_FAQ_MODIFY_ADMIN]",DB_PROC,arrParams,Nothing)
			OUTPUT_VALUE = arrParams(Ubound(arrParams))(4)
			GO_URL = "faq_list.asp?"&SC_QUERY
		Case "DELETE"
			intIDX		= pRequestTF("intIDX",True)

			arrParams = Array(_
				Db.makeParam("@intIDX",adInteger,adParamInput,0,intIDX), _
				Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
			)
			Call Db.exec("[DKSP_FAQ_DELETE_ADMIN]",DB_PROC,arrParams,Nothing)
			OUTPUT_VALUE = arrParams(Ubound(arrParams))(4)
			GO_URL = "faq_list.asp?"&SC_QUERY
		Case Else
	End Select
	Select Case OUTPUT_VALUE
		Case "FINISH" : Call ALERTS(DBFINISH,"GO",GO_URL)
		'Case "FINISH" : Call ALERTS(DBFINISH,"GO","faq_regist.asp?sc_Group="&strGroup)
		Case "ERROR" : Call ALERTS(DBERROR,"BACK","")
		Case Else : Call ALERTS(DBUNDEFINED,"BACK","")
	End Select








%>
<!--#include virtual = "/admin/_inc/header.asp"-->
<!--#include virtual = "/admin/_inc/copyright.asp"-->
