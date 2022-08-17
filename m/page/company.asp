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
		<img src="/m/images/content/company01.jpg" alt="" width="100%" />
	<%Case "2"%>
		<img src="/m/images/content/company02.jpg" alt="" width="100%" />
	<%Case "3"%>
		<img src="/m/images/content/company03.jpg" alt="" width="100%" />
	<%Case "4"%>
		<link rel="stylesheet" href="/m/css/company.css?v0">
		<div id="company" class="company04">
			<img src="/m/images/content/company04.jpg" alt="" width="100%" class="sample_image" />
			<section class="s01">
				<img src="/m/images/content/company04_1.jpg" alt="">
				<a href="/images/content/COSMICO KOREA(LOGO).ai" class="btn" download>
					<p>
						<i class="icon-download"></i>
						<span>DOWNLOAD</span>
					</p>
				</a>
			</section>
			<section class="s02">
				<img src="/m/images/content/company04_2.jpg" alt="">
				<a href="/images/content/DN_8(LOGO).ai" class="btn" download>
					<p>
						<i class="icon-download"></i>
						<span>DOWNLOAD</span>
					</p>
				</a>
			</section>
			<section class="s03">
				<img src="/m/images/content/company04_3.jpg" alt="">
				<a href="/images/content/Theta Mond(LOGO).ai" class="btn" download>
					<p>
						<i class="icon-download"></i>
						<span>DOWNLOAD</span>
					</p>
				</a>
			</section>
		</div>

	<%Case Else Call ALERTS(LNG_PAGE_ALERT01,"BACK","")%>
<%End Select%>
<!--#include virtual = "/m/_include/copyright.asp"-->