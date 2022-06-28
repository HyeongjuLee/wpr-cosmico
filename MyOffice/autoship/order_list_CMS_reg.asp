<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	PAGE_SETTING = "MYOFFICE"
	INFO_MODE	 = "AUTOSHIP1-2"

	ISLEFT = "T"
	ISSUBTOP = "T"
	AUTOSHIP_CNT_PAGE = "T"

	Call ONLY_BUSINESS_MEMBER(DK_MEMBER_LEVEL,1)
	Call FN_NationCurrency(DK_MEMBER_NATIONCODE,Chg_CurrencyName,Chg_CurrencyISO)
%>
<!--#include virtual = "/Myoffice/autoship/_autoship_CONFIG.asp"-->
<%
	arrParams = Array(_
		Db.makeParam("@mbid",adVarChar,adParamInput,20,DK_MEMBER_ID1), _
		Db.makeParam("@mbid2",adInteger,adParamInput,0,DK_MEMBER_ID2) _
	)
	Set DKRS = Db.execRs("DKP_MEMBER_INFO",DB_PROC,arrParams,DB3)
	If Not DKRS.BOF And Not DKRS.EOF Then
		DKRS_mbid				= DKRS("mbid")
		DKRS_mbid2				= DKRS("mbid2")
		DKRS_M_Name				= DKRS("M_Name")
		DKRS_E_name				= DKRS("E_name")
		DKRS_Email				= DKRS("Email")
		DKRS_cpno				= DKRS("cpno")
		DKRS_Addcode1			= DKRS("Addcode1")
		DKRS_Address1			= DKRS("Address1")
		DKRS_Address2			= DKRS("Address2")
		DKRS_Address3			= DKRS("Address3")
		DKRS_reqtel				= DKRS("reqtel")
		DKRS_officetel			= DKRS("officetel")
		DKRS_hometel			= DKRS("hometel")
		DKRS_hptel				= DKRS("hptel")
		DKRS_LineCnt			= DKRS("LineCnt")
		DKRS_N_LineCnt			= DKRS("N_LineCnt")
		DKRS_Recordid			= DKRS("Recordid")
		DKRS_Recordtime			= DKRS("Recordtime")
		DKRS_businesscode		= DKRS("businesscode")
		DKRS_bankcode			= DKRS("bankcode")
		DKRS_banklocal			= DKRS("banklocal")
		DKRS_bankaccnt			= DKRS("bankaccnt")
		DKRS_bankowner			= DKRS("bankowner")
		DKRS_Regtime			= DKRS("Regtime")
		DKRS_Saveid				= DKRS("Saveid")
		DKRS_Saveid2			= DKRS("Saveid2")
		DKRS_Nominid			= DKRS("Nominid")
		DKRS_Nominid2			= DKRS("Nominid2")
		DKRS_RegDocument		= DKRS("RegDocument")
		DKRS_CpnoDocument		= DKRS("CpnoDocument")
		DKRS_BankDocument		= DKRS("BankDocument")
		DKRS_Remarks			= DKRS("Remarks")
		DKRS_LeaveCheck			= DKRS("LeaveCheck")
		DKRS_LineUserCheck		= DKRS("LineUserCheck")
		DKRS_LeaveDate			= DKRS("LeaveDate")
		DKRS_LineUserDate		= DKRS("LineUserDate")
		DKRS_LeaveReason		= DKRS("LeaveReason")
		DKRS_LineDelReason		= DKRS("LineDelReason")
		DKRS_WebID				= DKRS("WebID")
		DKRS_WebPassWord		= DKRS("WebPassWord")
		DKRS_BirthDay			= DKRS("BirthDay")
		DKRS_BirthDay_M			= DKRS("BirthDay_M")
		DKRS_BirthDay_D			= DKRS("BirthDay_D")
		DKRS_BirthDayTF			= DKRS("BirthDayTF")
		DKRS_Ed_Date			= DKRS("Ed_Date")
		'DKRS_Ed_TF				= DKRS("Ed_TF")				'신버전삭제
		DKRS_PayStop_Date		= DKRS("PayStop_Date")
		DKRS_PayStop_TF			= DKRS("PayStop_TF")
		DKRS_For_Kind_TF		= DKRS("For_Kind_TF")
		DKRS_Sell_Mem_TF		= DKRS("Sell_Mem_TF")
		DKRS_CurGrade			= DKRS("CurGrade")
		DKRS_Remarks			= DKRS("Remarks")			'비고

		Set objEncrypter = Server.CreateObject ("Hyeongryeol.StringEncrypter")
			objEncrypter.Key = con_EncryptKey
			objEncrypter.InitialVector = con_EncryptKeyIV
			On Error Resume Next
				If DKRS_Address1		<> "" Then DKRS_Address1	= objEncrypter.Decrypt(DKRS_Address1)
				If DKRS_Address2		<> "" Then DKRS_Address2	= objEncrypter.Decrypt(DKRS_Address2)
				If DKRS_Address3		<> "" Then DKRS_Address3	= objEncrypter.Decrypt(DKRS_Address3)
				If DKRS_hometel			<> "" Then DKRS_hometel		= objEncrypter.Decrypt(DKRS_hometel)
				If DKRS_hptel			<> "" Then DKRS_hptel		= objEncrypter.Decrypt(DKRS_hptel)
				If DKRS_bankaccnt		<> "" Then DKRS_bankaccnt	= objEncrypter.Decrypt(DKRS_bankaccnt)
				If DKRS_Reg_bankaccnt		<> "" Then DKRS_Reg_bankaccnt	= objEncrypter.Decrypt(DKRS_Reg_bankaccnt)

				'If DKCONF_ISCSNEW = "T" Then	''▣CS신버전 암/복호화 추가
					If DKRS_Email		<> "" Then DKRS_Email		= objEncrypter.Decrypt(DKRS_Email)
					If DKRS_WebID		<> "" Then DKRS_WebID		= objEncrypter.Decrypt(DKRS_WebID)
					If DKRS_WebPassWord	<> "" Then DKRS_WebPassWord	= objEncrypter.Decrypt(DKRS_WebPassWord)
					If DKRS_cpno		<> "" Then DKRS_cpno		= objEncrypter.Decrypt(DKRS_cpno)				'▣cpno
				'End If
			On Error GoTo 0
		Set objEncrypter = Nothing
	Else
		Call ALERTS(LNG_JS_MEMBERINFO_FAIL,"back","")
	End If
	Call closeRS(DKRS)

	If DKPG_PGCOMPANY = "PAYTAG" Then
		If DKRS_hptel = "" Then
			Call ALERTS(LNG_JS_MOBILE&" (필수값)","GO","/mypage/member_info.asp")
		End if
	End If
