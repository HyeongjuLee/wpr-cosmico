<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	Call FN_NationCurrency(DK_MEMBER_NATIONCODE,Chg_CurrencyName,Chg_CurrencyISO)

	PAGE_SETTING = "SHOP"

	GoodsIDX = Trim(pRequestTF("Gidx",True))
	strOption = Trim(pRequestTF("goodsOption",False))
	orderEa = Trim(pRequestTF("ea",True))


	Call M_ONLY_MEMBER_DETAILVIEW(DK_MEMBER_LEVEL,GoodsIDX)


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

	Call noCache


	If GoodsIDX = "" Then Call alerts(LNG_SHOP_ORDER_DIRECT_01,"go","/index.asp")

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
				strzip		= cutZip(DKRS("Addcode1"))		'CS우편번호
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
				If strADDR2		<> "" Then straddr2			= objEncrypter.Decrypt(strADDR2)
				If strTel		<> "" Then strTel			= objEncrypter.Decrypt(strTel)
				If strMobile	<> "" Then strMobile		= objEncrypter.Decrypt(strMobile)
				If strEmail		<> "" Then strEmail			= objEncrypter.Decrypt(strEmail)

				If DK_MEMBER_TYPE = "COMPANY" And DKCONF_ISCSNEW = "T" Then	'▣CS신버전 암/복호화 추가
					If strEmail		<> "" Then strEmail		= objEncrypter.Decrypt(strEmail)
				End If
			On Error GoTo 0
		Set objEncrypter = Nothing
	End If


	If strTel = "" Or IsNull(strTel) Then strTel = "--"
	If strMobile = "" Or IsNull(strMobile) Then strMobile = "--"
	arrTel = Split(strTel,"-")
	arrMobile = Split(strMobile,"-")
	If UBound(arrTel) <> 2 Then arrTel = Array("","","")
	If UBound(arrMobile) <> 2 Then arrMobile = Array("","","")

	orderNum = makeOrderNo()


	arrParams = Array(_
		Db.makeParam("@intIDX",adInteger,adParamInput,0,GoodsIDX) _
	)
	Set DKRS = Db.execRs("DKP_ORDER_DIRECT_GOODS_INFO",DB_PROC,arrParams,Nothing)

	If Not DKRS.BOF Or Not DKRS.EOF Then
		DKRS_intIDX						= DKRS("intIDX")
		DKRS_Category					= DKRS("Category")
		DKRS_GoodsName					= DKRS("GoodsName")
		DKRS_GoodsPrice					= DKRS("GoodsPrice")
		DKRS_GoodsStockType				= DKRS("GoodsStockType")
		DKRS_GoodsStockNum				= DKRS("GoodsStockNum")
		DKRS_GoodsPoint					= DKRS("GoodsPoint")
		DKRS_GoodsViewTF				= DKRS("GoodsViewTF")
		DKRS_flagBest					= DKRS("flagBest")
		DKRS_flagNew					= DKRS("flagNew")
		DKRS_FlagVote					= DKRS("FlagVote")
		DKRS_GoodsDeliveryType			= DKRS("GoodsDeliveryType")
		DKRS_GoodsDeliveryFee			= DKRS("GoodsDeliveryFee")
		DKRS_isCSGoods					= DKRS("isCSGoods")
		DKRS_CSGoodsCode				= DKRS("CSGoodsCode")
		DKRS_isShopType					= DKRS("isShopType")
		DKRS_strShopID					= DKRS("strShopID")
		DKRS_isAccept					= DKRS("isAccept")
		DKRS_ImgThum					= DKRS("ImgThum")
		DKRS_intPriceNot				= DKRS("intPriceNot")
		DKRS_intPriceAuth				= DKRS("intPriceAuth")
		DKRS_intPriceDeal				= DKRS("intPriceDeal")
		DKRS_intPriceVIP				= DKRS("intPriceVIP")
		DKRS_intMinNot					= DKRS("intMinNot")
		DKRS_intMinAuth					= DKRS("intMinAuth")
		DKRS_intMinDeal					= DKRS("intMinDeal")
		DKRS_intMinVIP					= DKRS("intMinVIP")
		DKRS_intPointNot				= DKRS("intPointNot")
		DKRS_intPointAuth				= DKRS("intPointAuth")
		DKRS_intPointDeal				= DKRS("intPointDeal")
		DKRS_intPointVIP				= DKRS("intPointVIP")
		DKRS_isImgType					= DKRS("isImgType")
	Else
		Call ALERTS(LNG_SHOP_ORDER_DIRECT_05,"GO","/index.asp")
	End If
	Call CloseRS(DKRS)
	If DKRS_isAccept <> "T" Then Call ALERTS(LNG_SHOP_ORDER_DIRECT_06,"GO","/index.asp")

	Select Case DK_MEMBER_LEVEL
		Case 0,1 '비회원, 일반회원
			DKRS_GoodsPrice = DKRS_intPriceNot
			DKRS_GoodsPoint = DKRS_intPointNot
			DKRS_intMinimum = DKRS_intMinNot
		Case 2 '인증회원
			DKRS_GoodsPrice = DKRS_intPriceAuth
			DKRS_GoodsPoint = DKRS_intPointAuth
			DKRS_intMinimum = DKRS_intMinAuth
		Case 3 '딜러회원
			DKRS_GoodsPrice = DKRS_intPriceDeal
			DKRS_GoodsPoint = DKRS_intPointDeal
			DKRS_intMinimum = DKRS_intMinDeal
		Case 4,5 'VIP 회원
			DKRS_GoodsPrice = DKRS_intPriceVIP
			DKRS_GoodsPoint = DKRS_intPointVIP
			DKRS_intMinimum = DKRS_intMinVIP
		Case 9,10,11
			DKRS_GoodsPrice = DKRS_intPriceVIP
			DKRS_GoodsPoint = DKRS_intPointVIP
			DKRS_intMinimum = DKRS_intMinVIP
	End Select



'	If DKRS_isShopType = "S" Then
'		arrParams = Array(_
'			Db.makeParam("@strUserID",adInteger,adParamInput,0,GoodsIDX) _
'		)
'		sellerState = Db.execRsData("DKP_VENDOR_STATE_CHECK",DB_PROC,arrParams,Nothing)
'		If sellerState <> "101" Then Call ALERTS("허가되지 않은 판매자의 상품입니다.","GO","/index.asp")
'	End If

	'▣▣허가된 판매차 체크(본사 아닌경우)▣▣
	If DKRS_isShopType = "S" Then
		SQL = "SELECT COUNT(*) FROM [DK_VENDOR] WHERE [strShopID] = ? AND [sellerState] = '101' "
		arrParams = Array(_
			Db.makeParam("@strShopID",adVarChar,adParamInput,30,DKRS_strShopID) _
		)
		ShopIdCheckCnt = Db.execRsData(SQL,DB_TEXT,arrParams,Nothing)
'		If ShopIdCheckCnt = 0 Then Call ALERTS("허가되지 않거나 삭제된 판매자의 상품입니다.","back","")
		If ShopIdCheckCnt = 0 Then Call ALERTS(LNG_SHOP_ORDER_DIRECT_07,"back","")
	End If

	Call Db.beginTrans(Nothing)

		SQL = ""
		SQL = SQL & " INSERT INTO [DK_ORDER_TEMP] ("
		SQL = SQL & "[strDomain],[orderNum],[strIDX],[strUserID] "
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




DKFD_PGCOMPANY = "DAOU"


%>
<!--#include virtual = "/m/_include/document.asp"-->
<!--#include virtual = "/m/_include/jqueryload.asp"-->

<meta http-equiv="Cache-Control" content="no-cache"/>
<meta http-equiv="Expires" content="0"/>
<meta http-equiv="Pragma" content="no-cache"/>
<meta http-equiv="X-UA-Compatible" content="requiresActiveX=true" />
<link rel="stylesheet" href="order_direct.css">


<script type="text/javascript" src="/m/js/check.js"></script>
<script type="text/javascript" src="order_direct.js"></script>
<%
Select Case DKPG_PGCOMPANY
	Case "INICIS"
		BODYLOAD = "onload=""javascript:enable_click();"" onfocus=""javascript:focus_control();"""
		FORMDATA = "<form name=""ini"" method=""post"" autocomplete=""off"" action=""/PG/INICIS/INIsecureresult.asp"" onSubmit=""return pay(this)"">"
		oriAdd	= "inicis"				'주소선택
		takeAdd = "inicis_take"
