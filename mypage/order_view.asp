<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	Response.Redirect "/myoffice/buy/order_list.asp"

	Call FN_NationCurrency(DK_MEMBER_NATIONCODE,Chg_CurrencyName,Chg_CurrencyISO)

	pT = gRequestTF("pt",False)
	If pt = "" Then pt = ""

	If pT = "shop" Then
		PAGE_SETTING = "SHOP_MYPAGE"
		ORDERNUM_WIDTH ="800"
	Else
		PAGE_SETTING = "MYPAGE"
		ORDERNUM_WIDTH ="750"
	End If

	'PAGE_SETTING = "MYPAGE"
	CATEGORY = "101"
	ISLEFT = "T"
	ISSUBTOP = "T"
	ISSUBVISUAL = "T"
	view = 4
	sview = 2

	Call ONLY_MEMBER(DK_MEMBER_LEVEL)


	orderNum = gRequestTF("orderNum",True)

	If orderNum = "" Then Call ALERTS(LNG_SHOP_ORDER_VIEW_JS01,"back","")
	arrParams = Array(_
		Db.makeParam("@orderNum",adVarChar,adParamInput,20,orderNum), _
		Db.makeParam("@strUserID",adVarChar,adPAramInput,30,DK_MEMBER_ID) _
	)
	Set DKRS = Db.execRS("DKP_ORDER_VIEW",DB_PROC,arrParams,Nothing)
	If Not DKRS.BOF And Not DKRS.EOF Then
		DKRS_intIDX							= DKRS("intIDX")
		DKRS_strDomain						= DKRS("strDomain")
		DKRS_OrderNum						= DKRS("OrderNum")
		DKRS_strIDX							= DKRS("strIDX")
		DKRS_strUserID						= DKRS("strUserID")
		DKRS_payWay							= DKRS("payWay")
		DKRS_totalPrice						= Int(DKRS("totalPrice"))
		DKRS_totalDelivery					= Int(DKRS("totalDelivery"))
		DKRS_totalOptionPrice				= Int(DKRS("totalOptionPrice"))
		DKRS_totalPoint						= Int(DKRS("totalPoint"))
		DKRS_strName						= DKRS("strName")
		DKRS_strTel							= DKRS("strTel")
		DKRS_strMob							= DKRS("strMob")
		DKRS_strEmail						= DKRS("strEmail")
		DKRS_strZip							= DKRS("strZip")
		DKRS_strADDR1						= DKRS("strADDR1")
		DKRS_strADDR2						= DKRS("strADDR2")
		DKRS_takeName						= DKRS("takeName")
		DKRS_takeTel						= DKRS("takeTel")
		DKRS_takeMob						= DKRS("takeMob")
		DKRS_takeZip						= DKRS("takeZip")
		DKRS_takeADDR1						= DKRS("takeADDR1")
		DKRS_takeADDR2						= DKRS("takeADDR2")
		DKRS_orderMemo						= DKRS("orderMemo")
		DKRS_strSSH1						= DKRS("strSSH1")
		DKRS_strSSH2						= DKRS("strSSH2")
		DKRS_status							= DKRS("status")
		DKRS_status100Date					= DKRS("status100Date")
		DKRS_status101Date					= DKRS("status101Date")
		DKRS_status102Date					= DKRS("status102Date")
		DKRS_status103Date					= DKRS("status103Date")
		DKRS_status104Date					= DKRS("status104Date")
		DKRS_status201Date					= DKRS("status201Date")
		DKRS_status301Date					= DKRS("status301Date")
		DKRS_status302Date					= DKRS("status302Date")
		DKRS_DtoDCode						= DKRS("DtoDCode")
		DKRS_DtoDNumber						= DKRS("DtoDNumber")
		DKRS_DtoDDate						= DKRS("DtoDDate")
		DKRS_CancelCause					= DKRS("CancelCause")
		DKRS_bankIDX						= DKRS("bankIDX")
		DKRS_bankingName					= DKRS("bankingName")
		DKRS_usePoint						= Int(DKRS("usePoint"))
		DKRS_totalVotePoint					= Int(DKRS("totalVotePoint"))
		DKRS_PGorderNum						= DKRS("PGorderNum")
		DKRS_PGCardNum						= DKRS("PGCardNum")
		DKRS_PGAcceptNum					= DKRS("PGAcceptNum")
		DKRS_PGinstallment					= DKRS("PGinstallment")
		DKRS_PGCardCode						= DKRS("PGCardCode")
		DKRS_PGCardCom						= DKRS("PGCardCom")
		DKRS_bankingCom						= DKRS("bankingCom")
		DKRS_bankingNum						= DKRS("bankingNum")
		DKRS_bankingOwn						= DKRS("bankingOwn")

	'	DKRS_vBankCode						= DKRS("vBankCode")
	'	DKRS_vBankName						= DKRS("vBankName")
	'	DKRS_vBankAccNum					= DKRS("vBankAccNum")
	'	DKRS_vBankRecvName					= DKRS("vBankRecvName")
	'	DKRS_vBankDepDate					= DKRS("vBankDepDate")
	'	DKRS_vBankAmt						= DKRS("vBankAmt")
	'	DKRS_vBankSetDate					= DKRS("vBankSetDate")
	'	DKRS_vBankTRX						= DKRS("vBankTRX")
	Else
		Call ALERTS(LNG_SHOP_ORDER_FINISH_01,"go","/index.asp")
	End If
	Call closeRS(DKRS)
	If DK_MEMBER_ID <> DKRS_strUserID Then Call alerts(LNG_SHOP_ORDER_FINISH_03,"go","/member_login.asp")


	'CS 주문번호 호출
	SQL2 = "SELECT [OrderNumber] FROM [tbl_SalesDetail] WHERE [ETC2] = '"&LNG_SHOP_ORDER_FINISH_02&":'+ ? "
	arrParams = Array(_
		Db.makeParam("@OrderNum",adVarChar,adParamInput,20,DKRS_OrderNum) _
	)
	Set HJRSC = DB.execRs(SQL2,DB_TEXT,arrParams,DB3)
	If Not HJRSC.BOF And Not HJRSC.EOF Then
		RS_CSOrderNumber   = HJRSC(0)
	Else
		RS_CSOrderNumber   = ""
	End If
	Call closeRS(HJRSC)
