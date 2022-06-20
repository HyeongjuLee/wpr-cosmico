<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<!--#include virtual = "/admin/_inc/document.asp"-->
<%
	ADMIN_LEFT_MODE = "WEBPRO"
	INFO_MODE = "WEBPRO1-1"
	W1200 = "T"

	view = 7

	strBoardName = gRequestTF("bname",True)

	arrParams = Array(_
		Db.makeParam("@strBoardName",adVarChar,adParamInput,50,strBoardName) _
	)

	Set DKRS = Db.execRs("DKPA_FORUM_CONFIG_POINT",DB_PROC,arrParams,Nothing)

	If Not DKRS.BOF And Not DKRS.EOF Then

		isPointUse				= DKRS("isPointUse")
		intPointView			= DKRS("intPointView")
		intPointWrite			= DKRS("intPointWrite")
		intPointReply			= DKRS("intPointReply")
		intPointUpload			= DKRS("intPointUpload")
		intPointDownload		= DKRS("intPointDownload")
		intPointComment			= DKRS("intPointComment")
		intPointVote			= DKRS("intPointVote")
		isPointDelete			= DKRS("isPointDelete")
		isPointDelComment		= DKRS("isPointDelComment")
		intPointVoteWriter			= DKRS("intPointVoteWriter")
	Else
		Call ALERTS("설정값 로딩중 문제가 발생하였습니다. 새로고침 후 다시 시도해주세요.","back","")
	End If
	Call closeRs(DKRS)

	strBoardTitle = Db.execRsData("DKPA_FORUM_TITLE_SELECT",DB_PROC,arrParams,Nothing)

%>
<script type="text/javascript" src="forum.js"></script>
<link rel="stylesheet" href="forum.css" />
</head>
<body>
<!--#include virtual = "/admin/_inc/header.asp"-->

<div class="insert">
<!--#include file = "forum_tabs.asp"-->

	<form name="cfrm" action="forumHandler.asp" enctype="multipart/form-data"  method="post">
		<input type="hidden" name="mode" value="LIMIT" />
		<input type="hidden" name="strBoardName" value="<%=strBoardName%>" />
		<table <%=tableatt%> class="width100">
			<colgroup>
				<col width="150" />
				<col width="400" />
				<col width="*" />
			</colgroup>
			<tr>
				<th>항목</th>
				<th>설정</th>
				<th>설명</th>
			</tr><tr>
				<th>게시판아이디</th>
				<td><%=strBoardName%></td>
				<td colspan="2"></td>
			</tr><tr>
				<th>게시판이름</th>
				<td colspan="2"><%=strBoardTitle%></td>
			</tr><tr>
				<th>포인트 적용</th>
				<td>
					<label><input type="radio" name="isPointUse" class="input_chk" value="T" <%=isChecked("T",isPointUse)%> />적용</label>
					<label><input type="radio" name="isPointUse" class="input_chk" value="F" <%=isChecked("F",isPointUse)%> />미적용</label>
				</td>
				<td class="borLeft">해당 게시판에 포인트제도의 적용여부 선택</td>
			</tr>

		</table>
	</form>
	<div class="btn_area"><%=viewImgStJS(IMG_BTN&"/btn_rect_confirm.gif",99,45,"","margin-top:20px;","cp","onclick=""submitChkPoint();""")%></div>
</div>
<!--#include virtual = "/admin/_inc/copyright.asp"-->
