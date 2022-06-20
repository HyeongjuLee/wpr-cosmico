<!--#include virtual = "/_lib/strFunc.asp"-->
<!--#include virtual = "/counsel/1on1_config.asp"-->
<%

	'PAGE_SETTING = "MYOFFICE"
	PAGE_SETTING = "CUSTOMER"
	PAGE_SETTING2 = "SUBPAGE"
	ISSUBTOP = "T"

	mNum = 5
	sNum = 3
	sVar = sView
	view = sNum

	If PAGE_SETTING = "MYOFFICE" Then
		Call ONLY_BUSINESS_MEMBER(DK_MEMBER_LEVEL,2)
		Call ONLY_CS_MEMBER()
	End If

	' 게시판 변수 받아오기(설정) s
		Dim SEARCHTERM, SEARCHSTR, PAGE, PAGESIZE
			PAGE = Request("page")
			PAGESIZE = 20
			If PAGE="" Then PAGE = 1 End If


		arrParams = Array( _
			Db.makeParam("@PAGE",adInteger,adParamInput,4,PAGE), _
			Db.makeParam("@PAGESIZE",adInteger,adParamInput,4,PAGESIZE), _
			Db.makeParam("@strUserID",adVarChar,adParamInput,20,DK_MEMBER_ID), _
			Db.makeParam("@strNation",adVarChar,adParamInput,10,LANG), _
			Db.makeParam("@All_Count",adInteger,adParamOutPut,0,0) _
		)
		arrList = Db.execRsList("DKSP_COUNSEL_1ON1_LIST",DB_PROC,arrParams,listLen,Nothing)
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
<!-- <link rel="stylesheet" href="1on1.css" /> -->
<script type="text/javascript">
<!--
	$(document).ready(function() {
		$("tbody.link").click(function() {
			var linkHref = $(this).attr("attrLink");
			//console.log(linkHref);
			$(location).attr("href",linkHref);
		});
	});

// -->
</script>
</head>
<body onUnload="">
<!--#include virtual = "/m/_include/header.asp"-->

<div id="counseling" class="cs_list">
	<div class="write"><a href="1on1.asp"><i class="icon-pencil-2"></i><%=LNG_BOARD_BTN_WRITE%></a></div>

	<%	If IsArray(arrList) Then %>
		<ul>
		<%	For i = 0 To listLen
				arrList_ROWNUM			= arrList(0,i)
				arrList_intIDX			= arrList(1,i)
				arrList_isDel			= arrList(2,i)
				arrList_strUserID		= arrList(3,i)
				arrList_strName			= arrList(4,i)
				arrList_strEmail		= arrList(5,i)
				arrList_strMobile		= arrList(6,i)
				arrList_strSubject		= arrList(7,i)
				arrList_regDate			= arrList(8,i)
				arrList_isReply			= arrList(9,i)
				arrList_repDate			= arrList(10,i)
				NUMS = CDbl(All_Count) - CDbl(arrList_ROWNUM) + 1

	%>
		<li>
			<a href="1on1_view.asp?page=<%=PAGE%>&idx=<%=arrList_intIDX%>">
				<h6>
					<p><%=LNG_TEXT_WRITE_DATE%><i></i><%=dateFormat(arrList_regDate,"yyyy.mm.dd hh:nn:ss")%></p>
					<span><%=BACKWORD(arrList_strSubject)%></span>
				</h6>
				<div>
					<%=TFVIEWER(arrList_isReply,"REPLY")%>
					<p><span><%=LNG_1ON1_ANSWER%><i></i></span><%=dateFormat(arrList_repDate,"yyyy.mm.dd hh:nn:ss")%></p>
				</div>
			</a>
		</li>
	<%Next%>
	</ul>
	<%Else%>
		<p class="notList"><%=LNG_1ON1_NO_INQUIRY_WRITTEN_BY_ME%></p>
	<%End If%>
	<div class="width100">
		<div class="pagingArea pagingMob5n"><% Call pageListMob5n(PAGE,PAGECOUNT)%></div>
	</div>

	<form name="frm" method="get" action="">
		<input type="hidden" name="PAGE" value="<%=PAGE%>" />
	</form>

</div>
</div>
<!--#include virtual = "/m/_include/copyright.asp"-->