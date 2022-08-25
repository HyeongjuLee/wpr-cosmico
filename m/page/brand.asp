<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	PAGE_SETTING = "BRAND"
	PAGE_SETTING2 = "SUBPAGE"
	ISLEFT = "T"
	ISSUBTOP = "T"

	view = gRequestTF("view",True)
	sview = gRequestTF("sview",True)
	mNum = 2
	sNum = view
	sVar = sNum

	If view= 1 Then
		'CALL ONLY_BUSINESS_MEMBER(DK_MEMBER_LEVEL,1)
	End If

%>
<!--#include virtual = "/m/_include/document.asp"-->
<!--#include virtual = "/m/_include/jqueryload.asp"-->

</head>
<body>
<!--#include virtual = "/m/_include/header.asp"-->
<%Select Case view%>
<%Case "1"%>
		
	<%Select Case sview%>
	<%Case "1"%>
		<img src="/m/images/content/brand01_1_2.jpg" alt="" width="100%" />
	<%Case "2"%>
		<img src="/m/images/content/brand01_2.jpg" alt="" width="100%" />
	<%Case Else%>
	<%End Select%>

<%Case "2"%>
	<img src="/m/images/content/brand02_2.jpg" alt="" width="100%" />
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
<%Case "5"%>
	<div class="ready">
		<div><img src="/images/content/maintenance-line.svg" alt=""></div>
		<p><%=LNG_READY_02_01%></p>
	</div>
<%Case "6"%>
	<div class="ready">
		<div><img src="/images/content/maintenance-line.svg" alt=""></div>
		<p><%=LNG_READY_02_01%></p>
	</div>
<%Case "7"%>
	<div class="ready">
		<div><img src="/images/content/maintenance-line.svg" alt=""></div>
		<p><%=LNG_READY_02_01%></p>
	</div>

	<%Case Else Call ALERTS(LNG_PAGE_ALERT01,"BACK","")%>
<%End Select%>
<!--#include virtual = "/m/_include/copyright.asp"-->