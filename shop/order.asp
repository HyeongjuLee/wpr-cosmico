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
	Call noCache

	'If webproIP <> "T" Then  Call ALERTS("쇼핑몰 구매 테스트중입니다.","back","")

	inUidx = Trim(pRequestTF("cuidx",True))
	If inUidx = "" Then Call ALERTS(LNG_SHOP_ORDER_DIRECT_01_01,"GO","/shop/cart.asp")

	arrUidx = Split(inUidx,",")

%>

<script type="text/javascript">
	//매출구분 선택
	function chgSellCode(value) {
		var f = document.oFrm;
		f.v_SellCode.value = value;
		f.submit();
	}
</script>
<%'매출구분 reload COSMICO%>
<form action="" id="oFrm" name="oFrm" method="post">
	<input type="hidden" name="cuidx" value="<%=inUidx%>" readonly="readonly">
	<input type="hidden" name="v_SellCode" value="" readonly="readonly">
</form>
<%
	'COSMICO 매출구분
	'- 본인 직급 VIP 이하인 판매원의 매출의 경우 회원매출이며, VIP 달성 이후 회원매출, VIP매출를 선택하여 등록할 수 있다.
	'- 판매등록시 VIP매출의 경우 본인의 현직급에 따른 판매금액을 적용하여 구매가 가능하다.
	'- 최종 구매 페이지에서 매출구분을 선택할 수 있으며, 해당 매출 구분의 선택에 따라 구매 및 결제하여야 하는 금액이 변경된다.
	'- 소비자의 경우 VIP 달성 이후 VIP 매출만 등록이 가능하며, 자동으로 VIP 매출로 처리한다. (매출선택 없음)

	v_SellCode = Trim(pRequestTF("v_SellCode",False))
	IF v_SellCode = "" Then v_SellCode = "01"
	If nowGradeCnt >= 20 Then
		If Sell_Mem_TF = 1 Then v_SellCode = "02"
	End If
%>
<%

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
				strZip		= DKRS("strZip")
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
				strZip		= DKRS("Addcode1")
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
				strZip		= ""
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
				If strEmail		<> "" Then strEmail		= objEncrypter.Decrypt(strEmail)
			On Error GoTo 0
		Set objEncrypter = Nothing
	End If

	If strTel = "" Or IsNull(strTel) Then strTel = ""
	If strMobile = "" Or IsNull(strMobile) Then strMobile = ""


	orderNum = Replace(makeOrderNo(),"MT","DK")

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
<link rel="stylesheet" href="/css/order.css?v0" />

