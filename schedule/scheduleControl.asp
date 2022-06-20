<!--#include virtual = "/_lib/strFunc.asp"-->
<%

	Call ONLY_MEMBER_CLOSE(DK_MEMBER_LEVEL)

	popWidth = 935
	popHeight = 850


	schType = gRequestTF("stype", True)					'strScheduleType 추가

%>
<!--#include file = "schedule_config.asp"-->
<%
	syear = checkNumeric(gRequestTF("syear", False))
	smonth = checkNumeric(gRequestTF("smonth", False))
'	SLOCATIONS = gRequestTF("loca", True)

'	If DK_MEMBER_TYPE = "SADMIN" Then
'		If UCase(DK_MEMBER_GROUP) <> UCase(sLocations) Then Call ALERTS("관리할 수 있는 지점이 아닙니다","BACK","")
'	End If

	If Not IsDate(syear &"-"& smonth &"-1") Then
		syear = Year(nowTime)
		smonth = Month(nowTime)
	End If

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

'	PRINT sYearMonth


		'Db.makeParam("@strDiaryname",adVarchar,adParamInput,20,"admin") _
	SQL = "SELECT [intIDX], [Date], [StartTime], [EndTime], [strSubject], [Place], [strContent] FROM [DK_DIARY]"
	SQL = SQL &" WHERE [Date] LIKE ? "
	'SQL = SQL &" AND [strUserID] = ? "
	SQL = SQL &" AND [strNation] = '"&Lang&"' "
	SQL = SQL &" AND [strScheduleType] = '"&schType&"' "
	SQL = SQL &" ORDER BY [Date] ASC, [StartTime] ASC"
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
<script type="text/javascript">
<!--
function toggle(elmId) {
	var objLayer = document.getElementById(elmId);

	if (objLayer.style.display == "block") {

		objLayer.style.display="none";
	}
	else {
		objLayer.style.display="block";
	}
}
//-->
</script>
<style type="text/css" rel="stylesheet">

	#schedule .txtbg {float:left;width:101px; height:24px; margin:0 0px 0 4px; background:url(/images_kr/content/schedule_txt_bg.png) 0 3px no-repeat;}
	#schedule .numbg {float:left;width:11px; height:24px; margin:0 1px 0 0; background:url(/images_kr/content/schedule_number_bg.png) 0 50% no-repeat;}
	#schedule .n0 {background-position:0px 50%;}
	#schedule .n1 {background-position:-15px 50%;}
	#schedule .n2 {background-position:-30px 50%;}
	#schedule .n3 {background-position:-45px 50%; width:12px;}
	#schedule .n4 {background-position:-60px 50%; width:12px;}
	#schedule .n5 {background-position:-75px 50%; width:12px;}
	#schedule .n6 {background-position:-90px 50%;}
	#schedule .n7 {background-position:-105px 50%;}
	#schedule .n8 {background-position:-120px 50%; width:12px;}
	#schedule .n9 {background-position:-135px 50%;}
	#schedule .dot {background-position:-151px 50%; width:5px;}
	#schedule .button a {color:#000;}
	#schedule .button a:hover {color:red;}
	#schedule .button.f10px a {font-size:10px; color:#999;}
	#schedule .button.f10px a:hover {color:red;}
	#schedule .yyyydd {clear:both;float:left;}
	#schedule .move_yyyydd {float:left; margin-left:15px;}

	#schedule .myID {height:24px;font-family: tahoma, Arial, Helvetica, sans-serif;padding-right:10px;font-size:18px;font-weight:bold;}

	#schedule {clear:both;float:left;margin-top:10px;}

	#schedule .sche { }
	#schedule .sche th {text-align:center; height:32px; border:1px solid #ccc; font-weight:bold; background-color:#f7f7f7;}
	#schedule .sche .sun, #schedule .sche .sun a {color:#ec3d3d !important;}
	#schedule .sche .sat, #schedule .sche .sat a {color:#6197cf;}
	#schedule .sche .week a {color:#999;}
	#schedule .sche .cosmos a {font-size:8pt;color:#ec3d3d;}
	#schedule .sche tbody td {border:1px solid #ccc; }
	#schedule .sche tbody td.hts {min-height:130px;  height:130px; vertical-align:top;}
