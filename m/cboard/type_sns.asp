<%
	'SNS view
%>
<link rel="stylesheet" href="/m/css/type_video_popup.css?">

<div id="div_move1"></div>
<div id="img_board" class="video_popup">
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
					arrList_movieType			= arrList(10,i)
					arrList_movieURL			= arrList(11,i)
					arrList_strLink			= arrList(12,i)			'SNS link
					arrList_strHashtag			= arrList(13,i)			'SNS strHashtag

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

					NEW_LENGTH = 230
					Call imgInfoNew(imgPath,newimgWidth,newimgHeight,"",NEW_LENGTH)

					imgPaddingW = (NEW_LENGTH - newimgWidth)/2
					imgPaddingH = (NEW_LENGTH - newimgHeight)/2

						'가로가 긴 경우
						If newimgWidth > newimgHeight Then
							newimgWidth  = NEW_LENGTH * (newimgWidth/newimgHeight)
							newimgHeight = NEW_LENGTH
						End If

					liMarginTop = (170 - newimgHeight) / 2

					thumbImg = "<img src="""&imgPath&""" width="""&newimgWidth&""" height="""&newimgHeight&""" alt="""" style=""mar gin-top:"&liMarginTop&"px""/>"

					'NO IMAGE
					If arrList_strPic = "" Then
						thumbImg = "<img src=""/images/noimages.png"" width=""170"" hei ght=""75"" alt="""" style=""mar gin-top:30px""/>"
					End If

					isFirst = ""

					' If (i) Mod PCONF_LINECNT = 0 Or i = 0 Then
					' 	PRINT "<div class=""cleft width100"">"
					' Else
					' 	isFirst = " style=""margin-left:"&ImgsLeftMargin&"px"" "
					' End If
		%>
		<li class="thumb_imageArea" <%=isFirst%>>
			<%If DK_MEMBER_LEVEL < intLevelView Then%>
				<a href="<%=MOB_PATH&"/common/member_login.asp?backURL="&ThisPageURL%>"><div class="img"><%=thumbImg%></div>
			<%Else%>
				<a href="<%=arrList_strLink%>" target="_blank"><div class="img"><%=thumbImg%></div>
			<%End If%>
					<div class="txt">
						<p><%=backword_title(cutString(arrList_strSubject,15))%></p>
					</div>
				</a>
				<div class="txt">
					<p><%=backword_tag(cutString(arrList_strHashtag,38))%></p>
				</div>
			<%
				Select Case DK_MEMBER_TYPE
					Case "ADMIN","OPERATOR"	'관리자 수정페이지 이동
			%>
				<!-- <a class="edit" href="board_modify.asp?bname=<%=strBoardName%>&num=<%=arrList_intIDX%>"><%=LNG_BOARD_BTN_MODIFY%></a> -->
			<%Case Else%>
			<%End Select%>
		</li>
		<%
			Next
		%>

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
<%If False Then%>
<div id="contentG" class="porel">
	<%
		If IsArray(arrList) Then
	%>
	<div class="porel contentG_Area">
	<%
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
				arrList_movieType			= arrList(10,i)
				arrList_movieURL			= arrList(11,i)

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

				'classNames = "index_v_pic_2or3"		'1줄 2or 3(반응형)
				classNames = "index_v_pic_2"		'1줄 2
				'classNames = "index_v_pic_3"		'1줄 3

		%>
		<div class="gArea <%=classNames%>" id="gid<%=i+1%>" >
			<%'▣가로세로 비율고정 반응형 DIV 박스%>
			<a href="board_view.asp?bname=<%=strBoardName%>&num=<%=arrList_intIDX%>">
				<div class="img" style="padding-bottom:<%=BOX_RATIO_H%>%;" >
					<div class="tcenter" style="position:absolute; width:100%; height:100%;left:0;top:<%=TOP_RATIO%>%;">
						<!-- <a href="board_view.asp?bname=<%=strBoardName%>&num=<%=arrList_intIDX%>"><%=goodsImg%></a> -->
						<%If DK_MEMBER_LEVEL < intLevelView Then%>
							<a href="<%=MOB_PATH&"/common/member_login.asp?backURL="&ThisPageURL%>"><div class="images"><%=goodsImg%></div></a>
						<%Else%>
							<a href="<%=arrList_movieURL%>"><div class="images"><%=goodsImg%></div></a>
						<%End If%>
					</div>
				</div>
			</a>
			<div class="textArea" >
				<div class="subject">
					<%
						Select Case DK_MEMBER_TYPE
							Case "ADMIN","OPERATOR"	'관리자 수정페이지 이동
					%>
						<a href="board_modify.asp?bname=<%=strBoardName%>&num=<%=arrList_intIDX%>"><%=backword_title(cutString(arrList_strSubject,15))%></a>
					<%Case Else%>
						<%=backword_title(cutString(arrList_strSubject,15))%>
					<%End Select%>
				</div>
				<!-- <div class="text">
					<table <%=tableatt%> class="width100 gTable">
						<col width="" />
						<col width="" />
						<%
							PRINT "<tr>"
							PRINT "		<td class=""fleft""><span>"&arrList_regDate&"&nbsp;"&comment_Cnt&"</span></td>"
							PRINT "		<td class=""th""></td>"
							PRINT "</tr>"
						%>
					</table>
				</div> -->
				<!-- <%If isVote = "T" Then%>
				<div class="heartArea">
					<span class="heart1 fright"><span class="heartTxt"><%=num2cur(arrList_TOTALVOTE)%> </span></span>
				</div>
				<%End If%> -->
			</div>
		</div>
		<%
			Next
		%>

	<%
		Else

	%>
	<div class="porel">
		<div class="tweight tcenter" style="background-color:#fff; padding:120px 0px;font-size:16px; line-height:25px;"><%=LNG_TEXT_NO_REGISTERED_POST%></div>
	<%

		End If
	%>

	</div>

	<div class="boardBtnArea">
		<%
			Select Case DK_MEMBER_TYPE
				Case "MEMBER","COMPANY","GUEST"
					If DK_MEMBER_LEVEL >= intLevelWrite Then
						PRINT TABS(3)& "	<input type=""button"" class=""txtBtn small2 pd7"" value="""&LNG_BOARD_BTN_WRITE&""" onclick=""location.href='board_write.asp?bname="&strBoardName&"'"" />"
					End If
				Case "ADMIN","OPERATOR"
					PRINT TABS(3)& "	<input type=""button"" class=""txtBtn small2 pd7"" value="""&LNG_BOARD_BTN_WRITE&""" onclick=""location.href='board_write.asp?bname="&strBoardName&"'"" />"
			End Select
		%>
	</div>

	<!-- <div class="pagingArea pagingMob5 fleft" style="background:#fff;margin-top:20px;"><%Call pageListMob5(PAGE,PAGECOUNT)%></div> -->
	<!-- <div class="pagingArea pagingMobNewArea fleft"><%Call pagingMobNew(PAGE,PAGECOUNT)%></div> -->
	<div class="tcenter"><%Call pagingMobNewMOVE(PAGE,PAGECOUNT)%></div>

</div>
<%End If%>
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