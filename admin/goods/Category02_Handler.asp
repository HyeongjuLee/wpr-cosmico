<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<!--#include virtual = "/admin/_inc/document.asp"-->
<%
	ADMIN_LEFT_MODE = "GOODS"
	INFO_MODE = "GOODS6-2"
%>
</head>
<body>
<%

	MODE		= pRequestTF("MODE",True)


	Select Case MODE
		Case "REGIST"
			strNationCode	= pRequestTF("strNationCode",True)
			strCateName		= pRequestTF("strCateName",True)

			arrParams = Array(_
				Db.makeParam("@strNationCode",adVarChar,adParamInput,6,UCase(strNationCode)), _
				Db.makeParam("@strCateName",adVarWChar,adParamInput,20,strCateName),_
				Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
			)
			Call Db.exec("HWPA_SHOP_CATEGORY02_REGIST",DB_PROC,arrParams,Nothing)
			OUTPUT_VALUE = arrParams(Ubound(arrParams))(4)

		Case "MODIFY"
			intIDX		= pRequestTF("intIDX",True)
			strCateName	= pRequestTF("values",True)
			strNationCode	= pRequestTF("strNationCode",True)

			arrParams = Array(_
				Db.makeParam("@intIDX",adInteger,adParamInput,0,intIDX), _
				Db.makeParam("@strCateName",adVarWChar,adParamInput,20,strCateName), _
				Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
			)
			Call Db.exec("HWPA_SHOP_CATEGORY02_MODIFY",DB_PROC,arrParams,Nothing)
			OUTPUT_VALUE = arrParams(Ubound(arrParams))(4)


		Case "USE"
			intIDX	= pRequestTF("intIDX",True)
			isUse	= pRequestTF("values",True)
			strNationCode	= pRequestTF("strNationCode",True)

			arrParams = Array(_
				Db.makeParam("@intIDX",adInteger,adParamInput,4,intIDX), _
				Db.makeParam("@isUse",adChar,adParamInput,1,isUse), _
				Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
			)
			Call Db.exec("HWPA_SHOP_CATEGORY02_USECHG",DB_PROC,arrParams,Nothing)
			OUTPUT_VALUE = arrParams(Ubound(arrParams))(4)


		Case "DELETE"
			intIDX	= pRequestTF("intIDX",True)
			isDel	= pRequestTF("values",True)
			strNationCode	= pRequestTF("strNationCode",True)

			arrParams = Array(_
				Db.makeParam("@intIDX",adInteger,adParamInput,0,intIDX), _
				Db.makeParam("@isUse",adChar,adParamInput,1,isDel), _
				Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
			)
			Call Db.exec("HWPA_SHOP_CATEGORY02_DELETE",DB_PROC,arrParams,Nothing)
			OUTPUT_VALUE = arrParams(Ubound(arrParams))(4)

		Case Else
	End Select
	Select Case OUTPUT_VALUE
		Case "FINISH" : Call ALERTS(DBFINISH,"GO","Category02.asp?nc="&strNationCode)
		Case "ERROR" : Call ALERTS(DBERROR,"BACK","")
		Case Else : Call ALERTS(DBUNDEFINED,"BACK","")
	End Select








%>
<!--#include virtual = "/admin/_inc/header.asp"-->
<!--#include virtual = "/admin/_inc/copyright.asp"-->
