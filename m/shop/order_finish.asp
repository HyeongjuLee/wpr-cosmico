<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	Call FN_NationCurrency(DK_MEMBER_NATIONCODE,Chg_CurrencyName,Chg_CurrencyISO)
	Call ONLY_MEMBER(DK_MEMBER_LEVEL)

	PAGE_SETTING = "SHOP"




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
		Call ALERTS(LNG_SHOP_ORDER_FINISH_01&"DDD","go","/m/index.asp")
	End If
	Call closeRS(DKRS)


	If DK_MEMBER_ID <> DKRS_strUserID Then Call alerts(LNG_SHOP_ORDER_FINISH_03,"go","/m/common/member_logout.asp")

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
<!--#include virtual = "/m/_include/document.asp"-->
<!--#include virtual = "/m/_include/jqueryload.asp"-->
<link rel="stylesheet" href="/m/css/shop_order_style.css?v0" />

<meta http-equiv="Cache-Control" content="no-cache"/>
<meta http-equiv="Expires" content="0"/>
<meta http-equiv="Pragma" content="no-cache"/>
<meta http-equiv="X-UA-Compatible" content="requiresActiveX=true" />
<!-- <link rel="stylesheet" href="order_direct.css"> -->
<link rel="stylesheet" href="/m/js/icheck/skin/line/_all.css" />
<script type="text/javascript" src="/m/js/check.js"></script>
<script src="/m/js/icheck/icheck.min.js"></script>
<script type="text/javascript" src="/m/js/calendar.js"></script>
<script type="text/javascript" src="/shop/orderCalc.js?v3"></script>
<script type="text/javascript">
	$(document).ready(function(){
		deliveryClassfy();
	});

	function deliveryClassfy() {
		let SHOP_ORDERINFO_VIEW_TF = $("input[name=SHOP_ORDERINFO_VIEW_TF]").val();
		let DtoD = $("input[name=DtoD]").val();

		if (SHOP_ORDERINFO_VIEW_TF == 'T') {
		}else{
			$("#orderInfo").hide();
		}

		if (DtoD == 'F') {		//현장수령
			if (SHOP_ORDERINFO_VIEW_TF == 'T') {
				$("#orderInfo").hide();
			}
			$("#deliveryInfo").show();
			$(".directpickup").hide();
			$(".directpickupTitle").show();

		} else {
			if (SHOP_ORDERINFO_VIEW_TF == 'T') {
				$("#orderInfo").show();
			}
			$("#deliveryInfo").show();
			$(".directpickup").show();
			$(".directpickupTitle").hide();
		}
	}

