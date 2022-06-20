<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<!--#include virtual = "/admin/_inc/document.asp"-->
<%
	ADMIN_LEFT_MODE = "DELIVERY"
	INFO_MODE = "MANAGE3-1"


	MODE		= pRequestTF("MODE",True)


	intIDX		= pRequestTF("intIDX",False)
	isUse		= pRequestTF("isUse",False)
	strTag		= pRequestTF("strTag",False)






%>
</head>
<body>
<!--#include virtual = "/admin/_inc/header.asp"-->
<%
	Select Case MODE
		Case "REGIST"
			arrParams = Array(_
				Db.makeParam("isUse",adChar,adParamInput,1,"T"), _
				Db.makeParam("strTag",adVarWChar,adParamInput,50,strTag), _
				Db.makeParam("strLink",adVarWChar,adParamInput,250,""), _
				Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
			)
			Call Db.exec("DKPA_CLOUDTAG_REGIST",DB_PROC,arrParams,Nothing)
			OUTPUT_VALUE = arrParams(UBound(arrParams))(4)
			DB_FINISH_URL = "cloudTag.asp"

		Case "DELETE"
			arrParams = Array(_
				Db.makeParam("@intIDX",adInteger,adParamInput,0,intIDX), _
				Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
			)
			Call Db.exec("DKPA_CLOUDTAG_DELETE",DB_PROC,arrParams,Nothing)
			OUTPUT_VALUE = arrParams(UBound(arrParams))(4)
			DB_FINISH_URL = "cloudTag.asp"
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
