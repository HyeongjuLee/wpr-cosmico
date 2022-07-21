<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	'dialog modal 상세보기 : 동일페이지정보

	PAGE_SETTING = "MYOFFICE"
	INFO_MODE	 = "BONUS1-2"

	ISLEFT = "T"
	ISSUBTOP = "T"

	Call ONLY_BUSINESS_MEMBER(DK_MEMBER_LEVEL,2)
	Call ONLY_CS_MEMBER()

	If UCase(DK_MEMBER_NATIONCODE) = "KR" And F_CPNO_CHANGE_TF = "T" Then
		Call ALERTS("올바른 주민번호가 입력되지 않았습니다. \n\n주민번호는 마이페이지에서 입력가능합니다.","GO","/mypage/member_info.asp") '수당발생 체크X
	End If

	SDATE		= pRequestTF("SDATE",False)
	EDATE		= pRequestTF("EDATE",False)
	DATE_CATE		= pRequestTF("DATE_CATE",False)
	PAGE		= pRequestTF("PAGE",False)
'	PAGESIZE	= pRequestTF("PAGESIZE",False)
	If PAGE = ""		Then PAGE = 1
	If PAGESIZE = ""	Then PAGESIZE = 10
	If SDATE = ""		Then SDATE = ""
	If EDATE = ""		Then EDATE = ""
	If DATE_CATE = "" Then DATE_CATE = "FromEndDate"	'시작일

	'1(보임), 0(안보임)
	If webproIP="T" Then
		My_OF_View_TF = 1
	Else
		My_OF_View_TF = 1
	End if

	'내역 리스트
	arrParams = Array(_
		Db.makeParam("@MBID1",adVarChar,adParamInput,20,DK_MEMBER_ID1),_
		Db.makeParam("@MBID2",adInteger,adParamInput,0,DK_MEMBER_ID2),_
		Db.makeParam("@PAGE",adInteger,adParamInput,0,PAGE),_
		Db.makeParam("@PAGESIZE",adInteger,adParamInput,0,PAGESIZE),_
		Db.makeParam("@SDATE",adVarChar,adParamInput,10,SDATE),_
		Db.makeParam("@EDATE",adVarChar,adParamInput,10,EDATE),_
		Db.makeParam("@DATE_CATE",adVarChar,adParamInput,20,DATE_CATE),_
		Db.makeParam("@My_OF_View_TF",adInteger,adParamInput,0,My_OF_View_TF),_
		Db.makeParam("@Na_Code",adVarChar,adParamInput,10,UCase(DK_MEMBER_NATIONCODE)),_
		Db.makeParam("@ALL_COUNT",adInteger,adParamOutput,0,0) _
	)
	arrList = Db.execRsList("HJPS_CS_PRICE02",DB_PROC,arrParams,listLen,DB3)
	ALL_COUNT = arrParams(UBound(arrParams))(4)

	Dim PAGECOUNT,CNT
	PAGECOUNT = Int((CCur(ALL_COUNT) - 1 ) / CInt(PAGESIZE) ) + 1
	IF CCur(PAGE) = 1 Then
		CNT = ALL_COUNT
	Else
		CNT = ALL_COUNT - ((CCur(PAGE)-1)*CInt(PAGESIZE))
	End If

	FIRSTEACHPAGE = ((CCur(PAGE-1))*CInt(PAGESIZE)) + 1

	payDetailPage = "pay02_detail.asp"
%>

<!--#include virtual = "/_include/document.asp"-->
<!-- <link rel="stylesheet" type="text/css" href="/myoffice/css/style_cs.css" /> -->
<!-- <link rel="stylesheet" type="text/css" href="/myoffice/css/layout_cs.css" /> -->
<!-- <link rel="stylesheet" type="text/css" href="/css/pay.css?v1.3" /> -->
<link rel="stylesheet" type="text/css" href="/css/pay2.css?" />
<script type="text/javascript" src="/jscript/calendar.js"></script>
<script type="text/javascript" src="pay.js?v1"></script>
<%'sortTable%>
<link rel="stylesheet" href="/jscript/tablesorter/jquery.wprTablesorter.css">
<script type="text/javascript" src="/jscript/tablesorter/jquery.wprTablesorter.js"></script>
<script type="text/javascript">
	$(document).ready(function() {
		$("#sortTable").wprTablesorter({
			firstColFix : true,	//첫번째열 고정
			//firstColasc : true,	//첫번째열 오름차순 여부	//firstColFix=true일 경우 필수값
			noSortColumns : [9]		//정렬안하는 컬럼
		});
	});
