<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<!--#include virtual = "/admin/_inc/document.asp"-->
<%
	ADMIN_LEFT_MODE = "WEBPRO"
	INFO_MODE = "WEBPRO1-1"


	Set DKRS = Db.execRs("DKPA_CATEGORY_DEFAULT_COLOR_VIEW",DB_PROC,Nothing,Nothing)

	If Not DKRS.BOF And Not DKRS.EOF Then
		DKRS_OverColor     		= DKRS("OverColor")
		DKRS_OutColor			= DKRS("OutColor")
		DKRS_subOverColor  		= DKRS("subOverColor")
		DKRS_subOutColor   		= DKRS("subOutColor")
		DKRS_leftOverColor 		= DKRS("leftOverColor")
		DKRS_leftOutColor  		= DKRS("leftOutColor")
		DKRS_OverColor2d		= DKRS("OverColor2d")
		DKRS_OutColor2d			= DKRS("OutColor2d")
		DKRS_subOverColor2d		= DKRS("subOverColor2d")
		DKRS_subOutColor2d		= DKRS("subOutColor2d")
		DKRS_leftOverColor2d	= DKRS("leftOverColor2d")
		DKRS_leftOutColor2d		= DKRS("leftOutColor2d")
		DKRS_OverColor3d		= DKRS("OverColor3d")
		DKRS_OutColor3d			= DKRS("OutColor3d")
		DKRS_subOverColor3d		= DKRS("subOverColor3d")
		DKRS_subOutColor3d		= DKRS("subOutColor3d")
		DKRS_leftOverColor3d	= DKRS("leftOverColor3d")
		DKRS_leftOutColor3d		= DKRS("leftOutColor3d")
	Else
		DKRS_OverColor			= "000000"
		DKRS_OutColor			= "000000"
		DKRS_subOverColor 		= "000000"
		DKRS_subOutColor  		= "000000"
		DKRS_leftOverColor		= "000000"
		DKRS_leftOutColor 		= "000000"
		DKRS_OverColor2d		= "000000"
		DKRS_OutColor2d			= "000000"
		DKRS_subOverColor2d		= "000000"
		DKRS_subOutColor2d		= "000000"
		DKRS_leftOverColor2d	= "000000"
		DKRS_leftOutColor2d		= "000000"
		DKRS_OverColor3d		= "000000"
		DKRS_OutColor3d			= "000000"
		DKRS_subOverColor3d		= "000000"
		DKRS_subOutColor3d		= "000000"
		DKRS_leftOverColor3d	= "000000"
		DKRS_leftOutColor3d		= "000000"
	End If
%>
<link rel="stylesheet" href="menuColor.css" />
<script type="text/javascript" src="/jscript/mColorPicker.js"></script>

</head>
<body>


