<!--#include virtual = "/_lib/strFunc.asp"-->
<%																	'■ strScheduleType 기준
	PAGE_SETTING = "NOTICE"
	ISLEFT = "T"
	ISSUBTOP = "T"

	'view = 7
	mNum = 5
	schType = gRequestTF("stype", True)					'strScheduleType 추가
%>
<!--#include file = "schedule_config.asp"-->
<%
	syear = checkNumeric(gRequestTF("syear", False))
	smonth = checkNumeric(gRequestTF("smonth", False))
	to_day = Day(nowTime)

	If Not IsDate(syear &"-"& smonth &"-1") Then
		syear = Year(nowTime)
		smonth = Month(nowTime)
	End If

'	params = "syear="& syear &"&smonth="& smonth
	params = "syear="& syear &"&smonth="& smonth &"&stype="&schType

	sYearMonth = syear &"-"& setZeroFill(smonth, 2) &"-01"
	sYearMonthP = DateAdd("m",-1,sYearMonth)
	sYearMonthN = DateAdd("m",1,sYearMonth)

	nowParams = "syear="& Year(nowTime)		&"&smonth="& Month(nowTime)		&"&stype="&schType
	prevParam = "syear="& Year(sYearMonthP) &"&smonth="& Month(sYearMonthP)	&"&stype="&schType
	nextParam = "syear="& Year(sYearMonthN) &"&smonth="& Month(sYearMonthN)	&"&stype="&schType

	sdate = syear &"-"& smonth &"-1"
	firstWeek = Weekday(sdate)
	lastDay = getLastDay(syear, smonth)

	sYearMonth = syear &"-"& setZeroFill(smonth, 2) &"-"


	SQL = "SELECT [intIDX], [Date], [StartTime], [EndTime], [strSubject], [Place], [strContent] FROM [DK_DIARY]"
	SQL = SQL &" WHERE [Date] LIKE ? "
	'SQL = SQL &" AND [strUserID] = ? "
	SQL = SQL &" AND [strNation] = '"&Lang&"' "
	SQL = SQL &" AND [strScheduleType] = '"&schType&"' "
	SQL = SQL &" ORDER BY [Date] ASC, [StartTime] ASC"

	'▣ ID별 일정 호출 ▣
	'MY_MEMBER_ID = DK_MEMBER_ID
	MY_MEMBER_ID = "admin"

		'Db.makeParam("@strUserID",adVarchar,adParamInput,20,MY_MEMBER_ID) _
	arrParams = Array( _
		Db.makeParam("@Date",adVarchar,adParamInput,10,sYearMonth &"%") _
	)
	Set Rs = Db.execRs(SQL,DB_TEXT,arrParams,Nothing)

	If Not Rs.bof And Not Rs.eof Then
		flagRs = True
	Else
		flagRs = False
		Call closeRs(Rs)
	End If


	If Lang = "kr" Or Lang = "" Then
		txtbg = "txtbg"
	Else
		txtbg = ""
	End If

