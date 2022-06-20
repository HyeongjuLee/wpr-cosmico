<!--#include virtual = "/_lib/strFunc.asp"-->
<!--#include virtual="/PG/NICEPAY/NICEPAY_FUNCTION.ASP"-->
<!--#include virtual="/_lib/MD5.asp" -->
<%

	PAGE_SETTING = "MY_BUY"




If webproIP <> "T" Then Call ALERTS(LNG_ALERT_WRONG_ACCESS,"back","")

	Call ONLY_BUSINESS_MEMBER(DK_MEMBER_LEVEL,2)
	Call ONLY_CS_MEMBER()
	Call FN_NationCurrency(DK_MEMBER_NATIONCODE,Chg_CurrencyName,Chg_CurrencyISO)

	Call noCache

	''inUidx = Trim(pRequestTF("cuidx",True))
	inUidx = Trim(pRequestTF("nCode",True))

	If inUidx = "" Then Call ALERTS(LNG_CS_ORDERS_ALERT01,"go","/m/shop/cart.asp")

	arrUidx = Split(inUidx,",")
	orderNum = Replace(makeOrderNo(),"MT","MM")


	'회원 구분 후 회원정보 받아오기
	Select Case DK_MEMBER_TYPE
		Case "MEMBER","ADMIN"
			Call ALERTS("CS회원만 구매 이용가능합니다!","BACK","")

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
				strzip		= DKRS("Addcode1")
				strADDR1	= DKRS("Address1")
				strADDR2	= DKRS("Address2")
				intPoint	= 0
			Else
				Call  ALERTS(LNG_SHOP_ORDER_DIRECT_02,"BACK","")
			End If
			Call closeRS(DKRS)

		Case Else : Call ALERTS(LNG_SHOP_ORDER_DIRECT_04,"BACK","")
	End Select

	If DKCONF_SITE_ENC = "T" Then
		'회원정보 복호화
		Set objEncrypter = Server.CreateObject ("Hyeongryeol.StringEncrypter")
			objEncrypter.Key = con_EncryptKey
			objEncrypter.InitialVector = con_EncryptKeyIV
			On Error Resume Next
				If strADDR1		<> "" Then strADDR1			= objEncrypter.Decrypt(strADDR1)
				If strADDR2		<> "" Then strADDR2			= objEncrypter.Decrypt(strADDR2)
				If strTel		<> "" Then strTel			= objEncrypter.Decrypt(strTel)
				If strMobile	<> "" Then strMobile		= objEncrypter.Decrypt(strMobile)
				If strEmail		<> "" Then strEmail		= objEncrypter.Decrypt(strEmail)
			On Error GoTo 0
		Set objEncrypter = Nothing
	End If

	If strTel = "" Or IsNull(strTel) Then strTel = ""
	If strMobile = "" Or IsNull(strMobile) Then strMobile = ""
	arrTel = Split(strTel,"-")
	arrMobile = Split(strMobile,"-")
	If UBound(arrTel) <> 2 Then arrTel = Array("","","")
	If UBound(arrMobile) <> 2 Then arrMobile = Array("","","")



	'Call Db.beginTrans(Nothing)

	'◆ #1. SHOP 주문 임시테이블 정보 입력
	arrParams = Array(_
		Db.makeParam("@OrderNum",adVarChar,adParamInput,20,orderNum),_
		Db.makeParam("@sessionIDX",adVarChar,adParamInput,50,DK_SES_MEMBER_IDX),_
		Db.makeParam("@MBID",adVarChar,adParamInput,20,DK_MEMBER_ID1),_
		Db.makeParam("@MBID2",adInteger,adParamInput,0,DK_MEMBER_ID2),_
		Db.makeParam("@M_NAME",adVarWChar,adParamInput,50,DK_MEMBER_NAME),_
		Db.makeParam("@IDENTITY",adInteger,adParamOutput,0,0), _
		Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
	)
	Call Db.exec("DKP_ORDER_TEMP_INSERT2",DB_PROC,arrParams,DB3)
'	Call Db.exec("DKP_ORDER_TEMP_INSERT",DB_PROC,arrParams,DB3)
	orderTempIDX = arrParams(UBound(arrParams)-1)(4)
	OUTPUT_VALUE = arrParams(UBound(arrParams))(4)

	If OUTPUT_VALUE = "ERROR" Then Call ALERTS(LNG_CS_ORDERS_ALERT02,"back","")

