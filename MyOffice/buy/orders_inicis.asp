<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	PAGE_SETTING = "MYOFFICE"
	INFO_MODE	 = "ORDER1-1"

	ISLEFT = "T"
	ISSUBTOP = "T"
	OVERFLOW_VISIBLE = "F"

	Call ONLY_CS_MEMBER()

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

	If inUidx = "" Then Call ALERTS("주문할 상품의 번호가 없습니다.새로고침 후 다시 시도해주세요.","go","cart.asp")

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

	If OUTPUT_VALUE = "ERROR" Then Call ALERTS("임시주문정보 저장중 에러가 발생하였습니다","back","")

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
<script language=javascript src="https://plugin.inicis.com/pay61_secunissl_cross.js"></script>
<script type="text/javascript" src="/PG2/INICIS/pays.js"></script>
<%
'일반						http://plugin.inicis.com/pay61_secuni_cross.js
'OpenSSL사용				https://plugin.inicis.com/pay61_secunissl_cross.js
'UNI 코드사용 				http://plugin.inicis.com/pay61_secuni_cross.js
'OpenSSL, UNI 코드 사용 	https://plugin.inicis.com/pay61_secunissl_cross.js
%>
<script type="text/javascript" src="/jscript/calendar.js"></script>

</head>
<body onload="javascript:enable_click()" onFocus="javascript:focus_control()">

