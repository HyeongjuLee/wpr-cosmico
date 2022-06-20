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


	PAGE = Trim(pRequestTF("page",False))
	If PAGE = "" Then PAGE = 1
	PAGESIZE = 5


	SDATE = pRequestTF("SDATE",False)
	EDATE = pRequestTF("EDATE",False)

	If SDATE = "" Then SDATE = ""
	If EDATE = "" Then EDATE = ""


	arrParamsM = Array(_
		Db.makeParam("@PAGE",adInteger,adParamInput,0,PAGE), _
		Db.makeParam("@PAGESIZE",adInteger,adParamInput,0,PAGESIZE), _
		Db.makeParam("@strUserID",adVarChar,adParamInput,20,DK_MEMBER_ID), _

		Db.makeParam("@SDATE",adVarChar,adParamInput,10,SDATE), _
		Db.makeParam("@EDATE",adVarChar,adParamInput,10,EDATE), _

		Db.makeParam("@ALL_COUNT",adInteger,adParamOutput,0,0) _
	)
	arrListM = Db.execRsList("DKP_MYPAGE_ORDER_LIST",DB_PROC,arrParamsM,listLenM,Nothing)
	'arrListM = Db.execRsList("DKP_ORDER_LIST",DB_PROC,arrParamsM,listLenM,Nothing)

	ALL_COUNT = arrParamsM(UBound(arrParamsM))(4)

	Dim PAGECOUNT,CNT
	PAGECOUNT = int((ccur(All_Count) - 1 ) / CInt(PAGESIZE) ) + 1
	IF CCur(PAGE) = 1 Then
		CNT = All_Count
	Else
		CNT = All_Count - ((CCur(PAGE)-1)*CInt(PAGESIZE)) '
	End If

%>

<!--#include virtual = "/_include/document.asp"-->
<link rel="stylesheet" href="order_list.css" />
<link rel="stylesheet" href="/css/mypage.css" />
<script type="text/javascript" src="order_list.js"></script>
<script type="text/javascript" src="/jscript/calendar.js"></script>
</head>
<body>
<!--#include virtual="/_include/header.asp" -->
<div id="subTitle" class="" style="margin-left:20px;">
	<div class="fleft maps_title"><img src="<%=IMG_MYPAGE%>/tit_orderlist.png" alt="" /></div>
	<div class="fright maps_navi">SHOP > 마이페이지 > <span class="tweight last_navi">주문/배송조회 : 목록</span></div>
</div>

<div id="mypage" class="width100">

<!--  -->
<div id="orderlist" class="width100" style="margin-left:20px;">
	<div class="search">
		<form name="search" action="order_List.asp" method="post">
			<table <%=tableatt%> class="width100">
				<col width="150" />
				<col width="750" />
				<tr>
					<th rowspan="2"><%=viewImgOPT(IMG_MYPAGE&"/orderlist_search_tit.png",47,15,"","")%></th>
					<td>
						<span class="button medium icon"><span class="calendar"></span><button type="button" onclick="chgDate('<%=nowDate%>','<%=nowDate%>');">오늘</button></span>
						<span class="button medium icon"><span class="calendar"></span><button type="button" onclick="chgDate('<%=DateAdd("d",-7,nowDate)%>','<%=nowDate%>');">1주일</button></span>
						<span class="button medium icon"><span class="calendar"></span><button type="button" onclick="chgDate('<%=DateAdd("m",-1,nowDate)%>','<%=nowDate%>');">1개월</button></span>
						<span class="button medium icon"><span class="calendar"></span><button type="button" onclick="chgDate('<%=DateAdd("m",-3,nowDate)%>','<%=nowDate%>');">3개월</button></span>
						<span class="button medium icon"><span class="calendar"></span><button type="button" onclick="chgDate('<%=DateAdd("m",-6,nowDate)%>','<%=nowDate%>');">6개월</button></span>
						<span class="button medium icon"><span class="calendar"></span><button type="button" onclick="chgDate('<%=DateAdd("yyyy",-1,nowDate)%>','<%=nowDate%>');">1년</button></span>
						<span class="button medium icon"><span class="calendar"></span><button type="button" onclick="chgDate('','');">전체</button></span>
					</td>
				</tr><tr>
					<td>
						<input type="text" id="SDATE" name="SDATE" class="input_text tcenter tweight" style="width:140px;" value="<%=SDATE%>" readonly="readonly" onclick="openCalendar(event, this, 'YYYY-MM-DD');" /> 부터
						<input type="text" id="EDATE" name="EDATE" class="input_text tcenter tweight" style="width:140px;" value="<%=EDATE%>" readonly="readonly" onclick="openCalendar(event, this, 'YYYY-MM-DD');" /> 까지
						<input type="image" src="<%=IMG_MYPAGE%>/orderlist_search_submit.gif" class="vtop" style="margin-left:7px;" />
					</td>
				</tr>
			</table>
		</form>
	</div>

	<div style=" margin-top:20px;"><%=viewImg(IMG_MYPAGE&"/orderlist_list_tit.png",53,16,"")%></div>
	<div class="desc1">
		<p>- 상품명, 가격 및 <!-- 적립 -->포인트 내용은 주문당시를 기준으로 노출되어 현재와 다를 수 있습니다</p>
		<p>- 자세한 내용은 주문상세보기를 통해 확인해주세요.</p>
	</div>
