<!--#include virtual = "/_lib/strFunc.asp"-->
<%

	Call ONLY_MEMBER_CLOSE(DK_MEMBER_LEVEL)

	popWidth = 935
	popHeight = 850


	syear	= checkNumeric(gRequestTF("syear", True))
	smonth	= checkNumeric(gRequestTF("smonth", True))
	sday	= checkNumeric(gRequestTF("sday", True))
	schType = gRequestTF("stype", True)					'strScheduleType 추가

%>
<!--#include file = "schedule_config.asp"-->
<%

	If Not IsDate(syear &"-"& smonth &"-1") Then
		syear = Year(nowTime)
		smonth = Month(nowTime)
	End If

	params = "syear="& syear &"&amp;smonth="& smonth &"&stype="&schType

	sYearMonth = syear &"-"& setZeroFill(smonth, 2) &"-01"


	sdate = syear &"-"& smonth &"-1"
	firstWeek = Weekday(sdate)
	lastDay = getLastDay(syear, smonth)


	sYearDate = syear &"-"& setZeroFill(smonth, 2) &"-"&setZeroFill(sday, 2)


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

	function chkhoFrm(f){
		if (f.strSubject.value=='')
		{
			alert("<%=LNG_SCHEDULE_CONTROL_VIEW_JS01%>");
			f.strSubject.focus();
			return false;
		}
		if (f.strContent.value=='')
		{
			alert("<%=LNG_SCHEDULE_CONTROL_VIEW_JS02%>");
			f.strContent.focus();
			return false;
		}
	}

//-->
</script>
<style type="text/css" rel="stylesheet">
<!--

	#scheduleCtrl .txtbg {float:left;width:101px; height:24px; margin:0 0px 0 4px; background:url(/images_kr/content/lecture_txt_bg.png) 0 3px no-repeat;}
	#scheduleCtrl .numbg {float:left;width:11px; height:24px; margin:0 1px 0 0; background:url(/images_kr/content/lecture_number_bg.png) 0 50% no-repeat;}
	#scheduleCtrl .n0 {background-position:0px 50%;}
	#scheduleCtrl .n1 {background-position:-15px 50%;}
	#scheduleCtrl .n2 {background-position:-30px 50%;}
	#scheduleCtrl .n3 {background-position:-45px 50%; width:12px;}
	#scheduleCtrl .n4 {background-position:-60px 50%; width:12px;}
	#scheduleCtrl .n5 {background-position:-75px 50%; width:12px;}
	#scheduleCtrl .n6 {background-position:-90px 50%;}
	#scheduleCtrl .n7 {background-position:-105px 50%;}
	#scheduleCtrl .n8 {background-position:-120px 50%; width:12px;}
	#scheduleCtrl .n9 {background-position:-135px 50%;}
	#scheduleCtrl .dot {background-position:-151px 50%; width:5px;}
	#scheduleCtrl .button a {color:#000;}
	#scheduleCtrl .button a:hover {color:red;}
	#scheduleCtrl .button.f10px a {font-size:10px; color:#999;}
	#scheduleCtrl .button.f10px a:hover {color:red;}
	#scheduleCtrl .yyyydd {clear:both;float:left;}
	#scheduleCtrl .move_yyyydd {float:left; margin-left:15px;}
	#scheduleCtrl  .myID {height:24px;font-family: tahoma, Arial, Helvetica, sans-serif;padding-right:10px;font-size:18px;font-weight:bold;margin-top:20px;}

	#view {clear:both;float:left;margin-top:10px;}
	#view th,
	#view td {border:1px solid #ccc; padding:7px 0px; color:#333}
	#view thead th {color:#787878; font-size:16px; background-color:#e5e5e5;}
	#view tbody th { background-color:#eee;}
	#view tbody td { padding-left:10px;}

	#view .input_text {border:1px solid #ccc; line-height:22px; height:22px; padding:0px 7px;}
	#view .input_area {border:1px solid #ccc; line-height:16px; padding:7px;}


