<div id="div_move1"></div>
	<div id="board" class="board list">
		<table <%=tableatt%> id="board1">
			<%
				If NB_isTopNotice = "T" Then
					arrParamsM = Array(_
						Db.makeParam("@TOP",adInteger,adParamInput,20,NB_intTopNotice) ,_
						Db.makeParam("@strDomain",adVarChar,adParamInput,50,LANG) _
					)
					arrListM = Db.execRsList("DKP_NBOARD_MAIN_NOTICE_LIST",DB_PROC,arrParamsM,listLenM,Nothing)
					If IsArray(arrListM) Then
						For m = 0 To listLenM
							arrListM_intIDX			= arrListM(0,m)
							arrListM_intNum			= arrListM(1,m)
							arrListM_intList		= arrListM(2,m)
							arrListM_intDepth		= arrListM(3,m)
							arrListM_intRIDX		= arrListM(4,m)
							arrListM_strUserID		= arrListM(5,m)
							arrListM_strName		= arrListM(6,m)
							arrListM_regDate		= arrListM(7,m)
							arrListM_readCnt		= arrListM(8,m)
							arrListM_editDate		= arrListM(9,m)
							arrListM_strSubject		= arrListM(10,m)
			%>
						<tr class="notice">
							<td>
								<a href="board_view.asp?bname=<%=strBoardName%>&amp;ty=<%=LOCTYPE%>&amp;num=<%=arrListM_intIDX%><%=getCate%>">
								<div class="title">
									<span>[<%=LNG_BOARD_TYPE_BOARD_TEXT13%>]</span>
									<%=backword_title(arrListM_strSubject)%>&nbsp;<%=ico_data%><%=ico_secret%><%=new_icon%>&nbsp;<%=img_icons%><%=ico_hot%>
								</div>
								<p class="info">
									<span class="desc1"><%=arrListM_strName%></span><i></i>
									<span class="desc2"><%=LNG_BOARD_TYPE_BOARD_TEXT04%> : <%=Replace(Left(arrListM_regDate,10),"-",".")%></span><i></i>
									<span class="desc3"><%=LNG_BOARD_TYPE_BOARD_TEXT05%> : <%=arrListM_readCnt%></span>
								</p>
							</a>
							</td>
						</tr>
			<%
						Next
					End If
				End If
			%>


			<%
				If IsArray(arrList) Then
					For i = 0 To listLen
						arrList_intIDX			= arrList(1,i)
						arrList_intNum			= arrList(2,i)
						arrList_intList			= arrList(3,i)
						arrList_intDepth		= Int(arrList(4,i))
						arrList_intRIDX			= arrList(5,i)
						arrList_strUserID		= arrList(6,i)
						arrList_strName			= arrList(7,i)
						arrList_regDate			= arrList(8,i)
						arrList_readCnt			= arrList(9,i)
						arrList_editDate		= arrList(10,i)
						arrList_strSubject		= arrList(11,i)
						arrList_strContent		= arrList(12,i)
						arrList_strData1		= arrList(13,i)
						arrList_strData2		= arrList(14,i)
						arrList_strData3		= arrList(15,i)
						arrList_isSecret		= arrList(16,i)
						arrList_TOTALSCORE		= arrList(17,i)
						arrList_isIDImg			= arrList(18,i)
						arrList_imgPath			= arrList(19,i)
						arrList_ROWNUMBERS		= arrList(20,i)
						arrList_isMainNotice	= arrList(21,i)