%>
<script language=javascript src="<%=PGJAVA%>"></script>
<script type="text/javascript" src="/PG/INICIS/pays.js"></script>
<script type="text/javascript" src="orders.js"></script>
<%
	Case "DAOU"
		' onsubmit=""return fnSubmit();""
		BODYLOAD = "onload=""init();"""
		FORMDATA = "<form name=""frmConfirm"" id=""frmConfirm"" method=""post"">"
		If DK_MEMBER_TYPE = "COMPANY" And DK_MEMBER_STYPE = "0" And DKPG_KEYIN = "T" Then
			Response.Write "<script type=""text/javascript"" src=""/PG/DAOU/"&DKPG_PGJAVA_BASE4&"""></script>"
		Else
			Response.Write "<script type=""text/javascript"" src=""/PG/DAOU/"&DKPG_PGJAVA_BASE3&"""></script>"
		End If

	Case "KICCP"
		BODYLOAD = "onload=""f_init();"""
		FORMDATA = "<form name=""frm_pay"" method=""post"" action=""/PG/KICCP/easypay_request.asp"" onsubmit=""return f_submit();"">"
		oriAdd	= "kiccp"
		takeAdd = "kiccp_take"
%>
<script language="javascript" src="<%=PGJAVA%>"></script>
<script language="javascript" src="/PG/KICCP/pay.js"></script>

<%
End Select
%>


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

</head>
<body <%=BODYLOAD%>>
<!--#include virtual = "/m/_include/header.asp"-->
<!--#include virtual = "/m/_include/sub_header.asp"-->
<div id="shop" class="detailView porel">
<%
'	print DKPG_PGCOMPANY
'	print DKPG_PGJAVA_BASE4&"DD"
'	print DKPG_PGJAVA_BASE3
%>
<%
	If webproIP="T" Then
		Call ResRW(DKPG_PGCOMPANY,"웹프로_IP_VIEW - 연결PG사")
		Call ResRW(DKPG_PGMOD,"PG_MODE")
		If UCase(DKPG_PGCOMPANY) = "DAOU" Then
			If Right(DKFD_PGMOD,4) = "TEST" Then
				Call ResRW(DKPG_PGIDS_MOBILE,"DKPG_PGIDS_MOBILE")
				Call ResRW(DKPG_PGIDS_MOBILE_KEYIN,"DKPG_PGIDS_MOBILE_KEYIN")
				Call ResRW(DKPG_PGJAVA_BASE3,"자바연결3-모바일일반")
				Call ResRW(DKPG_PGJAVA_BASE4,"자바연결4-모바일키인")
			Else
				Call ResRW(DKPG_PGIDS_SHOP_KEYIN,"DKPG_PGIDS_SHOP_KEYIN")
				Call ResRW(DKPG_PGJAVA_BASE1,"자바연결1")
			End If
		End If
	End If
