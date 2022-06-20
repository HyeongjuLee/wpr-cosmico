<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<!--#include virtual = "/admin/_inc/document.asp"-->
<%
' ===================================================================
' 게시판 변수 받아오기(설정)
' ===================================================================
	Dim popWidth,popHeight
		popWidth = 700
		popHeight = 600

	Dim PAGE, PAGESIZE,IDV
		PAGE = Request.Form("page")
		PAGESIZE = 10
		IDV = gRequestTF("idv",True)

	If PAGE="" Then PAGE = 1 End If

' ===================================================================
' ===================================================================
' 데이터 가져오기
' ===================================================================
	arrParams = Array( _
		Db.makeParam("@PAGE",adInteger,adParamInput,0,PAGE), _
		Db.makeParam("@PAGESIZE",adInteger,adParamInput,0,PAGESIZE), _
		Db.makeParam("@strUserID",adVarChar,adParamInput,30,IDV),_
		Db.makeParam("@ALL_COUNT",adInteger,adParamOutput,0,0) _

	)
	arrList = Db.execRsList("DKP_ADMIN_MEMBER_MEMO_LIST",DB_PROC,arrParams,listLen,Nothing)

	All_Count = arrParams(3)(4)

' ===================================================================
		Dim PAGECOUNT,CNT
		PAGECOUNT = Int((CCur(All_Count) - 1 ) / CInt(PAGESIZE) ) + 1
		IF CCur(PAGE) = 1 Then
			CNT = All_Count
		Else
			CNT = All_Count - ((CCur(PAGE)-1)*CInt(PAGESIZE)) '
		End If


%>
<script type="text/javascript" src="/admin/jscript/member.js"></script>
<link rel="stylesheet" href="/admin/css/member.css" />
</head>
<body>
<div id="pop_all">
	<div class="top"><%=viewImg(IMG_POP&"/tit_member_memo_list.jpg",250,40,"")%></div>
	<div class="input_area">
		<form name="frmS" method="post" action="pop_memo_write.asp" onsubmit="return chkIn(this);">
			<input type="hidden" name="sui" value="<%=idv%>" />
			<input type="text" name="strMemo" class="input_text vtop insert_bg_js" style="width:600px;background:#fff url(/images/admin/pop/input_bg.gif) 0 0 no-repeat;" onfocus="bgDel(this);" onblur="bgChg(this,'memo');" /><input type="image" src="<%=IMG_BTN%>/btn_insert_01.gif" class="vtop" />
		</form>
	</div>
	<div class="list_area">
		<div class="counter"><%=spans(IDV,"#4b86af",9,"bold")%> 회원에 대한 <%=spans(All_Count,"#104f7b",9,"bold")%> 개의 메모가 있습니다.</div>
		<table <%=tableatt%> class="tables1" style="width:100%">
			<colgroup>
				<col width="23%" />
				<col width="67%" />
				<col width="10%" />
			</colgroup>
			<thead>
				<tr>
					<th>작성일</th>
					<th>내용</th>
					<th>삭제</th>
				</tr>
			</thead>
			<tbody>
				<%
					If IsArray(arrList) Then
						For i = 0 To listLen
							PRINT "				<tr>" & VbCrlf
							PRINT "					<td>"&arrList(3,i)&"</td>" & VbCrlf
							PRINT "					<td>"&arrList(1,i)&"</td>" & VbCrlf
							PRINT "					<td><a href=""pop_memo_delete.asp?num="&arrList(0,i)&"&amp;idv="&IDV&""">삭제</a></td>" & VbCrlf
							PRINT "				</tr>" & VbCrlf
						Next
					Else
						PRINT "				<tr>" & VbCrlf
						PRINT "					<td colspan=""3"" class=""tcenter"" style=""padding:40px 0px;"">작성된 메모가 없습니다.</td>" & VbCrlf
						PRINT "				</tr>" & VbCrlf
					End If

				%>
			</tbody>
		</table>
	</div>
	<div class="paging_area">
		<%Call pageList(PAGE,PAGECOUNT)%>
		<form name="frm" method="post" action="">
			<input type="hidden" name="PAGE" value="<%=PAGE%>" />
		</form>
	</div>
	<div class="bottom">
		<div class="info"><%=viewImg(IMG_POP&"/pop_bottom_info.gif",160,60,"")%></div>
		<div class="btn_area"><%=aImgSt("javascript:self.close()",IMG_BTN&"/btn_close_01.gif",52,23,"","margin-top:20px;margin-right:20px;","")%></div>

	</div>
</div>

<script type="text/javascript">
<!--
resizePopupWindow(parseInt("<%=popWidth%>", 10), parseInt("<%=popHeight%>", 10));
//-->
</script>
</body>
</html>
