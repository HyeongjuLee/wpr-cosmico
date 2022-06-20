
<div id="pagecnt_topArea">
	<div class="list_title">
		<div class="total"><p><em></em><span>Total : <%=All_Count%></span><!-- (1/10 Page) --></p></div>

		<%If strBoardName = "localforum" And DK_MEMBER_LEVEL > 0 Then%>
			<div class="request_btn">
				<a href="/m/forum/forum_request.asp">지역포럼 개설요청</a>
			</div>
		<%End If%>
		<!-- <%If strBoardName = "topicforum" And DK_MEMBER_LEVEL > 0 Then%>
			<div class="request_btn">
				<a href="/m/forum/forum_s_request.asp">주제별포럼 개설요청</a>
			</div>
		<%End If%> -->

	</div>
</div>

<%
'▣▣ 포커스포럼 [지역포럼소개] - 이주의 인기포럼 ▣▣
'If strBoardName = "localforum" Or strBoardName = "topicforum" Then
If strBoardName = "localforum" Then

	arrParamsTC = Array( _
		Db.makeParam("@TOP",adVarChar,adParamInput,50,2), _
		Db.makeParam("@strBoardName",adVarChar,adParamInput,50,strBoardName), _
		Db.makeParam("@SEARCHTERM",adVarChar,adParamInput,30,SEARCHTERM), _
		Db.makeParam("@SEARCHSTR",adVarChar,adParamInput,30,convSql(SEARCHSTR)), _
		Db.makeParam("@strDomain",adVarChar,adParamInput,50,UCase(DK_MEMBER_NATIONCODE)), _
		Db.makeParam("@strCenterCode",adVarChar,adParamInput,20,strCenterCode) _
	)
	arrListTC = Db.execRsList("HJP_NBOARD_BOARD_LIST_FOCUS_FORUM_TOP",DB_PROC,arrParamsTC,listLenTC,Nothing)

	If IsArray(arrListTC) Then
%>
		<div id="contentGT" class="porel">
			<div class="porel width100 contentGT_Area">
			<p class="tit" style="color: #1d1d1d; font-size: 15px; font-weight: 500; text-align: center; margin: 0px 0px 20px 0px;">이주의 인기포럼</p>
			<%

				For t = 0 To listLenTC
					arrListTC_intIDX		= arrListTC(0,t)
					arrListTC_intNum		= arrListTC(1,t)
					arrListTC_intList		= arrListTC(2,t)
					arrListTC_intDepth		= Int(arrListTC(3,t))
					arrListTC_intRIDX		= arrListTC(4,t)
					arrListTC_strUserID		= arrListTC(5,t)
					arrListTC_strName		= arrListTC(6,t)
					arrListTC_regDate		= arrListTC(7,t)
					arrListTC_readCnt		= arrListTC(8,t)
					arrListTC_editDate		= arrListTC(9,t)
					arrListTC_strSubject	= arrListTC(10,t)
					arrListTC_strContent	= arrListTC(11,t)
					arrListTC_strData1		= arrListTC(12,t)
					arrListTC_strData2		= arrListTC(13,t)
					arrListTC_strData3		= arrListTC(14,t)
					arrListTC_isSecret		= arrListTC(15,t)
					arrListTC_TOTALSCORE	= arrListTC(16,t)
					arrListTC_isIDImg		= arrListTC(17,t)
					arrListTC_imgPath		= arrListTC(18,t)
					arrListTC_isMainNotice	= arrListTC(19,t)
					arrListTC_strCenterCode	= arrListTC(20,t)
					arrListTC_strBandURL	= arrListTC(21,t)
					arrListTC_strForumCode	= arrListTC(22,t)
					arrListTC_strPic		= arrListTC(23,t)

					arrListTC_regDate = Replace(Left(arrListTC_regDate,10),"-",".")

					If isCommentUse = "T" Then
						comment_Cnt = arrListTC_TOTALSCORE
						If comment_Cnt = 0 Or IsNull(comment_Cnt) Then
							comment_Cnt = ""
						Else
							comment_Cnt = "<span class=""cnt"">(<strong>"&comment_Cnt&"</strong>)</span>"
						End If
					Else
						comment_Cnt =""
					End If

					new_icon = ""

					imgPath = VIR_PATH("board/thum")&"/"&backword(arrListTC_strPic)
					imgWidth = 0
					imgHeight = 0
					Call ImgInfo(imgPath,imgWidth,imgHeight,"")

					'▣가로세로 비율고정 반응형 DIV 박스
					BOX_RATIO_H = 100		'이미지 Div박스 가로세로 높이비율 (100 : BOX_RATIO_H) 	padding-bottom:(70~100)
					IMG_RATIO   = 95		'박스내 이미지 비율

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

					If (t + 1) Mod 2 = 0 Then
						classNames = "index_v_pic2"
					Else
						classNames = "index_v_pic"
					End If

				%>
				<div class="gArea <%=classNames%>" id="gid<%=i+1%>">
					<%'▣가로세로 비율고정 반응형 DIV 박스%>
					<a href="board_view.asp?bname=<%=strBoardName%>&amp;num=<%=arrListTC_intIDX%><%=getCate%>" id="link">
						<div class="img" style="padding-bottom:<%=BOX_RATIO_H%>%;" >
							<div class="tcenter" style="position:absolute; width:100%; height:100%;left:0;top:<%=TOP_RATIO%>%;">
								<%If DK_MEMBER_LEVEL > 0 Then%>
									<a href="board_view.asp?bname=<%=strBoardName%>&amp;num=<%=arrListTC_intIDX%><%=getCate%>"><%=goodsImg%></a>
								<%Else%>
									<a href="javascript:check_frm();"><%=goodsImg%></a>
								<%End If%>
							</div>
						</div>
					</a>
					<div class="textArea" >
						<div class="subject"><%=arrListTC_strSubject%></div>
						<div class="text">
							<table <%=tableatt%> class="width100 gTable">
								<col width="" />
								<col width="" />
								<%
								'	PRINT "<tr>"
								'	PRINT "		<td class=""fleft""><span>"&LNG_TEXT_COUNT_NUMBER&" : "&arrListTC_readCnt&"</span></td>"
								'	PRINT "		<td class=""th""></td>"
								'	PRINT "</tr><tr>"
								'	PRINT "		<td class=""fleft""><span>"&arrListTC_regDate&"</span></td>"
								'	PRINT "		<td class=""th""></td>"
								'	PRINT "</tr>"
								%>
							</table>
						</div>
						<!-- <div class="heartArea">
							<span class="heart1 fright"><span class="heartTxt"><%=num2cur(arrListTC_TOTALVOTE)%></span></span>
						</div> -->
					</div>
				</div>
			<%
				Next
			%>
			</div>
		</div>
