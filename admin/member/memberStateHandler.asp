<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<!--#include virtual = "/admin/_inc/document.asp"-->
</head>
<body>
<%
	strUserID = pRequestTF("strUserID",True)
	state = pRequestTF("state",True)




	arrParams = Array(_
		Db.makeParam("@strUserID",adVarChar,adParamInput,20,strUserID),_
		Db.makeParam("@STATE",adVarChar,adParamInput,10,state),_
		Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR")_
	)
	Call Db.exec("DKPA_MEMBER_STATE_HANDLER",DB_PROC,arrParams,Nothing)
	OUTPUT_VALUE = arrParams(UBound(arrParams))(4)


	Select Case OUTPUT_VALUE
		Case "ERROR" : Call alerts("변경에 오류가 발생하였습니다.관리자에게 문의해주세요","back","")

		Case "FINISH" : Call alerts("변경되었습니다.","go","member_list1.asp")
	End Select






%>
</body>
</html>
