<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<!--#include virtual = "/admin/_inc/document.asp"-->
<%
	ADMIN_LEFT_MODE = "WEBPRO"
	INFO_MODE = "WEBPRO1-1"
	W1200 = "T"

	view = 2

	strBoardName = gRequestTF("bname",True)

	arrParams = Array(_
		Db.makeParam("@strBoardName",adVarChar,adParamInput,50,strBoardName) _
	)

	Set DKRS = Db.execRs("DKPA_FORUM_CONFIG_LEVEL",DB_PROC,arrParams,Nothing)

	If Not DKRS.BOF And Not DKRS.EOF Then
		intLevelList				= DKRS("intLevelList")
		intLevelView				= DKRS("intLevelView")
		intLevelWrite				= DKRS("intLevelWrite")
		intLevelReply				= DKRS("intLevelReply")
		intLevelCommentList			= DKRS("intLevelCommentList")
		intLevelCommentWrite		= DKRS("intLevelCommentWrite")
		intLevelCommentReply		= DKRS("intLevelCommentReply")
		intLevelUpload				= DKRS("intLevelUpload")
		intLevelDownload			= DKRS("intLevelDownload")
	Else
		Call ALERTS("설정값 로딩중 문제가 발생하였습니다. 새로고침 후 다시 시도해주세요.","back","")

	End If
	Call closeRS(DKRS)
	strBoardTitle = Db.execRsData("DKPA_FORUM_TITLE_SELECT",DB_PROC,arrParams,Nothing)


%>

<script type="text/javascript" src="forum.js"></script>
<link rel="stylesheet" href="forum.css" />

</head>
<body>
<!--#include virtual = "/admin/_inc/header.asp"-->

<div class="insert">

<!--#include file = "forum_tabs.asp"-->
<form name="cfrm" action="forumHandler.asp" enctype="multipart/form-data" method="post">
<input type="hidden" name="mode" value="LEVEL" />
<input type="hidden" name="strBoardName" value="<%=strBoardName%>" />
<input type="hidden" name="memLevelDownload" value="<%=ADMIN%>" />
<input type="hidden" name="intLevelDownload" value="<%=10%>" />