<%
	End If
End If
%>

<div id="div_move1"></div>
<div id="" class="width100 company fleft">

	<div class="cleft pcontent" style="padding-top:0px">
		<div id="board">
			<div class="innerContent">
				<table <%=tableatt%> id="board2" style="width:100%;">
					<colgroup>
						<col width="">
						<col width="70">
					</colgroup>
					<%
						If strBoardName = "notice" Then
							arrParamsM = Array(_
								Db.makeParam("@TOP",adInteger,adParamInput,20,5) ,_
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
								<tr class="table_for" style="background-color:#f3f3f3;">
									<td class="tweight" style="color:red;">[<%=LNG_BOARD_TYPE_BOARD_TEXT13%>]
										<a href="board_view.asp?bname=<%=strBoardName%>&amp;ty=<%=LOCTYPE%>&amp;num=<%=arrListM_intIDX%><%=getCate%>"><%=backword_title(arrListM_strSubject)%><%=arrListM_strName%>&nbsp;<%=ico_data%><%=ico_secret%></a><%=new_icon%>&nbsp;<%=img_icons%><%=ico_hot%>
										<p class="info"><span class="desc1"><%=arrListM_strName%></span> | <span class="desc2"><%=LNG_BOARD_TYPE_BOARD_TEXT04%> : <%=Replace(Left(arrListM_regDate,10),"-",".")%></span> | <span class="desc3"><%=LNG_BOARD_TYPE_BOARD_TEXT05%> : <%=arrListM_readCnt%></span></p>
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

								'▣▣ 포커스포럼 [지역포럼소개] ▣▣
								arrList_strCenterCode	= arrList(22,i)
							'	arrList_strBandURL		= arrList(23,i)
							'	arrList_strForumCode	= arrList(24,i)

								'list = cInt(arrList(3,i))
								'depthst = cInt(arrList(4,i))

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

										arrList3_strSubject = cutString2(arrList3_strSubject,50)

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
												comment_Cnt = "&nbsp;<span class=""cnt"">(<strong>"&comment_Cnt&"</strong>)</span>"
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
										If DataCnt > 0 Then
											'ico_data = "<img src=""./images/files.gif"" width=""10"" height=""10"" class=""vmiddle"" alt="""&LNG_BOARD_TYPE_BOARD_TEXT08&"."" /> "
											ico_data = "<em></em>"
										End If

										If arrList3_isSecret = "T" Then
											ico_secret = "<img src=""./images/lock.gif"" width=""21"" height=""13"" alt=""비밀글입니다."" style=""vertical-align:middle;"" />"
										End If
										numView = ""
										If arrList3_intNum <> 0 Then numView = arrList3_intNum

										'print CDate(date)
										'print Replace(arrList3_regDate,".","-")
										new_icon = ""
										If CDate(Date)-newIconDate =< CDate(Replace(arrList3_regDate,".","-")) Then
											'new_icon = viewImgOpt("./images/icon_new.gif",11,11,"","class=""vmiddle""")
											new_icon = "<u></u>"
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
									<tr class="table_for">
										<td style="padding:12px 10px;font-size:13px;">
											<p class="subject">
											<%If arrList3_intDepth > 0 Then%><%For subtabs=1 To arrList3_intDepth%>&nbsp;&nbsp;<%next%><img src="images/bbs_answer.gif" width="10" height="10" alt="답변아이콘" />&nbsp;<%End If%>
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
										<p class="info"><span class="desc1"><%=arrList3_strName%></span> | <span class="desc2"><%=arrList3_regDate%></span> | <span class="desc3"><!-- <%=LNG_BOARD_TYPE_BOARD_TEXT05%> :  --><%=arrList3_readCnt%></span></p>
										</td>
										<td>
											<div class="fright">
												<%If arrList3_intDepth = 0 Then%>
												<div class="band_btn_wrap">
													<%
														If arrList_strForumCode <> "" Then
															linkF = "https://band.us/@"&arrList_strForumCode
															targets = "target=""_blank"""
															c_opac = ""
														Else
															linkF = "javascript:alert('등록된 주소가 없습니다.')"
															targets = "target=""_self"""
															c_opac = "opac"
														End If
													%>
													<a href="<%=linkF%>" class="band_btn <%=c_opac%>" <%=targets%>><u></u><em>바로가기</em></a>
												</div>
												<%End If%>
											</div>
										</td>
									</tr>
					<%

								Next
							End If

							Next
						Else
					%>
							<tr>
								<td colspan="2" class="nothing"><%=LNG_TEXT_NO_REGISTERED_POST%></td>
							</tr>
					<%
						End If
					%>
						<tfoot>
							<tr>
								<td colspan="2" height="50" class="tright">
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
						</tfoot>
					</table>
			</div>
		</div>
		<!-- <div class="pagingArea pagingMob5"><% Call pageListMob5(PAGE,PAGECOUNT)%></div> -->
		<div class="tcenter"><%Call pagingMobNewMOVE(PAGE,PAGECOUNT)%></div>

		<!-- <%
			Select Case DK_MEMBER_TYPE
				Case "MEMBER","COMPANY","GUEST"
					If DK_MEMBER_LEVEL >= intLevelWrite Then
		%>
					<div class="post_btn cp">
						<a onclick="location.href='board_write.asp?bname=<%=strBoardName%>'" >
							<p>글쓰기</p><em></em>
						</a>
					</div>
		<%
					End If
				Case "ADMIN","OPERATOR"
		%>
					<div class="post_btn cp">
						<a onclick="location.href='board_write.asp?bname=<%=strBoardName%>'" >
							<p>글쓰기</p><em></em>
						</a>
					</div>
		<%
			End Select
		%> -->


	</div>
</div>

<div id="memMenu" class="memMenu">sd<%=viewImg("./images/loading65.gif",65,65,"")%></div>
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
<!-- <button onclick="fnMove('1')">div1로 이동</button>
<button onclick="fnMove('2')">div2로 이동</button>
<button onclick="fnMove('3')">div3로 이동</button>
<div id="div2">div2</div>
<div id="div3">div3</div> -->
<form name="frm" method="post" action="">
	<input type="hidden " name="PAGE" value="<%=PAGE%>" />
	<input type="hidden" name="SEARCHTERM" value="<%=SEARCHTERM%>" />
	<input type="hidden" name="SEARCHSTR" value="<%=SEARCHSTR%>" />
	<input type="hidden" name="strCenterCode" value="<%=strCenterCode%>" />
	<input type="hidden" name="pagingCLICK" value="<%=pagingCLICK%>" />
</form>