<!--#include virtual = "/_include/header.asp"-->
<div id="cart" class="orderList">
	<form name="ini" method="post" autocomplete="off" action="/PG2/INICIS/INIsecureresult.asp" onSubmit="return pay(this)">
		<input type="hidden" name="cuidx" value="<%=inUidx%>" />
		<p class="titles">주문상품</p>
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
					<th>상품코드</th>
					<th>상품명</th>
					<th>회원가</th>
					<th>PV</th>
					<th>수량</th>
					<th>총 PV</th>
					<th>총 금액</th>
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
						RS_ea			= DKRSS("ea")
						RS_Bc			= DKRSS("Base_Cnt")
					Else
						Call alerts("주문할 상품 중 판매가 중지되었거나 삭제되는 등의 오류가 발생하였습니다.\n\n새로고침 후 다시 시도해주세요.","back","")
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
					Else
						RS_ncode		= RS_ncode
						RS_price2		= RS_price2
						RS_price4		= RS_price4
					End If
					Call closeRs(DKRS)

					SELF_PRICE = 0
					SELF_PRICE = RS_Price2 * RS_ea

					SELF_PV = 0
					SELF_PV = (RS_Price4 * RS_ea)

					PRINT tabs(1)&"	<tr>"
					PRINT tabs(1)&"		<td class=""tcenter"">"&RS_Ncode&"</td>"
					PRINT tabs(1)&"		<td style=""padding-left:5px;"">"&RS_Name&"</td>"
					PRINT tabs(1)&"		<td class=""inPrice"">"&num2cur(RS_Price2)&" 원</td>"
					PRINT tabs(1)&"		<td class=""inPrice Price"">"&num2cur(RS_Price4)&" PV </td>"
					PRINT tabs(1)&"		<td class=""inPrice"">"&RS_ea&" 개</td>"
					PRINT tabs(1)&"		<td class=""inPrice Price"">"&num2cur(SELF_PV)&" PV</td>"
					PRINT tabs(1)&"		<td class=""inPrice Price"">"&num2cur(SELF_PRICE)&" 원</td>"
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
						Call ALERTS("주문 임시 저장 중 오류가 발생하였습니다.새로고침 후 다시 시도해주세요.","BACK","")
						Exit For
					End If

				Next
			%>
			</tbody>
			<tfoot>
				<tr>
					<td colspan="6" class="tweight tright bg2 pR4">구매 총 PV</td>
					<td class="inPrice tPrice"><%=num2cur(TOTAL_PV)%> PV</td>
				</tr><tr>
					<td colspan="6" class="tweight tright bg2 pR4">구매 총 금액</td>
					<td class="inPrice tPrice"><%=num2cur(TOTAL_PRICE)%> 원</td>
				</tr>

				<%
					If TOTAL_PRICE < 50000 Then
						DELIVERY_PRICE = 0'2500
						DELIVERY_TXT = "※ 5만원 이하 구매로 배송료가 부과됩니다."
					Else
						DELIVERY_PRICE = 0
						DELIVERY_TXT = "※ 5만원 이상 구매로 무료배송처리 됩니다."
					End If

					LAST_PRICE = TOTAL_PRICE + DELIVERY_PRICE
				%>

				<tr>
					<td colspan="6" class="tweight tright bg2"><%=DELIVERY_TXT%></td>
					<td class="inPrice tPrice"><%=num2cur(DELIVERY_PRICE)%> 원</td>
				</tr>
				<tr>
					<td colspan="6" class="tweight tright bg2 pR4">최종 결제 금액</td>
					<td class="inPrice tPrice"><%=num2cur(LAST_PRICE)%> 원</td>
				</tr>
			</tfoot>
		</table>

		<p class="titles">배송(주문자)정보</p>
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
						If RS_Address1	<> "" Then RS_Address1	= objEncrypter.Decrypt(RS_Address1)
						If RS_Address2	<> "" Then RS_Address2	= objEncrypter.Decrypt(RS_Address2)
						If RS_Address3	<> "" Then RS_Address3	= objEncrypter.Decrypt(RS_Address3)
						If RS_hometel	<> "" Then RS_hometel	= objEncrypter.Decrypt(RS_hometel)
						If RS_hptel		<> "" Then RS_hptel		= objEncrypter.Decrypt(RS_hptel)
					'	PRINT  objEncrypter.Decrypt("Z0SPQ6DkhLd4e")
					Set objEncrypter = Nothing
				End If

				If RS_WebID = "" Then RS_WebID = "웹아이디 미등록 계정"

				If RS_hometel = "" Or IsNull(RS_hometel) Then RS_hometel = "--"
					arrTEL = Split(RS_hometel,"-")
				If RS_hptel = "" Or IsNull(RS_hptel) Then RS_hptel = "--"
					arrMob = Split(RS_hptel,"-")
				If RS_Email = "" Or IsNull(RS_Email) Then RS_Email = "@"
					arrMAIL = Split(RS_Email,"@")
				If RS_BirthDay = "" Or IsNull(RS_BirthDay) Then
					RS_BirthDay = "--"
				Else
					RS_BirthDay = date8to10(RS_BirthDay)
				End If
					arrBIRTH = Split(RS_BirthDay,"-")


			Else
				Call ALERTS("회원정보가 로드되지 못했습니다.","back","")
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
					<th>이름(수령인) <%=starText%></th>
					<td><input type="text" class="input_text" name="strName" style="width:200px;" value="<%=RS_M_Name%>" /></td>
				</tr><tr class="line">
					<th>주소 <%=starText%></th>
					<td>
						<input type="text" class="input_text" name="strZip" style="width:80px;background-color:#f4f4f4;" readonly="readonly" value="<%=cutZip(RS_addcode1)%>" />
						<img src="<%=IMG_MYPAGE%>/zip_search.gif" width="68" height="20" alt="주소 찾기" class="vmiddle cp" onclick="openzip('ini');" />
						<input type="text" class="input_text" name="strAddr1" style="width:390px;background-color:#f4f4f4;" readonly="readonly" value="<%=RS_Address1%>" />
					</td>
				</tr><tr>
					<th>상세주소 <%=starText%></th>
					<td><input type="text" class="input_text" name="strAddr2" style="width:550px;" value="<%=RS_Address2%>" /></td>
				</tr><tr>
					<th>이메일주소 <%=starText%></th>
					<td>
						<input type="text" class="input_text imes" name="strEmail" style="width:350px;" value="<%=RS_Email%>" /><br /><br />
						<span class="summary">* PG사 정책으로 인해 반드시 필요한 정보입니다. 정확히 기재해주세요.</span>
					</td>
				</tr><tr>
					<th>휴대폰번호 <%=starText%></th>
					<td>
						<select name="mob_num1" style="width:55px;" class="vmiddle">
							<option value=""		<%=isSelect(arrMob(0),"")%>>선택</option>
							<option value="010"		<%=isSelect(arrMob(0),"010")%>>010</option>
							<option value="011"		<%=isSelect(arrMob(0),"011")%>>011</option>
							<option value="016"		<%=isSelect(arrMob(0),"016")%>>016</option>
							<option value="017"		<%=isSelect(arrMob(0),"017")%>>017</option>
							<option value="018"		<%=isSelect(arrMob(0),"018")%>>018</option>
							<option value="019"		<%=isSelect(arrMob(0),"019")%>>019</option>
							<option value="0130"	<%=isSelect(arrMob(0),"0130")%>>0130</option>
							<option value="0502"	<%=isSelect(arrMob(0),"0502")%>>0502</option>
							<option value="0505"	<%=isSelect(arrMob(0),"0505")%>>0505</option>
							<option value="0506"	<%=isSelect(arrMob(0),"0506")%>>0506</option>
							<option value="1541"	<%=isSelect(arrMob(0),"1541")%>>1541</option>
							<option value="1595"	<%=isSelect(arrMob(0),"1595")%>>1595</option>
							<option value="08217"	<%=isSelect(arrMob(0),"08217")%>>08217</option>
						</select> -
						<input type="text" class="input_text" name="mob_num2" style="width:45px;" maxlength="5" <%=onLyKeys%> value="<%=arrMob(1)%>" /> -
						<input type="text" class="input_text" name="mob_num3" style="width:45px;" maxlength="5" <%=onLyKeys%> value="<%=arrMob(2)%>"  />
						<span class="summary">* 비상연락 시 반드시 필요한 정보입니다. 정확히 기재해주세요.</span>
					</td>
				</tr><tr>
					<th>전화번호</th>
					<td>
						<select name="tel_num1" style="width:55px;" class="vmiddle">
							<option value=""		<%=isSelect(arrTEL(0),"")%>>선택</option>
							<option value="02"		<%=isSelect(arrTEL(0),"02")%>>02</option>
							<option value="0303"	<%=isSelect(arrTEL(0),"0303")%>>0303</option>
							<option value="031"		<%=isSelect(arrTEL(0),"031")%>>031</option>
							<option value="032"		<%=isSelect(arrTEL(0),"032")%>>032</option>
							<option value="033"		<%=isSelect(arrTEL(0),"033")%>>033</option>
							<option value="041"		<%=isSelect(arrTEL(0),"041")%>>041</option>
							<option value="042"		<%=isSelect(arrTEL(0),"042")%>>042</option>
							<option value="043"		<%=isSelect(arrTEL(0),"043")%>>043</option>
							<option value="0502"	<%=isSelect(arrTEL(0),"0502")%>>0502</option>
							<option value="0504"	<%=isSelect(arrTEL(0),"0504")%>>0504</option>
							<option value="0505"	<%=isSelect(arrTEL(0),"0505")%>>0505</option>
							<option value="0506"	<%=isSelect(arrTEL(0),"0506")%>>0506</option>
							<option value="051"		<%=isSelect(arrTEL(0),"051")%>>051</option>
							<option value="052"		<%=isSelect(arrTEL(0),"052")%>>052</option>
							<option value="053"		<%=isSelect(arrTEL(0),"053")%>>053</option>
							<option value="054"		<%=isSelect(arrTEL(0),"054")%>>054</option>
							<option value="055"		<%=isSelect(arrTEL(0),"055")%>>055</option>
							<option value="061"		<%=isSelect(arrTEL(0),"061")%>>061</option>
							<option value="062"		<%=isSelect(arrTEL(0),"062")%>>062</option>
							<option value="063"		<%=isSelect(arrTEL(0),"063")%>>063</option>
							<option value="064"		<%=isSelect(arrTEL(0),"064")%>>064</option>
							<option value="070"		<%=isSelect(arrTEL(0),"070")%>>070</option>
							<option value="080"		<%=isSelect(arrTEL(0),"080")%>>080</option>
							<option value="1544"	<%=isSelect(arrTEL(0),"1544")%>>1544</option>
							<option value="1566"	<%=isSelect(arrTEL(0),"1566")%>>1566</option>
							<option value="1577"	<%=isSelect(arrTEL(0),"1577")%>>1577</option>
							<option value="1588"	<%=isSelect(arrTEL(0),"1588")%>>1588</option>
							<option value="1599"	<%=isSelect(arrTEL(0),"1599")%>>1599</option>
							<option value="1600"	<%=isSelect(arrTEL(0),"1600")%>>1600</option>
							<option value="1644"	<%=isSelect(arrTEL(0),"1644")%>>1644</option>
							<option value="1661"	<%=isSelect(arrTEL(0),"1661")%>>1661</option>
							<option value="1688"	<%=isSelect(arrTEL(0),"1688")%>>1688</option>
						</select> -
						<input type="text" class="input_text" name="tel_num2" style="width:45px;" maxlength="5" <%=onLyKeys%> value="<%=arrTEL(1)%>"  /> -
						<input type="text" class="input_text" name="tel_num3" style="width:45px;" maxlength="5" <%=onLyKeys%> value="<%=arrTEL(2)%>"  />
					</td>
				</tr>
			</tbody>
		</table>

		<p class="titles">기타사항</p>
		<table <%=tableatt%> class="userCWidth">
			<col width="140" />
			<col width="620" />
			<tr>
				<th>구매종류</th>
				<td style="padding-left:5px;">
					<select name="v_SellCode">
						<!-- <option value="">구매종류선택</option> -->
						<%
							arrListB = Db.execRsList("DKP_SELLTYPE_LIST",DB_PROC,Nothing,listLenB,DB3)
							If IsArray(arrListB) Then
								For i = 0 To listLenB
									PRINT TABS(4)&"	<option value="""&arrListB(0,i)&""">"&arrListB(1,i)&"</option>"
								Next
							Else
								PRINT TABS(4)&"	<option value="""">등록된 구매종류가 없습니다.</option>"
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

		<p class="titles">결제방식</p>
		<table <%=tableatt%> class="userCWidth">
			<col width="140" />
			<col width="400" />
			<col width="220" />
			<tr>
				<th>무통장입금</th>
				<td style="padding-left:5px;"><label><input type="radio" name="payKind" value="inBank" class="input_chk" onclick="payKindSelect(this.value)" />무통장입금 사용</label></td>
				<td style="padding-left:5px;">무통장입금으로 결제합니다.</td>
			</tr><tr id="inBankInfo" style="display:none;">
				<td colspan="3" style="padding-left:20px;">&#8226; 입금은행 :
					<select name="C_codeName" style="margin-left:5px;">
						<option value="">입금은행선택</option>
						<%
							arrListB = Db.execRsList("DKP_BANK_LIST2",DB_PROC,Nothing,listLenB,DB3)
							If IsArray(arrListB) Then
								For i = 0 To listLenB
									PRINT TABS(4)&"	<option value="""&arrListB(0,i)&","&arrListB(1,i)&","&arrListB(2,i)&","&arrListB(3,i)&""">["&arrListB(1,i)&"] "&arrListB(3,i)&" - "&arrListB(2,i)&"</option>"
								Next
							Else
								PRINT TABS(4)&"	<option value="""">등록된 회사계좌가 없습니다.</option>"
							End If
						%>
					</select><br /><br />
					<span>&#8226; 입금자명 : </span><input type="text" name="C_NAME2" class="input_text"/><span style="margin-left:50px;">&#8226; 입금예정일 : </span><input type='text' name='memo1' value="" class='input_text readonly' onclick="openCalendar(event, this, 'YYYY-MM-DD');" readonly="readonly">
				</td>
			</tr><!-- <tr>
				<th>현금결제</th>
				<td style="padding-left:5px;"><label><input type="radio" name="payKind" value="inCash" class="input_chk" onclick="payKindSelect(this.value)" />현금결제 사용</label></td>
				<td style="padding-left:5px;">현장에서 현금으로 결제합니다.</td>
			</tr> --><tr>
				<th>카드결제</th>
				<td style="padding-left:5px;"><label><input type="radio" name="payKind" value="Card" class="input_chk" onclick="payKindSelect(this.value)" />카드결제 사용(이니시스테스트)</label></td>
				<td style="padding-left:5px;">신용카드로 결제합니다.</td>
			</tr><!-- <tr>
				<th>실시간계좌이체</th>
				<td style="padding-left:5px;"><label><input type="radio" name="payKind" value="DirectBank" class="input_chk" onclick="payKindSelect(this.value)" />실시간계좌이체</label></td>
				<td style="padding-left:5px;">실시간 계좌이체로 결제합니다.</td>
			</tr><tr>
				<th>가상계좌(무통장입금)</th>
				<td style="padding-left:5px;"><label><input type="radio" name="payKind" value="VBank" class="input_chk" onclick="payKindSelect(this.value)" />가상계좌(무통장입금)</label></td>
				<td style="padding-left:5px;">가상계좌로 결제합니다.</td>
			</tr> -->
		</table>

		<div class="pagingArea"><input type="image" src="<%=IMG_BTN%>/payGo.gif" /></div>

<input type="hidden" name="gopaymethod" value="">
<input type="hidden" name="totalPrice" value="<%=LAST_PRICE%>" />
<input type="hidden" name="totalDelivery" value="<%=DELIVERY_PRICE%>" />
<input type="hidden" name="totalOptionPrice" value="<%=totalOptionPrice%>" />
<input type="hidden" name="totalPoint" value="<%=total_point%>" />
<input type="hidden" name="totalVotePoint" value="<%=total_voterpoint%>" />
<input type="hidden" name="strOption" value="<%=strOption%>" />
<input type="hidden" name="OrdNo" value="<%=orderNum%>" />
<input type="hidden" name="OIDX" value="<%=orderTempIDX%>" />

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
