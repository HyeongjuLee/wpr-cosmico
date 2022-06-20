<iframe src="/hiddens.asp" name="hiddenFrame" frameborder="0" border="0" width="0" height="0" style="display:none;"></iframe>
<div id="liner">
	<div class="liner_regist">
		<form name="rfrm" action="boardHandler.asp" method="post" enctype="multipart/form-data">
			<input type="hidden" name="mode" value="INSERT" />
			<input type="hidden" name="strBoardName" value="<%=strBoardName%>" />
			<input type="hidden" name="strDomain" value="<%=LOCATIONS%>" />
			<input type="hidden" name="Content1" value=" " />
			<input type="hidden" name="strName" class="input_text" value="<%=DK_MEMBER_NAME%>" />
			<div class="input" style="width:100%;">
				<div class="tcenter mgcenter">
					<div style="position:relative; padding-right:85px;width:100%;">
						<textarea name="strSubject" class="input_area" rows="3" placeholder="<%=LNG_BOARD_VIEW_TEXT28%>"></textarea>
						<input type="submit" class="tcenter replySubmit" value="등 록">
					</div>
				</div>
				<div class="remainingTXT width98 mgcenter tright" style=""><span class="count">0</span>/<span class="maxCount"><%=isVoteMaxLength%></span> byte</div>
			</div>
		</form>
	</div>

	<table <%=tableatt%> id="board_liner" class="width100">
		<colgroup>
			<col width="120" />
			<col width="*" />
			<col width="110" />
		</colgroup>
		<tbody>

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


						If NB_isViewNameType = "N" Then viewName = arrList3_strName Else viewName = arrList3_strUserID End If
						If UCase(DK_MEMBER_ID) = UCase(arrList3_strUserID) Or DK_MEMBER_TYPE = "ADMIN" Then
							viewName = "<span class=""itme"">"&viewName&"</span>"
						Else
							If NB_isViewNameChg = "T" Then viewName = FNC_ID_CHANGE_STAR(viewName,NB_intViewNameCnt)
						End If

						ATTRIBUTE = ""
						If DK_MEMBER_TYPE = "ADMIN" Then
						'	ATTRIBUTE = "class=""cp"" onclick=""viewMiniMemo('memMenu','"&arrList3_intIDX&"',event);"""
						End If

						arrParams4 = Array(_
							Db.makeParam("@strMatchingID",adVarChar,adParamInput,100,arrList3_strName) _
						)
						WriterImg = Db.execRsData("DKP_NBOARD_WRITER_IMG",DB_PROC,arrParams4,Nothing)

						If WriterImg = "" Or IsNull(WriterImg) Then
							arrList3_strName = "<a "&ATTRIBUTE&">"&arrList3_strName&"</a>"
						Else
							imgPath = VIR_PATH("matching")&"/"&WriterImg
							imgWidth = 0
							imgHeight = 0
							Call ImgInfo(imgPath,imgWidth,imgHeight,"")
							arrList3_strName = viewImgOpt(imgPath,imgWidth,imgHeight,"",ATTRIBUTE)
						End If


						'arrList3_regDate = Replace(Left(arrList3_regDate,10),"-",".")

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
							new_icon = viewImgSt("./images/icon_new.gif",11,11,"","","")
						End If

						'PRINT arrList3_intDepth

						If arrList3_intDepth > 0 Then
							idxs = ""
						Else
							idxs = All_Count - CInt(arrList(0,i)) + 1
							arrList3_strUserID = arrList3_strUserID
						End If

						If InStr(backword(LCase(arrList3_strContent)),"<img") > 0 Then
							img_icons = viewImgOpt("./images/icon_picT.gif",16,16,"","class=""vmiddle""")
						Else
							img_icons = ""
						End If
	%>
					<tr class="table_for">
						<th style="height:<%=tdHeight%>px" class="names"><%=viewName%></td>
						<td style="height:<%=tdHeight%>px" class="subject"><%=BACKWORD_AREA(arrList3_strSubject)%>&nbsp;<%=new_icon%></td>
						<td class="regDate tcenter"><%=datevalue(arrList3_regDate)%><br /><%=timevalue(arrList3_regDate)%><br />
						<%
						' 수정/삭제 타입별 확인
						Select Case DK_MEMBER_TYPE
							Case "MEMBER","ADMIN","OPERATOR","SADMIN","COMPANY"
								'BTN_CLICK_DELETE  = "<input type=""button"" class=""input_submit design4"" value="""&LNG_BOARD_BTN_DELETE&""" onclick=""javascript:delFrm('"&intIDX&"');""/>"
								BTN_CLICK_DELETE  = "<button type=""button"" onclick=""javascript:delFrm('"&arrList3_intIDX&"','"&arrList3_intList&"','"&arrList3_intDepth&"','"&arrList3_intRIDX&"');"" class=""replyDel cp""><i class=""fas fa-times""></i></button>"
								BTN_CLICK_MODIFY  = "<input type=""button"" class=""input_submit design1"" value="""&LNG_BOARD_BTN_MODIFY&""" onclick=""location.href='board_modify.asp?bname="&strBoardName&"&amp;num="&intIDX&"'""/>"

							Case "GUEST"
								If strUserID = "GUEST" Then
									BTN_CLICK_DELETE  = "<button type=""button"" onclick=""javascript:delFrm('"&arrList3_intIDX&"','"&arrList3_intList&"','"&arrList3_intDepth&"','"&arrList3_intRIDX&"');"" class=""replyDel cp""><i class=""fas fa-times""></i></button>"
									BTN_CLICK_MODIFY  = "<input type=""button"" class=""input_submit design1"" value="""&LNG_BOARD_BTN_MODIFY&""" onclick=""javascript:onoffabs('bmodify','bdelete');""/>"
								End If
						End Select
						' 수정/삭제 확인
						Select Case DK_MEMBER_TYPE
							Case "MEMBER","COMPANY"
								If DK_MEMBER_LEVEL >= intLevelWrite And DK_MEMBER_ID = arrList3_strUserID Then
									'PRINT TABS(3)& BTN_CLICK_DELETE &" "& BTN_CLICK_MODIFY
									PRINT TABS(3)& BTN_CLICK_DELETE
								End If
							Case "GUEST"
								If DK_MEMBER_LEVEL >= intLevelWrite And arrList3_strUserID = "GUEST" Then
									'PRINT TABS(3)& BTN_CLICK_DELETE &" "& BTN_CLICK_MODIFY
									PRINT TABS(3)& BTN_CLICK_DELETE
								End If
							Case "ADMIN","OPERATOR"
								'PRINT TABS(3)& BTN_CLICK_DELETE &" "& BTN_CLICK_MODIFY
								PRINT TABS(3)& BTN_CLICK_DELETE
							Case "SADMIN"
								If UCase(DK_MEMBER_GROUP) = LOCATIONS Then
									'PRINT TABS(3)& BTN_CLICK_DELETE &" "& BTN_CLICK_MODIFY
									PRINT TABS(3)& BTN_CLICK_DELETE
								Else
									If DK_MEMBER_LEVEL >= intLevelWrite And DK_MEMBER_ID = arrList3_strUserID Then
										'PRINT TABS(3)& BTN_CLICK_DELETE &" "& BTN_CLICK_MODIFY
										PRINT TABS(3)& BTN_CLICK_DELETE
									End If
								End If
						End Select
					%>

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
		</tbody>
	</table>


	<div class="pageArea tcenter pagingNew3"><%Call pageListNew(PAGE,PAGECOUNT)%></div>

	<form name="frm" method="post" action="">
		<input type="hidden" name="PAGE" value="<%=PAGE%>" />
		<input type="hidden" name="SEARCHTERM" value="<%=SEARCHTERM%>" />
		<input type="hidden" name="SEARCHSTR" value="<%=SEARCHSTR%>" />
	</form>
</div>

<form name="w_form" method="post" action="board_delete.asp">
	<input type="hidden" name="strBoardName" value="<%=strBoardName%>" />
	<input type="hidden" name="intIDX" value="" />
	<input type="hidden" name="list" value="" />
	<input type="hidden" name="depth" value="" />
	<input type="hidden" name="ridx" value="" />
</form>

<script>
	function delFrm(idx,list,depth,ridx) {
		var f = document.w_form;
		if (confirm("<%=LNG_JS_DELETE_POST%>")) {

			f.intIDX.value = idx;
			f.list.value = list;
			f.depth.value = depth;
			f.ridx.value = ridx;


			f.target = "_self";
			f.submit();
		}

	}
</script>