%>

<!--#include virtual = "/_include/document.asp"-->
<link rel="stylesheet" href="order_list.css" />
<script type="text/javascript" src="order_list.js"></script>
</head>
<body>
<!--#include virtual="/_include/header.asp" -->
<!--#include virtual="/_include/sub_title.asp" -->
<!-- <div id="subTitle" class="width100">
	<div class="fleft maps_title"><%=LNG_MYPAGE_04_2%></div>
	<div class="fright maps_navi">HOME > <%=LNG_MYPAGE%> > <span class="tweight last_navi"><%=LNG_MYPAGE_04_2%></span></div>
</div> -->
<div id="mypage" class="width100" >
	<div class="orderView cleft">

		<div class="cart_infos" style="width:<%=ORDERNUM_WIDTH%>px;"><%=LNG_SHOP_ORDER_FINISH_05%> <span class="ordNo"><%=DKRS_OrderNum%></span>
			<%If DK_MEMBER_ID = "GUEST" Then%><%=LNG_SHOP_ORDER_FINISH_06%><%End If%>
		</div>
		<%If RS_CSOrderNumber <> "" And DK_MEMBER_TYPE="COMPANY" Then %>
			<div class="cart_infos" style="width:<%=ORDERNUM_WIDTH%>px;"><%=LNG_SHOP_ORDER_FINISH_07%> : <span class="green"><%=RS_CSOrderNumber%></span></div>
		<%End If%>

		<div class="cart_list">
			<!-- <div class="order_title_01"></div> -->
			<div class="order_title"><%=LNG_SHOP_ORDER_DIRECT_TITLE_03%></div>
			<table <%=tableatt%> class="width100 goodsInfo">
				<colgroup>
					<col width="100" />
					<col width="330" />
					<col width="60" />

					<col width="120" />
					<col width="100" />

					<!-- <col width="140" /> -->
					<col width="*" />
				</colgroup>
				<thead>
					<tr>
						<th colspan="2"><%=LNG_SHOP_ORDER_DIRECT_TABLE_01%></th>
						<th><%=LNG_SHOP_ORDER_DIRECT_TABLE_03%></th>
						<th><%=LNG_SHOP_ORDER_DIRECT_TABLE_04%></th>
						<th><%=LNG_SHOP_ORDER_DIRECT_TABLE_24%></th>
						<th><%=LNG_SHOP_ORDER_DIRECT_TABLE_05%></th>
					</tr>
				</thead>
				<tbody>
					<% '상품 정보 출력 '
						k = 0
						arrParams = Array(_
							Db.makeParam("@orderIDX",adInteger,adParamInput,4,DKRS_intIDX) _
						)
						arrList = Db.execRsList("DKP_ORDER_GOODS_VIEW",DB_PROC,arrParams,listLen,Nothing)
						' 상품갯수를 확인하기 위한 반복루프
						'	total_orderEa = 0
						'	SQL = "SELECT sum(orderEa) FROM [DK_ORDER_GOODS] WHERE [orderIDX] = ?"
						'	arrParams = Array(_
						'		Db.makeParam("@orderIDX",adInteger,adParamInput,4,orderIDX) _
						'	)
						'	orderEaData = Db.execRsData(SQL,DB_TEXT,arrParams,Nothing)
						'	total_orderEa = total_orderEa + orderEaData
						'
						'
						'	SQLS2 = "SELECT TOP(1)[GoodsPrice] from [DK_LLIFE_GOODS_DC] WHERE [GoodsCnt] <= ? ORDER BY [GoodsCnt] DESC"
						'	arrParamsS2 = Array(Db.makeParam("@ORderCnt",adInteger,adParamInput,0,(ORderCnt+total_orderEa)))
						'	ThisDCPrice = Db.execRsData(SQLS2,DB_TEXT,arrParamsS2,Nothing)

						If IsArray(arrList) Then
							For i = 0 To listLen
								arrList_intIDX					= arrList(0,i)
								arrList_orderIDX				= arrList(1,i)
								arrList_GoodIDX					= arrList(2,i)
								arrList_strOption				= arrList(3,i)
								arrList_orderEa					= Int(arrList(4,i))
								arrList_orderDtoD				= arrList(5,i)
								arrList_orderDtoDValue			= arrList(6,i)
								arrList_orderDtoDDate			= arrList(7,i)
								arrList_reviewTF				= arrList(8,i)
								arrList_GoodsPrice				= Int(arrList(9,i))
								arrList_goodsOptionPrice		= Int(arrList(10,i))
								arrList_goodsPoint				= Int(arrList(11,i))
								arrList_goodsCost				= Int(arrList(12,i))
								arrList_OrderNum				= arrList(13,i)
								arrList_isShopType				= arrList(14,i)
								arrList_strShopID				= arrList(15,i)
								arrList_GoodsName				= arrList(16,i)
								arrList_ImgThum					= arrList(17,i)
								arrList_GoodsDeliveryType		= arrList(18,i)
								arrList_GoodsDeliveryFeeType	= arrList(19,i)
								arrList_GoodsDeliveryFee		= arrList(20,i)
								arrList_GoodsDeliveryLimit		= arrList(21,i)

								arrList_ShopCNT					= arrList(22,i)
								arrList_DELICNT					= arrList(23,i)

								If Left(LCase(arrList_ImgThum),7) = "http://" Or Left(LCase(arrList_ImgThum),8) = "https://" Then
									imgPath = backword(arrList_ImgThum)
									imgWidth = upImgWidths_Thum
									imgHeight = upImgHeight_Thum
									imgPaddingH = (upImgHeight_Thum - imgHeight) / 2
								Else
									imgPath = VIR_PATH("goods/thum")&"/"&backword(arrList_ImgThum)
									imgWidth = 0
									imgHeight = 0
									Call ImgInfo(imgPath,imgWidth,imgHeight,"")
									imgPaddingH = (upImgHeight_Thum - imgHeight) / 2
									'viewImg(imgPath,imgWidth,imgHeight,"")
								End If

								'CS상품 정보 유무 확인
								SQL4 = "SELECT "
								SQL4 = SQL4 & " [isCSGoods],[CSGoodsCode] "
								SQL4 = SQL4 & " FROM [DK_GOODS] WHERE [intIDX] = ?"
								arrParams4 = Array(_
									Db.makeParam("@GoodIDX",adInteger,adParamInput,4,arrList_GoodIDX) _
								)
								Set DKRS4 = Db.execRs(SQL4,DB_TEXT,arrParams4,Nothing)
								If Not DKRS4.BOF And Not DKRS4.EOF Then
									DKRS4_isCSGoods		= DKRS4("isCSGoods")
									DKRS4_CSGoodsCode	= DKRS4("CSGoodsCode")
								End If
								Call closeRs(DKRS4)

								If DK_MEMBER_TYPE = "COMPANY" Or DK_MEMBER_TYPE ="ADMIN" Then
									If DKRS4_isCSGoods	= "T" Then
