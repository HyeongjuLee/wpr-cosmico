<!--#include virtual = "/_lib/strFunc.asp"-->
<!--#include virtual="/PG/NICEPAY/NICEPAY_FUNCTION.ASP"-->
<!--#include virtual="/_lib/MD5.asp" -->
<%
	Call FN_NationCurrency(DK_MEMBER_NATIONCODE,Chg_CurrencyName,Chg_CurrencyISO)

	PAGE_SETTING = "SHOP"
	PAGE_INFO = "ORDER"

	'//////////////////////////////////////////////////////////////////////////////////
	Function makeOrderNo()
		Dim nowTime : nowTime = Now
		Dim firstDay, startTime
		Dim no1_head, no2_year, no3_dayNum, no4_secondNum, no5_rndNo

		firstDay = Year(nowTime) &"-01-01"
		startTime = FormatDateTime(nowTime, 2) &" 00:00:00"

		Randomize
		rndNo = Int(Rnd * 99+Second(nowTime))

		no1_head = "DM"
		no2_year = Right(Year(nowTime), 2)
		no3_dayNum = Right("00"& (DateDiff("d", firstDay, nowTime)+1), 3)
		no4_secondNum = Right("0000"& DateDiff("s", startTime, nowTime), 5)
		no5_rndNo = Right("0"& rndNo, 2)

		makeOrderNo = no1_head & no2_year & no3_dayNum & no4_secondNum & no5_rndNo
	End Function
	' ////////////////////////////////////////////////////////////////////////////////

	'회원 구분 후 회원정보 받아오기
	Select Case DK_MEMBER_TYPE
		Case "MEMBER","ADMIN"
			arrParams = Array( _
				Db.makeParam("@strUserID",adVarChar,adParamInput,30,DK_MEMBER_ID) _
			)
			Set DKRS = Db.execRs("DKP_ORDER_MEM_INFO",DB_PROC,arrParams,Nothing)
			If Not DKRS.BOF And Not DKRS.EOF Then
				strName		= DKRS("strName")
				strTel		= DKRS("strTel")
				strMobile	= DKRS("strMobile")
				strEmail	= DKRS("strEmail")
				strzip		= DKRS("strzip")
				strADDR1	= DKRS("strADDR1")
				strADDR2	= DKRS("strADDR2")
				intPoint	= DKRS("intPoint")
			Else
				Call  ALERTS(LNG_SHOP_ORDER_DIRECT_02,"BACK","")
			End If
			Call closeRS(DKRS)
		Case "COMPANY"
			arrParams = Array(_
				Db.makeParam("@mbid",adVarChar,adParamInput,20,DK_MEMBER_ID1), _
				Db.makeParam("@mbid2",adInteger,adParamInput,0,DK_MEMBER_ID2) _
			)
			Set DKRS = Db.execRs("DKP_MEMBER_INFO",DB_PROC,arrParams,DB3)
			If Not DKRS.BOF And Not DKRS.EOF Then
				strName		= DKRS("M_Name")
				strTel		= DKRS("hometel")
				strMobile	= DKRS("hptel")
				strEmail	= DKRS("Email")
				strzip		= (DKRS("Addcode1"))		'CS우편번호
				strADDR1	= DKRS("Address1")
				strADDR2	= DKRS("Address2")
				intPoint	= 0
			Else
				Call  ALERTS(LNG_SHOP_ORDER_DIRECT_02,"BACK","")
			End If
			Call closeRS(DKRS)
		Case "SELLER" : Call ALERTS(LNG_SHOP_ORDER_DIRECT_03,"BACK","")
		Case "GUEST"
				strName		= ""
				strTel		= ""
				strMobile	= ""
				strEmail	= ""
				strzip		= ""
				strADDR1	= ""
				strADDR2	= ""
				intPoint	= ""
		Case Else : Call ALERTS(LNG_SHOP_ORDER_DIRECT_04,"BACK","")
	End Select




	If DKCONF_SITE_ENC = "T" Then
		'회원정보 복호화
		Set objEncrypter = Server.CreateObject ("Hyeongryeol.StringEncrypter")
			objEncrypter.Key = con_EncryptKey
			objEncrypter.InitialVector = con_EncryptKeyIV
			If strADDR1		<> "" Then strADDR1			= objEncrypter.Decrypt(strADDR1)
			If straddr2		<> "" Then straddr2			= objEncrypter.Decrypt(straddr2)
			If strTel		<> "" Then strTel			= objEncrypter.Decrypt(strTel)
			If strMobile	<> "" Then strMobile		= objEncrypter.Decrypt(strMobile)
			If strEmail		<> "" Then strEmail			= objEncrypter.Decrypt(strEmail)
		Set objEncrypter = Nothing
	End If


	If strTel = "" Or IsNull(strTel) Then strTel = ""
	If strMobile = "" Or IsNull(strMobile) Then strMobile = ""
	arrTel = Split(strTel,"-")
	arrMobile = Split(strMobile,"-")
	If UBound(arrTel) <> 2 Then arrTel = Array("","","")
	If UBound(arrMobile) <> 2 Then arrMobile = Array("","","")

	orderNum = makeOrderNo()




	Call noCache

	inUidx = Trim(pRequestTF("cuidx",True))
	If inUidx = "" Then Call ALERTS(LNG_SHOP_ORDER_DIRECT_01_01,"GO","/m/shop/cart.asp")
	arrUidx = Split(inUidx,",")


	Call Db.beginTrans(Nothing)

		'◆ #1. SHOP 주문 임시테이블 정보 입력
		SQL = ""
		SQL = SQL & "INSERT INTO [DK_ORDER_TEMP] ("
		SQL = SQL & "	[strDomain],[orderNum],[strIDX],[strUserID] "
		SQL = SQL & " ) VALUES ( "
		SQL = SQL & " ?,?,?,?);"
		SQL = SQL & " SELECT ?=@@IDENTITY"
		arrParams = Array(_
			Db.makeParam("@strDomain",adVarChar,adParamInput,50,strHostA), _
			Db.makeParam("@orderNum",adVarChar,adParamInput,20,orderNum), _
			Db.makeParam("@strIDX",adVarChar,adParamInput,50,DK_SES_MEMBER_IDX), _
			Db.makeParam("@strUserID",adVarChar,adParamInput,50,DK_MEMBER_ID), _
			Db.makeParam("@identity",adInteger,adParamOutput,4,0) _
		)
		Call Db.exec(SQL,DB_TEXT,arrParams, Nothing)
		orderTempIDX = arrParams(UBound(arrParams))(4)



%>
<!--#include virtual = "/m/_include/document.asp"-->
<!--#include virtual = "/m/_include/jqueryload.asp"-->

<meta http-equiv="Cache-Control" content="no-cache"/>
<meta http-equiv="Expires" content="0"/>
<meta http-equiv="Pragma" content="no-cache"/>
<meta http-equiv="X-UA-Compatible" content="requiresActiveX=true" />
<link rel="stylesheet" href="order_direct.css">

<script type="text/javascript" src="/m/js/check.js"></script>
<!-- <script type="text/javascript" src="order_direct.js?v2"></script> -->
<script type="text/javascript">
	function deli1on() {
		$(".deli1").removeClass("off");
		$("#infoType").val("O");
		$("#user_info1").css({"display":"block"});
		$("#user_info2").css({"display":"none"});
		$(".deli2").addClass("off");
	}

	function deli2on() {
		$(".deli2").removeClass("off");
		$("#infoType").val("N");
		$("#user_info1").css({"display":"none"});
		$("#user_info2").css({"display":"block"});
		$(".deli1").addClass("off");
	}
</script>
<style>

</style>
<link rel="stylesheet" href="/m/js/icheck/skin/line/_all.css" />
<script src="/m/js/icheck/icheck.min.js"></script>
<script type="text/javascript" src="/m/js/calendar.js"></script>
<script src="https://spi.maps.daum.net/imap/map_js_init/postcode.v2.js"></script>
<script src="/jscript/daumPostCode.js"></script>
<!--#include virtual = "/m/_include/calendar.asp"-->
<!-- <script type="text/javascript" src="/PG/YESPAY/pay_m.js"></script> -->

<%
Select Case UCase(DK_MEMBER_NATIONCODE)
	Case "KR"
		Select Case DKPG_PGCOMPANY
			Case "DAOU"
				' onsubmit=""return fnSubmit();""
				BODYLOAD = "onLoad=""init();"""
				FORMDATA = "<form name=""frmConfirm"" id=""frmConfirm"" onsubmit=""return fnSubmit();"" method=""post"">"
				'If DK_MEMBER_TYPE = "COMPANY" And DK_MEMBER_STYPE = "0" And DKPG_KEYIN = "T" Then
				If DK_MEMBER_TYPE = "COMPANY" And DKPG_KEYIN = "T" Then
					'PRINT DKPG_PGJAVA_BASE2
					Response.Write "<script type=""text/javascript"" src=""/PG/DAOU/"&DKPG_PGJAVA_BASE4&"?v=3""></script>"

				Else
					Response.Write "<script type=""text/javascript"" src=""/PG/DAOU/"&DKPG_PGJAVA_BASE4&"?v=3""></script>"
					print DKPG_PGJAVA_BASE3
				End If
		%>
		<%
			Case "SPEEDPAY"
				BODYLOAD = ""
				FORMDATA = "<form name=""orderFrm"" id=""orderFrm"" action=""/PG/SPEEDPAY/order_card_result_mobile.asp"" onsubmit=""return orderSubmit(this);"" method=""post"">"
		%>
		<script type="text/javascript" src="/PG/SPEEDPAY/pay_order_mobile.js"></script>
		<%
			Case "YESPAY"
				BODYLOAD = ""
				FORMDATA = "<form name=""orderFrm"" id=""orderFrm"" action=""/PG/YESPAY/CardResult.asp"" onsubmit=""return orderSubmit(this);"" method=""post"">"
		%>
		<script type="text/javascript" src="/PG/YESPAY/pay_m.js"></script>
		<%
			Case "ONOFFKOREA"		'상단 order_direct.js 주석걸기!
				BODYLOAD = ""
				FORMDATA = "<form name=""orderFrm"" id=""orderFrm"" onsubmit=""return orderSubmit(this);"" method=""post"">"
		%>
		<script type="text/javascript" src="/PG/ONOFFKOREA/pay_m.js"></script>
		<%
			Case "NICEPAY"
				BODYLOAD = ""
				'FORMDATA = "<form name=""orderFrm"" id=""orderFrm"" onsubmit=""return orderSubmit(this);"" method=""post"">"
				FORMDATA = "<form name=""payForm"" id=""payForm"" action="" accept-charset=""euc-kr"" target=""_self""  onsubmit=""return orderSubmit(this);"" method=""post"">"
		%>
		<script type="text/javascript" src="/PG/NICEPAY/pay_m.js?v3"></script>

		<%
		End Select


	Case Else
		BODYLOAD = ""
		FORMDATA = "<form name=""payForm"" method=""post"" action=""/PG/inbank_Result.asp"" onsubmit=""return orderSubmit(this);"">"

%>
		<!--#include virtual = "/PG/pay_union_m.asp"-->
<%
End Select
%>
</head>
<body onload="calcSettlePrice(); checkpayType(); ">
<!--#include virtual = "/m/_include/header.asp"-->
<!--#include virtual = "/m/_include/sub_header.asp"-->
<%
	If webproIP="T" Then
		Call ResRW(DKPG_PGMOD,"PG_MODE")
		Call ResRW(DKPG_PGCOMPANY,"웹프로_IP_VIEW - 연결PG사")
		If UCase(DKPG_PGCOMPANY) = "DAOU" Then
			If Right(DKFD_PGMOD,4) = "TEST" Then
				Call ResRW(DKPG_PGIDS_MOBILE_KEYIN,"DKPG_PGIDS_SHOP_KEYIN")
				Call ResRW(DKPG_PGJAVA_BASE4,"자바연결1")
			Else
				Call ResRW(DKPG_PGIDS_MOBILE_KEYIN,"DKPG_PGIDS_SHOP_KEYIN")
				Call ResRW(DKPG_PGJAVA_BASE4,"자바연결1")
			End If
		End If
	End If
	If UCase(DKPG_PGCOMPANY) = "YESPAY" Then Call ResRW("/PG/YESPAY/pay_m.js","자바연결")
	If UCase(DKPG_PGCOMPANY) = "NICEPAY" Then Call ResRW("/PG/NICEPAY/pay_m.js","자바연결")
%>
<style type="text/css">
	#loading_bg {width:100%;height:100%;top:0px;left:0px;position:fixed;display:block; opacity:0.7;background-color:#fff;z-index:99;text-align:center; }
	#loading-image {position:absolute; top:40%; left:45%; z-index:100;}
