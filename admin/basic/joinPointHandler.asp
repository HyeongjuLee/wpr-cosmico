<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<!--#include virtual = "/admin/_inc/document.asp"-->
</head>
<body>
<%


	joinPoint		= pRequestTF("joinPoint",True)
	joinPointVM		= pRequestTF("joinPointVM",True)
	joinPointVV		= pRequestTF("joinPointVV",True)


	If Not IsNumeric(joinPoint) Then joinPoint = 0
	If Not IsNumeric(joinPointVM) Then joinPointVM = 0
	If Not IsNumeric(joinPointVV) Then joinPointVV = 0


	arrParams = Array(_
		Db.makeParam("@joinPoint",adInteger,adParamInput,0,joinPoint), _
		Db.makeParam("@joinPointVM",adInteger,adParamInput,0,joinPointVM), _
		Db.makeParam("@joinPointVV",adInteger,adParamInput,0,joinPointVV), _
		Db.makeParam("@strSiteID",adVarChar,adParamInput,50,"www"),_
		Db.makeParam("@OUPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
	)

	Call Db.exec("DKP_ADMIN_JOINPOINT_UPDATE",DB_PROC,arrParams,Nothing)
	OUTPUT_VALUE = arrParams(UBound(arrParams))(4)



	Select Case OUTPUT_VALUE
		Case "ERROR" : Call ALERTS(DBERROR,"back","")
		Case "FINISH" : Call ALERTS(DBFINISH,"go","joinPoint.asp")
	End Select


%>
