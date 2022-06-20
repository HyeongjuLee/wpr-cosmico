<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	PAGE_SETTING = "MY_MEMBER"

	Call ONLY_BUSINESS_MEMBER(DK_MEMBER_LEVEL,2)
	Call ONLY_CS_MEMBER()

	SDATE = pRequestTF("SDATE",False)
	EDATE = pRequestTF("EDATE",False)

	PAGE = pRequestTF("PAGE",False)
	PAGESIZE = 20
	If PAGE = "" Then PAGE = 1

	ThisM_1stDate = Left(Date(),8)&"01"				'이번달 1일

%>
<!--#include virtual = "/m/_include/document.asp"-->
<!--#include virtual = "/m/_include/jqueryload.asp"-->

</head>
<body>
<!--#include virtual = "/m/_include/header.asp"-->
<!--#include virtual = "/m/_include/sub_header.asp"-->
<link rel="stylesheet" href="member.css" />
<script type="text/javascript" src="/m/js/calendar.js?v1"></script>
<script type="text/javascript">
  $(document).ready(
	function() {
		$("tbody.htbody tr:last-child td").css("border-bottom", "2px solid #000");
	});
</script>
<div id="subTitle" class="width100 tcenter text_noline" ><%=LNG_MYOFFICE_MEMBER_02%></div>
<div id="div_date">
	<form name="dateFrm" action="memberVoteAll.asp" method="post" data-ajax="false">
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
				</td>
			</tr>
		</table>
	</form>
</div>
<div id="member" class="">
	<table <%=tableatt%> class="width100">
		<col width="40" />
		<col width="30%" />
		<col width="25%" />
		<col width="40" />
		<col width="*" />
		<tr>
			<th><%=LNG_TEXT_NUMBER%></th>
			<th><%=LNG_TEXT_MEMID%></th>
			<th><%=LNG_TEXT_NAME%></th>
			<th><%=LNG_TEXT_LEVEL%></th>
			<th><%=LNG_BTN_DETAIL%></th>
		</tr>
		<%
				v_Sell_Mem_TF = ""
				v_LeaveCheck = ""
				v_CurGrade = ""
				businesscode = ""

				arrParams = Array(_
					Db.makeParam("@PAGE",adInteger,adParamInput,0,PAGE), _
					Db.makeParam("@PAGESIZE",adInteger,adParamInput,0,PAGESIZE), _

					Db.makeParam("@mbid1",adVarChar,adParamInput,20,DK_MEMBER_ID1), _
					Db.makeParam("@mbid2",adInteger,adParamInput,0,DK_MEMBER_ID2), _
					Db.makeParam("@M_Name",adVarWChar,adParamInput,100,""), _

					Db.makeParam("@SDATE",adVarChar,adParamInput,10,SDATE), _
					Db.makeParam("@EDATE",adVarChar,adParamInput,10,EDATE), _

					Db.makeParam("@LEVEL",adChar,adParamInput,3,100), _

					Db.makeParam("@Sell_Mem_TF",adChar,adParamInput,1,v_Sell_Mem_TF), _
					Db.makeParam("@LeaveCheck",adChar,adParamInput,1,v_LeaveCheck), _
					Db.makeParam("@CurGrade",adVarChar,adParamInput,10,v_CurGrade), _
					Db.makeParam("@businesscode",adVarWChar,adParamInput,20,businesscode), _

					Db.makeParam("@ALL_Count",adInteger,adParamOutput,0,0) _
				)
				arrList =  Db.execRsList("HJP_MEMBER_INFOS_ALL_UNDER_VOTER",DB_PROC,arrParams,listLen,DB3)
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
						'ThisNum = ALL_COUNT - CInt(arrList(0,i)) + 1
						ThisNum 				= arrList(0,i)
						arrList_mbid			= arrList(1,i)
						arrList_mbid2			= arrList(2,i)
						arrList_M_Name			= arrList(3,i)
						arrList_LineCnt	    	= arrList(4,i)
						arrList_N_LineCnt	    = arrList(5,i)
						arrList_businesscode	= arrList(6,i)
						arrList_Regtime		    = arrList(7,i)
						arrList_Saveid		    = arrList(8,i)
						arrList_Saveid2		    = arrList(9,i)
						arrList_Nominid		    = arrList(10,i)
						arrList_Nominid2		= arrList(11,i)
						arrList_LeaveCheck		= arrList(12,i)
						arrList_WebID		    = arrList(13,i)
						arrList_Sell_Mem_TF	    = arrList(14,i)
						arrList_CurGrade	    = arrList(15,i)
						arrList_CenterName		= arrList(16,i)
						arrList_Grade_Name	    = arrList(17,i)
						arrList_SaveName	    = arrList(18,i)
						arrList_NominName	    = arrList(19,i)
						arrList_lvl			    = arrList(20,i)

						PRINT TABS(1) & "	<tr>"
						PRINT TABS(1) & "		<td class=""tcenter"">"&i+1&"</td>"
						PRINT TABS(1) & "		<td class=""tcenter"">"&arrList_mbid&"-"&arrList_mbid2&"</td>"
						PRINT TABS(1) & "		<td class=""tcenter"">"&arrList_M_Name&"</td>"
						PRINT TABS(1) & "		<td class=""tcenter"">"&arrList_lvl&"</td>"
						PRINT TABS(1) & "		<td><a class=""btn_a"" onclick=""toggle_tbody('tbody"&i&"');"">"&LNG_BTN_DETAIL&"</a></td>"
						PRINT TABS(1) & "	</tr>"
						PRINT TABS(1) & "	<tbody id=""tbody"&i&""" class=""htbody"" style=""display:none;"">"
						PRINT TABS(1) & "		<tr>"
						PRINT TABS(1) & "			<td colspan=""2"" class=""tright"">"&LNG_TEXT_REGTIME&"</td>"
						PRINT TABS(1) & "			<td colspan=""3"" class=""pad_l15"">"&date8to10(arrList_Regtime)&"</td>"
						PRINT TABS(1) & "		</tr>"
						PRINT TABS(1) & "		<tr>"
						PRINT TABS(1) & "			<td colspan=""2"" class=""tright"">"&LNG_LEFT_MEM_INFO_CENTER&"</td>"
						PRINT TABS(1) & "			<td colspan=""3"" class=""pad_l15"">"&arrList_CenterName&"</td>"
						PRINT TABS(1) & "		</tr>"
						PRINT TABS(1) & "	</tbody>"
				Next
			Else
				PRINT TABS(1) & "	<tr>"
					PRINT TABS(1) & "		<td colspan=""5"" class=""notData"">"&LNG_TEXT_NO_DATA&"</td>"
				PRINT TABS(1) & "	</tr>"
			End If
		%>
	</table>
</div>
<div class="pagingArea pagingMob5"><% Call pageListMob5(PAGE,PAGECOUNT)%></div>

<form name="frm" method="post" action="">
	<input type="hidden" name="PAGE" value="<%=PAGE%>" />
	<input type="hidden" name="SDATE" value="<%=SDATE%>" />
	<input type="hidden" name="EDATE" value="<%=EDATE%>" />
</form>

<!--#include virtual = "/m/_include/copyright.asp"-->