<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	PAGE_SETTING = "MYOFFICE"
	INFO_MODE	 = "ORDER1-1"

	ISLEFT = "T"
	ISSUBTOP = "T"


	Call ONLY_BUSINESS_MEMBER(DK_MEMBER_LEVEL,2)
	Call ONLY_CS_MEMBER()
Call ALERTS(LNG_ALERT_WRONG_ACCESS,"back","")
Response.end
Response.end
Response.End

'	Call MEMBER_AUTH_CHECK(nowGradeCnt,3)


	'직판신고관련 주문번호존재유무체크
'	SQL2 = "SELECT [cpno] FROM [tbl_memberinfo] where [mbid] = ? and [mbid2] = ?"
'	arrParams2 = Array(_
'		Db.makeParam("@MBID1",adVarChar,adParamInput,20,DK_MEMBER_ID1), _
'		Db.makeParam("@MBID2",adInteger,adParamInput,4,DK_MEMBER_ID2) _
'	)
'	Set HJRSS = Db.execRS(SQL2,DB_TEXT,arrParams2,DB3)
'	If Not HJRSS.BOF Or Not HJRSS.EOF Then
'		RS_CPNO = HJRSS("cpno")
'	Else
'		RS_CPNO = ""
'	End If
'	Call closeRs(HJRSS)

'	If RS_CPNO = "" Then Call alerts("주민번호가 입력되지 않았습니다(결제처리불가).\n\n본사에 문의해주세요.","back","")


	inUidx = Trim(pRequestTF("nCode",True))

	If inUidx = "" Then Call ALERTS(LNG_CS_ORDERS_ALERT01,"go","cart.asp")

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
'	Call Db.exec("DKP_ORDER_TEMP_INSERT",DB_PROC,arrParams,DB3)
	orderTempIDX = arrParams(UBound(arrParams)-1)(4)
	OUTPUT_VALUE = arrParams(UBound(arrParams))(4)

	If OUTPUT_VALUE = "ERROR" Then Call ALERTS(LNG_CS_ORDERS_ALERT02,"back","")

'	PRINT orderTempIDX
'	response.End


'	PRINT arrUidx(0)  95


%>
<!--#include virtual = "/_include/document.asp"-->
<meta http-equiv="Cache-Control" content="no-cache"/>
<meta http-equiv="Expires" content="0"/>
<meta http-equiv="Pragma" content="no-cache"/>
<meta http-equiv="X-UA-Compatible" content="requiresActiveX=true" />
<link rel="stylesheet" href="/myoffice/css/style_cs.css" />
<link rel="stylesheet" href="/myoffice/css/layout_cs.css" />

<%
Select Case DKPG_PGCOMPANY
	Case "INICIS"
		BODYLOAD = "onload=""javascript:enable_click();"" onfocus=""javascript:focus_control();"""
		FORMDATA = "<form name=""ini"" method=""post"" autocomplete=""off"" action=""/PG/INICIS/INIsecureresult_cs.asp"" onSubmit=""return pay(this)"">"
		'일반						http://plugin.inicis.com/pay61_secuni_cross.js
		'UNI 코드사용 				http://plugin.inicis.com/pay61_secuni_cross.js
		'OpenSSL사용				https://plugin.inicis.com/pay61_secunissl_cross.js
		'OpenSSL, UNI 코드 사용 	https://plugin.inicis.com/pay61_secunissl_cross.js

		'CONFIG.PGJAVA 설정 : ANSI	/ UTF8 / ANSISSL / UTF8SSL
%>
	<script language=javascript src="<%=PGJAVA%>"></script>
	<script type="text/javascript" src="/PG/INICIS/pays_cs.js"></script>
<%
	Case "DAOU"
		BODYLOAD = "onLoad=""init();"""
		FORMDATA = "<form name=""frmConfirm"" id=""frmConfirm"" onsubmit=""return fnSubmit();"" method=""post"">"

		If UCase(DK_MEMBER_NATIONCODE) = "KR" Or UCase(DK_MEMBER_NATIONCODE) = "" Then
			DKPG_PGJAVA_BASE2 = DKPG_PGJAVA_BASE2
		Else
			DKPG_PGJAVA_BASE2 = "pay_cs_"&LCase(DK_MEMBER_NATIONCODE)&".js"
		End If
%>
	<script type="text/javascript" src="/PG/DAOU/<%=DKPG_PGJAVA_BASE2%>"></script>
<%
	Case "SPEEDPAY"
		BODYLOAD = ""
		FORMDATA = "<form name=""orderFrm"" id=""orderFrm"" action=""/PG/SPEEDPAY/order_card_result_cs.asp"" onsubmit=""return orderSubmit(this);"" method=""post"">"
