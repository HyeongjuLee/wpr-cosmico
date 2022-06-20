<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<!--#include virtual = "/admin/_inc/document.asp"-->
<%
	ADMIN_LEFT_MODE = "DESIGN"
	INFO_MODE = "DESIGN1-3"


	SQL = "SELECT * FROM [DK_DESIGN_TAG] WHERE [isDel] = 'F'"
	Set DKRS =  Db.execRs(SQL,DB_TEXT,Nothing,Nothing)
	If Not DKRS.BOF And Not DKRS.EOF Then
		DKRS_strTag			= DKRS("strTag")
	Else
		DKRS_strTag			= ""
	End If

%>
<link rel="stylesheet" href="design.css" />
<script type="text/javascript" src="banner.js"></script>
</head>
<body>
<!--#include virtual = "/admin/_inc/header.asp"-->
<div id="design" class="banner_insert">
	<p class="titles">태그 등록</p>
	<form name="ifrm" method="post" action="tag_handler.asp">
		<input type="hidden" name="mode" value="INSERT" />
		<table <%=tableatt%> class="adminFullWidth insert">
			<col width="150" />
			<col width="550" />
			<col width="*" />
			<tr>
				<th>태그 입력</th>
				<td><input type="text" name="strTag" class="input_file" value="<%=DKRS_strTag%>" style="width:450px" /></td>
				<td><span class="red">한글 기준 약 60자 (3줄 표기) 까지 표시됩니다. (태그 등록 후 확인해주세요)</span></td>
			</tr><tr>
				<td colspan="3" class="tcenter"><input type="image" src="<%=IMG_BTN%>/btn_submit_gray.gif" /></td>
			</tr>
		</table>
	</form>
</div>
<!--#include virtual = "/admin/_inc/copyright.asp"-->