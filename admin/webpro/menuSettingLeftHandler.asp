<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<!--#include virtual = "/admin/_inc/document.asp"-->
<%
'한깨방


	intMenuGap				= pRequestTF("intMenuGap",True)
	intMenuWidth			= pRequestTF("intMenuWidth",True)
	intMenuHeight			= pRequestTF("intMenuHeight",True)
	intMenuX				= pRequestTF("intMenuX",True)
	intMenuY				= pRequestTF("intMenuY",True)
	intBgStart				= pRequestTF("intBgStart",True)



	arrParams = Array(_
		Db.makeParam("@intMenuGap",adInteger,adParamInput,0,intMenuGap), _
		Db.makeParam("@intMenuWidth",adInteger,adParamInput,0,intMenuWidth), _
		Db.makeParam("@intMenuHeight",adInteger,adParamInput,0,intMenuHeight), _
		Db.makeParam("@intMenuX",adInteger,adParamInput,0,intMenuX), _
		Db.makeParam("@intMenuY",adInteger,adParamInput,0,intMenuY), _
		Db.makeParam("@intBgStart",adInteger,adParamInput,0,intBgStart), _

		Db.makeParam("@hostIP",adVarChar,adParamInput,50,getUserIP), _
		Db.makeParam("@modifyID",adVarChar,adParamInput,50,DK_MEMBER_ID), _
		Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
	)
	Call Db.exec("DKPA_CATEGORY_LEFT_SETTING_INSERT",DB_PROC,arrParams,Nothing)


	OUTPUT_VALUE = arrParams(UBound(arrParams))(4)
	Select Case OUTPUT_VALUE
		Case "ERROR" : Call ALERTS(DBERROR,"back","")
		Case "FINISH" : Call ALERTS(DBFINISH,"go","menuSettingLeft.asp")
		Case Else : Call ALERTS(DBUNDEFINED,"back","")
	End Select



%>
</head>
<body>
</body>
</html>