%>

	<div id="cart_title_b" class="width100 tcenter text_noline tweight" ><%=LNG_SHOP_ORDER_DIRECT_TITLE_01%></div>
	<div id="cart_title_m" class="cart_title_m" ><%=LNG_SHOP_ORDER_DIRECT_TITLE_05%></div>

	<%=FORMDATA%>
		<input type="hidden" name="cuidx" value="<%=GoodsIDX%>" />
		<input type="hidden" name="infoType" id="infoType" value="O" /> <!-- O : 기존정보, N : 새정보 -->

		<div class="clear">
			<div class="deliveryBtn"><a href="javascript:deli1on();" class="deli1 " ><%=LNG_SHOP_ORDER_DIRECT_TITLE_05%></a></div>
			<div class="deliveryBtn"><a href="javascript:deli2on();" class="deli2 off" ><%=LNG_SHOP_ORDER_DIRECT_TITLE_08%></a></div>
		</div>
		<div  id="user_info1" class="user_info1 clear">
			<table <%=tableatt%> class="width100">
				<col width="" />
				<col width="" />
				<tr>
					<th><%=LNG_SHOP_ORDER_DIRECT_TABLE_17%></th>
					<td><%=DK_MEMBER_NAME%></td>
				</tr><tr>
					<th><%=LNG_SHOP_ORDER_DIRECT_TABLE_18%></th>
					<td><%=strTel%></td>
				</tr><tr>
					<th><%=LNG_SHOP_ORDER_DIRECT_TABLE_19%></th>
					<td><%=strMobile%></td>
				</tr><tr>
					<th><%=LNG_SHOP_ORDER_DIRECT_TABLE_20%></th>
					<td><%=strEmail%></td>
				</tr><tr>
					<th class="vtop"><%=LNG_SHOP_ORDER_DIRECT_TABLE_21%></th>
					<td style="line-height:18px;">(<%=strzip%>) <%=strADDR1%><br /><%=strADDR2%></td>
				</tr>
			</table>
		</div>
		<div id="user_info2" class="user_info1 clear" style="display:none;">
			<table <%=tableatt%> class="width100">
				<col width="" />
				<col width="" />
				<tr>
					<th><%=LNG_SHOP_ORDER_DIRECT_TABLE_17%></th>
					<td><input type="text" name="takeName" class="input_text width100" /></td>
				</tr><tr>
					<th><%=LNG_SHOP_ORDER_DIRECT_TABLE_18%></th>
					<td>
						<!-- <div style="width:32%;"><input type="text" name="takeTel1" class="input_text width100" /></div><div class="tcenter" style="width:3%;"> - </div><div style="width:32%;"><input type="text" name="takeTel2" class="input_text width100" /></div><div class="tcenter" style="width:3%;"> - </div><div style="width:30%;"><input type="text" name="takeTel3" class="input_text width100" /></div> -->
						<input type="tel" name="takeTel" class="input_text" style="width:50%;" maxlength="15" <%=onLyKeys%> value="" />
					</td>
				</tr><tr>
					<th><%=LNG_SHOP_ORDER_DIRECT_TABLE_19%></th>
					<td>
						<!-- <div style="width:32%;"><input type="text" name="takeMob1" class="input_text width100"/></div><div class="tcenter" style="width:3%;"> - </div><div style="width:32%;"><input type="text" name="takeMob2" class="input_text width100" /></div><div class="tcenter" style="width:3%;"> - </div><div style="width:30%;"><input type="text" name="takeMob3" class="input_text width100" /></div> -->
						<input type="tel" name="takeMobile" class="input_text" style="width:50%;" maxlength="15" <%=onLyKeys%> value="" />
					</td>
				</tr><tr>
					<th><%=LNG_SHOP_ORDER_DIRECT_TABLE_20%></th>
					<td>
					<%If UCase(DK_MEMBER_NATIONCODE)="KR" Then%>
						<div style="width:57%;"><input type="text" name="takeZip" class="input_text width100" readonly="readonly" style="background-color:#eee;" /></div><div class="tcenter" style="width:3%;"></div><div style="width:40%;"><input type="button" name="" onclick="openzip();" class="input_btn width100" value="우편번호찾기" /></div>
					<%Else%>
						<div style="width:22%;"><%=LNG_TEXT_ZIPCODE%></div><div style="width:57%;"><input type="text" name="takeZip" class="input_text width100" maxlength="7" value="<%=DKRS_Addcode1%>" /></div><div class="tcenter" style="width:3%;"></div>
					<%End If%>
					</td>
				</tr><tr>
					<th class="vtop"></th>
					<td>
						<%If UCase(DK_MEMBER_NATIONCODE)="KR" Then%>
							<input type="text" name="takeADDR1" class="input_text" style="width:100%;background-color:#eee;" readonly="readonly"  />
						<%Else%>
							<input type="text" name="takeADDR1" class="input_text width100" value="" />
						<%End If%>
					</td>
				</tr><tr>
					<th class="vtop"></th>
					<td><input type="text" name="takeADDR2" class="input_text" style="width:100%;" /></td>
				</tr>
			</table>
		</div>

		<div class="user_info2 clear">
			<p class="orderMemo"><%=LNG_SHOP_ORDER_DIRECT_TABLE_23%></p>
			<input type="text" name="orderMemo" class="input_text width100" />
		</div>




		<div class="cart_title_m" style="margin-top:15px;"><%=LNG_SHOP_ORDER_DIRECT_TABLE_01%></div>
		<%
			TOTAL_DeliveryFee = 0 ' 최종 배송금액
			TOTAL_OptionPrice =  0
			TOTAL_OptionPrice2 =  0
			TOTAL_Price = 0 ' 최종 결제금액
			TOTAL_Point =  0

			CSGoodCnt = 0

			If DKRS_isCSGoods = "T" Then CSGoodCnt = 1				'MOBILE order_direct.asp 추가

			'각상품별 필요 값self_DeliveryFee
				self_DeliveryFee	= 0 '개별 배송금액
				self_Price			= 0 '개별 상품 금액
				self_optionPrice	= 0 '옵션 금액
				sum_optionPrice		= 0 '각 상품별 옵션 금액
				sum_optionPrice2	= 0 '각 상품별 옵션공급가 금액
			' 이미지정보

				If DKRS_isImgType = "S" Then
					imgPath = VIR_PATH("goods/thum")&"/"&backword(DKRS_ImgThum)
					imgWidth = 0
					imgHeight = 0
					Call ImgInfo(imgPath,imgWidth,imgHeight,"")
					imgPaddingH = (upImgHeight_Thum - imgHeight) / 2
				Else
					imgPath = BACKWORD(DKRS_imgThum)
					imgWidth  = upImgWidths_Thum
					imgHeight = upImgHeight_Thum
					imgPaddingH = 0
				End If


			' 아이콘 정보
				printGoodsIcon = ""
				If DKRS_flagBest	= "T" Then printGoodsIcon = printGoodsIcon & "<span class=""icons"">"&viewImg(IMG_ICON&"/i_bestT.gif",31,11,"")&"</span>"
				If DKRS_flagNew		= "T" Then printGoodsIcon = printGoodsIcon & "<span class=""icons"">"&viewImg(IMG_ICON&"/i_newT.gif",31,11,"")&"</span>"
				If DKRS_flagVote	= "T" Then printGoodsIcon = printGoodsIcon & "<span class=""icons"">"&viewImg(IMG_ICON&"/i_voteT.gif",31,11,"")&"</span>"
				If DKRS_GoodsDeliveryType = "AFREE" Then printGoodsIcon = printGoodsIcon & "<span class=""icons"">"&viewImg(IMG_ICON&"/i_freeT.gif",31,11,"")&"</span>"

				If (DK_MEMBER_TYPE = "COMPANY" And DK_MEMBER_STYPE = "0") Or DK_MEMBER_TYPE ="ADMIN" Then
					If DKRS_isCSGoods	= "T" Then printGoodsIcon = printGoodsIcon & "<span class=""icons"">"&viewImg(IMG_ICON&"/i_csgoodsT.gif",50,11,"")&"</span>"
				End If

			' 상품별 금액/적립금 확인
				selfPrice = Int(orderEa) * Int(DKRS_GoodsPrice)
				selfPoint = Int(orderEa) * Int(DKRS_GoodsPoint)

			' 옵션 정보
				arrResult = Split(CheckSpace(strOption),",")
				'print arrResult(0)
				'print arrResult(1)
				'Response.End
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
					printOPTIONS = printOPTIONS & "<span style='font-size:11px;color:#9e9e9e;'>["&LNG_SHOP_ORDER_DIRECT_TABLE_06&"] "& arrOptionTitle(0) & " : " & arrOptionTitle(1) & OptionPrice & "</span><br />"
					sum_optionPrice = Int(sum_optionPrice) + Int(arrOption(1))
					sum_optionPrice2 = Int(sum_optionPrice2) + Int(arrOption(2))
					'print arrOption(0)
					'print arrOption(1)
					'print arrOption(2)
				Next

				SQL = " INSERT INTO [DK_ORDER_TEMP_OPTION] ("
				SQL = SQL & "[orderIDX],[goodsPrice],[optionPrice],[ea],[point],[VotePoint],[optionPrice2] "
				SQL = SQL & " ) VALUES ( "
				SQL = SQL & " ?,?,?,?,?,0,? "
				SQL = SQL & " ) "
				arrParams = Array(_
					Db.makeParam("@orderIDX",adInteger,adParamInput,0,orderTempIDX), _
					Db.makeParam("@goodsPrice",adInteger,adParamInput,0,DKRS_GoodsPrice), _
					Db.makeParam("@optionPrice",adInteger,adParamInput,0,sum_optionPrice), _
					Db.makeParam("@ea",adInteger,adParamInput,0,orderEa), _
					Db.makeParam("@point",adInteger,adParamInput,0,DKRS_GoodsPoint), _
					Db.makeParam("@optionPrice2",adInteger,adParamInput,0,sum_optionPrice2) _
				)
				Call Db.exec(SQL,DB_TEXT,arrParams,Nothing)
				self_optionPrice = Int(orderEa) * Int(sum_optionPrice)
				self_optionPrice2 = Int(orderEa) * Int(sum_optionPrice2)


				TOTAL_OptionPrice	= TOTAL_OptionPrice + self_optionPrice
				TOTAL_OptionPrice2	= TOTAL_OptionPrice2 + self_optionPrice2
				TOTAL_Price			= TOTAL_Price + selfPrice
				TOTAL_Point			= TOTAL_Point + selfPoint
				TOTAL_POINT_PRICE	= TOTAL_OptionPrice + TOTAL_Price



			'배송비 확인
				If DKRS_GoodsDeliveryType = "SINGLE" Then
					DeliveryFee = Int(DKRS_GoodsDeliveryFee)
					self_DeliveryFee = Int(orderEa) * Int(DKRS_GoodsDeliveryFee)
					'print DeliveryFee
					'spans(num2cur(DeliveryFee),"#FF6600","","")
					'txt_DeliveryFee = "<span class=""tweight"">선결제 "&spans(num2cur(self_DeliveryFee),"#FF6600","","")&"원</span>"
					'txt_DeliveryInfo = "<span class=""f11px"">단독배송상품 / 개당 "&num2cur(DeliveryFee)&"원 </span>"
					txt_DeliveryFee = "<span class=""tweight"">"&LNG_SHOP_ORDER_DIRECT_TABLE_08& " "&spans(num2cur(self_DeliveryFee),"#FF6600","","")&" "&Chg_CurrencyISO&"</span>"
					txt_DeliveryInfo = "<span class=""f11px"">"&LNG_SHOP_ORDER_DIRECT_TABLE_08&num2cur(DeliveryFee)&" "&Chg_CurrencyISO&"</span>"
					txt_DeliveryFeeType = LNG_SHOP_ORDER_DIRECT_TABLE_08
					'TOTAL_DeliveryFee = TOTAL_DeliveryFee + selfDeliveryFee

				ElseIf DKRS_GoodsDeliveryType = "AFREE" Then
						self_DeliveryFee = "0"
						'txt_DeliveryFee = "<span class=""tweight"">"&spans("무료배송상품(묶음배송불가)","#0099FF","","")&"</span>"
						'txt_DeliveryFeeType = "무료배송(묶음배송불가)"
						'txt_DeliveryInfo = "<span class=""f11px"">무료배송(묶음배송불가)</span>"
						txt_DeliveryFee = "<span class=""tweight"">"&spans(LNG_SHOP_ORDER_DIRECT_TABLE_09,"#0099FF","","")&"</span>"
						txt_DeliveryFeeType = LNG_SHOP_ORDER_DIRECT_TABLE_10
						txt_DeliveryInfo = "<span class=""f11px"">"&LNG_SHOP_ORDER_DIRECT_TABLE_10&"</span>"


				ElseIf DKRS_GoodsDeliveryType = "BASIC" Then
					'===================================================================================================
					'	SQL = "SELECT * FROM [DK_DELIVERY] WHERE [delTF] = 'F'"
					'	Set DKRS2 = Db.execRs(SQL,DB_TEXT,Nothing,Nothing)
					'	If Not DKRS2.BOF And Not DKRS2.EOF Then
					'		DKRS2_FeeType		= UCase(DKRS2("FeeType"))
					'		DKRS2_intFee		= Int(DKRS2("intFee"))
					'		DKRS2_intLimit		= DKRS2("intLimit")
					'	Else
					'		Response.Write "(기본배송비정책이 입력되지 않았습니다)"
					'	End If
					'	Call closeRS(DKRS2)
					'===================================================================================================
					arrParams2 = Array(_
						Db.makeParam("@strShopID",adVarChar,adParamInput,30,DKRS_strShopID) _
					)
					Set DKRS2 = DB.execRs("DKP_DELIVERY_FEE_VIEW",DB_PROC,arrParams2,Nothing) ''DKPA_DELIVEY_FEE_VIEW
					If Not DKRS2.BOF And Not DKRS2.EOF Then
						DKRS2_FeeType			= DKRS2("FeeType")
						DKRS2_intFee			= Int(DKRS2("intFee"))
						DKRS2_intLimit			= Int(DKRS2("intLimit"))
						'PRINT printDeli(DKRS2_FeeType)
						'If DKRS2_FeeType <> "FREE" Then
						'	PRINT num2cur(DKRS2_intFee) & "원 ("&num2cur(DKRS2_intLimit) &"원 이상 무료배송)"
						'End If
					Else
						'Call ALERTS("기본배송비정책이 입력되지 않았거나 삭제된 상품입니다.. 관리자에게 문의해주세요.","back","")
						Call ALERTS(LNG_SHOP_ORDER_DIRECT_07,"back","")
					End If
					Call closeRS(DKRS2)
					'===================================================================================================
					'DeliveryFee = Int(DKRS2_intFee) * Int(orderEa)

					Select Case LCase(DKRS2_FeeType)
						Case "free"
							self_DeliveryFee = 0
							'txt_DeliveryFee = "<span class=""tweight"">"&spans("무료배송","#FF6600","","")&"</span>"
							'txt_DeliveryFeeType = "무료배송"
							'txt_DeliveryInfo = "<span class=""f11px"">무료배송</span>"
							txt_DeliveryFee = "<span class=""tweight"">"&spans(LNG_SHOP_ORDER_DIRECT_TABLE_09,"#0099FF","","")&"</span>"
							txt_DeliveryFeeType = LNG_SHOP_ORDER_DIRECT_TABLE_10
							txt_DeliveryInfo = "<span class=""f11px"">"&LNG_SHOP_ORDER_DIRECT_TABLE_10&"</span>"

						Case "prev"
							If TOTAL_POINT_PRICE >= DKRS2_intLimit Then
								self_DeliveryFee = 0
								'txt_DeliveryFee = "<span class=""tweight"">"&spans("무료배송","#FF6600","","")&"</span>"
								'txt_DeliveryInfo = "<span class=""f11px"">묶음배송 상품 / "&num2cur(DKRS2_intLimit)&" 원 이상 무료배송</span>"
								'txt_DeliveryFeeType = "무료배송"
								txt_DeliveryFee = "<span class=""tweight"">"&spans(LNG_SHOP_ORDER_DIRECT_TABLE_10,"#FF6600","","")&"</span>"
								txt_DeliveryInfo = "<span class=""f11px"">"&LNG_SHOP_ORDER_DIRECT_TABLE_11&" <br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"&LNG_SHOP_DETAILVIEW_21&" ("&num2cur(DKRS2_intLimit)&" "&Chg_currencyISO&")</span>"
								txt_DeliveryFeeType = LNG_SHOP_ORDER_DIRECT_TABLE_10
							Else
								self_DeliveryFee = DKRS2_intFee
								'txt_DeliveryFee = "<span class=""tweight"">선결제 "&num2cur(self_DeliveryFee)&"원</span>"
								'txt_DeliveryInfo = "<span class=""f11px"">묶음배송 상품 / "&num2cur(DKRS2_intLimit)&" 원 이상 무료배송</span>"
								'txt_DeliveryFeeType = "선결제"
								txt_DeliveryFee = "<span class=""tweight"">"&LNG_SHOP_ORDER_DIRECT_TABLE_07&" "&num2cur(self_DeliveryFee)&" "&Chg_currencyISO&"</span>"
								txt_DeliveryInfo = "<span class=""f11px"">"&LNG_SHOP_ORDER_DIRECT_TABLE_11&" <br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"&LNG_SHOP_DETAILVIEW_21&" ("&num2cur(DKRS2_intLimit)&" "&Chg_currencyISO&")</span>"
								txt_DeliveryFeeType = LNG_SHOP_ORDER_DIRECT_TABLE_07
							End If
						Case "next"
							If TOTAL_POINT_PRICE >= DKRS2_intLimit Then
								self_DeliveryFee = "0"
								'txt_DeliveryFee = "<span class=""tweight"">"&spans("무료배송","#FF6600","","")&"</span>"
								'txt_DeliveryInfo = "<span class=""f11px"">묶음배송 상품 / "&num2cur(DKRS2_intLimit)&" 원 이상 무료배송</span>"
								'txt_DeliveryFeeType = "무료배송"
								txt_DeliveryFee = "<span class=""tweight"">"&spans(LNG_SHOP_ORDER_DIRECT_TABLE_10,"#FF6600","","")&"</span>"
								txt_DeliveryInfo = "<span class=""f11px"">"&LNG_SHOP_ORDER_DIRECT_TABLE_11&" <br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"&LNG_SHOP_DETAILVIEW_21&" ("&num2cur(DKRS2_intLimit)&" "&Chg_currencyISO&")</span>"
								txt_DeliveryFeeType = LNG_SHOP_ORDER_DIRECT_TABLE_10
							Else
								'txt_DeliveryFee = "<span class=""tweight"">착불 "&num2cur(self_DeliveryFee)&"원</span>"
								'txt_DeliveryInfo = "<span class=""f11px"">"&num2cur(DKRS2_intLimit)&"원 이상 무료배송</span>"
								'txt_DeliveryFeeType = "착불"
								txt_DeliveryFee = "<span class=""tweight"">"&LNG_SHOP_ORDER_DIRECT_TABLE_13&" "&num2cur(self_DeliveryFee)&" "&Chg_currencyISO&"</span>"
								txt_DeliveryInfo = "<span class=""f11px"">"&LNG_SHOP_ORDER_DIRECT_TABLE_11&" <br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"&LNG_SHOP_DETAILVIEW_21&" ("&num2cur(DKRS2_intLimit)&" "&Chg_currencyISO&")</span>"
								txt_DeliveryFeeType = LNG_SHOP_ORDER_DIRECT_TABLE_13
								self_DeliveryFee  = 0
							End If
					End Select

				End If

			%>
			<%

				If DKRS_isCSGoods = "T" And DK_MEMBER_TYPE = "COMPANY"  And DK_MEMBER_STYPE = "0" Then

					'▣CS상품정보
					SQL = "SELECT *"
					SQL = SQL& " ,[SellTypeName] = ISNULL((SELECT C.[SellTypeName] FROM [tbl_SellType] AS C WHERE C.[SellCode] = A.[Sellcode] ),'')"
					SQL = SQL& " FROM [tbl_Goods] AS A WHERE A.[ncode] = ? AND A.[GoodUse] = 0"
					arrParams = Array(_
						Db.makeParam("@ncode",adVarChar,adParamInput,20,DKRS_CSGoodsCode) _
					)
					Set DKRS = Db.execRs(SQL,DB_TEXT,arrParams,DB3)
					If Not DKRS.BOF And Not DKRS.EOF Then
						RS_ncode		= DKRS("ncode")
						RS_price2		= DKRS("price2")
						RS_price4		= DKRS("price4")
						RS_price5		= DKRS("price5")
						RS_price6		= DKRS("price6")
						RS_SellCode		= DKRS("SellCode")
						RS_SellTypeName	= DKRS("SellTypeName")		'구매종류
						'If RS_SellTypeName <> "" Then
						'RS_SellTypeName = "<span class=""tweight blue2"">구매종류 : </span><span class=""green tweight"">"&RS_SellTypeName&"</span>"
						'End If
						'변경값
						arrParams = Array(_
							Db.makeParam("@ncode",adVarChar,adParamInput,20,RS_ncode) _
						)
						Set DKRS2 = Db.execRs("DKP_GOODS_CHANGE",DB_PROC,arrParams,DB3)
						If Not DKRS2.BOF And Not DKRS2.EOF Then
							RS_price2	= DKRS2("price2")
							RS_price4	= DKRS2("price4")
							RS_price5	= DKRS2("price5")
							RS_price6	= DKRS2("price6")
						Else
							RS_price2	= RS_price2
							RS_price4	= RS_price4
							RS_price5	= RS_price5
							RS_price6	= RS_price6
						End If
						Call closeRs(DKRS2)
					End If
					Call closeRs(DKRS)


				End If


				self_PV = RS_price4 * orderEa
				self_GV = RS_price3 * orderEa
				TOTAL_PV = TOTAL_PV + self_PV
				TOTAL_GV = TOTAL_GV + self_GV


			%>
			<div class="width100">
				<div class="index_v_goods porel ">
					<div class="porel cartGoodsArea">
						<div class="poabs cartGoodsImg" style=""><img src="<%=imgPath%>" width="100%" height="90" alt="" /></div>
						<div class="porel ovhi" style="margin-left:110px; min-height:100px;">
							<div style="padding-top:10px; ">
								<div class="cartIcon"><%=printGoodsIcon%></div>
								<div class="cartGoodsName tweight text_noline"><%=DKRS_GoodsName%></div>
								<div class="cartOptName text_noline"><%=printOPTIONS%></div>
								<div class="porel" style="margin-top:15px; ">
									<div style="font-size:17px; color:#222; font-weight:bold; line-height:20px; letter-spacing:-1px;">
										<span style="vertical-align:-2px"><%=spans(num2cur(selfPrice)&"","#FF6600","","")%></span><span style="font-size:0.65em"> <%=Chg_currencyISO%>
										<%If DKRS_isCSGoods = "T" And DK_MEMBER_TYPE = "COMPANY"  And DK_MEMBER_STYPE = "0" Then%>
										 / <span style="vertical-align:-1px;color:#d43f05; font-size:14px;"><%=num2cur(self_PV)%> <%=CS_PV%></span>
										 / <span style="vertical-align:-1px;color:green; font-size:12px;"><%=RS_SellTypeName%></span>
										<%End If%>
										/ <%=txt_DeliveryFee%></span>
									</div>
								</div>
							</div>
						</div>
						<div class="porel" style="padding:7px 0px; background-color:#f4f4f4; margin:10px 10px 0px 10px;">
							<div style="text-indent:7px; line-height:20px;">
								<div>
									<span style="color:#333; display:inline-block; width:80px;"><%=LNG_SHOP_ORDER_DIRECT_TABLE_02%><!-- 상품금액 --></span>
									<span style="letter-spacing:-1px; font-size:12px;"><%=num2cur(selfPrice/orderEa)%> <%=Chg_currencyISO%> / <%=LNG_TEXT_EA%></span>
								</div>
								<div>
									<span style="color:#333; display:inline-block; width:80px;"><%=LNG_SHOP_ORDER_DIRECT_TABLE_03%><!-- 구매수량 --></span>
									<span style="letter-spacing:-1px; font-size:12px;"><input type="hidden" name="ea" class="input_text" style="width:25px;" value="<%=orderEa%>" /><%=orderEa%> <%=LNG_TEXT_EA%></span>
								</div>
								<%If DKRS_isCSGoods = "T" And DK_MEMBER_TYPE = "COMPANY"  And DK_MEMBER_STYPE = "0" Then%>
									<div>
										<span class="goodsInfo_span"><%=CS_PV%></span>
										<span style="letter-spacing:-1px; font-size:12px;"><%=num2cur(RS_PRICE4)%> <%=CS_PV%> / <%=LNG_TEXT_EA%></span>
									</div>
								<%End If%>
								<%If selfPoint > 0 Then%>
								<div>
									<span style="color:#333; display:inline-block; width:80px;"><%=LNG_SHOP_ORDER_FINISH_14%><!-- 적립금 --></span>
									<span style="letter-spacing:-1px; font-size:12px;"><%=num2cur(selfPoint)%> <%=Chg_currencyISO%> (<%=num2cur(selfPoint/orderEa)%> * <%=orderEa%>)</span>
								</div>
								<%End If%>
								<div>
									<span style="color:#333; display:inline-block; width:80px;"><%=LNG_SHOP_COMMON_DELIVERY_POLICY%><!-- 배송정책 --></span>
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

				TOTAL_DeliveryFee	= TOTAL_DeliveryFee + self_DeliveryFee
				TOTAL_SUM_PRICE = TOTAL_DeliveryFee + TOTAL_POINT_PRICE
				SQL = "UPDATE [DK_ORDER_TEMP] SET "
				SQL = SQL & "  [totalPrice] = ? "
				SQL = SQL & " ,[totalDelivery] = ? "
				SQL = SQL & " ,[totalOptionPrice] = ? "
				SQL = SQL & " ,[totalPoint] = ? "
				SQL = SQL & " WHERE [intIDX] = ? "
				arrParams = Array(_
					Db.makeParam("@totalPrice",adInteger,adParamInput,0,TOTAL_Price), _
					Db.makeParam("@totalDelivery",adInteger,adParamInput,0,TOTAL_DeliveryFee), _
					Db.makeParam("@totalOptionPrice",adInteger,adParamInput,0,TOTAL_OptionPrice), _
					Db.makeParam("@totalPoint",adInteger,adParamInput,0,TOTAL_Point), _
					Db.makeParam("@orderIDX",adInteger,adParamInput,0,orderTempIDX) _
				)
				Call Db.exec(SQL,DB_TEXT,arrParams,Nothing)

				Call Db.finishTrans(Nothing)

				dot_icon = viewImgSt(IMG_SHOP&"/circle_dot_skyblue.gif",16,14,"아이콘","","vmiddle")
			%>
			<input type="hidden" name="cmoneyUseLimit" value="1"> <%'사용가능 최소 적립금 %>
			<input type="hidden" name="cmoneyUseMin" value="1"> <%' 결제시 최소사용 적립금 %>
			<!-- <input type="hidden" name="cmoneyUseMax" value="<%=TOTAL_POINT_PRICE%>"><%'결제시 최대사용 적립금 : 상품가%> -->
			<input type="hidden" name="cmoneyUseMax" value="<%=TOTAL_SUM_PRICE - 1000%>"><%'▣(카드)결제시 최대사용 적립금 : 상품가 → 결제금(배송비포함, 카드결제최소금액세팅  1000)%>
			<input type="hidden" name="ownCmoney" value="<%=checkNumeric(MILEAGE_TOTAL)%>"> <%'회원 보유 마일리지:레인보우2(2015-08-28)%>
			<!-- <input type="hidden" name="ownCmoney" value="<%=checkNumeric(intPoint)%>"> --> <%'회원 보유 적립금%>
			<input type="hidden" name="orgSettlePrice" value="<%=TOTAL_SUM_PRICE%>"><%' 최초 결제금액%>

			<div class="cart_title_m" style="margin-top:15px; border-bottom:0px none;"><%=LNG_SHOP_ORDER_DIRECT_TABLE_14%><!-- 주문금액 --></div>
			<div class="width100">
				<div class="porel cartPriceArea" style="">
					<div class="porel ">
						<div class="porel" style="padding:7px 0px; background-color:#f4f4f4; margin:10px 10px 10px 10px;">
							<div style="line-height:20px;">
								<div>
									<span class="cartPrice_tit" ><%=LNG_SHOP_ORDER_FINISH_09%><!-- 상품가격 --></span>
									<span class="cartPrice_Res" style=""><strong><%=num2cur(TOTAL_Price)%></strong> <%=Chg_currencyISO%></span>
								</div>
								<%If DKRS_isCSGoods = "T" And DK_MEMBER_TYPE = "COMPANY" And DK_MEMBER_STYPE = "0" Then%>
									<div>
										<span class="cartPrice_tit"><%=CS_PV%></span>
										<span class="cartPrice_Res"><strong><%=num2cur(TOTAL_PV)%> </strong><%=CS_PV%></span>
									</div>
								<%End If%>
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
								<div style="margin-top:10px;">
									<span class="cartPrice_tit tweight"><%=LNG_SHOP_ORDER_DIRECT_TABLE_14%><!-- 주문금액 --></span>
									<span class="cartPrice_Res"><strong id="lastT XT" style="color:#f20000; font-size:24px;"><%=num2cur(TOTAL_SUM_PRICE)%></strong> <%=Chg_currencyISO%></span>
								</div>

								<%If isSHOP_POINTUSE = "T" Then%>
									<div style="margin-top:10px;">
										<span class="cartPrice_tit tweight"><%=SHOP_POINT%><span style="margin-left:5px;">(<%=LNG_CS_ORDERS_POINT_POSSESSION%>:<strong id="RemainArea"><%=num2Cur(MILEAGE_TOTAL)%></strong></span>)</span>
										<span class="cartPrice_Res"><input data-theme="w" type="tel" name="useCmoney" style="text-align:right;font-size:14px;width:50%;" onKeyUp="toCurrency(this)" onBlur="toCurrency(this); checkUseCmoney(this);" value="0" />
									</div>
									<div style="margin-top:10px;">
										<span class="cartPrice_tit tweight"><%=LNG_SHOP_ORDER_DIRECT_TITLE_07%><!-- 최종 결제금액 --></span>
										<span class="cartPrice_Res"><strong id="lastTXT" style="color:#f20000; font-size:24px;"><%=num2cur(TOTAL_SUM_PRICE)%></strong> <%=Chg_currencyISO%></span>
									</div>
								<%Else%>
									<input type="hidden" name="useCmoney" value="0" />
								<%End If%>

							</div>
						</div>
					</div>
				</div>
			</div>

			<%If DK_MEMBER_TYPE = "COMPANY" And DK_MEMBER_STYPE = "0" Then%>
			<!-- <div class="cart_title_m" style="margin-top:15px; border-bottom:0px none;"><%=LNG_SHOP_ORDER_DIRECT_PAY_10%></div>
			<div class="width100 porel" style="margin:10px; margin-left:0px;">
				<div class="porel" style="height:40px; margin:15px 10px 0px 10px; ">
					<div style="width:35%" class="skin-blue fleft"><input type="radio" name="DtoD" class="input_chk" value="T" checked="checked" /><label><%=LNG_SHOP_ORDER_DIRECT_PAY_11%></label></div>
					<div style="width:63%" class="skin-blue fright"><input type="radio" name="DtoD" class="input_chk" value="F" /><label><%=LNG_SHOP_ORDER_DIRECT_PAY_12%></label></div>
				</div>
			</div> -->
			<input type="hidden" name="DtoD" value="T" />
			<%Else%>
			<input type="hidden" name="DtoD" value="T" />
			<%End If%>

			<%'If DK_MEMBER_TYPE = "COMPANY" And DKRS_isCSGoods = "T" And DK_MEMBER_STYPE = "0" Then%>
			<%If DK_MEMBER_TYPE = "COMPANY" And DKRS_isCSGoods = "T"Then%>
				<div class="cart_title_m" style="margin-top:15px; border-bottom:0px none;"><%=LNG_SHOP_COMMON_BUSINESS_MEM_INFO%><!-- CS회원 관련정보 --></div>
				<div class="width100 porel" style="margin:10px; margin-left:0px;">
					<div class="poabs" style="line-height:30px;text-indent:10px; font-size:14px;"><span class="tweight"><%=LNG_SHOP_ORDER_DIRECT_PAY_04%><!-- 구매종류 --></span></div>
					<div class="porel" style="margin-left:100px;">
						<div style="margin-right:10px;">
						<select name="v_SellCode" style="width:100%; height:30px; ">
							<!-- <option value="">구매종류선택</option> -->
							<%
								'▣구매종류 선택
								arrParams = Array(_
									Db.makeParam("@SELLCODE",adVarChar,adParamInput,10,RS_SellCode) _
								)
								arrListB = Db.execRsList("DKP_SELLTYPE_LIST2",DB_PROC,arrParams,listLenB,DB3)
							'	arrListB = Db.execRsList("DKP_SELLTYPE_LIST",DB_PROC,Nothing,listLenB,DB3)
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
									SQL2 = "SELECT * FROM [tbl_Business] WITH(NOLOCK) WHERE [U_TF] = 0 ORDER BY [name] ASC"
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
				SQL_B = "SELECT * FROM [DK_BANK] WHERE [isUSE] ='T' ORDER BY [intIDX] ASC"
				arrList_B = Db.execRsList(SQL_B,DB_TEXT,Nothing,listLen_B,Nothing)
			%>

			<div class="width100 porel">
				<div class="porel" style="height:40px; margin:15px 10px 0px 10px; border-bottom:1px solid #eee;padding-bottom:10px;">
					<!-- <div class="fleft" style="width:49%; ">
						<div class="skin-blue"><input type="radio" name="paykind" value="Card" checked="checked" /><label><%=LNG_SHOP_ORDER_DIRECT_PAY_01%></label></div>
					</div> -->
					<div class="fleft" style="width:49%;">
						<%If IsArray(arrList_B) Then%>
							<div class="skin-blue"><input type="radio" name="paykind" value="inBank"  class="input_radio" /><label><%=LNG_SHOP_ORDER_DIRECT_PAY_02%></label></div>
						<%End If%>
					</div>
					<!-- <div class="fright" style="width:49%; ">
						<div class="skin-blue"><input type="radio" name="paykind" value="inCash" /><label>현금결제</label></div>
					</div> -->
				</div>
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


			<!-- <div id="CardInfo" class="width100 porel" style="margin:10px; margin-left:0px;">
				<div class="poabs" style="line-height:30px;text-indent:10px; font-size:14px;"><span class="tweight">할부정보</span></div>
				<div class="porel" style="margin-left:100px;">
					<div style="margin-right:10px;">
						<select name="quotabase" style="width:100%; height:30px;" >
							<%If TOTAL_SUM_PRICE > 49999 Then%>
								<option value="일시불">일시불</option>
								<option value="2개월">2개월</option>
								<option value="3개월">3개월</option>
							<%Else%>
							<option value="일시불">일시불</option>
							<%End If%>
						</select><br />
						<span class="f11px" style="line-height:20px;">신용카드 5만원 이상 할부거래 가능</span>
					</div>
				</div>
			</div> -->


			<div id="BankInfo" class="width100 porel" style="margin:10px; margin-left:0px;display:none;">
				<div class="porel">
					<div class="poabs" style="line-height:30px;text-indent:10px; font-size:14px;"><span class="tweight"><%=LNG_SHOP_ORDER_DIRECT_PAY_13%><!-- 입금은행 --></span></div>
					<div class="porel" style="margin-left:100px;">
						<div style="margin-right:10px;">
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
						</div>
					</div>
				</div>
				<div class="porel">
					<div class="poabs" style="line-height:30px;text-indent:10px; font-size:14px;"><span class="tweight"><%=LNG_SHOP_ORDER_DIRECT_PAY_14%><!-- 입금자명 --></span></div>
					<div class="porel" style="margin-left:100px;margin-right:10px;"><input type="text" name="bankingName" class="input_text" style="width:100%;" /></div>
				</div>
				<!-- <div class="porel red tcenter tweight" style="line-height:20px; font-size:15px;">3일 이내 미결제시 주문 취소될 수 있습니다.</div> -->

			</div>

			<div id="orderBtn" style="margin:10px;margin-top:30px;"><!-- <input type="submit" class="buys" /> --><a class="buys" href="javascript:fnSubmit();"><%=LNG_SHOP_ORDER_DIRECT_PAY_22%><!-- 결제하기 --></a></div>

			<div class="">
				<p style="margin-top:15px; margin-left:15px; color:#d75623;"><label><input type="checkbox" name="gAgreement" value="T" style="margin:0px; height:0px; vertical-align:middle; height:16px; width:16px;" chec ked="checked" /> <span style="vertical-align:middle;font-size:14px;"><%=LNG_SHOP_ORDER_DIRECT_PAY_21%></span></label></p>

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

