<!--#include virtual = "/_lib/strFunc.asp"-->
<%

	'PAGE_SETTING = "BCENTER"
	PAGE_SETTING = "MYOFFICE"
	INFO_MODE	 = "BCENTER1-1"

	ISSUBTOP = "T"




	Call ONLY_BUSINESS_MEMBER(DK_MEMBER_LEVEL,2)
	Call ONLY_CS_MEMBER()
	Call ONLY_BUSINESS(BUSINESS_CODE)

	PAGE		= pRequestTF("PAGE",False)
	SDATE		= pRequestTF("SDATE",False)
	EDATE		= pRequestTF("EDATE",False)
	LEAVE_CHECK	= pRequestTF("LEAVE_CHECK",False)
	GRADE_CNT	= pRequestTF("GRADE_CNT",False)
	M_NAME	= pRequestTF("M_NAME",False)
	MBID1	= pRequestTF("MBID1",False)
	MBID2	= pRequestTF("MBID2",False)

	If PAGE = ""		Then PAGE = 1
	If PAGESIZE = ""	Then PAGESIZE = 15
	If SDATE = ""		Then SDATE = ""
	If EDATE = ""		Then EDATE = ""
	If LEAVE_CHECK = ""		Then LEAVE_CHECK = ""
	If GRADE_CNT = ""		Then GRADE_CNT = ""
	If M_NAME = ""		Then M_NAME = ""
	If MBID1 = ""		Then MBID1 = ""
	If MBID2 = ""		Then MBID2 = ""

	arrParams = Array(_
		Db.makeParam("@NCODE",adVarChar,adParamInput,20,BUSINESS_CODE),_
		Db.makeParam("@PAGE",adInteger,adParamInput,0,PAGE),_
		Db.makeParam("@PAGESIZE",adInteger,adParamInput,0,PAGESIZE),_

		Db.makeParam("@SDATE",adVarChar,adParamInput,10,SDATE),_
		Db.makeParam("@EDATE",adVarChar,adParamInput,10,EDATE),_
		Db.makeParam("@LEAVE_CHECK",adChar,adParamInput,1,LEAVE_CHECK),_
		Db.makeParam("@GRADE_CNT",adVarChar,adParamInput,10,GRADE_CNT),_
		Db.makeParam("@M_NAME",adVarWChar,adParamInput,100,M_NAME),_

		Db.makeParam("@mbid1",adVarChar,adParamInput,20,MBID1), _
		Db.makeParam("@mbid2",adVarChar,adParamInput,10,MBID2), _

		Db.makeParam("@ALL_COUNT",adInteger,adParamOutput,0,0) _
	)
	arrList = Db.execRsList("HJP_BUSINESS_MEMBER_LIST",DB_PROC,arrParams,listLen,DB3)
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
<link rel="stylesheet" href="member.css" />
<link rel="stylesheet" href="/m/css/sticky_table.css?" />
<style>
	.sticky-wrap {
		margin: auto;
		overflow: auto;
		white-space: nowrap;
	}
	.sticky-wrap th:nth-child(1),
	.sticky-wrap td:nth-child(1){
		position: -webkit-sticky;
		position: sticky;
		left: 0px;
		width: 40px;
		min-width: 40px;
		box-shadow: inset -4px 0px 3px -4px rgba(131, 131, 131, 0.5);
	}
	.sticky-wrap td:nth-child(1) { background: #ffffff; }
</style>

</head>
<body>
<!--#include virtual = "/m/_include/header.asp"-->
<!--#include virtual = "/m/_include/sub_header.asp"-->
<div id="subTitle" class="width100 tcenter text_noline" ><%=LNG_MYOFFICE_BCENTER_01%></div>
<div id="div_date">
	<form name="dateFrm" action="" method="post">
		<table <%=tableatt%> class="width100">
			<col class="col-mw65"/>
			<col class="" />
			<tr>
				<th rowspan="2"><%=LNG_TEXT_REGTIME%></th>
				<td>
					<span class="button medium"><button type="button" onclick="chgDate('<%=DateAdd("m",-1,ThisM_1stDate)%>','<%=DateAdd("d",-1,ThisM_1stDate)%>');"><%=LNG_TEXT_LASTMONTH%></button></span>
					<span class="button medium"><button type="button" onclick="chgDate('<%=ThisM_1stDate%>','<%=nowDate%>');"><%=LNG_TEXT_THISMONTH%></button></span>
					<span class="button medium"><button type="button" onclick="chgDate('<%=DateAdd("m",-3,nowDate)%>','<%=nowDate%>');"><%=LNG_TEXT_3MONTH%></button></span>
					<span class="button medium"><button type="button" onclick="chgDate('<%=nowDate%>','<%=nowDate%>');"><%=LNG_TEXT_TODAY%></button></span>
					<span class="button medium"><button type="button" onclick="chgDate('','');"><%=LNG_TEXT_ALL%></button></span>
				</td>
			</tr><tr>
				<td>
					<input type="text" id="SDATE" name="SDATE" class="input_text readonly" style="width:100px;" value="<%=SDATE%>" readonly="readonly" onclick="openCalendar(event, this, 'YYYY-MM-DD');" /> ~
					<input type="text" id="EDATE" name="EDATE" class="input_text readonly" style="width:100px;" value="<%=EDATE%>" readonly="readonly" onclick="openCalendar(event, this,
					'YYYY-MM-DD');" />
				</td>
			</tr>
			<tbody id="filter" style="display: none;" >
				<tr>
					<th><%=LNG_TEXT_MEMID%></th>
					<td>
						<input type="text" name="MBID1" class="input_text tcenter" style="width:70px;" value="<%=MBID1%>" maxlength="2" onkeyup="this.value=this.value.replace(/[^a-zA-Z]/g,'');"/> ~
						<input type="text" name="MBID2" class="input_text" style="width:120px;" value="<%=MBID2%>" maxlength="<%=MBID2_LEN%>" <%=onlyKeys%> />
					</td>
				</tr><tr>
					<th><%=LNG_TEXT_NAME%></th>
					<td>
						<input type="text" name="M_NAME" class="input_text tcenter" style="width: 210px;" value="<%=M_NAME%>" maxlength="20" />
					</td>
				</tr><tr>
					<th><%=LNG_MEMBER_LOGIN_TEXT12%></th>
					<td>
						<label><input type="radio" name="LEAVE_CHECK" value="" <%=isChecked(LEAVE_CHECK,"")%> checked="checked"><%=LNG_TEXT_ALL%></label>
						<label><input type="radio" name="LEAVE_CHECK" value="1" <%=isChecked(LEAVE_CHECK,"1")%> ><%=LNG_STRTEXT_TEXT23_2%></label>
						<label><input type="radio" name="LEAVE_CHECK" value="0" <%=isChecked(LEAVE_CHECK,"0")%> ><%=LNG_TEXT_TREE_RESIGNED_MEMBER%></label>
					</td>
				</tr><tr>
					<th><%=LNG_TEXT_PAY_CATEGORY%>(<%=LNG_TEXT_POSITION%>)</th>
					<td>
						<select name="GRADE_CNT" class="input_select">
							<option value=""></option>
							<%
								SQL_BC = "SELECT [Grade_Cnt],[Grade_Name] FROM [tbl_Class] WITH(NOLOCK) ORDER BY [Grade_Cnt] ASC"
								arrList_BC = Db.execRsList(SQL_BC,DB_TEXT,Nothing,listLenBC,DB3)
								If IsArray(arrList_BC) Then
									For i = 0 To listLenBC
										PRINT TABS(5)& "	<option value="""&arrList_BC(0,i)&""" """&isSelect(GRADE_CNT,arrList_BC(0,i))&""">"&arrList_BC(1,i)&"</option>"
									Next
								Else
									PRINT TABS(5)& "	<option value="""">"&LNG_TEXT_NO_DATA&"</option>"
								End If
							%>
						</select>
					</td>
				</tr>
			</tbody>
			<tr>
				<th><%=LNG_TEXT_SEARCH%></th>
				<td>
					<div class="fleft">
						<input type="submit" id="searchBtn" class="txtBtn search radius3"  value="<%=LNG_TEXT_SEARCH%>"/>
						<input type="button" class="txtBtn small3 radius3" value="<%=LNG_TEXT_INITIALIZATION%>" onclick="location.href='/m/business/business_member.asp';"/>
						&nbsp;&nbsp;<input type="button" id="searchBtn" class="txtBtn s_modify radius3" onclick="toggle_filter('filter');"  value="필터"/>
					</div>
				</td>
			</tr>
		</table>
	</form>
