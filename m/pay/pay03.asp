<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	'dialog modal 상세보기 : 동일페이지정보

	PAGE_SETTING = "MYOFFICE"
	INFO_MODE	 = "BONUS1-3"

	ISSUBTOP = "T"


	Call ONLY_BUSINESS_MEMBER(DK_MEMBER_LEVEL,2)
	Call ONLY_CS_MEMBER()

	If UCase(DK_MEMBER_NATIONCODE) = "KR" And F_CPNO_CHANGE_TF = "T" Then
		'Call ALERTS("올바른 주민번호가 입력되지 않았습니다. \n\n주민번호는 마이페이지에서 입력가능합니다.","GO","/m/mypage/member_info.asp") '수당발생 체크X
	End If


	SDATE		= pRequestTF("SDATE",False)
	EDATE		= pRequestTF("EDATE",False)
	DATE_CATE		= pRequestTF("DATE_CATE",False)
	PAGE		= pRequestTF("PAGE",False)
'	PAGESIZE	= pRequestTF("PAGESIZE",False)
	If PAGE = ""		Then PAGE = 1
	If PAGESIZE = ""	Then PAGESIZE = 20
	If SDATE = ""		Then SDATE = ""
	If EDATE = ""		Then EDATE = ""
	If DATE_CATE = "" Then DATE_CATE = "FromEndDate"	'시작일

	'1(보임), 0(안보임)
	If webproIP="T" Then
		My_OF_View_TF = 0
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
	arrList = Db.execRsList("HJPS_CS_PRICE03",DB_PROC,arrParams,listLen,DB3)
	ALL_COUNT = arrParams(UBound(arrParams))(4)

	Dim PAGECOUNT,CNT
	PAGECOUNT = Int((CCur(ALL_COUNT) - 1 ) / CInt(PAGESIZE) ) + 1
	IF CCur(PAGE) = 1 Then
		CNT = ALL_COUNT
	Else
		CNT = ALL_COUNT - ((CCur(PAGE)-1)*CInt(PAGESIZE))
	End If

	payDetailPage = "pay03_detail.asp"
%>
<!--#include virtual = "/m/_include/document.asp"-->
<!--#include virtual = "/m/_include/jqueryload.asp"-->
<script type="text/javascript" src="/m/js/calendar.js"></script>
<script type="text/javascript" src="pay.js?v1"></script>
<script type="text/javascript">
	$(document).ready(function() {
	//	fixedTable(0,1); //컬럼고정
	});