<meta http-equiv="Cache-Control" content="no-cache"/>
<meta http-equiv="Expires" content="0"/>
<meta http-equiv="Pragma" content="no-cache"/>
<meta http-equiv="X-UA-Compatible" content="requiresActiveX=true" />
<%
Select Case UCase(DK_MEMBER_NATIONCODE)
	Case "KR"
		Select Case DKPG_PGCOMPANY
			Case "DAOU"
				BODYLOAD = "init();"
				FORMDATA = "<form name=""frmConfirm"" id=""frmConfirm"" onsubmit=""return fnSubmit();"" method=""post"">"
				If DK_MEMBER_TYPE = "COMPANY" And DKPG_KEYIN = "T" Then
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
		<script type="text/javascript" src="order_mComplex.js?v3"></script>

		<%
			Case "ONOFFKOREA"
				BODYLOAD = ""
				FORMDATA = "<form name=""orderFrm"" id=""orderFrm"" onsubmit=""return orderSubmit(this);"" method=""post"">"
		%>
		<script type="text/javascript" src="/PG/ONOFFKOREA/pay.js?v3.3"></script>
		<script type="text/javascript" src="order_mComplex.js?v1"></script>
		<script type="text/javascript" src="cashReceipt.js?v531"></script>
		<%
			Case "NICEPAY"
				BODYLOAD = ""
				FORMDATA = "<form name=""payForm"" id=""payForm"" method=""post"" action=""/PG/NICEPAY/payResult.asp"" onsubmit=""return orderSubmit(this);"">"
		%>
		<script src="https://web.nicepay.co.kr/flex/js/nicepay_tr_utf.js" type="text/javascript"></script>
		<script type="text/javascript" src="/PG/NICEPAY/pay.js?v1"></script>
		<%
			Case "KSNET"
				BODYLOAD = ""
				PRINT "<script type=""text/javascript"" src=""/PG/KSNET/pay.js?v1.2""></script>"
				FORMDATA = "<form name=""orderFrm"" id=""orderFrm"" method=""post"" action=""/PG/inbank_Result.asp"" onsubmit=""return orderSubmit(this);"">"
		%>
		<script language="javascript" src="https://kspay.ksnet.to/store/KSPayWebV1.4/js/kspay_web_ssl.js"></script>
		<script type="text/javascript" src="order_mComplex.js?v1"></script>
		<%
			Case "PAYTAG"
				BODYLOAD = ""
				PRINT "<script type=""text/javascript"" src=""/PG/PAYTAG/pay.js?v0.1""></script>"
				FORMDATA = "<form name=""orderFrm"" id=""orderFrm"" method=""post"" action="""" onsubmit=""return orderSubmit(this);"">"
		%>
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
<script type="text/javascript" src="/jscript/calendar.js"></script>
<script type="text/javascript" src="/shop/orderCalc.js?v2"></script>
<%
	If webproIP <> "T" Then
		Call No_Refresh()
	End If
%>
</head>
<!-- <body onLoad="ordererDeliveryInfo();<%=BODYLOAD%>"  <%=mouseLock()%>> -->
<body onLoad="baseDeliveryInfo();<%=BODYLOAD%>"  <%=mouseLock()%>>
<%
	If webproIP="T" Then
		PRINT "<div style=""position:absolute; top:150px; left:0;"">"
		Call ResRW(DKPG_PGMOD,"PG_MODE")
		Call ResRW(DKPG_PGCOMPANY,"연결PG사")
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
<!--#include virtual="/_include/header.asp" -->
<%=FORMDATA%>
<div id="loadingPro">
	<div class="loadingImg"><img src="<%=IMG%>/159.gif" width="80" alt="loadingImg" /></div>
</div>
<input type="hidden" name="cuidx" value="<%=inUidx%>" />
<input type="hidden" name="pageType" value="" />
<input type="hidden" name="ori_strName" value="<%=backword_br(strName)%>" readonly="readonly"/>
<input type="hidden" name="ori_strTel" value="<%=strTel%>" readonly="readonly"/>
<input type="hidden" name="ori_strMobile" value="<%=strMobile%>" readonly="readonly"/>
<input type="hidden" name="ori_strZip" value="<%=strZip%>" readonly="readonly"/>
<input type="hidden" name="ori_strADDR1" value="<%=strADDR1%>" readonly="readonly"/>
<input type="hidden" name="ori_strADDR2" value="<%=strADDR2%>" readonly="readonly"/>
<input type="hidden" name="DIRECT_PICKUP_USE_TF" value="<%=DIRECT_PICKUP_USE_TF%>" readonly="readonly"/>
<input type="hidden" name="SHOP_ORDERINFO_VIEW_TF" value="<%=SHOP_ORDERINFO_VIEW_TF%>" readonly="readonly"/>

<div id="order">
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
		<%
			If DK_MEMBER_ID <> "" Then
				cart_id = DK_MEMBER_ID
				cart_method = "MEMBER"
			Else
				cart_id = DK_MEMBER_IDX
				cart_method = "NOTMEM"
			End If

			TOTAL_DeliveryFee = 0 	'최종 배송금액
			TOTAL_OptionPrice =  0
			TOTAL_OptionPrice2 =  0
			TOTAL_Price = 0 				'상품가(옵션가 포함)
			TOTAL_Point =  0
			TOTAL_GOODS_PRICE = 0
			TOTAL_SUM_PRICE = 0			'최종 결제금액
			''TOTAL_USEPOINT_PRICE = 0
			TOTAL_PV = 0
			TOTAL_GV = 0

			CSGoodCnt = 0
			TOTAL_GOODS_CNT = 0
			First_GoodsName = ""
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
					arrList_isDirect			= arrList(48,i)
					arrList_DelTF				= arrList(49,i)
					arrList_isAccept			= arrList(50,i)

					arrList_TOTAL_SHOPCNT		= arrList(51,i)	'add

					If arrList_isCSGoods = "T" Then CSGoodCnt = CSGoodCnt + 1

					'##################################################################
					' 회원레벨별 상품가격 변경
					'################################################################## START
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
					'##################################################################	END


					'##################################################################
					' 상품 재고상태 확인
					'################################################################## START
					If arrList_DelTF = "T" Then Call ALERTS(LNG_SHOP_ORDER_WISHLIST_TEXT03 & LNG_STRTEXT_TEXT02,"BACK","")
					If arrList_isAccept <> "T" Then Call ALERTS(LNG_SHOP_ORDER_DIRECT_06 & LNG_STRTEXT_TEXT02,"BACK","")
					If arrList_GoodsViewTF <> "T" Then Call ALERTS(LNG_SHOP_ORDER_DIRECT_05 & LNG_STRTEXT_TEXT02,"BACK","")

					Select Case arrList_GoodsStockType
						Case "I"
						Case "N"
							If Int(arrList_GoodsStockNum) < Int(arrList_orderEa) Then
								Call ALERTS(LNG_SHOP_DETAILVIEW_06 & LNG_STRTEXT_TEXT02,"BACK","")
							End If
						Case "S"
							Call ALERTS(LNG_SHOP_DETAILVIEW_BTN_SOLDOUT & LNG_STRTEXT_TEXT02,"BACK","")
						Case Else : Call ALERTS(LNG_JS_INVALID_DATA & LNG_STRTEXT_TEXT02,"BACK","")
					End Select

					'상품갯수 체크
					If arrList_orderEa < 1 Then Call ALERTS(LNG_CS_CART_JS06,"back","")

					'▣상품최소구매갯수 체크!!
					If arrList_orderEa < arrList_intMinimum Then Call ALERTS(LNG_SHOP_DETAILVIEW_07,"back","")
					'##################################################################	END


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

					If arrList_flagBest	= "T" Then printGoodsIcon = printGoodsIcon & "<span class=""icons"">"&viewImg(IMG_ICON&"/i_bestT.gif",31,11,"")&"</span>"
					If arrList_flagNew	= "T" Then printGoodsIcon = printGoodsIcon & "<span class=""icons"">"&viewImg(IMG_ICON&"/i_newT.gif",31,11,"")&"</span>"
					If arrList_FlagVote	= "T" Then printGoodsIcon = printGoodsIcon & "<span class=""icons"">"&viewImg(IMG_ICON&"/i_voteT.gif",31,11,"")&"</span>"
					If (DK_MEMBER_TYPE = "COMPANY" And DK_MEMBER_STYPE = "0") Or DK_MEMBER_TYPE ="ADMIN" Then
						'If arrList_isCSGoods = "T" Then printGoodsIcon = printGoodsIcon & "<span class=""icons"">"&viewImg(IMG_ICON&"/i_csgoodsT.gif",50,11,"")&"</span>"
					End If
					'################################################################## END


					'##################################################################
					' 루프내 가격 초기화
					'################################################################## START
					self_GoodsPrice = 0
					self_GoodsPoint = 0
					self_GoodsOptionPrice = 0
					self_GoodsOptionPrice2 = 0
					self_TOTAL_PRICE = 0
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
					vipPrice = 0	'COSMICO

					If arrList_isCSGoods = "T" Then
						'▣CS상품정보 변동정보 통합
						arrParams = Array(_
							Db.makeParam("@ncode",adVarChar,adParamInput,20,arrList_CSGoodsCode) _
						)
						Set DKRS = Db.execRs("HJP_CSGOODS_PRICE_INFO",DB_PROC,arrParams,DB3)
						If Not DKRS.BOF And Not DKRS.EOF Then
							arr_CS_ncode		= DKRS("ncode")
							arr_CS_price		= DKRS("price")		'소비자가
							arr_CS_price2		= DKRS("price2")
							arr_CS_price4		= DKRS("price4")
							arr_CS_price5		= DKRS("price5")
							arr_CS_price6		= DKRS("price6")		'COSMICO VIP 가
							arr_CS_price7		= DKRS("price7")		'COSMICO 셀러 가
							arr_CS_price8		= DKRS("price8")		'COSMICO 매니저 가
							arr_CS_price9		= DKRS("price9")		'COSMICO 지점장 가
							arr_CS_price10		= DKRS("price10")	'COSMICO 본부장 가

							arr_CS_SellCode		= DKRS("SellCode")
							arr_CS_SellTypeName	= DKRS("SellTypeName")
							If arr_CS_SellTypeName <> "" Then
								arr_CS_SellTypeName = LNG_SHOP_ORDER_DIRECT_PAY_04&" : "&arr_CS_SellTypeName
							End If

							'COSMICO VIP 매출가
							Select Case nowGradeCnt
								Case "20"	vipPrice = arr_CS_price6
								Case "30"	vipPrice = arr_CS_price7
								Case "40"	vipPrice = arr_CS_price8
								Case "50"	vipPrice = arr_CS_price9
								Case "60"	vipPrice = arr_CS_price10
								Case Else vipPrice = 0
							End Select

						End If
						Call closeRs(DKRS)

						'▣ 소비자 가격
						If CONST_CS_SOBIJA_PRICE_USE_TF = "T" Then
							If DK_MEMBER_STYPE = "1" And arrList_isCSGoods = "T" Then
								arrList_GoodsPrice = arrList_GoodsCustomer
								arr_CS_price2 = arr_CS_price
							End If
						End If

						'CS판매금액과 쇼핑몰등록된 CS판매금 비교
						If arrList_isCSGoods = "T" And (arr_CS_price2 <> arrList_GoodsPrice) Then Call ALERTS(LNG_SHOP_DETAILVIEW_JS_DIFFERENT_PRICE,"back","")
						If arrList_GoodsPrice < 1 Or arr_CS_price2 < 1 Then Call ALERTS(LNG_SHOP_DETAILVIEW_JS_NO_PRICE,"back","")

						'▣구매종류가 다른 상품은 구매불가	Fn_DistinctData▣
						'If arr_CS_SellCode = "" Then arr_CS_SellCode = "NONE"
							LAST_CS_SellCode = CStr(arr_CS_SellCode)
							ALL_CS_SellCode  = ALL_CS_SellCode & arr_CS_SellCode &","

						'COSMICO VIP 매출가
						IF v_SellCode = "02" Then
							arrList_GoodsPrice = vipPrice
						End If

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
						sum_optionPrice2 = CDbl(sum_optionPrice2) + CDbl(arrOption(2))
					Next
					'################################################################## END

					'##################################################################
					' 상품별 금액/적립금 확인
					'################################################################## START
					self_GoodsPrice = Int(arrList_orderEa) * CDbl(arrList_GoodsPrice)						'@@@@@@@@@@@@@@@@@@@@@@@@@
					self_GoodsPoint = Int(arrList_orderEa) * Int(arrList_GoodsPoint)
					self_GoodsOptionPrice = Int(arrList_orderEa) * CDbl(sum_optionPrice)
					self_GoodsOptionPrice2 = Int(arrList_orderEa) * CDbl(sum_optionPrice2)
					self_TOTAL_PRICE = self_GoodsPrice + self_GoodsOptionPrice
					self_PV = Int(arrList_orderEa) * Int(arr_CS_price4)
					self_GV = Int(arrList_orderEa) * Int(arr_CS_price5)
					'################################################################## END

					'##################################################################
					' 배송비 확인
					'################################################################## START
					Select Case arrList_GoodsDeliveryType
						Case "SINGLE"
							self_DeliveryFee = Int(arrList_orderEa) * CDbl(arrList_GoodsDeliveryFee)
							txt_DeliveryFeeType = LNG_SHOP_ORDER_DIRECT_TABLE_08	'단독배송
							txt_self_DeliveryFee = " "&num2cur(self_DeliveryFee)&" "&Chg_currencyISO
							txt_DeliveryFee = "<span class=""tweight"">"&txt_DeliveryFeeType& "<br />"&txt_self_DeliveryFee&"</span>"
							'*상품별 배송비
							''txt_DeliveryFeeEach = "<span class=""deliveryeach"">("&LNG_CS_ORDERS_DELIVERY_PRICE&" "&num2cur(self_DeliveryFee)&" "&Chg_currencyISO&")</span>"
							DKRS2_intDeliveryFee = arrList_GoodsDeliveryFee		'BASIC_DeliveryFee (each)

							arrList_DELICNT = 1

						Case "BASIC"
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

							If arrList_DELICNT > 1 Then
								arrParams3 = Array(_
									Db.makeParam("@cart_method",adVarChar,adParamInput,10,cart_method), _
									Db.makeParam("@MEMTYPE",adVarChar,adParamInput,50,cart_id), _
									Db.makeParam("@strShopID",adVarChar,adParamInput,30,arrList_strShopID), _
									Db.makeParam("@GoodsDeliveryType",adVarChar,adParamInput,6,arrList_GoodsDeliveryType) _
								)
								arrList3 = Db.execRsList("DKSP_ORDER_DELIVERY_CALC",DB_PROC,arrParams3,listLen3,Nothing)
								self_TOTAL_PRICE = 0
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
							''If self_GoodsPrice >= DKRS2_intDeliveryFeeLimit Then
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

					TOTAL_Price = TOTAL_Price + self_GoodsPrice + self_GoodsOptionPrice
					''TOTAL_USEPOINT_PRICE = TOTAL_USEPOINT_PRICE + self_GoodsPrice + self_GoodsOptionPrice
					TOTAL_OptionPrice = TOTAL_OptionPrice + self_GoodsOptionPrice
					TOTAL_OptionPrice2 = TOTAL_OptionPrice2 + self_GoodsOptionPrice2
					TOTAL_GOODS_PRICE = TOTAL_GOODS_PRICE + self_GoodsPrice
					TOTAL_POINT = TOTAL_POINT + self_GoodsPoint

					TOTAL_PV = TOTAL_PV + self_PV
					TOTAL_GV = TOTAL_GV + self_GV

		%>
		<%
				'COSMICO VIP
				Item_Discount = "GradeCnt : "&nowGradeCnt
				Item_SellCode = v_SellCode
				IF Item_SellCode <> "02" Then Item_Discount = "No Discount"

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
							Db.makeParam("@Item_Discount",adVarChar,adParamInput,30,Item_Discount),_
							Db.makeParam("@Item_SellCode",adVarChar,adParamInput,30,Item_SellCode),_
						Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR")_
					)
					Call Db.exec("HJP_ORDER_TEMP_GOODS_SHOP_INSERT_COSMICO",DB_PROC,arrParamsGI,Nothing)		'COSMICO
					'Call Db.exec("HJP_ORDER_TEMP_GOODS_SHOP_INSERT",DB_PROC,arrParamsGI,Nothing)
					OUTPUT_VALUE = arrParams(UBound(arrParams))(4)

					If OUTPUT_VALUE = "ERROR" Then
						Call ALERTS(LNG_CS_ORDERS_ALERT04,"BACK","")
						Exit For
					End If

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
						<!-- <p><%=printGoodsIcon%></p> -->
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
				<td class="tright bor_l">
					<%If v_SellCode = "02" Then%><span class="blue2 tweight"><%=LNG_VIP%></span> :	<%End If%>
					<%=spans(num2cur(self_GoodsPrice/arrList_orderEa),"#222222","12","400")%><%=spans(""&Chg_currencyISO&"","#222222","11","400")%>
					<!-- <%If nowGradeCnt >= 20 And vipPrice > 0 Then 'COSMICO%>
						<br /><%=LNG_VIP%> :  <%=spans(num2cur(vipPrice),"#222222","12","400")%><%=spans(""&Chg_currencyISO&"","#222222","11","400")%>
					<%End If%> -->
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
					<input type="hidden" name="self_GoodsPrice" id="self_GoodsPrice_<%=attrShopID%>" value="<%=self_GoodsPrice%>" readonly="readonly" />
					<input type="hidden" name="self_PV" id="self_PV_<%=attrShopID%>" value="<%=self_PV%>" readonly="readonly" />
					<input type="hidden" name="ea" value="<%=arrList_orderEa%>" readonly="readonly"/>
					<input type="hidden" name="DeliveryType" value="<%=arrList_GoodsDeliveryType%>" readonly="readonly" />
					<input type="hidden" name="BASIC_DeliveryFeeLimit" value="<%=DKRS2_intDeliveryFeeLimit%>" readonly="readonly" />
					<input type="hidden" name="BASIC_DeliveryFee" value="<%=DKRS2_intDeliveryFee%>" readonly="readonly" />
				</td>
				<td class="tright bor_l">
					<%If v_SellCode = "02" Then%><span class="blue2 tweight"><%=LNG_VIP%></span> :	<%End If%>
					<%=spans(num2cur(self_GoodsPrice),"#222222","12","400")%><%=spans(""&Chg_currencyISO&"","#222222","11","400")%>
					<!-- <%If nowGradeCnt >= 20 And vipPrice > 0 Then 'COSMICO%>
						<br /><%=LNG_VIP%> :  <%=spans(num2cur(vipPrice * arrList_orderEa),"#222222","12","400")%><%=spans(""&Chg_currencyISO&"","#222222","11","400")%>
					<%End If%> -->
					<%If v_SellCode <> "02"  Then 'COSMICO%>
						<%If PV_VIEW_TF = "T" Then%>
						<br /><%=spans(num2curINT(self_PV),"#f2002e","11","400")%><%=spans(""&CS_PV&"","#f2002e","10","400")%>
						<%End If%>
						<%If BV_VIEW_TF = "T" Then%>
						<br /><%=spans(num2curINT(self_GV),"green","11","400")%><%=spans(""&CS_PV2&"","green","10","400")%>
						<%End If%>
					<%End If%>
				</td>
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

					'총 상품 수
					TOTAL_GOODS_CNT = listLen + 1
					'첫 번째 상품 명
					If i=0 Then	First_GoodsName = arrList_GoodsName	End If

				Next

				'상품명
				If TOTAL_GOODS_CNT > 1 Then
					arrList_GoodsName = First_GoodsName&" 외"& TOTAL_GOODS_CNT - 1 &"개"
				Else
					arrList_GoodsName = arrList_GoodsName
				End If

			Else
				Call ALERTS(LNG_SHOP_ORDER_DIRECT_08,"GO","/shop/cart.asp")
			End If


		%>
	</table>
	<%
		'If webproIP="T" Then TOTAL_DeliveryFee = 1120

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
	<!-- <input type="hidden" name="cmoneyUseMax" value="<%=self_TOTAL_PRICE%>"><%'결제시 최대사용 적립금 : 상품가%> -->
	<input type="hidden" name="cmoneyUseMax" value="<%=TOTAL_SUM_PRICE - 1000%>"><%'▣(카드)결제시 최대사용 적립금 : 상품가 → 결제금(배송비포함, 카드결제최소금액세팅  1000)%>
	<input type="hidden" name="ownCmoney" value="<%=checkNumeric(MILEAGE_TOTAL)%>">						<%'GNG 회원 보유 C포인트 (외국회원만) %>
	<input type="hidden" name="ownCmoney2" value="<%=checkNumeric(MILEAGE2_TOTAL)%>"  readonly="readonly"> <%'회원 보유 S포인트:%>
	<input type="hidden" name="orgSettlePrice" value="<%=TOTAL_SUM_PRICE%>"><%' 최초 결제금액%>
	<input type="hidden" name="TOTAL_POINTUSE_MIN" value="<%=TOTAL_POINTUSE_MIN%>"  readonly="readonly"><%'▶ 최소 포인트사용가능 금액%>
	<input type="hidden" name="TOTAL_POINTUSE_MAX" value="<%=TOTAL_POINTUSE_MAX%>"  readonly="readonly"><%'▶ 최대 포인트사용가능 금액%>

	<div class="width100 TotalArea">
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
				<col width="15%" />
				<col width="30%" />
				<col width="*" />
				<col width="30%" />
			</colgroup>
			<tbody>
				<tr>
					<th class="bor_top"><%=LNG_SHOP_ORDER_FINISH_08%></th>
					<td class="bor_l2" colspan="<%=COLSPAN2%>">
						<ul>
							<li><b><%=LNG_SHOP_ORDER_FINISH_09%></b>
								<span><%=num2cur(TOTAL_Price)%></span>
								<span><%=Chg_CurrencyISO%></span>
							</li>
							<!-- <li><span>·<%=LNG_SHOP_ORDER_FINISH_10%> : <span><%=num2cur(TOTAL_OptionPrice)%> <%=Chg_CurrencyISO%></span></li> -->
							<li><b><%=LNG_SHOP_ORDER_FINISH_11%></b>
								<span id="DeliveryAreaID2"><%=num2cur(TOTAL_DeliveryFee)%></span>
								<span><%=Chg_CurrencyISO%></span>
							</li>
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
								<th class="noline"><%=SHOP_POINT%></th>
								<td class="noline tright">
									<span id="viewPoint" class="tweight">0</span><%=Chg_CurrencyISO%>
								</td>
							</tr>
							<!-- <tr>
									<td class="noline"><%=SHOP_POINT2%></td>
									<td class="noline tright"><span id="viewPoint2" class="tweight">0</span> <%=Chg_CurrencyISO%></td>
								</tr> -->
						</table>
					</td>
					<%End If%>
					<td class="bor_l summ" rowspan="2">
						<ul>
							<li class="tit"><%=LNG_SHOP_ORDER_FINISH_13%></li>
							<%If DK_MEMBER_TYPE <> "GUEST" Then%>
							<!-- <li>·<%=LNG_SHOP_ORDER_FINISH_14%> : <span id="viewPoint"><%=num2curINT(TOTAL_Point)%></span> <%=Chg_CurrencyISO%></li> -->
							<%Else%>
							<li>· <%=LNG_SHOP_ORDER_FINISH_14%> : <span id="viewPoint" class="mline"><%=num2curINT(TOTAL_Point)%></span><%=Chg_CurrencyISO%></li>
							<li class="red2">· <%=LNG_SHOP_ORDER_FINISH_15%></li>
							<%End If%>
							<%If v_SellCode <> "02"  Then 'COSMICO%>
								<%If PV_VIEW_TF = "T" Then%>
								<li class="red2">· <%=CS_PV%> : <span><%=num2curINT(TOTAL_PV)%></span><%=CS_PV%></li>
								<%End If%>
								<%If BV_VIEW_TF = "T" Then%>
								<li class="green">·<%=CS_PV2%>: <span><%=num2curINT(TOTAL_GV)%></s> <%=CS_PV2%></li>
								<%End If%>
							<%End If%>
						</ul>
					</td>
				</tr>
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
				<%If isSHOP_POINTUSE = "T" Then%>
				<tr>
					<th class="bor_top"><%=SHOP_POINT%></th>
					<td class="bor_l2 point" colspan="2">
						<%If DK_MEMBER_TYPE <> "GUEST" Then%>
						<div class="point">
							<input type="text" name="useCmoney" class="input_text" onKeyUp="toCurrency(this)" onBlur="toCurrency(this); checkUseCmoney(this);" value="0" />
							<p> 사용가능 <%=SHOP_POINT%> :
								<span class="tweight"><%=num2CurINT(MILEAGE_TOTAL)%></span> <%=SHOP_POINT%>
							</p>
						</div>
						<!-- | <%=LNG_SHOP_ORDER_FINISH_30%> -->
						<br />
						<!-- <input type="text" name="useCmoney2" class="input_gray01" onKeyUp="<%=toCurrency%>(this)" onBlur="<%=toCurrency%>(this); checkUseCmoney2(this);" value="0" /><span> (<%=SHOP_POINT2%> &nbsp;<span class="tweight"><%=num2CurINT(MILEAGE2_TOTAL)%></span> <%=Chg_CurrencyISO%></span>) -->
						<input type="hidden" name="useCmoney2" value="0" />
					</td>
					<%Else%>
					<input type="hidden" name="useCmoney" class="input_gray01" value="0" disabled="disabled" />
					<p>(<%=SHOP_POINT%> <span>-</span><%=Chg_CurrencyISO%>) | <span class="red"><%=LNG_SHOP_ORDER_FINISH_31%></span></p>
					<input type="hidden" name="useCmoney2" class="input_gray01" value="0" disabled="disabled" />
					<p>(<%=SHOP_POINT2%> <span>-</span><%=Chg_CurrencyISO%>) | <span class="red"><%=LNG_SHOP_ORDER_FINISH_31%></span></p>
					</td>
				</tr>
				<%End If%>
				<%Else%>
				<input type="hidden" name="useCmoney" value="0" />
				<input type="hidden" name="useCmoney2" value="0" />
				<%End If%>
				<%'※ point_check%>
				<input type="hidden" name="ori_useCmoney" value="0" readonly="readonly" />
				<input type="hidden" name="useCmoneyTF" value="F" readonly="readonly" />

				<%If DIRECT_PICKUP_USE_TF = "T" Then 'strText %>
					<tr class="selectPay">
						<%If DK_MEMBER_TYPE = "COMPANY" Or DK_MEMBER_TYPE ="ADMIN" Then%>
						<th class="bor_top"><%=LNG_SHOP_ORDER_DIRECT_PAY_10%>&nbsp;<%=startext%></th>
						<td colspan="4" class="bor_l2">
							<select name="DtoD" id="DtoD" class="input_select" onchange="chgDelivery(this.value);">
								<option value="T" selected="selected"><%=LNG_SHOP_ORDER_DIRECT_PAY_11%></option>
								<option value="F"><%=LNG_SHOP_ORDER_DIRECT_PAY_12%></option>
							</select>
						</td>
					</tr>
				<%Else%>
					<input type="hidden" name="DtoD" value="T" />
				<%End If%>
				<%Else %>
					<input type="hidden" name="DtoD" value="T" />
				<%End If %>
			</tbody>
		</table>
	</div>

	<%'COSMICO 매출구분%>
	<%If DK_MEMBER_TYPE = "COMPANY" And CSGoodCnt > 0 Then%>
	<div class="orderInfos">
		<div class="order_title"><%=LNG_TEXT_SALES_TYPE%></div>
		<div class="info" id="deliveryInfo">
			<table <%=tableatt%> class="width100">
				<col width="135" />
				<col width="*" />
				<tbody>
					<tr>
						<th><%=LNG_TEXT_SALES_TYPE%> <%=startext%></th>
						<td>
							<div class="selects">
								<%If nowGradeCnt >= 20 Then 'COSMICO 20(VIP) %>
									<%If Sell_Mem_TF = 1 Then%>
										<label><input type="radio" name="v_SellCode" value="02" class="input_radio" onclick="chgSellCode(this.value);" <%=isChecked(v_SellCode,"02")%> checked="checked" /> VIP매출</label>
									<%Else%>
										<label><input type="radio" name="v_SellCode" value="01" class="input_radio" onclick="chgSellCode(this.value);" <%=isChecked(v_SellCode,"01")%> /> 회원매출</label>
										<label style="padding-left: 10px;"><input type="radio" name="v_SellCode" value="02" class="input_radio" onclick="chgSellCode(this.value);" <%=isChecked(v_SellCode,"02")%> /> VIP매출</label>
									<%End If%>
								<%Else%>
									<label><input type="radio" name="v_SellCode" value="01" class="input_radio" onclick="chgSellCode(this.value);" <%=isChecked(v_SellCode,"01")%> checked="checked"/> 회원매출</label>
								<%End If%>
							</div>
							<%If false Then	'select 형식%>
							<!-- <div class="selects">
								<select name="v_SellCode" class="input_select" onchange="chgSellCode(this.value);">
									<%If nowGradeCnt >= 20 Then 'COSMICO 20(VIP) %>
										<%If Sell_Mem_TF = 1 Then%>
											<option value="02" <%=isSelect(v_SellCode,"02")%> >VIP매출</option>
										<%Else%>
											<option value="01" <%=isSelect(v_SellCode,"01")%> selected="selected">회원매출</option>
											<option value="02" <%=isSelect(v_SellCode,"02")%> >VIP매출</option>
										<%End If%>
									<%Else%>
										<option value="01" <%=isSelect(v_SellCode,"01")%> selected="selected">회원매출</option>
									<%End If%>
								</select>
							</div> -->
							<%End If%>
						</td>
					</tr>
				</tbody>
			</table>
		</div>
	</div>
	<%End If%>

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
						<th><%=LNG_SHOP_ORDER_DIRECT_TABLE_17%> <%=startext%></th>
						<td><input type="text" name="strName" class="input_text" value="<%=backword_br(strName)%>" maxlength="100" /></td>
						<th><%=LNG_SHOP_ORDER_DIRECT_TABLE_18%></th>
						<td>
							<input type="text" class="input_text" name="strTel" maxlength="15" <%=onLyKeys%> value="<%=strTel%>" />
						</td>
					</tr>
					<tr>
						<th><%=LNG_SHOP_ORDER_DIRECT_TABLE_19%> <%=startext%></th>
						<td>
							<input type="text" class="input_text" name="strMobile" maxlength="15" <%=onLyKeys%> value="<%=strMobile%>" />
						</td>
					</tr>
					<tr class="address">
						<th><%=LNG_SHOP_ORDER_DIRECT_TABLE_21%> <%=startext%></th>
						<td class="zipTD" colspan="3">
							<%Select Case UCase(DK_MEMBER_NATIONCODE)%>
								<%Case "KR"%>
									<div>
										<p><input type="text" class="input_text readonly" name="strZip" id="strZipDaum" style="width:80px;" value="<%=strZip%>" maxlength="7" readonly="readonly" />	<span id="takeZipBtn"><a name="modal" href="/m/common/pop_postcode.asp?z=oris" id="pop_postcode" title="우편번호검색"><input type="button" class="detail_btn noline gray" value="우편번호검색"/></a></span></p>
										<p><input type="text" class="input_text readonly width95" name="strADDR1" id="strADDR1Daum" value="<%=strADDR1%>" maxlength="500" readonly="readonly" /></p>
										<p><input type="text" class="input_text width95" name="strADDR2" id="strADDR2Daum" value="<%=strADDR2%>" maxlength="500" /></p>
									</div>
								<%Case "JPTTTTT"%>
									<div>
										<p><input type="text" class="input_text readonly" name="strZip" id="strZip" style="width:80px;" value="<%=strZip%>" maxlength="7" readonly="readonly" <%=onLyKeys3%> /> <input type="button" class="detail_btn noline gray" onclick="openzip_jp2EN('strZip');" value="<%=LNG_TEXT_ZIPCODE%>" /> (ZipCode)</p>
										<p><input type="text" class="input_text width95 readonly" name="strADDR1" id="strADDR1" value="<%=strADDR1%>" maxlength="500" readonly="readonly" /></p>
										<p><input type="text" class="input_text width95" name="strADDR2" id="strADDR2" value="<%=strADDR2%>" maxlength="500" /></p>
									</div>
								<%Case Else%>
									<div>
										<p><input type="text" class="input_text" name="strZip" id="strZip" tyle="width:80px;" value="<%=strZip%>" maxlength="7" <%=onLyKeys3%> /><span style="line-height:28px;"> (ZipCode)</span></p>
										<p><input type="text" class="input_text width95" name="strADDR1" id="strADDR1" value="<%=strADDR1%>" maxlength="500" /></p>
										<p><input type="text" class="input_text width95" name="strADDR2" id="strADDR2" value="<%=strADDR2%>" maxlength="500" /></p>
									</div>
							<%End Select%>
						</td>
					</tr>
					<%If SHOP_ORDERINFO_VIEW_TF = "T" Then%>
					<tr>
						<th><%=LNG_SHOP_ORDER_DIRECT_TABLE_20%> <!-- <%=startext%> --></th>
						<td><input type="text" class="input_text imes width95" name="strEmail" value="<%=strEmail%>" maxlength="200" /></td>
					</tr>
					<%End IF%>
				</tbody>
			</table>
		</div>

		<div class="info" id="deliveryInfo">
			<div class="order_title" >
				<%If DIRECT_PICKUP_USE_TF = "T" Then 'strText %>
				<span class="directpickupTitle" style="display: none;"><%=LNG_SHOP_ORDER_DIRECT_TITLE_04%></span>
				<%End If%>
				<span class="directpickup"><%=LNG_SHOP_ORDER_DIRECT_TITLE_05%></span>
				<div class="directpickup labels label_wrap">
					<!-- <td style="border:none;"><label><input type="radio" name="dInfoType" class="input_radio" value="" onClick="ordererDeliveryInfo(this.form);" checked="checked" /> <%=LNG_TEXT_ORDERER_DELIVERYINFO%></label></td> -->
					<label>
						<input type="radio" name="dInfoType" class="input_radio" value="" onClick="baseDeliveryInfo(this.form);" checked="checked" />
						<i class="icon-ok"></i>
						<span><%=LNG_TEXT_BASE_DELIVERYINFO%></span>
					</label>
					<label>
						<input type="radio" name="dInfoType" class="input_radio" value="" onClick="openDeliveryInfo();" />
						<a name="modal" href="pop_deliveryInfo.asp" id="deliveryInfoModal" title="<%=LNG_TEXT_LATEST_DELIVERYINFO%>" ></a>
						<i class="icon-ok"></i>
						<span><%=LNG_TEXT_LATEST_DELIVERYINFO%></span>
					</label>
					<label>
						<input type="radio" name="dInfoType" class="input_radio" value="" onClick="emptyDeliveryInfo(this.form);" />
						<i class="icon-ok"></i>
						<span><%=LNG_TEXT_DIRECT_INPUT%></span>
					</label>
				</div>
				<!-- <label><input type="checkbox" name="infoCopys" onClick="infoCopy(this);" class="input_chk2"> <%=LNG_SHOP_ORDER_DIRECT_TABLE_22%></label> -->
			</div>
			<table <%=tableatt%> class="width100">
				<col width="135" />
				<col width="*" />
				<col width="135" />
				<col width="*" />
				<tbody>
					<tr>
						<th><%=LNG_SHOP_ORDER_DIRECT_TABLE_17%> <%=startext%></th>
						<td><input type="text" name="takeName" class="input_text" maxlength="100" /></td>
						<th><%=LNG_SHOP_ORDER_DIRECT_TABLE_18%></th>
						<td>
							<input type="text" class="input_text" name="takeTel" maxlength="15" <%=onLyKeys%> value="" />
						</td>
					</tr>
					<tr>
						<th><%=LNG_SHOP_ORDER_DIRECT_TABLE_19%> <%=startext%></th>
						<td>
							<input type="text" class="input_text" name="takeMobile" maxlength="15" <%=onLyKeys%> value="" />
						</td>
						<%If SHOP_ORDERINFO_VIEW_TF <> "T" Then%>
							<th><%=LNG_SHOP_ORDER_DIRECT_TABLE_20%> <!-- <%=startext%> --></th>
							<td><input type="text" class="input_text imes width95" name="strEmail" value="<%=strEmail%>" maxlength="200" /></td>
						<%Else%>
							<th></th>
							<td></td>
						<%End IF%>
					</tr>
					<tr class="directpickup">
						<th><%=LNG_SHOP_ORDER_DIRECT_TABLE_21%> <%=startext%></th>
						<td class="zipTD" colspan="3">
							<%Select Case UCase(DK_MEMBER_NATIONCODE)%>
								<%Case "KR"%>
									<div>
										<p><input type="text" class="input_text readonly" name="takeZip" id="takeZipDaum" style="width:80px;" maxlength="7" readonly="readonly" />	<span id="takeZipBtn"><a name="modal" href="/m/common/pop_postcode.asp?z=takes" id="pop_postcode" title="우편번호검색"><input type="button" class="detail_btn noline gray" value="우편번호검색"/></a></span></p>
										<p><input type="text" class="input_text readonly width95" name="takeADDR1" id="takeADDR1Daum" maxlength="500" readonly="readonly" /></p>
										<p><input type="text" class="input_text width95" name="takeADDR2" id="takeADDR2Daum" maxlength="500" /></p>
									</div>
								<%Case "JPTTTTT"%>
									<div>
										<p><input type="text" class="input_text readonly" name="takeZip" d="takeZip" style="width:80px;" maxlength="7" readonly="readonly" <%=onLyKeys3%> /> <input type="button" class="detail_btn noline gray" onclick="openzip_jp2EN('takeZip');" value="<%=LNG_TEXT_ZIPCODE%>" /> (ZipCode)</p>
										<p><input type="text" class="input_text width95 readonly" name="takeADDR1" id="takeADDR1" maxlength="500" readonly="readonly" /></p>
										<p><input type="text" class="input_text width95" name="takeADDR2" id="takeADDR2" maxlength="500" /></p>
									</div>
								<%Case Else%>
									<div>
										<p><input type="text" class="input_text" name="takeZip" id="takeZip" style="width:80px;" maxlength="7" <%=onLyKeys3%> /><span style="line-height:28px;"> (ZipCode)</span></p>
										<p><input type="text" class="input_text width95" name="takeADDR1" id="takeADDR1" maxlength="500" /></p>
										<p><input type="text" class="input_text width95" name="takeADDR2" id="takeADDR2" maxlength="500" /></p>
									</div>
							<%End Select%>
						</td>
					</tr>
					<tr class="directpickup">
						<th><%=LNG_SHOP_ORDER_DIRECT_TABLE_23%></td>
						<td colspan="3"><input type="text" name="orderMemo" maxlength="100" class="input_text" /></td>
					</tr>
				</tbody>
			</table>
		</div>
	</div>

	<%
		If DK_MEMBER_TYPE = "COMPANY" Then
			'CS은행정보
			SQL_B = "SELECT A.[BankCode],A.[BankName],A.[BankOwnerName],A.[BankAccountNumber] FROM [tbl_BankForCompany] AS A WITH(NOLOCK)"
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
		<div class="width100 selectPay labels label_wrap">
			<%If 1=1 Then%>
				<%If IsArray(arrList_B) Then%>
					<label><input type="radio" name="paykind" value="inBank" onclick="chgPay(this.value)" class="input_radio" />
						<i class="icon-ok"></i><span><%=LNG_SHOP_ORDER_DIRECT_PAY_02%></span>
					</label>
				<%Else%>
					<label><input type="radio" name="paykind" value="inBank" class="input_radio" disabled="disabled" /><i class="icon-ok"></i><span><%=LNG_SHOP_ORDER_DIRECT_PAY_03%></span></label>
				<%End If%>
			<%End If%>

			<%
				If UCase(DK_MEMBER_NATIONCODE) = "KR"	Then   '카드결제는 KR only

				MCOMPLEX_USE_TF = "T"		'♠
			%>
				<label><input type="radio" name="paykind" value="Card" onclick="chgPay(this.value)" class="input_radio" /><i class="icon-ok"></i><span><%=LNG_SHOP_ORDER_DIRECT_PAY_01%></span></label>
				<label><input type="radio" name="paykind" value="mComplex" onclick="chgPay(this.value)" class="input_radio" /><i class="icon-ok"></i><span>다카드결제</span></label>
				<%If 1=2 Then%>
				<label><input type="radio" name="paykind" value="CardAPI" onclick="chgPay(this.value)" class="input_radio" /><i class="icon-ok"></i><span><%=LNG_SHOP_ORDER_DIRECT_PAY_01%> - 수기</span></label>
				<!-- <label><input type="radio" name="paykind" value="CardAPI" onclick="chgPay(this.value)" class="input_radio" /> <%=LNG_SHOP_ORDER_DIRECT_PAY_01%>API</label> -->
				<!-- <label><input type="radio" name="paykind" value="Bank" onclick="chgPay(this.value)" class="input_radio" /> 실시간계좌이체(TEST)</label> -->
				<label><input type="radio" name="paykind" value="vBank" onclick="chgPay(this.value)" class="input_radio" /><i class="icon-ok"></i><span><%=LNG_TEXT_VIRTUAL_ACCOUNT%></span></label>
				<%End If%>
			<%End If%>

			<%'▣포인트 단독결제%>
				<%If DK_MEMBER_TYPE = "COMPANY" And isSHOP_POINTUSE = "T" Then%>
					<%If CDbl(MILEAGE_TOTAL) >= CDbl(TOTAL_SUM_PRICE) Then%>
						<label><input type="radio" name="paykind" value="point" onclick="chgPay(this.value)" class="input_radio"  /><i class="icon-ok"></i><span><%=LNG_CS_ORDERS_TEXT56%></span></label>
						&nbsp;&nbsp;<span id="pointTXT" class="tweight red2 font14px" ></span>
					<%Else%>
						<label><input type="radio" name="paykind" value="point" onclick="chgPay(this.value)" class="input_radio" disabled="disabled" /><i class="icon-ok"></i><span><%=LNG_TEXT_PAYING_POINT2_ALONE%> (포인트 부족)</span></label>
						&nbsp;&nbsp;<span id="pointTXT" class="tweight red2 font14px" ></span>
					<%End If %>
				<%End If %>
			<%
				If DK_MEMBER_TYPE = "COMPANY" And CSGoodCnt > 0 And PG_EXAM_MODE <> "T" Then
					If false  Then  'COSMICO 상단 이동
						PRINT TABS(4)&"<div class=""selects"">"
						PRINT TABS(4)&" <span class="""" style=""padding-left:60px;""> "&LNG_SHOP_ORDER_DIRECT_PAY_04&" : </span>"
						PRINT TABS(4)&" <select name=""v_SellCode"" class=""input_select"">"
						'PRINT TABS(4)&" <option value="""">"&LNG_SHOP_ORDER_DIRECT_PAY_05&"</option>"
							'▣구매종류 선택
							'arrParams = Array(_
							'	Db.makeParam("@SELLCODE",adVarChar,adParamInput,10,arr_CS_SELLCODE) _
							')
							'arrListB = Db.execRsList("DKP_SELLTYPE_LIST2",DB_PROC,arrParams,listLenB,DB3)
							arrListB = Db.execRsList("DKP_SELLTYPE_LIST",DB_PROC,Nothing,listLenB,DB3)
							If IsArray(arrListB) Then
								For i = 0 To listLenB
									PRINT TABS(4)&"	<option value="""&arrListB(0,i)&""">"&arrListB(1,i)&"</option>"
								Next
							Else
								PRINT TABS(4)&"	<option value="""">"&LNG_SHOP_ORDER_DIRECT_PAY_06&"</option>"
							End If
						PRINT TABS(4)&"	</select>"
						PRINT TABS(4)&"</div>"
					End If

					If 1=2 Then '판매센터
						PRINT TABS(4)&"<div class=""select"">"
						PRINT TABS(4)&" <span class=""tweight"" style=""padding-left:50px;""> "&LNG_SHOP_ORDER_DIRECT_PAY_07&" : </span>"
						PRINT TABS(4)&" <select class=""input_select"" name=""SalesCenter"">"
						PRINT TABS(4)&" <option value="""">::: "&LNG_SHOP_ORDER_DIRECT_PAY_08&" :::</option>"
							SQL2 = "SELECT * FROM [tbl_Business] WITH(NOLOCK) WHERE  [U_TF] = 0 And [Na_Code] = ? ORDER BY [name] ASC"
							arrParamsC = Array(Db.makeParam("@Na_Code",adVarChar,adParamInput,10,DK_MEMBER_NATIONCODE))
							arrListC = Db.execRsList(SQL2,DB_TEXT,arrParamsC,listLenC,DB3)
							If IsArray(arrListC) Then
								For i = 0 to listLenC
									PRINT TABS(5)& " <option value="""&arrListC(0,i)&""" >"&arrListC(1,i)&"</option>"
								Next
							Else
								PRINT TABS(4)&"	<option value="""">"&LNG_SHOP_ORDER_DIRECT_PAY_09&"</option>"
							End If
						PRINT TABS(4)&"	</select>"
						PRINT TABS(4)&"</div>"
					End If
			%>
					<input type="hidden" name="SalesCenter" value="" />
			<%
				Else
			%>
			<input type="hidden" name="v_SellCode" value="01" />
			<input type="hidden" name="SalesCenter" value="" />
			<%	End If%>
		</div>
		<div class="cleft width100 payinfoWrap">
			<div class="fleft payTypeLeftArea">
				<%If MCOMPLEX_USE_TF = "T" Then%>
				<div id="mComplexInfo" class="width100" style="display:none;">
					<table <%=tableatt%> class="width100">
						<tr>
							<td style="padding:8px 0px 8px 0px;">
								<input type="hidden" name="mComplexTotalPrice" value="<%=TOTAL_SUM_PRICE%>" readonly="readonly"/>
								<input type="hidden" name="mCardTotal" value="0" readonly="readonly"/>
								<input type="hidden" name="mBankTotal" value="0" readonly="readonly"/>
								<input type="hidden" name="mCashTotal" value="0" readonly="readonly"/>
								<input type="hidden" name="mComplexTotal" value="0" readonly="readonly"/>
								<div class="CardPriceTotal" style="margin-bottom: 8px; ">
									<div class="box red">
										<div class="tit">결제할 금액</div>
										<p>
											<span id="mCardPrice_TXT" class="red2" readonly="readonly"><%=num2cur(TOTAL_SUM_PRICE)%></span><span class="won">원</span>
											<input type="hidden" name="mCardPrice" value="<%=TOTAL_SUM_PRICE%>" maxlength="8" readonly="readonly"/>
										</p>
									</div>
									<div class="box blue">
										<div class="tit">남은 결제금액</div>
										<p>
											<span id="mComplexTotal_TXT" class="blue2" readonly="readonly"><%=num2cur(TOTAL_SUM_PRICE)%></span><span class="won">원</span>
										</p>
									</div>
								</div>
								<%'복합결제-카드%>
								<div class="CardInfo">
									<table <%=tableatt%> class="width100 mComplex">
										<col width="8%" />
										<col width="12%" />
										<col width="27%" />
										<col width="12%" />
										<col width="*" />
										<tr>
											<th rowspan="3" class="tcenter paymethod">카드 #<span class="cardAddNum" >1</span></th>
											<th>금액</th>
											<td>
												<input type="hidden" name="CardVld" value="F" readonly="readonly" />
												<input type="text" title="금액" name="CardPrice" class="input_text" style="width:80px" <%=onlykeys%> value="" />
												<a class="a_submit design3 submitPrice_Card">금액적용</a>
											</td>
											<th>카드번호</th>
											<td>
												<input type="text" title="카드번호 1" name="mCardNo1" class="input_text" style="width:62px" maxlength="4" onkeyup="focus_next_input(this);" value="" <%=onlyKeys%> />
												<input type="password" title="카드번호 2" name="mCardNo2" class="input_text" style="width:62px" maxlength="4" onkeyup="focus_next_input(this);" value="" <%=onlyKeys%> />
												<input type="password" title="카드번호 3" name="mCardNo3" class="input_text" style="width:62px" maxlength="4" onkeyup="focus_next_input(this);" value="" <%=onlyKeys%> />
												<input type="text" title="카드번호 4" name="mCardNo4" class="input_text" style="width:62px" maxlength="4" value="" <%=onlyKeys%> />
											</td>
										</tr><tr>
											<th>유효기간</th>
											<td>
												<select title="유효기간(월)" name="mCardMM" class="vmiddle input_select" style="width:70px;">
													<option value="">월</option>
													<%For j = 1 To 12%>
														<%jsmm = Right("0"&j,2)%>
														<option value="<%=jsmm%>" ><%=jsmm%></option>
													<%Next%>
												</select> /
												<select title="유효기간(년)" name="mCardYY" class="vmiddle input_select" style="width:90px;">
													<option value="">년</option>
													<%For i = THIS_YEAR To EXPIRE_YEAR%>
														<option value="<%=i%>" ><%=i%></option>
													<%Next%>
												</select>
											</td>
											<th>생년월일 <br />(사업자번호)</th>
											<td>
												<input type="text" title="생년월일" name="mCardBirth" class="input_text" style="width:120px" maxlength="10" value="" placeholder="yyyymmdd 형식" <%=onlyKeys%> />
												<br /><span class="font13px">(생년월일 8자리 또는 사업자번호 10자리)</span>
											</td>
										</tr><tr class="line_bot_bold">
											<th>비밀번호</th>
											<td>
												<input type="password" title="비밀번호 앞 2자리" name="mCardPass" class="input_text" style="width:40px" maxlength="2" value="" <%=onlyKeys%> />
												<span class="font13px">(앞2자리)</span>
											</td>
											<th>할부정보</th>
											<td>
												<select name="mQuotabase" class="vmiddle input_select">
													<option value="00">일시불</option>
												</select>
												<span class="font13px" style="margin-left:9px;">신용카드 5만원 이상 할부거래 가능</span>
											</td>
										</tr>
									</table>
								</div>
								<div class="paytypeAddArea">
									<div class ="fleft">
										<a class="a_submit design1 CardAdd" id="CardAdd">카드 추가</a>
										<a class="a_submit design4 CardRmv">마지막카드 삭제</a>
									</div>
									<%If 1=2 Then%>
									<div class ="fright">
										<label><input type="checkbox" name="BankChk" id="BankChk" value="T" class="addChk" ><i class="icon-ok"></i><span>무통장 추가</span></label>
										<label><input type="checkbox" name="CashChk" id="CashChk" value="T" class="addChk" ><i class="icon-ok"></i><span>현금 추가</span></label>
									</div>
									<%End If%>
								</div>
								<%'복합결제-무통장%>
								<div class="BankInfo" style="display:none;">
									<table <%=tableatt%> class="width100 mComplex">
										<col width="8%" />
										<col width="120" />
										<col width="*" />
										<tr class="firstTD">
											<th rowspan="4" class="tcenter paymethodAdd">무통장</span>
											<th>금액</th>
											<td>
												<input type="hidden" name="BankVld" value="F" readonly="readonly" />
												<input type="text" title="금액" name="BankPrice" id="BankPrice" class="input_text" style="width:100px" <%=onlykeys%> value="" />
												<a class="a_submit design3 submitPrice_Bank" >금액적용</a>
											</td>
										</tr>
										<tr>
											</th>
											<th><%=LNG_SHOP_ORDER_DIRECT_PAY_13%></th>
											<td>
												<ul class="bankInfo">
												<%
													'SQL_B = "SELECT A.[BankCode],A.[BankName],A.[BankPenName],A.[BankAccountNumber] FROM [tbl_BankForCompany] AS A WITH(NOLOCK) "
													SQL_B = "SELECT A.[BankCode],A.[BankName],A.[BankOwnerName],A.[BankAccountNumber] FROM [tbl_BankForCompany] AS A WITH(NOLOCK)"
													SQL_B = SQL_B& " JOIN [tbl_Bank] AS B WITH(NOLOCK) ON B.[ncode] = A.[BankCode]"
													SQL_B = SQL_B& " WHERE B.[Na_Code] = ? AND A.[Using_Flag] = 'Y' "		'CS 국가별 회사은행계좌 등록확인!
													arrParams_B = Array(Db.makeParam("@strNationCode",adVarChar,adParaminput,20,UCase(DK_MEMBER_NATIONCODE)))
													arrList_B = Db.execRsList(SQL_B,DB_TEXT,arrParams_B,listLen_B,DB3)

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
													<li><label><input type="radio" name="mBankidx" class="input_radio" value="<%=arr_BankCode%>,<%=arr_BankName%>,<%=arr_BankPenName%>,<%=arr_BankAccountNumber%>" /> <%=arr_BankName%> | <span class="tweight"><%=arr_BankAccountNumber%></span> | <%=arr_BankPenName%></label>
												<%
														Next
													End If
												%>
												</ul>
											</td>
										</tr><tr>
											<th><%=LNG_SHOP_ORDER_DIRECT_PAY_14%></th>
											<td><input type="text" name="mBankingName" class="input_text" maxlength="100" /></td>
										</tr><tr class="lastTD">
											<th><%=LNG_CS_ORDERS_TRANSFER_DATE%></th>
											<td><input type='text' id="mDDATE" name='mMemo1' value="" class='input_text readonly' readonly="readonly"></td>
										</tr>
									</table>
								</div>
								<%'복합결제-현금%>
								<div class="CashInfo" style="display:none;">
									<table <%=tableatt%> class="width100 mComplex">
										<col width="8%" />
										<col width="120" />
										<col width="*" />
										<tr>
											<th rowspan="1" class="tcenter paymethodAdd">현금</span>
											<th>금액</th>
											<td>
												<input type="hidden" name="CashVld" value="F" readonly="readonly" />
												<input type="text" title="금액" name="CashPrice"  id="CashPrice" class="input_text" style="width:100px" <%=onlykeys%> value="" maxlength="8" />
												<a id="submitBankPrice" class="a_submit design3 submitPrice_Cash" >금액적용</a>
											</td>
										</tr>
									</table>
								</div>

							</td>
						</tr>
					</table>
				</div>
				<%End If%>

				<div id="CardInfo" class="width100" style="display:none;">
					<table <%=tableatt%> class="width100">
						<col width="120" />
						<col width="*" />
						<%Select Case DKPG_PGCOMPANY%>
							<%Case "SPEEDPAY","YESPAY","DAOU","NICEPAY","ONOFFKOREA","KSNET","PAYTAG"%>
								<tr>
									<th>카드번호</th>
									<td>
										<input type="text" name="cardNo1" class="input_text tcenter" maxlength="4" onkeyup="focus_next_input(this);" style="width:70px;" placeholder="" <%=onlyKeys%> value="" /> -
										<input type="password" name="cardNo2" class="input_text tcenter" maxlength="4" onkeyup="focus_next_input(this);" style="width:70px;" placeholder="" <%=onlyKeys%> value="" /> -
										<input type="password" name="cardNo3" class="input_text tcenter" maxlength="4" onkeyup="focus_next_input(this);" style="width:70px;" placeholder="" <%=onlyKeys%> value="" /> -
										<input type="text" name="cardNo4" class="input_text tcenter" maxlength="4" style="width:70px;" placeholder="" <%=onlyKeys%> value="" />
									</td>
								</tr><tr>
									<th>유효기간</th>
									<td>
										<select name="card_mm" class="vmiddle input_select" style="width:90px;">
											<option value="">월</option>
											<%For j = 1 To 12%>
												<%jsmm = Right("0"&j,2)%>
												<option value="<%=jsmm%>" ><%=jsmm%></option>
											<%Next%>
										</select> /
										<select name="card_yy" class="vmiddle input_select" style="width:100px;">
											<option value="">년</option>
											<%For i = THIS_YEAR To EXPIRE_YEAR%>
												<option value="<%=i%>" ><%=i%></option>
											<%Next%>
										</select>
									</td>
								</tr>
								<tr>
									<th rowspan="2">카드구분</th>
									<td>
										<label><input type="radio" name="cardKind" value="P" onclick="chgCardKind(this.value)" class="input_radio" checked="checked" /> 일반신용</label>
										<label><input type="radio" name="cardKind" value="C" onclick="chgCardKind(this.value)" class="input_radio" /> 법인사업자</label>
										<label><input type="radio" name="cardKind" value="I" onclick="chgCardKind(this.value)" class="input_radio" /> 개인사업자</label>
									</td>
								</tr>
								<tr>
									<td>
										<div id="CardKind01">
											<select name="birthYY" class="vmiddle input_select" style="width:100px;">
												<option value="">년</option>
												<%For i = MIN_YEAR To MAX_YEAR%>
													<option value="<%=i%>" ><%=i%></option>
												<%Next%>
											</select>
											<select name="birthMM" class="vmiddle input_select" style="width:70px;">
												<option value="">월</option>
												<%For j = 1 To 12%>
													<%jsmm = Right("0"&j,2)%>
													<option value="<%=jsmm%>" ><%=jsmm%></option>
												<%Next%>
											</select>
											<select name="birthDD" class="vmiddle input_select" style="width:70px;">
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
										<input type="password" name="CardPass" class="input_text tcenter" maxlength="2" style="width:40px;" <%=onlyKeys%> value="" />
										<span style="color:#ee0000"> * 비밀번호 앞 2자리 입력</span>
									</td>
								</tr>

								<tr class="lastTD">
									<th>할부정보</th>
									<td>
										<select name="quotabase" class="vmiddle input_select">
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
												<option value="11">11개월</option>
												<option value="12">12개월</option>
											<%Else%>
												<option value="00">일시불</option>
											<%End If%>
										</select>
										<span class="font13px" style="margin-left:9px;">신용카드 5만원 이상 할부거래 가능</span>
									</td>
								</tr>
							<%Case Else%>
						<%End Select%>
					</table>
				</div>
				<div id="BankInfo" class="width100" style="display:none;">
					<table <%=tableatt%> class="width100">
						<col width="120" />
						<col width="*" />
						<tr>
							<th><%=LNG_SHOP_ORDER_DIRECT_PAY_13%></th>
							<td>
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
									<li><label><input type="radio" name="bankidx" class="input_radio" value="<%=arr_BankCode%>,<%=arr_BankName%>,<%=arr_BankPenName%>,<%=arr_BankAccountNumber%>" /> <%=arr_BankName%> | <span class="tweight"><%=arr_BankAccountNumber%></span> | <%=arr_BankPenName%></label>
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
									<li><label><input type="radio" name="bankidx" class="input_radio" value="<%=arrList_B(0,i)%>" /> <%=arrList_B(1,i)%> | <span class="tweight"><%=arrList_B(2,i)%></sp> | <%=arrList_B(3,i)%></label>
								<%
										Next
									End If
								%>
								</ul>
							<%End If%>
							</td>
						</tr><tr>
							<th><%=LNG_SHOP_ORDER_DIRECT_PAY_14%></th>
							<td><input type="text" name="bankingName" class="input_text" maxlength="100" /></td>
						</tr><tr class="lastTD">
							<th><%=LNG_CS_ORDERS_TRANSFER_DATE%></th>
							<!-- <td><input type='text' name='memo1' value="" class='input_text readonly' onclick="openCalendar(event, this, 'YYYY-MM-DD');" readonly="readonly"></td> -->
							<td><input type='text' id="DDATE" name='memo1' value="" class='input_text readonly' readonly="readonly"></td>
						</tr>
					</table>
				</div>
				<%If UCase(DKPG_PGCOMPANY) = "KSNET" Or UCase(DKPG_PGCOMPANY) = "ONOFFKOREA" Then%>
				<div id="vBankInfo" class="width100" style="display:none;">
					<table <%=tableatt%> class="width100">
						<col width="120" />
						<col width="*" />
						<tr>
							<th><%=LNG_CS_ORDERS_BANK_NAME%></th>
							<td>
								<select name="vBankCode" class="vmiddle input_text">
									<option value="" selected>-- 선택--</option>
										<option value="003">기업은행</option>
										<option value="004">국민은행</option>
										<option value="007">수협</option>
										<option value="011">농협은행</option>
										<option value="020">우리은행</option>
										<option value="023">SC제일은행</option>
										<option value="026">신한은행</option>
										<option value="032">부산은행</option>
										<option value="034">광주은행</option>
										<option value="071">우체국</option>
										<option value="081">하나은행</option>
										<!-- <option value="088">신한은행</option> -->
								</select>
								<p class="red2">※ 가상계좌 발급 후 2일 이내까지 입금이 가능합니다.</p>
							</td>
						</tr>

						<tr>
							<th><%=LNG_SHOP_ORDER_DIRECT_PAY_14%></th>
							<td><input type="text" name="vBankDepName" class="input_text" maxlength="100" /></td>
						</tr>
						<tr class="lastTD">
							<th>입금만료시간</th>
							<td>
								<span class="red tweight"><%=Left(DateAdd("d",1,now()),10)%> 23:59:59 까지 입금하지 않으면 주문이 취소됩니다.</span>
								<%
									vBankDepDate = Replace(Left(DateAdd("d",1,now()),10),"-","")
									vBankDepDate = vBankDepDate&"235959"
								%>
								<input type="hidden" name="vBankDepDate" value="<%=vBankDepDate%>" readonly="readonly"/>
							</td>
						</tr>
					</table>
				</div>
				<%End If%>

				<%'현금영수증 추가 inBank, vBank %>
				<div id="CashReceiptInfo" class="width100" style="display:none;">
					<table <%=tableatt%> class="width100">
						<col width="120" />
						<col width="*" />
							<tr class="lastTD"><%'개발%>
								<th>현금영수증</th>
								<td>
									<div>
										<label><input type="radio" name="receiptInfoTF" value="T" class="input_radio" /> 신청하기</label>
										<label style="margin-left:11px;"><input type="radio" name="receiptInfoTF" value="F" class="input_radio" checked="checked" /> 신청안함</label>
									</div>
									<div style="display:none;margin-top:11px;" id="receiptInfo" >
										<div>
											<label><input type="radio" name="receiptType" value="P" class="input_radio" /> 개인소득공제용</label>
											<label style="margin-left:11px;"><input type="radio" name="receiptType" value="C" class="input_radio" /> 사업자증빙용(세금계산서용)</label>
										</div>
										<div class="ReceiptP" style="display:none;margin-top:11px">
											<select name="receiptPType" class="vmiddle input_text">
												<option value="hpNum">휴대폰번호</option>
												<option value="ssNum">주민등록번호</option>
												<%If false Then%>
												<!-- <option value="CdNum">현금영수증카드번호</option> -->
												<%End If%>
											</select>
											<span class="hpNum" style="margin-left:11px;">
												<input type="text" name="recriptHp1" class="input_text" value="" maxlength="3" style="width:90px">
												- <input type="text" name="recriptHp2" class="input_text" value="" maxlength="4" style="width:110px">
												- <input type="text" name="recriptHp3" class="input_text" value="" maxlength="4" style="width:110px">
											</span>
											<span class="ssNum" style="display:none; margin-left:11px;">
												<input type="text" name="recriptSn1" class="input_text" value="" maxlength="6" style="width:140px">
												- <input type="password" name="recriptSn2" class="input_text" value="" maxlength="7" style="width:170px">
											</span>
											<span class="CdNum" style="display:none; margin-left:11px;">
												<input type="text" name="recriptCd1" class="input_text" value=""   maxlength="4" style="width:70px">
												- <input type="text" name="recriptCd2" class="input_text" value="" maxlength="4" style="width:70px">
												- <input type="text" name="recriptCd3" class="input_text" value="" maxlength="4" style="width:70px">
												- <input type="text" name="recriptCd4" class="input_text" value="" maxlength="4" style="width:70px">
											</span>

										</div>
										<div class="ReceiptC" style="display:none; margin-top:11px;">
											사업자 등록번호
											: <input type="text" name="recriptCn1" class="input_text" value="" maxlength="3" style="width:80px">
											- <input type="text" name="recriptCn2" class="input_text" value="" maxlength="2" style="width:70px">
											- <input type="text" name="recriptCn3" class="input_text" value="" maxlength="5" style="width:120px">
										</div>
									</div>
								</td>
							</tr>
					</table>
				</div>

				<div id="Agreement">
					<div class="ag">·<%=LNG_SHOP_ORDER_DIRECT_PAY_15%>
						<div class="fright"><label class="yesagree ya00"><input type="checkbox" name="gAgreement" value="T" class="input_chk" style="width: 18px;height: 18px;" /> <%=LNG_SHOP_ORDER_DIRECT_PAY_21%></label></div>
					</div>
					<div class="AgreementBox">
						-<span style="color:#d75623;"><%=LNG_SHOP_ORDER_DIRECT_PAY_16%></span><br />
						-<%=LNG_SHOP_ORDER_DIRECT_PAY_17%><br />
						-<%=LNG_SHOP_ORDER_DIRECT_PAY_18%><br />
						-<%=LNG_SHOP_ORDER_DIRECT_PAY_19%><br />
						-<%=LNG_SHOP_ORDER_DIRECT_PAY_20%>
					</div>
				</div>
				<%
				IF UCase(DK_MEMBER_NATIONCODE) = "KR" THEN
					'▣PG사 수기결제 약관처리
					PG_POLICY_VIEW_01 = "F" : PG_POLICY_VIEW_02 = "F" :	PG_POLICY_VIEW_03 = "F"
					Select Case DKPG_PGCOMPANY
						Case "PAYTAG"
							PG_POLICY_VIEW_01 = "T" : PG_POLICY_VIEW_02 = "T" :	PG_POLICY_VIEW_03 = "T"
							PG_POLICY_TYPE_01 = "PAYTAG01" : PG_POLICY_TYPE_02 = "PAYTAG02" : PG_POLICY_TYPE_03 = "PAYTAG03"
							PG_POLICY_TITLE_01 = "전자 금융거래 이용약관 동의"
							PG_POLICY_TITLE_02 = "개인정보취급방침 동의"
							PG_POLICY_TITLE_03 = "서비스 이용약관 동의"
						Case "KSNET"
							PG_POLICY_VIEW_01 = "T"
							PG_POLICY_TYPE_01 = "KSNET01"
							PG_POLICY_TITLE_01 = "전자 금융거래 이용약관 동의"

					End Select
				%>
					<div id="PG_POLICY_AREA" style="display:none;">
						<%If PG_POLICY_VIEW_01 = "T" Then%>
							<div id="PGAgreement">
								<div class="ag">·<%=PG_POLICY_TITLE_01%>
									<div class="fright">
										<a name="modal" href="/common/pop_policy.asp?pt=<%=PG_POLICY_TYPE_01%>" title="<%=PG_POLICY_TITLE_01%>"><input type="button" class="txtBtn small" value="자세히보기" /></a>
										<label class="yesagree ya01"><input type="checkbox" name="pAgreement01" value="T" class="input_chk" /> <%=LNG_TEXT_I_AGREE%></label>
									</div>
								</div>
							</div>
						<%End If%>
						<%If PG_POLICY_VIEW_02 = "T" Then%>
							<div id="PGAgreement">
								<div class="ag">·<%=PG_POLICY_TITLE_02%>
									<div class="fright">
										<a name="modal" href="/common/pop_policy.asp?pt=<%=PG_POLICY_TYPE_02%>" title="<%=PG_POLICY_TITLE_02%>"><input type="button" class="txtBtn small" value="자세히보기" /></a>
										<label class="yesagree ya02"><input type="checkbox" name="pAgreement02" value="T" class="input_chk" /> <%=LNG_TEXT_I_AGREE%></label>
									</div>
								</div>
							</div>
						<%End If%>
						<%If PG_POLICY_VIEW_03 = "T" Then%>
							<div id="PGAgreement">
								<div class="ag">·<%=PG_POLICY_TITLE_03%>
									<div class="fright">
										<a name="modal" href="/common/pop_policy.asp?pt=<%=PG_POLICY_TYPE_03%>" title="<%=PG_POLICY_TITLE_03%>"><input type="button" class="txtBtn small" value="자세히보기" /></a>
										<label class="yesagree ya03"><input type="checkbox" name="pAgreement03" value="T" class="input_chk" /> <%=LNG_TEXT_I_AGREE%></label>
									</div>
								</div>
							</div>
						<%End If%>
					</div>

				<%End If%>
			</div>
			<div class="fleft totals" style="width:35%;">
				<div class="tit"><%=LNG_SHOP_ORDER_DIRECT_TITLE_07%></div>
				<div class="PriceArea"><span id="payArea"><%=num2cur(TOTAL_SUM_PRICE)%></span><span class="won"><%=Chg_CurrencyISO%></span></div>
				<div class="btnZone">
					<input type="button" class="cancel" onclick="javascript:history.back();" value="<%=LNG_SHOP_ORDER_DIRECT_PAY_23%>"/>
					<input type="submit" class="order" value="<%=LNG_SHOP_ORDER_DIRECT_PAY_22%>"/>
				</div>
			</div>
		</div>
	</div>
