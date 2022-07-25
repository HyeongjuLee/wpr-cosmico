<%
	'gallery, movie

	PCONF_LINECNT = 4

	' 총 WIDTH 값에서 썸네일 갯수에 맞춰 LEFT-MARGIN 값 설정
	' 이미지 넓이는 border 를 포함하여 2를 더해준다
	ImgsLeftMargin = Int((1050 - (252*PCONF_LINECNT)) / (PCONF_LINECNT-1))
	'print ImgsLeftMargin
%>
<link rel="stylesheet" href="/css/board-gallery.css?">
<div id="img_board" class="gallery" >
	<ul>
		<%
			If IsArray(arrList) Then
				For i = 0 To listLen
					arrList_intIDX				= arrList(1,i)
					arrList_strUserID			= arrList(2,i)
					arrList_strName				= arrList(3,i)
					arrList_regDate				= arrList(4,i)
					arrList_readCnt				= arrList(5,i)
					arrList_strSubject			= arrList(6,i)
					arrList_strPic				= arrList(7,i)
					arrList_TOTALSCORE			= arrList(8,i)
					arrList_TOTALVOTE			= arrList(9,i)

					arrList_regDate = Replace(Left(arrList_regDate,10),"-",".")


					If NB_isViewNameType = "N" Then viewName = arrList_strName Else viewName = arrList_strUserID End If
					If UCase(DK_MEMBER_ID) = UCase(arrList_strUserID) Or DK_MEMBER_TYPE = "ADMIN" Then
						viewName = "<span class=""itme"">"&viewName&"</span>"
					Else
						If NB_isViewNameChg = "T" Then viewName = FNC_ID_CHANGE_STAR(viewName,NB_intViewNameCnt)
					End If

					If isCommentUse = "T" Then
						comment_Cnt = arrList_TOTALSCORE
						If comment_Cnt = 0 Or IsNull(comment_Cnt) Then
							comment_Cnt = ""
						Else
							comment_Cnt = "<span class=""cnt"">(<strong >"&comment_Cnt&"</strong>)</span>"
						End If
					Else
						comment_Cnt =""
					End If

					imgPath = VIR_PATH("board/thum")&"/"&backword(arrList_strPic)

					newimgWidth = 0
					newimgHeight = 0

					NEW_LENGTH = 150
					Call imgInfoNew(imgPath,newimgWidth,newimgHeight,"",NEW_LENGTH)

					imgPaddingW = (NEW_LENGTH - newimgWidth)/2
					imgPaddingH = (NEW_LENGTH - newimgHeight)/2

						'가로가 긴 경우
						If newimgWidth > newimgHeight Then
							newimgWidth  = NEW_LENGTH * (newimgWidth/newimgHeight)
							newimgHeight = NEW_LENGTH
						End If

					liMarginTop = (325 - newimgHeight) / 2

					thumbImg = "<img src="""&imgPath&""" width="""&newimgWidth&""" height="""&newimgHeight&""" alt="""" style=""margin-top:"&liMarginTop&"px""/>"

					'NO IMAGE
					If arrList_strPic = "" Then
						thumbImg = "<img src=""/images/noimages.png"" width=""170"" hei ght=""75"" alt=""""/>"
					End If

					isFirst = ""

					' If (i) Mod PCONF_LINECNT = 0 Or i = 0 Then
					' 	PRINT "<div class=""cleft width100"">"
					' Else
					' 	isFirst = " style=""margin-left:"&ImgsLeftMargin&"px"" "
					' End If
		%>
		<li class="thumb_imageArea" <%=isFirst%>>
			<a href="board_view.asp?bname=<%=strBoardName%>&num=<%=arrList_intIDX%>"><div class="img"><%=thumbImg%></div>
				<div class="txt">
					<p><%=backword_title(cutString(arrList_strSubject,15))%><!-- &nbsp;<%=comment_Cnt%> -->
						<%If isVote = "T" Then%>
							<span class="heart1 fright"><span class="heartTxt"><%=num2cur(arrList_TOTALVOTE)%></span></span>
						<%End If%>
					</p>
					<div class="info">
						<span class="views"><%=LNG_TEXT_COUNT_NUMBER%> <i></i> <%=arrList_readCnt%></span>
						<span class="date"><%=arrList_regDate%></span>
					</div>
				</div>
			</a>
		</li>
		<%
					If (i + 1) Mod PCONF_LINECNT = 0 Or i = listLen Then
		%>
		<%			End If

				Next
			Else
		%>
		<div class="cleft width100" style="text-align:center; padding:50px 0px;"><%=LNG_TEXT_NO_REGISTERED_POST%></div>

		<%
			End If
		%>
	</ul>
</div>

<div class="gallery_wrap fleft" style="margin:70px 0px;">
	<table <%=tableatt%> id="board1" class="gallery userCWidth2" style="width: 1200px;">
	<colgroup>
		<col width="60%" />
		<col width="40%" />
	</colgroup>
		<tfoot>
			<tr>
				<td colspan="2" height="30">
					<div class="pageList"><%Call pageList(PAGE,PAGECOUNT)%></div>
				</td>
			</tr>
			<tr>
				<td colspan="2" height="30" class="tright">
				<%
					Select Case DK_MEMBER_TYPE
						Case "MEMBER","GUEST","COMPANY"
							If DK_MEMBER_LEVEL >= intLevelWrite Then
								PRINT TABS(3)& "	<input type=""button"" class=""button write"" value=""작성하기"" onclick=""location.href='board_write.asp?bname="&strBoardName&"'"" />"
							End If
						Case "ADMIN","OPERATOR"
							PRINT TABS(3)& "	<input type=""button"" class=""button write"" value=""작성하기"" onclick=""location.href='board_write.asp?bname="&strBoardName&"'"" />"

					End Select
							PRINT TABS(3)& "	<input type=""button"" class=""button basic"" value=""목록보기"" onclick=""location.href='board_list.asp?bname="&strBoardName&"'"" />"
				%>
				</td>
			</tr>
		</tfoot>
	</table>
</div>

<form name="frm" method="post" action="">
	<input type="hidden" name="PAGE" value="<%=PAGE%>" />
	<input type="hidden" name="SEARCHTERM" value="<%=SEARCHTERM%>" />
	<input type="hidden" name="SEARCHSTR" value="<%=SEARCHSTR%>" />
</form>