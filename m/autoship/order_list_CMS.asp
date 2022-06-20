<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	PAGE_SETTING = "MYOFFICE"
	INFO_MODE	 = "AUTOSHIP1-1"

	ISLEFT = "T"
	ISSUBTOP = "T"

	Call ONLY_BUSINESS_MEMBER(DK_MEMBER_LEVEL,1)
	Call FN_NationCurrency(DK_MEMBER_NATIONCODE,Chg_CurrencyName,Chg_CurrencyISO)

	If Ucase(DK_MEMBER_NATIONCODE) <> "KR" Then CALL WRONG_ACCESS()

'If webproIP="T" Or DK_MEMBER_WEBID = "test" Then
'Else
'	Call ALERTS("접근 불가","BACK","")
'End If

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
<!--#include virtual = "/m/_include/document.asp"-->
<!--#include virtual = "/m/_include/jqueryload.asp"-->
<link rel="stylesheet" href="/m/css/order_list_CMS_mod.css?v0" />

<script type="text/javascript" src="/m/js/calendar.js"></script>

<script type="text/javascript">
	$(document).ready(function() {
		//$("tbody.hid_tbody tr:last-child td").css("border-bottom", "2px solid #000");
	});
</script>

</head>
<body>
<!--#include virtual = "/m/_include/header.asp"-->

<!-- <div id="div_date">
	<form name="dateFrm" action="order_list_CMS.asp" method="post" data-ajax="false">
		<p class="sub_title"><%=LNG_TEXT_DATE_SEARCH%></p>
		<table <%=tableatt%> class="width100">
			<col width="100" />
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
				</td>
			</tr>
		</table>
	</form>
</div> -->

<!-- <div class="subTitle_s" class="tcenter text_noline" ><%=LNG_MYOFFICE_BUY_01%></div> -->
<!-- <div id="b_title" class="cleft">
	<h3 class="fleft"><span class="h3color1"><%=LNG_MYOFFICE_BUY_01%></span></h3>
</div> -->
<div id="order" class="order_list orderList">
	<%If All_Count < 1 Then%>
	<p class="regist"><a href="order_list_CMS_reg.asp"><i class="icon-plus-1"></i><%=LNG_MYOFFICE_AUTOSHIP_02%></a></p>
	<%End If%>
	<table <%=tableatt%> class="width100 table1">
		<col width="40" />
		<col width="30%" />
		<col width="30%" />
		<col width="*" />
		<thead>
			<!-- <tr>
				<th rowspan="3"><%=LNG_TEXT_NUMBER%></th>
				<th>등록일</th>
				<th>오토쉽시작일</th>
				<th>다음 오토쉽일자<br />시작일</th>
			</tr><tr>
				<th>중지 시작일</th>
				<th>정기결제 기준일자</th>
				<th>정기결제 주기</th>
			</tr><tr>
				<th>수령인</th>
				<th>연락처1</th>
				<th>연락처2</th>
			</tr> -->
			<tr>
				<th rowspan="2"><%=LNG_TEXT_NUMBER%></th>
				<th>등록일</th>
				<th>시작일</th>
				<th>다음 시작일</th>
			</tr><tr>
				<th>기준일자</th>
				<th>주기</th>
				<th>총 결제금</th>
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
					arrList_A_ProcAmt				= arrList(39,i)
					arrList_A_Seq					= arrList(40,i)		'상품테이블 일련번호(1,1)
					arrList_A_Birth					= arrList(41,i)
					arrList_A_Card_Dongle			= arrList(42,i)
					arrList_A_Birth1				= arrList(43,i)
					arrList_A_AutoCnt				= arrList(44,i)
					arrList_A_Recordid				= arrList(45,i)
					arrList_A_Recordtime			= arrList(46,i)		'기록일자
					arrList_Send_Ch_TF				= arrList(47,i)


					PRINT TABS(1) & "	<tbody>"
					PRINT TABS(1) & "		<tr class=""bot_line_c_333"">"
					PRINT TABS(1) & "			<td class=""tcenter"" rowspan=""3"">"&ThisNum&"</td>"
					PRINT TABS(1) & "			<td class=""tcenter"">"&Left(arrList_A_Recordtime,10)&"</td>"
					PRINT TABS(1) & "			<td class=""tcenter"" >"&date8to10(arrList_A_Start_Date)&"</td>"
					PRINT TABS(1) & "			<td class=""tcenter tweight"" >"&date8to10(arrList_A_ProcDay)&"</td>"
					PRINT TABS(1) & "		</tr><tr>"
					'PRINT TABS(1) & "			<td class=""tcenter"" >"&date8to10(arrList_A_StopDay)&"</td>"
					PRINT TABS(1) & "			<td class=""tcenter"" >"&arrList_A_Month_Date&"일</td>"
					PRINT TABS(1) & "			<td class=""tcenter"">"&arrList_A_AutoCnt&" 개월</td>"
					PRINT TABS(1) & "			<td class=""tcenter tweight blue2"">"&num2cur(arrList_A_ProcAmt)&" 원</td>"
					PRINT TABS(1) & "		</tr>"
					'PRINT TABS(1) & "		<tr>"
					'PRINT TABS(1) & "			<td class=""tcenter"" >"&arrList_A_Rec_Name&"</td>"
					'PRINT TABS(1) & "			<td class=""tcenter"">"&arrList_A_hptel&"</td>"
					'PRINT TABS(1) & "			<td class=""tcenter"">"&arrList_A_hptel2&"</td>"
					'PRINT TABS(1) & "		</tr>"
					PRINT TABS(1) & "		<tr>"
					'PRINT TABS(1) & "			<td class=""tcenter bot_line_c_333"" >"&insuranceNumber&"</td>"
					PRINT TABS(1) & "			<td class=""tcenter bot_line_c_333"" colspan=""4""><a class=""detail_btn noline"" onclick=""location.href='order_list_CMS_mod.asp?oIDX="&arrList_A_Seq&"'"">"&LNG_BTN_DETAIL&"</a></td>"
					PRINT TABS(1) & "		</tr>"
					PRINT TABS(1) & "	</tbody>"

				Next
			Else
				PRINT TABS(1) & "	<tr>"
				PRINT TABS(1) & "		<td colspan=""4"" class=""notData tcenter"">정기결제 내역이 없습니다.</td>"
				PRINT TABS(1) & "	</tr>"
			End If

		%>
	<!--
	<tr>
		<td colspan="4" style="border-left:0px; border-right:0px; border-bottom:0px;">
			<a class="btn_a" href="order_list_CMS_reg.asp">정기결제 신규 등록</a>
		</td>
	</tr>
	-->
	</table>

	<div class="pagingArea pagingNew3"><% Call pageListMob5n(PAGE,PAGECOUNT)%></div>
	<form name="frm" method="post" action="">
		<input type="hidden" name="PAGE" value="<%=PAGE%>" />
		<input type="hidden" name="PAGESIZE" value="<%=PAGESIZE%>" />
		<input type="hidden" name="SDATE" value="<%=SDATE%>" />
		<input type="hidden" name="EDATE" value="<%=EDATE%>" />
	</form>


</div>
<!--#include virtual = "/m/_include/copyright.asp"-->