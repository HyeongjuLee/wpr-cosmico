<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<!--#include virtual = "/admin/_inc/document.asp"-->
</head>
<body>
<%
	strUserID = pRequestTF("sui",True)
	intPoint = pRequestTF("intPoint",True)
	pComment = pRequestTF("pComment",False)




	SQL1 = "INSERT INTO [DK_MEMBER_POINT_LOG]([strUserID],[intValue],[valueComment],[dComment]) VALUES (?,?,?,?)"
	SQL2 = "UPDATE [DK_MEMBER_FINANCIAL] SET [intPoint] = [intPoint] + ? WHERE [strUserID] = ?"
	VCOMMNET = "관리자"

	arrParams2 = Array(_
		Db.makeParam("@strMemo",adInteger,adParamInput,0,intPoint), _
		Db.makeParam("@strUserID",adVarChar,adParamInput,200,strUserID) _
	)

	arrParams1 = Array(_
		Db.makeParam("@strUserID",adVarChar,adParamInput,200,strUserID), _
		Db.makeParam("@valueP",adInteger,adParamInput,0,intPoint), _
		Db.makeParam("@valueComment",adVarChar,adParamInput,50,VCOMMNET), _
		Db.makeParam("@dComment",adVarChar,adParamInput,200,pComment) _
	)


	Call Db.BeginTrans(Nothing)
		Call Db.exec(SQL1,DB_TEXT,arrParams1,Nothing)
		Call Db.exec(SQL2,DB_TEXT,arrParams2,Nothing)

	Call Db.finishTrans(Nothing)

	If Err.Number = 0 Then
		Call alerts("등록되었습니다.","o_reloadA","")
	Else
		Call alerts("등록에 오류가 발생하였습니다.관리자에게 문의해주세요","back","")
	End If






%>
</body>
</html>
