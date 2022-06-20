<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	PAGE_SETTING = "PRODUCT2"
	view = gRequestTF("view",False)

	If view = "" Then view = 1

	PAGE_NUM = view
	Select Case view
		Case "1" : viewContent = "<img src="""&IMG&"/product_02_01.png"" width=""100%"" alt="""" />"
		Case "2" : viewContent = "<img src="""&IMG&"/product_02_02.png"" width=""100%"" alt="""" />"
	End Select


%>
<!--#include virtual = "/_inc/document.asp"-->
<!--#include virtual = "/_inc/jqueryload.asp"-->
</head>
<body>
<!--#include virtual = "/_inc/header.asp"-->
<!--#include virtual = "/_inc/sub_header.asp"-->
<div id="content">
	<div class="product"><%=viewContent%></div>
</div>
<!--#include virtual = "/_inc/copyright.asp"-->