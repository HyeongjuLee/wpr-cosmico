<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	PAGE_SETTING = "SMART"
	ISLEFT = "T"
	ISSUBTOP = "T"

	view = gRequestTF("view",True)
	mNum = 2


%>
<!--#include virtual = "/_include/document.asp"-->
</head>
<body>
<!--#include virtual = "/_include/header.asp"-->
<!--#include virtual = "/_include/sub_title.asp"-->
<div id="pages">
	<%
		Select Case view
			Case "1"  
				PRINT viewImg(IMG_CONTENT&"/smart01.jpg",780,2150,"")&"</div>"
			Case "2" 
				PRINT viewImg(IMG_CONTENT&"/smart02.jpg",780,1450,"")&"</div>"
			Case "3" 
				PRINT viewImg(IMG_CONTENT&"/smart03.jpg",780,3100,"")&"</div>"
			Case "4" 
				PRINT viewImg(IMG_CONTENT&"/smart04.jpg",780,1500,"")&"</div>"
			Case "5" 
				PRINT viewImg(IMG_CONTENT&"/smart05.jpg",780,1100,"")&"</div>"
		End Select
	%>
</div>
<!--#include virtual = "/_include/copyright.asp"-->
