<!--#include virtual="/_lib/strFunc.asp" -->
<%

	PAGE_SETTING = "SHOP"
	ISLEFT = "F"
	ISSUBTOP = "T"
	ISSUBVISUAL = "T"

	'Call ONLY_MEMBER(DK_MEMBER_LEVEL)
	Call ONLY_BUSINESS_MEMBER(DK_MEMBER_LEVEL,1)
%>
<!--#include virtual="/_include/document.asp" -->
<link rel="stylesheet" href="/css/order.css?v0" />
<script type="text/javascript" src="cart.js?v1"></script>
<!--#include virtual = "/shop/cartCalc.js.asp"-->
</head>
<body>
<!--#include virtual="/_include/header.asp" -->
<div id="order" class="cart">
	<form name="cartFrm" method="post" onsubmit="return allOrders(this,'<%=LNG_SHOP_CART_JS_01%>');">
		<input type="hidden" name="mode" readonly="readonly" />
		<input type="hidden" name="uidx" readonly="readonly" />
			<div class="order_title"><%=LNG_HEADER_CART%></div>
			<table <%=tableatt%> class="width100 list goodsInfo">
				<colgroup>
					<col width="30" />
					<col width="100" />
					<col width="*" />
					<col width="50" />
					<col width="180" />
					<col width="110" />
					<col width="180" />
					<col width="170" />
				</colgroup>
				<thead>
					<tr>
						<th><input type="checkbox" name="checklist" onClick="SelectAll()" /></th>
						<th colspan="2"><%=LNG_SHOP_ORDER_DIRECT_TABLE_01%></th>
						<th></th>
						<th><%=LNG_SHOP_ORDER_DIRECT_TABLE_02%></th>
						<th><%=LNG_SHOP_ORDER_DIRECT_TABLE_03%></th>
						<th><%=LNG_SHOP_ORDER_DIRECT_TABLE_04%></th>
						<th><%=LNG_SHOP_ORDER_DIRECT_TABLE_05%></th>
					</tr>
				</thead>
				<%
					If DK_MEMBER_ID <> "" Then
						cart_id = DK_MEMBER_ID
						cart_method = "MEMBER"
					Else
						cart_id = DK_MEMBER_IDX
						cart_method = "NOTMEM"
					End If

					k = 0
					arrParams = Array(_
						Db.makeParam("@cart_method",adVarChar,adParamInput,10,cart_method), _
						Db.makeParam("@MEMTYPE",adVarChar,adParamInput,50,cart_id), _
						Db.makeParam("@strNationCode",adVarChar,adParamInput,6,DK_MEMBER_NATIONCODE) _
					)
					'arrList = Db.execRsList("DKSP_CART_LIST",DB_PROC,arrParams,listLen,Nothing)
					arrList = Db.execRsList("DKP_CART_LIST",DB_PROC,arrParams,listLen,Nothing)		'기존 순서 변경(2021-10-28) arrList_GoodsContent

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
							arrList_strShopID			= arrList(24,i)
							arrList_isShopType			= arrList(25,i)
							arrList_flagNew				= arrList(26,i)
							arrList_isCSGoods			= arrList(27,i)
							arrList_GoodsDeliveryType	= arrList(28,i)
							arrList_GoodsDeliveryFee	= arrList(29,i)
							arrList_SHOPCNT				= Int(arrList(30,i))
							arrList_DELICNT				= Int(arrList(31,i))

							arrList_intPriceNot			= arrList(32,i)
							arrList_intPriceAuth		= arrList(33,i)
							arrList_intPriceDeal		= arrList(34,i)
							arrList_intPriceVIP			= arrList(35,i)
							arrList_intMinNot			= arrList(36,i)
							arrList_intMinAuth			= arrList(37,i)
							arrList_intMinDeal			= arrList(38,i)
							arrList_intMinVIP			= arrList(39,i)
							arrList_intPointNot			= arrList(40,i)
							arrList_intPointAuth		= arrList(41,i)
							arrList_intPointDeal		= arrList(42,i)
							arrList_intPointVIP			= arrList(43,i)

							arrList_isImgType			= arrList(44,i)
							arrList_imgList				= arrList(45,i)
							arrList_CSGoodsCode			= arrList(46,i)
							arrList_GoodsNote			= arrList(47,i)
							arrList_isDirect			= arrList(48,i)
							arrList_DelTF				= arrList(49,i)
							arrList_isAccept			= arrList(50,i)

							arrList_TOTAL_SHOPCNT		= arrList(51,i)	'add

							arrList_OPTIONCNT			= arrList(52,i)		'cart
							arrList_isChgGoods			= arrList(53,i)	'cart



							'##################################################################
							' 회원레벨별 상품가격 변경
							'################################################################## START
							Select Case DK_MEMBER_LEVEL
								Case 0,1 '비회원, 일반회원
									arrList_GoodsPrice = arrList_intPriceNot
									arrList_GoodsPoint = arrList_intPointNot
									arrList_intMinimum = arrList_intMinNot
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
							'##################################################################	END


							'##################################################################
							' 상품 재고상태 확인
							'################################################################## START
							goodsAlert = ""
							StockText = ""
							EA_Display = ""
							If arrList_DelTF = "T" Then goodsAlert = LNG_SHOP_ORDER_WISHLIST_TEXT03
							If arrList_isAccept <> "T" Then goodsAlert = LNG_SHOP_ORDER_DIRECT_06
							If arrList_GoodsViewTF <> "T" Then goodsAlert =	LNG_SHOP_ORDER_DIRECT_05
							If goodsAlert <> "" Then checkBox_Disabled = " disabled=""disabled"" "

							Select Case arrList_GoodsStockType
								Case "I" '무제한
									checkBox_Disabled = ""
									StockStatusText = ""
									StockStatusAlert = ""
								Case "N" '재고
									StockText = LNG_SHOP_CART_TXT_STOCK&":"&arrList_GoodsStockNum
									If arrList_GoodsStockNum < arrList_orderEa Then
										checkBox_Disabled = " disabled=""disabled"" "
										StockStatusText = "<span class=""icon-red"">"&LNG_SHOP_CART_TXT_NO_STOCK&"</span> "
										StockStatusAlert = LNG_SHOP_CART_TXT_OVER_STOCK &" ("&LNG_SHOP_CART_TXT_STOCK&":"&arrList_GoodsStockNum&")"
									End If
								Case "S" '품절
									checkBox_Disabled = " disabled=""disabled"" "
									StockStatusText = "<span class=""icon-red"">"&LNG_SHOP_DETAILVIEW_33&"</span> "
									StockStatusAlert = LNG_SHOP_DETAILVIEW_04
								Case Else '재고이상
									checkBox_Disabled = " disabled=""disabled"" "
									StockStatusText = "<span class=""icon-red"">"&LNG_JS_INVALID_DATA&"</span> "
									StockStatusAlert = LNG_SHOP_CART_TXT_STOCK_ERROR
							End Select

							'1.최소구매수량 확인
							intMinimumText = ""
							intMinimumAlert = ""
							If Int(arrList_orderEa) < Int(arrList_intMinimum)Then
								intMinimumText = "<span class=""icon-red"">"&LNG_SHOP_DETAILVIEW_34&"</span> "
								intMinimumAlert = LNG_SHOP_DETAILVIEW_07 &" ("&LNG_SHOP_DETAILVIEW_34&":"&arrList_intMinimum&")"
								checkBox_Disabled = " disabled=""disabled"" "
							End If
							'##################################################################	END


							'##################################################################
							' 이미지 / 아이콘정보 확인
							'################################################################## START
							If arrList_isImgType = "S" Then
								imgPath = VIR_PATH("goods/thum")&"/"&backword(arrList_imgThum)
								imgWidth = 0
								imgHeight = 0
								Call ImgInfo(imgPath,imgWidth,imgHeight,"")
								imgPaddingH = (upImgHeight_Thum - imgHeight) / 2
							Else
								imgPath = BACKWORD(arrList_imgThum)
								imgWidth = upImgWidths_Thum
								imgHeight = upImgHeight_Thum
								imgPaddingH = 0
							End If

							printGoodsIcon = ""

							If arrList_flagBest	= "T" Then printGoodsIcon = printGoodsIcon & "<span class=""icons"">"&viewImg(IMG_ICON&"/i_bestT.gif",31,11,"")&"</span>"
							If arrList_flagNew	= "T" Then printGoodsIcon = printGoodsIcon & "<span class=""icons"">"&viewImg(IMG_ICON&"/i_newT.gif",31,11,"")&"</span>"
							If arrList_FlagVote	= "T" Then printGoodsIcon = printGoodsIcon & "<span class=""icons"">"&viewImg(IMG_ICON&"/i_voteT.gif",31,11,"")&"</span>"
							If DK_MEMBER_TYPE = "COMPANY" Or DK_MEMBER_TYPE ="ADMIN" Then
								'If arrList_isCSGoods	= "T" Then printGoodsIcon = printGoodsIcon & "<span class=""icons"">"&viewImg(IMG_ICON&"/i_csgoodsT.gif",50,11,"")&"</span>"
							End If
							'################################################################## END


							'##################################################################
							' 루프내 가격 초기화
							'################################################################## START
							self_GoodsOptionPrice = 0
							self_PV = 0
							self_GV = 0

							sum_optionPrice = 0
							'################################################################## END


							'##################################################################
							' CS회원인 경우 PV값 / 상품판매가 확인
							'################################################################## START
							arr_CS_price4 = 0
							arr_CS_SELLCODE		= ""
							arr_CS_SellTypeName = ""
							vipPrice = 0	'COSMICO

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
									arr_CS_price		= DKRS("price")		'소비자가
									arr_CS_price2		= DKRS("price2")
									arr_CS_price4		= DKRS("price4")
									arr_CS_price5		= DKRS("price5")
									arr_CS_price6		= DKRS("price6")		'COSMICO VIP 가
									arr_CS_price7		= DKRS("price7")		'COSMICO 셀러 가
									arr_CS_price8		= DKRS("price8")		'COSMICO 매니저 가
									arr_CS_price9		= DKRS("price9")		'COSMICO 지점장 가
									arr_CS_price10		= DKRS("price10")	'COSMICO 본부장 가

									arr_CS_SellCode		= DKRS("SellCode")
									arr_CS_SellTypeName	= DKRS("SellTypeName")
									If arr_CS_SellTypeName <> "" Then
										arr_CS_SellTypeName = LNG_SHOP_ORDER_DIRECT_PAY_04&" : "&arr_CS_SellTypeName
									End If

									'COSMICO VIP 매출가
									Select Case nowGradeCnt
										Case "20"	vipPrice = arr_CS_price6
										Case "30"	vipPrice = arr_CS_price7
										Case "40"	vipPrice = arr_CS_price8
										Case "50"	vipPrice = arr_CS_price9
										Case "60"	vipPrice = arr_CS_price10
										Case Else vipPrice = 0
									End Select

								End If
								Call closeRs(DKRS)

								'▣ 소비자 가격
								If CONST_CS_SOBIJA_PRICE_USE_TF = "T" Then
									If DK_MEMBER_STYPE = "1" And arrList_isCSGoods = "T" Then
										arrList_GoodsPrice = arrList_GoodsCustomer
										arr_CS_price2 = arr_CS_price
									End If
								End If

								'▣ CS판매금액과 쇼핑몰등록된 CS판매금 비교
								DIFFERENT_GOODS_INFO_TXT = ""
								If arrList_isCSGoods = "T" And (arr_CS_price2 <> arrList_GoodsPrice) Then
									DIFFERENT_GOODS_INFO_TXT = "관리프로그램과 쇼핑몰 등록정보가 다릅니다.(구입불가)"
								End If

								'▣CS판매중지, 가격정보 체크
								If DIFFERENT_GOODS_INFO_TXT <> "" Or (arrList_GoodsPrice < 1) Or (arr_CS_price2 < 1) Then
									checkBox_Disabled = " disabled=""disabled"" "
								End If

							End If
							'################################################################## END

							'##################################################################
							' 옵션확인
							'################################################################## START
							arrResult = Split(CheckSpace(arrList_strOption),",")
							printOPTIONS = ""
							For j = 0 To UBound(arrResult)
								arrOption = Split(Trim(arrResult(j)),"\")
								arrOptionTitle = Split(arrOption(0),":")
								If arrOption(1) > 0 Then
									OptionPrice = " / + " & num2cur(arrOption(1)) &" "&Chg_CurrencyISO
								ElseIf arrOption(1) < 0 Then
									OptionPrice = "/ - " & num2cur(arrOption(1)) &" "&Chg_CurrencyISO
								ElseIf arrOption(1) = 0 Then
									OptionPrice = ""
								End If

								printOPTIONS = printOPTIONS & "<span style='font-size:8pt;color:#9e9e9e;'>["&LNG_SHOP_ORDER_DIRECT_TABLE_06&"] "& arrOptionTitle(0) & " : " & arrOptionTitle(1) & OptionPrice & "</span><br />"
								sum_optionPrice = CDbl(sum_optionPrice) + CDbl(arrOption(1))
							Next
							'################################################################## END

							'##################################################################
							' 상품별 금액/적립금 확인
							'################################################################## START
							self_GoodsPrice = Int(arrList_orderEa) * CDbl(arrList_GoodsPrice)
							self_GoodsPoint = Int(arrList_orderEa) * Int(arrList_GoodsPoint)
							self_GoodsOptionPrice = Int(arrList_orderEa) * CDbl(sum_optionPrice)
							self_TOTAL_PRICE = self_GoodsPrice + self_GoodsOptionPrice
							self_PV = Int(arrList_orderEa) * Int(arr_CS_price4)
							self_GV = Int(arrList_orderEa) * Int(arr_CS_price5)
							'################################################################## END

							'##################################################################
							' 배송비 확인
							'################################################################## START
							Select Case arrList_GoodsDeliveryType
								Case "SINGLE"
									self_DeliveryFee = Int(arrList_orderEa) * CDbl(arrList_GoodsDeliveryFee)
									txt_DeliveryFeeType = LNG_SHOP_ORDER_DIRECT_TABLE_08	'단독배송
									txt_self_DeliveryFee = " "&num2cur(self_DeliveryFee)&" "&Chg_currencyISO
									txt_DeliveryFee = "<span class=""tweight"">"&txt_DeliveryFeeType& "<br />"&txt_self_DeliveryFee&"</span>"
									'*상품별 배송비
									txt_DeliveryFeeEach = "<span class=""deliveryeach"">("&LNG_CS_ORDERS_DELIVERY_PRICE&" "&num2cur(self_DeliveryFee)&" "&Chg_currencyISO&")</span>"
									DKRS2_intDeliveryFee = arrList_GoodsDeliveryFee		'BASIC_DeliveryFee (each)

									arrList_DELICNT = 1

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

									If arrList_DELICNT > 1 Then
										arrParams3 = Array(_
											Db.makeParam("@cart_method",adVarChar,adParamInput,10,cart_method), _
											Db.makeParam("@MEMTYPE",adVarChar,adParamInput,50,cart_id), _
											Db.makeParam("@strShopID",adVarChar,adParamInput,30,arrList_strShopID), _
											Db.makeParam("@GoodsDeliveryType",adVarChar,adParamInput,6,arrList_GoodsDeliveryType) _
										)
										arrList3 = Db.execRsList("DKSP_CART_DELIVERY_CALC",DB_PROC,arrParams3,listLen3,Nothing)
										self_TOTAL_PRICE = 0
										If IsArray(arrList3) Then
											For z = 0 To listLen3
												arrList3_GoodsPrice		= arrList3(0,z)
												arrList3_OrderEa		= arrList3(1,z)
												arrList3_strOption		= arrList3(2,z)

												'내부 옵션 가격 확인
												calc_optionPrice = 0
												arrResult3 = Split(CheckSpace(arrList3_strOption),",")

												For y = 0 To UBound(arrResult3)
													arrOption3 = Split(Trim(arrResult3(y)),"\")
													calc_optionPrice = CDbl(calc_optionPrice) + CDbl(arrOption3(1))
												Next
												self_TOTAL_PRICE = self_TOTAL_PRICE + (calc_optionPrice * arrList3_OrderEa) + (arrList3_GoodsPrice*arrList3_OrderEa)
											Next
										End If
									End If

									If self_TOTAL_PRICE >= DKRS2_intDeliveryFeeLimit Then
										self_DeliveryFee = "0"
										txt_DeliveryFeeType = LNG_SHOP_ORDER_DIRECT_TABLE_10
										txt_self_DeliveryFee = ""
									Else
										self_DeliveryFee = DKRS2_intDeliveryFee
										txt_DeliveryFeeType = ""	'LNG_SHOP_ORDER_DIRECT_TABLE_07	'선결제
										txt_self_DeliveryFee = " "&num2cur(self_DeliveryFee)&" "&Chg_currencyISO
									End If

									If UCase(DK_MEMBER_NATIONCODE) = "KR" Then
										txt_DeliveryFee = "<span class=""tweight"">"&txt_DeliveryFeeType&txt_self_DeliveryFee&"</span><br /><span class=""deliverytotal"">("&num2cur(DKRS2_intDeliveryFeeLimit)&LNG_SHOP_DETAILVIEW_21&")</span>"
									Else
										txt_DeliveryFee = "<span class=""tweight"">"&txt_DeliveryFeeType&txt_self_DeliveryFee&"</span><br /><span class=""deliverytotal"">"&LNG_SHOP_DETAILVIEW_21&" <br />("&num2cur(DKRS2_intDeliveryFeeLimit)&" "&Chg_currencyISO&")</span>"
									End If

									'*상품별 배송비
									If self_GoodsPrice >= DKRS2_intDeliveryFeeLimit Then
										txt_DeliveryFeeEach = "<span class=""deliveryeach"">("&LNG_SHOP_ORDER_DIRECT_TABLE_10&")</span>"		'무료배송
									Else
										txt_DeliveryFeeEach = "<span class=""deliveryeach"">("&LNG_CS_ORDERS_DELIVERY_PRICE&" "&num2cur(DKRS2_intDeliveryFee)&" "&Chg_currencyISO&")</span>"
									End If

							End Select
							'################################################################## END

							trClass = ""
							If arrList_ShopCNT = 1 Then
								rowSpans1 = ""
								k = 1
								PRINT "<tbody>"
							Else
								trClass = " bgC1"
								If k = 0 Then
									k = 1
									rowSpans1 = " rowspan="""&arrList_ShopCNT&""" "
									PRINT "<tbody>"
								Else
									k = k
								End If
							End If
								trClass2 = ""
							If i = listLen Then trClass2 = " lastTR"


							'재고Flag
							If StockStatusText <> "" Then
								txt_DeliveryFee = "-"
								txt_DeliveryFeeEach = "<span class=""tweight"">"&LNG_SHOP_DETAILVIEW_BTN_CANNOT&"<span>"
								EA_Display = "display:none;"

								If arrList_GoodsStockType = "N" And arrList_GoodsStockNum > 0 Then
									txt_DeliveryFeeEach = ""
									EA_Display = ""
								End If
							End If


							'판매자명
							SQLCN = "SELECT [strComName] FROM [DK_VENDOR] WITH(NOLOCK) WHERE [strShopID] = ?"
							arrParamsCN = Array(Db.makeParam("@strUserID",adVarChar,adParamInput,30,arrList_strShopID))
							txt_strComName = Db.execRsData(SQLCN,DB_TEXT,arrParamsCN,Nothing)
							If arrList_strShopID = "company" Then txt_strComName = DKCONF_SITE_TITLE
				%>
				<%
							attrShopIdTOT = arrList_strShopID
							'attrShopID 설정 (단독배송비 구분)
							If arrList_GoodsDeliveryType = "SINGLE" Then
								attrShopID = arrList_strShopID&"_S"&i
							Else
								attrShopID = arrList_strShopID
							End If
				%>
					<tr class="<%=trClass%><%=trClass2%>">
						<td class="tcenter vtop">
							<input type="hidden" name="cuidx" value="<%=arrList_intIDX%>" />
							<input type="hidden" name="isChgGoods" value="<%=arrList_isChgGoods%>" />
							<input type="checkbox" name="chkCart" id="chkCart<%=i%>" <%=checkBox_Disabled%> attrCG="<%=arrList_isChgGoods%>" attrCode="<%=arr_CS_SellCode%>" attrShopID="<%=attrShopID%>" attrShopIdTOT="<%=attrShopIdTOT%>" value="<%=arrList_intIDX%>" onclick="sumAllPrice('<%=i%>');" />
						</td>
						<td class="tcenter vtop">
							<div class="thumImg" style="padding:<%=imgPaddingH%>px 0px;"><a href="/shop/detailView.asp?gidx=<%=arrList_GoodIDX%>" ><%=viewImg(imgPath,imgWidth,imgHeight,"")%></a></div>
							<!-- <div class="newWindow font_dotum font14px"><a href="/shop/detailView.asp?gidx=<%=arrList_GoodIDX%>" target="_blank"><%=LNG_SHOP_CART_TXT_01%></a></div> -->
						</td>
						<td class="vtop">
							<%If printGoodsIcon <> "" Then%>
								<!-- <p><%=printGoodsIcon%></p> -->
							<%End If%>
							<%If goodsAlert <> "" Then%><p><span class="goodsAlert"><%=goodsAlert%></span></p><%End If%>
							<%If DIFFERENT_GOODS_INFO_TXT <> "" Then%><p><span class="goodsAlert"><%=DIFFERENT_GOODS_INFO_TXT%></span></p><%End If%>
							<%If Int(arrList_TOTAL_SHOPCNT) > 1 Then%>
								<p><span class="strComName"><%=txt_strComName%></span></p>
							<%End If%>
							<p><span class="goodsName"><%=backword(arrList_GoodsName)%></span></p>
							<p><span class="goodsNote"><%=backword(arrList_GoodsNote)%></span></p>
							<%If DK_MEMBER_TYPE = "COMPANY" Then%>
								<p><span class="selltypeName"><%=arr_CS_SellTypeName%></span></p>
							<%End If%>
							<%If arrList_OPTIONCNT > 0 Then%>
								<!-- <p><input type="button" class="txtBtnC small border1  radius3" onclick="javascript:popup_chg_option('<%=arrList_intIDX%>');" value="<%=LNG_CS_CART_BTN_CHANGE_OPTION%>" /></div></p> -->
								<%'#modal dialog%>
								<p><a name="modal" id="popvoter" href="/shop/cart_pop_option.asp?idx=<%=arrList_intIDX%>" title="<%=LNG_CS_CART_BTN_CHANGE_OPTION%>"><input type="button" class="txtBtnC small border1 radius3" value="<%=LNG_CS_CART_BTN_CHANGE_OPTION%>" /></a></p>
							<%End If%>
							<%
								'옵션 체크
								If (arrList_strOption = "" And arrList_OPTIONCNT > 0) Or arrList_isChgGoods = "T" Then
							%>
							<p class="font13px"><%=LNG_SHOP_CART_TXT_02%></p>
							<%
								End If
							%>
							<p class="goodsOption"><%=printOPTIONS%></p>
							<%If StockText <> "" Then	'재고%>
								<p class="font13px"><%=StockText%></p>
							<%End If%>
							<%If arrList_intMinimum > 1 Then	'최소구매수량%>
								<p class="font13px"><%=LNG_SHOP_DETAILVIEW_34%> : <%=arrList_intMinimum%></p>
							<%End If%>
						</td>
						<td class="tcenter vtop">
							<a href="javascript: cartDelThis('<%=arrList_intIDX%>','<%=LNG_SHOP_CART_JS_DELETE%>');">&#x2715;</a>
						</td>
						<td class="tright bor_l"><%'상품금액%>
							<%=spans(num2cur(self_GoodsPrice/arrList_orderEa),"#222222","12","400")%><%=spans(""&Chg_currencyISO&"","#222222","11","400")%>
							<%If nowGradeCnt >= 20 And vipPrice > 0 Then 'COSMICO%>
								<br /><%=LNG_VIP%> :  <%=spans(num2cur(vipPrice),"#222222","12","400")%><%=spans(""&Chg_currencyISO&"","#222222","11","400")%>
							<%End If%>
							<%If PV_VIEW_TF = "T" Then%>
							<br /> <%=spans(num2curINT(self_PV/arrList_orderEa),"#f2002e","11","400")%><%=spans(""&CS_PV&"","#ff3300","10","400")%>
							<%End If%>
							<%If BV_VIEW_TF = "T" Then%>
							<br /><%=spans(num2curINT(self_GV/arrList_orderEa),"green","11","400")%><%=spans(""&CS_PV2&"","green","10","400")%>
							<%End If%>
						</td>
						<td class="tcenter bor_l"><%'수량%>
							<div style="<%=EA_Display%>"><span><%=arrList_orderEa%></span></div>
							<input type="hidden" name="ea" value="<%=arrList_orderEa%>" readonly="readonly" />
							<input type="hidden" name="basePrice" value="<%=arrList_GoodsPrice%>" readonly="readonly" />
							<input type="hidden" name="basePV" value="<%=arr_CS_price4%>" readonly="readonly" />
							<input type="hidden" name="baseBV" value="<%=arr_CS_price5%>" readonly="readonly" />

							<input type="hidden" name="DeliveryType" value="<%=arrList_GoodsDeliveryType%>" readonly="readonly" />
							<input type="hidden" name="BASIC_DeliveryFeeLimit" value="<%=DKRS2_intDeliveryFeeLimit%>" readonly="readonly" />
							<input type="hidden" name="BASIC_DeliveryFee" value="<%=DKRS2_intDeliveryFee%>" readonly="readonly" />
							<%If EA_Display = "" Then%>
								<!-- <p><input type="button" class="a_submit2 design8 font12px" onclick="javascript: popup_chg_ea('<%=arrList_intIDX%>');" value="<%=LNG_CS_CART_BTN_CHANGE_EA%>" /></div></p> -->
								<%'#modal dialog%>
								<p><a name="modal" id="popvoter" href="/shop/cart_pop_ea.asp?idx=<%=arrList_intIDX%>" title="<%=LNG_SHOP_CART_TXT_CHG_EA%>"><input type="button" class="a_submit2 design8 font12px" value="<%=LNG_CS_CART_BTN_CHANGE_EA%>"  /></a></p>
							<%End If%>

							<%If StockStatusText <> "" Then '재고Flag%>
								<p><a class="cp" onclick="javascript: alert('<%=StockStatusAlert%>');"><%=StockStatusText%></a></p>
							<%End If%>
							<%If intMinimumText <> "" Then '재고Flag%>
								<p><a class="cp" onclick="javascript: alert('<%=intMinimumAlert%>');"><%=intMinimumText%></a></p>
							<%End If%>
						</td>
						<td class="tright bor_l"><%'총 상품금액%>
							<div style="<%=EA_Display%>">
								<%=spans(num2cur(self_GoodsPrice),"#222222","12","400")%><%=spans(""&Chg_currencyISO&"","#222222","11","400")%>
								<%If nowGradeCnt >= 20 And vipPrice > 0 Then 'COSMICO%>
									<br /><%=LNG_VIP%> :  <%=spans(num2cur(vipPrice * arrList_orderEa),"#222222","12","400")%><%=spans(""&Chg_currencyISO&"","#222222","11","400")%>
								<%End If%>
								<%If PV_VIEW_TF = "T" Then%>
								<br /><%=spans(num2curINT(self_PV),"#f2002e","11","400")%><%=spans(""&CS_PV&"","#ff3300","10","400")%>
								<%End If%>
								<%If BV_VIEW_TF = "T" Then%>
								<br /><%=spans(num2curINT(self_GV),"green","11","400")%><%=spans(""&CS_PV2&"","green","10","400")%>
								<%End If%>
								<!-- <br /><%=viewImgSt(IMG_SHOP&"/icon_point_green.gif",13,15,"","","vmiddle")%>&nbsp;<%=num2cur(self_GoodsPoint)%> 원 -->
								<br />
							</div>
							<%=txt_DeliveryFeeEach%>
						</td>
						<%
							If arrList_DELICNT = 1 Then
								rowSpans2 = ""
								l = 1

							Else
								If l = 0 Then
									l = 1
									rowSpans2 = " rowspan="""&arrList_DELICNT&""" "

								Else
									l = l

								End If
							End If
							If l = 1 Then
						%>
						<td class="tcenter bor_l2 lheight160 lastTD" <%=rowSpans2%>>
							<%=txt_DeliveryFee%>
							<input type="hidden" name="sumPriceShopID" id="sumPriceShopID_<%=attrShopID%>" value="0" readonly="readonly"/>
							<input type="hidden" name="deliveryFeeShopID" id="deliveryFeeShopID_<%=attrShopID%>" value="0" readonly="readonly"/>
							<input type="hidden" name="orderPriceShopID" id="orderPriceShopID_<%=attrShopID%>" value="0" readonly="readonly"/>
							<input type="hidden" name="sumPvShopID" id="sumPvShopID_<%=attrShopID%>" value="0" readonly="readonly"/>
							<input type="hidden" name="sumBvShopID" id="sumBvShopID_<%=attrShopID%>" value="0" readonly="readonly"/>
						</td>
						<%
							End If
						%>
					</tr>
					<%
							If arrList_DELICNT = 1 Or arrList_DELICNT = k Then
								l = 0
							Else
								l = l + 1
							End If

							If arrList_ShopCNT = 1 Or arrList_ShopCNT = k Then
								k = 0
								PRINT "</tbody>"
							Else
								k = k + 1
							End If
					%>
					<%If k = 0 And Int(arrList_TOTAL_SHOPCNT) > 1 Then '업체별 주문합계	%>
						<tr>
							<td colspan="8" class="tcenter sumCartShopArea" >
								<div class="sumCartShop">
										<div class="tweight" ><%=txt_strComName%> 합계</div>
										<div class="sumCart02">
											<span class="pStitle sWidth"><%=LNG_SHOP_ORDER_FINISH_09%></span>
											<span class="pPrice sPrice TOTsumPriceShopID_<%=attrShopIdTOT%>_txt"">0</span>
											<span class="pUnit"><%=Chg_CurrencyISO%></span>
										</div>
										<h2 class="plus"></h2>
										<div class="sumCart02">
											<span class="pStitle sWidth"><%=LNG_CS_ORDERS_DELIVERY_PRICE%></span>
											<span class="pPrice sPrice TOTdeliveryFeeShopID_<%=attrShopIdTOT%>_txt">0</span>
											<span class="pUnit"><%=Chg_CurrencyISO%></span>
										</div>
										<h2 class="equal"></h2>
										<div class="flexColumn">
											<div class="sumCart02">
												<span class="pStitle tWidth"><%=LNG_TOTAL_PAY_PRICE%></span>
												<span class="pPrice sPrice TOTorderPriceShopID_<%=attrShopIdTOT%>_txt">0</span>
												<span class="pUnit"><%=Chg_CurrencyISO%></span>
											</div>
											<%If PV_VIEW_TF = "T" Then%>
											<div class="sumCart03">
												<span class="pStitle tWidth"><%=LNG_CS_ORDERS_TOTAL_PV%></span>
												<span class="pPrice sPrice pv TOTsumPvShopID_<%=attrShopIdTOT%>_txt">0</span>
												<span class="pPrice sPrice bv TOTsumBvShopID_<%=attrShopIdTOT%>_txt">0</span>
												<span class="pvUnit"><%=CS_PV%></span>
											</div>
											<%End If%>
										</div>
										<div></div>
								</div>
							</td>
						</tr>
					<%End if%>
				<%
						Next

					Else
				%>
					<tr>
						<td colspan="8" class="tcenter" style="height:120px;"><%=LNG_CS_CART_TEXT08%></td>
					</tr>
				<%
					End If
				%>
				<tfoot>
					<tr>
						<td colspan="8">
							<input type="button" class="detail_btn purple" value="<%=LNG_CS_CART_BTN01%>" name="checklist_calc" onClick="SelectAll_calc()" />
							<input type="button" class="detail_btn red" value="<%=LNG_SHOP_CART_TXT_04%>" onclick="delAll('<%=LNG_JS_DELETE_ALL%>');" />
							<input type="button" class="detail_btn amber" value="<%=LNG_SHOP_CART_TXT_05%>" onclick="selDEl('<%=LNG_SHOP_ORDER_DIRECT_08%>','<%=LNG_CS_CART_JS02%>');" />
						</td>
					</tr>
				</tfoot>
			</table>

		<%If DK_MEMBER_LEVEL > 0 Then%>
		<div id="fix_menu" class="layout_wrap" style="display: none;">
			<div class="layout_inner">
				<div class="sumCart">
					<div class="flexColumn">
						<div class="sumCart01">
							<span class="pStitle fWidth"><%=LNG_SHOP_CART_01%></span>
							<span class="pISO" id="sumAllCase_txt">0</span>
							<span class="pUnit"><%=LNG_SHOP_CART_02%></span>
						</div>
					</div>
					<i></i>
					<div class="flexColumn">
						<div class="priceArea sumCart02">
							<span class="pStitle sWidth"><%=LNG_SHOP_ORDER_FINISH_09%></span>
							<span class="pISO sPrice" id="sumAllPrice_txt">0</span>
							<span class="pUnit"><%=Chg_CurrencyISO%></span>
						</div>
						<div class="priceArea sumCart02">
							<span class="pStitle sWidth"><%=LNG_CS_ORDERS_DELIVERY_PRICE%></span>
							<span class="pISO sPrice" id="sumAlldeliveryFee_txt">0</span>
							<span class="pUnit"><%=Chg_CurrencyISO%></span>
						</div>
					</div>
					<i></i>
					<div class="flexColumn">
						<div class="priceArea sumCart03">
							<span class="pStitle tWidth"><%=LNG_TOTAL_PAY_PRICE%></span>
							<span class="pPriceT sPrice" id="sumAllorderPrice_txt">0</span>
							<span class="pUnit"><%=Chg_CurrencyISO%></span>
						</div>
						<%If PV_VIEW_TF = "T" Then%>
						<div class="sumCart03">
							<p>
								<span class="pStitle tWidth"><%=LNG_CS_ORDERS_TOTAL_PV%></span>
								<span class="pPriceT sPrice pv" id="sumAllPV_txt">0</span>
								<span class="pvUnit"><%=CS_PV%></span>
							</p>
						<%End If%>
						<%If BV_VIEW_TF = "T" Then%>
							<p>
								<span class="pStitle tWidth"><%=LNG_TOTAL%>&nbsp;BV</span>
								<span class="pPriceT sPrice pv" id="sumAllBV_txt">0</span>
								<span class="pvUnit"><%=CS_PV2%></span>
							</p>
						</div>
						<%End If%>
					</div>
				</div>
			</div>
		</div>
		<%End If%>

		<div class="btnZone">
			<input type="button" class="cancel" onclick="location.href='/shop/index.asp';" value="<%=LNG_SHOP_CART_TXT_07%>"/>
			<input type="button" class="order" onclick="javascript:selectOrder('<%=LNG_SHOP_CART_JS_01%>','<%=LNG_SHOP_CART_JS_02%>','<%=LNG_SHOP_CART_JS_03%>','<%=LNG_CS_CART_JS04%>');" value="<%=LNG_SHOP_CART_TXT_06%>"/>
		</div>

		</form>

		<form name="dFrm" method="post" action="cart_handler.asp">
			<input type="hidden" name="mode" value="" />
			<input type="hidden" name="cartIDX" value="" />
		</form>

</div>

<!--#include virtual="/_include/modal_config.asp" -->
<!--#include virtual="/_include/copyright.asp" -->
