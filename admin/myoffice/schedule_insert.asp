<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<!--#include virtual = "/admin/_inc/document.asp"-->
<%
	ADMIN_LEFT_MODE = "MYOFFICE"
	INFO_MODE = "MYOFFICE1-1"


	param = gRequestTF("param",True)
	slocation = gRequestTF("sloc",false)
	lm =  gRequestTF("lm",false)
%>
<link rel="stylesheet" href="schedule.css" />

<script type="text/javascript">
<!--
	function chkhoFrm(f){
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

	
	function delForm() {

		document.hoFrm.delTF.value='T';

		if(confirm("삭제하시겠습니까?")){
			document.hoFrm.submit();
		 }else{
		 }
	}
//-->
</script>
</head>
<body>
<!--#include virtual = "/admin/_inc/header.asp"-->
<div id="schedule">
	<p class="titles">일정입력</p>
	<div class="insert">
		<form name="hoFrm" action="schedule_insertOk.asp" method="post" onsubmit="return chkhoFrm(this);">
		<input type="hidden" name="mode" value="REGIST" />
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
				<td><input type="text" name="place" class="input_text" maxlength="50" size="40" style="width:400px;" value="" /></td>
				<td>일정의 장소 (예: 제1강의실)</td>
			</tr><tr>
				<th>제목</th>
				<td><input type="text" name="strSubject" class="input_text" maxlength="100" size="40" style="width:400px;" value="" /></td>
				<td>스케쥴에 표시될 제목(7자 내외가 가독성이 좋음)</td>
			</tr><tr>
				<th>내용</th>
				<td><textarea name="strContent" rows="10" cols="45" class="input_area"  style="width:400px;height:150px;"></textarea></td>
				<td>일정의 상세 내용을 기입합니다</td>
			</tr><tr>
				<td colspan="3" class="tcenter notBor"><input type="image" src="<%=IMG_BTN%>/btn_rect_confirm.gif" /></td>
			</tr>
		</table>
		</form>
	</div>
</div>
<!--#include virtual = "/admin/_inc/copyright.asp"-->
