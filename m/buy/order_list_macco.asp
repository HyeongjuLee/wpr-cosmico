<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	PAGE_SETTING = "MY_BUY"
	'Call FNC_ONLY_CS_MEMBER()
	Call ONLY_BUSINESS_MEMBER(DK_MEMBER_LEVEL,2)


	SDATE = pRequestTF("SDATE",False)
	EDATE = pRequestTF("EDATE",False)

	PAGE = pRequestTF("PAGE",False)
	PAGESIZE = 15
	If PAGE = "" Then PAGE = 1

	ThisM_1stDate = Left(Date(),8)&"01"				'이번달 1일

	If isMACCO <> "T" Then Response.Redirect "/m/buy/order_list.asp"

	arrParams = Array(_
		Db.makeParam("@mbid1",adVarChar,adParamInput,20,DK_MEMBER_ID1), _
		Db.makeParam("@mbid2",adInteger,adParamInput,0,DK_MEMBER_ID2), _
		Db.makeParam("@SDATE",adVarChar,adParamInput,10,SDATE), _
		Db.makeParam("@EDATE",adVarChar,adParamInput,10,EDATE), _
		Db.makeParam("@PAGE",adInteger,adParamInput,0,PAGE), _
		Db.makeParam("@PAGESIZE",adInteger,adParamInput,0,PAGESIZE), _
		Db.makeParam("@ALL_Count",adInteger,adParamOutput,0,0) _
	)
	arrList =  Db.execRsList("DKP_ORDER_LIST_MACCO",DB_PROC,arrParams,listLen,DB3)
	All_Count = arrParams(UBound(arrParams))(4)
	Dim PAGECOUNT,CNT
	PAGECOUNT = Int((CCur(All_Count) - 1 ) / CInt(PAGESIZE) ) + 1
	IF CCur(PAGE) = 1 Then
		CNT = All_Count
	Else
		CNT = All_Count - ((CCur(PAGE)-1)*CInt(PAGESIZE)) '
	End If
%>
<!--#include virtual = "/m/_include/document.asp"-->
<!--#include virtual = "/m/_include/jqueryload.asp"-->
<link rel="stylesheet" href="buy.css" />

<script type="text/javascript" src="/m/js/calendar.js"></script>

<script type="text/javascript">
	 $(document).ready(
		function() {
			//$("tbody.hid_tbody tr:last-child td").css("border-bottom", "2px solid #000");
	});

	function toggle_tbody(f_menu) {
		if (document.getElementById(f_menu).style.display == "") {
			//alert(f_menu);
			document.getElementById(f_menu).style.display = "none"
			$('#detail_'+f_menu).find('span.ui-btn-text').text("<%=LNG_BTN_DETAIL%>");
		} else {
			//		alert(f_menu);
			document.getElementById(f_menu).style.display = ""
			$('#detail_'+f_menu).find('span.ui-btn-text').text("<%=LNG_BTN_CLOSE%>");
		}
	}

	//주문내역_배송정보상세
	function toggle_tbody_inner(f_menu) {
		if (document.getElementById(f_menu).style.display == "") {
			document.getElementById(f_menu).style.display = "none"
			$('#detail_'+f_menu).text("<%=LNG_BTN_DETAIL%>");
			$('#detail_'+f_menu).addClass("txtBtnC small gray border1 radius3");
		} else {
			document.getElementById(f_menu).style.display = ""
			$('#detail_'+f_menu).text("<%=LNG_BTN_CLOSE%>");
			$('#detail_'+f_menu).addClass("txtBtnC small gray border1 radius3");
		}
	}
</script>

</head>
<body onunload="">
<!--#include virtual = "/m/_include/header.asp"-->
<!--#include virtual = "/m/_include/sub_header.asp"-->
<!-- <div id="subTitle" class="width100 tcenter text_noline" ><%=LNG_MYOFFICE_BUY_01%></div> -->

<!-- <div id="subDesc">
	<ul>
		<li>- CS에 등록된 상품구입정보만 출력됩니다.</li>
	</ul>
</div> -->
<div id="b_title" class="cleft" style="margin-bottom:10px;">
	<h3 class="fleft"><span class="h3color1"><%=LNG_MYOFFICE_BUY_01%></span></h3>
