<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	'주문/배송조회
	PAGE_SETTING = "INDEX"

	Response.Redirect "/m/buy/order_list.asp"


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
<!--#include virtual = "/m/_include/document.asp"-->
<!--#include virtual = "/m/_include/jqueryload.asp"-->
<script type="text/javascript" src="order_list.js"></script>
<script type="text/javascript" src="/m/js/calendar.js"></script>
<link rel="stylesheet" href="order_list.css" />
</head>
<body onUnload="">
<!--#include virtual = "/m/_include/header.asp"-->
<!--#include virtual = "/m/_include/sub_header.asp"-->
<div id="subTitle" class="width100 tcenter text_noline" ><%=LNG_MYPAGE_04%></div>
<div class="index_vote width100 cleft">

<div id="orderlist" style="background-color:#fff;">
	<div class="s_title"><%=LNG_TEXT_DATE_SEARCH%></div>
	<div class="search" style="border-bottom:1px solid #eee; padding-bottom:15px;">
		<form name="search" action="order_List.asp" method="post">
			<table <%=tableatt%> class="width100">
				<col width="80" />
				<col width="*" />
				<tr>
					<td class="tcenter" style="padding:8px 0px;">
						<span class="button medium icon"><span class="calendar"></span><button type="button" onclick="chgDate('<%=nowDate%>','<%=nowDate%>');"><%=LNG_TEXT_TODAY%></button></span>
						<span class="button medium icon"><span class="calendar"></span><button type="button" onclick="chgDate('<%=DateAdd("d",-7,nowDate)%>','<%=nowDate%>');"><%=LNG_TEXT_1WEEK%></button></span>
						<span class="button medium icon"><span class="calendar"></span><button type="button" onclick="chgDate('<%=DateAdd("m",-1,nowDate)%>','<%=nowDate%>');"><%=LNG_TEXT_THISMONTH%></button></span>
						<span class="button medium icon"><span class="calendar"></span><button type="button" onclick="chgDate('<%=DateAdd("m",-3,nowDate)%>','<%=nowDate%>');"><%=LNG_TEXT_3MONTH%></button></span>

						<span class="button medium icon"><span class="calendar"></span><button type="button" onclick="chgDate('','');"><%=LNG_TEXT_ALL%></button></span>
					</td>
				</tr><tr>
					<td class="tcenter">
						<input type="text" id="SDATE" name="SDATE" class="input_text tcenter tweight" style="width:140px;" value="<%=SDATE%>" readonly="readonly" onclick="openCalendar(event, this, 'YYYY-MM-DD');" /> ~
						<input type="text" id="EDATE" name="EDATE" class="input_text tcenter tweight" style="width:140px;" value="<%=EDATE%>" readonly="readonly" onclick="openCalendar(event, this, 'YYYY-MM-DD');" />
					</td>
				</tr><tr>
					<!-- <td class="tcenter" style="padding-top:7px;"><input type="image" src="<%=IMG_MYPAGE%>/orderlist_search_submit.gif" class="vtop"  /></td> -->
					<td class="tcenter" style="padding-top:7px;"><input type="submit" class="txtBtn small2 radius3" value="<%=LNG_TEXT_SEARCH%>"/></td>
				</tr>
			</table>
		</form>
	</div>

	<div class="s_title"><%=LNG_MYPAGE_04_1%></div>
	<div class="desc1">
		<p>- <%=LNG_SHOP_ORDER_LIST_NOTICE1%></p>
		<p>- <%=LNG_SHOP_ORDER_LIST_NOTICE2%></p>
	</div>
