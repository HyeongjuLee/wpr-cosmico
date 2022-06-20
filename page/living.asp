<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	PAGE_SETTING = "LIVING"
	ISLEFT = "T"
	ISSUBTOP = "T"

	view = gRequestTF("view",True)
	mNum = 3


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
	<%Case Else Call ALERTS(LNG_PAGE_ALERT01,"BACK","")%>
<%End Select%>
</div>
<!--#include virtual = "/_include/copyright.asp"-->