%>
<!--#include virtual = "/_include/document.asp"-->
<!--#include virtual = "/_include/calendar.asp"-->
<!-- <link rel="stylesheet" href="/myoffice/css/style_cs.css" /> -->
<!-- <link rel="stylesheet" href="/myoffice/css/layout_cs.css" /> -->
<link rel="stylesheet" href="/myoffice/autoship/order_list_CMS.css?v1" />
<link rel="stylesheet" href="/css/order_list_CMS_mod.css?" />

<!--#include file = "order_list_CMS.js.asp"--><%'JS%>
<script src="order_list_CMS_reg.js?v3"></script>
<script type="text/javascript">
</script>
</head>
<body>
<!--#include virtual = "/_include/header.asp"-->
<div id="loadingsA" class="loadingsA userCWidth">
	<div class="loadingsInnerA">
		<img src="<%=IMG%>/159.gif" width="60" alt="" />
	</div>
</div>
<div id="buy" class="orderList cms">
	<form name="cfrm" method="post">
		<input type="hidden" name="PGCOMPANY" value="<%=DKPG_PGCOMPANY%>" />
		<input type="hidden" name="mode" value="REGIST" />
		<div class="agree_info">
			<ul>
				<li class="li_title"><%=LNG_AUTOSHIP_REG_AGREE_01%></li>
				<li>-&nbsp;<%=LNG_AUTOSHIP_REG_AGREE_02%></li>
				<li>-&nbsp;<%=LNG_AUTOSHIP_REG_AGREE_03%></li>
				<li>-&nbsp;<%=LNG_AUTOSHIP_REG_AGREE_04%></li>
				<li>-&nbsp;<%=LNG_AUTOSHIP_REG_AGREE_05%></li>
				<li>-&nbsp;<%=LNG_AUTOSHIP_REG_AGREE_06%></li>
				<li>-&nbsp;<%=LNG_AUTOSHIP_REG_AGREE_07%><!-- , <%=LNG_AUTOSHIP_REG_AGREE_08%> --></li>
				<li>-&nbsp;<%=LNG_AUTOSHIP_REG_AGREE_09%></li>
			</ul>
			<div class="agreement">
				<label for="autoship_agree"><input type="checkbox" name="autoship_agree" id="autoship_agree" class="input_check" value="T" /> &nbsp;<%=LNG_AUTOSHIP_REG_AGREE_10%></label>
			</div>
		</div>

		<p class="titles"><%=LNG_AUTOSHIP_REG_MEMBER_INFO_01%></p><%'회원 기본 배송 주소%>
		<table <%=tableatt%> class="innerTable2 table1">
			<col width="160" />
			<col width="*" />
			<tr>
				<th><%=LNG_AUTOSHIP_REG_MEMBER_INFO_02%>&nbsp;<%=startext%></th>
				<td><input type="text" name="strName" class="input_text" value="<%=backword_br(DKRS_M_Name)%>" /></td>
			</tr><tr>
				<th><%=LNG_TEXT_ADDRESS1%>&nbsp;<%=starText%></th>
				<td>
					<input type="text" name="strZip" id="strZipDaum" class="input_text readonly vmiddle zip" value="<%=DKRS_Addcode1%>" maxlength="7" readonly="readonly" placeholder="" />
					<a name="modal" href="/m/common/pop_postcode.asp" id="pop_postcode"  title="<%=LNG_TEXT_ZIPCODE%>"><input type="button" class="input_submit design3" value="<%=LNG_TEXT_ZIPCODE%>"/></a>
					<input type="text" name="strADDR1" id="strADDR1Daum" class="input_text readonly vmiddle addr1" value="<%=DKRS_Address1%>" readonly="readonly" placeholder="" />
				</td>
			</tr><tr>
				<th><%=LNG_TEXT_ADDRESS2%>&nbsp;<%=starText%></th>
				<td><input type="text" name="strADDR2" id="strADDR2Daum" class="input_text addr2" value="<%=DKRS_Address2%>"  placeholder="" /></td>
			</tr>
			<tr>
				<th><%=LNG_TEXT_CONTACT_NUMBER%> 1&nbsp;<%=starText%></th>
				<td><input type="text" class="input_text" name="strMobile" maxlength="15" <%=onLyKeys%> value="<%=DKRS_hptel%>"  placeholder="" /></td>
			</tr><tr>
				<th><%=LNG_TEXT_CONTACT_NUMBER%> 2</th>
				<td><input type="text" class="input_text" name="strTel" maxlength="15" <%=onLyKeys%> value="<%=DKRS_hometel%>"  placeholder="" /></td>
			</tr>
		</table>

		<%
			'PG사별 오토쉽 인증방식 구분
			Select Case DKPG_PGCOMPANY
				Case "KSNET"
					KEYIN_CARDAUTH_TF = "F"
				Case Else
					KEYIN_CARDAUTH_TF = "T"
			End Select
		%>
		<input type="hidden" name="KEYIN_CARDAUTH_TF" id="KEYIN_CARDAUTH_TF" value="<%=KEYIN_CARDAUTH_TF%>" readonly="readonly" />

		<p class="titles"><%=LNG_AUTOSHIP_REG_CARD_INFO_01%></p><%'카드 결제 정보%>
		<table <%=tableatt%> class="innerTable3 table2">
			<col width="160" />
			<col width="*" />
			<tbody id="CARD_INFO">
			<%If KEYIN_CARDAUTH_TF = "T" Then%>
				<tr>
					<th><%=LNG_AUTOSHIP_REG_CARD_INFO_02%>&nbsp;<%=starText%></th>
					<td>
						<%
							Select Case DKPG_PGCOMPANY
								Case "ONOFFKOREA"
									V_display = ""
								Case Else
									V_display = "display: none;"
							End Select
						%>
						<select name="A_CardType" class="" style="<%=V_display%>">
							<option value="0"><%=LNG_AUTOSHIP_REG_CARD_INFO_03%></option>
							<option value="1"><%=LNG_AUTOSHIP_REG_CARD_INFO_04%></option>
						</select>
						<select name="A_CardCode" class="vmiddle input_text" >
							<option value="">== <%=LNG_AUTOSHIP_REG_CARD_INFO_05%> ==</option>
							<%
								SQL = "SELECT [ncode],[cardname] FROM [tbl_Card] WITH(NOLOCK) WHERE [recordid] = 'admin' ORDER BY [nCode] ASC"
								arrList = Db.execRsList(SQL,DB_TEXT,Nothing,listLen,DB3)
								If IsArray(arrList) Then
									For k = 0 To listLen
										PRINT Tabs(5)& "	<option value="""&arrList(0,k)&""" "&isSelect(RS_A_CardCode,arrList(0,k))&">"&arrList(1,k)&"</option>"
									Next
								Else
									PRINT Tabs(5)& "	<option value="""">"&LNG_AUTOSHIP_REG_CARD_INFO_NOT&"</option>"
								End If
							%>
						</select>
					</td>
				</tr><tr>
					<th><%=LNG_SHOP_ORDER_FINISH_21%>&nbsp;<%=startext%></th>
					<td>
						<input type="text" name="A_CardNumber1" id="A_CardNumber1" class="input_text vmiddle card" maxlength="4" onkeyup="focus_next_input(this);" value="" <%=onlyKeys%> />
						<input type="password" name="A_CardNumber2" id="A_CardNumber2" class="input_text vmiddle card" maxlength="4" onkeyup="focus_next_input(this);" value="" <%=onlyKeys%> />
						<input type="password" name="A_CardNumber3" id="A_CardNumber3" class="input_text vmiddle card" maxlength="4" onkeyup="focus_next_input(this);" value="" <%=onlyKeys%> />
						<input type="text" name="A_CardNumber4" id="A_CardNumber4" class="input_text vmiddle card" maxlength="4" value="" <%=onlyKeys%> />
					</td>
				<tr><tr>
					<th><%=LNG_SHOP_ORDER_CARD_01%>&nbsp;<%=starText%></th>
					<td>
						<select name="A_Period1" class="vmiddle input_text" style="width:120px;" >
							<option value=""><%=LNG_SHOP_ORDER_CARD_01%>(<%=LNG_TEXT_YEAR%>)</option>
							<%For i2 = THIS_YEAR To EXPIRE_YEAR%>
								<option value="<%=i2%>" ><%=i2%></option>
							<%Next%>
						</select>
						<select name="A_Period2" class="vmiddle input_text" style="width:110px;" >
							<option value=""><%=LNG_SHOP_ORDER_CARD_01%>(<%=LNG_TEXT_MONTH%>)</option>
							<%For j = 1 To 12%>
								<%jsmm = Right("0"&j,2)%>
								<option value="<%=jsmm%>"><%=jsmm%></option>
							<%Next%>
						</select>
					</td>
				</tr><tr>
					<th><%=LNG_AUTOSHIP_REG_CARD_INFO_06%>&nbsp;<%=starText%></th>
					<td><input type="text" name="A_Card_Name_Number" class="input_text vmiddle" value=""/></td>
				</tr>
				<%If DKPG_PGCOMPANY = "PAYTAG" Then%>
				<tr>
					<th><%=LNG_TEXT_PASSWORD%></th>
					<td>
						<input type="password" name="A_CardPass" class="input_text tcenter" maxlength="2" style="width:90px;" <%=onlyKeys%> value="" />
						<span class="red2"> * <%=LNG_SHOP_ORDER_CARD_09%></span>
					</td>
				</tr>
				<%Else%>
					<input type="hidden" name="A_CardPass" readonly="readonly" />
				<%End if%>

				<tr>
					<th>
						<span class="A_CardType_txt_0"><%=LNG_TEXT_BIRTH%></span>
						<span class="A_CardType_txt_1" style="display:none;"><%=LNG_AUTOSHIP_REG_CARD_INFO_07%></span>
						<%=starText%>
					</th>
					<td>
						<input type="password" name="A_Birth" maxlength="6" class="input_text vmiddle" value="" placeholder="YYMMDD" <%=onlyKeys%> />
						<span class="summary A_CardType_txt_0"> ex) 630215 <%=LNG_AUTOSHIP_REG_CARD_INFO_08%></span>
						<span class="summary A_CardType_txt_1" style="display:none;"> * <%=LNG_SHOP_ORDER_CARD_08%></span>
					</td>
				</tr>
				<%If DKPG_PGCOMPANY = "ONOFFKOREA" OR DKPG_PGCOMPANY = "PAYTAG" Then%>
				<tr>
					<th><%=LNG_TEXT_CONTACT_NUMBER%>&nbsp;<%=starText%></th>
					<td><input type="text" class="input_text" name="A_CardPhoneNum" maxlength="15" <%=onLyKeys2%> value="<%=DKRS_hptel%>"  placeholder="" /></td>
				</tr>
				<%Else%>
					<input type="hidden" name="A_CardPhoneNum" value="" readonly="readonly" />
				<%End If%>
				<tr>
					<th><%=LNG_AUTOSHIP_REG_CARD_INFO_09%>&nbsp;<%=starText%></th>
					<td>
						<input type="button" class="input_submit design3" onclick="join_cardCheck();" value="<%=LNG_AUTOSHIP_REG_CARD_INFO_09%>"/>
						&nbsp;&nbsp;&nbsp;
						<span class="summary" id="cardCheckSpan">
							<input type="hidden" name="cardCheck" value="F" readonly="readonly" />
							<input type="hidden" name="chkA_Card_Dongle" id="chkA_Card_Dongle" value="" readonly="readonly" />
							<input type="hidden" name="chkA_Card_DongleIDX" id="chkA_Card_DongleIDX" value="" readonly="readonly" />

							<input type="hidden" name="chkA_CardType" id="chkA_CardType" value="" readonly="readonly" />
							<input type="hidden" name="chkA_CardCode" id="chkA_CardCode" value="" readonly="readonly" />
							<input type="hidden" name="chkA_CardNumber" value="" readonly="readonly" />
							<input type="hidden" name="chkA_Period1" value="" readonly="readonly" />
							<input type="hidden" name="chkA_Period2" value="" readonly="readonly" />
							<input type="hidden" name="chkA_Card_Name_Number" id="chkA_Card_Name_Number" value="" readonly="readonly" />
							<input type="hidden" name="chkA_Birth" id="chkA_Birth" value="" readonly="readonly" />
							<input type="hidden" name="chkA_CardPhoneNum" id="chkA_CardPhoneNum" value="" readonly="readonly" />
						</span>
					</td>
				</tr>

			<%Else%>
				<tr>
					<th><%=LNG_AUTOSHIP_REG_CARD_INFO_02%></th>
					<td><span id="CardNameTXT"></span></td>
				</tr>
				<tr>
					<th><%=LNG_SHOP_ORDER_FINISH_21%></th>
					<td><span id="CardNumberTXT"></td>
				</tr>
				<tr>
					<th><%=LNG_AUTOSHIP_REG_CARD_INFO_09%>&nbsp;<%=starText%></th>
					<td>
					<%
						Select Case DKPG_PGCOMPANY
							Case "KSNET"
								If TX_KSNET_TID_AUTOSHIP = "2999199999" Then TEST_KEY_TXT = "_test_key!!"
					%>
							<input type="hidden" name="returnUrl" value="" readonly="readonly">
							<input type="hidden" name="storeid" size="10" value="<%=TX_KSNET_TID_AUTOSHIP%>" readonly="readonly">
							<!-- <input type="hidden" name="payKey" size="30" value="" readonly="readonly">
							<input type="hidden" name="cardNumb" size="30" value="" readonly="readonly">
							<input type="hidden" name="cardIssureCode" size="30" value="" readonly="readonly">
							<input type="hidden" name="cardPurchaserCode" size="30" value="" readonly="readonly"> -->
							<input type="button" class="txtBtn j_medium" onclick="javascript:submitAuth2();" value="<%=LNG_AUTOSHIP_REG_CARD_INFO_09%><%=TEST_KEY_TXT%>"/>
					<%
						End Select
					%>
						<span class="summary" id="cardCheckTXT"></span>
						<select name="A_CardCode" class="vmiddle input_text" style="display:none;"><option value=""></option></select>
						<input type="hidden" name="A_CardNumber1" id="A_CardNumber1" value="" readonly="readonly"  />
						<input type="hidden" name="A_CardNumber2" id="A_CardNumber2" value="" readonly="readonly"  />
						<input type="hidden" name="A_CardNumber3" id="A_CardNumber3" value="" readonly="readonly"  />
						<input type="hidden" name="A_CardNumber4" id="A_CardNumber4" value="" readonly="readonly"  />

						<input type="hidden" name="cardCheck" value="F" readonly="readonly" />
						<input type="hidden" name="chkA_Card_Dongle" id="chkA_Card_Dongle" value="" readonly="readonly" />
						<input type="hidden" name="chkA_Card_DongleIDX" id="chkA_Card_DongleIDX" value="" readonly="readonly" />
					</td>
				</tr>
			<%End If%>
			</tbody>
		</table>

		<p class="titles"><%=LNG_AUTOSHIP_REG_INFO_01%></p><%'정기결제 정보%>
		<table <%=tableatt%> class="innerTable3 table3">
			<col width="160" />
			<col width="*" />
			<tbody>
				<tr>
					<th><%=LNG_AUTOSHIP_REG_INFO_02%>&nbsp;<%=starText%></th>
					<td>
						<input type="hidden" id="TODAY" name="TODAY" value="<%=Date()%>" readonly="readonly" />
						<input type="text" id="A_Start_Date" name="A_Start_Date" class="input_text tweight datepicker" style="width: 100px;" value="" readonly="readonly" /> <%=LNG_AUTOSHIP_REG_INFO_08%> &nbsp;&nbsp;&nbsp;<%=AUTOSHIP_PAYABLE_DAYS_TEXT%>
					</td>
				</tr><tr>
					<th><%=LNG_AUTOSHIP_REG_INFO_03%></th>
					<td>
						<span id="A_Month_Date" class="tweight">00</span> <%=LNG_TEXT_DAY%>
					</td>
				</tr><tr>
					<th><%=LNG_AUTOSHIP_REG_INFO_04%>&nbsp;<%=starText%></th>
					<td>
						<select name="A_AutoCnt" class="vmiddle input_text">
							<option value=""><%=LNG_TEXT_SELECT%> ::::::</option>
							<option value="1"><%=LNG_AUTOSHIP_REG_INFO_05%></option>
							<option value="2"><%=LNG_AUTOSHIP_REG_INFO_06%></option>
							<option value="3"><%=LNG_AUTOSHIP_REG_INFO_07%></option>
						</select>
					</td>
				</tr>
				<!-- <tr>
					<th>비고</th>
					<td><input type="text" class="input_text" name="A_ETC"  style="width:95%;" value="" /></td>
				</tr> -->
			</tbody>
		</table>

		<p class="titles"><%=LNG_AUTOSHIP_REG_PRODUCT_01%></p><%'정기결제 상품등록%>
		<table <%=tableatt%> class="innerTable table4">
			<col width="50" />
			<col width="280" />
			<col width="140" />
			<col width="140" />
			<col width="140" />
			<col width="140" />
			<col width="140" />
			<thead>
			<tr>
				<th><%=LNG_TEXT_ITEM_NUMBER%>&nbsp;<%=starText%></th>
				<th><%=LNG_TEXT_ITEM_NAME%>&nbsp;<%=starText%></th>
				<th><%=LNG_TEXT_CSGOODS_CODE%></th>
				<th><%=LNG_TEXT_MEMBER_PRICE%></th>
				<th><%=CS_PV%></th>
				<th><%=CS_PV2%></th>
				<th>&nbsp;</th>
			</tr>
			</thead>
			<tbody>
			<tr>
				<td>
					<input type="text" name="regItemCount" id="regItemCount" class="input_text vmiddle tcenter regItemCount" value="1" maxlength="2" <%=onlyKeys%> />
				</td>
				<td>
					<select name="regItemCode" id="regItemCode" class="input_text" onchange="insertThisValue3(this, parentNode.parentNode.rowIndex);">
						<option value=""  thisattr="">::: <%=LNG_AUTOSHIP_REG_PRODUCT_02%> :::</option>
						<%
							MY_CMS_REG_PROC = "HJP_CSGOODS_PRICE_INFO_MY_CMS_REG"

							arrList = Db.execRsList(MY_CMS_REG_PROC,DB_PROC,Nothing,listLen,DB3)
							If IsArray(arrList) Then
								For i = 0 To listLen
									arrList_ncode	= arrList(0,i)
									arrList_name	= arrList(1,i)
									arrList_price2	= arrList(2,i)
									arrList_price4	= arrList(3,i)
									arrList_SellCode= arrList(4,i)
									arrList_price5	= arrList(5,i)	'bv

									PRINT TABS(5)& "	<option value="""&arrList_ncode&""" thisattr="""&arrList_price2&""" thisattr2="""&arrList_ncode&""" thisattr3="""&arrList_price4&""" thisattr4="""&arrList_SellCode&"""  thisattr5="""&arrList_price5&""" >"&arrList_name&"  ("&num2cur(arrList_price2)&" 원)</option>"
								Next
							Else
								PRINT TABS(5)& "	<option value="""">상품이 존재하지 않습니다.</option>"
							End If
						%>
					</select>
				</td>
				<td class=""><span id="thisNcode"><%=LNG_TEXT_CSGOODS_CODE%></span></td>
				<td class="inPrice price"><span id="thisPrice">0</span><span class="pUnit"><%=Chg_CurrencyISO%></span></td>
				<td class="inPrice pv"><span id="thisPV">0</span><span class="pv"><%=CS_PV%></td>
				<td class="inPrice bv"><span id="thisBV">0</span><span class="bv"><%=CS_PV2%></td>
				<td>
					<button type="button" class="input_submit design4" onclick="delAddTable(parentNode.parentNode.rowIndex);"><i class="fas fa-trash-alt"></i>&nbsp;<%=LNG_BTN_DELETE%></button>
					<!-- <span class="button medium vmiddle icon"><span class="delete"></span><a href="javascript:void(0);" onclick="delAddTable(parentNode.parentNode.parentNode.rowIndex);"><%=LNG_BTN_DELETE%></a></span> -->
				</td>
			</tr>
			</tbody>
			<tfoot>
			<tr>
				<td colspan="3" class="total"><%=LNG_TEXT_TOTAL%></td>
				<td class="total price"><span id="totalPrice">0</span><span class="pUnit"><%=Chg_CurrencyISO%></span></td>
				<td class="total pv"><span id="totalPV">0</span><span class="pv"><%=CS_PV%></td>
				<td class="total bv"><span id="totalBV">0</span><span class="bv"><%=CS_PV2%></td>
				<td class="total tcenter">
					<button type="button" class="input_submit design1" onclick="javascript:addThis();"><i class="fas fa-plus"></i>&nbsp;<%=LNG_AUTOSHIP_REG_PRODUCT_03%></button>
					<!-- <span class="button medium vmiddle icon"><span class="add"></span><a onclick="javascript:addThis();"><%=LNG_AUTOSHIP_REG_PRODUCT_03%></a></span> -->
				</td>
			</tr>
			</tfoot>
		</table>
		<div class="btnZone tcenter">
			<span class=""><input type="button" class="a_submit design1 blue" style="width:140px;" value="<%=LNG_AUTOSHIP_REG_PRODUCT_04%>" onclick="fnSubmitReg();" /></span>
		</div>
		<!-- <div class="tweight tcenter red2" style="width:948px;margin 20px 0px;border:1px solid #ccc;background:#fbfce4;line-height:18px;font-size:16px;">
			<div style="margin:0 auto;padding:20px;"><p>※ <%=LNG_AUTOSHIP_REG_PRODUCT_05%></p><br /><p> <%=LNG_AUTOSHIP_REG_PRODUCT_06%></p></div>
		</div> -->
	</form>
