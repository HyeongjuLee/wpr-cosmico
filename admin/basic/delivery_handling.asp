<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<!--#include virtual = "/admin/_inc/document.asp"-->
</head>
<body>
<%



	feeType = pRequestTF("feeType",True)
	intFee = pRequestTF("Fee",True)
	intLimit = pRequestTF("limit",True)


	arrParams = Array(_
		Db.makeParam("@SquenceType",adChar,adParamInput,1,"I"), _
		Db.makeParam("@feeType",adChar,adParamInput,4,feeType), _
		Db.makeParam("@intFee",adInteger,adParamInput,0,intFee), _
		Db.makeParam("@intLimit",adInteger,adParamInput,0,intLimit), _
		Db.makeParam("@regID",adVarChar,adParamInput,30,DK_MEMBER_ID), _
		Db.makeParam("@hostIP",adVarChar,adParamInput,30,getUserIP) _
	)

	Call Db.beginTrans(Nothing)
	Call Db.exec("DKP_DELIVERY",DB_PROC,arrParams,Nothing)
	Call Db.finishTrans(Nothing)

	If Err.Number <> 0 Then
		Call alerts("배송비 저장에 문제가 발생했습니다.","back","")
	Else
		Call ALERTS("정상적으로 저장되었습니다.","go","delivery.asp")
	End If



%>
