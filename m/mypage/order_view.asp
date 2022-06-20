<!--#include virtual = "/_lib/strFunc.asp"-->
<%

	PAGE_SETTING = "SHOP"

	orderNum = gRequestTF("orderNum",True)

	Response.Redirect "/m/buy/order_list.asp"


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

	'CS 주문번호 호출
		SQL2 = "SELECT [OrderNumber] FROM [tbl_SalesDetail] WHERE [ETC2] = '웹주문번호:'+ ? "
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

	Else
		Call ALERTS("주문정보가 옳바르지 않습니다.2","go","/index.asp")
	End If
	Call closeRS(DKRS)




%>
<!--#include virtual = "/m/_include/document.asp"-->
<!--#include virtual = "/m/_include/jqueryload.asp"-->

<meta http-equiv="Cache-Control" content="no-cache"/>
<meta http-equiv="Expires" content="0"/>
<meta http-equiv="Pragma" content="no-cache"/>
<meta http-equiv="X-UA-Compatible" content="requiresActiveX=true" />
<link rel="stylesheet" href="order_view.css">

<script type="text/javascript" src="/m/js/check.js"></script>

<link rel="stylesheet" href="/m/js/icheck/skin/line/_all.css" />
<script src="/m/js/icheck/icheck.min.js"></script>
<script type="text/javascript" src="/m/js/calendar.js"></script>