%>
<!--#include virtual = "/_include/document.asp"-->
<link rel="stylesheet" type="text/css" href="schedule.css" />
<script type="text/javascript" src="subVisual.js"></script>
<script type="text/javascript" src="schedule.js"></script>
</head>
<body>
<!--#include virtual = "/_include/header.asp"-->
<!--'include virtual = "/_include/sub_title.asp"-->
<%=viewTitleGroup%>
<form name="sfrm" method="post" action="schedule.asp" >
<div id="schedulearea">
	<div id="schedule" class="width100">
		<div class="yyyydd">
			<span class="numbg n<%=Left(syear,1)%>"></span>
			<span class="numbg n<%=Mid(syear,2,1)%>"></span>
			<span class="numbg n<%=Mid(syear,3,1)%>"></span>
			<span class="numbg n<%=Right(syear,1)%>"></span>
			<span class="numbg dot"></span>
			<span class="numbg n<%=Left(setZeroFill(smonth,2),1)%>"></span>
			<span class="numbg n<%=Right(setZeroFill(smonth,2),1)%>"></span>
			<span class="<%=txtbg%>"></span>
		</div>
		<div class="move_yyyydd">
			<span class="button medium f10px"><a href="?<%=prevParam%>">◀</a></span><span class="button medium f10px"><a href="?<%=nextParam%>">▶</a></span>
			<span class="button medium strong"><a href="?<%=nowParams%>"><%=LNG_SCHEDULE_TEXT01%></a></span>
		</div>

		<table <%=tableatt%> class="width100 sche">
			<colgroup>
				<col width="14%" />
				<col width="14%" />
				<col width="14%" />
				<col width="14%" />
				<col width="14%" />
				<col width="14%" />
				<col width="14%" />
			</colgroup>
			<thead>
				<tr>
					<th class="sun"><%=LNG_SCHEDULE_TEXT02%></th>
					<th><%=LNG_SCHEDULE_TEXT03%></th>
					<th><%=LNG_SCHEDULE_TEXT04%></th>
					<th><%=LNG_SCHEDULE_TEXT05%></th>
					<th><%=LNG_SCHEDULE_TEXT06%></th>
					<th><%=LNG_SCHEDULE_TEXT07%></th>
					<th class="sat"><%=LNG_SCHEDULE_TEXT08%></th>
				</tr>
			</thead>
			<tbody>
			<%
				viewDay = 1
				diaryCnt = 0

				SQL = "SELECT [day],[comment] FROM [DK_HOLIDAY] WHERE [year] = ? AND [month] = ?"
				arrParams = Array(_
					Db.makeParam("@year",adInteger,adParamInput,0,syear),_
					Db.makeParam("@smonth",adInteger,adParamInput,0,smonth)_
				)
				arrList = Db.execRsList(SQL,DB_TEXT,arrParams,listLen,Nothing)

				For Row = 1 To 6
					PRINT "<tr>"

					For Col = 1 To 7
						If (Row = 1 And Col < firstWeek) Or (viewday > lastDay) Then
							PRINT "<td class=""hts""></td>"
						Else
							targetDate = syear &"-"& setZeroFill(smonth, 2) &"-"& setZeroFill(viewDay, 2)

							Select Case col
								Case 1 : FontColor = "sun"
								Case 7 : FontColor = "sat"
								Case Else : FontColor = "week"
							End Select
							holiday = ""
							cosmos = ""

						'오늘날짜 강조
						If syear = Year(nowTime) And smonth = Month(nowTime) And viewday = to_day Then
							FontColor = "today"
						End If

							'arrHoliday = ""
							If IsArray(arrList) Then
								For i = 0 To listLen
									If viewDay = arrList(0,i) Then
										holiday = "sun"
										If arrList(1,i) <> "" Or Not IsNull(arrList(1,i)) Then
											cosmos = " <span class=""cosmos"">("&arrList(1,i)&")</span>"
										End If
									End If
								Next
							End If

							'If InStr(arrHoliday,viewDay) > 0 Then holiday = "sun"

							param = syear&Right("00"&smonth,2)&Right("00"&viewDay,2)


							'Select Case smonth
							'	Case 12
							'		Select Case viewDay
							'			Case 25 : holiday = "sun"
							'		End Select
							'End Select

							'<a href=""schedule_view.asp?param="&param&""">

							Select Case col
								Case 1
									COL_MARGIN = 5
								Case 6
									COL_MARGIN = -80
								Case 7
									COL_MARGIN = -150
								Case Else
									COL_MARGIN = 0
							End Select


							PRINT "<td class=""hts "&FontColor&"""><div class=""days""><p class=""dd "&FontColor&" "&holiday&""" style=""margin-bottom:5px;"" ><a style=""a:hover {color:red;}"">"&viewDay&"</a>"&cosmos&"</p>"
							If flagRs Then
								Do Until Rs.eof
									uid = Trim(Rs("intIDX"))
									nDate = Trim(Rs("Date"))
									startTime = Trim(Rs("StartTime"))
									endTime = Trim(Rs("EndTime"))
									subject = Trim(Rs("strSubject"))
									place = Trim(Rs("Place"))
									content = Trim(Rs("strContent"))

									If nDate = targetDate Then
			%>

									<div class="">
										<a onmouseover="toggle('divDetail<%=uid%>');" onmouseout="toggle('divDetail<%=uid%>');" class="week cp"><span class="layers"><%=cutString2(subject,10)%></span></a>
									</div>
									<div id="divDetail<%=uid%>" class="hiddendiv" style="margin-left:<%=COL_MARGIN%>px;">
										<table <%=tableatt%>>
											<tr>
												<th><%=LNG_SCHEDULE_TEXT09%></th>
												<td bgcolor="#FFFFFF"><%=subject%>&nbsp;</td>
											</tr><tr>
												<th><%=LNG_SCHEDULE_TEXT10%></th>
												<td bgcolor="#FFFFFF"><%=startTime%> ~ <%=endTime%>&nbsp;</td>
											</tr><tr>
												<th><%=LNG_SCHEDULE_TEXT11%></th>
												<td bgcolor="#FFFFFF"><%=place%>&nbsp;</td>
											</tr><tr>
												<th><%=LNG_SCHEDULE_TEXT12%></th>
												<td bgcolor="#FFFFFF"><%=content%>&nbsp;</td>
											</tr>
										</table>
									</div>
			<%
										'PRINT "<p>"
										'PRINT "<img src="""&IMG_SHARE&"/sche_icon.gif"" width=""12"" height=""12"" />"
										'PRINT subject
										'PRINT "</p>"
										Rs.MoveNext
									ElseIf nDate > targetDate Then
										Exit Do
									End If
								Loop
							End If

							PRINT "</div></td>"
						viewDay = viewDay + 1

						End If
					Next
					PRINT "</tr>"
					If viewDay > lastDay Then Exit For
				Next
			%>
			</tbody>
		</table>
	</div>
	<%
		'If DK_MEMBER_TYPE = "ADMIN" Or DK_MEMBER_TYPE = "OPERATOR" Or DK_MEMBER_TYPE = "COMPANY" Then
		If DK_MEMBER_TYPE = "ADMIN" Or DK_MEMBER_TYPE = "OPERATOR" Then
	%>
		<div style="margin-top:30px;margin-bottom:50px;" class="cleft tright width100">
			<!-- <a href="javascript:scheduleControl();"><img src="<%=IMG_CONTENT%>/schedule_reg_btn.gif" /> -->
			<input type="button" class="txtBtn large" style="width:150px;background-color:#4fbfe3;color:#fff;border:2px solid #65a5de;" value="<%=LNG_SCHEDULE_BTN01%>" onclick="javascript:scheduleControl('<%=params%>');">
			<!-- <input type="button" class="txtBtn large" style="width:150px;background-color:#4fbfe3;color:#fff;border:2px solid #65a5de;" value="<%=LNG_SCHEDULE_BTN01%>" onclick="javascript:scheduleControl('<%=schType%>');"> -->
		</div>
	<%
		End If
	%>
</div>
</form>
<!--#include virtual = "/_include/copyright.asp"-->
