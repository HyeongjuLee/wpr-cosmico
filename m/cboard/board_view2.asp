<!--#include virtual="/_lib/strFunc.asp" -->
<%
Response.End
	ADMIN_LEFT_MODE = "MYOFFICE"
	INFO_MODE = "MYOFFICE2-4"


	strBoardName = gRequestTF("bname",True)

	intIDX = gRequestTF("num",True)

	If strBoardName = "notice_b" Then
		PALN_TYPE =	"<span class=""red"">(B플랜)</span>"
	End If

	arrParams = Array(_
		Db.makeParam("@intIDX",adInteger,adParamInput,0,intIDX) _
	)
	Set DKRS = Db.execRs("DKPA_MYOFFICE_BOARD_VIEW",DB_PROC,arrParams,Nothing)
	If Not DKRS.BOF And Not DKRS.EOF Then
		DKRS_intIDX					= DKRS("intIDX")
		DKRS_strBoardName			= DKRS("strBoardName")
		DKRS_strName				= DKRS("strName")
		DKRS_strSubject				= DKRS("strSubject")
		DKRS_strContent				= DKRS("strContent")
		DKRS_regDate				= DKRS("regDate")
		DKRS_readCnt				= DKRS("readCnt")
		DKRS_strData1				= DKRS("strData1")
		DKRS_strData2				= DKRS("strData2")

	Else
		Call ALERTS("존재하지 않는 게시물입니다","back","")
	End If

%>
<!--#include virtual = "/_inc/document.asp"-->
<!--#include virtual = "/_inc/jqueryload.asp"-->
<link rel="stylesheet" href="board2.css" />
<script type="text/javascript" src="board.js"></script>
<script type="text/javascript" src="/common/SmartEditor2/js/HuskyEZCreator.js"></script>

</head>
<body>
<!--#include virtual = "/_inc/header.asp"-->
<!--#include virtual = "/_inc/sub_header.asp"-->
<div id="board">
	<p class="titles">게시물 보기 <%=PALN_TYPE%></p>

	<table <%=tableatt%> class="adminFullWidth regist">
		<col width="18%" />
		<col width="82%" />
		<tr>
			<th>작성자</th>
			<td><%=BACKWORD(DKRS_strName)%></td>
		</tr><tr>
			<th>제목</th>
			<td><%=BACKWORD(DKRS_strSubject)%></td>
		</tr><tr>
			<th>내용</th>
			<td class="contentTD"><%=backword(DKRS_strContent)%></td>
		</tr><!-- <tr>
			<th>첨부파일</th>
			<td><a href="<%=VIR_PATH("myoffice")%>/<%=backword(DKRS_strData1)%>" target="_blank"><%=backword(DKRS_strData1)%></a></td>
		</tr> -->
	</table>
	<div class="btn_area"><%=aImg("board_list.asp?bname="&strBoardName,IMG_BTN&"/btn_rect_list.gif",99,45,"")%>&nbsp;<%=aImg("board_modify.asp?bname="&strBoardName&"&amp;num="&DKRS_intIDX,IMG_BTN&"/btn_rect_change.gif",99,45,"")%>&nbsp;<%=aImg("javascript:ThisDel('"&DKRS_intIDX&"');",IMG_BTN&"/btn_rect_del.gif",99,45,"")%></div>
</div>

<form name="delFrm" action="board_handler.asp" method="post" enctype="multipart/form-data">
	<input type="hidden" name="MODE" VALUE="DELETE" />
	<input type="hidden" name="strBoardName" VALUE="<%=DKRS_strBoardName%>" />
	<input type="hidden" name="intIDX" VALUE="<%=DKRS_intIDX%>" />
	<input type="hidden" name="ostrData1" VALUE="<%=BACKWORD(DKRS_strData1)%>" />
</form>

<!--#include virtual = "/_inc/copyright.asp"-->