<input type="hidden" name="input_mode" value="direct" />



<%Select Case DKPG_PGCOMPANY%>
<%Case "DAOU"%>
	<input type="hidden" name="Daou_MEMBER_ID" value="<%=DK_MEMBER_ID%>" readonly="readonly"/>
	<input type="hidden" name="Daou_MEMBER_ID1" value="<%=DK_MEMBER_ID1%>" readonly="readonly"/>
	<input type="hidden" name="Daou_MEMBER_ID2" value="<%=DK_MEMBER_ID2%>" readonly="readonly"/>
	<input type="hidden" name="Daou_MEMBER_WEBID" value="<%=DK_MEMBER_WEBID%>" readonly="readonly"/>
	<input type="hidden" name="Daou_MEMBER_NAME" value="<%=DK_MEMBER_NAME%>" readonly="readonly"/>
	<input type="hidden" name="Daou_MEMBER_LEVEL" value="<%=DK_MEMBER_LEVEL%>" readonly="readonly"/>
	<input type="hidden" name="Daou_MEMBER_TYPE" value="<%=DK_MEMBER_TYPE%>" readonly="readonly"/>
	<input type="hidden" name="Daou_MEMBER_STYPE" value="<%=DK_MEMBER_STYPE%>" readonly="readonly"/>

	<%If DK_MEMBER_TYPE ="COMPANY" And DKPG_KEYIN = "T" And DK_MEMBER_STYPE = "0" Then%>
		<input type="hidden" name="CPID" size="50" maxlength="50" value="<%=DKPG_PGIDS_MOBILE_KEYIN%>" style="IME-MODE:disabled" />
		<input type="hidden" name="BILLTYPE" size="10" maxlength="2"  value="15" style="IME-MODE:disabled" /><!-- -->
		<input type="hidden" name="keyin" size="5" value="KEYIN" style="IME-MODE:disabled" /><!-- -->
	<%Else%>
		<input type="hidden" name="CPID" size="50" maxlength="50" value="<%=DKPG_PGIDS_MOBILE%>" style="IME-MODE:disabled" />
		<input type="hidden" name="BILLTYPE" size="10" maxlength="2"  value="1" style="IME-MODE:disabled" /><!-- -->
	<%End If%>
	<input type="hidden" name="PRODUCTTYPE" size="10" maxlength="2" value="1" style="IME-MODE:disabled" /><!-- -->

	<input type="hidden" name="ORDERNO" size="50" maxlength="50" value="<%=orderNum%>" style="I ME-MODE:disabled" />
	<input type="hidden" name="AMOUNT" size="10" maxlength="10" value="<%=TOTAL_SUM_PRICE%>" style="IME-MODE:disabled" onkeypress="fnNumCheck();" />
	<input type="hidden" name="quotaopt" value="06" />

	<input type="hidden" name="TAXFREECD" value="00" />
	<input type="hidden" name="EMAIL" size="100" maxlength="100" value="<%=strEmail%>" />
	<input type="hidden" name="USERID" size="30" maxlength="30" value="<%=DK_MEMBER_ID%>" />
	<input type="hidden" name="USERNAME" size="50" maxlength="50" value="<%=DK_MEMBER_NAME%>" />
	<input type="hidden" name="PRODUCTCODE" size="10" value="<%=GoodsIDX%>" />
	<input type="hidden" name="PRODUCTNAME" size="50" value="<%=DKRS_GoodsName%>" />
	<input type="hidden" name="TELNO1" size="50" value="" />
	<input type="hidden" name="TELNO2" size="50" value="" />
	<input type="hidden" name="RESERVEDINDEX1" size="20" value="" />
	<input type="hidden" name="RESERVEDINDEX2" size="20" value="" />
	<input type="hidden" name="RESERVEDSTRING" size="10" value="" />
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




