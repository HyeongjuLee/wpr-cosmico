<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	Call ONLY_MEMBER(DK_MEMBER_LEVEL)

	PAGE_SETTING = "SHOP"
	SHOP_MYPAGE	="T"

	CATEGORY = "101"
	ISLEFT = "T"
	ISSUBTOP = "T"
	ISSUBVISUAL = "T"
	view = 4


	orderNum = gRequestTF("orderNum",True)

	If orderNum = "" Then Call ALERTS("주문정보가 옳바르지 않습니다.1","back","")
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
	Else
		Call ALERTS("주문정보가 옳바르지 않습니다.2","go","/index.asp")
	End If
	Call closeRS(DKRS)
	If DK_MEMBER_ID <> DKRS_strUserID Then Call alerts("주문자와 현재 로그인된 회원이 틀립니다.","go","/member_login.asp")

%>

<!--#include virtual = "/_include/document.asp"-->
<link rel="stylesheet" href="order_list.css" />
<script type="text/javascript" src="order_list.js"></script>
</head>
<body>
<!--#include virtual="/_include/header.asp" -->
<div id="subTitle" class="" style="margin-left:20px;">
	<div class="fleft maps_title"><img src="<%=IMG_MYPAGE%>/tit_orderlist.png" alt="" /></div>
	<div class="fright maps_navi">SHOP > 마이페이지 > <span class="tweight last_navi">주문/배송조회 : 상세보기</span></div>
</div>

