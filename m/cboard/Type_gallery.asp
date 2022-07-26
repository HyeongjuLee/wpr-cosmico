<link rel="stylesheet" href="/m/css/board-gallery.css?">
<div id="div_move1"></div>
<div id="img_board" class="gallery">
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

					If isCommentUse = "T" Then
						comment_Cnt = arrList_TOTALSCORE
						If comment_Cnt = 0 Or IsNull(comment_Cnt) Then
							comment_Cnt = ""
						Else
							comment_Cnt = "<span class=""cnt"">(<strong>"&comment_Cnt&"</strong>)</span>"
						End If
					Else
						comment_Cnt =""
					End If

					new_icon = ""
				'	If CDate(Date) = CDate(Replace(arrList_regDate,".","-")) Then
				'		new_icon = viewImgSt("./images/icon_new.gif",11,11,"","","vmiddle")
				'	End If

					imgPath = VIR_PATH("board/thum")&"/"&backword(arrList_strPic)

					imgWidth = 0
					imgHeight = 0
					Call ImgInfo(imgPath,imgWidth,imgHeight,"")

					'▣가로세로 비율고정 반응형 DIV 박스
					BOX_RATIO_H = 100		'이미지 Div박스 가로세로 높이비율 (100 : BOX_RATIO_H) 	padding-bottom:(70~100)
					IMG_RATIO   = 85		'박스내 이미지 비율

					'Response.end
					If imgPath <> "" And imgHeight > 0 And imgWidth > 0 Then
						If imgHeight > imgWidth Then

							IMG_RATIO_W = IMG_RATIO * (imgWidth / imgHeight)
							imgWidth	= IMG_RATIO_W
							TOP_RATIO	= (100 - (IMG_RATIO   / (BOX_RATIO_H / 100))) / 2

						ElseIf imgHeight < imgWidth Then

							IMG_RATIO_W = IMG_RATIO * (imgHeight / imgWidth)
							imgWidth	= IMG_RATIO
							TOP_RATIO	= (100 - (IMG_RATIO_W / (BOX_RATIO_H / 100))) / 2

						ElseIf imgHeight = imgWidth Then

							IMG_RATIO_W = IMG_RATIO * (imgHeight / imgWidth)
							imgWidth	= IMG_RATIO
							TOP_RATIO	= (100 - (IMG_RATIO_W / (BOX_RATIO_H / 100))) / 2
						End if
					End If

					goodsImg = "<img src="""&imgPath&""" width="""&imgWidth&"%"" alt="""" />"

					new_icon = ""
					If CDate(Date)-newIconDate =< CDate(Replace(arrList_regDate,".","-")) Then
						new_icon = viewImgOpt("./images/icon_new.gif",11,11,"","class=""vmiddle""")
					End If

				'	If (i + 1) Mod 3 = 0 Then
				'		classNames = "index_v_pic2"
				'	Else
				'		classNames = "index_v_pic"
				'	End If


				'	classNames = "index_v_pic_2or3"		'1줄 2or 3(반응형)
				'	classNames = "index_v_pic_2"		'1줄 2
					'classNames = "index_v_pic_3"		'1줄 3

			%>
			<li class="thumb_imageArea" <%=isFirst%>>
				<a href="board_view.asp?bname=<%=strBoardName%>&num=<%=arrList_intIDX%>"><div class="img"><%=goodsImg%></div>
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
			Next
		%>
	</ul>

	<%
		Else

	%>
	<div class="porel">
		<div class="tweight tcenter" style="background-color:#fff; padding:120px 0px;font-size:16px; line-height:25px;"><%=LNG_TEXT_NO_REGISTERED_POST%></div>
	<%

		End If
	%>

	</div>

	<!-- <div class="pagingArea pagingMob5 fleft" style="background:#fff;margin-top:20px;"><%Call pageListMob5(PAGE,PAGECOUNT)%></div> -->
	<!-- <div class="pagingArea pagingMobNewArea fleft"><%Call pagingMobNew(PAGE,PAGECOUNT)%></div> -->
	<div class="tcenter"><%Call pagingMobNewMOVE(PAGE,PAGECOUNT)%></div>

	<div class="boardBtnArea">
		<%
			Select Case DK_MEMBER_TYPE
				Case "MEMBER","COMPANY","GUEST"
					If DK_MEMBER_LEVEL >= intLevelWrite Then
						PRINT TABS(3)& "	<input type=""button"" class=""button write"" value="""&LNG_BOARD_BTN_WRITE&""" onclick=""location.href='board_write.asp?bname="&strBoardName&"'"" />"
					End If
				Case "ADMIN","OPERATOR"
					PRINT TABS(3)& "	<input type=""button"" class=""button write"" value="""&LNG_BOARD_BTN_WRITE&""" onclick=""location.href='board_write.asp?bname="&strBoardName&"'"" />"
			End Select
		%>
	</div>
</div>
<script>
	//pagingMobNewMOVE
	$(document).ready(function(){
		//게시판 페이지 이동시 높이 조정
		if(	$("input[name=pagingCLICK]").val() == 'T') {
			fnMove(1);
		}
	});

	//게시판 페이지 이동시 높이 조정
    function fnMove(seq){
        var offset = $("#div_move" + seq).offset();
        $('html, body').animate({scrollTop : offset.top - 110}, 100);
    }
</script>
<form name="frm" method="post" action="">
	<input type="hidden" name="PAGE" value="<%=PAGE%>" />
	<input type="hidden" name="SEARCHTERM" value="<%=SEARCHTERM%>" />
	<input type="hidden" name="SEARCHSTR" value="<%=SEARCHSTR%>" />
	<input type="hidden" name="pagingCLICK" value="<%=pagingCLICK%>" />
</form>