<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<!--#include virtual = "/admin/_inc/document.asp"-->
</head>
<body>
<%

	Dim iMode,strDtoDName,strDtoDTel,strDtoDURL,strDtoDTrace,useTF
	iMode = pRequestTF("iMode",True)
	bankName = pRequestTF("bankName",False)
	bankNumber = pRequestTF("bankNumber",False)
	bankOwner = pRequestTF("bankOwner",False)
	intIDX = pRequestTF("intIDX",False)





	If useTF = "" Then useTF = "F"



	arrParams = Array(_
		Db.makeParam("@bankName",adVarWChar,adParamInput,50,bankName), _
		Db.makeParam("@bankNumber",adVarWChar,adParamInput,50,bankNumber), _
		Db.makeParam("@bankOwner",adVarWChar,adParamInput,50,bankOwner), _
		Db.makeParam("@intIDX",adInteger,adParamInput,0,intIDX), _
		Db.makeParam("@DtoD_Type",adChar,adParamInput,1,iMode) _

	)

	Call Db.beginTrans(Nothing)
	Call Db.exec("DKP_BANK",DB_PROC,arrParams,Nothing)
	Call Db.finishTrans(Nothing)

	If Err.Number <> 0 Then
		Call alerts("카테고리 수정에 문제가 발생했습니다.","back","")
	Else
		Call ALERTS("정상적으로 저장되었습니다.","go","bank.asp")
	End If


%>
</body>
</html>
