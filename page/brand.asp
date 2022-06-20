<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	PAGE_SETTING = "BRAND"
	ISLEFT = "T"
	ISSUBTOP = "T"

	view = gRequestTF("view",True)
	'sview = gRequestTF("sview",True)
	mNum = 3
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
		<div id="brand" class="brand01">
			<div class="txt">
				<div><img src="/images/content/brand01_5.jpg" alt=""></div>
				<i></i>
				<div class="tit"><%=LNG_BRAND_01_1%></div>
				<p><%=LNG_BRAND_01_2%></p><br>
				<p><%=LNG_BRAND_01_3%></p><br>
				<p><%=LNG_BRAND_01_4%></p>
			</div>
			<div class="img">
				<video preload="auto" autoplay="autoplay" loop="loop" muted="muted" width="600px">
					<source src="/images/content/brand01.mp4" type="video/mp4">
				</video>
			</div>
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
	<%Case "4"%>
		<div class="ready1">
			<div><img src="/images/content/maintenance-line(1).svg" alt=""></div>
			<p><%=LNG_READY_02_01%></p>
		</div>
	<%Case "5"%>
		<div class="ready1">
			<div><img src="/images/content/maintenance-line(1).svg" alt=""></div>
			<p><%=LNG_READY_02_01%></p>
		</div>
	<%Case Else Call ALERTS("존재하지 않는 페이지입니다.","BACK","")%>
<%End Select%>
</div>
<!--#include virtual = "/_include/copyright.asp"-->