</script>
<link rel="stylesheet" href="/m/css/pay.css?v0" />
</head>
<body>
<!--#include virtual = "/m/_include/header.asp"-->
<div class="orderList">

	<form name="dateFrm" action="" method="post">
		<div class="search_form vertical">
			<article>
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
					<button type="button" onclick="chgDate('','');"><%=LNG_TEXT_ALL%></button>
				</div>
			</article>
			<article class="table" id="filter" style="display: none;">
				<!-- <h6><%=LNG_TEXT_DATE_SEARCH%></h6> -->
				<div class="level">
					<select id="DATE_CATE" name="DATE_CATE" class="vmiddle input_select">
						<option value="FromEndDate"  <%=isSelect("FromEndDate",DATE_CATE)%> selected="selected" ><%=LNG_TEXT_START_DATE%></option>
						<option value="ToEndDate"  <%=isSelect("ToEndDate",DATE_CATE)%>><%=LNG_TEXT_END_DATE%></option>
						<option value="PayDate"  <%=isSelect("PayDate",DATE_CATE)%>><%=LNG_TEXT_PAYMENT_DATE%></option>
					</select>
				</div>
				<%'검색%>
			</article>
			<article class="table">
				<div class="search">
					<input type="submit" class="search_btn" value="<%=LNG_TEXT_SEARCH%>"/>
					<div class="icon-ccw-1 search_reset" onclick="location.replace(location.href);"/></div>
					<div class="icon-cog search_filter" onclick="toggle_filter('filter');"/></div>
				</div>
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
			Set HJRSC = Db.execRs("HJPS_CS_PRICE03_ALL_TOTAL",DB_PROC,CarrParams,DB3)
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
	<div class="" style="overflow: auto;">
		<table <%=tableatt%> class="width100 board1">
			<col span="5" width="20%" />
			<thead>
				<tr class="">
					<th><%=LNG_TEXT_SUM_ALLOWANCE%></th>
					<th><%=LNG_TEXT_RETURN_DEDUCT%></th>
					<th><%=LNG_TEXT_INCOME_TEX%></th>
					<th><%=LNG_TEXT_RESIDENT_TEX%></th>
					<th><%=LNG_TEXT_ACTUAL_PAYMENT%></th>
				</tr>
			</thead>
			<tbody>
				<tr class="">
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
	<table <%=tableatt%> class="width100 board">
		<col width="38%" />
		<col width="38%" />
		<col width="24%" />
		<thead>
			<tr>
				<th><%=LNG_TEXT_PAYMENT_DATE%></th>
				<th><%=LNG_TEXT_ACTUAL_PAYMENT%></th>
				<th><%=LNG_BTN_DETAIL%></th>
			</tr>
		</thead>
		<tbody>
		<%
			If IsArray(arrList) Then
				For i = 0 To listLen
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
			<tr onclick="">
				<td class="tcenter"><%=date8to13(arrList_paydate)%></td>
				<td class="tright tweight"><%=num2cur(arrList_truepayMent)%></td>
				<td><button class="dialog-layer-opener detail_btn noline" data-openerid="#dialog-layer<%=i%>"><%=LNG_TEXT_CONFIRM%></button></td>
			</tr>
		<%
				Next
			Else
		%>
		<tr>
			<td colspan="3" class="tcenter" style="height:90px;"><%=LNG_CS_PAY_TEXT28%></td>
		</tr>
		<%
			End If
		%>
		</tbody>
	</table>

	<%'modal dialog-layer 상세보기 S%>
	<%
		If IsArray(arrList) Then
			For i = 0 To listLen
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

				dialog_title = LNG_BTN_DETAIL '&"("&date8to11(arrList_fromenddate)&" ~ "&date8to11(arrList_toenddate)&")"
	%>
	<div class="dialog-layer orderList" id="dialog-layer<%=i%>" title="<%=dialog_title%>" style="display: none; overflow-y: auto;">

		<div class="htbody" style="background: #fff;">
			<!-- <p class="titles"><%=LNG_TEXT_PAY_ALLOWANCE_LIST%><%=vbTab%>(<%=date8to13(arrList_fromenddate)%> ~<%=date8to13(arrList_toenddate)%>)</p> -->
			<table class="table1 width100">
				<col width="32%" />
				<col width="34%" />
				<col width="34%" />
				<tbody>
					<tr class="plus">
						<th><%=LNG_TEXT_START_DATE%></th>
						<th><%=LNG_TEXT_END_DATE%></th>
						<th><%=LNG_TEXT_PAYMENT_DATE%></th>
					</tr>
					<tr>
						<td class="tcenter"><%=date8to13(arrList_FromEndDate)%></td>
						<td class="tcenter"><%=date8to13(arrList_ToEndDate)%></td>
						<td class="tcenter"><%=date8to13(arrList_PayDate)%></td>
					</tr>
				</tbody>
			</table>
			<%If 1=222 Then%>
			<table class="table1 width100">
				<col width="32%" />
				<col width="34%" />
				<col width="34%" />
				<tbody>
					<!-- <tr class="plus">
						<th colspan="3" class=""><%=LNG_TEXT_TOTAL_SALES_OF_UNDER_MEMBER%></th>
					</tr> -->
					<tr>
						<th><%=LNG_TEXT_PAY_CATEGORY%></th>
						<th><%=LNG_TEXT_PAY_LINE1%></th>
						<th><%=LNG_TEXT_PAY_LINE2%></th>
					</tr><tr>
						<th><%=LNG_TEXT_PAY_PREVIOUS%></th>
						<td><%=num2cur(arrList_Be_PV_1)%></td>
						<td><%=num2cur(arrList_Be_PV_2)%></td>
					</tr><tr>
						<th><%=LNG_TEXT_PAY_DEADLINE%></th>
						<td><%=num2cur(arrList_Cur_PV_1)%></td>
						<td><%=num2cur(arrList_Cur_PV_2)%></td>
					</tr><tr>
						<th><%=LNG_TEXT_PAY_DEDUCTIONS%></th>
						<td><%=num2cur(arrList_Ded_1)%></td>
						<td><%=num2cur(arrList_Ded_2)%></td>
					</tr><!-- <tr>
						<th><%=LNG_TEXT_PAY_BALANCE%></th>
						<td><%=num2cur(arrList_Fresh_1)%></td>
						<td><%=num2cur(arrList_Fresh_2)%></td>
					</tr> --><tr>
						<th><%=LNG_TEXT_PAY_CARRIED_FORWARD%></th>
						<td><%=num2cur(arrList_Sum_PV_1)%></td>
						<td><%=num2cur(arrList_Sum_PV_2)%></td>
					</tr>
				</tbody>
			</table>
			<%End If%>
			<p class="titles"><%=LNG_TEXT_PAY_ALLOWANCE_LIST%></p>
			<table class="table1 width100">
				<tbody>
					<!-- <tr>
						<th colspan="3" class=""><%=LNG_TEXT_PAY_ALLOWANCE_LIST%></th>
					</tr> -->
					<tr>
						<th><%=LNG_TEXT_PAY_BONUS03_1%></th>
						<td class="tright"><%=num2cur(arrList_Allowance1)%></td>
						<td class="tcenter">
							<!-- <a class="detail_btn noline"  href="javascript:pay_ajax_view('1','<%=arrList_toenddate%>','pay_detail<%=i%>','1','<%=payDetailPage%>')" ><%=LNG_BTN_DETAIL%></a> -->
						</td>
					</tr>
					<tr>
						<th><%=LNG_TEXT_PAY_BONUS03_2%></th>
						<td class="tright"><%=num2cur(arrList_Allowance2)%></td>
						<td class="tcenter">
							<!-- <a class="detail_btn noline"  href="javascript:pay_ajax_view('2','<%=arrList_toenddate%>','pay_detail<%=i%>','1','<%=payDetailPage%>')" ><%=LNG_BTN_DETAIL%></a> -->
						</td>
					</tr>
					<tr>
						<th><%=LNG_TEXT_PAY_BONUS03_3%></th>
						<td class="tright"><%=num2cur(arrList_Allowance3)%></td>
						<td class="tcenter">
							<!-- <a class="detail_btn noline"  href="javascript:pay_ajax_view('3','<%=arrList_toenddate%>','pay_detail<%=i%>','1','<%=payDetailPage%>')" ><%=LNG_BTN_DETAIL%></a> -->
						</td>
					</tr>
					<%If 1=22 Then%>
					<tr>
						<th><%=LNG_TEXT_PAY_BONUS03_4%></th>
						<td class="tright"><%=num2cur(arrList_Allowance4)%></td>
						<td class="tcenter">
							<!-- <a class="detail_btn noline"  href="javascript:pay_ajax_view('4','<%=arrList_toenddate%>','pay_detail<%=i%>','1','<%=payDetailPage%>')" ><%=LNG_BTN_DETAIL%></a> -->
						</td>
					</tr>
					<tr>
						<th><%=LNG_TEXT_PAY_BONUS03_5%></th>
						<td class="tright"><%=num2cur(arrList_Allowance5)%></td>
						<td class="tcenter">
							<!-- <a class="detail_btn noline"  href="javascript:pay_ajax_view('5','<%=arrList_toenddate%>','pay_detail<%=i%>','1','<%=payDetailPage%>')" ><%=LNG_BTN_DETAIL%></a> -->
						</td>
					</tr>
					<tr>
						<th><%=LNG_TEXT_PAY_BONUS03_6%></th>
						<td class="tright"><%=num2cur(arrList_Allowance6)%></td>
						<td class="tcenter">
							<!-- <a class="detail_btn noline"  href="javascript:pay_ajax_view('6','<%=arrList_toenddate%>','pay_detail<%=i%>','1','<%=payDetailPage%>')" ><%=LNG_BTN_DETAIL%></a> -->
						</td>
					</tr>
					<tr>
						<th><%=LNG_TEXT_PAY_BONUS03_7%></th>
						<td class="tright"><%=num2cur(arrList_Allowance7)%></td>
						<td class="tcenter">
							<!-- <a class="detail_btn noline"  href="javascript:pay_ajax_view('7','<%=arrList_toenddate%>','pay_detail<%=i%>','1','<%=payDetailPage%>')" ><%=LNG_BTN_DETAIL%></a> -->
						</td>
					</tr>
					<tr>
						<th><%=LNG_TEXT_PAY_BONUS03_8%></th>
						<td class="tright"><%=num2cur(arrList_Allowance8)%></td>
						<td class="tcenter">
							<!-- <a class="detail_btn noline"  href="javascript:pay_ajax_view('8','<%=arrList_toenddate%>','pay_detail<%=i%>','1','<%=payDetailPage%>')" ><%=LNG_BTN_DETAIL%></a> -->
						</td>
					</tr>
					<tr>
						<th><%=LNG_TEXT_PAY_BONUS03_9%></th>
						<td class="tright"><%=num2cur(arrList_Allowance9)%></td>
						<td class="tcenter">
							<!-- <a class="detail_btn noline"  href="javascript:pay_ajax_view('9','<%=arrList_toenddate%>','pay_detail<%=i%>','1','<%=payDetailPage%>')" ><%=LNG_BTN_DETAIL%></a> -->
						</td>
					</tr>
					<tr>
						<th><%=LNG_TEXT_PAY_BONUS03_10%></th>
						<td class="tright"><%=num2cur(arrList_Allowance10)%></td>
						<td class="tcenter">
							<!-- <a class="detail_btn noline"  href="javascript:pay_ajax_view('10','<%=arrList_toenddate%>','pay_detail<%=i%>','1','<%=payDetailPage%>')" ><%=LNG_BTN_DETAIL%></a> -->
						</td>
					</tr>
					<%End If%>
					<tr class="plus">
						<th><%=LNG_TEXT_SUM_ALLOWANCE%></th>
						<td class="tweight tright"><%=num2cur(Sumallallowance_NOT_DED)%></td>
						<td class="tcenter"></td>
					</tr>
					<!-- <tr class="plus">
						<th><%=LNG_TEXT_SUM_ALLOWANCE_EXRATE%></th>
						<td class="tright"><%=num2cur(arrList_SumAllAllowance_KR)%></td>
						<td class="tcenter"></td>
					</tr> -->
					<tr class="minus">
						<th><%=LNG_TEXT_RETURN_DEDUCT%></th>
						<td class="tright"><%=num2cur(arrList_Cur_DedCut_Pay)%></td>
						<td class="tcenter"></td>
					</tr>
					<!-- <tr class="plus">
						<th><%=LNG_TEXT_TOTAL_SUM_ALLOWANCE_AFTER_DEDUCTION%>공제후수당합계</th>
						<td class="tweight tright"><%=num2cur(arrList_sumallallowance)%></td>
						<td class="tcenter"></td>
					</tr> -->
					<tr class="minus">
						<th><%=LNG_TEXT_INCOME_TEX%></th>
						<td class="tright"><%=num2cur(arrList_incomeTax)%></td>
						<td class="tcenter"></td>
					</tr>
					<tr class="minus">
						<th><%=LNG_TEXT_RESIDENT_TEX%></th>
						<td class="tright"><%=num2cur(arrList_residentTax)%></td>
						<td class="tcenter"></td>
					</tr>
					<tr class="plus">
						<th><%=LNG_TEXT_ACTUAL_PAYMENT%></th>
						<td class="tweight tright"><%=num2cur(arrList_truepayMent)%></td>
						<td class="tcenter"></td>
					</tr>
				</tbody>
			</table>

			<div class="payment_blocker"></div>
			<div class="payment_detail">
				<!-- <div id="payment_detail_body"></div> -->
				<div id="payment_detail_body_pay_detail<%=i%>"></div>
				<div id="loading" style="position: fixed; z-index: 99999; width: 100%; height: 100%; top: 0px; left: 0px; background: url(/images_kr/loading_bg70.png) 0 0 repeat; display: none; ">
					<div class="loadingImg" style="position: relative; top: 40%; text-align: center;"><img src="<%=IMG%>/159.gif" width="40" alt="loadingImg" /></div>
				</div>
			</div>

		</div>

	</div>
	<%
			Next
		End If
	%>
	<%'modal dialog-layer 상세보기 E%>

	<div class="paging_area pagingNew3">
		<%Call pageListMob5(PAGE,PAGECOUNT)%>
		<form name="frm" method="post" action="">
			<input type="hidden" name="PAGE" value="<%=PAGE%>" />
			<input type="hidden" name="PAGESIZE" value="<%=PAGESIZE%>" />
			<input type="hidden" name="SDATE" value="<%=SDATE%>" />
			<input type="hidden" name="EDATE" value="<%=EDATE%>" />
		</form>
	</div>
</div>

<!--#include virtual="/m/_include/modal_config.asp" -->
<!--#include virtual = "/m/_include/copyright.asp"-->
