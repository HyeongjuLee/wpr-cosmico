<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<!--#include virtual = "/admin/_inc/document.asp"-->
<%
	ADMIN_LEFT_MODE = "MANAGE"
	INFO_MODE = "MANAGE4-1"


' ===================================================================
' 게시판 변수 받아오기(설정)
' ===================================================================
	Dim SEARCHTERM, SEARCHSTR, PAGE, PAGESIZE
		SEARCHTERM = Request.Form("SEARCHTERM")
		SEARCHSTR = Request.Form("SEARCHSTR")
		PAGE = Request.Form("page")
		PAGESIZE = 16

	If SEARCHTERM = "" Then SEARCHTERM = "" End If
	If SEARCHSTR = "" Then SEARCHSTR = "" End if
	If PAGE="" Then PAGE = 1 End If
	If BranchCode = "" Then BranchCode = ""

	arrParams = Array( _
		Db.makeParam("@PAGE",adInteger,adParamInput,0,PAGE), _
		Db.makeParam("@PAGESIZE",adInteger,adParamInput,0,PAGESIZE), _
		Db.makeParam("@SEARCHSTR",adVarChar,adParamInput,30,convSql(SEARCHSTR)), _
		Db.makeParam("@SEARCHTERM",adVarChar,adParamInput,30,SEARCHTERM), _
		Db.makeParam("@BranchCode",adVarChar,adParamInput,20,BranchCode), _
		Db.makeParam("@ALL_COUNT",adInteger,adParamOutput,0,0) _

	)
	arrList = Db.execRsList("DKPA_BRANCH_LIST",DB_PROC,arrParams,listLen,Nothing)

	All_Count = arrParams(UBound(arrParams))(4)
		Dim PAGECOUNT,CNT
		PAGECOUNT = Int((CCur(All_Count) - 1 ) / CInt(PAGESIZE) ) + 1
		IF CCur(PAGE) = 1 Then
			CNT = All_Count
		Else
			CNT = All_Count - ((CCur(PAGE)-1)*CInt(PAGESIZE)) '
		End If

%>
<link rel="stylesheet" href="/admin/css/branch.css">
<script type="text/javascript" src="/admin/jscript/branch.js"></script>
</head>
<body>
<!--#include virtual = "/admin/_inc/header.asp"-->
<div id="bracn_regist">
	<form name="sfrm" action="branch_list.asp" method="post">
		<p class="titles">검색<p>
		<table <%=tableatt%> class="adminFullTable search">
			<colgroup>
				<col width="220" />
				<col width="*" />
			</colgroup>
			<tr>
				<th>조건검색</th>
				<td>
					<select name="SEARCHTERM">
						<option value="" <%=isSelect(SEARCHTERM,"")%>>==조건을 선택해주세요==</option>
						<option value="strBranchName" <%=isSelect(SEARCHTERM,"strBranchName")%>>지사 이름으로 검색</option>
						<option value="strBranchOwner" <%=isSelect(SEARCHTERM,"strBranchOwner")%>>지사장 이름으로 검색</option>
					</select>
					<input type="text" name="SEARCHSTR" class="input_text" style="width:200px;" value="<%=SEARCHSTR%>" />
					<input type="image" src="<%=IMG_BTN%>/btn_search.gif" />
					<%=aImg(Request.ServerVariables("SCRIPT_NAME"),IMG_BTN&"/search_reset.gif",80,23,"")%>
				</td>
			</tr>
		</table>
	</form>

	<p class="titles">리스트<p>
	<table <%=tableatt%> class="adminFullTable list">
		<colgroup>
			<col width="65" />
			<col width="140" />
			<col width="130" />
			<col width="100" />
			<col width="100" />
			<col width="320" />
			<col width="70" />
			<col width="*" />
		</colgroup>
		<thead>
			<tr>
				<th>번호</th>
				<th>지역</th>
				<th>지사이름</th>
				<th>지사장명</th>
				<th>지사연락처</th>
				<th>지사주소</th>
				<th>지도</th>
				<th>상세보기</th>
			</tr>
		</thead>
		<%
			If IsArray(arrList) Then
				For i = 0 To listLen

				ThisNum = All_Count - cInt(arrList(0,i)) + 1
				If arrList(10,i) <> "" Then
					isMap = "등록"
				Else
					isMap = "미등록"
				End If
		%>
		<tr class="datas">
			<td><%=ThisNum%></td>
			<td><%=arrList(11,i)%></td>
			<td><%=arrList(3,i)%></td>
			<td><%=arrList(7,i)%></td>
			<td><%=arrList(8,i)%></td>
			<td>(<%=arrList(4,i)%>) <%=arrList(5,i)%>&nbsp;<%=arrList(6,i)%></td>
			<td><%=isMap%></td>
			<td><%=aImg("branch_view.asp?idx="&arrList(1,i),IMG_BTN&"/btn_gray_detailView.gif",70,22,"")%></td>
		</tr>
		<%
				Next
			Else
		%>
		<tr>
			<td colspan="10" align="center" style="height:150px;">현재 등록된 지사가 없습니다.</td>
		</tr>
		<%
			End If
		%><tr>
			<td colspan="8" align="center" style="height:45px; border:none;"><%Call pageList(PAGE,PAGECOUNT)%></td>
		</tr>
	</table>
</div>
<form name="frm" method="post" action="">
	<input type="hidden" name="PAGE" value="<%=PAGE%>" />
	<input type="hidden" name="SEARCHTERM" value="<%=SEARCHTERM%>" />
	<input type="hidden" name="SEARCHSTR" value="<%=convSql(SEARCHSTR)%>" />
</form>
<!--#include virtual = "/admin/_inc/copyright.asp"-->
