<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/PG/NICEPAY/NICEPAY_FUNCTION.ASP"-->
<!--#include virtual="/_lib/MD5.asp" -->
<%
	'On Error Resume Next

	PAGE_SETTING = "SHOP"
	ISLEFT = "F"
	ISSUBTOP = "T"
	ISSUBVISUAL = "T"
	IS_LANGUAGESELECT = "F"			'언어선택 불가

	IS_SHOW_FIXED_MENU = "F"		'상단메뉴고정X


	Call ONLY_MEMBER(DK_MEMBER_LEVEL)

'If webproIP <> "T" Then  Call ALERTS("쇼핑몰 구매 테스트중입니다.","back","")

	'//////////////////////////////////////////////////////////////////////////////////
	Function makeOrderNo()
		Dim nowTime : nowTime = Now
		Dim firstDay, startTime
		Dim no1_head, no2_year, no3_dayNum, no4_secondNum, no5_rndNo

		firstDay = Year(nowTime) &"-01-01"
		startTime = FormatDateTime(nowTime, 2) &" 00:00:00"

		Randomize
		rndNo = Int(Rnd * 99+Second(nowTime))

		no1_head = "DK"
		no2_year = Right(Year(nowTime), 2)
		no3_dayNum = Right("00"& (DateDiff("d", firstDay, nowTime)+1), 3)
		no4_secondNum = Right("0000"& DateDiff("s", startTime, nowTime), 5)
		no5_rndNo = Right("0"& rndNo, 2)

		makeOrderNo = no1_head & no2_year & no3_dayNum & no4_secondNum & no5_rndNo
	End Function
	' ////////////////////////////////////////////////////////////////////////////////

	Call noCache

	inUidx = Trim(pRequestTF("cuidx",True))

	If inUidx = "" Then Call ALERTS(LNG_SHOP_ORDER_DIRECT_01_01,"GO","/shop/cart.asp")

	arrUidx = Split(inUidx,",")


'	print inUidx



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
					Db.makeParam("@mbid2",adInteger,adParamInput,4,DK_MEMBER_ID2) _
				)
				Set DKRS = Db.execRs("DKP_MEMBER_INFO",DB_PROC,arrParams,DB3)
				If Not DKRS.BOF And Not DKRS.EOF Then
					strName		= DKRS("M_Name")
					strTel		= DKRS("hometel")
					strMobile	= DKRS("hptel")
					strEmail	= DKRS("Email")
					strzip		= DKRS("Addcode1")
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
				On Error Resume Next
					If strADDR1		<> "" Then strADDR1			= objEncrypter.Decrypt(strADDR1)
					If straddr2		<> "" Then straddr2			= objEncrypter.Decrypt(straddr2)
					If strTel		<> "" Then strTel			= objEncrypter.Decrypt(strTel)
					If strMobile	<> "" Then strMobile		= objEncrypter.Decrypt(strMobile)

					If DKCONF_ISCSNEW = "T" Then	'▣CS신버전 암/복호화 추가
						If strEmail		<> "" Then strEmail		= objEncrypter.Decrypt(strEmail)
					End If
				On Error GoTo 0
			Set objEncrypter = Nothing
		End If

		If strTel = "" Or IsNull(strTel) Then strTel = ""
		If strMobile = "" Or IsNull(strMobile) Then strMobile = ""
		arrTel = Split(strTel,"-")
		arrMobile = Split(strMobile,"-")
		If UBound(arrTel) <> 2 Then arrTel = Array("","","")
		If UBound(arrMobile) <> 2 Then arrMobile = Array("","","")


	orderNum = makeOrderNo()
'	ORderCnt = MemberGoodsOrderCnt(DK_MEMBER_ID)


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
<!--#include virtual="/_include/document.asp" -->

<meta http-equiv="Cache-Control" content="no-cache"/>
<meta http-equiv="Expires" content="0"/>
<meta http-equiv="Pragma" content="no-cache"/>
<meta http-equiv="X-UA-Compatible" content="requiresActiveX=true" />
<!-- <script type="text/javascript" src="/PG/YESPAY/pay.js"></script> -->
<%
Select Case UCase(DK_MEMBER_NATIONCODE)
	Case "KR"
		Select Case DKPG_PGCOMPANY
			Case "DAOU"
				BODYLOAD = "onLoad=""init();"""
				FORMDATA = "<form name=""frmConfirm"" id=""frmConfirm"" onsubmit=""return fnSubmit();"" method=""post"">"
				'If DK_MEMBER_TYPE = "COMPANY" And DK_MEMBER_STYPE = 0 And DKPG_KEYIN = "T" Then
				If DK_MEMBER_TYPE = "COMPANY" And DKPG_KEYIN = "T" Then
					'PRINT DKPG_PGJAVA_BASE1
					'PRINT DKPG_PGJAVA_BASE2
					'Response.Write "<script type=""text/javascript"" src=""/PG/DAOU/"&DKPG_PGJAVA_BASE2&"""></script>"
					Response.Write "<script type=""text/javascript"" src=""/PG/DAOU/"&DKPG_PGJAVA_BASE1&"?v=1""></script>"
				Else
					Response.Write "<script type=""text/javascript"" src=""/PG/DAOU/"&DKPG_PGJAVA_BASE1&"?v=1""></script>"
				End If
		%>
		<%
			Case "SPEEDPAY"
				BODYLOAD = ""
				FORMDATA = "<form name=""orderFrm"" id=""orderFrm"" action=""/PG/SPEEDPAY/order_card_result.asp"" onsubmit=""return orderSubmit(this);"" method=""post"">"
		%>
		<script type="text/javascript" src="/PG/SPEEDPAY/pay_order.js"></script>
		<%
			Case "YESPAY"
				BODYLOAD = ""
				FORMDATA = "<form name=""orderFrm"" id=""orderFrm"" action=""/PG/YESPAY/CardResult.asp"" onsubmit=""return orderSubmit(this);"" method=""post"">"
		%>
		<script type="text/javascript" src="/PG/YESPAY/pay.js"></script>
		<%
			Case "ONOFFKOREA"
				BODYLOAD = ""
				FORMDATA = "<form name=""orderFrm"" id=""orderFrm"" onsubmit=""return orderSubmit(this);"" method=""post"">"
		%>
		<script type="text/javascript" src="/PG/ONOFFKOREA/pay.js"></script>
		<%
			Case "NICEPAY"
				BODYLOAD = ""
				FORMDATA = "<form name=""payForm"" id=""payForm"" method=""post"" action=""/PG/NICEPAY/payResult.asp"" onsubmit=""return orderSubmit(this);"">"
		%>
		<%'▣▣▣ NICEPAY JS설정  S ▣▣▣%>
		<script src="https://web.nicepay.co.kr/flex/js/nicepay_tr_utf.js" type="text/javascript"></script>
		<script type="text/javascript" src="/PG/NICEPAY/pay.js?v1"></script>
		<script type="text/javascript">
		/*
			//결제창 최초 요청시 실행됩니다.
			function nicepayStart(){
				goPay(document.payForm);
			}

			//결제 최종 요청시 실행됩니다. <<'nicepaySubmit()' 이름 수정 불가능>>
			function nicepaySubmit(){
				document.payForm.submit();
			}

			//결제창 종료 함수 <<'nicepayClose()' 이름 수정 불가능>>
			function nicepayClose(){
				alert("결제가 취소 되었습니다!");
				doubleSubmit = false;
			}
		*/
		</script>
		<%'▣▣▣ NICEPAY JS설정  E ▣▣▣%>
		<%
		End Select


	Case Else
		BODYLOAD = ""
		FORMDATA = "<form name=""payForm"" id=""payForm"" method=""post"" action=""/PG/inbank_Result.asp"" onsubmit=""return orderSubmit(this);"">"

%>
		<!--#include virtual = "/PG/pay_union.asp"-->
<%
End Select
%>
<!--#include virtual = "/_include/calendar.asp"-->
<script src="https://spi.maps.daum.net/imap/map_js_init/postcode.v2.js"></script>
<script src="/jscript/daumPostCode.js"></script>
<script type="text/javascript" src="/jscript/calendar.js"></script>
<%
	If webproIP<>"T" Then
		Call No_Refresh()
	End If
%>
</head>
<body <%=BODYLOAD%>  <%=mouseLock()%>>
<!--#include virtual="/_include/header.asp" -->
<%
	If webproIP="T" Then
		PRINT "<div style=""position:absolute; top:150px; left:0;"">"
		Call ResRW(DKPG_PGMOD,"PG_MODE")
		Call ResRW(DKPG_PGCOMPANY,"웹프로_IP_VIEW - 연결PG사")
		If UCase(DKPG_PGCOMPANY) = "DAOU" Then
			If Right(DKFD_PGMOD,4) = "TEST" Then
				Call ResRW(DKPG_PGIDS_SHOP_KEYIN,"DKPG_PGIDS_SHOP_KEYIN")
				Call ResRW(DKPG_PGJAVA_BASE1,"자바연결1")
			Else
				Call ResRW(DKPG_PGIDS_SHOP_KEYIN,"DKPG_PGIDS_SHOP_KEYIN")
				Call ResRW(DKPG_PGJAVA_BASE1,"자바연결1")
			End If
		End If
		If UCase(DKPG_PGCOMPANY) = "YESPAY" Then Call ResRW("/PG/YESPAY/pay.js","자바연결")
		If UCase(DKPG_PGCOMPANY) = "NICEPAY" Then Call ResRW("/PG/NICEPAY/pay.js","자바연결")
		PRINT "</div>"
	End If
%>
<%=FORMDATA%>
<div id="loadingPro" style="position:fixed; z-index:99999; width:100%; height:100%; top:0px; left:0px; background:url(/images_kr/loading_bg70.png) 0 0 repeat; display:none;">
	<div style="position:relative; top:40%; text-align:center;">
		<img src="<%=IMG%>/159.gif" width="80" alt="" />
	</div>
</div>
<input type="hidden" name="cuidx" value="<%=inUidx%>" />
<input type="hidden" name="pageType" value="" />
<!-- <div id="subTitle" class="width100">
	<div class="fleft maps_title"><%=LNG_SHOP_ORDER_DIRECT_TITLE_01%></div>
	<div class="fright maps_navi">HOME > <%=LNG_SHOP_ORDER_DIRECT_TITLE_02%> > <span class="tweight last_navi"><%=LNG_SHOP_ORDER_DIRECT_TITLE_01%></span></div>
