<!--#include virtual = "/_lib/strFunc.asp"-->
<%
'플래시 사용. 향후 사용금지
Response.End
%><%
	PAGE_SETTING = "COMPANY"
	ISLEFT = "T"
	ISSUBTOP = "T"
	ISSUBVISUAL = "T"

	view = 7 'gRequestTF("view",True)
	mNum = 1


	BranchCode = gRequestTF("code",False)

	If BranchCode = "" Then BranchCode = ""
	Dim SEARCHTERM, SEARCHSTR, PAGE, PAGESIZE
		SEARCHSTR  = Request.Form("SEARCHSTR")		'검색어
		SEARCHTERM = Request.Form("SEARCHTERM")		'옵션(지사이름/지사장명)
		PAGE	   = Request.Form("page")
		PAGESIZE   = 10

	If SEARCHTERM = "" Then SEARCHTERM = "" End If
	If SEARCHSTR = "" Then SEARCHSTR = "" End if
	If PAGE="" Then PAGE = 1 End If
	If BranchCode = "" Then BranchCode = ""

	arrParams = Array( _
		Db.makeParam("@PAGE",adInteger,adParamInput,0,PAGE), _
		Db.makeParam("@PAGESIZE",adInteger,adParamInput,0,PAGESIZE), _
		Db.makeParam("@SEARCHSTR",adVarChar,adParamInput,30,convSql(SEARCHSTR)), _
		Db.makeParam("@SEARCHTERM",adVarChar,adParamInput,30,SEARCHTERM), _
		Db.makeParam("@cateCode",adVarChar,adParamInput,20,BranchCode), _
		Db.makeParam("@ALL_COUNT",adInteger,adParamOutput,0,0) _
	)
		arrList = Db.execRsList("DKP_BRANCH_LIST_SEARCH",DB_PROC,arrParams,listLen,Nothing)

	All_Count = arrParams(UBound(arrParams))(4)
		Dim PAGECOUNT,CNT
		PAGECOUNT = Int((CCur(All_Count) - 1 ) / CInt(PAGESIZE) ) + 1
		IF CCur(PAGE) = 1 Then
			CNT = All_Count
		Else
			CNT = All_Count - ((CCur(PAGE)-1)*CInt(PAGESIZE)) '
		End If

%>
<!--#include virtual = "/_include/document.asp"-->
<link rel="stylesheet" href="branch.css" />

<script type="text/javascript">
<!--

//-->
</script>
</head>
<body>
<!--#include virtual = "/_include/header.asp"-->
<div class="clear">
<p><%=viewImg(IMG_CONTENT&"/company_07_tit.jpg",780,40,"")%></p>

<%

	PAGE_NUM = 2
	Select Case PAGE_SETTING
		Case "COMPANY"
			li_class_num1 = "off"
			li_class_num2 = "off"

			Select Case PAGE_NUM
				Case 1 : li_class_num1 = "on"
				Case 2 : li_class_num2 = "on"
			End Select
	End Select

%>

	<div class="sub_nav cleft" style="margin-bottom:15px;">
		<ul>
			<li class="<%=li_class_num1%>"><a href="http://sidshop.co.kr/branch/branch.asp" >지도로 찾기</a></li>
			<li class="<%=li_class_num2%>"><a href="http://sidshop.co.kr/branch/branch_search.asp" >검색어로 찾기</a></li>
		</ul>
	</div>

	<form name="sfrm" action="branch_search.asp" method="post">
		<table <%=tableatt%> class="searchFullWidth search">
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
						<option value="strBranchLocation" <%=isSelect(SEARCHTERM,"strBranchLocation")%>>지역 이름(주소)으로 검색</option>
					</select>
					<input type="text" name="SEARCHSTR" class="input_text" style="width:200px;" value="<%=SEARCHSTR%>" />
					<input type="image" src="<%=IMG_BTN%>/btn_search.gif" />
					<%=aImg(Request.ServerVariables("SCRIPT_NAME"),IMG_BTN&"/search_reset.gif",80,23,"")%>
				</td>
			</tr>
		</table>
	</form>

	<div class="clear" style="">
		<div class="clear" style="margin-top:25px;"><%=viewImg("./images/tit_page4_2_01.gif",170,25,"")%></div>
		<div id="BranchList">
			<table <%=tableatt%> class="userCWidth2">
				<col width="150" />
				<col width="140" />
				<col width="300" />
				<col width="130" />
				<tr>
					<th>지역</th>
					<th>지사명</th>
					<th>연락처/주소</th>
					<th>보기</th>
				</tr>
				<%
					If IsArray(arrList) Then
						For i = 0 To listLen

				%>
				<tr>
					<td rowspan="2"><%=arrList(2,i)%></td>
					<td rowspan="2"><%=arrList(3,i)%></td>
					<td><%=arrList(8,i)%></td>
					<td rowspan="2"><%=aImg("javascript:popBranch('"&arrList(1,i)&"')","./images/btn_branchView.jpg",83,40,"")%></td>
				</tr><tr>
					<td><%=arrList(5,i)%>&nbsp;<%=arrList(6,i)%></td>
				</tr>

				<%
						Next
					Else
				%>
				<tr>
					<td colspan="4" class="notData">해당 지역에 등록된 지사가 없습니다</td>
				</tr>
				<%
					End If
				%>
			</table>
			<div class="pageArea2"><%Call pageList(PAGE,PAGECOUNT)%></div>
		</div>
	</div>

</div>


<form name="frm" method="post" action="">
	<input type="hidden" name="PAGE" value="<%=PAGE%>" />
	<input type="hidden" name="SEARCHTERM" value="<%=SEARCHTERM%>" />
	<input type="hidden" name="SEARCHSTR" value="<%=convSql(SEARCHSTR)%>" />
</form>
<!--#include virtual = "/_include/copyright.asp"-->