<%Case "INICIS"%>
<%
	'*******************************************************************************
	'INIsecureStart.asp
	'
	'결제 페이지 생성 처리 => 중요 정보 암호화 작업 .
	'플러그인 호출 부분 구성.
	'코드에 대한 자세한 설명은 매뉴얼을 참조하십시오.
	'<주의> 구매자의 세션을 반드시 체크하도록하여 부정거래를 방지하여 주십시요.
	'http://www.inicis.com
	'Copyright (C) 2007 Inicis, Co. All rights reserved.
	'*******************************************************************************

	'###############################################################################
	'# 1. 결제 페이지 상에 위변조 체크를 해야할  중요 필드 #
	'#######################################################
	'#		상점아이디 : MerID
	'#		결제   금액 : Price
	'#		무이자할부 : Nointerest
	'#			무이자로 할부 여부 제공(yes), 제공하지 않음(no)
	'#			무이자할부는 별도 계약이 필요합니다.
	'#			카드사별,할부개월수별 무이자할부 적용은 아래의 카드할부기간을 참조 하십시오.
	'#			무이자할부 옵션 적용은 반드시 매뉴얼을 참조하여 주십시오.
	'#		카드할부기간 : Quotabase
	'#			각 카드사별로 지원하는 개월수가 다르므로 유의하시기 바랍니다.
	'#			value의 마지막 부분에 카드사코드와 할부기간을 입력하면 해당 카드사의 해당
	'#			할부개월만 무이자할부로 처리됩니다 (매뉴얼 참조).
	'#######################################################


	'###############################################################################
	'# 1. 객체 생성 #
	'################

	Set INIpay = Server.CreateObject("INItx50.INItx50.1")

	'###############################################################################
	'# 2. 인스턴스 초기화 #
	'######################
	PInst = INIpay.Initialize("")

	'###############################################################################
	'# 3. 체크 유형 설정 #
	'#####################
	INIpay.SetActionType CLng(PInst), "chkfake"

	'###############################################################################
	'# 5. 암호화 처리 필드 세팅        #
	'###################################
	Session("INI_MID") =  PGIDS
	Session("INI_PRICE") = TOTAL_SUM_PRICE '결제 금액 =>  결제 처리 페이지에서 체크 하기 위해 세션에 저장 (또는 DB에 저장)하여 다음 결제 처리 페이지 에서 체크)
	'상품가 총액을 알기 위해 하단으로 이동 조치
	Session("INI_ADMIN") = PGPASSKEY '상점키 패스워드 =>  결제 처리 페이지에서 체크 하기 위해 세션에 저장 (또는 DB에 저장)하여 다음 결제 처리 페이지 에서 체크)

	INIpay.SetField CLng(PInst), "mid", Session("INI_MID")			'상점아이디
	'INIpay.SetField CLng(PInst), "price",  Request("totalPrice")'Session("INI_PRICE")		'결제 금액
	INIpay.SetField CLng(PInst), "nointerest", "no"  			'무이자 할부 세팅
	'INIpay.SetField CLng(PInst), "quotabase","lumpsum:00:02:03:04:05:06:07:08:09:10:11:12"   '할부 개월 및 카드사별 무이자 세팅
	INIpay.SetField CLng(PInst), "currency", "WON"

	'**************************************************************************************************
	'* admin 은 키패스워드 변수명입니다. 수정하시면 안됩니다. 위의 세션 "INI_ADMIN" 의 1111의 부분만 수정해서 사용하시기 바랍니다.
	'* 키패스워드는 상점관리자 페이지(https://iniweb.inicis.com)의 비밀번호가 아닙니다. 주의해 주시기 바랍니다.
	'* 키패스워드는 숫자 4자리로만 구성됩니다. 이 값은 키파일 발급시 결정됩니다.
	'* 키패스워드 값을 확인하시려면 상점측에 발급된 키파일 안의 readme.txt 파일을 참조해 주십시오.
	'**************************************************************************************************
	INIpay.SetField CLng(PInst), "admin", Session("INI_ADMIN") '상점키 패스워드


	INIpay.SetField CLng(PInst), "debug", "true" '로그모드("true"로 설정하면 상세한 로그를 남김)
	'###############################################################################
	'# 5. 체크 처리를 위한 암호화 처리 #
	'###################################
	INIpay.StartAction(CLng(PInst))

	'###############################################################################
	'6. 암호화  결과 #
	'###############################################################################
	resultcode = INIpay.GetResult(CLng(PInst), "resultcode")
	resultmsg = INIpay.GetResult(CLng(PInst), "resultmsg")
	rn_value = INIpay.GetResult(CLng(PInst), "rn")		'다음 페이지에서 체크할 RN값
	return_enc = INIpay.GetResult(CLng(PInst), "return_enc")	'해당 필드값을 암호화한 결과 값
	ini_certid = INIpay.GetResult(CLng(PInst), "ini_certid")		'상점 구분키 값
	'###############################################################################
	'7. RN 값 세션에 저장 #
	'###############################################################################
	Session("INI_RN") = rn_value  	'RN값 => 결제 처리 페이지에서 체크 하기 위해 세션에 저장 (또는 DB에 저장)하여 다음 결제 처리 페이지 에서 체크)

	'###############################################################################
	'# 8. 인스턴스 해제 #
	'###############################################################################
	INIpay.Destroy CLng(PInst)

	'###############################################################################
	'# 9. 결제 페이지 생성 성공 유무에 대한 처리  #
	'###############################################################################
	IF resultcode <> "00" THEN
		'실패 처리 =>  결제 페이지 생성 실패에 따른 처리 절차 삽입 (예 : 상점키 파일을 읽지 못해 실패 처리 되면 해당 resultmsg를 확인하여 상점 관리자거 해당 오류 처리 필요)

		response.write " 결제 페이지 생성에 문제 발생<BR>"
		response.write "에러 원인 : "&  	resultmsg
		Response.End
	End If


	%>

	<input type="hidden" name="goodname" maxlength="300" value="<%=arrList_GoodsName%>" />
	<input type="hidden" name="buyername" value="" />
	<input type="hidden" name="buyeremail" value="" />
	<input type="hidden" name="buyertel" value="" />
	<input type="hidden" name="price" value="" />
	<!-- 기타설정 -->
	<!--
	SKIN : 플러그인 스킨 칼라 변경 기능 - 5가지 칼라(ORIGINAL/BLUE중 택1, GREEN, ORANGE, BLUE, KAKKI, GRAY)
	HPP : 컨텐츠 또는 실물 결제 여부에 따라 HPP(1)과 HPP(2)중 선택 적용(HPP(1):컨텐츠, HPP(2):실물)
	Card(0): 신용카드 지불시에 이니시스 대표 가맹점인 경우에 필수적으로 세팅 필요 ( 자체 가맹점인 경우에는 카드사의 계약에 따라 설정) - 자세한 내용은 메뉴얼  참조
	OCB : OK CASH BAG 가맹점으로 신용카드 결제시에 OK CASH BAG 적립을 적용하시기 원하시면 "OCB" 세팅 필요 그 외에 경우에는 삭제해야 정상적인 결제 이루어짐
	-->
	<input type="hidden" name="acceptmethod" value="SKIN(ORIGINAL):HPP(1)" />

	<!--
	상점 주문번호
	무통장입금 예약(가상계좌 이체),전화결재(1588 Bill) 관련 필수필드로 반드시 상점의 주문번호를 페이지에 추가해야 합니다.
	결제수단 중에 실시간 계좌이체 이용 시에는 주문 번호가 결제결과를 조회하는 기준 필드가 됩니다.
	상점 주문번호는 최대 40 BYTE 길이입니다.
	-->
	<input type="hidden" name="oid" size="40" value="<%=orderNum%>" />
	<input type="hidden" name="INIregno" size="40" value="" />

	<!--
	플러그인 좌측 상단 상점 로고 이미지 사용
	플러그인 좌측 상단에 상점 로고 이미지를 사용하실 수 있으며,
	주석을 풀고 이미지가 있는 URL을 입력하시면 플러그인 상단 부분에 상점 이미지를 삽입할수 있습니다.
	-->
	<!--input type=hidden name=ini_logoimage_url  value="http://[사용할 이미지주소]"-->

	<!--
	좌측 결제메뉴 위치에 이미지 추가
	좌측 결제메뉴 위치에 미미지를 추가하시 위해서는 담당 영업대표에게 사용여부 계약을 하신 후
	주석을 풀고 이미지가 있는 URL을 입력하시면 플러그인 좌측 결제메뉴 부분에 이미지를 삽입할수 있습니다.
	-->
	<!--input type=hidden name=ini_menuarea_url value="http://[사용할 이미지주소]"-->

	<!--
	플러그인에 의해서 값이 채워지거나, 플러그인이 참조하는 필드들
	삭제/수정 불가
	-->
	<input type="hidden" name="ini_encfield" value="<%=return_enc%>" />


	<input type="hidden" name="ini_certid" value="<%=ini_certid %>" />
	<input type="hidden" name="quotainterest" value="" />
	<input type="hidden" name="paymethod" value="" />
	<input type="hidden" name="cardcode" value="" />
	<input type="hidden" name="cardquota" value="" />
	<input type="hidden" name="rbankcode" value="" />
	<input type="hidden" name="reqsign" value="DONE" />
	<input type="hidden" name="encrypted" value="" />
	<input type="hidden" name="sessionkey" value="" />
	<input type="hidden" name="uid" value="" />
	<input type="hidden" name="sid" value="" />
	<input type="hidden" name="version" value="4000" />
	<input type="hidden" name="clickcontrol" value="" />


