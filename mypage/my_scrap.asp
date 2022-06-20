<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	PAGE_SETTING = "MYPAGE"
	ISLEFT = "T"
	ISSUBTOP = "T"
	ISSUBVISUAL = "T"
	view = 2


	Call ONLY_MEMBER_CONFIRM(DK_MEMBER_LEVEL)
%>

<!--#include virtual = "/_include/document.asp"-->
<link rel="stylesheet" href="/css/mypage.css" />
<script type="text/javascript" src="/jscript/mypage.js"></script>
</head>
<body>
<!--#include virtual = "/_include/header.asp"-->
<!--#include virtual = "/_include/sub_title.asp"-->

<div class="my_scrap">
	<p><%=viewImg(IMG_MYPAGE&"/mypage_top.jpg",790,130,"")%></p>
	<p><%=viewImg(IMG_MYPAGE&"/tit_my_scrap.gif",790,35,"")%></p>
	<table <%=tableatt%> class="userFullWidth defaultTable1">
		<colgroup>
			<col width="50" />
			<col width="100" />
			<col width="*" />
			<col width="90" />
			<col width="90" />
		</colgroup>
		<thead>
			<tr>
				<th>번호</th>
				<th>게시판이름</th>
				<th>제목</th>
				<th>스크랩일자</th>
				<th>삭제</th>
			</tr>
		</thead>
		<tbody>
		<%
			Dim SEARCHTERM, SEARCHSTR, PAGE, PAGESIZE
			SEARCHTERM = Request("searchterm")
			SEARCHSTR = Request("searchstr")
			PAGE = Request("page")
			PAGESIZE =10

			If SEARCHTERM = "" Then SEARCHTERM = "" End If
			If SEARCHSTR = "" Then SEARCHSTR = "" End if
			If PAGE="" Then PAGE = 1 End If

			arrParams = Array(_
				Db.makeParam("@strUserID",adVarChar,adParamInput,20,DK_MEMBER_ID), _
				Db.makeParam("@SEARCHTERM",adVarChar,adParamInput,30,SEARCHTERM), _
				Db.makeParam("@SEARCHSTR",adVarChar,adParamInput,30,convSql(SEARCHSTR)), _
				Db.makeParam("@PAGESIZE",adInteger,adParamInput,0,PAGESIZE), _
				Db.makeParam("@PAGE",adInteger,adParamInput,0,PAGE), _
				Db.makeParam("@All_Count",adInteger,adParamOutPut,0,0) _
			)
			arrList = Db.execRsList("DKP_MYPAGE_SCRAP_LIST",DB_PROC,arrParams,listLen,Nothing)
		All_Count = arrParams(UBound(arrParams))(4)

		Dim PAGECOUNT,CNT
		PAGECOUNT = int((ccur(All_Count) - 1 ) / CInt(PAGESIZE) ) + 1
		IF CCur(PAGE) = 1 Then
			CNT = All_Count
		Else
			CNT = All_Count - ((CCur(PAGE)-1)*CInt(PAGESIZE)) '
		End If
			If IsArray(arrList) Then
				For i = 0 To listLen
					PRINT "		<tr>"
					PRINT "			<td>"&arrList(7,i)&"</td>"
					PRINT "			<td>"&arrList(3,i)&"</td>"
					PRINT "			<td class=""scrap_subject"">"
					PRINT "				<p><a href=""/cboard/board_view.asp?bname="&arrList(2,i)&"&amp;num="&arrList(1,i)&""">"&arrList(4,i)&"</a></p>"
					PRINT "				<p class=""p2"">메모 : "&arrList(5,i)&"</p>"
					PRINT "			</td>"
					PRINT "			<td>"&Left(arrList(6,i),10)&"</td>"
					PRINT "			<td><a href=""javascript:scrapDel('"&arrList(7,i)&"')""><img src="""&IMG_MYPAGE&"/btn_gray_delete.gif"" width=""45"" height=""22"" alt="""" /></a></td>"
					PRINT "		</tr>"
				Next
			Else
				PRINT "		<tr>"
				PRINT "			<td colspan=""6"" class=""notdata"">스크랩 하신 게시물이 없습니다.</td>"
				PRINT "		</tr>"
			End If

		%>
		</tbody>
	</table>
	<div id="bbs_search">
		<table <%=tableatt%>>
			<tr>
				<td height="50" align="center"><% Call pageList(PAGE,PAGECOUNT)%></td>
			</tr><tr>
				<td>
					<form action="" method="post" name="search">
						<input type="hidden" name="searchterm" value="strSubject" />
						<table <%=tableatt%> class='searchbar'>
							<tr>
								<td class="searchbars1"></td>
								<td class="searchbars2"><img src="<%=IMG_MYPAGE%>/search_img.gif" width="70" height="44" alt="검색이미지" /></td>
								<td class="searchbars4"><input type="text" class="searchstr" name="SEARCHSTR" value="<%=convSql(SEARCHSTR)%>" /></td>
								<td class="searchbars5"><input type="image" src="<%=IMG_MYPAGE%>/btn_bbs01.gif" /></td>
								<td class="searchbars6">
									<a href="board_list.asp?bname=<%=strBoardName%>"><img src="<%=IMG_MYPAGE%>/btn_bbs02.gif" width="59" height="21" alt="목록가기" align="middle" /></a>
								</td>
								<td class="searchbars7"></td>
							</tr>
						</table>
					</form>
					<form name="frm" method="post" action="">
						<input type="hidden" name="PAGE" value="<%=PAGE%>" />
						<input type="hidden" name="SEARCHTERM" value="<%=SEARCHTERM%>" />
						<input type="hidden" name="SEARCHSTR" value="<%=convSql(SEARCHSTR)%>" />
					</form>
				</td>
			</tr>
		</table>
	</div>
	<form name="scrapFrm" method="post" action="scrapHandler.asp">
		<input type="hidden" name="mode" value="DELETE" />
		<input type="hidden" name="intIDX" value="" />
	</form>
</div>
<!--#include virtual = "/_include/copyright.asp"-->
