<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	PAGE_SETTING = "MYOFFICE"
	INFO_MODE	 = "ORDER1-1"

	ISLEFT = "T"
	ISSUBTOP = "T"
	OVERFLOW_VISIBLE = "F"


	Call ONLY_CS_MEMBER()
'	Call MEMBER_AUTH_CHECK(nowGradeCnt,3)

	If Not checkRef(houUrl &"/myoffice/buy/goodsList_sellcode.asp") Then Call alerts(LNG_ALERT_WRONG_ACCESS,"BACK","")


	'CATA 회원매출 1주문번호에 1개의 상품, 1개만 구매(2016-10-23) 전체
	If MEMBER_ORDER_CHK01_ALL > 0 Then Call alerts(LNG_CS_GOODSLIST_TEXT01_CATA,"back","")


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

	ncode = gRequestTF("nCode",True)
	inUidx = 1
	'inUidx = Trim(pRequestTF("nCode",True))
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
<script type="text/javascript" src="/PG/YESPAY/pay_cs.js"></script>
<script type="text/javascript" src="/jscript/calendar.js"></script>
<script src="http://dmaps.daum.net/map_js_init/postcode.v2.js"></script>
<script src="/jscript/daumPostCode.js"></script>
<style>
	#pages {padding: 0px 0 0px 0; display: inline-block;}
</style>
</head>
<body <%=BODYLOAD%>>
<!--#include virtual = "/_include/header.asp"-->
<%
	If webproIP="T" Then
		print "<br /><br /><br />"
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
		If UCase(DKPG_PGCOMPANY) = "CARDNUM" Then
			Call ResRW("/PG/CardNum/CardNum_cs.js","자바연결")
		End If
	End If
	If UCase(DKPG_PGCOMPANY) = "YESPAY" Then Call ResRW("/PG/YESPAY/pay_cs.js","자바연결")
