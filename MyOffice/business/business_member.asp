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
<link rel="stylesheet" href="/myoffice/css/style_cs.css" />
<link rel="stylesheet" href="/myoffice/css/layout_cs.css" />
<link rel="stylesheet" href="default.css" />
<script type="text/javascript" src="/jscript/calendar.js"></script>
</head>
<body>
<!--#include virtual = "/_include/header.asp"-->
<div id="business" class="member mt">
	<form name="dateFrm" action="business_member.asp" method="post">
		<table <%=tableatt%> class="userCWidth table1">
			<col width="15%" />
			<col width="35%" />
			<col width="15%" />
			<col width="35%" />
			<tr>
				<th rowspan="2"><%=LNG_TEXT_REGTIME%></th>
				<td colspan="3">
					<button type="button" class="input_submit design2" onclick="chgDate('<%=DateAdd("m",-1,ThisM_1stDate)%>','<%=DateAdd("d",-1,ThisM_1stDate)%>');"><%=LNG_TEXT_LASTMONTH%></button>
					<button type="button" class="input_submit design2" onclick="chgDate('<%=ThisM_1stDate%>','<%=nowDate%>');"><%=LNG_TEXT_THISMONTH%></button>
					<button type="button" class="input_submit design2" onclick="chgDate('<%=DateAdd("m",-3,nowDate)%>','<%=nowDate%>');"><%=LNG_TEXT_3MONTH%></button>
					<button type="button" class="input_submit design2" onclick="chgDate('<%=nowDate%>','<%=nowDate%>');"><%=LNG_TEXT_TODAY%></button>
					<button type="button" class="input_submit design2" onclick="chgDate('<%=DateAdd("m",-6,nowDate)%>','<%=nowDate%>');"><%=LNG_TEXT_6MONTH%></button>
					<button type="button" class="input_submit design2" onclick="chgDate('<%=DateAdd("yyyy",-1,nowDate)%>','<%=nowDate%>');"><%=LNG_TEXT_1YEAR%></button>
					<button type="button" class="input_submit design2" onclick="chgDate('','');"><%=LNG_TEXT_ALL%></button>
				</td>
			</tr><tr>
				<td colspan="3">
					<input type="text" id="SDATE" name="SDATE" class="input_text tcenter" style="width:140px;" value="<%=SDATE%>" readonly="readonly" onclick="openCalendar(event, this, 'YYYY-MM-DD');" /> ~
					<input type="text" id="EDATE" name="EDATE" class="input_text tcenter" style="width:140px;" value="<%=EDATE%>" readonly="readonly" onclick="openCalendar(event, this, 'YYYY-MM-DD');" />
				</td>
			</tr>
			<tr>
				<th><%=LNG_TEXT_MEMID%></th>
				<td>
					<input type="text" name="MBID1" class="input_text tcenter" style="width:70px;" value="<%=MBID1%>" maxlength="2" onkeyup="this.value=this.value.replace(/[^a-zA-Z]/g,'');"/> ~
					<input type="text" name="MBID2" class="input_text" style="width:120px;" value="<%=MBID2%>" maxlength="<%=MBID2_LEN%>" <%=onlyKeys%> />
				</td>
				<th><%=LNG_TEXT_NAME%></th>
				<td>
					<input type="text" name="M_NAME" class="input_text tcenter" style="width: 210px;" value="<%=M_NAME%>" maxlength="20" />
				</td>
			</tr>
			<tr>
				<th><%=LNG_MEMBER_LOGIN_TEXT12%></th>
				<td>
					<label><input type="radio" name="LEAVE_CHECK" value="" <%=isChecked(LEAVE_CHECK,"")%> checked="checked"><%=LNG_TEXT_ALL%></label>
					<label><input type="radio" name="LEAVE_CHECK" value="1" <%=isChecked(LEAVE_CHECK,"1")%> ><%=LNG_STRTEXT_TEXT23_2%></label>
					<label><input type="radio" name="LEAVE_CHECK" value="0" <%=isChecked(LEAVE_CHECK,"0")%> ><%=LNG_TEXT_TREE_RESIGNED_MEMBER%></label>
				</td>
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
			<tr>
				<td colspan="4" class="tcenter" style="padding: 12px;">
					<input type="submit" value="<%=LNG_TEXT_SEARCH%>" class="input_submit design3" />
					<a href="<%=Request.ServerVariables("SCRIPT_NAME")%>" class="a_submit design8"><%=LNG_TEXT_INITIALIZATION%></a>
				</td>
			</tr>
		</table>
	</form>

	<p class="titles"><%=LNG_TEXT_LIST%></p>
	<table <%=tableatt1%> class="userCWidth list">
		<colgroup>
			<col width="70" />
			<col width="" />
			<col width="" />
			<col width="" />
			<col width="" />
		</colgroup>
		<tr>
			<th><%=LNG_TEXT_NUMBER%></th>
			<th><%=LNG_TEXT_MEMID%></th>
			<th><%=LNG_TEXT_NAME%></th>
			<!-- <th><%=LNG_TEXT_TEL%></th>
			<th><%=LNG_TEXT_MOBILE%></th> -->
			<th><%=LNG_TEXT_POSITION%></th>
			<th><%=LNG_TEXT_REGTIME%></th>
		</tr>
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
	<div class="pagingArea pagingNew3 userCWidth"><% Call pageListNew3(PAGE,PAGECOUNT)%></div>
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

<!--#include virtual = "/_include/copyright.asp"-->
