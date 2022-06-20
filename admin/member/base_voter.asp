<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<!--#include virtual = "/admin/_inc/document.asp"-->
<%
	ADMIN_LEFT_MODE = "MEMBER"
	INFO_MODE = "MEMBER3-2"
' ===================================================================
'
' ===================================================================
' ===================================================================






' ===================================================================
' 데이터 가져오기
' ===================================================================

	SQL = "SELECT * FROM [DKT_BASE_VOTER] ORDER BY [intIDX] DESC"
	arrList = Db.execRsList(SQL,DB_TEXT,arrParams,listLen,db3)




%>
<link rel="stylesheet" href="/admin/css/member.css" />
<script>
	function chkRfrm(f) {
		if (f.mbid.value =='')
		{
			alert("회원아이디 1을 입력해주세요");
			f.mbid.focus();
			return false
		}
		if (f.mbid2.value =='')
		{
			alert("회원아이디 2를 입력해주세요");
			f.mbid2.focus();
			return false
		}
	}

</script>
</head>
<body>
<!--#include virtual = "/admin/_inc/header.asp"-->
<div class="member_list">
	<form name="rfrm" action="base_voter_handler.asp" method="post" onsubmit="return chkRfrm(this);">
		<p class="titles">입력<p>
		<table <%=tableatt%> class="width100 search">
			<colgroup>
				<col width="220" />
				<col width="*" />
			</colgroup>
			<tr>
				<th>등록</th>
				<td style="padding:5px 10px;">
					<input type="text" name="mbid" class="input_text" style="width:80px;" value="" /> -
					<input type="text" name="mbid2" class="input_text" style="width:200px;" value="" />
					<input type="submit" class="input_submit design1" value="등록" />
					<p style="margin-top:7px;">회원아이디를 정확하게 입력해주세요</p>

				</td>
			</tr>
		</table>
	</form>


	<p class="titles">기본지정 회원 목록 리스트<p>
	<table <%=tableatt%> class="width100">
		<colgroup>
			<!-- <col width="40" />
			<col width="80" />
			<col width="90" />
			<col width="90" />
			<col width="30" />
			<col width="50" />
			<col width="50" />
			<col width="50" />
			<col width="50" />
			<col width="90" />
			<col width="60" />
			<col width="90" />
			<col width="85" />
			<col width="*" /> -->
			<col width="80" />
			<col width="200" />
			<col width="220" />
			<col width="150" />
			<col width="100" />
			<col width="150" />
			<col width="*" />

		</colgroup>
		<thead>
			<tr>
				<th>Index</th>
				<th>사용여부</th>
				<th>ID</th>
				<th>등록일</th>
			</tr>
		</tr>
	<%
		If IsArray(arrList) Then
			For i = 0 To listLen

				arrList_intIDX			= arrList(0,i)
				arrList_isUse			= arrList(1,i)
				arrList_mbid			= arrList(2,i)
				arrList_mbid2			= arrList(3,i)
				arrList_regDate			= arrList(4,i)

				ThisNum = ALL_COUNT - CInt(arrList(0,i)) + 1
				PRINT "<tr>" & VbCrlf
				PRINT "	<td class=""tcenter"">" & arrList_intIDX &"</td>" &VbCrlf
				PRINT "	<td class=""tcenter"">" & TFVIEWER(arrList_isUse,"USE") &"</td>" &VbCrlf
				PRINT "	<td class=""tcenter"">" & arrList(2,i) &" - " & arrList(3,i) &"</td>" &VbCrlf
				PRINT "	<td class=""tcenter"">" & arrList(4,i) &"</td>" &VbCrlf
				PRINT "</tr>" & VbCrlf
			Next
		Else
			PRINT "<tr>"
			PRINT "	<td colspan=""7"" class=""notData"">등록된 회원이 없습니다</td>"
			PRINT "</tr>"
		End If
	%>
	</table>
	<div class="paging_area">
		<%Call pageList(PAGE,PAGECOUNT)%>
		<form name="frm" method="post" action="">
			<input type="hidden" name="PAGE" value="<%=PAGE%>" />
			<input type="hidden" name="SEARCHTERM" value="<%=SEARCHTERM%>" />
			<input type="hidden" name="SEARCHSTR" value="<%=convSql(SEARCHSTR)%>" />
			<input type="hidden" name="memberType" value="<%=memberType%>" />
			<input type="hidden" name="mid" value="" />
		</form>
	</div>
</div>
<!--#include virtual = "/admin/_inc/copyright.asp"-->
