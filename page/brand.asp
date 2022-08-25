<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	PAGE_SETTING = "BRAND"
	ISLEFT = "T"
	ISSUBTOP = "T"

	view = gRequestTF("view",True)
	sview = gRequestTF("sview",True)
	mNum = 2
	sNum = view

	If view = 1 Then
		'CALL ONLY_BUSINESS_MEMBER(DK_MEMBER_LEVEL,1)
	End If
%>
<!--#include virtual = "/_include/document.asp"-->
</head>
<body>
<!--#include virtual = "/_include/header.asp"-->
	<div id="pages">
	<%Select Case view%>
	<%Case "1"%>
		
		<%Select Case sview%>
		<%Case "1"%>
			<div><img src="/images/content/brand01_1_5.jpg" alt=""></div>
		<%Case "2"%>
			<div><img src="/images/content/brand01_2_2.jpg" alt=""></div>
		<%Case Else%>
		<%End Select%>

	<%Case "2"%>
		<div><img src="/images/content/brand02_2.jpg" alt=""></div>
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
	<%Case Else Call ALERTS("존재하지 않는 페이지입니다.","BACK","")%>
<%End Select%>
</div>
<!--#include virtual = "/_include/copyright.asp"-->




