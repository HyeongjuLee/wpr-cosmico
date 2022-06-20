<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	PAGE_SETTING = "KBICHE"
	ISLEFT = "T"
	ISSUBTOP = "T"

	view = gRequestTF("view",True)
	'sview = gRequestTF("sview",True)
	mNum = 1

%>
<!--#include virtual = "/_include/document.asp"-->
</head>
<body>
<!--#include virtual = "/_include/header.asp"-->
	<div id="pages">
	<%Select Case view%>
	<%Case "1"%>
		<div class="ready">
			<div class="img"></div>
			<div class="color"></div>
			<div class="tit">
				<p><%=LNG_READY_01_01%><span><%=LNG_READY_01_02%></span><%=LNG_READY_01_03%></p>
			</div>
			<div class="stit"><%=LNG_READY_02_01%></div>
		</div>
	<%Case "2"%>
		<div class="ready">
			<div class="img"></div>
			<div class="color"></div>
			<div class="tit">
				<p><%=LNG_READY_01_01%><span><%=LNG_READY_01_02%></span><%=LNG_READY_01_03%></p>
			</div>
			<div class="stit"><%=LNG_READY_02_01%></div>
		</div>
	<%Case "3"%>
		<div class="ready">
			<div class="img"></div>
			<div class="color"></div>
			<div class="tit">
				<p><%=LNG_READY_01_01%><span><%=LNG_READY_01_02%></span><%=LNG_READY_01_03%></p>
			</div>
			<div class="stit"><%=LNG_READY_02_01%></div>
		</div>
	<%Case Else Call ALERTS("존재하지 않는 페이지입니다.","BACK","")%>
<%End Select%>
</div>
<!--#include virtual = "/_include/copyright.asp"-->




