<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<!--#include virtual = "/admin/_inc/document.asp"-->
<%
	ADMIN_LEFT_MODE = "DELIVERY"
	INFO_MODE = "MANAGE3-3"


	MODE		= pRequestTF("MODE",True)

	intIDX		= pRequestTF("intIDX",True)
	PAGE		= pRequestTF("PAGE",False)
	SEARCHTERM	= pRequestTF("SEARCHTERM",False)
	SEARCHSTR	= pRequestTF("SEARCHSTR",False)
	replyTF		= pRequestTF("replyTF",False)


	isReply		= pRequestTF("isReply",False)


	adminComment	= pRequestTF("adminComment",False)





%>
</head>
<body>
<!--#include virtual = "/admin/_inc/header.asp"-->
<%
	Select Case MODE
		Case "MODIFY"
			arrParams = Array(_
				Db.makeParam("@intIDX",adInteger,adParamInput,0,intIDX), _
				Db.makeParam("@isReply",adChar,adParamInput,1,isReply), _
				Db.makeParam("@adminComment",adVarWChar,adParamInput,MAX_LENGTH,adminComment), _
				Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
			)
			Call Db.exec("DKPA_COUNSEL2_MODIFY ",DB_PROC,arrParams,Nothing)
			OUTPUT_VALUE = arrParams(UBound(arrParams))(4)
			DB_FINISH_URL = "counsel2_view.asp"
		Case "DELETE"
			arrParams = Array(_
				Db.makeParam("@intIDX",adInteger,adParamInput,0,intIDX), _
				Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
			)
			Call Db.exec("DKPA_COUNSEL2_DELETE",DB_PROC,arrParams,Nothing)
			OUTPUT_VALUE = arrParams(UBound(arrParams))(4)
			DB_FINISH_URL = "counsel2_list.asp"
		Case Else Call ALERTS("처리할 수 없는 처리요청값이 요청되었습니다.","BACK","")
	End Select


%>
<%
	Select Case OUTPUT_VALUE
		Case "FINISH"
%>
	<form name="frm" method="post" action="<%=DB_FINISH_URL%>">
		<input type="hidden" name="PAGE" value="<%=PAGE%>" />
		<input type="hidden" name="SEARCHTERM" value="<%=SEARCHTERM%>" />
		<input type="hidden" name="SEARCHSTR" value="<%=SEARCHSTR%>" />
		<input type="hidden" name="replyTF" value="<%=replyTF%>" />
		<input type="hidden" name="intIDX" value="<%=intIDX%>" />
	</form>
	<script type="text/javascript">
		<!--
			alert("처리되었습니다.");
			document.frm.submit();
		//-->
	</script>
<%
		Case "ERROR"
			Call ALERTS(DBERROR,"BACK","")
		Case Else
			Call ALERTS(DBUNDEFINED,"BACK","")
	End Select
%>
<!--#include virtual = "/admin/_inc/copyright.asp"-->
