<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<!--#include virtual = "/admin/_inc/document.asp"-->
</head>
<body>
<%

	policyType = pRequestTF("type",True)
	policyContent = pRequestTF("content1",True)
	strNationCode = pRequestTF("strNationCode",True)

'	referURL = pRequestTF("goURL",True)

	hostIP = getUserIP


'	Call ResRW(policyType,"policyType")
'	Call ResRW(policyContent,"policyContent")
'	Call ResRW(hostIP,"hostIP")

	arrParams = Array(_
		Db.makeParam("@policyType",adChar,adParamInput,20,policyType),_
		Db.makeParam("@policyContent",adVarWChar,adParamInput,MAX_LENGTH,policyContent),_
		Db.makeParam("@regID",adVarChar,adParamInput,30,DK_MEMBER_ID),_
		Db.makeParam("@hostIP",adVarChar,adParamInput,30,hostIP),_
		Db.makeParam("@strNation",adVarChar,adParamInput,10,UCase(strNationCode)), _
		Db.makeParam("@OUPUT_VALUE",adVarChar,adParamOutput,10,"ERROR")_
	)

	Call Db.exec("DKPA_POLICY_INSERT",DB_PROC,arrParams,Nothing)
	OUTPUT_VALUE = arrParams(UBound(arrParams))(4)


	Select Case OUTPUT_VALUE
		Case "ERROR" : Call ALERTS(DBERROR,"back","")
		'Case "FINISH" : Call ALERTS(DBFINISH,"go","policy.asp?type="&policyType)
		Case "FINISH" : Call ALERTS(DBFINISH,"go","policy.asp?type="&policyType&"&nc="&strNationCode)
	End Select





%>
