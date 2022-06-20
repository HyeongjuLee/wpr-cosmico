<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<!--#include virtual = "/admin/_inc/document.asp"-->
<%
	ADMIN_LEFT_MODE = "MYOFFICE"
	INFO_MODE = "MYOFFICE1-1"

	syear = checkNumeric(gRequestTF("syear", False))
	smonth = checkNumeric(gRequestTF("smonth", False))


	If Not IsDate(syear &"-"& smonth &"-1") Then
		syear = Year(nowTime)
		smonth = Month(nowTime)
	End If
	
	to_day = Day(nowTime)

	sdate = syear &"-"& smonth &"-1"
	firstWeek = Weekday(sdate)
	lastDay = getLastDay(syear, smonth)



	sYearMonth = syear &"-"& setZeroFill(smonth, 2) &"-"

'	PRINT to_day
'	PRINT sYearMonth
'	PRINT slocation
'	PRINT sloctype
	sql = "SELECT [intIDX], [Date], [StartTime], [EndTime], [strSubject], [Place], [strContent] FROM [DK_DIARY]"
	sql = sql &" WHERE [Date] LIKE ?"
	sql = sql &" ORDER BY [Date] ASC, [StartTime] ASC"
	arrParams = Array( _
		Db.makeParam("@Date", adVarchar, adParamInput, 10, sYearMonth) _
	)
	Set Rs = Db.execRs("DKPA_SCHEDULER_LIST",DB_PROC,arrParams,Nothing)
	If Not Rs.bof And Not Rs.eof Then
		flagRs = True
	Else
		flagRs = False
		Call closeRs(Rs)
	End If
%>
<script type="text/javascript">
<!--
	function toggle(elmId) {
		var objLayer = document.getElementById(elmId);

		if (objLayer.style.display == "block") {
			var menuLocBod = window.document.body;
			var xPos = menuLocBod.scrollLeft + event.clientX;
			var yPos = menuLocBod.scrollTop + event.clientY;

			objLayer.style.pixelLeft = xPos;
			objLayer.style.pixelTop = yPos;
			objLayer.style.display="none";
		}
		else {
			objLayer.style.display="block";
		}
	}
//-->
</script>
<link rel="stylesheet" href="schedule.css" />
</head>
<body>
<!--#include virtual = "/admin/_inc/header.asp"-->
<div id="schedule">
	<p class="titles">검색조건</p>
	<form name="sfrm" method="get" action="schedule.asp">
		<table <%=tableatt%> class="adminFullWidth search">
			<col width="200" />
			<col width="800" />
			<tr>
				<th>일정표</th>
				<td>
					<select name="syear" class="vmiddle">
						<%
							For i = 2010 To 2022
								PRINT "<option value="""&i&""" "&isSelect(i,syear)&">"&i&" 년</option>"
							Next
						%>
					</select>
					<select name="smonth" class="vmiddle">
						<%
							For i = 1 To 12
								PRINT "<option value="""&i&""" "&isSelect(i,smonth)&">"&i&" 월</option>"
							Next
						%>
					</select>
					<input type="image" src="<%=IMG_BTN%>/g_list_search.gif" class="vmiddle" />
				</td>
			</tr>
		</table>
	</form>
	<div class="sche">
		<table <%=tableatt%> width="1000">
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
					<th colspan="7" class="notBor tleft" style="font-size:11pt; color:#000;"><span class="fleft"><%=syear%>년 <%=smonth%>월 일정표</span>
					<span class="fright">
						<%=aImgOPT("schedule.asp?syear="&syear&"&amp;smonth="&smonth,"S",IMG_BTN&"/btn_schedule_calendar_on.gif",130,25,"","")%>
						<%=aImgOPT("schedule_week.asp?syear="&syear&"&amp;smonth="&smonth,"S",IMG_BTN&"/btn_schedule_list_off.gif",130,25,"","")%>
					</span></th>
				</tr><tr>
					<th class="sun">SUN</th>
					<th>MON</th>
					<th>TUE</th>
					<th>WED</th>
					<th>THU</th>
					<th>FRI</th>
					<th class="sat">SAT</th>
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
				PRINT "<td></td>"
			Else
				targetDate = syear &"-"& setZeroFill(smonth, 2) &"-"& setZeroFill(viewDay, 2)

				Select Case col
					Case 1 : FontColor = "sun"
					Case 7 : FontColor = "sat"
					Case Else : FontColor = "week"
				End Select
				holiday = ""
				cosmos = ""

'				arrHoliday = ""

				If syear = Year(nowTime) And smonth = Month(nowTime) And viewday = to_day Then						'오늘날짜 강조
					FontColor = "today"
				End If

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

'				If InStr(arrHoliday,viewDay) > 0 Then holiday = "sun"




'				Select Case smonth
'					Case 12
'						Select Case viewDay
'							Case 25 : holiday = "sun"
'						End Select
'				End Select


				PRINT "<td class=""hts "&FontColor&"""><div class=""days""><a href=""schedule_regist.asp?param="&targetDate&"&amp;lm=cal""><span class="""&FontColor&" "&holiday&""" style=""font-size:15px;"">"&viewDay&cosmos&"</span></a>"
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
						<div style="margin-top:10px;">
							<div class="clear fleft" style="margin-bottom:4px;">
								<a href="schedule_view.asp?idx=<%=uid%>&amp;lm=cal" onMouseOver="toggle('divDetail<%=uid%>');" onMouseOut="toggle('divDetail<%=uid%>');"><img src="<%=IMG_SHARE%>/sche_icon.gif" width="12" height="12"/>&nbsp;<%=subject%></a><div>
								<div id="divDetail<%=uid%>" class="hiddendiv">
									<table border="0" cellpadding="0" cellspacing="1" width="300" bgcolor="#E6E6E6">
									<tr>
										<td width="25%" bgcolor="#F5F5F5" align="center">제 목</td>
										<td bgcolor="#FFFFFF"><%=subject%>&nbsp;</td>
									</tr>
									<tr>
										<td width="25%" bgcolor="#F5F5F5" align="center">시 간</td>
										<td bgcolor="#FFFFFF"><%=startTime%> ~ <%=endTime%>&nbsp;</td>
									</tr>
									<tr>
										<td width="25%" bgcolor="#F5F5F5" align="center">장 소</td>
										<td bgcolor="#FFFFFF"><%=place%>&nbsp;</td>
									</tr>
									<tr>
										<td width="25%" bgcolor="#F5F5F5" align="center">내 용</td>
										<td bgcolor="#FFFFFF"><%=content%>&nbsp;</td>
									</tr>
									</table>
								</div>
							</div>
						</div>
<%
'							PRINT "<p>"
'							PRINT "<img src="""&IMG_SHARE&"/sche_icon.gif"" width=""12"" height=""12"" />"
'							PRINT subject
'							PRINT "</p>"
							Rs.MoveNext
						ElseIf nDate > targetDate Then
							Exit Do
						End If
					Loop
				End If

				PRINT "</td>"
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
</div>

<!--#include virtual = "/admin/_inc/copyright.asp"-->
