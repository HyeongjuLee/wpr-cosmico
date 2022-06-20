<!--#include virtual = "/_lib/strFunc.asp"-->
<!--#include virtual = "/_include/document.asp"-->
<%
	pT = gRequestTF("pt",False)
	If pt = "" Then pt = ""

	If pT = "shop" Then
		PAGE_SETTING = "SHOP_MYPAGE"
		ptshop = "?pt=shop"
	Else
		PAGE_SETTING = "MYPAGE"
		ptshop = ""
	End If


	ISLEFT = "T"
	ISSUBTOP = "T"
	ISSUBVISUAL = "T"
	view = 2

	If DK_MEMBER_STYPE <> 1 Then Call ALERTS(LNG_ALERT_WRONG_ACCESS,"back","")		'스피나 소비자 구매내역

	Call ONLY_BUSINESS_MEMBER(DK_MEMBER_LEVEL,2)
	Call FN_NationCurrency(DK_MEMBER_NATIONCODE,Chg_CurrencyName,Chg_CurrencyISO)

	If isMACCO = "T" Then Response.Redirect "order_list_macco.asp"

	SDATE = pRequestTF("SDATE",False)
	EDATE = pRequestTF("EDATE",False)

	PAGE = pRequestTF("PAGE",False)
	PAGESIZE = 15
	If PAGE = "" Then PAGE = 1

	ThisM_1stDate = Left(Date(),8)&"01"				'이번달 1일

