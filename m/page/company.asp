<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	PAGE_SETTING = "COMPANY"
	PAGE_SETTING2 = "SUBPAGE"
	ISLEFT = "T"
	ISSUBTOP = "T"

	view = gRequestTF("view",True)
	'sview = gRequestTF("sview",True)
	mNum = 1
	sNum = view
	sVar = sNum
	'Response.Redirect "/m/page/comp.asp?view="&view
	'If webproiP<>"T" Then Response.redirect "/m/index.asp"
%>
<!--#include virtual = "/m/_include/document.asp"-->
<!--#include virtual = "/m/_include/jqueryload.asp"-->

</head>
<body>
<!--#include virtual = "/m/_include/header.asp"-->
<META NAME="GOOGLEBOT" CONTENT="NOINDEX, NOFOLLOW">
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
	<%Case "3"%>
		<div class="ready">
			<div><img src="/images/content/maintenance-line.svg" alt=""></div>
			<p><%=LNG_READY_02_01%></p>
		</div>
	<%Case "4"%>
		<div class="ready">
			<div><img src="/images/content/maintenance-line.svg" alt=""></div>
			<p><%=LNG_READY_02_01%></p>
		</div>

	<%Case Else Call ALERTS(LNG_PAGE_ALERT01,"BACK","")%>
<%End Select%>

<!--#include virtual = "/m/_include/copyright.asp"-->