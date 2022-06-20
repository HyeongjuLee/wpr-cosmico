<!--#include virtual = "/_lib/strFunc.asp"-->
<%IF CONST_MOBILE_ONLY = "T" Then%>
<!--#include virtual="/admin/_inc/adminPath.asp" -->
<%End If%>
<%
	strCateCode = gRequestTF("cate",True)
	ContainMode = "LEFT_T"

%>
<%IF CONST_MOBILE_ONLY = "T" Then%>
<!--#include virtual = "/admin/_inc/document.asp"-->
<%Else%>
<!--#include virtual = "/_include/document.asp"-->
<%End If%>
<link rel="stylesheet" href="css_common.css" />
<%

	SQL = "SELECT [strCateName] FROM [DK_COM_CATEGORY] WHERE [strCateCode] = ?"
	arrParams = Array(_
		Db.makeParam("@strCatrCode",adVarChar,adParamInput,20,strCateCode)_
	)
	cateTitle = Db.execRsData(SQL,DB_TEXT,arrParams,Nothing)



%>

</head>
<body>
<%IF CONST_MOBILE_ONLY = "T" Then%>
<!--#include virtual = "/admin/_inc/header.asp"-->
<%Else%>
<!--#include virtual = "/_include/header.asp"-->
<%End If%>
<!--#include virtual = "/_include/smartTok.asp"-->

<div class="ForumCntLine">
<table <%=tableatt%> style="width:790px;">
	<tr>
		<td>전체글수 <strong>0</strong> 개</td>
		<td>전체 댓글수 <strong>0</strong> 개</td>
		<td>전체 자료수 <strong>0</strong> 개</td>
		<td>생성 포럼수 <strong>0</strong> 개</td>
		<td align="right" style="width:220px;padding-right:5px;">
			<select name="" class="ForumCntLineSelect">
				<option value="">:::::::::::: 포럼 바로가기 ::::::::::::</option>
			</select>
		</td>
	</tr>
</table>
</div>
<div class="titleLine"><%=viewFlash(IMG&"/txt2.swf","subject="&cateTitle&" - 전체보기&wnum=400&hnum=32&fcolor=0x267ea4&fsize=19&align=left",400,32)%></div>
<div id="sumboard">
<%
	SQL = "SELECT [strBoardTitle],[strBoardName] FROM [DK_NBOARD_CONFIG] WHERE [strCateCode] = ? AND [isUse] = 'T' ORDER BY [intIDX] ASC"
	arrParams = Array(_
		Db.makeParam("@strCatrCode",adVarChar,adParamInput,20,strCateCode)_
	)
	arrList = Db.execRsList(SQL,DB_TEXT,arrParams,listLen,Nothing)



	If IsArray(arrList) Then
		For i = 0 To listLen
			PRINT "<div class=""clear"" style=""margin-top:20px;"">"&viewFlash(IMG&"/txt2.swf","subject="&arrList(0,i)&"&wnum=400&hnum=20&fcolor=0xcb4800&fsize=14&align=left",400,20)&"</div>"

			PRINT "<div class=""sumline"">"
			PRINT "	<table "&tableatt&" style=""width:700px;margin-left:50px;"">"
			SQL = "SELECT TOP(5)[intIDX],[strSubject],[regDate] FROM [DK_NBOARD_CONTENT] WHERE [strBoardName] = ? AND [intDepth] = 0 ORDER BY [intIDX] DESC"
			arrParams = Array(_
				Db.makeParam("@strBoardName",adVarChar,adParamInput,50,arrList(1,i))_
			)
			arrList1 = Db.execRsList(SQL,DB_TEXT,arrParams,listLen1,Nothing)
			If IsArray(arrList1) Then
					PRINT "		<colgroup>"
					PRINT "			<col width=""8"">"
					PRINT "			<col width=""*"">"
					PRINT "			<col width=""100"">"
					PRINT "		</colgroup>"
				For j = 0 To listLen1
					PRINT "		<tr>"
					PRINT "			<td>"&viewImg(CIMG_SHARE&"/desc_rect.gif",3,3,"")&"</td>"
					PRINT "			<td>"&arrList1(1,j)&"<span style=""color:orange;font-size:8pt;""> [0]</span></td>"
					PRINT "			<td style=""color:#777;font-size:8pt;"">"&Left(arrList1(2,j),10)&"</td>"
					PRINT "		</tr>"
				Next
			Else
				PRINT "		<tr>"
				PRINT "			<td height=""90"" class=""tcenter"">해당 포럼에 게시물이 없습니다.</td>"
				PRINT "		</tr>"

			End If
			PRINT "	</table>"
			PRINT "</div>"
		Next
	End If
%>




</div>
<%IF CONST_MOBILE_ONLY = "T" Then%>
<!--#include virtual = "/admin/_inc/copyright.asp"-->
<%Else%>
<!--#include virtual = "/_include/copyright.asp"-->
<%End If%>
