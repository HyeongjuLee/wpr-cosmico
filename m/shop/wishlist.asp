<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	Call FN_NationCurrency(DK_MEMBER_NATIONCODE,Chg_CurrencyName,Chg_CurrencyISO)
	Call ONLY_BUSINESS_MEMBER(DK_MEMBER_LEVEL,1)

Call ALERTS(LNG_ALERT_WRONG_ACCESS,"back","")


	'위시리스트
	PAGE_SETTING = "SHOP"

	'Call ONLY_MEMBER(DK_MEMBER_LEVEL)


	Dim PAGE			:	PAGE = Request("PAGE")
	PAGESIZE = 20
	If PAGE = "" Then	PAGE = 1




%>
<!--#include virtual = "/m/_include/document.asp"-->
<!--#include virtual = "/m/_include/jqueryload.asp"-->
<script type="text/javascript">
	function wishDel(idx) {
		var f = document.dFrm;
		//if (confirm('해당 상품을 삭제하시겠습니까?'))
		if (confirm('<%=LNG_SHOP_CART_JS_DELETE%>'))
		{
			f.cartIDX.value = idx;
			f.submit();
		}
	}

function selectOrder() {
	var f = document.cartFrm
	var i,len;
	var objCbList = f.chkCart;
	var objCart = f.cuidx;
	var objEa = f.ea;
	var selCnt = 0;

	if (typeof objCart == "undefined") {
		//alert("장바구니에 담으실 상품이 없습니다.");
		alert("<%=LNG_SHOP_ORDER_WISHLIST_JS02%>");
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
		//alert("장바구니에 담을 상품을 선택해 주세요.");
		alert("<%=LNG_SHOP_ORDER_WISHLIST_JS03%>");
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
	f.action = "wishlist_cart.asp";
	f.submit();
}


</script>
</head>
<body onUnload="">
<!--#include virtual = "/m/_include/header.asp"-->
<!--#include virtual = "/m/_include/sub_header.asp"-->
<div id="WishList" class="width100 cleft">
	<div id="subTitle" class="width100 tcenter text_noline" ><%=LNG_MYPAGE_WISHCART%></div>

	<form name="cartFrm" method="post" action="wishlist_cart.asp" >
		<input type="hidden" name="uidx" />
		<input type="hidden" name="ea" />
		<%
			arrParams = Array(_
				Db.makeParam("@strUserID",adVarChar,adParamInput,20,DK_MEMBER_ID), _
				Db.makeParam("@PAGE",adInteger,adParamInput,4,PAGE), _
				Db.makeParam("@PAGESIZE",adInteger,adParamInput,4,PAGESIZE), _
				Db.makeParam("@ALL_COUNT",adInteger,adParamOutPut,4,0) _
			)
			arrList = Db.execRsList("DKP_WISHLIST_E",DB_PROC,arrParams,listLen,Nothing)
			'arrList = Db.execRsList("DKP_WISHLIST",DB_PROC,arrParams,listLen,Nothing)
			ALL_COUNT = arrParams(Ubound(arrParams))(4)

			Dim PAGECOUNT,CNT
			PAGECOUNT = Int((CCur(ALL_COUNT) - 1 ) / CInt(PAGESIZE) ) + 1
			IF CCur(PAGE) = 1 Then
				CNT = ALL_COUNT
			Else
				CNT = ALL_COUNT - ((CCur(PAGE)-1)*CInt(PAGESIZE)) '
			End If

			If IsArray(arrList) Then
				For i = 0 To listLen
					arrList_intIDX				= arrList(1,i)
					arrList_goodsIDX			= arrList(2,i)
					arrList_Category			= arrList(3,i)
					arrList_DelTF				= arrList(4,i)
					arrList_GoodsName			= arrList(5,i)
					arrList_GoodsComment		= arrList(6,i)

					arrList_GoodsViewTF			= arrList(7,i)
					arrList_flagBest			= arrList(8,i)
					arrList_flagNew				= arrList(9,i)
					arrList_FlagVote			= arrList(10,i)
					arrList_strShopID			= arrList(11,i)

					arrList_ImgThum				= arrList(12,i)
					arrList_isViewMemberNot		= arrList(13,i)
					arrList_isViewMemberAuth	= arrList(14,i)
					arrList_isViewMemberDeal	= arrList(15,i)
					arrList_isViewMemberVIP		= arrList(16,i)

					arrList_intPriceNot			= arrList(17,i)
					arrList_intPriceAuth		= arrList(18,i)
					arrList_intPriceDeal		= arrList(19,i)
					arrList_intPriceVIP			= arrList(20,i)

					arrList_intPointNot 		= arrList(21,i)
					arrList_intPointAuth		= arrList(22,i)
					arrList_intPointDeal		= arrList(23,i)
					arrList_intPointVIP 		= arrList(24,i)
					arrList_isImgType 			= arrList(25,i)

					arrList_imgList				= arrList(26,i)
					arrList_isCSGoods			= arrList(27,i)
					arrList_CSGoodsCode			= arrList(28,i)
					arrList_GoodsDeliveryType	= arrList(29,i)
					arrList_GoodsDeliveryFee	= arrList(30,i)

					arrList_GoodsStockType		= arrList(31,i)
					arrList_GoodsStockNum		= arrList(32,i)

					arrList_GoodsCustomer		= arrList(33,i)		'소비자가

					gView = "F"

					Select Case DK_MEMBER_LEVEL
						Case 0,1 '비회원, 일반회원
							arrList_GoodsPrice = arrList_intPriceNot
							arrList_GoodsPoint = arrList_intPointNot
							If arrList_isViewMemberNot = "T" Then gView = "T"
						Case 2 '인증회원
							arrList_GoodsPrice = arrList_intPriceAuth
							arrList_GoodsPoint = arrList_intPointAuth
							If arrList_isViewMemberNot = "T" Then gView = "T"
						Case 3 '딜러회원
							arrList_GoodsPrice = arrList_intPriceDeal
							arrList_GoodsPoint = arrList_intPointDeal
							If arrList_isViewMemberNot = "T" Then gView = "T"
						Case 4,5 'VIP 회원
							arrList_GoodsPrice = arrList_intPriceVIP
							arrList_GoodsPoint = arrList_intPointVIP
							If arrList_isViewMemberNot = "T" Then gView = "T"
						Case 9,10,11
							arrList_GoodsPrice = arrList_intPriceVIP
							arrList_GoodsPoint = arrList_intPointVIP
							gView = "T"
					End Select

			'▣소비자 가격(2018-05-18)
			If DK_MEMBER_STYPE = "1" And arrList_isCSGoods = "T" Then
				arrList_GoodsPrice	 = arrList_GoodsCustomer
			End If

					Select Case arrList_GoodsStockType
						Case "I" '무제한'
							checkBox_Disabled = ""
							StockText1 = ""
							StockText2 = ""
						Case "S" '품절'
							checkBox_Disabled = " disabled=""disabled"" "
							StockText1 = "<span class=""red"">["&LNG_SHOP_DETAILVIEW_33&"]</span> "
						Case Else '이상제품
							checkBox_Disabled = " disabled=""disabled"" "
							StockText1 = "<span class=""red"">["&LNG_SHOP_ORDER_WISHLIST_STOCK_ERROR&"]</span> "
					End Select




					If arrList_isImgType = "S" Then
						'imgPath = VIR_PATH("goods/list")&"/"&arrList_imgList
						imgPath = VIR_PATH("goods/thum")&"/"&backword(arrList_ImgThum)
						goodsImg = "<img src="""&imgPath&""" width=""100%"" alt="""" />"
					Else
						goodsImg = "<img src="""&backword(arrList_imgList)&""" width=""100%"" alt="""" />"
					End If

					arr_CS_price4 = 0
					arr_CS_SELLCODE		= ""
					arr_CS_SellTypeName = ""
					'If arrList_isCSGoods = "T" And DK_MEMBER_STYPE = "0" Then
					If arrList_isCSGoods = "T" Then
						'▣CS상품정보 변동정보 통합
						arrParams = Array(_
							Db.makeParam("@Na_Code",adVarChar,adParamInput,50,UCase(DK_MEMBER_NATIONCODE)), _
							Db.makeParam("@ncode",adVarChar,adParamInput,20,arrList_CSGoodsCode) _
						)
						Set DKRS = Db.execRs("HJP_CSGOODS_PRICE_INFO_GLOBAL",DB_PROC,arrParams,DB3)
						'Set DKRS = Db.execRs("HJP_CSGOODS_PRICE_INFO",DB_PROC,arrParams,DB3)
						If Not DKRS.BOF And Not DKRS.EOF Then
							arr_CS_ncode		= DKRS("ncode")
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

				%>
				<div>
					<div class="index_v_goods porel">
						<div class="chkboxArea tweight text_noline" style="height:40px;text-indent:15px; font-size:15px; color:#444; line-height:40px; margin-right:45px;">
							<input type="hidden" name="cuidx" value="<%=arrList_intIDX%>" />
							<input type="hidden" name="isChgGoods" value="<%=arrList_isChgGoods%>" />
							<input type="hidden" name="ea" class="input_text" style="width:25px;" value="<%=arrList_orderEa%>" />
							<label style="cursor:pointer;"><input type="checkbox" name="chkCart" attrCG="<%=arrList_isChgGoods%>" value="<%=arrList_intIDX%>" style="margin:0px; height:0px; vertical-align:middle; height:20px; width:20px;" <%=checkBox_Disabled%> /> <%=StockText1%> <%=arrList_goodsName%></label>
							<div style="position:absolute; text-indent:0px; padding:0px; right:5px; display:inline-block; text-align:center;width:30px; height:30px; margin-top:5px;">
								<a href="javascript:wishDel('<%=arrList_intIDX%>');" style="display:block;margin:0px; border-color:#ccc;width:30px; height:30px; line-height:30px;">X</a>
							</div>
						</div>
						<div class="porel goodsArea">
							<div class="poabs ImgArea"><%=goodsImg%></div>
							<div class="porel" style="margin-left:110px; min-height:100px; padding:10px 0px;">
								<div style="">
									<div style="width:100%;"></div>
									<%If printOPTIONS <> "" Then%>
										<div class="text_noline optionTxtArea"><%=printOPTIONS%></div>
									<%Else%>
										<!-- <div class="text_noline optionTxtArea">옵션없음</div> -->
									<%End If%>


									<div class="porel CartInfoArea" style="margin-top:10px; ">
										<table <%=tableatt%> class="width100">
											<col width="55" />
											<col width="20" />
											<col width="*" />
											<tr>
												<td colspan="3" class="tdTitle"><%=arrList_GoodsComment%></td>
											</tr><tr>
												<td class="tdTitle"><%=LNG_SHOP_ORDER_FINISH_09%><!-- 상품가 --></td>
												<td class="">:</td>
												<td class="sellPrice"><%=num2cur(arrList_GoodsPrice)%> <span class="s_kor"><%=Chg_CurrencyISO%></span></td>
											</tr><tr>
												<td class="tdTitle"><%=LNG_SHOP_ORDER_FINISH_11%><!-- 배송비 --></td>
												<td class="">:</td>
												<td class="sellOptPrice">
													<%
														Select Case arrList_GoodsDeliveryType
															Case "SINGLE"
																printDeliveryFee = arrList_GoodsDeliveryFee
																printDeliveryTxt = "("&LNG_SHOP_ORDER_DIRECT_TABLE_08&")"	'(단독배송)
															Case "AFREE"
																printDeliveryFee = 0
																printDeliveryTxt = "("&LNG_SHOP_ORDER_DIRECT_TABLE_10&")"	'(무료배송)
															Case "BASIC"
																arrParams2 = Array(_
																	Db.makeParam("@strShopID",adVarChar,adParamInput,30,arrList_strShopID) _
																)
																Set DKRS2 = DB.execRs("DKP_DELIVERY_FEE_VIEW",DB_PROC,arrParams2,Nothing) 'DKPA_DELIVEY_FEE_VIEW
																If Not DKRS2.BOF And Not DKRS2.EOF Then
																	DKRS2_FeeType			= DKRS2("FeeType")
																	DKRS2_intFee			= DKRS2("intFee")
																	DKRS2_intLimit			= DKRS2("intLimit")

																	'PRINT printDeli(DKRS2_FeeType)

																	Select Case LCase(DKRS2_FeeType)
																		Case "free"
																			printDeliveryFee = 0
																			printDeliveryTxt = "("&LNG_SHOP_ORDER_DIRECT_TABLE_10&")"	'(무료배송)
																		Case "prev"
																			printDeliveryFee = DKRS2_intFee
																			printDeliveryTxt = "("&LNG_STRTEXT_TEXT19_2&")"	'(선불결제)
																		Case "next"
																			printDeliveryFee = DKRS2_intFee
																			printDeliveryTxt = "("&LNG_STRTEXT_TEXT19_1&")"	'(착불결제)
																	End Select
																Else
																	printDeliveryFee = 0
																	printDeliveryTxt = ""
																End If

														End Select
													%>
													<%=num2cur(printDeliveryFee)%> <span class="s_kor"><%=Chg_CurrencyISO%> <%=printDeliveryTxt%></span>
												</td>
											</tr>
											<%If arrList_isCSGoods = "T" And DK_MEMBER_STYPE = "0" Then%>
											<!-- <tr>
												<td class="tdTitle"><%=CS_PV%></td>
												<td class="">:</td>
												<td class="sellPV"><%=num2cur(arr_CS_price4)%> <%=CS_PV%></td>
											</tr> -->
											<%End If%>
										</table>
									</div>
								</div>
							</div>
						</div>
						<div class="porel" style="padding:7px 0px;">
							<!-- <div style="line-height:14px; font-size:12px; padding-left:10px;">* 배송비 묶음 할인 적용중</div> -->
						</div>

					</div>
				</div>

			<%

					Next
				Else
			%>
			<div style="padding:40px;" class="tweight tcenter"><%=LNG_SHOP_NOT_DATA_TXT_01%></div>
			<%
				End If
			%>
			<div id="Cart_Summary">
				<div style="background-color:#fff; margin-top:40px;"><a class="buys" href="javascript:selectOrder();"><%=LNG_SHOP_CART_TXT_06%></a></div>
			</div>






	</form>

	<form name="dFrm" method="post" action="wishlist_del.asp">
		<input type="hidden" name="cartIDX" value="" />
	</form>

</div>




<!--#include virtual = "/m/_include/copyright.asp"-->