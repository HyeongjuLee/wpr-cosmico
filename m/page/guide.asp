<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	PAGE_SETTING = "GUIDE"
	PAGE_SETTING2 = "SUBPAGE"
	ISLEFT = "T"
	ISSUBTOP = "T"

	view = gRequestTF("view",True)
	'sview = gRequestTF("sview",True)
	mNum = 5
	sNum = view
	sVar = sNum

%>
<!--#include virtual = "/m/_include/document.asp"-->
<!--#include virtual = "/m/_include/jqueryload.asp"-->
</head>
<body>
<!--#include virtual = "/m/_include/header.asp"-->
<%Select Case view%>
<%Case "1"%>
	<div class="ready">
		<div><img src="/images/content/maintenance-line.svg" alt=""></div>
		<p><%=LNG_READY_02_01%></p>
	</div>
<%Case "2"%>
	<div class="ready">
		<div><img src="/images/content/maintenance-line.svg" alt=""></div>
		<p><%=LNG_READY_02_01%></p>
	</div>

	<%Case Else Call ALERTS(LNG_PAGE_ALERT01,"BACK","")%>
<%End Select%>

<!--#include virtual = "/m/_include/copyright.asp"-->