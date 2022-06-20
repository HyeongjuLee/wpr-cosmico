
<script type="text/javascript">
	function delFrm_blog(idx,list,depth,ridx) {
		var f = document.w_form;
		if (confirm("<%=LNG_JS_DELETE_POST%>")) {
			f.action = 'board_delete.asp';
			f.intIDX.value = idx;
			f.list.value = list;
			f.depth.value = depth;
			f.ridx.value = ridx;
			f.target = "_self";
			f.submit();
		}

	}
</script>
<div id="blog_search">
	<form action="" method="post" name="search">
		<select class="searchterm select vmiddle" name="searchterm">
			<option value="strSubject"<%If SEARCHTERM = "strSubject" Then%> selected="selected"<%End If%>><%=LNG_TEXT_TITLE%></option>
			<option value="strContent"<%If SEARCHTERM = "strContent" Then%> selected="selected"<%End If%>><%=LNG_TEXT_CONTENT%></option>
		</select>
		<input type="text" class="searchstr vmiddle" name="SEARCHSTR" value="<%=convSql(SEARCHSTR)%>" /></td>
		<input type="image" src="./images/btn_blog01.gif" class="vmiddle" />
	</form>
</div>
<%

	If IsArray(arrList) Then
		For i = 0 To listLen

%>
<div class="BlogData">
	<table <%=tableatt%> class="userCWidth2">
		<col width="600" />
		<col width="150" />
		<tr>
			<th class="tleft"><%=arrList(11,i)%></th>
			<td class="date"><%=arrList(8,i)%></td>
		</tr><tr>
			<td colspan="2" class="content"><%=backword(arrList(12,i))%></td>
		</tr><tr>
			<td colspan="2" class="btns">
<%
		' 수정/삭제 타입별 확인
		Select Case DK_MEMBER_TYPE
			Case "ADMIN"
				BTN_CLICK_DELETE  = aImgOpt("javascript:delFrm_blog('"&arrList(1,i)&"','"&arrList(3,i)&"','"&arrList(4,i)&"','"&arrList(5,i)&"');","","images/btn_blog05.gif",60,23,"","class=""vmiddle""")
				BTN_CLICK_MODIFY  = aImgOpt("board_modify.asp?bname="&strBoardName&"&amp;num="&arrList(1,i),"S","images/btn_blog06.gif",60,23,"","class=""vmiddle""")
		End Select
		' 수정/삭제 확인
		Select Case DK_MEMBER_TYPE
			Case "ADMIN"
				PRINT BTN_CLICK_DELETE &" "& BTN_CLICK_MODIFY
		End Select
%>
			</td>
		</tr>
	</table>
</div>

<%
		Next
	Else
%>
<div class="notBlogData"><%=LNG_TEXT_NO_REGISTERED_POST%></div>
<%
	End If
%>
<div class="tright" style="padding:10px 0px;">
<%
		Select Case DK_MEMBER_TYPE
			Case "ADMIN","OPERATOR"
				PRINT TABS(3)& "	<a href=""board_write.asp?bname="&strBoardName&"""><img src=""images/btn_blog04.gif"" width=""60"" height=""23"" alt=""목록가기"" align=""middle"" /></a>"
		End Select

	%>
</div>
<div class="blog_paging"><%Call pageList(PAGE,PAGECOUNT)%></div>


<form name="dFrm" action="replyHandler.asp" method="post" target="hiddenFrame">
	<input type="hidden" name="mode" value="DELETE" />
	<input type="hidden" name="appIDX" value="" />
</form>
<form name="w_form" method="post" action="">
	<input type="hidden" name="strBoardName" value="<%=strBoardName%>" />
	<input type="hidden" name="intIDX" value="<%=intIDX%>" />
	<input type="hidden" name="list" value="<%=intList%>" />
	<input type="hidden" name="depth" value="<%=intDepth%>" />
	<input type="hidden" name="ridx" value="<%=intRIDX%>" />
</form>
