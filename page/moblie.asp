<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	PAGE_SETTING = "MOBLIE"
	ISLEFT = "T"
	ISSUBTOP = "T"

	view = gRequestTF("view",True)
	mNum = 2


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
	<%Case Else Call ALERTS("존재하지 않는 페이지입니다.","BACK","")%>
<%End Select%>
</div>
<!--#include virtual = "/_include/copyright.asp"-->
