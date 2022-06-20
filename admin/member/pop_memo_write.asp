<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<!--#include virtual = "/admin/_inc/document.asp"-->
</head>
<body>
<%
	strUserID = pRequestTF("sui",True)
	strMemo = pRequestTF("strMemo",True)


	Call Db.BeginTrans(Nothing)
	SQL = "INSERT INTO [DK_MEMBER_ADMIN_MEMO]([strUserID],[strMemo],[regID]) VALUES (?,?,?)"
	arrParams = Array(_
		Db.makeParam("@strUserID",adVarChar,adParamInput,30,strUserID),_
		Db.makeParam("@strMemo",adVarChar,adParamInput,200,strMemo), _
		Db.makeParam("@regID",adVarChar,adParamInput,200,DK_MEMBER_ID) _
	)

	Call Db.exec(SQL,DB_TEXT,arrParams,Nothing)

	Call Db.finishTrans(Nothing)

	If Err.Number = 0 Then
		Call alerts("등록되었습니다.","go","pop_memo_list.asp?idv="&strUserID)
	Else
		Call alerts("등록에 오류가 발생하였습니다.관리자에게 문의해주세요","back","")
	End If






%>
</body>
</html>