<%Case "KICCP"%>
<!--#include virtual="/PG/KICCP/easypay_config.asp" -->

<!-- [수정불가] 해외카드인증구분 //-->
<input type="hidden" name="EP_os_cert_flag"     value="2">

<!-- 플러그인으로 부터 받는 필드 [변경불가] //-->
<input type="hidden" name="EP_res_cd"           value="">             <!-- 응답코드     //-->
<input type="hidden" name="EP_res_msg"          value="">             <!-- 응답메시지   //-->

<input type="hidden" name="EP_tr_cd"            value="">             <!-- 플러그인 요청구분  //-->
<input type="hidden" name="EP_trace_no"         value="">             <!-- 거래추적번호 //-->
<input type="hidden" name="EP_sessionkey"       value="">             <!-- 암호화키     //-->
<input type="hidden" name="EP_encrypt_data"     value="">             <!-- 암호화전문   //-->

<input type="hidden" name="EP_card_code"        value="">             <!-- 인증카드코드   //-->
<input type="hidden" name="EP_ret_pay_type"     value="">             <!-- 안심클릭인증값 //-->
<input type="hidden" name="EP_ret_complex_yn"   value="">             <!-- 복합결제여부   //-->


<input type="hidden" name="EP_mall_id" value="<%=g_mall_id%>" size="50" maxlength="8">			<!-- 가맹점아이디 -->
<input type="hidden" name="EP_mall_pwd" value="1111" size="50">									<!-- 가맹점암호 -->

