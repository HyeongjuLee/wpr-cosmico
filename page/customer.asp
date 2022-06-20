<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	PAGE_SETTING = "CUSTOMER"
	ISLEFT = "T"
	ISSUBTOP = "T"

	view = gRequestTF("view",True)
	mNum = 7


%>
<!--#include virtual = "/_include/document.asp"-->
</head>
<body>
<!--#include virtual = "/_include/header.asp"-->
<!--#include virtual = "/_include/sub_title.asp"-->
<div id="pages">
<%Select Case view%>
	<%Case "1"%>
		<p><%=viewImg(IMG_CONTENT&"/ready.jpg",780,400,"")%></p>
	<%Case "2"%>
		<p><%=viewImg(IMG_CONTENT&"/ready.jpg",780,400,"")%></p>
	<%Case "3"%>
		<p><%=viewImg(IMG_CONTENT&"/ready.jpg",780,400,"")%></p>
	<%Case "4"%>
		<p><%=viewImg(IMG_CONTENT&"/ready.jpg",780,400,"")%></p>
	<%Case "5"%>
		<p><%=viewImg(IMG_CONTENT&"/ready.jpg",780,400,"")%></p>
	<%Case "6"%>
		<p><%=viewImgOpt(IMG_CONTENT&"/customer06.jpg",780,950,"","usemap=""#sitemap""")%></p>

	<%Case Else Call ALERTS(LNG_PAGE_ALERT01,"BACK","")%>
<%End Select%>

		<map name="sitemap" id="sitemap">
<area shape="rect" coords="222,829,300,857" href="#">
<area shape="rect" coords="222,795,367,823" href="/cboard/board_list.asp?bname=notice">
<area shape="rect" coords="222,760,300,788" href="/cboard/board_list.asp?bname=pds">
<area shape="rect" coords="222,724,300,752" href="/counsel/counsel.asp">
<area shape="rect" coords="222,691,300,719" href="/cboard/board_list.asp?bname=qna">
<area shape="rect" coords="222,658,300,686" href="/faq/faq_list.asp">

<area shape="rect" coords="644,436,732,464" target="_blank" href="http://gabogo.w-pro.kr/">

<area shape="rect" coords="447,539,535,567" href="/page/community.asp?view=4">
<area shape="rect" coords="447,504,535,532" href="/cboard/board_list.asp?bname=info">
<area shape="rect" coords="447,470,535,498" href="/cboard/board_list.asp?bname=gallery">
<area shape="rect" coords="447,436,535,464" href="/cboard/board_list.asp?bname=free">

<area shape="rect" coords="222,435,271,463" href="/page/aris.asp?view=1">

<area shape="rect" coords="646,145,734,173" href="/page/gstory.asp?view=1">

<area shape="rect" coords="448,213,536,241" href="/page/business.asp?view=3">
<area shape="rect" coords="448,179,536,207" href="/page/business.asp?view=2">
<area shape="rect" coords="448,145,536,173" href="/page/business.asp?view=1">

<area shape="rect" coords="222,321,339,349" href="/page/company.asp?view=6">
<area shape="rect" coords="222,286,297,314" href="/page/company.asp?view=5">
<area shape="rect" coords="222,251,297,279" href="/page/company.asp?view=4">
<area shape="rect" coords="222,215,377,243" href="/page/company.asp?view=3">
<area shape="rect" coords="222,181,297,209" href="/page/company.asp?view=2">
<area shape="rect" coords="220,146,295,174" href="/page/company.asp?view=1">
		</map>

</div>
<!--#include virtual = "/_include/copyright.asp"-->