</style>
<div id="shop" class="detailView porel">
	<div id="cart_title_b" class="width100 tcenter text_noline tweight" ><%=LNG_SHOP_ORDER_DIRECT_TITLE_01%></div>
	<!-- <form name="orderFrm" id="orderFrm" onsubmit="return orderSubmit(this);" action="/PG/YESPAY/CardResult.asp" method="post"> -->
	<%=FORMDATA%>
	<div id="loadingPro" style="position:fixed; z-index:99999; width:100%; height:100%; top:0px; left:0px; background:url(/images_kr/loading_bg70.png) 0 0 repeat; display:none;">
		<div style="position:relative; top:40%; text-align:center;">
			<img src="<%=IMG%>/159.gif" width="60" alt="" />
		</div>
	</div>
		<input type="hidden" name="cuidx" value="<%=inUidx%>" />
		<input type="hidden" name="infoType" id="infoType" value="O" /> <!-- O : 기존정보, N : 새정보 -->
		<input type="hidden" name="pageType" value="mobile" />
		<input type="hidden" name="orderMode" value="mobile" />

		<div class="cart_title_m"><%=LNG_SHOP_ORDER_DIRECT_TABLE_01%></div>
		<%
			TOTAL_DeliveryFee = 0 ' 최종 배송금액
			TOTAL_OptionPrice =  0
			TOTAL_OptionPrice2 =  0
			TOTAL_Price = 0 ' 최종 결제금액
			TOTAL_Point =  0
			TOTAL_GOODS_PRICE = 0
			TOTAL_USEPOINT_PRICE = 0
			TOTAL_PV = 0

				CSGoodCnt = 0

				If DK_MEMBER_ID <> "" Then
					CART_ID = DK_MEMBER_ID
					CART_METHOD = "MEMBER"
				Else
					CART_ID = DK_MEMBER_IDX
					cart_method = "NOTMEM"
				End If

				'print DK_MEMBER_ID
				'print inUidx
				'print CART_METHOD

				k = 0
				arrParams = Array(_
					Db.makeParam("@strUserID",adVarChar,adParamInput,30,DK_MEMBER_ID), _
					Db.makeParam("@DATA_IDX",adVarChar,adParamInput,2000,inUidx), _
					Db.makeParam("@CART_METHOD",adVarChar,adParamInput,10,CART_METHOD) _
				)
				arrList = Db.execRsList("DKP_ORDER_GOODS_CART_LIST",DB_PROC,arrParams,listLen,Nothing)
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

						arrList_isDirect			= arrList(48,i)		'isDirect or Cart 체크

						'print arrList_isCSGoods
						If arrList_isCSGoods = "T" Then CSGoodCnt = CSGoodCnt + 1

						'##################################################################
						' 회원레벨별 상품가격 변졍
						'################################################################## START
							Select Case DK_MEMBER_LEVEL
								Case 0,1 '비회원, 일반회원
									arrList_GoodsPrice = arrList_intPriceNot
									arrList_GoodsPoint = arrList_intPointNot
								Case 2 '인증회원
									arrList_GoodsPrice = arrList_intPriceAuth
									arrList_GoodsPoint = arrList_intPointAuth
								Case 3 '딜러회원
									arrList_GoodsPrice = arrList_intPriceDeal
									arrList_GoodsPoint = arrList_intPointDeal
								Case 4,5 'VIP 회원
									arrList_GoodsPrice = arrList_intPriceVIP
									arrList_GoodsPoint = arrList_intPointVIP
								Case 9,10,11
									arrList_GoodsPrice = arrList_intPriceVIP
									arrList_GoodsPoint = arrList_intPointVIP
							End Select
						'##################################################################	END

						'##################################################################
						' 루프내 가격 초기화
						'################################################################## START
							self_Price = 0
							self_Point = 0
							self_optionPrice = 0
							self_optionPrice2 = 0
							self_total_price = 0 'TOTAL_POINT_PRICE = self_Price + self_optionPrice
							self_PV = 0

							sum_optionPrice = 0
							sum_optionPrice2 = 0
						'################################################################## END


						'##################################################################
						' CS회원인 경우 PV값 / 상품판매가 확인
						'################################################################## START
							arr_CS_price4 = 0
							arr_CS_SELLCODE		= ""
							arr_CS_SellTypeName = ""

							If arrList_isCSGoods = "T" And DK_MEMBER_TYPE = "COMPANY" Then
								'▣CS상품정보 변동정보 통합
								arrParams = Array(_
									Db.makeParam("@ncode",adVarChar,adParamInput,20,arrList_CSGoodsCode) _
								)
								Set DKRS = Db.execRs("HJP_CSGOODS_PRICE_INFO",DB_PROC,arrParams,DB3)
								If Not DKRS.BOF And Not DKRS.EOF Then
									arr_CS_ncode		= DKRS("ncode")
									arr_CS_price		= DKRS("price")			'소비자가
									arr_CS_price2		= DKRS("price2")
									arr_CS_price4		= DKRS("price4")
									arr_CS_price5		= DKRS("price5")
									arr_CS_price6		= DKRS("price6")
									arr_CS_SellCode		= DKRS("SellCode")
									arr_CS_SellTypeName	= DKRS("SellTypeName")
									If arr_CS_SellTypeName <> "" Then
									arr_CS_SellTypeName = "<span class=""tweight blue2"">구매종류 : </span><span class=""green tweight"">"&arr_CS_SellTypeName&"</span>"
									End If
								End If
								Call closeRs(DKRS)

								'▣ 소비자 가격
								If CONST_CS_SOBIJA_PRICE_USE_TF = "T" Then
									If DK_MEMBER_STYPE = "1" And arrList_isCSGoods = "T" Then
										arrList_GoodsPrice = arrList_GoodsCustomer
										arr_CS_price2	   = arr_CS_price
									End If
								End If

								'CS판매금액과 쇼핑몰등록된 CS판매금 비교
								If arrList_isCSGoods = "T" And (arr_CS_price2 <> arrList_GoodsPrice) Then Call ALERTS(LNG_SHOP_DETAILVIEW_JS_DIFFERENT_PRICE,"back","")

								'▣구매종류가 다른 상품은 구매불가	Fn_DistinctData▣
									LAST_CS_SellCode = CStr(arr_CS_SellCode)
									ALL_CS_SellCode  = ALL_CS_SellCode & arr_CS_SellCode &","

							End If
						'################################################################## END


						'##################################################################
						' 이미지 / 아이콘정보 확인
						'################################################################## START
							If arrList_isImgType = "S" Then
								'imgPath = VIR_PATH("goods/list")&"/"&backword(arrList_imgList)
								imgPath = VIR_PATH("goods/thum")&"/"&backword(arrList_imgThum)
							Else
								imgPath = BACKWORD(arrList_imgList)
							End If

							printGoodsIcon = ""

							If arrList_flagBest	= "T" Then printGoodsIcon = printGoodsIcon & "<span class=""icons"">"&viewImg(IMG_ICON&"/i_bestT.gif",31,11,"")&"</span>"
							If arrList_flagNew	= "T" Then printGoodsIcon = printGoodsIcon & "<span class=""icons"">"&viewImg(IMG_ICON&"/i_newT.gif",31,11,"")&"</span>"
							If arrList_FlagVote	= "T" Then printGoodsIcon = printGoodsIcon & "<span class=""icons"">"&viewImg(IMG_ICON&"/i_voteT.gif",31,11,"")&"</span>"
							If (DK_MEMBER_TYPE = "COMPANY" And DK_MEMBER_STYPE = "0") Or DK_MEMBER_TYPE ="ADMIN" Then
								If arrList_isCSGoods	= "T" Then printGoodsIcon = printGoodsIcon & "<span class=""icons"">"&viewImg(IMG_ICON&"/i_csgoodsT.gif",50,11,"")&"</span>"
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
								sum_optionPrice = Int(sum_optionPrice) + Int(arrOption(1))
								sum_optionPrice2 = Int(sum_optionPrice2) + Int(arrOption(2))
							Next
						'################################################################## END

						'##################################################################
						' 상품별 금액/적립금 확인
						'################################################################## START
							self_Price = Int(arrList_orderEa) * Int(arrList_GoodsPrice)
							self_Point = Int(arrList_orderEa) * Int(arrList_GoodsPoint)
							self_optionPrice = Int(arrList_orderEa) * Int(sum_optionPrice)
							self_optionPrice2 = Int(arrList_orderEa) * Int(sum_optionPrice2)
							self_total_price = self_Price + self_optionPrice

							TOTAL_POINT_PRICE = self_Price + self_optionPrice		'self_total_price
							self_PV = Int(arrList_orderEa) * Int(arr_CS_price4)
						'################################################################## END

						'##################################################################
						' 배송비 확인
						'################################################################## START
							If arrList_GoodsDeliveryType = "SINGLE" Then
								DeliveryFee = Int(arrList_GoodsDeliveryFee)
								self_DeliveryFee = Int(arrList_orderEa) * Int(arrList_GoodsDeliveryFee)
								'spans(num2cur(DeliveryFee),"#FF6600","","")
								'txt_DeliveryFee = "<span class=""tweight"">선결제 "&spans(num2cur(self_DeliveryFee),"#FF6600","","")&"원</span>"
								'txt_DeliveryInfo = "<span class=""f11px"">단독배송상품 / 개당 "&num2cur(self_DeliveryFee)&"원 </span>"
								txt_DeliveryFee = "<span class=""tweight"">"&LNG_SHOP_ORDER_DIRECT_TABLE_08& " "&spans(num2curINT(self_DeliveryFee),"#FF6600","","")&" "&Chg_CurrencyISO&"</span>"
								txt_DeliveryInfo = "<span class=""f11px"">"&LNG_SHOP_ORDER_DIRECT_TABLE_08&num2curINT(DeliveryFee)&" "&Chg_CurrencyISO&"</span>"

								'TOTAL_DeliveryFee = TOTAL_DeliveryFee + selfDeliveryFee
								arrList_DELICNT = 1
								txt_DeliveryFeeType = LNG_SHOP_ORDER_DIRECT_TABLE_08

							ElseIf arrList_GoodsDeliveryType = "AFREE" Then
								self_DeliveryFee = "0"
								'txt_DeliveryFee = "<span class=""tweight"">"&spans("무료배송상품(묶음배송불가)","#0099FF","","")&"</span>"
								'txt_DeliveryFeeType = "무료배송(묶음배송불가)"
								'txt_DeliveryInfo = "<span class=""f11px"">무료배송(묶음배송불가)</span>"
								txt_DeliveryFee = "<span class=""tweight"">"&spans(LNG_SHOP_ORDER_DIRECT_TABLE_09,"#0099FF","","")&"</span>"
								txt_DeliveryFeeType = LNG_SHOP_ORDER_DIRECT_TABLE_10
								txt_DeliveryInfo = "<span class=""f11px"">"&LNG_SHOP_ORDER_DIRECT_TABLE_10&"</span>"
								arrList_DELICNT = 1
							ElseIf arrList_GoodsDeliveryType = "BASIC" Then
								'print arrList_DELICNT
								If arrList_DELICNT = 1 Then

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

									'▣ 국가별 배송비 설정
									If TOTAL_POINT_PRICE >= DKRS2_intDeliveryFeeLimit Then
										self_DeliveryFee = "0"
										txt_DeliveryFee = "<span class=""tweight"">"&spans(LNG_SHOP_ORDER_DIRECT_TABLE_10,"#FF6600","","")&"</span>"		'무료배송
										txt_DeliveryFeeType = LNG_SHOP_ORDER_DIRECT_TABLE_10
										txt_DeliveryInfo = "<span class=""f11px"">"&LNG_SHOP_ORDER_DIRECT_TABLE_10&"</span>"
									Else
										self_DeliveryFee = DKRS2_intDeliveryFee
										txt_DeliveryFee = "<span class=""tweight"">"&LNG_SHOP_ORDER_DIRECT_TABLE_07&" "&num2curINT(self_DeliveryFee)&" "&Chg_currencyISO&"</span><br /><span class=""f11px lheight130"">"&LNG_SHOP_ORDER_DIRECT_TABLE_11&" <br />"&LNG_SHOP_DETAILVIEW_21&" ("&num2curINT(DKRS2_intDeliveryFeeLimit)&" "&Chg_currencyISO&")</span>"
										txt_DeliveryFeeType = LNG_SHOP_ORDER_DIRECT_TABLE_07
										txt_DeliveryInfo = "<span class=""f11px"">"&LNG_SHOP_ORDER_DIRECT_TABLE_11&" <br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"&LNG_SHOP_DETAILVIEW_21&" ("&num2curINT(DKRS2_intDeliveryFeeLimit)&" "&Chg_currencyISO&")</span>"
									End If

								Else
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

									arrParams3 = Array(_
										Db.makeParam("@cart_method",adVarChar,adParamInput,10,cart_method), _
										Db.makeParam("@MEMTYPE",adVarChar,adParamInput,50,cart_id), _
										Db.makeParam("@strShopID",adVarChar,adParamInput,30,arrList_strShopID), _
										Db.makeParam("@GoodsDeliveryType",adVarChar,adParamInput,6,arrList_GoodsDeliveryType) _
									)
									arrList3 = Db.execRsList("DKP_CART_DELIVERY_CALC2",DB_PROC,arrParams3,listLen3,Nothing)

									TOTAL_POINT_PRICE = 0
									If IsArray(arrList3) Then
										For z = 0 To listLen3
											arrList3_GoodsPrice		= arrList3(0,z)
											arrList3_OrderEa		= arrList3(1,z)
											arrList3_strOption		= arrList3(2,z)
											arrList3_intPriceNot	= arrList3(3,z)
											arrList3_intPriceAuth	= arrList3(4,z)
											arrList3_intPriceDeal	= arrList3(5,z)
											arrList3_intPriceVIP	= arrList3(6,z)

											Select Case DK_MEMBER_LEVEL
												Case 0,1 '비회원, 일반회원
													arrList3_GoodsPrice = arrList3_intPriceNot
												Case 2 '인증회원
													arrList3_GoodsPrice = arrList3_intPriceAuth
												Case 3 '딜러회원
													arrList3_GoodsPrice = arrList3_intPriceDeal
												Case 4,5 'VIP 회원
													arrList3_GoodsPrice = arrList3_intPriceVIP
												Case 9,10,11
													arrList3_GoodsPrice = arrList3_intPriceVIP
											End Select

											'내부 옵션 가격 확인
											calc_optionPrice = 0
											arrResult3 = Split(CheckSpace(arrList3_strOption),",")

											For y = 0 To UBound(arrResult3)
												arrOption3 = Split(Trim(arrResult3(y)),"\")
												calc_optionPrice = Int(calc_optionPrice) + Int(arrOption3(1))
											Next
											TOTAL_POINT_PRICE = TOTAL_POINT_PRICE + (calc_optionPrice * arrList3_OrderEa) + (arrList3_GoodsPrice*arrList3_OrderEa)
										Next
									End If

									'▣ 국가별 배송비 설정
									If TOTAL_POINT_PRICE >= DKRS2_intDeliveryFeeLimit Then
										self_DeliveryFee = "0"
										txt_DeliveryFee = "<span class=""tweight"">"&spans(LNG_SHOP_ORDER_DIRECT_TABLE_10,"#FF6600","","")&"</span>"		'무료배송
										txt_DeliveryFeeType = LNG_SHOP_ORDER_DIRECT_TABLE_10
										txt_DeliveryInfo = "<span class=""f11px"">"&LNG_SHOP_ORDER_DIRECT_TABLE_10&"</span>"
									Else
										self_DeliveryFee = DKRS2_intDeliveryFee
										txt_DeliveryFee = "<span class=""tweight"">"&LNG_SHOP_ORDER_DIRECT_TABLE_07&" "&num2curINT(self_DeliveryFee)&" "&Chg_currencyISO&"</span><br /><span class=""f11px lheight130"">"&LNG_SHOP_ORDER_DIRECT_TABLE_11&" <br />"&LNG_SHOP_DETAILVIEW_21&" ("&num2curINT(DKRS2_intDeliveryFeeLimit)&" "&Chg_currencyISO&")</span>"
										txt_DeliveryFeeType = LNG_SHOP_ORDER_DIRECT_TABLE_07
										txt_DeliveryInfo = "<span class=""f11px"">"&LNG_SHOP_ORDER_DIRECT_TABLE_11&" <br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"&LNG_SHOP_DETAILVIEW_21&" ("&num2curINT(DKRS2_intDeliveryFeeLimit)&" "&Chg_currencyISO&")</span>"
									End If

								End If
							End If
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

						'TOTAL_Price = TOTAL_Price + self_Price + self_DeliveryFee + self_optionPrice
						TOTAL_Price = TOTAL_Price + self_Price + self_optionPrice
						TOTAL_USEPOINT_PRICE = TOTAL_USEPOINT_PRICE + self_Price + self_optionPrice
						'TOTAL_FIRST_PRICE = TOTAL_FIRST_PRICE + self_Price + self_optionPrice + self_DeliveryFee
						'TOTAL_DeliveryFee = TOTAL_DeliveryFee + self_DeliveryFee
						TOTAL_OptionPrice = TOTAL_OptionPrice + self_optionPrice
						TOTAL_OptionPrice2 = TOTAL_OptionPrice2 + self_optionPrice2
						TOTAL_GOODS_PRICE = TOTAL_GOODS_PRICE + self_Price
						TOTAL_POINT = TOTAL_POINT + self_Point
						TOTAL_PV = TOTAL_PV + self_PV


						'애니페이 상품별 SP사용 최대 포인트
					''	SP_POINTUSE_MAX		= selfPrice * (arr_CS_price6 / 100)					'상품별 SP사용 최대 포인트
					''	TOTAL_SP_POINTUSE_MAX = TOTAL_SP_POINTUSE_MAX + SP_POINTUSE_MAX			'총 SP사용 최대 포인트(배송비 제외)
					''	'print selfPrice &" "&arr_CS_price6&" "&arr_CS_price6/100&" "&SP_POINTUSE_RATIO&"<br/>"
					''	'print TOTAL_SP_POINTUSE_MAX

			%>
			<%

					'◆ #2. SHOP 주문 임시테이블 정보 입력 SHOP 상품 임시테이블 정보 입력
					arrParamsGI = Array(_
						Db.makeParam("@OrderIDX",adInteger,adParamInput,0,orderTempIDX),_
						Db.makeParam("@orderNum",adVarChar,adParamInput,20,orderNum), _
						Db.makeParam("@GoodIDX",adInteger,adParamInput,0,arrList_GoodIDX),_
						Db.makeParam("@GoodsCode",adVarChar,adParamInput,20,arrList_CSGoodsCode),_
						Db.makeParam("@GoodsPrice",adVarChar,adParamInput,20,arrList_GoodsPrice),_
						Db.makeParam("@GoodsPV",adInteger,adParamInput,0,arr_CS_price4),_
						Db.makeParam("@orderEa",adInteger,adParamInput,0,arrList_orderEa),_
						Db.makeParam("@strOption",adVarWChar,adParamInput,800,arrList_strOption),_
						Db.makeParam("@isShopType",adChar,adParamInput,1,arrList_isShopType),_
						Db.makeParam("@strShopID",adVarChar,adParamInput,20,arrList_strShopID),_
						Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR")_
					)
					Call Db.exec("HJP_ORDER_TEMP_GOODS_SHOP_INSERT",DB_PROC,arrParamsGI,Nothing)
					OUTPUT_VALUE = arrParams(UBound(arrParams))(4)

					If OUTPUT_VALUE = "ERROR" Then
						Call ALERTS(LNG_CS_ORDERS_ALERT04,"BACK","")
						Exit For
					End If

			%>
			<input type="hidden" name="GoodIDXs" value="<%=arrList_GoodIDX%>" readonly="readonly"/><%'◆%>
			<input type="hidden" name="strOptions" value="<%=arrList_strOption%>" readonly="readonly"/><%'◆%>
			<input type="hidden" name="ea" value="<%=arrList_orderEa%>" readonly="readonly"/><%'◆%>

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
											<span style="vertical-align:-2px; color:#ff6600; font-size:17px;"><%=num2cur(self_Price)%></span> <%=Chg_currencyISO%>
											<%If arrList_isCSGoods = "T" And DK_MEMBER_TYPE = "COMPANY"  And DK_MEMBER_STYPE = "0" Then%>
											 <!-- / <span style="vertical-align:-1px;color:#d43f05; font-size:14px;"><%=num2cur(self_PV)%></span> <%=CS_PV%> -->
											 <!-- <%If arr_CS_SellTypeName <> "" Then%>/ <span style="vertical-align:-1px;color:green; font-size:12px;"><%=arr_CS_SellTypeName%></span><%End If%> -->
											<%End If%>
											/ <%
												If k = 1 Then
													print txt_DeliveryFee
												Else
													'print "묶음배송상품"
													print LNG_SHOP_DETAILVIEW_20
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
									<span class="goodsInfo_span"><%=LNG_SHOP_ORDER_DIRECT_TABLE_02%><!-- 상품금액 --></span>
									<span style="letter-spacing:-1px; font-size:12px;"><%=num2cur(arrList_GoodsPrice)%> <%=Chg_currencyISO%> / <%=LNG_TEXT_EA%></span>
								</div>
								<div>
									<span class="goodsInfo_span"><%=LNG_SHOP_ORDER_DIRECT_TABLE_03%><!-- 구매수량 --></span>
									<span style="letter-spacing:-1px; font-size:12px;"><%=arrList_orderEa%> <%=LNG_TEXT_EA%></span>
								</div>
								<%If arrList_isCSGoods = "T" And DK_MEMBER_TYPE = "COMPANY"  And DK_MEMBER_STYPE = "0" Then%>
									<!-- <div>
										<span class="goodsInfo_span"><%=CS_PV%></span>
										<span style="letter-spacing:-1px; font-size:12px;"><%=num2curINT(arr_CS_price4)%> <%=CS_PV%> / <%=LNG_TEXT_EA%></span>
									</div> -->
								<%End If%>
								<%If self_Point > 0 Then%>
								<div>
									<span class="goodsInfo_span"><%=LNG_SHOP_ORDER_FINISH_14%><!-- 적립금 --></span>
									<span style="letter-spacing:-1px; font-size:12px;"><%=num2cur(self_Point)%> <%=Chg_currencyISO%> (<%=num2cur(self_Point)%> * <%=orderEa%>)</span>
								</div>
								<%End If%>
								<div>
									<span class="goodsInfo_span"><%=LNG_SHOP_COMMON_DELIVERY_POLICY%><!-- 배송정책 --></span>
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
				'print Total_DeliveryFee
						If arrList_DELICNT = 1 Then
							l = 1
							TOTAL_DeliveryFee = TOTAL_DeliveryFee + self_DeliveryFee
						Else
							If l = 0 Then
								l = 1
								TOTAL_DeliveryFee = TOTAL_DeliveryFee + self_DeliveryFee
							Else
								l = l
								TOTAL_DeliveryFee = TOTAL_DeliveryFee
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
					'Call ALERTS("장바구니가 비었습니다.","GO","/m/shop/cart.asp")
					Call ALERTS(LNG_SHOP_ORDER_DIRECT_08,"GO","/m/shop/cart.asp")
				End If

'If webproIP="T" Then TOTAL_DeliveryFee = 10

				TOTAL_SUM_PRICE = TOTAL_GOODS_PRICE + TOTAL_DeliveryFee + TOTAL_OptionPrice

				TOTAL_POINTUSE_MIN = CONST_CS_POINTUSE_MIN				'최소사용 포인트
				TOTAL_POINTUSE_MAX = TOTAL_SUM_PRICE					'최대사용 포인트

			%>
			<%
				'▣구매종류가 다른 상품은 구매불가	Fn_DistinctData▣
				If DK_MEMBER_TYPE = "COMPANY" Then
					Dim arrData, arrTmp, sData

					sData	= ALL_CS_SellCode
					arrData = Split(sData,",")
					arrTmp	= Fn_DistinctData(arrData)

					For d = 0 to Ubound(arrTmp)
						DISTINCT_SELLCODE = DISTINCT_SELLCODE & arrTmp(d)
					Next
					'PRINT DISTINCT_SELLCODE

					If LAST_CS_SellCode <> DISTINCT_SELLCODE Then
						 Call ALERTS(LNG_CS_CART_JS04,"back","")
					End If
				End If
			%>
			<input type="hidden" name="cmoneyUseLimit" value="1"> <%'사용가능 최소 적립금 %>
			<input type="hidden" name="cmoneyUseMin" value="1"> <%' 결제시 최소사용 적립금 %>
			<!-- <input type="hidden" name="cmoneyUseMax" value="<%=TOTAL_POINT_PRICE%>"><%'결제시 최대사용 적립금 : 상품가%> -->
			<input type="hidden" name="cmoneyUseMax" value="<%=TOTAL_SUM_PRICE - 1000%>"><%'▣(카드)결제시 최대사용 적립금 : 상품가 → 결제금(배송비포함, 카드결제최소금액세팅  1000)%>
			<input type="hidden" name="ownCmoney" value="<%=checkNumeric(MILEAGE_TOTAL)%>">						<%'GNG 회원 보유 C포인트 (외국회원만) %>
			<input type="hidden" name="ownCmoney2" value="<%=checkNumeric(MILEAGE2_TOTAL)%>"  readonly="readonly"> <%'회원 보유 S포인트:%>
			<input type="hidden" name="orgSettlePrice" value="<%=TOTAL_SUM_PRICE%>"><%' 최초 결제금액%>
				<input type="hidden" name="TOTAL_POINTUSE_MIN" value="<%=TOTAL_POINTUSE_MIN%>"  readonly="readonly"><%'▶ 최소 포인트사용가능 금액%>
				<input type="hidden" name="TOTAL_POINTUSE_MAX" value="<%=TOTAL_POINTUSE_MAX%>"  readonly="readonly"><%'▶ 최대 포인트사용가능 금액%>

			<div id="cart_title_m" class="cart_title_m" style="margin-top:15px;" ><%=LNG_SHOP_ORDER_DIRECT_TITLE_04%></div>
			<div  id="user_info1" class="user_info1 clear">
				<table <%=tableatt%> class="width100">
					<col width="120" />
					<col width="*" />
					<tr>
						<th><%=LNG_SHOP_ORDER_DIRECT_TABLE_17%> <%=startext%></th>
						<td><input type="text" name="strName" class="input_text width100" value="<%=strName%>" /></td>
					</tr><tr>
						<th><%=LNG_SHOP_ORDER_DIRECT_TABLE_18%></th>
						<td><input type="tel" name="strTel" class="input_text width100" style="ime-mode: disabled;" <%=onLyKeys%> value="<%=strTel%>" maxlength="15" /></td>
					</tr><tr>
						<th><%=LNG_SHOP_ORDER_DIRECT_TABLE_19%> <%=startext%></th>
						<td><input type="tel" name="strMobile" class="input_text width100" style="ime-mode: disabled;" <%=onLyKeys%> value="<%=strMobile%>" maxlength="15"/></td>
					</tr>
					<!-- <tr>
						<th class="vtop" rowspan="3"><%=LNG_SHOP_ORDER_DIRECT_TABLE_21%></th>
						<td>
							<div style="width:57%;"><input type="text" class="input_text width100 readonly" name="strZip" id="strZipDaum" class="input_text width100 readonly" readonly="readonly" style="background-color:#eee;" value="<%=strzip%>" /></div><%If UCase(DK_MEMBER_NATIONCODE)="KR" Then%><div class="tcenter" style="width:3%;"></div><div style="width:40%;"><input type="button" name="" onclick="execDaumPostcode('oris');" class="input_btn width100" value="우편번호찾기" /></div><%End If%>
						</td>
					</tr><tr>
						<td><input type="text" name="strADDR1" id="strADDR1Daum" class="input_text" style="width:100%;background-color:#eee;" value="<%=strADDR1%>"  readonly="readonly"  /></td>
					</tr><tr>
						<td><input type="text" name="strADDR2" id="strADDR2Daum" class="input_text" style="width:100%;" value="<%=strADDR2%>"  /></td>
					</tr> -->
					<%Select Case UCase(DK_MEMBER_NATIONCODE)%>
						<%Case "KR"%>
						<tr>
							<th class="vtop" rowspan="3"><%=LNG_SHOP_ORDER_DIRECT_TABLE_21%> <%=startext%></th>
							<td>
								<div style="width:57%;"><input type="text" class="input_text width100 readonly" name="strZip" id="strZipDaum" class="input_text width100 readonly" readonly="readonly" style="background-color:#eee;" value="<%=strzip%>" /></div><div class="tcenter" style="width:3%;"></div><div style="width:40%;"><input type="button" name="" onclick="execDaumPostcode_oris();" class="input_btn width100" value="우편번호찾기" /></div>
							</td>
						</tr><tr>
							<td><input type="text" name="strADDR1" id="strADDR1Daum" class="input_text" style="width:100%;background-color:#eee;" value="<%=strADDR1%>"  readonly="readonly"  /></td>
						</tr>
						<%Case "JPTTTTT"%>
						<tr>
							<th class="vtop" rowspan="3"><%=LNG_SHOP_ORDER_DIRECT_TABLE_21%></th>
							<td>
								<div style="width:57%;"><input type="text" class="input_text width100 readonly" name="strZip" id="strZip" class="input_text width100 readonly" readonly="readonly" style="background-color:#eee;" value="<%=strzip%>" /></div><div class="tcenter" style="width:3%;"></div><div style="width:40%;"><input type="button" name="" onclick="openzip_mjp2EN('strZip');" class="input_btn width100" value="<%=LNG_TEXT_ZIPCODE%>" /></div>
							</td>
						</tr><tr>
							<td><input type="text" name="strADDR1" id="strADDR1" class="input_text" style="width:100%;background-color:#eee;" value="<%=strADDR1%>"  readonly="readonly"  /></td>
						</tr>
						<%Case Else%>
						<tr>
							<th class="vtop" rowspan="3"><%=LNG_SHOP_ORDER_DIRECT_TABLE_21%></th>
							<td>
								<div style="width:57%;"><input type="text" class="input_text width100" name="strZip" class="input_text width100" value="<%=strzip%>" maxlength="6" <%=onLyKeys3%>  /></div><div style="width:40%;">&nbsp;(ZipCode)</div>
							</td>
						</tr><tr>
							<td><input type="text" name="strADDR1" class="input_text" style="width:100%;" value="<%=strADDR1%>" /></td>
						</tr>
					<%End Select%>
					<tr>
						<td><input type="text" name="strADDR2" id="strADDR2Daum" class="input_text" style="width:100%;" value="<%=strADDR2%>"  /></td>
					</tr>
					<%'execDaumPostcode_oris 페이지 끼워넣기%>
					<tr id="DaumPostcode" style="display:none;" class="tcenter">
						<td colspan="2">
							<div id="wrap" style="display:none;border:3px solid;width:98%;height:300px;margin:5px 0;position:relative;">
								<img src="/images_kr/close.png" class="cp" style="position:absolute;right:2px;top:2px;z-index:1;background:#fff;" onclick="foldDaumPostcode()" alt="접기 버튼">
							</div>
							<script src="/jscript/daumPostCode_oris.js"></script>
						</td>
					</tr>
					<tr>
						<th><%=LNG_SHOP_ORDER_DIRECT_TABLE_20%> <%=startext%></th>
						<td><input type="email" class="input_text width100" name="strEmail" value="<%=strEmail%>" /></td>
					</tr>
				</table>
			</div>
			<div id="cart_title_m" class="cart_title_m"  style=""><%=LNG_SHOP_ORDER_DIRECT_TITLE_05%></div>
			<div id="orderSame" style="margin-top:10px; margin-left:10px; color:#d75623;font-size:14px;">&nbsp;&nbsp;<label><input type="checkbox" name="infoCopys" onClick="infoCopy(this);" class="input_chk2" style="margin:0px; height:0px; vertical-align:middle; height:16px; width:16px;" > <%=LNG_SHOP_ORDER_DIRECT_TABLE_22%></label></div>
			<div id="user_info2" class="user_info1 clear">
				<table <%=tableatt%> class="width100">
					<col width="120" />
					<col width="*" />
					<tr>
						<th><%=LNG_SHOP_ORDER_DIRECT_TABLE_17%> <%=startext%></th>
						<td><input type="text" name="takeName" class="input_text width100" /></td>
					</tr><tr>
						<th><%=LNG_SHOP_ORDER_DIRECT_TABLE_18%></th>
						<td><input type="tel" name="takeTel" class="input_text width100" style="ime-mode: disabled;" <%=onLyKeys%> value="" /></td>
					</tr><tr>
						<th><%=LNG_SHOP_ORDER_DIRECT_TABLE_19%> <%=startext%></th>
						<td><input type="tel" name="takeMobile" class="input_text width100" style="ime-mode: disabled;" <%=onLyKeys%> value="" /></td>
					</tr>
					<!-- <tr>
						<th class="vtop" rowspan="3"><%=LNG_SHOP_ORDER_DIRECT_TABLE_21%></th>
						<td>
							<div style="width:57%;"><input type="text" name="takeZip" id="takeZipDaum" class="input_text width100 readonly" readonly="readonly" style="background-color:#eee;" /></div><%If UCase(DK_MEMBER_NATIONCODE)="KR" Then%><div class="tcenter" style="width:3%;"></div><div style="width:40%;"><input type="button" name="" onclick="execDaumPostcode('takes');" class="input_btn width100" value="우편번호찾기" /></div><%End If%>
						</td>
					</tr><tr>
						<td><input type="text" name="takeADDR1" id="takeADDR1Daum" class="input_text" style="width:100%;background-color:#eee;" readonly="readonly"  /></td>
					</tr><tr>
						<td><input type="text" name="takeADDR2" id="takeADDR2Daum" class="input_text" style="width:100%;" /></td>
					</tr> -->
					<%Select Case UCase(DK_MEMBER_NATIONCODE)%>
						<%Case "KR"%>
						<tr>
							<th class="vtop" rowspan="3"><%=LNG_SHOP_ORDER_DIRECT_TABLE_21%> <%=startext%></th>
							<td>
								<div style="width:57%;"><input type="text" name="takeZip" id="takeZipDaum" class="input_text width100 readonly" readonly="readonly" style="background-color:#eee;" /></div><div class="tcenter" style="width:3%;"></div><div style="width:40%;"><input type="button" name="" onclick="execDaumPostcode_takes();" class="input_btn width100" value="우편번호찾기" /></div>
							</td>
						</tr><tr>
							<td><input type="text" name="takeADDR1" id="takeADDR1Daum" class="input_text" style="width:100%;background-color:#eee;" readonly="readonly"  /></td>
						</tr>
						<%Case "JPTTTTT"%>
						<tr>
							<th class="vtop" rowspan="3"><%=LNG_SHOP_ORDER_DIRECT_TABLE_21%></th>
							<td>
								<div style="width:57%;"><input type="text" class="input_text width100 readonly" name="takeZip" id="takeZip" class="input_text width100 readonly" readonly="readonly" style="background-color:#eee;" value="<%=strzip%>" /></div><div class="tcenter" style="width:3%;"></div><div style="width:40%;"><input type="button" name="" onclick="openzip_mjp2EN('takeZip');" class="input_btn width100" value="<%=LNG_TEXT_ZIPCODE%>" /></div>
							</td>
						</tr><tr>
							<td><input type="text" name="takeADDR1" id="takeADDR1" class="input_text" style="width:100%;background-color:#eee;" value=""  readonly="readonly"  /></td>
						</tr>
						<%Case Else%>
						<tr>
							<th class="vtop" rowspan="3"><%=LNG_SHOP_ORDER_DIRECT_TABLE_21%></th>
							<td>
								<div style="width:57%;"><input type="text" class="input_text width100" name="takeZip" class="input_text width100" value="" maxlength="6" <%=onLyKeys3%> /></div><div style="width:40%;">&nbsp;(ZipCode)</div>
							</td>
						</tr><tr>
							<td><input type="text" name="takeADDR1" class="input_text" style="width:100%;" value="" /></td>
						</tr>
					<%End Select %>
					<tr>
						<td><input type="text" name="takeADDR2" id="takeADDR2Daum" class="input_text" style="width:100%;" /></td>
					</tr>
					<%'execDaumPostcode_takes 페이지 끼워넣기%>
					<tr id="DaumPostcode2" style="display:none;" class="tcenter">
						<td colspan="2">
							<div id="wrap2" style="display:none;border:3px solid;width:98%;height:300px;margin:5px 0;position:relative;">
								<img src="/images_kr/close.png" class="cp" style="position:absolute;right:2px;top:2px;z-index:1;background:#fff;" onclick="foldDaumPostcode2()" alt="접기 버튼2">
							</div>
							<script src="/jscript/daumPostCode_takes.js"></script>
						</td>
					</tr>
				</table>
			</div>

			<div class="user_info2 clear">
				<p class="orderMemo"><%=LNG_SHOP_ORDER_DIRECT_TABLE_23%></p>
				<input type="text" name="orderMemo" class="input_text width100" />
			</div>

			<!-- <div class="user_info2 clear">
				<p class="orderMemo">비회원 주문 비밀번호</p> -->
				<input type="hidden" name="strOrderPassword" class="input_text width100 imes" maxlength="20" />
			<!-- </div> -->

			<div class="cart_title_m" style="margin-top:15px; border-bottom:0px none;"><%=LNG_SHOP_ORDER_DIRECT_TABLE_14%><!-- 주문금액 --></div>
			<div class="width100">
				<div class="totalSum porel cartPriceArea" style="">
					<div class="porel ">
						<div class="porel" style="padding:7px 0px; background-color:#f4f4f4; margin:10px 10px 10px 10px;">
							<div style="line-height:20px;">
								<div>
									<span class="cartPrice_tit" ><%=LNG_SHOP_ORDER_FINISH_09%><!-- 상품가격 --></span>
									<span class="cartPrice_Res" style=""><strong><%=num2cur(TOTAL_GOODS_PRICE)%></strong> <%=Chg_currencyISO%></span>
								</div>
								<!-- <%If CSGoodCnt > 0 And DK_MEMBER_TYPE = "COMPANY"  And DK_MEMBER_STYPE = "0" Then%>
									<div>
										<span class="cartPrice_tit"><%=CS_PV%></span>
										<span class="cartPrice_Res"><strong><%=num2curINT(TOTAL_PV)%> </strong><%=CS_PV%></span>
									</div>
								<%End If%> -->
								<%If TOTAL_OptionPrice > 0 Then%>
								<div>
									<span class="cartPrice_tit"><%=LNG_SHOP_ORDER_FINISH_10%><!-- 옵션가 --></span>
									<span class="cartPrice_Res"><strong><%=num2cur(TOTAL_OptionPrice)%></strong> <%=Chg_currencyISO%></span>
								</div>
								<%End If%>
								<div>
									<span class="cartPrice_tit"><%=LNG_SHOP_ORDER_FINISH_11%><!-- 배송비 --></span>
									<span class="cartPrice_Res"><span id="delTXT" style="font-size:0.95em; margin-right:10px;"></span><strong id="priTXT"><%=num2cur(TOTAL_DeliveryFee)%></strong> <%=Chg_currencyISO%></span>
								</div>
								<!-- <div style="margin-top:10px;">
									<span class="cartPrice_tit tweight"><%=LNG_SHOP_ORDER_DIRECT_TABLE_14%></span>
									<span class="cartPrice_Res"><strong id="lastTXT" style="color:#f20000; font-size:24px;"><%=num2cur(TOTAL_SUM_PRICE)%></strong> <%=Chg_currencyISO%></span>
								</div> -->
								<%If isSHOP_POINTUSE = "T" Then%>
								<%
									'▶포인트 소수점 입력시 toCurrency → toCurrencyP2
									Select Case UCase(DK_MEMBER_NATIONCODE)
										Case "KR"
											toCurrency	= "toCurrency"		'포인트 입력창
											pSpace		= 0					'calcSettlePrice  text 표기 소수점 자리수(/PG/NICEPAY/pay_m.js)
										Case Else
											toCurrency  = "toCurrencyP2"
											pSpace		= 2
									End Select
								%>
									<script type="text/javascript">
									<!--
										//소수점
										var NumberFormatter = new Intl.NumberFormat('en-US', {
										  minimumFractionDigits: <%=pSpace%>,
										  maximumFractionDigits: <%=pSpace%>
										});
									// -->
									</script>
									<!-- <div style="margin-top:10px;">
										<span class="cartPrice_tit tweight"><%=SHOP_POINT%><span style="margin-left:5px;">(<%=LNG_CS_ORDERS_POINT_POSSESSION%>:<strong id="RemainArea"><%=num2Cur(MILEAGE_TOTAL)%></strong></span>)</span>
										<span class="cartPrice_Res"><input data-theme="w" type="tel" name="useCmoney" class="" style="text-align:right;font-size:14px;width:50%;" onKeyUp="" onBlur="toCurrency(this); checkUseCmoney(this);" value="0"  />
									</div> -->
									<!-- <div style="margin-top:10px;">
										<span class="cartPrice_tit tweight"><%=SHOP_POINT2%><span style="margin-left:5px;">(<%=LNG_CS_ORDERS_POINT_POSSESSION%>:<strong id="RemainArea"><%=num2Cur(MILEAGE2_TOTAL)%></strong></span>)</span>
										<span class="cartPrice_Res"><input data-theme="w" type="tel" name="useCmoney2" style="text-align:right;font-size:14px;width:50%;" onKeyUp="" onBlur="<%=toCurrency%>(this); checkUseCmoney2(this);" value="0" />
									</div> -->
									<input type="hidden" name="useCmoney" value="0" />
									<input type="hidden" name="useCmoney2" value="0" />
								<%Else%>
									<input type="hidden" name="useCmoney" value="0" />
									<input type="hidden" name="useCmoney2" value="0" />
								<%End If%>

									<div style="margin-top:10px;">
										<span class="cartPrice_tit tweight"><%=LNG_SHOP_ORDER_DIRECT_TITLE_07%><!-- 최종 결제금액 --></span>
										<span class="cartPrice_Res"><strong id="lastTXT" style="color:#f20000; font-size:24px;"><%=num2cur(TOTAL_SUM_PRICE)%></strong> <%=Chg_currencyISO%></span>
									</div>
							</div>
						</div>
					</div>
				</div>
			</div>
			<div class="cart_title_m" style="margin-top:15px; border-bottom:0px none;"><%=LNG_CS_ORDERS_POINT_POSSESSION%> <%=SHOP_POINT%></div>
			<div class="width100 porel tright" style="margin:10px; margin-left:0px;"><span class="cartPrice_Res " style="padding-right:20px;"><strong  id="lastTXT" style="color:#f20000; font-size:16px;"><%=num2cur(MILEAGE_TOTAL)%></strong> <%=SHOP_POINT%></span>
			</div>


			<%'If DK_MEMBER_TYPE = "COMPANY"  And DK_MEMBER_STYPE = 0 Then%>
			<%If DK_MEMBER_TYPE = "COMPANY" Then%>
			<!-- <div class="cart_title_m" style="margin-top:15px; border-bottom:0px none;"><%=LNG_SHOP_ORDER_DIRECT_PAY_10%></div>
			<div class="width100 porel" style="margin:10px; margin-left:0px;">
				<div class="porel" style="height:40px; margin:15px 10px 0px 10px; ">
					<div style="width:49%" class="skin-blue fleft"><input type="radio" name="DtoD" class="input_chk" value="F" /><label><%=LNG_TEXT_DIRECT_RECEIPT%></label></div>
					<div style="width:49%" class="skin-blue fright"><input type="radio" name="DtoD" class="input_chk" value="T"  /><label><%=LNG_SHOP_ORDER_DIRECT_PAY_11%></label></div>
				</div>
				<div class="porel" style="height:30px; margin:0px 10px 0px 10px; ">
					<div style="width:49%" class="skin-blue fleft"><input type="radio" name="DtoD" class="input_chk" value="C" /><label><%=LNG_TEXT_CENTER_RECEIPT%></label></div>
				</div>
			</div> -->
			<input type="hidden" name="DtoD" value="T" />
			<%Else%>
			<input type="hidden" name="DtoD" value="T" />
			<%End If%>

			<%If DK_MEMBER_TYPE = "COMPANY" And CSGoodCnt > 0 Then%>
				<div class="cart_title_m" style="margin-top:15px; border-bottom:0px none;"><%=LNG_SHOP_COMMON_BUSINESS_MEM_INFO%></div>
				<div class="width100 porel" style="margin:10px; margin-left:0px;">
					<div class="poabs" style="line-height:30px;text-indent:10px; font-size:14px;"><span class="tweight"><%=LNG_SHOP_ORDER_DIRECT_PAY_04%></span></div>
					<div class="porel" style="margin-left:100px;">
						<div style="margin-right:10px;">
						<select name="v_SellCode" style="width:100%; height:30px; ">
							<!-- <option value=""><%=LNG_SHOP_ORDER_DIRECT_PAY_05%></option> -->
							<%
								'▣구매종류 선택
								arrParams = Array(_
									Db.makeParam("@SELLCODE",adVarChar,adParamInput,10,arr_CS_SELLCODE) _
								)
								arrListB = Db.execRsList("DKP_SELLTYPE_LIST2",DB_PROC,arrParams,listLenB,DB3)
								'arrListB = Db.execRsList("DKP_SELLTYPE_LIST",DB_PROC,Nothing,listLenB,DB3)
								If IsArray(arrListB) Then
									For i = 0 To listLenB
										PRINT TABS(4)&"	<option value="""&arrListB(0,i)&""">"&arrListB(1,i)&"</option>"
									Next
								Else
									PRINT TABS(4)&"	<option value="""">"&LNG_SHOP_ORDER_DIRECT_PAY_06&"</option>"
								End If
							%>
						</select>
						</div>
					</div>
				</div>
				<!-- <div class="width100 porel" style="margin:10px; margin-left:0px;">
					<div class="poabs" style="line-height:30px;text-indent:10px; font-size:14px;"><span class="tweight"><%=LNG_SHOP_ORDER_DIRECT_PAY_07%></span></div>
					<div class="porel" style="margin-left:100px;">
						<div style="margin-right:10px;">
							<select name="SalesCenter" style="width:100%; height:30px; ">
								<option value="">::: <%=LNG_SHOP_ORDER_DIRECT_PAY_08%> :::</option>
								<%
								'	SQL2 = "SELECT * FROM [tbl_Business] WHERE [Na_Code] = ? ORDER BY [name] ASC"
								'	arrParamsC = Array(_
								'		Db.makeParam("@Na_Code",adVarChar,adParamInput,10,DK_MEMBER_NATIONCODE) _
								'	)
								'	arrListC = Db.execRsList(SQL2,DB_TEXT,arrParamsC,listLenC,DB3)
									SQL2 = "SELECT * FROM [tbl_Business] ORDER BY [name] ASC"
									arrListC = Db.execRsList(SQL2,DB_TEXT,Nothing,listLenC,DB3)
									If IsArray(arrListC) Then
										For i = 0 to listLenC
											PRINT TABS(5)& " <option value="""&arrListC(0,i)&""" "&isSelect(arrListC(0,i),businesscode)&">"&arrListC(1,i)&"</option>"
										Next
									Else
										PRINT TABS(4)&"	<option value="""">"&LNG_SHOP_ORDER_DIRECT_PAY_09&"</option>"
									End If
								%>
							</select>

						</div>
					</div>
				</div> -->
				<input type="hidden" name="SalesCenter" value="" />
			<%Else%>
			<input type="hidden" name="v_SellCode" value="" />
			<input type="hidden" name="SalesCenter" value="" />
			<%End If%>


			<div class="cart_title_m" style="margin-top:15px; border-bottom:0px none;"><%=LNG_SHOP_ORDER_DIRECT_TITLE_06%><!-- 결제 수단 --></div>
			<%
				If DK_MEMBER_TYPE = "COMPANY" Then
					'CS은행정보
					SQL_B = "SELECT A.[BankCode],A.[BankName],A.[BankPenName],A.[BankAccountNumber] FROM [tbl_BankForCompany] AS A WITH(NOLOCK)"
					SQL_B = SQL_B& " JOIN [tbl_Bank] AS B WITH(NOLOCK) ON B.[ncode] = A.[BankCode]"
					SQL_B = SQL_B& " WHERE B.[Na_Code] = ? AND A.[Using_Flag] = 'Y' "		'CS 국가별 회사은행계좌 등록확인!
					arrParams_B = Array(Db.makeParam("@strNationCode",adVarChar,adParaminput,20,UCase(DK_MEMBER_NATIONCODE)))
					arrList_B = Db.execRsList(SQL_B,DB_TEXT,arrParams_B,listLen_B,DB3)
				Else
					SQL_B = "SELECT * FROM [DK_BANK] WITH(NOLOCK) WHERE [isUSE] ='T' ORDER BY [intIDX] ASC"
					arrList_B = Db.execRsList(SQL_B,DB_TEXT,Nothing,listLen_B,Nothing)
				End If
			%>

			<div class="width100 porel" style="padding:10px 0px;">
				<div class="porel payBtnWrap" style="">
					<!-- <div class="width100 selectPayBtn">
						<%If IsArray(arrList_B) Then%>
							<div class="skin-blue"><input type="radio" name="paykind" value="inBank" class="input_radio" /><label><%=LNG_SHOP_ORDER_DIRECT_PAY_02%><!-- 무통장 입금 -- ></label></div>
						<%End If%>
					</div> -->
					<%If UCase(DK_MEMBER_NATIONCODE) = "KR" And webproIP="T" Then   '카드결제는 KR only%>
					<div class="width100 selectPayBtn">
						<div class="skin-blue"><input type="radio" name="paykind" value="Card" /><label><%=LNG_SHOP_ORDER_DIRECT_PAY_01%></label></div>
					</div>
					<!--
					<div class="width100 selectPayBtn">
						<div class="skin-blue"><input type="radio" name="paykind" value="CardAPI" /><label><%=LNG_SHOP_ORDER_DIRECT_PAY_01%>수기test</label></div>
					</div> -->
					<!-- <div class="width100 selectPayBtn">
						<div class="skin-blue"><input type="radio" name="paykind" value="vBank" /><label>가상계좌결제(TEST)</label></div>
					</div>
					<div class="width100 selectPayBtn">
						<div class="skin-blue"><input type="radio" name="paykind" value="Bank" /><label>실시간계좌이체(TEST)</label></div>
					</div> -->
					<%End If%>

					<%If DK_MEMBER_TYPE = "COMPANY" And isSHOP_POINTUSE = "T" Then%>
						<%If CDbl(MILEAGE_TOTAL) >= CDbl(TOTAL_SUM_PRICE) Then%>
							<div class="width100 selectPayBtn">
								<div class="skin-blue"><input type="radio" name="paykind" value="point" /><label><%=LNG_TEXT_PAYING_POINT2_ALONE%></label></div>
							</div>
						<%Else%>
							<div class="width100 selectPayBtn">
								<div class="skin-blue"><input type="radio" name="paykind" value="point" disabled="disabled" /><label><%=LNG_TEXT_PAYING_POINT2_ALONE%> (<%=LNG_JS_SHORT_OF_POINT%>)</label></div>
							</div>
						<%End If %>
					<%End If %>

				<!-- <%'▣S포인트 단독결제%>
					<%If DK_MEMBER_TYPE = "COMPANY" And isSHOP_POINTUSE = "T" Then%>
						<%If CDbl(MILEAGE2_TOTAL) >= CDbl(TOTAL_SUM_PRICE) Then%>
							<div class="width100 selectPayBtn">
								<div class="skin-blue"><input type="radio" name="paykind" value="point2" /><label><%=LNG_TEXT_PAYING_POINT2_ALONE%></label></div>
							</div>
						<%End If %>
					<%End If %>
				</div> -->



				<script>
					$(document).ready(function(){
						$('.skin-blue input').each(function(){
							var self = $(this),
							label = self.next(),
							label_text = label.text();

							label.remove();
							self.iCheck({
								checkboxClass: 'icheckbox_line-blue',
								radioClass: 'iradio_line-blue',
								insert: '<div class="icheck_line-icon"></div>' + label_text
							}).on('ifChecked',function(event){
								checkpayType();
							});
						});

					});
				</script>
			</div>

			<div id="CardInfo" class="width100 porel" style="margin:10px; margin-left:0px;display:none;">
			<%Select Case DKPG_PGCOMPANY%>
				<%Case "SPEEDPAY","YESPAY","DAOU","NICEPAY","ONOFFKOREA"%>
				<div class="porel">
					<div class="poabs" style="line-height:27px;text-indent:10px; font-size:14px;"><span class="tweight">카드번호</span></div>
					<div class="porel" style="margin-left:100px;margin-right:10px;">
						<input type="number" name="cardNo1" class="input_text tcenter" maxlength="4" style="width:23%;" placeholder="4자리" <%=onlyKeys%> value="" oninput="maxLengthCheck(this)" />
						<input type="number" name="cardNo2" class="input_text tcenter" maxlength="4" style="width:23%;" placeholder="4자리" <%=onlyKeys%> value="" oninput="maxLengthCheck(this)" />
						<input type="password" name="cardNo3" class="input_text tcenter" maxlength="4" style="width:23%;" placeholder="4자리" <%=onlyKeys%> value="" oninput="maxLengthCheck(this)" />
						<input type="password" name="cardNo4" class="input_text tcenter" maxlength="4" style="width:23%;" placeholder="4자리" <%=onlyKeys%> value="" oninput="maxLengthCheck(this)" />
					</div>
				</div>
				<div class="porel" style="margin-top:8px;">
					<div class="poabs" style="line-height:27px;text-indent:10px; font-size:14px;"><span class="tweight">유효기간</span></div>
					<div class="porel" style="margin-left:100px;margin-right:10px;">
						<!-- <input type="number" name="card_mm" class="input_text tcenter" maxlength="2" style="width:49%;" placeholder="유효기간(월)" <%=onlyKeys%> value="" oninput="maxLengthCheck(this)" />
						<input type="number" name="card_yy" class="input_text tcenter" maxlength="4" style="width:49%;" placeholder="유효기간(년)" <%=onlyKeys%> value="" oninput="maxLengthCheck(this)" /> -->
						<select name="card_mm" class="vmiddle input_text" style="width:110px;height:28px;">
							<option value="">유효기간(월)</option>
							<%For j = 1 To 12%>
								<%jsmm = Right("0"&j,2)%>
								<option value="<%=jsmm%>" ><%=jsmm%></option>
							<%Next%>
						</select> /
						<select name="card_yy" class="vmiddle input_text" style="width:110px;height:28px;">
							<option value="">유효기간(년)</option>
							<%For i = THIS_YEAR To EXPIRE_YEAR%>
								<option value="<%=i%>" ><%=i%></option>
							<%Next%>
						</select>
					</div>
				</div>
				<%If DKPG_PGCOMPANY = "YESPAY" Then %>
				<div class="porel" style="margin-top:8px;">
					<div class="poabs" style="line-height:27px;text-indent:10px; font-size:14px;"><span class="tweight">생년월일</span></div>
					<div class="porel" style="margin-left:100px;margin-right:10px;">
						<input type="password" name="CardBirth" class="input_text1" style="width:150px" maxlength="10" value="" placeholder="731025 형식(yymmdd)" <%=onlyKeys%> /><br />(생년월일 6자리 yymmdd, 사업자의 경우 사업자번호10자리)
					</div>
				</div>
				<div class="porel" style="margin-top:8px;">
					<div class="poabs" style="line-height:27px;text-indent:10px; font-size:14px;"><span class="tweight"><%=LNG_TEXT_PASSWORD%></span></div>
					<div class="porel" style="margin-left:100px;margin-right:10px;">
						<input type="password" name="CardPass" class="input_text1" style="width:40px" maxlength="2" value="" /> (앞2자리)
					</div>
				</div>
				<%End If%>

				<%If DKPG_PGCOMPANY = "DAOU" Then%>
					<div class="porel" style="margin-top:8px;">
						<div class="poabs" style="line-height:27px;text-indent:10px; font-size:12px;"><span class="tweight"><!-- 생년월일 -->카드구분</span></div>
						<div class="porel" style="margin-left:100px;margin-right:6px;">
							<div style="margin-top:15px;margin-bottom:10px;">
								<label><input type="radio" name="cardKind" value="P" onclick="chgCardKind(this.value)" class="input_radio" checked="checked" />일반신용</label>
								<label><input type="radio" name="cardKind" value="C" onclick="chgCardKind(this.value)" class="input_radio" />법인사업자</label>
								<label><input type="radio" name="cardKind" value="I" onclick="chgCardKind(this.value)" class="input_radio" />개인사업자</label>
							</div>
							<div id="CardKind01">
								<select name = "birthYY" class="vmiddle input_text" style="width:60px;height:28px;">
									<option value=""></option>
									<%For i = MIN_YEAR To MAX_YEAR%>
										<option value="<%=i%>" ><%=i%></option>
									<%Next%>
								</select> 년
								<select name = "birthMM" class="vmiddle input_text" style="width:45px;height:28px;">
									<option value=""></option>
									<%For j = 1 To 12%>
										<%jsmm = Right("0"&j,2)%>
										<option value="<%=jsmm%>" ><%=jsmm%></option>
									<%Next%>
								</select> 월
								<select name = "birthDD" class="vmiddle input_text" style="width:45px;height:28px;">
									<option value=""></option>
									<%For k = 1 To 31%>
										<%ksdd = Right("0"&k,2)%>
										<option value="<%=ksdd%>" ><%=ksdd%></option>
									<%Next%>
								</select> 일
								<br /><span style="color:#ee0000"> * 생년월일 입력</span>
							</div>
							<div id="CardKind02" style="display:none;">
								<input type="password" name="CorporateNumber" class="input_text" maxlength="10" style="width:200px;" placeholder="사업자등록번호 10자리" <%=onlyKeys%> value="" />
								<br /><span style="color:#ee0000"> * 사업자등록번호 10자리 입력</span>
							</div>
							<!-- <div id="CardKind03" style="display:none;">
								<input type="text" name="ssh1" class="input_text" style="width:90px;" value="" maxlength="6" <%=onlyKeys%>/> - <input type="password" name="ssh2" class="input_text" style="width:110px;" value="" maxlength="7" <%=onlyKeys%> /></li>
								<br /><span style="color:#ee0000"> * 주민등록번호 13자리 입력</span>
							</div> -->
						</div>
					</div>
					<div class="porel" style="margin-top:8px;">
						<div class="poabs" style="line-height:27px;text-indent:10px; font-size:12px;"><span class="tweight">비밀번호</span></div>
						<div class="porel" style="margin-left:100px;margin-right:10px;">
							<input type="password" name="CardPass" class="input_text tcenter" maxlength="2" style="width:60px;" placeholder="앞2자리" <%=onlyKeys%> value="" oninput="maxLengthCheck(this)" />
							<span style="color:#ee0000"> * 비밀번호 앞 2자리 입력</span>
						</div>
					</div>
				<%End If%>

				<%If DKPG_PGCOMPANY = "ONOFFKOREA" Then%>
					<div class="porel" style="margin-top:8px;">
						<div class="poabs" style="line-height:27px;text-indent:10px; font-size:12px;"><span class="tweight"><!-- 생년월일 -->카드구분</span></div>
						<div class="porel" style="margin-left:100px;margin-right:6px;">
							<div style="margin-top:15px;margin-bottom:10px;">
								<label><input type="radio" name="cardKind" value="P" onclick="chgCardKind(this.value)" class="input_radio" checked="checked" />일반신용</label>
								<label><input type="radio" name="cardKind" value="C" onclick="chgCardKind(this.value)" class="input_radio" />법인사업자</label>
								<!-- <label><input type="radio" name="cardKind" value="I" onclick="chgCardKind(this.value)" class="input_radio" />개인사업자</label> -->
							</div>
							<div id="CardKind01">
								<select name = "birthYY" class="vmiddle input_text" style="width:60px;height:28px;">
									<option value=""></option>
									<%For i = MIN_YEAR To MAX_YEAR%>
										<option value="<%=i%>" ><%=i%></option>
									<%Next%>
								</select> 년
								<select name = "birthMM" class="vmiddle input_text" style="width:45px;height:28px;">
									<option value=""></option>
									<%For j = 1 To 12%>
										<%jsmm = Right("0"&j,2)%>
										<option value="<%=jsmm%>" ><%=jsmm%></option>
									<%Next%>
								</select> 월
								<select name = "birthDD" class="vmiddle input_text" style="width:45px;height:28px;">
									<option value=""></option>
									<%For k = 1 To 31%>
										<%ksdd = Right("0"&k,2)%>
										<option value="<%=ksdd%>" ><%=ksdd%></option>
									<%Next%>
								</select> 일
								<br /><span style="color:#ee0000"> * 생년월일 입력</span>
							</div>
							<div id="CardKind02" style="display:none;">
								<input type="password" name="CorporateNumber" class="input_text" maxlength="10" style="width:200px;" placeholder="사업자등록번호 10자리" <%=onlyKeys%> value="" />
								<br /><span style="color:#ee0000"> * 사업자등록번호 10자리 입력</span>
							</div>
						</div>
					</div>
					<div class="porel" style="margin-top:8px;">
						<div class="poabs" style="line-height:27px;text-indent:10px; font-size:12px;"><span class="tweight">비밀번호</span></div>
						<div class="porel" style="margin-left:100px;margin-right:10px;">
							<input type="password" name="CardPass" class="input_text tcenter" maxlength="2" style="width:60px;" placeholder="앞2자리" <%=onlyKeys%> value="" oninput="maxLengthCheck(this)" />
							<span style="color:#ee0000"> * 비밀번호 앞 2자리 입력</span>
						</div>
					</div>
				<%End If%>

				<%If DKPG_PGCOMPANY = "NICEPAY" Then%>
				<div class="porel" style="margin-top:8px;">
					<div class="poabs" style="line-height:27px;text-indent:10px; font-size:14px;"><span class="tweight">생년월일</span></div>
					<div class="porel" style="margin-left:100px;margin-right:10px;">
						<select name = "birthYY" class="vmiddle input_text" style="width:60px;height:28px;">
							<option value=""></option>
							<%For i = MIN_YEAR To MAX_YEAR%>
								<option value="<%=i%>" ><%=i%></option>
							<%Next%>
						</select> 년
						<select name = "birthMM" class="vmiddle input_text" style="width:45px;height:28px;">
							<option value=""></option>
							<%For j = 1 To 12%>
								<%jsmm = Right("0"&j,2)%>
								<option value="<%=jsmm%>" ><%=jsmm%></option>
							<%Next%>
						</select> 월
						<select name = "birthDD" class="vmiddle input_text" style="width:45px;height:28px;">
							<option value=""></option>
							<%For k = 1 To 31%>
								<%ksdd = Right("0"&k,2)%>
								<option value="<%=ksdd%>" ><%=ksdd%></option>
							<%Next%>
						</select> 일
					</div>
				</div>
				<div class="porel" style="margin-top:8px;">
					<div class="poabs" style="line-height:27px;text-indent:10px; font-size:14px;"><span class="tweight">비밀번호</span></div>
					<div class="porel" style="margin-left:100px;margin-right:10px;">
						<input type="password" name="CardPass" class="input_text tcenter" maxlength="2" style="width:60px;" placeholder="앞2자리" <%=onlyKeys%> value="" oninput="maxLengthCheck(this)" />
						<span style="color:#ee0000"> * 비밀번호 앞 2자리 입력</span>
					</div>
				</div>
				<%End If%>


				<div class="porel" style="margin-top:8px;">
					<div class="poabs" style="line-height:30px;text-indent:10px; font-size:14px;"><span class="tweight">할부정보</span></div>
					<div class="porel" style="margin-left:100px;">
						<div style="margin-right:10px;">
							<select name="quotabase" style="width:100%; height:30px;" >
								<%If TOTAL_SUM_PRICE > 49999 Then%>
									<option value="00">일시불</option>
									<option value="02">2개월</option>
									<option value="03">3개월</option>
									<option value="04">4개월</option>
									<option value="05">5개월</option>
									<option value="06">6개월</option>
									<option value="07">7개월</option>
									<option value="08">8개월</option>
									<option value="09">9개월</option>
									<option value="10">10개월</option>
								<%Else%>
									<option value="00">일시불</option>
								<%End If%>
							</select><br />
							<span class="f11px" style="line-height:20px;">신용카드 5만원 이상 할부거래 가능</span>
						</div>
					</div>
				</div>
				<%Case Else%>

				<%End Select%>
			</div>

			<div id="BankInfo" class="width100 porel" style="margin:10px; margin-top:10px;display:none;">
				<div class="porel">
					<div class="poabs" style="line-height:30px;text-indent:10px; font-size:14px;"><span class="tweight"><%=LNG_SHOP_ORDER_DIRECT_PAY_13%><!-- 입금은행 --></span></div>
					<div class="porel" style="margin-left:100px;">
						<div style="margin-right:10px;">
						<%If DK_MEMBER_TYPE = "COMPANY" Then	'CS은행정보%>
							<ul class="bankInfo">
								<%
									If IsArray(arrList_B) Then
										For i = 0 To listLen_B
											'cs bank정보
											arr_BankCode		  =	arrList_B(0,i)
											arr_BankName		  =	arrList_B(1,i)
											arr_BankPenName		  =	arrList_B(2,i)
											arr_BankAccountNumber =	arrList_B(3,i)

											If DKCONF_SITE_ENC = "T" Then
												Set objEncrypter = Server.CreateObject ("Hyeongryeol.StringEncrypter")
													objEncrypter.Key = con_EncryptKey
													objEncrypter.InitialVector = con_EncryptKeyIV
													If DKCONF_ISCSNEW = "T" Then
														If arr_BankAccountNumber <> "" Then arr_BankAccountNumber = objEncrypter.Decrypt(arr_BankAccountNumber)
													End If
												Set objEncrypter = Nothing
											End If
								%>

									<li style="font-size:14px;margin-bottom:10px;"><label><input type="radio" name="bankidx" style="vertical-align:middle; margin:0px; padding:0px;" value="<%=arr_BankCode%>,<%=arr_BankName%>,<%=arr_BankPenName%>,<%=arr_BankAccountNumber%>" /> <%=arr_BankName%> | <strong><%=arr_BankAccountNumber%></strong><br /><%=LNG_TEXT_BANKOWNER%><!-- 예금주 --> : <%=arr_BankPenName%></label>
								<%
										Next
									End If
								%>
							</ul>
						<%Else%>
							<ul class="bankInfo">
								<%
									If IsArray(arrList_B) Then
										For i = 0 To listLen_B
								%>

									<li style="font-size:14px;margin-bottom:10px;"><label><input type="radio" name="bankidx" style="vertical-align:middle; margin:0px; padding:0px;" value="<%=arrList_B(0,i)%>" /> <%=arrList_B(1,i)%> | <strong><%=arrList_B(2,i)%></strong><br /><%=LNG_TEXT_BANKOWNER%><!-- 예금주 --> : <%=arrList_B(3,i)%></label>
								<%
										Next
									End If
								%>
							</ul>
						<%End If%>
						</div>
					</div>
				</div>
				<div class="porel">
					<style>
						.inbank th {padding : 4px 6px;}
						.inbank td {padding : 4px 6px;}
					</style>
					<table <%=tableatt%> class="width95 inbank">
						<col width="140" />
						<col width="*" />
						<tr>
							<th><%=LNG_SHOP_ORDER_DIRECT_PAY_14%></th>
							<td><input type="text" name="bankingName" class="input_text width95" /></td>
						</tr><tr>
							<th><%=LNG_CS_ORDERS_TRANSFER_DATE%></th>
							<td><input type="text" id="DDATE" name="memo1" class="input_text width95" style="background-color:#eee;" onclick="" readonly="readonly" /></td>
						</tr>
					</table>
				</div>
				<!-- <div class="porel red tcenter tweight" style="line-height:20px; font-size:15px;">3일 이내 미결제시 주문 취소될 수 있습니다.</div> -->
			</div>

			<!-- <div id="orderBtn" style="margin:10px;margin-top:30px;"><a class="buys" href="javascript:fnSubmit();"><%=LNG_SHOP_ORDER_DIRECT_PAY_22%></a></div> -->
			<div id="orderBtn" style="margin:10px;margin-top:10px;"><input type="submit" class="buys" value="<%=LNG_SHOP_ORDER_DIRECT_PAY_22%>" /></div><%'YESPAY, NICEPAY%>

			<div class="">
				<p style="margin-top:15px; margin-left:15px; color:#d75623;"><label><input type="checkbox" name="gAgreement" value="T" style="margin:0px; height:0px; vertical-align:middle; height:16px; width:16px;" /> <span style="vertical-align:middle;font-size:14px;"><%=LNG_SHOP_ORDER_DIRECT_PAY_21%></span></label></p>

				<div class="AgreementBox" style="margin:10px;padding:10px; background-color:#eee;line-height:15px;">
					<p class="f11px ag">·<%=LNG_SHOP_ORDER_DIRECT_PAY_15%> (<span style="color:#d75623;"><%=LNG_SHOP_ORDER_DIRECT_PAY_16%></span>)</p>
					<br />
					-<%=LNG_SHOP_ORDER_DIRECT_PAY_17%><br />
					-<%=LNG_SHOP_ORDER_DIRECT_PAY_18%><br />
					-<%=LNG_SHOP_ORDER_DIRECT_PAY_19%><br />
					-<%=LNG_SHOP_ORDER_DIRECT_PAY_20%>
				</div>

			</div>

		</div>




<input type="hidden" name="gopaymethod" id="gopaymethod" value="">

<input type="hidden" name="totalPrice" value="<%=TOTAL_SUM_PRICE%>" />
<input type="hidden" name="totalDelivery" value="<%=TOTAL_DeliveryFee%>" />
<input type="hidden" name="GoodsPrice" value="<%=TOTAL_Price%>" />
<input type="hidden" name="DeliveryFeeType" value="<%=txt_DeliveryFeeType%>" />
<input type="hidden" name="totalOptionPrice" value="<%=TOTAL_OptionPrice%>" />
<input type="hidden" name="totalOptionPrice2" value="<%=TOTAL_OptionPrice2%>" />
<input type="hidden" name="totalPoint" value="<%=TOTAL_Point%>" />
<input type="hidden" name="totalVotePoint" value="0" />
<input type="hidden" name="strOption" value="<%=strOption%>" />
<input type="hidden" name="OrdNo" value="<%=orderNum%>" />

<input type="hidden" name="SellerID" value="<%=DKRS_strShopID%>" />
<input type="hidden" name="CSGoodCnt" value="<%=CSGoodCnt%>" />
<input type="hidden" name="isSpecialSell" value="F" /> <!-- 우대매출관련 -->


<input type="hidden" name="ori_price" value="<%=TOTAL_SUM_PRICE%>" />
<input type="hidden" name="ori_delivery" value="<%=TOTAL_DeliveryFee%>" readonly/>

<input type="hidden" name="input_mode" value="" />

<input type="hidden" name="MEMBER_STYPE" value="<%=DK_MEMBER_STYPE%>" readonly="readonly"/>
<input type="hidden" name="MEMBER_TYPE" value="<%=DK_MEMBER_TYPE%>" readonly="reorderFrmadonly"/>


<!-- <input type="hidden" name="goodsName" size="50" value="<%=arrList_GoodsName%>" /> -->


	<%If DK_MEMBER_TYPE = "COMPANY" And CSGoodCnt > 0 Then%>
		<input type="hidden" name="isComSell" value="T" />
	<%Else%>
		<input type="hidden" name="isComSell" value="F" />
	<%End If%>

<input type="hidden" name="isDirect" value="<%=arrList_isDirect%>" readonly="readonly"/><%'isDirect or Cart 체크%>
<input type="hidden" name="GoodIDX" value="<%=arrList_GoodIDX%>" readonly="readonly"/><%'isDirect or Cart 체크%>

<input type="hidden" name="OIDX" value="<%=orderTempIDX%>" readonly="readonly" /><%'◆ #4. SHOP 임시주문테이블 idx%>


<%Select Case UCase(DK_MEMBER_NATIONCODE)%>
	<%Case "KR"%>

		<%Select Case DKPG_PGCOMPANY%>
			<%Case "NICEPAY"%>
				<!-- <input type="hidden" name="paymethod" value="CARD" readonly="readonly"/>
				<input type="hidden" name="goodsname" value="<%=arrList_GoodsName%>" readonly="readonly" /> -->
				<input type="hidden" name="regnumber" value="" readonly="readonly"/>
				<input type="hidden" name="cardpw" value="" readonly="readonly"/>
				<input type="hidden" name="cardquota" value="00" readonly="readonly"/>
				<input type="hidden" name="malluserid" value="<%=DK_MEMBER_ID%>" readonly="readonly" />

							<%'▣▣▣ NICEPAY 설정 / 추가필드 S ▣▣▣%>
							<!--''''include virtual="/PG/NICEPAY/PC_TX_ASP/lib/SHA256.asp" -->
							<%
								''''''''''''''''''''''''''''''''''''''''''''''''''''''''
								' <결제요청 파라미터>
								' 결제시 Form 에 보내는 결제요청 파라미터입니다.
								' 샘플페이지에서는 기본(필수) 파라미터만 예시되어 있으며,
								' 추가 가능한 옵션 파라미터는 연동메뉴얼을 참고하세요.
								''''''''''''''''''''''''''''''''''''''''''''''''''''''''
								merchantKey      = NICE_merchantKey							 '상점키
								merchantID       = NICE_merchantID                           '상점아이디
								'encodeParameters = "CardNo,CardExpire,CardPwd"              '암호화대상항목 (변경불가)
								'returnURL        = "http://localhost/MOBILE_TX_ASP/payResult_utf.asp"			'결과페이지 URL
								'returnURL        = "http://ssangfamily.com/PG/NICEPAY/cardResult_m.asp"		'결과페이지 URL
								'returnURL        = "http://"&houUrl&"/PG/NICEPAY/cardResult_m.asp"				'결과페이지 URL  ~2019-02-17
								returnURL        = "http://"&houUrl&"/PG/NICEPAY/payResult.asp"					'결과페이지 URL  2019-02-17~	(PC/MOB통합)
								charSet          = "utf-8"

								''''''''''''''''''''''''''''''''''''''''''''''''''''''''
								' <가상계좌 입금 만료일>
								''''''''''''''''''''''''''''''''''''''''''''''''''''''''
								tomorrow = (date()+1)
								tomorrow = Replace(tomorrow, "-", "")

								''''''''''''''''''''''''''''''''''''''''''''''''''''''''
								' <해쉬암호화> (수정하지 마세요)
								' SHA256 해쉬암호화는 거래 위변조를 막기위한 방법입니다.
								' [WEBPRO] : 암호화 충돌로 WEBPRO MD5.asp 변경(동일 결과값)
								''''''''''''''''''''''''''''''''''''''''''''''''''''''''
								'''Call initCodecs																'[NICEPAY] 해쉬암호화 충돌

								ediDate = getNow()
								'''hashString = SHA256_Encrypt(ediDate & merchantID & price & merchantKey)		'[NICEPAY] 해쉬암호화 충돌

								'[Webpro] MD5 SHA256
								Set XTEncrypt = new XTclsEncrypt
									hashString  =  XTEncrypt.SHA256(ediDate & merchantID & TOTAL_SUM_PRICE & merchantKey)
								Set XTEncrypt = nothing
								'[Webpro] MD5 SHA256

								Function getNow()
								Dim aDate(2), aTime(2)
									aDate(0) = Year(Now)
									aDate(1) = Right("0" & Month(Now), 2)
									aDate(2) = Right("0" & Day(Now), 2)
									aTime(0) = Right("0" & Hour(Now), 2)
									aTime(1) = Right("0" & Minute(Now), 2)
									aTime(2) = Right("0" & Second(Now), 2)
									getNow   = aDate(0)&aDate(1)&aDate(2)&aTime(0)&aTime(1)&aTime(2)
								End Function
							%>
							<input type="hidden" name="PayMethod" id="PayMethod" value="" readonly="readonly"/>						<!-- 결제 수단CARD, BANK, CELLPHONE, VBANK-->
							<input type="hidden" name="GoodsName" value="<%=arrList_GoodsName%>" readonly="readonly" />	<!-- 결제 상품명 -->
							<input type="hidden" name="GoodsCnt" value="<%=TOTAL_orderEaCnt%>" readonly="readonly" />	<!-- 결제 상품개수 -->
							<input type="hidden" id="Amt" name="Amt" value="<%=TOTAL_SUM_PRICE%>" readonly="readonly" />			<!-- 결제 상품금액 -->
							<input type="hidden" name="BuyerName" value="<%=DK_MEMBER_NAME%>" readonly="readonly" />	<!-- 구매자명 -->
							<input type="hidden" name="BuyerTel" value="" readonly="readonly" />						<!-- 구매자 연락처 -->
							<input type="hidden" name="Moid" value="<%=orderNum%>" readonly="readonly" />				<!-- 상품 주문번호 -->
							<input type="hidden" name="MID" value="<%=merchantID%>" readonly="readonly" />				<!-- 상점 아이디 -->

							<!-- IP -->
							<input type="hidden" name="UserIP" value="<%=Request.ServerVariables("REMOTE_ADDR")%>" readonly="readonly">
							<input type="hidden" name="MallIP" value="<%=Request.ServerVariables("LOCAL_ADDR")%>" readonly="readonly">

							<!-- 옵션 -->
							<input type="hidden" name="VbankExpDate" value="<%=tomorrow%>" readonly="readonly"/>				<!-- 가상계좌입금만료일 -->
							<input type="hidden" name="BuyerEmail" value="" readonly="readonly" />					            <!-- 구매자 이메일 -->
							<input type="hidden" name="GoodsCl" value="0" readonly="readonly" />								<!-- 상품구분(실물(1),컨텐츠(0)) -->
							<input type="hidden" name="TransType" value="0" readonly="readonly" />								<!-- 일반(0)/에스크로(1) -->

							<!-- 모바일 추가 -->
								  <input type="hidden" name="MallReserved"  value=""readonly="readonly" />						<!-- 상점 여분 필드 -->
								  <input type="hidden" name="ReturnURL" value="<%=returnURL%>" readonly="readonly" />			<!-- 결과페이지 URL -->
								  <input type="hidden" name="CharSet" value="<%=charSet%>" readonly="readonly" />				<!-- 결과페이지 인코딩 -->

							<!-- 변경 불가능 -->
							<!-- <input type="hidden" name="EncodeParameters" value="<%=encodeParameters%>" readonly="readonly" /> -->  <!-- 암호화대상항목 -->
							<input type="hidden" id="EdiDate" name="EdiDate" value="<%=ediDate%>" readonly="readonly" />				<!-- 전문 생성일시 -->
							<input type="hidden" id="EncryptData" name="EncryptData" value="<%=hashString%>" readonly="readonly" />		<!-- 해쉬값 -->
							<input type="hidden" name="TrKey" value="" readonly="readonly" />									<!-- 필드만 필요 -->
							<!-- <input type="hidden" name="SocketYN" value="Y" readonly="readonly" /> -->						<!-- 소켓통신 유무-->
							<input type="hidden" name="MerchantKey" value="<%=merchantKey%>" readonly="readonly" />			<!-- 상점 키 -->
							<%'▣▣▣ NICEPAY 설정 / 추가필드 E ▣▣▣%>


			<%Case "DAOU"%>
				<input type="hidden" name="Daou_MEMBER_ID" value="<%=DK_MEMBER_ID%>" readonly="readonly"/>
				<input type="hidden" name="Daou_MEMBER_ID1" value="<%=DK_MEMBER_ID1%>" readonly="readonly"/>
				<input type="hidden" name="Daou_MEMBER_ID2" value="<%=DK_MEMBER_ID2%>" readonly="readonly"/>
				<input type="hidden" name="Daou_MEMBER_WEBID" value="<%=DK_MEMBER_WEBID%>" readonly="readonly"/>
				<input type="hidden" name="Daou_MEMBER_NAME" value="<%=DK_MEMBER_NAME%>" readonly="readonly"/>
				<input type="hidden" name="Daou_MEMBER_LEVEL" value="<%=DK_MEMBER_LEVEL%>" readonly="readonly"/>
				<input type="hidden" name="Daou_MEMBER_TYPE" value="<%=DK_MEMBER_TYPE%>" readonly="readonly"/>
				<input type="hidden" name="Daou_MEMBER_STYPE" value="<%=DK_MEMBER_STYPE%>" readonly="readonly"/>
				<input type="hidden" name="Daou_MEMBER_NATIONCODE" value="<%=DK_MEMBER_NATIONCODE%>" readonly="readonly"/>

				<%'If DK_MEMBER_TYPE ="COMPANY" And DKPG_KEYIN = "T" And DK_MEMBER_STYPE = "0" Then%>
				<%If DK_MEMBER_TYPE ="COMPANY" And DKPG_KEYIN = "T" Then	'▣▣스피나 판매원/소비자 KEYIN(2017-05-16)▣▣%>
					<input type="hidden" name="CPID" size="50" maxlength="50" value="<%=DKPG_PGIDS_MOBILE_KEYIN%>" style="IME-MODE:disabled" />
					<input type="hidden" name="BILLTYPE" id="BILLTYPE" size="10" maxlength="2"  value="15" style="IME-MODE:disabled" /><!-- -->
					<input type="hidden" name="keyin" size="5" value="" style="IME-MODE:disabled" />
				<%Else%>
					<input type="hidden" name="CPID" size="50" maxlength="50" value="<%=DKPG_PGIDS_MOBILE%>" style="IME-MODE:disabled" />
					<input type="hidden" name="BILLTYPE" size="10" maxlength="2"  value="1" style="IME-MODE:disabled" /><!-- -->
				<%End If%>

				<input type="hidden" name="PRODUCTTYPE" id="PRODUCTTYPE" size="10" maxlength="2" value="2" style="IME-MODE:disabled" /><!-- -->

				<input type="hidden" name="ORDERNO" size="50" maxlength="50"value="<%=orderNum%>" style="IME-MODE:disabled" />
				<input type="hidden" name="AMOUNT" size="10" maxlength="10" value="<%=TOTAL_SUM_PRICE%>" style="IME-MODE:disabled" onkeypress="fnNumCheck();" />
				<input type="hidden" name="quotaopt" value="12" />

				<input type="hidden" name="TAXFREECD" value="00" />
				<input type="hidden" name="EMAIL" size="100" maxlength="100" value="<%=strEmail%>" />
				<input type="hidden" name="USERID" size="30" maxlength="30" value="<%=DK_MEMBER_ID%>" />
				<input type="hidden" name="USERNAME" size="50" maxlength="50" value="<%=DK_MEMBER_NAME%>" />
				<input type="hidden" name="PRODUCTCODE" size="10" value="<%=GoodsIDX%>" />
				<input type="hidden" name="PRODUCTNAME" size="50" value="<%=arrList_GoodsName%>" />
				<input type="hidden" name="TELNO1" size="50" value="" />
				<input type="hidden" name="TELNO2" size="50" value="" />
				<input type="hidden" name="RESERVEDINDEX1" size="20" value="" />
				<input type="hidden" name="RESERVEDINDEX2" size="20" value="" />
				<input type="hidden" name="RESERVEDSTRING" size="100" value="" />
				<input type="hidden" name="RETURNURL" value="" />
				<input type="hidden" name="HOMEURL" value="http://<%=houUrl%>/PG/DAOU/order_finish.asp?orderIDX=<%=orderNum%>&m=m" />
				<input type="hidden" name="FAILURL" value="http://<%=houUrl%>/PG/DAOU/order_failed.asp">
				<input type="hidden" name="DIRECTRESULTFLAG" value="Y" />

				<input type="hidden" name="kcp_noint" value="" />
				<input type="hidden" name="kcp_noint_quota" value="" />
				<input type="hidden" name="fix_inst" value="" />
				<input type="hidden" name="not_used_card" value="" />
				<input type="hidden" name="save_ocb" value="" />
				<input type="hidden" name="used_card_YN" value="" />
				<input type="hidden" name="used_card" value="" />
				<input type="hidden" name="eng_flag" value="" />
				<input type="hidden" name="kcp_site_logo" value="" />
				<input type="hidden" name="kcp_site_img" value="" />


				<!--
					* ORDERNO : 주문번호 [필수항목] // 주문번호를 입력하시면 됩니다.
					* PRODUCTTYPE : 상품구분 [필수항목] // 상품구분을 입력하시면 됩니다.
					* BILLTYPE : 과금유형(1:일반) [필수항목] // 과금유형을 입력하시면 됩니다.
					* TAXFREECD : 비과세결제유무[선택항목] // 결제하려는 금액의 과세유무 // 00:과세, 01:비과세
					* AMOUNT : 결제금액[필수항목] // 결제금액을 입력하시면 됩니다.
					* EMAIL : 고객 E-MAIL(결제결과 통보 Default) [선택항목] // 고객 E-MAIL를 입력하시면 됩니다.
					* USERID : 고객ID [선택항목] // 고객아이디를 입력하시면 됩니다.
					* USERNAME : 고객명 [선택항목] // 고객명를 입력하시면 됩니다.
					* PRODUCTCODE : 상품코드 [선택항목]	// 상품코드를 입력하시면 됩니다.
					* PRODUCTNAME : 상품명[선택항목] // 상품명을 입력하시면 됩니다.
					* TELNO1 : 고객전화번호[선택항목] // 고객전화번호를 입력하시면 됩니다.
					* TELNO2 : 고객휴대폰번호[선택항목] // 고객휴대폰번호를 입력하시면 됩니다.
					* RESERVEDINDEX1 : 예약항목1(내부에서 INDEX로 관리)[선택항목] // 예약항목1을 입력하시면 됩니다.
					* RESERVEDINDEX2 : 예약항목2(내부에서 INDEX로 관리)[선택항목] // 예약항목2를 입력하시면 됩니다.
					* RESERVEDSTRING : 예약항목(내부에서 INDEX로 관리)[선택항목] // 예약항목을 입력하시면 됩니다.
					* RETURNURL : 결제완료 url[선택항목] // 결제 완료 후, 이동할 url(팝업으로 결제창을 오픈한 메인 화면)
					* DIRECTRESULTFLAG : 결제완료 url[필수항목] // 결제 완료 후, 이동할 url(팝업)
					나머지 상점 옵션값 <br>
					kcp_noint :		   <input type=text name=kcp_noint value=""><br>
					kcp_noint_quota  : <input type=text name=kcp_noint_quota   value=""><br>
					QUOTAOPT         : <input type=text name=quotaopt         value=""><br>
					fix_inst         : <input type=text name=fix_inst         value=""><br>
					not_used_card    : <input type=text name=not_used_card    value=""><br>
					save_ocb         : <input type=text name=save_ocb         value=""><br>
					used_card_YN     : <input type=text name=used_card_YN   value=""><br>
					used_card        : <input type=text name=used_card         value=""><br>
					eng_flag         : <input type=text name=eng_flag         value=""><br>
					kcp_site_logo	 : <input type=text name=kcp_site_logo         value="">(카드결제창 좌측상단 노출될 이미지(미입력시 다우페이 이미지  출력))<br>
					kcp_site_img	 : <input type=text name=kcp_site_img         value="">(카드결제창 좌측하당 노출될 이미지(미입력시 다우페이 이미지 출력))<br>
				-->




			<%Case "SPEEDPAY","YESPAY"%>
				<input type="hidden" name="GoodsName" value="<%=arrList_GoodsName%>" readonly="readonly" />
				<input type="hidden" name="MEMBER_STYPE" value="<%=DK_MEMBER_STYPE%>" readonly="readonly"/>
				<input type="hidden" name="payAmount" size="10" maxlength="10" value="<%=TOTAL_SUM_PRICE%>" readonly="readonly"/>

			<%Case "ONOFFKOREA"%>
				<input type="hidden" name="GoodsName" value="<%=arrList_GoodsName%>" />

		<%End Select%>

	<%Case Else%>
		<input type="hidden" name="PayMethod" id="PayMethod" value="" readonly="readonly"/>

<%End Select%>










	</form>
</div>

<%
	'◆ #3. SHOP 주문 임시테이블 정보 가격정보 UPDATE
		arrParams = Array(_
			Db.makeParam("@OrderNum",adVarChar,adParamInput,20,orderNum),_
			Db.makeParam("@totalPrice",adInteger,adParamInput,4,TOTAL_SUM_PRICE), _
			Db.makeParam("@intIDX",adInteger,adParamInput,0,orderTempIDX), _
			Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
		)
		Call Db.exec("HJP_ORDER_TOTAL_PRICE_SHOP_UPDATE",DB_PROC,arrParams,Nothing)
		OUTPUT_VALUE3 = arrParams(Ubound(arrParams))(4)
		Select Case OUTPUT_VALUE3
			Case "FINISH"
			Case "ERROR" : Call ALERTS(LNG_CS_ORDERS_ALERT06,"BACK","")
			Case "NOTORDER" : Call ALERTS(LNG_CS_ORDERS_ALERT07,"BACK","")
		End Select
%>
<!--#include virtual = "/m/_include/copyright.asp"-->

























