<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	PAGE_SETTING = "MYOFFICE"
	INFO_MODE	 = "AUTOSHIP1-1"

	ISLEFT = "T"
	ISSUBTOP = "T"

	Call ONLY_BUSINESS_MEMBER(DK_MEMBER_LEVEL,1)
	Call FN_NationCurrency(DK_MEMBER_NATIONCODE,Chg_CurrencyName,Chg_CurrencyISO)

	If Ucase(DK_MEMBER_NATIONCODE) <> "KR" Then CALL WRONG_ACCESS()

	SDATE = pRequestTF("SDATE",False)
	EDATE = pRequestTF("EDATE",False)

	PAGE = pRequestTF("PAGE",False)
	PAGESIZE = 15
	If PAGE = "" Then PAGE = 1

	ThisM_1stDate = Left(Date(),8)&"01"				'이번달 1일


	arrParams = Array(_
		Db.makeParam("@mbid1",adVarChar,adParamInput,20,DK_MEMBER_ID1), _
		Db.makeParam("@mbid2",adInteger,adParamInput,0,DK_MEMBER_ID2), _
		Db.makeParam("@SDATE",adVarChar,adParamInput,10,SDATE), _
		Db.makeParam("@EDATE",adVarChar,adParamInput,10,EDATE), _
		Db.makeParam("@PAGE",adInteger,adParamInput,0,PAGE), _
		Db.makeParam("@PAGESIZE",adInteger,adParamInput,0,PAGESIZE), _
		Db.makeParam("@ALL_Count",adInteger,adParamOutput,0,0) _
	)
	arrList =  Db.execRsList("HJP_ORDER_LIST_CMS",DB_PROC,arrParams,listLen,DB3)
	All_Count = arrParams(UBound(arrParams))(4)
	Dim PAGECOUNT,CNT
	PAGECOUNT = Int((CCur(All_Count) - 1 ) / CInt(PAGESIZE) ) + 1
	IF CCur(PAGE) = 1 Then
		CNT = All_Count
	Else
		CNT = All_Count - ((CCur(PAGE)-1)*CInt(PAGESIZE)) '
	End If
