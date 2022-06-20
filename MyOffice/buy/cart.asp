<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	PAGE_SETTING = "MYOFFICE"
	INFO_MODE	 = "ORDER1-3"

	ISLEFT = "T"
	ISSUBTOP = "T"

If webproIP <> "T" Then Call ALERTS(LNG_ALERT_WRONG_ACCESS,"back","")

	Call ONLY_BUSINESS_MEMBER(DK_MEMBER_LEVEL,2)
	Call ONLY_CS_MEMBER()
	Call FN_NationCurrency(DK_MEMBER_NATIONCODE,Chg_CurrencyName,Chg_CurrencyISO)

	'Response.Redirect "/myoffice/buy/goodsList_sellcode.asp"

%>
<!--#include virtual = "/_include/document.asp"-->
<link rel="stylesheet" href="/myoffice/css/style_cs.css" />
<link rel="stylesheet" href="/myoffice/css/layout_cs.css" />
<script type="text/javascript">

	function SelectAlls() {
		var f = document.cartFrm;
		if (f.checklist.checked) {
			f.checklist.checked = false;
		} else {
			f.checklist.checked = true;
		}
		SelectAll();
	}


	function SelectAll(){
		var f = document.cartFrm;
		if(f.checklist.checked){
			if (typeof f.chkCart.length == "undefined") {
				f.chkCart.checked = true;
			}
			else {
				for (i=0, len=f.chkCart.length; i<len; i++) {
					f.chkCart[i].checked = true;
				}
			}
		}
		else{
			if (typeof f.chkCart.length == "undefined") {
				f.chkCart.checked = false;
			}
			else {
				for (i=0, len=f.chkCart.length; i<len; i++) {
					f.chkCart[i].checked = false;
				}
			}
		}
	}

	function delAll() {
		var f= document.cartFrm;
		if (typeof f.nCode == "undefined"){
			//alert("삭제할 상품이 없습니다.");
			alert("<%=LNG_CS_CART_JS01%>");
			return;
		}

		f.checklist.checked = true;
		f.mode.value = "DELALL";
		f.target = "_self";
		f.action = "cartHandler.asp";
		f.submit();
	}


	function selDEl() {
		var f = document.cartFrm
		var i,len;
		var objCbList = f.chkCart;
		var objCart = f.nCode;
		var objEa = f.ea;
		var selCnt = 0;

		if (typeof f.nCode == "undefined") {
			//alert("삭제할 상품이 없습니다.");
			alert("<%=LNG_CS_CART_JS01%>");
			return;
		}
		if (typeof f.chkCart.length == "undefined") {
			if (f.chkCart.checked) ++selCnt;
		}
		else {
			for (i=0, len=f.chkCart.length; i<len; i++) {
				if (f.chkCart[i].checked) ++selCnt;
			}
		}

		if (selCnt == 0) {
			//alert("삭제하실 상품을 선택해 주세요.");
			alert("<%=LNG_CS_CART_JS02%>");
			return;
		}

		if (typeof f.chkCart.length == "undefined") {
			if (f.chkCart.checked) {
				objCart.disabled = false;
			}
			else {
				objCart.disabled = true;
			}
		}
		else {
			for (i=0, len=f.chkCart.length; i<len; i++) {
				if (f.chkCart[i].checked) {
					objCart[i].disabled = false;
				}
				else {
					objCart[i].disabled = true;
				}
			}
		}

		f.mode.value = "SELDEL";
		f.target = "_self";
		f.action = "cartHandler.asp";
		f.submit();
	}

	function selectOrder() {
		var f = document.cartFrm
		var i,len;
		var objCbList = f.chkCart;
		var objCart = f.nCode;
		var objEa = f.ea;
		var selCnt = 0;

		//CS상품 구매종류가 같은 상품만 넘김s
		if ($("input[name=chkCart]:checked").length == 0)
		{
			//alert("주문하실 상품을 선택해주세요!");
			alert("<%=LNG_CS_CART_JS03%>");
			return ;
		}

		var attrResult = [];									// 배열선언
		$("input[name=chkCart]:checked").each(function(){		// input name 이 chkCart 중 체크된 애들만 가져온다. (for 문과 같은 반복)
			var vs = $(this).attr("attrCode");					// vs 는 해당 값의 어트리뷰트중 attrCode 의 값
			if (vs != "")										// attrCode 가 빈값이 아니라면
			{
				if ($.inArray(vs,attrResult) == -1)				// 배열과 비교해서 기존에 없는 값인 경우
				{
					attrResult.push(vs);						// 배열에 저장
				}
			}

		});
		var attrReCount = attrResult.length;					// 배열의 갯수를 센다

		if (attrReCount > 1)									// 배열의 갯수가 1개 이상인 경우 (일반상품 제외vs에서 걸렀음)
		{
			//alert("구매종류가 다른 상품은 같이 구매할 수 없습니다.");
			alert("<%=LNG_CS_CART_JS04%>");
			return ;
		}
		//CS상품 구매종류가 같은 상품만 넘김e



		if (typeof objCart == "undefined") {
			//alert("주문하실 상품이 없습니다.");
			alert("<%=LNG_CS_CART_JS05%>");
			return;
		}

		if (typeof f.chkCart.length == "undefined") {
			if (f.chkCart.checked) ++selCnt;
		}
		else {
			for (i=0, len=f.chkCart.length; i<len; i++) {
				if (f.chkCart[i].checked) ++selCnt;
			}
		}

		if (selCnt == 0) {
			//alert("주문하실 상품을 선택해 주세요.");
			alert("<%=LNG_CS_CART_JS03%>");
			return;
		}

		if (typeof f.chkCart.length == "undefined") {
			if (f.chkCart.checked) {
				objCart.disabled = false;
			}
			else {
				objCart.disabled = true;
			}
		}
		else {
			for (i=0, len=f.chkCart.length; i<len; i++) {
				if (f.chkCart[i].checked) {
					objCart[i].disabled = false;
				}
				else {
					objCart[i].disabled = true;
				}
			}
		}

		f.target = "_self";
		//f.action = "orders.asp";
		f.action = "order.asp";
		f.submit();
	}

	//카트수량조정
	function thisGoodsCart(nums,modes) {
		var eavalue = document.getElementById('oxea'+nums).value;
		var idvalue = document.getElementById('oxid'+nums).value;

		if (eavalue == '') { alert('<%=LNG_CS_CART_JS06%>'); return false;}
		if (idvalue == '') { alert('<%=LNG_CS_CART_JS07%>'); return false;}
		if (eavalue < 1){
			alert('<%=LNG_CS_CART_JS08%>');
			document.location.reload();
		} else {
			chg_cart(eavalue,idvalue,modes);
		}
	}

	function chg_cart(mode1,mode2,mode3) {

		$.ajax({
			type: "POST"
			,url: "cart_ajax.asp"
			,data: {
				  "modes"		: mode3
				 ,"eavalue"		: mode1
				 ,"idvalue"		: mode2
			}
			//,contentType: "application/json; charset=utf-8"
			,success: function(data) {
				var json = $.parseJSON(data);
				//console.log(data);
				//console.log(json.result);
				//console.log(json.resultMsg);
				alert(json.resultMsg);
				document.location.reload();
			}
			,error:function(data) {
				alert("ajax error");
			}
		});
	}

