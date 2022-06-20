<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<!--#include virtual = "/admin/_inc/document.asp"-->
<%
' ===================================================================
' 게시판 변수 받아오기(설정)
' ===================================================================
	Dim popWidth,popHeight
		popWidth = 400
		popHeight = 300

	Dim IDV
		IDV = gRequestTF("idv",True)

	arrParams = Array(_
		Db.makeParam("@intIDX",adInteger,adParamInput,0,IDV) _
	)
	Set DKRS = Db.execRs("DKPA_ORDERS_CANCEL",DB_PROC,arrParams,Nothing)
	If Not DKRS.BOF And Not DKRS.EOF Then
		RS_status				= DKRS("status")
		RS_status100Date		= DKRS("status100Date")
		RS_status101Date		= DKRS("status101Date")
		RS_status102Date		= DKRS("status102Date")
		RS_status103Date		= DKRS("status103Date")
		RS_status104Date		= DKRS("status104Date")
		RS_status201Date		= DKRS("status201Date")
		RS_status301Date		= DKRS("status301Date")
		RS_status302Date		= DKRS("status302Date")

	Else
		Call ALERTS("존재하지 않는 주문입니다.","close","")
	End If



%>

<link rel="stylesheet" href="/admin/css/orders.css" />
<script type="text/javascript" src="/admin/jscript/orders.js"></script>
<script type="text/javascript" src="/jscript/calendar.js"></script>
</head>
<body>
<div id="pop_all">
	<div id="orderCancel">
		<div class="top"><%=viewImg(IMG_POP&"/tit_popup_orderCancel.gif",250,40,"")%></div>
		<div class="content">
			<form name="frms" action="orderCancelHandler.asp" method="post">
			<input type="hidden" name="mode" value="CANCEL" />
			<input type="hidden" name="intIDX" value="<%=IDV%>" />
			<table <%=tableatt%> style="width:100%;">
				<colgroup>
					<col width="130" />
					<col width="*" />
				</colgroup>
				<tr>
					<th>취소사유</th>
					<td><textarea name="CancelCause" class="input_area" style="width:250px;height:120px;"></textarea></td>
				</tr><tr>
					<td colspan="2" class="submitzone"><input type="image" src="<%=IMG_BTN%>/btn_order_go_cancel.gif" /></td>
				</tr>
			</table>
			</form>
		</div>
		<div class="bottom">
			<div class="info"><%=viewImg(IMG_POP&"/pop_bottom_info.gif",160,60,"")%></div>
			<div class="btn_area"><%=aImgSt("javascript:self.close()",IMG_BTN&"/btn_close_01.gif",52,23,"","margin-top:20px;margin-right:20px;","")%></div>
		</div>
	</div>
</div>

<script type="text/javascript">
<!--
resizePopupWindow(parseInt("<%=popWidth%>", 10), parseInt("<%=popHeight%>", 10));
//-->
</script>


</body>
</html>
