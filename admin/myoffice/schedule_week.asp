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
	<form name="sfrm" method="get" action="schedule_week.asp">
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
				<col width="130" />
				<col width="870" />
			</colgroup>
			<thead>
				<tr>
					<th colspan="2" class="notBor tleft" style="font-size:11pt; color:#000;"><span class="fleft"><%=syear%>년 <%=smonth%>월 일정표</span>
						<span class="fright">
						<%=aImgOPT("schedule.asp?syear="&syear&"&amp;smonth="&smonth,"S",IMG_BTN&"/btn_schedule_calendar_off.gif",130,25,"","")%>
						<%=aImgOPT("schedule_week.asp?syear="&syear&"&amp;smonth="&smonth,"S",IMG_BTN&"/btn_schedule_list_on.gif",130,25,"","")%>
						</span>
					</th>
				</tr><tr>
					<th>요일</th>
					<th>일정</th>
				</tr>
			</thead>
			<tbody>
			<%
				SQL = "SELECT [day],[comment] FROM [DK_HOLIDAY] WHERE [year] = ? AND [month] = ?"
				arrParams = Array(_
					Db.makeParam("@year",adInteger,adParamInput,0,syear),_
					Db.makeParam("@smonth",adInteger,adParamInput,0,smonth)_
				)
				arrList = Db.execRsList(SQL,DB_TEXT,arrParams,listLen,Nothing)
				
				For i = 1 To lastDay
					thisDay = syear &"-"& smonth &"-"&Right("00"&i,2)
					viewThisDay = Right("00"&smonth,2) &"."&Right("00"&i,2)
					thisDay_for = weekday(thisDay)

					Select Case thisDay_for
						Case 1 : FontColor = "sun"
						Case 7 : FontColor = "sat"
						Case Else : FontColor = "week"
					End Select
					holiday = ""
					cosmos = ""

					targetDate = syear &"-"& setZeroFill(smonth, 2) &"-"& setZeroFill(i, 2)
				
				If IsArray(arrList) Then
					For j = 0 To listLen
						If i = arrList(0,j) Then											'If 오늘날짜(i) = 공휴일
							holiday = "sun"
							FontColor = "sun"
							If arrList(1,j) <> "" Or Not IsNull(arrList(1,j)) Then
								cosmos = " <span class=""cosmos"">("&arrList(1,j)&")</span>"
							End If
						End If
					Next
				End If
			%>
			<tr>
			<%If syear = Year(nowTime) And smonth = Month(nowTime) And i = to_day Then%>     <!-- 오늘이면 오늘날짜 강조 -->
				<td class="tweight tcenter today"><a href="schedule_regist.asp?param=<%=targetDate%>&amp;lm=list"><span class=" <%=FontColor%> "><%=viewThisDay%>(<%=viewWeekDay(thisDay)%>)</span></a></td>
			<%Else%>				
				<td class="tweight tcenter"><a href="schedule_regist.asp?param=<%=targetDate%>&amp;lm=list"><span class=" <%=FontColor%> "><%=viewThisDay%>(<%=viewWeekDay(thisDay)%>)</span></a></td>
			<%End If%>
				<td>
				<%			
					PRINT "<div class=""days""><a href=""schedule_regist.asp?param="&targetDate&"&amp;lm=list""><span class="""&FontColor&" "&holiday&""">"&viewDay&cosmos&"</span></a>"
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
					<div>
						<div class="clear fleft" style="margin-bottom:4px;">
							<a href="schedule_view.asp?idx=<%=uid%>&amp;lm=list" onMouseOver="toggle('divDetail<%=uid%>');" onMouseOut="toggle('divDetail<%=uid%>');"><img src="<%=IMG_SHARE%>/sche_icon.gif" width="12" height="12" />&nbsp;<%=subject%></a><div>
							<div id="divDetail<%=uid%>" class="hiddendiv">
								<table border="0" cellpadding="0" cellspacing="1" width="600" bgcolor="#E6E6E6">
									<col width="120" />
									<col width="480" />
									<tr>
										<td bgcolor="#f5f5f5" align="center">제 목</td>
										<td bgcolor="#ffffff" style="padding-left:7px;"><%=subject%>&nbsp;</td>
									</tr>
									<tr>
										<td bgcolor="#f5f5f5" align="center">시 간</td>
										<td bgcolor="#ffffff" style="padding-left:7px;"><%=startTime%> ~ <%=endTime%>&nbsp;</td>
									</tr>
									<tr>
										<td bgcolor="#f5f5f5" align="center">장 소</td>
										<td bgcolor="#ffffff" style="padding-left:7px;"><%=place%>&nbsp;</td>
									</tr>
									<tr>
										<td bgcolor="#f5f5f5" align="center">내 용</td>
										<td bgcolor="#ffffff" style="padding-left:7px;"><%=content%>&nbsp;</td>
									</tr>
								</table>
							</div>
						</div>
					</div>
				<%
								Rs.MoveNext
							ElseIf nDate > targetDate Then
								Exit Do
							End If
						Loop
					End If
				%>
				</td>
			</tr>
			<%


				Next

			%>
			</tbody>


		</table>
	</div>
</div>

<!--#include virtual = "/admin/_inc/copyright.asp"-->
