<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	PAGE_SETTING = "CUSTOMER"

	view = 7
	mNum = 6

'	Call ONLY_MEMBER_CONFIRM(DK_MEMBER_LEVEL)
'	Call ONLY_BUSINESS_MEMBER(DK_MEMBER_LEVEL,1)		'고객지원 - 1:1상담 : 회원공개


	syear = checkNumeric(gRequestTF("syear", False))
	smonth = checkNumeric(gRequestTF("smonth", False))
	to_day = Day(nowTime)

	If Not IsDate(syear &"-"& smonth &"-1") Then
		syear = Year(nowTime)
		smonth = Month(nowTime)
	End If


	params = "syear="& syear &"&smonth="& smonth

	sYearMonth = syear &"-"& setZeroFill(smonth, 2) &"-01"
	sYearMonthP = DateAdd("m",-1,sYearMonth)
	sYearMonthN = DateAdd("m",1,sYearMonth)

	nowParams = "syear="& Year(nowTime) &"&smonth="& Month(nowTime)
	prevParam = "syear="& Year(sYearMonthP) &"&smonth="& Month(sYearMonthP)
	nextParam = "syear="& Year(sYearMonthN) &"&smonth="& Month(sYearMonthN)

	sdate = syear &"-"& smonth &"-1"
	firstWeek = Weekday(sdate)
	lastDay = getLastDay(syear, smonth)

	LOCATIONS = ""
	LOCTYPE = ""

	sYearMonth = syear &"-"& setZeroFill(smonth, 2) &"-"



%>
<!--#include virtual = "/m/_include/document.asp"-->
<!--#include virtual = "/m/_include/jqueryload.asp"-->
<link rel="stylesheet" type="text/css" href="schedule.css" />
</head>
<body onunload="">
<!--#include virtual = "/m/_include/header.asp"-->
<!--#include virtual = "/m/_include/sub_header.asp"-->
<div id="scheduler" class="scheduler01">
	<div id="subTitle" class="width100 tcenter text_noline" ><%=LNG_CUSTOMER_07%></div>
	<div id="mBtn" class="width100" style="margin:10px 0px;">
		<div class="fleft width100 btnList">
			<span class="fleft" style="width:15%;"><a class="gray" href="schedule_list.asp?<%=prevParam%>" data-ajax="false"><</a></span>
			<span class="fleft date" style="width:45%;"><%=syear%>.<%=Right("00"&smonth,2)%></span>
			<span class="fleft" style="width:15%;"><a class="gray" href="schedule_list.asp?<%=nextParam%>" data-ajax="false">></a></span>
			<span class="fleft" style="width:25%;"><a class="gray" href="schedule_list.asp?<%=nowParams%>" data-ajax="false"><%=LNG_SCHEDULE_TEXT01%></a></span>
		</div>
	</div>

	<div id="schedule" class="width100">
		<table <%=tableatt%> class="width100 sche">
			<colgroup>
				<col width="100" />
				<col width="*" />
			</colgroup>
			<thead>
				<tr>
					<th><%=LNG_SCHEDULE_TEXT01_M%></th>
					<th><%=LNG_SCHEDULE_TEXT02_M%></th>
				</tr>
			</thead>
			<tbody>
			<%
				For j = 1 To lastDay
					thisDay = syear &"-"& smonth &"-"&Right("00"&j,2)
					viewThisDay = Right("00"&smonth,2) &"."&Right("00"&j,2)
					thisDay_for = weekday(thisDay)

					Select Case thisDay_for
						Case 1 : FontColor = "sun"
						Case 7 : FontColor = "sat"
						Case Else : FontColor = "week"
					End Select

					targetDate = syear &"-"& setZeroFill(smonth, 2) &"-"& setZeroFill(j, 2)

					'금일강조
					todayColor = ""
					If syear = Year(nowTime) And smonth = Month(nowTime) And j = to_day Then
						todayColor = "background-color:#e5f5a7;"
					End If

			%>
			<tr>
				<td class="tweight tcenter" style="<%=todayColor%>"><span class=" <%=FontColor%>"><%=viewThisDay%> (<%=viewWeekDay(thisDay)%>)</span></td>
				<td>
				<%

'							'ThisColDate = syear&"-"&Right("00"&smonth,2)&"-"&Right("00"&viewDay,2)
'							arrParams2 = Array(_
'								Db.makeParam("@Date",adVarChar,adParamInput,10,targetDate) _
'							)
'							arrList2 = Db.execRsList("DKP_DIARY_LOCATIONS",DB_PROC,arrParams2,listLen2,Nothing)
'
'							If IsArray(arrList2) Then
'								PRINT "<div class=""allA""><a href=""counsel_schedule_view.asp?dates="&targetDate&""" data-ajax=""false"">"
'								PRINT "<p class=""p_title"">개강예정</p>"
'								For i = 0 To listLen2
'									PRINT "<p class=""loc_info"">"&Fn_viewLocation2(arrList2(0,i)) &" : <span class=""tweight red"">"&arrList2(1,i)&"</span> 강좌</p>"
'									'PRINT Fn_viewLocation2(arrList2(0,i))
'									'PRINT arrList2(0,i)
'									'PRINT arrList2(1,i)
'								Next
'								PRINT "</a></div>"
'
'							End If

							SQL_CNT = "SELECT COUNT(*) FROM [DK_DIARY] WHERE [Date] = ?"
							SQL_CNT = SQL_CNT &" AND [strNation] = '"&Lang&"' "
							arrParams2 = Array(_
								Db.makeParam("@Date",adVarChar,adParamInput,10,targetDate) _
							)
							DiaryCnt = Db.execRsData(SQL_CNT,DB_TEXT,arrParams2,Nothing)

							If DiaryCnt > 0 Then

								'TOP 제목호출
								SQL = "SELECT TOP(1) [intIDX], [Date], [StartTime], [EndTime], [strSubject], [Place], [strContent] FROM [DK_DIARY]"
								SQL = SQL &" WHERE [Date] LIKE ? "
								SQL = SQL &" AND [strNation] = '"&Lang&"' "
								SQL = SQL &" ORDER BY [Date] ASC, [StartTime] ASC"
								arrParams = Array( _
									Db.makeParam("@Date",adVarchar,adParamInput,10,targetDate) _
								)
								Set HJRS = Db.execRs(SQL,DB_TEXT,arrParams,Nothing)
								If Not HJRS.BOF And Not HJRS.EOF Then
									HJRS_intIDX = HJRS(0)
									HJRS_strSubject = HJRS(4)
								Else
									HJRS_intIDX = 0
									HJRS_strSubject = ""
								End If

								PRINT "<div class=""allA""><a href=""schedule_view.asp?ptype=_list&dates="&targetDate&""" data-ajax=""false"">"
								If DiaryCnt = 1 Then
								PRINT "	<p class=""loc_info"">"&HJRS_strSubject&"</p>"
								Else
									If UCase(Lang) = "" Or UCase(Lang) = "KR" Then
										PRINT "	<p class=""loc_info"">"&HJRS_strSubject&" 외 <span class=""tweight red"">"&DiaryCnt-1&"</span> 개의 일정 등록</p>"
									Else
										PRINT "	<p class=""loc_info"">"&HJRS_strSubject&" + <span class=""tweight red"">"&DiaryCnt-1&"</span></p>"
									End If
								End If
								PRINT "</a></div>"
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
<!--#include virtual = "/m/_include/copyright.asp"-->


