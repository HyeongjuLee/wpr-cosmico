<!--#include virtual="/_lib/strFunc.asp"-->
<!--#include virtual="/_include/document.asp"-->
<%


	Response.Redirect "/mypage/order_list.asp"



	PAGE_SETTING = "MYPAGE"
	ISLEFT = "T"
	ISSUBTOP = "T"
	ISSUBVISUAL = "T"
	view = 4
	sView = 1

	Call ONLY_MEMBER_CONFIRM(DK_MEMBER_LEVEL)


	PAGE = Trim(pRequestTF("page",False))
	If PAGE = "" Then PAGE = 1
	PAGESIZE = 20


	SDATE = pRequestTF("SDATE",False)
	EDATE = pRequestTF("EDATE",False)

	If SDATE = "" Then SDATE = ""
	If EDATE = "" Then EDATE = ""

	arrParams = Array(_
		Db.makeParam("@PAGE",adInteger,adParamInput,0,PAGE), _
		Db.makeParam("@PAGESIZE",adInteger,adParamInput,0,PAGESIZE), _
		Db.makeParam("@strUserID",adVarChar,adParamInput,20,DK_MEMBER_ID), _

		Db.makeParam("@SDATE",adVarChar,adParamInput,10,SDATE), _
		Db.makeParam("@EDATE",adVarChar,adParamInput,10,EDATE), _

		Db.makeParam("@ALL_COUNT",adInteger,adParamOutput,0,0) _
	)
	arrList = Db.execRsList("DKP2_MYPAGE_ORDER_LIST",DB_PROC,arrParams,listLen,Nothing)
	ALL_COUNT = arrParams(UBound(arrParams))(4)

	Dim PAGECOUNT,CNT
	PAGECOUNT = int((ccur(All_Count) - 1 ) / CInt(PAGESIZE) ) + 1
	IF CCur(PAGE) = 1 Then
		CNT = All_Count
	Else
		CNT = All_Count - ((CCur(PAGE)-1)*CInt(PAGESIZE)) '
	End If
%>

<link rel="stylesheet" href="/css/mypage.css" />
<script type="text/javascript" src="/jscript/calendar.js"></script>
<script type="text/javascript">
<!--


//-->
</script>
<script type="text/javascript" src="orders.js"></script>
</head>
<body>
<!--#include virtual="/_include/header.asp"-->
<!--#include virtual = "/_include/sub_title.asp"-->

