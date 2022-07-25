<!--#include virtual="/_lib/strFunc.asp" -->
<%

	PAGE_SETTING = "SHOP"
	ISLEFT = "F"
	ISSUBTOP = "T"
	ISSUBVISUAL = "T"

	Call ONLY_MEMBER(DK_MEMBER_LEVEL)

	orderNum = gRequestTF("orderNum",True)


	If orderNum = "" Then Call ALERTS(LNG_SHOP_ORDER_FINISH_01,"back","")

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
		DKRS_totalPrice						= CDbl(DKRS("totalPrice"))
		DKRS_totalDelivery					= CDbl(DKRS("totalDelivery"))
		DKRS_totalOptionPrice				= CDbl(DKRS("totalOptionPrice"))
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
		DKRS_usePoint2						= Int(DKRS("usePoint2"))
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
		DKRS_CSORDERNUM						= DKRS("CSORDERNUM")
		DKRS_strNationCode					= DKRS("strNationCode")

		DKRS_vBankCode						= DKRS("vBankCode")
		DKRS_vBankName						= DKRS("vBankName")
		DKRS_vBankDepName					= DKRS("vBankDepName")
		DKRS_vBankAccNum					= DKRS("vBankAccNum")
		DKRS_vBankRecvName					= DKRS("vBankRecvName")
		DKRS_vBankDepDate					= DKRS("vBankDepDate")
		DKRS_vBankAmt						= DKRS("vBankAmt")
		DKRS_vBankSetDate					= DKRS("vBankSetDate")
		DKRS_vBankTRX						= DKRS("vBankTRX")

	'회원정보 복호화
		If DKCONF_SITE_ENC = "T" And DKCONF_ISCSNEW = "T" Then
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
					If DKRS_PGCardNum	<> "" Then DKRS_PGCardNum	= Trim(objEncrypter.Decrypt(DKRS_PGCardNum))
				On Error GoTo 0
			Set objEncrypter = Nothing
		End If

		'CS 주문번호
		If DKRS_CSORDERNUM = "" Then
			SQL2 = "SELECT [OrderNumber] FROM [tbl_SalesDetail] WITH(NOLOCK) WHERE [ETC2] = '웹주문번호:'+ ? "
			arrParams = Array(Db.makeParam("@OrderNum",adVarChar,adParamInput,20,DKRS_OrderNum))
			Set HJRSC = DB.execRs(SQL2,DB_TEXT,arrParams,DB3)
			If Not HJRSC.BOF And Not HJRSC.EOF Then
				RS_CSOrderNumber = HJRSC(0)
				DKRS_CSORDERNUM = RS_CSOrderNumber
			Else
				RS_CSOrderNumber = ""
				DKRS_CSORDERNUM = "<span class=""red2"">발급 오류 - 본사로 문의해주세요.</span> (확인코드 : "&DKRS_OrderNum&")"
			End If
			Call closeRS(HJRSC)
		End IF

	Else
		Call ALERTS(LNG_SHOP_ORDER_FINISH_01,"go","/index.asp")
	End If
	Call closeRS(DKRS)


	If DK_MEMBER_ID <> DKRS_strUserID Then Call alerts(LNG_SHOP_ORDER_FINISH_03,"go","/common/member_logout.asp")

%>
<%
	'Cosmico v_SellCode 02 PV X
	If DKRS_CSORDERNUM <> "" Then
		SQL2 = "SELECT [SellCode] FROM [tbl_SalesDetail] WITH(NOLOCK) WHERE [OrderNumber] = ? "
		arrParams = Array(Db.makeParam("@OrderNum",adVarChar,adParamInput,20,DKRS_CSORDERNUM))
		Set HJRSC = DB.execRs(SQL2,DB_TEXT,arrParams,DB3)
		If Not HJRSC.BOF And Not HJRSC.EOF Then
			v_SellCode = HJRSC(0)
		Else
			v_SellCode = ""
		End If
		Call closeRS(HJRSC)
	End If
%>
<%
	'직판 공제번호
	If DK_MEMBER_TYPE = "COMPANY" And DKCONF_SITE_ENC = "T" And isMACCO = "T" Then
		SQL2 = "SELECT [InsuranceNumber],[INS_Num_Err] FROM [tbl_SalesDetail] WITH(NOLOCK) WHERE [ETC2] = '웹주문번호:'+ ? AND ([InsuranceNumber] <> '' OR [INS_Num_Err] <> '') "
		arrParams = Array(_
			Db.makeParam("@OrderNum",adVarChar,adParamInput,20,DKRS_OrderNum) _
		)
		Set HJRSC = DB.execRs(SQL2,DB_TEXT,arrParams,DB3)
		If Not HJRSC.BOF And Not HJRSC.EOF Then
			RS_INS_Num = HJRSC(0)
			RS_INS_Num_Err = HJRSC(1)
		Else
			RS_INS_Num = ""
			RS_INS_Num_Err = ""
		End If
		Call closeRS(HJRSC)
	End If