</script>
</head>
<body>
<!--#include virtual = "/_include/header.asp"-->
<p class="titles"><%=LNG_TEXT_LIST%></p>
<div id="cart" class="orderList">
	<form name="cartFrm" method="post" action="">
		<input type="hidden" name="mode" value="" />
		<input type="hidden" name="ea" />
		<table <%=tableatt%> class="width100 orderTable board">
			<colgroup>
				<col width="40" />
				<col width="80" />
				<col width="*" />
				<col width="160" />
				<col width="130" />
				<col width="160" />
			</colgroup>
			<thead>
				<tr>
					<th><input type="checkbox" name="checklist"  onClick="SelectAll()" /></th>
					<th><%=LNG_TEXT_CSGOODS_CODE%></th>
					<th><%=LNG_TEXT_ITEM_NAME%></th>
					<th><%=LNG_SHOP_ORDER_DIRECT_TABLE_02%></th>
					<th><%=LNG_SHOP_ORDER_DIRECT_TABLE_03%></th>
					<th><%=LNG_SHOP_ORDER_DIRECT_TABLE_04%></th>
				</tr>
			</thead>
			<tbody>
			<%
				arrParams = Array(_
					Db.makeParam("@strNation",adVarChar,adParamInput,10,UCase(DK_MEMBER_NATIONCODE)), _
					Db.makeParam("@MBID",adVarChar,adParamInput,20,DK_MEMBER_ID1),_
					Db.makeParam("@MBID2",adInteger,adParamInput,0,DK_MEMBER_ID2) _
				)
				arrList = Db.execRsList("DKP_CART_LIST",DB_PROC,arrParams,listLen,DB3)

				total_Price = 0
				total_pv_all = 0
				total_PV = 0
				total_price_all = 0
				If IsArray(arrList) Then
					For i = 0 To listLen
						RS_ncode		= arrList(1,i)
						RS_name			= arrList(2,i)
						RS_price2		= arrList(3,i)
						RS_GoodUse		= arrList(4,i)
						RS_price4		= arrList(5,i)
						RS_ea			= arrList(7,i)
						RS_SellCode		= arrList(8,i)
						RS_price6		= arrList(9,i)
						RS_SellTypeName	= arrList(10,i)

						'구매종류
						If RS_SellTypeName <> "" Then
							RS_SellTypeName = "<p span class=""blue2"">["&RS_SellTypeName&"]</p>"
						End If

						'▣CS상품정보 변동정보 통합
						arrParams = Array(_
							Db.makeParam("@ncode",adVarChar,adParamInput,20,RS_ncode) _
						)
						Set DKRS = Db.execRs("HJP_CSGOODS_PRICE_INFO",DB_PROC,arrParams,DB3)
						If Not DKRS.BOF And Not DKRS.EOF Then
							RS_ncode		= DKRS("ncode")
							RS_price2		= DKRS("price2")
							RS_price4		= DKRS("price4")
							RS_price5		= DKRS("price5")
							RS_price6		= DKRS("price6")
							RS_SellCode		= DKRS("SellCode")
							RS_SellTypeName	= DKRS("SellTypeName")
						End If
						Call closeRs(DKRS)

						total_Price = RS_ea * RS_price2
						total_PV = RS_ea * RS_price4
						total_price_all	= total_price_all + (RS_ea * RS_price2)
						total_pv_all = total_pv_all + (RS_ea * RS_price4)
			%>
						<tr>
							<td class="tcenter"><input type="hidden" name="nCode" value="<%=arrList(0,i)%>" /><input type="checkbox" name="chkCart" value="<%=arrList(0,i)%>" attrCode="<%=RS_SellCode%>" /></td>
							<td class="tcenter"><%=RS_ncode%></td>
							<td>
								<%=RS_name&RS_SellTypeName%>
							</td>
							<td class="inPrice">
								<%=spans(num2cur(RS_price2),"#222222","13","400")%>&nbsp;<%=spans(""&Chg_currencyISO&"","#222222","12","400")%>
								<%If DK_MEMBER_STYPE = "0" Then%>
								<br /><%=spans(num2curINT(RS_price4),"#ff3300","11","400")%><%=spans(""&CS_PV&"","#ff3300","10","400")%>
								<%End If%>
							</td>
							<td class="tcenter">
								<input type="text" name="ea" id="oxea<%=i%>" class="tcenter input_text" style="width:50px;" maxlength="2"  value="<%=RS_ea%>" <%=onLyKeys%> />
								<input type="hidden" name="oxid" id="oxid<%=i%>" value="<%=RS_ncode%>" />
								<input type="button" class="txtBtn s_modify radius3" onclick="thisGoodsCart('<%=i%>','modify');" value="<%=LNG_CS_CART_BTN04%>" />
							</td>
							<td class="inPrice">
								<%=spans(num2cur(total_Price),"#222222","13","400")%>&nbsp;<%=spans(""&Chg_currencyISO&"","#222222","12","400")%>
								<%If DK_MEMBER_STYPE = "0" Then%>
								<br /><%=spans(num2curINT(total_PV),"#ff3300","11","400")%><%=spans(""&CS_PV&"","#ff3300","10","400")%>
								<%End If%>
							</td>
						</tr>
			<%
					Next
				Else
			%>
						<tr>
							<td colspan="6" class="notData"><%=LNG_CS_CART_TEXT08%></td>
						</tr>
			<%
				End If
			%>
			</tbody>
			<tfoot>
				<!-- <td colspan="5" class="tright bg2 pR4" style="padding:10px 10px;"><%=LNG_CS_CART_TEXT09%></td>
				<td colspan="1" class="inPrice Price red tright bg2 pR4">
					<%=spans(num2cur(total_price_all),"#222222","11","400")%>&nbsp;<%=spans(""&Chg_currencyISO&"","#222222","11","400")%>
					<%If DK_MEMBER_STYPE = "0" Then%>
					<br /><%=spans(num2curINT(total_pv_all),"#ff3300","10","400")%><%=spans(""&CS_PV&"","#ff3300","9","400")%>
					<%End If%>
				</td> -->
				<tr>
					<td colspan="6" class="notBor">
						<input type="button" class="detail_btn" onclick="SelectAlls();" value="<%=LNG_CS_CART_BTN01%>"/>
						<input type="button" class="detail_btn" onclick="delAll();" value="<%=LNG_CS_CART_BTN02%>" />
						<input type="button" class="detail_btn purple" onclick="selDEl();" value="<%=LNG_CS_CART_BTN03%>"/>
					</td>
				</tr>
			</tfoot>
		</table>
		<div class="pagingArea width100 btnZone">
			<input type="button" class="promise" style="min-width:140px;" value="<%=LNG_CS_CART_BTN05%>" onclick="javascript:selectOrder();"/>
		</div>
	</form>
</div>
<!--#include virtual = "/_include/copyright.asp"-->
