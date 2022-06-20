<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	PAGE_SETTING = "MYOFFICE"
	INFO_MODE	 = "BONUS2-1"

	ISLEFT = "T"
	ISSUBTOP = "T"
	OVERFLOW_VISIBLE = "F"

	Call ONLY_CS_MEMBER()

	SDATE		= pRequestTF("SDATE",False)
	EDATE		= pRequestTF("EDATE",False)
	If SDATE = ""		Then SDATE = ""
	If EDATE = ""		Then EDATE = ""


%>
<!--#include virtual = "/_include/document.asp"-->
<link rel="stylesheet" href="/myoffice/css/style_cs.css" />
<link rel="stylesheet" href="/myoffice/css/layout_cs.css" />
<link rel="stylesheet" type="text/css" href="pay.css" />
<script type="text/javascript" src="/jscript/calendar.js"></script>
<script type="text/javascript" src="pay.js"></script>
<script type="text/javascript">
<!--
//-->
</script>
</head>
<body>
<!--#include virtual = "/_include/header.asp"-->
<form name="dateFrm" action="payTotal.asp" method="post">
	<table <%=tableatt%> class="userCWidth table1">
		<col width="200" />
		<col width="*" />
		<tr>
			<th>날짜검색</th>
			<td>
				<strong>시작일</strong> : <input type='text' name='SDATE' value="<%=SDATE%>" class='input_text readonly' onclick="openCalendar(event, this, 'YYYY-MM-DD');" readonly="readonly">
				부터
				<strong>종료일</strong> : <input type='text' name='EDATE' value="<%=EDATE%>" class='input_text readonly' onclick="openCalendar(event, this, 'YYYY-MM-DD');" readonly="readonly">
				까지
				<input type="image" src="<%=IMG_BTN%>/g_list_search.gif" style="width:43px; height:19px; vertical-align:middle;" />
			</td>
		</tr>
	</table>
</form>
<p class="titles"><%=LNG_CS_PAYTOTAL_TEXT01%><!-- 일일마감수당 합계내역 --></p>
<table <%=tableatt%> class="userCWidth table2">
	<colgroup>
		<col span="4" width="95" />
		<col span="3" width="95" />
		<col span="1" width="135" />
	</colgroup>
	<tr>
		<th><%=LNG_CS_PAY_BONUS_TEXT01_1%></th>
		<th><%=LNG_CS_PAY_BONUS_TEXT01_2%></th>
		<th><%=LNG_CS_PAY_BONUS_TEXT01_3%></th>
		<th><%=LNG_CS_PAY_TEXT09%></th>
		<th><%=LNG_CS_PAY_TEXT06%></th>
		<th><%=LNG_CS_PAY_TEXT11%></th>
		<th><%=LNG_CS_PAY_TEXT12%></th>
		<th><%=LNG_CS_PAY_TEXT13%></th>
	</tr>
	<%
		arrParams = Array(_
			Db.makeParam("@MBID1",adVarChar,adParamInput,20,DK_MEMBER_ID1),_
			Db.makeParam("@MBID2",adInteger,adParamInput,0,DK_MEMBER_ID2),_
			Db.makeParam("@SDATE",adVarChar,adParamInput,10,SDATE),_
			Db.makeParam("@EDATE",adVarChar,adParamInput,10,EDATE),_
			Db.makeParam("@ALL_COUNT",adInteger,adParamOutput,0,0) _
		)
		Set DKRS = Db.execRs("HJPS_CS_PRICE_01_TOTAL",DB_PROC,arrParams,DB3)
		If Not DKRS.BOF And Not DKRS.EOF Then
			RS_sumallallowance_T	= DKRS(0)
			RS_incomeTax_T			= DKRS(1)
			RS_residentTax_T		= DKRS(2)
			RS_truepayMent_T		= DKRS(3)
			RS_Allowance1_T			= DKRS(4)
			RS_Allowance2_T			= DKRS(5)
			RS_Allowance3_T			= DKRS(6)
			RS_Allowance4_T			= DKRS(7)
			RS_Allowance5_T			= DKRS(8)
			RS_Allowance6_T			= DKRS(9)
			RS_Allowance7_T			= DKRS(10)
			RS_Allowance8_T			= DKRS(11)
			RS_Allowance9_T			= DKRS(12)
			RS_Allowance10_T		= DKRS(13)
			RS_Cur_DedCut_Pay_T		= DKRS(14)

			'▣극점계산 : ReqTF3 =  1 이면서  SellPV05 > 0
			If ReqTF3 = 1 And SellPV05 > 0 Then
				Allowance1 =Allowance1 * (SellPV05 / 100)
				Allowance2 =Allowance3 * (SellPV05 / 100)
				Allowance2 =Allowance3 * (SellPV05 / 100)
			End If
			RS_Allowance1_T_n		= DKRS(15)
			RS_Allowance2_T_n		= DKRS(16)
			RS_Allowance3_T_n		= DKRS(17)
			RS_SumAllAllowance_10000= DKRS(18)	'보류수당

		Else
			RS_sumallallowance_T	= 0
			RS_incomeTax_T			= 0
			RS_residentTax_T		= 0
			RS_truepayMent_T		= 0
			RS_Allowance1_T			= 0
			RS_Allowance2_T			= 0
			RS_Allowance3_T			= 0
			RS_Allowance4_T			= 0
			RS_Allowance5_T			= 0
			RS_Allowance6_T			= 0
			RS_Allowance7_T			= 0
			RS_Allowance8_T			= 0
			RS_Allowance9_T			= 0
			RS_Allowance10_T		= 0
			RS_Cur_DedCut_Pay_T		= 0
			RS_Allowance1_T_n		= 0
			RS_Allowance2_T_n		= 0
			RS_Allowance3_T_n		= 0
			RS_SumAllAllowance_10000= 0
		End If
		Call closeRS(DKRS)

		'헬씨 특이사항
		RS_Allowance1_T = RS_Allowance1_T_n
		RS_Allowance2_T = RS_Allowance2_T_n
		RS_Allowance3_T = RS_Allowance3_T_n
	%>
	<tr>
		<td><%=num2cur(RS_Allowance1_T)%></td>
		<td><%=num2cur(RS_Allowance2_T)%></td>
		<td><%=num2cur(RS_Allowance3_T)%></td>
		<td><%=num2cur(RS_SumAllAllowance_10000)%></td>
		<td><%=num2cur(RS_sumallallowance_T)%></td>
		<td><%=num2cur(RS_incomeTax_T)%></td>
		<td><%=num2cur(RS_residentTax_T)%></td>
		<td class="twe ight"><%=num2cur(RS_truepayMent_T)%></td>
	</tr>