//-->
</style>
</head>
<body>
<div class="tcenter" style="margin:10px 0px;"><img src="<%=IMG_SHARE%>/top_logo.png"></div>
<div id="scheduleCtrl">
	<div class="myID tweight tright " style="">
		<!-- <span><%=DK_MEMBER_ID%></span> -->
		<span><%=SCHEDULE_TYPE_TXT%></span>
	</div>
	<div id="view" class="width100">
		<form name="lecFrm" action="scheduleControlHandler.asp" method="post" onsubmit="return chkhoFrm(this);">
			<input type="hidden" name="mode" value="REGIST" />
			<input type="hidden" name="param" value="<%=params%>" />
			<input type="hidden" name="stype" value="<%=schType%>" />
			<table <%=tableatt%> class="width100 tlf">
				<col width="150" />
				<col width="*" />
				<col width="280" />
				<thead>
					<tr>
						<th colspan="3"><%=sYearDate%>&nbsp; <%=LNG_SCHEDULE_TEXT02_M%></th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<th><%=LNG_SCHEDULE_CONTROL_VIEW_TEXT01%></th>
						<td><input type="text" name="sYearDate" value="<%=sYearDate%>"  class='input_text readonly cp' onclick="openCalendar(event, this, 'YYYY-MM-DD');" readonly="readonly" /></td>
						<td><%=LNG_SCHEDULE_CONTROL_VIEW_TEXT01_1%></td>
					</tr><tr>
						<th><%=LNG_SCHEDULE_CONTROL_VIEW_TEXT03%></th>
						<td>
							<%
								PRINT "<select name=""starthour"">"
								For i = 0 To 23
									hh = Right("0"&i,2)
									PRINT "<option value="""&hh&""" "&isSelect(DKRS_StartHH,hh)&">"&hh&" "&LNG_SCHEDULE_CONTROL_VIEW_TEXT03_2&"</option>"
								Next
								PRINT "</select>"
								PRINT "<select name=""startminute"">"
								For i = 0 To 59
									hh = Right("0"&i,2)
									PRINT "<option value="""&hh&""" "&isSelect(DKRS_StartMM,hh)&">"&hh&" "&LNG_SCHEDULE_CONTROL_VIEW_TEXT03_3&"</option>"
								Next
								PRINT "</select>"
								PRINT "~"
								PRINT "<select name=""endhour"">"
								For i = 0 To 23
									hh = Right("0"&i,2)
									PRINT "<option value="""&hh&""" "&isSelect(DKRS_EndHH,hh)&">"&hh&" "&LNG_SCHEDULE_CONTROL_VIEW_TEXT03_2&"</option>"
								Next
								PRINT "</select>"
								PRINT "<select name=""endminute"">"
								For i = 0 To 59
									hh = Right("0"&i,2)
									PRINT "<option value="""&hh&""" "&isSelect(DKRS_EndMM,hh)&">"&hh&" "&LNG_SCHEDULE_CONTROL_VIEW_TEXT03_3&"</option>"
								Next
								PRINT "</select>"
								'PRINT "까지"
							%>
						</td>
						<td><%=LNG_SCHEDULE_CONTROL_VIEW_TEXT02_1%></td>
					</tr><tr>
						<th><%=LNG_SCHEDULE_CONTROL_VIEW_TEXT04%></th>
						<td><input type="text" name="place" class="input_text" maxlength="50" size="40" style="width:400px;" value="<%=DKRS_Place%>" /></td>
						<td><%=LNG_SCHEDULE_CONTROL_VIEW_TEXT03_1%></td>
					</tr><tr>
						<th><%=LNG_SCHEDULE_CONTROL_VIEW_TEXT02%></th>
						<td><input type="text" name="strSubject" class="input_text" maxlength="100" size="40" style="width:400px;" value="<%=DKRS_ %>" /></td>
						<td><%=LNG_SCHEDULE_CONTROL_VIEW_TEXT04_1%></td>
					</tr><tr>
						<th><%=LNG_SCHEDULE_CONTROL_VIEW_TEXT05%></th>
						<td><textarea name="strContent" rows="10" cols="45" class="input_area"  style="width:400px;height:150px;"><%=DKRS_strContent%></textarea></td>
						<td><%=LNG_SCHEDULE_CONTROL_VIEW_TEXT05_1%></td>
					</tr>
				</tbody>
			</table>
			<div class="width100 tcenter" style="padding:20px 0px;">
				<!-- <input type="image" src="<%=IMG_POPUP%>/btn_rect_confirm.gif" />
				<a href="scheduleControl.asp?<%=params%>"><img src="<%=IMG_POPUP%>/btn_rect_list.gif" alt="" /></a> -->
				<input type="submit" class="txtBtn large b_blue" value="<%=LNG_TEXT_CONFIRM%>">
				<input type="button" class="txtBtn large b_gray" value="<%=LNG_SCHEDULE_CONTROL_VIEW_BTN02%>" onclick="location.href='scheduleControl.asp?<%=params%>'">
			</div>
		</form>
	</div>

</div>

<script type="text/javascript">
<!--
	resizePopupWindow(parseInt("<%=popWidth%>", 10), parseInt("<%=popHeight%>", 10));
//-->
</script>
</body>
</html>