/*	#schedule .sche tbody td:hover {background:#dbf9ff;}*/
	#schedule .sche tbody td .days {font-weight:bold; padding-bottom:6px;}
	#schedule .sche tbody td .days>p>a {font-family:verdana;}
	#schedule .sche tfoot td {border:0px none;}

	#schedule .sche td img {vertical-align:middle; margin-left:5px;}
	#schedule .sche td p {font-size:9pt;}

	#schedule .layers {margin-left:2px;margin-right:2px; margin-top:6px; padding:2px 0px 2px 14px; background:url(/images_kr/content/schedule_icon_01.png) 0 3px no-repeat; line-height:15px;}

	#schedule .hiddendiv {display:none; position:absolute; z-index:1; background-color:#eee; padding:10px;border:1px solid #ccc;}
	#schedule .hiddendiv th {background-color:#fbfbfb; width:70px;}
	#schedule .hiddendiv td {color:#7a7a7a; padding:4px 7px 4px 7px;line-height:17px; font-weight:normal;}

	#schedule.dateList h2 {font-size:16pt;}
	#schedule.dateList .dlist {margin-top:30px;}
	#schedule.dateList .title {font-size:11pt; font-weight:bold;}
	#schedule.dateList th {border:1px solid #ccc; background-color:#eee;}
	#schedule.dateList td {border:1px solid #ccc; padding:7px 0px 7px 7px;}
	#schedule.dateList .btn_area {text-align:center; padding-top:30px;}

</style>
</head>
<body>
<div class="tcenter" style="margin:20px 0px;"><img src="<%=IMG_SHARE%>/top_logo.png"></div>
<div id="schedule" class="width100">
	<div class="yyyydd">
		<span class="numbg n<%=Left(syear,1)%>"></span>
		<span class="numbg n<%=Mid(syear,2,1)%>"></span>
		<span class="numbg n<%=Mid(syear,3,1)%>"></span>
		<span class="numbg n<%=Right(syear,1)%>"></span>
		<span class="numbg dot"></span>
		<span class="numbg n<%=Left(setZeroFill(smonth,2),1)%>"></span>
		<span class="numbg n<%=Right(setZeroFill(smonth,2),1)%>"></span>
		<!-- <span class="txtbg"></span> -->
	</div>
	<div class="move_yyyydd">
		<span class="button medium f10px"><a href="?<%=prevParam%>">◀</a></span><span class="button medium f10px"><a href="?<%=nextParam%>">▶</a></span>
		<span class="button medium strong"><a href="?<%=nowParams%>"><%=LNG_SCHEDULE_TEXT01%></a></span>
	</div>

	<div class="myID tweight tright " style="">
		<!-- <span><%=DK_MEMBER_ID%></span> -->
		<span><%=SCHEDULE_TYPE_TXT%></span>
	</div>




	<div id="schedule" class="width100">
		<!-- <table <%=tableatt%> class="width100 sche">
				<tr>
					<th colspan="4" class="notBor tleft" style="font-size:11pt; color:#000;"></th>
					<th colspan="3" class="notBor tright">
						<form name="schFrm" action="scheduler.asp" method="get">
						<select name="syear" onchange="chgDate();">
							<%
								For i = 2010 To 2022
									PRINT "<option value="""&i&""" "&isSelect(i,syear)&">"&i&" 년</option>"
								Next
							%>
						</select>
						<select name="smonth" onchange="chgDate();">
							<%
								For i = 1 To 12
									PRINT "<option value="""&i&""" "&isSelect(i,smonth)&">"&i&" 월</option>"
								Next
							%>
						</select>
						</form>
					</th>
				</tr>
		</table> -->



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


							PRINT "<td class=""hts""><div class=""days""><p class="""&FontColor&" "&holiday&""" style=""margin-bottom:5px;"" ><a>"&viewDay&"</a> <a href=""scheduleControlReg.asp?"&params&"&amp;sday="&viewDay&""">["&LNG_COUNSEL_TEXT09&"]</a>"&cosmos&"</p>"
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
								<a onmouseover="toggle('divDetail<%=uid%>');" onmouseout="toggle('divDetail<%=uid%>');" class="week cp" href="scheduleControlView.asp?idx=<%=uid%>&amp;<%=params%>"><span class="layers"><%=cutString2(subject,12)%></span></a>
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

</div>

<script type="text/javascript">
<!--
	resizePopupWindow(parseInt("<%=popWidth%>", 10), parseInt("<%=popHeight%>", 10));
//-->
</script>
</body>
</html>