<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<!--#include virtual = "/admin/_inc/document.asp"-->
<%
	ADMIN_LEFT_MODE = "WEBPRO"
	INFO_MODE = "WEBPRO1-1"
	W1200 = "T"

	view = 6

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
<input type="hidden" name="mode" value="POINT" />
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
			<input type="radio" name="isPointUse" id="isPointUse_T" class="input_check"  value="T" <%=isChecked("T",isPointUse)%> /><label for="isPointUse_T">적용</label>
			<input type="radio" name="isPointUse" id="isPointUse_F" class="input_check2" value="F" <%=isChecked("F",isPointUse)%> /><label for="isPointUse_F">미적용</label>
		</td>
		<td class="borLeft">해당 게시판에 포인트제도의 적용여부 선택</td>
	</tr><tr>
		<th>게시물보기</th>
		<td><input type="text" name="intPointView" class="input_text tright" style="width:120px;" value="<%=intPointView%>" /> <strong>POINT</strong></td>
		<td class="borLeft">게시물 클릭 시 부여될 포인트</td>
	</tr><tr>
		<th>게시물작성</th>
		<td><input type="text" name="intPointWrite" class="input_text tright" style="width:120px;" value="<%=intPointWrite%>" /> <strong>POINT</strong></td>
		<td class="borLeft">게시물 작성 시 부여될 포인트</td>
	</tr><tr>
		<th>게시물 답변 작성</th>
		<td><input type="text" name="intPointReply" class="input_text tright" style="width:120px;" value="<%=intPointReply%>" /> <strong>POINT</strong></td>
		<td class="borLeft">게시물 답글 작성 시 부여될 포인트</td>
	</tr><tr>
		<th>자료업로드시</th>
		<td><input type="text" name="intPointUpload" class="input_text tright" style="width:120px;" value="<%=intPointUpload%>" /> <strong>POINT</strong></td>
		<td class="borLeft">게시물 작성 시 자료가 포함된 게시물 (작성과 업로드는 중복 적용)</td>
	</tr><tr>
		<th>자료다운로드</th>
		<td><input type="text" name="intPointDownload" class="input_text tright" style="width:120px;" value="<%=intPointDownload%>" /> <strong>POINT</strong></td>
		<td class="borLeft">게시물에 첨부된 자료를 다운로드 받을시 부여될 포인트</td>
	</tr><tr>
		<th>코멘트 작성</th>
		<td><input type="text" name="intPointComment" class="input_text tright" style="width:120px;" value="<%=intPointComment%>" /> <strong>POINT</strong></td>
		<td class="borLeft">코멘트 작성시 부여될 포인트</td>
	</tr><tr>
		<th>게시물 추천</th>
		<td><input type="text" name="intPointVote" class="input_text tright" style="width:120px;" value="<%=intPointVote%>" /> <strong>POINT</strong></td>
		<td class="borLeft">게시물 추천시 부여될 포인트</td>
	</tr><tr>
		<th>추천시 게시자 포인트</th>
		<td><input type="text" name="intPointVoteWriter" class="input_text tright" style="width:120px;" value="<%=intPointVoteWriter%>" /> <strong>POINT</strong></td>
		<td class="borLeft">게시물 추천시 글 작성자에게 부여될 포인트</td>
	</tr>


	<tr>
		<th>게시물 삭제 적용</th>
		<td>
			<input type="radio" name="isPointDelete" id="isPointDelete_T" class="input_check"  value="T" <%=isChecked("T",isPointDelete)%> /><label for="isPointDelete_T">삭제시 포인트 차감 적용</label>
			<input type="radio" name="isPointDelete" id="isPointDelete_F" class="input_check2" value="F" <%=isChecked("F",isPointDelete)%> /><label for="isPointDelete_F">삭제시 포인트 차감 미적용</label>
		</td>
		<td class="borLeft">작성한 게시물 삭제 시 부여된 포인트 차감 여부</td>
	</tr><tr>
		<th>코멘트 삭제 적용</th>
		<td>
			<input type="radio" name="isPointDelComment" id="isPointDelComment_T" class="input_check"  value="T" <%=isChecked("T",isPointDelComment)%> /><label for="isPointDelComment_T">삭제시 포인트 차감 적용</label>
			<input type="radio" name="isPointDelComment" id="isPointDelComment_F" class="input_check2" value="F" <%=isChecked("F",isPointDelComment)%> /><label for="isPointDelComment_F">삭제시 포인트 차감 미적용</label>
		</td>
		<td class="borLeft">작성한 코멘트 삭제 시 부여된 포인트 차감 여부</td>
	</tr>
</table>
</form>
	<div class="btn_area"><%=viewImgStJS(IMG_BTN&"/btn_rect_confirm.gif",99,45,"","margin-top:20px;","cp","onclick=""submitChkPoint();""")%></div>
</div>
<!--#include virtual = "/admin/_inc/copyright.asp"-->
