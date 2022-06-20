<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<!--#include virtual = "/admin/_inc/document.asp"-->
<%
	ADMIN_LEFT_MODE = "CONFIG"
	INFO_MODE = "CONFIG3-4"


	arrParams = Array(_
		Db.makeParam("@strDomain",adVarChar,adParamInput,50,"www") _
	)
	Set DKRS = Db.execRs("DKP_ADMIN_JOINPOINT",DB_PROC,arrParams,Nothing)

	If Not DKRS.BOF And Not DKRS.EOF Then
		RS_joinPoint		= DKRS("intJoinPoint")
		RS_joinPointVM		= DKRS("intJoinPointVM")
		RS_joinPointVV		= DKRS("intJoinPointVV")
	Else

	End If

%>
<link rel="stylesheet" href="/admin/css/base.css" />
<script type="text/javascript" src="/admin/jscript/base.js"></script>
</head>
<body>
<!--#include virtual = "/admin/_inc/header.asp"-->
<div id="joinPoint">
	<form name="frm" action="joinPointHandler.asp" method="post">
		<p class="titles">가입 시 적립금 설정</p>
		<table <%=tableatt%> class="adminFullTable">
			<colgroup>
				<col width="180" />
				<col width="300" />
				<col width="*" />
			</colgroup>
			<tr>
				<th>단독 가입 시</th>
				<td class="tweight"><input type="text" name="joinPoint" class="input_text" style="width:140px;" <%=onlyKeys%> value="<%=RS_joinPoint%>" /> Point</td>
				<td>가입자가 추천인 기입없이 단독 가입했을때 지급되는 포인트입니다.</td>
			</tr><tr>
				<th>추천인 기입 시</th>
				<td class="tweight"><input type="text" name="joinPointVM" class="input_text" style="width:140px;" <%=onlyKeys%> value="<%=RS_joinPointVM%>" /> Point</td>
				<td>가입자가 추천인을 기입했을 시 가입회원에게 지급되는 포인트입니다.</td>
			</tr><tr>
				<th>추천인 지급 포인트</th>
				<td class="tweight"><input type="text" name="joinPointVV" class="input_text" style="width:140px;" <%=onlyKeys%> value="<%=RS_joinPointVV%>" /> Point</td>
				<td>가입자가 추천인을 기입했을 시 추천받은 회원에게 지급되는 포인트입니다.</td>
			</tr>
		</table>
		<div class="btn_zone"><input type="image" src="<%=IMG_BTN%>/btn_rect_change.gif" /></div>
	</form>
</div>
<!--#include virtual = "/admin/_inc/copyright.asp"-->
