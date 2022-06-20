<!--#include virtual = "/_lib/strFunc.asp"-->
<!--#include virtual = "/MyOffice\point\_point_Config.asp"-->
<%
	PAGE_SETTING = "MYOFFICE"
	'PAGE_SETTING = "MY_POINT"

	ISSUBTOP = "T"
	ISSCROLL = "T"


	Call ONLY_CS_MEMBER()							'판매원만
	Call ONLY_BUSINESS_MEMBER(DK_MEMBER_LEVEL,2)


	mn = gRequestTF("mn", False)
	'마일리지123 분기 / 치환  =============================================S
	Select Case mn
		Case "1"		'mileage
			INFO_MODE	 = "POINT1-1"
			SHOP_POINT = SHOP_POINT
			PLUS_TOTAL_MILEAGE 	= PLUS_TOTAL_MILEAGE
			MINUS_TOTAL_MILEAGE = MINUS_TOTAL_MILEAGE
			MILEAGE_TOTAL 			= MILEAGE_TOTAL
			PLUS_TOTAL_MILEAGE_NOTAVAIL = PLUS_TOTAL_MILEAGE_NOTAVAIL
			PROC_CS_POINT_KIND = "HJPS_CS_POINT_KIND"
			TRANSFER_VIEW = False
			WITHDRAW_VIEW = True

		Case "2"		'Bo
			Call Alerts(LNG_ALERT_WRONG_ACCESS,"BACK","")
			INFO_MODE	 = "POINT2-1"
			SHOP_POINT = SHOP_POINT2
			PLUS_TOTAL_MILEAGE 	= PLUS_TOTAL_MILEAGE2
			MINUS_TOTAL_MILEAGE = MINUS_TOTAL_MILEAGE2
			MILEAGE_TOTAL 			= MILEAGE2_TOTAL
			PLUS_TOTAL_MILEAGE_NOTAVAIL = PLUS_TOTAL_MILEAGE2_NOTAVAIL
			PROC_CS_POINT_KIND = "HJPS_CS_POINT2_KIND"
			TRANSFER_VIEW = False
			WITHDRAW_VIEW = False

		Case "3"		'Za
			Call Alerts(LNG_ALERT_WRONG_ACCESS,"BACK","")
			INFO_MODE	 = "POINT3-1"
			SHOP_POINT = SHOP_POINT3
			PLUS_TOTAL_MILEAGE 	= PLUS_TOTAL_MILEAGE3
			MINUS_TOTAL_MILEAGE = MINUS_TOTAL_MILEAGE3
			MILEAGE_TOTAL 			= MILEAGE3_TOTAL
			PLUS_TOTAL_MILEAGE_NOTAVAIL = PLUS_TOTAL_MILEAGE3_NOTAVAIL
			PROC_CS_POINT_KIND = "HJPS_CS_POINT3_KIND"
			TRANSFER_VIEW = False
			WITHDRAW_VIEW = True

		Case Else
			Call Alerts(LNG_ALERT_WRONG_ACCESS,"BACK","")
	End Select

	SDATE		= pRequestTF("SDATE",False)
	EDATE		= pRequestTF("EDATE",False)
	PAGE		= pRequestTF("PAGE",False)
	KIND		= pRequestTF("KIND",False)
'	PAGESIZE	= pRequestTF("PAGESIZE",False)
	If PAGE = ""		Then PAGE = 1
	If PAGESIZE = ""	Then PAGESIZE = 10
	If SDATE = ""		Then SDATE = ""
	If EDATE = ""		Then EDATE = ""
	If KIND = ""		Then KIND = ""

	Select Case LCase(KIND)
		Case "transfer"
			LNG_TEXT_POINT_RESERVE_ORDERNO = LNG_CS_POINT_TRANSFERINFO_TEXT07
			LNG_TEXT_POINT_USE_ORDERNO = LNG_CS_POINT_TRANSFERINFO_TEXT09
			THIS_PAGE_TITLE = " - " &LNG_MYOFFICE_POINT_02
		Case "withdraw"
			LNG_TEXT_POINT_RESERVE_ORDERNO = LNG_TEXT_POINT_RESERVE_ORDERNO
			LNG_TEXT_POINT_USE_ORDERNO = LNG_TEXT_POINT_USE_ORDERNO
			THIS_PAGE_TITLE = " - " &LNG_MYOFFICE_POINT_03
	End Select

	arrParams = Array(_
		Db.makeParam("@MBID1",adVarChar,adParamInput,20,DK_MEMBER_ID1),_
		Db.makeParam("@MBID2",adInteger,adParamInput,0,DK_MEMBER_ID2),_
		Db.makeParam("@PAGE",adInteger,adParamInput,0,PAGE),_
		Db.makeParam("@PAGESIZE",adInteger,adParamInput,0,PAGESIZE),_
		Db.makeParam("@SDATE",adVarChar,adParamInput,10,SDATE),_
		Db.makeParam("@EDATE",adVarChar,adParamInput,10,EDATE),_
		Db.makeParam("@KIND",adVarChar,adParamInput,10,KIND),_
		Db.makeParam("@ALL_COUNT",adInteger,adParamOutput,0,0) _
	)
	arrList = Db.execRsList(PROC_CS_POINT_KIND,DB_PROC,arrParams,listLen,DB3)			'전체,이체,출금 통합
	'arrList = Db.execRsList("HJPS_CS_POINT",DB_PROC,arrParams,listLen,DB3)
	ALL_COUNT = arrParams(UBound(arrParams))(4)

	Dim PAGECOUNT,CNT
	PAGECOUNT = Int((CCur(ALL_COUNT) - 1 ) / CInt(PAGESIZE) ) + 1
	IF CCur(PAGE) = 1 Then
		CNT = ALL_COUNT
	Else
		CNT = ALL_COUNT - ((CCur(PAGE)-1)*CInt(PAGESIZE)) '
	End If

	ThisM_1stDate = Left(Date(),8)&"01"				'이번달 1일
