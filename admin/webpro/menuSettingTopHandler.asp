<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<!--#include virtual = "/admin/_inc/document.asp"-->
<%
'한깨방


	intMainMenuGap			= pRequestTF("intMainMenuGap",True)
	intSubMenuGap			= pRequestTF("intSubMenuGap",True)
	intSubBgAdd				= pRequestTF("intSubBgAdd",True)
	intSubMenuSpeed			= pRequestTF("intSubMenuSpeed",True)
	intMainMenuStart		= pRequestTF("intMainMenuStart",True)



	arrParams = Array(_
		Db.makeParam("@intMainMenuGap",adInteger,adParamInput,0,intMainMenuGap), _
		Db.makeParam("@intSubMenuGap",adInteger,adParamInput,0,intSubMenuGap), _
		Db.makeParam("@intSubBgAdd",adInteger,adParamInput,0,intSubBgAdd), _
		Db.makeParam("@intSubMenuSpeed",adInteger,adParamInput,0,intSubMenuSpeed), _
		Db.makeParam("@intMainMenuStart",adInteger,adParamInput,0,intMainMenuStart), _
		Db.makeParam("@hostIP",adVarChar,adParamInput,50,getUserIP), _
		Db.makeParam("@modifyID",adVarChar,adParamInput,50,DK_MEMBER_ID), _
		Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
	)
	Call Db.exec("DKPA_CATEGORY_TOP_SETTING_INSERT",DB_PROC,arrParams,Nothing)


	OUTPUT_VALUE = arrParams(UBound(arrParams))(4)
	Select Case OUTPUT_VALUE
		Case "ERROR" : Call ALERTS(DBERROR,"back","")
		Case "FINISH" : Call ALERTS(DBFINISH,"go","menuSettingTop.asp")
		Case Else : Call ALERTS(DBUNDEFINED,"back","")
	End Select



%>
</head>
<body>
</body>
</html>




