<table <%=tableatt%> id="board1" class="width100">
	<colgroup>
		<col width="60" />
		<col width="*" />
		<col width="90" />
		<col width="90" />
		<col width="120" />
		<col width="90" />
		<col width="65" />
	</colgroup>
	<thead>
		<tr>
			<th><%=LNG_BOARD_TYPE_BOARD_TEXT01%></th>
			<th><%=LNG_BOARD_TYPE_BOARD_TEXT02%></th>
			<th><%=LNG_BOARD_TYPE_BOARD_TEXT14%></th>
			<th><%=LNG_BOARD_TYPE_BOARD_TEXT15%></th>
			<th><%=LNG_BOARD_TYPE_BOARD_TEXT03%></th>
			<th><%=LNG_BOARD_TYPE_BOARD_TEXT04%></th>
			<th><%=LNG_BOARD_TYPE_BOARD_TEXT05%></th>
		</tr>
	</thead>
	<tfoot>
		<tr>
			<td colspan="2" height="30" class="tleft pagingNew3"><%Call pageListNew(PAGE,PAGECOUNT)%></td>
			<td colspan="5" height="40" class="tright">
				<%
					Select Case DK_MEMBER_TYPE
						Case "MEMBER","GUEST","COMPANY"
							If DK_MEMBER_LEVEL >= intLevelWrite Then
								'PRINT TABS(3)& "	<input type=""button"" class=""txtBtn small2 pd7"" value="""&LNG_BOARD_BTN_WRITE&""" onclick=""location.href='board_write.asp?bname="&strBoardName&"'"" />"

								WriteTF = FN_CHECK_BOARD_WRITE_COUNT_KIN(strBoardName,DK_MEMBER_ID,NB_intWriteLimit,"TF","0")
								If WriteTF = "T" Then
									PRINT TABS(3)& "	<a href=""board_write.asp?bname="&strBoardName&""" class=""a_submit design1"">"&LNG_BOARD_BTN_WRITE&"</a>"
								Else
									PRINT TABS(3)& "	<a href=""javascript:alert('해당 게시판의 일일 글쓰기 횟수를 초과했습니다.\n익일 글쓰기를 시도해주세요.');"" class=""a_submit design1"">"&LNG_BOARD_BTN_WRITE&"</a>"
								End If
							End If
							'Call ALERTS(LNG_JS_UNAUTHORIZED_WRITE,"back","")
						Case "ADMIN","OPERATOR"
							'PRINT TABS(3)& "	<input type=""button"" class=""txtBtn small2 pd7"" value="""&LNG_BOARD_BTN_WRITE&""" onclick=""location.href='board_write.asp?bname="&strBoardName&"'"" />"
							PRINT TABS(3)& "	<a href=""board_write.asp?bname="&strBoardName&""" class=""a_submit design1"">"&LNG_BOARD_BTN_WRITE&"</a>"

					End Select

					'PRINT TABS(3)& "	<input type=""button"" class=""txtBtn small2 pd7"" value="""&LNG_BOARD_BTN_LIST&""" onclick=""location.href='board_list.asp?bname="&strBoardName&"'"" />"
					PRINT TABS(3)& "	<a href=""board_list.asp?bname="&strBoardName&""" class=""a_submit design3"">"&LNG_BOARD_BTN_LIST&"</a>"
				%>
			</td>
		</tr>
	</tfoot>
	<tbody>
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

				PRINT TABS(2)& "	<tr class=""table_for"" style=""background-color:#f3f3f3;"">"
				PRINT TABS(2)& "		<td class=""tcenter tweight"" style=""color:red;"">["&LNG_BOARD_TYPE_BOARD_TEXT13&"]</td>"
				PRINT TABS(2)& "		<td class=""subject tweight"" colspan=""3""><a href=""board_view_kin.asp?bname=notice&amp;num="&arrListM_intIDX&""">"&backword_title(arrListM_strSubject)&"</a></td>"
				PRINT TABS(2)& "		<td class=""tcenter"">"&arrListM_strName&"</td>"
				PRINT TABS(2)& "		<td class=""tcenter"">"&Replace(Left(arrListM_regDate,10),"-",".")&"</td>"
				PRINT TABS(2)& "		<td class=""tcenter"">"&arrListM_readCnt&"</td>"
				PRINT TABS(2)& "	</tr>"
			Next
		End If
	End If
