<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual = "/_include/document.asp"-->
<%
' ===================================================================
' 게시판 변수 받아오기(설정)
' ===================================================================
	Call FN_NationCurrency(DK_MEMBER_NATIONCODE,Chg_CurrencyName,Chg_CurrencyISO)

	Dim popWidth,popHeight
		popWidth = 380
		popHeight = 500
'	Call ONLY_MEMBER()
	'Call MEMBER_AUTH_CHECK(nowGradeCnt,3)
	Dim NCODE
		NCODE = Request.QueryString("code")

	mid1 = gRequestTF("mid1",True)
	mid2 = gRequestTF("mid2",True)


	If NCODE = "" Then Call ALERTS(LNG_CS_POPCART_ALERT01,"close","")

	'SQL = "SELECT * FROM [tbl_Goods] WHERE [ncode] = ? AND [GoodUse] = 0"
	SQL = "SELECT * FROM [tbl_Goods] WHERE [ncode] = ? AND [GoodUse] = 0 AND [Na_Code] = '"&UCase(Lang)&"' "
	arrParams = Array(_
		Db.makeParam("@ncode",adVarChar,adParamInput,20,NCODE) _
	)
	Set DKRS = Db.execRs(SQL,DB_TEXT,arrParams,DB3)
	If Not DKRS.BOF And Not DKRS.EOF Then
		RS_ncode					= DKRS("ncode")
		RS_name						= DKRS("name")
		RS_inspection				= DKRS("inspection")
		RS_price					= DKRS("price")
		RS_price2					= DKRS("price2")
		RS_price3					= DKRS("price3")
		RS_price4					= DKRS("price4")
		RS_price5					= DKRS("price5")
		RS_price6					= DKRS("price6")
		RS_Sell_VAT_Price			= DKRS("Sell_VAT_Price")
		RS_Except_Sell_VAT_Price	= DKRS("Except_Sell_VAT_Price")
		RS_Base_Cnt					= 1	'DKRS("Base_Cnt")
	Else
		Call ALERTS(LNG_CS_POPCART_ALERT01,"close","")
	End If
	Call closeRs(DKRS)

	arrParams = Array(_
		Db.makeParam("@ncode",adVarChar,adParamInput,20,RS_ncode) _
	)
	Set DKRS = Db.execRs("DKP_GOODS_CHANGE",DB_PROC,arrParams,DB3)
	If Not DKRS.BOF And Not DKRS.EOF Then
		RS_ncode					= DKRS("ncode")
		RS_price					= DKRS("price1")
		RS_price2					= DKRS("price2")
		RS_price4					= DKRS("price4")
		RS_price5					= DKRS("price5")
		RS_price6					= DKRS("price6")
		RS_Sell_VAT_Price			= DKRS("Sell_VAT_Price")
		RS_Except_Sell_VAT_Price	= DKRS("Except_Sell_VAT_Price")		'= DKRS(7)
	Else
		RS_ncode					= RS_ncode
		RS_price					= RS_price
		RS_price2					= RS_price2
		RS_price4					= RS_price4
		RS_price5					= RS_price5
		RS_price6					= RS_price6
		RS_Sell_VAT_Price			= RS_Sell_VAT_Price
		RS_Except_Sell_VAT_Price	= RS_Except_Sell_VAT_Price
	End If
	Call closeRs(DKRS)



