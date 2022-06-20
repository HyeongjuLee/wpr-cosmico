<!--#include virtual = "/_lib/strFunc.asp"-->
<!--#include virtual="/_include/document.asp" -->

<%
	'◆마이오피스 결제 튕겼을 때 (GO_BACK_ADDR) 주문페이지로 보내기
	Call ONLY_MEMBER(DK_MEMBER_LEVEL)

	gidx = Trim(gRequestTF("gidx",False))

	If gidx = "" Then Call ALERTS(LNG_ALERT_WRONG_ACCESS&"02","GO","/myoffice/buy/goodsList.asp")

	On Error Resume Next
	Set StrCipher = Server.CreateObject("Hoyasoft.StrCipher")
		gidx = Trim(StrCipher.Decrypt(gidx,EncTypeKey1,EncTypeKey2))
	Set StrCipher = Nothing
	On Error GoTo 0


	arrGidx = Split(CheckSpace(gidx),",")
	For i = 0 To UBound(arrGidx)
		If Not IsNumeric(arrGidx(i)) Then Call ALERTS(LNG_ALERT_WRONG_ACCESS&"03","GO","/myoffice/buy/goodsList.asp")
	Next

	'print gidx
	'Response.end

%>
</head>
<body onload="document.frm.submit();">
<div id="loadingPro" style="position:fixed; z-index:99999; width:100%; height:100%; top:0px; left:0px; background:url(/images_kr/loading_bg70.png) 0 0 repeat; ">
	<div style="position:relative; top:40%; text-align:center;">
		<img src="<%=IMG%>/159.gif" width="80" alt="" />
	</div>
</div>
<form name="frm" method="post" action="/myoffice/buy/order.asp">
	<input type="hidden" name="nCode" value="<%=gidx%>" />
</form>

