<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	PAGE_SETTING = "BRAND"
	PAGE_SETTING2 = "SUBPAGE"
	ISLEFT = "T"
	ISSUBTOP = "T"

	view = gRequestTF("view",True)
	'sview = gRequestTF("sview",True)
	mNum = 3
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
		<div id="brand" class="brand01">
			<div class="txt">
				<div><img src="/images/content/brand01_5.jpg" alt=""></div>
				<div class="tit"><%=LNG_BRAND_01_1%></div>
				<i></i>
				<p><%=LNG_BRAND_01_2%><br><%=LNG_BRAND_01_3%><br><%=LNG_BRAND_01_4%></p>
				<video preload="auto" autoplay="autoplay" loop="loop" muted="muted" width="100%">
					<source src="/images/content/brand01.mp4" type="video/mp4">
				</video>
			</div>
		</div>
<%Case "2"%>
	<div class="ready">
		<div><img src="/images/content/maintenance-line(1).svg" alt=""></div>
		<p><%=LNG_READY_02_01%></p>
	</div>
<%Case "3"%>
	<div class="ready">
		<div><img src="/images/content/maintenance-line(1).svg" alt=""></div>
		<p><%=LNG_READY_02_01%></p>
	</div>
<%Case "4"%>
	<div class="ready">
		<div><img src="/images/content/maintenance-line(1).svg" alt=""></div>
		<p><%=LNG_READY_02_01%></p>
	</div>
<%Case "5"%>
	<div class="ready">
		<div><img src="/images/content/maintenance-line(1).svg" alt=""></div>
		<p><%=LNG_READY_02_01%></p>
	</div>
<%Case "6"%>
	<div class="ready">
		<div><img src="/images/content/maintenance-line(1).svg" alt=""></div>
		<p><%=LNG_READY_02_01%></p>
	</div>
<%Case "7"%>
	<div class="ready">
		<div><img src="/images/content/maintenance-line(1).svg" alt=""></div>
		<p><%=LNG_READY_02_01%></p>
	</div>

	<%Case Else Call ALERTS(LNG_PAGE_ALERT01,"BACK","")%>
<%End Select%>
<!--#include virtual = "/m/_include/copyright.asp"-->