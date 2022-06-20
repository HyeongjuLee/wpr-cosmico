<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	PAGE_SETTING = "COMPANY"
	ISLEFT = "T"
	ISSUBTOP = "T"

	view = gRequestTF("view",True)
	'sview = gRequestTF("sview",True)
	mNum = 1
	sNum = view
	sVar = sNum
%>
<!--#include virtual = "/_include/document.asp"-->
</head>
<body>
<!--#include virtual = "/_include/header.asp"-->
	<div id="pages">
	<%Select Case view%>
	<%Case "1"%>
		<div id="company" class="company01">
			<div class="txt">
				<div class="tit"><%=LNG_COMPANY_01_1%></div>
				<i></i>
				<p><%=LNG_COMPANY_01_2%></p><br>
				<p><%=LNG_COMPANY_01_3%></p><br>
				<p><%=LNG_COMPANY_01_4%></p><br>
				<p><%=LNG_COMPANY_01_5%></p><br>
				<p><%=LNG_COMPANY_01_6%></p>
			</div>
			<div class="img"><img src="/images/content/company01_2.jpg" alt=""></div>
		</div>
	<%Case "2"%>
		<div><img src="/images/content/company02(1).jpg" alt=""></div>
	<%Case "3"%>
		<div><img src="/images/content/company03_2.jpg" alt=""></div>
	<%Case "4"%>
		<div class="ready1">
			<div><img src="/images/content/maintenance-line(1).svg" alt=""></div>
			<p><%=LNG_READY_02_01%></p>
		</div>

	<%Case Else Call ALERTS(LNG_PAGE_ALERT01,"BACK","")%>
<%End Select%>
</div>
<!--#include virtual = "/_include/copyright.asp"-->