%>
<%

	If NB_isTopBestView = "T" Then

		arrParamsM = Array(_
			Db.makeParam("@TOP",adInteger,adParamInput,20,NB_intTopBestView) ,_
			Db.makeParam("@strDomain",adVarChar,adParamInput,50,LANG), _
			Db.makeParam("@intTopBestLimit",adInteger,adParamInput,20,NB_intTopBestLimit) ,_
			Db.makeParam("@strBoardName",adVarChar,adParamInput,50,strBoardName) _
		)
		arrListM = Db.execRsList("DKP_NBOARD_BEST_CONTENT_LIST",DB_PROC,arrParamsM,listLenM,Nothing)
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
				arrListM_strContent		= arrListM(11,m)
				arrListM_strData1		= arrListM(12,m)
				arrListM_strData2		= arrListM(13,m)
				arrListM_strData3		= arrListM(14,m)
				arrListM_isSecret		= arrListM(15,m)
				arrListM_TOTALSCORE		= arrListM(16,m)
				arrListM_VOTECNT		= arrListM(17,m)
				arrListM_orderGrade		= arrListM(18,m)
				arrListM_isKinSelect	= arrListM(19,m)

				If NB_isViewNameType = "N" Then viewName = arrListM_strName Else viewName = arrListM_strUserID End If
				If UCase(DK_MEMBER_ID) = UCase(arrListM_strUserID) Or DK_MEMBER_TYPE = "ADMIN" Then
					viewName = "<span class=""itme"">"&viewName&"</span>"
				Else
					If NB_isViewNameChg = "T" Then viewName = FNC_ID_CHANGE_STAR(viewName,NB_intViewNameCnt)
				End If

				ReplyCnt = 0
				arrParams3 = Array(_
					Db.makeParam("@intList",adInteger,adParamInput,0,arrListM_intList) _
				)
				ReplyCnt = Db.execRsData("DKSP_NBOARD_KIN_LIST_DATA",DB_PROC,arrParams3,Nothing)


				PRINT TABS(2)& "	<tr class=""table_for"" style=""background-color:#fafafa;"">"
				PRINT TABS(2)& "		<td class=""tcenter"" style=""color:blue;"">[BEST]</td>"
				PRINT TABS(2)& "		<td class=""subject"" style=""font-weight:500;""><a href=""board_view_kin.asp?bname="&strBoardName&"&amp;num="&arrListM_intIDX&""">"&backword_title(arrListM_strSubject)&"</a></td>"
%>
			<td style="height:<%=tdHeight%>px"><%=num2cur(ReplyCnt)%></td>
			<td style="height:<%=tdHeight%>px"><%=TFVIEWER(arrListM_isKinSelect,"KIN")%></td>
<%
				PRINT TABS(2)& "		<td class=""tcenter"">"&viewName&"</td>"
				PRINT TABS(2)& "		<td class=""tcenter"">"&Replace(Left(arrListM_regDate,10),"-",".")&"</td>"
				PRINT TABS(2)& "		<td class=""tcenter"">"&arrListM_readCnt&"</td>"
				PRINT TABS(2)& "	</tr>"
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
			arrList_isKinSelect		= arrList(22,i)
			'arrList_VOTECNT			= arrList(23,k)

			If NB_isViewNameType = "N" Then viewName = arrList_strName Else viewName = arrList_strUserID End If
			If UCase(DK_MEMBER_ID) = UCase(arrList_strUserID) Or DK_MEMBER_TYPE = "ADMIN" Then
				viewName = "<span class=""itme"">"&viewName&"</span>"
			Else
				If NB_isViewNameChg = "T" Then viewName = FNC_ID_CHANGE_STAR(viewName,NB_intViewNameCnt)
			End If

			ReplyCnt = 0
			arrParams3 = Array(_
				Db.makeParam("@intList",adInteger,adParamInput,0,arrList_intList) _
			)
			ReplyCnt = Db.execRsData("DKSP_NBOARD_KIN_LIST_DATA",DB_PROC,arrParams3,Nothing)


			'SQL = "SELECT

			ATTRIBUTE = ""
			If DK_MEMBER_TYPE = "ADMIN" Then
			'	ATTRIBUTE = "class=""cp"" onclick=""viewMiniMemo('memMenu','"&arrList3_intIDX&"',event);"""
			End If

			arrParams4 = Array(_
				Db.makeParam("@strMatchingID",adVarChar,adParamInput,100,arrList_strName) _
			)
			WriterImg = Db.execRsData("DKP_NBOARD_WRITER_IMG",DB_PROC,arrParams4,Nothing)

			If WriterImg = "" Or IsNull(WriterImg) Then
				arrList_strName = "<a "&ATTRIBUTE&">"&arrList_strName&"</a>"
			Else
				imgPath = VIR_PATH("matching")&"/"&WriterImg
				imgWidth = 0
				imgHeight = 0
				Call ImgInfo(imgPath,imgWidth,imgHeight,"")
				arrList_strName = viewImgOpt(imgPath,imgWidth,imgHeight,"",ATTRIBUTE)
			End If


			arrList_regDate = Replace(Left(arrList_regDate,10),"-",".")

			DataCnt		= 0
			ico_data	= ""
			ico_secret	= ""

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

			If arrList_strData1 = "" Or IsNull(arrList_strData1) Then DataCnt1 = 0 : Else DataCnt1 = 1
			If arrList_strData2 = "" Or IsNull(arrList_strData2) Then DataCnt2 = 0 : Else DataCnt2 = 1
			If arrList_strData3 = "" Or IsNull(arrList_strData3) Then DataCnt3 = 0 : Else DataCnt3 = 1

			DataCnt = DataCnt1 + DataCnt2 + DataCnt3
			'PRINT arrList3_isSecret

			If DataCnt > 0 Then ico_data = "<img src=""./images/files.gif"" width=""10"" height=""10"" class=""vmiddle"" alt="""&LNG_BOARD_TYPE_BOARD_TEXT08&"."" /> "
			If arrList_isSecret = "T" Then
				ico_secret = "<img src=""./images/lock.gif"" width=""21"" height=""13"" alt=""비밀글입니다."" style=""vertical-align:middle;"" />"
			End If
			numView = ""
			If arrList_intNum <> 0 Then numView = arrList_intNum

			'print CDate(date)
			'print Replace(arrList3_regDate,".","-")
			new_icon = ""
			If CDate(Date)-newIconDate =< CDate(Replace(arrList_regDate,".","-")) Then
				new_icon = viewImgSt("./images/icon_new.gif",11,11,"","","")
			End If

			'PRINT arrList3_intDepth

			If arrList_intDepth > 0 Then
				idxs = ""
			Else
				idxs = All_Count - CInt(arrList(0,i)) + 1
				arrList_strUserID = arrList_strUserID
			End If

			If InStr(backword(LCase(arrList_strContent)),"<img") > 0 Then
				img_icons = viewImgOpt("./images/icon_picT.gif",16,16,"","class=""vmiddle""")
			Else
				img_icons = ""
			End If
		%>
		<tr class="table_for">
			<td style="height:<%=tdHeight%>px"><%=idxs%></td>
			<td style="height:<%=tdHeight%>px" class="subject">
				<%If arrList_intDepth > 0 Then%><%For subtabs=1 To arrList_intDepth%>&nbsp;&nbsp;&nbsp;<%next%><img src="images/bbs_answer.gif" width="10" height="10" alt="답변아이콘" />&nbsp;<%End If%>
				<%
					If arrList_isSecret = "T" Then
						Select Case DK_MEMBER_TYPE
							Case "GUEST"
								IF arrList_strUserID = "GUEST" Then
									PRINT "<a class=""cp"" onclick=""viewPass('passMenu','"&arrList_intIDX&"','"&strBoardName&"',event);"">"&backword_title(arrList_strSubject)&"&nbsp;"&comment_Cnt&"&nbsp;"&ico_data&""&ico_secret&"</a>"&new_icon
								Else
									PRINT "<a class=""cp"" onclick=""alert('"&LNG_BOARD_TYPE_BOARD_TEXT09&"');"">"&backword_title(arrList_strSubject)&"&nbsp;"&ico_data&""&ico_secret&"</a>"&new_icon&"&nbsp;"&img_icons&""&ico_hot
								End If
							Case "MEMBER","COMPANY"
								IF arrList_strUserID <> DK_MEMBER_ID Then
									PRINT "<a class=""cp"" onclick=""alert('\'"&DK_MEMBER_ID&"\'"&LNG_BOARD_TYPE_BOARD_TEXT10&".');"">"&backword_title(arrList_strSubject)&"&nbsp;"&ico_data&""&ico_secret&"</a>"&new_icon
								Else
									PRINT "<a href=""board_view_kin.asp?bname="&strBoardName&"&amp;num="&arrList_intIDX&""&getCate&""">"&backword_title(arrList_strSubject)&"&nbsp;"&comment_Cnt&"&nbsp;"&ico_data&""&ico_secret&"</a>"&new_icon&"&nbsp;"&img_icons&""&ico_hot
								End If
							Case "ADMIN","OPERATOR"
									PRINT "<a href=""board_view_kin.asp?bname="&strBoardName&"&amp;num="&arrList_intIDX&""&getCate&""">"&backword_title(arrList_strSubject)&"&nbsp;"&comment_Cnt&"&nbsp;"&ico_data&""&ico_secret&"</a>"&new_icon&"&nbsp;"&img_icons&""&ico_hot
							Case "SADMIN"
								If UCase(DK_MEMBER_GROUP) <> LOCATIONS Then
									PRINT "<a class=""cp"" onclick=""alert('"&LNG_BOARD_TYPE_BOARD_TEXT11&"');"">"&backword_title(arrList_strSubject)&"&nbsp;"&ico_data&""&ico_secret&"</a>"&new_icon
								Else
									PRINT  "<a href=""board_view_kin.asp?bname="&strBoardName&"&amp;num="&arrList_intIDX&""&getCate&""">"&backword_title(arrList_strSubject)&"&nbsp;"&comment_Cnt&"&nbsp;"&ico_data&""&ico_secret&"</a>"&new_icon&"&nbsp;"&img_icons&""&ico_hot
								End If
						End Select
					Else
						PRINT "<a href=""board_view_kin.asp?bname="&strBoardName&"&amp;num="&arrList_intIDX&""&getCate&""">"&backword_title(arrList_strSubject)&"&nbsp;"&comment_Cnt&"&nbsp;"&ico_data&""&ico_secret&"</a>"&new_icon&"&nbsp;"&img_icons&""&ico_hot
					End If
				%>
			</td>
			<td style="height:<%=tdHeight%>px"><%=num2cur(ReplyCnt)%></td>
			<td style="height:<%=tdHeight%>px"><%=TFVIEWER(arrList_isKinSelect,"KIN")%></td>
			<td style="height:<%=tdHeight%>px"><%=viewName%></td>
			<td style="height:<%=tdHeight%>px"><%=arrList_regDate%></td>
			<td style="height:<%=tdHeight%>px"><%=num2cur(arrList_readCnt)%></td>
		</tr>
<%
		Next
	Else
%>
				<tr>
					<td colspan="7" class="nothing"><%=LNG_TEXT_NO_REGISTERED_POST%></td>
				</tr>
<%

	End If
%>
	</tbody>
</table>

<div id="memMenu" class="memMenu"><%=viewImg("./images/loading65.gif",65,65,"")%></div>
<div id="passMenu" class="passMenu">
	<form name="vfrm" method="post" action="pass.asp" onsubmit="return ChkvFrm(this);">
		<%=LNG_BOARD_TYPE_BOARD_TEXT12%> : <input type="password" class="input_text_gr vmiddle" name="strPass" style="width:150px;" /> <input type="submit" class="txtBtn small2 pd7" value="<%=LNG_TEXT_CONFIRM%>" />
	</form>
</div>
<form name="frm" method="post" action="">
	<input type="hidden" name="PAGE" value="<%=PAGE%>" />
	<input type="hidden" name="SEARCHTERM" value="<%=SEARCHTERM%>" />
	<input type="hidden" name="SEARCHSTR" value="<%=SEARCHSTR%>" />
</form>