<div id="mypage" class="width 100" style="margin-left:20px;">
	<div class="orderView cleft">

	<div class="cart_infos">고객님의 주문번호는 <span class="ordNo"><%=DKRS_OrderNum%></span> 입니다.
		<%If DK_MEMBER_ID = "GUEST" Then%>비회원님은 주문번호를 반드시 기억해주세요. (잊어버리시면 주문조회를 하실 수 없습니다.)<%End If%>
	</div>


		<div class="cart_list">
			<div class="order_title_01"></div>
			<table <%=tableatt%> class="width100 goodsInfo">
				<colgroup>
					<col width="80" />
					<col width="310" />
					<col width="50" />

					<col width="100" />
					<col width="80" />

					<col width="120" />
					<col width="60" />
				</colgroup>
				<thead>
					<tr>
						<th colspan="2">상품정보</th>
						<th>수량</th>
						<th>금액정보</th>

						<th>판매자</th>
						<th>배송비</th>
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
										OptionPrice = " / + " & num2cur(arrOption(1)) &" 원"
									ElseIf arrOption(1) < 0 Then
										OptionPrice = "/ - " & num2cur(arrOption(1)) &" 원"
									ElseIf arrOption(1) = 0 Then
										OptionPrice = ""
									End If
									printOPTIONS = printOPTIONS & "<span style='font-size:8pt;color:#9e9e9e;'>[옵션] "& arrOptionTitle(0) & " : " & arrOptionTitle(1) & OptionPrice & "</span><br />"
									sum_optionPrice = Int(sum_optionPrice) + Int(arrOption(1))
								Next

								self_GoodsPrice			= arrList_orderEa * arrList_GoodsPrice
								self_GoodsPoint			= arrList_orderEa * arrList_goodsPoint
								self_goodsOptionPrice	= arrList_orderEa * arrList_goodsOptionPrice
								self_TOTAL_PRICE		= selfPrice + self_optionPrice


								If arrList_GoodsDeliveryType = "SINGLE" Then
									arrList_DELICNT		= 1
									self_DeliveryFee	= Int(arrList_orderEa) * Int(arrList_GoodsDeliveryFee)
									txt_DeliveryFee		= "<span class=""tweight"">선결제 "&spans(num2cur(self_DeliveryFee),"#FF6600","","")&"원</span><br /><span class=""f11px lheight130""> 개당 "&num2cur(arrList_GoodsDeliveryFee)&"원<br /> 단독배송상품</span>"

								Else
									If arrList_DELICNT = 1 Then
										If self_TOTAL_PRICE >= arrList_GoodsDeliveryLimit Then
											self_DeliveryFee	= "0"
											txt_DeliveryFee		= "<span class=""tweight"">"&spans("무료배송","#FF6600","","")&"</span><br /><span class=""f11px lheight130"">묶음배송 상품 <br />"&num2cur(DKRS2_intLimit)&" 원 이상<br /> 무료배송</span>"
										Else
											self_DeliveryFee	= Int(arrList_GoodsDeliveryFee)
											txt_DeliveryFee		= "<span class=""tweight"">"&arrList_GoodsDeliveryFeeType&" "&num2cur(self_DeliveryFee)&"원</span><br /><span class=""f11px lheight130"">묶음배송 상품 <br />"&num2cur(arrList_GoodsDeliveryLimit)&" 원 이상<br /> 무료배송</span>"
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
											txt_DeliveryFee		= "<span class=""tweight"">"&spans("무료배송","#FF6600","","")&"</span><br /><span class=""f11px lheight130"">묶음배송 상품 <br />"&num2cur(DKRS2_intLimit)&" 원 이상<br /> 무료배송</span>"
										Else
											self_DeliveryFee	= Int(arrList_GoodsDeliveryFee)
											txt_DeliveryFee		= "<span class=""tweight"">"&arrList_GoodsDeliveryFeeType&" "&num2cur(self_DeliveryFee)&"원</span><br /><span class=""f11px lheight130"">묶음배송 상품 <br />"&num2cur(arrList_GoodsDeliveryLimit)&" 원 이상<br /> 무료배송</span>"
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
							가격 :<strong><%=spans(num2cur(self_GoodsPrice)&" 원","#FF6600","","")%></strong><br />
							옵션 : <%=num2cur(self_goodsOptionPrice)%> 원
							<br /><%=viewImgSt(IMG_SHOP&"/icon_point_green.gif",13,15,"","","vmiddle")%>&nbsp;<%=num2cur(self_GoodsPoint)%> 원
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
			<div class="AreaZoneWrap">
				<div class="AreaZone">
					<div class="PriceArea"><span class="tit"></span><span id="PriceArea"><%=num2cur(TOTAL_PRICE)%></span><span class="won"></span></div>
					<div class="PointArea"><span class="tit"></span><span id="PointArea"><%=num2cur(TOTAL_USEPOINT)%></span><span class="won"></span></div>
					<div class="LastArea"><span class="tit"></span><span id="LastArea"><%=num2cur(TOTAL_SUM_PRICE)%></span><span class="won"></span></div>
				</div>
				<div class="disArea">
					<table <%=tableatt%> class="width100">
						<colgroup>
							<col width="120" />
							<col width="280" />
							<col width="*" />
							<col width="300" />
						</colgroup>
						<tbody>
							<tr>
								<td class="bor_l2">금액내역</td>
							</tr><tr>
								<td class="bor_l2">
									<ul>
										<li class="cleft">·상품가 : </li>
										<li class="fright"><strong><%=num2cur(TOTAL_GOODS_PRICE)%></strong> 원</li>
										<li class="cleft">·옵션가 : </li>
										<li class="fright"><strong><%=num2cur(DKRS_totalOptionPrice)%></strong> 원</li>
										<li class="cleft">·배송비 : </li>
										<li class="fright"><strong><%=num2cur(DKRS_totalDelivery)%></strong> 원</li>
									</ul>
								</td>
							</tr><tr>
								<td class="bor_l2 vtop point">
									<ul>
										<li class="cleft">·적립금사용 : </li>
										<li class="fright"><strong id="viewPoint"><%=num2cur(DKRS_usePoint)%></strong> 원</li>
									</ul>
								</td>
							</tr><tr>
								<td class="bor_l2 summ">
									<ul>
										<li class="tweight">결제 후 내용</li>
										<%If DK_MEMBER_TYPE <> "GUEST" Then%>
											<li class="cleft" style="margin-top:8px;">·적립금 : </li>
											<li class="fright"><strong><%=num2cur(DKRS_totalPoint)%></strong> 원</li>
										<%Else%>
											<li class="cleft" style="margin-top:8px;">·적립금 : </li>
											<li class="fright"><strong><%=num2cur(DKRS_totalPoint)%></strong> 원</li>
											<li class="cright" style="margin-top:8px; color:#ee0000">·적립금은 회원만 적립이 가능합니다.</li>
										<%End If%>
									</ul>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
			</div>
		</div>

		<%
		'회원정보 복호화
		'	Set objEncrypter = Server.CreateObject ("Hyeongryeol.StringEncrypter")
		'		objEncrypter.Key = con_EncryptKey
		'		objEncrypter.InitialVector = con_EncryptKeyIV
		'		If DKRS_strADDR1	<> "" Then DKRS_strADDR1	= Trim(objEncrypter.Decrypt(DKRS_strADDR1))
		'		If DKRS_strADDR2	<> "" Then DKRS_strADDR2	= Trim(objEncrypter.Decrypt(DKRS_strADDR2))
		'		If DKRS_strTel		<> "" Then DKRS_strTel		= Trim(objEncrypter.Decrypt(DKRS_strTel))
		'		If DKRS_strMob		<> "" Then DKRS_strMob		= Trim(objEncrypter.Decrypt(DKRS_strMob))

		'		If DKRS_takeADDR1	<> "" Then DKRS_takeADDR1	= Trim(objEncrypter.Decrypt(DKRS_takeADDR1))
		'		If DKRS_takeADDR2	<> "" Then DKRS_takeADDR2	= Trim(objEncrypter.Decrypt(DKRS_takeADDR2))
		'		If DKRS_takeTel		<> "" Then DKRS_takeTel		= Trim(objEncrypter.Decrypt(DKRS_takeTel))
		'		If DKRS_takeMob		<> "" Then DKRS_takeMob		= Trim(objEncrypter.Decrypt(DKRS_takeMob))

		'	Set objEncrypter = Nothing
		%>
		<div class="cleft ordersInfo width100">
			<div class="fleft" style="width:48%">
				<div class="order_title_03"></div>
				<table <%=tableatt%> class="width100">
					<col width="135" />
					<col width="*" />
					<tbody>
						<tr>
							<th>성명</th>
							<td><%=DKRS_strName%></td>
						</tr><tr>
							<th>연락처</th>
							<td><%=DKRS_strTel%></td>
						</tr><tr>
							<th>휴대폰번호</th>
							<td><%=DKRS_strMob%></td>
						</tr><tr>
							<th>이메일</th>
							<td><%=DKRS_strEmail%></td>
						</tr><tr>
							<th>주소</th>
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
				<div class="order_title_04"></div>
				<table <%=tableatt%> class="width100">
					<col width="135" />
					<col width="*" />
					<tbody>
						<tr>
							<th>성명</th>
							<td><%=DKRS_takeName%></td>
						</tr><tr>
							<th>연락처</th>
							<td><%=DKRS_takeTel%></td>
						</tr><tr>
							<th>휴대폰번호</th>
							<td><%=DKRS_takeMob%></td>
						</tr><tr>
							<th>주소</th>
							<td class="zipTD">
								<p><%=DKRS_takeZip%></p>
								<p><%=DKRS_takeADDR1%></p>
								<p><%=DKRS_takeADDR2%></p>
							</td>
						</tr><tr>
						<th>배송 시 요청사항</td>
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
				<div class="order_title_05"></div>
				<div class="width100 selectPay tweight">무통장 입금</div>
				<div class="cleft width100 payinfoWrap">
					<div class="fleft" style="width:100%;">
						<div id="BankInfo" class="width100">
							<table <%=tableatt%> class="width100">
								<col width="120" />
								<col width="*" />
								<tr>
									<th>입금은행</th>
									<td><%=DKRS_bankingCom%></td>
								</tr><tr>
									<th>입금계좌번호</th>
									<td><%=DKRS_bankingNum%></td>
								</tr><tr>
									<th>예금주</th>
									<td><%=DKRS_bankingOwn%></td>
								</tr><tr>
									<th>입금자명</th>
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
				<div class="width100 selectPay">카드결제</div>
				<div class="cleft width100 payinfoWrap">
					<div class="fleft" style="width:100%;">
						<div id="CardInfo" class="width100">
							<table <%=tableatt%> class="width100">
								<col width="120" />
								<col width="*" />
								<tr>
									<th>결제사</th>
									<td><%=DKFD_PGCOMPANY%> (<a href="<%=PGCOMURL%>" target="_blank"><%=PGCOMURL%></a>)</td>
								</tr><tr>
									<th>카드코드</th>
									<td><%=DKRS_PGCardCode%> (<%=FN_INICIS_CARDCODE_VIEW(DKRS_PGCardCode)%>)</td>
								</tr>
								<%IF UCASE(DKFD_PGCOMPANY) <> "DAOU" Then%>
								<tr>
									<th>카드번호</th>
									<td><%=DKRS_PGCardNum%></td>
								</tr><tr>
									<th>할부개월수</th>
									<td><%=DKRS_PGinstallment%></td>
								</tr>
								<%End If%>
								<tr>
									<th>승인번호</th>
									<td><%=DKRS_PGAcceptNum%></td>
								</tr>
							</table>
						</div>
					</div>
				</div>
			</div>

		<%
			End Select
		%>



	</div>

	<div style="clear:both; float:left; width:100%; text-align:center;margin-top:30px;">
	<%=aImgOpt("/shop/mypage/order_list.asp","S",IMG_SHOP&"/goMypage.gif",200,42,"","")%>
	<%=aImgOpt("/shop","S",IMG_SHOP&"/goShopMain.gif",200,42,"","style=""margin-left:5px;""")%>
	</div>


</div>


<!--#include virtual = "/_include/copyright.asp"-->
