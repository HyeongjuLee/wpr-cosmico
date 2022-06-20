<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<!--#include virtual = "/admin/_inc/document.asp"-->
<%
	ADMIN_LEFT_MODE = "WEBPRO"
	INFO_MODE = "WEBPRO1-1"


	intIDX = gRequestTF("view",True)

	arrParams = Array(_
		Db.makeParam("@intIDX",adInteger,adParamInput,4,intIDX) _
	)
	Set DKRS = Db.execRs("DKP_PYRAMID_VIEW",DB_PROC,arrParams,Nothing)
	If Not DKRS.BOF And Not DKRS.EOF Then
		DKRS_intCate			= DKRS("intCate")
		DKRS_strAticle			= BACKWORD(DKRS("strAticle"))
		DKRS_strSubject			= BACKWORD(DKRS("strSubject"))
		DKRS_strContent			= BACKWORD(DKRS("strContent"))
	Else
		Call ALERTS("데이터가 없습니다. 새로고침 후 다시 시도해주세요","BACK","")
	End If
	Call closeRs(DKRS)

%>
<%=CONST_SmartEditor_JS%>
<script type="text/javascript" src="pyramid.js"></script>

<link rel="stylesheet" href="pyramid.css" />
</head>
<body>
<!--#include virtual = "/admin/_inc/header.asp"-->
<div class="insert">
	<form name="ifrm" method="post" action="pyramid_handler.asp" onsubmit="return chkGFrm(this);">
		<input type="hidden" name="MODE" value="MODIFY" />
		<input type="hidden" name="intIDX" value="<%=intIDX%>" />
		<table <%=tableatt%> class="width100">
			<col width="180" />
			<col width="*" />
			<tr>
				<th>카테고리</th>
				<td>
					<select name="intCate">
						<option value="5" <%=isSelect(DKRS_intCate,"5")%>>규정 및 활동법규</option>
						<option value="1" <%=isSelect(DKRS_intCate,"1")%>>방문판매 등에 관한 법률</option>
						<option value="2" <%=isSelect(DKRS_intCate,"2")%>>방문판매 등에 관한 법률 시행령</option>
						<option value="3" <%=isSelect(DKRS_intCate,"3")%>>방문판매 등에 관한 법률 시행규칙</option>
						<option value="4" <%=isSelect(DKRS_intCate,"4")%>>고시</option>
					</select>
				</td>
			</tr><tr>
				<th>조,항</th>
				<td><input type="text" name="strAticle" class="input_text" style="width:150px;" value="<%=DKRS_strAticle%>" /></td>
			</tr><tr>
				<th>제목</th>
				<td><input type="text" name="strSubject" class="input_text" style="width:550px;" value="<%=DKRS_strSubject%>" /></td>
			</tr><tr>
				<th>내용</th>
				<td>
					<input type="hidden" id="WYG_MOD" name="WYG_MOD" value="T" />
					<textarea name="strContent" id="ir1" style="width:100%;height:450px;min-width:610px;display:none;" cols="50" rows="10"><%=backword_Area(DKRS_strContent)%></textarea>
					<input type="hidden" name="firstChk" value="T" />
					<%=FN_Print_SmartEditor("ir1","pyramid_Content",UCase(viewAdminLangCode),"","","")%>
				</td>
			</tr>
		</table>
		<div class="notbor tcenter"><input type="submit" class="input_submit_b design1" value="정책 저장" /></div>

	</form>
</div>
<!--#include virtual = "/admin/_inc/copyright.asp"-->