%>
<!--#include virtual="/_include/document.asp" -->
<link rel="stylesheet" href="/css/order.css?v0" />
<script type="text/javascript" src="/shop/orderCalc.js"></script>
<script type="text/javascript">
	$(document).ready(function(){
		deliveryClassfy();
	});

	function deliveryClassfy() {
		let SHOP_ORDERINFO_VIEW_TF = $("input[name=SHOP_ORDERINFO_VIEW_TF]").val();
		let DtoD = $("input[name=DtoD]").val();

		if (SHOP_ORDERINFO_VIEW_TF == 'T') {
			$("#orderInfo").css("width","48%");
			$("#deliveryInfo").css("width","48%");
		}else{
			$("#orderInfo").hide();
			$("#deliveryInfo").css("width","100%");
		}

		if (DtoD == 'F') {		//현장수령
			if (SHOP_ORDERINFO_VIEW_TF == 'T') {
				$("#orderInfo").hide();
				$("#deliveryInfo").css("width","100%");
			}
			$("#deliveryInfo").show();
			$(".directpickup").hide();
			$(".directpickupTitle").show();

		} else {
			if (SHOP_ORDERINFO_VIEW_TF == 'T') {
				$("#orderInfo").show();
				$("#deliveryInfo").css("width","48%");
			}
			$("#deliveryInfo").show();
			$(".directpickup").show();
			$(".directpickupTitle").hide();
		}
	}

