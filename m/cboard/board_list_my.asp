<!--#include virtual = "/_lib/strFunc.asp"-->
<%

	Call ONLY_BUSINESS_MEMBER(DK_MEMBER_LEVEL,1)


	cmt = gRequestTF("cmt",False)
	If UCase(cmt) = "T" Then
		'▣▣▣ 내가작성한 댓글(comment) 보기
		PROC_NBOARD_BOARD_LIST_MY	= "HJP_NBOARD_BOARD_LIST_MY_COMMENT_POST"
		MYPAGE_MY_POST_TITLE		= LNG_MYPAGE_MY_COMMENT_POST
	Else
		'▣▣▣ 내가작성한 글보기
		PROC_NBOARD_BOARD_LIST_MY	= "HJP_NBOARD_BOARD_LIST_MY_POST"
		MYPAGE_MY_POST_TITLE		= LNG_MYPAGE_MY_POST
	End If


	Dim SEARCHTERM, SEARCHSTR, PAGE, PAGESIZE
		SEARCHTERM	= Request.Form("SEARCHTERM")
		SEARCHSTR	= Request.Form("SEARCHSTR")
		PAGE		= Request.Form("page")
		PAGESIZE	= 100

		pagingCLICK = Request.Form("pagingCLICK")


	If SEARCHTERM = "" Then SEARCHTERM = "" End If
	If SEARCHSTR = "" Then SEARCHSTR = "" End if
	If PAGE="" Then PAGE = 1 End If
	If intCate = "" Then intCate = "" End If


	strBoardType = ""


	arrParams = Array( _
		Db.makeParam("@strUserID",adVarChar,adParamInput,30,DK_MEMBER_ID), _
		Db.makeParam("@intCate",adInteger,adParamInput,0,intCate), _
		Db.makeParam("@strBoardType",adVarChar,adParamInput,10,strBoardType), _
		Db.makeParam("@SEARCHTERM",adVarChar,adParamInput,30,SEARCHTERM), _
		Db.makeParam("@SEARCHSTR",adVarChar,adParamInput,30,convSql(SEARCHSTR)), _
		Db.makeParam("@PAGESIZE",adInteger,adParamInput,0,PAGESIZE), _
		Db.makeParam("@PAGE",adInteger,adParamInput,0,PAGE), _
		Db.makeParam("@strDomain",adVarChar,adParamInput,50,UCase(DK_MEMBER_NATIONCODE)), _
		Db.makeParam("@All_Count",adInteger,adParamOutPut,0,0) _
	)
	'arrList = Db.execRsList("HJP_NBOARD_BOARD_LIST_MY",DB_PROC,arrParams,listLen,Nothing)
	arrList = Db.execRsList(PROC_NBOARD_BOARD_LIST_MY,DB_PROC,arrParams,listLen,Nothing)	'본인 or 본인이 작성한(다른회원의)댓글
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

<link rel="stylesheet" href="board.css?v1" />
<script type="text/javascript" src="board.js?v1"></script>
</head>
<body>
<!--#include virtual = "/m/_include/header.asp"-->
<!--#include virtual = "/m/_include/sub_header.asp"-->
<div id="b_title" class="cleft">
	<h3 class="fleft"><span class="h3color1"><%=MYPAGE_MY_POST_TITLE%></span></h3>
</div>
<div id="subTitle" class="width100 tcenter text_noline" ><%=MYPAGE_MY_POST_TITLE%></div>

<!--#include file = "board_search.asp" -->
<!--#include file = "Type_board_my.asp" -->



<!--#include virtual = "/m/_include/copyright.asp"-->