</div>
<div id="div_date">
	<form name="dateFrm" action="order_list_macco.asp" method="post" data-ajax="false">
		<!-- <p class="sub_title"><%=LNG_TEXT_DATE_SEARCH%></p> -->
		<table <%=tableatt%> class="width100">
			<col width="" />
			<col width="*" />
			<col width="80" />
			<tr>
				<th colspan="3" class="tcenter" style="height:32px;">
					<span class="button medium"><button type="button" onclick="chgDate('<%=DateAdd("m",-1,ThisM_1stDate)%>','<%=DateAdd("d",-1,ThisM_1stDate)%>');"><%=LNG_TEXT_LASTMONTH%></button></span>
					<span class="button medium"><button type="button" onclick="chgDate('<%=ThisM_1stDate%>','<%=nowDate%>');"><%=LNG_TEXT_THISMONTH%></button></span>
					<span class="button medium"><button type="button" onclick="chgDate('<%=DateAdd("m",-3,nowDate)%>','<%=nowDate%>');"><%=LNG_TEXT_3MONTH%></button></span>
					<span class="button medium"><button type="button" onclick="chgDate('<%=nowDate%>','<%=nowDate%>');"><%=LNG_TEXT_TODAY%></button></span>
					<span class="button medium"><button type="button" onclick="chgDate('','');"><%=LNG_TEXT_ALL%></button></span>
				</td>
				<td class="tcenter" rowspan="3" style="padding:0px 5px;">
					<input type="submit" value="<%=LNG_TEXT_SEARCH%>" class="date_submit" />
				</td>
			</tr><tr>
				<th><%=LNG_TEXT_START_DATE%></th>
				<td class="tcenter" colspan="2">
					<input type='text' id="SDATE" name='SDATE' value="<%=SDATE%>" class='input_text_date readonly' onclick="openCalendar(event, this, 'YYYY-MM-DD');" readonly="readonly">
				</td>
			</tr><tr>
				<th><%=LNG_TEXT_END_DATE%></th>
				<td class="tcenter" colspan="2">
					<input type='text' id="EDATE" name='EDATE' value="<%=EDATE%>" class='input_text_date readonly' onclick="openCalendar(event, this, 'YYYY-MM-DD');" readonly="readonly"></td>
					<!-- <input type="image" src="<%=IMG_BTN%>/g_list_search.gif" style="width:43px; height:19px; vertical-align:middle;" /> -->
				</td>
			</tr>
		</table>
	</form>
</div>

<!-- <div class="subTitle_s" class="tcenter text_noline" ><%=LNG_MYOFFICE_BUY_01%></div> -->
<!-- <div id="b_title" class="cleft">
	<h3 class="fleft"><span class="h3color1"><%=LNG_MYOFFICE_BUY_01%></span></h3>
</div> -->

