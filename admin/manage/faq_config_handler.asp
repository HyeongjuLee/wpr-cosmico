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

	Select Case MODE
		Case "REGIST"
			strGroup		= pRequestTF("strGroup",True)
			strCateCode		= pRequestTF("strCateCode",True)
			isUse			= pRequestTF("isUse",True)
			mainVar			= pRequestTF("mainVar",False)
			subVar			= pRequestTF("subVar",False)
			sViewVar		= pRequestTF("sViewVar",False)
			intViewLevel	= pRequestTF("intViewLevel",False)
			arrParams = Array(_
				Db.makeParam("@strNationCode",adVarChar,adParamInput,10,strNationCode), _
				Db.makeParam("@strGroup",adVarChar,adParamInput,20,strGroup), _
				Db.makeParam("@strCateCode",adVarChar,adParamInput,20,strCateCode), _
				Db.makeParam("@isUse",adChar,adParamInput,1,isUse), _
				Db.makeParam("@mainVar",adInteger,adParamInput,4,mainVar), _
				Db.makeParam("@SubVar",adInteger,adParamInput,4,SubVar), _
				Db.makeParam("@sViewVar",adInteger,adParamInput,4,sViewVar), _
				Db.makeParam("@intViewLevel",adInteger,adParamInput,4,intViewLevel), _
				Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
			)
			Call Db.exec("[DKSP_FAQ_CONFIG_INSERT_ADMIN]",DB_PROC,arrParams,Nothing)
			OUTPUT_VALUE = arrParams(Ubound(arrParams))(4)
		Case "MODIFY"
			intIDX			= pRequestTF("intIDX",True)
			strGroup		= pRequestTF("strGroup",True)
			strCateCode		= pRequestTF("strCateCode",True)
			isUse			= pRequestTF("isUse",True)
			mainVar			= pRequestTF("mainVar",False)
			subVar			= pRequestTF("subVar",False)
			sViewVar		= pRequestTF("sViewVar",False)
			ORI_strGroup	= pRequestTF("ORI_strGroup",True)
			intViewLevel	= pRequestTF("intViewLevel",False)

			arrParams = Array(_
				Db.makeParam("@intIDX",adInteger,adParamInput,0,intIDX), _
				Db.makeParam("@strNationCode",adVarChar,adParamInput,10,strNationCode), _
				Db.makeParam("@strGroup",adVarChar,adParamInput,20,strGroup), _
				Db.makeParam("@strCateCode",adVarChar,adParamInput,20,strCateCode), _
				Db.makeParam("@isUse",adChar,adParamInput,1,isUse), _
				Db.makeParam("@mainVar",adInteger,adParamInput,4,mainVar), _
				Db.makeParam("@SubVar",adInteger,adParamInput,4,SubVar), _
				Db.makeParam("@sViewVar",adInteger,adParamInput,4,sViewVar), _
				Db.makeParam("@ORI_strGroup",adVarChar,adParamInput,20,ORI_strGroup), _
				Db.makeParam("@intViewLevel",adInteger,adParamInput,4,intViewLevel), _

				Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
			)
			Call Db.exec("[DKSP_FAQ_CONFIG_MODIFY_ADMIN]",DB_PROC,arrParams,Nothing)
			OUTPUT_VALUE = arrParams(Ubound(arrParams))(4)
			'Call ALERTS(OUTPUT_VALUE,"BACK","")
		Case "DELETE"
			intIDX		= pRequestTF("intIDX",True)
			strGroup	= pRequestTF("strGroup",True)

			arrParams = Array(_
				Db.makeParam("@intIDX",adInteger,adParamInput,0,intIDX), _
				Db.makeParam("@strNationCode",adVarChar,adParamInput,10,strNationCode), _
				Db.makeParam("@strGroup",adVarChar,adParamInput,20,strGroup), _
				Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
			)
			Call Db.exec("DKSP_FAQ_CONFIG_DELETE_ADMIN",DB_PROC,arrParams,Nothing)
			OUTPUT_VALUE = arrParams(Ubound(arrParams))(4)
		Case Else
	End Select

	Select Case OUTPUT_VALUE
		'Case "FINISH" : Call ALERTS(DBFINISH,"GO","faq_category.asp")
		Case "FINISH" : Call ALERTS(DBFINISH,"GO","faq_config.asp")
		Case "ERROR" : Call ALERTS(DBERROR,"BACK","")
		Case Else : Call ALERTS(DBUNDEFINED,"BACK","")
	End Select








%>
<!--#include virtual = "/admin/_inc/header.asp"-->
<!--#include virtual = "/admin/_inc/copyright.asp"-->
