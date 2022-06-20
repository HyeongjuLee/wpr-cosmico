<ul class="tabs">
	<li <%if view = "1" Then%>class="on"<%end if%>><a href="forumConfig.asp?bname=<%=strBoardName%>">게시판 기본설정</a></li>
	<li <%if view = "2" then%>class="on"<%end if%>><a href="forumLevelConfig.asp?bname=<%=strBoardName%>">게시판 권한설정</a></li>
	<li <%if view = "3" then%>class="on"<%end if%>><a href="forumWriteConfig.asp?bname=<%=strBoardName%>">게시판 쓰기설정</a></li>
	<li <%if view = "4" then%>class="on"<%end if%>><a href="forumViewConfig.asp?bname=<%=strBoardName%>">게시판 보기설정</a></li>
<!-- 	<li <%if view = "5" then%>class="on"<%end if%>><a href="forumCategoryConfig.asp?bname=<%=strBoardName%>">카테고리설정</a></li> -->
	<li <%If view = "6" then%>class="on"<%End if%>><a href="forumPointConfig.asp?bname=<%=strBoardName%>">게시판 포인트설정</a></li>
	<!-- <li <%If view = "7" then%>class="on"<%End if%>><a href="forumLimitConfig.asp?bname=<%=strBoardName%>">게시판 제약사항설정</a></li> 분리보류-->
	<li style="padding-left:7px; padding-right:7px;">QUICK MOVE :
		<select name="quickBBSList" id="quickBBSList" onchange="javascript:moveBBS();">
		<%
			arrList = Db.execRsList("DKP_FORUM_LIST",DB_PROC,Nothing,listLen,Nothing)
			If IsArray(arrList) Then
				For i = 0 To listLen
					If arrList(8,i) = "" Or isNull(arrList(8,i)) Then arrList(8,i) = "-"
					If arrList(9,i) = "" Or isNull(arrList(9,i)) Then arrList(9,i) = "-"
					If arrList(10,i) = 0 Or isNull(arrList(10,i)) Then
						arrList(10,i) = ""
					Else
						arrList(10,i) = "/"&arrList(10,i)
					End If
					PRINT "	<option value="""&arrList(1,i)&""" "&isSelect(strBoardName,arrList(1,i))&">"&arrList(2,i)&"</option>"
				Next

			End If
		%>
		</select>
	</li>
</ul>
<script type="text/javascript">
	function moveBBS() {
		var val = document.getElementById('quickBBSList').value;
		document.location.href = window.location.pathname + '?bname='+ val;

	}
</script>