%>
<!--#include virtual = "/m/_include/document.asp"-->
<!--#include virtual = "/m/_include/jqueryload.asp"-->
<meta http-equiv="Cache-Control" content="no-cache"/>
<meta http-equiv="Expires" content="0"/>
<meta http-equiv="Pragma" content="no-cache"/>
<meta http-equiv="X-UA-Compatible" content="requiresActiveX=true" />
<link rel="stylesheet" href="order.css">
<script type="text/javascript" src="/m/js/check.js"></script>
<!-- <script type="text/javascript" src="order_direct.js?v2"></script> -->
<link rel="stylesheet" href="/m/js/icheck/skin/line/_all.css" />
<script src="/m/js/icheck/icheck.min.js"></script>
<script type="text/javascript" src="/m/js/calendar.js"></script>
<script src="https://spi.maps.daum.net/imap/map_js_init/postcode.v2.js"></script>
<script src="/jscript/daumPostCode.js"></script>
<!--#include virtual = "/m/_include/calendar.asp"-->
<%
Select Case UCase(DK_MEMBER_NATIONCODE)
	Case "KR"
		Select Case DKPG_PGCOMPANY
			Case "DAOU"
				' onsubmit=""return fnSubmit();""
				BODYLOAD = "init();"
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
		'	Case "SPEEDPAY"
		'		BODYLOAD = ""
		'		FORMDATA = "<form name=""orderFrm"" id=""orderFrm"" action=""/PG/SPEEDPAY/order_card_result_mobile.asp"" onsubmit=""return orderSubmit(this);"" method=""post"">"
		%>
		<!-- <script type="text/javascript" src="/PG/SPEEDPAY/pay_order_cs_mobile.js"></script> -->
		<%
		'	Case "YESPAY"
		'		BODYLOAD = ""
		'		FORMDATA = "<form name=""orderFrm"" id=""orderFrm"" action=""/PG/YESPAY/CardResult_cs.asp"" onsubmit=""return orderSubmit(this);"" method=""post"">"
		%>
		<!-- <script type="text/javascript" src="/PG/YESPAY/pay_cs_m.js"></script> -->
		<%
		'	Case "ONOFFKOREA"		'상단 order_direct.js 주석걸기!
		'		BODYLOAD = ""
		'		FORMDATA = "<form name=""orderFrm"" id=""orderFrm"" onsubmit=""return orderSubmit(this);"" method=""post"">"
		%>
		<!-- <script type="text/javascript" src="/PG/ONOFFKOREA/pay_cs_m.js"></script> -->
		<%
		'	Case "NICEPAY"
		'		BODYLOAD = ""
		'		FORMDATA = "<form name=""payForm"" id=""payForm"" action="" accept-charset=""euc-kr"" target=""_self""  onsubmit=""return orderSubmit(this);"" method=""post"">"
		%>
		<!-- <script type="text/javascript" src="/PG/NICEPAY/pay_cs_m.js"></script> -->

		<%
			Case "KSNET"
				BODYLOAD = ""
				FORMDATA = "<form name=""orderFrm"" id=""orderFrm"" method=""post"" action="""" onsubmit=""return orderSubmit(this);"">"
				PRINT "<script type=""text/javascript"" src=""/PG/KSNET/pay_cs_m.js?v1.1""></script>"
		%>


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
<body onload="calcSettlePrice(); checkpayType(); <%=BODYLOAD%>">
<!--#include virtual = "/m/_include/header.asp"-->
<!--#include virtual = "/m/_include/sub_header.asp"-->
<%
	If webproIP="T1" Then
		Call ResRW(DKPG_PGMOD,"PG_MODE")
		Call ResRW(DKPG_PGCOMPANY,"웹프로_IP_VIEW - 연결PG사")
	End If
%>
<style type="text/css">
	#loading_bg {width:100%;height:100%;top:0px;left:0px;position:fixed;display:block; opacity:0.7;background-color:#fff;z-index:99;text-align:center; }
	#loading-image {position:absolute; top:40%; left:45%; z-index:100;}
</style>
<div id="subTitle" class="width100 tcenter text_noline" ><%=LNG_MYOFFICE_ORDER_03%></div>
<div class="detailView porel" style="padding:0px 5px;">
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
	<input type="hidden" name="ori_strName" value="<%=backword_br(strName)%>" readonly="readonly"/>
	<input type="hidden" name="ori_strTel" value="<%=strTel%>" readonly="readonly"/>
	<input type="hidden" name="ori_strMobile" value="<%=strMobile%>" readonly="readonly"/>
	<input type="hidden" name="ori_strZip" value="<%=strZip%>" readonly="readonly"/>
	<input type="hidden" name="ori_strADDR1" value="<%=strADDR1%>" readonly="readonly"/>
	<input type="hidden" name="ori_strADDR2" value="<%=strADDR2%>" readonly="readonly"/>
	<p class="titles"><%=LNG_CS_ORDERS_TEXT01%></p>
	<div id="cart" class="width100">
		<table <%=tableatt%> class="width100">
			<colgroup>
				<col width="" />
				<col width="" />
				<col width="" />
			</colgroup>
			<thead>
				<tr>
					<th colspan="3" style="border-top:2px solid #444;">
						[<%=LNG_TEXT_CSGOODS_CODE%>] <%=LNG_TEXT_ITEM_NAME%>
					</th>
				</tr><tr>
					<th><%=LNG_SHOP_ORDER_DIRECT_TABLE_02%></th>
					<th><%=LNG_SHOP_ORDER_DIRECT_TABLE_03%></th>
					<th><%=LNG_SHOP_ORDER_DIRECT_TABLE_04%></th>
				</tr>
			</thead>
			<%
				For i = 0 To UBound(arrUidx)

					arrParams = Array(_
						Db.makeParam("@intIDX",adInteger,adParamInput,0,arrUidx(i)), _
						Db.makeParam("@MBID",adVarChar,adParamInput,20,DK_MEMBER_ID1),_
						Db.makeParam("@MBID2",adInteger,adParamInput,0,DK_MEMBER_ID2)_
					)
					Set DKRSS = Db.execRs("DKP_DKP_CART_ONE",DB_PROC,arrParams,DB3)
					If Not DKRSS.BOF And Not DKRSS.EOF Then
						arrList_CSGoodsCode	= DKRSS("ncode")
						arrList_GoodsName	= DKRSS("name")
						arrList_orderEa		= DKRSS("ea")
					Else
						Call alerts(LNG_CS_ORDERS_ALERT03,"back","")
					End If
					Call closeRs(DKRSS)

					'상품갯수 체크
					'If arr_CS_ea < 1 Then Call ALERTS(LNG_CS_CART_JS06,"back","")
					If arrList_orderEa < 1 Then Call ALERTS(LNG_CS_CART_JS06,"back","")

					arr_CS_price4 = 0
					arr_CS_SELLCODE		= ""
					arr_CS_SellTypeName = ""

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
							If DK_MEMBER_STYPE = "1" Then
								arr_CS_price2	   = arr_CS_price
							End If
						End If

					'▣구매종류가 다른 상품은 구매불가	Fn_DistinctData▣
						LAST_CS_SellCode = CStr(arr_CS_SellCode)
						ALL_CS_SellCode  = ALL_CS_SellCode & arr_CS_SellCode &","


					' 상품별 금액
						SELF_PRICE = 0
						SELF_PRICE	= Int(arrList_orderEa) * arr_CS_price2

						SELF_PV = 0
						SELF_PV		= Int(arrList_orderEa) * arr_CS_price4
			%>

				<tr class="hovers">
					<td colspan="3" class="title">
						<span class="vmiddle">[<%=arrList_CSGoodsCode%>]</span> <span class="title vmiddle"><%=arrList_GoodsName%></span><%=arr_CS_SellTypeName%>
						<p class=""><%=arr_Goods_Sort_TXT%></p>
					</td>
				</tr><tr>
					<td class="tright bot_line_c">
						<%=spans(num2cur(SELF_PRICE/arrList_orderEa),"#222222","11","400")%>&nbsp;<%=spans(""&Chg_currencyISO&"","#222222","11","400")%>
						<%If DK_MEMBER_STYPE = "0" Then%>
						<br /><%=spans(num2curINT(SELF_PV/arrList_orderEa),"#ff3300","10","400")%><%=spans(""&CS_PV&"","#ff3300","9","400")%>
						<%End If%>
					</td>
					<td class="tcenter bot_line_c">
						<input type="hidden" name="ea" class="input_text" value="<%=arrList_orderEa%>" /><%=arrList_orderEa%>
					</td>
					<td class="tright bot_line_c">
						<%=spans(num2cur(SELF_PRICE),"#222222","11","400")%>&nbsp;<%=spans(""&Chg_currencyISO&"","#222222","11","400")%>
						<%If DK_MEMBER_STYPE = "0" Then%>
						<br /><%=spans(num2curINT(SELF_PV),"#ff3300","10","400")%><%=spans(""&CS_PV&"","#ff3300","9","400")%>
						<%End If%>
					</td>
				</tr>
			<%

					TOTAL_GOODS_PRICE	= TOTAL_GOODS_PRICE + SELF_PRICE
					TOTAL_PV			= TOTAL_PV + SELF_PV

					'◆ #2. SHOP 주문 임시테이블 정보 입력
					arrParams2 = Array(_
						Db.makeParam("@OrderIDX",adInteger,adParamInput,0,orderTempIDX),_
						Db.makeParam("@GoodsCode",adVarChar,adParamInput,20,arrList_CSGoodsCode),_
						Db.makeParam("@GoodsPrice",adVarChar,adParamInput,20,arr_CS_price2),_
						Db.makeParam("@GoodsPV",adInteger,adParamInput,0,arr_CS_price4),_
						Db.makeParam("@ea",adInteger,adParamInput,0,arrList_orderEa),_
						Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR")_
					)
					Call Db.exec("DKP_ORDER_TEMP_GOODS_INSERT",DB_PROC,arrParams2,DB3)
					OUTPUT_VALUE = arrParams(UBound(arrParams))(4)

					If OUTPUT_VALUE = "ERROR" Then
						Call ALERTS(LNG_CS_ORDERS_ALERT04,"BACK","")
						Exit For
					End If

				Next
			%>
		</table>
	</div>


	<%
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

		If TOTAL_GOODS_PRICE >= DKRS2_intDeliveryFeeLimit Then
			TOTAL_DELIVERYFEE = "0"
		Else
			TOTAL_DELIVERYFEE = DKRS2_intDeliveryFee
		End If


		'If webproIP="T" Then TOTAL_DELIVERYFEE = 3

		'결제금 계산
		TOTAL_SUM_PRICE = TOTAL_GOODS_PRICE + TOTAL_DELIVERYFEE

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
	<input type="hidden" name="cmoneyUseMax" value="<%=TOTAL_SUM_PRICE - 1000%>"><%'▣(카드)결제시 최대사용 적립금 : 상품가 → 결제금(배송비포함, 카드결제최소금액세팅  1000)%>
	<input type="hidden" name="ownCmoney" value="<%=checkNumeric(MILEAGE_TOTAL)%>">						<%'GNG 회원 보유 C포인트 (외국회원만) %>
	<input type="hidden" name="ownCmoney2" value="<%=checkNumeric(MILEAGE2_TOTAL)%>"  readonly="readonly"> <%'회원 보유 S포인트:%>
	<input type="hidden" name="orgSettlePrice" value="<%=TOTAL_SUM_PRICE%>"><%' 최초 결제금액%>
	<input type="hidden" name="TOTAL_POINTUSE_MIN" value="<%=TOTAL_POINTUSE_MIN%>"  readonly="readonly"><%'▶ 최소 포인트사용가능 금액%>
	<input type="hidden" name="TOTAL_POINTUSE_MAX" value="<%=TOTAL_POINTUSE_MAX%>"  readonly="readonly"><%'▶ 최대 포인트사용가능 금액%>

	<p class="titles"><%=LNG_SHOP_ORDER_DIRECT_TITLE_05%></p>
	<div style="margin-bottom: 10px; color: #d75623; font-size: 14px;">
		<label><input type="radio" name="dInfoType" class="input_radio" value="" onClick="baseDeliveryInfo(this.form);" checked="checked" /><%=LNG_TEXT_BASE_DELIVERYINFO%></label>
		<label><input type="radio" name="dInfoType" class="input_radio" value="" onClick="openDeliveryInfo();" /><%=LNG_TEXT_LATEST_DELIVERYINFO%></label>
		<a name="modal" href="/m/shop/pop_deliveryInfo.asp" id="deliveryInfoModal" title="<%=LNG_TEXT_LATEST_DELIVERYINFO%>" ></a>
		<!-- <label><input type="radio" name="dInfoType" class="input_radio" value="" onClick="emptyDeliveryInfo(this.form);" /><%=LNG_TEXT_DIRECT_INPUT%></label> -->
	</div>
	<div class="ordersInfo clear">
		<table <%=tableatt%> class="width100">
			<col width="80" />
			<col width="*" />
			<tr>
				<th><%=LNG_SHOP_ORDER_DIRECT_TABLE_17%> <%=startext%></th>
				<td><input type="text" name="takeName" class="input_text width100" value="<%=backword_br(strName)%>" /></td>
			</tr>
			<tr style="display: none;">
				<th><%=LNG_SHOP_ORDER_DIRECT_TABLE_18%></th>
				<td><input type="tel" name="takeTel" class="input_text width100" style="ime-mode: disabled;" <%=onLyKeys%> value="" /></td>
			</tr>
			<tr>
				<th><%=LNG_TEXT_MOBILE%> <%=startext%></th>
				<td><input type="tel" name="takeMobile" class="input_text width100" style="ime-mode: disabled;" <%=onLyKeys%> value="<%=strMobile%>" /></td>
			</tr>
			<tr>
				<th><%=LNG_SHOP_ORDER_DIRECT_TABLE_21%> <%=startext%></th>
				<td class="zipTD">
					<%Select Case UCase(DK_MEMBER_NATIONCODE)%>
						<%Case "KR"%>
							<p><input type="text" class="input_text readonly" style="width: 50px;" name="takeZip" id="takeZipDaum" readonly="readonly" value="<%=strzip%>" />	<span id="takeZipBtn"><input type="button" class="input_btn" style="padding:0px 6px;" onclick="execDaumPostcode_takes();" value="우편번호검색" /></span></p>
						<%Case "JPTTTTT"%>
							<p><input type="text" class="input_text" name="takeZip"   id="takeZip" maxlength="7" readonly="readonly" value="<%=strzip%>" <%=onLyKeys3%> /> <input type="button" class="txtBtn j_medium" onclick="openzip_jp2EN('takeZip');" value="<%=LNG_TEXT_ZIPCODE%>" /> (ZipCode)</p>
						<%Case Else%>
							<p><input type="text" class="input_text" name="takeZip"   id="takeZip" maxlength="7" value="<%=strzip%>" <%=onLyKeys3%> /><span> (ZipCode)</span></p>
					<%End Select%>
				</td>
			</tr><tr>
				<td class="zipTD" colspan="2">
				<%Select Case UCase(DK_MEMBER_NATIONCODE)%>
					<%Case "KR"%>
						<p><input type="text" class="input_text width100 readonly" name="takeADDR1" id="takeADDR1Daum" readonly="readonly" value="<%=strADDR1%>" /></p>
						<p><input type="text" class="input_text width100" name="takeADDR2" id="takeADDR2Daum" value="<%=strADDR2%>" /></p>
					<%Case "JPTTTTT"%>
						<p><input type="text" class="input_text width100 readonly" name="takeADDR1" id="takeADDR1" readonly="readonly" value="<%=strADDR1%>" /></p>
						<p><input type="text" class="input_text width100" name="takeADDR2" id="takeADDR2" value="<%=strADDR2%>" /></p>
					<%Case Else%>
						<p><input type="text" class="input_text width100 readonly" name="takeADDR1" id="takeADDR1" value="<%=strADDR1%>" /></p>
						<p><input type="text" class="input_text width100" name="takeADDR2" id="takeADDR2" value="<%=strADDR2%>" /></p>
				<%End Select%>
				</td>
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
			<tr>
				<th><%=LNG_SHOP_ORDER_DIRECT_TABLE_20%> <%=startext%></th>
				<td><input type="email" class="input_text width100" name="strEmail" value="<%=strEmail%>" /></td>
			</tr>
			<tr>
				<th><%=LNG_SHOP_ORDER_DIRECT_TABLE_23%></th>
				<td><input type="text" name="orderMemo" class="input_text width100" /></td>
			</tr>
		</table>
	</div>

	<div class="cart_title_m tcenter" style="margin-top:15px;"><%=LNG_SHOP_ORDER_DIRECT_TABLE_14%></div>
	<div class="width100">
		<div class="totalSum porel cartPriceArea" >
			<div class="porel ">
				<div class="porel" style="background-color:#f4f4f4; margin:10px 10px;">
					<div>
						<div>
							<span class="cartPrice_tit"><%=LNG_SHOP_ORDER_DIRECT_TABLE_14%></span>
							<span class="cartPrice_Res"><span class="price"><%=num2cur(TOTAL_GOODS_PRICE)%></span> <span class="won"><%=Chg_CurrencyISO%></span></span>
						</div>
						<div>
							<span class="cartPrice_tit"><%=LNG_SHOP_ORDER_DIRECT_TABLE_15%></span>
							<span class="cartPrice_Res"><span class="price"><%=num2cur(TOTAL_DELIVERYFEE)%></span> <span class="won"><%=Chg_CurrencyISO%></span></span>
						</div>
						<div>
							<span class="cartPrice_tit tweight"><%=LNG_SHOP_ORDER_DIRECT_TABLE_16%></span>
							<span class="cartPrice_Res"><span id="LastAreaID" class="price LastArea"><%=num2cur(TOTAL_SUM_PRICE)%></span> <span class="won"><%=Chg_CurrencyISO%></span></span>
						</div>
						<%If DK_MEMBER_TYPE = "COMPANY" And DK_MEMBER_STYPE = "0" Then%>
							<div>
								<input type="hidden" name="ori_TOTAL_PV" id="ori_TOTAL_PV" value="<%=num2curINT(TOTAL_PV)%>" readonly="readonly" >
								<span class="cartPrice_tit"><%=LNG_CS_ORDERS_TOTAL_PV%></span>
								<span class="cartPrice_Res"><span id="TOTAL_PV" class="totalPV"><%=num2curINT(TOTAL_PV)%></span><span class="pv"><%=CS_PV%></span></span>
							</div>
						<%End If%>
					</div>
				</div>
			</div>
			<%'If isSHOP_POINTUSE = "T" And CDbl(MILEAGE_TOTAL) >= CDbl(TOTAL_SUM_PRICE) Then%>
			<%If isSHOP_POINTUSE = "T" Then%>
				<div class="porel ">
					<div class="porel" style="padding:7px 0px; background-color:#f4f4f4; margin:10px 10px ;">
						<div style="line-height:20px;">
							<div>
								<span class="cartPrice_tit">사용가능 <%=SHOP_POINT%></span>
								<span class="cartPrice_Res"><span class="pointPrice"><%=num2cur(MILEAGE_TOTAL)%></span> <span class="point"><%=SHOP_POINT%></span></span>
							</div>
						</div>
						<div style="line-height:20px;">
							<div>
								<span class="cartPrice_tit tweight"><%=SHOP_POINT%> 사용</span>
								<span class="cartPrice_Res"><input type="tel" name="useCmoney" class="input_text width60 tright" onKeyUp="" onBlur="toCurrency(this); checkUseCmoney(this);" value="0"  /></span>
							</div>
							<input type="hidden" name="useCmoney2" value="0" />
						</div>
					</div>
				</div>
			<%Else%>
				<input type="hidden" name="useCmoney" value="0" />
				<input type="hidden" name="useCmoney2" value="0" />
			<%End If%>
			<%'point_check 추가%>
			<input type="hidden" name="ori_useCmoney" value="0" readonly="readonly"/>
			<input type="hidden" name="useCmoneyTF" value="F" readonly="readonly"/>
		</div>
	</div>

	<!-- <div class="cart_title_m tcenter" style="margin-top:15px;"><%=LNG_SHOP_ORDER_DIRECT_TABLE_16%></div>
	<div class="width100">
		<div class="totalSum porel cartPriceArea" >
			<div class="porel ">
				<div class="porel" style="background-color:#f4f4f4; margin:10px 10px;">
					<div>
						<div>
							<span class="cartPrice_tit tweight"></span>
							<span class="cartPrice_Res"><span id="payArea" class="price LastArea"><%=num2cur(TOTAL_SUM_PRICE)%></span> <span class="won"><%=Chg_CurrencyISO%></span></span>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div> -->

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

	<p class="titles"><%=LNG_SHOP_ORDER_DIRECT_TITLE_06%></p>
	<%
		If DK_MEMBER_TYPE = "COMPANY" Then
			'CS은행정보
			'SQL_B = "SELECT A.[BankCode],A.[BankName],A.[BankPenName],A.[BankAccountNumber] FROM [tbl_BankForCompany] AS A WITH(NOLOCK)"
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

	<div class="width100 porel" style="border-top: 2px solid #444;">
		<div class="porel payBtnWrap" >
			<div class="width100 selectPayBtn">
				<%If IsArray(arrList_B) Then%>
					<div class="skin-blue"><input type="radio" name="paykind" value="inBank" class="input_radio" /><label><%=LNG_SHOP_ORDER_DIRECT_PAY_02%></label></div>
				<%End If%>
			</div>

			<%If UCase(DK_MEMBER_NATIONCODE) = "KR" Then   '카드결제는 KR only

				 MCOMPLEX_USE_TF = "T"
			%>
			<div class="width100 selectPayBtn">
				<div class="skin-blue"><input type="radio" name="paykind" value="Card" /><label><%=LNG_SHOP_ORDER_DIRECT_PAY_01%></label></div>
			</div>
			<div class="width100 selectPayBtn">
				<div class="skin-blue"><input type="radio" name="paykind" value="CardAPI" /><label><%=LNG_SHOP_ORDER_DIRECT_PAY_01%>-수기</label></div>
			</div>
			<%If 1=1 Then %>
			<div class="width100 selectPayBtn">
				<div class="skin-blue"><input type="radio" name="paykind" value="mComplex" /><label>다카드 결제</label></div>
			</div>
			<%End If%>
			<!-- <div class="width100 selectPayBtn">
				<div class="skin-blue"><input type="radio" name="paykind" value="vBank" /><label><%=LNG_TEXT_VIRTUAL_ACCOUNT%></label></div>
			</div> -->
			<!--<div class="width100 selectPayBtn">
				<div class="skin-blue"><input type="radio" name="paykind" value="Bank" /><label>실시간계좌이체(TEST)</label></div>
			</div> -->
			<%End If%>

			<%If DK_MEMBER_TYPE = "COMPANY" And isSHOP_POINTUSE = "T" Then%>
				<%If CDbl(MILEAGE_TOTAL) >= CDbl(TOTAL_SUM_PRICE) Then%>
					<div class="width100 selectPayBtn">
						<div class="skin-blue"><input type="radio" name="paykind" value="point" /><label>포인트 단독결제</label></div>
					</div>
				<%Else%>
					<!-- <div class="width100 selectpaybtn">
						<div class="skin-blue"><input type="radio" name="paykind" value="point" disabled="disabled" /><label>포인트 단독결제 (<%=lng_js_short_of_point%>)</label></div>
					</div> -->
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
		<div class="ordersInfo clear">
		<%If DK_MEMBER_TYPE = "COMPANY"  And DK_MEMBER_STYPE = "0" Then%>
			<table <%=tableatt%> class="width100">
				<col width="80" />
				<col width="*" />
				<tr>
					<th><%=LNG_SHOP_ORDER_DIRECT_PAY_04%> <%=startext%></th>
					<td>
						<select name="v_SellCode" class="vmiddle input_text width100" style="height:30px; ">
							<!-- <option value=""><%=LNG_SHOP_ORDER_DIRECT_PAY_05%></option> -->
							<%
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
							%>
						</select>
					</td>
				</tr>
			</table>
			<input type="hidden" name="SalesCenter" value="" />
		<%Else%>
			<input type="hidden" name="v_SellCode" value="01" />
			<input type="hidden" name="SalesCenter" value="" />
		<%End If%>
		</div>

	</div>

	<%If MCOMPLEX_USE_TF = "T" Then%>
	<script type="text/javascript" src="/m/shop/order_mComplex.js?v1"></script>

	<div id="mComplexInfo" class="width100 porel" style="margin:10px; margin-left:0px; display:none;">

		<table <%=tableatt%> class="width100">
			<tr>
				<td style="padding:8px 8px 20px 8px;">
					<input type="hidden" name="mComplexTotalPrice" value="<%=TOTAL_SUM_PRICE%>" readonly="readonly"/>
					<input type="hidden" name="mCardTotal" value="0" readonly="readonly"/>
					<input type="hidden" name="mBankTotal" value="0" readonly="readonly"/>
					<input type="hidden" name="mCashTotal" value="0" readonly="readonly"/>
					<input type="hidden" name="mComplexTotal" value="0" readonly="readonly"/>
					<div class="CardPriceTotal" style="margin-bottom: 8px; ">
						<table <%=tableatt%> class="width100" style="border:none;">
							<col width="30%" />
							<col width="70%" />
							<tr>
								<th class="title tcenter">결제할 금액</th>
								<td class="amount">
									<span id="mCardPrice_TXT" class="red2" readonly="readonly"><%=num2cur(TOTAL_SUM_PRICE)%></span><span class="won">원</span>
									<input type="hidden" name="mCardPrice" value="<%=TOTAL_SUM_PRICE%>" readonly="readonly"/>
								</td>
							</tr>
							<tr>
								<th class="title tcenter blue2">남은 결제금액</th>
								<td class="amountR">
									<span id="mComplexTotal_TXT" class="blue2" readonly="readonly"><%=num2cur(TOTAL_SUM_PRICE)%></span><span class="won">원</span>
								</td>
							</tr>
						</table>
					</div>
					<%'복합결제-카드%>
					<div class="CardInfo">
						<table <%=tableatt%> class="width100">
							<col width="70" />
							<col width="*" />
							<tr>
								<th colspan="2" class="tcenter paymethod">카드 #<span class="cardAddNum" >1</span></th>
							</tr>
							<tr>
								<th>금액</th>
								<td>
									<input type="hidden" name="CardVld" value="F" readonly="readonly" />
									<input type="number" title="금액" name="CardPrice" class="input_text" style="width:100px" <%=onlykeys%> value="" />
									<a class="a_submit design3 submitPrice_Card">금액적용</a>
								</td>
							</tr><tr>
								<th>카드번호</th>
								<td>
									<input type="number" title="카드번호 1" name="mCardNo1" class="input_text tcenter" style="width:20%" maxlength="4" value="" <%=onlyKeys%> oninput="maxLengthCheck(this)" />
									<input type="password" title="카드번호 2" name="mCardNo2" class="input_text tcenter" style="width:20%" maxlength="4" value="" <%=onlyKeys%> oninput="maxLengthCheck(this)" />
									<input type="password" title="카드번호 3" name="mCardNo3" class="input_text tcenter" style="width:20%" maxlength="4" value="" <%=onlyKeys%> oninput="maxLengthCheck(this)" />
									<input type="number" title="카드번호 4" name="mCardNo4" class="input_text tcenter" style="width:20%" maxlength="4" value="" <%=onlyKeys%> oninput="maxLengthCheck(this)" />
								</td>
							</tr><tr>
								<th>유효기간</th>
								<td>
									<select title="유효기간(월)" name="mCardMM" class="vmiddle input_text" style="width:60px;">
										<option value="">월</option>
										<%For j = 1 To 12%>
											<%jsmm = Right("0"&j,2)%>
											<option value="<%=jsmm%>" ><%=jsmm%></option>
										<%Next%>
									</select> /
									<select title="유효기간(년)" name="mCardYY" class="vmiddle input_text" style="width:80px;">
										<option value="">년</option>
										<%For i = THIS_YEAR To EXPIRE_YEAR%>
											<option value="<%=i%>" ><%=i%></option>
										<%Next%>
									</select>
								</td>
							</tr><tr>
								<th>생년월일 <br />(사업자번호)</th>
								<td>
									<input type="number" title="생년월일" name="mCardBirth" class="input_text" style="width:140px" maxlength="10" value="" placeholder="yyyymmdd 형식" <%=onlyKeys%> />
									<br />(생년월일 8자리 또는 사업자번호 10자리)
								</td>
							</tr><tr class="line_bot_bold">
								<th>비밀번호</th>
								<td>
									<input type="password" title="비밀번호 앞 2자리" name="mCardPass" class="input_text tcenter" style="width:60px" maxlength="2" value="" placeholder="앞2자리" <%=onlyKeys%> /> (앞2자리)
								</td>
							</tr><tr>
								<th>할부정보</th>
								<td>
									<select name="mQuotabase" class="vmiddle input_text width100" s tyle="width:100%; height:30px;" >
										<option value="00">일시불</option>
									</select>
									<span class="f11px" style="margin-left:9px;">신용카드 5만원 이상 할부거래 가능</span>
								</td>
							</tr>
						</table>
					</div>
					<div class="paytypeAddArea">
						<div class ="fleft">
							<a class="a_submit design1 CardAdd" id="CardAdd">카드 추가</a>
							<a class="a_submit design4 CardRmv">삭제</a>
						</div>
						<%If 1=2 Then %>
						<div class ="fright">
							<label class="addbtn design5"><input type="checkbox" name="BankChk" id="BankChk" value="T" class="input_chk2 addChk" > 무통장</label>
							<label class="addbtn design5"><input type="checkbox" name="CashChk" id="CashChk" value="T" class="input_chk2 addChk" > 현금</label>
						</div>
						<%End If%>
					</div>
					<%'복합결제-무통장%>
					<div class="BankInfo" style="display:none;">
						<table <%=tableatt%> class="width100">
							<col width="70" />
							<col width="*" />
							<tr>
								<th colspan="2" class="tcenter paymethodAdd">무통장</th>
							</tr>
							<tr>
								<th>금액</th>
								<td>
									<input type="hidden" name="BankVld" value="F" readonly="readonly" />
									<input type="number" title="금액" name="BankPrice" id="BankPrice" class="input_text" style="width:100px" <%=onlykeys%> value="" />
									<a class="a_submit design3 submitPrice_Bank" >금액적용</a>
								</td>
							</tr>
							<tr>
								<th><%=LNG_SHOP_ORDER_DIRECT_PAY_13%></th>
								<td>
									<ul class="bankInfo">
									<%
										If DK_MEMBER_TYPE = "COMPANY" Then

											'SQL_B = "SELECT A.[BankCode],A.[BankName],A.[BankPenName],A.[BankAccountNumber] FROM [tbl_BankForCompany] AS A WITH(NOLOCK) "
											SQL_B = "SELECT A.[BankCode],A.[BankName],A.[BankOwnerName],A.[BankAccountNumber] FROM [tbl_BankForCompany] AS A WITH(NOLOCK)"
											SQL_B = SQL_B& " JOIN [tbl_Bank] AS B WITH(NOLOCK) ON B.[ncode] = A.[BankCode]"
											SQL_B = SQL_B& " WHERE B.[Na_Code] = ? AND A.[Using_Flag] = 'Y' "		'CS 국가별 회사은행계좌 등록확인!
											arrParams_B = Array(Db.makeParam("@strNationCode",adVarChar,adParaminput,20,UCase(DK_MEMBER_NATIONCODE)))
											arrList_B = Db.execRsList(SQL_B,DB_TEXT,arrParams_B,listLen_B,DB3)

											If IsArray(arrList_B) Then
												For i = 0 To listLen_B
													'cs bank정보
													arr_mBankCode		  =	arrList_B(0,i)
													arr_mBankName		  =	arrList_B(1,i)
													arr_mBankPenName	  =	arrList_B(2,i)
													arr_mBankAccountNumber=	arrList_B(3,i)

													If DKCONF_SITE_ENC = "T" Then
														Set objEncrypter = Server.CreateObject ("Hyeongryeol.StringEncrypter")
															objEncrypter.Key = con_EncryptKey
															objEncrypter.InitialVector = con_EncryptKeyIV
															If DKCONF_ISCSNEW = "T" Then
																If arr_mBankAccountNumber <> "" Then arr_mBankAccountNumber = objEncrypter.Decrypt(arr_mBankAccountNumber)
															End If
														Set objEncrypter = Nothing
													End If
									%>
										<li><label><input type="radio" name="mBankidx" class="input_radio" value="<%=arr_mBankCode%>,<%=arr_mBankName%>,<%=arr_mBankPenName%>,<%=arr_mBankAccountNumber%>" /> <%=arr_mBankName%> | <strong><%=arr_mBankAccountNumber%></strong> | <%=arr_mBankPenName%></label>

									<%
												Next
											End If

										End If
									%>
									</ul>
								</td>
							</tr><tr>
								<th><%=LNG_SHOP_ORDER_DIRECT_PAY_14%></th>
								<td><input type="text" name="mBankingName" class="input_text" /></td>
							</tr><tr class="lastTD">
								<th><%=LNG_CS_ORDERS_TRANSFER_DATE%></th>
								<td><input type='text' id="mDDATE" name='mMemo1' value="" class='input_text readonly' readonly="readonly"></td>
							</tr>
						</table>
					</div>
					<%'복합결제-현금%>
					<div class="CashInfo" style="display:none;">
						<table <%=tableatt%> class="width100">
							<col width="70" />
							<col width="*" />
							<tr>
								<th colspan="2" class="tcenter paymethodAdd">현금</th>
							</tr>
							<tr>
								<th>금액</th>
								<td>
									<input type="hidden" name="CashVld" value="F" readonly="readonly" />
									<input type="number" title="금액" name="CashPrice"  id="CashPrice" class="input_text" style="width:100px" <%=onlykeys%> value="" />
									<a id="submitBankPrice" class="a_submit design3 submitPrice_Cash" >금액적용3</a>
								</td>
							</tr>
						</table>
					</div>

				</td>
			</tr>
		</table>
	</div>
	<%End If%>

	<div id="CardInfo" class="width100 porel" style="margin:10px; margin-left:0px;display:none;">
	<%Select Case DKPG_PGCOMPANY%>
		<%Case "SPEEDPAY","YESPAY","DAOU","NICEPAY","ONOFFKOREA","KSNET"%>
		<div class="porel">
			<div class="poabs" style="line-height:27px;text-indent:10px;"><span class="tweight">카드번호</span></div>
			<div class="porel" style="margin-left:80px;margin-right:10px;">
				<input type="number" name="cardNo1" class="input_text tcenter" maxlength="4" style="width:23%;" placeholder="4자리" <%=onlyKeys%> value="" oninput="maxLengthCheck(this)" />
				<input type="password" name="cardNo2" class="input_text tcenter" maxlength="4" style="width:23%;" placeholder="4자리" <%=onlyKeys%> value="" oninput="maxLengthCheck(this)" />
				<input type="password" name="cardNo3" class="input_text tcenter" maxlength="4" style="width:23%;" placeholder="4자리" <%=onlyKeys%> value="" oninput="maxLengthCheck(this)" />
				<input type="number" name="cardNo4" class="input_text tcenter" maxlength="4" style="width:23%;" placeholder="4자리" <%=onlyKeys%> value="" oninput="maxLengthCheck(this)" />
			</div>
		</div>
		<div class="porel" style="margin-top:8px;">
			<div class="poabs" style="line-height:27px;text-indent:10px;"><span class="tweight">유효기간</span></div>
			<div class="porel" style="margin-left:80px;margin-right:10px;">
				<!-- <input type="number" name="card_mm" class="input_text tcenter" maxlength="2" style="width:49%;" placeholder="유효기간(월)" <%=onlyKeys%> value="" oninput="maxLengthCheck(this)" />
				<input type="number" name="card_yy" class="input_text tcenter" maxlength="4" style="width:49%;" placeholder="유효기간(년)" <%=onlyKeys%> value="" oninput="maxLengthCheck(this)" /> -->
				<select name="card_mm" class="vmiddle input_text" style="width:70px;">
					<option value="">월</option>
					<%For j = 1 To 12%>
						<%jsmm = Right("0"&j,2)%>
						<option value="<%=jsmm%>" ><%=jsmm%></option>
					<%Next%>
				</select> /
				<select name="card_yy" class="vmiddle input_text" style="width:80px;">
					<option value="">년</option>
					<%For i = THIS_YEAR To EXPIRE_YEAR%>
						<option value="<%=i%>" ><%=i%></option>
					<%Next%>
				</select>
			</div>
		</div>

		<div class="porel" style="margin-top:8px;">
			<div class="poabs" style="line-height:27px;text-indent:10px;"><span class="tweight"><!-- 생년월일 -->카드구분</span></div>
			<div class="porel" style="margin-left:80px;margin-right:6px;">
				<div style="margin-top:15px;margin-bottom:10px;">
					<label><input type="radio" name="cardKind" value="P" onclick="chgCardKind(this.value)" class="input_radio" checked="checked" />일반신용</label>
					<label><input type="radio" name="cardKind" value="C" onclick="chgCardKind(this.value)" class="input_radio" />법인사업자</label>
					<label><input type="radio" name="cardKind" value="I" onclick="chgCardKind(this.value)" class="input_radio" />개인사업자</label>
				</div>
				<div id="CardKind01">
					<select name = "birthYY" class="vmiddle input_text" style="width:80px;height:28px;">
						<option value=""></option>
						<%For i = MIN_YEAR To MAX_YEAR%>
							<option value="<%=i%>" ><%=i%></option>
						<%Next%>
					</select> 년
					<select name = "birthMM" class="vmiddle input_text" style="width:65px;height:28px;">
						<option value=""></option>
						<%For j = 1 To 12%>
							<%jsmm = Right("0"&j,2)%>
							<option value="<%=jsmm%>" ><%=jsmm%></option>
						<%Next%>
					</select> 월
					<select name = "birthDD" class="vmiddle input_text" style="width:65px;height:28px;">
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
			<div class="poabs" style="line-height:27px;text-indent:10px;"><span class="tweight">비밀번호</span></div>
			<div class="porel" style="margin-left:80px;margin-right:10px;">
				<input type="password" name="CardPass" class="input_text tcenter" maxlength="2" style="width:60px;" placeholder="앞2자리" <%=onlyKeys%> value="" oninput="maxLengthCheck(this)" />
				<span style="color:#ee0000"> * 비밀번호 앞 2자리 입력</span>
			</div>
		</div>

		<div class="porel" style="margin-top:8px;">
			<div class="poabs" style="line-height:30px;text-indent:10px;"><span class="tweight">할부정보</span></div>
			<div class="porel" style="margin-left:80px;">
				<div style="margin-right:10px;">
					<select name="quotabase" class="vmiddle input_text" style="width:100%; height:30px;" >
						<%If TOTAL_SUM_PRICE > 49999 Then%>
							<option value="00">일시불</option>
							<option value="02">2개월</option>
							<option value="03">3개월</option>
							<!-- <option value="04">4개월</option>
							<option value="05">5개월</option>
							<option value="06">6개월</option>
							<option value="07">7개월</option>
							<option value="08">8개월</option>
							<option value="09">9개월</option>
							<option value="10">10개월</option>
							<option value="11">11개월</option>
							<option value="12">12개월</option> -->
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
			<div class="poabs" style="line-height:30px;text-indent:10px;"><span class="tweight"><%=LNG_SHOP_ORDER_DIRECT_PAY_13%><!-- 입금은행 --></span></div>
			<div class="porel" style="margin-left:80px;">
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
				.inbank th {padding : 4px 0px 4px 10px; text-align:left; font-weight: 500;}
				.inbank td {padding : 4px 0px 4px 0px; text-align:left; font-weight: 500;}
			</style>
			<table <%=tableatt%> class="width95 inbank">
				<col width="80" />
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

	<div id="vBankInfo" class="width100 porel" style="margin:10px; margin-top:10px;display:none;">
		<div class="porel">
			<div class="poabs" style="line-height:27px;text-indent:10px; font-size:14px;"><span class="tweight"><%=LNG_CS_ORDERS_BANK_NAME%></span></div>
			<div class="porel" style="margin-left:80px;margin-right:10px;line-height:27px; font-size:14px;">
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
			</div>
		</div>
		<div class="porel">
			<div class="poabs" style="line-height:27px;text-indent:10px; font-size:14px;"><span class="tweight"><%=LNG_SHOP_ORDER_DIRECT_PAY_14%></span> <%=starText%></div>
			<div class="porel" style="margin-left:80px;margin-right:10px;"><input type="text" name="vBankDepName" class="input_text" /></div>
		</div>
		<div class="porel">
			<div class="poabs" style="line-height:27px;text-indent:10px; font-size:14px;"><span class="tweight">입금만료시간</span> <%=starText%></div>
			<div class="porel" style="margin-left:80px;margin-right:10px; font-size:14px; padding-top:3px;">
				<span class="red tweight"><%=Left(DateAdd("d",1,now()),10)%> 23:59:59 까지 입금하지 않으면 주문이 취소됩니다.</span>
				<%
					vBankDepDate = Replace(Left(DateAdd("d",1,now()),10),"-","")
					vBankDepDate = vBankDepDate&"235959"
				%>
				<input type="hidden" name="vBankDepDate" value="<%=vBankDepDate%>" readonly="readonly"/>
			</div>
		</div>
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

<input type="hidden" name="totalPrice" value="<%=TOTAL_SUM_PRICE%>" readonly="readonly"/>
<input type="hidden" name="totalDelivery" value="<%=TOTAL_DELIVERYFEE%>" readonly="readonly"//>
<input type="hidden" name="GoodsPrice" value="<%=TOTAL_GOODS_PRICE%>" />
<input type="hidden" name="DeliveryFeeType" value="<%=txt_DeliveryFeeType%>" />
<input type="hidden" name="OrdNo" value="<%=orderNum%>" />
<input type="hidden" name="ori_price" value="<%=TOTAL_SUM_PRICE%>" />
<input type="hidden" name="ori_delivery" value="<%=TOTAL_DELIVERYFEE%>" readonly/>
<input type="hidden" name="input_mode" value="" />
<%If DK_MEMBER_TYPE = "COMPANY" Then%>
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
				<%If DK_MEMBER_TYPE ="COMPANY" And DKPG_KEYIN = "T" Then%>
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

			<%Case "KSNET"%>
				<input type="hidden" name="GoodsName" value="<%=arrList_GoodsName%>" />

				<input type="hidden" name="sndPaymethod" id="sndPaymethod" value="" readonly="readonly" />

				<!-- <input type="hidden" name="sndStoreid" value="2999199999" size="15" maxlength="10" readonly="readonly">	<%'상점아이디 : 테스트용 아이디: 2999199999 (테스트이후 실제발급아이디로 변경)%> -->
				<input type="hidden" name="sndStoreid" value="<%=TX_KSNET_TID%>" size="15" maxlength="10" readonly="readonly">	<%'상점아이디 : 스타컴즈 실거래 아이디, 신용카드(계좌이체,가상계좌)%>
				<input type="hidden" name="sndOrdernumber" value="<%=orderNum%>" size="30" readonly="readonly">	<%'주문번호%>
				<input type="hidden" name="sndGoodname" value="<%=arrList_GoodsName%>" size="30" readonly="readonly">
				<input type="hidden" name="sndAmount" value="<%=TOTAL_SUM_PRICE%>" size="15" maxlength="9" readonly="readonly">
				<input type="hidden" name="sndOrdername" value="<%=DK_MEMBER_NAME%>" size="30" readonly="readonly">	<%'주문자명%>
				<input type="hidden" name="sndEmail" value="" size="30" readonly="readonly">	<%'KSPAY에서 결제정보를 메일로 보내줍니다.(신용카드거래에만 해당)%>
				<input type="hidden" name="sndMobile" value="" size="12" maxlength="12" readonly="readonly">

				<!-- 1. 신용카드 관련설정 -->
				<!-- 화폐단위 원화로 설정 : 410 또는 WON -->
				<input type="hidden"	name=sndCurrencytype value="WON" readonly="readonly"> <!-- 원화(WON), 달러(USD) -->

				<!--상점에서 적용할 할부개월수를 세팅합니다. 여기서 세팅하신 값은 KSPAY결재팝업창에서 고객이 스크롤선택하게 됩니다 -->
				<!--아래의 예의경우 고객은 0~12개월의 할부거래를 선택할수있게 됩니다. -->
				<input type="hidden"	name=sndInstallmenttype value="ALL(0:2:3:4:5:6:7:8:9:10:11:12)" readonly="readonly">

				<!--무이자 구분값은 중요합니다. 무이자 선택하게 되면 상점쪽에서 이자를 내셔야합니다.-->
				<!--무이자 할부를 적용하지 않는 업체는 value='NONE" 로 넘겨주셔야 합니다. -->
				<!--예 : 모두 무이자 적용할 때는 value="ALL" / 무이자 미적용할 때는 value="NONE" -->
				<!--예 : 3,4,5,6개월 무이자 적용할 때는 value="3:4:5:6" -->
				<input type="hidden"	name=sndInteresttype value="NONE" readonly="readonly">

				<!-- 신용카드표시구분  -->
				<input type="hidden"  name=sndShowcard value="C" readonly="readonly">

				<input type="hidden" name="sndCharSet"  value="utf-8" readonly="readonly"><%'sndCharSet 추가 2020-09-18%>

				<input type="hidden" name=sndReply value="<%=HTTPS%>://<%=houUrl%>" style="width: 550px;" readonly="readonly">
				<input type="hidden" name=sndEscrow value="0" readonly="readonly">					<!--에스크로적용여부-- 0: 적용안함, 1: 적용함 -->
				<input type="hidden" name=sndVirExpDt value="" readonly="readonly">					<!-- 마감일시 -->
				<input type="hidden" name=sndVirExpTm value="" readonly="readonly">					<!-- 마감시간 -->
				<input type="hidden" name=sndStoreName value="케이에스페이(주)" readonly="readonly"><!--회사명을 한글로 넣어주세요(최대20byte)-->
				<input type="hidden" name=sndStoreNameEng value="kspay" readonly="readonly">		<!--회사명을 영어로 넣어주세요(최대20byte)-->
				<input type="hidden" name=sndStoreDomain value="http://www.kspay_test.co.kr" readonly="readonly"><!-- 회사 도메인을 http://를 포함해서 넣어주세요-->
				<input type="hidden" name=sndGoodType value="1" readonly="readonly">				<!--실물(1) / 디지털(2) -->
				<input type="hidden" name=sndUseBonusPoint value="" readonly="readonly">			<!-- 포인트거래시 60 -->
				<input type="hidden" name=sndRtApp value="" readonly="readonly">					<!-- 하이브리드APP 형태로 개발시 사용하는 변수 -->
				<input type="hidden" name=sndStoreCeoName value="" readonly="readonly">				<!--  카카오페이용 상점대표자명 -->
				<input type="hidden" name=sndStorePhoneNo value="" readonly="readonly">				<!--  카카오페이 연락처 -->
				<input type="hidden" name=sndStoreAddress value="" readonly="readonly">				<!--  카카오페이 주소 -->



				<!-- 2. 온라인입금(가상계좌) 관련설정 -->
				<!-- <input type="hidden"	name=sndEscrow value="0" readonly="readonly">  -->			        <!-- 에스크로사용여부 (0:사용안함, 1:사용) -->

				<!-- 3. 계좌이체 현금영수증발급여부 설정 -->
				<!-- <input type="hidden"  name=sndCashReceipt value="0" readonly="readonly"> -->          <!--계좌이체시 현금영수증 발급여부 (0: 발급안함, 1:발급) -->


				<!----------------------------------------------- <Part 3. 승인응답 결과데이터>  ----------------------------------------------->
				<!-- 결과데이타: 승인이후 자동으로 채워집니다. (*변수명을 변경하지 마세요) -->

				<!-- <input type="hidden" name=reWHCid		value="" readonly="readonly">
				<input type="hidden" name=reWHCtype	value="" readonly="readonly">
				<input type="hidden" name=reWHHash		value="" readonly="readonly"> -->

				<!--------------------------------------------------------------------------------------------------------------------------->

				<!--업체에서 추가하고자하는 임의의 파라미터를 입력하면 됩니다.-->
				<!--이 파라메터들은 지정된결과 페이지(kspay_result.asp)로 전송됩니다.-->

				<input type="hidden" name="ECHA" value="" readonly="readonly">
				<input type="hidden" name="ECHB" value="" readonly="readonly">
				<input type="hidden" name="ECHC" value="" readonly="readonly">
				<input type="hidden" name="ECHD" value="" readonly="readonly">
				<!--------------------------------------------------------------------------------------------------------------------------->

				<%'웹프로 모바일CS 인자값 추가 S%>
				<input type="hidden" name="ECH_paykind" value="" readonly="readonly">
				<input type="hidden" name="ECH_OrdNo" value="" readonly="readonly">
				<input type="hidden" name="ECH_cuidx" value="" readonly="readonly">
				<input type="hidden" name="ECH_gopaymethod" value="" readonly="readonly">
				<input type="hidden" name="ECH_orderMode" value="" readonly="readonly">
				<input type="hidden" name="ECH_strEmail" value="" readonly="readonly">
				<input type="hidden" name="ECH_takeName" value="" readonly="readonly">
				<input type="hidden" name="ECH_takeTel" value="" readonly="readonly">
				<input type="hidden" name="ECH_takeMobile" value="" readonly="readonly">
				<input type="hidden" name="ECH_takeZip" value="" readonly="readonly">
				<input type="hidden" name="ECH_takeADDR1" value="" readonly="readonly">
				<input type="hidden" name="ECH_takeADDR2" value="" readonly="readonly">
				<input type="hidden" name="ECH_ori_price" value="" readonly="readonly">
				<input type="hidden" name="ECH_totalPrice" value="" readonly="readonly">
				<input type="hidden" name="ECH_totalDelivery" value="" readonly="readonly">
				<input type="hidden" name="ECH_DeliveryFeeType" value="" readonly="readonly">
				<input type="hidden" name="ECH_GoodsPrice" value="" readonly="readonly">
				<input type="hidden" name="ECH_usePoint" value="" readonly="readonly">
				<input type="hidden" name="ECH_usePoint2" value="" readonly="readonly">
				<input type="hidden" name="ECH_GoodsName" value="" readonly="readonly">
				<input type="hidden" name="ECH_TOTAL_POINTUSE_MAX" value="" readonly="readonly">
				<input type="hidden" name="ECH_orderMemo" value="" readonly="readonly">
				<input type="hidden" name="ECH_bankidx" value="" readonly="readonly">
				<input type="hidden" name="ECH_bankingName" value="" readonly="readonly">
				<input type="hidden" name="ECH_ea" value="" readonly="readonly">
				<input type="hidden" name="ECH_OIDX" value="" readonly="readonly">
				<input type="hidden" name="ECH_isDirect" value="" readonly="readonly">
				<input type="hidden" name="ECH_GoodIDX" value="" readonly="readonly">
				<input type="hidden" name="ECH_v_SellCode" value="" readonly="readonly">
				<input type="hidden" name="ECH_SalesCenter" value="" readonly="readonly">
				<input type="hidden" name="ECH_DtoD" value="" readonly="readonly">
				<%'웹프로 모바일CS 추가 E%>


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
		Db.makeParam("@totalPrice",adInteger,adParamInput,0,TOTAL_SUM_PRICE), _
		Db.makeParam("@deliveryFee",adDouble,adParamInput,16,TOTAL_DELIVERYFEE), _
		Db.makeParam("@intIDX",adInteger,adParamInput,0,orderTempIDX), _
		Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
	)
	Call Db.exec("DKP_ORDER_TOTAL_PRICE_UPDATE2",DB_PROC,arrParams,DB3)
	''Call Db.exec("DKP_ORDER_TOTAL_PRICE_UPDATE",DB_PROC,arrParams,DB3)
	OUTPUT_VALUE = arrParams(Ubound(arrParams))(4)
	Select Case OUTPUT_VALUE
		Case "FINISH"
		Case "ERROR" : Call ALERTS(LNG_CS_ORDERS_ALERT06,"BACK","")
		Case "NOTORDER" : Call ALERTS(LNG_CS_ORDERS_ALERT07,"BACK","")
	End Select
%>
<script type="text/javascript" src="/m/shop/order.bottom.js"></script>
<!--#include virtual="/m/_include/modal_config.asp" -->
<!--#include virtual = "/m/_include/copyright.asp"-->
