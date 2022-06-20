<!--#include virtual = "/_lib/strFunc.asp"-->
<%

	PAGE_SETTING = "PAY"

	Call FNC_ONLY_CS_MEMBER()

	SDATE		= pRequestTF("SDATE",False)
	EDATE		= pRequestTF("EDATE",False)
	PAGE		= pRequestTF("PAGE",False)
'	PAGESIZE	= pRequestTF("PAGESIZE",False)
	If PAGE = ""		Then PAGE = 1
	If PAGESIZE = ""	Then PAGESIZE = 10
	If SDATE = ""		Then SDATE = ""
	If EDATE = ""		Then EDATE = ""



	arrParams = Array(_
		Db.makeParam("@MBID1",adVarChar,adParamInput,20,DK_MEMBER_ID1),_
		Db.makeParam("@MBID2",adInteger,adParamInput,0,DK_MEMBER_ID2),_
		Db.makeParam("@PAGE",adInteger,adParamInput,0,PAGE),_
		Db.makeParam("@PAGESIZE",adInteger,adParamInput,0,PAGESIZE),_
		Db.makeParam("@SDATE",adVarChar,adParamInput,10,SDATE),_
		Db.makeParam("@EDATE",adVarChar,adParamInput,10,EDATE),_
		Db.makeParam("@ALL_COUNT",adInteger,adParamOutput,0,0) _
	)
	arrList = Db.execRsList("DKPS_CS_PRICE01",DB_PROC,arrParams,listLen,DB3)
	ALL_COUNT = arrParams(UBound(arrParams))(4)

	Dim PAGECOUNT,CNT
	PAGECOUNT = Int((CCur(ALL_COUNT) - 1 ) / CInt(PAGESIZE) ) + 1
	IF CCur(PAGE) = 1 Then
		CNT = ALL_COUNT
	Else
		CNT = ALL_COUNT - ((CCur(PAGE)-1)*CInt(PAGESIZE)) '
	End If
%>
<!--#include virtual = "/m/_include/document.asp"-->
<!--#include virtual = "/m/_include/jqueryload.asp"-->
<script type="text/javascript" src="/m/js/calendar.js"></script>
<link rel="stylesheet" href="pay.css" />

</head>
<body  onunload="">
<!--#include virtual = "/m/_include/header.asp"-->
<!--#include virtual = "/m/_include/sub_header.asp"-->
<div id="subTitle" class="width100 tcenter text_noline" >수당합계조회</div>

<div id="div_date">
	<form name="dateFrm" action="payTotal.asp" method="post" data-ajax="false">
		<table <%=tableatt%> class="width100">
			<col width="100" />
			<col width="*" />
			<col width="80" />
			<tr>
				<th>검색시작일</th>
				<td class="tcenter"><input type='text' name='SDATE' value="<%=SDATE%>" class='input_text_date readonly' onclick="openCalendar(event, this, 'YYYY-MM-DD');" readonly="readonly" /></td>
				<td class="tcenter" rowspan="2" style="padding:0px 5px;">
				<input type="submit" value="검색" class="date_submit" />
				</td>
			</tr><tr>
				<th>검색종료일</th>
				<td class="tcenter"><input type='text' name='EDATE' value="<%=EDATE%>" class='input_text_date readonly' onclick="openCalendar(event, this, 'YYYY-MM-DD');" readonly="readonly" /></td>

					<!-- <input type="image" src="<%=IMG_BTN%>/g_list_search.gif" style="width:43px; height:19px; vertical-align:middle;" /> -->
				</td>
			</tr>
		</table>
	</form>
</div>


<p class="sub_title" style="background-color:#56bebe;">일일마감수당 합계내역</p>
	<table <%=tableatt%> class="width100 pays" >
		<col width="27%" />
		<col width="23%" />
		<col width="23%" />
		<col width="27%" />
		<thead>
			<tr>
				<th>수당합계</th>
				<th>소득세</th>
				<th>주민세</th>
				<th>실지급액</th>
			</tr>
		</thead>
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
		<tbody>
		<tr onclick="">
			<td class="tright" style="font-size:14px;"><%=num2cur(RS_sumallallowance_T)%></td>
			<td class="tright" style="font-size:14px;"><%=num2cur(RS_incomeTax_T)%></td>
			<td class="tright" style="font-size:14px;"><%=num2cur(RS_residentTax_T)%></td>
			<td class="tright" style="font-size:14px;"><%=num2cur(RS_truepayMent_T)%></td>
		</tr>
		</tbody>
	</table>

<p class="sub_title" style="background-color:#56bebe;">월마감수당 합계내역</p>
	<table <%=tableatt%> class="width100 pays">
		<col width="27%" />
		<col width="23%" />
		<col width="23%" />
		<col width="27%" />
		<thead>
			<tr>
				<th>수당합계</th>
				<th>소득세</th>
				<th>주민세</th>
				<th>실지급액</th>
			</tr>
		</thead>
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
		<tbody>
		<tr onclick="">
			<td class="tright" style="font-size:14px;"><%=num2cur(RS2_sumallallowance_T)%></td>
			<td class="tright" style="font-size:14px;"><%=num2cur(RS2_incomeTax_T)%></td>
			<td class="tright" style="font-size:14px;"><%=num2cur(RS2_residentTax_T)%></td>
			<td class="tright" style="font-size:14px;"><%=num2cur(RS2_truepayMent_T)%></td>
		</tr>
		</tbody>
	</table>

<p class="sub_title">수당 합계조회</p>
	<table <%=tableatt%> class="width100 pays">
		<col width="27%" />
		<col width="23%" />
		<col width="23%" />
		<col width="27%" />
		<thead>
			<tr>
				<th>수당합계</th>
				<th>소득세</th>
				<th>주민세</th>
				<th>실지급액</th>
			</tr>
		</thead>
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
		<tbody>
		<tr onclick="">
			<td class="tright tweight" style="font-size:14px;"><%=num2cur(Sumallallowance_T)%></td>
			<td class="tright tweight" style="font-size:14px;"><%=num2cur(IncomeTax_T)%></td>
			<td class="tright tweight" style="font-size:14px;"><%=num2cur(ResidentTax_T)%></td>
			<td class="tright tweight" style="font-size:14px;"><%=num2cur(TruepayMent_T)%></td>
		</tr>
		</tbody>
	</table>
<!--#include virtual = "/m/_include/copyright.asp"-->