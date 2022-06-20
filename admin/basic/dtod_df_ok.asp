<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<!--#include virtual = "/admin/_inc/document.asp"-->
</head>
<body>
<%

	intIDX = pRequestTF("intIDX",True)

	If useTF = "" Then useTF = "F"

	arrParams = Array(_
		Db.makeParam("@intIDX",adInteger,adParamInput,0,intIDX) _
	)

	Call Db.beginTrans(Nothing)
	Call Db.exec("DKP_DTOD_DF",DB_PROC,arrParams,Nothing)
	Call Db.finishTrans(Nothing)

	If Err.Number <> 0 Then
		Call alerts("카테고리 수정에 문제가 발생했습니다.","back","")
	Else
		Call ALERTS("정상적으로 저장되었습니다.","go","dtod.asp")
	End If


%>
</body>
</html>