</script>
</head>
<body>
<!--#include virtual = "/_include/header.asp"-->
<div id="myoffice_pay" class="orderList pays">
	<form name="dateFrm" action="" method="post">
		<div class="search_form">
			<article class="date">
				<h6><%=LNG_TEXT_PAY_DEADLINE%></h6>
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
			</article>
			<article class="searchs">
				<div class="labels">
					<label class="checkbox"><input type="radio" name="DATE_CATE" value="FromEndDate" <%=isChecked(DATE_CATE,"FromEndDate")%> checked="checked"><span><i class="icon-ok"></i><%=LNG_TEXT_START_DATE%></span></label>
					<label class="checkbox"><input type="radio" name="DATE_CATE" value="ToEndDate" <%=isChecked(DATE_CATE,"ToEndDate")%>><span><i class="icon-ok"></i><%=LNG_TEXT_END_DATE%></span></label>
					<label class="checkbox"><input type="radio" name="DATE_CATE" value="PayDate" <%=isChecked(DATE_CATE,"PayDate")%>><span><i class="icon-ok"></i><%=LNG_TEXT_PAYMENT_DATE%></span></label>
				</div>
				<%'검색%>
				<input type="submit" value="<%=LNG_TEXT_SEARCH%>" class="search_btn" />
				<a href="<%=Request.ServerVariables("SCRIPT_NAME")%>" class="search_reset"><%=LNG_TEXT_INITIALIZATION%></a>
			</article>
		</div>
	</form>

	<%If IsArray(arrList) Then%>
	<%
		'합계내역
		CarrParams = Array(_
			Db.makeParam("@MBID1",adVarChar,adParamInput,20,DK_MEMBER_ID1),_
			Db.makeParam("@MBID2",adInteger,adParamInput,0,DK_MEMBER_ID2),_
			Db.makeParam("@SDATE",adVarChar,adParamInput,10,SDATE),_
			Db.makeParam("@EDATE",adVarChar,adParamInput,10,EDATE),_
			Db.makeParam("@DATE_CATE",adVarChar,adParamInput,20,DATE_CATE),_
			Db.makeParam("@My_OF_View_TF",adInteger,adParamInput,0,My_OF_View_TF),_
			Db.makeParam("@Na_Code",adVarChar,adParamInput,10,UCase(DK_MEMBER_NATIONCODE)) _
		)
		Set HJRSC = Db.execRs("HJPS_CS_PRICE02_ALL_TOTAL",DB_PROC,CarrParams,DB3)
		If Not HJRSC.BOF And Not HJRSC.EOF Then
			SUM_SumAllAllowance = HJRSC(0)
			SUM_InComeTax       = HJRSC(1)
			SUM_ResidentTax     = HJRSC(2)
			SUM_TruePayment     = HJRSC(3)
			SUM_Cur_DedCut_Pay	= HJRSC(11)

			SUM_VAT	= SUM_SumAllAllowance - SUM_InComeTax	'부가세 = 지급기준액 - 공급가

		Else
			SUM_SumAllAllowance = 0
			SUM_InComeTax       = 0
			SUM_ResidentTax     = 0
			SUM_TruePayment     = 0
			SUM_Cur_DedCut_Pay	= 0

			SUM_VAT             = 0
		End If
		Call closeRS(HJRSC)
	%>
	<p class="titles"><%=LNG_TEXT_TOTAL%></p>
	<div class="sum_totalWrap ">
		<table <%=tableatt%> class="total">
			<col span="5" width="20%" />
			<thead>
				<tr>
					<th><%=LNG_TEXT_SUM_ALLOWANCE%></th>
					<th><%=LNG_TEXT_RETURN_DEDUCT%></th>
					<th><%=LNG_TEXT_INCOME_TEX%></th>
					<th><%=LNG_TEXT_RESIDENT_TEX%></th>
					<th><%=LNG_TEXT_ACTUAL_PAYMENT%></th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<td class="inPrice"><%=num2cur(SUM_SumAllAllowance)%></td>
					<td class="inPrice"><%=num2cur(SUM_Cur_DedCut_Pay)%></td>
					<td class="inPrice"><%=num2cur(SUM_InComeTax)%></td>
					<td class="inPrice"><%=num2cur(SUM_ResidentTax)%></td>
					<td class="inPrice"><%=num2cur(SUM_TruePayment)%></td>
				</tr>
			</tbody>
		</table>
	</div>
	<%End If%>

	<p class="titles"><%=LNG_TEXT_DETAIL_LIST%></p>
	<table id="sortTable" <%=tableatt%> class="table">
		<thead>
			<tr class="fixedTR">
				<th><%=LNG_TEXT_NUMBER%></th>
				<th><%=LNG_TEXT_START_DATE%></th>
				<th><%=LNG_TEXT_END_DATE%></th>
				<th><%=LNG_TEXT_PAYMENT_DATE%></th>
				<th><%=LNG_TEXT_SUM_ALLOWANCE%></th>
				<th><%=LNG_TEXT_RETURN_DEDUCT%></th>
				<th><%=LNG_TEXT_INCOME_TEX%></th>
				<th><%=LNG_TEXT_RESIDENT_TEX%></th>
				<th><%=LNG_TEXT_ACTUAL_PAYMENT%></th>
				<!-- <th><%=LNG_BTN_DETAIL%></th> -->
				<th class="remarks"><%=LNG_TEXT_REMARKS%></th>
			</tr>
		</thead>
		<tbody>
		<%
			If IsArray(arrList) Then
				For i = 0 To listLen
					ThisNum = CInt(arrList(0,i))
					arrList_fromenddate			= arrList(1,i)
					arrList_toenddate			= arrList(2,i)
					arrList_paydate				= arrList(3,i)
					arrList_sumallallowance		= arrList(4,i)
					arrList_incomeTax			= arrList(5,i)
					arrList_residentTax			= arrList(6,i)
					arrList_truepayMent			= arrList(7,i)

					arrList_Cur_DedCut_Pay		= arrList(18,i)

					Sumallallowance_NOT_DED = arrList_sumallallowance + arrList_Cur_DedCut_Pay
		%>
			<tr class="fixedTR">
				<td class="tcenter first"><%=ThisNum%></td>
				<td class="tcenter"><%=date8to13(arrList_fromenddate)%></td>
				<td class="tcenter"><%=date8to13(arrList_toenddate)%></td>
				<td class="tcenter"><%=date8to13(arrList_paydate)%></td>
				<td class="inPrice"><%=num2cur(Sumallallowance_NOT_DED)%></td>
				<td class="inPrice"><%=num2cur(arrList_Cur_DedCut_Pay)%></td>
				<td class="inPrice"><%=num2cur(arrList_incomeTax)%></td>
				<td class="inPrice"><%=num2cur(arrList_residentTax)%></td>
				<td class="inPrice tweight"><%=num2cur(arrList_truepayMent)%></td>
				<td class="tcenter"><button class="dialog-layer-opener detail_btn noline" data-openerid="#dialog-layer<%=i%>"><%=LNG_BTN_DETAIL%></button></td>
			</tr>
		<%
				Next
			Else
		%>
			<tr>
				<td colspan="10" class="nodata" ><%=LNG_CS_PAY_TEXT28%></td>
			</tr>
		<%End If%>
		</tbody>
	</table>

	<%'modal dialog-layer 상세보기 S%>
	<%
		If IsArray(arrList) Then
			For i = 0 To listLen
				ThisNum = CInt(arrList(0,i))
				arrList_fromenddate			= arrList(1,i)
				arrList_toenddate			= arrList(2,i)
				arrList_paydate				= arrList(3,i)
				arrList_sumallallowance		= arrList(4,i)
				arrList_incomeTax			= arrList(5,i)
				arrList_residentTax			= arrList(6,i)
				arrList_truepayMent			= arrList(7,i)
				arrList_Allowance1			= arrList(8,i)
				arrList_Allowance2			= arrList(9,i)
				arrList_Allowance3			= arrList(10,i)
				arrList_Allowance4			= arrList(11,i)
				arrList_Allowance5			= arrList(12,i)
				arrList_Allowance6			= arrList(13,i)
				arrList_Allowance7			= arrList(14,i)
				arrList_Allowance8			= arrList(15,i)
				arrList_Allowance9			= arrList(16,i)
				arrList_Allowance10			= arrList(17,i)
				arrList_Cur_DedCut_Pay		= arrList(18,i)

				Sumallallowance_NOT_DED = arrList_sumallallowance + arrList_Cur_DedCut_Pay

				dialog_title = LNG_BTN_DETAIL &" ("&date8to13(arrList_fromenddate)&" ~ "&date8to13(arrList_toenddate)&")"
	%>
	<div class="dialog-layer" id="dialog-layer<%=i%>" title="<%=dialog_title%>" style="display: none; overflow-y: auto;">

		<%If 1=2 Then%>
			<div class="cleft pay_totals">
				<table <%=tableatt%> class="totals_table">
					<colgroup>
						<col span="6" width="" />
					</colgroup>
					<thead>
						<tr>
							<th><%=LNG_TEXT_START_DATE%></th>
							<th><%=LNG_TEXT_END_DATE%></th>
							<th><%=LNG_TEXT_PAYMENT_DATE%></th>
							<th><%=LNG_TEXT_INCOME_TEX%></th>
							<th><%=LNG_TEXT_RESIDENT_TEX%></th>
							<th><%=LNG_TEXT_ACTUAL_PAYMENT%></th>
						</tr>
					</thead>
					<tr>
						<td class="tcenter"><%=date8to13(arrList_FromEndDate)%></td>
						<td class="tcenter"><%=date8to13(arrList_ToEndDate)%></td>
						<td class="tcenter"><%=date8to13(arrList_PayDate)%></td>
						<td class="inPrice"><%=num2cur(arrList_InComeTax)%></td>
						<td class="inPrice"><%=num2cur(arrList_ResidentTax)%></td>
						<td class="inPrice tweight thisNum<%=ThisNum%>" attr="<%=ThisNum%>"><%=num2cur(arrList_TruePayment)%></td>
					</tr>
				</table>
			</div>
			<div class="cleft pay_totals">
				<p class="titles tleft"><%=LNG_TEXT_TOTAL_SALES_OF_UNDER_MEMBER%></p>
				<table <%=tableatt%> class="totals_table">
					<col width="10%" />
					<col width="17%" />
					<col width="17%" />
					<col width="17%" />
					<col width="17%" />
					<col width="17%" />
					<thead>
						<tr>
							<th><%=LNG_TEXT_PAY_CATEGORY%></th>
							<th><%=LNG_TEXT_PAY_PREVIOUS%></th>
							<th><%=LNG_TEXT_PAY_DEADLINE%></th>
							<th><%=LNG_TEXT_PAY_DEDUCTIONS%></th>
							<th><%=LNG_TEXT_PAY_BALANCE%></th>
							<th><%=LNG_TEXT_PAY_CARRIED_FORWARD%></th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<th><%=LNG_TEXT_PAY_LINE1%></th>
							<td><%=num2cur(arrList_Be_PV_1)%></td>
							<td><%=num2cur(arrList_Cur_PV_1)%></td>
							<td><%=num2cur(arrList_Ded_1)%></td>
							<td><%=num2cur(arrList_Fresh_1)%></td>
							<td><%=num2cur(arrList_Sum_PV_1)%></td>
						</tr><tr>
							<th><%=LNG_TEXT_PAY_LINE2%></th>
							<td><%=num2cur(arrList_Be_PV_2)%></td>
							<td><%=num2cur(arrList_Cur_PV_2)%></td>
							<td><%=num2cur(arrList_Ded_2)%></td>
							<td><%=num2cur(arrList_Fresh_2)%></td>
							<td><%=num2cur(arrList_Sum_PV_2)%></td>
						</tr>
					</tbody>
				</table>
			</div>
		<%End If%>

		<%
			No_pay_detail = "F"
			pay_detail_left_width = ""
			IF No_pay_detail = "T" Then
				pay_detail_left_width = "width: 100%;"
			End If
		%>
		<div class="pay_detail_both">
			<div class="cpay_detail left" style="<%=pay_detail_left_width%>">
				<p class="titles tleft"><%=LNG_TEXT_PAY_ALLOWANCE_LIST%></p>
				<table <%=tableatt%>  class="pay_detail_table">
					<col width="150" />
					<col width="*" />
					<col width="90" />
					<!-- <thead>
						<tr>
							<th colspan="3" class="tcenter"><%=LNG_TEXT_PAY_ALLOWANCE_LIST%></th>
						</tr>
					</thead> -->
					<tbody>
						<tr>
							<th><%=LNG_TEXT_PAY_BONUS02_1%></th>
							<td class="inPrice"><%=num2cur(arrList_Allowance1)%></td>
							<td class="tcenter">
								<a href="javascript:pay_ajax_view('1','<%=arrList_toenddate%>','pay_detail<%=i%>','1','<%=payDetailPage%>')" onfocus="this.blur();" class="detail_btn"><%=LNG_BTN_DETAIL%></a>
							</td>
						</tr>
						<tr>
							<th><%=LNG_TEXT_PAY_BONUS02_2%></th>
							<td class="inPrice"><%=num2cur(arrList_Allowance2)%></td>
							<td class="tcenter">
								<a href="javascript:pay_ajax_view('2','<%=arrList_toenddate%>','pay_detail<%=i%>','1','<%=payDetailPage%>')" onfocus="this.blur();" class="detail_btn"><%=LNG_BTN_DETAIL%></a>
							</td>
						</tr>
						</tr>
						<tr>
							<th><%=LNG_TEXT_PAY_BONUS02_3%></th>
							<td class="inPrice"><%=num2cur(arrList_Allowance3)%></td>
							<td class="tcenter">
								<a href="javascript:pay_ajax_view('3','<%=arrList_toenddate%>','pay_detail<%=i%>','1','<%=payDetailPage%>')" onfocus="this.blur();" class="detail_btn"><%=LNG_BTN_DETAIL%></a>
							</td>
						</tr>
						<%If 1=2 Then%>
						<tr>
							<th><%=LNG_TEXT_PAY_BONUS02_4%></th>
							<td class="inPrice"><%=num2cur(arrList_Allowance4)%></td>
							<td class="tcenter">
								<!-- <a href="javascript:pay_ajax_view('4','<%=arrList_toenddate%>','pay_detail<%=i%>','1','<%=payDetailPage%>')" onfocus="this.blur();" class="detail_btn"><%=LNG_BTN_DETAIL%></a> -->
							</td>
						</tr>
						<tr>
							<th><%=LNG_TEXT_PAY_BONUS02_5%></th>
							<td class="inPrice"><%=num2cur(arrList_Allowance5)%></td>
							<td class="tcenter">
								<!-- <a href="javascript:pay_ajax_view('5','<%=arrList_toenddate%>','pay_detail<%=i%>','1','<%=payDetailPage%>')" onfocus="this.blur();" class="detail_btn"><%=LNG_BTN_DETAIL%></a> -->
							</td>
						</tr>
						<tr>
							<th><%=LNG_TEXT_PAY_BONUS02_6%></th>
							<td class="inPrice"><%=num2cur(arrList_Allowance6)%></td>
							<td class="tcenter">
								<!-- <a href="javascript:pay_ajax_view('6','<%=arrList_toenddate%>','pay_detail<%=i%>','1','<%=payDetailPage%>')" onfocus="this.blur();" class="detail_btn"><%=LNG_BTN_DETAIL%></a> -->
							</td>
						</tr>
						<tr>
							<th><%=LNG_TEXT_PAY_BONUS02_7%></th>
							<td class="inPrice"><%=num2cur(arrList_Allowance7)%></td>
							<td class="tcenter">
								<!-- <a href="javascript:pay_ajax_view('7','<%=arrList_toenddate%>','pay_detail<%=i%>','1','<%=payDetailPage%>')" onfocus="this.blur();" class="detail_btn"><%=LNG_BTN_DETAIL%></a> -->
							</td>
						</tr>
						<tr>
							<th><%=LNG_TEXT_PAY_BONUS02_8%></th>
							<td class="inPrice"><%=num2cur(arrList_Allowance8)%></td>
							<td class="tcenter">
								<!-- <a href="javascript:pay_ajax_view('8','<%=arrList_toenddate%>','pay_detail<%=i%>','1','<%=payDetailPage%>')" onfocus="this.blur();" class="detail_btn"><%=LNG_BTN_DETAIL%></a> -->
							</td>
						</tr>
						<tr>
							<th><%=LNG_TEXT_PAY_BONUS02_9%></th>
							<td class="inPrice"><%=num2cur(arrList_Allowance9)%></td>
							<td class="tcenter">
								<!-- <a href="javascript:pay_ajax_view('9','<%=arrList_toenddate%>','pay_detail<%=i%>','1','<%=payDetailPage%>')" onfocus="this.blur();" class="detail_btn"><%=LNG_BTN_DETAIL%></a> -->
							</td>
						</tr>
						<tr>
							<th><%=LNG_TEXT_PAY_BONUS02_10%></th>
							<td class="inPrice"><%=num2cur(arrList_Allowance10)%></td>
							<td class="tcenter">
								<!-- <a href="javascript:pay_ajax_view('10','<%=arrList_toenddate%>','pay_detail<%=i%>','1','<%=payDetailPage%>')" onfocus="this.blur();" class="detail_btn"><%=LNG_BTN_DETAIL%></a> -->
							</td>
						</tr>
						<%End If%>
						<tr class="plus">
							<th><%=LNG_TEXT_SUM_ALLOWANCE%></th>
							<td class="inPrice"><%=num2cur(Sumallallowance_NOT_DED)%></td>
							<td></td>
						</tr>
						<tr class="minus">
							<th><%=LNG_TEXT_INCOME_TEX%></th>
							<td class="inPrice"><%=num2cur(arrList_incomeTax)%></td>
							<td></td>
						</tr>
						<tr class="minus">
							<th><%=LNG_TEXT_RESIDENT_TEX%></th>
							<td class="inPrice"><%=num2cur(arrList_residentTax)%></td>
							<td></td>
						</tr>
						<tr class="plus">
							<th><%=LNG_TEXT_ACTUAL_PAYMENT%></th>
							<td class="inPrice"><%=num2cur(arrList_truepayMent)%></td>
							<td></td>
						</tr>
					</tbody>
				</table>
			</div>
			<%IF No_pay_detail <> "T" Then%>
			<div class="pay_detail right" id="pay_detail<%=i%>" >
				<p class="titles tleft"><%=LNG_TEXT_PAY_ALLOWANCE_DETAILS%></p>
				<table <%=tableatt%> class="pay_detail_table">
					<tr>
						<td class="nodata"><p style="min-height:215px;"><%=LNG_CS_PAY_TEXT27%></p></td>
					</tr>
				</table>
			</div>
			<%End If%>

		</div>
		<%
				Next
			End If
		%>
	</div>
	</div>
	<%'modal dialog-layer 상세보기 E%>
</div>

<div class="pagingArea pagingNew3">
	<% Call pageListNew3(PAGE,PAGECOUNT)%>dd
	<form name="frm" method="post" action="">
		<input type="hidden" name="PAGE" value="<%=PAGE%>" />
		<input type="hidden" name="PAGESIZE" value="<%=PAGESIZE%>" />
		<input type="hidden" name="SDATE" value="<%=SDATE%>" />
		<input type="hidden" name="EDATE" value="<%=EDATE%>" />
		<input type="hidden" name="DATE_CATE" value="<%=DATE_CATE%>" />
	</form>
</div>
</div>
</div>

<%
	IF No_pay_detail = "T" Then
		MODAL_CONTENT_WIDTH	= 500
	Else
		MODAL_CONTENT_WIDTH	= 1000
	End If
	MODAL_CONTENT_HEIGHT	= 650
	MODAL_OVERLAY_CLICK_CLOSE = "T"
	MODAL_NO_CLOSE_BUTTON = "T"
%>
<!--#include virtual="/_include/modal_config.asp" -->
</div>
<!--#include virtual = "/_include/copyright.asp"-->