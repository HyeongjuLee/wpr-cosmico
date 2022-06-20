<!--#include virtual = "/_lib/strFunc.asp"-->
<!--#include virtual = "/_include/document.asp"-->
<%

	Call Only_Member(DK_MEMBER_LEVEL)


	intIDX = gRequestTF("idv",True)

	SQL = "SELECT * FROM [DK_ORDER] WHERE [intIDX]=?"
'	SQL = "SELECT * FROM [DK_ORDER2] WHERE [intIDX]=?"
	arrParams = Array(_
		Db.makeParam("@idx",adInteger,adParamInput,0,intIDX) _
	)
	Set RSCOM = Db.execRs(SQL,DB_TEXT,arrParams,Nothing)

	If Not RSCOM.BOF And Not RSCOM.EOF Then
		strUserID				= RSCOM("strUserID")
		OrderNum				= RSCOM("OrderNum")
		totalPrice				= RSCOM("totalPrice")
		totalDelivery			= RSCOM("totalDelivery")
		totalOptionPrice		= RSCOM("totalOptionPrice")
		payway					= RSCOM("payway")
		bankIDX					= RSCOM("bankIDX")
		bankingName				= RSCOM("bankingName")
		usePoint				= RSCOM("usePoint")
		strName					= RSCOM("strName")
		strTel					= RSCOM("strTel")
		strEmail				= RSCOM("strEmail")
		takeName				= RSCOM("takeName")
		takeTel					= RSCOM("takeTel")
		takeMob					= RSCOM("takeMob")
		takeZip					= RSCOM("takeZip")
		takeADDR1				= RSCOM("takeADDR1")
		takeADDR2				= RSCOM("takeADDR2")
		orderMemo				= RSCOM("orderMemo")
		state					= RSCOM("status")
		registDate				= RSCOM("status100Date")
	End If
	Call closeRS(RSCOM)
	If strUserID <> DK_MEMBER_ID Then Call alerts(LNG_SHOP_ORDER_FINISH_03,"back","")

	Select Case payway
		Case "inbank"
			SQL = "SELECT * FROM [DK_BANK] WHERE [intIDX] = ? "
			arrParams = Array(_
				Db.makeParam("@intIDX",adInteger,adParamInput,0,bankIDX) _
			)
			Set rs_payInfo = Db.execRs(SQL,DB_TEXT,arrParams,Nothing)

			payMethod = LNG_SHOP_ORDER_DIRECT_PAY_02	'"온라인입금"
			payInfo = "("&rs_payInfo(1) &") "& rs_payInfo(2) &" "&LNG_SHOP_ORDER_DIRECT_PAY_14&": " & bankingName
		Case "card"
			payMethod = LNG_SHOP_ORDER_DIRECT_PAY_01	'"카드결제"
			'payInfo = "카드로 결제된 주문입니다."
			payInfo = LNG_SHOP_ORDER_CANCEL_CARD_PAY
	End Select
%>
<script type="text/javascript">
<!--
	function chkQfrm(f) {
		if (f.intIDX.value=="")
		{
			alert("<%=LNG_SHOP_ORDER_CANCEL_JS01%>");
			f.intIDX.focus();
			return false;
		}


		if (f.CancelCause.value=="")
		{
			alert("<%=LNG_SHOP_ORDER_CANCEL_JS02%>");
			f.CancelCause.focus();
			return false;
		}
		if (confirm("<%=LNG_SHOP_ORDER_CANCEL_JS03%>")) {
		} else {
			return false;
		}
	}
