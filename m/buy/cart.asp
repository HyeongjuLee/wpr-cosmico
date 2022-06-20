<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	PAGE_SETTING = "MY_BUY"

If webproIP <> "T" Then Call ALERTS(LNG_ALERT_WRONG_ACCESS,"back","")

	Call ONLY_BUSINESS_MEMBER(DK_MEMBER_LEVEL,2)
	Call ONLY_CS_MEMBER()
	Call FN_NationCurrency(DK_MEMBER_NATIONCODE,Chg_CurrencyName,Chg_CurrencyISO)

	'Response.Redirect "/myoffice/buy/goodsList_sellcode.asp"

%>
<!--#include virtual = "/m/_include/document.asp"-->
<!--#include virtual = "/m/_include/jqueryload.asp"-->
<script type="text/javascript" src="/js/ajax.js"></script>
<!-- <script type="text/javascript" src="cart.js"></script> -->
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

		if (confirm("<%=LNG_JS_DELETE_ALL%>")) {
			f.checklist.checked = true;
			f.mode.value = "DELALL";
			f.target = "_self";
			f.action = "cartHandler.asp";
			f.submit();
		} else {
			return;
		}

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


		if (confirm("<%=LNG_JS_DELETE%>")) {
			f.mode.value = "SELDEL";
			f.target = "_self";
			f.action = "cartHandler.asp";
			f.submit();
		} else {
			return;
		}

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
			alert('<%=LNG_CS_CART_JS03%>');
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
			alert('<%=LNG_CS_CART_JS04%>');
			return ;
		}
		//CS상품 구매종류가 같은 상품만 넘김e



		if (typeof objCart == "undefined") {
			alert('<%=LNG_CS_CART_JS05%>');
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
			alert('<%=LNG_CS_CART_JS03%>');
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




	function thisGoodsCart(nums,modes) {
		//alert(modes);
		var eavalue = document.getElementById('oxea'+nums).value;
		var idvalue = document.getElementById('oxid'+nums).value;

		if (eavalue == '') { alert('<%=LNG_CS_CART_JS06%>');}
		if (idvalue == '') { alert('<%=LNG_CS_CART_JS07%>');}

		if (modes == 'delall') {
			if (confirm("<%=LNG_JS_DELETE_ALL%>")) {
				chg_cart(1,1,modes);
			}
		}else{
			if (eavalue < 1){
				//alert('수량값은 1 이상입니다.');
				alert('<%=LNG_CS_CART_JS08%>');
				chg_cart(1,idvalue,modes);
			} else {
				if (modes == 'delete') {
					if (confirm("<%=LNG_JS_DELETE%>")) {
						chg_cart(eavalue,idvalue,modes);
					} else {
					}
				}else{
					chg_cart(eavalue,idvalue,modes);
				}
			//	chg_cart(eavalue,idvalue,modes);
			}

		}

	}


	function chg_cart(mode1,mode2,mode3) {
		createRequest();
		var url = 'cart_ajax.asp';
		//alert(mode3);
		postParams = "eavalue=" + mode1;
		postParams += "&idvalue=" + mode2;
		postParams += "&modes=" + mode3;

		request.open("POST",url,true);
		request.onreadystatechange = function ChgContent() {
			if(request.readyState == 4){    // 요청응답상태가 4인지 확인해주고
				if(request.status == 200){     // HTTP상태가 완료인지 체크해줍니다.
					var newContent = request.responseText;
					//alert(newContent);
					alert('<%=LNG_SHOP_ORDER_LIST_JS01%>');
					document.location.reload();
				} else {
					alert("ajax error2");
				}
			  }
			}
		request.setRequestHeader("Content-Type","application/x-www-form-urlencoded;charset=utf-8");
		request.send(postParams);
		return;
	}
	/* cart.js E */



</script>
<style>


</style>
</head>
<body  onunload="">
<!--#include virtual = "/m/_include/header.asp"-->
<!--#include virtual = "/m/_include/sub_header.asp"-->
<div id="subTitle" class="width100 tcenter text_noline" ><%=LNG_HEADER_CART%></div>
<div id="cart" class="cleft width100" style="margin-top:10px;">
	<form name="cartFrm" method="post" action="orders.asp" >
		<input type="hidden" name="mode" value="" />
		<input type="hidden" name="ea" />
		<table <%=tableatt%> class="width100">
			<colgroup>
				<col width="" />
				<col width="100" />
				<col width="" />
			</colgroup>
			<thead>
				<tr>
					<th colspan="3">
						<input type="checkbox" name="checklist"  onClick="SelectAll()" style="height:20px; width:20px; display:none;"/>
						[<%=LNG_TEXT_CSGOODS_CODE%>] <%=LNG_TEXT_ITEM_NAME%>
					</th>
				</tr><tr>
					<th><%=LNG_SHOP_ORDER_DIRECT_TABLE_02%></th>
					<th><%=LNG_SHOP_ORDER_DIRECT_TABLE_03%></th>
					<th><%=LNG_SHOP_ORDER_DIRECT_TABLE_04%></th>
				</tr>
			</thead>
			<%
				arrParams = Array(_
					Db.makeParam("@strNation",adVarChar,adParamInput,10,UCase(DK_MEMBER_NATIONCODE)), _
					Db.makeParam("@MBID",adVarChar,adParamInput,20,DK_MEMBER_ID1),_
					Db.makeParam("@MBID2",adInteger,adParamInput,0,DK_MEMBER_ID2) _
				)
				arrList = Db.execRsList("DKP_CART_LIST",DB_PROC,arrParams,listLen,DB3)

				total_price = 0
				RS_SellTypeName = ""
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
			<tbody>
				<tr class="hovers">
					<td colspan="3" class="title" style="padding-right:40px;">
						<div style="position:absolute; right:5px; display:inline-block; text-align:center;width:30px; height:30px; margin-top:0px;">
							<a onclick="thisGoodsCart('<%=i%>','delete');" class="cp" style="display:block;margin:0px; width:30px; height:30px; line-height:30px;border:1px solid #ccc;border-radius:4px;font-size:15px;font-weight:bold;">X</a>
						</div>
						<input type="hidden" name="nCode" value="<%=arrList(0,i)%>" />
						<input type="checkbox" name="chkCart" value="<%=arrList(0,i)%>" attrCode="<%=RS_SellCode%>"  style="height:20px; width:20px;" class="vmiddle" />
						<span class="vmiddle">[<%=RS_ncode%>]</span> <span class="title vmiddle"><%=RS_name%></span><%=RS_SellTypeName%>
						<p><span style="padding-left:30px;"><%=arr_Goods_Sort_TXT%></span></p>
					</td>
				</tr><tr>
					<td class="tright bot_line_c" style="" colspan="1">
						<%=spans(num2cur(RS_price2),"#222222","11","400")%>&nbsp;<%=spans(""&Chg_currencyISO&"","#222222","11","400")%>
						<%If DK_MEMBER_STYPE = "0" Then%>
						<br /><%=spans(num2curINT(RS_price4),"#ff3300","10","400")%><%=spans(""&CS_PV&"","#ff3300","9","400")%>
						<%End If%>
					</td>
					<td class="tcenter bot_line_c">
						<input type="tel" name="ea" id="oxea<%=i%>" class="tcenter input_text vmiddle" style="width:40px;" maxlength="2"  value="<%=RS_ea%>" <%=onLyKeys%> />
						<input type="hidden" name="oxid" id="oxid<%=i%>" value="<%=RS_ncode%>" />
						<input type="button" class="txtBtn s_modify radius3" onclick="thisGoodsCart('<%=i%>','modify');" value="<%=LNG_CS_CART_BTN04%>" />
					</td>
					<td class="tright bot_line_c">
						<%=spans(num2cur(total_Price),"#222222","11","400")%>&nbsp;<%=spans(""&Chg_currencyISO&"","#222222","11","400")%>
						<%If DK_MEMBER_STYPE = "0" Then%>
						<br /><%=spans(num2curINT(total_PV),"#ff3300","10","400")%><%=spans(""&CS_PV&"","#ff3300","9","400")%>
						<%End If%>
					</td>
				</tr>
			</tbody>
			<%
					Next
				Else
					PRINT tabs(1)&"	<tr>"
					PRINT tabs(1)&"		<td colspan=""3"" class=""notData"">"&LNG_CS_GOODSLIST_TEXT22&"</td>"
					PRINT tabs(1)&"	</tr>"
				End If
			%>
			<tfoot>
				<!-- <tr>
					<th colspan="2" class="tright bot_line_c"><%=LNG_CS_CART_TEXT09%></th>
					<th colspan="2" class="tright bot_line_c">
						<%=spans(num2cur(total_price_all),"#222222","11","400")%>&nbsp;<%=spans(""&Chg_currencyISO&"","#222222","11","400")%>
						<%If DK_MEMBER_STYPE = "0" Then%>
						<br /><%=spans(num2curINT(total_pv_all),"#ff3300","10","400")%><%=spans(""&CS_PV&"","#ff3300","9","400")%>
						<%End If%>
					</th>
				</tr> -->
				<tr>
					<td colspan="7" class="notBor">
						<input type="button" class="txtBtnC small gray radius3 border1" onclick="SelectAlls();" value="<%=LNG_CS_CART_BTN01%>"/>
						<input type="button" class="txtBtnC small gray radius3 border1" style="color:red;" onclick="delAll();" value="<%=LNG_CS_CART_BTN02%>" />
						<!-- <input type="button" class="txtBtnC small gray radius3 border1" style="color:#bd3e3e;" onclick="selDEl();" value="<%=LNG_CS_CART_BTN03%>"/> -->
					</td>
				</tr>

			</tfoot>
		</table>

		<div id="" class="width100" style="margin:20px 0px 50px 0px;">
			<div class="clear" style=" margin:0px 10px; overflow:hidden;">
			<%If RS_ncode <> "" And RS_name <> "" Then%>
				<div><input type="button" class="mBtn joinBtn jBtn2 fleft" style="width:49%" onclick="location.href='goodslist.asp'" value="<%=LNG_CS_CART_BTN_GOODSLIST%>"/></div>
				<div><input type="button" class="mBtn joinBtn jBtn1 fright" style="width:49%" onclick="javascript:return selectOrder();" value="<%=LNG_CS_CART_BTN05%>"/></div>
			<%Else%>
				<div><input type="button" class="mBtn joinBtn jBtn2 tcenter" style="width:49%" onclick="location.href='goodslist.asp'" value="<%=LNG_CS_CART_BTN_GOODSLIST%>"/></div>
			<%End If%>
			</div>
		</div>
	</form>

</div>
<form name="frm" method="post" action="">
	<input type="hidden" name="v_SellCode" value="<%=v_SellCode%>" />
</form>
<!--#include virtual = "/m/_include/copyright.asp"-->
