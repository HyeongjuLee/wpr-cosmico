<!--#include virtual="/_lib/strFunc.asp" -->
<%
	Response.Redirect "/mypage/order_view.asp"

	PAGE_SETTING = "MYPAGE"
	ISLEFT = "T"
	ISSUBTOP = "T"
	ISSUBVISUAL = "T"
	view = 4
	sView = 2

	Call ONLY_MEMBER_CONFIRM(DK_MEMBER_LEVEL)


	oidx = Trim(gRequestTF("oidx",True))


	arrParams = Array(_
		Db.makeParam("@intIDX",adInteger,adParamInput,0,oidx), _
		Db.makeParam("@strUserID",adVarChar,adParamInput,20,DK_MEMBER_ID) _
	)
	Set DKRS = Db.execRs("DKP2_ORDER_VIEW",DB_PROC,arrParams,Nothing)
	If Not DKRS.BOF And Not DKRS.EOF Then
		DKRS_intIDX						= DKRS("intIDX")
		DKRS_strDomain					= DKRS("strDomain")
		DKRS_OrderNum					= DKRS("OrderNum")
		DKRS_strIDX						= DKRS("strIDX")
		DKRS_strUserID					= DKRS("strUserID")
		DKRS_payWay						= DKRS("payWay")
		DKRS_totalPrice					= DKRS("totalPrice")
		DKRS_totalDelivery				= DKRS("totalDelivery")
		DKRS_totalOptionPrice			= DKRS("totalOptionPrice")
		DKRS_totalPoint					= DKRS("totalPoint")
		DKRS_strName					= DKRS("strName")
		DKRS_strTel						= DKRS("strTel")
		DKRS_strMob						= DKRS("strMob")
		DKRS_strEmail					= DKRS("strEmail")
		DKRS_strZip						= DKRS("strZip")
		DKRS_strADDR1					= DKRS("strADDR1")
		DKRS_strADDR2					= DKRS("strADDR2")
		DKRS_takeName					= DKRS("takeName")
		DKRS_takeTel					= DKRS("takeTel")
		DKRS_takeMob					= DKRS("takeMob")
		DKRS_takeZip					= DKRS("takeZip")
		DKRS_takeADDR1					= DKRS("takeADDR1")
		DKRS_takeADDR2					= DKRS("takeADDR2")
		DKRS_orderMemo					= DKRS("orderMemo")
		DKRS_strSSH1					= DKRS("strSSH1")
		DKRS_strSSH2					= DKRS("strSSH2")
		DKRS_status						= DKRS("status")
		DKRS_status100Date				= DKRS("status100Date")
		DKRS_status101Date				= DKRS("status101Date")
		DKRS_status102Date				= DKRS("status102Date")
		DKRS_status103Date				= DKRS("status103Date")
		DKRS_status104Date				= DKRS("status104Date")
		DKRS_status201Date				= DKRS("status201Date")
		DKRS_status301Date				= DKRS("status301Date")
		DKRS_status302Date				= DKRS("status302Date")
		DKRS_DtoDCode					= DKRS("DtoDCode")
		DKRS_DtoDNumber					= DKRS("DtoDNumber")
		DKRS_DtoDDate					= DKRS("DtoDDate")
		DKRS_CancelCause				= DKRS("CancelCause")
		DKRS_bankIDX					= DKRS("bankIDX")
		DKRS_bankingName				= DKRS("bankingName")
		DKRS_usePoint					= DKRS("usePoint")
		DKRS_totalVotePoint				= DKRS("totalVotePoint")
		DKRS_PGorderNum					= DKRS("PGorderNum")
		DKRS_PGCardNum					= DKRS("PGCardNum")
		DKRS_PGAcceptNum				= DKRS("PGAcceptNum")
		DKRS_PGinstallment				= DKRS("PGinstallment")
		DKRS_PGCardCode					= DKRS("PGCardCode")
		DKRS_PGCardCom					= DKRS("PGCardCom")
		DKRS_ALL_GOODS_PRICE			= DKRS("ALL_GOODS_PRICE")
		DKRS_ALL_OPTION_PRICE			= DKRS("ALL_OPTION_PRICE")

		If UCase(DKRS_payWay) = "VBANK" Then
			DKRS_PGINPUT_BANKCODE = DKRS_PGinstallment
		End If

		If DKRS_PGinstallment = "00" Then
			DKRS_PGinstallment = "일시불"
		Else
			DKRS_PGinstallment = DKRS_PGinstallment &"개월"
		End If

	Else
		Call ALERTS("존재하지 않는 주문번호입니다","BACK","")
	End If
	Call closeRs(DKRS)

	If DKRS_strUserID <> DK_MEMBER_ID Then Call alerts("주문자와 현재 로그인된 회원이 틀립니다.","back","")


	this_icon = "<img src="""&IMG_MYPAGE&"/tit_rect.gif"" width=""4"" height=""6"" alt="""" align=""absmiddle"" /> "
	If state = "100" Or state = "101" Or state = "102" Then
		thisStatus = aImgOpt("javascript:openOrderCancel('"&DKRS_intIDX&"')","",IMG_BTN&"/order_cancel.gif",70,17,"","class=""vmiddle""")
	Else
		thisStatus = ""
	End If


