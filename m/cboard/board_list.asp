<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	strBoardName = gRequestTF("bname",True)
	intCate = Request("Cate")
%>
<!--#include file="board_config.asp"-->
<%
	Select Case DK_MEMBER_TYPE
		Case "MEMBER","GUEST","COMPANY","COMPANY_LINK"
		'	If DK_MEMBER_LEVEL < intLevelList Then Call ALERTS("게시판보기 권한이 없습니다. 관리자에게 문의해주세요.","back","")
			If DK_MEMBER_LEVEL < intLevelList Then Call ONLY_BUSINESS_MEMBER(DK_MEMBER_LEVEL,intLevelList)
			'If DK_MEMBER_LEVEL < intLevelList Then Call ALERTS(LNG_BOARD_LIST_TEXT01,"back","")
		Case "ADMIN","OPERATOR"

		Case "SADMIN"
			If UCase(DK_MEMBER_GROUP) <> LOCATIONS Then
				If DK_MEMBER_LEVEL < intLevelList Then Call ALERTS(LNG_BOARD_LIST_TEXT01,"back","")
			End If
	End Select


	Dim SEARCHTERM, SEARCHSTR, PAGE, PAGESIZE
		SEARCHTERM = Request.Form("SEARCHTERM")
		SEARCHSTR = Request.Form("SEARCHSTR")
		PAGE = Request.Form("page")
		PAGESIZE = intListView

		pagingCLICK = Request.Form("pagingCLICK")


	If SEARCHTERM = "" Then SEARCHTERM = "" End If
	If SEARCHSTR = "" Then SEARCHSTR = "" End if
	If PAGE="" Then PAGE = 1 End If
	If intCate = "" Then intCate = "" End If

	Select Case strBoardType
		Case "board","board2"
			FN_PROCEDURE_NAME = "DKP_NBOARD_BOARD_LIST_ORDER1"
		Case "gallery","gallery2"
			'FN_PROCEDURE_NAME = "DKP_NBOARD_GALLERY_LIST2"
			FN_PROCEDURE_NAME = "DKSP_NBOARD_GALLERY_LIST"
		Case "movie","movie2"
			'FN_PROCEDURE_NAME = "DKP_NBOARD_MOVIE_LIST"
			FN_PROCEDURE_NAME = "DKSP_NBOARD_MOVIE_LIST"
	End Select

	arrParams = Array( _
		Db.makeParam("@strBoardName",adVarChar,adParamInput,50,strBoardName), _
		Db.makeParam("@intCate",adInteger,adParamInput,0,intCate), _
		Db.makeParam("@strBoardType",adVarChar,adParamInput,10,strBoardType), _
		Db.makeParam("@SEARCHTERM",adVarChar,adParamInput,30,SEARCHTERM), _
		Db.makeParam("@SEARCHSTR",adVarChar,adParamInput,30,convSql(SEARCHSTR)), _
		Db.makeParam("@PAGESIZE",adInteger,adParamInput,0,PAGESIZE), _
		Db.makeParam("@PAGE",adInteger,adParamInput,0,PAGE), _
		Db.makeParam("@strDomain",adVarChar,adParamInput,50,UCase(DK_MEMBER_NATIONCODE)), _
		Db.makeParam("@GroupData",adVarChar,adParamInput,40,UCase(GroupData)), _
		Db.makeParam("@All_Count",adInteger,adParamOutPut,0,0) _
	)
	arrList = Db.execRsList(FN_PROCEDURE_NAME,DB_PROC,arrParams,listLen,Nothing)
	All_Count = arrParams(UBound(arrParams))(4)

	Dim PAGECOUNT,CNT
	PAGECOUNT = int((ccur(All_Count) - 1 ) / CInt(PAGESIZE) ) + 1
	IF CCur(PAGE) = 1 Then
		CNT = All_Count
	Else
		CNT = All_Count - ((CCur(PAGE)-1)*CInt(PAGESIZE)) '
	End If

%>
<!--#include virtual = "/m/_include/document.asp"-->
<!--#include virtual = "/m/_include/jqueryload.asp"-->

<!-- <link rel="stylesheet" href="/m/css/board.css?" /> -->
<script type="text/javascript" src="board.js?"></script>
</head>
<body>
<!--#include virtual = "/m/_include/header.asp"-->
<!--#include file = "board_search.asp" -->

<%
	Select Case strBoardType
		Case "board"
%>
		<!--#include file = "Type_board.asp" -->

<%		Case "board2"%>
		<!--#include file = "Type_board2.asp" -->

<%		Case "gallery","movie"%>
		<!--#include file = "Type_gallery.asp" -->

<%		Case "gallery2","movie2"%>						<!-- 2개씩 -->
		<!--#include file = "Type_gallery2.asp" -->

<%End Select%>
</div>

<!--#include virtual = "/m/_include/copyright.asp"-->






