<%
	'gallery, movie
%>
<%
	TOP3_VIEW_TF = ""
	Select Case strBoardName			'책과인생, 포럼자랑하기
		Case "books"
			TOP3_VIEW_TF = "T"
			TOP3_TITLE	 = "금주의 지식"
			BOTM_TITLE	 = "지식 서재"

		Case "proud"
			TOP3_VIEW_TF = "T"
			TOP3_TITLE	 = "신규포럼"
			BOTM_TITLE	 = "우리포럼최고"

	End Select
%>
<%If TOP3_VIEW_TF = "T" Then %>
	<div id="community" class="community01">
		<div class="title">
			<p><%=TOP3_TITLE%></p><i></i>
		</div>
	</div>
	<div id="" class="company">
		<div class="width100" style="">
			<table <%=tableatt%> class="gallery_list width100">
				<col width="130" />
				<col width="*" />
				<%
					arrParamsM = Array(_
						Db.makeParam("@TOP",adInteger,adParamInput,20,3) ,_
						Db.makeParam("@strBoardName",adVarChar,adParamInput,50,strBoardName), _
						Db.makeParam("@strDomain",adVarChar,adParamInput,50,LANG) _
					)
					arrListM = Db.execRsList("HJP_NBOARD_LIST_TOP",DB_PROC,arrParamsM,listLenM,Nothing)
					If IsArray(arrListM) Then
						For m = 0 To listLenM
							arrListM_intIDX				= arrListM(0,m)
							arrListM_strUserID			= arrListM(1,m)
							arrListM_strName			= arrListM(2,m)
							arrListM_regDate			= arrListM(3,m)
							arrListM_readCnt			= arrListM(4,m)
							arrListM_strSubject			= arrListM(5,m)
							arrListM_strPic				= arrListM(6,m)
							arrListM_TOTALSCORE			= arrListM(7,m)
							arrListM_TOTALVOTE			= arrListM(8,m)
							arrListM_strContent			= arrListM(9,m)

							arrListM_regDate = Replace(Left(arrListM_regDate,10),"-",".")

							If isCommentUse = "T" Then
								comment_Cnt = arrListM_TOTALSCORE
								If comment_Cnt = 0 Or IsNull(comment_Cnt) Then
									comment_Cnt = ""
								Else
									comment_Cnt = "<span class=""cnt"" style=""font-size:13px;"">(<strong>"&comment_Cnt&"</strong>)</span>"
								End If
							Else
								comment_Cnt =""
							End If

							new_icon = ""
						'	If CDate(Date) = CDate(Replace(arrListM_regDate,".","-")) Then
						'		new_icon = viewImgSt("./images/icon_new.gif",11,11,"","","vmiddle")
						'	End If
							imgPath = VIR_PATH("board/thum")&"/"&backword(arrListM_strPic)
							imgWidth = 0
							imgHeight = 0
							'Call imgInfo(imgPath,imgWidth,imgHeight,"")
							newimgWidth = 0
							newimgHeight = 0
							NEW_LENGTH = 110
							Call imgInfoNew(imgPath,newimgWidth,newimgHeight,"",NEW_LENGTH)

							thumbImg = aImgOPT("board_view.asp?bname="&strBoardName&"&amp;num="&arrListM_intIDX,"S",imgPath,newimgWidth,newimgHeight,"","style=""margin:"&imgPaddingH&"px "&imgPaddingW&"px;""")

							'이미지 제거
							arrListM_strContent	= stripHTMLtag(backword(LCase(arrListM_strContent)))

							PRINT "	 <tr>"
							PRINT "	 	<td class=""imgages tcenter"" rowspan=""3"">"&thumbImg&"</td>"
							PRINT "	 	<td class=""subject""><a href=""board_view.asp?bname="&strBoardName&"&amp;num="&arrListM_intIDX&""">"&backword_title(cutString(arrListM_strSubject,20))&"&nbsp;"&comment_Cnt&"</a></td>"
							PRINT "	 </tr>"
							PRINT "	 <tr>"
							PRINT "	 	<td class=""content"">"&cutString(arrListM_strContent,30)&"</td>"
							PRINT "	 </tr>"
							PRINT "	 <tr>"
							If strBoardName = "books" Then  '책과인생
								PRINT "	<td><a href=""board_view.asp?bname="&strBoardName&"&amp;num="&arrListM_intIDX&"""><div class=""movie_more"">영상보기<i></i></div></a></td>"
							Else
								PRINT "	<td><div class=""movie_more""></div></td>"
							End If
							PRINT "	 </tr>"
							PRINT "	 <tr>"
							PRINT "	 	<td colspan=""2""  style=""background:#ebebeb;height:9px;""></td>"
							PRINT "	 </tr>"
						Next
					Else
							PRINT "	<tbody>"
							PRINT "		<tr>"
							PRINT "			<td class=""imgages tcenter"" style=""height:100px;"">"&LNG_TEXT_NO_REGISTERED_POST&"</td>"
							PRINT "		</tr>"
							PRINT "	</tbody>"
					End If
				%>
			</table>
		</div>
	</div>
<%End If%>



<div id="div_move1"></div>
<%If TOP3_VIEW_TF = "T" Then %>
<div id="community" class="community01">
	<div class="title">
		<p><%=BOTM_TITLE%></p><i></i>
	</div>
</div>
<%End If%>
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
				classNames = "index_v_pic_3"		'1줄 3

		%>
		<div class="gArea <%=classNames%>" id="gid<%=i+1%>" >
			<%'▣가로세로 비율고정 반응형 DIV 박스%>
			<a href="board_view.asp?bname=<%=strBoardName%>&num=<%=arrList_intIDX%>">
				<div class="img" style="padding-bottom:<%=BOX_RATIO_H%>%;" >
					<div class="tcenter" style="position:absolute; width:100%; height:100%;left:0;top:<%=TOP_RATIO%>%;">
						<a href="board_view.asp?bname=<%=strBoardName%>&num=<%=arrList_intIDX%>"><%=goodsImg%></a>
					</div>
				</div>
			</a>
			<div class="textArea" >
				<div class="subject"><%=arrList_strSubject%><!-- &nbsp;<%=comment_Cnt%>&nbsp;<%=ico_data%><%=ico_secret%></a><%=new_icon%> --></div>
				<div class="text">
					<table <%=tableatt%> class="width100 gTable">
						<col width="" />
						<col width="" />
						<%
						'	PRINT "<tr>"
						'	PRINT "		<td class=""fleft""><span>"&LNG_TEXT_COUNT_NUMBER&" : "&arrList_readCnt&"</span></td>"
						'	PRINT "		<td class=""th""></td>"
						'	PRINT "</tr>"
							PRINT "<tr>"
							PRINT "		<td class=""fleft""><span>"&arrList_regDate&"&nbsp;"&comment_Cnt&"</span></td>"
							PRINT "		<td class=""th""></td>"
							PRINT "</tr>"
							If strBoardName = "books" Then  '책과인생
								PRINT "<tr>"
								PRINT "	 	<td colspan=""1"" class=""""><a href=""board_view.asp?bname="&strBoardName&"&amp;num="&arrListM_intIDX&"""><div class=""movie_more"">영상보기<i></i></div></a></td>"
								PRINT "</tr>"
							End If
						%>
					</table>
				</div>
				<%If isVote = "T" Then%>
				<div class="heartArea">
					<span class="heart1 fright"><span class="heartTxt"><%=num2cur(arrList_TOTALVOTE)%> </span></span>
				</div>
				<%End If%>
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