</head>
<body>
<!--#include virtual = "/m/_include/header.asp"-->
<!--#include virtual = "/m/_include/sub_header.asp"-->
<div id="shop" class="detailView porel">
	<div id="cart_title_b" class="width100 tcenter text_noline tweight" >주문 상세 보기</div>
	<div id="cart_title_m" class="cart_title_m" >배송지 정보</div>
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
		<div id="user_info1" class="user_info1 clear">
			<table <%=tableatt%> class="width100">
				<col width="80" />
				<col width="*" />
				<tr>
					<th>받는분</th>
					<td><%=DKRS_takeName%></td>
				</tr><tr>
					<th>연락처</th>
					<td><%=DKRS_takeMob%></td>
				</tr><tr>
					<th>이메일</th>
					<td><%=DKRS_strEmail%></td>
				</tr><tr>
					<th class="vtop">주소</th>
					<td style="line-height:18px;">(<%=DKRS_takeZip%>) <%=DKRS_takeADDR1%>&nbsp;<%=DKRS_takeADDR2%></td>
				</tr><tr>
					<th>요청사항</th>
					<td><%=DKRS_orderMemo%></td>
				</tr>
			</table>
		</div>





		<div class="cart_title_m" style="margin-top:15px;">구매상품 정보</div>
		<%
			k = 0
			arrParams = Array(_
				Db.makeParam("@orderIDX",adInteger,adParamInput,4,DKRS_intIDX) _
			)
			arrList = Db.execRsList("DKP_ORDER_GOODS_VIEW",DB_PROC,arrParams,listLen,Nothing)
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

							arrList_imgType					= arrList(28,i)
						'print
							If arrList_imgType = "S" Then
								imgPath = VIR_PATH("goods/thum")&"/"&backword(arrList_ImgThum)
							Else
								imgPath = BACKWORD(arrList_imgList)
							End If

							printGoodsIcon = ""
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
									If DKRS4_isCSGoods	= "T" Then printGoodsIcon = printGoodsIcon & "<span class=""icons"">"&viewImg(IMG_ICON&"/i_csgoodsT.gif",50,11,"")&"</span>"
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
								self_GoodsOptionPrice	= arrList_orderEa * arrList_goodsOptionPrice
								self_TOTAL_PRICE		= selfPrice + self_optionPrice


								If arrList_GoodsDeliveryType = "SINGLE" Then
									arrList_DELICNT		= 1
									self_DeliveryFee	= Int(arrList_orderEa) * Int(arrList_GoodsDeliveryFee)
									txt_DeliveryFee = "<span class=""tweight"">선결제 "&spans(num2cur(self_DeliveryFee),"#FF6600","","")&"원</span>"
									txt_DeliveryInfo = "<span class=""f11px"">단독배송상품 / 개당 "&num2cur(self_DeliveryFee)&"원 </span>"

								ElseIf arrList_GoodsDeliveryType = "AFREE" Then
									self_DeliveryFee = "0"
									txt_DeliveryFee = "<span class=""tweight"">"&spans("무료배송상품(묶음배송불가)","#0099FF","","")&"</span>"
									txt_DeliveryFeeType = "무료배송(묶음배송불가)"
									txt_DeliveryInfo = "<span class=""f11px"">무료배송(묶음배송불가)</span>"
									arrList_DELICNT = 1

								ElseIf arrList_GoodsDeliveryType = "BASIC" Then
									If arrList_DELICNT = 1 Then
										arrParams2 = Array(_
											Db.makeParam("@strShopID",adVarChar,adParamInput,30,arrList_strShopID) _
										)
										Set DKRS2 = DB.execRs("DKP_DELIVERY_FEE_VIEW",DB_PROC,arrParams2,Nothing)'DKPA_DELIVEY_FEE_VIEW
										If Not DKRS2.BOF And Not DKRS2.EOF Then
											DKRS2_strShopID			= DKRS2("strShopID")
											DKRS2_strComName		= DKRS2("strComName")
											DKRS2_FeeType			= DKRS2("FeeType")
											DKRS2_intFee			= Int(DKRS2("intFee"))
											DKRS2_intLimit			= Int(DKRS2("intLimit"))
											'PRINT printDeli(DKRS2_FeeType)
											'If DKRS2_FeeType <> "FREE" Then
											'	PRINT num2cur(DKRS2_intFee) & "원 ("&num2cur(DKRS2_intLimit) &"원 이상 무료배송)"
											'End If
										Else
											Response.Write "(기본배송비정책이 입력되지 않았습니다)"
										End If
										Call closeRS(DKRS2)
										'print "s : " &self_total_price
										Select Case LCase(DKRS2_FeeType)
											Case "free"
												self_DeliveryFee = 0
												txt_DeliveryFee = "<span class=""tweight"">"&spans("무료배송","#FF6600","","")&"</span>"
												txt_DeliveryInfo = "<span class=""f11px"">무료배송</span>"
												txt_DeliveryFeeType = "무료배송"
											Case "prev"
												If self_total_price >= DKRS2_intLimit Then
													self_DeliveryFee = 0
													txt_DeliveryFee = "<span class=""tweight"">"&spans("무료배송","#FF6600","","")&"</span>"
													txt_DeliveryInfo = "<span class=""f11px"">묶음배송 상품 / "&num2cur(DKRS2_intLimit)&" 원 이상 무료배송</span>"
													txt_DeliveryFeeType = "무료배송"
												Else
													self_DeliveryFee = DKRS2_intFee
													txt_DeliveryFee = "<span class=""tweight"">선결제 "&num2cur(self_DeliveryFee)&"원</span>"
													txt_DeliveryInfo = "<span class=""f11px"">묶음배송 상품 / "&num2cur(DKRS2_intLimit)&" 원 이상 무료배송</span>"
													txt_DeliveryFeeType = "선결제"
												End If
											Case "next"
												If self_total_price >= DKRS2_intLimit Then
													self_DeliveryFee = 0
													txt_DeliveryFee = "<span class=""tweight"">"&spans("무료배송","#FF6600","","")&"</span>"
													txt_DeliveryInfo = "<span class=""f11px"">묶음배송 상품 / "&num2cur(DKRS2_intLimit)&" 원 이상 무료배송</span>"
													txt_DeliveryFeeType = "무료배송"
												Else
													txt_DeliveryFee = "<span class=""tweight"">착불 "&num2cur(self_DeliveryFee)&"원</span>"
													txt_DeliveryInfo = "<span class=""f11px"">"&num2cur(DKRS2_intLimit)&"원 이상 무료배송</span>"
													txt_DeliveryFeeType = "착불"
													self_DeliveryFee  = 0
												End If
										End Select
									Else
										arrParams2 = Array(_
											Db.makeParam("@strShopID",adVarChar,adParamInput,30,arrList_strShopID) _
										)
										Set DKRS2 = DB.execRs("DKP_DELIVERY_FEE_VIEW",DB_PROC,arrParams2,Nothing)'DKPA_DELIVEY_FEE_VIEW
										If Not DKRS2.BOF And Not DKRS2.EOF Then
											DKRS2_strShopID			= DKRS2("strShopID")
											DKRS2_strComName		= DKRS2("strComName")
											DKRS2_FeeType			= DKRS2("FeeType")
											DKRS2_intFee			= Int(DKRS2("intFee"))
											DKRS2_intLimit			= Int(DKRS2("intLimit"))
										Else
											Call ALERTS("기본배송비정책이 입력되지 않았거나 삭제된 상품입니다.. 관리자에게 문의해주세요.","back","")
										End If
										Call closeRS(DKRS2)


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
										Select Case LCase(DKRS2_FeeType)
											Case "free"
												self_DeliveryFee = 0
												txt_DeliveryFee = "<span class=""tweight"">"&spans("무료배송","#FF6600","","")&"</span>"
												txt_DeliveryInfo = "<span class=""f11px"">무료배송</span>"
												txt_DeliveryFeeType = "무료배송"
											Case "prev"
												If self_total_price >= DKRS2_intLimit Then
													self_DeliveryFee = 0
													txt_DeliveryFee = "<span class=""tweight"">"&spans("무료배송","#FF6600","","")&"</span>"
													txt_DeliveryInfo = "<span class=""f11px"">묶음배송 상품 / "&num2cur(DKRS2_intLimit)&" 원 이상 무료배송</span>"
													txt_DeliveryFeeType = "무료배송"
												Else
													self_DeliveryFee = DKRS2_intFee
													txt_DeliveryFee = "<span class=""tweight"">선결제 "&num2cur(self_DeliveryFee)&"원</span>"
													txt_DeliveryInfo = "<span class=""f11px"">묶음배송 상품 / "&num2cur(DKRS2_intLimit)&" 원 이상 무료배송</span>"
													txt_DeliveryFeeType = "선결제"

												End If
											Case "next"
												If self_total_price >= DKRS2_intLimit Then
													self_DeliveryFee = "0"
													txt_DeliveryFee = "<span class=""tweight"">"&spans("무료배송","#FF6600","","")&"</span>"
													txt_DeliveryInfo = "<span class=""f11px"">묶음배송 상품 / "&num2cur(DKRS2_intLimit)&" 원 이상 무료배송</span>"
													txt_DeliveryFeeType = "무료배송"
												Else
													txt_DeliveryFee = "<span class=""tweight"">착불 "&num2cur(self_DeliveryFee)&"원</span>"
													txt_DeliveryInfo = "<span class=""f11px"">"&num2cur(DKRS2_intLimit)&"원 이상 무료배송</span>"
													txt_DeliveryFeeType = "착불"
													self_DeliveryFee  = 0
												End If
										End Select
									End If
								End If


			%>
			<div class="width100">
				<div class="index_v_goods porel ">
					<div class="porel cartGoodsArea">
						<div class="poabs cartGoodsImg" style=""><img src="<%=imgPath%>" width="100%" height="90" alt="" /></div>
						<div class="porel ovhi" style="margin-left:110px; min-height:100px;">
							<div style="padding-top:10px; ">
								<div class="cartIcon"><%=printGoodsIcon%></div>
								<div class="cartGoodsName tweight text_noline"><%=arrList_GoodsName%></div>
								<div class="cartOptName text_noline"><%=printOPTIONS%></div>
								<div class="porel" style="margin-top:15px; ">
									<div style="font-size:17px; color:#222; font-weight:bold; line-height:20px; letter-spacing:-1px;">
										<span style="font-size:0.65em">
											<span style="vertical-align:-2px; color:#ff6600; font-size:17px;"><%=num2cur(arrList_GoodsPrice)%></span> 원
											<%If arrList_isCSGoods = "T" And DK_MEMBER_TYPE = "COMPANY"  And DK_MEMBER_STYPE = "0" Then%>
											 / <span style="vertical-align:-1px;color:#d43f05; font-size:14px;"><%=num2cur(self_PV)%></span> PV
											<%End If%>
											/ <%
												If k = 1 Then
													print txt_DeliveryFee
												Else
													print "묶음배송상품"
												End If
											%>
										</span>
									</div>
								</div>
							</div>
						</div>
						<div class="porel" style="padding:7px 0px; background-color:#f4f4f4; margin:10px 10px 0px 10px;">
							<div style="text-indent:7px; line-height:20px;">
								<div>
									<span class="goodsInfo_span">상품가격</span>
									<span style="letter-spacing:-1px; font-size:12px;"><%=num2cur(arrList_GoodsPrice)%> 원 / 개</span>
								</div>
								<div>
									<span class="goodsInfo_span">구매수량</span>
									<span style="letter-spacing:-1px; font-size:12px;"><%=arrList_orderEa%> 개</span>
								</div>
								<%If arrList_isCSGoods = "T" And DK_MEMBER_TYPE = "COMPANY"  And DK_MEMBER_STYPE = "0" Then%>
									<div>
										<span class="goodsInfo_span">상품P.V</span>
										<span style="letter-spacing:-1px; font-size:12px;"><%=num2cur(RS_PRICE4)%> PV / 개</span>
									</div>
								<%End If%>
								<%If self_Point > 0 Then%>
								<div>
									<span class="goodsInfo_span">적립금</span>
									<span style="letter-spacing:-1px; font-size:12px;"><%=num2cur(self_Point)%> 원 (<%=num2cur(self_Point)%> * <%=orderEa%>)</span>
								</div>
								<%End If%>
								<div>
									<span class="goodsInfo_span">배송정책</span>
									<span style="letter-spacing:-1px; font-size:11px;"><%=txt_DeliveryInfo%></span>
								</div>


								<!--
								<span style="background-color:#eee; padding:4px 6px; letter-spacing:-1px;">선불배송</span><br />
								<span style="background-color:#eee; padding:4px 6px; letter-spacing:-1px;">후불배송</span><br />
								<span style="background-color:#eee; padding:4px 6px; letter-spacing:-1px;">조건부무료</span><br /> -->
							</div>
						</div>
					</div>


				</div>
			</div>








		<%
			Next
			End If
		%>

			<div class="cart_title_m" style="margin-top:15px; border-bottom:0px none;">결제 금액</div>
			<div class="width100">
				<div class="totalSum porel cartPriceArea" style="">
					<div class="porel ">
						<div class="porel" style="padding:7px 0px; background-color:#f4f4f4; margin:10px 10px 10px 10px;">
							<div style="line-height:20px;">
								<div>
									<span class="cartPrice_tit" >상품가격</span>
									<span class="cartPrice_Res" style=""><strong><%=num2cur(DKRS_totalPrice-DKRS_totalDelivery)%></strong> 원</span>
								</div>

								<%If DKRS_totalOptionPrice > 0 Then%>
								<div>
									<span class="cartPrice_tit">옵션가</span>
									<span class="cartPrice_Res"><strong><%=num2cur(DKRS_totalOptionPrice)%></strong> 원</span>
								</div>
								<%End If%>
								<div>
									<span class="cartPrice_tit">배송비</span>
									<span class="cartPrice_Res"><span id="delTXT" style="font-size:0.95em; margin-right:10px;"></span><strong id="priTXT"><%=num2cur(DKRS_totalDelivery)%></strong> 원</span>
								</div>
								<div style="margin-top:10px;">
									<span class="cartPrice_tit tweight">결제금액</span>
									<span class="cartPrice_Res"><strong id="lastTXT" style="color:#f20000; font-size:24px;"><%=num2cur(DKRS_totalPrice)%></strong> 원</span>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>




</div>
<!--#include virtual = "/m/_include/copyright.asp"-->