//-->
</script>
<style type="text/css">
	div#pop_top {clear:both;width:100%; height:40px;background:url(/images/pop/popAll2_bg.gif) 0 0 repeat-x;}
	.input_text {height:16px; padding-top:2px;border:1px solid #ccc;}
	.input_area {border:1px solid #ccc; width:350px; height:200px;}
	div#pop_content {clear:both;}

	div#close {height:30px;text-align:right;margin-top:13px;}
	.line1 {height:1px; background-color:#dedede;}
	.line2 {height:2px; background-color:#f4f4f4;}

	.goods td {border:1px solid #ccc; padding:5px 0px; padding-left:10px;}
	.goods th {border:1px solid #ccc; padding:5px 0px; background-color:#eee;}

	.write td {border:1px solid #ccc; padding:5px 0px;}
	.write th {border:1px solid #ccc; padding:5px 0px;}
	.write td.pl10 {padding-left:10px;}
	.write th {background-color:#eee;}
	.write td label {float:left; display:block; margin-right:10px;}
	.input_check {margin:0px 0px 0px 0px;vertical-align:middle;}

	html {overflow:hidden}	/*크롬 스크롤바 생성 방지*/
	.bgtitle {
		width:100%;padding:10px 10px;margin:0px auto;
		background: #2070aa;
		background: -moz-linear-gradient(#5080af 20%, #2070aa 80%);
		background: -webkit-gradient(linear, left top, left bottom, color-stop(20%, #5080af), color-stop(80%, #2070aa));
		background: -webkit-linear-gradient(#5080af 20%, #2070aa 80%);
		background: linear-gradient(#5080af 20%, #2070aa 80%);
	}
	.bgtitle .bgFont{
		font-size:20px;color:#eee;font-family:malgun gothic;Arial,verdana;
	}
</style>
</head>
<body>
<!-- <div id="pop_top"><img src="<%=IMG_POP%>/tit_OrderCancel.gif" width="250" height="40" alt="" /></div> -->
<div class="bgtitle tweight">
	<span class="bgFont"><%=LNG_STRTEXT_TEXT24_6%></span>
</div>
<div id="pop_content">
	<form name="qfrm" action="popOrderCancelHandler.asp" method="post" onsubmit="return chkQfrm(this)">
		<input type="hidden" name="intIDX" value="<%=intIDX%>" />
		<table <%=tableatt%> style="width:600px;" class="goods">
			<col width="130" />
			<col width="470" />
			<tr>
				<th><%=LNG_SHOP_ORDER_FINISH_05%></th>
				<td class="tweight"><%=OrderNum%></td>
			</tr><tr>
				<th><%=LNG_SHOP_ORDER_ORDERDATE%></th>
				<td><%=registDate%></td>
			</tr><tr>
				<th><%=LNG_SHOP_ORDER_CANCEL_PAYSTATUS%></th>
				<td>[<%=payMethod%>] <%=payInfo%></td>
			</tr><tr>
				<th><%=LNG_SHOP_ORDER_ORDERSTATUS%></th>
				<td><%=CallState(state)%></td>
			</tr><tr>
				<th colspan="2"><%=LNG_SHOP_ORDER_CANCEL_REASON%></th>
			</tr><tr>
				<td colspan="2"><textarea name="CancelCause" cols="20" rows="10" class="input_area" style="width:580px; height:150px;"></textarea></td>
			</tr>
		</table>
		<p class="tcenter" style="margin-top:10px;"><input type="submit" class="txtBtnC medium radius5 blue" style="min-width:60px;" onclick="" value="<%=LNG_TEXT_CONFIRM%>"/></p>
		<!-- <p class="tcenter" style="margin-top:10px;"><input type="image" src="<%=IMG_POP%>/qna_pop_write.gif" /></p> -->
	</form>
</div>
<div id="close">
	<div class="line1"></div>
	<div class="line2"></div>
	<span class="button medium tweight" style="margin:10px 10px 0px 0px"><a onclick="self.close();"><%=LNG_TEXT_WINDOW_CLOSE%></a></span>
	<!-- <img src="<%=IMG_JOIN%>/btn_close01.gif" width="52" height="23" alt="창 닫기" style="margin-top:4px;cursor:pointer;" onclick="self.close();" /> -->
</div>


</body>
</html>