</div>
<!--  -->

	<div style="background-color:#eee;padding:5px 10px 20px 10px;">

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
								Call ALERTS(LNG_SHOP_ORDER_FINISH_01,"go","/index.asp")
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
								beforeOrdNum = ""
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

										self_GoodsPrice			= arrList_orderEa * arrList_GoodsPrice
										self_GoodsPoint			= arrList_orderEa * arrList_goodsPoint
										self_GoodsOptionPrice	= arrList_orderEa * arrList_goodsOptionPrice
										self_TOTAL_PRICE		= selfPrice + self_optionPrice

							%>
							<%If beforeOrdNum <> arrList_orderIDX Or i = 0 Then%><div class="divWrap" ><table <%=tableatt%> class="width100"><col width="*" /><col width="80" /><%End If%>

							<tr>
								<td class="goodsInfo"  onclick="javascript:location.href='order_view.asp?orderNum=<%=DKRS_orderNum%>';">
									<table <%=tableatt%> class="width100">
										<col width="60" />
										<col width="*" />
										<tr>
											<td style="border:0px none; border-right:1px dashed #ccc;"><img src="<%=imgPath%>" width="60" height="60" alt="" /></td>
											<td style="border:0px none; padding:0px 6px;">
												<p style="font-size:11px;"><%=Left(DKRS_status100Date,10)%> | <%=DKRS_OrderNum%></p>
												<div class="width100 overflow:hidden;">
												<div class="tweight"><%=backword(arrList_GoodsName)%></div>
												</div>
											</td>
										</tr>
									</table>
								</td>
								<td class="tcenter deliTD" id="deli<%=m%>_TD<%=i%>"><% '주문상태 보기
									Select Case DKRS_status
										Case "100" : PRINT "<p><span class=""f11px font_dotum tweight"">"&LNG_SHOP_ORDER_WAIT_PAYMENT&"</span></p>"
										Case "101" : PRINT "<p><span class=""f11px font_dotum tweight lheight160"">"&LNG_SHOP_ORDER_COMPLETE_PAYMENT&"<br />("&LNG_SHOP_ORDER_PREPARE_SHIPPING&")</span></p>"
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

													PRINT "<span class=""button small tnormal""><a href="""&DKRS1_strDtoDTrace&arrList_orderDtoDValue&""" target=""_blank"">"&LNG_SHOP_ORDER_TRACKING&"</a></span><br />"
												Else
													PRINT "("&arrList_orderDtoDDate&")<br />"
													PRINT LNG_SHOP_ORDER_UNREGISTERED_SHIP	'"미등록 배송사"
												End If
											Else
												PRINT "("&arrList_orderDtoDDate&")<br />"
												PRINT LNG_SHOP_ORDER_DELIVERY_DATE_ONLY&"<br />"		'"배송날짜만 존재 <br />"
												'PRINT "<span class=""button small""><a href=""javascript:alert('직접수령, 퀵수령등 택배사를 이용하지 않는 배송입니다.');"">배송추적</a></span><br />"
												PRINT "<span class=""button small""><a href=""javascript:alert('"&LNG_SHOP_ORDER_DELIVERY_ALERT2&"');"">"&LNG_SHOP_ORDER_TRACKING&"</a></span><br />"

											End If
									%>
									<!-- <p><span class="f11px font_dotum tweight"><%=LNG_SHOP_ORDER_DELIVERY_FINISH%></span></p> -->
									<!-- <p><span class="button small tnormal"><a href="javascript:OpenPopDeli('<%=arrList_intIDX%>');"><%=LNG_SHOP_ORDER_TRACKING%></a></span></p> -->
									<!-- <p><span class="button small tnormal"><a href="javascript:AJ_deliveryFinish('<%=arrList_intIDX%>','deli<%=m%>_TD<%=i%>');"><%=LNG_SHOP_ORDER_RECEIVE_CONFIRM%></a></span></p> -->
									<p><span class="button small tnormal"><a href="javascript:orderFinish('<%=DKRS_OrderNum%>');"><%=LNG_SHOP_ORDER_RECEIVE_CONFIRM%></a></span></p>

									<%
										Case "103"
											PRINT "<span class=""f11px font_dotum tweight"">"&LNG_SHOP_ORDER_DELIVERY_FINISH&"</span></p>"
											If arrList_orderDtoD <> "0" Then
												arrParams3 = Array(_
													Db.makeParam("@intIDX",adInteger,adParamInput,0,arrList_orderDtoD) _
												)
												Set DKRS1 = Db.execRs("DKP_DTOD_SELECTOR",DB_PROC,arrParams3,Nothing)
												If Not DKRS1.BOF And Not DKRS1.EOF Then
													DKRS1_strDtoDTrace		= DKRS1("strDtoDTrace")
													PRINT "<span class=""button small tnormal""><a href="""&DKRS1_strDtoDTrace&arrList_orderDtoDValue&""" target=""_blank"">"&LNG_SHOP_ORDER_TRACKING&"</a></span><br />"
												Else
													PRINT "("&arrList_orderDtoDDate&")<br />"
													PRINT LNG_SHOP_ORDER_UNREGISTERED_SHIP
												End If
											Else
												PRINT "("&arrList_orderDtoDDate&")<br />"
												PRINT LNG_SHOP_ORDER_DELIVERY_DATE_ONLY&"<br />"		'"배송날짜만 존재 <br />"
												PRINT "<span class=""button small""><a href=""javascript:alert('"&LNG_SHOP_ORDER_DELIVERY_ALERT2&"');"">"&LNG_SHOP_ORDER_TRACKING&"</a></span><br />"
											End If
									%>
									<%If arrList_reviewTF = "F" Then%>
									<!-- <p><span class="button small tnormal"><a href="javascript:openReviewWrite('<%=arrList_intIDX%>');">리뷰작성</a></span></p> -->
									<%Else%>
									<!-- <p>리뷰작성완료</p> -->
									<%End If%>
									<%
										Case "201" : PRINT LNG_STRFUNCSITE_TEXT14	'"관리자취소"
										Case "301" : PRINT LNG_STRFUNCSITE_TEXT15	'"취소요청"
										Case "302" : PRINT LNG_STRFUNCSITE_TEXT16	'"취소완료"
									%>
									<%

									End Select

								%></td>

							<%

									beforeOrdNum = arrList_orderIDX
									If i = listLen Then
							%>
														</tr>
								</table>
							</div>
							<%
									Else
							%>
								<tr>
									<td colspan="2" style="height:1px; border-bottom: 1px dashed #ccc;"></td>
								</tr>
							<%
									End If
								Next
							End If




						Next
					Else

					End If
				%>


	</div>
		<div class="pagingArea pagingMob5"><% Call pageListMob5(PAGE,PAGECOUNT)%></div>
		<!-- <div class="pagingArea"><%Call pageList(PAGE,PAGECOUNT)%></div> -->



		<form name="frm" method="post" action="">
			<input type="hidden" name="PAGE" value="<%=PAGE%>" />
		</form>
</div>




<!--#include virtual = "/m/_include/copyright.asp"-->