<div id="orderlist" class="userCWidth2">
	<div class="search">
		<form name="search" action="orderList.asp" method="post">
			<table <%=tableatt%> class="width100">
				<col width="150" />
				<col width="*" />
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
		<p>- 상품명, 가격 및 적립내용은 주문당시를 기준으로 노출되어 현재와 다를 수 있습니다</p>
		<p>- 자세한 내용은 주문상세보기를 통해 확인해주세요.</p>
	</div>

	<div class="list">
		<table <%=tableatt%> class="userCWidth2">
			<col width="120" />
			<col width="350" />
			<col width="110" />
			<col width="100" />
			<col width="*" />
			<thead>
				<tr>
					<th>주문일자</th>
					<th>주문상품</th>
					<th>상품금액</th>
					<th>배송상태</th>
					<th class="last">주문상태</th>
				</tr>
			</thead>
			<tfoot>
				<tr>
					<td colspan="5" align="center" height="40"><%Call pageList(PAGE,PAGECOUNT)%></td>
				</tr>
			</tfoot>
			<%
				If IsArray(arrList) Then
					For i = 0 To listLen
						orderDate = Left(arrList(5,i),10)
						orderIDX = arrList(1,i)
						orderNum = arrList(2,i)
						orderPrice = num2cur(arrList(3,i))
						orderState = arrList(4,i)

							arrParams1 = Array(_
								Db.makeParam("@orderIDX",adInteger,adParamInput,0,orderIDX), _
								Db.makeParam("@GOODSCNT",adInteger,adParamOutput,0,0) _
							)
							arrList1 = Db.execRsList("DKP2_ORDER_LIST_DETAIL",DB_PROC,arrParams1,listLen1,Nothing)


			%>
			<tbody class="lines">
				<tr>
					<td class="orderNum tcenter">
						<%=orderDate%><br />
						(<%=orderNum%>)<br />
						<span class="button small"><a href="/mypage/orderView.asp?oidx=<%=orderIDX%>">주문상세보기</a>
					</td>
					<td class="orderGoods" colspan="3">
						<table <%=tableatt%> class="width100 inGoodsTable">
							<col width="80" />
							<col width="270" />
							<col width="110" />
							<col width="100" />
							<%
								If IsArray(arrList1) Then
									For j = 0 To listLen1
										arrList1_imgThum				= arrList1(0,j)
										arrList1_reviewTF				= arrList1(1,j)
										arrList1_intIDX					= arrList1(2,j)
										arrList1_GoodsPrice				= arrList1(3,j)
										arrList1_GoodsOptionPrice		= arrList1(4,j)
										arrList1_GoodsName				= arrList1(5,j)
										arrList1_orderEa				= arrList1(6,j)
										arrList1_strOption				= arrList1(7,j)
										arrList1_orderDtoD				= arrList1(8,j)
										arrList1_orderDtoDValue			= arrList1(9,j)
										arrList1_orderDtoDDate			= arrList1(10,j)



										If Left(LCase(arrList_ImgThum),7) = "http://" Or Left(LCase(arrList_ImgThum),8) = "https://" Then
											imgPath = backword(arrList_ImgThum)
											imgWidth = 65
											imgHeight = 65
											imgPaddingH = (65 - imgHeight) / 2
										Else
											imgPath = VIR_PATH("goods/thum")&"/"&backword(arrList_ImgThum)
											imgWidth = 0
											imgHeight = 0
											Call ImgInfo(imgPath,imgWidth,imgHeight,"")
											imgPaddingH = (65 - imgHeight) / 2
											'viewImg(imgPath,imgWidth,imgHeight,"")
										End If



										Goods_Price = (arrList1_GoodsPrice * arrList1_orderEa) + (arrList1_GoodsOptionPrice * arrList1_orderEa)

									'B.[imgThum],A.[reviewTF],A.[intIDX],A.[GoodsPrice],A.[GoodsOptionPrice],A.[GoodsName]
									If j = listLen1 Then trClass=" class=""last"" " Else trClass = "" End If
							%>
								<tr <%=trClass%>>
									<td class="tcenter"><div class="thumImg tcenter" style=""><%=viewImgOPT(imgPath,imgWidth,imgHeight,"","style=""margin-top:"&imgMarginH&"px;""")%></div></td>
									<td class="bor_right vtop">
										<p style="margin-top:5px;"><%=arrList1_GoodsName%></p>
										<%
											If arrList1(7,j) <> "" Then
												Response.Write "<ul style=""margin-top:10px;"">"
												arrOpt = Split(arrList1(7,j),",")
												For z = 0 To UBound(arrOpt)
													arrOptTxt = Split(arrOpt(z),"\")
													Response.Write "<li class=""option"">"&arrOptTxt(0)&" (+"&num2cur(arrOptTxt(1))&" 원)</li>"
												Next
												Response.Write "</ul>"
											End If
										%>
									</td>
									<td class="bor_right tcenter orderPrice">
										<strong><%=num2cur(Goods_Price)%> 원</strong>
										<table <%=tableatt%> style="width:85%; margin:0px auto;">
											<col width="30" />
											<col width="*" />
											<tr>
												<td class="tleft">상품 : </td>
												<td class="tright"><%=num2cur(arrList1_GoodsPrice)%> 원</td>
											</tr>
											<% If arrList1_GoodsOptionPrice <> 0 Then%>
											<tr>
												<td class="tleft">옵션 : </td>
												<td class="tright option"><%=num2cur(arrList1_GoodsOptionPrice)%> 원</td>
											</tr>
											<%End If%>
											<tr>
												<td class="tleft">수량 : </td>
												<td class="tright"><%=num2cur(arrList1_orderEa)%> 개</td>
											</tr>
										</table>
									</td>
									<td class="bor_right tcenter font11px DtoD">
									<%
										If orderState = "102" Or orderState = "103" Then
											If arrList1_orderDtoD <> "0" Then
												arrParams3 = Array(_
													Db.makeParam("@intIDX",adInteger,adParamInput,0,arrList1_orderDtoD) _
												)
												Set DKRS1 = Db.execRs("DKP_DTOD_SELECTOR",DB_PROC,arrParams3,Nothing)
												If Not DKRS1.BOF And Not DKRS1.EOF Then
													DKRS1_intIDX			= DKRS1("intIDX")
													DKRS1_intSort			= DKRS1("intSort")
													DKRS1_strDtoDName		= DKRS1("strDtoDName")
													DKRS1_strDtoDTel		= DKRS1("strDtoDTel")
													DKRS1_strDtoDURL		= DKRS1("strDtoDURL")
													DKRS1_strDtoDTrace		= DKRS1("strDtoDTrace")
													DKRS1_useTF				= DKRS1("useTF")
													DKRS1_defaultTF			= DKRS1("defaultTF")

													PRINT "("&arrList1_orderDtoDDate&")<br />"
													PRINT DKRS1_strDtoDName &"<br />"
													PRINT "<span class=""button small""><a href="""&DKRS1_strDtoDTrace&arrList1_orderDtoDValue&""" target=""_blank"">배송추적</a></span><br />"
												Else
													PRINT "("&arrList1_orderDtoDDate&")<br />"
													PRINT "미등록 배송사"
												End If
											Else
												PRINT "("&arrList1_orderDtoDDate&")<br />"
												PRINT "배송날짜만 존재 <br />"
												PRINT "<span class=""button small""><a href=""javascript:alert('직접수령, 퀵수령등 택배사를 이용하지 않는 배송입니다.');"">배송추적</a></span><br />"
											End If
										Else
											PRINT "배송전 상품"
										End If

										If orderState = "103" Then
											If arrList1_reviewTF = "F" Then
												PRINT "<span class=""button small""><a href=""javascript:openReviewWrite('"&arrList1_intIDX&"')"" class=""red"">리뷰작성하기</a></span>"
											Else
												PRINT "<span class=""red"">리뷰 등록 완료</span>"
											End If
										End If

									%>
									</td>
								</tr>
							<%
									Next
								End If

							%>
						</table>
					</td>
					<td class="orderStatus tcenter">
						<%=CallState(orderState)%>
						<%
							If orderState = "102" Then
								PRINT "<span class=""button small""><a href=""javascript:orderFinish('"&orderNum&"')"" class=""red"">수취확인</a></span>"
							End If
						%>
					</td>
				</tr>
			</tbody>
			<%

					Next
				Else
			%>
			<tr>
				<td colspan="5" style="padding:50px 0px" class="tcenter tweight">기간내 주문된 상품이 없습니다.</td>
			</tr>
			<%
				End If
			%>
		</table>


	</div>
	<form name="frm" method="post" action="">
		<input type="hidden" name="PAGE" value="<%=PAGE%>" />
	</form>

</div>
<!--#include virtual="/_include/copyright.asp"-->
