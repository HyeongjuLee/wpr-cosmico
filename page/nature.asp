<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	PAGE_SETTING = "NATURE"
	ISLEFT = "T"
	ISSUBTOP = "T"

	view = gRequestTF("view",True)
	mNum = 1
	'sview = gRequestTF("sview",True)


%>
<!--#include virtual = "/_include/document.asp"-->
</head>
<body>
<!--#include virtual = "/_include/header.asp"-->
<!--#include virtual = "/_include/sub_title.asp"-->
<div id="pages">
<%Select Case view%>
	<%Case "1"%>
		<p><img src="<%=IMG_CONTENT%>/ready.jpg" alt="" /></p>
	<%Case "2"%>
		<p><img src="<%=IMG_CONTENT%>/ready.jpg" alt="" /></p>
	<%Case "3"%>
		<p><img src="<%=IMG_CONTENT%>/ready.jpg" alt="" /></p>
	<%Case "4"%>
    	<p><img src="<%=IMG_CONTENT%>/ready.jpg" alt="" /></p>
	<%Case "5"%>
    	<p><img src="<%=IMG_CONTENT%>/ready.jpg" alt="" /></p>
	<%Case "6"%>
    	<p><img src="<%=IMG_CONTENT%>/ready.jpg" alt="" /></p>
	<%Case "7"%>
    	<p><img src="<%=IMG_CONTENT%>/ready.jpg" alt="" /></p>

	<%Case Else Call ALERTS(LNG_PAGE_ALERT01,"BACK","")%>
<%End Select%>
</div>
<!--#include virtual = "/_include/copyright.asp"-->




