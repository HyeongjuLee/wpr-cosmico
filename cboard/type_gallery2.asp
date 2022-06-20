<%
	'gallery2, movie2
%>
<div class="gallery_wrap">
	<div class="top_line"></div>
	<table <%=tableatt%> id="gallery2_list" class="gallery width100 ">
		<col width="180" />
		<col width="*" />
		<col width="120" />
		<col width="150" />
		<!-- <tr>
			<td class="titles tcenter tweight" colspan="2" ><%=TITLE_TXT1%></td>
			<td class="titles tcenter tweight"><%=TITLE_TXT2%></td>
		</tr> -->
	<%
		If Not IsArray(arrList) Then
	%>
			<tr>
				<td class="notData width100" colspan="4" ><%=LNG_TEXT_NO_REGISTERED_POST%></td>
			</tr>
	<%
		Else
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
				arrList_strPic1				= arrList(10,i)
				arrList_strContent			= arrList(11,i)

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

				new_icon = ""
				'If CDate(Date) = CDate(Replace(arrList_regDate,".","-")) Then
				'	new_icon = viewImgSt("./images/icon_new.gif",11,11,"","","vmiddle")
				'End If

				'imgPath = VIR_PATH("board/thum")&"/"&backword(arrList_strPic)
				imgPath = VIR_PATH("board/pic1")&"/"&backword(arrList_strPic1)
				'imgWidth = 0
				'imgHeight = 0
				'Call imgInfo(imgPath,imgWidth,imgHeight,"")

				Call imgInfoNew(imgPath,newimgWidth,newimgHeight,"",NEW_LENGTH)

				'thumbImg = aImgOPT("board_view.asp?bname="&strBoardName&"&amp;num="&arrList_intIDX,"S",imgPath,newimgWidth,newimgHeight,"","style=""margin:"&imgPaddingH&"px "&imgPaddingW&"px;""")

				'NO IMAGE
				If arrList_strPic1 <> "" Then
					'thumbImg = aImgOPT("board_view.asp?bname="&strBoardName&"&amp;num="&arrList_intIDX,"S","/images/noimages.png",130,75,"","style=""margin:"&imgPaddingH&"px "&imgPaddingW&"px;""")
					imgPath = VIR_PATH("board/pic1")&"/"&backword(arrList_strPic1)
				Else
					imgPath = O_IMG&"/notImg/notImg170x250.png"
				End If

	%>
		<tbody class="hovers">
			<tr>
				<td class="imgages tcenter" rowspan="3"><a href="board_view.asp?bname=<%=strBoardName%>&num=<%=arrList_intIDX%>"><img src="<%=imgPath%>" class="maxWH" alt="" /></a></td>
				<td class="subject tweight" colspan="2" ><a href="board_view.asp?bname=<%=strBoardName%>&num=<%=arrList_intIDX%>"><%=BACKWORD(arrList_strSubject)%>&nbsp;</a></td>
				<td class="subject tright">
					<%If isVote = "T" Then%>
						<span class="heart1 fright"><span class="heartTxt"><%=num2cur(arrList_TOTALVOTE)%></span></span>
					<%End If%>
				</td>			</tr><tr>
				<td colspan="3" class="content" style="padding-bottom:8px;"><a href="board_view.asp?bname=<%=strBoardName%>&amp;num=<%=arrList_intIDX%>" ><%=cutString2(stripHTMLtag(arrList_strContent),500)%></a></td>
			</tr><tr>
				<td class="info "><%=LNG_TEXT_WRITER%> : <%=viewName%></td>
				<td class="info tright"><%=LNG_TEXT_COUNT_NUMBER%> : <%=arrList(5,i)%> </td>
				<td class="info tright"><%=LNG_TEXT_WRITE_DATE%> : <%=arrList_regDate%> </td>
			</tr>
		</tbody>
	<%
			Next
		End If
	%>
		<tfoot>
			<tr>
				<td colspan="2" height="30" class="tleft pagingNew3"><%Call pageListNew(PAGE,PAGECOUNT)%></td>
				<td colspan="2" height="30" class="tright">
				<%
					Select Case DK_MEMBER_TYPE
						Case "MEMBER","GUEST","COMPANY"
							If DK_MEMBER_LEVEL >= intLevelWrite Then
								WriteTF = FN_CHECK_BOARD_WRITE_COUNT(strBoardName,DK_MEMBER_ID,NB_intWriteLimit,"TF")
								'PRINT WriteTF
								If WriteTF = "T" Then
									PRINT TABS(3)& "	<a href=""board_write.asp?bname="&strBoardName&""" class=""a_submit design1"">"&LNG_BOARD_BTN_WRITE&"</a>"
								Else
									PRINT TABS(3)& "	<a href=""javascript:alert('해당 게시판의 일일 글쓰기 횟수를 초과했습니다.\n익일 글쓰기를 시도해주세요.');"" class=""a_submit design1"">"&LNG_BOARD_BTN_WRITE&"</a>"
								End If
							End If
						Case "ADMIN","OPERATOR"
							PRINT TABS(3)& "	<a href=""board_write.asp?bname="&strBoardName&""" class=""a_submit design1"">"&LNG_BOARD_BTN_WRITE&"</a>"
					End Select
							PRINT TABS(3)& "	<a href=""board_list.asp?bname="&strBoardName&""" class=""a_submit design3"">"&LNG_BOARD_BTN_LIST&"</a>"
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