<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<!--#include virtual = "/admin/_inc/document.asp"-->
<%
	ADMIN_LEFT_MODE = "ORDERS"
	INFO_MODE = "ORDERS1-1"



	DtoDCode		= pRequestTF("DtoDCode",True)
	DtoDNumber		= pRequestTF("DtoDNumber",False)
	DtoDDate		= pRequestTF("DtoDDate",True)
	intIDX			= pRequestTF("intIDX",True)
'	Call ResRW(intIDX,"intIDX")
'	Response.End


	If UCase(DtoDCode) = "DATE" Then DtoDCode = 0
	SQL = "UPDATE [DK_ORDER] SET [DtoDCode] = ?, [DtoDNumber] = ?, [DtoDDate] = ? WHERE [intIDX] = ?"

	arrParams = Array(_
		Db.makeParam("@DtoDCode",adInteger,adParamInput,0,DtoDCode), _
		Db.makeParam("@DtoDNumber",adVarChar,adParamInput,20,DtoDNumber), _
		Db.makeParam("@DtoDDate",adDBTimeStamp,adParamInput,16,DtoDDate), _
		Db.makeParam("@intIDX",adInteger,adParamInput,0,intIDX) _
	)
	Call Db.exec(SQL,DB_TEXT,arrParams,Nothing)

	If Err.Number = 0 Then
		Call ALERTS("저장되었습니다.","o_reloadA","")
	Else
		Call ALERTS("처리중 오류가 발생하였습니다. 새로고침 후 다시 시도해주세요","back","")
	End If


%>
</head>
<body>

<!--#include virtual = "/admin/_inc/header.asp"-->


<!--#include virtual = "/admin/_inc/copyright.asp"-->