</table>

<p class="titles"><%=LNG_CS_PAYTOTAL_TEXT02%><!-- 월마감수당 합계내역 --></p>
<table <%=tableatt%> class="userCWidth table2">
	<colgroup>
		<col span="4" width="95" />
		<col span="3" width="95" />
		<col span="1" width="135" />
	</colgroup>
	<tr>
		<th colspan="4"><%=LNG_CS_PAY_BONUS_TEXT03_1%></th>
		<th><%=LNG_CS_PAY_TEXT06%></th>
		<th><%=LNG_CS_PAY_TEXT11%></th>
		<th><%=LNG_CS_PAY_TEXT12%></th>
		<th><%=LNG_CS_PAY_TEXT13%></th>
	</tr>
	<%
		arrParams2 = Array(_
			Db.makeParam("@MBID1",adVarChar,adParamInput,20,DK_MEMBER_ID1),_
			Db.makeParam("@MBID2",adInteger,adParamInput,0,DK_MEMBER_ID2),_
			Db.makeParam("@SDATE",adVarChar,adParamInput,10,SDATE),_
			Db.makeParam("@EDATE",adVarChar,adParamInput,10,EDATE),_
			Db.makeParam("@ALL_COUNT",adInteger,adParamOutput,0,0) _
		)
		Set DKRS2 = Db.execRs("HJPS_CS_PRICE_12_TOTAL",DB_PROC,arrParams2,DB3)
		If Not DKRS2.BOF And Not DKRS2.EOF Then
			RS2_sumallallowance_T	= DKRS2(0)
			RS2_incomeTax_T			= DKRS2(1)
			RS2_residentTax_T		= DKRS2(2)
			RS2_truepayMent_T		= DKRS2(3)
			RS2_Allowance1_T		= DKRS2(4)
			RS2_Allowance2_T		= DKRS2(5)
			RS2_Allowance3_T		= DKRS2(6)
			RS2_Allowance4_T		= DKRS2(7)
			RS2_Allowance5_T		= DKRS2(8)
			RS2_Allowance6_T		= DKRS2(9)
			RS2_Allowance7_T		= DKRS2(10)
			RS2_Allowance8_T		= DKRS2(11)
			RS2_Allowance9_T		= DKRS2(12)
			RS2_Allowance10_T		= DKRS2(13)
			RS2_Cur_DedCut_Pay_T	= DKRS2(14)
		Else
			RS2_sumallallowance_T	= 0
			RS2_incomeTax_T			= 0
			RS2_residentTax_T		= 0
			RS2_truepayMent_T		= 0
			RS2_Allowance1_T		= 0
			RS2_Allowance2_T		= 0
			RS2_Allowance3_T		= 0
			RS2_Allowance4_T		= 0
			RS2_Allowance5_T		= 0
			RS2_Allowance6_T		= 0
			RS2_Allowance7_T		= 0
			RS2_Allowance8_T		= 0
			RS2_Allowance9_T		= 0
			RS2_Allowance10_T		= 0
			RS2_Cur_DedCut_Pay_T	= 0
		End If
		Call closeRS(DKRS2)

		RS2_GRADE_BONUS = RS2_Allowance1_T + RS2_Allowance2_T + RS2_Allowance3_T + RS2_Allowance4_T + RS2_Allowance5_T + RS2_Allowance6_T

	%>
	<tr>
		<td colspan="4"><%=num2cur(RS2_GRADE_BONUS)%></td>
		<td><%=num2cur(RS2_sumallallowance_T)%></td>
		<td><%=num2cur(RS2_incomeTax_T)%></td>
		<td><%=num2cur(RS2_residentTax_T)%></td>
		<td class="twe ight"><%=num2cur(RS2_truepayMent_T)%></td>
	</tr>