<div id="order" class="order_list" style="margin-top:10px;">
<%
%>
	<table <%=tableatt%> class="width100">
		<col width="40" />
		<col width="30%" />
		<col width="30%" />
		<col width="*" />
		<thead>
			<tr>
				<th rowspan="3"><%=LNG_TEXT_NUMBER%></th>
				<th><%=LNG_TEXT_ORDER_DATE%></th>
				<th colspan="2"><%=LNG_TEXT_ORDER_NUMBER%></th>

			</tr><tr>
				<th><%=LNG_TEXT_SALES_TYPE%></th>
				<th><%=LNG_TEXT_ORDER_AMOUNT%></th>
				<th><%=CS_PV%></th>
				<!-- <th><%=CS_PV%> / <%=LNG_TEXT_ORDER_APPROVAL_TF%></th> -->
			</tr><tr>
				<th>공제번호</th>
				<th><%=LNG_TEXT_ORDER_APPROVAL_TF%></th>
				<th>열기/닫기</th>
				<!-- <th colspan="2">열기/닫기</th> -->
			</tr>
		</thead>
		<%

			If IsArray(arrList) Then
				For i = 0 To listLen
					ThisNum = ALL_COUNT - CInt(arrList(0,i)) + 1

					arrList_OrderNumber				= arrList(1,i)
					arrList_mbid					= arrList(2,i)
					arrList_mbid2					= arrList(3,i)
					arrList_M_Name					= arrList(4,i)
					arrList_SellDate				= arrList(5,i)
					arrList_SellTypeName			= arrList(6,i)
					arrList_InputCard				= arrList(7,i)
					arrList_InputPassbook			= arrList(8,i)
					arrList_InputCash				= arrList(9,i)
					arrList_TotalPrice				= arrList(10,i)
					arrList_TotalPV					= arrList(11,i)
					arrList_ReturnTF				= arrList(12,i)
					arrList_SellCode				= arrList(13,i)
					arrList_Approval				= arrList(14,i)
					arrList_InputMile				= arrList(15,i)
					'arrList_Etc2					= arrList(16,i)		'웹주문번호
					arrList_InsuranceNumber			= arrList(17,i)
					arrList_CancelStatus			= arrList(18,i)
					arrList_InsuranceNumber_Cancel	= arrList(19,i)
					arrList_CancelRequest			= arrList(20,i)
					arrList_ReturnTF				= arrList(21,i)
					arrList_isSellDate				= arrList(22,i)
					arrList_TotalCV					= arrList(23,i)

					If arrList_Approval = 1 Then
						'arrList_Approval = "승인"
						arrList_Approval = LNG_TEXT_ORDER_APPROVAL	'"승인"
					Else
						'arrList_Approval = "미승인"
						arrList_Approval = LNG_TEXT_ORDER_DISAPPROVAL	'"미승인"
					End If


					arrList_WebOrderNumber = ""
					'If arrList_Etc2 <> "" Then arrList_WebOrderNumber = Right(arrList_Etc2,14)


					'▣MACCO 신고NEW (2016-06-13,2016-08-08)
					'Case 			 WHEN ReturnTF = 1 AND (SELECT SellDate FROM tbl_SalesDetail WHERE OrderNumber = Re_BaseOrderNumber) IS NULL 	 AND InsuranceNumber <> '' THEN InsuranceNumber
					'[취소상태]		 WHEN ReturnTF = 1 AND (SELECT SellDate FROM tbl_SalesDetail WHERE OrderNumber = Re_BaseOrderNumber) IS NOT NULL AND InsuranceNumber_Cancel ='Y' THEN InsuranceNumber + '(취소상태)'
					'[취소상태]		 WHEN ReturnTF = 5 AND InsuranceNumber_Cancel ='Y' Then InsuranceNumber + '(취소상태)' ";
					'[취소요청중]	 WHEN ReturnTF = 1 AND (SELECT SellDate FROM tbl_SalesDetail WHERE OrderNumber = Re_BaseOrderNumber) IS NOT NULL AND InsuranceNumber_Cancel ='' Then InsuranceNumber + '(취소요청중)'
					'[반품처리]		 WHEN ReturnTF = 2 THEN '반품처리'
					'[재발급요청요망]WHEN ReturnTF = 1 AND InsuranceNumber = '' Then '재발급요청요망' + ' ' + INS_Num_Err
					'ELSE InsuranceNumber END

					INS_Num_STATE = ""
					TxtClass1 = ""

					Select Case arrList_ReturnTF
						Case "1"
							If arrList_InsuranceNumber = "" Then
								insNums = "재발급요청요망"
							Else
								If arrList_isSellDate = "" Then
									If arrList_InsuranceNumber <> "" Then
										insNums = arrList_InsuranceNumber
										INS_Num_STATE = ""
									End If
								Else
									If arrList_InsuranceNumber_Cancel = "Y" Then
										TxtClass1 = "style=""color:red;text-decoration:line-through;"""
										insNums = arrList_InsuranceNumber
										INS_Num_STATE = "<br /><span style=""text-decoration:none;font-size:10pt;"">취소상태</span>"
									Else
										TxtClass1 = ""
										insNums = arrList_InsuranceNumber
										INS_Num_STATE = "<br /><span style=""text-decoration:none;font-size:10pt;"">취소요청중</span>"
									End If
									arrList_OrderNumber = "<span style=""text-decoration:line-through;"">"&arrList_OrderNumber&"</span>"
								End If
							End If
						Case "2"
							insNums = "반품처리"
							INS_Num_STATE = ""
						Case "5"
							If arrList_InsuranceNumber_Cancel = "Y" Then
								TxtClass1 = "style=""color:red;text-decoration:line-through;"""
								insNums = arrList_InsuranceNumber
								INS_Num_STATE = "<br /><span style=""text-decoration:none;font-size:10pt;"">취소상태</span>"
								arrList_OrderNumber = "<span style=""text-decoration:line-through;"">"&arrList_OrderNumber&"</span>"
							End If
						Case Else
							insNums = arrList_InsuranceNumber
							INS_Num_STATE = ""
					End Select


					PRINT TABS(1) & "	<tbody>"
					PRINT TABS(1) & "		<tr class=""bot_line_c_333"">"
					PRINT TABS(1) & "			<td class=""tcenter bot_line_c_333"" rowspan=""3"">"&ThisNum&"</td>"
					PRINT TABS(1) & "			<td class=""tcenter"">"&date8to10(arrList_SellDate)&"</td>"
					PRINT TABS(1) & "			<td class=""tcenter "" colspan=""2"">"&arrList_OrderNumber&"<br />"&arrList_WebOrderNumber&"</td>"
					PRINT TABS(1) & "		</tr><tr>"
					PRINT TABS(1) & "			<td class=""tcenter"" >"&arrList_SellTypeName&"</td>"
					PRINT TABS(1) & "			<td class=""tright"">"&num2cur(arrList_TotalPrice)&" "&CS_CURC&"</td>"
					PRINT TABS(1) & "			<td class=""tright"">"&num2cur(arrList_TotalPV)&"</td>"
					'PRINT TABS(1) & "			<td class=""tright"">"&num2cur(arrList_TotalPV)&" "&CS_PV&" / "&arrList_Approval&"</td>"
					PRINT TABS(1) & "		</tr><tr>"
					PRINT TABS(1) & "			<td class=""tcenter bot_line_c_333""><span "&TxtClass1&" >"&insNums&"</span>"&INS_Num_STATE&"</td>"
					PRINT TABS(1) & "			<td class=""tcenter bot_line_c_333""><span "&TxtClass1&" >"&arrList_Approval&"</td>"
					PRINT TABS(1) & "			<td class=""tcenter bot_line_c_333""><a class=""btn_a"" onclick=""toggle_tbody('tbody"&i&"');"">"&LNG_BTN_DETAIL&"</a></td>"
					'PRINT TABS(1) & "			<td class=""tcenter bot_line_c_333"" colspan=""2""><a class=""btn_a"" onclick=""toggle_tbody('tbody"&i&"');"">"&LNG_BTN_DETAIL&"</a></td>"
					PRINT TABS(1) & "		</tr>"
					PRINT TABS(1) & "	</tbody>"


