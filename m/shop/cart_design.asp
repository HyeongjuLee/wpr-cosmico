<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	Call FN_NationCurrency(DK_MEMBER_NATIONCODE,Chg_CurrencyName,Chg_CurrencyISO)
	Call ONLY_BUSINESS_MEMBER(DK_MEMBER_LEVEL,1)

	'장바구니
	PAGE_SETTING = "SHOP"
	SHOP_ORDER_PAGE_TYPE = "CART"


	If DK_MEMBER_ID <> "" Then
		cart_id = DK_MEMBER_ID
		cart_method = "MEMBER"
	Else
		cart_id = DK_MEMBER_IDX
		cart_method = "NOTMEM"
	End If




%>
<!--#include virtual = "/m/_include/document.asp"-->
<!--#include virtual = "/m/_include/jqueryload.asp"-->

<script type="text/javascript">
	function SelectAll(){
		var f = document.cartFrm;
		if(f.checklist.checked){
			if (typeof f.chkCart.length == "undefined") {
				if (f.chkCart.disabled != true)
					{
						//f.chkCart[i].checked = true;
						f.chkCart.checked = true;
					}

			} else {
				for (i=0, len=f.chkCart.length; i<len; i++) {
					if (f.chkCart[i].disabled != true)
					{
						//alert("aa2");
						f.chkCart[i].checked = true;
					}
				}
			}
		} else {
			if (typeof f.chkCart.length == "undefined") {
				f.chkCart.checked = false;
				//alert("3");
			} else {
				for (i=0, len=f.chkCart.length; i<len; i++) {
					//f.chkCart[i].checked = false;
					if (f.chkCart[i].disabled != true)
					{
						//alert("aa1");
						f.chkCart[i].checked = false;
					}
				}
			}
		}
	}


	//thisDel( 상품직접삭제, mode="SELDEL" )  = cartDel(모바일상품직접삭제, mode="DELETE")
	function cartDel(idx) {
		var f = document.dFrm;
		//if (confirm('해당 상품을 삭제하시겠습니까?'))
		if (confirm('<%=LNG_SHOP_CART_JS_DELETE%>'))
		{
			f.mode.value = 'DELETE';
			f.cartIDX.value = idx;
			f.submit();
		}
	}

	/*
	function chgCartEa(ipName,idx) {
		var setEa = $("#"+ipName).val();
		var f = document.dFrm;

		if (setEa < 1 )
		{
			alert("수량값은 최소 1이상입니다.");
			//alert("<%=LNG_CS_CART_JS08%>");
			f.setEa.value=1;
			return;
		}

		f.mode.value = 'EACHG';
		f.cartIDX.value = idx;
		f.cartEa.value = setEa;
		f.submit();
	}
	*/

	// onclick="chgCartEa_N('cartEA<%=i%>','<%=arrList_intIDX%>'			,'<%=arrList_orderEa%>','<%=arrList_GoodIDX%>','<%=arrList_intMinimum%>');" />

	//최소구매갯수 체크, eaORG, gIDX 추가2018-10-19
	//function chgCartEa_N(ipName,idx,eaORG,gIDX,intMinimum) {
	function chgCartEa(idx) {
		const f = document.mFrm;
		let chkboxArea = $("#chkboxArea"+idx);
		let eaORG = $(chkboxArea).find("input[name=ea]").val();
		let gIDX = $(chkboxArea).find("input[name=gIDX]").val();
		let intMinimum = $(chkboxArea).find("input[name=intMinimum]").val();
		let setEa = $(chkboxArea).find("input[name=setEa]").val();

		if (setEa == "" || parseInt(setEa,10) < parseInt(intMinimum,10))
		{
			//alert("수량은 <%=DKRS_intMinimum%>보다 커야합니다.");
			alert("<%=LNG_SHOP_DETAILVIEW_14%>");
			return;
		}

		if (setEa < 1 )
		{
			alert("수량값은 최소 1이상입니다.");
			//alert("<%=LNG_CS_CART_JS08%>");
			f.setEa.value=1;
			return;
		}

		f.mode.value = 'EACHG';
		f.cartIDX.value = idx;
		f.cartEa.value = setEa;
		f.eaORG.value	= eaORG;
		f.gIDX.value	= gIDX;
		f.submit();
	}

	function selectOrder() {
		var f = document.cartFrm;
		var i,len;
		var objCbList = f.chkCart;
		var objCart = f.cuidx;
		var objEa = f.ea;
		var selCnt = 0;
		var chgGoodsCnt = 0;
		var attr;

		// CS회원구매, CS상품 구매종류가 같은 상품만 넘김
		var isCSMEMBER = $("input[name=isCSMEMBER]").val();

		if (isCSMEMBER == "T")
		{
			if ($("input[name=chkCart]:checked").length == 0)
			{
				//alert("주문하실 상품을 선택해주세요!");
				alert("<%=LNG_SHOP_CART_JS_02%>");
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
		}


		if (typeof objCart == "undefined") {
			//alert("주문하실 상품이 없습니다.");
			alert("<%=LNG_SHOP_CART_JS_01%>");
			return;
		}

		if (typeof f.chkCart.length == "undefined") {
			if (f.chkCart.checked) ++selCnt;
		}
		else {
			for (i=0, len=f.chkCart.length; i<len; i++) {
				if (f.chkCart[i].checked){
					++selCnt;
					attr = f.chkCart[i].getAttribute('attrCG');
					//alert(attr);
					if (attr == 'T')
					{
						//alert(attr);
						++chgGoodsCnt;
					}
				}
			}
		}

		if (selCnt == 0) {
			//alert("주문하실 상품을 선택해 주세요.");
			alert("<%=LNG_SHOP_CART_JS_02%>");
			return;
		}
		if (chgGoodsCnt > 0)
		{
			//alert("주문하려는 상품중에 옵션이 선택되지 않은 상품이 있습니다.\n\n옵션을 확인해주세요");
			alert("<%=LNG_SHOP_CART_JS_03%>");
			return;
		}


		if (typeof f.chkCart.length == "undefined") {
			if (f.chkCart.checked) {
				objCart.disabled = false;
				objEa.disabled = false;
			}
			else {
				objCart.disabled = true;
				objEa.disabled = true;
			}
		}
		else {
			for (i=0, len=f.chkCart.length; i<len; i++) {
				if (f.chkCart[i].checked) {
					objCart[i].disabled = false;
					objEa[i].disabled = false;
				}
				else {
					objCart[i].disabled = true;
					objEa[i].disabled = true;
				}
			}
		}

		f.target = "_self";
		f.action = "/m/shop/order.asp";
		f.submit();
	}


</script>
</head>
<body onUnload="">
<!--#include virtual = "/m/_include/header.asp"-->
<div id="Cart" class="shopPage cart">
	<form name="cartFrm" method="post" onsubmit="return allOrders(this);">
		<!-- <input type="hidden" name="uidx" />
		<input type="hidden" name="ea" /> -->
		<%If DK_MEMBER_TYPE = "COMPANY" Then%>
			<input type="hidden" name="isCSMEMBER" value="T" />
		<%ELSE%>
			<input type="hidden" name="isCSMEMBER" value="F" />
		<%End IF%>

		<div id="cartChk">
			<label>
				<input type="checkbox" name="checklist" onClick="SelectAll()"/>
				<span><%=LNG_CS_CART_BTN01%></span>
			</label>
		</div>

		<ul class="order-list cart-list">
		<%
			k = 0
			arrParams = Array(_
				Db.makeParam("@cart_method",adVarChar,adParamInput,10,cart_method), _
				Db.makeParam("@MEMTYPE",adVarChar,adParamInput,50,cart_id), _
				Db.makeParam("@DKSP_CART_LIST",adVarChar,adParamInput,6,DK_MEMBER_NATIONCODE) _
			)
			arrList = Db.execRsList("DKSP_CART_LIST",DB_PROC,arrParams,listLen,Nothing)

			If IsArray(arrList) Then
				For i = 0 To listLen
					totalOptionPrice = 0
					totalPrice = 0

					arrList_intIDX				= arrList(0,i)
					arrList_strDomain			= arrList(1,i)
					arrList_strMemID			= arrList(2,i)
					arrList_strIDX				= arrList(3,i)
					arrList_GoodIDX				= arrList(4,i)
					arrList_strOption			= arrList(5,i)
					arrList_orderEa				= arrList(6,i)
					arrList_RegistDate			= arrList(7,i)
					arrList_BintIDX				= arrList(8,i)
					arrList_Category			= arrList(9,i)
					arrList_GoodsName			= arrList(10,i)
					arrList_GoodsComment		= arrList(11,i)
					arrList_FlagVote			= arrList(12,i)
					arrList_flagBest			= arrList(13,i)
					arrList_GoodsStockNum		= arrList(14,i)
					arrList_GoodsStockType		= arrList(15,i)
					arrList_GoodsMade			= arrList(16,i)
					arrList_GoodsProduct		= arrList(17,i)
					arrList_GoodsCost			= arrList(18,i)
					arrList_GoodsPrice			= arrList(19,i)
					arrList_GoodsCustomer		= arrList(20,i)
					arrList_GoodsPoint			= arrList(21,i)
					arrList_GoodsViewTF			= arrList(22,i)
					arrList_imgThum				= arrList(23,i)
					arrList_GoodsContent		= arrList(24,i)
					arrList_strShopID			= arrList(25,i)
					arrList_isShopType			= arrList(26,i)
					arrList_flagNew				= arrList(27,i)
					arrList_isCSGoods			= arrList(28,i)
					arrList_GoodsDeliveryType	= arrList(29,i)
					arrList_GoodsDeliveryFee	= arrList(30,i)
					arrList_SHOPCNT				= Int(arrList(31,i))
					arrList_DELICNT				= Int(arrList(32,i))

					arrList_intPriceNot			= arrList(33,i)
					arrList_intPriceAuth		= arrList(34,i)
					arrList_intPriceDeal		= arrList(35,i)
					arrList_intPriceVIP			= arrList(36,i)
					arrList_intMinNot			= arrList(37,i)
					arrList_intMinAuth			= arrList(38,i)
					arrList_intMinDeal			= arrList(39,i)
					arrList_intMinVIP			= arrList(40,i)
					arrList_intPointNot			= arrList(41,i)
					arrList_intPointAuth		= arrList(42,i)
					arrList_intPointDeal		= arrList(43,i)
					arrList_intPointVIP			= arrList(44,i)

					arrList_OPTIONCNT			= arrList(45,i)
					arrList_isChgGoods			= arrList(46,i)
					arrList_isImgType			= arrList(47,i)

					arrList_imgList				= arrList(48,i)
					arrList_CSGoodsCode			= arrList(49,i)		'CS상품코드

					Select Case DK_MEMBER_LEVEL
						Case 0,1 '비회원, 일반회원
							arrList_GoodsPrice = arrList_intPriceNot
							arrList_GoodsPoint = arrList_intPointNot
							arrList_intMinimum = arrList_intMinNot	'Minimum 추가
						Case 2 '인증회원
							arrList_GoodsPrice = arrList_intPriceAuth
							arrList_GoodsPoint = arrList_intPointAuth
							arrList_intMinimum = arrList_intMinAuth
						Case 3 '딜러회원
							arrList_GoodsPrice = arrList_intPriceDeal
							arrList_GoodsPoint = arrList_intPointDeal
							arrList_intMinimum = arrList_intMinDeal
						Case 4,5 'VIP 회원
							arrList_GoodsPrice = arrList_intPriceVIP
							arrList_GoodsPoint = arrList_intPointVIP
							arrList_intMinimum = arrList_intMinVIP
						Case 9,10,11
							arrList_GoodsPrice = arrList_intPriceVIP
							arrList_GoodsPoint = arrList_intPointVIP
							arrList_intMinimum = arrList_intMinVIP
					End Select

					'▣ 소비자 가격
					If CONST_CS_SOBIJA_PRICE_USE_TF = "T" Then
						If DK_MEMBER_STYPE = "1" And arrList_isCSGoods = "T" Then
							arrList_GoodsPrice	 = arrList_GoodsCustomer
						End If
					End If

					If arrList_isImgType = "S" Then
						'imgPath = VIR_PATH("goods/list")&"/"&arrList_imgList
						imgPath = VIR_PATH("goods/thum")&"/"&backword(arrList_imgThum)

						goodsImg = "<img src="""&imgPath&""" width=""100%"" alt="""" />"
					Else
						goodsImg = "<img src="""&backword(arrList_imgList)&""" width=""100%"" alt="""" />"
					End If

					sum_optionPrice = 0
					arrResult = Split(CheckSpace(arrList_strOption),",")
					printOPTIONS = ""
					For j = 0 To UBound(arrResult)
						arrOption = Split(Trim(arrResult(j)),"\")
						arrOptionTitle = Split(arrOption(0),":")
						If arrOption(1) > 0 Then
							OptionPrice = " / + " & num2cur(arrOption(1)) &" "&Chg_CurrencyISO&""
						ElseIf arrOption(1) < 0 Then
							OptionPrice = "/ - " & num2cur(arrOption(1)) &" "&Chg_CurrencyISO&""
						ElseIf arrOption(1) = 0 Then
							OptionPrice = ""
						End If

						printOPTIONS = printOPTIONS & "<span style='font-size:8pt;color:#9e9e9e;'>["&LNG_SHOP_ORDER_DIRECT_TABLE_06&"] "& arrOptionTitle(0) & " : " & arrOptionTitle(1) & OptionPrice & "</span><br />"
						sum_optionPrice = Int(sum_optionPrice) + Int(arrOption(1))
					Next

					arr_CS_price4 = 0
					arr_CS_SELLCODE		= ""
					arr_CS_SellTypeName = ""
					'If arrList_isCSGoods = "T" And DK_MEMBER_STYPE = "0" Then
					If arrList_isCSGoods = "T" Then
						'▣CS상품정보 변동정보 통합
							'Db.makeParam("@Na_Code",adVarChar,adParamInput,50,UCase(DK_MEMBER_NATIONCODE)), _
						arrParams = Array(_
							Db.makeParam("@ncode",adVarChar,adParamInput,20,arrList_CSGoodsCode) _
						)
						Set DKRS = Db.execRs("HJP_CSGOODS_PRICE_INFO",DB_PROC,arrParams,DB3)
						'Set DKRS = Db.execRs("HJP_CSGOODS_PRICE_INFO_GLOBAL",DB_PROC,arrParams,DB3)
						If Not DKRS.BOF And Not DKRS.EOF Then
							arr_CS_ncode		= DKRS("ncode")
							arr_CS_price		= DKRS("price")
							arr_CS_price2		= DKRS("price2")
							arr_CS_price4		= DKRS("price4")
							arr_CS_price5		= DKRS("price5")
							arr_CS_price6		= DKRS("price6")
							arr_CS_SellCode		= DKRS("SellCode")
							arr_CS_SellTypeName	= DKRS("SellTypeName")
							If arr_CS_SellTypeName <> "" Then
							arr_CS_SellTypeName = "<span class=""tweight blue2""></span><span class=""green tweight""> ["&arr_CS_SellTypeName&"]</span>"
							End If
						End If
						Call closeRs(DKRS)

						self_PV = arr_CS_price4 * arrList_orderEa
					Else
						self_PV = 0
					End If

					'▣소비자 가격, 쇼핑몰가/CS가 비교 & 소비자 = 소비자가 구매
					If CONST_CS_SOBIJA_PRICE_USE_TF = "T" Then
						If DK_MEMBER_STYPE = "1" And arrList_isCSGoods = "T" Then
							arr_CS_price2 = arr_CS_price
						End If
					End If

					If arrList_isCSGoods = "T" And (arr_CS_price2 <> arrList_GoodsPrice) Then
						DIFFERENT_GOODS_INFO_TXT = "<br /><span class=""red tweight""> 관리프로그램과 쇼핑몰 등록정보가 다릅니다.(구입불가)</span>"
					Else
						DIFFERENT_GOODS_INFO_TXT = ""
					End If

					'상품별 금액/적립금 확인
					selfPrice = Int(arrList_orderEa) * Int(arrList_GoodsPrice)
					selfPoint = Int(arrList_orderEa) * Int(arrList_GoodsPoint)
					self_optionPrice = Int(arrList_orderEa) * Int(sum_optionPrice)
					selfPV = Int(arrList_orderEa) * Int(arr_CS_price4)

					TOTAL_POINT_PRICE = selfPrice + self_optionPrice

					Select Case arrList_GoodsStockType
						Case "N" '재고부족
							If arrList_GoodsStockNum < arrList_orderEa Then
								checkBox_Disabled = " disabled=""disabled"" "
								StockText1 = "<span class=""red"">["&LNG_SHOP_CART_TXT_NO_STOCK&"]</span> "
								StockText2 = LNG_SHOP_CART_TXT_OVER_STOCK &" ("&LNG_SHOP_CART_TXT_STOCK&"'"&arrList_GoodsStockNum&"')"
							End If
						Case "I" '무제한'
							checkBox_Disabled = ""
							StockText1 = ""
							StockText2 = ""
						Case "S" '품절'
							checkBox_Disabled = " disabled=""disabled"" "
							StockText1 = "<span class=""red"">["&LNG_SHOP_DETAILVIEW_33&"]</span> "
							StockText2 = LNG_SHOP_DETAILVIEW_04
						Case Else '재고이상
							checkBox_Disabled = " disabled=""disabled"" "
							StockText1 = "<span class=""red"">["&LNG_SHOP_ORDER_WISHLIST_STOCK_ERROR&"]</span> "
							StockText2 = LNG_SHOP_CART_TXT_STOCK_ERROR
					End Select

					'▣CS판매중지, 가격정보 체크
					arrList_CANNOT_CSGOODS_BUY = "F"
					If DIFFERENT_GOODS_INFO_TXT <> "" Or arrList_GoodsPrice < 1 Or arr_CS_price2 < 1 Then
						arrList_CANNOT_CSGOODS_BUY = "T"
						checkBox_Disabled = " disabled=""disabled"" "
					Else
						arrList_CANNOT_CSGOODS_BUY = "F"
						checkBox_Disabled = ""
					End If

					If arrList_ShopCNT = 1 Then
						k = 1
					Else
						If k = 0 Then
							k = 1
						Else
							k = k
						End If
					End If

				'판매자 정보
				If k = 1 Then
					SQL = "SELECT [strComName] FROM [DK_VENDOR] WITH(NOLOCK) WHERE [strShopID] = ?"
					arrParams2 = Array(Db.makeParam("@strUserID",adVarChar,adParamInput,30,arrList_strShopID))
					txt_strComName = Db.execRsData(SQL,DB_TEXT,arrParams2,Nothing)
					If arrList_strShopID = "company" Then txt_strComName = DKCONF_SITE_TITLE
					If txt_strComName <> "" Then txt_strComName = "<span class=""tright"" style=""font-size:12px;""> ("&txt_strComName&")</span>"
		%>
		<!-- <div class="cart_title_m" style="margin-top:4px;"><%=LNG_SHOP_ORDER_DIRECT_TABLE_01%><%=txt_strComName%></div> -->
		<%End If%>
			<li id="chkboxArea<%=arrList_intIDX%>">
				<input type="hidden" name="cuidx" value="<%=arrList_intIDX%>" readonly="readonly" />
				<input type="hidden" name="isChgGoods" value="<%=arrList_isChgGoods%>" readonly="readonly" />
				<input type="hidden" name="ea" value="<%=arrList_orderEa%>" readonly="readonly" />
				<input type="hidden" name="gIDX" value="<%=arrList_GoodIDX%>" readonly="readonly" />
				<input type="hidden" name="intMinimum" value="<%=arrList_intMinimum%>" readonly="readonly"/>

				<div class="goodsTitle">
					<label>
						<input type="checkbox" name="chkCart" <%=checkBox_Disabled%> attrCG="<%=arrList_isChgGoods%>" attrCode="<%=arr_CS_SELLCODE%>" value="<%=arrList_intIDX%>" />
						<span><i class="icon-ok"></i></span>
					</label>
					<div class="title">
						<h2><%=arrList_goodsName%></h2>
						<%If DK_MEMBER_TYPE = "COMPANY" Then%><%=arr_CS_SellTypeName%><%End If%>
						<%=StockText1%>
					</div>
					<a href="javascript:cartDel('<%=arrList_intIDX%>');" class="cartDel"><i class="icon-close-outline"></i></a>
				</div>
				
				<%=DIFFERENT_GOODS_INFO_TXT%>
				<div class="goodsImg"><%=goodsImg%></div>
				<%If printOPTIONS <> "" Then%>
					<div class="text_noline optionTxtArea"><%=printOPTIONS%></div>
				<%Else%>
					<!-- <div class="text_noline optionTxtArea">옵션없음</div> -->
				<%End If%>

				<div class="goodsTxt">
					<div class="goodsInfo">
						<%If StockText2 <> "" Then%>
							<span class="stock"><%=LNG_SHOP_CART_TXT_STOCK%>&nbsp;<%=StockText2%></span> / 
						<%End If%>
						<h6><%=LNG_TEXT_SELLING_PRICE%></h6>
						<div>
							<span><%=num2cur(selfPrice/arrList_orderEa)%><%=Chg_CurrencyISO%></span> / 
							
							<%If arrList_isCSGoods = "T" And DK_MEMBER_TYPE = "COMPANY"  And DK_MEMBER_STYPE = "0" Then%>
								<span><%=num2curINT(arr_CS_price4)%><%=CS_PV%></span>
							<%End If%>

						</div>
					</div>
					<div class="ea">
						<h6><%=LNG_TEXT_ITEM_NUMBER%></h6>
						<span>
							<input type="text" name="setEa" id="cartEA<%=i%>" class="cartEA" value="<%=arrList_orderEa%>" <%=onlyKeys%> />
							<!-- <input type="button" class="cartEaChg" value="<%=LNG_CS_CART_BTN04%>" onclick="chgCartEa('cartEA<%=i%>','<%=arrList_intIDX%>');" /> -->
							<%If checkBox_Disabled = "" Then%>
							<!-- <input type="button" class="cartEaChg" value="<%=LNG_CS_CART_BTN04%>" onclick="chgCartEa_N('cartEA<%=i%>','<%=arrList_intIDX%>','<%=arrList_orderEa%>','<%=arrList_GoodIDX%>','<%=arrList_intMinimum%>');" /> -->
							<input type="button" class="cartEaChg" value="<%=LNG_CS_CART_BTN04%>" onclick="chgCartEa('<%=arrList_intIDX%>');" />
							<%End If%>
						</span>
					</div>
					<div class="price-total">
						<!-- <h6><%=LNG_SHOP_ORDER_DIRECT_TABLE_14%></h6> -->
						<h6><%=LNG_CS_ORDERS_TOTAL_PRICE%>
						<!-- <%If arrList_isCSGoods = "T" And DK_MEMBER_STYPE = "0" Then%>
							 / <%=LNG_CS_ORDERS_TOTAL_PV%>
						<%End If%> -->
						</h6>

						<p>
							<span><strong><%=num2cur(TOTAL_POINT_PRICE)%></strong><%=Chg_CurrencyISO%></span>
							<%If arrList_isCSGoods = "T" And DK_MEMBER_STYPE = "0" Then%>
								 / <span><strong><%=num2cur(selfPV)%></strong><%=CS_PV%></span>
							<%End If%>
						</p>
					</div>

					<%If arrList_isCSGoods = "T" And DK_MEMBER_STYPE = "0" Then%>
						<!-- <div class="price-type">
							<h6><%=LNG_SHOP_ORDER_DIRECT_PAY_04%></h6>
							<span><%=arr_CS_SellTypeName%></span>
						</div> -->
					<%End If%>
					
					<div class="delivery">
						<h6><%=LNG_SHOP_ORDER_FINISH_11%></h6>
						<div>
							<%
								Select Case arrList_GoodsDeliveryType
									Case "SINGLE"
										printDeliveryFee = arrList_GoodsDeliveryFee
										'printDeliveryTxt = "(단독배송)"
										printDeliveryTxt = "<span class=""single"">"&LNG_SHOP_ORDER_DIRECT_TABLE_08&"</span>"
									Case "AFREE"
										printDeliveryFee = 0
										'printDeliveryTxt = "(무료배송)"
										printDeliveryTxt = "<span class=""afree"">"&LNG_SHOP_ORDER_DIRECT_TABLE_10&"</span>"
									Case "BASIC"
										'▣ 국가별 배송비 설정
										arrParams2 = Array(_
											Db.makeParam("@strNationCode",adVarChar,adParamInput,6,UCase(DK_MEMBER_NATIONCODE)) _
										)
										Set DKRS2 = DB.execRs("HJP_GLOBAL_DELIVERY_FEE_VIEW",DB_PROC,arrParams2,Nothing)
										If Not DKRS2.BOF And Not DKRS2.EOF Then
											DKRS2_intDeliveryFee		= DKRS2("intDeliveryFee")
											DKRS2_intDeliveryFeeLimit	= DKRS2("intDeliveryFeeLimit")
										Else
											Response.Write LNG_SHOP_DETAILVIEW_22
										End If
										Call closeRS(DKRS2)
										If arrList_DELICNT = 1 Then
											'▣ 국가별 배송비 설정
											If TOTAL_POINT_PRICE >= DKRS2_intDeliveryFeeLimit Then
												self_DeliveryFee = "0"
												txt_DeliveryFee = "<span class=""free"">"&LNG_SHOP_ORDER_DIRECT_TABLE_10&"</span>"		'무료배송
												txt_DeliveryFeeType = LNG_SHOP_ORDER_DIRECT_TABLE_10
												txt_DeliveryInfo = "<span class=""free info"">"&LNG_SHOP_ORDER_DIRECT_TABLE_10&"</span>"
											Else
												self_DeliveryFee = DKRS2_intDeliveryFee
												txt_DeliveryFee = "<span class=""prepay"">"&LNG_SHOP_ORDER_DIRECT_TABLE_07&" "&num2cur(self_DeliveryFee)&" "&Chg_currencyISO&"</span>"
												txt_DeliveryFeeType = LNG_SHOP_ORDER_DIRECT_TABLE_07
												txt_DeliveryInfo = "<span class=""same-seller""><strong>"&LNG_SHOP_ORDER_DIRECT_TABLE_11&"</strong> "&num2cur(DKRS2_intDeliveryFeeLimit)&LNG_SHOP_DETAILVIEW_21&"</span>"
											End If

										Else

											arrParams3 = Array(_
												Db.makeParam("@cart_method",adVarChar,adParamInput,10,cart_method), _
												Db.makeParam("@MEMTYPE",adVarChar,adParamInput,50,cart_id), _
												Db.makeParam("@strShopID",adVarChar,adParamInput,30,arrList_strShopID), _
												Db.makeParam("@GoodsDeliveryType",adVarChar,adParamInput,6,arrList_GoodsDeliveryType) _
											)
											arrList3 = Db.execRsList("DKSP_ORDER_DELIVERY_CALC",DB_PROC,arrParams3,listLen3,Nothing)
											self_total_price = 0
											If IsArray(arrList3) Then
												For z = 0 To listLen3
													arrList3_GoodsPrice		= arrList3(0,z)
													arrList3_OrderEa		= arrList3(1,z)
													arrList3_strOption		= arrList3(2,z)
													arrList3_intPriceNot	= arrList3(3,z)
													arrList3_intPriceAuth	= arrList3(4,z)
													arrList3_intPriceDeal	= arrList3(5,z)
													arrList3_intPriceVIP	= arrList3(6,z)

													Select Case DK_MEMBER_LEVEL
														Case 0,1 '비회원, 일반회원
															arrList3_GoodsPrice = arrList3_intPriceNot
														Case 2 '인증회원
															arrList3_GoodsPrice = arrList3_intPriceAuth
														Case 3 '딜러회원
															arrList3_GoodsPrice = arrList3_intPriceDeal
														Case 4,5 'VIP 회원
															arrList3_GoodsPrice = arrList3_intPriceVIP
														Case 9,10,11
															arrList3_GoodsPrice = arrList3_intPriceVIP
													End Select

													'내부 옵션 가격 확인
													calc_optionPrice = 0
													arrResult3 = Split(CheckSpace(arrList3_strOption),",")

													For y = 0 To UBound(arrResult3)
														arrOption3 = Split(Trim(arrResult3(y)),"\")
														calc_optionPrice = Int(calc_optionPrice) + Int(arrOption3(1))
													Next
													self_total_price = self_total_price + (calc_optionPrice * arrList3_OrderEa) + (arrList3_GoodsPrice*arrList3_OrderEa)
												Next
											End If

											'▣ 국가별 배송비 설정
											If TOTAL_POINT_PRICE >= DKRS2_intDeliveryFeeLimit Then
												self_DeliveryFee = "0"
												txt_DeliveryFee = "<span class=""free"">"&LNG_SHOP_ORDER_DIRECT_TABLE_10&"</span>"		'무료배송
												txt_DeliveryFeeType = LNG_SHOP_ORDER_DIRECT_TABLE_10
												txt_DeliveryInfo = "<span class=""free info"">"&LNG_SHOP_ORDER_DIRECT_TABLE_10&"</span>"
											Else
												self_DeliveryFee = DKRS2_intDeliveryFee
												txt_DeliveryFee = "<span class=""prepay"">"&LNG_SHOP_ORDER_DIRECT_TABLE_07&" "&num2cur(self_DeliveryFee)&" "&Chg_currencyISO&"</span>"


												txt_DeliveryFeeType = LNG_SHOP_ORDER_DIRECT_TABLE_07
												txt_DeliveryInfo = "<span class=""same-seller""><strong>"&LNG_SHOP_ORDER_DIRECT_TABLE_11&"</strong> "&num2cur(DKRS2_intDeliveryFeeLimit)&LNG_SHOP_DETAILVIEW_21&"</span>"
											End If

										End If

										printDeliveryTxt = txt_DeliveryInfo

								End Select
							%>
							<!-- <%=num2cur(txt_DeliveryFee)%> <%=printDeliveryTxt%></span> -->
							<%=num2cur(txt_DeliveryFee)%><!-- <%=printDeliveryTxt%> -->
						</div>
					</div>
				</div>

				<div class="porel" style="padding:7px 0px;">
					<!-- <div style="line-height:14px; font-size:12px; padding-left:10px;">* 배송비 묶음 할인 적용중</div> -->
				</div>

			</li>
		<%
					If arrList_ShopCNT = 1 Or arrList_ShopCNT = k Then
						k = 0
					Else
						k = k + 1
					End If

				Next
			Else
		%>
				<div class="tcenter" style="line-height:80px;background:#ffffff;"><%=LNG_CS_CART_TEXT08%></div>
		<%
			End If
		%>


			</ul>



			<div id="Cart_Summary">
				<div style="background-color:#fff; margin-top:40px;"><a class="buys" href="javascript:selectOrder();"><%=LNG_SHOP_CART_TXT_06%></a></div>
			</div>


	</form>



	<form name="dFrm" method="post" action="cart_handler.asp">
		<input type="hidden" name="mode" value="" />
		<input type="hidden" name="cartIDX" value="" />
	</form>

	<form name="mFrm" method="post" action="cart_handler.asp">
		<input type="hidden" name="mode" value="" />
		<input type="hidden" name="cartIDX" value="" />
		<input type="hidden" name="cartEa" value="" />
		<input type="hidden" name="eaORG" value="" />
		<input type="hidden" name="gIDX" value="" />
	</form>

</div>
<!--#include virtual = "/m/_include/copyright.asp"-->