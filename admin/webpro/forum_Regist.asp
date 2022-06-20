<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<!--#include virtual = "/admin/_inc/document.asp"-->
<%
	ADMIN_LEFT_MODE = "WEBPRO"
	INFO_MODE = "WEBPRO1-1"


%>
<script type="text/javascript" src="forum.js"></script>
<link rel="stylesheet" href="forum.css" />
</head>
<body>
<!--#include virtual = "/admin/_inc/header.asp"-->
<div class="insert">
	<form name="cfrm" action="forumHandler.asp" enctype="multipart/form-data"  method="post">
		<input type="hidden" name="mode" value="CREATE" />
		<input type="hidden" name="isLeft" value="F" />
		<input type="hidden" name="strLeftMode" value="" />
		<input type="hidden" name="idcheck" value="" />
		<table <%=tableatt%> class="width100">
			<colgroup>
				<col width="150" />
				<col width="*" />
			</colgroup>
			<tr>
				<th>게시판아이디</th>
				<td>
					<input type="text" name="strBoardName" id="strBoardName" class="vmiddle input_text" style="width:180px;" />
					<a href="javascript:boardNamecheck();" class="a_submit design1" >중복체크</a>

				</td>
			</tr><tr>
				<th>게시판이름</th>
				<td><input type="text" name="strBoardTitle" class="input_text" style="width:220px;" /></td>
			</tr><tr>
				<th>게시판출력위치</th>
				<td>
					<%
							'				SQL = "SELECT [strCateCode], [strCateName],[isView] "
							'				SQL = SQL & " FROM [DK_COM_CATEGORY] "
							'				SQL = SQL & " WHERE [strCateParent] = ? ORDER BY [intCateSort] ASC"
							'				arrParams = Array(_
							'					Db.makeParam("@PARENTS",adVarchar,adParamInput,20,"000") _
							'				)
							'				Set DKRS_CATEGORY = Db.execRs(SQL,DB_TEXT,arrParams,Nothing)
							'
							'				PRINT Tabs(6)&"<select name=""strCateCode"">"
							'				PRINT Tabs(7)&"<option value="""">메뉴 설정</option>"
							'				If DKRS_CATEGORY.BOF Or DKRS_CATEGORY.EOF Then
							'					PRINT Tabs(7)&"<option value="""">카테고리를 우선 저장해주셔야합니다</option>"
							'				Else
							'					Do Until DKRS_CATEGORY.EOF
							'						PRINT Tabs(7)&"<option value="""&DKRS_CATEGORY(0)&""" "&isSelect(CATEGORYS1,DKRS_CATEGORY(0))&">"&DKRS_CATEGORY(1)&" ("&TFVIEWER(DKRS_CATEGORY(2),"USE")&")</option>"
							'						DKRS_CATEGORY.MoveNext
							'					Loop
							''				End If
							'				PRINT Tabs(6)&"</select>"
					%>
					<input type="text" name="strCateCode" value="" class="input_text" />
				</td>
			</tr><tr>
				<th>게시판타입</th>
				<td>
					<select name="strBoardType" class="select">
						<option value="board">게시판타입</option>
						<option value="board_vote">게시판타입_추천노출</option>
						<option value="limitReply">게시판타입_댓글일자제한</option>

						<option value="gallery">갤러리타입</option>
						<option value="gallery2">갤러리타입(blog리스트)</option>
						<option value="movie">동영상타입</option>
						<option value="movie2">동영상타입(blog리스트)</option>
						<option value="liner">한 줄 게시판 타입</option>
						<option value="review">리뷰게시판</option>
						<option value="kin">지식인타입</option>
					</select>


				</td>
			</tr><tr>
				<th>게시판사용</th>
				<td>
					<label><input type="radio" name="isUse" class="vmiddle" style="" value="T" checked="checked" />사용함</label>
					<label><input type="radio" name="isUse" class="vmiddle" style="" value="F" />사용중지</label>
				</td>
			</tr><!-- <tr>
				<th>레프트메뉴사용</th>
				<td>
					<label><input type="radio" name="isLeft" class="vmiddle" style="" value="T" checked="checked" />레프트메뉴를 출력합니다.</label>
					<label><input type="radio" name="isLeft" class="vmiddle" style="" value="F" />레프트메뉴를 출력 하지 않습니다.</label>
				</td>
			</tr><tr>
				<th>레프트출력값</th>
				<td><input type="" name="strLeftMode" class="input_text" style="width:220px;" /> 빈공간으로 놔두시면 됩니다.</td>
			</tr> --><tr>
				<th>카테고리기능사용</th>
				<td>
					<label><input type="radio" name="isCategoryUse" value="T" class="vmiddle" style="" value="T" />카테고리 기능 사용</label>
					<label><input type="radio" name="isCategoryUse" value="F" class="vmiddle" style="" value="F" checked="checked"  />카테고리 기능 미사용</label>
				</td>
			</tr><tr>
				<th>코멘트(댓글)기능사용</th>
				<td>
					<label><input type="radio" name="isCommentUse" class="vmiddle" style="" value="T" />코멘트(댓글)를 사용합니다.</label>
					<label><input type="radio" name="isCommentUse" class="vmiddle" style="" value="F"  checked="checked" />코멘트(댓글)를 사용하지 않습니다.</label>
				</td>
			</tr>
		</table>
	</form>
	<div class="btn_area"><%=viewImgStJS(IMG_BTN&"/btn_rect_confirm.gif",99,45,"","margin-top:20px;","cp","onclick=""submitChk();""")%></div>
</div>
<!--#include virtual = "/admin/_inc/copyright.asp"-->