<input type="hidden" name="EP_mall_nm" value="<%=g_mall_name%>" size="50" /> <!-- 가맹점명 -->
<input type="hidden" name="EP_ci_url" value="testpg.easypay.co.kr/plugin/logo_kicc.png" size="50" /> <!-- 가맹점 CI 주소 -->


<input type="hidden" name="EP_lang_flag" value="" size="50" /> <!-- 한글/영문 (빈값/ENG) -->
<input type="hidden" name="EP_agent_ver" value="" size="50" /> <!-- 가맹점개발언어 (JSP/PHP/ASP) -->

<input type="hidden" name="EP_pay_type" value="11" size="50" /> <!-- 결제수단 (11:신용카드/21:계좌이체/22:무통장입금/31:휴대폰/32:전화결제/41:포인트/11:21:22:31:32:41 : 모든결제수단) -->

<input type="hidden" name="EP_currency" value="00" size="50" /> <!-- 통화코드 (00:원화/01:달러) -->
<input type="hidden" name="EP_complex_yn" value="N" size="50" /> <!-- 복합결제 허용여부 (Y/N) -->

 <input type="hidden" name="usedcard_code" value="" />
 <input type="hidden" name="EP_usedcard_code" value="" />
 <!-- 가맹점에서 사용 가능한 카드만 노출하고 싶을 때 아래 코드를 삽입 하시기 바랍니다.
        <td bgcolor="#FFFFFF" width="750" colspan="3">&nbsp;<input type="checkbox" name="usedcard_code" value="029" checked>신한(029)
            <input type="checkbox" name="usedcard_code" value="027" checked>현대(027)
            <input type="checkbox" name="usedcard_code" value="031" checked>삼성(031)
            <input type="checkbox" name="usedcard_code" value="008" checked>외환(008)
            <input type="checkbox" name="usedcard_code" value="026" checked>비씨(026)
            <input type="checkbox" name="usedcard_code" value="016" checked>국민(016)
            <input type="checkbox" name="usedcard_code" value="047" checked>롯데(047)
            <input type="checkbox" name="usedcard_code" value="018" checked>NH농협(018)
            <input type="checkbox" name="usedcard_code" value="006" checked>하나SK(006)<br>
            &nbsp;<input type="checkbox" name="usedcard_code" value="022" checked>시티(022)
            <input type="checkbox" name="usedcard_code" value="021" checked>우리(021)
            <input type="checkbox" name="usedcard_code" value="002" checked>광주(002)
            <input type="checkbox" name="usedcard_code" value="017" checked>수협(017)
            <input type="checkbox" name="usedcard_code" value="010" checked>전북(010)
            <input type="checkbox" name="usedcard_code" value="011" checked>제주(011)
            <input type="checkbox" name="usedcard_code" value="001" checked>조흥(001)
            <input type="checkbox" name="usedcard_code" value="058" checked>산업(058)
            <input type="checkbox" name="usedcard_code" value="126" checked>저축(126)<br>
            &nbsp;<input type="checkbox" name="usedcard_code" value="226" checked>우체국(226)
            <input type="checkbox" name="usedcard_code" value="050" checked>VISA(050)
            <input type="checkbox" name="usedcard_code" value="028" checked>JCB(028)
            <input type="checkbox" name="usedcard_code" value="048" checked>다이너스(048)
            <input type="checkbox" name="usedcard_code" value="049" checked>Master(049)
        </td>
        -->
        <!-- 플러그인에 전달될 카드사 리스트 변수 -->

 <input type="hidden" name="EP_cert_type" value="" />	<!-- 신용카드인증방식 (0:인증/1:비인증) -->
 <input type="hidden" name="EP_noinst_flag" value="" />	<!-- 무이자사용여부 (:DB조회/Y:무이자/N/일반) -->
 <input type="hidden" name="EP_noinst_term" value="" />	<!-- 무이자설정(카드코드-할부개월) (029-02:03:04:05:06,027-02:03) -->
 <input type="hidden" name="vacct_bank" value="" />	<!-- 가상계좌<br>&nbsp;은행 리스트 (국민은행(004),농협중앙회(011),우리은행(020),SC제일은행(023),신한은행(026),부산은행(032),우체국(071),하나은행(081)         ) -->