%>
<div id="cart" class="orderList" style="margin-top:30px;">
	<form name="orderFrm" id="orderFrm" onsubmit="return orderSubmit(this);" action="/PG/YESPAY/CardResult_cs.asp" method="post">
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
					<th><%=LNG_CS_ORDERS_TEXT03%></th>
					<th><!-- <%=LNG_CS_ORDERS_TEXT04%> --><%=LNG_TEXT_SELLING_PRICE%></th>
					<th><%=CS_PV%></th>
					<th><%=LNG_TEXT_ITEM_NUMBER%></th>
					<th><%=LNG_CS_ORDERS_TOTAL_PV%></th>
					<th><%=LNG_CS_ORDERS_TEXT08%></th>
				</tr>
			</thead>
			<tbody>
			<%

				TOTAL_PRICE		= 0
				TOTAL_PV		= 0

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
						RS_Sell_VAT_Price			= DKRS("Sell_VAT_Price")			'부가세
						RS_Except_Sell_VAT_Price	= DKRS("Except_Sell_VAT_Price")		'공급가
					Else
						RS_ncode		= RS_ncode
						RS_price2		= RS_price2
						RS_price4		= RS_price4
						RS_Sell_VAT_Price			= RS_Sell_VAT_Price
						RS_Except_Sell_VAT_Price	= RS_Except_Sell_VAT_Price
					End If
					Call closeRs(DKRS)

					SELF_PRICE = 0
					SELF_PRICE = RS_Price2 * RS_ea

					SELF_PV = 0
					SELF_PV = RS_Price4 * RS_ea

					'공급가
					SELF_Except_Sell_VAT_Price = 0
					SELF_Except_Sell_VAT_Price = (RS_Except_Sell_VAT_Price * RS_ea)
					'부가세
					SELF_Sell_VAT_Price = 0
					SELF_Sell_VAT_Price = RS_Sell_VAT_Price * RS_ea

					'SELF_PRICE = (SELF_Except_Sell_VAT_Price + SELF_Sell_VAT_Price)

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
				'		Exit For
					End If

				'Next
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
			</tfoot>
		</table>

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
					<td><input type="text" class="input_text" name="takeADDR2" id="takeADDR2Daum" style="width:400px;" value="<%=RS_Address2%>" /></td>
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
							If RS_SellCode <> "01" Then Call ALERTS("회원매출상품만 구매 가능합니다.  ","BACK","")			'파인애플 상품테이블내 SellCode 없음

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
						'		PRINT TABS(4)&"	<option value=""01"">일반매출</option>"
						'	ElseIf Sell_Mem_TF = 1 Then
						'		PRINT TABS(4)&"	<option value=""02"">소비자매출</option>"
						'	Else
						'		PRINT TABS(4)&"	<option value="""">등록된 구매종류가 없습니다.</option>"
						'	End If
						%>
					</select>

				</td>
			</tr>
		</table>

		<%
			'▣제품구매관련 약관(파인애플 2017-02-01)
			arrParams2 = Array(_
				Db.makeParam("@policyType",adVarChar,adParamInput,10,"policy04") ,_
				Db.makeParam("@strNation",adVarChar,adParamInput,10,UCase(LANG)) _
			)
			viewContent = Db.execRsData("DKP_POLICY_CONTENT",DB_PROC,arrParams2,Nothing)
		%>
		<p class="titles">제품구매 약관동의</p>
		<div id="pages">
			<div style="" >
				<div class="agree_box" style="width:918px;"><div class="agree_content1" style="width:902px;height:150px;"><%=backword(viewContent)%></div></div>
				<p class="agreeArea tweight" style="padding-top:4px;"><label><input type="checkbox" name="agreement" value="T" id="agree01Chk" class="input_chk3" style="width:16px;height:16px;"/> 제품구매약관에 동의합니다.</label>
			</div>
		</div>

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
					</select><br /><br />
					<span>&#8226; <%=LNG_TEXT_DEPOSITOR%> : </span><input type="text" name="C_NAME2" class="input_text"/><span style="margin-left:50px;">&#8226; <%=LNG_CS_ORDERS_TRANSFER_DATE%> : </span><input type='text' name='memo1' value="" class='input_text readonly' onclick="openCalendar(event, this, 'YYYY-MM-DD');" readonly="readonly">
				</td>
			</tr><tr>
				<th>카드결제</th>
				<td style="padding-left:5px;"><label><input type="radio" name="payKind" value="Card" class="input_chk" onclick="payKindSelect(this.value)" /> 카드결제 사용</label></td>
				<td style="padding-left:5px;">신용카드로 결제합니다.</td>
			</tr><tr id="CardInfo" style="display:none;">
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
			</tr><!-- <tr>
				<th>현금결제</th>
				<td style="padding-left:5px;"><label><input type="radio" name="payKind" value="inCash" class="input_chk" onclick="payKindSelect(this.value)" />현금결제 사용</label></td>
				<td style="padding-left:5px;">현장에서 현금으로 결제합니다.</td>
			</tr> -->
			<!-- <tr>
				<th>이미 카드결제를 하신 분<%=LNG_TEXT_ORDER_CARD%> </th>
				<td style="padding-left:5px;"><label><input type="radio" name="payKind" value="Card" class="input_chk" onclick="payKindSelect(this.value)" /> <%=LNG_TEXT_ORDER_CARD%> (<%=DKPG_PGCOMPANY%>)</label></td>
				<td style="padding-left:5px;">이미 카드결제를 하신 분<%=LNG_TEXT_ORDER_CARD%></td>
			</tr><tr id="inCardInfo" style="display:none;">
				<td colspan="3" style="padding:20px 10px;background-color:#e8e8e8">
					<div style="background-color:#fff; padding:10px; border:1px solid #e2e2e2;">
						<table <%=tableatt%> class="inTable width100">
							<col width="130" />
							<col width="*" />
							<col width="250" />
							<tr>
								<th>카드사</th>
								<td>
									<select name="PGCardCode">
										<%
											arrParams = Array(_
												Db.makeParam("@strNationCode",adVarChar,adParamInput,6,LANG) _
											)
											arrList = Db.execRsList("DKSP_TBL_CARD_LIST",DB_PROC,arrParams,listLen,DB3)
											If IsArray(arrList) Then
										%>
										<option value="">== 결제하신 카드사를 선택해주세요 ==</option>
										<%
												For i = 0 To listLen
													arrList_ncode		= arrList(0,i)
													arrList_cardname	= arrList(1,i)

										%>
										<option value="<%=arrList_ncode%>"><%=arrList_cardname%></option>
										<%
												Next
											Else
										%>
										<option value="">== 지정된 카드사가 없습니다. 회사에 문의해주세요 ==</option>
										<%
											End If

										%>
									</select>
								</td>
								<td></td>
							</tr><tr>
								<th>카드번호</th>
								<td>
									<input type="text" name="CardNum1" class="input_text" maxlength="4" style="width:90px;" value="" <%=onlyKeys%> /> -
									**** -
									**** -
									<input type="text" name="CardNum4" class="input_text" maxlength="4" style="width:90px;" value="" <%=onlyKeys%> />
								</td>
								<td>앞 4자리, 마지막 4자리</td>
							</tr><tr>
								<th>승인번호</th>
								<td><input type="text" name="PGAcceptNum" maxlength="20" class="input_text" value="" /></td>
								<td>카드승인번호를 입력해주세요</td>
							</tr><tr>
								<th>승인일자</th>
								<td><input type="text" name="PGACP_TIME" maxlength="10" class="input_text readonly cp" readonly="reaonly" onclick="openCalendar(event, this, 'YYYY-MM-DD');" value="" /></td>
								<td>승인받은 일자를 선택해주세요</td>
							</tr>
						</table>
					</div>
				</td>
			</tr> -->

			<!-- <tr>
				<th>실시간계좌이체</th>
				<td style="padding-left:5px;"><label><input type="radio" name="payKind" value="DirectBank" class="input_chk" onclick="payKindSelect(this.value)" />실시간계좌이체</label></td>
				<td style="padding-left:5px;">실시간 계좌이체로 결제합니다.</td>
			</tr><tr>
				<th>가상계좌(무통장입금)</th>
				<td style="padding-left:5px;"><label><input type="radio" name="payKind" value="VBank" class="input_chk" onclick="payKindSelect(this.value)" />가상계좌(무통장입금)</label></td>
				<td style="padding-left:5px;">가상계좌로 결제합니다.</td>
			</tr> -->
		</table>

		<div class="pagingArea">
			<!-- <input type="image" src="<%=IMG_BTN%>/payGo.gif" /> -->
			<input type="submit" class="txtBtnC medium red2 shadow1 tshadow2 radius5" style="min-width:140px;" value="<%=LNG_CS_ORDERS_BTN01%>" />
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
	<input type="hidden" name="goodsName" size="50" value="<%=RS_Name%>" />

<input type="hidden" name="ori_price" value="<%=LAST_PRICE%>" />
<input type="hidden" name="ori_delivery" value="<%=DELIVERY_PRICE%>" readonly="readonly" />
<input type="hidden" name="isDownOrder" value="F" />	<!-- 본인구매 -->

<!-- 직판공제번호발급용 본인 -->
<input type="hidden" name="mbid1" value="<%=DK_MEMBER_ID1%>" />
<input type="hidden" name="mbid2" value="<%=DK_MEMBER_ID2%>" />


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
		Case "ERROR" : Call ALERTS("상품 가격 업데이트 중 에러가 발생하였습니다.","BACK","")
		Case "NOTORDER" : Call ALERTS("주문번호가 없습니다.","BACK","")
	End Select
%>
<!--#include virtual = "/_include/copyright.asp"-->
