<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	PAGE_SETTING = "MYOFFICE"
	INFO_MODE	 = "BCENTER1-1"

	ISLEFT = "T"
	ISSUBTOP = "T"
	OVERFLOW_VISIBLE = "F"

	Call ONLY_BUSINESS_MEMBER(DK_MEMBER_LEVEL,2)
	Call ONLY_CS_MEMBER()
	Call ONLY_BUSINESS(BUSINESS_CODE)

	SDATE		= pRequestTF("SDATE",False)
	EDATE		= pRequestTF("EDATE",False)
	LEAVE_CHECK	= pRequestTF("LEAVE_CHECK",False)
	GRADE_CNT	= pRequestTF("GRADE_CNT",False)
	M_NAME	= pRequestTF("M_NAME",False)
	MBID1	= pRequestTF("MBID1",False)
	MBID2	= pRequestTF("MBID2",False)
	PAGE		= pRequestTF("PAGE",False)

	If PAGE = ""		Then PAGE = 1
	If PAGESIZE = ""	Then PAGESIZE = 20
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
<!--#include virtual = "/_include/document.asp"-->
<!-- <link rel="stylesheet" href="/myoffice/css/style_cs.css" /> -->
<!-- <link rel="stylesheet" href="/myoffice/css/layout_cs.css" /> -->
<link rel="stylesheet" href="/css/myoffice-business.css?" />
<link rel="stylesheet" href="default.css" />
<script type="text/javascript" src="/jscript/calendar.js"></script>
</head>
<body>
<!--#include virtual = "/_include/header.asp"-->
<div id="myoffice_business" class="member">
	<form name="dateFrm" action="business_member.asp" method="post">
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
			<article class="members">
				<h6><%=LNG_TEXT_MEMID%></h6>
				<div class="memberNum">
					<div class="inputs">
						<input type="text" name="MBID1" class="input_text" value="<%=MBID1%>" maxlength="2" onkeyup="this.value=this.value.replace(/[^a-zA-Z]/g,'');"/>
						<span>-</span>
						<input type="text" name="MBID2" class="input_text" value="<%=MBID2%>" maxlength="<%=MBID2_LEN%>" <%=onlyKeys%> />
					</div>
				</div>
				<h6><%=LNG_TEXT_NAME%></h6>
				<div class="name">
					<input type="text" name="M_NAME" class="input_text" value="<%=M_NAME%>" maxlength="20" />
				</div>
				<h6><%=LNG_TEXT_PAY_CATEGORY%>(<%=LNG_TEXT_POSITION%>)</h6>
				<div class="rank">
					<select name="GRADE_CNT" class="input_select">
						<option value="" selected disabled><%=LNG_TEXT_POSITION%></option>
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
				</div>
			</article>
			<article class="searchs">
				<h6><%=LNG_MEMBER_LOGIN_TEXT12%></h6>
				<div class="labels">
					<label><input type="radio" name="LEAVE_CHECK" value="" <%=isChecked(LEAVE_CHECK,"")%> checked="checked"><span><i class="icon-ok"></i><%=LNG_TEXT_ALL%></span></label>
					<label><input type="radio" name="LEAVE_CHECK" value="1" <%=isChecked(LEAVE_CHECK,"1")%> ><span><i class="icon-ok"></i><%=LNG_STRTEXT_TEXT23_2%></span></label>
					<label><input type="radio" name="LEAVE_CHECK" value="0" <%=isChecked(LEAVE_CHECK,"0")%> ><span><i class="icon-ok"></i><%=LNG_TEXT_TREE_RESIGNED_MEMBER%></span></label>
				</div>
				<input type="submit" value="<%=LNG_TEXT_SEARCH%>" class="search_btn" />
				<a href="<%=Request.ServerVariables("SCRIPT_NAME")%>" class="search_reset"><%=LNG_TEXT_INITIALIZATION%></a>
			</article>
		</div>
	</form>


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
	<p class="titles"><%=LNG_TEXT_LIST%></p>
	<table <%=tableatt0%> class="table tcenter" id="sortTable">
		<colgroup>
			<col width="70" />
			<col width="" />
			<col width="" />
			<col width="" />
			<col width="" />
		</colgroup>
		<thead>
			<tr>
				<th><%=LNG_TEXT_NUMBER%></th>
				<th><%=LNG_TEXT_MEMID%></th>
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
					PRINT TABS(1)& "	<tr>"
					PRINT TABS(1)& "		<td colspan=""5"" style=""height:80px;"">"&LNG_CS_BUSINESS_MEMBER_TEXT09&"</td>"
					PRINT TABS(1)& "	</tr>"
				End If
				On Error GoTo 0
			Set objEncrypter = Nothing
		%>
	</table>
	<div class="pagingArea pagingNew3"><% Call pageListNew3(PAGE,PAGECOUNT)%></div>
</div>
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
</div>
<!--#include virtual = "/_include/copyright.asp"-->