%>
<link rel="stylesheet" href="/myoffice/css/style_cs.css" />
<link rel="stylesheet" href="/myoffice/css/layout_cs.css" />
<style type="text/css">
   .btn01 {display:inline-block;border:1px solid #848484; width:55px;height:15px; padding:2px 0px 2px 0px;-webkit-border-radius:4px;-moz-border-radius:4px;border-radius:4px;}
   .fon1 {font-family:malgun gothic,dotum,gulim;font-size:9pt;font-weight:bold;color:#0057d3;text-align:center;}
   a:hover{color:blue;}
</style>
<script type="text/javascript" src="/jscript/calendar.js"></script>
</head>
<body>
<!--#include virtual = "/_include/header.asp"-->
<div id="buy" class="orderList">
	<form name="dateFrm" action="order_list_s.asp" method="post">
		<table <%=tableatt%> class="userCWidth table1">
			<col width="200" />
			<col width="*" />
			<tr>
				<th rowspan="2"><%=LNG_TEXT_DATE_SEARCH%></th>
				<td>
					<span class="button medium icon"><span class="calendar"></span><button type="button" onclick="chgDate('<%=DateAdd("m",-1,ThisM_1stDate)%>','<%=DateAdd("d",-1,ThisM_1stDate)%>');"><%=LNG_TEXT_LASTMONTH%></button></span>
					<span class="button medium icon"><span class="calendar"></span><button type="button" onclick="chgDate('<%=ThisM_1stDate%>','<%=nowDate%>');"><%=LNG_TEXT_THISMONTH%></button></span>
					<span class="button medium icon"><span class="calendar"></span><button type="button" onclick="chgDate('<%=DateAdd("m",-3,nowDate)%>','<%=nowDate%>');"><%=LNG_TEXT_3MONTH%></button></span>
					<span class="button medium icon"><span class="calendar"></span><button type="button" onclick="chgDate('<%=nowDate%>','<%=nowDate%>');"><%=LNG_TEXT_TODAY%></button></span>
					<span class="button medium icon"><span class="calendar"></span><button type="button" onclick="chgDate('<%=DateAdd("m",-6,nowDate)%>','<%=nowDate%>');"><%=LNG_TEXT_6MONTH%></button></span>
					<span class="button medium icon"><span class="calendar"></span><button type="button" onclick="chgDate('<%=DateAdd("yyyy",-1,nowDate)%>','<%=nowDate%>');"><%=LNG_TEXT_1YEAR%></button></span>
					<span class="button medium icon"><span class="calendar"></span><button type="button" onclick="chgDate('','');"><%=LNG_TEXT_ALL%></button></span>
					<!-- <span class="button medium icon"><span class="calendar"></span><button type="button" onclick="chgDate('<%=DateAdd("m",-1,nowDate)%>','<%=nowDate%>');">1개월</button></span>
					<span class="button medium icon"><span class="calendar"></span><button type="button" onclick="chgDate('<%=DateAdd("d",-7,nowDate)%>','<%=nowDate%>');">1주일</button></span> -->
				</td>
			</tr><tr>
				<td>
					<input type="text" id="SDATE" name="SDATE" class="input_text tcenter tweight" style="width:140px;" value="<%=SDATE%>" readonly="readonly" onclick="openCalendar(event, this, 'YYYY-MM-DD');" /> ~
					<input type="text" id="EDATE" name="EDATE" class="input_text tcenter tweight" style="width:140px;" value="<%=EDATE%>" readonly="readonly" onclick="openCalendar(event, this, 'YYYY-MM-DD');" />
					<input type="submit" class="txtBtn small2 radius3" value="<%=LNG_TEXT_SEARCH%>"/>
					<!-- <input type="image" src="<%=IMG_BTN%>/g_list_search.gif" style="width:43px; height:19px; vertical-align:middle;" />
					<span class="button medium"><button type="submit">검색</button></span>
					<span class="button medium vmiddle"><span class="refresh"></span><a href="order_list_s.asp">초기화</a> -->
				</td>
			</tr>
		</table>
	</form>
	<p class="titles"><%=LNG_TEXT_LIST%></p>
	<table <%=tableatt%> class="userCWidth table2" style="border-bottom:1px solid #cdcdcd;"><!-- 820 -->
		<col width="60" />
		<col width="85" />
		<col width="160" />
		<col width="110" />
		<col width="110" />
		<col width="110" />
		<col width="110" />
		<!-- <col width="90" />
		<col width="70" /> -->
		<col width="75" />
		<tr>
			<th><%=LNG_TEXT_NUMBER%></th>
			<th><%=LNG_TEXT_ORDER_DATE%></th>
			<th><%=LNG_TEXT_ORDER_NUMBER%></th>
			<!-- <th><%=LNG_TEXT_NAME%></th> -->
			<th><%=LNG_TEXT_ORDER_AMOUNT%></th>
			<th><%=LNG_TEXT_ORDER_CARD%></th>
			<th><%=LNG_TEXT_ORDER_BANK%></th>
			<th><%=LNG_TEXT_ORDER_CASH%></th>
			<!-- <th><%=SHOP_POINT%></th> -->
			<!-- <th><%=CS_PV%> . <%=CS_WP%></th>
			<th><%=LNG_TEXT_SALES_TYPE%></th> -->
			<th><%=LNG_TEXT_ORDER_APPROVAL_TF%></th>
		</tr>
		<%
			arrParams = Array(_
				Db.makeParam("@mbid1",adVarChar,adParamInput,20,DK_MEMBER_ID1), _
				Db.makeParam("@mbid2",adInteger,adParamInput,0,DK_MEMBER_ID2), _
				Db.makeParam("@SDATE",adVarChar,adParamInput,10,SDATE), _
				Db.makeParam("@EDATE",adVarChar,adParamInput,10,EDATE), _
				Db.makeParam("@PAGE",adInteger,adParamInput,0,PAGE), _
				Db.makeParam("@PAGESIZE",adInteger,adParamInput,0,PAGESIZE), _
				Db.makeParam("@ALL_Count",adInteger,adParamOutput,0,0) _
			)
			arrList =  Db.execRsList("DKP_ORDER_LIST2",DB_PROC,arrParams,listLen,DB3)
			All_Count = arrParams(UBound(arrParams))(4)
			Dim PAGECOUNT,CNT
			PAGECOUNT = Int((CCur(All_Count) - 1 ) / CInt(PAGESIZE) ) + 1
			IF CCur(PAGE) = 1 Then
				CNT = All_Count
			Else
				CNT = All_Count - ((CCur(PAGE)-1)*CInt(PAGESIZE)) '
			End If
			If IsArray(arrList) Then
				For i = 0 To listLen
					ThisNum = ALL_COUNT - CInt(arrList(0,i)) + 1

					arrList_OrderNumber		= arrList(1,i)
					arrList_mbid			= arrList(2,i)
					arrList_mbid2			= arrList(3,i)
					arrList_M_Name			= arrList(4,i)
					arrList_SellDate		= arrList(5,i)
					arrList_SellTypeName	= arrList(6,i)
					arrList_InputCard		= arrList(7,i)
					arrList_InputPassbook	= arrList(8,i)
					arrList_InputCash		= arrList(9,i)
					arrList_TotalPrice		= arrList(10,i)
					arrList_TotalPV			= arrList(11,i)		'스피나 SV
					arrList_ReturnTF		= arrList(12,i)
					arrList_SellCode		= arrList(13,i)
					arrList_Approval		= arrList(14,i)
					arrList_InputMile		= arrList(15,i)
					arrList_Etc2			= arrList(16,i)
					arrList_TotalCV			= arrList(17,i)		'스피나 WP

					If arrList_Approval = 1 Then
						'arrList_Approval = "승인"
						arrList_Approval = LNG_TEXT_ORDER_APPROVAL	'"승인"
					Else
						'arrList_Approval = "미승인"
						arrList_Approval = LNG_TEXT_ORDER_DISAPPROVAL	'"미승인"
					End If

					arrList_WebOrderNumber = ""
					If arrList_Etc2 <> "" Then arrList_WebOrderNumber = Right(arrList_Etc2,14)


					PRINT TABS(1) & "	<tr onclick=""toggle_content('order"&i&"')"" class=""trh"">"
					PRINT TABS(1) & "		<td>"&ThisNum&"</td>"
					PRINT TABS(1) & "		<td>"&date8to10(arrList_SellDate)&"</td>"
					'PRINT TABS(1) & "		<td class="""">"&arrList_OrderNumber&"<br />"&arrList_WebOrderNumber&"</td>"
					PRINT TABS(1) & "		<td class="""">"&arrList_OrderNumber&"</td>"
					'PRINT TABS(1) & "		<td>"&arrList_M_Name&"</td>"
					PRINT TABS(1) & "		<td class=""inPrice"">"&num2cur(arrList_TotalPrice)&" "&Chg_CurrencyISO&"</td>"
					PRINT TABS(1) & "		<td class=""inPrice"">"&num2cur(arrList_inputCard)&" "&Chg_CurrencyISO&"</td>"
					PRINT TABS(1) & "		<td class=""inPrice"">"&num2cur(arrList_inputPassbooK)&" "&Chg_CurrencyISO&"</td>"
					PRINT TABS(1) & "		<td class=""inPrice"">"&num2cur(arrList_inputCash)&" "&Chg_CurrencyISO&"</td>"
					'PRINT TABS(1) & "		<td class=""inPrice"">"&num2cur(arrList_InputMile)&"</td>"
					'If arrList_SellCode = "01" Then
					'	PRINT TABS(1) & "		<td class=""inPrice"">"&num2cur(arrList_TotalPV)&" "&CS_PV&"</td>"
					'ElseIf arrList_SellCode = "02" Then
					'	PRINT TABS(1) & "		<td class=""inPrice"">"&num2cur(arrList_TotalCV)&" "&CS_WP&"</td>"
					'End If
					'PRINT TABS(1) & "		<td>"&arrList_SellTypeName&"</td>"
					PRINT TABS(1) & "		<td>"&arrList_Approval&"</td>"
					PRINT TABS(1) & "	</tr>"

					'▣결제상세내역
					arrParams2 = Array(_
						Db.makeParam("@orderNum",adVarChar,adParamInput,50,arrList_OrderNumber)_
					)
					arrList2 = Db.execRsList("DKP_ORDER_DETAIL_CACU",DB_PROC,arrParams2,listLen2,DB3)

					PRINT TABS(1) & "	<tr id=""order"&i&""" class=""bottomLine"" style=""display:none;"">"
					PRINT TABS(1) & "		<td colspan=""8"" class=""tcenter notpadding blines"">"
					If IsArray(arrList2) Then

						PRINT TABS(1) & "		<table "&tableatt&" class=""innerTable3"" style=""width:95%; margin:0px auto;"">"
						PRINT TABS(1) & "			<col width=""80"" />"
						PRINT TABS(1) & "			<col width=""110"" />"
						PRINT TABS(1) & "			<col width=""90"" />"
						PRINT TABS(1) & "			<col width=""100"" />"
						PRINT TABS(1) & "			<col width=""150"" />"
						PRINT TABS(1) & "			<col width=""90"" />"
						PRINT TABS(1) & "			<col width=""90"" />"
						'PRINT TABS(1) & "			<col width=""60"" />"
						PRINT TABS(1) & "			<tr>"
						PRINT TABS(1) & "				<th colspan=""7"">"&LNG_TEXT_PAYMENT_RECORD&"</th>"
						PRINT TABS(1) & "			<tr>"
						PRINT TABS(1) & "				<th>"&LNG_TEXT_PAYMENT_METHOD&"</th>"
						PRINT TABS(1) & "				<th>"&LNG_TEXT_PAYMENT_AMOUNT&"</th>"
						PRINT TABS(1) & "				<th>"&LNG_CS_ORDER_LIST_CACU_TEXT04&"</th>"
						PRINT TABS(1) & "				<th>"&LNG_CS_ORDER_LIST_CACU_TEXT05&"</th>"
						PRINT TABS(1) & "				<th>"&LNG_CS_ORDER_LIST_CACU_TEXT06&"</th>"
						PRINT TABS(1) & "				<th>"&LNG_CS_ORDER_LIST_CACU_TEXT07&"</th>"
						PRINT TABS(1) & "				<th>"&LNG_TEXT_DEPOSITOR&"</th>"
						'PRINT TABS(1) & "				<th>"&LNG_TEXT_REMARKS&"</th>"
						PRINT TABS(1) & "			</tr>"

						Set objEncrypter = Server.CreateObject ("Hyeongryeol.StringEncrypter")
							objEncrypter.Key = con_EncryptKey
							objEncrypter.InitialVector = con_EncryptKeyIV
							For k = 0 To listLen2
								arrList2_C_index				= arrList2(0,k)
								arrList2_OrderNumber			= arrList2(1,k)
								arrList2_C_TF					= arrList2(2,k)
								arrList2_C_Code					= arrList2(3,k)
								arrList2_C_CodeName				= arrList2(4,k)
								arrList2_C_Name1				= arrList2(5,k)
								arrList2_C_Name2				= arrList2(6,k)
								arrList2_C_Number1				= arrList2(7,k)
								arrList2_C_Number2				= arrList2(8,k)
								arrList2_C_Number3				= arrList2(9,k)
								arrList2_C_Price1				= arrList2(10,k)
								arrList2_C_Price2				= arrList2(11,k)
								arrList2_C_AppDate1				= arrList2(12,k)
								arrList2_C_AppDate2				= arrList2(13,k)
								arrList2_C_CancelTF				= arrList2(14,k)
								arrList2_C_CancelDate			= arrList2(15,k)
								arrList2_C_CancelPrice			= arrList2(16,k)
								arrList2_C_Period1				= arrList2(17,k)
								arrList2_C_Period2				= arrList2(18,k)
								arrList2_C_Installment_Period	= arrList2(19,k)
								arrList2_C_Etc					= arrList2(20,k)
								arrList2_C_Base_Index			= arrList2(21,k)

								Select Case arrList2_C_TF
									Case "1" : ThisPayment = LNG_TEXT_ORDER_CASH		'"현금"
									Case "2" : ThisPayment = LNG_TEXT_ORDER_BANK		'"무통장"
										arrList2_C_Name2 = arrList2_C_Name1
										arrList2_C_Name1 = ""
									Case "3" : ThisPayment = LNG_TEXT_ORDER_CARD		'"카드"
									'Case "4" : ThisPayment = LNG_TEXT_VIRTUAL_ACCOUNT		'"가상계좌"
									'Case "5" : ThisPayment = SHOP_POINT		'마일리지
									Case "50" : ThisPayment = LNG_TEXT_POINT_A			'더화이트 Point-A
									Case "4"  : ThisPayment = LNG_TEXT_POINT_B			'더화이트 Point-B
								End Select

								On Error Resume Next
									If arrList2_C_Number1	<> "" Then arrList2_C_Number1	= objEncrypter.Decrypt(arrList2_C_Number1)
								On Error Goto 0

								If arrList2_C_Number1 <> "" And arrList2_C_TF = "3" Then
									arrList2_C_Number1_LEN = Len(arrList2_C_Number1) - 4
									arrList2_C_Number1 = Left(arrList2_C_Number1,arrList2_C_Number1_LEN) & "****"
								End If

								PRINT TABS(1) & "	<tr>"
								PRINT TABS(1) & "		<td>"&ThisPayment&"</td>"
								PRINT TABS(1) & "		<td class=""inPrice"">"&num2cur(arrList2_C_Price1)&"</td>"
								PRINT TABS(1) & "		<td>"&date8to10(arrList2_C_AppDate1)&"</td>"
								PRINT TABS(1) & "		<td>"&arrList2_C_CodeName&"</td>"
								PRINT TABS(1) & "		<td>"&arrList2_C_Number1&"</td>"
								PRINT TABS(1) & "		<td>"&arrList2_C_Name1&"</td>"
								PRINT TABS(1) & "		<td>"&arrList2_C_Name2&"</td>"
								'PRINT TABS(1) & "		<td>"&arrList2_C_Etc&"</td>"
								PRINT TABS(1) & "	</tr>"
							Next
						Set objEncrypter = Nothing
					Else
						PRINT TABS(1) & "		<table "&tableatt&" class=""innerTable3"" style=""width:95%; margin:0px auto;"">"
						PRINT TABS(1) & "			<tr>"
						PRINT TABS(1) & "				<th colspan=""1"">"&LNG_TEXT_PAYMENT_RECORD&"</th>"
						PRINT TABS(1) & "			<tr>"
						PRINT TABS(1) & "				<td colspan=""1"" style=""color:#bbbbbb;"">"&LNG_TEXT_NO_SALES_DETAIL&"</td>"
						PRINT TABS(1) & "			</tr>"
					End If


					'▣구매상세내역
					arrParams1 = Array(_
						Db.makeParam("@orderNum",adVarChar,adParamInput,50,arrList_OrderNumber)_
					)
					arrList1 = Db.execRsList("DKP_ORDER_DETAIL2",DB_PROC,arrParams1,listLen1,DB3)

					If IsArray(arrList1) Then
					'	PRINT TABS(1) & "	<tr id=""order"&i&""" class=""bottomLine"" style=""display:none;"">"
					'	PRINT TABS(1) & "		<td colspan=""9"" class=""tcenter notpadding blines"">"
					'	PRINT TABS(1) & "			<table "&tableatt&" class=""innerTable"" style=""width:700px;"">"
						PRINT TABS(1) & "		<table "&tableatt&" class=""innerTable"" style=""width:95%; margin:0px auto; margin-top:15px;"">"
						PRINT TABS(1) & "			<col width=""40"" />"
						PRINT TABS(1) & "			<col width=""230"" />"
						'PRINT TABS(1) & "			<col width=""100"" />"
						PRINT TABS(1) & "			<col width=""100"" />"
						'PRINT TABS(1) & "			<col width=""100"" />"
						PRINT TABS(1) & "			<col width=""40"" />"
						PRINT TABS(1) & "			<col width=""120"" />"
						PRINT TABS(1) & "			<col width=""70"" />"
						PRINT TABS(1) & "			<tr>"
						PRINT TABS(1) & "				<th colspan=""6"">"&LNG_CS_ORDER_LIST_PURCHASE_PRODUCT&"</th>"
						PRINT TABS(1) & "			<tr>"
						PRINT TABS(1) & "				<th>"&LNG_TEXT_NUMBER&"</th>"
						PRINT TABS(1) & "				<th>"&LNG_TEXT_ITEM_NAME&"</th>"
						'PRINT TABS(1) & "				<th>"&LNG_TEXT_CONSUMER_PRICE&"</th>"	'(소비자가)
						PRINT TABS(1) & "				<th>"&LNG_TEXT_PURCHASE_PRICE&"</th>"	'(구매가)
						'PRINT TABS(1) & "				<th>"&CS_PV&"."&CS_WP&"</th>"
						PRINT TABS(1) & "				<th>"&LNG_TEXT_ITEM_NUMBER&"</th>"
						PRINT TABS(1) & "				<th>"&LNG_CS_ORDERS_TOTAL_PURCHASE_AMOUNT&"</th>"
						PRINT TABS(1) & "				<th>"&LNG_TEXT_DELIVERY_INFO&"</th>"
						PRINT TABS(1) & "			</tr>"

						Set objEncrypter = Server.CreateObject ("Hyeongryeol.StringEncrypter")
							objEncrypter.Key = con_EncryptKey
							objEncrypter.InitialVector = con_EncryptKeyIV
							For j = 0 To listLen1
								arr_name			= arrList1(1,j)
								arr_price			= arrList1(2,j)			'소비자가
								arr_ItemPrice		= arrList1(3,j)			'회원가
								arr_ItemPV			= arrList1(4,j)			'PV
								arr_ItemCount		= arrList1(5,j)
								arr_ItemTotalPrice	= arrList1(6,j)
								arr_ItemTotalPV		= arrList1(7,j)
								arr_Receive_Method	= arrList1(8,j)
								arr_Delivery_No		= arrList1(9,j)
								arr_DCode			= arrList1(10,j)
								arr_Get_Name1		= arrList1(11,j)
								arr_Get_ZipCode		= arrList1(12,j)
								arr_Get_Address1	= arrList1(13,j)
								arr_Get_Address2	= arrList1(14,j)
								arr_Get_Tel1		= arrList1(15,j)
								arr_Get_Tel2		= arrList1(16,j)
								arr_Rece_OrderNo	= arrList1(17,j)
								arr_NCODE			= arrList1(18,j)
								arr_Sell_VAT_Price			= arrList1(19,j)	'부가세
								arr_Sell_Except_VAT_Price	= arrList1(20,j)	'공급가
								arr_ItemCV			= arrList1(21,j)			'스피나WP

								On Error Resume Next
									If arr_Get_Address1		<> "" Then arr_Get_Address1		= objEncrypter.Decrypt(arr_Get_Address1)
									If arr_Get_Address2		<> "" Then arr_Get_Address2		= objEncrypter.Decrypt(arr_Get_Address2)
									If arr_Get_Tel1			<> "" Then arr_Get_Tel1			= objEncrypter.Decrypt(arr_Get_Tel1)
									If arr_Get_Tel2			<> "" Then arr_Get_Tel2			= objEncrypter.Decrypt(arr_Get_Tel2)
								On Error Goto 0

								'소비자가 변경체크
								arrParams = Array(_
									Db.makeParam("@ncode",adVarChar,adParamInput,20,arr_NCODE) _
								)
								Set DKRS = Db.execRs("DKP_GOODS_CHANGE",DB_PROC,arrParams,DB3)
								If Not DKRS.BOF And Not DKRS.EOF Then
									arr_price	= DKRS("price1")
								Else
									arr_price	= arr_price
								End If
								Call CloseRS(DKRS)

								Select Case arr_Receive_Method
									Case "1"
										DELIVERY_WAY = LNG_TEXT_DIRECT_RECEIPT		'"직접수령"
									Case "2"
										DELIVERY_WAY = LNG_TEXT_PARCEL_RECEIPT		'"택배"
									Case "3"
										DELIVERY_WAY = LNG_TEXT_CENTER_RECEIPT		'"센타수령"
									Case Else
										DELIVERY_WAY = LNG_CS_ORDER_LIST_DETAIL_TEXT15		'"미등록"
								End Select

								'SQL = " SELECT [strDtoDTrace] FROM [DK_DTOD] WHERE [useTF] = 'T' AND [CS_NCODE] = '"&arr_DCode&"' "
								SQL = " SELECT [strDtoDTrace] FROM [DK_DTOD] WHERE [useTF] = 'T' AND [defaultTF] ='T' "
								DTOD_ADDRESS = Db.execRsData(SQL,DB_TEXT,Nothing,Nothing)

								If arr_Delivery_No <> "" Then	'송장번호가 있을때
									DTOD_NUMBER = Replace(arr_Delivery_No,"-","")
									If arr_DCode = "" Or isNull(arr_DCode) Then
										'DTOD_LINK = "javascript:alert('배송사코드 미입력으로 조회할 수가 없습니다.\n\n본사로 문의해 주십시오.');"
										DTOD_LINK = "javascript:alert('"&LNG_CS_ORDER_LIST_DETAIL_TEXT16&"');"
										DELIVERY_NO = arr_Delivery_No&"<a href="""&DTOD_LINK&""" target=""_self""><span class=""tweight red""> "&LNG_CS_ORDER_LIST_DETAIL_TEXT17&"</span></a>"
									Else
										DTOD_LINK = DTOD_ADDRESS&DTOD_NUMBER
										DELIVERY_NO = arr_Delivery_No&"<a href="""&DTOD_LINK&""" target=""_blank""><span class=""tweight red""> "&LNG_CS_ORDER_LIST_DETAIL_TEXT17&"</span></a>"
									End If
								Else
										DELIVERY_NO = "--"
								End If

								PRINT TABS(1) & "	<tr>"
								PRINT TABS(1) & "		<td>"&j+1&"</td>"
								PRINT TABS(1) & "		<td>"&arr_name&"</td>"
								'PRINT TABS(1) & "		<td class=""inPrice"">"&num2cur(arr_price)&" "&Chg_CurrencyISO&"</td>"
								PRINT TABS(1) & "		<td class=""inPrice"">"&num2cur(arr_ItemPrice)&" "&Chg_CurrencyISO&"</td>"
								'PRINT TABS(1) & "		<td class=""inPrice"">"&num2cur(arr_Sell_Except_VAT_Price)&" "&Chg_CurrencyISO&"</td>"
								'PRINT TABS(1) & "		<td class=""inPrice"">"&num2cur(arr_Sell_VAT_Price)&" "&Chg_CurrencyISO&"</td>"
								'If arrList_SellCode = "01" Then		'스피나회원매출
								'	PRINT TABS(1) & "		<td class=""inPrice"">"&num2cur(arr_ItemPV)&CS_PV&"</td>"
								'ElseIf arrList_SellCode = "02" Then
								'	PRINT TABS(1) & "		<td class=""inPrice"">"&num2cur(arr_ItemCV)&CS_WP&"</td>"
								'End If
								PRINT TABS(1) & "		<td>"&arr_ItemCount&"</td>"
								PRINT TABS(1) & "		<td class=""inPrice"">"&num2cur(arr_ItemTotalPrice)&" "&Chg_CurrencyISO&"</td>"
								If arr_Receive_Method = 1 Then
									PRINT TABS(1) & "	<td><span class="""">직접수령</span></td>"
								Else
									If arr_Rece_OrderNo <> "" Then		'배송정보토글
										PRINT TABS(1) & "<td><span class=""btn01 fon1""><a href=""javascript:toggle_content('deliveryInfo"&i&j&"')"" id=""detail_deliveryInfo"&i&j&""">상세보기</span></a></td>"
									Else
										PRINT TABS(1) & "<td><span class=""red"">미등록</span></td>"
									End If
								End If
								PRINT TABS(1) & "	</tr>"
								PRINT TABS(1) & "	<tr id=""deliveryInfo"&i&j&""" class=""bottomLine"" style=""display:none;"">"
								PRINT TABS(1) & "		<td colspan=""8"" class=""tcenter notpadding blines"">"
								PRINT TABS(1) & "			<div style=""margin-top:10px;"">"
								PRINT TABS(1) & "				<table "&tableatt&" class=""innerTable2"" style=""width:460px;"">"
								PRINT TABS(1) & "					<col width=""100"" />"
								PRINT TABS(1) & "					<col width=""180"" />"
								PRINT TABS(1) & "					<col width=""100"" />"
								PRINT TABS(1) & "					<col width=""180"" />"
								PRINT TABS(1) & "					<tr>"
								PRINT TABS(1) & "						<th colspan=""4"">"&LNG_CS_ORDER_LIST_DETAIL_TEXT18&"</th>"
								PRINT TABS(1) & "					</tr><tr>"
								PRINT TABS(1) & "						<th>"&LNG_TEXT_RECIPIENT&"</th>"
								PRINT TABS(1) & "						<td colspan=""3"">"&arr_Get_Name1&"</td>"
								PRINT TABS(1) & "					</tr><tr>"
								PRINT TABS(1) & "						<th>"&LNG_CS_ORDER_LIST_DETAIL_TEXT20&"</th>"
								PRINT TABS(1) & "						<td>"&DELIVERY_WAY&"</td>"
								PRINT TABS(1) & "						<th>"&LNG_CS_ORDER_LIST_DETAIL_TEXT21&"</th>"
								PRINT TABS(1) & "						<td>"&DELIVERY_NO&"</td>"
								PRINT TABS(1) & "					</tr><tr>"
								PRINT TABS(1) & "						<th>"&LNG_CS_ORDER_LIST_DETAIL_TEXT22&"</th>"
								PRINT TABS(1) & "						<td>"&arr_Get_Tel1&"</td>"
								PRINT TABS(1) & "						<th>"&LNG_CS_ORDER_LIST_DETAIL_TEXT23&"</th>"
								PRINT TABS(1) & "						<td>"&arr_Get_Tel2&"</td>"
								PRINT TABS(1) & "					</tr><tr>"
								PRINT TABS(1) & "						<th>"&LNG_TEXT_ZIPCODE&"</th>"
								PRINT TABS(1) & "						<td colspan=""3"">"&arr_Get_ZipCode&"</td>"
								PRINT TABS(1) & "					</tr><tr>"
								PRINT TABS(1) & "						<th>"&LNG_TEXT_ADDRESS1&"</th>"
								PRINT TABS(1) & "						<td colspan=""3"">"&arr_Get_Address1&"&nbsp;"&arr_Get_Address2&"</td>"
								PRINT TABS(1) & "					</tr>"
								PRINT TABS(1) & "				</table>"
								PRINT TABS(1) & "			</div>"
								PRINT TABS(1) & "		</td>"
								PRINT TABS(1) & "	</tr>"
							Next
						Set objEncrypter = Nothing
					Else
						PRINT TABS(1) & "		<table "&tableatt&" class=""innerTable"" style=""width:95%; margin:0px auto; margin-top:15px;"">"
						PRINT TABS(1) & "			<tr>"
						PRINT TABS(1) & "				<th colspan=""1"">"&LNG_CS_ORDER_LIST_PURCHASE_PRODUCT&"</th>"
						PRINT TABS(1) & "			<tr>"
						PRINT TABS(1) & "				<td colspan=""1"" style=""color:#bbbbbb;"">"&LNG_CS_ORDER_LIST_DETAIL_TEXT26&"</td>"
						PRINT TABS(1) & "			</tr>"
					End If
					PRINT TABS(1) & "			</table>"
					PRINT TABS(1) & "		</td>"
					PRINT TABS(1) & "	</tr>"

				Next
			Else
				PRINT TABS(1) & "		<tr>"
				PRINT TABS(1) & "			<td colspan=""8"" class=""notData"">"&LNG_CS_ORDER_LIST_TEXT22&"</td>"
				PRINT TABS(1) & "		</tr>"
			End If

		%>


	</table>
	<div class="pagingArea pagingNew userCWidth"><% Call pageListNew(PAGE,PAGECOUNT)%></div>
</div>
<form name="frm" method="post" action="">
	<input type="hidden" name="PAGE" value="<%=PAGE%>" />
	<input type="hidden" name="SDATE" value="<%=SDATE%>" />
	<input type="hidden" name="EDATE" value="<%=EDATE%>" />
</form>

<!--#include virtual = "/_include/copyright.asp"-->