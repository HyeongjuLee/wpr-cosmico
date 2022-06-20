<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	PAGE_SETTING = "MYOFFICE"
	INFO_MODE	 = "BUY1-1"

	ISLEFT = "T"
	ISSUBTOP = "T"

	If DK_MEMBER_TYPE = "ADMIN" Then Response.Redirect "/cboard/board_list.asp?bname=myoffice"

	Call ONLY_BUSINESS_MEMBER(DK_MEMBER_LEVEL,2)
	'Call ONLY_CS_MEMBER()
	Call ONLY_CS_MEMBER_ALL()											'◈(소비자) 조회 허용 DK_MEMBER_STYPE
	'Call FN_NationCurrency(DK_MEMBER_NATIONCODE,Chg_CurrencyName,Chg_CurrencyISO)

	If isMACCO <> "T" Then Response.Redirect "order_list.asp"

	SDATE = pRequestTF("SDATE",False)
	EDATE = pRequestTF("EDATE",False)

	PAGE = pRequestTF("PAGE",False)
	PAGESIZE = 15
	If PAGE = "" Then PAGE = 1

%>
<!--#include virtual = "/_include/document.asp"-->
<link rel="stylesheet" href="/myoffice/css/layout_cs.css" />
<link rel="stylesheet" href="/css/style_cs.css" />
<link rel="stylesheet" href="/css/pay.css?v2" />
<script type="text/javascript" src="/jscript/calendar.js"></script>
<script>
</script>
</head>
<body>
<!--#include virtual = "/_include/header.asp"-->
<div id="buy" class="orderList">
	<form name="dateFrm" action="order_list_macco.asp" method="post">
		<div class="search_form vertical">
			<article class="date">
				<h6><%=LNG_TEXT_DATE_SEARCH%></h6>
				<div class="inputs">
					<input type="text" id="SDATE" name="SDATE" value="<%=SDATE%>" readonly="readonly" onclick="openCalendar(event, this, 'YYYY-MM-DD');" />
					<span>~</span>
					<input type="text" id="EDATE" name="EDATE" value="<%=EDATE%>" readonly="readonly" onclick="openCalendar(event, this, 'YYYY-MM-DD');" />
				</div>
				<div class="buttons">
					<button type="button" onclick="chgDate('<%=DateAdd("m",-1,ThisM_1stDate)%>','<%=DateAdd("d",-1,ThisM_1stDate)%>');"><%=LNG_TEXT_LASTMONTH%></button>
					<button type="button" onclick="chgDate('<%=ThisM_1stDate%>','<%=nowDate%>');"><%=LNG_TEXT_THISMONTH%></button>
					<button type="button" onclick="chgDate('<%=DateAdd("m",-3,nowDate)%>','<%=nowDate%>');"><%=LNG_TEXT_3MONTH%></button>
					<button type="button" onclick="chgDate('<%=nowDate%>','<%=nowDate%>');"><%=LNG_TEXT_TODAY%></button>
					<button type="button" onclick="chgDate('<%=DateAdd("m",-6,nowDate)%>','<%=nowDate%>');"><%=LNG_TEXT_6MONTH%></button>
					<button type="button" onclick="chgDate('<%=DateAdd("yyyy",-1,nowDate)%>','<%=nowDate%>');"><%=LNG_TEXT_1YEAR%></button>
					<button type="button" onclick="chgDate('','');"><%=LNG_TEXT_ALL%></button>
				</div>
			<!-- </article>
			<article class="searchs">
				<h6><%=LNG_TEXT_SEARCH_CONDITION%></h6>
				<div class="selects">
				</div> -->
				<input type="submit" class="search_btn" value="<%=LNG_TEXT_SEARCH%>"/>
			</article>
			<!-- <input type="button" class="search_reset" value="<%=LNG_TEXT_INITIALIZATION%>" onclick="location.href='order_list'"/> -->
			<!-- <input type="submit" class="search_btn" value="<%=LNG_TEXT_SEARCH%>"/> -->
		</div>
	</form>

	<%If 1=2 Then	'table sorter%>
	<link rel="stylesheet" href="/jscript/tablesorter/jquery.wprTablesorter.css">
	<script type="text/javascript" src="/jscript/tablesorter/jquery.wprTablesorter.js"></script>
	<script type="text/javascript">
		//table sorter
		$(document).ready(function() {
			$("#sortTable").wprTablesorter({
				firstColFix : true,	//첫번째열 고정
				firstColasc : false,	//첫번째열 오름차순 여부	//firstColFix=true일 경우 필수값
				noSortColumns : [0,8]		//정렬안하는 컬럼
			});
		});
	</script>
	<%End If%>

	<p class="titles"><%=LNG_TEXT_LIST%></p>
	<table <%=tableatt%> class="width100 table2 tablesorter" id="sortTable">
		<col width="40" />
		<col width="" />
		<col width="" />
		<col width="" />
		<col width="100" />
		<col width="90" />
		<col width="" />
		<col width="" />
		<col width="" />
		<thead>
			<tr>
				<th><%=LNG_TEXT_NUMBER%></th>
				<th><%=LNG_TEXT_ORDER_DATE%></th>
				<th><%=LNG_TEXT_ORDER_NUMBER%></th>
				<th>공제번호</th>
				<th><%=LNG_TEXT_ORDER_AMOUNT%></th>
				<th><%=CS_PV%></th>
				<th><%=LNG_SHOP_ORDER_DIRECT_TITLE_06%></th>
				<!-- <th><%=LNG_TEXT_POINT%></th> -->
				<th><%=LNG_TEXT_SALES_TYPE%><br /><%=LNG_TEXT_ORDER_APPROVAL_TF%></th>
				<th><%=LNG_BTN_DETAIL%></th>
			</tr>
		</thead>
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
			arrList =  Db.execRsList("DKP_ORDER_LIST_MACCO",DB_PROC,arrParams,listLen,DB3)
			All_Count = arrParams(UBound(arrParams))(4)
			Dim PAGECOUNT,CNT
			PAGECOUNT = Int((CCur(All_Count) - 1 ) / CInt(PAGESIZE) ) + 1
			IF CCur(PAGE) = 1 Then
				CNT = All_Count
			Else
				CNT = All_Count - ((CCur(PAGE)-1)*CInt(PAGESIZE)) '
			End If

			TOTAL_PRICE		= 0
			TOTAL_PV		= 0
			TOTAL_CV		= 0
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
					ElseIf arrList_Approval = 0 Then
						'arrList_Approval = "미승인"
						arrList_Approval = "<span class=""red"">"&LNG_TEXT_ORDER_DISAPPROVAL&"</span>"	'"미승인"
					Else
						arrList_Approval = ""
					End If

					arrList_WebOrderNumber = ""
					If arrList_Etc2 <> "" Then arrList_WebOrderNumber = Right(arrList_Etc2,14)

					'반품, 교환, 취소 여부
					CANCEL_STATUS = FN_CANCEL_STATUS(arrList_ReturnTF)

					PAY_WAYS = ""
					If arrList_InputCard		> 0 Then PAY_WAYS = PAY_WAYS & LNG_TEXT_ORDER_CARD &"<br />"
					If arrList_InputPassbook	> 0 Then PAY_WAYS = PAY_WAYS & LNG_TEXT_ORDER_BANK &"<br />"
					If arrList_InputPassbook_2	> 0 Then PAY_WAYS = PAY_WAYS & LNG_TEXT_VIRTUAL_ACCOUNT &"<br />"
					If arrList_InputCash		> 0 Then PAY_WAYS = PAY_WAYS & LNG_TEXT_ORDER_CASH &"<br />"

					PAY_POINTS = ""
					If arrList_InputMile		> 0 Then PAY_POINTS = PAY_POINTS & LNG_TEXT_POINT&"<br />"
					If arrList_InputMile_S		> 0 Then PAY_POINTS = PAY_POINTS & LNG_TEXT_POINT_S&"<br />"

					'MACCO
					'If arrList_CancelStatus = 1 Then
					'	TxtClass1 = "style=""color:red;text-decoration:line-through;font-size:8pt;"""
					'	If arrList_InsuranceNumber_Cancel = "Y" Then
					'		insuranceNumber = "<br /><span style=""text-decoration:none;font-size:8pt;"">취소상태</span>"
					'	Else
					'		insuranceNumber = "<br /><span style=""text-decoration:none;font-size:8pt;"">취소요청중</span>"
					'	End If
					'	OrderNumbers = "<span style=""text-decoration:line-through;font-size:8pt;"">"&arrList(1,i)&"</span><br /><span style=""text-decoration:none;font-size:8pt;"">반품등록<!-- 주문취소 --></span>"
					'Else
					'	TxtClass1 = ""
					'	insuranceNumber = ""
					'	OrderNumbers = arrList(1,i)
					'End If


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
										INS_Num_STATE = "<br /><span style=""text-decoration:none;font-size:8pt;"">취소상태</span>"
									Else
										TxtClass1 = ""
										insNums = arrList_InsuranceNumber
										INS_Num_STATE = "<br /><span style=""text-decoration:none;font-size:8pt;"">취소요청중</span>"
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
								INS_Num_STATE = "<br /><span style=""text-decoration:none;font-size:8pt;"">취소상태</span>"
								arrList_OrderNumber = "<span style=""text-decoration:line-through;"">"&arrList_OrderNumber&"</span>"
							End If
						Case Else
							insNums = arrList_InsuranceNumber
							INS_Num_STATE = ""
					End Select

					PRINT TABS(1) & "	<tr>"
					PRINT TABS(1) & "		<td>"&ThisNum&"</td>"
					PRINT TABS(1) & "		<td>"&date8to13(arrList_SellDate)&"</td>"
					PRINT TABS(1) & "		<td class="""">"&arrList_OrderNumber&"</td>"
					PRINT TABS(1) & "		<td ><span "&TxtClass1&">"&insNums&"</span>"&INS_Num_STATE&"</td>"
					PRINT TABS(1) & "		<td class=""inPrice"">"&num2cur(arrList_TotalPrice)&" "&Chg_CurrencyISO&"</td>"
					PRINT TABS(1) & "		<td class=""inPrice"">"&num2cur(arrList_TotalPV)&"</td>"

					PRINT TABS(1) & "		<td class=""tcenter"">"&PAY_WAYS&"</td>"
					'PRINT TABS(1) & "		<td class=""tcenter"">"&PAY_POINTS&"</td>"
					PRINT TABS(1) & "		<td>"&arrList_SellTypeName&" <br />"&arrList_Approval&"</td>"
					'PRINT TABS(1) & "		<td>"&CANCEL_STATUS&"</td>"
					PRINT TABS(1) & "		<td class=""tcenter"">"
					PRINT TABS(1) & "			<a name=""modal"" href=""order_list_detail.asp?ord="&arrList_OrderNumber&""" title="""&LNG_BTN_DETAIL&" ("&arrList_OrderNumber&")"">"
					PRINT TABS(1) & "				<input type=""button"" class=""detail_btn noline"" value="""&LNG_BTN_DETAIL&""" />"
					PRINT TABS(1) & "			</a>"
					PRINT TABS(1) & "		</td>"

					PRINT TABS(1) & "	</tr>"


					TOTAL_PRICE	   = TOTAL_PRICE	+ arrList_TotalPrice
					TOTAL_PV	   = TOTAL_PV		+ arrList_TotalPV
					TOTAL_CV	   = TOTAL_CV		+ arrList_TotalCV
				Next
		%>
			<!-- <tfoot>
				<th colspan="4" class="tcenter">총 합계</th>
				<td class="inprice tweight" ><%=num2cur(total_price)%></td>
				<td class="inprice tweight"><%=num2cur(total_pv)%></td>
				<td class=""></td>
				<td class=""></td>
				<td colspan="1"></td>
			</tfoot> -->
		<%
			Else
				PRINT TABS(1) & "		<tr>"
				PRINT TABS(1) & "			<td colspan=""9"" class=""notData"">"&LNG_CS_ORDER_LIST_TEXT22&"</td>"
				PRINT TABS(1) & "		</tr>"
			End If

		%>


	</table>
	<div class="pagingArea pagingNew3 userCWidth"><% Call pageListNew3(PAGE,PAGECOUNT)%></div>
</div>
<form name="frm" method="post" action="">
	<input type="hidden" name="PAGE" value="<%=PAGE%>" />
	<input type="hidden" name="SDATE" value="<%=SDATE%>" />
	<input type="hidden" name="EDATE" value="<%=EDATE%>" />
</form>

<%
	MODAL_CONTENT_WIDTH = 1000
	MODAL_CONTENT_HEIGHT = 700
	MODAL_OVERLAY_CLICK_CLOSE = "T"
%>
<!--#include virtual="/_include/modal_config.asp" -->
<!--#include virtual = "/_include/copyright.asp"-->
