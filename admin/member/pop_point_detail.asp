<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<!--#include virtual = "/admin/_inc/document.asp"-->
<%
' ===================================================================
' 게시판 변수 받아오기(설정)
' ===================================================================
	Dim popWidth,popHeight
		popWidth = 730
		popHeight = 600

	Dim IDV
		IDV = gRequestTF("idv",True)

' ===================================================================
' ===================================================================
' 데이터 가져오기
' ===================================================================
	PAGE = Trim(pRequestTF("page",False))
	If PAGE = "" Then PAGE = 1
		PAGESIZE = 17
		PAGESUM = PAGESIZE * (PAGE-1)

		'WHERE = " AND (([valueP] IS NOT NULL OR [valueM] IS NOT NULL) AND ([valueP] <> 0 or [valueM] <> 0 )) "

		SQL = "SELECT COUNT(*) FROM [DK_MEMBER_POINT_LOG] WHERE [strUserID] = ? " & WHERE
		arrParams = Array( _
			Db.makeParam("@strID",adVarChar,adParamInput,30,IDV) _
		)
		ALL_COUNT = CInt(Db.execRsData(SQL, DB_TEXT, arrParams, Nothing))
		Dim PAGECOUNT,CNT
		PAGECOUNT = int((ccur(All_Count) - 1 ) / CInt(PAGESIZE) ) + 1
		IF CCur(PAGE) = 1 Then
			CNT = All_Count
		Else
			CNT = All_Count - ((CCur(PAGE)-1)*CInt(PAGESIZE)) '
		End If



		SQL = "SELECT TOP(?) * "
		SQL = SQL & " FROM [DK_MEMBER_POINT_LOG] WHERE [intIDX] NOT IN "
		SQL = SQL & " (SELECT TOP(?)[intIDX] FROM [DK_MEMBER_POINT_LOG] WHERE [strUserID] = ? "&WHERE&" ORDER BY [intIDX] DESC)"
		SQL = SQL & " AND [strUserID] = ? "&WHERE&" ORDER BY [intIDX] DESC "
		arrParams = Array(_
			Db.makeParam("@PAGESIZE",adInteger,adParamInput,4,PAGESIZE), _
			Db.makeParam("@PAGESUM",adInteger,adParamInput,4,PAGESUM), _
			Db.makeParam("@strID",adVarChar,adParamInput,30,IDV), _
			Db.makeParam("@strID",adVarChar,adParamInput,30,IDV) _
		)
		orderList = Db.execRsList(SQL,DB_TEXT,arrParams,orderLen,Nothing)


%>
<script type="text/javascript" src="/admin/jscript/member.js"></script>
<link rel="stylesheet" href="/admin/css/member.css" />
</head>
<body>
<div id="pop_all">
	<div id="pointd">
		<div class="top"><%=viewImg(IMG_POP&"/tit_point_calc.jpg",250,40,"")%></div>
		<div class="pointlog">
			<table <%=tableatt%> class="list">
				<col width="170" />
				<col width="170" />
				<col width="100" />
				<col width="*" />

				<thead>
					<tr>
						<th>일자</th>
						<th>적립내용</th>
						<th>적립/사용금액</th>
						<th>코멘트</th>
					</tr>
				</thead>
				<tfoot>
					<tr>
						<td colspan="6" align="center" height="40"><%Call pageList(PAGE,PAGECOUNT)%></td>
					</tr>
				</tfoot>
				<tbody>
					<%
						If IsArray(orderList) Then
							For i = 0 To orderLen

								PRINT "<tr>"
								PRINT "	<td>"&orderList(4,i)&"</td>"
								PRINT "	<td>"&orderList(3,i)&"</td>"
								PRINT "	<td class=""tweight"">"&num2cur(orderList(2,i))&"</td>"
								PRINT "	<td class=""tweight"">"&orderList(5,i)&"</td>"
								PRINT "</tr>"
							Next
						End If
					%>
				</tbody>
			</table>
			<form name="frm" method="post" action="">
				<input type="hidden" name="PAGE" value="<%=PAGE%>" />
			</form>
		</div>
		<div class="bottom">
			<div class="info"><%=viewImg(IMG_POP&"/pop_bottom_info.gif",160,60,"")%></div>
			<div class="btn_area"><%=aImgSt("javascript:self.close()",IMG_BTN&"/btn_close_01.gif",52,23,"","margin-top:20px;margin-right:20px;","")%></div>

		</div>
	</div>

</div>

<script type="text/javascript">
<!--
resizePopupWindow(parseInt("<%=popWidth%>", 10), parseInt("<%=popHeight%>", 10));
//-->
</script>
</body>
</html>
