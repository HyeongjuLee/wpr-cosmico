<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	PAGE_SETTING = "EVENT"
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
		<div id="con" class="c01 eve01">
			<div class="tit"><%=LNG_EVENT_02%></div>
			<div class="ready">
				<div class="tit">
					<p><%=LNG_READY_01_01%><span><%=LNG_READY_01_02%></span><%=LNG_READY_01_03%></p>
				</div>
				<div class="stit"><%=LNG_READY_02_01%></div>
			</div>
		</div>
	<%Case Else Call ALERTS("존재하지 않는 페이지입니다.","BACK","")%>
<%End Select%>
</div>
<!--#include virtual = "/_include/copyright.asp"-->




