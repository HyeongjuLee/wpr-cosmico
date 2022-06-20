<!--#include virtual = "/_lib/strFunc.asp"-->
<!--#include file = "1on1_config.asp"-->
<%
'	PAGE_MODE_ON = "SHOP"
'	PAGE_MODE = FN_PAGE_MODE_SELECTOR(PAGE_MODE_ON)


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

<!--#include virtual = "/_include/document.asp"-->
<link rel="stylesheet" href="1on1.css" />
<script type="text/javascript">
<!--
	$(document).ready(function() {
		$("tr.link").click(function() {
			var linkHref = $(this).attr("attrLink");
			//console.log(linkHref);
			$(location).attr("href",linkHref);
		});
	});

// -->
</script>
</head>
<body>
<!--#include virtual="/_include/header.asp" -->
<div id="counseling" class="cs_list">
	<div class="cleft width100 writeBtnZone"><a href="1on1.asp"><i class="fas fa-pencil-alt"></i> <%=LNG_BOARD_BTN_WRITE%></a></div>

	<table <%=tableatt%> class="width100">
		<col width="70" />
		<col width="*" />
		<col width="220" />
		<col width="220" />

		<tr>
			<th><%=LNG_BOARD_TYPE_BOARD_TEXT01%></th>
			<th><%=LNG_TEXT_TITLE%></th>
			<th><%=LNG_TEXT_WRITE_DATE%></th>
			<th><%=LNG_1ON1_WHETHER_TO_ANSWER%><br /><%=LNG_1ON1_RESPONSE_MODIFY_TIME%></th>
		</tr>

	<%



		If IsArray(arrList) Then
			For i = 0 To listLen
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



				PRINT "<tr class=""link"" attrLink=""1on1_view.asp?page="&PAGE&"&idx="&arrList_intIDX&""">"
				PRINT "	<td class=""tcenter"">"&NUMS&"</td>"
				PRINT "	<td class=""subject"">"&BACKWORD(arrList_strSubject)&"</td>"
				PRINT "	<td class=""tcenter"">"&dateFormat(arrList_regDate,"yyyy.mm.dd hh:nn:ss")&"</td>"
				PRINT "	<td class=""tcenter"">"&TFVIEWER(arrList_isReply,"REPLY")&"<br />"&dateFormat(arrList_repDate,"yyyy.mm.dd hh:nn:ss")&"</td>"
				PRINT "</tr>"

			Next
		Else
			PRINT "<tr>"
			PRINT "	<td colspan=""4"" class=""notData"">"&LNG_1ON1_NO_INQUIRY_WRITTEN_BY_ME&"</td>"
			PRINT "</tr>"
		End If
	%>
	</table>

	<div class="cleft width100" style="margin-top:15px;text-align:center; padding-bottom:40px;">
		<!-- <div class="pageArea2"><%Call pageList(PAGE,PAGECOUNT)%></div> -->
		<div class="pagingArea pagingNew3"><% Call pageListNew3(PAGE,PAGECOUNT)%></div>
	</div>

	<form name="frm" method="get" action="">
		<input type="hidden" name="PAGE" value="<%=PAGE%>" />
	</form>

</div>
<!--#include virtual = "/_include/copyright.asp"-->