%>
<!--#include virtual = "/_include/document.asp"-->
<!-- <link rel="stylesheet" href="/myoffice/css/style_cs.css" /> -->
<!-- <link rel="stylesheet" href="/myoffice/css/layout_cs.css" /> -->
<!-- <link rel="stylesheet" href="/myoffice/autoship/order_list_CMS_mod.css" /> -->
<link rel="stylesheet" href="/css/pay2.css?" />
<link rel="stylesheet" href="/css/order_list_CMS_mod.css?" />
<script type="text/javascript" src="/jscript/calendar.js"></script>
<script type="text/javascript">
<!--
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
// -->
</script>
</head>
<body>
<!--#include virtual = "/_include/header.asp"-->
<div id="buy" class="orderList">
	<!-- <form name="dateFrm" action="order_list_CMS.asp" method="post">
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
				</td>
			</tr><tr>
				<td>
					<input type="text" id="SDATE" name="SDATE" class="input_text tcenter tweight" style="width:140px;" value="<%=SDATE%>" readonly="readonly" onclick="openCalendar(event, this, 'YYYY-MM-DD');" /> ~
					<input type="text" id="EDATE" name="EDATE" class="input_text tcenter tweight" style="width:140px;" value="<%=EDATE%>" readonly="readonly" onclick="openCalendar(event, this, 'YYYY-MM-DD');" />
					<input type="submit" class="txtBtn small2 radius3" value="<%=LNG_TEXT_SEARCH%>"/>
				</td>
			</tr>
		</table>
	</form> -->
	<p class="titles"><%=LNG_TEXT_LIST%>
		<%If All_Count < 1 Then%>
			<a href="order_list_CMS_reg.asp"><i class="icon-plus-1"></i><%=LNG_MYOFFICE_AUTOSHIP_02%></a>
		<%End If%>
	</p>
	<table <%=tableatt%> class="table">
		<col width="70" />
		<col width="140" />
		<col width="140" />
		<col width="140" />
		<col width="140" />
		<col width="120" />
		<col width="120" />
		<thead>
			<tr>
				<th><%=LNG_TEXT_NUMBER%></th>
				<th><%=LNG_BOARD_TYPE_BOARD_TEXT04%></th>
				<th><%=LNG_AUTOSHIP_01%></th>
				<th><%=LNG_AUTOSHIP_02%></th>
				<!-- <th><%=LNG_AUTOSHIP_03%></th> -->
				<th><%=LNG_AUTOSHIP_04%> <br />/ <%=LNG_AUTOSHIP_05%></th>
				<th><%=LNG_TEXT_PAYMENT_AMOUNT%></th>
				<th><%=LNG_BTN_DETAIL%></th>
			</tr>
		</thead>
		<%
			If IsArray(arrList) Then
				For i = 0 To listLen
					ThisNum = ALL_COUNT - CInt(arrList(0,i)) + 1

					arrList_mbid					= arrList(1,i)
					arrList_mbid2					= arrList(2,i)
					arrList_ApplyDay				= arrList(3,i)
					arrList_A_ItemCode				= arrList(4,i)
					arrList_A_Cul_Code				= arrList(5,i)
					arrList_A_BankCode				= arrList(6,i)
					arrList_A_BankAccount			= arrList(7,i)
					arrList_A_BankOwner				= arrList(8,i)
					arrList_A_BankOwner_Cpno		= arrList(9,i)
					arrList_A_CardCode				= arrList(10,i)
					arrList_A_CardNumber			= arrList(11,i)
					arrList_A_Period1				= arrList(12,i)
					arrList_A_Period2				= arrList(13,i)
					arrList_A_Installment_Period	= arrList(14,i)
					arrList_A_Card_Name_Number		= arrList(15,i)
					arrList_A_Start_Date			= arrList(16,i)		'오토쉽 시작일
					arrList_A_Month_Date			= arrList(17,i)		'기준일자
					arrList_T_index					= arrList(18,i)
					arrList_CMS_TF					= arrList(19,i)
					arrList_CMS_ing					= arrList(20,i)
					arrList_CMS_Result				= arrList(21,i)
					arrList_CMS_Error				= arrList(22,i)
					arrList_A_Receive_Method		= arrList(23,i)
					arrList_A_Rec_Name				= arrList(24,i)
					arrList_A_hptel					= arrList(25,i)
					arrList_A_hptel2				= arrList(26,i)
					arrList_A_Addcode1				= arrList(27,i)
					arrList_A_Address1				= arrList(28,i)
					arrList_A_Address2				= arrList(29,i)
					arrList_A_Address3				= arrList(30,i)
					arrList_A_ETC					= arrList(31,i)
					arrList_A_UseType				= arrList(32,i)
					arrList_A_StopDay				= arrList(33,i)		'중지 시작일
					arrList_A_ProcDay				= arrList(34,i)		'다음 오토쉽일자
					arrList_A_RealProcDay			= arrList(35,i)
					arrList_A_UserProcDay			= arrList(36,i)
					arrList_A_ProcWeek				= arrList(37,i)
					arrList_A_ProcWeekDay			= arrList(38,i)
					arrList_A_ProcAmt				= arrList(39,i)		'결제금액
					arrList_A_Seq					= arrList(40,i)		'상품테이블 일련번호(1,1)
					arrList_A_Birth					= arrList(41,i)
					arrList_A_Card_Dongle			= arrList(42,i)
					arrList_A_Birth1				= arrList(43,i)
					arrList_A_AutoCnt				= arrList(44,i)		'정기결제 주기(개월)
					arrList_A_Recordid				= arrList(45,i)
					arrList_A_Recordtime			= arrList(46,i)		'기록일자
					arrList_Send_Ch_TF				= arrList(47,i)

					PRINT TABS(1) & "	<tr>"
					PRINT TABS(1) & "		<td>"&ThisNum&"</td>"
					PRINT TABS(1) & "		<td>"&Left(arrList_A_Recordtime,10)&"</td>"
					PRINT TABS(1) & "		<td>"&date8to10(arrList_A_Start_Date)&"</td>"
					PRINT TABS(1) & "		<td class=""tweight"">"&date8to10(arrList_A_ProcDay)&"</td>"
					'PRINT TABS(1) & "		<td>"&date8to10(arrList_A_StopDay)&"</td>"
					PRINT TABS(1) & "		<td>"&arrList_A_Month_Date&LNG_DAYS&" / "&arrList_A_AutoCnt&LNG_MONTHS&"</td>"
					PRINT TABS(1) & "		<td class=""tright tweight blue2"">"&num2cur(arrList_A_ProcAmt)&LNG_STRTEXT_TEXT_CURC&" &nbsp;&nbsp;</td>"
					PRINT TABS(1) &"		<td><input type=""button"" class=""detail_btn noline"" value="""&LNG_BTN_DETAIL&""" onclick=""location.href='order_list_CMS_mod.asp?oIDX="&arrList_A_Seq&"'"" /></td>"
					PRINT TABS(1) & "	</tr>"

				Next
			Else
				PRINT TABS(1) & "		<tr>"
				PRINT TABS(1) & "			<td colspan=""7"" class=""notData"">"&LNG_AUTOSHIP_NOT&"</td>"
				PRINT TABS(1) & "		</tr>"
			End If

		%>
	</table>
	<div class="pagingArea pagingNew3 userCWidth"><% Call pageListNew3(PAGE,PAGECOUNT)%></div>
</div>
</div>
<form name="frm" method="post" action="">
	<input type="hidden" name="PAGE" value="<%=PAGE%>" />
	<input type="hidden" name="SDATE" value="<%=SDATE%>" />
	<input type="hidden" name="EDATE" value="<%=EDATE%>" />
</form>


<!--#include virtual = "/_include/copyright.asp"-->