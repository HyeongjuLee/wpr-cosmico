<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	PAGE_SETTING = "MY_BUY"

	Call FNC_ONLY_CS_MEMBER()

	'신버전 카트상품선택(2015-11-05)


	'SELLCODE = Trim(pRequestTF("v_SellCode",True))
	'If SELLCODE = "" Then Call ALERTS("구매종류가 등록되지 않았습니다.","BACK","")

	inUidx = Trim(pRequestTF("nCode",True))

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
	Call Db.exec("DKPM_ORDER_TEMP_INSERT",DB_PROC,arrParams,DB3)
	orderTempIDX = arrParams(UBound(arrParams)-1)(4)
	OUTPUT_VALUE = arrParams(UBound(arrParams))(4)

	If OUTPUT_VALUE = "ERROR" Then Call ALERTS(LNG_CS_ORDERS_ALERT02,"back","")


%>
<!--#include virtual = "/m/_include/document.asp"-->
<!--#include virtual = "/m/_include/jqueryload.asp"-->
<script type="text/javascript" src="/js/ajax.js"></script>
<!-- <script type="text/javascript" src="orders.js"></script> -->
<script type="text/javascript" src="/m/js/calendar.js"></script>
<script type="text/javascript" src="/js/check.js"></script>
<link rel="stylesheet" type="text/css" href="orders.css" />
<script type="text/javascript" src="/PG/DAOU/pay_cs_mobile_te.js"></script>
<!-- <script language=javascript src="/PG/DAOU/pay.js"></script> -->
<script src="https://spi.maps.daum.net/imap/map_js_init/postcode.v2.js"></script>
<script src="/jscript/daumPostCode.js"></script>
</head>
<script type="text/javascript">
<!--
// -->
</script>
<body  onload="init();" onunload="">
<!--#include virtual = "/m/_include/header.asp"-->
<!--#include virtual = "/m/_include/sub_header.asp"-->
<%
	DKPG_PGCOMPANY = "DAOU"


	If webproIP="T" Then
		Call ResRW(DKPG_PGCOMPANY,"웹프로_IP_VIEW - 연결PG사")
		If UCase(DKPG_PGCOMPANY) = "DAOU" Then
			Call ResRW("/PG/DAOU/pay_cs_mobile_te.js","js")
		End If
	End If

