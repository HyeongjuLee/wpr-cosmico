<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	PAGE_SETTING = "PRODUCT"
	ISLEFT = "T"
	ISSUBTOP = "T"

	view = gRequestTF("view",True)
	'sview = gRequestTF("sview",True)
	mNum = 2

%>
<!--#include virtual = "/_include/document.asp"-->
</head>
<body>
<!--#include virtual = "/_include/header.asp"-->
	<div id="pages">
	<%Select Case view%>
	<%Case "1"%>
		<div class="ready1">
			<div><img src="/images/content/maintenance-line(1).svg" alt=""></div>
			<p><%=LNG_READY_02_01%></p>
		</div>
	<%Case "2"%>
		<div class="ready1">
			<div><img src="/images/content/maintenance-line(1).svg" alt=""></div>
			<p><%=LNG_READY_02_01%></p>
		</div>
	<%Case "3"%>
		<div class="ready1">
			<div><img src="/images/content/maintenance-line(1).svg" alt=""></div>
			<p><%=LNG_READY_02_01%></p>
		</div>
	<%Case Else Call ALERTS("존재하지 않는 페이지입니다.","BACK","")%>
<%End Select%>
</div>
<!--#include virtual = "/_include/copyright.asp"-->