</div>

<%
	'table sorter
	'<thead></thead> 필수!
%>
<link rel="stylesheet" href="/jscript/tablesorter/jquery.wprTablesorter.css">
<script type="text/javascript" src="/jscript/tablesorter/jquery.wprTablesorter.js"></script>
<script type="text/javascript">
	//table sorter
	$(document).ready(function() {
		$("#sortTable").wprTablesorter({
			firstColFix : false,	//첫번째열 고정
			firstColasc : false,	//첫번째열 오름차순 여부	//firstColFix=true일 경우 필수값
			//noSortColumns : [0]		//정렬안하는 컬럼
		});
	});
</script>
<div id="business">
	<p class="titles"><%=LNG_TEXT_LIST%> <%=UnderMemberInfo%></p>
	<div class="sticky-wrap">
		<table id="sortTable" <%=tableatt%> class="width100">
			<thead>
				<tr>
					<th class="first"><%=LNG_TEXT_NUMBER%></th>
					<th class="second"><%=LNG_TEXT_MEMID%></th>
					<th><%=LNG_TEXT_NAME%></th>
					<!-- <th><%=LNG_TEXT_TEL%></th>
					<th><%=LNG_TEXT_MOBILE%></th> -->
					<th><%=LNG_TEXT_POSITION%></th>
					<th><%=LNG_TEXT_REGTIME%></th>
				</tr>
			</thead>
			<%
			Set objEncrypter = Server.CreateObject ("Hyeongryeol.StringEncrypter")
				objEncrypter.Key = con_EncryptKey
				objEncrypter.InitialVector = con_EncryptKeyIV
				On Error Resume Next

				If IsArray(arrList) Then
					For i = 0 To listLen
						'ThisNum = ALL_COUNT - CInt(arrList(0,i)) + 1
						ThisNum 		 = arrList(0,i)
						arrList_mbid	 = arrList(1,i)
						arrList_mbid2	 = arrList(2,i)
						arrList_M_Name	 = arrList(3,i)
						arrList_hometel	 = arrList(4,i)
						arrList_hptel	 = arrList(5,i)
						arrList_CurGrade = arrList(6,i)
						arrList_regTime  = arrList(7,i)

						If arrList_hometel <> "" Then arrList_hometel = objEncrypter.Decrypt(arrList_hometel)
						If arrList_hptel <> "" Then arrList_hptel = objEncrypter.Decrypt(arrList_hptel)

						PRINT TABS(1)& "	<tr>"
						PRINT TABS(1)& "		<td>"&ThisNum&"</td>"
						PRINT TABS(1)& "		<td>"&arrList_mbid&"-"&Fn_MBID2(arrList_mbid2)&"</td>"
						PRINT TABS(1)& "		<td>"&arrList_M_Name&"</td>"
						'PRINT TABS(1)& "		<td>"&arrList_hometel&"</td>"
						'PRINT TABS(1)& "		<td>"&arrList_hptel&"</td>"
						PRINT TABS(1)& "		<td>"&arrList_CurGrade&"</td>"
						PRINT TABS(1)& "		<td>"&date8to10(arrList_regTime)&"</td>"
						PRINT TABS(1)& "	</tr>"
					Next
				Else
					PRINT TABS(1) & "		<tr>"
					PRINT TABS(1) & "			<td colspan=""5"" class=""notData"">"&LNG_TEXT_NO_DATA&"</td>"
					PRINT TABS(1) & "		</tr>"
				End If

				On Error GoTo 0
			Set objEncrypter = Nothing
			%>
		</table>
	</div>
</div>
<div class="pagingArea pagingMob5n"><% Call pageListMob5n(PAGE,PAGECOUNT)%></div>

<form name="frm" method="post" action="">
	<input type="hidden" name="PAGE" value="<%=PAGE%>" />
	<input type="hidden" name="PAGESIZE" value="<%=PAGESIZE%>" />
	<input type="hidden" name="SDATE" value="<%=SDATE%>" />
	<input type="hidden" name="EDATE" value="<%=EDATE%>" />
	<input type="hidden" name="LEAVE_CHECK" value="<%=LEAVE_CHECK%>" />
	<input type="hidden" name="GRADE_CNT" value="<%=GRADE_CNT%>" />
	<input type="hidden" name="M_NAME" value="<%=M_NAME%>" />
	<input type="hidden" name="MBID1" value="<%=MBID1%>" />
	<input type="hidden" name="MBID2" value="<%=MBID2%>" />
</form>

<!--#include virtual = "/m/_include/copyright.asp"-->