'								list = cInt(arrList(3,i))
'								depthst = cInt(arrList(4,i))

						arrParams3 = Array(_
							Db.makeParam("@intList",adInteger,adParamInput,0,arrList_intList) _
						)
						arrList3 = Db.execRsList("DKP_NBOARD_REPLY_LIST",DB_PROC,arrParams3,listLen3,Nothing)

						If IsArray(arrList3) Then
							For k = 0 To listLen3
								arrList3_intIDX			= arrList3(1,k)
								arrList3_intNum			= Int(arrList3(2,k))
								arrList3_intList		= arrList3(3,k)
								arrList3_intDepth		= Int(arrList3(4,k))
								arrList3_intRIDX		= arrList3(5,k)
								arrList3_strUserID		= arrList3(6,k)
								arrList3_strName		= arrList3(7,k)
								arrList3_regDate		= arrList3(8,k)
								arrList3_readCnt		= arrList3(9,k)
								arrList3_editDate		= arrList3(10,k)
								arrList3_strSubject		= arrList3(11,k)
								arrList3_strContent		= arrList3(12,k)
								arrList3_strData1		= arrList3(13,k)
								arrList3_strData2		= arrList3(14,k)
								arrList3_strData3		= arrList3(15,k)
								arrList3_isSecret		= arrList3(16,k)
								arrList3_TOTALSCORE		= arrList3(17,k)
								arrList3_isIDImg		= arrList3(18,k)
								arrList3_imgPath		= arrList3(19,k)

								ATTRIBUTE = ""
								If DK_MEMBER_TYPE = "ADMIN" Then
									ATTRIBUTE = "class=""cp"" onclick=""viewMiniMemo('memMenu','"&arrList3_intIDX&"',event);"""
								End If


								arrList3_regDate = Replace(Left(arrList3_regDate,10),"-",".")

								DataCnt		= 0
								ico_data	= ""
								ico_secret	= ""

								If isCommentUse = "T" Then
									comment_Cnt = arrList3_TOTALSCORE
									If comment_Cnt = 0 Or IsNull(comment_Cnt) Then
										comment_Cnt = ""
									Else
										comment_Cnt = "<span class=""cnt"">(<strong>"&comment_Cnt&"</strong>)</span>"
									End If
								Else
									comment_Cnt =""
								End If

								If arrList3_strData1 = "" Or IsNull(arrList3_strData1) Then DataCnt1 = 0 : Else DataCnt1 = 1
								If arrList3_strData2 = "" Or IsNull(arrList3_strData2) Then DataCnt2 = 0 : Else DataCnt2 = 1
								If arrList3_strData3 = "" Or IsNull(arrList3_strData3) Then DataCnt3 = 0 : Else DataCnt3 = 1

								DataCnt = DataCnt1 + DataCnt2 + DataCnt3
								'PRINT arrList3_isSecret
								ico_hot = ""
								If hotIconCnt > 0 Then
									If CInt(arrList3_readCnt) >= CInt(hotIconCnt) Then ico_hot = "&nbsp;<img src=""./images/icon_hot.gif"" width=""24"" height=""13"" class=""vmiddle"" alt="""" /> "
								End If
								If DataCnt > 0 Then ico_data = "<img src=""./images/files.gif"" width=""10"" height=""10"" class=""vmiddle"" alt="""&LNG_BOARD_TYPE_BOARD_TEXT08&"."" /> "

								If arrList3_isSecret = "T" Then
									ico_secret = "<img src=""./images/lock.gif"" width=""21"" height=""13"" alt=""비밀글입니다."" style=""vertical-align:middle;"" />"
								End If
								numView = ""
								If arrList3_intNum <> 0 Then numView = arrList3_intNum

								'print CDate(date)
								'print Replace(arrList3_regDate,".","-")
								new_icon = ""
								If CDate(Date)-newIconDate =< CDate(Replace(arrList3_regDate,".","-")) Then
									new_icon = viewImgOpt("./images/icon_new.gif",11,11,"","class=""vmiddle""")
								End If

								'PRINT arrList3_intDepth

								If arrList3_intDepth > 0 Then
									idxs = ""
								Else
									idxs = ALL_COUNT - CInt(arrList(0,i)) + 1
									writeID = arrList3_strUserID
								End If

								If InStr(backword(LCase(arrList3_strContent)),"<img") > 0 Then
									img_icons = viewImgOpt("./images/icon_picT.gif",16,16,"","class=""vmiddle""")
								Else
									img_icons = ""
								End If
								'print writeID
			%>
				<tr>
					<td>
					<%
						 '■QnA 본인 작성글만 확인
						 If strBoardName = "qna" And UCase(DK_MEMBER_TYPE) <> "ADMIN" Then
							'원글 작성자 ID
							SQL_OR = "SELECT [strUserID] FROM [DK_NBOARD_CONTENT] WITH(NOLOCK) WHERE [intDepth] = 0 AND [intList] = ?"
							arrParams_OR = Array(_
								Db.makeParam("@intList",adInteger,adParamInput,4,arrList3_intList)_
							)
							ORI_WRITE_MEMBER_ID = Db.execRsData(SQL_OR,DB_TEXT,arrParams_OR,Nothing)

							If DK_MEMBER_TYPE = "GUEST" Then
								QNA_ALERT_TEXT = LNG_STRCHECK_TEXT02
							Else
								QNA_ALERT_TEXT = "본인이 작성한 글만 확인할 수 있습니다."
							End If
						%>
							<%IF ORI_WRITE_MEMBER_ID <> DK_MEMBER_ID Then%>
								<a onclick="alert('<%=QNA_ALERT_TEXT%>');">
									<div class="title"><%=ico_reply%>&nbsp;<%=backword_title(arrList3_strSubject)%>&nbsp;<%=ico_data%><%=ico_secret%><%=new_icon%></div>
							<%Else%>
								<a href="board_view.asp?bname=<%=strBoardName%>&amp;num=<%=arrList3_intIDX%><%=getCate%>">
									<div class="title"><%=ico_reply%>&nbsp;<%=backword_title(arrList3_strSubject)%>&nbsp;<%=comment_Cnt%>&nbsp;<%=ico_data%><%=ico_secret%><%=new_icon%>&nbsp;<%=img_icons%><%=ico_hot%></div>
							<%End If%>

						<%Else%>


							<!-- <%If arrList3_intDepth > 0 Then%><%For subtabs=1 To arrList3_intDepth%><%next%><img src="images/bbs_answer.gif" width="10" height="10" alt="답변아이콘" /><%End If%> -->
							<%
								ico_reply = ""
								If arrList3_intDepth > 0 Then
									For subtabs=1 To arrList3_intDepth
									next
									'ico_reply = "<img src=""images/bbs_answer.gif"" width=""10"" height=""10"" alt=""답변아이콘"" />"
									ico_reply = viewImgOpt("./images/bbs_answer.gif",10,10,"","class=""vmiddle"" alt=""답변아이콘""")
								End If
							%>
							<%
								If arrList3_isSecret = "T" Then
									Select Case DK_MEMBER_TYPE
										Case "GUEST"
											IF writeID = "GUEST" Then
							%>
								<a onclick="viewPass('passMenu','<%=arrList3_intIDX%>','<%=strBoardName%>',event);">
									<div class="title"><%=ico_reply%>&nbsp;<%=backword_title(arrList3_strSubject)%>&nbsp;<%=comment_Cnt%>&nbsp;<%=ico_data%><%=ico_secret%><%=new_icon%></div>

							<%	Else%>
								<a onclick="alert('<%=LNG_BOARD_TYPE_BOARD_TEXT09%>');">
									<div class="title"><%=ico_reply%>&nbsp;<%=backword_title(arrList3_strSubject)%>&nbsp;<%=ico_data%><%=ico_secret%><%=new_icon%>&nbsp;<%=img_icons%><%=ico_hot%></div>

							<%	End If
								Case "MEMBER","COMPANY"
									IF writeID <> DK_MEMBER_ID Then%>
								<a onclick="alert('\'<%=DK_MEMBER_ID%>\'<%=LNG_BOARD_TYPE_BOARD_TEXT10%>.');">
									<div class="title"><%=ico_reply%>&nbsp;<%=backword_title(arrList3_strSubject)%>&nbsp;<%=ico_data%><%=ico_secret%><%=new_icon%></div>
							<%	Else%>
								<a href="board_view.asp?bname=<%=strBoardName%>&amp;num=<%=arrList3_intIDX%><%=getCate%>">
									<div class="title"><%=ico_reply%>&nbsp;<%=backword_title(arrList3_strSubject)%>&nbsp;<%=comment_Cnt%>&nbsp;<%=ico_data%><%=ico_secret%><%=new_icon%>&nbsp;<%=img_icons%><%=ico_hot%></div>

							<%	End If
								Case "ADMIN","OPERATOR"
							%>
								<a href="board_view.asp?bname=<%=strBoardName%>&amp;num=<%=arrList3_intIDX%><%=getCate%>">
									<div class="title"><%=ico_reply%>&nbsp;<%=backword_title(arrList3_strSubject)%>&nbsp;<%=comment_Cnt%>&nbsp;<%=ico_data%><%=ico_secret%><%=new_icon%>&nbsp;<%=img_icons%><%=ico_hot%></div>
							<%	Case "SADMIN"
								If UCase(DK_MEMBER_GROUP) <> LOCATIONS Then
							%>
								<a onclick="alert('<%=LNG_BOARD_TYPE_BOARD_TEXT11%>');">
									<div class="title"><%=ico_reply%>&nbsp;<%=backword_title(arrList3_strSubject)%>&nbsp;<%=ico_data%><%=ico_secret%><%=new_icon%></div>
							<%	Else%>
								<a href="board_view.asp?bname=<%=strBoardName%>&amp;num=<%=arrList3_intIDX%><%=getCate%>">
									<div class="title"><%=ico_reply%>&nbsp;<%=backword_title(arrList3_strSubject)%>&nbsp;<%=comment_Cnt%>&nbsp;<%=ico_data%><%=ico_secret%><%=new_icon%>&nbsp;<%=img_icons%><%=ico_hot%></div>
							<%	End If
								End Select
								Else%>
							<a href="board_view.asp?bname=<%=strBoardName%>&amp;num=<%=arrList3_intIDX%><%=getCate%>">
								<div class="title"><%=ico_reply%>&nbsp;<%=backword_title(arrList3_strSubject)%>&nbsp;<%=comment_Cnt%>&nbsp;<%=ico_data%><%=ico_secret%><%=new_icon%>&nbsp;<%=img_icons%><%=ico_hot%></div>
							<%	End If%>

							<%End If%>
							<p class="info">
								<span class="desc1"><%=arrList3_strName%></span><i></i>
								<span class="desc2"><%=LNG_BOARD_TYPE_BOARD_TEXT04%> : <%=arrList3_regDate%></span><i></i>
								<span class="desc3"><%=LNG_BOARD_TYPE_BOARD_TEXT05%> : <%=arrList3_readCnt%></span>
							</p>
						</a>

						</td>
				</tr>
			<%

						Next
					End If

					Next
				Else
			%>
					<tr>
						<td class="nothing"><%=LNG_TEXT_NO_REGISTERED_POST%></td>
					</tr>
			<%
				End If
			%>
				<tfoot>
					<tr>
						<td colspan="1" class="tright">
						<%
							Select Case DK_MEMBER_TYPE
								Case "MEMBER","COMPANY","GUEST"
									If DK_MEMBER_LEVEL >= intLevelWrite Then
										PRINT TABS(3)& "	<input type=""button"" class=""button"" value="""&LNG_BOARD_BTN_WRITE&""" onclick=""location.href='board_write.asp?bname="&strBoardName&"'"" />"
									End If
								Case "ADMIN","OPERATOR"
									PRINT TABS(3)& "	<input type=""button"" class=""button admin"" value="""&LNG_BOARD_BTN_WRITE&""" onclick=""location.href='board_write.asp?bname="&strBoardName&"'"" />"
							End Select
						%>
						</td>
					</tr>
				</tfoot>
			</table>
	</div>

<!-- <div class="pagingArea pagingMob5"><% Call pageListMob5(PAGE,PAGECOUNT)%></div> -->
<div class="tcenter"><%Call pagingMobNewMOVE(PAGE,PAGECOUNT)%></div>


<div id="memMenu" class="memMenu"><%=viewImg("./images/loading65.gif",65,65,"")%></div>
<div id="passMenu" class="passMenu">
	<form name="vfrm" method="post" action="pass.asp" onsubmit="return ChkvFrm(this);">
		<%=LNG_BOARD_TYPE_BOARD_TEXT12%> : <input type="password" class="input_text_gr vmiddle" name="strPass" style="width:110px;" /> <input type="submit" class="txtBtn small2 pd7" value="<%=LNG_TEXT_CONFIRM%>" />
	</form>
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