%>
<!--#include virtual="/_include/document.asp" -->
<link rel="stylesheet" href="/css/mypage.css">
<script type="text/javascript" src="orders.js"></script>

</head>
<body>
<!--#include virtual="/_include/header.asp" -->
<!--#include virtual = "/_include/sub_title.asp"-->


<div id="orderView">

	<div class="order_infos">현재 확인하시고 있는 주문의 주문번호는 <strong><span style='color:#2f7099 ;'>[<%=DKRS_OrderNum%>]</span></strong> 입니다.</div>

	<div style=" margin-top:20px;"><%=viewImg(IMG_MYPAGE&"/orderView_pay_tit.png",52,17,"")%></div>
	<table <%=tableatt%> class="width100 pay" style="margin-top:5px;">
		<col width="135" />
		<col width="180" />
		<col width="*" />
		<tbody>
			<tr>
				<td class="th bor_bot">주문상태</td>
				<td class="bor_right bor_bot"><%=CallState(DKRS_status)%></td>
				<td class="bor_bot">
					<%
						If DKRS_status = "102" Then
							PRINT "<span class=""button small red""><a href=""javascript:orderFinish('"&DKRS_OrderNum&"')"" class=""red"">수취확인</a></span>"
						End If
					%>
					<span class="button small icon"><span class="refresh"></span><a href="javascript:openOrderCancel('<%=DKRS_intIDX%>')">주문취소요청</a></span>
				</td>
			</tr><tr>
				<td class="th bor_bot">주문일자</td>
				<td colspan="2" class=" bor_bot"><%=DKRS_status100Date%></td>
			</tr><tr>
				<td class="th">주문금액</td>
				<td class="tright bor_right bor_bot"><%=num2cur(DKRS_ALL_GOODS_PRICE+DKRS_ALL_OPTION_PRICE)%> 원</td>
				<td class=" bor_bot">상품 총 가격 : <%=num2cur(DKRS_ALL_GOODS_PRICE)%> 원 + 옵션 총 가격 : <%=num2cur(DKRS_ALL_OPTION_PRICE)%> 원</td>
			</tr><tr>
				<td class="th bor_bot">배송비</td>
				<td class="tright bor_right bor_bot"><%=num2cur(DKRS_totalDelivery)%> 원</td>
				<td class=" bor_bot">배송비 : <%=num2cur(DKRS_totalDelivery)%> 원</td>
			</tr><tr>
				<td rowspan="2" class="th bor_bot" >총 결제금액</td>
				<td rowspan="2" class="tright bor_right bor_bot"><strong class="red"><%=num2cur(DKRS_totalPrice)%></strong> 원</td>
				<td class=" bor_bot">
					<%=FN_PAYWAY_VIEW(DKRS_payWay)%>
				</td>
			</tr><tr>
				<td class="lheight160 bor_bot">
					<%
						Select Case UCase(DKRS_payWay)
							Case "INBANK"
								arrParams = Array(_
									Db.makeParam("@intIDX",adInteger,adParamInput,4,DKRS_bankIDX) _
								)
								Set DKRS1 = Db.execRs("DKP2_MYPAGE_ORDER_BANK",DB_PROC,arrParams,Nothing)
								If Not DKRS1.BOF And Not DKRS1.EOF Then
									DKRS1_intIDX			= DKRS1("intIDX")
									DKRS1_BankName			= DKRS1("BankName")
									DKRS1_BankNumber		= DKRS1("BankNumber")
									DKRS1_BankOwner			= DKRS1("BankOwner")
									DKRS1_isUse				= DKRS1("isUse")

									PRINT "입금은행 : " & DKRS1_BankName &" : "& DKRS1_BankNumber &" : "& DKRS1_BankOwner &"<br />"
									PRINT "입금자명 : " &DKRS_bankingName &"<br />"


								Else

								End If
							Case "INCASH"
							Case "CARD"
								PRINT FN_INICIS_CARDCODE_VIEW(DKRS_PGCardCode) & "("& DKRS_PGCardNum &"**********) " &DKRS_PGinstallment & "<br />"
								PRINT DKRS_status101Date

							Case "DBANK"
								PRINT "결제사 : (<a href=""https://inicis.com"" target=""_blank"">http://inicis.com</a>)"
								PRINT "결제은행 : "& FN_INICIS_BANKCODE_VIEW(DKRS_PGCardCom) &"<br />"

							Case "VBANK"
								PRINT "결제사 : (<a href=""https://inicis.com"" target=""_blank"">http://inicis.com</a>)"&"<br />"
								PRINT "입금은행 : "& FN_INICIS_BANKCODE_VIEW(DKRS_PGINPUT_BANKCODE) &"<br />"
								PRINT "입금계좌 : "& DKRS_PGCardNum &"<br />"
								PRINT "입금자명 : "& DKRS_PGAcceptNum &"<br />"
								PRINT "입금예정일 : "& date8to10(DKRS_PGCardCode) &"<br />"

						End Select


					%>



				</td>
			</tr>
		</tbody>
	</table>

	<div style=" margin-top:20px;"><%=viewImg(IMG_MYPAGE&"/orderView_goods_tit.png",87,17,"")%></div>

	<div class="list">
		<table <%=tableatt%> class="userCWidth2" style="margin-top:5px;">
			<col width="40" />
			<col width="80" />
			<col width="350" />
			<col width="50" />
			<col width="110" />
			<col width="*" />
			<thead>
				<tr>
					<th></th>
					<th colspan="2">주문상품</th>
					<th>수량</th>
					<th>상품금액</th>
					<th class="last">배송상태</th>
				</tr>
			</thead>


			<%


				arrParams1 = Array(_
					Db.makeParam("@orderIDX",adInteger,adParamInput,0,DKRS_intIDX), _
					Db.makeParam("@GOODSCNT",adInteger,adParamOutput,0,0) _
				)
				arrList1 = Db.execRsList("DKP2_ORDER_LIST_DETAIL",DB_PROC,arrParams1,listLen1,Nothing)
				GOODS_CNT = arrParams(Ubound(arrParams))(4)
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

						imgPath = VIR_PATH("goods2/thum")&"/"&backword(arrList1_imgThum)
						imgWidth = 0
						imgHeight = 0
						Call ImgInfo(imgPath,imgWidth,imgHeight,"")
						imgMarginH = (65 - imgHeight) / 2

						Goods_Price = (arrList1_GoodsPrice * arrList1_orderEa) + (arrList1_GoodsOptionPrice * arrList1_orderEa)

					'B.[imgThum],A.[reviewTF],A.[intIDX],A.[GoodsPrice],A.[GoodsOptionPrice],A.[GoodsName]
					If j = listLen1 Then trClass=" class=""last"" " Else trClass = "" End If

			%>
			<tbody class="lines">
				<tr>
					<td class="tcenter"><%=j+1%></td>
					<td class="tcenter"><div class="thumImg tcenter" style=""><%=viewImgOPT(imgPath,imgWidth,imgHeight,"","style=""margin-top:"&imgMarginH&"px;""")%></div></td>
					<td class="bor_right vtop orderGoods">
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
					<td class="bor_right tcenter"><%=num2cur(arrList1_orderEa)%></td>
					<td class="bor_right tcenter orderPrice">
						<strong><%=num2cur(Goods_Price)%> 원</strong>

					</td>
					<td class="bor_right tcenter font11px DtoD lheight160">
						<%

							If DKRS_status = "102" Or DKRS_status = "103" Then
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

							If DKRS_status = "103" Then
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
			</tbody>
		</table>
	</div>



	<div style=" margin-top:20px;"><%=viewImg(IMG_MYPAGE&"/orderView_dtod_tit.png",69,17,"")%></div>
	<table <%=tableatt%> class="width100 dtod" style="margin-top:5px;">
		<col width="135" />
		<col width="180" />
		<col width="*" />
		<tbody>
			<tr>
				<td class="th bor_bot">주문자 정보</td>
				<td colspan="2" class="bor_bot">
					<p class="tweight"><%=DKRS_strName%></p>
					<p>(<%=DKRS_strZip%>) <%=DKRS_strADDR1%>&nbsp;<%=DKRS_strADDR2%></p>
					<p><%=DKRS_strTel%> / <%=DKRS_strMob%> / <%=DKRS_strEmail%></p>
				</td>
			</tr><tr>
				<td class="th bor_bot">배송지 정보</td>
				<td colspan="2" class="bor_bot">
					<p class="tweight"><%=DKRS_takeName%></p>
					<p>(<%=DKRS_takeZip%>) <%=DKRS_takeADDR1%>&nbsp;<%=DKRS_takeADDR2%></p>
					<p><%=DKRS_takeTel%> / <%=DKRS_takeMob%></p>
				</td>
			</tr><tr>
				<td class="th bor_bot">주문 시 요청사항</td>
				<td colspan="2" class="bor_bot"><%=DKRS_orderMemo%></td>
			</tr>
		</tbody>
	</table>

	<div style="margin:20px 20px;" class="tcenter"><a href="orderlist.asp"><img src="<%=IMG_MYPAGE%>/BtnGoOrder.gif" width="100" height="49" alt="" /></a></div>
</div>

<!--#include virtual="/_include/copyright.asp" -->
