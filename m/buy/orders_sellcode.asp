<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	PAGE_SETTING = "MY_BUY"

	Call FNC_ONLY_CS_MEMBER()

	'신버전 카트상품선택(2015-11-05)


	If Not checkRef(houUrl &"/m/buy/goodsList_sellcode.asp") Then Call alerts(LNG_ALERT_WRONG_ACCESS,"back","")

	'CATA 회원매출 1주문번호에 1개의 상품, 1개만 구매(2016-10-23) 전체
	If MEMBER_ORDER_CHK01_ALL > 0 Then Call alerts(LNG_CS_GOODSLIST_TEXT01_CATA,"back","")

	ncode = gRequestTF("nCode",True)
	inUidx = 1
	'inUidx = Trim(pRequestTF("nCode",True))
	If inUidx = "" Then Call ALERTS(LNG_CS_ORDERS_ALERT01,"go","cart.asp")

	'//////////////////////////////////////////////////////////////////////////////////
	Function makeOrderNo()
		Dim nowTime : nowTime = Now
		Dim firstDay, startTime
		Dim no1_head, no2_year, no3_dayNum, no4_secondNum, no5_rndNo

		firstDay = Year(nowTime) &"-01-01"
		startTime = FormatDateTime(nowTime, 2) &" 00:00:00"

		Randomize
		rndNo = Int(Rnd * 99+Second(nowTime))

		no1_head = "MM"
		no2_year = Right(Year(nowTime), 2)
		no3_dayNum = Right("00"& (DateDiff("d", firstDay, nowTime)+1), 3)
		no4_secondNum = Right("0000"& DateDiff("s", startTime, nowTime), 5)
		no5_rndNo = Right("0"& rndNo, 2)

		makeOrderNo = no1_head & no2_year & no3_dayNum & no4_secondNum & no5_rndNo
	End Function
	' ////////////////////////////////////////////////////////////////////////////////


	arrUidx = Split(inUidx,",")
	orderNum = makeOrderNo()

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
	orderTempIDX = arrParams(UBound(arrParams)-1)(4)
	OUTPUT_VALUE = arrParams(UBound(arrParams))(4)

	If OUTPUT_VALUE = "ERROR" Then Call ALERTS(LNG_CS_ORDERS_ALERT02,"back","")


%>
<!--#include virtual = "/m/_include/document.asp"-->
<!--#include virtual = "/m/_include/jqueryload.asp"-->
<script type="text/javascript" src="/m/js/calendar.js"></script>
<link rel="stylesheet" type="text/css" href="orders.css" />
<script type="text/javascript" src="/PG/CardNum/CardNum_cs.js"></script>
</head>
<script src="http://dmaps.daum.net/map_js_init/postcode.v2.js"></script>
<script src="/jscript/daumPostCode.js"></script>
<script type="text/javascript" src="/PG/YESPAY/pay_cs_m.js"></script>

<body >
<!--#include virtual = "/m/_include/header.asp"-->
<!--#include virtual = "/m/_include/sub_header.asp"-->
<%


	If webproIP="T" Then
		Call ResRW(DKPG_PGCOMPANY,"웹프로_IP_VIEW - 연결PG사")
		If UCase(DKPG_PGCOMPANY) = "DAOU" Then
			Call ResRW("/PG/DAOU/pay_cs_mobile_te.js","js")
		End If
	End If
	If UCase(DKPG_PGCOMPANY) = "YESPAY" Then Call ResRW("/PG/YESPAY/pay_cs_m.js","자바연결")

