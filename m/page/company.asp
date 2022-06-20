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
		<div id="company" class="company01">
			<div class="txt">
				<div class="tit"><%=LNG_COMPANY_01_1%></div>
				<i></i>
				<p><%=LNG_COMPANY_01_2%></p><br>
				<p><%=LNG_COMPANY_01_3%></p>
				<div class="img"><img src="/m/images/content/company01_2.jpg" alt=""></div>
				<p><%=LNG_COMPANY_01_4%></p><br>
				<p><%=LNG_COMPANY_01_5%></p><br>
				<p><%=LNG_COMPANY_01_6%></p>
			</div>
		</div>
	<%Case "2"%>
		<p><img src="/m/images/content/company02(1).jpg" width="100%" alt="" /></p>
	<%Case "3"%>
		<p><img src="/m/images/content/company03_2.jpg" width="100%" alt="" /></p>
	<%Case "4"%>
		<div class="ready">
			<div><img src="/images/content/maintenance-line(1).svg" alt=""></div>
			<p><%=LNG_READY_02_01%></p>
		</div>

	<%Case Else Call ALERTS(LNG_PAGE_ALERT01,"BACK","")%>
<%End Select%>

<!--#include virtual = "/m/_include/copyright.asp"-->