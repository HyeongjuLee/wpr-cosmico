<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<!--#include virtual = "/admin/_inc/document.asp"-->
<%
	ADMIN_LEFT_MODE = "WEBPRO"
	INFO_MODE = "WEBPRO1-1"


	strBoardName = gRequestTF("bname",True)



	arrParams = Array(_
		Db.makeParam("@strBoardName",adVarChar,adParamInput,50,strBoardName) _
	)

	Set DKRS = Db.execRs("[DKSP_FORUM_CONFIG_VIEW_ADMIN]",DB_PROC,arrParams,Nothing)

	If Not DKRS.BOF And Not DKRS.EOF Then
		isCategoryUse	= DKRS("isCategoryUse")
	Else
		Call ALERTS("설정값 로딩중 문제가 발생하였습니다. 새로고침 후 다시 시도해주세요.","back","")
	End If
	If isCategoryUse = "F" Then Call ALERTS("카테고리가 미사용상태입니다. 설정값을 바꿔주세요.","go","forumConfig.asp?bname="&strBoardName)




	arrParams = Array(_
		Db.makeParam("@strBoardName",adVarChar,adParamInput,50,strBoardName) _
	)

	arrList = Db.execRsList("DKPA_FORUM_CATEGORY_VIEW",DB_PROC,arrParams,listLen,Nothing)







%>
<script type="text/javascript" src="/jscript/jquery-1.3.2.min.js"></script>
<script type="text/javascript" src="/jscript/jquery_cate.js"></script>
<script type="text/javascript" src="/admin/jscript/community_forum.js"></script>
<link rel="stylesheet" href="/admin/css/community_forum.css" />
</head>
<body>
<!--#include virtual = "/admin/_inc/header.asp"-->

<div class="insert">
	<ul class="tabs">
		<li><a href="forumConfig.asp?bname=<%=strBoardName%>">게시판 기본설정</a></li>
		<li><a href="forumLevelConfig.asp?bname=<%=strBoardName%>">게시판 권한설정</a></li>
		<li><a href="forumWriteConfig.asp?bname=<%=strBoardName%>">게시판 쓰기설정</a></li>
		<li><a href="forumViewConfig.asp?bname=<%=strBoardName%>">게시판 보기설정</a></li>
		<li class="on"><a href="forumCategoryConfig.asp?bname=<%=strBoardName%>">게시판 카테고리설정</a></li>
		<li><a href="forumPointConfig.asp?bname=<%=strBoardName%>">게시판 포인트설정</a></li>
	</ul>
	<form name="cfrm" action="forumHandler.asp" method="post" enctype="multipart/form-data"  onsubmit="return chkConfigFrm(this)">
		<input type="hidden" name="mode" value="CATEGORYINSERT" />
		<input type="hidden" name="strBoardName" value="<%=strBoardName%>" />
		<div class="titles"><%=viewImgSt(IMG_ICON&"/icon_arrow1.gif",16,16,"","","vtop")%> 게시판 카테고리 추가</div>
		<table <%=tableatt%> class="adminFullTable">
			<colgroup>
				<col width="150" />
				<col width="*" />
			</colgroup>
			<tr>
				<th>사용</th>
				<td><label><input type="checkbox" name="isUseTF" value="T" class="vmiddle" />등록 후 바로 사용</label></td>
			</tr><tr>
				<th>카테고리명</th>
				<td><input type="text" name="CateName" class="input_text" style="width:200px;" /> <input type="image" src="<%=IMG_BTN%>/btn_submit_gray.gif" class="vmiddle" /></td>
			</tr>
		</table>
	</form>

	<div class="titles"><%=viewImgSt(IMG_ICON&"/icon_arrow1.gif",16,16,"","","vtop")%> 게시판 카테고리 설정</div>
	<table <%=tableatt%> class="adminFullTable cates">
		<colgroup>
			<col width="80" />
			<col width="100" />
			<col width="*" />
			<col width="*" />
			<col width="*" />
			<col width="*" />
		</colgroup>
		<tr>
			<th>순서</th>
			<th>순서변경</th>
			<th>카테고리명</th>
			<th>사용여부</th>
			<th>수정</th>
			<th>삭제</th>
		</tr>
		<%
			If IsArray(arrList) Then
				For i = 0 To listLen
					PRINT "	<tr>"
					PRINT "		<td>"&arrList(2,i)&"</td>"
					PRINT "		<td>현재 미지원</td>"
					PRINT "		<td class='tleft'><input type='text' name='cateName' value='"&arrList(0,i)&"' class='input_text' style='width:200px;' /></td>"
					PRINT "		<td><label><input type='checkbox' name='isUseTF' value='T' class='vmiddle' "&isChecked("T",arrList(1,i))&" />사용</label></td>"
					PRINT "		<td>"&viewImg(IMG_BTN&"/btn_gray_update.gif",45,22,"")&"</td>"
					PRINT "		<td>"&viewImg(IMG_BTN&"/btn_gray_delete.gif",45,22,"")&"</td>"
					PRINT "	</tr>"
				Next

			Else
				PRINT "<tr><td colspan=""5"" align=""120"" height=""90"">설정된 카테고리가 없습니다.</td>"
			End If
		%>
	</table>
</div>
<!--#include virtual = "/admin/_inc/copyright.asp"-->
