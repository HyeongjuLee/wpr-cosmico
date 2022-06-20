<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<!--#include virtual = "/admin/_inc/document.asp"-->
<%
	ADMIN_LEFT_MODE = "WEBPRO"
	INFO_MODE = "WEBPRO1-1"
	W1200 = "T"
	view = 1

	strBoardName = gRequestTF("bname",True)

	arrParams = Array(_
		Db.makeParam("@strBoardName",adVarChar,adParamInput,50,strBoardName) _
	)

	Set DKRS = Db.execRs("DKSP_FORUM_CONFIG_VIEW_ADMIN",DB_PROC,arrParams,Nothing)

	If Not DKRS.BOF And Not DKRS.EOF Then

		DKRS_strCateCode		= DKRS("strCateCode")
		DKRS_strBoardTitle		= DKRS("strBoardTitle")
		DKRS_strBoardType		= DKRS("strBoardType")
		DKRS_strBoardSkin		= DKRS("strBoardSkin")
		DKRS_isUse				= DKRS("isUse")
		DKRS_isLeft				= DKRS("isLeft")
		DKRS_strLeftMode		= DKRS("strLeftMode")
		DKRS_isCategoryUse		= DKRS("isCategoryUse")
		DKRS_isCommentUse		= DKRS("isCommentUse")
		DKRS_isForum			= DKRS("isForum")
		DKRS_blockWord			= DKRS("blockWord")
		DKRS_blockWordChg		= DKRS("blockWordChg")
		DKRS_defaultWord		= DKRS("defaultWord")
		DKRS_isSearch			= DKRS("isSearch")
		DKRS_intListView		= DKRS("intListView")
		DKRS_isSMS				= DKRS("isSMS")
		DKRS_defaultSMS			= DKRS("defaultSMS")
		DKRS_newIconDate		= DKRS("newIconDate")
		DKRS_isImg				= DKRS("isImg")
		DKRS_strImg				= DKRS("strImg")
		DKRS_isSubImg			= DKRS("isSubImg")
		DKRS_SubImg				= DKRS("SubImg")
		DKRS_mainVar			= DKRS("mainVar")
		DKRS_SubVar				= DKRS("SubVar")
		DKRS_sViewVar			= DKRS("sViewVar")			'sview
		DKRS_isVote				= DKRS("isVote")			'sview
		DKRS_intWriteLimit		= DKRS("intWriteLimit")
		DKRS_intReplyLimit		= DKRS("intReplyLimit")
		DKRS_isReplyLimitDate	= DKRS("isReplyLimitDate")
		DKRS_isGroupUse			= DKRS("isGroupUse")
		DKRS_isTopNotice		= DKRS("isTopNotice")
		DKRS_intTopNotice		= DKRS("intTopNotice")
		DKRS_isViewNameType		= DKRS("isViewNameType")
		DKRS_isViewNameChg		= DKRS("isViewNameChg")
		DKRS_intViewNameCnt		= DKRS("intViewNameCnt")
		DKRS_isTopBestView  	= DKRS("isTopBestView")
		DKRS_intTopBestView 	= DKRS("intTopBestView")
		DKRS_intTopBestLimit	= DKRS("intTopBestLimit")
		DKRS_isTopNavi			= DKRS("isTopNavi")
		DKRS_isTopMargin		= DKRS("isTopMargin")
		DKRS_intTopMargin		= DKRS("intTopMargin")

	Else
		Call ALERTS("설정값 로딩중 문제가 발생하였습니다. 새로고침 후 다시 시도해주세요.","back","")

	End If

