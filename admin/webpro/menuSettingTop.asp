<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<!--#include virtual = "/admin/_inc/document.asp"-->
<%
	ADMIN_LEFT_MODE = "WEBPRO"
	INFO_MODE = "WEBPRO1-2"


	Set DKRS = Db.execRs("DKPA_CATEGORY_TOP_SETTING_VIEW",DB_PROC,Nothing,Nothing)

	If Not DKRS.BOF And Not DKRS.EOF Then
		DKRS_intMainMenuGap			= DKRS("intMainMenuGap")
		DKRS_intSubMenuGap			= DKRS("intSubMenuGap")
		DKRS_intSubBgAdd			= DKRS("intSubBgAdd")
		DKRS_intSubMenuSpeed		= DKRS("intSubMenuSpeed")
		DKRS_intMainMenuStart		= DKRS("intMainMenuStart")
	Else
		DKRS_intMainMenuGap			= "0"
		DKRS_intSubMenuGap			= "0"
		DKRS_intSubBgAdd			= "0"
		DKRS_intSubMenuSpeed		= "0"
		DKRS_intMainMenuStart		= "0"
	End If
%>
<link rel="stylesheet" href="menuSettingTop.css" />
</head>
<body>
<!-- menuGap : 메인메뉴사이의 간격조정
outColor : 메뉴의 아웃칼라(기본칼라)
overColor : 메뉴의 마우스오버시칼라
bgColor : 텍스트배경칼라
letterSpacing : 메뉴 텍스트 자간조절 -->

<!--#include virtual = "/admin/_inc/header.asp"-->
<div id="menuSetting">
	<form name="colorFrm" action="menuSettingTopHandler.asp" method="post">
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
				<th>메인메뉴 간격</th>
				<td><input type="text" name="intMainMenuGap" value="<%=DKRS_intMainMenuGap%>" class="input_text2 color vmiddle" style="width:140px;" maxlength="6" /></td>
				<td>메인메뉴 사이의 간격을 지정합니다</td>
			</tr><tr>
				<th>서브메뉴 간격</th>
				<td><input type="text" name="intSubMenuGap" value="<%=DKRS_intSubMenuGap%>" class="input_text2 color vmiddle" style="width:140px;" maxlength="6" /></td>
				<td>서브메뉴 사이의 간격을 지정합니다</td>
			</tr><tr>
				<th>서브메뉴 좌우여백</th>
				<td><input type="text" name="intSubBgAdd" value="<%=DKRS_intSubBgAdd%>" class="input_text2 color vmiddle" style="width:140px;" maxlength="6" /></td>
				<td>서브메뉴배경의 좌우여백을 지정</td>
			</tr><tr>
				<th>서브메뉴표시속도</th>
				<td><input type="text" name="intSubMenuSpeed" value="<%=DKRS_intSubMenuSpeed%>" class="input_text2 color vmiddle" style="width:140px;" maxlength="6" /></td>
				<td>서브메뉴가 나타나는 시간 입력 (단위 : 초)</td>
			</tr><tr>
				<th>메인메뉴시작값</th>
				<td><input type="text" name="intMainMenuStart" value="<%=DKRS_intMainMenuStart%>" class="input_text2 color vmiddle" style="width:140px;" maxlength="6" /></td>
				<td>메인메뉴 1번째가 시작되는 시작점</td>
			</tr><tr>
				<td colspan="3" align="center" style="padding:10px 0px;"><input type="image" src="<%=IMG_BTN%>/btn_submit_gray.gif" /></td>
			</tr>

		</table>
	</form>
</div>
<!--#include virtual = "/admin/_inc/copyright.asp"-->