<input type="hidden" name="EP_vacct_bank">

<input type="hidden" name="EP_vacct_end_date" value="<%=DateAdd("D",3,Left(now,10))%>" size="50" />	<!-- 가상계좌 입금만료일  -->
<input type="hidden" name="EP_vacct_end_time" value="235959" size="50" />	<!-- 가상계좌 입금만료시간  -->



<input type="hidden" name="EP_order_no" size="50" value="<%=ORDERNUM%>" />			<!-- 주문번호 -->
<input type="hidden" name="EP_user_type" size="50" value="2" />						<!-- 사용자구분(1:일반/2:회원)-->
<input type="hidden" name="EP_user_id" size="50" value="<%=DK_MEMBER_ID%>" />			<!-- 고객ID -->
<input type="hidden" name="EP_user_nm" size="50" value="<%=DK_MEMBER_ID%>" />			<!-- 고객명 -->
<input type="hidden" name="EP_user_mail" size="50" />									<!-- 고객Email -->
<input type="hidden" name="EP_user_phone1" size="50" />								<!-- 고객전화번호 -->
<input type="hidden" name="EP_user_phone2" size="50" />								<!-- 고객휴대폰 -->
<input type="hidden" name="EP_user_addr" size="100" />								<!-- 고객주소 -->
<input type="hidden" name="EP_product_nm" size="50" value="<%=arrList_GoodsName%>" />			<!-- 상품명 -->
<input type="hidden" name="EP_product_amt" size="50" value="<%=TOTAL_SUM_PRICE%>" />		<!-- 상품금액 -->
<input type="hidden" name="EP_product_type" size="50" value="0" />								<!-- 상품구분 (0:실물/1:컨텐츠) -->
<input type="hidden" name="EP_tax_flg" size="50" />									<!-- 과세구분 (:일반/TG01:복합과세) -->
<input type="hidden" name="EP_com_tax_amt" size="50" />								<!-- 과세 승인금액 -->
<input type="hidden" name="EP_com_free_amt" size="50" />								<!-- 비과세 승인금액 -->
<input type="hidden" name="EP_com_vat_amt" size="50" />								<!-- 부가세 금액  -->



<%End Select%>








	</form>
</div>
<!--#include virtual = "/m/_include/copyright.asp"-->