%>
	<script type="text/javascript" src="/PG/SPEEDPAY/pay_order_cs.js"></script>

<%
End Select
%>
<script type="text/javascript" src="/jscript/calendar.js"></script>
<script src="http://dmaps.daum.net/map_js_init/postcode.v2.js"></script>
<script src="/jscript/daumPostCode.js"></script>
</head>
<body <%=BODYLOAD%>>
<!--#include virtual = "/_include/header.asp"-->
<%
	If webproIP="T" Then
		Call ResRW(DKPG_PGMOD,"PG_MODE")
		Call ResRW(DKPG_PGCOMPANY,"웹프로_IP_VIEW - 연결PG사")
		If UCase(DKPG_PGCOMPANY) = "DAOU" Then
			If Right(DKFD_PGMOD,4) = "TEST" Then
				Call ResRW(DKPG_PGIDS_SHOP_KEYIN,"DKPG_PGIDS_SHOP_KEYIN")
				Call ResRW(DKPG_PGJAVA_BASE2,"자바연결2")
			Else
				Call ResRW(DKPG_PGIDS_SHOP_KEYIN,"DKPG_PGIDS_SHOP_KEYIN")
				Call ResRW(DKPG_PGJAVA_BASE2,"자바연결2")
			End If
		End If
	End If
