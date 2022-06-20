<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<!--#include virtual = "/admin/_inc/document.asp"-->
</head>
<body>
<%

	Dim iMode,strDtoDName,strDtoDTel,strDtoDURL,strDtoDTrace,useTF
	iMode = pRequestTF("iMode",True)
	strDtoDName = pRequestTF("strDtoDName",False)
	strDtoDTel = pRequestTF("strDtoDTel",False)
	strDtoDURL = pRequestTF("strDtoDURL",False)
	strDtoDTrace = pRequestTF("strDtoDTrace",False)
	useTF = pRequestTF("useTF",False)
	intIDX = pRequestTF("intIDX",False)
	SORT_TYPE = pRequestTF("SORT_TYPE",False)





	If useTF = "" Then useTF = "F"

	arrParams = Array(_
		Db.makeParam("@strDtoDName",adVarChar,adParamInput,20,strDtoDName), _
		Db.makeParam("@strDtoDTel",adVarChar,adParamInput,20,strDtoDTel), _
		Db.makeParam("@strDtoDURL",adVarChar,adParamInput,150,strDtoDURL), _
		Db.makeParam("@strDtoDTrace",adVarChar,adParamInput,160,strDtoDTrace), _
		Db.makeParam("@useTF",adChar,adParamInput,1,useTF), _
		Db.makeParam("@intIDX",adInteger,adParamInput,0,intIDX), _
		Db.makeParam("@SORT_TYPE",adChar,adParamInput,2,SORT_TYPE), _
		Db.makeParam("@DtoD_Type",adChar,adParamInput,1,iMode) _

	)

	Call Db.beginTrans(Nothing)
	Call Db.exec("DKP_DTOD",DB_PROC,arrParams,Nothing)
	Call Db.finishTrans(Nothing)

	If Err.Number <> 0 Then
		Call alerts("카테고리 수정에 문제가 발생했습니다.","back","")
	Else
		Call ALERTS("정상적으로 저장되었습니다.","go","dtod.asp")
	End If


%>
</body>
</html>
