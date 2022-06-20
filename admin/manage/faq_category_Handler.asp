<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<!--#include virtual = "/admin/_inc/document.asp"-->
<%
	ADMIN_LEFT_MODE = "MANAGE"
	INFO_MODE = "MANAGE1-1"


%>
</head>
<body>
<%

	MODE			= pRequestTF("MODE",True)
	strNationCode	= pRequestTF("strNationCode",True)
	strGroup	= pRequestTF("strGroup",True)

	Select Case MODE
		Case "REGIST"
			strTitle	= pRequestTF("strTitle",True)
			arrParams = Array(_
				Db.makeParam("@strTitle",adVarWChar,adParamInput,50,strTitle), _
				Db.makeParam("@strNation",adVarChar,adParamInput,10,UCase(strNationCode)), _
				Db.makeParam("@strGroup",adVarChar,adParamInput,20,strGroup), _
				Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
			)
			Call Db.exec("[DKSP_FAQ_CATEGORY_INSERT_ADMIN]",DB_PROC,arrParams,Nothing)
			OUTPUT_VALUE = arrParams(Ubound(arrParams))(4)
		Case "MODIFY"
			intIDX		= pRequestTF("intIDX",True)
			values		= pRequestTF("values",True)
			arrParams = Array(_
				Db.makeParam("@intIDX",adInteger,adParamInput,0,intIDX), _
				Db.makeParam("@strTitle",adVarWChar,adParamInput,50,values), _
				Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
			)
			Call Db.exec("[DKSP_FAQ_CATEGORY_MODIFY_ADMIN]",DB_PROC,arrParams,Nothing)
			OUTPUT_VALUE = arrParams(Ubound(arrParams))(4)
		Case "VIEWCHG"
			intIDX		= pRequestTF("intIDX",True)
			values		= pRequestTF("values",True)
			Select Case values
				Case "T" : isView = "F"
				Case "F" : isView = "T"
				Case Else : Call ALERTS("변경값이 올바르지 않습니다.","BACK","")
			End Select
			arrParams = Array(_
				Db.makeParam("@intIDX",adInteger,adParamInput,0,intIDX), _
				Db.makeParam("@isView",adChar,adParamInput,1,isView), _
				Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
			)
			Call Db.exec("[DKSP_FAQ_CATEGORY_VIEW_CHANGE_ADMIN]",DB_PROC,arrParams,Nothing)
			OUTPUT_VALUE = arrParams(Ubound(arrParams))(4)
		Case "SORTUP"
			intIDX		= pRequestTF("intIDX",True)

			arrParams = Array(_
				Db.makeParam("@intIDX",adInteger,adParamInput,0,intIDX), _
				Db.makeParam("@strNation",adVarChar,adParamInput,10,UCase(strNationCode)), _
				Db.makeParam("@strGroup",adVarChar,adParamInput,20,strGroup), _
				Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
			)
			Call Db.exec("[DKSP_FAQ_CATEGORY_SORTUP_ADMIN]",DB_PROC,arrParams,Nothing)
			OUTPUT_VALUE = arrParams(Ubound(arrParams))(4)
		Case "SORTDOWN"
			intIDX		= pRequestTF("intIDX",True)

			arrParams = Array(_
				Db.makeParam("@intIDX",adInteger,adParamInput,0,intIDX), _
				Db.makeParam("@strNation",adVarChar,adParamInput,10,UCase(strNationCode)), _
				Db.makeParam("@strGroup",adVarChar,adParamInput,20,strGroup), _
				Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
			)
			Call Db.exec("[DKSP_FAQ_CATEGORY_SORTDOWN_ADMIN]",DB_PROC,arrParams,Nothing)
			OUTPUT_VALUE = arrParams(Ubound(arrParams))(4)
		Case "DELETE"
			intIDX		= pRequestTF("intIDX",True)

			arrParams = Array(_
				Db.makeParam("@intIDX",adInteger,adParamInput,0,intIDX), _
				Db.makeParam("@strNation",adVarChar,adParamInput,10,UCase(strNationCode)), _
				Db.makeParam("@strGroup",adVarChar,adParamInput,20,strGroup), _
				Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
			)
			Call Db.exec("DKSP_FAQ_CATEGORY_DELETE_ADMIN",DB_PROC,arrParams,Nothing)
			OUTPUT_VALUE = arrParams(Ubound(arrParams))(4)
		Case Else
	End Select
	Select Case OUTPUT_VALUE
		'Case "FINISH" : Call ALERTS(DBFINISH,"GO","faq_category.asp")
		Case "FINISH" : Call ALERTS(DBFINISH,"GO","faq_category.asp?sc_group="&strGroup)
		Case "ERROR" : Call ALERTS(DBERROR,"BACK","")
		Case "NOTUP" : Call ALERTS("더이상 올릴 수 없습니다.","BACK","")
		Case "NOTDOWN" : Call ALERTS("더이상 내릴 수 없습니다.","BACK","")
		Case Else : Call ALERTS(DBUNDEFINED,"BACK","")
	End Select








%>
<!--#include virtual = "/admin/_inc/header.asp"-->
<!--#include virtual = "/admin/_inc/copyright.asp"-->
