<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	PAGE_SETTING = "MYOFFICE"
	INFO_MODE	 = "ORDER1-1"

	ISLEFT = "T"
	ISSUBTOP = "T"
	OVERFLOW_VISIBLE = "F"

	Call ONLY_CS_MEMBER()

'	Call MEMBER_AUTH_CHECK(nowGradeCnt,3)


	'���ǽŰ���� �ֹ���ȣ��������üũ
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

'	If RS_CPNO = "" Then Call alerts("�ֹι�ȣ�� �Էµ��� �ʾҽ��ϴ�(����ó���Ұ�).\n\n���翡 �������ּ���.","back","")


	inUidx = Trim(pRequestTF("nCode",True))

	If inUidx = "" Then Call ALERTS("�ֹ��� ��ǰ�� ��ȣ�� �����ϴ�.���ΰ�ħ �� �ٽ� �õ����ּ���.","go","cart.asp")

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

	If OUTPUT_VALUE = "ERROR" Then Call ALERTS("�ӽ��ֹ����� ������ ������ �߻��Ͽ����ϴ�","back","")

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
'�Ϲ�						http://plugin.inicis.com/pay61_secuni_cross.js
'OpenSSL���				https://plugin.inicis.com/pay61_secunissl_cross.js
'UNI �ڵ��� 				http://plugin.inicis.com/pay61_secuni_cross.js
'OpenSSL, UNI �ڵ� ��� 	https://plugin.inicis.com/pay61_secunissl_cross.js
%>
<script type="text/javascript" src="/jscript/calendar.js"></script>

</head>
<body onload="javascript:enable_click()" onFocus="javascript:focus_control()">