%>
<!--#include virtual = "/m/_include/document.asp"-->
<!--#include virtual = "/m/_include/jqueryload.asp"-->
<link rel="stylesheet" type="text/css" href="/m/css/point.css?" />
<script type="text/javascript" src="/m/js/calendar.js"></script>
</head>
<body>
<!--#include virtual = "/m/_include/header.asp"-->
<%'sortTable%>
<link rel="stylesheet" href="/jscript/tablesorter/jquery.wprTablesorter.css">
<script type="text/javascript" src="/jscript/tablesorter/jquery.wprTablesorter.js"></script>
<script type="text/javascript">
	$(document).ready(function() {
		$("#sortTable").wprTablesorter({
			firstColFix : true,	//첫번째열 고정
			//firstColasc : true,	//첫번째열 오름차순 여부	//firstColFix=true일 경우 필수값
			noSortColumns : [7]		//정렬안하는 컬럼
		});
	});

	function chgDate(sdate,nDate) {
		var SDATE = $("#SDATE");
		var EDATE = $("#EDATE");
		var nowDate = nDate;

		if (sdate != '')
		{
			EDATE.val(nowDate);
			SDATE.val(sdate);

		} else {
			EDATE.val('');
			SDATE.val('');
		}
	}
</script>
<div id="subTitle" class="width100 tcenter text_noline" ><%=SHOP_POINT_TITLE%></div>
<div>

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
			<article id="filter" class="table" style="display: none;" >
				<div class="members">
					<h6><%=LNG_TEXT_PAY_CATEGORY%></h6>
					<div class="labels">
						<label><input type="radio" name="KIND" value="" <%=isChecked(KIND,"")%> checked="checked"><span><i class="icon-ok"></i><%=LNG_TEXT_ALL%></span></label>
						<%If TRANSFER_VIEW Then%><label><input type="radio" name="KIND" value="transfer" <%=isChecked(KIND,"transfer")%> ><span><i class="icon-ok"></i><%=LNG_MYOFFICE_POINT_02%></span></label><%End If%>
						<%If WITHDRAW_VIEW Then%><label><input type="radio" name="KIND" value="withdraw" <%=isChecked(KIND,"withdraw")%> ><span><i class="icon-ok"></i><%=LNG_MYOFFICE_POINT_03%></span></label><%End If%>
					</div>
				</div>
			</article>
			<article>
				<div class="search">
					<input type="submit" id="searchBtn" class="search_btn" value="<%=LNG_TEXT_SEARCH%>"/>
					<div class="icon-ccw-1 search_reset" onclick="location.replace(location.href);"/></div>
					<div class="icon-cog search_filter" onclick="toggle_filter('filter');"/></div>
				</div>
			</article>
		</div>
	</form>

	<p class="titles"><%=SHOP_POINT%> <%=LNG_TEXT_POINT_SEARCH_TOTAL%></p>
	<table <%=tableatt%> class="total">
		<col width="40%" />
		<col width="60%" />
		<tr>
			<th class="th"><%=LNG_TEXT_POINT_TOTAL_RESERVE%> <%=SHOP_POINT%></th>
			<td class="tcenter tweight green"><%=num2Cur(PLUS_TOTAL_MILEAGE)%></td>
		</tr>
		<tr>
			<th class="th"><%=LNG_TEXT_POINT_TOTAL_USE%> <%=SHOP_POINT%></th>
			<td class="tcenter tweight"><%=num2Cur(MINUS_TOTAL_MILEAGE)%></td>
		</tr>
		<tr>
			<th class="th"><%=LNG_TEXT_POINT_AVAILABLE%> <%=SHOP_POINT%></th>
			<td class="tcenter tweight blue2"><%=num2Cur(MILEAGE_TOTAL)%></td>
		</tr>
		<tr>
			<th class="th"><%=LNG_TEXT_POINT_UNAVAILABLE%> <%=SHOP_POINT%></th>
			<td class="tcenter tweight red2"><%=num2Cur(PLUS_TOTAL_MILEAGE_NOTAVAIL)%></td>
		</tr>
	</table>

	<p class="titles"><%=LNG_TEXT_POINT_DETAILED_RECORD%><%=THIS_PAGE_TITLE%></p>
	<%'sticky-wrap%>
	<div id="fixedTable" class="sticky-wrap">
		<table id="sortTable" <%=tableatt%> class="">
			<%
				If IsArray(arrList) Then
			%>
			<thead>
				<tr>
					<th><%=LNG_SCHEDULE_TEXT01_M%><!-- <%=LNG_TEXT_POINT_PRODUCTION_TIME%> --></th>
					<th><%=LNG_TEXT_POINT_RESERVE_AMOUNT%></th>
					<th><%=LNG_TEXT_POINT_USED_AMOUNT%></th>

					<th><%=LNG_TEXT_POINT_REASON%></th>
					<th><%=LNG_TEXT_POINT_RESERVE_ORDERNO%></th>
					<!-- <th><%=LNG_TEXT_POINT_RESERVE_PURCHASE_DATE%></th> -->

					<th><%=LNG_TEXT_POINT_USE_ORDERNO%></th>
					<!-- <th><%=LNG_TEXT_POINT_USE_SELL_DATE%></th> -->
					<th><%=LNG_TEXT_POINT_PAYDATE%></th>
					<th><%=LNG_TEXT_REMARKS%></th>
				</tr>
			</thead>
			<tbody>
			<%
					For i = 0 To listLen
						arr_T_Time				= arrList(1,i)
						arr_mbid				= arrList(2,i)
						arr_mbid2				= arrList(3,i)

						arr_M_Name				= arrList(4,i)
						arr_PlusValue			= arrList(5,i)
						arr_PlusKind			= arrList(6,i)
						arr_MinusValue			= arrList(7,i)

						arr_MinusKind			= arrList(8,i)
						arr_Plus_OrderNumber	= arrList(9,i)
						arr_Minus_OrderNumber	= arrList(10,i)
						'arr_Use_End_Date		= arrList(11,i)
						'arr_Use_End_Date_BT	= arrList(12,i)
						arr_ETC1				= arrList(11,i)
						'arr_PlusSellDate		= arrList(14,i)
						'arr_MinusSellDate		= arrList(15,i)
						arr_PayDate				= arrList(12,i)
						arr_PLUS_VAUE			= arrList(13,i)
						arr_MINUS_VALUE			= arrList(14,i)

						'If arr_PlusKind  <> "" Then OCCUR_REASON = arr_PLUS_VAUE
						'If arr_MinusKind <> "" Then OCCUR_REASON = arr_MINUS_VALUE
						If arr_PlusKind  <> "" Then OCCUR_REASON = FUNC_OCCUR_REASON(arr_PlusKind)
						If arr_MinusKind <> "" Then OCCUR_REASON = FUNC_OCCUR_REASON(arr_MinusKind)
						If OCCUR_REASON  = "" Then OCCUR_REASON = arr_PLUS_VAUE
						If OCCUR_REASON = "" Then OCCUR_REASON = arr_MINUS_VALUE

						arr_T_Time_DATE = Replace(arr_T_Time,"-","")
						arr_T_Time_DATE = Left(arr_T_Time_DATE,8)
			%>
				<tr>
					<!-- <td class="tcenter date"><%=Left(arr_T_Time,10)%><br /><%=mid(arr_T_Time,12,8)%></td> -->
					<td class="tcenter date"><%=date8to13(arr_T_Time_DATE)%></td>
					<td class="tright"><%=num2cur(arr_PlusValue)%></td>
					<td class="tright"><%=num2cur(arr_MinusValue)%></td>
					<td class="tcenter"><%=OCCUR_REASON%></td>
					<td class="tcenter"><%=arr_Plus_OrderNumber%></td>
					<!-- <td class="tcenter"><%=date8to10(arr_PlusSellDate)%></td> -->
					<td class="tcenter"><%=arr_Minus_OrderNumber%></td>
					<!-- <td class="tcenter"><%=date8to10(arr_MinusSellDate)%></td> -->
					<td class="tcenter <%=avail_color%>"><%=date8to13(arr_PayDate)%></td>
					<td class="tcenter" style="max-width: 100px;"><%=arr_ETC1%></td>
				</tr>
			<%
					Next
				Else
					PRINT TABS(1) & "		<tr>"
					PRINT TABS(1) & "			<td colspan=""1"" class=""nodata"">"&LNG_TEXT_NO_DATA&"</td>"
					PRINT TABS(1) & "		</tr>"
				End If
			%>
			</tbody>
		</table>
	</div>

</div>
<div class="paging_area pagingNew3"><%Call pageListMob5(PAGE,PAGECOUNT)%></div>

<form name="frm" method="post" action="">
	<input type="hidden" name="PAGE" value="<%=PAGE%>" />
	<input type="hidden" name="PAGESIZE" value="<%=PAGESIZE%>" />
	<input type="hidden" name="SDATE" value="<%=SDATE%>" />
	<input type="hidden" name="EDATE" value="<%=EDATE%>" />
	<input type="hidden" name="KIND" value="<%=KIND%>" />
</form>

<!--#include virtual = "/m/_include/copyright.asp"-->