%>
<div id="cart" class="orderList">
	<%=FORMDATA%>
		<input type="hidden" name="cuidx" value="<%=inUidx%>" />
		<p class="titles"><%=LNG_CS_ORDERS_TEXT01%></p>
		<table <%=tableatt%> class="userCWidth orderTable">
			<col width="70" />
			<col width="250" />
			<col width="95" />
			<col width="95" />
			<col width="55" />
			<col width="95" />
			<col width="120" />
			<thead>
				<tr>
					<th><%=LNG_TEXT_CSGOODS_CODE%></th>
					<th><%=LNG_TEXT_ITEM_NAME%></th>
					<th><!-- <%=LNG_TEXT_MEMBER_PRICE%> --><%=LNG_TEXT_SELLING_PRICE%></th>
					<th><%=CS_PV%></th>
					<th><%=LNG_TEXT_ITEM_NUMBER%></th>
					<th><%=LNG_CS_ORDERS_TOTAL_PV%></th>
					<th><%=LNG_CS_ORDERS_TOTAL_PRICE%></th>
				</tr>
			</thead>
			<tbody>
			<%

				TOTAL_PRICE		= 0
				TOTAL_PV		= 0

				For i = 0 To UBound(arrUidx)

					SQL = "SELECT * FROM [DK_CART] WHERE [intIDX] = ?"
					arrParams = Array(_
						Db.makeParam("@intIDX",adInteger,adParamInput,0,arrUidx(i)), _
						Db.makeParam("@MBID",adVarChar,adParamInput,20,DK_MEMBER_ID1),_
						Db.makeParam("@MBID2",adInteger,adParamInput,0,DK_MEMBER_ID2)_
					)
					Set DKRSS =  Db.execRS("DKP_DKP_CART_ONE",DB_PROC,arrParams,DB3)
					If Not DKRSS.BOF Or Not DKRSS.EOF Then
						RS_Ncode		= DKRSS("Ncode")
						RS_Name			= DKRSS("Name")
						RS_Price2		= DKRSS("Price2")
						RS_Price4		= DKRSS("Price4")
						RS_Price5		= DKRSS("Price5")
						RS_ea			= DKRSS("ea")
						RS_Bc			= 1	'DKRSS("Base_Cnt")
						RS_Price6		= DKRSS("Price6")
						RS_SellCode		= DKRSS("SellCode")
					Else
						Call alerts(LNG_CS_ORDERS_ALERT03,"back","")
					End If
					Call closeRs(DKRSS)

					'▣CS상품정보 변동정보 통합
					arrParams = Array(_
						Db.makeParam("@ncode",adVarChar,adParamInput,20,RS_ncode) _
					)
					Set DKRS = Db.execRs("HJP_CSGOODS_PRICE_INFO",DB_PROC,arrParams,DB3)
					If Not DKRS.BOF And Not DKRS.EOF Then
						RS_ncode		= DKRS("ncode")
						RS_price2		= DKRS("price2")
						RS_price4		= DKRS("price4")
						RS_price5		= DKRS("price5")
						RS_price6		= DKRS("price6")
					End If
					Call closeRs(DKRS)

	'▣더리코(마이오피스 재구매매출02 상품만 구매(2017-03-31)
	If RS_SellCode <> "02" Then Call ALERTS("재구매매출 상품만 구입할 수 있습니다.","back","")


					SELF_PRICE = 0
					SELF_PRICE = RS_Price2 * RS_ea

					SELF_PV = 0
					SELF_PV = (RS_Price4 * RS_ea)

					PRINT tabs(1)&"	<tr>"
					PRINT tabs(1)&"		<td class=""tcenter"">"&RS_Ncode&"</td>"
					PRINT tabs(1)&"		<td style=""padding-left:5px;"">"&RS_Name&"</td>"
					PRINT tabs(1)&"		<td class=""inPrice"">"&num2cur(RS_Price2)&" "&CS_CURC&"</td>"
					PRINT tabs(1)&"		<td class=""inPrice Price"">"&num2cur(RS_Price4)&" "&CS_PV&" </td>"
					PRINT tabs(1)&"		<td class=""inPrice"">"&RS_ea&" "&LNG_TEXT_EA&"</td>"
					PRINT tabs(1)&"		<td class=""inPrice Price"">"&num2cur(SELF_PV)&" "&CS_PV&"</td>"
					PRINT tabs(1)&"		<td class=""inPrice Price"">"&num2cur(SELF_PRICE)&" "&CS_CURC&"</td>"
					PRINT tabs(1)&"	</tr>"

					TOTAL_PRICE		= TOTAL_PRICE + SELF_PRICE
					TOTAL_PV		= TOTAL_PV + SELF_PV


					arrParams2 = Array(_
						Db.makeParam("@OrderIDX",adInteger,adParamInput,0,orderTempIDX),_
						Db.makeParam("@GoodsCode",adVarChar,adParamInput,20,RS_Ncode),_
						Db.makeParam("@GoodsPrice",adVarChar,adParamInput,20,RS_Price2),_
						Db.makeParam("@GoodsPV",adInteger,adParamInput,0,RS_Price4),_
						Db.makeParam("@ea",adInteger,adParamInput,0,RS_ea),_
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
			</tbody>
			<tfoot>
				<tr>
					<td colspan="6" class="tweight tright bg2 pR4"><%=LNG_CS_ORDERS_TOTAL_PURCHASE_PV%></td>
					<td class="inPrice tPrice"><%=num2cur(TOTAL_PV)%> <%=CS_PV%></td>
				</tr><tr>
					<td colspan="6" class="tweight tright bg2 pR4"><%=LNG_CS_ORDERS_TOTAL_PURCHASE_AMOUNT%></td>
					<td class="inPrice tPrice"><%=num2cur(TOTAL_PRICE)%> <%=CS_CURC%></td>
				</tr>

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
					<td colspan="6" class="tweight tright bg2 pR4"><span id="delTXT"><%=DELIVERY_TXT%></span> <span id="oriTXT1" style="display:none;"><%=DELIVERY_TXT%></span></td>
					<td class="inPrice tPrice"><span id="priTXT"><%=num2cur(DELIVERY_PRICE)%></span> <%=CS_CURC%> <span id="oriTXT2" style="display:none;"><%=num2cur(DELIVERY_PRICE)%></span></td>
				</tr><tr>
					<td colspan="6" class="tweight tright bg2 pR4"><%=LNG_CS_ORDERS_TOTAL_PRICE%></td>
					<!-- <td class="inPrice tPrice1" ><%=num2cur(LAST_PRICE)%> <%=CS_CURC%> </td> -->
					<td class="inPrice tPrice1" ><span id="totalTXT"><%=num2cur(LAST_PRICE)%></span> <%=CS_CURC%> <span id="oriTXT3" style="display:none;"><%=num2cur(LAST_PRICE)%></span></td>
				</tr>


				<input type="hidden" name="cmoneyUseLimit" value="1"> <!-- 사용가능 최소 적립금 -->
				<input type="hidden" name="cmoneyUseMin" value="1"> <!-- 결제시 최소사용 적립금 -->
				<input type="hidden" name="cmoneyUseMax" value="<%=LAST_PRICE - 1000%>"><%'▣(카드)결제시 최대사용 적립금%>
				<input type="hidden" name="ownCmoney" value="<%=checkNumeric(MILEAGE_TOTAL)%>"> <%'회원 보유 마일리지%>
				<input type="hidden" name="orgSettlePrice" value="<%=LAST_PRICE%>"><%' 최초 결제금액%>
				<%If isSHOP_POINTUSE = "T" Then%>
				<tr>
					<td colspan="2" class="tweight tright bg2 pR4">
						<%=SHOP_POINT%> 사용<span style="margin-left:5px;">(보유 : <strong id="RemainArea"><%=num2Cur(MILEAGE_TOTAL)%></strong></span>)
					</td>
					<td class="tcenter">
						<input type="text" name="useCmoney" class="input_gray01"  onKeyUp="toCurrency(this)" onBlur="toCurrency(this); checkUseCmoney(this);" value="0" />
					</td>
					<td colspan="3" class="tweight tright bg2 pR4">최종 결제 금액</td>
					<td class="inPrice tPrice2" ><span id="lastTXT"><%=num2cur(LAST_PRICE)%></span> 원 <span id="oriTXT3" style="display:none;"><%=num2cur(LAST_PRICE)%></span></td>
				</tr>
				<%Else%>
				<input type="hidden" name="useCmoney" value="0">
				<%End If%>

			</tfoot>
		</table>

		<!-- <p class="titles"><%=LNG_CS_ORDERS_RECEIVE_METHOD%></p>
		<table <%=tableatt%> class="userCWidth">
			<col width="140" />
			<col width="320" />
			<col width="300" />
			<tr>
				<th><%=LNG_CS_ORDERS_RECEIVE_METHOD%></th>
				<td style="padding-left:5px;">
					<label><input type="radio" name="DtoD" class="input_chk" value="T" checked="checked" onclick="payKindSelect2(this.value)" /> <%=LNG_CS_ORDERS_RECEIVE_DELIVERY%></label>
					<label><input type="radio" name="DtoD" class="input_chk" value="F" onclick="payKindSelect2(this.value)" /> <%=LNG_CS_ORDERS_RECEIVE_PICKUP%></label>
				</td>
				<td style="padding-left:5px;"><%=LNG_CS_ORDERS_RECEIVE_METHOD_EXP%></td>
			</tr>
		</table> -->


		<div id="DtoD_toggle">
		<p class="titles"><%=LNG_CS_ORDERS_DELIVERY_INFO%></p>
		<%
			arrParams = Array(_
				Db.makeParam("@mbid",adVarChar,adParamInput,20,DK_MEMBER_ID1), _
				Db.makeParam("@mbid2",adInteger,adParamInput,0,DK_MEMBER_ID2) _
			)
			Set DKRS = Db.execRs("DKP_MEMBER_INFO",DB_PROC,arrParams,DB3)
			If Not DKRS.BOF And Not DKRS.EOF Then
				RS_M_Name		= DKRS("M_Name")
				RS_Addcode1		= DKRS("Addcode1")
				RS_Address1		= DKRS("Address1")
				RS_Address2		= DKRS("Address2")
				RS_Address3		= DKRS("Address3")
				RS_reqtel		= DKRS("reqtel")
				RS_officetel	= DKRS("officetel")
				RS_hometel		= DKRS("hometel")
				RS_hptel		= DKRS("hptel")
				RS_Email		= DKRS("Email")
				Sell_Mem_TF		= DKRS("Sell_Mem_TF")	'판매원0, 소비자1

				If DKCONF_SITE_ENC = "T" Then
					Set objEncrypter = Server.CreateObject ("Hyeongryeol.StringEncrypter")
						objEncrypter.Key = con_EncryptKey
						objEncrypter.InitialVector = con_EncryptKeyIV
						On Error Resume Next
						If RS_Address1		<> "" Then RS_Address1	= objEncrypter.Decrypt(RS_Address1)
						If RS_Address2		<> "" Then RS_Address2	= objEncrypter.Decrypt(RS_Address2)
						If RS_Address3		<> "" Then RS_Address3	= objEncrypter.Decrypt(RS_Address3)
						If RS_hometel		<> "" Then RS_hometel	= objEncrypter.Decrypt(RS_hometel)
						If RS_hptel			<> "" Then RS_hptel		= objEncrypter.Decrypt(RS_hptel)

						If DKCONF_ISCSNEW = "T" Then	''▣CS신버전 암/복호화 추가
							If RS_Email		<> "" Then RS_Email		= objEncrypter.Decrypt(RS_Email)
						End If
						On Error GoTo 0
					Set objEncrypter = Nothing
				End If

				If RS_WebID = "" Then RS_WebID = ""

			'	If RS_hometel = "" Or IsNull(RS_hometel) Then RS_hometel = "--"
			'		arrTEL = Split(RS_hometel,"-")
			'	If RS_hptel = "" Or IsNull(RS_hptel) Then RS_hptel = "--"
			'		arrMob = Split(RS_hptel,"-")
				If RS_Email = "" Or IsNull(RS_Email) Then RS_Email = "@"
					arrMAIL = Split(RS_Email,"@")
				If RS_BirthDay = "" Or IsNull(RS_BirthDay) Then
					RS_BirthDay = "--"
				Else
					RS_BirthDay = date8to10(RS_BirthDay)
				End If
					arrBIRTH = Split(RS_BirthDay,"-")


			Else
				Call ALERTS(LNG_CS_ORDERS_ALERT05,"back","")
			End If
			Call closeRS(DKRS)


		%>
		<table <%=tableatt%> class="userCWidth meminfo">
			<colgroup>
				<col width="140" />
				<col width="620" />
			</colgroup>
			<tbody>
				<tr>
					<th><%=LNG_CS_ORDERS_DELIVERY_NAME%> <%=starText%></th>
					<td><input type="text" class="input_text" name="takeName" style="width:200px;" value="<%=RS_M_Name%>" /></td>
				</tr><tr class="line">
					<th><%=LNG_TEXT_ADDRESS1%> <%=starText%></th>
					<td>
						<%If UCase(DK_MEMBER_NATIONCODE)="KR" Then%>
							<input type="text" class="input_text" name="takeZip" id="takeZipDaum" style="width:80px;background-color:#f4f4f4;" readonly="readonly" value="<%=RS_addcode1%>" />
							<img src="<%=IMG_MYPAGE%>/zip_search.gif" width="68" height="20" alt="주소 찾기" class="vmiddle cp" onclick="execDaumPostcode('takes');" />
							<input type="text" class="input_text" name="takeADDR1" id="takeADDR1Daum" style="width:390px;background-color:#f4f4f4;" readonly="readonly" value="<%=RS_Address1%>" />
						<%Else%>
							<input type="text" class="input_text" name="takeADDR1" id="takeADDR1Daum" style="width:400px;" value="<%=RS_Address1%>" />
							&nbsp;&nbsp;&nbsp;ZIP CODE
							<input type="text" class="input_text vmiddle" name="takeZip" id="takeZipDaum" style="width:60px;" maxlength="7"  <%=onLyKeys%> value="<%=RS_addcode1%>" />
						<%End If%>
					</td>
				</tr><tr>
					<th><%=LNG_TEXT_ADDRESS2%> <%=starText%></th>
					<td><input type="text" class="input_text" name="takeADDR2" id="takeADDR2Daum" style="width:550px;" value="<%=RS_Address2%>" /></td>
				</tr><tr>
					<th><%=LNG_TEXT_EMAIL%> <%=starText%></th>
					<td>
						<input type="text" class="input_text imes" name="strEmail" style="width:350px;" value="<%=RS_Email%>" /><br /><br />
						<span class="summary">* <%=LNG_CS_ORDERS_TEXT27%></span>
					</td>
				</tr><tr>
					<th><%=LNG_TEXT_MOBILE%> <%=starText%></th>
					<td>
						<input type="text" class="input_text" name="takeMob" style="width:150px;" maxlength="15" <%=onLyKeys%> value="<%=RS_hptel%>" />
						<span class="summary">* <%=LNG_MYPAGE_INFO_COMPANY_TEXT23%></span>
					</td>
				</tr><tr>
					<th><%=LNG_TEXT_TEL%></th>
					<td>
						<input type="text" class="input_text" name="takeTel" style="width:150px;" maxlength="15" <%=onLyKeys%> value="<%=RS_hometel%>" />
					</td>
				</tr>
			</tbody>
		</table>
		</div>

		<p class="titles"><%=LNG_CS_ORDERS_ETC%></p>
		<table <%=tableatt%> class="userCWidth">
			<col width="140" />
			<col width="620" />
			<tr>
				<th><%=LNG_TEXT_SALES_TYPE%></th>
				<td style="padding-left:5px;">
					<select name="v_SellCode">
						<!-- <option value=""><%=LNG_TEXT_SALES_TYPE_SELECT%></option> -->
						<%
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
						'	If Sell_Mem_TF = 0 Then
						'		PRINT TABS(4)&"	<option value=""01"">"&LNG_CS_ORDERS_TEXT32_1&"</option>"
						'	ElseIf Sell_Mem_TF = 1 Then
						'		PRINT TABS(4)&"	<option value=""02"">"&LNG_CS_ORDERS_TEXT32_3&"</option>"
						'	Else
						'		PRINT TABS(4)&"	<option value="""">"&LNG_CS_ORDERS_TEXT34&"</option>"
						'	End If
						%>
					</select>
				</td>
			</tr>
		</table>

		<p class="titles"><%=LNG_CS_ORDERS_PAYMENT_METHOD%></p>
		<table <%=tableatt%> class="userCWidth">
			<col width="140" />
			<col width="400" />
			<col width="220" />
			<tr>
				<th><%=LNG_TEXT_ORDER_BANK%></th>
				<td style="padding-left:5px;"><label><input type="radio" name="payKind" value="inBank" class="input_chk" onclick="payKindSelect(this.value)" /> <%=LNG_TEXT_ORDER_BANK%></label></td>
				<td style="padding-left:5px;"><%=LNG_TEXT_ORDER_BANK%></td>
			</tr><tr id="inBankInfo" style="display:none;">
				<td colspan="3" style="padding-left:20px;">&#8226; <%=LNG_CS_ORDERS_BANK_NAME%> :
					<select name="C_codeName" style="margin-left:5px;">
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
					</select><br /><br />
					<span>&#8226; <%=LNG_TEXT_DEPOSITOR%> : </span><input type="text" name="C_NAME2" class="input_text"/><span style="margin-left:50px;">&#8226; <%=LNG_CS_ORDERS_TRANSFER_DATE%> : </span><input type='text' name='memo1' value="" class='input_text readonly' onclick="openCalendar(event, this, 'YYYY-MM-DD');" readonly="readonly">
				</td>
			</tr>
<%If webproIP="T" then%>
			<tr>
				<th><%=LNG_TEXT_ORDER_CARD%></th>
				<td style="padding-left:5px;"><label><input type="radio" name="payKind" value="Card" class="input_chk" onclick="payKindSelect(this.value)" /> <%=LNG_TEXT_ORDER_CARD%>(<%=DKPG_PGCOMPANY%>)</label></td>
				<td style="padding-left:5px;"><%=LNG_TEXT_ORDER_CARD%></td>
			</tr>
<%End If%>
			<%If DKPG_PGCOMPANY = "SPEEDPAY" Then%>
			<tr id="CardInfo" style="display:none;">
				<td colspan="3" style="padding-left:20px;">
					<div class="fleft">
						<span>&#8226; 카드번호 : </span>
							<input type="text" name="cardNo1" class="input_text tcenter" maxlength="4" style="width:60px;" placeholder="4자리" <%=onlyKeys%> value="" /> -
							<input type="text" name="cardNo2" class="input_text tcenter" maxlength="4" style="width:60px;" placeholder="4자리" <%=onlyKeys%> value="" /> -
							<input type="text" name="cardNo3" class="input_text tcenter" maxlength="4" style="width:60px;" placeholder="4자리" <%=onlyKeys%> value="" /> -
							<input type="text" name="cardNo4" class="input_text tcenter" maxlength="4" style="width:60px;" placeholder="4자리" <%=onlyKeys%> value="" />
							<br /><br />
						<span>&#8226; 유효기간 : </span>
							<input type="text" name="card_mm" class="input_text tcenter" maxlength="2" style="width:90px;" placeholder="유효기간(월)" <%=onlyKeys%> value="" /> 월
							<input type="text" name="card_yy" class="input_text tcenter" maxlength="4" style="width:90px;" placeholder="유효기간(년)" <%=onlyKeys%> value="" /> 년
							<br /><br />
						<span>&#8226; 할부정보 : </span>
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
					</div>
				</td>
			</tr>
			<%End If%>
			<!-- <tr>
				<th><%=LNG_TEXT_ORDER_CASH%></th>
				<td style="padding-left:5px;"><label><input type="radio" name="payKind" value="inCash" class="input_chk" onclick="payKindSelect(this.value)" /> <%=LNG_TEXT_ORDER_CASH%></label></td>
				<td style="padding-left:5px;"><%=LNG_CS_ORDERS_TEXT46%></td>
			</tr> -->
			<!-- <tr>
				<th rowspan="2"><%=LNG_TEXT_ORDER_CARD%></th>
				<td style="padding-left:5px;"><label><input type="radio" name="payKind" value="Card" class="input_chk" onclick="payKindSelect(this.value)" /> <%=LNG_TEXT_ORDER_CARD%>(<%=DKPG_PGCOMPANY%>)</label></td>
				<td style="padding-left:5px;"><%=LNG_TEXT_ORDER_CARD%></td>
			</tr><tr>
				<td style="padding-left:5px;"><label><input type="radio" name="payKind" value="sCard" class="input_chk" onclick="payKindSelect(this.value)" /> <%=LNG_CS_ORDERS_TEXT50%></label></td>
				<td style="padding-left:5px;"><%=LNG_CS_ORDERS_TEXT51%></td>
			</tr>
			<tr>
				<th><%=LNG_CS_ORDERS_TEXT52%></th>
				<td style="padding-left:5px;"><label><input type="radio" name="payKind" value="dBank" class="input_chk" onclick="payKindSelect(this.value)" /> <%=LNG_CS_ORDERS_TEXT52%></label></td>
				<td style="padding-left:5px;"><%=LNG_CS_ORDERS_TEXT53%></td>
			</tr><tr>
				<th><%=LNG_CS_ORDERS_TEXT54%></th>
				<td style="padding-left:5px;"><label><input type="radio" name="payKind" value="vBank" class="input_chk" onclick="payKindSelect(this.value)" /> <%=LNG_CS_ORDERS_TEXT54%></label></td>
				<td style="padding-left:5px;"><%=LNG_CS_ORDERS_TEXT55%></td>
			</tr> -->
			<%'If MILEAGE_TOTAL >= LAST_PRICE Then%>
			<!-- <tr>
				<th><%=LNG_CS_ORDERS_TEXT56%></th>
				<td style="padding-left:5px;"><label><input type="radio" name="payKind" value="point" class="input_chk" onclick="payKindSelect(this.value)" /> <%=LNG_CS_ORDERS_TEXT56%></label></td>
				<td style="padding-left:5px;"><%=LNG_CS_ORDERS_TEXT57%></td>
			</tr> -->
			<%'End If%>
		</table>

		<div class="pagingArea userCWidth2" >
			<!-- <input type="image" src="<%=IMG_BTN%>/payGo.gif" /> -->
			<input type="submit" class="txtBtnC medium red2 shadow1 radius5" style="min-width:140px;" value="<%=LNG_CS_ORDERS_BTN01%>" />
		</div>

<input type="hidden" name="gopaymethod" value="">
<input type="hidden" name="totalPrice" value="<%=LAST_PRICE%>" />
<input type="hidden" name="totalDelivery" value="<%=DELIVERY_PRICE%>" />
<input type="hidden" name="totalOptionPrice" value="<%=totalOptionPrice%>" />
<input type="hidden" name="totalPoint" value="<%=total_point%>" />
<input type="hidden" name="totalVotePoint" value="<%=total_voterpoint%>" />
<input type="hidden" name="strOption" value="<%=strOption%>" />
<input type="hidden" name="OrdNo" value="<%=orderNum%>" />
<input type="hidden" name="OIDX" value="<%=orderTempIDX%>" />

<input type="hidden" name="ori_price" value="<%=LAST_PRICE%>" />
<input type="hidden" name="ori_delivery" value="<%=DELIVERY_PRICE%>" readonly="readonly" />

<!-- 직판공제번호발급용 본인 -->
<input type="hidden" name="mbid1" value="<%=DK_MEMBER_ID1%>" />
<input type="hidden" name="mbid2" value="<%=DK_MEMBER_ID2%>" />

<%

Select Case DKPG_PGCOMPANY
	Case "INICIS"

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

	Session("INI_MID") = PGIDS
	Session("INI_PRICE") = LAST_PRICE '결제 금액 =>  결제 처리 페이지에서 체크 하기 위해 세션에 저장 (또는 DB에 저장)하여 다음 결제 처리 페이지 에서 체크)
	'상품가 총액을 알기 위해 하단으로 이동 조치
	Session("INI_ADMIN") = PGPASSKEY '상점키 패스워드 =>  결제 처리 페이지에서 체크 하기 위해 세션에 저장 (또는 DB에 저장)하여 다음 결제 처리 페이지 에서 체크)

	INIpay.SetField CLng(PInst), "mid", Session("INI_MID")			'상점아이디
	INIpay.SetField CLng(PInst), "price",  Session("INI_PRICE")		'결제 금액
	INIpay.SetField CLng(PInst), "nointerest", "no"  			'무이자 할부 세팅
	INIpay.SetField CLng(PInst), "quotabase","lumpsum:00:02:03"   '할부 개월 및 카드사별 무이자 세팅
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
	IF resultcode <> "00" Then
		Call ALERTS(resultmsg&" - 관리자에게 문의해 주세요.","go","cart.asp")
		'실패 처리 =>  결제 페이지 생성 실패에 따른 처리 절차 삽입 (예 : 상점키 파일을 읽지 못해 실패 처리 되면 해당 resultmsg를 확인하여 상점 관리자거 해당 오류 처리 필요)

		response.write " 결제 페이지 생성에 문제 발생<BR>"
		response.write "에러 원인 : "&  	resultmsg
		Response.End
	End If


	%>

	<input type="hidden" name="goodname" maxlength="300" value="<%=RS_Name%>" />

	<!-- <input type="hidden" name="buyername" value="" />
	<input type="hidden" name="buyeremail" value="" />
	<input type="hidden" name="buyertel" value="" /> -->
	<input type="hidden" name="buyername" value="<%=RS_M_Name%>" />
	<input type="hidden" name="buyeremail" value="<%=RS_Email%>" />
	<input type="hidden" name="buyertel" value="<%=RS_hptel%>" />

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

<%
	Case "DAOU"


	'▣▣▣테스트그룹4 일반▣▣▣
	DKPG_PGIDS_SHOP_KEYIN = "CTS14214"


%>
	<input type="hidden" name="CPID" size="50" maxlength="50" value="<%=DKPG_PGIDS_SHOP_KEYIN%>" style="IME-MODE:disabled" readonly="readonly"/>			<!-- PGIDS 키인! -->
	<!-- CPID 치환 -->
	<input type="hidden" name="CPID_CARD"  size="50" maxlength="50" value="<%=DKPG_PGIDS_SHOP_KEYIN%>" style="IME-MODE:disabled" readonly="readonly"/>			<!-- 카드 -->
	<input type="hidden" name="CPID_VBANK" size="50" maxlength="50" value="PGIDS가상" style="IME-MODE:disabled" readonly="readonly"/>			<!-- 가상계좌 -->
	<input type="hidden" name="CPID_DBANK" size="50" maxlength="50" value="PGIDS실시간" style="IME-MODE:disabled" readonly="readonly"/>			<!-- 실시간이체 -->

	<input type="hidden" name="ORDERNO" size="50" maxlength="50"value="<%=orderNum%>" style="IME-MODE:disabled" readonly="readonly"/>
	<input type="hidden" name="PRODUCTTYPE" size="10" maxlength="2" value="2" style="IME-MODE:disabled" />
	<input type="hidden" name="BILLTYPE" size="10" maxlength="2"  value="1" style="IME-MODE:disabled" /><!-- -->
	<input type="hidden" name="AMOUNT" size="10" maxlength="10" value="<%=LAST_PRICE%>" style="IME-MODE:disabled" onkeypress="fnNumCheck();" />
	<input type="hidden" name="quotaopt" value="12" />

	<input type="hidden" name="TAXFREECD" value="00" />
	<input type="hidden" name="EMAIL" size="100" maxlength="100" value="" />
	<input type="hidden" name="USERID" size="30" maxlength="30" value="<%=DK_MEMBER_ID1%>-<%=DK_MEMBER_ID2%>" />
	<input type="hidden" name="USERNAME" size="50" maxlength="50" value="<%=DK_MEMBER_NAME%>" />
	<input type="hidden" name="PRODUCTCODE" size="10" value="<%=inUidx%>" />
	<input type="hidden" name="PRODUCTNAME" size="50" value="<%=RS_Name%>" />
	<input type="hidden" name="TELNO1" size="50" value="" />
	<input type="hidden" name="TELNO2" size="50" value="" />
	<input type="hidden" name="RESERVEDINDEX1" size="20" value="" />
	<input type="hidden" name="RESERVEDINDEX2" size="20" value="" />
	<input type="hidden" name="RESERVEDSTRING" size="100" value="" />
	<input type="hidden" name="RETURNURL" value="" />
	<input type="hidden" name="HOMEURL" value="http://<%=houUrl%>/PG/DAOU/order_finish_cs.asp?orderIDX=<%=orderNum%>" />
	<!-- HOMEURL 치환 -->
	<input type="hidden" name="HOMEURL_CARD"  value="http://<%=houUrl%>/PG/DAOU/order_finish_cs.asp?orderIDX=<%=orderNum%>" />
	<input type="hidden" name="HOMEURL_VBANK" value="http://<%=houUrl%>/PG/DAOU/order_finish_vBank.asp?orderIDX=<%=orderNum%>" />
	<input type="hidden" name="FAILURL" value="http://<%=houUrl%>/PG/DAOU/order_failed_cs.asp">
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
	<input type="hidden" name="keyin" value="CERT" />	<!-- 키인결제시!! -->

	<input type="hidden" name="isDownOrder" value="F" />	<!-- 본인구매 -->

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

	<%Case "SPEEDPAY"%>
		<input type="hidden" name="GoodsName" value="<%=RS_Name%>" readonly="readonly" />
		<input type="hidden" name="MEMBER_STYPE" value="<%=DK_MEMBER_STYPE%>" readonly="readonly"/>
		<input type="hidden" name="isDownOrder" value="F" />	<!-- 본인구매 -->

	<%End Select%>

	</form>
</div>
<%


	arrParams = Array(_
		Db.makeParam("@OrderNum",adVarChar,adParamInput,20,orderNum),_
		Db.makeParam("@totalPrice",adInteger,adParamInput,0,LAST_PRICE), _
		Db.makeParam("@intIDX",adInteger,adParamInput,0,orderTempIDX), _
		Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
	)
	Call Db.exec("DKP_ORDER_TOTAL_PRICE_UPDATE",DB_PROC,arrParams,DB3)
	OUTPUT_VALUE = arrParams(Ubound(arrParams))(4)
	Select Case OUTPUT_VALUE
		Case "FINISH"
		Case "ERROR" : Call ALERTS(LNG_CS_ORDERS_ALERT06,"BACK","")
		Case "NOTORDER" : Call ALERTS(LNG_CS_ORDERS_ALERT07,"BACK","")
	End Select
%>
<!--#include virtual = "/_include/copyright.asp"-->
