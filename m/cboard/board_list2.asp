<!--#include virtual="/_lib/strFunc.asp" -->

<%
	ADMIN_LEFT_MODE = "MYOFFICE"
	INFO_MODE = "MYOFFICE2-2"


	Dim SEARCHTERM, SEARCHSTR, PAGE, PAGESIZE
		SEARCHTERM = Request.Form("SEARCHTERM")
		SEARCHSTR = Request.Form("SEARCHSTR")
		PAGE = Request.Form("page")
		PAGESIZE = 15

		strBoardName = gRequestTF("bname",True)

		Select Case strBoardName
			Case "notice_a"
				PALN_TYPE =	"<span class=""red"">(A플랜)</span>"
			Case "notice_b"
				PALN_TYPE =	"<span class=""red"">(B플랜)</span>"
		End Select
		
'		If strBoardName = "notice_b" Then
'			PALN_TYPE =	"<span class=""red"">(B플랜)</span>"
'		End If

		If SEARCHTERM = "" Then SEARCHTERM = "" End If
		If SEARCHSTR = "" Then SEARCHSTR = "" End if
		If PAGE="" Then PAGE = 1 End If




		arrParams = Array( _
			Db.makeParam("@strBoardName",adVarChar,adParamInput,50,strBoardName), _
			Db.makeParam("@SEARCHTERM",adVarChar,adParamInput,30,SEARCHTERM), _
			Db.makeParam("@SEARCHSTR",adVarChar,adParamInput,30,convSql(SEARCHSTR)), _
			Db.makeParam("@PAGESIZE",adInteger,adParamInput,0,PAGESIZE), _
			Db.makeParam("@PAGE",adInteger,adParamInput,0,PAGE), _
			Db.makeParam("@All_Count",adInteger,adParamOutPut,0,0) _
		)
		arrList = Db.execRsList("DKPA_MYOFFICE_BOARD_LIST",DB_PROC,arrParams,listLen,Nothing)
		All_Count = arrParams(UBound(arrParams))(4)


		Dim PAGECOUNT,CNT
		PAGECOUNT = int((ccur(All_Count) - 1 ) / CInt(PAGESIZE) ) + 1
		IF CCur(PAGE) = 1 Then
			CNT = All_Count
		Else
			CNT = All_Count - ((CCur(PAGE)-1)*CInt(PAGESIZE)) '
		End If

%>
<!--#include virtual = "/_inc/document.asp"-->
<!--#include virtual = "/_inc/jqueryload.asp"-->
<link rel="stylesheet" href="board2.css" />
<script type="text/javascript" src="board.js"></script>

</head>
<body>
<!--#include virtual = "/_inc/header.asp"-->
<!--#include virtual = "/_inc/sub_header.asp"-->

<div id="board">
	<p class="titles">게시물 검색 <%=PALN_TYPE%></p>
	<form name="sfrm" action="" method="post">
		<table <%=tableatt%> class="adminFullTable search">
			<colgroup>
				<col width="220" />
				<col width="*" />
			</colgroup>
			<tr>
				<th>조건검색</th>
				<td style="padding-left:7px;">
					<select name="SEARCHTERM" class="vtop">
						<option value="" <%=isSelect(SEARCHTERM,"")%>>==조건을 선택해주세요==</option>
						<option value="strSubject" <%=isSelect(SEARCHTERM,"strSubject")%>>제목으로 검색</option>
						<option value="strContent" <%=isSelect(SEARCHTERM,"strContent")%>>내용으로 검색</option>
					</select>
					<input type="text" name="SEARCHSTR" class="input_text vtop" style="width:200px;" value="<%=SEARCHSTR%>" />
					<input type="image" src="<%=IMG_BTN%>/btn_search.gif" class="vtop" />
					<%=aImgOPT(Request.ServerVariables("SCRIPT_NAME"),"S",IMG_BTN&"/search_reset.gif",80,23,"","class=""vtop""")%>
				</td>
			</tr>
		</table>
	</form>

	<p class="titles">게시물 목록</p>

	<table <%=tableatt%> class="adminFullWidth list">
		<col width="6%" />
		<col width="*" />
		<col width="15%" />
		<col width="12%" />
		<col width="8%" />
		<tr>
			<th>번호</th>
			<th>제목</th>
			<th>작성자</th>
			<th>작성일</th>
			<th>조회수</th>
		</tr>
		<%
			If IsArray(arrList) Then
				For i = 0 To listLen

					arrList_intNum				= ALL_COUNT - CInt(arrList(0,i)) + 1
					arrList_intIDX				= arrList(1,i)
					arrList_strBoardName		= arrList(2,i)
					arrList_strName				= arrList(3,i)
					arrList_strSubject			= arrList(4,i)
					arrList_strContent			= arrList(5,i)
					arrList_regDate				= arrList(6,i)
					arrList_readCnt				= arrList(7,i)
					arrList_strData1			= arrList(8,i)
					arrList_strData2			= arrList(9,i)

				If arrList_strData1 <> "" Then
					file_icon = "<img src=""/images/files.gif"" width=""10"" height=""10"" class=""vmiddle"" alt=""파일이 첨부된 게시물입니다."" />"
				Else
					file_icon = ""
				End If

		%>
		<tr>
			<td class="tcenter"><%=arrList_intNum%></td>
			<td><a href="board_view2.asp?bname=<%=strBoardName%>&amp;num=<%=arrList_intIDX%>"><%=backword(arrList_strSubject)%></a> <%=file_icon%></td>
			<td class="tcenter"><%=arrList_strName%></td>
			<td class="tcenter"><%=Left(arrList_regDate,10)%></td>
			<td class="tcenter"><%=arrList_readCnt%></td>
		</tr>
		<%
				Next
			Else
		%>
		<tr>
			<td colspan="5" class="notData">데이터가 없습니다.</td>
		</tr>
		<%
			End If

		%>

	</table>
	<div class="pageArea2"><%Call pageList(PAGE,PAGECOUNT)%></div>
</div>
<form name="frm" method="post" action="">
	<input type="hidden" name="PAGE" value="<%=PAGE%>" />
	<input type="hidden" name="SEARCHTERM" value="<%=SEARCHTERM%>" />
	<input type="hidden" name="SEARCHSTR" value="<%=SEARCHSTR%>" />
</form>
<!--#include virtual = "/_inc/copyright.asp"-->
