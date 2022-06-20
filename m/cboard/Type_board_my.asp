<div id="div_move1"></div>
<div id="content" class="company">

	<div class="cleft pcontent">
		<div id="board">
			<div class="innerContent">
				<table <%=tableatt%> id="board1" style="width:100%;">
					<col width="*" />
					<col width="90" />
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
								arrList_strPic			= arrList(13,i)
								arrList_strBoardName	= arrList(14,i)

								'▣ board_view.asp?bname=  boardName치환!! ▣
								strBoardName  = arrList_strBoardName

								'▣board_config
								arrParams = Array(_
									Db.makeParam("@strBoardName",adVarChar,adParamInput,50,strBoardName)_
								)
								Set DKRS = Db.execRs("DKP_NBOARD_CONFIG",DB_PROC,arrParams,Nothing)

								If Not DKRS.BOF And Not DKRS.EOF Then
									PAGE_SETTING		= DKRS("strCateCode")
									strBoardTitle		= DKRS("strBoardTitle")
									strBoardType		= DKRS("strBoardType")
									isCommentUse		= DKRS("isCommentUse")
								End If
								Call closeRs(DKRS)


								'▣ 내가 작성한 댓글보기 (본인작성 COMMENT COUNT)
								arrParams3 = Array(_
									Db.makeParam("@strUserID",adVarChar,adParamInput,30,DK_MEMBER_ID), _
									Db.makeParam("@intList",adInteger,adParamInput,0,arrList_intList) _
								)
								arrList3 = Db.execRsList("HJP_NBOARD_MY_REPLY_LIST",DB_PROC,arrParams3,listLen3,Nothing)
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
										arrList3_MY_ALL_COMMENT_CNT	= arrList3(20,k)

										ATTRIBUTE = ""
										If DK_MEMBER_TYPE = "ADMIN" Then
											ATTRIBUTE = "class=""cp"" onclick=""viewMiniMemo('memMenu','"&arrList3_intIDX&"',event);"""
										End If


										arrList3_regDate = Replace(Left(arrList3_regDate,10),"-",".")

										DataCnt		= 0
										ico_data	= ""
										ico_secret	= ""

									''	If isCommentUse = "T" Then
									''		comment_Cnt = arrList3_TOTALSCORE
									''		If comment_Cnt = 0 Or IsNull(comment_Cnt) Then
									''			comment_Cnt = ""
									''		Else
									''			comment_Cnt = "&nbsp;<span class=""cnt"">(<strong>"&comment_Cnt&"</strong>)</span>"
									''		End If
									''	Else
									''		comment_Cnt =""
									''	End If

										If isCommentUse = "T" And UCase(cmt) = "T" Then
											comment_Cnt = arrList3_MY_ALL_COMMENT_CNT

											If comment_Cnt = 0 Or IsNull(comment_Cnt) Then
												comment_Cnt = ""
											Else
												comment_Cnt = "&nbsp;<span class=""cnt"" style=""background :yellow;"">(<strong>"&comment_Cnt&"</strong>)</span>"
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

					%>
					<%
										imgPath = VIR_PATH("board/thum")&"/"&backword(arrList_strPic)
										imgWidth = 0
										imgHeight = 0
										'Call imgInfo(imgPath,imgWidth,imgHeight,"")
										newimgWidth = 0
										newimgHeight = 0
										NEW_LENGTH = 85
										Call imgInfoNew(imgPath,newimgWidth,newimgHeight,"",NEW_LENGTH)

										If arrList3_intDepth = 0 Then
											thumbImg = aImgOPT("board_view.asp?bname="&strBoardName&"&amp;num="&arrList3_intIDX,"S",imgPath,newimgWidth,newimgHeight,"","style=""margin:"&imgPaddingH&"px "&imgPaddingW&"px;""")
										Else
											thumbImg = ""
										End If

										'▣ 내가 작성한 댓글보기
										If UCase(cmt) <> "T" Then
											If DK_MEMBER_ID <> arrList3_strUserID Then
												OPAC_IS = "opacity:0.7;"
												HIGHLIGHT_NAME = ""
											Else
												OPAC_IS = ""
												HIGHLIGHT_NAME = "background: #CCFFCC;"
											End If
										End If

										If arrList_strPic = "" Then
											col_span = 2
										Else
											col_span = 1
										End If
					%>
									<tr class="table_for">
										<td style="padding:6px 0px 0px 2px;font-size:15px;<%=OPAC_IS%>" colspan="<%=col_span%>">
											<p class="subject">
												<%If arrList3_intDepth > 0 Then%>
													<%For subtabs=1 To arrList3_intDepth%>&nbsp;&nbsp;<%next%><img src="images/bbs_answer.gif" width="10" height="10" alt="답변아이콘" />&nbsp;
												<%End If%>
												<%
													If arrList3_isSecret = "T" Then
														Select Case DK_MEMBER_TYPE
															Case "GUEST"
																IF writeID = "GUEST" Then
												%>
													<a class="cp" onclick="viewPass('passMenu','<%=arrList3_intIDX%>','<%=strBoardName%>',event);"><%=backword_title(arrList3_strSubject)%>&nbsp;<%=comment_Cnt%>&nbsp;<%=ico_data%><%=ico_secret%></a><%=new_icon%>

												<%				Else%>
													<a class="cp" onclick="alert('<%=LNG_BOARD_TYPE_BOARD_TEXT09%>');"><%=backword_title(arrList3_strSubject)%>&nbsp;<%=ico_data%><%=ico_secret%></a><%=new_icon%>&nbsp;<%=img_icons%><%=ico_hot%>

												<%				End If
															Case "MEMBER","COMPANY"
																IF writeID <> DK_MEMBER_ID Then%>
													<a class="cp" onclick="alert('\'<%=DK_MEMBER_ID%>\'<%=LNG_BOARD_TYPE_BOARD_TEXT10%>.');"><%=backword_title(arrList3_strSubject)%>&nbsp;<%=ico_data%><%=ico_secret%></a><%=new_icon%>
												<%				Else%>
													<a href="board_view.asp?bname=<%=strBoardName%>&amp;num=<%=arrList3_intIDX%><%=getCate%>"><%=backword_title(arrList3_strSubject)%>&nbsp;<%=comment_Cnt%>&nbsp;<%=ico_data%><%=ico_secret%></a><%=new_icon%>&nbsp;<%=img_icons%><%=ico_hot%>

												<%				End If
															Case "ADMIN","OPERATOR"
												%>
													<a href="board_view.asp?bname=<%=strBoardName%>&amp;num=<%=arrList3_intIDX%><%=getCate%>"><%=backword_title(arrList3_strSubject)%>&nbsp;<%=comment_Cnt%>&nbsp;<%=ico_data%><%=ico_secret%></a><%=new_icon%>&nbsp;<%=img_icons%><%=ico_hot%>
												<%			Case "SADMIN"
																If UCase(DK_MEMBER_GROUP) <> LOCATIONS Then
												%>
													<a class="cp" onclick="alert('<%=LNG_BOARD_TYPE_BOARD_TEXT11%>');"><%=backword_title(arrList3_strSubject)%>&nbsp;<%=ico_data%><%=ico_secret%></a><%=new_icon%>
												<%				Else%>
													<a href="board_view.asp?bname=<%=strBoardName%>&amp;num=<%=arrList3_intIDX%><%=getCate%>"><%=backword_title(arrList3_strSubject)%>&nbsp;<%=comment_Cnt%>&nbsp;<%=ico_data%><%=ico_secret%></a><%=new_icon%>&nbsp;<%=img_icons%><%=ico_hot%>
												<%				End If
														End Select
													Else%>
												<a href="board_view.asp?bname=<%=strBoardName%>&amp;num=<%=arrList3_intIDX%><%=getCate%>"><%=backword_title(arrList3_strSubject)%>&nbsp;<%=comment_Cnt%>&nbsp;<%=ico_data%><%=ico_secret%></a><%=new_icon%>&nbsp;<%=img_icons%><%=ico_hot%>
												<%	End If%>
											</p>
											<p class="info">
												<!-- <div class="fleft" style="border:1px solid red;width:70px;height:60px;"><%=thumbImg%></div>
												<div> -->
												<span class="desc1 fleft" style="<%=HIGHLIGHT_NAME%>"><%=arrList3_strName%></span> | <span class="desc2"><!-- <%=LNG_BOARD_TYPE_BOARD_TEXT04%> :--> <%=arrList3_regDate%></span> | <span class="desc3"><!-- <%=LNG_BOARD_TYPE_BOARD_TEXT05%> :--> <%=arrList3_readCnt%></span>
												</div>
											</p>
											<p class="info"><span style="color: #8E6458;"><%=strBoardTitle%></span></p>

										</td>
										<td class="imgages tcenter"><%=thumbImg%></td>
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
						<!-- <tfoot>
							<tr>
								<td colspan="1" height="50" class="tright">
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
								</td>
							</tr>
						</tfoot> -->
					</table>
			</div>
		</div>
	</div>
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