</script>
</head>
<body>
<!--#include virtual="/_include/header.asp" -->
<div id="order" class="orderFinish">
	<div class="order_finish">
		<h5><%=LNG_SHOP_ORDER_FINISH_04%></h5>
		<%If DK_MEMBER_TYPE="COMPANY" Then%>
			<div><%=LNG_TEXT_ORDER_NUMBER_CS%> : <span class="ordNo"><%=DKRS_CSORDERNUM%></span></div>
			<%If isMACCO = "T" Then%>
			<div>
				<%If RS_INS_Num <> "" Then%>
					공제번호 : <%=spans(RS_INS_Num,"green","","")%>
				<%ElseIf RS_INS_Num_Err <> "" And RS_INS_Num = "" THEN%>
					공제번호발급이 실패되었습니다. 에러코드 : <%=spans(RS_INS_Num_Err,"red","","")%>
				<%Else%>
					공제번호 : <%=spans("재발급 요청 요망","red","","")%>
				<%End If%>
			</div>
			<%End If%>
		<%Else%>
			<div><%=LNG_SHOP_ORDER_FINISH_02%> : <span class="ordNo"><%=DKRS_OrderNum%></span>
				<%If DK_MEMBER_ID = "GUEST" Then%><%=LNG_SHOP_ORDER_FINISH_06%><%End If%>
			</div>
		<%End If%>
	</div>

		<div class="cleft width100 order_list">
			<div class="order_title"><%=LNG_SHOP_ORDER_DIRECT_TITLE_03%></div>
			<table <%=tableatt%> class="width100 list goodsInfo">
				<colgroup>
					<col width="100" />
					<col width="*" />
					<col width="180" />
					<col width="100" />
					<col width="180" />
					<col width="170" />
				</colgroup>
				<thead>
					<tr>
						<th colspan="2"><%=LNG_SHOP_ORDER_DIRECT_TABLE_01%></th>
						<th><%=LNG_SHOP_ORDER_DIRECT_TABLE_02%></th>
						<th><%=LNG_SHOP_ORDER_DIRECT_TABLE_03%></th>
						<th><%=LNG_SHOP_ORDER_DIRECT_TABLE_04%></th>
						<th><%=LNG_SHOP_ORDER_DIRECT_TABLE_05%></th>
					</tr>
				</thead>
				<tbody>
				<%
					TOTAL_DeliveryFee = 0 	'최종 배송금액
					TOTAL_OptionPrice =  0
					TOTAL_OptionPrice2 =  0
					TOTAL_Price = 0 				'상품가(옵션가 포함)
					TOTAL_SUM_PRICE = 0			'최종 결제금액
					TOTAL_PV = 0
					TOTAL_GV = 0

					k = 0
					arrParams = Array(_
						Db.makeParam("@orderIDX",adInteger,adParamInput,4,DKRS_intIDX) _
					)
					'arrList = Db.execRsList("DKP_ORDER_GOODS_VIEW",DB_PROC,arrParams,listLen,Nothing)
					arrList = Db.execRsList("DKSP_ORDER_GOODS_VIEW",DB_PROC,arrParams,listLen,Nothing)
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
							arrList_GoodsPrice				= CDbl(arrList(9,i))
							arrList_goodsOptionPrice		= CDbl(arrList(10,i))
							arrList_goodsPoint				= Int(arrList(11,i))
							arrList_goodsCost				= CDbl(arrList(12,i))
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

							arrList_status					= arrList(24,i)
							arrList_isImgType					= arrList(25,i)
							arrList_CSGoodsCode					= arrList(26,i)

							arrList_TOTAL_SHOPCNT		= arrList(27,i)	'add
							arrList_GoodsNote			= ""

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

							If DK_MEMBER_TYPE = "COMPANY" Or DK_MEMBER_TYPE ="ADMIN" Then
								'If arrList_CSGoodsCode	<> "" Then printGoodsIcon = printGoodsIcon & "<span class=""icons"">"&viewImg(IMG_ICON&"/i_csgoodsT.gif",50,11,"")&"</span>"
							End If
							'################################################################## END


							'##################################################################
							' 루프내 가격 초기화
							'################################################################## START
							self_GoodsPrice = 0
							self_GoodsPoint = 0
							self_GoodsOptionPrice	= 0
							self_TOTAL_PRICE = 0
							self_PV = 0
							self_GV = 0

							sum_optionPrice = 0
							'################################################################## END


							'##################################################################
							' CS회원인 경우 PV값 / CV값 확인 (SalesItemDetail)
							'################################################################## START
							arr_CS_price4 = 0
							arr_CS_SELLCODE		= ""
							arr_CS_SellTypeName = ""

							If DKRS_CSORDERNUM <> "" Then
								arrParams = Array(_
									Db.makeParam("@OrderNumber",adVarChar,adParamInput,50,DKRS_CSORDERNUM), _
									Db.makeParam("@ncode",adVarChar,adParamInput,20,arrList_CSGoodsCode) _
								)
								Set DKRS = Db.execRs("HJP_CSGOODS_ORDER_PRICE_INFO",DB_PROC,arrParams,DB3)
								If Not DKRS.BOF And Not DKRS.EOF Then
									arr_CS_price4		= DKRS("ItemPV")
									arr_CS_price5		= DKRS("ItemCV")
									arr_CS_SellCode		= DKRS("Item_SellCode")
									arr_CS_SellTypeName	= DKRS("SellTypeName")
									If arr_CS_SellTypeName <> "" Then
										arr_CS_SellTypeName = LNG_SHOP_ORDER_DIRECT_PAY_04&" : "&arr_CS_SellTypeName
									End If
								End If
								Call closeRs(DKRS)
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
							self_GoodsPrice			= arrList_orderEa * arrList_GoodsPrice
							self_GoodsPoint			= arrList_orderEa * arrList_goodsPoint
							self_GoodsOptionPrice	= arrList_orderEa * arrList_goodsOptionPrice
							self_TOTAL_PRICE		= self_GoodsPrice + self_GoodsOptionPrice
							self_PV = Int(arrList_orderEa) * Int(arr_CS_price4)
							self_GV = Int(arrList_orderEa) * Int(arr_CS_price5)
							'################################################################## END

							'##################################################################
							' 배송비 확인
							'################################################################## START
							Select Case arrList_GoodsDeliveryType
								Case "SINGLE"
									arrList_GoodsDeliveryFee = arrList_GoodsDeliveryFee / arrList_orderEa			'주문완료 : 개당 단독배송비 계산

									self_DeliveryFee = Int(arrList_orderEa) * CDbl(arrList_GoodsDeliveryFee)
									txt_DeliveryFeeType = LNG_SHOP_ORDER_DIRECT_TABLE_08	'단독배송
									txt_self_DeliveryFee = " "&num2cur(self_DeliveryFee)&" "&Chg_currencyISO
									txt_DeliveryFee = "<span class=""tweight"">"&txt_DeliveryFeeType& "<br />"&txt_self_DeliveryFee&"</span>"
									'*상품별 배송비
									''txt_DeliveryFeeEach = "<span class=""deliveryeach"">("&LNG_CS_ORDERS_DELIVERY_PRICE&" "&num2cur(self_DeliveryFee)&" "&Chg_currencyISO&")</span>"
									DKRS2_intDeliveryFee = arrList_GoodsDeliveryFee		'BASIC_DeliveryFee (each)

									arrList_DELICNT = 1

								Case "BASIC"
									'▣ 국가별 배송비 (주문시점)
									DKRS2_intDeliveryFee = arrList_GoodsDeliveryFee
									DKRS2_intDeliveryFeeLimit = arrList_GoodsDeliveryLimit

									If arrList_DELICNT > 1 Then
										arrParams3 = Array(_
											Db.makeParam("@orderIDX",adInteger,adParamInput,4,DKRS_intIDX), _
											Db.makeParam("@strShopID",adVarChar,adParamInput,30,arrList_strShopID), _
											Db.makeParam("@GoodsDeliveryType",adVarChar,adParamInput,6,arrList_GoodsDeliveryType) _
										)
										arrList3 = Db.execRsList("DKSP_ORDER_DELIVERY_CALC2",DB_PROC,arrParams3,listLen3,Nothing)
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

									'txt_DeliveryFee = "<span class=""tweight"">"&txt_DeliveryFeeType&txt_self_DeliveryFee&"</span>"		'배송비 조건표기X

									'*상품별 배송비
									''If selfPrice >= DKRS2_intDeliveryFeeLimit Then
									''	txt_DeliveryFeeEach = "<span class=""deliveryeach"">("&LNG_SHOP_ORDER_DIRECT_TABLE_10&")</span>"		'무료배송
									''Else
									''	txt_DeliveryFeeEach = "<span class=""deliveryeach"">("&LNG_CS_ORDERS_DELIVERY_PRICE&" "&num2cur(DKRS2_intDeliveryFee)&" "&Chg_currencyISO&")</span>"
									''End If

							End Select
							'################################################################## END

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


							TOTAL_PV = TOTAL_PV + self_PV
							TOTAL_GV = TOTAL_GV + self_GV

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
					<input type="hidden" name="shopIdTOT" id="shopIdTOT<%=i%>" attrShopID="<%=attrShopID%>" attrShopIdTOT="<%=attrShopIdTOT%>" value="<%=arrList_intIDX%>" readonly="reaonly"/>
					<input type="hidden" name="GoodIDXs" value="<%=arrList_GoodIDX%>" readonly="readonly"/><%'◆%>
					<input type="hidden" name="strOptions" value="<%=arrList_strOption%>" readonly="readonly"/><%'◆%>

					<tr class="<%=trClass%><%=trClass2%>">
						<td class="tcenter">
							<div class="thumImg" style="padding:<%=imgPaddingH%>px 0px;"><%=viewImg(imgPath,imgWidth,imgHeight,"")%></div>
						</td>
						<td class="vtop">
							<%If printGoodsIcon <> "" Then%>
								<p><%=printGoodsIcon%></p>
							<%End If%>
							<%If Int(arrList_TOTAL_SHOPCNT) > 1 Then%>
								<p><span class="strComName"><%=txt_strComName%></span></p>
							<%End If%>
							<p><span class="goodsName"><%=backword(arrList_GoodsName)%></span></p>
							<p><span class="goodsNote"><%=backword(arrList_GoodsNote)%></span></p>
							<%If DK_MEMBER_TYPE = "COMPANY" Then%>
								<p><span class="selltypeName"><%=arr_CS_SellTypeName%></span></p>
							<%End If%>
							<p class="goodsOption"><%=printOPTIONS%></p>
						</td>
						<td class="tcenter bor_l">
							<%=spans(num2cur(self_GoodsPrice/arrList_orderEa),"#222222","12","400")%><%=spans(""&Chg_currencyISO&"","#222222","11","400")%>
							<%If v_SellCode <> "02"  Then 'COSMICO%>
								<%If PV_VIEW_TF = "T" Then%>
								<br /><%=spans(num2curINT(self_PV/arrList_orderEa),"#f2002e","11","400")%><%=spans(""&CS_PV&"","#f2002e","10","400")%>
								<%End If%>
								<%If BV_VIEW_TF = "T" Then%>
								<br /><%=spans(num2curINT(self_GV/arrList_orderEa),"green","11","400")%><%=spans(""&CS_PV2&"","green","10","400")%>
								<%End If%>
							<%End If%>
						</td>
						<td class="tcenter bor_l">
							<%=arrList_orderEa%>
							<input type="hidden" name="ea" value="<%=arrList_orderEa%>" readonly="readonly"/>
							<input type="hidden" name="basePrice" value="<%=arrList_GoodsPrice%>" readonly="readonly" />
							<input type="hidden" name="basePV" value="<%=arr_CS_price4%>" readonly="readonly" />
							<input type="hidden" name="DeliveryType" value="<%=arrList_GoodsDeliveryType%>" readonly="readonly" />
							<input type="hidden" name="BASIC_DeliveryFeeLimit" value="<%=DKRS2_intDeliveryFeeLimit%>" readonly="readonly" />
							<input type="hidden" name="BASIC_DeliveryFee" value="<%=DKRS2_intDeliveryFee%>" readonly="readonly" />
						</td>
						<td class="tcenter bor_l">
							<%=spans(num2cur(self_GoodsPrice),"#222222","12","400")%><%=spans(""&Chg_currencyISO&"","#222222","11","400")%>
							<%If v_SellCode <> "02"  Then 'COSMICO%>
								<%If PV_VIEW_TF = "T" Then%>
								<br /><%=spans(num2curINT(self_PV),"#f2002e","11","400")%><%=spans(""&CS_PV&"","#f2002e","10","400")%>
								<%End If%>
								<%If BV_VIEW_TF = "T" Then%>
								<br /><%=spans(num2curINT(self_GV),"green","11","400")%><%=spans(""&CS_PV&"","green","10","400")%>
								<%End If%>
							<%End If%>
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

							If k = 0 And Int(arrList_TOTAL_SHOPCNT) > 1 Then '업체별 주문합계
					%>
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
											<%If v_SellCode <> "02"  Then 'COSMICO%>
												<%If PV_VIEW_TF = "T" Then%>
												<div class="sumCart03">
													<span class="pStitle tWidth"><%=LNG_CS_ORDERS_TOTAL_PV%></span>
													<span class="pPrice sPrice pv TOTsumPvShopID_<%=attrShopIdTOT%>_txt">0</span>
													<span class="pvUnit"><%=CS_PV%></span>
												</div>
												<%End If%>
											<%End If%>
										</div>
										<div></div>
								</div>
							</td>
						</tr>
					<%
							End If

						Next

					End If

					%>
			</table>
		</div>

	<%
		'금액표기
		TOTAL_OptionPrice	= DKRS_totalOptionPrice
		TOTAL_USEPOINT		= DKRS_usePoint + DKRS_usePoint2				'포인트 사용

		TOTAL_SUM_PRICE		= DKRS_totalPrice												'최종 결제금액
		TOTAL_DeliveryFee = DKRS_totalDelivery										'배송비
		TOTAL_Price 			= TOTAL_SUM_PRICE - TOTAL_DeliveryFee		'상품가(옵션가 포함)
		If LCase(DKRS_payWay) <> "point" And TOTAL_USEPOINT > 0 Then
			TOTAL_Price = TOTAL_Price + TOTAL_USEPOINT		'부분 포인트 사용시 상품가
		End If
	%>
	<div class="cleft width100 TotalArea">
		<ul class="AreaZone">
			<li id="PriceArea">
				<span class="tit"><%=LNG_SHOP_ORDER_FINISH_09%></span>
				<p>
					<span class="price PriceArea" id="PriceAreaID"><%=num2cur(TOTAL_Price)%></span>
					<span class="won"><%=Chg_CurrencyISO%></span>
				</p>
			</li>
			<li id="DeliveryArea">
				<i class="icon-plus-2"></i>
				<span class="tit"><%=LNG_SHOP_ORDER_DIRECT_TABLE_15%></span>
				<p>
					<span class="price DeliveryArea" id="DeliveryAreaID"><%=num2cur(TOTAL_DeliveryFee)%></span>
					<span class="won"><%=Chg_CurrencyISO%></span>
				</p>
			</li>
			<li id="LastArea">
				<i class="icon-angle-circled-right"></i>
				<span class="tit"><%=LNG_SHOP_ORDER_DIRECT_TABLE_16%></span>
				<p>
					<span class="price LastArea" id="LastAreaID"><%=num2cur(TOTAL_SUM_PRICE)%></span>
					<span class="won"><%=Chg_CurrencyISO%></span>
				</p>
			</li>
		</ul>
		<table <%=tableatt%> class="disArea width100">
			<colgroup>
				<col width="120" />
				<col width="280" />
				<col width="*" />
				<col width="300" />
			</colgroup>
			<tbody>
				<tr>
					<th class="bor_top"><%=LNG_SHOP_ORDER_FINISH_08%></th>
					<td class="bor_l2" colspan="<%=COLSPAN2%>">
						<ul>
							<li>·<%=LNG_SHOP_ORDER_FINISH_09%> : <span><%=num2cur(TOTAL_Price)%> <%=Chg_CurrencyISO%></span></li>
							<!-- <li><span>·<%=LNG_SHOP_ORDER_FINISH_10%> : <span><%=num2cur(TOTAL_OptionPrice)%> <%=Chg_CurrencyISO%></span></li> -->
							<li>·<%=LNG_SHOP_ORDER_FINISH_11%> : <span><%=num2cur(TOTAL_DeliveryFee)%> <%=Chg_CurrencyISO%></span></li>
						</ul>
					</td>
					<%If isSHOP_POINTUSE = "T" Then%>
					<td class="bor_l2 vtop point">
						<table <%=tableatt%> >
							<colgroup>
								<col width="100" />
								<col width="150" />
							</colgroup>
							<tr>
								<td class="noline"><%=SHOP_POINT%></td>
								<td class="noline tright"><span id="viewPoint" class="tweight"><%=num2cur(DKRS_usePoint)%></span> <%=Chg_CurrencyISO%></td>
							</tr>
							<!-- <tr>
								<td class="noline"><%=SHOP_POINT2%></td>
								<td class="noline tright"><span id="viewPoint2" class="tweight"><%=num2cur(DKRS_usePoint2)%></span> <%=Chg_CurrencyISO%></td>
							</tr> -->
						</table>
					</td>
					<%End If%>
					<td class="bor_l summ" rowspan="2">
						<ul>
							<li class=""><%=LNG_SHOP_ORDER_FINISH_13%></li>
							<%If DK_MEMBER_TYPE <> "GUEST" Then%>
								<!-- <li>·<%=LNG_SHOP_ORDER_FINISH_14%> : <span id="viewPoint"><%=num2cur(DKRS_totalPoint)%></span>&nbsp;<%=Chg_CurrencyISO%></li> -->
							<%Else%>
								<li>·<%=LNG_SHOP_ORDER_FINISH_14%> : <span id="viewPoint" class="mline"><%=num2cur(DKRS_totalPoint)%></span>&nbsp;<%=Chg_CurrencyISO%></li>
								<li class="red2">·<%=LNG_SHOP_ORDER_FINISH_15%></li>
							<%End If%>
							<%If v_SellCode <> "02"  Then 'COSMICO%>
								<%If PV_VIEW_TF = "T" Then%>
									<li class="red2">·<%=CS_PV%>: <span><%=num2curINT(TOTAL_PV)%></span> <%=CS_PV%></li>
								<%End If%>
								<%If BV_VIEW_TF = "T" Then%>
									<li class="green">·<%=CS_PV2%>: <span><%=num2curINT(TOTAL_GV)%></span> <%=CS_PV2%></li>
								<%End If%>
							<%End If%>
						</ul>
					</td>
				</tr>
			</tbody>
		</table>
	</div>

	<%
		'▣수령방식
		SQL9 = "SELECT [DtoD] FROM [DK_ORDER_TEMP] WITH(NOLOCK) WHERE [OrderNum] = ?"
		arrParams_DT = Array(_
			Db.makeParam("@orderNum",adVarChar,adParamInput,20,orderNum) _
		)
		Set HJRS9 = Db.execRs(SQL9,DB_TEXT,arrParams_DT,DB3)
		If Not HJRS9.BOF And Not HJRS9.EOF Then
			DtoD= HJRS9("DtoD")
		Else
			DtoD= "T"
		End If
		Call closeRs(HJRS9)

	%>
	<input type="hidden" name="SHOP_ORDERINFO_VIEW_TF" value="<%=SHOP_ORDERINFO_VIEW_TF%>" readonly="readonly"/>
	<input type="hidden" name="DtoD" value="<%=DtoD%>" readonly="readonly"/>
	<div class="orderInfos">
		<div class="info" id="orderInfo">
			<div class="order_title"><%=LNG_SHOP_ORDER_DIRECT_TITLE_04%></div>
			<table <%=tableatt%> class="width100">
				<col width="135" />
				<col width="*" />
				<col width="135" />
				<col width="*" />
				<tbody>
					<tr>
						<th><%=LNG_SHOP_ORDER_DIRECT_TABLE_17%></th>
						<td><%=DKRS_strName%></td>
						<th><%=LNG_SHOP_ORDER_DIRECT_TABLE_18%></th>
						<td><%=DKRS_strTel%></td>
					</tr>
					<tr>
						<th><%=LNG_SHOP_ORDER_DIRECT_TABLE_19%></th>
						<td><%=DKRS_strMob%></td>
					</tr>
					<tr class="address">
						<th><%=LNG_SHOP_ORDER_DIRECT_TABLE_21%></th>
						<td class="zipTD">
							<p><%=DKRS_strZip%></p>
							<p><%=DKRS_strADDR1%></p>
							<p><%=DKRS_strADDR2%></p>
						</td>
					</tr>
					<%If SHOP_ORDERINFO_VIEW_TF = "T" Then%>
					<tr>
						<th><%=LNG_SHOP_ORDER_DIRECT_TABLE_20%></th>
						<td><%=DKRS_strEmail%></td>
					</tr>
					<%End If%>
				</tbody>
			</table>
		</div>

		<div class="info" id="deliveryInfo">
			<div class="order_title">
				<%If DIRECT_PICKUP_USE_TF = "T" Then 'strText %>
				<span class="directpickupTitle" style="display: none;"><%=LNG_SHOP_ORDER_DIRECT_TITLE_04%></span>
				<%End If%>
				<span class="directpickup"><%=LNG_SHOP_ORDER_DIRECT_TITLE_05%></span>
			</div>
			<table <%=tableatt%> class="width100">
				<col width="150" />
				<col width="*" />
				<col width="150" />
				<col width="*" />
				<tbody>
					<tr>
						<th><%=LNG_SHOP_ORDER_DIRECT_TABLE_17%></th>
						<td><%=DKRS_takeName%></td>
						<th><%=LNG_SHOP_ORDER_DIRECT_TABLE_18%></th>
						<td><%=DKRS_takeTel%></td>
					</tr><tr>
						<th><%=LNG_SHOP_ORDER_DIRECT_TABLE_19%></th>
						<td><%=DKRS_takeMob%></td>
						<th><%=LNG_SHOP_ORDER_DIRECT_TABLE_21%></th>
						<td class="zipTD">
							<p><%=DKRS_takeZip%></p>
							<p><%=DKRS_takeADDR1%></p>
							<p><%=DKRS_takeADDR2%></p>
						</td>
					</tr>
					<tr class="directpickup">
					<%If SHOP_ORDERINFO_VIEW_TF <> "T" Then%>
						<th><%=LNG_SHOP_ORDER_DIRECT_TABLE_20%></th>
						<td><%=DKRS_strEmail%></td>
					<%End If%>
						<th><%=LNG_SHOP_ORDER_DIRECT_TABLE_23%></td>
						<td><%=DKRS_orderMemo%></td>
					</tr>
				</tbody>
			</table>
		</div>
	</div>
	<%
		If UCase(DK_MEMBER_NATIONCODE) = "KR" Then
			Select Case LCase(DKRS_PAYWAY)
				Case "inbank","vbank"
					'현금영수증 처리
					SQL2 = "SELECT [C_HY_TF],[C_HY_Date],[C_HY_ApNum],[C_HY_SendNum],[C_HY_Division] FROM [tbl_Sales_Cacu] WITH(NOLOCK) WHERE [OrderNumber] = ? "
					arrParams = Array(Db.makeParam("@OrderNum",adVarChar,adParamInput,20,DKRS_CSORDERNUM))
					Set HJRSC = DB.execRs(SQL2,DB_TEXT,arrParams,DB3)
					If Not HJRSC.BOF And Not HJRSC.EOF Then
						RS_C_HY_TF = HJRSC(0)			'현금영수증 발행 (0 :미발행, 1 :발행)
						RS_C_HY_Date = HJRSC(1)		'현금 영수증 발행일	(승인시)
						RS_C_HY_ApNum = HJRSC(2)		'현금영수증 승인번호 	(승인시)
						RS_C_HY_SendNum = HJRSC(3)		'현금영수증 신청번호
						RS_C_HY_Division = HJRSC(4)		'신청구분 (0 : 개인소득공제용, 1 : 사업자용)

						Select Case RS_C_HY_TF
							Case 0
								C_HY_TF_TEXT = "미발행"
							Case 1
								If RS_C_HY_ApNum <> "" Then
									C_HY_TF_TEXT = "발행"
								Else
									C_HY_TF_TEXT = "발행신청"
								End If
						End Select

						IF RS_C_HY_Division <> "" Then
							Select Case RS_C_HY_Division
								Case 0
									C_HY_Division_TEXT = "개인소득공제용"
								Case 1
									C_HY_Division_TEXT = "사업자용"
								Case Else
									C_HY_Division_TEXT = ""
							End Select
						End If

						Set objEncrypter = Server.CreateObject ("Hyeongryeol.StringEncrypter")
							objEncrypter.Key = con_EncryptKey
							objEncrypter.InitialVector = con_EncryptKeyIV
							On Error Resume Next
								If RS_C_HY_SendNum	<> "" Then RS_C_HY_SendNum	= Trim(objEncrypter.Decrypt(RS_C_HY_SendNum))
							On Error GoTo 0
						Set objEncrypter = Nothing

						If RS_C_HY_SendNum <> "" Then
							S_Num_LEN = 0
							S_Num_LEN = Len(RS_C_HY_SendNum)

							cStars = ""
							C_V_Number_LEN = 5
							If S_Num_LEN > 0 Then
								For s = 1 To S_Num_LEN-C_V_Number_LEN
									cStars = cStars&"*"
								Next
								RS_C_HY_SendNum =	Left(RS_C_HY_SendNum,C_V_Number_LEN) & cStars
							End If
						End If

					Else
						RS_C_HY_TF = ""
						RS_C_HY_Date = ""
						RS_C_HY_SendNum = ""
						RS_C_HY_Division = ""
					End If
					Call closeRS(HJRSC)
			End Select
		End If
	%>
	<%
		Select Case LCase(DKRS_PAYWAY)
			Case "inbank"
	%>
		<div class="cleft width100 payment">
			<div class="order_title"><%=LNG_SHOP_ORDER_DIRECT_TITLE_06%></div>
			<div class="width100 selectPay"><p><%=LNG_SHOP_ORDER_DIRECT_PAY_02%></p></div>
			<div class="cleft width100 payinfoWrap">
				<div class="fleft" style="width:65%;">
					<div id="BankInfo" class="width100">
						<table <%=tableatt%> class="width100 pay">
							<col width="150" />
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
							<%If UCase(DK_MEMBER_NATIONCODE) = "KR" Then%>
								<tr>
									<th>현금영수증 발행</th>
									<td><%=C_HY_TF_TEXT%></td>
								</tr>
								<%If RS_C_HY_TF = "1" Then%>
								<tr>
									<th>현금영수증 신고번호</th>
									<td>[<%=C_HY_Division_TEXT%>] <%=RS_C_HY_SendNum%></td>
								</tr>
								<%End If%>
							<%End If%>
						</table>
					</div>
				</div>
				<div class="fleft" style="width:35%;">
					<div class="cleft width100 cart_btn">
						<p><span class="red2"><%=LNG_SHOP_ORDER_FINISH_18%></span></p>
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
				<div class="fleft" style="width:65%;">
					<div id="CardInfo" class="width100">
						<table <%=tableatt%> class="width100 pay">
							<col width="150" />
							<col width="*" />
							<tr>
								<th><%=LNG_SHOP_ORDER_FINISH_19%></th>
								<td><%=DKPG_PGCOMPANY%> (<a href="<%=PGCOMURL%>" target="_blank"><%=PGCOMURL%></a>)</td>
							</tr><tr>
								<th><%=LNG_SHOP_ORDER_FINISH_20%></th>
								<td><%=DKRS_PGCardCode%> (<%=FN_INICIS_CARDCODE_VIEW(DKRS_PGCardCode)%>)</td>
							</tr>
							<%IF UCASE(DKPG_PGCOMPANY) <> "DAOU" Then%>
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
				<div class="fleft" style="width:35%;">
					<div class="cleft width100 cart_btn">
						<p><span class="red2"></span></p>
					</div>
				</div>
			</div>
		</div>
	<%
		Case "vbank"
	%>
		<div class="cleft width100 payment">
			<div class="order_title_05"></div>
			<div class="width100 selectPay"><%=LNG_SHOP_ORDER_FINISH_24%></div>
			<div class="cleft width100 payinfoWrap">
				<div class="fleft" style="width:65%;">
					<div id="CardInfo" class="width100">
						<table <%=tableatt%> class="width100 pay">
							<col width="150" />
							<col width="*" />
							<tr>
								<th>결제사</th>
								<td><%=DKPG_PGCOMPANY%> (<a href="<%=PGCOMURL%>" target="_blank"><%=PGCOMURL%></a>)</td>
							</tr>
							<%IF UCASE(DKPG_PGCOMPANY) <> "DAOU" Then%>
							<tr>
								<th>입금은행</th>
								<td><%=DKRS_vBankName%></td>
							</tr><tr>
								<th>입금계좌</th>
								<td><%=DKRS_vBankAccNum%></td>
							</tr><tr>
								<th>예금주</th>
								<td><%=DKRS_vBankRecvName%></td>
							</tr><tr>
								<th>입금종료일</th>
								<td><%=datetoText(DKRS_vBankDepDate)%></td>
							</tr>
							<%ELSE%>
							<tr>
								<th>입금은행</th>
								<td><%=FN_INICIS_BANKCODE_VIEW(DKRS_PGinstallment)%></td>
							</tr><tr>
								<th>입금계좌</th>
								<td><%=DKRS_PGCardNum%></td>
							</tr><tr>
								<th>입금자명</th>
								<td><%=DKRS_PGAcceptNum%></td>
							</tr><tr>
								<th>입금예정일</th>
								<td><%=DKRS_PGCardCode%></td>
							</tr>
							<%End If%>
							<%If UCase(DK_MEMBER_NATIONCODE) = "KR" Then%>
								<tr>
									<th>현금영수증 발행</th>
									<td><%=C_HY_TF_TEXT%></td>
								</tr>
								<%If RS_C_HY_TF = "1" Then%>
								<tr>
									<th>현금영수증 신고번호</th>
									<td>[<%=C_HY_Division_TEXT%>] <%=RS_C_HY_SendNum%></td>
								</tr>
								<%End If%>
							<%End If%>
						</table>
					</div>
				</div>
				<div class="fleft" style="width:35%;">
					<div class="cleft width100 cart_btn">
						<p><span class="red2"></span></p>
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
						<table <%=tableatt%> class="width100 pay">
							<col width="150" />
							<col width="*" />
							<tr>
								<th><%=LNG_SHOP_ORDER_FINISH_19%></th>
								<td><%=DKPG_PGCOMPANY%> (<a href="<%=PGCOMURL%>" target="_blank"><%=PGCOMURL%></a>)</td>
							</tr><tr>
								<th><%=LNG_SHOP_ORDER_FINISH_27%></th>
								<td><%=FN_INICIS_BANKCODE_VIEW(DKRS_PGCardCom)%></td>
							</tr>
						</table>
					</div>
				</div>
				<div class="fleft" style="width:35%;">
					<div class="cleft width100 cart_btn">
						<p><span class="red2"></span></p>
					</div>
				</div>
			</div>
		</div>
	<%
			Case "point","point2"
	%>
		<div class="cleft width100 payment">
			<div class="order_title_05"></div>
			<div class="width100 selectPay"><%=LNG_SHOP_ORDER_FINISH_12%></div>
			<div class="cleft width100 payinfoWrap">
				<div class="fleft" style="width:65%;">
					<div id="CardInfo" class="width100">
						<table <%=tableatt%> class="width100 pay">
							<col width="150" />
							<col width="*" />
							<%If UCase(DK_MEMBER_NATIONCODE) <> "KR" Then %>
							<tr>
								<th><%=SHOP_POINT%></th>
								<td><%=num2cur(DKRS_usePoint)%></td>
							</tr>
							<%End If%>
							<%If DKRS_usePoint2 > 0 Then%>
							<tr>
								<th><%=SHOP_POINT2%></th>
								<td><%=num2cur(DKRS_usePoint2)%></td>
							</tr>
							<%End If%>
						</table>
					</div>
				</div>
				<div class="fleft" style="width:35%;">
					<div class="cleft width100 cart_btn">
						<p><span class="red2"></span></p>
					</div>
				</div>
			</div>
		</div>
	<%
		Case "direct"	'직접수령
	%>
		<!-- <div class="cleft width100 payment">
			<div class="order_title"><%=LNG_CS_ORDERS_RECEIVE_METHOD%></div>
			<div class="width100 selectPay"><%=LNG_CS_ORDERS_RECEIVE_PICKUP%></div>
		</div> -->
	<%
		End Select
	%>

	<div class="btnZone">
		<input type="button" class="promise" onclick="location.href='/mypage/order_list.asp';" value="<%=LNG_MYOFFICE_BUY%>"/>
		<input type="button" class="cancel" onclick="location.href='/shop/index.asp';" value="<%=LNG_SHOP_ORDER_FINISH_29%>"/>
	</div>
</div>
<!--#include virtual="/_include/copyright.asp" -->
