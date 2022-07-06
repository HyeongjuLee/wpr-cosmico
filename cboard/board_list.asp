<!--#include virtual = "/_lib/strFunc.asp"-->
<%IF CONST_MOBILE_ONLY = "T" Then%>
<!--#include virtual="/admin/_inc/adminPath.asp" -->
<%End If%>
<%
	strBoardName = gRequestTF("bname",True)
	intCate = Request("Cate")
%>
<!--#include file = "board_config.asp"-->
<%IF CONST_MOBILE_ONLY = "T" Then%>
<!--#include virtual = "/admin/_inc/document.asp"-->
<%Else%>
<!--#include virtual = "/_include/document.asp"-->
<%End If%>
<link rel="stylesheet" href="css_common.css?v5" />
<link rel="stylesheet" href="/css/board.css?" />

<%

	Select Case DK_MEMBER_TYPE
		Case "MEMBER","GUEST","COMPANY","COMPANY_LINK","ADMIN"
			If DK_MEMBER_LEVEL < intLevelList Then Call ONLY_BUSINESS_MEMBER(DK_MEMBER_LEVEL,intLevelList)
			'If DK_MEMBER_LEVEL < intLevelList Then Call ALERTS(LNG_BOARD_LIST_TEXT01,"back","")
		'Case "ADMIN","OPERATOR"
		Case "OPERATOR"

		Case "SADMIN"
			If UCase(DK_MEMBER_GROUP) <> LOCATIONS Then
				If DK_MEMBER_LEVEL < intLevelList Then Call ALERTS(LNG_BOARD_LIST_TEXT01,"back","")
			End If
	End Select



	' 게시판 변수 받아오기(설정)
	Dim SEARCHTERM, SEARCHSTR, PAGE, PAGESIZE
		SEARCHTERM = Request.Form("SEARCHTERM")
		SEARCHSTR = Request.Form("SEARCHSTR")
		PAGE = Request.Form("page")
		PAGESIZE = intListView


	If SEARCHTERM = "" Then SEARCHTERM = "" End If
	If SEARCHSTR = "" Then SEARCHSTR = "" End if
	If PAGE="" Then PAGE = 1 End If
	If intCate = "" Then intCate = "" End If


	Select Case strBoardType
		Case "board","board2","liner","review","board_vote","kin","limitReply"
			FN_PROCEDURE_NAME = "DKP_NBOARD_BOARD_LIST_ORDER1"
		Case "gallery","gallery2"
			FN_PROCEDURE_NAME = "DKSP_NBOARD_GALLERY_LIST"
		Case "movie","movie2","video_pop"		'팝업동영상 추가
			FN_PROCEDURE_NAME = "DKSP_NBOARD_MOVIE_LIST"
	End Select

	'그룹조건 주기 S
		'board_config 으로 이관
	'그룹조건 주기 E

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
	If intCate <> "" Then getCate = "&amp;cate="&intCate

%>
<script type="text/javascript" src="board.js"></script>
<link rel="stylesheet" href="a_btnCss.css" />
<%Select Case strBoardType%>
<%Case "liner"%><script type="text/javascript" src="Type_liner.js"></script><link rel="stylesheet" href="Type_liner.css" />

<%End Select%>


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
<%IF CONST_MOBILE_ONLY = "T" Then%>
<!--#include virtual = "/admin/_inc/header.asp"-->
<%Else%>
<!--#include virtual = "/_include/header.asp"-->
<%End If%>
<!--#include file = "_inc_board_top.asp" -->
<%

%>
<div id="forum" class="list" style="<%=FORUM_TOP_MARGIN%>">
<!--include file = "board_search.asp" -->
<%
	Select Case strBoardType
		Case "board","board2"
%>
		<!--#include file = "Type_board.asp" -->
<%		Case "board_vote"%>
		<!--#include file = "Type_board_vote.asp" -->
<%		Case "kin"%>
		<!--#include file = "Type_board_kin.asp" -->
<%		Case "gallery","movie"%>
		<!--#include file = "Type_gallery.asp" -->
<%		Case "gallery2","movie2"%>
		<!--#include file = "Type_gallery2.asp" -->
<%		Case "video_pop"		'팝업동영상%>
		<!--#include file = "type_video_popup.asp" -->
<%		Case "liner"%>
		<!--#include file = "Type_liner.asp" -->
<%		Case "review"%>
		<!--#include file = "Type_review.asp" -->
<%		Case "limitReply"%>
		<!--#include file = "Type_limitReply.asp" -->

<%End Select%>
</div>
</div>
<%IF CONST_MOBILE_ONLY = "T" Then%>
<!--#include virtual = "/admin/_inc/copyright.asp"-->
<%Else%>
<!--#include virtual = "/_include/copyright.asp"-->
<%End If%>