</div>
<div style="display:none;">
	<table id="cloneTable">
		<tr class="cloneTr">
			<td>
				<input type="text" name="regItemCount" class="input_text vmiddle tcenter regItemCount" value="1" maxlength="2" <%=onlyKeys%> />
			</td>
			<td>
				<select name="regItemCode" id="regItemCode" class="input_text" onchange="insertThisValue3(this, parentNode.parentNode.rowIndex);">
					<option value=""  thisattr="">::: <%=LNG_AUTOSHIP_REG_PRODUCT_02%> :::</option>
					<%
						MY_CMS_REG_PROC = "HJP_CSGOODS_PRICE_INFO_MY_CMS_REG"

						arrList = Db.execRsList(MY_CMS_REG_PROC,DB_PROC,Nothing,listLen,DB3)
						If IsArray(arrList) Then
							For i = 0 To listLen
								arrList_ncode	= arrList(0,i)
								arrList_name	= arrList(1,i)
								arrList_price2	= arrList(2,i)
								arrList_price4	= arrList(3,i)
								arrList_SellCode= arrList(4,i)
								arrList_price5	= arrList(5,i)	'bv

								PRINT TABS(5)& "	<option value="""&arrList_ncode&""" thisattr="""&arrList_price2&""" thisattr2="""&arrList_ncode&""" thisattr3="""&arrList_price4&""" thisattr4="""&arrList_SellCode&"""  thisattr5="""&arrList_price5&""">"&arrList_name&"  ("&num2cur(arrList_price2)&" 원)</option>"

							Next
						Else
							PRINT TABS(5)& "	<option value="""">"&LNG_AUTOSHIP_REG_PRODUCT_NOT&"</option>"
						End If
					%>
				</select>
			</td>
			<td><span id="thisNcode"><%=LNG_TEXT_CSGOODS_CODE%></span></td>
			<td class="inPrice price"><span id="thisPrice">0</span><span class="pUnit"><%=Chg_CurrencyISO%></span></td>
			<td class="inPrice pv"><span id="thisPV">0</span> <span class="pv"><%=CS_PV%></td>
			<td class="inPrice bv"><span id="thisBV">0</span> <span class="bv"><%=CS_PV2%></td>
			<td>
				<button type="button" class="input_submit design4" onclick="delAddTable(parentNode.parentNode.rowIndex);"><i class="fas fa-trash-alt"></i>&nbsp;<%=LNG_BTN_DELETE%></button>
				<!-- <span class="button medium vmiddle icon"><span class="delete"></span><a href="javascript:void(0);" onclick="delAddTable(parentNode.parentNode.parentNode.rowIndex);"><%=LNG_BTN_DELETE%></a></span> -->
			</td>
		</tr>
	</table>
</div>
<%
	MODAL_BORDER_THICKNESS = 1
%>
<!--#include virtual="/_include/modal_config.asp" -->
</div>
<!--#include virtual = "/_include/copyright.asp"-->