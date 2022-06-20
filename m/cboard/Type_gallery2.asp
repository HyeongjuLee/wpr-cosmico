<%
	'gallery2, movie2
%>
<div id="div_move1"></div>
<div id="content" class="company">
	<div class="width100" style="margin-bottom:15px;">
		<table <%=tableatt%> class="gallery_list width100">
			<col width="150" />
			<col width="*" />
			<%

				If IsArray(arrList) Then
					PRINT "	 <tr>"
					PRINT "	 	<td colspan=""2""  style=""background:#ebebeb;height:10px;""></td>"
					PRINT "	 </tr>"

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
								comment_Cnt = "<span class=""cnt"" style=""font-size:13px;"">(<strong>"&comment_Cnt&"</strong>)</span>"
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
						'Call imgInfo(imgPath,imgWidth,imgHeight,"")
						newimgWidth = 0
						newimgHeight = 0
						NEW_LENGTH = 110
						Call imgInfoNew(imgPath,newimgWidth,newimgHeight,"",NEW_LENGTH)

						thumbImg = aImgOPT("board_view.asp?bname="&strBoardName&"&amp;num="&arrList_intIDX,"S",imgPath,newimgWidth,newimgHeight,"","style=""margin:"&imgPaddingH&"px "&imgPaddingW&"px;""")

						'NO IMAGE
						If arrList_strPic = "" Then
							thumbImg = aImgOPT("board_view.asp?bname="&strBoardName&"&amp;num="&arrList_intIDX,"S","/images/noimages.png",110,65,"","style=""margin:"&imgPaddingH&"px "&imgPaddingW&"px;""")
						End If

						PRINT "	<tr>"
						PRINT "		<td class=""imgages tcenter"" rowspan=""3"">"&thumbImg&"</td>"
						PRINT "		<td colspan=""1"" class=""subject""><a href=""board_view.asp?bname="&strBoardName&"&amp;num="&arrList_intIDX&""">"&backword_title(cutString(arrList_strSubject,20))&"&nbsp;"&comment_Cnt&"</a></td>"
						PRINT "	</tr>"
						PRINT "	<tr>"
						PRINT "		<td class=""noHeart"">"
						If isVote ="T" Then
							PRINT "		<span class=""heart1 fleft""><span class=""heartTxt"">"&num2cur(arrList_TOTALVOTE)&"</span></span>"
						End If
						PRINT "		</td>"
						PRINT "	</tr>"
						PRINT "	<tr>"
						'PRINT "		<td class=""desc1 tweight fleft"">"&arrList_strName&"</td>"
						If arrList_readCnt > 0 Then
							arrList_readCnt = "<span style=""color:#888;font-weight:normal;"">("&arrList_readCnt&")</span>"
						Else
							arrList_readCnt = ""
						End If
						PRINT "		<td class=""desc1 fleft tweight"">"&arrList_strName&" "&arrList_readCnt&"</td>"
						PRINT "		<td class=""desc2 fright"">"&arrList_regDate&"</td>"
						PRINT "	</tr>"

						PRINT "	 <tr>"
						PRINT "	 	<td colspan=""2""  style=""background:#ebebeb;height:9px;""></td>"
						PRINT "	 </tr>"

					Next
				Else
						PRINT "	<tbody>"
						PRINT "	<tr>"
						PRINT "		<td class=""imgages tcenter"" style=""height:100px;"">"&LNG_TEXT_NO_REGISTERED_POST&"</td>"
						PRINT "	</tr>"
						PRINT "	</tbody>"
				End If
			%>
			<tfoot>
				<tr>
					<td colspan="2" class="tcenter btn_area">
						<div class="tcenter btn_area" style="margin-top:20px;" >
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
					</td>
				</tr>
			</tfoot>

		</table>
	</div>
</div>
<!-- <div class="pagingArea pagingMob5"><% Call pageListMob5(PAGE,PAGECOUNT)%></div> -->
<div class="tcenter"><%Call pagingMobNewMOVE(PAGE,PAGECOUNT)%></div>

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