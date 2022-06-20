<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	PAGE_SETTING = "UNDER"
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
				PRINT viewImg(IMG_CONTENT&"/under01.jpg",780,1830,"")&"</div>"
			Case "2" 
				PRINT viewImg(IMG_CONTENT&"/under02.jpg",780,2600,"")&"</div>"
			Case "3" 
				PRINT viewImg(IMG_CONTENT&"/under03.jpg",780,550,"")&"</div>"
			Case "4" 
				PRINT viewImg(IMG_CONTENT&"/under04.jpg",780,1150,"")&"</div>"
			Case "5" 
				PRINT viewImg(IMG_CONTENT&"/under05.jpg",780,870,"")&"</div>"
		End Select
	%>
</div>
<!--#include virtual = "/_include/copyright.asp"-->