%>
<div id="cart" class="cleft width100">
	<div class="cleft b_title">
		<h3 class="fleft"><span class="h3color1"><%=LNG_MYOFFICE_ORDER_03%></span> <span class="h3color2"><%=SELL_TXT%></span></h3>
	</div>
	<form name="orderFrm" id="orderFrm" onsubmit="return orderSubmit(this);" action="/PG/YESPAY/CardResult_cs.asp" method="post">
	<input type="hidden" name="cuidx" value="<%=inUidx%>" />
	<input type="hidden" name="pageType" value="mobile" />
	<input type="hidden" name="orderMode" value="mobile" />
	<div class="cleft width100" style="margin-top:10px;">
		<table <%=tableatt%> class="width100">
			<col width="45%" />
			<col width="45%" />
			<col width="10%" />
			<thead>
				<tr>
					<th colspan="3">[<%=LNG_TEXT_CSGOODS_CODE%>] <%=LNG_TEXT_ITEM_NAME%></th>
				</tr><tr>
					<th><%=LNG_TEXT_MEMBER_PRICE%></th>
					<th><%=CS_PV%></th>
					<th><%=LNG_TEXT_ITEM_NUMBER%></th>
				</tr>
			</thead>
			<%

			'	arrParams = Array(_
			'		Db.makeParam("@SELLCODE",adVarChar,adParamInput,10,SELLCODE),_
			'		Db.makeParam("@MBID",adVarChar,adParamInput,20,DK_MEMBER_ID1),_
			'		Db.makeParam("@MBID2",adInteger,adParamInput,0,DK_MEMBER_ID2) _
			'	)
			'	arrList = Db.execRsList("DKPM_CART_LIST2",DB_PROC,arrParams,listLen,DB3)
				'arrList = Db.execRsList("DKPM_CART_LIST",DB_PROC,arrParams,listLen,DB3)

				'회원번호앞자리SK=한국회원=KR
			'	CS_NATION_CODE = DK_MEMBER_ID1
			'	If UCase(CS_NATION_CODE) = "SK" THEN
			'		CS_NATION_CODE = "KR"
			'	Else
			'		CS_NATION_CODE = CS_NATION_CODE
			'	End If
			'	CS_Na_Code = CS_NATION_CODE

			'		Db.makeParam("@Na_Code",adVarWchar,adParamInput,50,CS_Na_Code)_
			'	arrParams = Array(_
			'		Db.makeParam("@MBID",adVarChar,adParamInput,20,DK_MEMBER_ID1),_
			'		Db.makeParam("@MBID2",adInteger,adParamInput,0,DK_MEMBER_ID2) _
			'	)
			'	arrList = Db.execRsList("DKPM_CART_LIST",DB_PROC,arrParams,listLen,DB3)
			'	arrList = Db.execRsList("DKPM_CART_LIST_GLOBAL",DB_PROC,arrParams,listLen,DB3)
			'	If IsArray(arrList) Then
			'		For i = 0 To listLen
			'			arrList_intIDX				= arrList(0,i)
			'			arrList_NCODE				= arrList(1,i)
			'			arrList_NAME				= arrList(2,i)
			'			arrList_price2				= arrList(3,i)	'회원가
			'			arrList_GoodUse				= arrList(4,i)
			'			arrList_price4				= arrList(5,i)	'PV : 회원매출
			'			arrList_Base_Cnt			= arrList(6,i)
			'			arrList_ea					= arrList(7,i)

					THIS_GOODS_PATTERN	= 0
					TOTAL_PRICE			= 0
					TOTAL_PV			= 0

					'For i = 0 To UBound(arrUidx)
						If ncode = "" Then Call ALERTS(LNG_CS_POPCART_ALERT01,"back","")

						SQL = "SELECT * FROM [tbl_Goods] WHERE [ncode] = ? AND [GoodUse] = 0"
						arrParams = Array(_
							Db.makeParam("@ncode",adVarChar,adParamInput,20,ncode) _
						)
						Set DKRSS = Db.execRs(SQL,DB_TEXT,arrParams,DB3)
						If Not DKRSS.BOF Or Not DKRSS.EOF Then
							RS_Ncode		= DKRSS("Ncode")
							RS_Name			= DKRSS("Name")
							RS_Price2		= DKRSS("Price2")
							RS_Price4		= DKRSS("Price4")
							RS_ea			= 1					'단품
							RS_SellCode		= DKRSS("SellCode")
							RS_Sell_VAT_Price			= DKRSS("Sell_VAT_Price")
							RS_Except_Sell_VAT_Price	= DKRSS("Except_Sell_VAT_Price")
						Else
							Call alerts(LNG_CS_ORDERS_ALERT03,"back","")
						End If
						Call closeRs(DKRSS)

						'상품가 변경내역 체크
						arrParams = Array(_
							Db.makeParam("@ncode",adVarChar,adParamInput,20,RS_ncode) _
						)
						Set DKRS = Db.execRs("DKP_GOODS_CHANGE",DB_PROC,arrParams,DB3)
						If Not DKRS.BOF And Not DKRS.EOF Then
							RS_ncode		= DKRS("ncode")
							RS_price2		= DKRS("price2")	'회원가
							RS_price4		= DKRS("price4")
							RS_Sell_VAT_Price			= DKRS("Sell_VAT_Price")				'부가세
							RS_Except_Sell_VAT_Price	= DKRS("Except_Sell_VAT_Price")		'공급가
						Else
							RS_ncode		= RS_ncode
							RS_price2		= RS_price2
							RS_price4		= RS_price4
							RS_Sell_VAT_Price			= RS_Sell_VAT_Price
							RS_Except_Sell_VAT_Price	= RS_Except_Sell_VAT_Price
						End If
						Call closeRs(DKRS)


						TOTAL_PRICE		= TOTAL_PRICE + (RS_ea * RS_price2)
						TOTAL_PV		= TOTAL_PV + (RS_ea * RS_price4)
						SELF_PRICE		= RS_price2

			%>
			<tbody id="tbody<%=i%>">
				<tr>
					<td colspan="3" class="font_14px">
						[<%=RS_NCODE%>] <strong><%=RS_NAME%></strong><%=OPTION_GOODS_MSG%><%=D_FREE_GOODS_MSG%>
					</td>
				</tr><tr>
					<td class="tright tweight font_14px" style="color:red; border-bottom:2px solid #888;"><%=num2cur(RS_price2)%> <%=CS_CURC%></td>
					<td class="tright tweight font_14px" style="color:blue; border-bottom:2px solid #888;"><span class="<%=PV_COLOR%>"><%=num2cur(RS_price4)%> <%=CS_PV%></span></td>
					<td class="tcenter tweight font_14px" style=" border-bottom:2px solid #888;"><%=RS_ea%></td>
				</tr>
			</tbody>
			<%

						arrParams2 = Array(_
							Db.makeParam("@OrderIDX",adInteger,adParamInput,0,orderTempIDX),_
							Db.makeParam("@GoodsCode",adVarChar,adParamInput,20,RS_Ncode),_
							Db.makeParam("@GoodsPrice",adVarChar,adParamInput,20,RS_Price2),_
							Db.makeParam("@GoodsPV",adInteger,adParamInput,0,RS_Price4),_
							Db.makeParam("@ea",adInteger,adParamInput,0,RS_ea),_
							Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR")_
						)
						Call Db.exec("DKP_ORDER_TEMP_GOODS_INSERT",DB_PROC,arrParams2,DB3)
						'Call Db.exec("DKP_ORDER_TEMP_GOODS_INSERT2",DB_PROC,arrParams2,DB3)
						OUTPUT_VALUE = arrParams(UBound(arrParams))(4)

						If OUTPUT_VALUE = "ERROR" Then
							Call ALERTS(LNG_CS_ORDERS_ALERT04,"BACK","")
							'Exit For
						End If

					'Next


			'	Else
			'		Call alerts(LNG_CS_ORDERS_ALERT03,"back","")
			'	End If

			%>
			<tfoot>
				<%
					If TOTAL_PRICE < 50000 Then
						DELIVERY_PRICE = CS_DELIVERY_PRICE	'strText
						DELIVERY_TXT = "※ "&LNG_CS_ORDERS_DELIVERY
					Else
						DELIVERY_PRICE = 0
						DELIVERY_TXT = "※ "&LNG_CS_ORDERS_DELIVERY_FREE
					End If

					LAST_PRICE = TOTAL_PRICE + DELIVERY_PRICE
				%>
				<tr>
					<td class="th tweight tright font_14px" style="padding:10px 10px;"><%=LNG_CS_ORDERS_TOTAL_PURCHASE_PV%></td>
					<td colspan="2" class="tweight tright font_14px" style="color:#0072bc;"><%=num2cur(TOTAL_PV)%> <%=CS_PV%></td>
				</tr><tr>
					<td class="th tweight tright font_14px" style="padding:10px 10px;"><%=LNG_CS_ORDERS_TOTAL_PURCHASE_AMOUNT%></td>
					<td colspan="2" class="tweight tright font_14px" style="color:#0072bc;"><%=num2cur(TOTAL_PRICE)%> <%=Chg_CurrencyISO%></td>
				</tr>
				<tr>
					<td colspan="3" class="th tweight tcenter font_13px" style="padding:7px 0px;background-color:#fbfff0;"><span id="delTXT"><%=DELIVERY_TXT%></span> <span id="oriTXT1" style="display:none;"><%=DELIVERY_TXT%></span></td>
				</tr>
				<tr>
					<td class="th tweight tright font_14px" style="padding:10px 10px;"><%=LNG_CS_ORDERS_DELIVERY_PRICE%></td>
					<td colspan="2" class="tweight tright font_14px" style="color:#0072bc;"><span id="priTXT"><%=num2cur(DELIVERY_PRICE)%></span> <%=Chg_CurrencyISO%> <span id="oriTXT2" style="display:none;"><%=num2cur(DELIVERY_PRICE)%></span></td>
				</tr>
				<tr>
					<td class="th tweight tright font_14px" style="padding:10px 10px;"><%=LNG_CS_ORDERS_TOTAL_PRICE%></td>
					<td colspan="2" class="th tweight tright font_14px" style="color:blue;"><span id="totalTXT"><%=num2cur(LAST_PRICE)%></span> <%=Chg_CurrencyISO%> <span id="oriTXT3" style="display:none;"><%=num2cur(LAST_PRICE)%></span></td>
				</tr>
				<tr>
					<td class="th tweight tright font_14px" style="padding:10px 10px;"><%=LNG_CS_ORDERS_FINAL_TOTAL_PRICE%></td>
					<td colspan="2" class="th tweight tright font_14px" style="color:red;"><span id="lastTXT"><%=num2cur(LAST_PRICE)%></span> <%=Chg_CurrencyISO%> <span id="oriTXT3" style="display:none;"><%=num2cur(LAST_PRICE)%></span></td>
				</tr>
			</tfoot>
		</table>
	</div>

	<!-- <div class="cleft b_title">
		<h4 class="fleft"><span class="h3color1"><%=LNG_CS_ORDERS_RECEIVE_METHOD%></span></h4>
	</div>
	<div>
		<table <%=tableatt%> style="width:100%;" class="member_info">
			<colgroup>
				<col width="110" />
				<col width="*" />
			</colgroup>
			<tbody>
				<tr>
					<th><%=LNG_CS_ORDERS_RECEIVE_METHOD%></th>
					<td>
						<label><input type="radio" name="DtoD" class="input_chk" value="T" checked="checked" /> <%=LNG_CS_ORDERS_RECEIVE_DELIVERY%></label>
						<label><input type="radio" name="DtoD" class="input_chk" value="F" /> <%=LNG_CS_ORDERS_RECEIVE_PICKUP%></label>
					</td>
				</tr>
			</tbody>
		</table>
	</div> -->


	<div id="DtoD_toggle">
		<div class="cleft b_title">
			<h4 class="fleft"><span class="h3color1"><%=LNG_CS_ORDERS_DELIVERY_INFO%></span></h4>
		</div>
		<%
			arrParams = Array(_
				Db.makeParam("@mbid",adVarChar,adParamInput,20,DK_MEMBER_ID1), _
				Db.makeParam("@mbid2",adInteger,adParamInput,0,DK_MEMBER_ID2) _
			)
			Set DKRS = Db.execRs("DKP_MEMBER_INFO",DB_PROC,arrParams,DB3)
			If Not DKRS.BOF And Not DKRS.EOF Then
				DKRS_M_Name			= DKRS("M_Name")
				DKRS_E_name			= DKRS("E_name")
				DKRS_Addcode1		= DKRS("Addcode1")
				DKRS_Address1		= DKRS("Address1")
				DKRS_Address2		= DKRS("Address2")
				DKRS_Address3		= DKRS("Address3")
				DKRS_hometel		= DKRS("hometel")
				DKRS_hptel			= DKRS("hptel")
				DKRS_Email			= DKRS("Email")

				If RS_WebID = "" Then RS_WebID = "웹아이디 미등록 계정"

				If DKCONF_SITE_ENC = "T" Then
					Set objEncrypter = Server.CreateObject ("Hyeongryeol.StringEncrypter")
						objEncrypter.Key = con_EncryptKey
						objEncrypter.InitialVector = con_EncryptKeyIV
						If DKRS_Address1	<> "" Then DKRS_Address1	= objEncrypter.Decrypt(DKRS_Address1)
						If DKRS_Address2	<> "" Then DKRS_Address2	= objEncrypter.Decrypt(DKRS_Address2)
						If DKRS_Address3	<> "" Then DKRS_Address3	= objEncrypter.Decrypt(DKRS_Address3)
						If DKRS_hometel		<> "" Then DKRS_hometel		= objEncrypter.Decrypt(DKRS_hometel)
						If DKRS_hptel		<> "" Then DKRS_hptel		= objEncrypter.Decrypt(DKRS_hptel)

						If DKCONF_ISCSNEW = "T" Then	''▣CS신버전 암/복호화 추가
							If DKRS_Email		<> "" Then DKRS_Email		= objEncrypter.Decrypt(DKRS_Email)
						End If
					Set objEncrypter = Nothing
				End If


				'If DKRS_hometel = "" Or IsNull(DKRS_hometel) Then DKRS_hometel = "--"
				'If DKRS_hptel = "" Or IsNull(DKRS_hptel) Then DKRS_hptel = "--"

				'	arrTEL = Split(DKRS_hometel,"-")
				'	arrMob = Split(DKRS_hptel,"-")
				If DKRS_Email = "" Or IsNull(DKRS_Email) Then DKRS_Email = "@"
					arrMAIL = Split(DKRS_Email,"@")



			Else
				Call ALERTS(LNG_JS_MEMBERINFO_FAIL,"back","")
			End If
			Call closeRS(DKRS)
		%>
		<div id="member">
			<table <%=tableatt%> style="width:100%;" class="member_info">
				<colgroup>
					<col width="110" />
					<col width="*" />
				</colgroup>
				<tbody>
					<tr>
						<th><%=LNG_CS_ORDERS_DELIVERY_NAME%></th>
						<td><input type="text" name="takeName"  class="input_text width95a" value="<%=DK_MEMBER_NAME%>" /></td>
					</tr><tr class="line">
						<th>우편번호 <%=starText%></th>
						<td>
							<div style="width:57%;" class="fleft" ><input type="text" name="takeZip" id="takeZipDaum" class="input_text width95a" value="<%=DKRS_Addcode1%>" maxlength="7" /></div><div class="fleft" style="width:3%;"></div><div style="width:40%;" class="fleft"><input type="button" id="ZipBtn" name="" class="input_btn width95a" value="우편번호입력"  onclick="execDaumPostcode('takes');" /></div>
						</td>
					</tr><tr class="line">
						<th><%=LNG_TEXT_ADDRESS1%> <%=starText%></th>
						<td><input type="text" name="takeADDR1" id="takeADDR1Daum" class="input_text width95a" value="<%=DKRS_Address1%>" /></td>
					</tr><tr>
						<th><%=LNG_TEXT_ADDRESS2%> <%=starText%></th>
						<td><input type="text" name="takeADDR2" id="takeADDR2Daum" class="input_text width95a" value="<%=DKRS_Address2%>" /></td>
					</tr><tr>
						<th><%=LNG_TEXT_EMAIL%> <%=starText%></th>
						<td><input type="email" name="strEmail" class="input_text width95a" value="<%=DKRS_Email%>" /></td>
					</tr><tr>
						<th><%=LNG_TEXT_MOBILE%> <%=starText%></th>
						<td><input type="tel" name="takeMob" class="input_text width95a" value="<%=DKRS_hptel%>" <%=onlyKeys%> /></td>
					</tr><tr>
						<th><%=LNG_TEXT_TEL%></th>
						<td><input type="tel" name="takeTel" class="input_text width95a" value="<%=DKRS_hometel%>" <%=onlyKeys%> /></td>
					</tr>
				</tbody>
			</table>
		</div>
	</div>

	<div id="" class="cleft b_title">
		<h4 class="fleft"><span class="h3color1"><%=LNG_CS_ORDERS_ETC%></span></h4>
	</div>
	<div>
		<table <%=tableatt%> style="width:100%;" class="member_info">
			<colgroup>
				<col width="110" />
				<col width="*" />
			</colgroup>
			<tbody>
				<%If THIS_GOODS_PATTERN > 0 Then%>
					<tr>
						<th>옵션 및 기타사항 <%=starText%></th>
						<td><input type="text" class="input_text" name="v_Get_Etc1" value="" />
							<p style="margin-top:10px; color:#cc6633;"><span class="summary">* 옵션 필수 상품을 선택하셨습니다. 상품의 옵션을 확인하시고 정확한 옵션사항을 적어주시기 바랍니다.(사이즈, 성별, 색상 등)</span><p>
						</td>
					</tr>
				<%End If%>
				<tr class="lheight130">
					<th><%=LNG_TEXT_SALES_TYPE%></th>
					<td>
						<select name="v_SellCode">
							<!-- <option value=""><%=LNG_TEXT_SALES_TYPE_SELECT%></option> -->
							<%
								If RS_SellCode <> "01" Then Call ALERTS("회원매출상품만 구매 가능합니다.  ","BACK","")

								'▣구매종류 선택
								arrParams = Array(_
									Db.makeParam("@SELLCODE",adVarChar,adParamInput,10,RS_SellCode) _
								)
								arrListB = Db.execRsList("DKP_SELLTYPE_LIST2",DB_PROC,arrParams,listLenB,DB3)
								'arrListB = Db.execRsList("DKP_SELLTYPE_LIST",DB_PROC,Nothing,listLenB,DB3)

								If IsArray(arrListB) Then
									For i = 0 To listLenB
										PRINT TABS(4)&"	<option value="""&arrListB(0,i)&""">"&arrListB(1,i)&"</option>"
									Next
								Else
									PRINT TABS(4)&"	<option value="""">"&LNG_CS_ORDERS_TEXT34&"</option>"
								End If
							%>
						</select>
					</td>
				</tr>
				<!-- <tr>
					<th>배송구분</th>
					<td style="padding-left:5px;">
						<select name="v_Receive_Method">
							<option value="">배송구분선택</option>
							<option value="1">직접수령</option>
							<option value="2">택배수령</option>
							<option value="3">센타수령</option>
						</select>
					</td>
				</tr> -->
			</tbody>
		</table>
	</div>

	<!--  -->
	<%
		'▣제품구매관련 약관(파인애플 2017-02-01)
		arrParams2 = Array(_
			Db.makeParam("@policyType",adVarChar,adParamInput,10,"policy04") ,_
			Db.makeParam("@strNation",adVarChar,adParamInput,10,UCase(LANG)) _
		)
		viewContent = Db.execRsData("DKP_POLICY_CONTENT",DB_PROC,arrParams2,Nothing)
	%>
	<div id="" class="cleft b_title">
		<h4 class="fleft"><span class="h3color1">제품구매 약관동의</span></h4>
	</div>
	<div class="in_content" style="margin-top:45px;">
		<div class="alert3"><%=backword(viewContent)%></div>
		<p class="agree Area tweight" style="font-size:16px;margin-top:-14px;"><label><input type="checkbox" name="agreement" value="T" id="agree01Chk" class="" style="width:18px;height:18px;"/> 제품구매약관에 동의합니다.</label>
	</div>
	<!--  -->


	<div class="cleft b_title">
		<h4 class="fleft"><span class="h3color1"><%=LNG_CS_ORDERS_PAYMENT_METHOD%></span></h4>
	</div>
	<div>
		<table <%=tableatt%> class="width100 member_info">
			<colgroup>
				<col width="110" />
				<col width="*" />
			</colgroup>
			<tr class="lheight130">
				<th rowspan="2"><%=LNG_CS_ORDERS_PAYMENT_METHOD%></th>
				<td class="payway" style="height:25px;"><input type="radio" name="payKind" id="pays3" class="input_chk" value="inBank" onclick="payKindSelect(this.value)"   /><label for="pays3"><%=LNG_TEXT_ORDER_BANK%></label></td>
			</tr>
			<tr>
				<td class="payway" style="height:25px;"><input type="radio" name="payKind" id="pays1" class="input_chk" value="Card" onclick="payKindSelect(this.value)" /><label for="pays1"><%=LNG_TEXT_ORDER_CARD%></label></td>
			</tr>
			<tbody id="inBankInfo" style="display:none;">
				<td colspan="2" style="padding:20px 10px;background-color:#e8e8e8">
					<div style="background-color:#fff; padding:10px; border:1px solid #e2e2e2;">
						<table <%=tableatt%> class="inTable width100">
							<col width="130" />
							<col width="*" />
							<tr class="lheight130">
								<th><%=LNG_CS_ORDERS_BANK_NAME%></th>
								<td>
									<select name="C_codeName" style="width:150px;">
										<option value=""><%=LNG_CS_ORDERS_BANK_NAME_SELECT%></option>
										<%
											'GLOBAL
											SQLB = "SELECT * FROM [tbl_BankForCompany] AS A"
											SQLB = SQLB& " JOIN [tbl_Bank] AS B ON B.[ncode] = A.[BankCode]"
											SQLB = SQLB& " WHERE B.[Na_Code] = '"&UCase(DK_MEMBER_NATIONCODE)&"' "
											arrListB = Db.execRsList(SQLB,DB_TEXT,Nothing,listLenB,DB3)
											'arrListB = Db.execRsList("DKP_BANK_LIST2",DB_PROC,Nothing,listLenB,DB3)
											If IsArray(arrListB) Then
												For i = 0 To listLenB

													If DKCONF_SITE_ENC = "T" Then
														Set objEncrypter = Server.CreateObject ("Hyeongryeol.StringEncrypter")
															objEncrypter.Key = con_EncryptKey
															objEncrypter.InitialVector = con_EncryptKeyIV
															If DKCONF_ISCSNEW = "T" Then										'▣CS신버전 암/복호화 추가
																If arrListB(4,i) <> "" Then arrListB(4,i) = objEncrypter.Decrypt(arrListB(4,i))
															End If
														Set objEncrypter = Nothing
													End If

													PRINT TABS(4)&"	<option value="""&arrListB(1,i)&","&arrListB(2,i)&","&arrListB(3,i)&","&arrListB(4,i)&""">["&arrListB(2,i)&"] "&arrListB(4,i)&" - "&arrListB(3,i)&"</option>"
												Next
											Else
												PRINT TABS(4)&"	<option value="""">"&LNG_CS_ORDERS_TEXT41&"</option>"
											End If
										%>
									</select>
								</td>
							</tr><tr>
								<th><%=LNG_TEXT_DEPOSITOR%></th>
								<td><input type="text" name="C_NAME2" class="input_text" style="" /></td>
							</tr><tr>
								<th><%=LNG_CS_ORDERS_TRANSFER_DATE%></th>
								<td><input type="text" name="memo1" class="input_text" style="" onclick="openCalendar(event, this, 'YYYY-MM-DD');" readonly="readonly" /></td>
							</tr>
						</table>
					</div>
				</td>
			</tbody>
			<tbody id="CardInfo" style="display:none;">
				<tr>
					<td colspan="3" style="padding:10px;">
						<div class="width100">
							<table <%=tableatt%> class="width100">
								<col width="120" />
								<col width="*" />
								<tr>
									<th>카드번호</th>
									<td style="padding-left:5px;">
										<input type="text" name="cardNo1" class="input_text tcenter" maxlength="4" style="width:60px;" placeholder="4자리" <%=onlyKeys%> value="" /> -
										<input type="text" name="cardNo2" class="input_text tcenter" maxlength="4" style="width:60px;" placeholder="4자리" <%=onlyKeys%> value="" /> -
										<input type="text" name="cardNo3" class="input_text tcenter" maxlength="4" style="width:60px;" placeholder="4자리" <%=onlyKeys%> value="" /> -
										<input type="text" name="cardNo4" class="input_text tcenter" maxlength="4" style="width:60px;" placeholder="4자리" <%=onlyKeys%> value="" />
									</td>
								</tr><tr>
									<th>유효기간</th>
									<td style="padding-left:5px;">
										<input type="text" name="card_mm" class="input_text tcenter" maxlength="2" style="width:90px;" placeholder="유효기간(월)" <%=onlyKeys%> value="" /> 월
										<input type="text" name="card_yy" class="input_text tcenter" maxlength="4" style="width:90px;" placeholder="유효기간(년)" <%=onlyKeys%> value="" /> 년
									</td>
								</tr>
								<tr class="lastTD">
									<th>할부정보</th>
									<td style="padding-left:5px;">
										<select name="quotabase" class="selects">
											<%If LAST_PRICE > 49999 Then%>
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
										<span class="f11px" style="margin-left:9px;">신용카드 5만원 이상 할부거래 가능</span>
									</td>
								</tr>
							</table>
						</div>
					</td>
				</tr>
			</tbody>


				<!-- <tr>
					<td class="payway" colspan="2" style="height:25px;"><input type="radio" name="payKind" id="pays2" class="input_chk" value="inCash"  /><label for="pays2"><%=LNG_TEXT_ORDER_CASH%></label></td>
				</tr> --><!-- <tr>
					<td class="payway" colspan="2" style="height:25px;"><input type="radio" name="payKind" id="pays4" class="input_chk" value="dBank"  /><label for="pays4">실시간계좌이체</label></td>
				</tr><tr>
					<td class="payway" colspan="2" style="height:25px;"><input type="radio" name="payKind" id="pays5" class="input_chk" value="vBank"  /><label for="pays5">가상계좌(무통장입금)</label></td>
				</tr><tr>
					<td class="payway" colspan="2" style="height:25px;"><input type="radio" name="payKind" id="pays6" class="input_chk" value="point"  /><label for="pays6"><%=SHOP_POINT%> 단독결제</label></td>
				</tr> -->

			<tbody id="pays2view" style="display:none;">
				<tr>
					<td colspan="2" style=" font-size:20px; font-weight:bold; padding:15px 0px;">현장 결제는 구입자가 사업장에서 직접 결제하는 방식입니다.</td>
				</tr>
			</tbody>

		</table>
	</div>
