<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	PAGE_SETTING = "IMPORT"
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
		<img src="<%=IMG_CONTENT%>/import01.jpg" alt="" />
	<%Case Else Call ALERTS("존재하지 않는 페이지입니다.","BACK","")%>
<%End Select%>
</div>
<!--#include virtual = "/_include/copyright.asp"-->