</table>


<p class="titles"><%=LNG_CS_PAYTOTAL_TEXT03%><!-- 수당 합계조회 --></p>
<table <%=tableatt%> class="userCWidth table2">
	<colgroup>
		<col span="4" width="95" />
		<col span="3" width="95" />
		<col span="1" width="135" />
	</colgroup>
	<tr>
		<!-- <th colspan="2" style="background-color:#d0f2fd;">총판매액</th>
		<th colspan="2" style="background-color:#d0f2fd;">총판매PV</th> -->
		<th colspan="4" rowspan="2" style="background-color:#d0f2fd;">TOTAL</th>
		<th style="background-color:#d0f2fd;"><%=LNG_CS_PAY_TEXT06%></th>
		<th style="background-color:#d0f2fd;"><%=LNG_CS_PAY_TEXT11%></th>
		<th style="background-color:#d0f2fd;"><%=LNG_CS_PAY_TEXT12%></th>
		<th style="background-color:#d0f2fd;"><%=LNG_CS_PAY_TEXT13%></th>
	</tr>
	<%
			'▣ 본인누적 매출
			arrParams = Array(_
				Db.makeParam("@mbid",adVarChar,adParamInput,20,DK_MEMBER_ID1), _
				Db.makeParam("@mbid2",adInteger,adParamInput,0,DK_MEMBER_ID2), _
				Db.makeParam("@SDATE",adVarChar,adParamInput,10,SDATE),_
				Db.makeParam("@EDATE",adVarChar,adParamInput,10,EDATE) _
			)
			Set HJRSC = Db.execRs("HJP_SALES_TOTAL",DB_PROC,arrParams,DB3)
			If Not HJRSC.BOF And Not HJRSC.EOF Then
				MY_TotalPrice = HJRSC(0)
				MY_TotalPV	  = HJRSC(1)
			Else
				MY_TotalPrice = 0
				MY_TotalPV	  = 0
			End If
			Call closeRS(HJRSC)

			Sumallallowance_T = 0
			IncomeTax_T		  = 0
			ResidentTax_T	  = 0
			TruepayMent_T	  = 0

			Sumallallowance_T	= RS_sumallallowance_T + RS2_sumallallowance_T + RS3_sumallallowance_T
			IncomeTax_T			= RS_incomeTax_T + RS2_incomeTax_T + RS3_incomeTax_T
			ResidentTax_T		= RS_residentTax_T + RS2_residentTax_T + RS3_residentTax_T
			TruepayMent_T		= RS_truepayMent_T + RS2_truepayMent_T + RS3_truepayMent_T
	%>
	<tr>
		<!-- <td colspan="2" class="tweight" style="line-height:30px;"><%=num2cur(MY_TotalPrice)%></td>
		<td colspan="2" class="tweight"><%=num2cur(MY_TotalPV)%></td> -->

		<td class="tweight"><%=num2cur(Sumallallowance_T)%></td>
		<td class="tweight"><%=num2cur(IncomeTax_T)%></td>
		<td class="tweight"><%=num2cur(ResidentTax_T)%></td>
		<td class="tweight"><%=num2cur(TruepayMent_T)%></td>
	</tr>
</table>



<form name="frm" method="post" action="">
	<input type="hidden" name="SDATE" value="<%=SDATE%>" />
	<input type="hidden" name="EDATE" value="<%=EDATE%>" />
</form>

<!--#include virtual = "/_include/copyright.asp"-->