</div>
<!--  -->
	<div class="orderlist">
		<table <%=tableatt%> class="widt h100 tbfix" style="width:800px;margin-left:20px;">
			<col width="110" />
			<col width="280" />
			<col width="90" />
			<col width="90" />
			<col width="110" />
			<col width="*" />
			<thead>
				<tr>
					<th>주문일자</th>
					<th>주문상품</th>
					<th>상품금액</th>
					<th>판매자</th>
					<th>배송비</th>
					<th>주문상태</th>
				</tr>
			</thead>

			<tbody>
				<%
					If IsArray(arrListM) Then
						For m = 0 To listLenM
							arrParams = Array(_
								Db.makeParam("@orderNum",adVarChar,adParamInput,20,arrListM(2,m)), _
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
							 '상품 정보 출력 '
							' print DKRS_intIDX
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
										arrList_OrderDtoD				= arrList(24,i)
										arrList_OrderDtoDValue			= arrList(25,i)
										arrList_OrderDtoDDate			= arrList(26,i)
										arrList_Status					= arrList(27,i)


										arrList_GoodsName = Replace(arrList_GoodsName,"\","")


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
											printOPTIONS = printOPTIONS & "<span>[옵션] "& arrOptionTitle(0) & " : " & arrOptionTitle(1) & OptionPrice & "</span><br />"
											sum_optionPrice = Int(sum_optionPrice) + Int(arrOption(1))
										Next

										self_GoodsPoint			= arrList_orderEa * arrList_GoodsPrice
										self_GoodsPoint			= arrList_orderEa * arrList_goodsPoint
										self_GoodsOptionPrice	= arrList_orderEa * arrList_goodsOptionPrice
										self_TOTAL_PRICE		= selfPrice + self_optionPrice


										If arrList_GoodsDeliveryType = "SINGLE" Then
											arrList_DELICNT		= 1
											self_DeliveryFee	= Int(arrList_orderEa) * Int(arrList_GoodsDeliveryFee)
											txt_DeliveryFee		= "<span class=""tweight"">선결제 "&spans(num2cur(self_DeliveryFee),"#FF6600","","")&"원</span><br /><span class=""f11px lheight130""> 개당 "&num2cur(arrList_GoodsDeliveryFee)&"원<br /> 단독배송상품</span>"

										Else
											If arrList_DELICNT = 1 Then
												If self_TOTAL_PRICE >= arrList_GoodsDeliveryLimit Then
													self_DeliveryFee	= "0"
													txt_DeliveryFee		= "<span class=""tweight"">"&spans("무료배송","#FF6600","","")&"</span><br /><span class=""f11px lheight130"">묶음배송 상품 <br />"&num2cur(arrList_GoodsDeliveryLimit)&" 원 이상<br /> 무료배송</span>"
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
													txt_DeliveryFee		= "<span class=""tweight"">"&spans("무료배송","#FF6600","","")&"</span><br /><span class=""f11px lheight130"">묶음배송 상품 <br />"&num2cur(arrList_GoodsDeliveryLimit)&" 원 이상<br /> 무료배송</span>"
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
									'PRINT "<tbody>"
								Else
									trClass = "bgC1"
									If k = 0 Then
										k = 1
										rowSpans1 = " rowspan="""&arrList_ShopCNT&""" "
										'PRINT "<tbody>"
									Else
										k = k
									End If
								End If
								 trClass2 = ""
								If i = listLen Then trClass2 = " lastTR"
							%>
							<%If i = 0 Then%>
							<tr class="fisrtTR">
								<td rowspan="<%=listLen+1%>" class="orderNum">
									<%=Left(DKRS_status100Date,10)%><br />
									(<%=DKRS_OrderNum%>)<br />
									<span class="button small tnormal"><a href="order_view.asp?orderNum=<%=DKRS_OrderNum%>">상세보기</a></span>
								</td>
							<%Else%>
							<tr>
							<%End If%>
								<td class="goodsInfo">
									<div class="clear ovhi">
										<div class="thumImg" style="padding:<%=imgPaddingH%>px 0px;"><%=viewImg(imgPath,imgWidth,imgHeight,"")%></div>
										<div class="goodsName"><%=backword(arrList_GoodsName)%></div>
									</div>
									<%If printOPTIONS <> "" Then%>
									<div class="goodsOption"><%=printOPTIONS%></div>
									<%End If%>
								</td>
								<td class="tcenter " style="line-height:160%;">
									<strong><%=spans(num2cur(self_GoodsPoint+self_GoodsOptionPrice)&" 원","#FF6600","","")%></strong><br />
									(<%=arrList_orderEa%>개)
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
								<td class="tcenter deliTD" id="deli<%=m%>_TD<%=i%>"><% '주문상태 보기
									Select Case DKRS_status
										Case "100" : PRINT "<p><span class=""f11px font_dotum tweight"">입금대기중</span></p>"
										Case "101" : PRINT "<p><span class=""f11px font_dotum tweight lheight160"">결제완료<br />(배송준비중)</span></p>"
										Case "102"
											If arrList_orderDtoD <> "0" Then
												arrParams3 = Array(_
													Db.makeParam("@intIDX",adInteger,adParamInput,0,arrList_orderDtoD) _
												)
												Set DKRS1 = Db.execRs("DKP_DTOD_SELECTOR",DB_PROC,arrParams3,Nothing)
												If Not DKRS1.BOF And Not DKRS1.EOF Then
													'DKRS1_intIDX			= DKRS1("intIDX")
													'DKRS1_intSort			= DKRS1("intSort")
													'DKRS1_strDtoDName		= DKRS1("strDtoDName")
													'DKRS1_strDtoDTel		= DKRS1("strDtoDTel")
													'DKRS1_strDtoDURL		= DKRS1("strDtoDURL")
													DKRS1_strDtoDTrace		= DKRS1("strDtoDTrace")
													'DKRS1_useTF				= DKRS1("useTF")
													'DKRS1_defaultTF			= DKRS1("defaultTF")

													PRINT "<span class=""button small tnormal""><a href="""&DKRS1_strDtoDTrace&arrList_orderDtoDValue&""" target=""_blank"">배송추적</a></span><br />"
												Else
													PRINT "("&arrList_orderDtoDDate&")<br />"
													PRINT "미등록 배송사"
												End If
											Else
												PRINT "("&arrList_orderDtoDDate&")<br />"
												PRINT "배송날짜만 존재 <br />"
												PRINT "<span class=""button small""><a href=""javascript:alert('직접수령, 퀵수령등 택배사를 이용하지 않는 배송입니다.');"">배송추적</a></span><br />"
											End If
									%>
									<!-- <p><span class="f11px font_dotum tweight">배송완료</span></p> -->
									<!-- <p><span class="button small tnormal"><a href="javascript:OpenPopDeli('<%=arrList_intIDX%>');">배송추적</a></span></p> -->
									<!-- <p><span class="button small tnormal"><a href="javascript:AJ_deliveryFinish('<%=arrList_intIDX%>','deli<%=m%>_TD<%=i%>');">수취확인</a></span></p> -->
									<p><span class="button small tnormal"><a href="javascript:orderFinish('<%=DKRS_OrderNum%>');">수취확인</a></span></p>

									<%
										Case "103"
											PRINT "<span class=""f11px font_dotum tweight"">배송완료</span></p>"
											If arrList_orderDtoD <> "0" Then
												arrParams3 = Array(_
													Db.makeParam("@intIDX",adInteger,adParamInput,0,arrList_orderDtoD) _
												)
												Set DKRS1 = Db.execRs("DKP_DTOD_SELECTOR",DB_PROC,arrParams3,Nothing)
												If Not DKRS1.BOF And Not DKRS1.EOF Then
													DKRS1_strDtoDTrace		= DKRS1("strDtoDTrace")
													PRINT "<span class=""button small tnormal""><a href="""&DKRS1_strDtoDTrace&arrList_orderDtoDValue&""" target=""_blank"">배송추적</a></span><br />"
												Else
													PRINT "("&arrList_orderDtoDDate&")<br />"
													PRINT "미등록 배송사"
												End If
											Else
												PRINT "("&arrList_orderDtoDDate&")<br />"
												PRINT "배송날짜만 존재 <br />"
												PRINT "<span class=""button small""><a href=""javascript:alert('직접수령, 퀵수령등 택배사를 이용하지 않는 배송입니다.');"">배송추적</a></span><br />"
											End If
									%>
									<%If arrList_reviewTF = "F" Then%>
									<!-- <p><span class="button small tnormal"><a href="javascript:openReviewWrite('<%=arrList_intIDX%>');">리뷰작성</a></span></p> -->
									<%Else%>
									<!-- <p>리뷰작성완료</p> -->
									<%End If%>
									<%
										Case "201" : PRINT "관리자취소"
										Case "301" : PRINT "취소요청"
										Case "302" : PRINT "취소완료"
									%>
									<%

									End Select

								%></td>
							</tr>
							<%
									If arrList_DELICNT = 1 Or arrList_DELICNT = k Then
										l = 0
									Else
										l = l + 1
									End If

									If arrList_ShopCNT = 1 Or arrList_ShopCNT = k Then
										k = 0
										'PRINT "</tbody>"
									Else
										k = k + 1
									End If
								Next
							End If




						Next
					Else
				%>
				<tr>
					<td colspan="6" style="padding:50px 0px" class="tcenter tweight">기간내 주문된 상품이 없습니다.</td>
				</tr>
				<%
					End If
				%>
			</tbody>
		</table>

		<div class="pagingArea"><%Call pageList(PAGE,PAGECOUNT)%></div>



		<form name="frm" method="post" action="">
			<input type="hidden" name="PAGE" value="<%=PAGE%>" />
		</form>
	</div>
</div>


<!--#include virtual = "/_include/copyright.asp"-->
