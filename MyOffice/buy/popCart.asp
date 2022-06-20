<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual = "/_include/document.asp"-->
<%
' ===================================================================
' 게시판 변수 받아오기(설정)
' ===================================================================
	Call FN_NationCurrency(DK_MEMBER_NATIONCODE,Chg_CurrencyName,Chg_CurrencyISO)

	Dim popWidth,popHeight
		popWidth = 480
		popHeight = 500
'	Call ONLY_MEMBER()
	'Call MEMBER_AUTH_CHECK(nowGradeCnt,3)
	Dim NCODE
		NCODE = Request.QueryString("code")

	If NCODE = "" Then Call ALERTS(LNG_CS_POPCART_ALERT01,"close","")

	'SQL = "SELECT * FROM [tbl_Goods] WITH(NOLOCK) WHERE [ncode] = ? AND [GoodUse] = 0"
	SQL = "SELECT * FROM [tbl_Goods] WITH(NOLOCK) WHERE [ncode] = ? AND [GoodUse] = 0 AND [Na_Code] = '"&UCase(Lang)&"' "
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

	'▣CS상품정보 변동정보 통합
	arrParams = Array(_
		Db.makeParam("@ncode",adVarChar,adParamInput,20,RS_ncode) _
	)
	Set DKRS = Db.execRs("HJP_CSGOODS_PRICE_INFO",DB_PROC,arrParams,DB3)
	If Not DKRS.BOF And Not DKRS.EOF Then
		RS_ncode					= DKRS("ncode")
		RS_price					= DKRS("price")
		RS_price2					= DKRS("price2")
		RS_price4					= DKRS("price4")
		RS_price5					= DKRS("price5")
		RS_price6					= DKRS("price6")
		RS_Sell_VAT_Price			= DKRS("Sell_VAT_Price")
		RS_Except_Sell_VAT_Price	= DKRS("Except_Sell_VAT_Price")
	End If
	Call closeRs(DKRS)

	If CONST_CS_SOBIJA_PRICE_USE_TF = "T" Then
		If DK_MEMBER_STYPE = "1" Then
			RS_price2 = RS_price
		End If
	End If

%>
<link rel="stylesheet" href="/myoffice/css/style_cs.css" />
<link rel="stylesheet" href="/myoffice/css/layout_cs.css" />
<style type="text/css">
	html {overflow:hidden}
	.bgtitle {
		padding:10px 10px;margin:0px auto;
		background: #2070aa;
	}
	.bgtitle .bgFont{
		font-size:20px;color:#eee;font-family:malgun gothic;Arial,verdana;
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
	<div class="bgtitle tweight"><span class="bgFont"><%=LNG_TEXT_CART%></span></div>
	<div class="popContent">
		<form name="pfrm" action="popCartHandler.asp" method="post" onsubmit="return chkThisFrm(this)">
			<input type="hidden" name="ncode" value="<%=NCODE%>" />
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
					<td><input type="text" class="input_text" name="ea" value="<%=RS_Base_Cnt%>" style="width:50px;" maxlength="2" <%=onlyKeys%> /><%=LNG_TEXT_EA%>
					</td>
				</tr>
			</table>
			<div class="btnArea">
				<!-- <input type="image" src="<%=IMG_BTN%>/goCart.gif" /> -->
				<input type="submit" class="txtBtnC medium red2 radius5" value="<%=LNG_TEXT_CART%>" />
			</div>
		</form>
	</div>
	<div class="bottom">
		<div class="btn_area">
			<input type="button" class="txtBtnC small border1 radius3 tweight" style="margin-top:20px;margin-right:20px;" onclick="self.close();" value="<%=LNG_TEXT_WINDOW_CLOSE%>"/>
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