</div> -->
<div id="subTitle" class="layout_inner">
	<div class="sub_title">
		<div class="fright maps_navi">
			<span class="first_navi"><img src="<%=IMG_NAVI%>/subtit_home.png" alt="home" />HOME</span><span class="arrow"><img src="<%=IMG_NAVI%>/subtit_arrow.png" alt="" /></span>
			<span class="center_navi">SHOP</span><span class="arrow"><img src="<%=IMG_NAVI%>/subtit_arrow.png" alt="" /></span>
			<span class="last_navi"><%=LNG_SHOP_ORDER_DIRECT_TITLE_01%></span>
		</div>
		<div class="maps_title"><%=LNG_SHOP_ORDER_DIRECT_TITLE_01%></div>
	</div>
</div>
<div id="cart">
	<div class="cleft width100 cart_list">
		<div class="order_title"><%=LNG_SHOP_ORDER_DIRECT_TITLE_03%></div>
		<%
			TOTAL_DeliveryFee = 0 ' 최종 배송금액
			TOTAL_OptionPrice =  0
			TOTAL_OptionPrice2 =  0
			TOTAL_Price = 0 ' 최종 결제금액
			TOTAL_Point =  0
			TOTAL_GOODS_PRICE = 0
			TOTAL_USEPOINT_PRICE = 0
			TOTAL_PV = 0
		%>
		<table <%=tableatt%> class="width100 goodsInfo">
			<colgroup>
				<col width="100" />
				<col width="*" />
				<col width="160" />
				<col width="60" />

				<col width="160" />
				<col width="100" />

				<col width="200" />
			</colgroup>
			<thead>
				<tr>
					<th colspan="2"><%=LNG_SHOP_ORDER_DIRECT_TABLE_01%></th>
					<th><%=LNG_SHOP_ORDER_DIRECT_TABLE_02%></th>
					<th><%=LNG_SHOP_ORDER_DIRECT_TABLE_03%></th>
					<th><%=LNG_SHOP_ORDER_DIRECT_TABLE_04%></th>
					<th><%=LNG_SHOP_ORDER_DIRECT_TABLE_24%></th>
					<th><%=LNG_SHOP_ORDER_DIRECT_TABLE_05%></th>
				</tr>
			</thead>
			<%
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

						Select Case DK_MEMBER_LEVEL
							Case 0,1 '비회원, 일반회원
								arrList_GoodsPrice = arrList_intPriceNot
								arrList_GoodsPoint = arrList_intPointNot
								arrList_intMinimum = arrList_intMinNot
							Case 2 '인증회원
								arrList_GoodsPrice = arrList_intPriceAuth
								arrList_GoodsPoint = arrList_intPointAuth
								arrList_intMinimum = arrList_intMinAuth
							Case 3 '딜러회원
								arrList_GoodsPrice = arrList_intPriceDeal
								arrList_GoodsPoint = arrList_intPointDeal
								arrList_intMinimum = arrList_intMinDeal
							Case 4,5 'VIP 회원
								arrList_GoodsPrice = arrList_intPriceVIP
								arrList_GoodsPoint = arrList_intPointVIP
								arrList_intMinimum = arrList_intMinVIP
							Case 9,10,11
								arrList_GoodsPrice = arrList_intPriceVIP
								arrList_GoodsPoint = arrList_intPointVIP
								arrList_intMinimum = arrList_intMinVIP
						End Select

						'상품갯수 체크
						If arrList_orderEa < 1 Then Call ALERTS(LNG_CS_CART_JS06,"back","")

						'▣상품최소구매갯수 체크!!
						If arrList_orderEa < arrList_intMinimum Then Call ALERTS(LNG_SHOP_DETAILVIEW_07,"back","")

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

						If arrList_flagBest	= "T" Then printGoodsIcon = printGoodsIcon & "<span class=""icons"">"&viewImg(IMG_ICON&"/i_bestT.gif",31,11,"")&"</span>"
						If arrList_flagNew	= "T" Then printGoodsIcon = printGoodsIcon & "<span class=""icons"">"&viewImg(IMG_ICON&"/i_newT.gif",31,11,"")&"</span>"
						If arrList_FlagVote	= "T" Then printGoodsIcon = printGoodsIcon & "<span class=""icons"">"&viewImg(IMG_ICON&"/i_voteT.gif",31,11,"")&"</span>"
						If (DK_MEMBER_TYPE = "COMPANY" And DK_MEMBER_STYPE = "0") Or DK_MEMBER_TYPE ="ADMIN" Then
							If arrList_isCSGoods = "T" Then printGoodsIcon = printGoodsIcon & "<span class=""icons"">"&viewImg(IMG_ICON&"/i_csgoodsT.gif",50,11,"")&"</span>"
						End If

						'##################################################################
						' 루프내 가격 초기화
						'################################################################## START
							self_GoodsPrice = 0
							self_GoodsPoint = 0
							self_GoodsOptionPrice = 0
							self_GoodsOptionPrice2 = 0
							self_TOTAL_PRICE = 0 'TOTAL_POINT_PRICE = self_GoodsPrice + self_GoodsOptionPrice
							self_PV = 0
							self_GV = 0

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

						' 상품별 금액/적립금 확인
							self_GoodsPrice = Int(arrList_orderEa) * Int(arrList_GoodsPrice)
							selfPoint = Int(arrList_orderEa) * Int(arrList_GoodsPoint)
							self_GoodsOptionPrice = Int(arrList_orderEa) * Int(sum_optionPrice)
							self_GoodsOptionPrice2 = Int(arrList_orderEa) * Int(sum_optionPrice2)
							TOTAL_POINT_PRICE = self_GoodsPrice + self_GoodsOptionPrice
							self_PV = Int(arrList_orderEa) * Int(arr_CS_price4)
							self_GV = Int(arrList_orderEa) * Int(arr_CS_price5)

						'배송비 확인
							If arrList_GoodsDeliveryType = "SINGLE" Then
								DeliveryFee = Int(arrList_GoodsDeliveryFee)
								self_DeliveryFee = Int(arrList_orderEa) * Int(arrList_GoodsDeliveryFee)
								'spans(num2curINT(DeliveryFee),"#FF6600","","")
								txt_DeliveryFee = "<span class=""tweight"">"&LNG_SHOP_ORDER_DIRECT_TABLE_08& " "&spans(num2curINT(self_DeliveryFee),"#FF6600","","")&" "&Chg_CurrencyISO&"</span><br /><span class=""f11px lheight130"">"&LNG_SHOP_ORDER_DIRECT_TABLE_08&num2curINT(DeliveryFee)&" "&Chg_CurrencyISO&"</span>"

								'TOTAL_DeliveryFee = TOTAL_DeliveryFee + selfDeliveryFee
								arrList_DELICNT = 1
								txt_DeliveryFeeType = LNG_SHOP_ORDER_DIRECT_TABLE_08

							ElseIf arrList_GoodsDeliveryType = "BASIC" Then
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
									Else
										self_DeliveryFee = DKRS2_intDeliveryFee
										txt_DeliveryFee = "<span class=""tweight"">"&LNG_SHOP_ORDER_DIRECT_TABLE_07&" "&num2curINT(self_DeliveryFee)&" "&Chg_currencyISO&"</span><br /><span class=""f11px lheight130"">"&LNG_SHOP_ORDER_DIRECT_TABLE_11&" <br />"&LNG_SHOP_DETAILVIEW_21&" <br />("&num2curINT(DKRS2_intDeliveryFeeLimit)&" "&Chg_currencyISO&")</span>"
										txt_DeliveryFeeType = LNG_SHOP_ORDER_DIRECT_TABLE_07
									End If

								''	arrParams2 = Array(_
								''		Db.makeParam("@strShopID",adVarChar,adParamInput,30,arrList_strShopID) _
								''	)
								''	Set DKRS2 = DB.execRs("DKP_DELIVERY_FEE_VIEW",DB_PROC,arrParams2,Nothing)'DKPA_DELIVEY_FEE_VIEW
								''	If Not DKRS2.BOF And Not DKRS2.EOF Then
								''		DKRS2_strShopID			= DKRS2("strShopID")
								''		DKRS2_strComName		= DKRS2("strComName")
								''		DKRS2_FeeType			= DKRS2("FeeType")
								''		DKRS2_intFee			= Int(DKRS2("intFee"))
								''		DKRS2_intLimit			= Int(DKRS2("intLimit"))
								''		'PRINT printDeli(DKRS2_FeeType)
								''		'If DKRS2_FeeType <> "FREE" Then
								''		'	PRINT num2cur(DKRS2_intFee) & "원 ("&num2cur(DKRS2_intLimit) &"원 이상 무료배송)"
								''		'End If
								''	Else
								''		Response.Write LNG_SHOP_ORDER_DIRECT_07
								''	End If
								''	Call closeRS(DKRS2)
								''
								''	'print DKRS2_FeeType
								''	'DeliveryFee = Int(DKRS2_intFee) * Int(orderEa)
								''	Select Case LCase(DKRS2_FeeType)
								''		Case "free"
								''			self_DeliveryFee = "0"
								''			txt_DeliveryFee = "<span class=""tweight"">"&spans(LNG_SHOP_ORDER_DIRECT_TABLE_10,"#FF6600","","")&"</span>"
								''			txt_DeliveryFeeType = LNG_SHOP_ORDER_DIRECT_TABLE_10
								''		Case "prev"
								''			If TOTAL_POINT_PRICE >= DKRS2_intLimit Then
								''				self_DeliveryFee = "0"
								''				txt_DeliveryFee = "<span class=""tweight"">"&spans(LNG_SHOP_ORDER_DIRECT_TABLE_10,"#FF6600","","")&"</span><br /><span class=""f11px lheight130"">"&LNG_SHOP_ORDER_DIRECT_TABLE_11&" <br />"&LNG_SHOP_DETAILVIEW_21&" ("&num2cur(DKRS2_intLimit)&" "&Chg_currencyISO&")</span>"
								''				txt_DeliveryFeeType = LNG_SHOP_ORDER_DIRECT_TABLE_10
								''			Else
								''				self_DeliveryFee = DKRS2_intFee
								''				txt_DeliveryFee = "<span class=""tweight"">"&LNG_SHOP_ORDER_DIRECT_TABLE_07&" "&num2cur(self_DeliveryFee)&" "&Chg_currencyISO&"</span><br /><span class=""f11px lheight130"">"&LNG_SHOP_ORDER_DIRECT_TABLE_11&" <br />"&LNG_SHOP_DETAILVIEW_21&" ("&num2cur(DKRS2_intLimit)&" "&Chg_currencyISO&")</span>"
								''				txt_DeliveryFeeType = LNG_SHOP_ORDER_DIRECT_TABLE_07
								''			End If
								''		Case "next"
								''			If TOTAL_POINT_PRICE >= DKRS2_intLimit Then
								''				self_DeliveryFee = "0"
								''				txt_DeliveryFee = "<span class=""tweight"">"&spans(LNG_SHOP_ORDER_DIRECT_TABLE_10,"#FF6600","","")&"</span><br /><span class=""f11px lheight130"">"&LNG_SHOP_ORDER_DIRECT_TABLE_11&" <br />"&LNG_SHOP_DETAILVIEW_21&" ("&num2cur(DKRS2_intLimit)&" "&Chg_currencyISO&")</span>"
								''				txt_DeliveryFeeType = LNG_SHOP_ORDER_DIRECT_TABLE_10
								''			Else
								''				txt_DeliveryFee = "<span class=""tweight"">"&LNG_SHOP_ORDER_DIRECT_TABLE_13&" "&num2cur(self_DeliveryFee)&" "&Chg_currencyISO&"</span><br /><br />"&LNG_SHOP_DETAILVIEW_21&" ("&num2cur(DKRS2_intLimit)&" "&Chg_currencyISO&")"
								''				txt_DeliveryFeeType = LNG_SHOP_ORDER_DIRECT_TABLE_13
								''				self_DeliveryFee = 0
								''
								''			End If
								''	End Select
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

								''	arrParams2 = Array(_
								''		Db.makeParam("@strShopID",adVarChar,adParamInput,30,arrList_strShopID) _
								''	)
								''	Set DKRS2 = DB.execRs("DKP_DELIVERY_FEE_VIEW",DB_PROC,arrParams2,Nothing)'DKPA_DELIVEY_FEE_VIEW
								''	If Not DKRS2.BOF And Not DKRS2.EOF Then
								''		DKRS2_strShopID			= DKRS2("strShopID")
								''		DKRS2_strComName		= DKRS2("strComName")
								''		DKRS2_FeeType			= DKRS2("FeeType")
								''		DKRS2_intFee			= Int(DKRS2("intFee"))
								''		DKRS2_intLimit			= Int(DKRS2("intLimit"))
								''		'PRINT printDeli(DKRS2_FeeType)
								''		'If DKRS2_FeeType <> "FREE" Then
								''		'	PRINT num2cur(DKRS2_intFee) & "원 ("&num2cur(DKRS2_intLimit) &"원 이상 무료배송)"
								''		'End If
								''	Else
	'							''		Response.Write "(기본배송비정책이 입력되지 않았습니다)"
								''		Call ALERTS(LNG_SHOP_ORDER_DIRECT_07,"back","")
								''	End If
								''	Call closeRS(DKRS2)

									arrParams3 = Array(_
										Db.makeParam("@cart_method",adVarChar,adParamInput,10,cart_method), _
										Db.makeParam("@MEMTYPE",adVarChar,adParamInput,50,cart_id), _
										Db.makeParam("@strShopID",adVarChar,adParamInput,30,arrList_strShopID), _
										Db.makeParam("@GoodsDeliveryType",adVarChar,adParamInput,6,arrList_GoodsDeliveryType) _
									)
									arrList3 = Db.execRsList("DKSP_ORDER_DELIVERY_CALC",DB_PROC,arrParams3,listLen3,Nothing)
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
									Else
										self_DeliveryFee = DKRS2_intDeliveryFee
										txt_DeliveryFee = "<span class=""tweight"">"&LNG_SHOP_ORDER_DIRECT_TABLE_07&" "&num2curINT(self_DeliveryFee)&" "&Chg_currencyISO&"</span><br /><span class=""f11px lheight130"">"&LNG_SHOP_ORDER_DIRECT_TABLE_11&" <br />"&LNG_SHOP_DETAILVIEW_21&" ("&num2curINT(DKRS2_intDeliveryFeeLimit)&" "&Chg_currencyISO&")</span>"
										txt_DeliveryFeeType = LNG_SHOP_ORDER_DIRECT_TABLE_07
									End If

								''	Select Case LCase(DKRS2_FeeType)
								''		Case "free"
								''			self_DeliveryFee = "0"
								''			txt_DeliveryFee = "<span class=""tweight"">"&spans(LNG_SHOP_ORDER_DIRECT_TABLE_10,"#FF6600","","")&"</span>"
								''			txt_DeliveryFeeType = LNG_SHOP_ORDER_DIRECT_TABLE_10
								''		Case "prev"
								''			If TOTAL_POINT_PRICE >= DKRS2_intLimit Then
								''				self_DeliveryFee = "0"
								''				txt_DeliveryFee = "<span class=""tweight"">"&spans(LNG_SHOP_ORDER_DIRECT_TABLE_10,"#FF6600","","")&"</span><br /><span class=""f11px lheight130"">"&LNG_SHOP_ORDER_DIRECT_TABLE_11&" <br />"&LNG_SHOP_DETAILVIEW_21&" ("&num2cur(DKRS2_intLimit)&" "&Chg_currencyISO&")</span>"
								''				txt_DeliveryFeeType = LNG_SHOP_ORDER_DIRECT_TABLE_10
								''			Else
								''				self_DeliveryFee = DKRS2_intFee
								''				txt_DeliveryFee = "<span class=""tweight"">"&LNG_SHOP_ORDER_DIRECT_TABLE_07&" "&num2cur(self_DeliveryFee)&" "&Chg_currencyISO&"</span><br /><span class=""f11px lheight130"">"&LNG_SHOP_ORDER_DIRECT_TABLE_11&" <br />"&LNG_SHOP_DETAILVIEW_21&" ("&num2cur(DKRS2_intLimit)&" "&Chg_currencyISO&")</span>"
								''				txt_DeliveryFeeType = LNG_SHOP_ORDER_DIRECT_TABLE_07
								''			End If
								''		Case "next"
								''			If TOTAL_POINT_PRICE >= DKRS2_intLimit Then
								''				self_DeliveryFee = "0"
								''				txt_DeliveryFee = "<span class=""tweight"">"&spans(LNG_SHOP_ORDER_DIRECT_TABLE_10,"#FF6600","","")&"</span><br /><span class=""f11px lheight130"">"&LNG_SHOP_ORDER_DIRECT_TABLE_11&" <br />"&LNG_SHOP_DETAILVIEW_21&" ("&num2cur(DKRS2_intLimit)&" "&Chg_currencyISO&")</span>"
								''				txt_DeliveryFeeType = LNG_SHOP_ORDER_DIRECT_TABLE_10
								''			Else
								''				txt_DeliveryFee = "<span class=""tweight"">"&LNG_SHOP_ORDER_DIRECT_TABLE_13&" "&num2cur(self_DeliveryFee)&" "&Chg_currencyISO&"</span><br /><br />"&LNG_SHOP_DETAILVIEW_21&" ("&num2cur(DKRS2_intLimit)&" "&Chg_currencyISO&")"
								''				txt_DeliveryFeeType = LNG_SHOP_ORDER_DIRECT_TABLE_13
								''				self_DeliveryFee  = 0
								''			End If
								''	End Select
								End If
							End If


						'trClass = ""
						'tdClass = ""
						'If arrList_SHOPCNT <> "1" Then
						'	trClass = "class=""bgC1"""
						'	If k = "" Or IsNull(k) = True Then k = 1
						'	If k = arrList_SHOPCNT Then tdClass = " lastTD"
						'Else
						'	k = ""
						'	trClass = ""
						'	tdClass = " lastTD"
						'End If
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

						'TOTAL_Price = TOTAL_Price + self_GoodsPrice + self_DeliveryFee + self_GoodsOptionPrice
						TOTAL_Price = TOTAL_Price + self_GoodsPrice + self_GoodsOptionPrice
						TOTAL_USEPOINT_PRICE = TOTAL_USEPOINT_PRICE + self_GoodsPrice + self_GoodsOptionPrice
						'TOTAL_FIRST_PRICE = TOTAL_FIRST_PRICE + self_GoodsPrice + self_GoodsOptionPrice + self_DeliveryFee
						'TOTAL_DeliveryFee = TOTAL_DeliveryFee + self_DeliveryFee
						TOTAL_OptionPrice = TOTAL_OptionPrice + self_GoodsOptionPrice
						TOTAL_OptionPrice2 = TOTAL_OptionPrice2 + self_GoodsOptionPrice2
						TOTAL_GOODS_PRICE = TOTAL_GOODS_PRICE + self_GoodsPrice
						TOTAL_POINT = TOTAL_POINT + selfPoint

						TOTAL_PV = TOTAL_PV + self_PV
						TOTAL_GV = TOTAL_GV + self_GV



						'애니페이 상품별 SP사용 최대 포인트
					''	SP_POINTUSE_MAX		= self_GoodsPrice * (arr_CS_price6 / 100)					'상품별 SP사용 최대 포인트
					''	TOTAL_SP_POINTUSE_MAX = TOTAL_SP_POINTUSE_MAX + SP_POINTUSE_MAX			'총 SP사용 최대 포인트(배송비 제외)
					''	'print self_GoodsPrice &" "&arr_CS_price6&" "&arr_CS_price6/100&" "&SP_POINTUSE_RATIO&"<br/>"
					''	'print TOTAL_SP_POINTUSE_MAX


			%>
			<%

					'◆ #2. SHOP 주문 임시테이블 정보 입력
						arrParamsGI = Array(_
							Db.makeParam("@OrderIDX",adInteger,adParamInput,4,orderTempIDX),_
							Db.makeParam("@orderNum",adVarChar,adParamInput,20,orderNum), _
							Db.makeParam("@GoodIDX",adInteger,adParamInput,4,arrList_GoodIDX),_
							Db.makeParam("@GoodsCode",adVarChar,adParamInput,20,arrList_CSGoodsCode),_
							Db.makeParam("@GoodsPrice",adDouble,adParamInput,16,arrList_GoodsPrice),_
							Db.makeParam("@GoodsPV",adDouble,adParamInput,16,arr_CS_price4),_
							Db.makeParam("@orderEa",adInteger,adParamInput,4,arrList_orderEa),_
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

				<tr class="<%=trClass%><%=trClass2%>">
					<td class="tcenter" style="padding:13px 10px;"><div class="thumImg" style="padding:<%=imgPaddingH%>px 0px;"><%=viewImg(imgPath,imgWidth,imgHeight,"")%></div></td>
					<td class="vtop " style="padding:13px 10px;">
						<p><%=printGoodsIcon%></p>
						<p class="goodsName"><strong><%=backword(arrList_GoodsName)%></strong><br /><%=arrList_GoodsNote%></p>
						<p class="goodsOption"><%=printOPTIONS%></p>
					</td>
					<td class="tcenter <%=tdClass%>">
						<%=spans(num2cur(self_GoodsPrice/arrList_orderEa),"#FF6600","","bold")%>&nbsp;<%=Chg_currencyISO%>
						<%If DK_MEMBER_STYPE = "0" And arrList_isCSGoods = "T" Then%>
						<!-- <br /><%=spans(num2curINT(self_PV/arrList_orderEa),"#ff3300","","bold")%> <%=CS_PV%>
						<br /><%=spans(num2curINT(self_GV/arrList_orderEa),"green","","bold")%> <%=CS_PV2%> -->
						<%End If%>

					</td>

					<td class="tcenter"><input type="hidden" name="ea" class="input_text" style="width:25px;" value="<%=arrList_orderEa%>" /><strong><%=arrList_orderEa%></strong> ea</td>
					<!-- <td class="tcenter" style="line-height:160%;">
						<strong><%=spans(num2cur(self_GoodsPrice)&" 원","#FF6600","","")%></strong>
						<%If arrList_isCSGoods = "T" And DK_MEMBER_TYPE = "COMPANY" And DK_MEMBER_STYPE = "0" Then%>
						<br /><strong><%=spans(num2curINT(self_PV)&" PV","#eb4800","","")%></strong>
						<%End If%>
						<br /><%=viewImgSt(IMG_SHOP&"/icon_point_green.gif",13,15,"","","vmiddle")%>&nbsp;<%=num2cur(selfPoint)%> 원
					</td> -->
					<td class="tcenter <%=tdClass%>">
						<%=spans(num2cur(self_GoodsPrice),"#ff6600","","bold")%>&nbsp;<%=Chg_currencyISO%>
						<%If DK_MEMBER_STYPE = "0" And arrList_isCSGoods = "T" Then%>
						<!-- <br /><%=spans(num2curINT(self_PV),"#ff3300","","bold")%> <%=CS_PV%>
						<br /><%=spans(num2curINT(self_GV),"green","","bold")%> <%=CS_PV2%> -->
						<%End If%>
					</td>
					<% If k = 1 Then%>
					<td class="tcenter bor_l lheight160 lastTD" <%=rowSpans1%>>
						<%
								SQL = "SELECT [strComName] FROM [DK_VENDOR] WHERE [strShopID] = ?"
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
							TOTAL_DeliveryFee = TOTAL_DeliveryFee + self_DeliveryFee

						Else
							If l = 0 Then
								l = 1
								rowSpans2 = " rowspan="""&arrList_DELICNT&""" "
								TOTAL_DeliveryFee = TOTAL_DeliveryFee + self_DeliveryFee
							Else
								l = l
								TOTAL_DeliveryFee = TOTAL_DeliveryFee

							End If
						End If
						If l = 1 Then
							'print "<td class=""tcenter bor_l lheight160 "" "&rowSpans2&">"&txt_DeliveryFee&"</td>"
							print "<td class=""tcenter bor_l lheight160 lastTD"" "&rowSpans2&">"&txt_DeliveryFee&"</td>"
						End If

					%>
					<%

					'	Select Case arrList_GoodsDeliveryType
					'		Case "SINGLE"
					'			PRINT "<td class=""tcenter bor_l lheight160 "&tdClass&""">"&txt_DeliveryFee&"</td>"
					'		Case "BASIC"
					'			If l = 0 Then l = 1
					'			PRINT "<td>"&arrList_DELICNT&","&l&"</td>"
'
'								If arrList_DELICNT = l Then
'									l = 0
'								Else
'									l = l + 1
'								End If
'						End Select
'
'						print prev_GoodsDeliveryType
'						print arrList_GoodsDeliveryType
'						If arrList_DELICNT <> "1" Then
'							If prev_GoodsDeliveryType <> arrList_GoodsDeliveryType Then
'								PRINT "<td class=""tcenter bor_l lheight160 "&tdClass&""" rowspan="""&arrList_DELICNT&""">"&txt_DeliveryFee&"</td>"
'							End If
'						Else
'							PRINT "<td class=""tcenter bor_l lheight160 "&tdClass&""">"&txt_DeliveryFee&"</td>"
'						End If
'						prev_GoodsDeliveryType = arrList_GoodsDeliveryType
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

				Else
					Call ALERTS(LNG_SHOP_ORDER_DIRECT_08,"GO","/shop/cart.asp")
				End If

			%>
		</table>
	</div>

	<%
'If webproIP="T" Then TOTAL_DeliveryFee = 100

	'	TOTAL_SUM_PRICE = TOTAL_Price
		TOTAL_SUM_PRICE = TOTAL_GOODS_PRICE + TOTAL_DeliveryFee + TOTAL_OptionPrice

		TOTAL_POINTUSE_MIN = CONST_CS_POINTUSE_MIN				'최소사용 포인트
		TOTAL_POINTUSE_MAX = TOTAL_SUM_PRICE
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

	<div class="cleft width100 TotalArea">
		<div class="AreaZoneWrap">
			<div class="AreaZone">
				<div class="pws" id="PriceArea">
					<span class="tit"><%=LNG_SHOP_ORDER_DIRECT_TABLE_14%></span><span class="price PriceArea" id="PriceAreaID"><%=num2cur(TOTAL_Price)%></span><span class="won"><%=Chg_CurrencyISO%></span>
				</div>
				<!-- <div class="pws" id="DeliveryArea"><span class="tit tit2"><%=LNG_SHOP_ORDER_DIRECT_TABLE_15%></span><span class="price DeliveryArea" id="DeliveryAreaID"><%=num2cur(TOTAL_DeliveryFee)%></span><span class="won"><%=Chg_CurrencyISO%></span></div> -->
				<div class="pws" id="DeliveryArea"><span class="tit tit2"><%=LNG_SHOP_ORDER_DIRECT_TABLE_15%></span><span class="price DeliveryArea" id="DeliveryAreaID"><%=num2cur(TOTAL_DeliveryFee)%></span><span class="won"><%=Chg_CurrencyISO%></span></div>
				<div class="pws" id="LastArea"><span class="tit tit2"><%=LNG_SHOP_ORDER_DIRECT_TABLE_16%></span><span class="price LastArea" id="LastAreaID"><%=num2cur(TOTAL_SUM_PRICE)%></span><span class="won"><%=Chg_CurrencyISO%></span></div>
			</div>
			<div class="disArea width100">
				<table <%=tableatt%> class="width100">
					<colgroup>
						<col width="120" />
						<col width="280" />
						<col width="*" />
						<col width="300" />
					</colgroup>
					<tbody>
						<tr>
							<td><%=LNG_SHOP_ORDER_FINISH_08%></td>
							<td class="bor_l2" colspan="<%=COLSPAN2%>">
								<ul>
									<li>·<%=LNG_SHOP_ORDER_FINISH_09%> : <strong><%=num2cur(TOTAL_Price)%></strong> <%=Chg_CurrencyISO%></li>
									<!-- <li>·<%=LNG_SHOP_ORDER_FINISH_10%> : <strong><%=num2cur(TOTAL_OptionPrice)%></strong> <%=Chg_CurrencyISO%></li> -->
									<li>·<%=LNG_SHOP_ORDER_FINISH_11%> : <strong><%=num2cur(TOTAL_DeliveryFee)%></strong> <%=Chg_CurrencyISO%></li>
								</ul>
							</td>
							<%If isSHOP_POINTUSE = "T" Then%>
							<td class="bor_l2 vtop point">
								<!-- <ul>
									<%'▣C포인트 한국사용X, 외국회원만 사용(gng)
									'	If UCase(DK_MEMBER_NATIONCODE) = "KR" Then
									'		DISPLAY_STYLE = "display:none;"
									'	End If
									%>
									<li style="<%=DISPLAY_STYLE%>">·<%=SHOP_POINT%>: <strong id="viewPoint">0</strong> <%=Chg_CurrencyISO%></li>
									<li>·<%=SHOP_POINT2%> : <strong id="viewPoint2">0</strong> <%=Chg_CurrencyISO%></li>
								</ul> -->
								<table <%=tableatt%> >
									<colgroup>
										<col width="100" />
										<col width="150" />
									</colgroup>
									<tr>
										<td class="noline"><%=SHOP_POINT%></td>
										<td class="noline tright"><strong id="viewPoint">0</strong> <%=Chg_CurrencyISO%></td>
									</tr>
									<!-- <tr>
										<td class="noline"><%=SHOP_POINT2%></td>
										<td class="noline tright"><strong id="viewPoint2">0</strong> <%=Chg_CurrencyISO%></td>
									</tr> -->
								</table>
							</td>
							<%End If%>
							<td class="bor_l summ" rowspan="2">
								<ul>
									<li class="tweight"><%=LNG_SHOP_ORDER_FINISH_13%></li>
									<%If DK_MEMBER_TYPE <> "GUEST" Then%>
										<!-- <li style="margin-top:8px;">·<%=LNG_SHOP_ORDER_FINISH_14%> : <strong id="viewPoint"><%=num2curINT(TOTAL_Point)%></strong> <%=Chg_CurrencyISO%></li> -->
									<%Else%>
										<li style="margin-top:8px;">·<%=LNG_SHOP_ORDER_FINISH_14%> : <strong id="viewPoint" class="mline"><%=num2curINT(TOTAL_Point)%></strong> <%=Chg_CurrencyISO%></li>
										<li style="margin-top:8px; color:#ee0000">·<%=LNG_SHOP_ORDER_FINISH_15%></li>
									<%End If%>
									<%If arrList_isCSGoods = "T" And DK_MEMBER_STYPE = "0" Then%>
										<li style="margin-top:8px; color:#ee0000">·<%=CS_PV%>: <strong><%=num2curINT(TOTAL_PV)%></strong> <%=CS_PV%></li>
										<!-- <li style="margin-top:8px; color:green">·<%=CS_PV2%>: <strong><%=num2curINT(TOTAL_GV)%></strong> <%=CS_PV2%></li> -->
									<%End If%>
								</ul>
							</td>
						</tr>
						<%If isSHOP_POINTUSE = "T" Then%>
						<%
							'▶포인트 소수점 입력시 toCurrency → toCurrencyP2
							Select Case UCase(DK_MEMBER_NATIONCODE)
								Case "KR"
									toCurrency	= "toCurrency"		'포인트 입력창
									pSpace		= 0					'calcSettlePrice  text 표기 소수점 자리수(/PG/NICEPAY/pay.js)
								Case Else
									toCurrency  = "toCurrencyP2"
									pSpace		= 2
							End Select
						%>
							<script type="text/javascript">
								//소수점
								var NumberFormatter = new Intl.NumberFormat('en-US', {
								  minimumFractionDigits: <%=pSpace%>,
								  maximumFractionDigits: <%=pSpace%>
								});
							</script>

						<tr>
							<td><%=LNG_CS_ORDERS_USE_POINT%></td>
							<td class="bor_l2" colspan="2">
							<%If DK_MEMBER_TYPE <> "GUEST" Then%>
								<input type="text" name="useCmoney" class="input_gray01"  onKeyUp="toCurrency(this)" onBlur="toCurrency(this); checkUseCmoney(this);" value="0"   /><span style="margin-left:5px;">(<%=SHOP_POINT%> <strong><%=num2CurINT(MILEAGE_TOTAL)%></strong> <%=Chg_CurrencyISO%></span>) <!-- | <%=LNG_SHOP_ORDER_FINISH_30%> --><!-- </td> -->
								 <!-- 'point' 현금개념(단독 or 단독 + SP) -->
								<br />
								<!-- <input type="text" name="useCmoney2" class="input_gray01" onKeyUp="<%=toCurrency%>(this)" onBlur="<%=toCurrency%>(this); checkUseCmoney2(this);" value="0" /><span style="margin-left:5px;">(<%=SHOP_POINT2%> &nbsp;<strong><%=num2CurINT(MILEAGE2_TOTAL)%></strong> <%=Chg_CurrencyISO%></span>) -->
								<input type="hidden" name="useCmoney2" value="0" />
								</td>

							<%Else%>
								<input type="text" name="useCmoney" class="input_gray01" value="0" disabled="disabled" style="background-color:#eee;" /><span style="margin-left:5px;">(<%=SHOP_POINT%> <strong>-</strong> <%=Chg_CurrencyISO%></span>) | <span style="color:#ee0000"><%=LNG_SHOP_ORDER_FINISH_31%></span><!-- </td> -->
								<br />
								<input type="text" name="useCmoney2" class="input_gray01" value="0" disabled="disabled" style="background-color:#eee;" /><span style="margin-left:5px;">(<%=SHOP_POINT2%> <strong>-</strong> <%=Chg_CurrencyISO%></span>) | <span style="color:#ee0000"><%=LNG_SHOP_ORDER_FINISH_31%></span>
								</td>
							<%End If%>
						</tr>
						<%Else%>
							<input type="hidden" name="useCmoney" value="0" />
							<input type="hidden" name="useCmoney2" value="0" />
						<%End If%>
					</tbody>
				</table>
			</div>
		</div>
	</div>

<!-- <input type="hidden" name="useCmoney" value="0" /> -->

	<div class="cleft ordersInfo width100">
		<div class="fleft" style="width:48%">
			<div class="order_title"><%=LNG_SHOP_ORDER_DIRECT_TITLE_04%><!-- <%If DK_MEMBER_TYPE <> "GUEST" Then%><label><input type="checkbox" name="infoChg" value="T" class="input_chk2"> 회원정보를 주문자정보로 수정합니다.</label><%End If%> --></div>
			<table <%=tableatt%> class="width100">
				<col width="135" />
				<col width="*" />
				<tbody>
				<tr>
					<th><%=LNG_SHOP_ORDER_DIRECT_TABLE_17%> <%=startext%></th>
					<td><input type="text" name="strName" class="input_text1" value="<%=backword_br(strName)%>" /></td>
				</tr><tr>
					<th><%=LNG_SHOP_ORDER_DIRECT_TABLE_18%></th>
					<td>
						<input type="text" class="input_text1" name="strTel" style="width:150px;" maxlength="15" <%=onLyKeys%> value="<%=strTel%>" />
						<!-- <input type="text" class="input_text1" name="strTel1" style="width:45px;ime-mode: disabled;" maxlength="4" onKeyPress="blockNotNumber(event)" value="<%=arrTel(0)%>" /> -	<input type="text" class="input_text1" name="strTel2" style="width:45px;ime-mode: disabled;" maxlength="5" onKeyPress="blockNotNumber(event)" value="<%=arrTel(1)%>" /> - <input type="text" class="input_text1" name="strTel3" style="width:45px;ime-mode: disabled;" maxlength="5" onKeyPress="blockNotNumber(event)" value="<%=arrTel(2)%>" /> -->
					</td>
				</tr><tr>
					<th><%=LNG_SHOP_ORDER_DIRECT_TABLE_19%> <%=startext%></th>
					<td>
						<input type="text" class="input_text1" name="strMobile" style="width:150px;" maxlength="15" <%=onLyKeys%> value="<%=strMobile%>" />
						<!-- <input type="text" class="input_text1" name="strMob1" style="width:45px;ime-mode: disabled;" maxlength="4" onKeyPress="blockNotNumber(event)" value="<%=arrMobile(0)%>" /> - <input type="text" class="input_text1" name="strMob2" style="width:45px;ime-mode: disabled;" maxlength="5" onKeyPress="blockNotNumber(event)" value="<%=arrMobile(1)%>" /> - <input type="text" class="input_text1" name="strMob3" style="width:45px;ime-mode: disabled;" maxlength="5" onKeyPress="blockNotNumber(event)" value="<%=arrMobile(2)%>" /><span style="margin-left:15px;"> -->
					</td>
				</tr><tr>
					<th><%=LNG_SHOP_ORDER_DIRECT_TABLE_21%> <%=startext%></th>
					<!-- <td class="zipTD">
						<p><input type="text" class="input_text1" name="strZip" style="width:60px;" value="<%=strzip%>" /> <img src="<%=IMG_SHOP%>/zip_search.gif" width="68" height="20" alt="주소 찾기" class="vtop" style="cursor:pointer;" onclick="openzip('<%=oriAdd%>');" /></p>
						<p><input type="text" class="input_text1" name="strADDR1" style="width:95%;" value="<%=strADDR1%>" /></p>
						<p><input type="text" class="input_text1" name="strADDR2" style="width:95%;" value="<%=strADDR2%>" /></p>
					</td> -->
					<!-- <td class="zipTD">
						<p>
							<input type="text" class="input_text1" name="strZip" id="strZipDaum" style="width:80px;background:#efefef;" value="<%=strzip%>" maxlength="7" readonly="reaonly"  />
							<%If UCase(DK_MEMBER_NATIONCODE)="KR" Then%>
							<input type="button" class="txtBtn j_medium" onclick="execDaumPostcode('oris');" value="우편번호검색" />
							<%End If%>
						</p>
						<p><input type="text" class="input_text1" name="strADDR1" id="strADDR1Daum" style="width:95%;background:#efefef;" value="<%=strADDR1%>" readonly="reaonly" /></p>
						<p><input type="text" class="input_text1" name="strADDR2" id="strADDR2Daum" style="width:95%;" value="<%=strADDR2%>" /></p>
					</td> -->
					<td class="zipTD">
						<%Select Case UCase(DK_MEMBER_NATIONCODE)%>
							<%Case "KR"%>
								<p><input type="text" class="input_text1 readonly" name="strZip" id="strZipDaum" style="width:80px;background:#f5f5f5;" value="<%=strzip%>" maxlength="7" readonly="readonly" /> <input type="button" class="txtBtn j_medium" onclick="execDaumPostcode('oris');" value="우편번호검색" /></p>
								<p><input type="text" class="input_text1" name="strADDR1" id="strADDR1Daum" style="width:95%;background:#f5f5f5;" value="<%=strADDR1%>" readonly="readonly"  /></p>
								<p><input type="text" class="input_text1" name="strADDR2" id="strADDR2Daum" style="width:95%;" value="<%=strADDR2%>" /></p>
							<%Case "JPTTTTT"%>
								<p><input type="text" class="input_text1" name="strZip"   id="strZip"   style="width:80px;background:#f5f5f5;" value="<%=strzip%>" maxlength="7" readonly="readonly" <%=onLyKeys3%> /> <input type="button" class="txtBtn j_medium" onclick="openzip_jp2EN('strZip');" value="<%=LNG_TEXT_ZIPCODE%>" /> (ZipCode)</p>
								<p><input type="text" class="input_text1" name="strADDR1" id="strADDR1" style="width:95%;background:#f5f5f5;" value="<%=strADDR1%>" readonly="readonly" /></p>
								<p><input type="text" class="input_text1" name="strADDR2" id="strADDR2" style="width:95%;" value="<%=strADDR2%>" /></p>
							<%Case Else%>
								<p><input type="text" class="input_text1" name="strZip"   id="strZip"   style="width:80px;" value="<%=strzip%>" maxlength="7" <%=onLyKeys3%> /><span style="line-height:28px;"> (ZipCode)</span></p>
								<p><input type="text" class="input_text1" name="strADDR1" id="strADDR1" style="width:95%;" value="<%=strADDR1%>" /></p>
								<p><input type="text" class="input_text1" name="strADDR2" id="strADDR2" style="width:95%;" value="<%=strADDR2%>" /></p>
						<%End Select%>
					</td>
				</tr>
				<tr>
					<th><%=LNG_SHOP_ORDER_DIRECT_TABLE_20%> <%=startext%></th>
					<td><input type="text" class="input_text1 imes" name="strEmail" style="width:95%;" value="<%=strEmail%>" /></td>
				</tr>
				</tbody>
			</table>

		</div>
		<div class="fright" style="width:48%">
			<div class="order_title"><%=LNG_SHOP_ORDER_DIRECT_TITLE_05%><label><input type="checkbox" name="infoCopys" onClick="infoCopy(this);" class="input_chk2"> <%=LNG_SHOP_ORDER_DIRECT_TABLE_22%></label></div>
			<table <%=tableatt%> class="width100">
				<col width="135" />
				<col width="*" />
				<tbody>
				<tr>
					<th><%=LNG_SHOP_ORDER_DIRECT_TABLE_17%> <%=startext%></th>
					<td><input type="text" name="takeName" class="input_text1" /></th>
				</tr><tr>
					<th><%=LNG_SHOP_ORDER_DIRECT_TABLE_18%></th>
					<td>
						<input type="text" class="input_text1" name="takeTel" style="width:150px;" maxlength="15" <%=onLyKeys%> value="" />
						<!-- <input type="text" class="input_text1" name="takeTel1" style="width:45px;" maxlength="4" onKeyPress="blockNotNumber(event)" onKeyUp="numberOnly(this)" onBlur="numberOnly(this)" /> - <input type="text" class="input_text1" name="takeTel2" style="width:45px;" maxlength="5" onKeyPress="blockNotNumber(event)" onKeyUp="numberOnly(this)" onBlur="numberOnly(this)" /> - <input type="text" class="input_text1" name="takeTel3" style="width:45px;" maxlength="5" onKeyPress="blockNotNumber(event)" onKeyUp="numberOnly(this)" onBlur="numberOnly(this)" /> -->
					</td>
				</tr><tr>
					<th><%=LNG_SHOP_ORDER_DIRECT_TABLE_19%> <%=startext%></th>
					<td>
						<input type="text" class="input_text1" name="takeMobile" style="width:150px;" maxlength="15" <%=onLyKeys%> value="" />
						<!-- <input type="text" class="input_text1" name="takeMob1" style="width:45px;" maxlength="4" onKeyPress="blockNotNumber(event)" onKeyUp="numberOnly(this)" onBlur="numberOnly(this)" /> - <input type="text" class="input_text1" name="takeMob2" style="width:45px;" maxlength="5" onKeyPress="blockNotNumber(event)" onKeyUp="numberOnly(this)" onBlur="numberOnly(this)" /> - <input type="text" class="input_text1" name="takeMob3" style="width:45px;" maxlength="5" onKeyPress="blockNotNumber(event)" onKeyUp="numberOnly(this)" onBlur="numberOnly(this)" /><span style="margin-left:15px;"> -->
					</td>
				</tr><tr>
					<th><%=LNG_SHOP_ORDER_DIRECT_TABLE_21%> <%=startext%></th>
					<!-- <td class="zipTD">
						<p>
							<input type="text" class="input_text1" name="takeZip" id="takeZipDaum" style="width:60px;background:#efefef;" readonly="reaonly"  />
							<%If UCase(DK_MEMBER_NATIONCODE)="KR" Then%>
								<input type="button" class="txtBtn j_medium" onclick="execDaumPostcode('takes');" value="우편번호검색" />
							<%End If%>
						</p>
						<p><input type="text" class="input_text1" name="takeADDR1" id="takeADDR1Daum" style="width:95%;background:#efefef;" readonly="reaonly"  /></p>
						<p><input type="text" class="input_text1" name="takeADDR2" id="takeADDR2Daum" style="width:95%;" /></p>
					</td> -->
					<td class="zipTD">
						<%Select Case UCase(DK_MEMBER_NATIONCODE)%>
							<%Case "KR"%>
								<p><input type="text" class="input_text1" name="takeZip"   id="takeZipDaum" style="width:80px;background:#f5f5f5;" readonly="readonly" />	<input type="button" class="txtBtn j_medium" onclick="execDaumPostcode('takes');" value="우편번호검색" /></p>
								<p><input type="text" class="input_text1" name="takeADDR1" id="takeADDR1Daum" style="width:95%;background:#f5f5f5;" readonly="readonly" /></p>
								<p><input type="text" class="input_text1" name="takeADDR2" id="takeADDR2Daum" style="width:95%;" /></p>
							<%Case "JPTTTTT"%>
								<p><input type="text" class="input_text1" name="takeZip"   id="takeZip" style="width:80px;background:#f5f5f5;" maxlength="7" readonly="readonly" <%=onLyKeys3%> /> <input type="button" class="txtBtn j_medium" onclick="openzip_jp2EN('takeZip');" value="<%=LNG_TEXT_ZIPCODE%>" /> (ZipCode)</p>
								<p><input type="text" class="input_text1" name="takeADDR1" id="takeADDR1" style="width:95%;background:#f5f5f5;" readonly="readonly" /></p>
								<p><input type="text" class="input_text1" name="takeADDR2" id="takeADDR2" style="width:95%;" /></p>
							<%Case Else%>
								<p><input type="text" class="input_text1" name="takeZip"   id="takeZip"   style="width:80px;" maxlength="7" <%=onLyKeys3%> /><span style="line-height:28px;"> (ZipCode)</span></p>
								<p><input type="text" class="input_text1" name="takeADDR1" id="takeADDR1" style="width:95%;" /></p>
								<p><input type="text" class="input_text1" name="takeADDR2" id="takeADDR2" style="width:95%;" /></p>
						<%End Select%>
					</td>
				</tr><tr>
					<th><%=LNG_SHOP_ORDER_DIRECT_TABLE_23%></td>
					<td><input type="text" name="orderMemo" maxlength="100" class="input_text1" style="width:95%;" /></td>
				</tbody>
			</table>
		</div>
	</div>

	<!-- <%
		'▣제품구매관련 약관(파인애플 2017-02-01)
	'	arrParams2 = Array(_
	'		Db.makeParam("@policyType",adVarChar,adParamInput,10,"policy04") ,_
	'		Db.makeParam("@strNation",adVarChar,adParamInput,10,UCase(LANG)) _
	'	)
	'	viewContent = Db.execRsData("DKP_POLICY_CONTENT",DB_PROC,arrParams2,Nothing)
	%>
	<div class="cleft ordersInfo width100">
		<div class="order_title">제품구매 약관동의</div>
		<div id="pages">
			<div style="" >
				<div class="agree_box" style="width:998px;"><div class="agree_content1" style="width:982px;height:140px;"><%=backword(viewContent)%></div></div>
				<p class="agreeArea tweight" style="padding-top:4px;"><label><input type="checkbox" name="agreement" value="T" id="agree01Chk" class="input_chk3" style="width:16px;height:16px;"/> 제품구매약관에 동의합니다.</label>
			</div>
		</div>
	</div> -->

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
	<div class="cleft width100 payment">
		<div class="order_title"><%=LNG_SHOP_ORDER_DIRECT_TITLE_06%></div>
		<div class="width100 selectPay">
			<%If IsArray(arrList_B) Then%>
				<label><input type="radio" name="paykind" value="inBank" onclick="chgPay(this.value)" class="input_radio" /> <%=LNG_SHOP_ORDER_DIRECT_PAY_02%></label>
			<%Else%>
				<label><input type="radio" name="paykind" value="inBank" class="input_radio" disabled="disabled" /> <%=LNG_SHOP_ORDER_DIRECT_PAY_03%></label>
			<%End If%>

			<%If UCase(DK_MEMBER_NATIONCODE) = "KR" And webproIP="T" Then   '카드결제는 KR only%>
			<!-- <label><input type="radio" name="paykind" value="Card" onclick="chgPay(this.value)" class="input_radio" /> <%=LNG_SHOP_ORDER_DIRECT_PAY_01%></label>
			<label><input type="radio" name="paykind" value="CardAPI" onclick="chgPay(this.value)" class="input_radio" /> <%=LNG_SHOP_ORDER_DIRECT_PAY_01%>API</label> -->
			<!-- <label><input type="radio" name="paykind" value="Bank" onclick="chgPay(this.value)" class="input_radio" /> 실시간계좌이체(TEST)</label>
			<label><input type="radio" name="paykind" value="vBank" onclick="chgPay(this.value)" class="input_radio" /> 가상계좌(TEST)</label> -->
			<%End If%>

			<%'▣C포인트의 경우 현금성 포인트 이며,	한국사용X,  외국회원만 사용!!
				If UCase(DK_MEMBER_NATIONCODE) <> "KR" Then
			%>
				<%If DK_MEMBER_TYPE = "COMPANY" And isSHOP_POINTUSE = "T" Then%>
					<%If CDbl(MILEAGE_TOTAL) + CDbl(MILEAGE2_TOTAL) >= CDbl(TOTAL_SUM_PRICE) Then%>
						<label><input type="radio" name="paykind" value="point" onclick="chgPay(this.value)" class="input_radio"  /> <%=SHOP_POINT%> <!-- 단독결제 or S + P --></label>
					   &nbsp;&nbsp;<span id="pointTXT" class="tweight red2 font14px" ></span>
					<%End If %>
				<%End If %>
			<%End If %>
			<!-- <%'▣S포인트 단독결제%>
				<%If DK_MEMBER_TYPE = "COMPANY" And isSHOP_POINTUSE = "T" Then%>
					<%If CDbl(MILEAGE2_TOTAL) >= CDbl(TOTAL_SUM_PRICE) Then%>
						<label><input type="radio" name="paykind" value="point2" onclick="chgPay(this.value)" class="input_radio"  /> <%=LNG_TEXT_PAYING_POINT2_ALONE%></label>
					   &nbsp;&nbsp;<span id="pointTXT" class="tweight red2 font14px" ></span>
					<%End If %>
				<%End If %> -->

			<!-- <label><input type="radio" name="paykind" value="vBank" onclick="chgPay(this.value)" class="input_radio"  /> 가상계좌 결제</label>
			<label><input type="radio" name="paykind" value="dBank" onclick="chgPay(this.value)" class="input_radio"  /> 실시간계좌이체</label> -->

			<%
				If DK_MEMBER_TYPE = "COMPANY" And CSGoodCnt > 0  Then
					PRINT TABS(4)&" <span class=""tweight"" style=""padding-left:60px;""> "&LNG_SHOP_ORDER_DIRECT_PAY_04&" : </span>"
					PRINT TABS(4)&" <select name=""v_SellCode"">"
					'PRINT TABS(4)&" <option value="""">"&LNG_SHOP_ORDER_DIRECT_PAY_05&"</option>"

						'▣디자이너스 매출구분(2020-03-05)
						Select Case DK_MEMBER_STYPE
							Case "0"
								If arr_CS_SELLCODE <> "01" Then Call ALERTS("회원매출 상품만 구매할 수 있습니다.","back","")
							Case "1"
								If arr_CS_SELLCODE <> "02" Then Call ALERTS("소비자매출 상품만 구매할 수 있습니다.","back","")
						End Select

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
					PRINT TABS(4)&"	</select>"

				'	PRINT TABS(4)&" <span class=""tweight"" style=""padding-left:50px;""> "&LNG_SHOP_ORDER_DIRECT_PAY_07&" : </span>"
				'	PRINT TABS(4)&" <select name=""SalesCenter"">"
				'	PRINT TABS(4)&" <option value="""">::: "&LNG_SHOP_ORDER_DIRECT_PAY_08&" :::</option>"
				'		'SQL2 = "SELECT * FROM [tbl_Business] ORDER BY [name] ASC"
				'		SQL2 = "SELECT * FROM [tbl_Business] WHERE [Na_Code] = '"&DK_MEMBER_NATIONCODE&"' ORDER BY [name] ASC"
				'		arrListC = Db.execRsList(SQL2,DB_TEXT,Nothing,listLenC,DB3)
				'		If IsArray(arrListC) Then
				'			For i = 0 to listLenC
				'				PRINT TABS(5)& " <option value="""&arrListC(0,i)&""" >"&arrListC(1,i)&"</option>"
				'				'"&isSelect("100",arrListC(0,i))&"
				'			Next
				'		Else
				'			PRINT TABS(4)&"	<option value="""">"&LNG_SHOP_ORDER_DIRECT_PAY_09&"</option>"
				'		End If
				'	PRINT TABS(4)&"	</select>"
			%>
					<input type="hidden" name="SalesCenter" value="" />
			<%
				Else
			%>
			<input type="hidden" name="v_SellCode" value="01" />
			<input type="hidden" name="SalesCenter" value="" />
			<%	End If%>
			<%'If DK_MEMBER_TYPE = "COMPANY" And DK_MEMBER_STYPE = "0" Then%>
			<%If DK_MEMBER_TYPE = "COMPANY" Then%>
				<!-- <span class="tweight" style="padding-left:50px;"><%=LNG_SHOP_ORDER_DIRECT_PAY_10%> : </span>
				<select name="DtoD" onchange="chgDelivery(this.value);">
					<option value="">배송구분선택</option>
					<option value="F"><%=LNG_TEXT_DIRECT_RECEIPT%></option>
					<option value="T"><%=LNG_SHOP_ORDER_DIRECT_PAY_11%></option>
					<option value="C"><%=LNG_TEXT_CENTER_RECEIPT%></option>
				</select> -->
				<input type="hidden" name="DtoD" value="T" />
			<%Else%>
				<input type="hidden" name="DtoD" value="T" />
			<%End If%>

		</div>
		<div class="cleft width100 payinfoWrap">
			<div class="fleft" style="width:65%;">
				<div id="CardInfo" class="width100" style="display:none;">
					<table <%=tableatt%> class="width100">
						<col width="120" />
						<col width="*" />
						<%Select Case DKPG_PGCOMPANY%>
							<%Case "SPEEDPAY","YESPAY","DAOU","NICEPAY","ONOFFKOREA"%>
								<tr>
									<th>카드번호</th>
									<td>
										<input type="text" name="cardNo1" class="input_text tcenter" maxlength="4" style="width:60px;" placeholder="4자리" <%=onlyKeys%> value="" /> -
										<input type="text" name="cardNo2" class="input_text tcenter" maxlength="4" style="width:60px;" placeholder="4자리" <%=onlyKeys%> value="" /> -
										<input type="password" name="cardNo3" class="input_text tcenter" maxlength="4" style="width:60px;" placeholder="4자리" <%=onlyKeys%> value="" /> -
										<input type="password" name="cardNo4" class="input_text tcenter" maxlength="4" style="width:60px;" placeholder="4자리" <%=onlyKeys%> value="" />
									</td>
								</tr><tr>
									<th>유효기간</th>
									<td>
										<!-- <input type="text" name="card_mm" class="input_text tcenter" maxlength="2" style="width:90px;" placeholder="유효기간(월)" <%=onlyKeys%> value="" /> 월
										<input type="text" name="card_yy" class="input_text tcenter" maxlength="4" style="width:90px;" placeholder="유효기간(년)" <%=onlyKeys%> value="" /> 년 -->
										<select name="card_mm" class="vmiddle input_text" style="width:90px;">
											<option value="">유효기간(월)</option>
											<%For j = 1 To 12%>
												<%jsmm = Right("0"&j,2)%>
												<option value="<%=jsmm%>" ><%=jsmm%></option>
											<%Next%>
										</select> /
										<select name="card_yy" class="vmiddle input_text" style="width:100px;">
											<option value="">유효기간(년)</option>
											<%For i = THIS_YEAR To EXPIRE_YEAR%>
												<option value="<%=i%>" ><%=i%></option>
											<%Next%>
										</select>
									</td>
								</tr>
								<%If DKPG_PGCOMPANY = "YESPAY" Then %>
								<tr>
									<th>생년월일</th>
									<td>
										<input type="password" name="CardBirth" class="input_text1" style="width:150px" maxlength="10" value="" placeholder="731025 형식(yymmdd)" <%=onlyKeys%> /> (생년월일 6자리 yymmdd, 사업자의 경우 사업자번호10자리)
									</td>
								</tr><tr>
									<th>비밀번호</th>
									<td>
										<input type="password" name="CardPass" class="input_text1" style="width:40px" maxlength="2" value="" /> (앞2자리)
									</td>
								</tr>
								<%End If%>
								<%If DKPG_PGCOMPANY = "DAOU" Then%>
								<tr>
									<th rowspan="2"><!-- 생년월일 -->카드구분</th>
									<td>
										<label><input type="radio" name="cardKind" value="P" onclick="chgCardKind(this.value)" class="input_radio" checked="checked" /> 일반신용</label>
										<label><input type="radio" name="cardKind" value="C" onclick="chgCardKind(this.value)" class="input_radio" /> 법인사업자</label>
										<label><input type="radio" name="cardKind" value="I" onclick="chgCardKind(this.value)" class="input_radio" /> 개인사업자</label>
									</td>
								</tr>
								<tr>
									<td>
										<div id="CardKind01">
											<select name="birthYY" class="vmiddle input_text" style="width:100px;">
												<option value="">년</option>
												<%For i = MIN_YEAR To MAX_YEAR%>
													<option value="<%=i%>" ><%=i%></option>
												<%Next%>
											</select>
											<select name="birthMM" class="vmiddle input_text" style="width:70px;">
												<option value="">월</option>
												<%For j = 1 To 12%>
													<%jsmm = Right("0"&j,2)%>
													<option value="<%=jsmm%>" ><%=jsmm%></option>
												<%Next%>
											</select>
											<select name="birthDD" class="vmiddle input_text" style="width:70px;">
												<option value="">일</option>
												<%For k = 1 To 31%>
													<%ksdd = Right("0"&k,2)%>
													<option value="<%=ksdd%>"><%=ksdd%></option>
												<%Next%>
											</select>
											<span style="color:#ee0000"> * 생년월일 입력</span>
										</div>
										<div id="CardKind02" style="display:none;">
											<input type="password" name="CorporateNumber" class="input_text" maxlength="10" style="width:200px;" placeholder="사업자등록번호 10자리" <%=onlyKeys%> value="" />
											<span style="color:#ee0000"> * 사업자등록번호 10자리 입력</span>
										</div>
										<!-- <div id="CardKind03" style="display:none;">
											<input type="text" name="ssh1" class="input_text" style="width:90px;" value="" maxlength="6" <%=onlyKeys%>/> - <input type="password" name="ssh2" class="input_text" style="width:110px;" value="" maxlength="7" <%=onlyKeys%> /></li>
											<span style="color:#ee0000"> * 주민등록번호 13자리 입력</span>
										</div> -->
									</td>
								</tr>
								<tr>
									<th>비밀번호</th>
									<td>
										<input type="password" name="CardPass" class="input_text tcenter" maxlength="2" style="width:90px;" placeholder="앞 2자리" <%=onlyKeys%> value="" />
										<span style="color:#ee0000"> * 비밀번호 앞 2자리 입력</span>
									</td>
								</tr>
								<%End If%>

								<%If DKPG_PGCOMPANY = "NICEPAY" Then%>
								<tr>
									<th>생년월일</th>
									<td>
										<select name="birthYY" class="vmiddle input_text" style="width:100px;">
											<option value="">년</option>
											<%For i = MIN_YEAR To MAX_YEAR%>
												<option value="<%=i%>" ><%=i%></option>
											<%Next%>
										</select>
										<select name="birthMM" class="vmiddle input_text" style="width:70px;">
											<option value="">월</option>
											<%For j = 1 To 12%>
												<%jsmm = Right("0"&j,2)%>
												<option value="<%=jsmm%>" ><%=jsmm%></option>
											<%Next%>
										</select>
										<select name="birthDD" class="vmiddle input_text" style="width:70px;">
											<option value="">일</option>
											<%For k = 1 To 31%>
												<%ksdd = Right("0"&k,2)%>
												<option value="<%=ksdd%>"><%=ksdd%></option>
											<%Next%>
										</select>
										<!-- <span style="color:#ee0000"> * 생년월일 입력</span> -->
									</td>
								</tr>
								<tr>
									<th>비밀번호</th>
									<td>
										<input type="password" name="CardPass" class="input_text tcenter" maxlength="2" style="width:90px;" placeholder="앞 2자리" <%=onlyKeys%> value="" />
										<span class="red"> * 비밀번호 앞 2자리 입력</span>
									</td>
								</tr>
								<%End If%>

								<%If DKPG_PGCOMPANY = "ONOFFKOREA" Then%>
								<tr>
									<th rowspan="2">카드구분</th>
									<td>
										<label><input type="radio" name="cardKind" value="P" onclick="chgCardKind(this.value)" class="input_radio" checked="checked" /> 개인카드</label>
										<label><input type="radio" name="cardKind" value="C" onclick="chgCardKind(this.value)" class="input_radio" /> 법인사업자</label>
										<!-- <label><input type="radio" name="cardKind" value="I" onclick="chgCardKind(this.value)" class="input_radio" /> 개인사업자</label> -->
									</td>
								</tr>
								<tr>
									<td>
										<div id="CardKind01">
											<select name="birthYY" class="vmiddle input_text" style="width:100px;">
												<option value="">년</option>
												<%For i = MIN_YEAR To MAX_YEAR%>
													<option value="<%=i%>" ><%=i%></option>
												<%Next%>
											</select>
											<select name="birthMM" class="vmiddle input_text" style="width:70px;">
												<option value="">월</option>
												<%For j = 1 To 12%>
													<%jsmm = Right("0"&j,2)%>
													<option value="<%=jsmm%>" ><%=jsmm%></option>
												<%Next%>
											</select>
											<select name="birthDD" class="vmiddle input_text" style="width:70px;">
												<option value="">일</option>
												<%For k = 1 To 31%>
													<%ksdd = Right("0"&k,2)%>
													<option value="<%=ksdd%>"><%=ksdd%></option>
												<%Next%>
											</select>
											<span style="color:#ee0000"> * 생년월일 입력</span>
										</div>
										<div id="CardKind02" style="display:none;">
											<input type="password" name="CorporateNumber" class="input_text" maxlength="10" style="width:200px;" placeholder="사업자등록번호 10자리" <%=onlyKeys%> value="" />
											<span style="color:#ee0000"> * 사업자등록번호 10자리 입력</span>
										</div>
									</td>
								</tr>
								<tr>
									<th>비밀번호</th>
									<td>
										<input type="password" name="CardPass" class="input_text tcenter" maxlength="2" style="width:90px;" placeholder="앞 2자리" <%=onlyKeys%> value="" />
										<span style="color:#ee0000"> * 비밀번호 앞 2자리 입력</span>
									</td>
								</tr>
								<%End If%>

								<tr class="lastTD">
									<th>할부정보</th>
									<td>
										<select name="quotabase" class="selects">
											<%If TOTAL_SUM_PRICE > 49999 Then%>
												<option value="00">일시불</option>
												<option value="02">2개월</option>
												<option value="03">3개월</option>
											<%Else%>
												<option value="00">일시불</option>
											<%End If%>
										</select>
										<span class="f11px" style="margin-left:9px;">신용카드 5만원 이상 할부거래 가능</span>
									</td>
								</tr>
							<%Case Else%>
								<!-- <tr class="lastTD">
									<th>할부정보</th>
									<td>
										<select name="quotabase">
											<%If TOTAL_SUM_PRICE > 49999 Then%>
												<option value="일시불">일시불</option>
												<option value="2개월">2개월</option>
												<option value="3개월">3개월</option>
												<option value="4개월">4개월</option>
												<option value="5개월">5개월</option>
												<option value="6개월">6개월</option>
												<option value="7개월">7개월</option>
												<option value="8개월">8개월</option>
												<option value="9개월">9개월</option>
												<option value="10개월">10개월</option>
												<option value="11개월">11개월</option>
												<option value="12개월">12개월</option>
											<%Else%>
											<option value="일시불">일시불</option>
											<%End If%>
										</select>
										<span class="f11px" style="margin-left:9px;">신용카드 5만원 이상 할부거래 가능</span>
									</td>
								</tr> -->
						<%End Select%>
					</table>
				</div>
				<div id="BankInfo" class="width100" style="display:none;">
					<table <%=tableatt%> class="width100">
						<col width="180" />
						<col width="*" />
						<tr>
							<th><%=LNG_SHOP_ORDER_DIRECT_PAY_13%></th>
							<td>
							<%If DK_MEMBER_TYPE = "COMPANY" Then	'CS은행정보%>
								<ul class="bankInfo">
								<%
'									SQL_B = "SELECT A.[BankCode],A.[BankName],A.[BankPenName],A.[BankAccountNumber] FROM [tbl_BankForCompany] AS A"

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
									<li><label><input type="radio" name="bankidx" class="input_radio" value="<%=arr_BankCode%>,<%=arr_BankName%>,<%=arr_BankPenName%>,<%=arr_BankAccountNumber%>" /> <%=arr_BankName%> | <strong><%=arr_BankAccountNumber%></strong> | <%=arr_BankPenName%></label>
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
									<li><label><input type="radio" name="bankidx" class="input_radio" value="<%=arrList_B(0,i)%>" /> <%=arrList_B(1,i)%> | <strong><%=arrList_B(2,i)%></strong> | <%=arrList_B(3,i)%></label>
								<%
										Next
									End If
								%>
								</ul>
							<%End If%>
							</td>
						</tr><tr>
							<th><%=LNG_SHOP_ORDER_DIRECT_PAY_14%></th>
							<td><input type="text" name="bankingName" class="input_text" /></td>
						</tr><tr class="lastTD">
							<th><%=LNG_CS_ORDERS_TRANSFER_DATE%></th>
							<!-- <td><input type='text' name='memo1' value="" class='input_text readonly' onclick="openCalendar(event, this, 'YYYY-MM-DD');" readonly="readonly"></td> -->
							<td><input type='text' id="DDATE" name='memo1' value="" class='input_text readonly' readonly="readonly"></td>
						</tr>
					</table>
				</div>
				<div id="Agreement">
					<p class="f11px ag">·<%=LNG_SHOP_ORDER_DIRECT_PAY_15%> (<span style="color:#d75623;"><%=LNG_SHOP_ORDER_DIRECT_PAY_16%></span>)</p>
					<div class="AgreementBox">
						-<%=LNG_SHOP_ORDER_DIRECT_PAY_17%><br />
						-<%=LNG_SHOP_ORDER_DIRECT_PAY_18%><br />
						-<%=LNG_SHOP_ORDER_DIRECT_PAY_19%><br />
						-<%=LNG_SHOP_ORDER_DIRECT_PAY_20%>
					</div>
					<p style="margin-top:8px;text-align:right; padding-left:30px; color:#d75623;"><label><input type="checkbox" name="gAgreement" value="T" class="input_chk" /> <%=LNG_SHOP_ORDER_DIRECT_PAY_21%></label></p>
				</div>
			</div>
			<div class="fleft" style="width:35%;">
				<div class="cleft width100 cart_btn">
					<div class="tit"><%=LNG_SHOP_ORDER_DIRECT_TITLE_07%></div>
					<div class="PriceArea"><span id="payArea"><%=num2cur(TOTAL_SUM_PRICE)%></span><span class="won" style="display:inline-block;"><%=Chg_CurrencyISO%></span></div>
					<div class="btnArea">
						<span><input type="button" class="txtBtnC large gray border1" onclick="javascript:history.back();" value="<%=LNG_SHOP_ORDER_DIRECT_PAY_23%>"/></span>
						<span class="pL10"><input type="submit" class="txtBtnC large red" value="<%=LNG_SHOP_ORDER_DIRECT_PAY_22%>"/> </span>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>


<input type="hidden" name="gopaymethod" value="">

<input type="hidden" name="totalPrice" value="<%=TOTAL_SUM_PRICE%>" readonly="readonly"/>
<input type="hidden" name="totalDelivery" value="<%=TOTAL_DeliveryFee%>" readonly="readonly"/>
<input type="hidden" name="GoodsPrice" value="<%=TOTAL_Price%>" />
<input type="hidden" name="DeliveryFeeType" value="<%=txt_DeliveryFeeType%>" />
<input type="hidden" name="totalOptionPrice" value="<%=TOTAL_OptionPrice%>" />
<input type="hidden" name="totalOptionPrice2" value="<%=TOTAL_OptionPrice2%>" />
<input type="hidden" name="totalPoint" value="<%=TOTAL_Point%>" />
<input type="hidden" name="totalVotePoint" value="0" />
<input type="hidden" name="strOption" value="<%=strOption%>" />
<input type="hidden" name="OrdNo" value="<%=orderNum%>" />
<input type="hidden" name="SellerID" value="<%=DKRS_strShopID%>" />



<input type="hidden" name="CSGoodCnt" value="<%=CSGoodCnt%>" readonly="readonly"/>
<input type="hidden" name="isSpecialSell" value="F" />

<input type="hidden" name="ori_price" value="<%=TOTAL_SUM_PRICE%>" readonly="readonly"/>
<input type="hidden" name="ori_delivery" value="<%=TOTAL_DeliveryFee%>" readonly="readonly"/>
<input type="hidden" name="input_mode" value="" />
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
				<%'키인결제용 S%>
				<!-- <input type="hidden" name="paymethod" value="CARD" readonly="readonly"/>
				<input type="hidden" name="goodsname" value="<%=arrList_GoodsName%>" readonly="readonly" /> -->
                <input type="hidden" name="regnumber" value="" readonly="readonly"/>
                <input type="hidden" name="cardpw" value="" readonly="readonly"/>
				<input type="hidden" name="cardquota" value="00" readonly="readonly"/>
				<input type="hidden" name="malluserid" value="<%=DK_MEMBER_ID%>" readonly="readonly" />
				<%'키인결제용 E%>

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
					encodeParameters = "CardNo,CardExpire,CardPwd"              '암호화대상항목 (변경불가)

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
				<input type="hidden" name="PayMethod" value="" readonly="readonly"/>						<!-- 결제 수단CARD, BANK, CELLPHONE, VBANK-->
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
				<input type="hidden" name="VbankExpDate" value="<%=tomorrow%>" readonly="readonly" />				 <!-- 가상계좌입금만료일 -->
				<input type="hidden" name="BuyerEmail" value="" readonly="readonly" />					            <!-- 구매자 이메일 -->
				<input type="hidden" name="GoodsCl" value="0" readonly="readonly" />								<!-- 상품구분(실물(1),컨텐츠(0)) -->
				<input type="hidden" name="TransType" value="0" readonly="readonly" />								<!-- 일반(0)/에스크로(1) -->

				<!-- 변경 불가능 -->
				<input type="hidden" name="EncodeParameters" value="<%=encodeParameters%>" readonly="readonly" />		<!-- 암호화대상항목 -->
				<input type="hidden" id="EdiDate" name="EdiDate"  value="<%=ediDate%>" readonly="readonly"/>			<!-- 전문 생성일시 -->
				<input type="hidden" id="EncryptData" name="EncryptData"  value="<%=hashString%>"  readonly="readonly" /><!-- 해쉬값 -->
				<input type="hidden" name="TrKey" value="" readonly="readonly" />										<!-- 필드만 필요 -->
				<input type="hidden" name="SocketYN" value="Y" readonly="readonly" />									<!-- 소켓통신 유무-->
				<input type="hidden" name="MerchantKey" value="<%=merchantKey%>" readonly="readonly" />					<!-- 상점 키 -->
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
				<%If DK_MEMBER_TYPE ="COMPANY" And DKPG_KEYIN = "T" And DK_MEMBER_STYPE = "0" Then%>
					<input type="hidden" name="CPID" size="50" maxlength="50" value="<%=DKPG_PGIDS_SHOP_KEYIN%>" style="IME-MODE:disabled" readonly="readonly"/>
					<input type="hidden" name="CPID_CARD"  size="50" maxlength="50" value="<%=DKPG_PGIDS_SHOP_KEYIN%>" style="IME-MODE:disabled" readonly="readonly"/>
					<input type="hidden" name="BILLTYPE" size="10" maxlength="2"  value="1" style="IME-MODE:disabled" readonly="readonly"/>
					<input type="hidden" name="keyin" size="5" value="CERT" style="IME-MODE:disabled" readonly="readonly"/>
				<%Else%>
					<input type="hidden" name="CPID" size="50" maxlength="50" value="<%=DKPG_PGIDS_SHOP%>" style="IME-MODE:disabled" readonly="readonly"/>
					<input type="hidden" name="CPID_CARD"  size="50" maxlength="50" value="<%=DKPG_PGIDS_SHOP%>" style="IME-MODE:disabled" readonly="readonly"/>
					<input type="hidden" name="BILLTYPE" size="10" maxlength="2"  value="1" style="IME-MODE:disabled" />
				<%End If%>
				<!-- CPID 치환 -->
				<input type="hidden" name="CPID_VBANK" size="50" maxlength="50" value="PGIDS가상" style="IME-MODE:disabled" readonly="readonly"/>
				<input type="hidden" name="CPID_DBANK" size="50" maxlength="50" value="PGIDS실시간" style="IME-MODE:disabled" readonly="readonly"/>

				<input type="hidden" name="ORDERNO" size="50" maxlength="50"value="<%=orderNum%>" style="IME-MODE:disabled" />
				<input type="hidden" name="PRODUCTTYPE" size="10" maxlength="2" value="2" style="IME-MODE:disabled" />
				<input type="hidden" name="AMOUNT" size="10" maxlength="10" value="<%=TOTAL_SUM_PRICE%>" style="IME-MODE:disabled" onkeypress="fnNumCheck();" />
				<input type="hidden" name="quotaopt" value="12" />

				<input type="hidden" name="TAXFREECD" value="00" />
				<input type="hidden" name="EMAIL" size="100" maxlength="100" value="" />
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
				<input type="hidden" name="HOMEURL" value="http://<%=houUrl%>/PG/DAOU/order_finish.asp?orderIDX=<%=orderNum%>" />
				<input type="hidden" name="FAILURL" value="http://<%=houUrl%>/PG/DAOU/order_failed.asp">
				<input type="hidden" name="DIRECTRESULTFLAG" value="" />

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



			<%Case "SPEEDPAY", "YESPAY"%>
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

<%
	'◆ #3. SHOP 주문 임시테이블 정보 가격정보 UPDATE
		arrParams = Array(_
			Db.makeParam("@OrderNum",adVarChar,adParamInput,20,orderNum),_
			Db.makeParam("@totalPrice",adDouble,adParamInput,16,TOTAL_SUM_PRICE), _
			Db.makeParam("@intIDX",adInteger,adParamInput,4,orderTempIDX), _
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


<!--#include virtual="/_include/copyright.asp" -->
