<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<!--#include virtual = "/admin/_inc/document.asp"-->
</head>
<body>
<%
	intIDX = gRequestTF("num",True)
	strUserID = gRequestTF("idv",True)


	Call Db.BeginTrans(Nothing)
	SQL = "UPDATE [DK_MEMBER_ADMIN_MEMO] SET [delFlagTF] = ?,[delID] = ?,[delDate] = ? WHERE [intIDX] = ?"
	arrParams = Array(_
		Db.makeParam("@delFlagTF",adChar,adParamInput,1,"T"),_
		Db.makeParam("@delID",adVarChar,adParamInput,200,DK_MEMBER_ID), _
		Db.makeParam("@delDate",adDbTimeStamp,adParamInput,16,Now), _
		Db.makeParam("@intIDX",adInteger,adParamInput,0,intIDX) _
	)

	Call Db.exec(SQL,DB_TEXT,arrParams,Nothing)

	Call Db.finishTrans(Nothing)

	If Err.Number = 0 Then
		Call alerts("삭제되었습니다.","go","pop_memo_list.asp?idv="&strUserID)
	Else
		Call alerts("삭제에 오류가 발생하였습니다.관리자에게 문의해주세요","back","")
	End If






%>
</body>
</html>