<table <%=tableatt%> class="width100">
	<colgroup>
		<col width="200" />
		<col width="*" />
	</colgroup>
	<tr>
		<th>게시판아이디</th>
		<td><%=strBoardName%></td>
	</tr><tr>
		<th>게시판 이름</th>
		<td><%=strBoardTitle%></td>
	</tr><tr>
		<th colspan="2">서브 관리자 및 관리자는 모든 권한을 갖고 있습니다</th>
	</tr><tr>
		<th>게시판 리스트 권한</th>
		<td>
			<select name="intLevelList" class="select">
				<option value="0"	<%=isSelect("0",intLevelList)%> >전체공개</option>
				<option value="1"	<%=isSelect("1",intLevelList)%> >1레벨 이상 회원에게 공개</option>
				<option value="2"	<%=isSelect("2",intLevelList)%> >2레벨 이상 회원에게 공개</option>
				<option value="3"	<%=isSelect("3",intLevelList)%> >3레벨 이상 회원에게 공개</option>
				<option value="4"	<%=isSelect("4",intLevelList)%> >4레벨 이상 회원에게 공개</option>
				<option value="5"	<%=isSelect("5",intLevelList)%> >5레벨 이상 회원에게 공개</option>
				<option value="6"	<%=isSelect("6",intLevelList)%> >6레벨 이상 회원에게 공개</option>
				<option value="7"	<%=isSelect("7",intLevelList)%> >7레벨 이상 회원에게 공개</option>
				<option value="8"	<%=isSelect("8",intLevelList)%> >8레벨 이상 회원에게 공개</option>
				<option value="9"	<%=isSelect("9",intLevelList)%> >9레벨 이상 회원에게 공개</option>
				<option value="10"	<%=isSelect("10",intLevelList)%>>10레벨 이상 회원에게 공개</option>
				<option value="11"	<%=isSelect("11",intLevelList)%>>11레벨 이상 회원에게 공개</option>
			</select>
			: 게시판 목록을 볼 수 있는 권한입니다.
		</td>
	</tr><tr>
		<th>게시판 내용보기 권한</th>
		<td>
			<select name="intLevelView" class="select">
				<option value="0"	<%=isSelect("0",intLevelView)%> >전체공개</option>
				<option value="1"	<%=isSelect("1",intLevelView)%> >1레벨 이상 회원에게 공개</option>
				<option value="2"	<%=isSelect("2",intLevelView)%> >2레벨 이상 회원에게 공개</option>
				<option value="3"	<%=isSelect("3",intLevelView)%> >3레벨 이상 회원에게 공개</option>
				<option value="4"	<%=isSelect("4",intLevelView)%> >4레벨 이상 회원에게 공개</option>
				<option value="5"	<%=isSelect("5",intLevelView)%> >5레벨 이상 회원에게 공개</option>
				<option value="6"	<%=isSelect("6",intLevelView)%> >6레벨 이상 회원에게 공개</option>
				<option value="7"	<%=isSelect("7",intLevelView)%> >7레벨 이상 회원에게 공개</option>
				<option value="8"	<%=isSelect("8",intLevelView)%> >8레벨 이상 회원에게 공개</option>
				<option value="9"	<%=isSelect("9",intLevelView)%> >9레벨 이상 회원에게 공개</option>
				<option value="10"	<%=isSelect("10",intLevelView)%>>10레벨 이상 회원에게 공개</option>
				<option value="11"	<%=isSelect("11",intLevelView)%>>11레벨 이상 회원에게 공개</option>
			</select>
			: 글 내용을 볼 수 있는 권한입니다
		</td>
	</tr><tr>
		<th>게시판 쓰기 권한</th>
		<td>
			<select name="intLevelWrite" class="select">
				<option value="0"	<%=isSelect("0",intLevelWrite)%> >전체공개</option>
				<option value="1"	<%=isSelect("1",intLevelWrite)%> >1레벨 이상 회원에게 공개</option>
				<option value="2"	<%=isSelect("2",intLevelWrite)%> >2레벨 이상 회원에게 공개</option>
				<option value="3"	<%=isSelect("3",intLevelWrite)%> >3레벨 이상 회원에게 공개</option>
				<option value="4"	<%=isSelect("4",intLevelWrite)%> >4레벨 이상 회원에게 공개</option>
				<option value="5"	<%=isSelect("5",intLevelWrite)%> >5레벨 이상 회원에게 공개</option>
				<option value="6"	<%=isSelect("6",intLevelWrite)%> >6레벨 이상 회원에게 공개</option>
				<option value="7"	<%=isSelect("7",intLevelWrite)%> >7레벨 이상 회원에게 공개</option>
				<option value="8"	<%=isSelect("8",intLevelWrite)%> >8레벨 이상 회원에게 공개</option>
				<option value="9"	<%=isSelect("9",intLevelWrite)%> >9레벨 이상 회원에게 공개</option>
				<option value="10"	<%=isSelect("10",intLevelWrite)%>>10레벨 이상 회원에게 공개</option>
				<option value="11"	<%=isSelect("11",intLevelWrite)%>>11레벨 이상 회원에게 공개</option>
			</select>
			: 글 작성을 할 수 있는 권한입니다
		</td>
	</tr><tr>
		<th>게시판 답변글 권한</th>
		<td>
			<select name="intLevelReply" class="select">
				<option value="0"	<%=isSelect("0",intLevelReply)%> >전체공개</option>
				<option value="1"	<%=isSelect("1",intLevelReply)%> >1레벨 이상 회원에게 공개</option>
				<option value="2"	<%=isSelect("2",intLevelReply)%> >2레벨 이상 회원에게 공개</option>
				<option value="3"	<%=isSelect("3",intLevelReply)%> >3레벨 이상 회원에게 공개</option>
				<option value="4"	<%=isSelect("4",intLevelReply)%> >4레벨 이상 회원에게 공개</option>
				<option value="5"	<%=isSelect("5",intLevelReply)%> >5레벨 이상 회원에게 공개</option>
				<option value="6"	<%=isSelect("6",intLevelReply)%> >6레벨 이상 회원에게 공개</option>
				<option value="7"	<%=isSelect("7",intLevelReply)%> >7레벨 이상 회원에게 공개</option>
				<option value="8"	<%=isSelect("8",intLevelReply)%> >8레벨 이상 회원에게 공개</option>
				<option value="9"	<%=isSelect("9",intLevelReply)%> >9레벨 이상 회원에게 공개</option>
				<option value="10"	<%=isSelect("10",intLevelReply)%>>10레벨 이상 회원에게 공개</option>
				<option value="11"	<%=isSelect("11",intLevelReply)%>>11레벨 이상 회원에게 공개</option>
			</select>
			: 글에 대해서 답변을 할 수 있는 권한입니다
		</td>
	</tr><tr>
		<th>게시판 코멘트 보기 권한</th>
		<td>
			<select name="intLevelCommentList" class="select">
				<option value="0"	<%=isSelect("0",intLevelCommentList)%> >전체공개</option>
				<option value="1"	<%=isSelect("1",intLevelCommentList)%> >1레벨 이상 회원에게 공개</option>
				<option value="2"	<%=isSelect("2",intLevelCommentList)%> >2레벨 이상 회원에게 공개</option>
				<option value="3"	<%=isSelect("3",intLevelCommentList)%> >3레벨 이상 회원에게 공개</option>
				<option value="4"	<%=isSelect("4",intLevelCommentList)%> >4레벨 이상 회원에게 공개</option>
				<option value="5"	<%=isSelect("5",intLevelCommentList)%> >5레벨 이상 회원에게 공개</option>
				<option value="6"	<%=isSelect("6",intLevelCommentList)%> >6레벨 이상 회원에게 공개</option>
				<option value="7"	<%=isSelect("7",intLevelCommentList)%> >7레벨 이상 회원에게 공개</option>
				<option value="8"	<%=isSelect("8",intLevelCommentList)%> >8레벨 이상 회원에게 공개</option>
				<option value="9"	<%=isSelect("9",intLevelCommentList)%> >9레벨 이상 회원에게 공개</option>
				<option value="10"	<%=isSelect("10",intLevelCommentList)%>>10레벨 이상 회원에게 공개</option>
				<option value="11"	<%=isSelect("11",intLevelCommentList)%>>11레벨 이상 회원에게 공개</option>
			</select>
			: 게시물에 달린 코멘트를 볼 수 있는 권한입니다.
		</td>
	</tr><tr>
		<th>게시판 코멘트 쓰기 권한</th>
		<td>
			<select name="intLevelCommentWrite" class="select">
				<option value="0"	<%=isSelect("0",intLevelCommentWrite)%> >전체공개</option>
				<option value="1"	<%=isSelect("1",intLevelCommentWrite)%> >1레벨 이상 회원에게 공개</option>
				<option value="2"	<%=isSelect("2",intLevelCommentWrite)%> >2레벨 이상 회원에게 공개</option>
				<option value="3"	<%=isSelect("3",intLevelCommentWrite)%> >3레벨 이상 회원에게 공개</option>
				<option value="4"	<%=isSelect("4",intLevelCommentWrite)%> >4레벨 이상 회원에게 공개</option>
				<option value="5"	<%=isSelect("5",intLevelCommentWrite)%> >5레벨 이상 회원에게 공개</option>
				<option value="6"	<%=isSelect("6",intLevelCommentWrite)%> >6레벨 이상 회원에게 공개</option>
				<option value="7"	<%=isSelect("7",intLevelCommentWrite)%> >7레벨 이상 회원에게 공개</option>
				<option value="8"	<%=isSelect("8",intLevelCommentWrite)%> >8레벨 이상 회원에게 공개</option>
				<option value="9"	<%=isSelect("9",intLevelCommentWrite)%> >9레벨 이상 회원에게 공개</option>
				<option value="10"	<%=isSelect("10",intLevelCommentWrite)%>>10레벨 이상 회원에게 공개</option>
				<option value="11"	<%=isSelect("11",intLevelCommentWrite)%>>11레벨 이상 회원에게 공개</option>
			</select>
			: 게시물에 코멘트를 작성할 수 있는 권한입니다
		</td>
	</tr><tr>
		<th>게시판 코멘트 답변 권한</th>
		<td>
			<select name="intLevelCommentReply" class="select">
				<option value="0"	<%=isSelect("0",intLevelCommentReply)%> >전체공개 에게</option>
				<option value="1"	<%=isSelect("1",intLevelCommentReply)%> >1레벨 이상 회원에게 공개</option>
				<option value="2"	<%=isSelect("2",intLevelCommentReply)%> >2레벨 이상 회원에게 공개</option>
				<option value="3"	<%=isSelect("3",intLevelCommentReply)%> >3레벨 이상 회원에게 공개</option>
				<option value="4"	<%=isSelect("4",intLevelCommentReply)%> >4레벨 이상 회원에게 공개</option>
				<option value="5"	<%=isSelect("5",intLevelCommentReply)%> >5레벨 이상 회원에게 공개</option>
				<option value="6"	<%=isSelect("6",intLevelCommentReply)%> >6레벨 이상 회원에게 공개</option>
				<option value="7"	<%=isSelect("7",intLevelCommentReply)%> >7레벨 이상 회원에게 공개</option>
				<option value="8"	<%=isSelect("8",intLevelCommentReply)%> >8레벨 이상 회원에게 공개</option>
				<option value="9"	<%=isSelect("9",intLevelCommentReply)%> >9레벨 이상 회원에게 공개</option>
				<option value="10"	<%=isSelect("10",intLevelCommentReply)%>>10레벨 이상 회원에게 공개</option>
				<option value="11"	<%=isSelect("11",intLevelCommentReply)%>>11레벨 이상 회원에게 공개</option>
			</select>
			: 게시물 달린 코멘트에 답변을 작성할 수 있는 권한입니다
		</td>
	</tr><tr>
		<th>파일업로드권한</th>
		<td>
			<select name="intLevelUpload" class="select">
				<option value="0"	<%=isSelect("0",intLevelUpload)%> >전체공개</option>
				<option value="1"	<%=isSelect("1",intLevelUpload)%> >1 레벨 이상 회원에게 공개</option>
				<option value="2"	<%=isSelect("2",intLevelUpload)%> >2 레벨 이상 회원에게 공개</option>
				<option value="3"	<%=isSelect("3",intLevelUpload)%> >3 레벨 이상 회원에게 공개</option>
				<option value="4"	<%=isSelect("4",intLevelUpload)%> >4 레벨 이상 회원에게 공개</option>
				<option value="5"	<%=isSelect("5",intLevelUpload)%> >5 레벨 이상 회원에게 공개</option>
				<option value="6"	<%=isSelect("6",intLevelUpload)%> >6 레벨 이상 회원에게 공개</option>
				<option value="7"	<%=isSelect("7",intLevelUpload)%> >7 레벨 이상 회원에게 공개</option>
				<option value="8"	<%=isSelect("8",intLevelUpload)%> >8 레벨 이상 회원에게 공개</option>
				<option value="9"	<%=isSelect("9",intLevelUpload)%> >9 레벨 이상 회원에게 공개</option>
				<option value="10"	<%=isSelect("10",intLevelUpload)%>>10 레벨 이상 회원에게 공개</option>
				<option value="11"	<%=isSelect("11",intLevelUpload)%>>11 레벨 이상 회원에게 공개</option>
			</select>
			: 자료첨부 사용 시 파일업로드를 할 수 있는 권한입니다.
		</td>
	</tr><!-- <tr>
		<th>파일다운로드권한</th>
		<td>
			<select name="memLevelDownload" class="select">
				<option value="ALL"		<%=isSelect("ALL",memLevelDownload)%>>모든 그룹 에게</option>
				<option value="COMPANY"	<%=isSelect("COMPANY",memLevelDownload)%>>사업자 그룹 이상</option>
				<option value="ADMIN"	<%=isSelect("ADMIN",memLevelDownload)%>>관리자 그룹 이상</option>
			</select>
			<select name="intLevelDownload" class="select">
				<option value="0"	<%=isSelect("0",intLevelDownload)%> >전체공개</option>
				<option value="1"	<%=isSelect("1",intLevelDownload)%> >1레벨 이상 회원에게 공개</option>
				<option value="2"	<%=isSelect("2",intLevelDownload)%> >2레벨 이상 회원에게 공개</option>
				<option value="3"	<%=isSelect("3",intLevelDownload)%> >3레벨 이상 회원에게 공개</option>
				<option value="4"	<%=isSelect("4",intLevelDownload)%> >4레벨 이상 회원에게 공개</option>
				<option value="5"	<%=isSelect("5",intLevelDownload)%> >5레벨 이상 회원에게 공개</option>
				<option value="6"	<%=isSelect("6",intLevelDownload)%> >6레벨 이상 회원에게 공개</option>
				<option value="7"	<%=isSelect("7",intLevelDownload)%> >7레벨 이상 회원에게 공개</option>
				<option value="8"	<%=isSelect("8",intLevelDownload)%> >8레벨 이상 회원에게 공개</option>
				<option value="9"	<%=isSelect("9",intLevelDownload)%> >9레벨 이상 회원에게 공개</option>
				<option value="10"	<%=isSelect("10",intLevelDownload)%>>10레벨 이상 회원에게 공개</option>
			</select>
			: 자료첨부 사용 시 파일에 대한 다운로드를 할 수 있는 권한입니다.
		</td>
	</tr> -->
</table>
</form>
	<div class="btn_area"><%=viewImgStJS(IMG_BTN&"/btn_rect_confirm.gif",99,45,"","margin-top:20px;","cp","onclick=""submitChkLevel();""")%></div>
</div>
<!--#include virtual = "/admin/_inc/copyright.asp"-->