</div>
		<input type="hidden" name="gopaymethod" id="paysKind" value="" />
		<input type="hidden" name="totalPrice" value="<%=LAST_PRICE%>" />
		<input type="hidden" name="totalDelivery" value="<%=DELIVERY_PRICE%>" />
		<input type="hidden" name="totalOptionPrice" value="<%=totalOptionPrice%>" />
		<input type="hidden" name="totalPoint" value="<%=total_point%>" />
		<input type="hidden" name="totalVotePoint" value="<%=total_voterpoint%>" />
		<input type="hidden" name="strOption" value="<%=strOption%>" />

		<input type="hidden" name="gptn" value="<%=THIS_GOODS_PATTERN%>">
		<input type="hidden" name="OrdNo" value="<%=orderNum%>" readonly="readonly"/>
		<input type="hidden" name="OIDX" value="<%=orderTempIDX%>" readonly="readonly"/>
			<input type="hidden" name="goodsName" size="50" value="<%=RS_Name%>" />

		<input type="hidden" name="ori_price" value="<%=LAST_PRICE%>" />
		<input type="hidden" name="ori_delivery" value="<%=DELIVERY_PRICE%>" readonly="readonly" />

		<input type="hidden" name="mbid1" value="<%=DK_MEMBER_ID1%>" />
		<input type="hidden" name="mbid2" value="<%=DK_MEMBER_ID2%>" />
		<input type="hidden" name="isDownOrder" value="F" />			<!-- 본인구매 -->

		<div id="" class="width100" style="margin-top:10px">
			<div class="clear" style=" margin:0px 10px; overflow:hidden;">
				<div><input type="submit" class="mBtn joinBtn jBtn1 tcenter" style="width:49%" onclick="" value="<%=LNG_CS_ORDERS_BTN01%>"/></div>
			</div>
		</div>

	 </form>


	<%
	'	arrParams = Array(_
	'		Db.makeParam("@MBID",adVarChar,adParamInput,20,DK_MEMBER_ID1),_
	'		Db.makeParam("@MBID2",adInteger,adParamInput,0,DK_MEMBER_ID2) _
	'	)
	'	Call Db.exec("DKPM_ORDER_TEMP_OLD_DELETE",DB_PROC,arrParams,DB3)


		arrParams = Array(_
			Db.makeParam("@OrderNum",adVarChar,adParamInput,20,orderNum),_
			Db.makeParam("@totalPrice",adInteger,adParamInput,0,LAST_PRICE), _
			Db.makeParam("@intIDX",adInteger,adParamInput,0,orderTempIDX), _
			Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
		)
		Call Db.exec("DKPM_ORDER_TOTAL_PRICE_UPDATE",DB_PROC,arrParams,DB3)
		OUTPUT_VALUE = arrParams(Ubound(arrParams))(4)
		Select Case OUTPUT_VALUE
			Case "FINISH"
			Case "ERROR" : Call ALERTS(LNG_CS_ORDERS_ALERT06,"BACK","")
			Case "NOTORDER" : Call ALERTS(LNG_CS_ORDERS_ALERT07,"BACK","")
		End Select

	%>



</div>
<!--#include virtual = "/m/_include/copyright.asp"-->
