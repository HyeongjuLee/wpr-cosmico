<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<!--#include virtual = "/admin/_inc/document.asp"-->
<%
	ADMIN_LEFT_MODE = "ORDERS"
	INFO_MODE = "ORDERS1-1"


	intIDX = Request.Form("intIDX")

'	Call ResRW(intIDX,"intIDX")
'	Response.End

	SQL = " UPDATE [DK_ORDER] SET [state] = '101', [isConfirm] = 'T', [ConfirmDate] = getdate() WHERE [intIDX] = ?"
	arrParams = Array(_
		Db.makeParam("@intIDX",adInteger,adParamInput,0,intIDX) _
	)
	Call Db.exec(SQL,DB_TEXT,arrParams,Nothing)
%>
<script type='text/javascript'>
<!--
	parent.location.reload();
//-->
</script>


</head>
<body>


<!--#include virtual = "/admin/_inc/header.asp"-->


<!--#include virtual = "/admin/_inc/copyright.asp"-->
