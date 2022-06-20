<!--#include virtual = "/_lib/strFunc.asp"-->
<%IF CONST_MOBILE_ONLY = "T" Then%>
<!--#include virtual="/admin/_inc/adminPath.asp" -->
<%End If%>
<%
	PAGE_SETTING = "MYPAGE"
	ISLEFT = "T"
	ISSUBTOP = "T"
	ISSUBVISUAL = "F"


	mNum = mainVar

	tdHeight = 28


	Call ONLY_BUSINESS_MEMBER(DK_MEMBER_LEVEL,1)

	cmt = gRequestTF("cmt",False)
	If UCase(cmt) = "T" Then
		'▣▣▣ 내가작성한 댓글(comment) 보기
		PROC_NBOARD_BOARD_LIST_MY	= "HJP_NBOARD_BOARD_LIST_MY_COMMENT_POST"
		MYPAGE_MY_POST_TITLE		= LNG_MYPAGE_MY_COMMENT_POST

		view = 7
	Else
		'▣▣▣ 내가작성한 글보기
		PROC_NBOARD_BOARD_LIST_MY	= "HJP_NBOARD_BOARD_LIST_MY_POST"
		MYPAGE_MY_POST_TITLE		= LNG_MYPAGE_MY_POST

		view = 6
	End If

%>
<%IF CONST_MOBILE_ONLY = "T" Then%>
<!--#include virtual = "/admin/_inc/document.asp"-->
<%Else%>
<!--#include virtual = "/_include/document.asp"-->
<%End If%>
<link rel="stylesheet" href="css_common.css" />
<%

	Call ONLY_BUSINESS_MEMBER(DK_MEMBER_LEVEL,1)


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
<script type="text/javascript" src="board.js"></script>
<link rel="stylesheet" href="/css/select.css" />
<script type="text/javascript" src="/jscript/jcombox-1.0b.packed.js"></script>
<script type="text/javascript">
	$(function(){
		/* 기본 */
		//$('.select').jcombox();
	});

	function ChkvFrm(f) {
		if (f.strPass.value=='')
		{
			alert("<%=LNG_BOARD_VIEW_TEXT02%>");
			f.strPass.focus();
			return false;
		}
	}
</script>
</head>
<body>
<!--#include virtual = "/_include/header.asp"-->
<!--#include file = "_inc_board_top.asp" -->

<div id="forum">
<!--#include file = "board_search.asp" -->
<!--#include file = "Type_board_my.asp" -->
</div>
<%IF CONST_MOBILE_ONLY = "T" Then%>
<!--#include virtual = "/admin/_inc/copyright.asp"-->
<%Else%>
<!--#include virtual = "/_include/copyright.asp"-->
<%End If%>