%>

			<tbody id="tbody<%=i%>" class="hid_tbody" style="display:none;">
			<tr>
				<td colspan="4" class="tcenters" style="padding:10px 10px;background-color:#fffffa;border-bottom:2px solid #888;">
					<table <%=tableatt%> class="innerTablePay width100 search">
						<col width="40" />
						<col width="32%" />
						<col width="28%" />
						<col width="*" />
						<%
							'▣결제상세내역
							arrParams2 = Array(_
								Db.makeParam("@orderNum",adVarChar,adParamInput,50,arrList_OrderNumber)_
							)
							arrList2 = Db.execRsList("DKP_ORDER_DETAIL_CACU",DB_PROC,arrParams2,listLen2,DB3)

							If IsArray(arrList2) Then

						%>
						<tr>
							<td class="th" colspan="4"><%=LNG_TEXT_PAYMENT_RECORD%></td>
						</tr><tr>
							<td class="th" rowspan="2"><%=LNG_TEXT_PAYMENT_METHOD%></td>
							<td class="th"><%=LNG_CS_ORDER_LIST_CACU_TEXT05%></td>
							<td class="th"><%=LNG_CS_ORDER_LIST_CACU_TEXT07%></td>
							<td class="th" rowspan="2"><%=LNG_TEXT_PAYMENT_AMOUNT%></td>
						</tr><tr>
							<td class="th"><%=LNG_CS_ORDER_LIST_CACU_TEXT06%></td>
							<td class="th"><%=LNG_TEXT_DEPOSITOR%></td>
						</tr>
						<%
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
										'Case "4" : ThisPayment = LNG_TEXT_VIRTUAL_ACCOUNT	'"가상계좌"
										Case "4" : ThisPayment = SHOP_POINT					'마일리지 (바이오플래넷)
									End Select

									On Error Resume Next
										If arrList2_C_Number1	<> "" Then arrList2_C_Number1	= objEncrypter.Decrypt(arrList2_C_Number1)
									On Error Goto 0

									'If arrList2_C_Number1 <> "" And Len(arrList2_C_Number1) > 3 And arrList2_C_TF = "3" Then
									'	arrList2_C_Number1_LEN = Len(arrList2_C_Number1) - 4
									'	arrList2_C_Number1 = Left(arrList2_C_Number1,arrList2_C_Number1_LEN) & "****"
									'End If

									If arrList2_C_TF = "3" Then
										If arrList2_C_Number1 <> "" Then
											'카드번호* 처리
											C_Number_LEN = 0
											C_Number_LEN = Len(arrList2_C_Number1)

											cStars = ""
											If C_Number_LEN >= 14 Then
												For s = 1 To 8				'1234********1234
													cStars = cStars&"*"
												Next
												arrList2_C_Number1 = Left(arrList2_C_Number1,4) & cStars & Right(arrList2_C_Number1,C_Number_LEN - (4+8))
											Else
												For s = 1 To 8
													cStars = cStars&"*"		'1234********8
												Next
												arrList2_C_Number1 =	Left(arrList2_C_Number1,4) & cStars & Right(arrList2_C_Number1,1)
											End If
										End If
									End If
						%>
								<tr>
									<td class="tcenter td" rowspan="2"><%=ThisPayment%></td>
									<td class="tcenter td" style="height:14px;"><%=arrList2_C_CodeName%></td>
									<td class="tcenter td"><span><%=arrList2_C_Name1%></span></td>
									<td class="tright td" rowspan="2"><span><%=num2cur(arrList2_C_Price1)%></span></td>
								</tr><tr>
									<td class="tcenter td" style="height:14px;"><%=arrList2_C_Number1%></td>
									<td class="tcenter td"><%=arrList2_C_Name2%></td>
								</tr>

						<%
								Next
							Set objEncrypter = Nothing
							Else
						%>
							<tr>
								<td class="th tcenter tweight" colspan="4"><%=LNG_TEXT_PAYMENT_RECORD%></td>
							</tr><tr>
								<td class="tcenter" colspan="4" style="height:14px;"><%=LNG_TEXT_NO_SALES_DETAIL%></td>
							</tr>
						<%
							End If
						%>

					<table <%=tableatt%> class="innerTableBuy width100 search" style="margin-top:10px;">
						<col width="40" />
						<col width="30%" />
						<col width="30%" />
						<col width="*" />
						<%
							'▣구매상세내역
							arrParams1 = Array(_
								Db.makeParam("@orderNum",adVarChar,adParamInput,50,arrList_OrderNumber)_
							)
							arrList1 = Db.execRsList("DKP_ORDER_DETAIL2",DB_PROC,arrParams1,listLen1,DB3)

							If IsArray(arrList1) Then
						%>
						<tr>
							<td class="th" colspan="4"><%=LNG_CS_ORDER_LIST_PURCHASE_PRODUCT%></td>
						</tr><tr>
							<td class="th" rowspan="2"><%=LNG_TEXT_NUMBER%></td>
							<td class="th" colspan="2"><%=LNG_TEXT_ITEM_NAME%></td>
							<!-- <td class="th"><%=LNG_TEXT_CONSUMER_PRICE%></td> -->
							<td class="th"><%=LNG_TEXT_PURCHASE_PRICE%></td>
						</tr><tr>
							<td class="th"><%=LNG_TEXT_DELIVERY_INFO%></td>
							<!-- <td class="th"><%=LNG_TEXT_ITEM_NUMBER%></td> -->
							<td class="th"><%=LNG_TEXT_ITEM_NUMBER%> / <%=CS_PV%></td>
							<td class="th"><%=LNG_TEXT_TOTAL_SALES_PRICE%></td>
						</tr>
						<%

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
									arr_Get_Etc1				= arrList1(21,j)
									arr_Get_Etc2				= arrList1(22,j)
									arr_ItemCV					= arrList1(23,j)
									arr_ItemTotalCV				= arrList1(24,j)

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

						%>
								<tr>
									<td class="tcenter td" rowspan="2"><%=j+1%></td>
									<td class="tcenter td" colspan="2" style="height:14px;"><%=arr_name%></td>
									<!-- <td class="tright td"><span><%=num2cur(arr_price)%></span></td> -->
									<td class="tright td"><span><%=num2cur(arr_ItemPrice)%></span></td>
								</tr>
								<%
									'◆배송정보 1번만
									If j = 0 Then
										If arr_Receive_Method = 2 Then
											DELIVERY_WAY = "<a href=""javascript:toggle_tbody_inner('tbodyIn"&i&j&"')"" id=""detail_tbodyIn"&i&j&"""><span class=""txtBtnC small gray border1 radius3"">"&LNG_SHOP_ORDER_BTN_DETAILVIEW&"</span></a>"
										End If
									Else
										DELIVERY_WAY = ""
									End If
								%>
								<tr>
									<td class="tcenter td"><%=DELIVERY_WAY%></td>
									<td class="tright td" style="height:14px;"><%=(arr_ItemCount)%> / <%=num2cur(arr_ItemPV)%></td>
									<td class="tright td"><%=num2cur(arr_ItemTotalPrice)%></td>
								</tr>
								<tr class="tcenter" rowspan="2" id="tbodyIn<%=i%><%=j%>" style="display:none;">
									<td colspan="4" class="tcenters" style="padding:10px 10px;">
										<div>
											<table <%=tableatt%> class="innerTableRece width100 search">
												<col width="80" />
												<col width="*" />
												<tr>
													<td class="th" colspan="2"><%=LNG_CS_ORDER_LIST_DETAIL_TEXT18%></td>
												</tr><tr>
													<td class="th"><%=LNG_TEXT_RECIPIENT%></td>
													<td class="td"><%=arr_Get_Name1%></td>
												</tr><!-- <tr>
													<td class="th"><%=LNG_CS_ORDER_LIST_DETAIL_TEXT20%></td>
													<td class="td"><%=DELIVERY_WAY%></td>
												</tr> --><tr>
													<td class="th"><%=LNG_CS_ORDER_LIST_DETAIL_TEXT21%></td>
													<td class="td"><%=DELIVERY_NO%></td>
												</tr><tr>
													<td class="th"><%=LNG_CS_ORDER_LIST_DETAIL_TEXT22%></td>
													<td class="td"><%=arr_Get_Tel1%></td>
												</tr><tr>
													<td class="th"><%=LNG_CS_ORDER_LIST_DETAIL_TEXT23%></td>
													<td class="td"><%=arr_Get_Tel2%></td>
												</tr><tr>
													<td class="th"><%=LNG_TEXT_ZIPCODE%></td>
													<td class="td"><%=arr_Get_ZipCode%></td>
												</tr><tr>
													<td class="th"><%=LNG_TEXT_ADDRESS1%></td>
													<td class="td"><%=arr_Get_Address1%>&nbsp;<%=arr_Get_Address2%></td>
												</tr><tr>
													<td class="th"><%=LNG_TEXT_REMARKS%></td>
													<td class="td"><%=arr_Get_Etc1%></td>
												</tr>
											</table>
										</div>
									</td>
								</tr>
						<%
								Next
							Set objEncrypter = Nothing
							Else
						%>
							<tr>
								<td class="th tweight" colspan="4"><%=LNG_CS_ORDER_LIST_PURCHASE_PRODUCT%></td>
							</tr><tr>
								<td class="tcenter" colspan="4" style="height:14px;"><%=LNG_CS_ORDER_LIST_DETAIL_TEXT26%></td>
							</tr>
						<%
							End If
						%>
					</table>
				</td>
			</tr>
			</tbody>
		<%

				Next
			Else
				PRINT TABS(1) & "	<tr>"
				PRINT TABS(1) & "		<td colspan=""11"" class=""notData"">"&LNG_CS_ORDER_LIST_TEXT22&"</td>"
				PRINT TABS(1) & "	</tr>"
			End If

		%>
	</table>

	<div class="pagingArea pagingMob5n"><% Call pageListMob5n(PAGE,PAGECOUNT)%></div>


	<form name="frm" method="post" action="">
		<input type="hidden" name="PAGE" value="<%=PAGE%>" />
		<input type="hidden" name="PAGESIZE" value="<%=PAGESIZE%>" />
		<input type="hidden" name="SDATE" value="<%=SDATE%>" />
		<input type="hidden" name="EDATE" value="<%=EDATE%>" />
	</form>



</div>
<!--#include virtual = "/m/_include/copyright.asp"-->