'										printGoodsIcon = printGoodsIcon & "<span class=""icons"">"&viewImg(IMG_ICON&"/i_csgoodsT.gif",50,11,"")&"</span>"
										printGoodsIcon = "<span class=""icons"">"&viewImg(IMG_ICON&"/i_csgoodsT.gif",50,11,"")&"</span>"
									End If
								End If


								sum_optionPrice = 0
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
									sum_optionPrice = Int(sum_optionPrice) + Int(arrOption(1))
								Next

								self_GoodsPrice			= arrList_orderEa * arrList_GoodsPrice
								self_GoodsPoint			= arrList_orderEa * arrList_goodsPoint
								self_GoodsOptionPrice	= arrList_orderEa * arrList_goodsOptionPrice
								self_TOTAL_PRICE		= selfPrice + self_optionPrice


								If arrList_GoodsDeliveryType = "SINGLE" Then
								print "DD"
									arrList_DELICNT		= 1
									self_DeliveryFee	= Int(arrList_orderEa) * Int(arrList_GoodsDeliveryFee)
									'txt_DeliveryFee		= "<span class=""tweight"">선결제 "&spans(num2cur(self_DeliveryFee),"#FF6600","","")&"원</span><br /><span class=""f11px lheight130""> 개당 "&num2cur(arrList_GoodsDeliveryFee)&"원<br /> 단독배송상품</span>"
									txt_DeliveryFee = "<span class=""tweight"">"&LNG_SHOP_ORDER_DIRECT_TABLE_07&" "&num2cur(self_DeliveryFee)&" "&Chg_currencyISO&"</span><br /><span class=""f11px lheight130"">"&LNG_SHOP_ORDER_DIRECT_TABLE_11&" <br />"&LNG_SHOP_DETAILVIEW_21&" ("&num2cur(arrList_GoodsDeliveryFee)&" "&Chg_currencyISO&")</span>"
								Else
									If arrList_DELICNT = 1 Then
										If self_TOTAL_PRICE >= arrList_GoodsDeliveryLimit Then
											self_DeliveryFee	= "0"
											'txt_DeliveryFee		= "<span class=""tweight"">"&spans("무료배송","#FF6600","","")&"</span><br /><span class=""f11px lheight130"">묶음배송 상품 <br />"&num2cur(DKRS2_intLimit)&" 원 이상<br /> 무료배송</span>"
											txt_DeliveryFee		= "<span class=""tweight"">"&spans(LNG_SHOP_ORDER_DIRECT_TABLE_10,"#FF6600","","")&"</span><br /><span class=""f11px lheight130"">"&LNG_SHOP_ORDER_DIRECT_TABLE_11&" <br />"&LNG_SHOP_DETAILVIEW_21&" ("&num2cur(arrList_GoodsDeliveryLimit)&" "&Chg_currencyISO&")</span>"
										Else
											self_DeliveryFee	= Int(arrList_GoodsDeliveryFee)
											'txt_DeliveryFee		= "<span class=""tweight"">"&arrList_GoodsDeliveryFeeType&" "&num2cur(self_DeliveryFee)&"원</span><br /><span class=""f11px lheight130"">묶음배송 상품 <br />"&num2cur(arrList_GoodsDeliveryLimit)&" 원 이상<br /> 무료배송</span>"
											txt_DeliveryFee		= "<span class=""tweight"">"&arrList_GoodsDeliveryFeeType&" "&num2cur(self_DeliveryFee)&" "&Chg_currencyISO&"</span><br /><span class=""f11px lheight130"">"&LNG_SHOP_ORDER_DIRECT_TABLE_11&" <br />"&LNG_SHOP_DETAILVIEW_21&" ("&num2cur(arrList_GoodsDeliveryLimit)&" "&Chg_currencyISO&")</span>"
										End If
									Else
										arrParams3 = Array(_
											Db.makeParam("@orderIDX",adInteger,adParamInput,4,DKRS_intIDX), _
											Db.makeParam("@strShopID",adVarChar,adParamInput,30,arrList_strShopID), _
											Db.makeParam("@GoodsDeliveryType",adVarChar,adParamInput,6,arrList_GoodsDeliveryType) _
										)
										arrList3 = Db.execRsList("DKP_ORDER_DELIVERY_CALC",DB_PROC,arrParams3,listLen3,Nothing)
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
													calc_optionPrice = Int(calc_optionPrice) + Int(arrOption3(1))
												Next
												self_TOTAL_PRICE = self_TOTAL_PRICE + (calc_optionPrice * arrList3_OrderEa) + (arrList3_GoodsPrice*arrList3_OrderEa)
											Next
										End If
										If self_TOTAL_PRICE >= arrList_GoodsDeliveryLimit Then
											self_DeliveryFee	= "0"
											'txt_DeliveryFee		= "<span class=""tweight"">"&spans("무료배송","#FF6600","","")&"</span><br /><span class=""f11px lheight130"">묶음배송 상품 <br />"&num2cur(DKRS2_intLimit)&" 원 이상<br /> 무료배송</span>"
											txt_DeliveryFee		= "<span class=""tweight"">"&spans(LNG_SHOP_ORDER_DIRECT_TABLE_10,"#FF6600","","")&"</span><br /><span class=""f11px lheight130"">"&LNG_SHOP_ORDER_DIRECT_TABLE_11&" <br />"&LNG_SHOP_DETAILVIEW_21&" ("&num2cur(arrList_GoodsDeliveryLimit)&" "&Chg_currencyISO&")</span>"
										Else
											self_DeliveryFee	= Int(arrList_GoodsDeliveryFee)
											'txt_DeliveryFee		= "<span class=""tweight"">"&arrList_GoodsDeliveryFeeType&" "&num2cur(self_DeliveryFee)&"원</span><br /><span class=""f11px lheight130"">묶음배송 상품 <br />"&num2cur(arrList_GoodsDeliveryLimit)&" 원 이상<br /> 무료배송</span>"
											txt_DeliveryFee		= "<span class=""tweight"">"&arrList_GoodsDeliveryFeeType&" "&num2cur(self_DeliveryFee)&" "&Chg_currencyISO&"</span><br /><span class=""f11px lheight130"">"&LNG_SHOP_ORDER_DIRECT_TABLE_11&" <br />"&LNG_SHOP_DETAILVIEW_21&" ("&num2cur(arrList_GoodsDeliveryLimit)&" "&Chg_currencyISO&")</span>"
										End If
									End If
								End If






						trClass = ""
						If arrList_ShopCNT = 1 Then
							rowSpans1 = ""
							k = 1
							PRINT "<tbody>"
						Else
							trClass = "bgC1"
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
					%>
					<tr>
						<td align="center" style="padding:13px 10px;"><div class="thumImg" style="padding:<%=imgPaddingH%>px 0px;"><%=viewImg(imgPath,imgWidth,imgHeight,"")%></div></td>
						<td class="subject vtop" style="padding:13px 10px;">
							<p><%=printGoodsIcon%></p>
							<p class="goodsName"><strong><%=backword(arrList_GoodsName)%></strong></p>
							<%If printOPTIONS <> "" Then%>
							<p class="goodsOption"><%=printOPTIONS%></p>
							<%End If%>
						</td>
						<td class="tcenter"><strong><%=arrList_orderEa%></strong> ea</td>
						<td class="tcenter " style="line-height:160%;">
							<!-- 가격 :<strong><%=spans(num2cur(self_GoodsPrice)&" 원","#FF6600","","")%></strong><br />
							옵션 : <%=num2cur(self_GoodsOptionPrice)%> 원
							<br /><%=viewImgSt(IMG_SHOP&"/icon_point_green.gif",13,15,"","","vmiddle")%>&nbsp;<%=num2cur(self_GoodsPoint)%> 원 -->
							<strong><%=spans(num2cur(self_GoodsPrice)&" "&Chg_currencyISO,"#FF6600","","")%></strong>
							<br /><%=viewImgSt(IMG_SHOP&"/icon_point_green.gif",13,15,"","","vmiddle")%>&nbsp;<%=num2cur(self_GoodsPoint)%>&nbsp;<%=Chg_currencyISO%>
						</td>
						<% If k = 1 Then%>
							<td class="tcenter bor_l lheight160 lastTD" <%=rowSpans1%>>
								<%

											SQL = "SELECT [strComName] FROM [DK_DELIVERY_FEE_BY_COMPANY] WHERE [strShopID] = ?"
										arrParams2 = Array(_
											Db.makeParam("@strUserID",adVarChar,adParamInput,30,arrList_strShopID) _
										)
										txt_strComName = Db.execRsData(SQL,DB_TEXT,arrParams2,Nothing)
										PRINT "<strong>"&arrList_strShopID&"</strong><br /><span class=""f11px"">"&txt_strComName&"</span>"

								%>
							</td>
						<%End If%>
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
								print "<td class=""tcenter bor_l lheight160"" "&rowSpans2&">"&txt_DeliveryFee&"</td>"
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
						Next
					End If

					%>
			</table>
		</div>

		<%
			TOTAL_USEPOINT		= DKRS_usePoint
			TOTAL_SUM_PRICE		= DKRS_totalPrice
			TOTAL_PRICE			= DKRS_totalPrice + DKRS_usePoint
			TOTAL_GOODS_PRICE	= DKRS_totalPrice - DKRS_totalOptionPrice - DKRS_totalDelivery + DKRS_usePoint
			'DKRS_totalDelivery
			'DKRS_totalOptionPrice
			'DKRS_totalPoint
			'DKRS_usePoint
		%>
		<div class="cleft width100 TotalArea">
			<div class="AreaZoneWrap"><!-- asdfadfdafasdfasd -->
				<div class="AreaZone" style="width:380px;">
					<div class="PriceArea"><span class="tit"><%=LNG_SHOP_ORDER_DIRECT_TABLE_14%></span><span id="PriceArea"><%=num2cur(TOTAL_PRICE)%></span><span class="won"><%=Chg_CurrencyISO%></span></div>
					<div class="PointArea"><span class="tit"><%=LNG_SHOP_ORDER_DIRECT_TABLE_15%></span><span id="PointArea"><%=num2cur(TOTAL_USEPOINT)%></span><span class="won"><%=Chg_CurrencyISO%></span></div>
					<div class="LastArea"><span class="tit"><%=LNG_SHOP_ORDER_DIRECT_TABLE_16%></span><span id="LastArea"><%=num2cur(TOTAL_SUM_PRICE)%></span><span class="won"><%=Chg_CurrencyISO%></span></div>
				</div>
				<div class="disArea">
					<table <%=tableatt%> class="width100" style="width:380px;">
						<colgroup>
							<col width="120" />
							<col width="280" />
							<col width="*" />
							<col width="300" />
						</colgroup>
						<tbody>
							<tr>
								<td class="bor_l2"><%=LNG_SHOP_ORDER_FINISH_08%></td>
							</tr><tr>
								<td class="bor_l2">
									<table <%=tableatt%> class="width100">
										<col width="30%" />
										<col width="70%" />
										<tr>
											<td>·<%=LNG_SHOP_ORDER_FINISH_09%> : </td>
											<td class="tright"><strong><%=num2cur(TOTAL_GOODS_PRICE)%></strong>&nbsp;<%=Chg_CurrencyISO%></td>
										</tr><tr>
											<td>·<%=LNG_SHOP_ORDER_FINISH_10%> : </td>
											<td class="tright"><strong><%=num2cur(DKRS_totalOptionPrice)%></strong>&nbsp;<%=Chg_CurrencyISO%></td>
										</tr><tr>
											<td>·<%=LNG_SHOP_ORDER_FINISH_11%> : </td>
											<td class="tright"><strong><%=num2cur(DKRS_totalDelivery)%></strong>&nbsp;<%=Chg_CurrencyISO%></td>
										</tr>
									</table>
								</td>
							<%If isSHOP_POINTUSE = "T" Then%>
							<tr>
								<td class="bor_l2 vtop point">
									<table <%=tableatt%> class="width100">
										<col width="30%" />
										<col width="70%" />
										<tr>
											<td>·<%=LNG_SHOP_ORDER_FINISH_12%> : </td>
											<td class="tright"><strong><%=num2cur(DKRS_usePoint)%></strong> &nbsp;<%=Chg_CurrencyISO%></td>
										</tr>
									</table>
								</td>
							</tr>
							<%End If%>
							<tr>
								<td class="bor_l2 summ">
									<table <%=tableatt%> class="width100">
										<col width="30%" />
										<col width="70%" />
										<tr>
											<td colspan="2" class="tweight"><%=LNG_SHOP_ORDER_FINISH_13%></td>
										</tr>
										<%If DK_MEMBER_TYPE ="GUEST" Then%>
										<tr>
											<td>·<%=LNG_SHOP_ORDER_FINISH_14%> : </td>
											<td class="tright"><strong><%=num2cur(DKRS_totalPoint)%></strong>  &nbsp;<%=Chg_CurrencyISO%></td>
										</tr>
										<%Else%>
										<tr>
											<td>·<%=LNG_SHOP_ORDER_FINISH_14%> : </td>
											<td class="tright"><strong><%=num2cur(DKRS_totalPoint)%></strong>  &nbsp;<%=Chg_CurrencyISO%></td>
										</tr><tr>
											<td colspan="2" class="">·<%=LNG_SHOP_ORDER_FINISH_15%></td>
										</tr>
										<%End If%>
									</table>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
			</div>
			<!-- 취소s -->
			<div id="CardInfo" class="width100" style="border-top:1px solid #cdcdcd;">
				<table <%=tableatt%> class="width100">
					<col width="120" />
					<col width="*" />
					<tr>
						<th><%=LNG_SHOP_ORDER_ORDERSTATUS%></th>
						<td><%=CallState(DKRS_status)%></td>
						<td>
							<%
								If DKRS_status = "102" Then
									PRINT "<span class=""button small red""><a href=""javascript:orderFinish('"&DKRS_OrderNum&"')"" class=""red"">"&LNG_SHOP_ORDER_RECEIVE_CONFIRM&"</a></span>"
								End If
							%>
							<%If DKRS_status = "103" Or DKRS_status = "201" Or DKRS_status ="301" Or DKRS_status = "302" Then %>
							<%Else%>
								<span class="button small icon"><span class="refresh"></span><a href="javascript:openOrderCancel('<%=DKRS_intIDX%>')"><%=LNG_STRTEXT_TEXT24_6%></a></span>
							<%End If%>
						</td>
					</tr><tr>
						<th><%=LNG_SHOP_ORDER_ORDERDATE%></th>
						<td><%=DKRS_status100Date%></td>
					</tr>
				</table>
			</div>
			<!-- 취소e -->

		</div>

		<%
			'회원정보 복호화
		'	If DKCONF_SITE_ENC = "T" And DKCONF_ISCSNEW = "T" Then
				Set objEncrypter = Server.CreateObject ("Hyeongryeol.StringEncrypter")
					objEncrypter.Key = con_EncryptKey
					objEncrypter.InitialVector = con_EncryptKeyIV
					On Error Resume Next
						If DKRS_strADDR1	<> "" Then DKRS_strADDR1	= Trim(objEncrypter.Decrypt(DKRS_strADDR1))
						If DKRS_strADDR2	<> "" Then DKRS_strADDR2	= Trim(objEncrypter.Decrypt(DKRS_strADDR2))
						If DKRS_strTel		<> "" Then DKRS_strTel		= Trim(objEncrypter.Decrypt(DKRS_strTel))
						If DKRS_strMob		<> "" Then DKRS_strMob		= Trim(objEncrypter.Decrypt(DKRS_strMob))
						If DKRS_takeADDR1	<> "" Then DKRS_takeADDR1	= Trim(objEncrypter.Decrypt(DKRS_takeADDR1))
						If DKRS_takeADDR2	<> "" Then DKRS_takeADDR2	= Trim(objEncrypter.Decrypt(DKRS_takeADDR2))
						If DKRS_takeTel		<> "" Then DKRS_takeTel		= Trim(objEncrypter.Decrypt(DKRS_takeTel))
						If DKRS_takeMob		<> "" Then DKRS_takeMob		= Trim(objEncrypter.Decrypt(DKRS_takeMob))
						If DKRS_strEmail	<> "" Then DKRS_strEmail	= Trim(objEncrypter.Decrypt(DKRS_strEmail))
						If DKRS_bankingNum	<> "" Then DKRS_bankingNum	= Trim(objEncrypter.Decrypt(DKRS_bankingNum))
						If DKRS_PGAcceptNum	<> "" Then DKRS_PGAcceptNum	= Trim(objEncrypter.Decrypt(DKRS_PGAcceptNum))
					On Error GoTo 0
				Set objEncrypter = Nothing
		'	End If
		%>
		<div class="cleft ordersInfo width100">
			<div class="fleft" style="width:48%">
				<!-- <div class="order_title_03"></div> -->
				<div class="order_title"><%=LNG_SHOP_ORDER_DIRECT_TITLE_04%></div>
				<table <%=tableatt%> class="width100">
					<col width="135" />
					<col width="*" />
					<tbody>
						<tr>
							<th><%=LNG_SHOP_ORDER_DIRECT_TABLE_17%></th>
							<td><%=DKRS_strName%></td>
						</tr><tr>
							<th><%=LNG_SHOP_ORDER_DIRECT_TABLE_18%></th>
							<td><%=DKRS_strTel%></td>
						</tr><tr>
							<th><%=LNG_SHOP_ORDER_DIRECT_TABLE_19%></th>
							<td><%=DKRS_strMob%></td>
						</tr><tr>
							<th><%=LNG_SHOP_ORDER_DIRECT_TABLE_20%></th>
							<td><%=DKRS_strEmail%></td>
						</tr><tr>
							<th><%=LNG_SHOP_ORDER_DIRECT_TABLE_21%></th>
							<td class="zipTD">
								<p><%=DKRS_strZip%></p>
								<p><%=DKRS_strADDR1%></p>
								<p><%=DKRS_strADDR2%></p>
							</td>
						</tr>
					</tbody>
				</table>

			</div>
			<div class="fright" style="width:48%">
				<!-- <div class="order_title_04"></div> -->
				<div class="order_title"><%=LNG_SHOP_ORDER_DIRECT_TITLE_05%></div>
				<table <%=tableatt%> class="width100">
					<col width="135" />
					<col width="*" />
					<tbody>
						<tr>
							<th><%=LNG_SHOP_ORDER_DIRECT_TABLE_17%></th>
							<td><%=DKRS_takeName%></td>
						</tr><tr>
							<th><%=LNG_SHOP_ORDER_DIRECT_TABLE_18%></th>
							<td><%=DKRS_takeTel%></td>
						</tr><tr>
							<th><%=LNG_SHOP_ORDER_DIRECT_TABLE_19%></th>
							<td><%=DKRS_takeMob%></td>
						</tr><tr>
							<th><%=LNG_SHOP_ORDER_DIRECT_TABLE_21%></th>
							<td class="zipTD">
								<p><%=DKRS_takeZip%></p>
								<p><%=DKRS_takeADDR1%></p>
								<p><%=DKRS_takeADDR2%></p>
							</td>
						</tr><tr>
						<th><%=LNG_SHOP_ORDER_DIRECT_TABLE_23%></td>
						<td><%=DKRS_orderMemo%></td>
					</tbody>
				</table>
			</div>
		</div>
		<%
			Select Case LCase(DKRS_PAYWAY)
				Case "inbank"
		%>
			<div class="cleft width100 payment">
				<!-- <div class="order_title_05"></div> -->
				<div class="order_title"><%=LNG_SHOP_ORDER_DIRECT_TITLE_06%></div>
					<div class="width100 selectPay tweight"><%=LNG_SHOP_ORDER_DIRECT_PAY_02%></div>
				<div class="cleft width100 payinfoWrap">
					<div class="fleft" style="width:100%;">
						<div id="BankInfo" class="width100">
							<table <%=tableatt%> class="width100">
								<col width="120" />
								<col width="*" />
								<tr>
									<th><%=LNG_SHOP_ORDER_DIRECT_PAY_13%></th>
									<td><%=DKRS_bankingCom%></td>
								</tr><tr>
									<th><%=LNG_SHOP_ORDER_FINISH_16%></th>
									<td><%=DKRS_bankingNum%></td>
								</tr><tr>
									<th><%=LNG_SHOP_ORDER_FINISH_17%></th>
									<td><%=DKRS_bankingOwn%></td>
								</tr><tr>
									<th><%=LNG_SHOP_ORDER_DIRECT_PAY_14%></th>
									<td><%=DKRS_bankingName%></td>
								</tr>
							</table>
						</div>
					</div>

				</div>
			</div>
		<%
			Case "card"
		%>
			<div class="cleft width100 payment">
				<div class="order_title_05"></div>
				<div class="width100 selectPay"><%=LNG_SHOP_ORDER_DIRECT_PAY_01%></div>
				<div class="cleft width100 payinfoWrap">
					<div class="fleft" style="width:100%;">
						<div id="CardInfo" class="width100">
							<table <%=tableatt%> class="width100">
								<col width="120" />
								<col width="*" />
								<tr>
									<th><%=LNG_SHOP_ORDER_FINISH_19%></th>
									<td><%=DKFD_PGCOMPANY%> (<a href="<%=PGCOMURL%>" target="_blank"><%=PGCOMURL%></a>)</td>
								</tr><tr>
									<th><%=LNG_SHOP_ORDER_FINISH_20%></th>
									<td><%=DKRS_PGCardCode%> (<%=FN_INICIS_CARDCODE_VIEW(DKRS_PGCardCode)%>)</td>
								</tr>
								<%IF UCASE(DKFD_PGCOMPANY) <> "DAOU" Then%>
								<tr>
									<th><%=LNG_SHOP_ORDER_FINISH_21%></th>
									<td><%=DKRS_PGCardNum%></td>
								</tr><tr>
									<th><%=LNG_SHOP_ORDER_FINISH_22%></th>
									<td><%=DKRS_PGinstallment%></td>
								</tr>
								<%End If%>
								<tr>
									<th><%=LNG_SHOP_ORDER_FINISH_23%></th>
									<td><%=DKRS_PGAcceptNum%></td>
								</tr>
							</table>
						</div>
					</div>
				</div>
			</div>
	<%
		Case "vbank"

		'DKRS_vBankCode    						= DKRS("vBankCode")
		'DKRS_vBankName    						= DKRS("vBankName")
		'DKRS_vBankAccNum  						= DKRS("vBankAccNum")
		'DKRS_vBankRecvName						= DKRS("vBankRecvName")
		'DKRS_vBankDepDate 						= DKRS("vBankDepDate")
		'DKRS_vBankAmt     						= DKRS("vBankAmt")
		'DKRS_vBankSetDate 						= DKRS("vBankSetDate")
		'DKRS_vBankTRX     						= DKRS("vBankTRX")

	%>
		<div class="cleft width100 payment">
			<div class="order_title_05"></div>
			<div class="width100 selectPay"><%=LNG_SHOP_ORDER_FINISH_24%></div>
			<div class="cleft width100 payinfoWrap">
				<div class="fleft width100">
					<div id="CardInfo" class="width100">
						<table <%=tableatt%> class="width100">
							<col width="120" />
							<col width="*" />
							<tr>
								<th><%=LNG_SHOP_ORDER_FINISH_19%></th>
								<td><%=DKFD_PGCOMPANY%> (<a href="<%=PGCOMURL%>" target="_blank"><%=PGCOMURL%></a>)</td>
							</tr><tr>
								<th><%=LNG_SHOP_ORDER_DIRECT_PAY_13%></th>
								<td><%=FN_INICIS_BANKCODE_VIEW(DKRS_PGinstallment)%></td>
							</tr><tr>
								<th><%=LNG_SHOP_ORDER_FINISH_16%></th>
								<td><%=DKRS_PGCardNum%></td>
							</tr><tr>
								<th><%=LNG_SHOP_ORDER_DIRECT_PAY_14%></th>
								<td><%=DKRS_PGAcceptNum%></td>
							</tr><tr>
								<th><%=LNG_SHOP_ORDER_FINISH_25%></th>
								<td><%=DKRS_PGCardCode%></td>
							</tr>
						</table>
					</div>
				</div>

			</div>
		</div>
	<%
		Case "dbank"
	%>
		<div class="cleft width100 payment">
			<div class="order_title_05"></div>
			<div class="width100 selectPay"><%=LNG_SHOP_ORDER_FINISH_26%></div>
			<div class="cleft width100 payinfoWrap">
				<div class="fleft" style="width:65%;">
					<div id="CardInfo" class="width100">
						<table <%=tableatt%> class="width100">
							<col width="120" />
							<col width="*" />
							<tr>
								<th><%=LNG_SHOP_ORDER_FINISH_19%></th>
								<td><%=DKFD_PGCOMPANY%> (<a href="<%=PGCOMURL%>" target="_blank"><%=PGCOMURL%></a>)</td>
							</tr><tr>
								<th><%=LNG_SHOP_ORDER_FINISH_27%></th>
								<td><%=FN_INICIS_BANKCODE_VIEW(DKRS_PGCardCom)%></td>
							</tr>
						</table>
					</div>
				</div>
				<div class="fleft" style="width:35%;">
					<div class="cleft width100 cart_btn">
						<p style="width:80%; margin:0px auto; margin-top:40px;"><span style="color:#d75623; line-height:16px;"></span></p>
					</div>
				</div>
			</div>
		</div>
	<%
		End Select
	%>




	</div>
	<%
		If pT = "shop" Then
			ptshop = "?pt=shop"
		Else
			ptshop = ""
		End If
	%>
	<div style="clear:both; float:left; width:100%; text-align:center;margin-top:30px;height:80px;">
		<a href="/mypage/order_list.asp<%=ptshop%>"><input type="button" class="txtBtnC large tshadow1 radius5 red2" style="width:170px;" value="<%=LNG_SHOP_ORDER_FINISH_28%>"/></a>
		<span class="pL10"><a href="/shop"><input type="button" class="txtBtnC large radius5 gray border1" style="width:170px;" onclick="location.href='/shop/index.asp';" value="<%=LNG_SHOP_ORDER_FINISH_29%>"/></a></span>
	</div>
	<!-- <div style="clear:both; float:left; width:100%; text-align:center;margin-top:30px;">
		<%=aImgOpt("/mypage/order_list.asp","S",IMG_SHOP&"/goMypage.gif",200,42,"","")%>
		<%=aImgOpt("/shop","S",IMG_SHOP&"/goShopMain.gif",200,42,"","style=""margin-left:5px;""")%>
	</div> -->

</div>


<!--#include virtual = "/_include/copyright.asp"-->
