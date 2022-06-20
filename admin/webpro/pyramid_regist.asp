<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<!--#include virtual = "/admin/_inc/document.asp"-->
<%
	ADMIN_LEFT_MODE = "WEBPRO"
	INFO_MODE = "WEBPRO1-1"




%>
<%=CONST_SmartEditor_JS%>
<script type="text/javascript" src="pyramid.js?V1"></script>

<link rel="stylesheet" href="pyramid.css" />
</head>
<body>
<!--#include virtual = "/admin/_inc/header.asp"-->
<div class="insert">
	<form name="ifrm" method="post" action="pyramid_handler.asp" onsubmit="return chkGFrm(this);">
		<input type="hidden" name="MODE" value="REGIST" />
		<table <%=tableatt%> class="width100">
			<col width="180" />
			<col width="*" />
			<tr>
				<th>카테고리</th>
				<td>
					<select name="intCate">
						<option value="5">규정 및 활동법규</option>
						<option value="1">방문판매 등에 관한 법률</option>
						<option value="2">방문판매 등에 관한 법률 시행령</option>
						<option value="3">방문판매 등에 관한 법률 시행규칙</option>
						<option value="4">고시</option>
					</select>
				</td>
			</tr><tr>
				<th>조,항</th>
				<td><input type="text" name="strAticle" class="input_text" style="width:150px;" /></td>
			</tr><tr>
				<th>제목</th>
				<td><input type="text" name="strSubject" class="input_text" style="width:550px;"  /></td>
			</tr><tr>
				<th>내용</th>
				<td>
					<input type="hidden" id="WYG_MOD" name="WYG_MOD" value="T" />
					<textarea name="strContent" id="ir1" style="width:100%;height:450px;min-width:610px;display:none;" cols="50" rows="10"></textarea>
					<input type="hidden" name="firstChk" value="T" />
					<%=FN_Print_SmartEditor("ir1","pyramid_Content",UCase(viewAdminLangCode),"","","")%>
				</td>
			</tr>
		</table>
		<div class="notbor tcenter"><input type="submit" class="input_submit_b design1" value="정책 저장" /></div>
	</form>
</div>
<!--#include virtual = "/admin/_inc/copyright.asp"-->