<!--#include virtual = "/admin/_inc/header.asp"-->
<div id="menuColor">
	<form name="colorFrm" action="menuColorHandler.asp" method="post" onsubmit="return thisForm(this);">
		<table <%=tableatt%> class="adminFullWidth list">
			<col width="250" />
			<col width="200" />
			<col width="200" />
			<col width="350" />
			<tr>
				<th>구분</th>
				<th>오버컬러</th>
				<th>아웃컬러</th>
				<th>설명</th>
			</tr>
			<tr>
				<th colspan="4">1차 메뉴 기본 컬러</th>
			</tr><tr>
				<th>대메뉴컬러</th>
				<td><input type="color" id="overColor" name="overColor" value="<%=DKRS_OverColor%>"class="input_text2 color vmiddle" style="width:140px;" maxlength="6" data-hex="true" /></td>
				<td><input type="color" id="outColor" name="outColor" value="<%=DKRS_OutColor%>"class="input_text2 color vmiddle" style="width:140px;" maxlength="6" data-hex="true" /></td>
				<td>상단 대메뉴 컬러</td>
			</tr><tr>
				<th>서브메뉴컬러</th>
				<td><input type="color" id="soverColor" name="subOverColor" value="<%=DKRS_subOverColor%>"class="input_text2 color vmiddle" style="width:140px;" maxlength="6" data-hex="true" /></td>
				<td><input type="color" id="soutColor" name="subOutColor" value="<%=DKRS_subOutColor%>"class="input_text2 color vmiddle" style="width:140px;" maxlength="6" data-hex="true" /></td>
				<td>상단 서브메뉴컬러</td>
			</tr><tr>
				<th>레프트메뉴컬러</th>
				<td><input type="color" id="loverColor" name="leftOverColor" value="<%=DKRS_leftOverColor%>"class="input_text2 color vmiddle" style="width:140px;" maxlength="6" data-hex="true" /></td>
				<td><input type="color" id="loutColor" name="leftOutColor" value="<%=DKRS_leftOutColor%>"class="input_text2 color vmiddle" style="width:140px;" maxlength="6" data-hex="true" /></td>
				<td>좌측메뉴컬러</td>
			</tr>

			<tr>
				<th colspan="4">2차 메뉴 기본 컬러</th>
			</tr><tr>
				<th>대메뉴컬러</th>
				<td><input type="color" id="overColor2d" name="overColor2d" value="<%=DKRS_OverColor2d%>"class="input_text2 color vmiddle" style="width:140px;" maxlength="6" data-hex="true" /></td>
				<td><input type="color" id="outColor2d" name="outColor2d" value="<%=DKRS_OutColor2d%>"class="input_text2 color vmiddle" style="width:140px;" maxlength="6" data-hex="true" /></td>
				<td>상단 대메뉴 컬러</td>
			</tr><tr>
				<th>서브메뉴컬러</th>
				<td><input type="color" id="soverColor2d" name="subOverColor2d" value="<%=DKRS_subOverColor2d%>"class="input_text2 color vmiddle" style="width:140px;" maxlength="6" data-hex="true" /></td>
				<td><input type="color" id="soutColor2d" name="subOutColor2d" value="<%=DKRS_subOutColor2d%>"class="input_text2 color vmiddle" style="width:140px;" maxlength="6" data-hex="true" /></td>
				<td>상단 서브메뉴컬러</td>
			</tr><tr>
				<th>레프트메뉴컬러</th>
				<td><input type="color" id="loverColor2d" name="leftOverColor2d" value="<%=DKRS_leftOverColor2d%>"class="input_text2 color vmiddle" style="width:140px;" maxlength="6" data-hex="true" /></td>
				<td><input type="color" id="loutColor2d" name="leftOutColor2d" value="<%=DKRS_leftOutColor2d%>"class="input_text2 color vmiddle" style="width:140px;" maxlength="6" data-hex="true" /></td>
				<td>좌측메뉴컬러</td>
			</tr>

			<tr>
				<th colspan="4">3차 메뉴 기본 컬러</th>
			</tr><tr>
				<th>대메뉴컬러</th>
				<td><input type="color" id="overColor3d" name="overColor3d" value="<%=DKRS_OverColor3d%>"class="input_text2 color vmiddle" style="width:140px;" maxlength="6" data-hex="true" /></td>
				<td><input type="color" id="outColor3d" name="outColor3d" value="<%=DKRS_OutColor3d%>"class="input_text2 color vmiddle" style="width:140px;" maxlength="6" data-hex="true" /></td>
				<td>상단 대메뉴 컬러</td>
			</tr><tr>
				<th>서브메뉴컬러</th>
				<td><input type="color" id="soverColor3d" name="subOverColor3d" value="<%=DKRS_subOverColor3d%>"class="input_text2 color vmiddle" style="width:140px;" maxlength="6" data-hex="true" /></td>
				<td><input type="color" id="soutColor3d" name="subOutColor3d" value="<%=DKRS_subOutColor3d%>"class="input_text2 color vmiddle" style="width:140px;" maxlength="6" data-hex="true" /></td>
				<td>상단 서브메뉴컬러</td>
			</tr><tr>
				<th>레프트메뉴컬러</th>
				<td><input type="color" id="loverColor3d" name="leftOverColor3d" value="<%=DKRS_leftOverColor3d%>"class="input_text2 color vmiddle" style="width:140px;" maxlength="6" data-hex="true" /></td>
				<td><input type="color" id="loutColor3d" name="leftOutColor3d" value="<%=DKRS_leftOutColor3d%>"class="input_text2 color vmiddle" style="width:140px;" maxlength="6" data-hex="true" /></td>
				<td>좌측메뉴컬러</td>
			</tr><tr>
				<td colspan="4" align="center" style="padding:10px 0px;"><input type="image" src="<%=IMG_BTN%>/btn_submit_gray.gif" /></td>
			</tr>
		</table>
	</form>
</div>
<!--#include virtual = "/admin/_inc/copyright.asp"-->