<!--#include virtual = "/_include/header.asp"-->
<div id="cart" class="orderList">
	<form name="ini" method="post" autocomplete="off" action="/PG2/INICIS/INIsecureresult.asp" onSubmit="return pay(this)">
		<input type="hidden" name="cuidx" value="<%=inUidx%>" />
		<p class="titles">�ֹ���ǰ</p>
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
					<th>��ǰ�ڵ�</th>
					<th>��ǰ��</th>
					<th>ȸ����</th>
					<th>PV</th>
					<th>����</th>
					<th>�� PV</th>
					<th>�� �ݾ�</th>
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
						Call alerts("�ֹ��� ��ǰ �� �ǸŰ� �����Ǿ��ų� �����Ǵ� ���� ������ �߻��Ͽ����ϴ�.\n\n���ΰ�ħ �� �ٽ� �õ����ּ���.","back","")
					End If
					Call closeRs(DKRSS)

					'��ǰ�� ���泻�� üũ
					arrParams = Array(_
						Db.makeParam("@ncode",adVarChar,adParamInput,20,RS_ncode) _
					)
					Set DKRS = Db.execRs("DKP_GOODS_CHANGE",DB_PROC,arrParams,DB3)
					If Not DKRS.BOF And Not DKRS.EOF Then
						RS_ncode		= DKRS("ncode")
						RS_price2		= DKRS("price2")	'ȸ����
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
					PRINT tabs(1)&"		<td class=""inPrice"">"&num2cur(RS_Price2)&" ��</td>"
					PRINT tabs(1)&"		<td class=""inPrice Price"">"&num2cur(RS_Price4)&" PV </td>"
					PRINT tabs(1)&"		<td class=""inPrice"">"&RS_ea&" ��</td>"
					PRINT tabs(1)&"		<td class=""inPrice Price"">"&num2cur(SELF_PV)&" PV</td>"
					PRINT tabs(1)&"		<td class=""inPrice Price"">"&num2cur(SELF_PRICE)&" ��</td>"
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
						Call ALERTS("�ֹ� �ӽ� ���� �� ������ �߻��Ͽ����ϴ�.���ΰ�ħ �� �ٽ� �õ����ּ���.","BACK","")
						Exit For
					End If

				Next
			%>
			</tbody>
			<tfoot>
				<tr>
					<td colspan="6" class="tweight tright bg2 pR4">���� �� PV</td>
					<td class="inPrice tPrice"><%=num2cur(TOTAL_PV)%> PV</td>
				</tr><tr>
					<td colspan="6" class="tweight tright bg2 pR4">���� �� �ݾ�</td>
					<td class="inPrice tPrice"><%=num2cur(TOTAL_PRICE)%> ��</td>
				</tr>

				<%
					If TOTAL_PRICE < 50000 Then
						DELIVERY_PRICE = 0'2500
						DELIVERY_TXT = "�� 5���� ���� ���ŷ� ��۷ᰡ �ΰ��˴ϴ�."
					Else
						DELIVERY_PRICE = 0
						DELIVERY_TXT = "�� 5���� �̻� ���ŷ� ������ó�� �˴ϴ�."
					End If

					LAST_PRICE = TOTAL_PRICE + DELIVERY_PRICE
				%>

				<tr>
					<td colspan="6" class="tweight tright bg2"><%=DELIVERY_TXT%></td>
					<td class="inPrice tPrice"><%=num2cur(DELIVERY_PRICE)%> ��</td>
				</tr>
				<tr>
					<td colspan="6" class="tweight tright bg2 pR4">���� ���� �ݾ�</td>
					<td class="inPrice tPrice"><%=num2cur(LAST_PRICE)%> ��</td>
				</tr>
			</tfoot>
		</table>

		<p class="titles">���(�ֹ���)����</p>
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
				Sell_Mem_TF		= DKRS("Sell_Mem_TF")	'�Ǹſ�0, �Һ���1

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

				If RS_WebID = "" Then RS_WebID = "�����̵� �̵�� ����"

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
				Call ALERTS("ȸ�������� �ε���� ���߽��ϴ�.","back","")
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
					<th>�̸�(������) <%=starText%></th>
					<td><input type="text" class="input_text" name="strName" style="width:200px;" value="<%=RS_M_Name%>" /></td>
				</tr><tr class="line">
					<th>�ּ� <%=starText%></th>
					<td>
						<input type="text" class="input_text" name="strZip" style="width:80px;background-color:#f4f4f4;" readonly="readonly" value="<%=cutZip(RS_addcode1)%>" />
						<img src="<%=IMG_MYPAGE%>/zip_search.gif" width="68" height="20" alt="�ּ� ã��" class="vmiddle cp" onclick="openzip('ini');" />
						<input type="text" class="input_text" name="strAddr1" style="width:390px;background-color:#f4f4f4;" readonly="readonly" value="<%=RS_Address1%>" />
					</td>
				</tr><tr>
					<th>���ּ� <%=starText%></th>
					<td><input type="text" class="input_text" name="strAddr2" style="width:550px;" value="<%=RS_Address2%>" /></td>
				</tr><tr>
					<th>�̸����ּ� <%=starText%></th>
					<td>
						<input type="text" class="input_text imes" name="strEmail" style="width:350px;" value="<%=RS_Email%>" /><br /><br />
						<span class="summary">* PG�� ��å���� ���� �ݵ�� �ʿ��� �����Դϴ�. ��Ȯ�� �������ּ���.</span>
					</td>
				</tr><tr>
					<th>�޴�����ȣ <%=starText%></th>
					<td>
						<select name="mob_num1" style="width:55px;" class="vmiddle">
							<option value=""		<%=isSelect(arrMob(0),"")%>>����</option>
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
						<span class="summary">* ��󿬶� �� �ݵ�� �ʿ��� �����Դϴ�. ��Ȯ�� �������ּ���.</span>
					</td>
				</tr><tr>
					<th>��ȭ��ȣ</th>
					<td>
						<select name="tel_num1" style="width:55px;" class="vmiddle">
							<option value=""		<%=isSelect(arrTEL(0),"")%>>����</option>
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

		<p class="titles">��Ÿ����</p>
		<table <%=tableatt%> class="userCWidth">
			<col width="140" />
			<col width="620" />
			<tr>
				<th>��������</th>
				<td style="padding-left:5px;">
					<select name="v_SellCode">
						<!-- <option value="">������������</option> -->
						<%
							arrListB = Db.execRsList("DKP_SELLTYPE_LIST",DB_PROC,Nothing,listLenB,DB3)
							If IsArray(arrListB) Then
								For i = 0 To listLenB
									PRINT TABS(4)&"	<option value="""&arrListB(0,i)&""">"&arrListB(1,i)&"</option>"
								Next
							Else
								PRINT TABS(4)&"	<option value="""">��ϵ� ���������� �����ϴ�.</option>"
							End If
						'	If Sell_Mem_TF = 0 Then
						'		PRINT TABS(4)&"	<option value=""01"">�Ϲݸ���</option>"
						'	ElseIf Sell_Mem_TF = 1 Then
						'		PRINT TABS(4)&"	<option value=""02"">�Һ��ڸ���</option>"
						'	Else
						'		PRINT TABS(4)&"	<option value="""">��ϵ� ���������� �����ϴ�.</option>"
						'	End If
						%>
					</select>

				</td>
			</tr>
		</table>

		<p class="titles">�������</p>
		<table <%=tableatt%> class="userCWidth">
			<col width="140" />
			<col width="400" />
			<col width="220" />
			<tr>
				<th>�������Ա�</th>
				<td style="padding-left:5px;"><label><input type="radio" name="payKind" value="inBank" class="input_chk" onclick="payKindSelect(this.value)" />�������Ա� ���</label></td>
				<td style="padding-left:5px;">�������Ա����� �����մϴ�.</td>
			</tr><tr id="inBankInfo" style="display:none;">
				<td colspan="3" style="padding-left:20px;">&#8226; �Ա����� :
					<select name="C_codeName" style="margin-left:5px;">
						<option value="">�Ա����༱��</option>
						<%
							arrListB = Db.execRsList("DKP_BANK_LIST2",DB_PROC,Nothing,listLenB,DB3)
							If IsArray(arrListB) Then
								For i = 0 To listLenB
									PRINT TABS(4)&"	<option value="""&arrListB(0,i)&","&arrListB(1,i)&","&arrListB(2,i)&","&arrListB(3,i)&""">["&arrListB(1,i)&"] "&arrListB(3,i)&" - "&arrListB(2,i)&"</option>"
								Next
							Else
								PRINT TABS(4)&"	<option value="""">��ϵ� ȸ����°� �����ϴ�.</option>"
							End If
						%>
					</select><br /><br />
					<span>&#8226; �Ա��ڸ� : </span><input type="text" name="C_NAME2" class="input_text"/><span style="margin-left:50px;">&#8226; �Աݿ����� : </span><input type='text' name='memo1' value="" class='input_text readonly' onclick="openCalendar(event, this, 'YYYY-MM-DD');" readonly="readonly">
				</td>
			</tr><!-- <tr>
				<th>���ݰ���</th>
				<td style="padding-left:5px;"><label><input type="radio" name="payKind" value="inCash" class="input_chk" onclick="payKindSelect(this.value)" />���ݰ��� ���</label></td>
				<td style="padding-left:5px;">���忡�� �������� �����մϴ�.</td>
			</tr> --><tr>
				<th>ī�����</th>
				<td style="padding-left:5px;"><label><input type="radio" name="payKind" value="Card" class="input_chk" onclick="payKindSelect(this.value)" />ī����� ���(�̴Ͻý��׽�Ʈ)</label></td>
				<td style="padding-left:5px;">�ſ�ī��� �����մϴ�.</td>
			</tr><!-- <tr>
				<th>�ǽð�������ü</th>
				<td style="padding-left:5px;"><label><input type="radio" name="payKind" value="DirectBank" class="input_chk" onclick="payKindSelect(this.value)" />�ǽð�������ü</label></td>
				<td style="padding-left:5px;">�ǽð� ������ü�� �����մϴ�.</td>
			</tr><tr>
				<th>�������(�������Ա�)</th>
				<td style="padding-left:5px;"><label><input type="radio" name="payKind" value="VBank" class="input_chk" onclick="payKindSelect(this.value)" />�������(�������Ա�)</label></td>
				<td style="padding-left:5px;">������·� �����մϴ�.</td>
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
	'���� ������ ���� ó�� => �߿� ���� ��ȣȭ �۾� .
	'�÷����� ȣ�� �κ� ����.
	'�ڵ忡 ���� �ڼ��� ������ �Ŵ����� �����Ͻʽÿ�.
	'<����> �������� ������ �ݵ�� üũ�ϵ����Ͽ� �����ŷ��� �����Ͽ� �ֽʽÿ�.
	'http://www.inicis.com
	'Copyright (C) 2007 Inicis, Co. All rights reserved.
	'*******************************************************************************

	'###############################################################################
	'# 1. ���� ������ �� ������ üũ�� �ؾ���  �߿� �ʵ� #
	'#######################################################
	'#		�������̵� : MerID
	'#		����   �ݾ� : Price
	'#		�������Һ� : Nointerest
	'#			�����ڷ� �Һ� ���� ����(yes), �������� ����(no)
	'#			�������Һδ� ���� ����� �ʿ��մϴ�.
	'#			ī��纰,�Һΰ������� �������Һ� ������ �Ʒ��� ī���ҺαⰣ�� ���� �Ͻʽÿ�.
	'#			�������Һ� �ɼ� ������ �ݵ�� �Ŵ����� �����Ͽ� �ֽʽÿ�.
	'#		ī���ҺαⰣ : Quotabase
	'#			�� ī��纰�� �����ϴ� �������� �ٸ��Ƿ� �����Ͻñ� �ٶ��ϴ�.
	'#			value�� ������ �κп� ī����ڵ�� �ҺαⰣ�� �Է��ϸ� �ش� ī����� �ش�
	'#			�Һΰ����� �������Һη� ó���˴ϴ� (�Ŵ��� ����).
	'#######################################################


	'###############################################################################
	'# 1. ��ü ���� #
	'################

	Set INIpay = Server.CreateObject("INItx50.INItx50.1")

	'###############################################################################
	'# 2. �ν��Ͻ� �ʱ�ȭ #
	'######################
	PInst = INIpay.Initialize("")

	'###############################################################################
	'# 3. üũ ���� ���� #
	'#####################
	INIpay.SetActionType CLng(PInst), "chkfake"

	'###############################################################################
	'# 5. ��ȣȭ ó�� �ʵ� ����        #
	'###################################

	Session("INI_MID") = PGIDS
	Session("INI_PRICE") = LAST_PRICE '���� �ݾ� =>  ���� ó�� ���������� üũ �ϱ� ���� ���ǿ� ���� (�Ǵ� DB�� ����)�Ͽ� ���� ���� ó�� ������ ���� üũ)
	'��ǰ�� �Ѿ��� �˱� ���� �ϴ����� �̵� ��ġ
	Session("INI_ADMIN") = PGPASSKEY '����Ű �н����� =>  ���� ó�� ���������� üũ �ϱ� ���� ���ǿ� ���� (�Ǵ� DB�� ����)�Ͽ� ���� ���� ó�� ������ ���� üũ)

	INIpay.SetField CLng(PInst), "mid", Session("INI_MID")			'�������̵�
	INIpay.SetField CLng(PInst), "price",  Session("INI_PRICE")		'���� �ݾ�
	INIpay.SetField CLng(PInst), "nointerest", "no"  			'������ �Һ� ����
	INIpay.SetField CLng(PInst), "quotabase","lumpsum:00:02:03"   '�Һ� ���� �� ī��纰 ������ ����
	INIpay.SetField CLng(PInst), "currency", "WON"



	'**************************************************************************************************
	'* admin �� Ű�н����� �������Դϴ�. �����Ͻø� �ȵ˴ϴ�. ���� ���� "INI_ADMIN" �� 1111�� �κи� �����ؼ� ����Ͻñ� �ٶ��ϴ�.
	'* Ű�н������ ���������� ������(https://iniweb.inicis.com)�� ��й�ȣ�� �ƴմϴ�. ������ �ֽñ� �ٶ��ϴ�.
	'* Ű�н������ ���� 4�ڸ��θ� �����˴ϴ�. �� ���� Ű���� �߱޽� �����˴ϴ�.
	'* Ű�н����� ���� Ȯ���Ͻ÷��� �������� �߱޵� Ű���� ���� readme.txt ������ ������ �ֽʽÿ�.
	'**************************************************************************************************
	INIpay.SetField CLng(PInst), "admin", Session("INI_ADMIN") '����Ű �н�����


	INIpay.SetField CLng(PInst), "debug", "true" '�α׸��("true"�� �����ϸ� ���� �α׸� ����)
	'###############################################################################
	'# 5. üũ ó���� ���� ��ȣȭ ó�� #
	'###################################
	INIpay.StartAction(CLng(PInst))

	'###############################################################################
	'6. ��ȣȭ  ��� #
	'###############################################################################
	resultcode = INIpay.GetResult(CLng(PInst), "resultcode")
	resultmsg = INIpay.GetResult(CLng(PInst), "resultmsg")
	rn_value = INIpay.GetResult(CLng(PInst), "rn")		'���� ���������� üũ�� RN��
	return_enc = INIpay.GetResult(CLng(PInst), "return_enc")	'�ش� �ʵ尪�� ��ȣȭ�� ��� ��
	ini_certid = INIpay.GetResult(CLng(PInst), "ini_certid")		'���� ����Ű ��
	'###############################################################################
	'7. RN �� ���ǿ� ���� #
	'###############################################################################
	Session("INI_RN") = rn_value  	'RN�� => ���� ó�� ���������� üũ �ϱ� ���� ���ǿ� ���� (�Ǵ� DB�� ����)�Ͽ� ���� ���� ó�� ������ ���� üũ)

	'###############################################################################
	'# 8. �ν��Ͻ� ���� #
	'###############################################################################
	INIpay.Destroy CLng(PInst)

	'###############################################################################
	'# 9. ���� ������ ���� ���� ������ ���� ó��  #
	'###############################################################################
	IF resultcode <> "00" Then
		Call ALERTS(resultmsg&" - �����ڿ��� ������ �ּ���.","go","cart.asp")
		'���� ó�� =>  ���� ������ ���� ���п� ���� ó�� ���� ���� (�� : ����Ű ������ ���� ���� ���� ó�� �Ǹ� �ش� resultmsg�� Ȯ���Ͽ� ���� �����ڰ� �ش� ���� ó�� �ʿ�)

		response.write " ���� ������ ������ ���� �߻�<BR>"
		response.write "���� ���� : "&  	resultmsg
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

	<!-- ��Ÿ���� -->
	<!--
	SKIN : �÷����� ��Ų Į�� ���� ��� - 5���� Į��(ORIGINAL/BLUE�� ��1, GREEN, ORANGE, BLUE, KAKKI, GRAY)
	HPP : ������ �Ǵ� �ǹ� ���� ���ο� ���� HPP(1)�� HPP(2)�� ���� ����(HPP(1):������, HPP(2):�ǹ�)
	Card(0): �ſ�ī�� ���ҽÿ� �̴Ͻý� ��ǥ �������� ��쿡 �ʼ������� ���� �ʿ� ( ��ü �������� ��쿡�� ī����� ��࿡ ���� ����) - �ڼ��� ������ �޴���  ����
	OCB : OK CASH BAG ���������� �ſ�ī�� �����ÿ� OK CASH BAG ������ �����Ͻñ� ���Ͻø� "OCB" ���� �ʿ� �� �ܿ� ��쿡�� �����ؾ� �������� ���� �̷����
	-->
	<input type="hidden" name="acceptmethod" value="SKIN(ORIGINAL):HPP(1)" />

	<!--
	���� �ֹ���ȣ
	�������Ա� ����(������� ��ü),��ȭ����(1588 Bill) ���� �ʼ��ʵ�� �ݵ�� ������ �ֹ���ȣ�� �������� �߰��ؾ� �մϴ�.
	�������� �߿� �ǽð� ������ü �̿� �ÿ��� �ֹ� ��ȣ�� ��������� ��ȸ�ϴ� ���� �ʵ尡 �˴ϴ�.
	���� �ֹ���ȣ�� �ִ� 40 BYTE �����Դϴ�.
	-->
	<input type="hidden" name="oid" size="40" value="<%=orderNum%>" />
	<input type="hidden" name="INIregno" size="40" value="" />

	<!--
	�÷����� ���� ��� ���� �ΰ� �̹��� ���
	�÷����� ���� ��ܿ� ���� �ΰ� �̹����� ����Ͻ� �� ������,
	�ּ��� Ǯ�� �̹����� �ִ� URL�� �Է��Ͻø� �÷����� ��� �κп� ���� �̹����� �����Ҽ� �ֽ��ϴ�.
	-->
	<!--input type=hidden name=ini_logoimage_url  value="http://[����� �̹����ּ�]"-->

	<!--
	���� �����޴� ��ġ�� �̹��� �߰�
	���� �����޴� ��ġ�� �̹����� �߰��Ͻ� ���ؼ��� ��� ������ǥ���� ��뿩�� ����� �Ͻ� ��
	�ּ��� Ǯ�� �̹����� �ִ� URL�� �Է��Ͻø� �÷����� ���� �����޴� �κп� �̹����� �����Ҽ� �ֽ��ϴ�.
	-->
	<!--input type=hidden name=ini_menuarea_url value="http://[����� �̹����ּ�]"-->

	<!--
	�÷����ο� ���ؼ� ���� ä�����ų�, �÷������� �����ϴ� �ʵ��
	����/���� �Ұ�
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
		Case "ERROR" : Call ALERTS("��ǰ ���� ������Ʈ �� ������ �߻��Ͽ����ϴ�.","BACK","")
		Case "NOTORDER" : Call ALERTS("�ֹ���ȣ�� �����ϴ�.","BACK","")
	End Select
%>
<!--#include virtual = "/_include/copyright.asp"-->
