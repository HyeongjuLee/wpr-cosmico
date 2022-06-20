<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<!--#include virtual = "/admin/_inc/document.asp"-->
<%
	ADMIN_LEFT_MODE = "MYOFFICE"
	INFO_MODE = "MYOFFICE1-1"



		intIDX =  gRequestTF("idx",True)
		lm =  gRequestTF("lm",False)


		SQL = "SELECT * FROM [DK_DIARY] WHERE [intIDX] = ?"
		arrParams = Array(_
			Db.makeParam("@intIDX",adInteger,adParamInput,0,intIDX) _
		)
		Set DKRS = Db.execRs(SQL,DB_TEXT,arrParams,Nothing)

		If Not DKRS.BOF And Not DKRS.EOF Then
			param			= DKRS("Date")
			StartTime		= DKRS("StartTime")
			EndTime			= DKRS("EndTime")
			strSubject		= DKRS("strSubject")
			Place			= DKRS("Place")
			strContent		= DKRS("strContent")
			RegDate			= DKRS("RegDate")

			StartHH = Split(StartTime,":")(0)
			StartMM = Split(StartTime,":")(1)
			EndHH = Split(EndTime,":")(0)
			EndMM = Split(EndTime,":")(1)

		Else
			Call ALERTS("존재하지 않는 값입니다.","back","")
		End If


%>
<link rel="stylesheet" href="schedule.css" />
<script type="text/javascript" src="/jscript/calendar.js"></script>

<script type="text/javascript">
<!--
	function chkSubmit(f){
		if (f.strSubject.value=='')
		{
			alert("제목을 입력해주세요");
			f.strSubject.focus();
			return false;
		}
		if (f.strContent.value=='')
		{
			alert("내용을 입력해주세요");
			f.strContent.focus();
			return false;
		}		
	}

	function delok(uidx){
		var f = document.delFrm;

		if (confirm("해당 스케쥴을 삭제하시겠습니까?\n\n\※ 삭제 후 복구할 수 없습니다.※")) {
			f.idx.value = uidx;
			f.submit();
		}
	}

//-->
</script>
</head>
<body>
<!--#include virtual = "/admin/_inc/header.asp"-->
<div id="schedule">
	<p class="titles">일정수정</p>
	<div class="insert">
		<form name="hoFrm" action="schedule_insertOk.asp" method="post" onsubmit="return chkSubmit(this);">
			<input type="hidden" name="idx" value="<%=intIDX%>" />

			<input type="hidden" name="mode" value="MODIFY" />
			<input type="hidden" name="lm" value="<%=lm%>" />
			<table <%=tableatt%> class="adminFullWidth">
				<colgroup>
					<col width="150" />
					<col width="500" />
					<col width="350" />
				<colgroup>
				<tr>
					<th>일자</th>
					<td><input type="text" name="param" value="<%=param%>"  class='input_text readonly cp' onclick="openCalendar(event, this, 'YYYY-MM-DD');" readonly="readonly" /></td>
					<td>일정 적용 일자</td>
				</tr><tr>
					<th>시간</th>
					<td>
						<%
							PRINT "<select name=""starthour"">"
							For i = 0 To 23
								hh = Right("0"&i,2)
								PRINT "<option value="""&hh&""" "&isSelect(StartHH,hh)&">"&hh&" 시</option>"
							Next
							PRINT "</select>"
							PRINT "<select name=""startminute"">"
							For i = 0 To 59
								hh = Right("0"&i,2)
								PRINT "<option value="""&hh&""" "&isSelect(StartMM,hh)&">"&hh&" 분</option>"
							Next
							PRINT "</select>"
							PRINT "부터"
							PRINT "<select name=""endhour"">"
							For i = 0 To 23
								hh = Right("0"&i,2)
								PRINT "<option value="""&hh&""" "&isSelect(EndHH,hh)&">"&hh&" 시</option>"
							Next
							PRINT "</select>"
							PRINT "<select name=""endminute"">"
							For i = 0 To 59
								hh = Right("0"&i,2)
								PRINT "<option value="""&hh&""" "&isSelect(EndMM,hh)&">"&hh&" 분</option>"
							Next
							PRINT "</select>"
							PRINT "까지"
						%>
					</td>
					<td>해당 일정의 시간입니다</td>
				</tr><tr>
					<th>장소</th>
					<td><input type="text" name="place" class="input_text" maxlength="50" size="40" style="width:400px;" value="<%=place%>" /></td>
					<td>일정의 장소 (예: 제1강의실)</td>
				</tr><tr>
					<th>제목</th>
					<td><input type="text" name="strSubject" class="input_text" maxlength="100" size="40" style="width:400px;" value="<%=strSubject%>" /></td>
					<td>스케쥴에 표시될 제목(7자 내외가 가독성이 좋음)</td>
				</tr><tr>
					<th>내용</th>
					<td><textarea name="strContent" rows="10" cols="45" class="input_area"  style="width:400px;height:150px;"><%=backword(strContent)%></textarea></td>
					<td>일정의 상세 내용을 기입합니다</td>
				</tr><tr>
					<td colspan="3" class="tcenter notBor"><input type="image" src="<%=IMG_BTN%>/btn_rect_confirm.gif" class="vmiddle" /><%=aImgOpt("schedule.asp?syear="&Year(param)&"&amp;smonth="&Month(param),"S",IMG_BTN&"/btn_rect_list.gif",99,45,"","style=""margin-left:7px;""")%><%=aImgOpt("javascript:delok('"&intIDX&"')","S",IMG_BTN&"/btn_rect_del.gif",99,45,"","style=""margin-left:7px;""")%></td>
				</tr>
			</table>
		</form>
	</div>
</div>
<form name="delFrm" action="schedule_insertOk.asp" method="post">
	<input type="hidden" name="idx" value="" />
	<input type="hidden" name="param" value="<%=param%>" />
	<input type="hidden" name="mode" value="DELETE" />

	<input type="hidden" name="lm" value="<%=lm%>" />
</form>
<!--#include virtual = "/admin/_inc/copyright.asp"-->
