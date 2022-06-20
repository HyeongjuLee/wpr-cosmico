<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<!--#include virtual = "/admin/_inc/document.asp"-->
<%
	ADMIN_LEFT_MODE = "WEBPRO"
	INFO_MODE = "WEBPRO1-2"


	Set DKRS = Db.execRs("DKPA_CATEGORY_LEFT_SETTING_VIEW",DB_PROC,Nothing,Nothing)

	If Not DKRS.BOF And Not DKRS.EOF Then
		DKRS_intMenuGap				= DKRS("intMenuGap")
		DKRS_intMenuWidth			= DKRS("intMenuWidth")
		DKRS_intMenuHeight			= DKRS("intMenuHeight")
		DKRS_intMenuX				= DKRS("intMenuX")
		DKRS_intMenuY				= DKRS("intMenuY")
		DKRS_intBgStart				= DKRS("intBgStart")
	Else
		DKRS_intMenuGap			= "0"
		DKRS_intMenuWidth		= "0"
		DKRS_intMenuHeight		= "0"
		DKRS_intMenuX			= "0"
		DKRS_intMenuY			= "0"
		DKRS_intBgStart			= "0"
	End If
%>
<link rel="stylesheet" href="menuSettingLeft.css" />
</head>
<body>

<!--#include virtual = "/admin/_inc/header.asp"-->
<div id="menuSetting">
	<form name="colorFrm" action="menuSettingLeftHandler.asp" method="post">
		<table <%=tableatt%> class="adminFullWidth list">
			<col width="250" />
			<col width="300" />
			<col width="450" />
			<tr>
				<th>구분</th>
				<th>값</th>
				<th>설명</th>
			</tr>
			<tr>
				<th>메뉴 간격</th>
				<td><input type="text" name="intMenuGap" value="<%=DKRS_intMenuGap%>" class="input_text2 color vmiddle" style="width:140px;" maxlength="6" /></td>
				<td>메인메뉴 사이의 간격을 지정합니다</td>
			</tr><tr>
				<th>메뉴넓이</th>
				<td><input type="text" name="intMenuWidth" value="<%=DKRS_intMenuWidth%>" class="input_text2 color vmiddle" style="width:140px;" maxlength="6" /></td>
				<td>메뉴의 넓이를 지정합니다</td>
			</tr><tr>
				<th>메뉴높이</th>
				<td><input type="text" name="intMenuHeight" value="<%=DKRS_intMenuHeight%>" class="input_text2 color vmiddle" style="width:140px;" maxlength="6" /></td>
				<td>메뉴의 높이를 지정합니다</td>
			</tr><tr>
				<th>메뉴시작 값 (x)</th>
				<td><input type="text" name="intMenuX" value="<%=DKRS_intMenuX%>" class="input_text2 color vmiddle" style="width:140px;" maxlength="6" /></td>
				<td>메뉴시작의 가로값을 지정합니다</td>
			</tr><tr>
				<th>메뉴시작 값 (y)</th>
				<td><input type="text" name="intMenuY" value="<%=DKRS_intMenuY%>" class="input_text2 color vmiddle" style="width:140px;" maxlength="6" /></td>
				<td>메뉴시작의 세로값을 지정합니다</td>
			</tr><tr>
				<th>배경시작 값 (x)</th>
				<td><input type="text" name="intBgStart" value="<%=DKRS_intBgStart%>" class="input_text2 color vmiddle" style="width:140px;" maxlength="6" /></td>
				<td>메뉴배경 시작의 가로값을 지정합니다</td>
			</tr><tr>
				<td colspan="3" align="center" style="padding:10px 0px;"><input type="image" src="<%=IMG_BTN%>/btn_submit_gray.gif" /></td>
			</tr>

		</table>
	</form>
</div>
<!--#include virtual = "/admin/_inc/copyright.asp"-->