%>
<script type="text/javascript" src="forum.js"></script>
<link rel="stylesheet" href="forum.css" />
</head>
<body>
<!--#include virtual = "/admin/_inc/header.asp"-->
<div id="admin_forum" class="insert">
	<!--#include file = "forum_tabs.asp"-->
	<form name="cfrm" action="forumHandler.asp" method="post" enctype="multipart/form-data" onsubmit="return chkConfigFrm(this)">
		<input type="hidden" name="mode" value="CONFIG" />
		<input type="hidden" name="strBoardName" value="<%=strBoardName%>" />
		<input type="hidden" name="isLeft" value="<%=DKRS_isLeft%>" />
		<input type="hidden" name="strLeftMode" value="<%=strLeftMode%>" />
		<input type="hidden" name="strBoardSkin" value="<%=strBoardSkin%>" />
		<input type="hidden" name="o_strImg" value="<%=DKRS_strImg%>" />
		<input type="hidden" name="o_SubImg" value="<%=DKRS_SubImg%>" />
		<table <%=tableatt%> class="width100">
			<colgroup>
				<col width="150" />
				<col width="550" />
				<col width="*" />
			</colgroup>
			<tr>
				<th colspan="3">게시판 기본내용</th>
			</tr><tr>
				<th>항목</th>
				<th>설정</th>
				<th>설명</th>
			</tr><tr>
				<th>게시판아이디</th>
				<td><%=strBoardName%></td>
				<td class="borLeft"></td>
			</tr><tr>
				<th>게시판사용</th>
				<td><div class="checks">
					<input type="radio" name="isUse" id="isUse_T" class="input_check"  value="T" <%=isChecked("T",DKRS_isUse)%> /><label for="isUse_T" class="radioT">사용함</label>
					<input type="radio" name="isUse" id="isUse_F" class="input_check2" value="F" <%=isChecked("F",DKRS_isUse)%> /><label for="isUse_F" class="radioF">사용중지</label>

				</div></td>
				<td class="borLeft">게시판을 활성화(사용) 합니다.</td>
			</tr><tr>
				<th>게시판타입</th>
				<td>
					<select name="strBoardType" class="input_select">
						<option value="board" <%=isSelect(DKRS_strBoardType,"board")%>>게시판타입</option>
						<option value="board_vote" <%=isSelect(DKRS_strBoardType,"board_vote")%>>게시판타입_추천노출</option>
						<option value="limitReply" <%=isSelect(DKRS_strBoardType,"limitReply")%>>게시판타입_댓글일자제한</option>

						<option value="gallery" <%=isSelect(DKRS_strBoardType,"gallery")%>>갤러리타입</option>
						<option value="gallery2" <%=isSelect(DKRS_strBoardType,"gallery2")%>>갤러리타입(blog리스트)</option>
						<option value="movie" <%=isSelect(DKRS_strBoardType,"movie")%>>동영상타입</option>
						<option value="movie2" <%=isSelect(DKRS_strBoardType,"movie2")%>>동영상타입(blog리스트)</option>
						<option value="liner" <%=isSelect(DKRS_strBoardType,"liner")%>>한 줄 게시판 타입</option>
						<option value="review" <%=isSelect(DKRS_strBoardType,"review")%>>리뷰게시판</option>
						<option value="kin" <%=isSelect(DKRS_strBoardType,"kin")%>>지식인타입</option>

					</select>
				</td>
				<td class="borLeft">게시판타입을 설정합니다.</td>
			</tr><tr>
				<th>게시판이름</th>
				<td><input type="text" name="strBoardTitle" class="input_text" style="width:220px;" value="<%=DKRS_strBoardTitle%>" /></td>
				<td class="borLeft">게시판이름을 설정합니다.</td>
			</tr><tr>
				<th>게시판출력위치</th>
				<td><input type="text" name="strCateCode" class="input_text" style="width:220px;" value="<%=DKRS_strCateCode%>" /></td>
				<td class="borLeft">게시판이름을 설정합니다.</td>
			</tr><tr>
				<th>게시판 네비 추적</th>
				<td>메인 : <input type="text" name="mainVar" class="input_text" style="width:45px;" value="<%=DKRS_mainVar%>" />&nbsp;&nbsp; 서브 (view값) : <input type="text" name="SubVar" class="input_text" style="width:45px;" value="<%=DKRS_SubVar%>" />&nbsp;&nbsp; 서브2 (sview값) : <input type="text" name="sViewVar" class="input_text" style="width:45px;" value="<%=DKRS_sViewVar%>" /></td>
				<td class="borLeft">게시판네비추적 (서브 = view값, 서브2 = sview값(기본값:0) ).</td>
			</tr>

			<tr>
				<th colspan="3">게시판 출력 관련</th>
			</tr><tr>
				<th>상단 내비 출력</th>
				<td>
					<input type="radio" name="isTopNavi" id="isTopNavi_T" class="input_check"  value="T" <%=isChecked("T",DKRS_isTopNavi)%> /><label for="isTopNavi_T" class="radioT">상단 내비 사용</label>
					<input type="radio" name="isTopNavi" id="isTopNavi_F" class="input_check2" value="F" <%=isChecked("F",DKRS_isTopNavi)%> /><label for="isTopNavi_F" class="radioF">상단 내비 미사용</label>
				</td>
				<td class="borLeft">게시판에 상단에 내비(브레드크럼/GNB등)을 사용합니다.</td>
			</tr><tr>
				<th>상단 여백 사용</th>
				<td>
					<input type="radio" name="isTopMargin" id="isTopMargin_T" class="input_check"  value="T" <%=isChecked("T",DKRS_isTopMargin)%> /><label for="isTopMargin_T" class="radioT">상단 여백 사용</label>
					<input type="radio" name="isTopMargin" id="isTopMargin_F" class="input_check2" value="F" <%=isChecked("F",DKRS_isTopMargin)%> /><label for="isTopMargin_F" class="radioF">상단 여백 미사용</label>
					/ <input type="text" name="intTopMargin" class="input_text" style="width:60px;" value="<%=DKRS_intTopMargin%>" <%=onlyKeys%> />px
				</td>
				<td class="borLeft">게시판에 출력할 목록의 수를 지정합니다.</td>
			</tr><tr>
				<th>게시판서브이미지</th>
				<td>
					<select name="isSubImg" class="input_select">
						<option value="T" <%=isSelect(DKRS_isSubImg,"T")%>>사용</option>
						<option value="F" <%=isSelect(DKRS_isSubImg,"F")%>>미사용</option>
					</select>
					<input type="file" name="SubImg" class="input_file" style="width:220px;" value="" /></td>
				<td class="borLeft">게시판의 서브 이미지를 설정합니다.</td>
			</tr><tr>
				<th>게시판상단이미지</th>
				<td>
					<select name="isImg" class="input_select">
						<option value="T" <%=isSelect(DKRS_isImg,"T")%>>사용</option>
						<option value="F" <%=isSelect(DKRS_isImg,"F")%>>미사용</option>
					</select>
					<input type="file" name="strImg" class="input_file" style="width:220px;" value="" /></td>
				<td class="borLeft">게시판의 상단 이미지를 설정합니다.</td>
			</tr><tr>
				<th>리스트 출력 갯수</th>
				<td><input type="text" name="intListView" class="input_text" style="width:60px;" value="<%=DKRS_intListView%>" <%=onlyKeys%> /> 개 씩 출력</td>
				<td class="borLeft">게시판에 출력할 목록의 수를 지정합니다.</td>
			</tr><tr>
				<th>New 아이콘 적용일자</th>
				<td style="padding-top:7px;padding-bottom:7px;">
					<input type="text" name="newIconDate" class="input_text" style="width:80px;" value="<%=DKRS_newIconDate%>" />일 전 게시물까지 표시<br />
				</td>
				<td class="borLeft">0일로 설정하면 오늘 작성된 게시물만 new 아이콘을 표시합니다.</td>
			</tr>

			<tr>
				<th colspan="3">게시판 기능 노출 관련</th>
			</tr>
			<tr>
				<th>검색기능 사용</th>
				<td>
					<input type="radio" name="isSearch" id="isSearch_T" class="input_check"  value="T" <%=isChecked("T",DKRS_isSearch)%> /><label for="isSearch_T" class="radioT">검색기능을 사용합니다.</label>
					<input type="radio" name="isSearch" id="isSearch_F" class="input_check2" value="F" <%=isChecked("F",DKRS_isSearch)%> /><label for="isSearch_F" class="radioF">검색기능을 사용하지 않습니다.</label>
				</td>
				<td class="borLeft">게시판에 검색 기능을 사용합니다.</td>
			</tr><tr>
				<th>코멘트기능사용<br />(상세보기 댓글)</th>
				<td>
					<input type="radio" name="isCommentUse" id="isCommentUse_T" class="input_check"  value="T" <%=isChecked("T",DKRS_isCommentUse)%> /><label for="isCommentUse_T" class="radioT">코멘트(댓글)를 사용합니다.</label>
					<input type="radio" name="isCommentUse" id="isCommentUse_F" class="input_check2" value="F" <%=isChecked("F",DKRS_isCommentUse)%> /><label for="isCommentUse_F" class="radioF">코멘트(댓글)를 사용하지 않습니다.</label>
				</td>
				<td class="borLeft">게시판에 코멘트(댓글) 기능을 사용합니다.</td>
			</tr><tr>
				<th>추천기능 사용</th>
				<td>
					<input type="radio" name="isVote" id="isVote_T" class="input_check"  value="T" <%=isChecked("T",DKRS_isVote)%> /><label for="isVote_T" class="radioT">추천기능(좋아요)를 사용</label>
					<input type="radio" name="isVote" id="isVote_F" class="input_check2" value="F" <%=isChecked("F",DKRS_isVote)%> /><label for="isVote_F" class="radioF">추천기능(좋아요)를 미사용</label>
				</td>
				<td class="borLeft">게시판에 추천기능(좋아요) 기능을 사용합니다.</td>
			</tr>
			<tr>
				<th>상단 공지 노출</th>
				<td>
					<input type="radio" name="isTopNotice" id="isTopNotice_T" class="input_check"  value="T" <%=isChecked("T",DKRS_isTopNotice)%> /><label for="isTopNotice_T" class="radioT">공지를 노출</label>
					<input type="radio" name="isTopNotice" id="isTopNotice_F" class="input_check2" value="F" <%=isChecked("F",DKRS_isTopNotice)%> /><label for="isTopNotice_F" class="radioF">공지를 미노출</label>
					/ <input type="text" name="intTopNotice" class="input_text" style="width:60px;" value="<%=DKRS_intTopNotice%>" <%=onlyKeys%> /> 개

				</td>
				<td class="borLeft">게시판에 상단 공지 노출 기능을 사용합니다.</td>
			</tr><tr>
				<th>상단 베스트 노출</th>
				<td>
					<input type="radio" name="isTopBestView" id="isTopBestView_T" class="input_check"  value="T" <%=isChecked("T",DKRS_isTopBestView)%> /><label for="isTopBestView_T" class="radioT">상단 베스트 사용</label>
					<input type="radio" name="isTopBestView" id="isTopBestView_F" class="input_check2" value="F" <%=isChecked("F",DKRS_isTopBestView)%> /><label for="isTopBestView_F" class="radioF">상단 베스트 미사용</label>
					/ <input type="text" name="intTopBestView" class="input_text" style="width:60px;" value="<%=DKRS_intTopBestView%>" <%=onlyKeys%> /> 개
					/ <input type="text" name="intTopBestLimit" class="input_text" style="width:60px;" value="<%=DKRS_intTopBestLimit%>" <%=onlyKeys%> /> 일이내
				</td>
				<td class="borLeft">게시판 상단에 베스트 노출을 사용합니다.</td>
			</tr>

			<tr>
				<th>게시판 작성자 노출</th>
				<td>
					<input type="radio" name="isViewNameType" id="isViewNameType_N" class="input_check"  value="N" <%=isChecked("N",DKRS_isViewNameType)%> /><label for="isViewNameType_N" class="radioT">이름 노출</label>
					<input type="radio" name="isViewNameType" id="isViewNameType_I" class="input_check2" value="I" <%=isChecked("I",DKRS_isViewNameType)%> /><label for="isViewNameType_I" class="radioF">아이디 노출</label>

				</td>
				<td class="borLeft">게시판에 상단 공지 노출 기능을 사용합니다.</td>
			</tr><tr>
				<th>작성자 아이디 가리기</th>
				<td>
					<input type="radio" name="isViewNameChg" id="isViewNameChg_T" class="input_check"  value="T" <%=isChecked("T",DKRS_isViewNameChg)%> /><label for="isViewNameChg_T" class="radioT">가리기</label>
					<input type="radio" name="isViewNameChg" id="isViewNameChg_F" class="input_check2" value="F" <%=isChecked("F",DKRS_isViewNameChg)%> /><label for="isViewNameChg_F" class="radioF">그대로 노출</label>
					/ <input type="text" name="intViewNameCnt" class="input_text" style="width:60px;" value="<%=DKRS_intViewNameCnt%>" <%=onlyKeys%> /> 글자 제외

				</td>
				<td class="borLeft">게시판에 상단 공지 노출 기능을 사용합니다.</td>
			</tr>

			<tr>
				<th>그룹게시판</th>
				<td>
					<input type="radio" name="isGroupUse" id="isGroupUse_T" class="input_check"  value="T" <%=isChecked("T",DKRS_isGroupUse)%> /><label for="isGroupUse_T" class="radioT">그룹기능을 사용</label>
					<input type="radio" name="isGroupUse" id="isGroupUse_F" class="input_check2" value="F" <%=isChecked("F",DKRS_isGroupUse)%> /><label for="isGroupUse_F" class="radioF">미사용</label>
				</td>
				<td class="borLeft">해당하는 그룹만 사용하는 게시판 사용여부.</td>
			</tr>

			<tr>
				<th colspan="3">게시판 제한 사항 관련</th>
			</tr>
			<tr>
				<th>일일 게시물 작성 제한</th>
				<td><input type="text" name="intWriteLimit" class="input_text" style="width:60px;" value="<%=DKRS_intWriteLimit%>" <%=onlyKeys%> /> 개 / (0 : 무제한)</td>
				<td class="borLeft">하루에 게시물을 작성할 수 있는 갯수를 지정합니다. </td>
			</tr><tr>
				<th>게시물당 댓글 갯수 제한</th>
				<td><input type="text" name="intReplyLimit" class="input_text" style="width:60px;" value="<%=DKRS_intReplyLimit%>" <%=onlyKeys%> /> 개 / (0 : 무제한)</td>
				<td class="borLeft">게시물에 댓글을 달 수 있는 갯수를 제한합니다. </td>
			</tr><tr>
				<th>댓글 일자 제한</th>
				<td>
					<input type="radio" name="isReplyLimitDate" id="isReplyLimitDate_T" class="input_check"  value="T" <%=isChecked("T",DKRS_isReplyLimitDate)%> /><label for="isReplyLimitDate_T" class="radioT">사용</label>
					<input type="radio" name="isReplyLimitDate" id="isReplyLimitDate_F" class="input_check2" value="F" <%=isChecked("F",DKRS_isReplyLimitDate)%> /><label for="isReplyLimitDate_F" class="radioF">미사용</label>
				</td>
				<td class="borLeft">게시물에 댓글을 달 수 있는 일자를 지정합니다. </td>
			</tr>


			<tr>
				<th>불량단어</th>
				<td style="padding-top:7px;padding-bottom:7px;">
					<textarea name="blockWord" class="input_area" style="width:95%; height:200px;"><%=DKRS_blockWord%></textarea><br />
				</td>
				<td class="borLeft">쉼표(,) 로 구분해주세요. (ex:병신,개새끼,욕설 등)</td>
			</tr><tr>
				<th>불량단어 변경</th>
				<td>불량단어를 <input type="text" name="blockWordChg" class="input_text" style="width:80px;" value="<%=DKRS_blockWordChg%>" /> 로 변경합니다.</td>
				<td class="borLeft"></td>
			</tr><tr>
				<th>기본문구</th>
				<td style="padding-top:7px;padding-bottom:7px;">
					<textarea name="defaultWord" class="input_area" style="width:95%; height:200px;"><%=DKRS_defaultWord%></textarea><br />
				</td>
				<td class="borLeft">게시물 작성 시 기본으로 설정되는 글입니다.</td>
			</tr><tr>
				<th>SMS 사용여부</th>
				<td>
					<input type="radio" name="isSMS" id="isSMS_T" class="input_check"  value="T" <%=isChecked("T",DKRS_isSMS)%> /><label for="isSMS_T">SMS기능을 사용합니다.</label>
					<input type="radio" name="isSMS" id="isSMS_F" class="input_check2" value="F" <%=isChecked("F",DKRS_isSMS)%> /><label for="isSMS_F">SMS기능을 사용하지 않습니다.</label>
				</td>
				<td class="borLeft">해당 게시판에 SMS 사용여부를 확인합니다.</td>
			</tr><tr>
				<th>SMS 기본문구</th>
				<td style="padding-top:7px;padding-bottom:7px;">
					<textarea name="defaultSMS" class="input_area" style="width:95%; height:100px;"><%=DKRS_defaultSMS%></textarea><br />
				</td>
				<td class="borLeft"><p>SMS 기본문구를 설정합니다.</p>(<span class="GoodsComment_cnt">0</span> / 80byte)</td>
			</tr>
		</table>
	</form>
	<div class="btn_area"><%=viewImgStJS(IMG_BTN&"/btn_rect_confirm.gif",99,45,"","margin-top:20px;","cp","onclick=""submitChkConfig();""")%></div>
</div>
<!--#include virtual = "/admin/_inc/copyright.asp"-->
