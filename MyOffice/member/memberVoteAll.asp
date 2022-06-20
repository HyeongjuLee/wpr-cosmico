<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	PAGE_SETTING = "MYOFFICE"
	INFO_MODE	 = "MEMBER1-2"

	ISLEFT = "T"
	ISSUBTOP = "T"

	Call ONLY_BUSINESS_MEMBER(DK_MEMBER_LEVEL,2)
	Call ONLY_CS_MEMBER()

	SDATE = pRequestTF("SDATE",False)
	EDATE = pRequestTF("EDATE",False)

	PAGE = pRequestTF("PAGE",False)
	PAGESIZE = 20
	If PAGE = "" Then PAGE = 1

%>
<!--#include virtual = "/_include/document.asp"-->
<link rel="stylesheet" href="/myoffice/css/style_cs.css" />
<link rel="stylesheet" href="/myoffice/css/layout_cs.css" />
<script type="text/javascript" src="/jscript/calendar.js"></script>
</head>
<body>
<!--#include virtual = "/_include/header.asp"-->
<!-- <div id="buy" class="orderList"> -->
<div id="member" class="member_vote">
	<form name="dateFrm" action="memberVoteAll.asp" method="post">
	<table <%=tableatt%> class="userCWidth table1">
			<col width="200" />
			<col width="*" />
			<tr>
				<th rowspan="2"><%=LNG_TEXT_REGTIME%></th>
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
					<input type="text" id="SDATE" name="SDATE" class="input_text tcenter tweight" value="<%=SDATE%>" readonly="readonly" onclick="openCalendar(event, this, 'YYYY-MM-DD');" /> ~
					<input type="text" id="EDATE" name="EDATE" class="input_text tcenter tweight" value="<%=EDATE%>" readonly="readonly" onclick="openCalendar(event, this, 'YYYY-MM-DD');" />
					<input type="submit" class="txtBtn small2 radius3" value="<%=LNG_TEXT_SEARCH%>"/>
				</td>
			</tr>
		</table>
	</form>
	<p class="titles"><%=LNG_TEXT_LIST%></p>
	<table <%=tableatt%> class="userCWidth table2">
		<col width="60" />
		<col width="" />
		<col width="" />
		<col width="" />
		<col width="" />
		<col width="*" />
		<tr>
			<th><%=LNG_TEXT_NUMBER%></th>
			<th><%=LNG_TEXT_MEMID%></th>
			<th><%=LNG_TEXT_NAME%></th>
			<th><%=LNG_TEXT_LEVEL%></th>
			<th><%=LNG_TEXT_REGTIME%></th>
			<th><%=LNG_LEFT_MEM_INFO_CENTER%></th>
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
						arrList_LineCnt				= arrList(4,i)
						arrList_N_LineCnt			= arrList(5,i)
						arrList_businesscode	= arrList(6,i)
						arrList_Regtime			= arrList(7,i)
						arrList_Saveid			= arrList(8,i)
						arrList_Saveid2			= arrList(9,i)
						arrList_Nominid			= arrList(10,i)
						arrList_Nominid2		= arrList(11,i)
						arrList_LeaveCheck		= arrList(12,i)
						arrList_WebID			= arrList(13,i)
						arrList_Sell_Mem_TF		= arrList(14,i)
						arrList_CurGrade			= arrList(15,i)
						arrList_CenterName		= arrList(16,i)
						arrList_Grade_Name			= arrList(17,i)
						arrList_SaveName			= arrList(18,i)
						arrList_NominName			= arrList(19,i)
						arrList_lvl			= arrList(20,i)

						PRINT TABS(1) & "	<tr>"
						PRINT TABS(1) & "		<td>"&ThisNum&"</td>"
						PRINT TABS(1) & "		<td>"&arrList_mbid&"-"&arrList_mbid2&"</td>"
						PRINT TABS(1) & "		<td>"&arrList_M_Name&"</td>"
						PRINT TABS(1) & "		<td>"&arrList_lvl&"</td>"
						PRINT TABS(1) & "		<td>"&date8to10(arrList_Regtime)&"</td>"
						PRINT TABS(1) & "		<td>"&arrList_CenterName&"</td>"
						PRINT TABS(1) & "	</tr>"
					Next
				Else
					PRINT TABS(1) & "		<tr>"
					PRINT TABS(1) & "			<td colspan=""6"" class=""notData"">"&LNG_TEXT_NO_DATA&"</td>"
					PRINT TABS(1) & "		</tr>"
				End If
		%>
	</table>
	<div class="pagingArea pagingNew4 userCWidth"><% Call pageListNew3(PAGE,PAGECOUNT)%></div>
</div>
<form name="frm" method="post" action="">
	<input type="hidden" name="PAGE" value="<%=PAGE%>" />
	<input type="hidden" name="SDATE" value="<%=SDATE%>" />
	<input type="hidden" name="EDATE" value="<%=EDATE%>" />
</form>
<!--#include virtual = "/_include/copyright.asp"-->
