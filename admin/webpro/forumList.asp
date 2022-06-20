<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<!--#include virtual = "/admin/_inc/document.asp"-->
<%
	ADMIN_LEFT_MODE = "WEBPRO"
	INFO_MODE = "WEBPRO2-1"
	W1200 = "T"




	arrList = Db.execRsList("DKP_FORUM_LIST",DB_PROC,Nothing,listLen,Nothing)

%>

<script type="text/javascript" src="forum.js"></script>
<link rel="stylesheet" href="forum.css" />
</head>
<body>
<!--#include virtual = "/admin/_inc/header.asp"-->
<div id="forum" class="list">
	<table <%=tableatt%> class="width100 list">
		<colgroup>
			<col width="50" />
			<col width="120" />
			<col width="60" />
			<col width="180" />
			<col width="90" />
			<col width="120" />
			<col width="60" />
			<col width="330" />
			<col width="50" />
			<col width="50" />
			<col width="90" />
		</colgroup>
		<tr>
			<th>번호</th>
			<th>게시판 아이디</th>
			<th>사용여부</th>
			<th>게시판 이름</th>
			<th>게시판 타입</th>
			<th>카테고리<br />PAGE_SETTING</th>
			<th>Navi</th>
			<th>주소</th>
			<th>게시물</th>
			<th>댓글</th>
			<th>설정</th>
		</tr>
		<%
			If IsArray(arrList) Then
				For i = 0 To listLen
					If arrList(8,i) = "" Or isNull(arrList(8,i)) Then arrList(8,i) = "-"
					If arrList(9,i) = "" Or isNull(arrList(9,i)) Then arrList(9,i) = "-"
					If arrList(10,i) = 0 Or isNull(arrList(10,i)) Then
						arrList(10,i) = ""
					Else
						arrList(10,i) = "/"&arrList(10,i)
					End If

					arrList_isUse = arrList(4,i)
					If arrList_isUse = "T" Then
						arrList_isUseTXT = LNG_STRTEXT_TEXT10
						class_isUse = "radioT"
					Else
						arrList_isUseTXT = LNG_STRTEXT_TEXT11
						class_isUse = "radioF"
					End If

					PRINT "	<tr>"
					PRINT "		<td>"&arrList(0,i)&"</td>"
					PRINT "		<td>"&arrList(1,i)&"</td>"
					PRINT "		<td class="""&class_isUse&""">"&arrList_isUseTXT&"</td>"
					PRINT "		<td>"&arrList(2,i)&"</td>"
					PRINT "		<td>"&arrList(3,i)&"</td>"
					PRINT "		<td>"&arrList(5,i)&"</td>"
					PRINT "		<td class=""tleft"" style=""padding-left:15px;"">"&arrList(8,i)&"/"&arrList(9,i)&arrList(10,i)&"</td>"
					PRINT "		<td class=""tleft"" style=""padding-left:20px;""><a href=""/cboard/board_list.asp?bname="&arrList(1,i)&""" target=""_blank"">/cboard/board_list.asp?bname="&arrList(1,i)&"</a></td>"
					PRINT "		<td>"&arrList(6,i)&"</td>"
					PRINT "		<td>"&arrList(7,i)&"</td>"
					PRINT "		<td><span class=""button medium vmiddle icon""><span class=""check""></span><a href=""forumConfig.asp?bname="&arrList(1,i)&""">설정</a></span></td>"
					'PRINT "		<td><a href=""forumConfig.asp?bname="&arrList(1,i)&""" />설정</a></td>"
					PRINT "	</tr>"
				Next
			Else
				PRINT "	<tr>"
				PRINT "		<td colspan=""11"">등록된 포럼(게시판)이 없습니다.</td>"
				PRINT "	</tr>"

			End If
		%>
	</table>
</div>
<!--#include virtual = "/admin/_inc/copyright.asp"-->
