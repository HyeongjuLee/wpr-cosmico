<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	ADMIN_LEFT_MODE = "MENU1"
	INFO_MODE = "MENU1-2-3"
	Call ONLY_MEMBER()

%>
<!--#include virtual = "/_include/document.asp"-->
</head>
<body>
<!--#include virtual = "/_include/header.asp"-->
<div id="member" class="member_vote">
<%
	arrParams = Array(_
		Db.makeParam("@mbid",adVarChar,adParamInput,20,DK_MEMBER_ID1), _
		Db.makeParam("@mbid2",adInteger,adParamInput,0,DK_MEMBER_ID2) _
	)
	arrList = Db.execRsList("HJP_PV_BY_GRADE_LEFT",DB_PROC,arrParams,listLen,Nothing)
%>
	<p class="titles">후원 좌 직급대비 실적</p>
	<table <%=tableatt%> class="adminFullWidth">
		<col width="100" />
		<col width="400" />
		<col width="500" />
		<tr>
			<!-- <th>라인</th> -->
			<th>회원등급</th>
			<th>직급</th>
			<th>PV 합계</th>
			<!-- <th>등록일</th>
			<th>주민번호앞자리</th> -->
		</tr>
		<%
			If IsArray(arrList) Then
				For i = 0 To listLen
					If arrList(0,i) = 0 Then
						arrList(1,i) = "직급없음"
					End If

					PRINT TABS(1) & "	<tr>"
'					PRINT TABS(1) & "		<td>"&i+1&"</td>"
					PRINT TABS(1) & "		<td>"&arrList(0,i)&"</td>"
					PRINT TABS(1) & "		<td>"&arrList(1,i)&"</td>"
					PRINT TABS(1) & "		<td>"&num2cur(arrList(2,i))&" PV</td>"
'					PRINT TABS(1) & "		<td>"&date8to10(arrList(3,i))&"</td>"
'					PRINT TABS(1) & "		<td>"&Left(arrList(4,i),6)&"</td>"
					PRINT TABS(1) & "	</tr>"
				Next
			Else
					PRINT TABS(1)& "	<tr>"
					PRINT TABS(1)& "		<td colspan=""3"" class=""notData"">후원 좌 직급대비 실적이 없습니다.</td>"
					PRINT TABS(1)& "	</tr>"
			End If
		%>

	</table>
</div>
<div id="member" class="member_vote">
<%
'	SQL = "SELECT [mbid],[mbid2],[M_Name],[Regtime],[cpno],[hptel] FROM [tbl_memberinfo] WHERE [NOMINID] = ? AND [NOMINID2] = ?"
	arrParams = Array(_
		Db.makeParam("@mbid",adVarChar,adParamInput,20,DK_MEMBER_ID1), _
		Db.makeParam("@mbid2",adInteger,adParamInput,0,DK_MEMBER_ID2) _
	)
	arrList = Db.execRsList("HJP_PV_BY_GRADE_RIGHT",DB_PROC,arrParams,listLen,Nothing)
%>
	<p class="titles">후원 우 직급대비 실적</p>
	<table <%=tableatt%> class="adminFullWidth">
		<col width="100" />
		<col width="400" />
		<col width="500" />
		<tr>
			<!-- <th>라인</th> -->
			<th>회원등급</th>
			<th>직급</th>
			<th>PV 합계</th>
			<!-- <th>등록일</th>
			<th>주민번호앞자리</th> -->
		</tr>
		<%
			If IsArray(arrList) Then
				For i = 0 To listLen
					If arrList(0,i) = 0 Then
						arrList(1,i) = "직급없음"
					End If

					PRINT TABS(1) & "	<tr>"
'					PRINT TABS(1) & "		<td>"&i+1&"</td>"
					PRINT TABS(1) & "		<td>"&arrList(0,i)&"</td>"
					PRINT TABS(1) & "		<td>"&arrList(1,i)&"</td>"
					PRINT TABS(1) & "		<td>"&num2cur(arrList(2,i))&" PV</td>"
'					PRINT TABS(1) & "		<td>"&date8to10(arrList(3,i))&"</td>"
'					PRINT TABS(1) & "		<td>"&Left(arrList(4,i),6)&"</td>"
					PRINT TABS(1) & "	</tr>"
				Next
			Else
					PRINT TABS(1)& "	<tr>"
					PRINT TABS(1)& "		<td colspan=""3"" class=""notData"">후원 우 직급대비 실적이 없습니다.</td>"
					PRINT TABS(1)& "	</tr>"
			End If
		%>

	</table>
</div>
<!--#include virtual = "/_include/copyright.asp"-->