</div>


<input type="hidden" name="gopaymethod" value="">

<input type="hidden" name="totalPrice" value="<%=TOTAL_SUM_PRICE%>" readonly="readonly"/>
<input type="hidden" name="totalDelivery" value="<%=TOTAL_DeliveryFee%>" readonly="readonly"/>
<input type="hidden" name="GoodsPrice" value="<%=TOTAL_Price%>" readonly="readonly"/>
<input type="hidden" name="DeliveryFeeType" value="<%=txt_DeliveryFeeType%>" readonly="readonly"/>
<input type="hidden" name="totalOptionPrice" value="<%=TOTAL_OptionPrice%>" readonly="readonly"/>
<input type="hidden" name="totalOptionPrice2" value="<%=TOTAL_OptionPrice2%>" readonly="readonly"/>
<input type="hidden" name="totalPoint" value="<%=TOTAL_Point%>" readonly="readonly"/>
<input type="hidden" name="totalVotePoint" value="0" readonly="readonly"/>
<input type="hidden" name="strOption" value="<%=strOption%>" readonly="readonly"/>
<input type="hidden" name="OrdNo" value="<%=orderNum%>" readonly="readonly"/>
<input type="hidden" name="SellerID" value="<%=DKRS_strShopID%>" readonly="readonly"/>



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
					<!-- <input type="hidden" name="keyin" size="5" value="CERT" style="IME-MODE:disabled" readonly="readonly"/> -->
					<input type="hidden" name="keyin" size="5" value="" style="IME-MODE:disabled" readonly="readonly"/>
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
				<input type="hidden" name="HOMEURL" value="<%=HTTPS%>://<%=houUrl%>/PG/DAOU/order_finish.asp?orderIDX=<%=orderNum%>" />
				<input type="hidden" name="FAILURL" value="<%=HTTPS%>://<%=houUrl%>/PG/DAOU/order_failed.asp">
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
				<%
					'* ORDERNO : 주문번호 [필수항목] // 주문번호를 입력하시면 됩니다.
					'* PRODUCTTYPE : 상품구분 [필수항목] // 상품구분을 입력하시면 됩니다.
					'* BILLTYPE : 과금유형(1:일반) [필수항목] // 과금유형을 입력하시면 됩니다.
					'* TAXFREECD : 비과세결제유무[선택항목] // 결제하려는 금액의 과세유무 // 00:과세, 01:비과세
					'* AMOUNT : 결제금액[필수항목] // 결제금액을 입력하시면 됩니다.
					'* EMAIL : 고객 E-MAIL(결제결과 통보 Default) [선택항목] // 고객 E-MAIL를 입력하시면 됩니다.
					'* USERID : 고객ID [선택항목] // 고객아이디를 입력하시면 됩니다.
					'* USERNAME : 고객명 [선택항목] // 고객명를 입력하시면 됩니다.
					'* PRODUCTCODE : 상품코드 [선택항목]	// 상품코드를 입력하시면 됩니다.
					'* PRODUCTNAME : 상품명[선택항목] // 상품명을 입력하시면 됩니다.
					'* TELNO1 : 고객전화번호[선택항목] // 고객전화번호를 입력하시면 됩니다.
					'* TELNO2 : 고객휴대폰번호[선택항목] // 고객휴대폰번호를 입력하시면 됩니다.
					'* RESERVEDINDEX1 : 예약항목1(내부에서 INDEX로 관리)[선택항목] // 예약항목1을 입력하시면 됩니다.
					'* RESERVEDINDEX2 : 예약항목2(내부에서 INDEX로 관리)[선택항목] // 예약항목2를 입력하시면 됩니다.
					'* RESERVEDSTRING : 예약항목(내부에서 INDEX로 관리)[선택항목] // 예약항목을 입력하시면 됩니다.
					'* RETURNURL : 결제완료 url[선택항목] // 결제 완료 후, 이동할 url(팝업으로 결제창을 오픈한 메인 화면)
					'* DIRECTRESULTFLAG : 결제완료 url[필수항목] // 결제 완료 후, 이동할 url(팝업)
					'나머지 상점 옵션값 <br>
					'kcp_noint :		   <input type=text name=kcp_noint value=""><br>
					'kcp_noint_quota  : <input type=text name=kcp_noint_quota   value=""><br>
					'QUOTAOPT         : <input type=text name=quotaopt         value=""><br>
					'fix_inst         : <input type=text name=fix_inst         value=""><br>
					'not_used_card    : <input type=text name=not_used_card    value=""><br>
					'save_ocb         : <input type=text name=save_ocb         value=""><br>
					'used_card_YN     : <input type=text name=used_card_YN   value=""><br>
					'used_card        : <input type=text name=used_card         value=""><br>
					'eng_flag         : <input type=text name=eng_flag         value=""><br>
					'kcp_site_logo	 : <input type=text name=kcp_site_logo         value="">(카드결제창 좌측상단 노출될 이미지(미입력시 다우페이 이미지  출력))<br>
					'kcp_site_img	 : <input type=text name=kcp_site_img         value="">(카드결제창 좌측하당 노출될 이미지(미입력시 다우페이 이미지 출력))<br>
				%>

			<%Case "SPEEDPAY", "YESPAY"%>
				<input type="hidden" name="GoodsName" value="<%=arrList_GoodsName%>" readonly="readonly" />
				<input type="hidden" name="MEMBER_STYPE" value="<%=DK_MEMBER_STYPE%>" readonly="readonly"/>
				<input type="hidden" name="payAmount" size="10" maxlength="10" value="<%=TOTAL_SUM_PRICE%>" readonly="readonly"/>

			<%Case "ONOFFKOREA","PAYTAG"%>
				<input type="hidden" name="GoodsName" value="<%=arrList_GoodsName%>" readonly="readonly"/>

			<%Case "KSNET"%>
				<input type="hidden" name="GoodsName" value="<%=arrList_GoodsName%>" />

				<input type="hidden" name="sndPaymethod" id="sndPaymethod" value="" readonly="readonly" />

				<!-- <input type="hidden" name="sndStoreid" value="2999199999" size="15" maxlength="10" readonly="readonly">	<%'상점아이디 : 테스트용 아이디: 2999199999 (테스트이후 실제발급아이디로 변경)%> -->
				<input type="hidden" name="sndStoreid" value="<%=TX_KSNET_TID%>" size="15" maxlength="10" readonly="readonly">		<%'상점아이디 : 실거래 아이디, 신용카드(계좌이체,가상계좌)%>
				<input type="hidden" name="sndOrdernumber" value="<%=orderNum%>" size="30" readonly="readonly">	<%'주문번호%>
				<input type="hidden" name="sndGoodname" value="<%=arrList_GoodsName%>" size="30" readonly="readonly">
				<input type="hidden" name="sndAmount" value="<%=TOTAL_SUM_PRICE%>" size="15" maxlength="9" readonly="readonly">
				<input type="hidden" name="sndOrdername" value="<%=DK_MEMBER_NAME%>" size="30" readonly="readonly">	<%'주문자명%>
				<input type="hidden" name="sndEmail" value="" size="30" readonly="readonly">	<%'KSPAY에서 결제정보를 메일로 보내줍니다.(신용카드거래에만 해당)%>
				<input type="hidden" name="sndMobile" value="" size="12" maxlength="12" readonly="readonly">


				<!------------------------------ <Part 2. 추가설정항목(메뉴얼참조)>  ---------------------------------->

				<!-- 0. 공통 환경설정 -->
				<input type="hidden"	name="sndReply"    value="<%=HTTPS%>://<%=houUrl%>" style="width:500px;" readonly="readonly">
				<input type="hidden"	name="sndReply_ORI"    value="<%=HTTPS%>://<%=houUrl%>" style="width:500px;" readonly="readonly"><%'WEBPRO 추가%>
				<input type="hidden"	name="iframeYn"    value="Y" readonly="readonly">
				<input type="hidden"	name="sndCharSet"  value="utf-8" readonly="readonly"> <!-- 가맹점 CharSet 설정변수 -->
				<input type="hidden"  name="sndGoodType" value="1" readonly="readonly"> 	<!-- 상품유형: 실물(1),디지털(2) -->

				<!-- 1. 신용카드 관련설정 -->

				<!-- 신용카드 결제방법  -->
				<!-- 일반적인 업체의 경우 ISP,안심결제만 사용하면 되며 다른 결제방법 추가시에는 사전에 협의이후 적용바랍니다 -->
				<input type="hidden"  name=sndShowcard value="C" readonly="readonly">

				<!-- 신용카드(해외카드) 통화코드: 해외카드결제시 달러결제를 사용할경우 변경 -->
				<input type="hidden"	name=sndCurrencytype value="WON" readonly="readonly"> <!-- 원화(WON), 달러(USD) -->

				<!-- 할부개월수 선택범위 -->
				<!--상점에서 적용할 할부개월수를 세팅합니다. 여기서 세팅하신 값은 결제창에서 고객이 스크롤하여 선택하게 됩니다 -->
				<!--아래의 예의경우 고객은 0~12개월의 할부거래를 선택할수있게 됩니다. -->
				<input type="hidden"	name=sndInstallmenttype value="ALL(0:2:3:4:5:6:7:8:9:10:11:12)" readonly="readonly">

				<!-- 가맹점부담 무이자할부설정 -->
				<!-- 카드사 무이자행사만 이용하실경우  또는 무이자 할부를 적용하지 않는 업체는  "NONE"로 세팅  -->
				<!-- 예 : 전체카드사 및 전체 할부에대해서 무이자 적용할 때는 value="ALL" / 무이자 미적용할 때는 value="NONE" -->
				<!-- 예 : 전체카드사 3,4,5,6개월 무이자 적용할 때는 value="ALL(3:4:5:6)" -->
				<!-- 예 : 삼성카드(카드사코드:04) 2,3개월 무이자 적용할 때는 value="04(3:4:5:6)"-->
				<!-- <input type="hidden"	name=sndInteresttype value="10(02:03),05(06)"> -->
				<input type="hidden"	name=sndInteresttype value="NONE" readonly="readonly">

				<!-- 카카오페이 사용시 필수 세팅 값 -->
				<input type="hidden" name=sndStoreCeoName         value="" readonly="readonly">  <!--  카카오페이용 상점대표자명 -->
				<input type="hidden" name=sndStorePhoneNo         value="" readonly="readonly">  <!--  카카오페이 연락처 -->
				<input type="hidden" name=sndStoreAddress         value="" readonly="readonly">  <!--  카카오페이 주소 -->

				<!-- 2. 온라인입금(가상계좌) 관련설정 -->
				<input type="hidden"	name=sndEscrow value="0" readonly="readonly"> 			        <!-- 에스크로사용여부 (0:사용안함, 1:사용) -->

				<!-- 3. 계좌이체 현금영수증발급여부 설정 -->
				<input type="hidden"  name=sndCashReceipt value="0" readonly="readonly">          <!--계좌이체시 현금영수증 발급여부 (0: 발급안함, 1:발급) -->


				<!----------------------------------------------- <Part 3. 승인응답 결과데이터>  ----------------------------------------------->
				<!-- 결과데이타: 승인이후 자동으로 채워집니다. (*변수명을 변경하지 마세요) -->

				<input type="hidden" name=reWHCid 	value="" readonly="readonly">
				<input type="hidden" name=reWHCtype 	value="" readonly="readonly">
				<input type="hidden" name=reWHHash 	value="" readonly="readonly">

				<!--------------------------------------------------------------------------------------------------------------------------->

				<!--업체에서 추가하고자하는 임의의 파라미터를 입력하면 됩니다.-->
				<!--이 파라메터들은 지정된결과 페이지(kspay_result.asp)로 전송됩니다.-->
				<input type="hidden" name=a        value="a1" readonly="readonly">
				<input type="hidden" name=b        value="b1" readonly="readonly">
				<input type="hidden" name=c        value="c1" readonly="readonly">
				<input type="hidden" name=d        value="d1" readonly="readonly">
				<!--------------------------------------------------------------------------------------------------------------------------->

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
			Db.makeParam("@deliveryFee",adDouble,adParamInput,16,TOTAL_DeliveryFee), _
			Db.makeParam("@intIDX",adInteger,adParamInput,4,orderTempIDX), _
			Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
		)
		Call Db.exec("HJP_ORDER_TOTAL_PRICE_SHOP_UPDATE2",DB_PROC,arrParams,Nothing)
		''Call Db.exec("HJP_ORDER_TOTAL_PRICE_SHOP_UPDATE",DB_PROC,arrParams,Nothing)
		OUTPUT_VALUE3 = arrParams(Ubound(arrParams))(4)
		Select Case OUTPUT_VALUE3
			Case "FINISH"
			Case "ERROR" : Call ALERTS(LNG_CS_ORDERS_ALERT06,"BACK","")
			Case "NOTORDER" : Call ALERTS(LNG_CS_ORDERS_ALERT07,"BACK","")
		End Select
%>

<script type="text/javascript" src="order.bottom.js?v5"></script>

<%
	MODAL_BORDER_THICKNESS = 1
%>
<!--#include virtual="/_include/modal_config.asp" -->
<!--#include virtual="/_include/copyright.asp" -->