%>
<div id="cart" class="cleft width100">
	<div class="cleft b_title">
		<h3 class="fleft"><span class="h3color1"><%=LNG_MYOFFICE_ORDER_03%></span> <span class="h3color2"><%=SELL_TXT%></span></h3>
	</div>
	<form name="frmConfirm" id="frmConfirm" onsubmit="return fnSubmit();" method="post" data-ajax="false">
	<input type="hidden" name="cuidx" value="<%=inUidx%>" />
	<input type="hidden" name="orderTempIDX" maxlength="400" value="<%=orderTempIDX%>" />
	<input type="hidden" name="orderNum" maxlength="40" value="<%=orderNum%>" />
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

					For i = 0 To UBound(arrUidx)

						SQL = "SELECT * FROM [DK_CART] WHERE [intIDX] = ?"
						arrParams = Array(_
							Db.makeParam("@intIDX",adInteger,adParamInput,0,arrUidx(i)), _
							Db.makeParam("@MBID",adVarChar,adParamInput,20,DK_MEMBER_ID1),_
							Db.makeParam("@MBID2",adInteger,adParamInput,0,DK_MEMBER_ID2)_
						)
						Set DKRSS =  Db.execRS("DKP_DKP_CART_ONE",DB_PROC,arrParams,DB3)
						If Not DKRSS.BOF Or Not DKRSS.EOF Then
							arrList_NCODE		= DKRSS("Ncode")
							arrList_NAME		= DKRSS("Name")
							arrList_price2		= DKRSS("Price2")
							arrList_price4		= DKRSS("Price4")
							arrList_ea			= DKRSS("ea")
							arrList_Bc			= 1';DKRSS("Base_Cnt")
							arrList_Price6		= DKRSS("Price6")
							arrList_SellCode	= DKRSS("SellCode")
						Else
							Call alerts(LNG_CS_ORDERS_ALERT03,"back","")
						End If
						Call closeRs(DKRSS)

						'▣CS상품정보 변동정보 통합
						arrParams = Array(_
							Db.makeParam("@ncode",adVarChar,adParamInput,20,arrList_NCODE) _
						)
						Set DKRS = Db.execRs("HJP_CSGOODS_PRICE_INFO",DB_PROC,arrParams,DB3)
						If Not DKRS.BOF And Not DKRS.EOF Then
							arrList_ncode		= DKRS("ncode")
							arrList_price2		= DKRS("price2")
							arrList_price4		= DKRS("price4")
							arrList_price5		= DKRS("price5")
							arrList_price6		= DKRS("price6")
						End If
						Call closeRs(DKRS)


	'▣더리코(마이오피스 재구매매출02 상품만 구매(2017-03-31)
	If arrList_SellCode <> "02" Then Call ALERTS("재구매매출 상품만 구입할 수 있습니다.","back","")


						TOTAL_PRICE		= TOTAL_PRICE + (arrList_ea * arrList_PRICE2)
						TOTAL_PV		= TOTAL_PV + (arrList_ea * arrList_price4)
						SELF_PRICE		= arrList_PRICE2

			%>
			<tbody id="tbody<%=i%>">
				<tr>
					<td colspan="3" class="font_14px">
						[<%=arrList_NCODE%>] <strong><%=arrList_NAME%></strong><%=OPTION_GOODS_MSG%><%=D_FREE_GOODS_MSG%>
						<input type="hidden" name="oxid" id="oxid<%=i%>" value="<%=arrList_NCODE%>" />
						<input type="hidden" name="c_idx" value="<%=arrList_intIDX%>" />
					</td>
				</tr><tr>
					<td class="tright tweight font_14px" style="color:red; border-bottom:2px solid #888;"><%=num2cur(arrList_PRICE2)%> <%=Chg_CurrencyISO%></td>
					<td class="tright tweight font_14px" style="color:blue; border-bottom:2px solid #888;"><span class="<%=PV_COLOR%>"><%=num2cur(arrList_price4)%> <%=CS_PV%></span></td>
					<td class="tcenter tweight font_14px" style=" border-bottom:2px solid #888;"><%=arrList_ea%></td>
				</tr>
			</tbody>
			<%

						arrParams2 = Array(_
							Db.makeParam("@OrderIDX",adInteger,adParamInput,0,orderTempIDX),_
							Db.makeParam("@GoodsCode",adVarChar,adParamInput,20,arrList_NCODE),_
							Db.makeParam("@GoodsPrice",adVarChar,adParamInput,20,arrList_PRICE2),_
							Db.makeParam("@GoodsPV",adInteger,adParamInput,0,arrList_price4),_
							Db.makeParam("@ea",adInteger,adParamInput,0,arrList_ea),_
							Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR")_
						)
						Call Db.exec("DKP_ORDER_TEMP_GOODS_INSERT",DB_PROC,arrParams2,DB3)
						'Call Db.exec("DKP_ORDER_TEMP_GOODS_INSERT2",DB_PROC,arrParams2,DB3)
						OUTPUT_VALUE = arrParams(UBound(arrParams))(4)

						If OUTPUT_VALUE = "ERROR" Then
							Call ALERTS(LNG_CS_ORDERS_ALERT04,"BACK","")
							Exit For
						End If

					Next


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
				<input type="hidden" name="cmoneyUseLimit" value="1"> <%'사용가능 최소 적립금 %>
				<input type="hidden" name="cmoneyUseMin" value="1">  <%' 결제시 최소사용 적립금 %>
				<input type="hidden" name="cmoneyUseMax" value="<%=LAST_PRICE - 1000%>"><%'▣(카드)결제시 최대사용 적립금%>
				<input type="hidden" name="ownCmoney" value="<%=checkNumeric(MILEAGE_TOTAL)%>"> <%'회원 보유 마일리지%>
				<input type="hidden" name="orgSettlePrice" value="<%=LAST_PRICE%>"><%' 최초 결제금액%>
				<%If isSHOP_POINTUSE = "T" Then%>
				<tr>
					<td class="th tweight tright font_14px" style="padding:10px 10px;"><%=SHOP_POINT%><span style="margin-left:5px;">(<%=LNG_CS_ORDERS_POINT_POSSESSION%>:<strong id="RemainArea"><%=num2Cur(MILEAGE_TOTAL)%></strong></span>)</td>
					<td colspan="2"><input type="tel" name="useCmoney" class="input_text" style="text-align:right;font-size:14px;width:95%;" onKeyUp="toCurrency(this)" onBlur="toCurrency(this); checkUseCmoney(this);" value="0" /></td>
				</tr>
				<%Else%>
					<input type="hidden" name="useCmoney" value="0" />
				<%End If%>
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
							<div style="width:57%;" class="fleft" ><input type="text" name="takeZip" id="takeZipDaum" class="input_text width95a" value="<%=DKRS_Addcode1%>" maxlength="7" /></div><div class="fleft" style="width:3%;"></div><div style="width:40%;" class="fleft"><input type="button" id="ZipBtn" name="" class="input_btn width95a" value="우편번호입력"  onclick="execDaumPostcode('takes');"  /></div>
						</td>
					</tr><tr class="line">
						<th><%=LNG_TEXT_ADDRESS1%> <%=starText%></th>
						<td><input type="text" name="takeADDR1" id="takeADDR1Daum"  class="input_text width95a" value="<%=DKRS_Address1%>" /></td>
					</tr><tr>
						<th><%=LNG_TEXT_ADDRESS2%> <%=starText%></th>
						<td><input type="text" name="takeADDR2" id="takeADDR2Daum"  class="input_text width95a" value="<%=DKRS_Address2%>" /></td>
					</tr><tr>
						<th><%=LNG_TEXT_EMAIL%> <%=starText%></th>
						<td><input type="email" name="strEmail" class="input_text width95a" value="<%=DKRS_Email%>" /></td>
					</tr><tr>
						<th><%=LNG_TEXT_MOBILE%> <%=starText%></th>
						<td><input type="tel" name="takeMob" class="input_text width95a" value="<%=DKRS_hptel%>" /></td>
					</tr><tr>
						<th><%=LNG_TEXT_TEL%></th>
						<td><input type="tel" name="takeTel" class="input_text width95a" value="<%=DKRS_hometel%>" /></td>
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
								'▣구매종류 선택
								arrParams = Array(_
									Db.makeParam("@SELLCODE",adVarChar,adParamInput,10,arrList_SellCode) _
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

	<div class="cleft b_title">
		<h4 class="fleft"><span class="h3color1"><%=LNG_CS_ORDERS_PAYMENT_METHOD%></span></h4>
	</div>
	<div>
		<table <%=tableatt%> style="width:100%;" class="member_info">
			<colgroup>
				<col width="110" />
				<col width="*" />
			</colgroup>
			<tbody>
				<tr class="lheight130">
					<th rowspan="3"><%=LNG_CS_ORDERS_PAYMENT_METHOD%></th>
					<!-- <td class="payway" style="height:25px;"><input type="radio" name="pays" id="pays1" class="input_chk" value="Card"  /><label for="pays1"><%=LNG_TEXT_ORDER_CARD%></label></td>
				</tr><tr> -->
					<td class="payway" colspan="2" style="height:25px;"><input type="radio" name="pays" id="pays3" class="input_chk" value="inBank"  /><label for="pays3"><%=LNG_TEXT_ORDER_BANK%></label></td>
				</tr><!-- <tr>
					<td class="payway" colspan="2" style="height:25px;"><input type="radio" name="pays" id="pays2" class="input_chk" value="inCash"  /><label for="pays2"><%=LNG_TEXT_ORDER_CASH%></label></td>
				</tr> --><!-- <tr>
					<td class="payway" colspan="2" style="height:25px;"><input type="radio" name="pays" id="pays4" class="input_chk" value="dBank"  /><label for="pays4">실시간계좌이체</label></td>
				</tr><tr>
					<td class="payway" colspan="2" style="height:25px;"><input type="radio" name="pays" id="pays5" class="input_chk" value="vBank"  /><label for="pays5">가상계좌(무통장입금)</label></td>
				</tr><tr>
					<td class="payway" colspan="2" style="height:25px;"><input type="radio" name="pays" id="pays6" class="input_chk" value="point"  /><label for="pays6"><%=SHOP_POINT%> 단독결제</label></td>
				</tr> -->
			</tbody>

			<tbody id="pays2view" style="display:none;">
				<tr>
					<td colspan="2" style=" font-size:20px; font-weight:bold; padding:15px 0px;">현장 결제는 구입자가 사업장에서 직접 결제하는 방식입니다.</td>
				</tr>
			</tbody>
			<tbody id="pays3view" style="display:none;">
				<tr class="lheight130">
					<th><%=LNG_CS_ORDERS_BANK_NAME%></th>
					<td>
						<select name="C_codeName" style="width:150px;">
							<option value=""><%=LNG_CS_ORDERS_BANK_NAME_SELECT%></option>
							<%
								'GLOBAL
								'SQLB = "SELECT * FROM [tbl_BankForCompany] AS A"
								'SQLB = SQLB& " JOIN [tbl_Bank] AS B ON B.[ncode] = A.[BankCode]"
								'SQLB = SQLB& " WHERE B.[Na_Code] = '"&UCase(DK_MEMBER_NATIONCODE)&"' "
								'arrListB = Db.execRsList(SQLB,DB_TEXT,Nothing,listLenB,DB3)
								arrListB = Db.execRsList("DKP_BANK_LIST2",DB_PROC,Nothing,listLenB,DB3)
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

		<input type="hidden" name="ori_price" value="<%=LAST_PRICE%>" />
		<input type="hidden" name="ori_delivery" value="<%=DELIVERY_PRICE%>" readonly="readonly" />

		<input type="hidden" name="mbid1" value="<%=DK_MEMBER_ID1%>" />
		<input type="hidden" name="mbid2" value="<%=DK_MEMBER_ID2%>" />
		<input type="hidden" name="CPID" size="50" maxlength="50" value="<%=PGIDS2%>" style="IME-MODE:disabled" readonly="readonly"/>				<!-- 모바일 키인결제 테스트그룹1 -->
		<!-- CPID 치환 -->
		<input type="hidden" name="CPID_CARD" size="50" maxlength="50" value="<%=PGIDS2%>" style="IME-MODE:disabled" readonly="readonly"/>			<!-- 카드 -->
		<input type="hidden" name="CPID_VBANK" size="50" maxlength="50" value="PGIDS가상" style="IME-MODE:disabled" readonly="readonly"/>			<!-- 가상계좌 -->
		<input type="hidden" name="CPID_DBANK" size="50" maxlength="50" value="PGIDS실시간" style="IME-MODE:disabled" readonly="readonly"/>			<!-- 실시간이체 -->

		<input type="hidden" name="ORDERNO" size="50" maxlength="50"value="<%=orderNum%>" style="IME-MODE:disabled" readonly="readonly"/>
		<input type="hidden" name="PRODUCTTYPE" id="PRODUCTTYPE" size="10" maxlength="2" value="2" style="IME-MODE:disabled" /><!-- 2 -->
		<input type="hidden" name="BILLTYPE" id="BILLTYPE" size="15" maxlength="2"  value="15" style="IME-MODE:disabled" /><!-- 15 -->
		<input type="hidden" name="AMOUNT" size="10" maxlength="10" value="<%=LAST_PRICE%>" style="IME-MODE:disabled" onkeypress="fnNumCheck();" />
		<input type="hidden" name="quotaopt" value="12" />

		<input type="hidden" name="TAXFREECD" value="00" />
		<input type="hidden" name="EMAIL" size="100" maxlength="100" value="" />
		<input type="hidden" name="USERID" size="30" maxlength="30" value="<%=DK_MEMBER_ID1%>-<%=DK_MEMBER_ID2%>" />
		<input type="hidden" name="USERNAME" size="50" maxlength="50" value="<%=DK_MEMBER_NAME%>" />
		<input type="hidden" name="PRODUCTCODE" size="10" value="<%=orderTempIDX%>" />
		<input type="hidden" name="PRODUCTNAME" size="50" value="<%=arrList_NAME%>" />
		<input type="hidden" name="TELNO1" size="50" value="" />
		<input type="hidden" name="TELNO2" size="50" value="" />
		<input type="hidden" name="RESERVEDINDEX1" size="20" value="" />
		<input type="hidden" name="RESERVEDINDEX2" size="20" value="" />
		<input type="hidden" name="RESERVEDSTRING" size="100" value="" />
		<input type="hidden" name="RETURNURL" value="" />

		<input type="hidden" name="HOMEURL" value="http://<%=houUrl%>/PG/DAOU/order_finish_cs.asp" style="width:350px;"/>
		<!-- HOMEURL 치환 -->
		<input type="hidden" name="HOMEURL_CARD"  value="http://<%=houUrl%>/PG/DAOU/order_finish_cs.asp" />
		<input type="hidden" name="HOMEURL_VBANK" value="http://<%=houUrl%>/PG/DAOU/order_finish_vBank.asp?orderIDX=<%=orderNum%>" />
		<input type="hidden" name="HOMEURL_DBANK" value="http://<%=houUrl%>/buy/order_list.asp" />			<!-- 모바일 : 실주소(http, port번호)기입! -->

		<input type="hidden" name="FAILURL" value="http://<%=houUrl%>/PG/DAOU/order_failed_cs.asp">
		<input type="hidden" name="DIRECTRESULTFLAG" value="Y" />		<!-- 모바일 KEYIN일 경우!!!! : Y -->

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
		<input type="hidden" name="keyin" value="KEYIN" />				<!-- 키인결제시!! -->

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