%>
<link rel="stylesheet" href="/myoffice/css/style_cs.css" />
<link rel="stylesheet" href="/myoffice/css/layout_cs.css" />
<style type="text/css">
	.bgtitle {
		width:100%;padding:8px 10px;margin:0px auto;
		background: #535353;
		background: -moz-linear-gradient(#535353 20%, #404040 80%);
		background: -webkit-gradient(linear, left top, left bottom, color-stop(20%, #535353), color-stop(80%, #404040));
		background: -webkit-linear-gradient(#535353 20%, #404040 80%);
		background: linear-gradient(#535353 20%, #404040 80%);
	}
	.bgtitle .bgFont{
		font-size:18px;color:#eee;font-family:malgun gothic;Arial,verdana;
	}
</style>
<script type="text/javascript">
<!--
	function chkThisFrm(f) {
		var minEa = <%=RS_Base_Cnt%>;
		if (f.ncode.value =="")
		{
			alert("<%=LNG_CS_POPCART_JS01%>");
			return false;
		}
		if (f.ea.value < 1)
		{
			alert("<%=LNG_CS_POPCART_JS02%>");
			f.ea.focus();
			return false;
		}

	}
//-->
</script>
</head>
<body onload="document.pfrm.ea.focus();">
<div id="pop_all">
	<!-- <div class="top" ><%=viewImg(IMG_POP&"/pop_title_cartGo.gif",250,40,"")%></div> -->
	<div class="bgtitle tweight"><span class="bgFont"><%=LNG_TEXT_CART%> - (<%=mid1%>-<%=Fn_MBID2(mid2)%>)</span></div>
	<div class="popContent">
		<form name="pfrm" action="popCart_4_downMembberHandler.asp" method="post" onsubmit="return chkThisFrm(this)">
			<input type="hidden" name="ncode" value="<%=NCODE%>" />
			<input type="hidden" name="mid1" value="<%=mid1%>" />
			<input type="hidden" name="mid2" value="<%=mid2%>" />
			<table <%=tableatt%> width="100%" class="popCart">
				<col width="120" />
				<col width="*" />
				<tr>
					<th><%=LNG_TEXT_CSGOODS_CODE%></th>
					<td><%=RS_ncode%></td>
				</tr><tr>
					<th><%=LNG_TEXT_ITEM_NAME%></th>
					<td><%=RS_name%></td>
				</tr><tr>
					<th><%=LNG_TEXT_GOODS_SPECIFICATIONS%></th>
					<td><%=RS_inspection%></td>
				</tr><tr>
					<th><%=LNG_TEXT_CONSUMER_PRICE%></th>
					<td><%=num2cur(RS_price)%> <%=Chg_CurrencyISO%></td>
				</tr><tr>
					<th><%=LNG_TEXT_MEMBER_PRICE%></th>
					<td class="Price"><%=num2cur(RS_price2)%> <%=Chg_CurrencyISO%></td>
				</tr><!-- <tr>
					<th><%=LNG_TEXT_WHOLESALE_PRICE%></th>
					<td><%=num2cur(RS_Except_Sell_VAT_Price)%> <%=Chg_CurrencyISO%></td>
				</tr> --><tr>
					<th><%=LNG_TEXT_VAT%></th>
					<td><%=num2cur(RS_Sell_VAT_Price)%> <%=Chg_CurrencyISO%></td>
				</tr><tr>
					<th>PV</th>
					<td class="Price"><%=num2cur(RS_price4)%> <%=CS_PV%></td>
				</tr><tr>
					<th><%=LNG_TEXT_ITEM_NUMBER%></th>
					<td><input type="text" class="input_text" name="ea" value="<%=RS_Base_Cnt%>" style="width:50px;" <%=onlyKeys%> /><%=LNG_TEXT_EA%> <!-- (<%=RS_Base_Cnt%><%=LNG_CS_POPCART_TEXT11%>) -->
					</td>
				</tr>
			</table>
			<div class="btnArea">
				<!-- <input type="image" src="<%=IMG_BTN%>/goCart.gif" /> -->
				<input type="submit" class="txtBtnC medium red2 shadow1 tshadow2 radius5" value="<%=LNG_TEXT_CART%>" />
			</div>
		</form>
	</div>
	<div class="bottom">
		<div class="info"><%=viewImg(IMG_POP&"/pop_bottom_info.gif",160,60,"")%></div>
		<div class="btn_area">
			<!-- <%=aImgSt("javascript:self.close()",IMG_BTN&"/btn_close01.gif",52,23,"","margin-top:20px;margin-right:20px;","")%> -->
			<input type="button" class="txtBtnC small shadow1 border1 radius3 fGray tweight" style="width:52px;margin-top:20px;margin-right:20px;" onclick="self.close();" value="<%=LNG_TEXT_WINDOW_CLOSE%>"/>
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