</script>
</head>
<body style="<%=CANCEL_OPACITY%>">
<!--#include virtual = "/m/_include/header.asp"-->
<!--#include virtual = "/m/_include/sub_header.asp"-->
<!-- <div id="shop" class="detailView porel"> -->
<div id="order" class="detailView porel">
	<div id="order_title_b" class="width100 tcenter text_noline tweight" ><%=LNG_SHOP_ORDER_FINISH_04%></div>

	<%If DK_MEMBER_TYPE="COMPANY" Then%>
		<div class="order_infos" ><%=LNG_TEXT_ORDER_NUMBER_CS%> : <span class="ordNo"><%=DKRS_CSORDERNUM%></span></div>
		<%If isMACCO = "T" Then%>
		<div class="order_infos">
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
		<div class="cart_infos"><%=LNG_SHOP_ORDER_FINISH_02%> : <span class="ordNo"><%=DKRS_OrderNum%></span>
			<%If DK_MEMBER_ID = "GUEST" Then%><%=LNG_SHOP_ORDER_FINISH_06%><%End If%>
		</div>
	<%End If%>

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
		<input type="hidden" name="DtoD" id="DtoD" value="<%=DtoD%>" readonly="readonly"/>
		<div id="orderInfo" style="display: none;">
			<div class="order_title_m" ><%=LNG_SHOP_ORDER_DIRECT_TITLE_04%></div>
			<div class="user_info1 clear">
				<table <%=tableatt%> class="width100">
					<col width="130" />
					<col width="*" />
					<tr>
						<th><%=LNG_SHOP_ORDER_DIRECT_TABLE_17%></th>
						<td><%=DKRS_strName%></td>
					</tr><tr>
						<th><%=LNG_SHOP_ORDER_DIRECT_TABLE_18%></th>
						<td><%=DKRS_strTel%></td>
					</tr><tr>
						<th><%=LNG_SHOP_ORDER_DIRECT_TABLE_19%></th>
						<td><%=DKRS_strMob%></td>
					</tr><tr class="">
						<th class="vtop"><%=LNG_SHOP_ORDER_DIRECT_TABLE_21%></th>
						<td>(<%=DKRS_strZip%>) <%=DKRS_strADDR1%>&nbsp;<%=DKRS_strADDR2%></td>
					</tr>
					<%If SHOP_ORDERINFO_VIEW_TF = "T" Then%>
					<tr>
						<th><%=LNG_SHOP_ORDER_DIRECT_TABLE_20%></th>
						<td><%=DKRS_strEmail%></td>
					</tr>
					<%End If%>
				</table>
			</div>
		</div>

		<div id="deliveryInfo">
			<div class="order_title_m" >
				<!-- <%=LNG_SHOP_ORDER_DIRECT_TITLE_04%> -->
				<%If DIRECT_PICKUP_USE_TF = "T" Then 'strText %>
				<span class="directpickupTitle" style="display: none;"><%=LNG_SHOP_ORDER_DIRECT_TITLE_04%></span>
				<%End If%>
				<span class="directpickup"><%=LNG_SHOP_ORDER_DIRECT_TITLE_05%></span>
			</div>
			<div class="user_info1 clear">
				<table <%=tableatt%> class="width100">
					<col width="130" />
					<col width="*" />
					<tr>
						<th><%=LNG_SHOP_ORDER_DIRECT_TABLE_17%></th>
						<td><%=DKRS_takeName%></td>
					</tr><tr>
						<th><%=LNG_SHOP_ORDER_DIRECT_TABLE_18%></th>
						<td><%=DKRS_takeTel%></td>
					</tr><tr>
						<th><%=LNG_SHOP_ORDER_DIRECT_TABLE_19%></th>
						<td><%=DKRS_takeMob%></td>
					</tr><tr class="directpickup">
						<th class="vtop"><%=LNG_SHOP_ORDER_DIRECT_TABLE_21%></th>
						<td>(<%=DKRS_takeZip%>) <%=DKRS_takeADDR1%>&nbsp;<%=DKRS_takeADDR2%></td>
					</tr>
					<%If SHOP_ORDERINFO_VIEW_TF = "T" Then%>
					<tr class="directpickup">
						<th><%=LNG_SHOP_ORDER_DIRECT_TABLE_20%></th>
						<td><%=DKRS_strEmail%></td>
					</tr>
					<%End If%>
					<tr class="directpickup">
						<th><%=LNG_SHOP_ORDER_DIRECT_TABLE_23%></th>
						<td><%=DKRS_orderMemo%></td>
					</tr>
				</table>
			</div>
		</div>

		<!-- <div class="order_title_m"><%=LNG_SHOP_ORDER_DIRECT_TITLE_03%></div> -->
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
							thumbMargin = 10
							imgPaddingH = (upImgHeight_Thum + thumbMargin - imgHeight) / 2
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

						If arrList_ShopCNT = 1 Then
							k = 1
						Else
							If k = 0 Then
								k = 1
							Else
								k = k
							End If
						End If

						TOTAL_PV = TOTAL_PV + self_PV
						TOTAL_GV = TOTAL_GV + self_GV

			%>
			<%
				'판매자 정보
				If k = 1 Then
					SQL = "SELECT [strComName] FROM [DK_VENDOR] WITH(NOLOCK) WHERE [strShopID] = ?"
					arrParams2 = Array(Db.makeParam("@strUserID",adVarChar,adParamInput,30,arrList_strShopID))
					txt_strComName = Db.execRsData(SQL,DB_TEXT,arrParams2,Nothing)
					If arrList_strShopID = "company" Then txt_strComName = DKCONF_SITE_TITLE

					If txt_strComName <> "" Then
						txt_strComName = "<span class=""tright font_size08em""> ("&txt_strComName&")</span>"
					End If
			%>
			<div class="cart_title b_radius_top">
				<%=LNG_SHOP_ORDER_DIRECT_TABLE_01%><%=txt_strComName%>
			</div>
			<%End If%>
			<%
				'판매처별 라운딩
				If arrList_ShopCNT = 1 Or arrList_ShopCNT = k Then	'마지막상품 하단 라운딩
					shopAmountResultView = "T"
					b_radius_bottom = "b_radius_bottom"
				Else
					shopAmountResultView = ""
					b_radius_bottom = "b_radius_bottom_0"
				End If

				sIDX = i
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

			<div class="goodsInfo_wrap <%=b_radius_bottom%>">
				<div class="goodsInfo">
					<div class="goodsArea order">
						<div class="goodsBox">
							<div class="ImgArea">
								<div class="" style="padding:<%=imgPaddingH%>px 0px;">
									<%=viewImg(imgPath,imgWidth,imgHeight,"")%>
								</div>
							</div>
							<div class="goodsInfoArea">
								<p class="goodsName ellipsis2" ><%=arrList_goodsName%></p>
								<%If printOPTIONS <> "" Then%>
									<p class="text_noline optionTxtArea"><%=printOPTIONS%></p>
								<%Else%>
									<!-- <p class="text_noline optionTxtArea">옵션없음</p> -->
								<%End If%>
								<%If printGoodsIcon <> "" Then%>
									<!-- <p><%=printGoodsIcon%></p> -->
								<%End If%>
								<p><span class="goodsNote"><%=backword(arrList_GoodsNote)%></span></p>
								<%If DK_MEMBER_TYPE = "COMPANY" Then %>
									<!-- <p><span class="selltypeName"><%=arr_CS_SellTypeName%></span></p> -->
								<%End If%>

								<%'상품금액%>
								<p><%=spans(num2cur(self_GoodsPrice/arrList_orderEa),"#222222","10","400")%><%=spans(""&Chg_currencyISO&"","#222222","9","400")%></p>
								<%If v_SellCode <> "02"  Then 'COSMICO%>
									<%If PV_VIEW_TF = "T" Then%>
									<p><%=spans(num2curINT(self_PV/arrList_orderEa),"#f2002e","9","400")%><%=spans(""&CS_PV&"","#ff3300","8","400")%></p>
									<%End If%>
									<%If BV_VIEW_TF = "T" Then%>
									<p><%=spans(num2curINT(self_GV/arrList_orderEa),"green","9","400")%><%=spans(""&CS_PV2&"","green","8","400")%></p>
									<%End If%>
								<%End If%>
								<!-- <p id="txt_DeliveryFeeEach<%=i%>"><%=txt_DeliveryFeeEach%></p> -->

								<input type="hidden" name="ea" value="<%=arrList_orderEa%>" readonly="readonly" />
								<input type="hidden" name="basePrice" value="<%=arrList_GoodsPrice%>" readonly="readonly" />
								<input type="hidden" name="basePV" value="<%=arr_CS_price4%>" readonly="readonly" />
								<input type="hidden" name="DeliveryType" value="<%=arrList_GoodsDeliveryType%>" readonly="readonly" />
								<input type="hidden" name="BASIC_DeliveryFeeLimit" value="<%=DKRS2_intDeliveryFeeLimit%>" readonly="readonly" />
								<input type="hidden" name="BASIC_DeliveryFee" value="<%=DKRS2_intDeliveryFee%>" readonly="readonly" />
								<p class="ea">
									<%=LNG_TEXT_ITEM_NUMBER%> : <%=arrList_orderEa%>
									<!-- <span class="ea_bg"><a href="javascript: eaUpDown('down','<%=sIDX%>');"  class="minus">-</a></span><input type="tel" name="setEa" id="good_ea<%=sIDX%>" value="<%=arrList_orderEa%>" class="input_text_ea vmiddle tcenter readonly" maxlength="2" onkeyup="this.value=this.value.replace(/[^0-9]/g,'');" readonly="readonly" /><span class="ea_bg"><a href="javascript: eaUpDown('up','<%=sIDX%>');" class="plus">+</a></span> -->
								</p>
							</div>
						</div>
						<div class="eachPriceInfo display-none" >
							<table <%=tableatt%> class="width100">
								<col width="" />
								<col width="" />
								<tr>
									<td class="title"><%=LNG_SHOP_ORDER_DIRECT_TABLE_04%></td>
									<td class="tright"><span id="sumEachPrice_txt<%=sIDX%>"><%=num2cur(self_GoodsPrice)%></span><span class="pUnit"><%=Chg_CurrencyISO%></span></td>
								</tr>
								<%If v_SellCode <> "02"  Then 'COSMICO%>
									<%If PV_VIEW_TF = "T" Then%>
									<tr>
										<td class="title"><%=CS_PV%></td>
										<td class="tright"><span id="sumEachPV_txt<%=sIDX%>" class="pv"><%=num2curINT(self_PV)%></span><span class="pvUnit"><%=CS_PV%></span></td>
									</tr>
									<%End If%>
									<%If BV_VIEW_TF = "T" Then%>
									<tr>
										<td class="title"><%=CS_PV2%></td>
										<td class="tright"><span id="sumEachPV_txt<%=sIDX%>" class="bv"><%=num2curINT(self_GV)%></span><span class="pvUnit"><%=CS_PV2%></span></td>
									</tr>
									<%End If%>
								<%End If%>
							</table>
						</div>
					</div>
					<%
						'모바일 업체별, 단독배송 표기
						l = 0
						If arrList_DELICNT = k Or arrList_GoodsDeliveryType = "SINGLE" Then
							l = 1
						End If

						If l = 1 Then
							BUNDLE_DELIVERY_TXT = ""
							If arrList_DELICNT > 1 Then
								BUNDLE_DELIVERY_TXT = arrList_DELICNT&"건 묶음 배송비<br />"
							End If
							txt_DeliveryFee = Replace(txt_DeliveryFee,"<br />"," ")
					%>
						<div class="txt_DeliveryFee">
							<div class="inner"><span class="blue2"><%=BUNDLE_DELIVERY_TXT%></span><%=txt_DeliveryFee%></div>
						</div>
						<input type="hidden" name="sumPriceShopID" id="sumPriceShopID_<%=attrShopID%>" value="0" readonly="readonly"/>
						<input type="hidden" name="deliveryFeeShopID" id="deliveryFeeShopID_<%=attrShopID%>" class="deliveryFeeShopID" value="0" readonly="readonly"/>
						<input type="hidden" name="orderPriceShopID" id="orderPriceShopID_<%=attrShopID%>" value="0" readonly="readonly"/>
						<input type="hidden" name="sumPvShopID" id="sumPvShopID_<%=attrShopID%>" value="0" readonly="readonly"/>
						<input type="hidden" name="sumBvShopID" id="sumBvShopID_<%=attrShopID%>" value="0" readonly="readonly"/>
					<%
						End If
					%>
					<%'If shopAmountResultView = "T" And Int(arrList_TOTAL_SHOPCNT) > 1 Then	'업체별 주문합계%>
					<%If shopAmountResultView = "T" And Int(arrList_TOTAL_SHOPCNT) > 0 Then	'업체별 주문합계%>
						<div class="eachPriceInfo total">
							<table <%=tableatt%> class="width100">
								<col width="" />
								<col width="" />
								<col width="20" />
								<tbody id="shopPrices<%=sIDX%>" onclick="toggle_shopPrices('shopPrices<%=sIDX%>')" style="display: none;" >
									<tr>
										<td class="title sub"><%=LNG_TOTAL_PAY_PRICE%></td>
										<td class="tright"><span class="TOTsumPriceShopID_<%=attrShopIdTOT%>_txt">0</span><span class="pUnit"><%=Chg_CurrencyISO%></span></td>
										<td class="tright"><span class="shopPrices-up"></span></td>
									</tr>
									<tr>
										<td class="title sub"><%=LNG_CS_ORDERS_DELIVERY_PRICE%></td>
										<td class="tright"><span class="TOTdeliveryFeeShopID_<%=attrShopIdTOT%>_txt">0</span><span class="pUnit"><%=Chg_CurrencyISO%></span></td>
										<td></td>
									</tr>
								</tbody>
								<tr onclick="toggle_shopPrices('shopPrices<%=sIDX%>')">
									<td class="title top"><%=LNG_CS_ORDERS_TOTAL_PRICE%></td>
									<td class="tright top_price"><span class="TOTorderPriceShopID_<%=attrShopIdTOT%>_txt">0</span><span class="pUnit"><%=Chg_CurrencyISO%></span></td>
									<td class="tright"><span class="shopPrices-down"></span></td>
								</tr>
								<%If v_SellCode <> "02"  Then 'COSMICO%>
									<%If PV_VIEW_TF = "T" Then%>
									<tr>
										<td class="title sub"><%=LNG_CS_ORDERS_TOTAL_PV%></td>
										<td class="tright"><span class="TOTsumPvShopID_<%=attrShopIdTOT%>_txt pv">0</span><span class="pvUnit"><%=CS_PV%></span></td>
										<td></td>
									</tr>
									<%End If%>
									<%If BV_VIEW_TF = "T" Then%>
									<tr>
										<td class="title sub">총 BV</td>
										<td class="tright"><span class="TOTsumBvShopID_<%=attrShopIdTOT%>_txt bv">0</span><span class="bvUnit"><%=CS_PV2%></span></td>
										<td></td>
									</tr>
									<%End If%>
								<%End If%>
							</table>
						</div>
					<%'Else%>
						<!-- <div class="eachPriceInfo hide"></div> -->
					<%End If%>
				</div>
			</div>

			<%
						'print Total_DeliveryFee
						If arrList_DELICNT = 1 Then
							l = 1
						Else
							If l = 0 Then
								l = 1
							Else
								l = l
							End If
						End If
						If arrList_DELICNT = 1 Or arrList_DELICNT = k Then
							l = 0
						Else
							l = l + 1
						End If

						If arrList_ShopCNT = 1 Or arrList_ShopCNT = k Then
							k = 0
						Else
							k = k + 1
						End If

					Next
				Else
					Call ALERTS(LNG_SHOP_ORDER_DIRECT_08,"GO","/m/shop/cart.asp")
				End If

			%>
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

			<%'주문금액%>
			<div class="order_title_m"><%=LNG_SHOP_ORDER_DIRECT_TABLE_14%></div>
			<div class="width100">
				<div class="porel orderPriceArea">
					<div class="porel prices">
						<div>
							<span class="orderPrice_tit" ><%=LNG_SHOP_ORDER_FINISH_09%></span>
							<span class="orderPrice_Res"><span class="strong"><%=num2cur(TOTAL_Price)%></span> <%=Chg_currencyISO%></span>
						</div>
						<%If DKRS_totalOptionPrice > 0 Then%>
						<div>
							<span class="orderPrice_tit"><%=LNG_SHOP_ORDER_FINISH_10%></span>
							<span class="orderPrice_Res"><span class="strong"><%=num2cur(DKRS_totalOptionPrice)%></span> <%=Chg_currencyISO%></span>
						</div>
						<%End If%>
						<div>
							<span class="orderPrice_tit"><%=LNG_SHOP_ORDER_FINISH_11%></span>
							<span class="orderPrice_Res"><span id="delTXT"></span><span class="strong" id="priTXT"><%=num2cur(TOTAL_DeliveryFee)%></span> <%=Chg_currencyISO%></span>
						</div>
						<div>
							<span class="orderPrice_tit tweight"><%=LNG_SHOP_ORDER_DIRECT_TITLE_07%></span>
							<span class="orderPrice_Res "><span class="LastArea" id="lastTXT"><%=num2cur(TOTAL_SUM_PRICE)%></span> <%=Chg_currencyISO%></span>
						</div>
						<%If v_SellCode <> "02"  Then 'COSMICO%>
							<%If PV_VIEW_TF = "T" Then%>
								<div>
									<span class="orderPrice_tit"><%=CS_PV%></span>
									<span class="orderPrice_Res"><span class="strong"><%=num2curINT(TOTAL_PV)%></span><%=CS_PV%></span>
								</div>
							<%End If%>
							<%If BV_VIEW_TF = "T" Then%>
								<div>
									<span class="orderPrice_tit"><%=CS_PV2%></span>
									<span class="orderPrice_Res"><span class="strong"><%=num2curINT(TOTAL_GV)%></span><%=CS_PV2%></span>
								</div>
							<%End If%>
						<%End If%>
						<%If DKRS_usePoint > 0 Then%>
						<div>
							<span class="orderPrice_tit"><%=LNG_CS_ORDERS_USE_POINT%></span>
							<span class="orderPrice_Res"><span class="strong"><%=num2curINT(DKRS_usePoint)%></span><%=LNG_TEXT_POINT%></span>
						</div>
						<%End If%>
						<%If DKRS_usePoint2 > 0 Then%>
						<div>
							<span class="orderPrice_tit <%=M_LINE%>"><%=SHOP_POINT2%></span>
							<span class="orderPrice_Res"><span class="strong"><%=num2curINT(DKRS_usePoint2)%></span><%=LNG_TEXT_POINT%></span>
						</div>
						<%End If%>
					</div>
				</div>
			</div>

		<%
			'▣수령방식
			'Select Case DtoD
			'	Case "T"
			'	Case "F"
			'		DKRS_PAYWAY = "direct"
			'End Select
		%>
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
			<div class="order_title_m"><%=LNG_SHOP_ORDER_DIRECT_TITLE_06%> - <%=LNG_SHOP_ORDER_DIRECT_PAY_02%></div>
			<div class="width100">
				<div class="porel orderPriceArea">
					<div class="porel infos">
						<div>
							<span class="orderPrice_tit"><%=LNG_SHOP_ORDER_DIRECT_PAY_13%></span>
							<span class="orderPrice_infos"><%=DKRS_bankingCom%></span></span>
						</div>
						<div>
							<span class="orderPrice_tit"><%=LNG_SHOP_ORDER_FINISH_16%></span>
							<span class="orderPrice_infos"><%=DKRS_bankingNum%></span>
						</div>
						<div>
							<span class="orderPrice_tit"><%=LNG_SHOP_ORDER_FINISH_17%></span>
							<span class="orderPrice_infos"><%=DKRS_bankingOwn%></span>
						</div>
						<div>
							<span class="orderPrice_tit"><%=LNG_SHOP_ORDER_DIRECT_PAY_14%></span>
							<span class="orderPrice_infos"><%=DKRS_bankingName%></span>
						</div>
						<%If UCase(DK_MEMBER_NATIONCODE) = "KR" Then%>
							<hr>
							<div>
								<span class="orderPrice_tit">현금영수증 발행</span>
								<span class="orderPrice_infos"><%=C_HY_TF_TEXT%></span>
							</div>
							<%If RS_C_HY_TF = "1" Then%>
								<div>
									<span class="orderPrice_tit">현금영수증 신고번호</span>
									<span class="orderPrice_infos">[<%=C_HY_Division_TEXT%>] <%=RS_C_HY_SendNum%></span>
								</div>
							<%End If%>
						<%End If%>
					</div>
				</div>
			</div>

		<%
			Case "card","cardapi"
		%>
		<%If CANCEL_ORDER_TF = "T" Then%>
			<div class="order_title_m"><%=LNG_SHOP_ORDER_DIRECT_PAY_01%> 취소처리</div>
			<div class="width100">
				<div class="porel orderPriceArea">
					<div class="porel infos">
						<%If CANCEL_FAIL = "T" Then%>
							<span class="red2" >※ 카드취소중 오류가 발생하였습니다. 결제취소가 정상적으로 이루어 지지 않은 경우 업체에 문의해주세요</span>
						<%End If%>
						<div>
							<span class="orderPrice_tit"><%=LNG_SHOP_ORDER_FINISH_19%></span>
							<span class="orderPrice_infos"><%=DKPG_PGCOMPANY%> (<a href="<%=PGCOMURL%>" target="_blank"><%=PGCOMURL%></a>)</span>
						</div>
						<div>
							<span class="orderPrice_tit">취소사유</span>
							<span class="orderPrice_infos"><span class="red"><%=DKRS_CANCEL_REASON%></span></span>
						</div>
						<%If DKRS_CANCEL_RESULTCODE = "0000" Then%>
						<div>
							<span class="orderPrice_tit">취소금액</span>
							<span class="orderPrice_infos"><%=num2cur(DKRS_CANCEL_AMOUNT)%> 원</span>
						</div>
						<%End If %>
						<div>
							<span class="orderPrice_tit">취소상태</span>
							<%If DKRS_CANCEL_RESULTCODE = "0000" Then%>
							<span class="orderPrice_infos">[정상 카드취소처리]</span>
							<%Else%>
							<span class="orderPrice_infos"><span class="red">[카드취소실패]&nbsp;<%=DKRS_CANCEL_RET%></span></span>
							<%End If%>
						</div>
					</div>
				</div>
			</div>
		<%Else%>

			<div class="order_title_m"><%=LNG_SHOP_ORDER_DIRECT_TITLE_06%> - <%=LNG_SHOP_ORDER_DIRECT_PAY_01%></div>
			<div class="width100">
				<div class="porel orderPriceArea">
					<div class="porel infos">
						<div>
							<span class="orderPrice_tit" ><%=LNG_SHOP_ORDER_FINISH_19%></span>
							<span class="orderPrice_infos"><%=DKPG_PGCOMPANY%> (<a href="<%=PGCOMURL%>" target="_blank"><%=PGCOMURL%></a>)</span>
						</div>
						<div>
							<span class="orderPrice_tit"><%=LNG_SHOP_ORDER_FINISH_20%></span>
							<span class="orderPrice_infos"><%=DKRS_PGCardCode%> (<%=FN_INICIS_CARDCODE_VIEW(DKRS_PGCardCode)%>)</span>
						</div>
						<%IF UCASE(DKPG_PGCOMPANY) <> "DAOU" Then%>
						<div>
							<span class="orderPrice_tit"><%=LNG_SHOP_ORDER_FINISH_21%></span>
							<span class="orderPrice_infos"><%=DKRS_PGCardNum%></span>
						</div>
						<div>
							<span class="orderPrice_tit"><%=LNG_SHOP_ORDER_FINISH_22%></span>
							<span class="orderPrice_infos"><%=DKRS_PGinstallment%></span>
						</div>
						<%End If%>
						<div>
							<span class="orderPrice_tit"><%=LNG_SHOP_ORDER_FINISH_23%></span>
							<span class="orderPrice_infos"><%=DKRS_PGAcceptNum%></span>
						</div>
					</div>
				</div>
			</div>
		<%End If%>

		<%
			Case "vbank"
		%>
			<div class="order_title_m"><%=LNG_SHOP_ORDER_DIRECT_TITLE_06%> - <%=LNG_TEXT_VIRTUAL_ACCOUNT%></div>
			<div class="width100">
				<div class="porel orderPriceArea">
					<div class="porel infos">
						<div>
							<span class="orderPrice_tit" >결제사</span>
							<span class="orderPrice_infos"><%=DKPG_PGCOMPANY%> (<a href="<%=PGCOMURL%>" target="_blank"><%=PGCOMURL%></a>)</span>
						</div>
						<%IF UCASE(DKPG_PGCOMPANY) <> "DAOU" Then%>
						<div>
							<span class="orderPrice_tit">입금은행</span>
							<span class="orderPrice_infos"><%=DKRS_vBankName%></span>
						</div>
						<div>
							<span class="orderPrice_tit">입금계좌</span>
							<span class="orderPrice_infos"><%=DKRS_vBankAccNum%></span>
						</div>
						<div>
							<span class="orderPrice_tit">예금주</span>
							<span class="orderPrice_infos"><%=DKRS_vBankRecvName%></span>
						</div>
						<div>
							<span class="orderPrice_tit">입금종료일</span>
							<span class="orderPrice_infos"><%=datetoText(DKRS_vBankDepDate)%></span>
						</div>
						<%ELSE%>
						<div>
							<span class="orderPrice_tit">입금은행</span>
							<span class="orderPrice_infos"><%=FN_INICIS_BANKCODE_VIEW(DKRS_PGinstallment)%></span>
						</div>
						<div>
							<span class="orderPrice_tit">입금계좌</span>
							<span class="orderPrice_infos"><%=DKRS_vBankAccNum%></span>
						</div>
						<div>
							<span class="orderPrice_tit">입금자명</span>
							<span class="orderPrice_infos"><%=DKRS_PGAcceptNum%></span>
						</div>
						<div>
							<span class="orderPrice_tit">입금예정일</span>
							<span class="orderPrice_infos"><%=DKRS_PGCardCode%></span>
						</div>
						<%End If%>
						<%If UCase(DK_MEMBER_NATIONCODE) = "KR" Then%>
							<hr>
							<div>
								<span class="orderPrice_tit">현금영수증 발행</span>
								<span class="orderPrice_infos"><%=C_HY_TF_TEXT%></span>
							</div>
							<%If RS_C_HY_TF = "1" Then%>
								<div>
									<span class="orderPrice_tit">현금영수증 신고번호</span>
									<span class="orderPrice_infos">[<%=C_HY_Division_TEXT%>] <%=RS_C_HY_SendNum%></span>
								</div>
							<%End If%>
						<%End If%>
					</div>
				</div>
			</div>
		<%
			Case "dbank"
		%>
			<div class="order_title_m"><%=LNG_SHOP_ORDER_DIRECT_TITLE_06%> - <%=LNG_SHOP_ORDER_FINISH_26%></div>
			<div class="width100">
				<div class="porel orderPriceArea">
					<div class="porel infos">
						<div>
							<span class="orderPrice_tit" ><%=LNG_SHOP_ORDER_FINISH_19%></span>
							<span class="orderPrice_infos"><%=DKPG_PGCOMPANY%> (<a href="<%=PGCOMURL%>" target="_blank"><%=PGCOMURL%></a>)</span>
						</div>
						<div>
							<span class="orderPrice_tit"><%=LNG_SHOP_ORDER_FINISH_27%></span>
							<span class="orderPrice_infos"><%=FN_INICIS_BANKCODE_VIEW(DKRS_PGCardCode)%></span>
						</div>
					</div>
				</div>
			</div>
		<%
			Case "point","point2"
		%>
			<div class="order_title_m"><%=LNG_SHOP_ORDER_DIRECT_TITLE_06%> - <%=LNG_SHOP_ORDER_FINISH_12%></div>
			<div class="width100">
				<div class="porel orderPriceArea">
					<div class="porel infos">
						<div>
							<span class="orderPrice_tit" ><%=SHOP_POINT%></span>
							<span class="orderPrice_infos"><%=num2cur(DKRS_usePoint)%></span>
						</div>
						<%If DKRS_usePoint2 > 0 Then%>
						<div>
							<span class="orderPrice_tit"><%=SHOP_POINT2%></span>
							<span class="orderPrice_infos"><%=num2cur(DKRS_usePoint2)%></span>
						</div>
						<%End If%>
					</div>
				</div>
			</div>

		<%
			Case "direct"	'직접수령
		%>
			<!-- <div class="order_title_m"><%=LNG_SHOP_ORDER_DIRECT_TITLE_06%> - <%=LNG_CS_ORDERS_RECEIVE_METHOD%></div>
			<div class="width100">
				<div class="porel orderPriceArea">
					<div class="porel infos">
						<div>
							<span class="orderPrice_infos" ><%=LNG_CS_ORDERS_RECEIVE_PICKUP%></span>
						</div>
					</div>
				</div>
			</div> -->
		<%
			End Select
		%>

</div>
<!--#include virtual = "/m/_include/copyright.asp"-->
