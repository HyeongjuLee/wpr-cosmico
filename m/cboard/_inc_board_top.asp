<%If DK_MEMBER_TYPE = "ADMIN" Then%>
<iframe src="/hiddens.asp" name="hiddenFrame" frameborder="0" width="0" height="0" style="display:none;"></iframe>
<form name="memInfo" method="post" action="memInfoHandler.asp">
	<input type="hidden" name="MODE" value="" />
	<input type="hidden" name="idx" value="" />
</form>
<%End If%>
<%
'	DEPTH1 = "<a href=""/index.asp"">HOME</a>"
'
'	Select Case PAGE_SETTING
'		Case "CUSTOMER"
'			DEPTH2 = "<a href=""/cboard/board_list.asp?bname=notice"">고객지원</a>"
'			Select Case view
'				Case "1"
'					DEPTH3 = "<a href=""/cboard/board_list.asp?bname=notice"">뉴스/공지사항/행사안내</a>"
'				Case "2"
'					DEPTH3 = "<a href=""/cboard/board_list.asp?bname=pds"">자료실</a>"
'				Case "3"
'					DEPTH3 = "<a href=""/cboard/board_list.asp?bname=qna"">1:1상담</a>"
'			End Select
'
'	End Select



'				PRINT TABS(1)& "	<div class=""titleLine"">"
'				PRINT TABS(1)& "		<div class=""fleft"">"&ViewMenuImg&"</div>"
'				PRINT TABS(1)& "		<div class=""fright navi"">"&DEPTH1&" > "&DEPTH2&" > "&DEPTH3&"</div>"
'				PRINT TABS(1)& "	</div>"

%>

