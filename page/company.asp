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
		<div><img src="/images/content/company01_2.jpg" alt=""></div>
	<%Case "2"%>
		<div><img src="/images/content/company02_2.jpg" alt=""></div>
	<%Case "3"%>
		<div><img src="/images/content/company03_2.jpg" alt=""></div>
	<%Case "4"%>
		<link rel="stylesheet" href="/css/company.css?">
		<div id="company" class="company04">
			<section class="s01">
				<img src="/images/content/company04_1.jpg" alt="">
				<a href="/images/content/COSMICO KOREA(LOGO).ai" class="btn" download>
					<i class="icon-download"></i>
					<span>DOWNLOAD</span>
				</a>
			</section>
			<section class="s02">
				<img src="/images/content/company04_2.jpg" alt="">
				<a href="/images/content/DN_8(LOGO).ai" class="btn" download>
					<i class="icon-download"></i>
					<span>DOWNLOAD</span>
				</a>
			</section>
			<section class="s03">
				<img src="/images/content/company04_3.jpg" alt="">
				<a href="/images/content/Theta Mond(LOGO).ai" class="btn" download>
					<i class="icon-download"></i>
					<span>DOWNLOAD</span>
				</a>
			</section>
		</div>

	<%Case Else Call ALERTS(LNG_PAGE_ALERT01,"BACK","")%>
<%End Select%>
</div>
<!--#include virtual = "/_include/copyright.asp"-->




