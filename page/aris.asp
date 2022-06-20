<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	PAGE_SETTING = "ARIS"
	ISLEFT = "T"
	ISSUBTOP = "T"

	view = gRequestTF("view",True)
	sview = gRequestTF("sview",True)
	mNum = 3


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
				Select Case sview
					Case "1"
						PRINT TABS(1)& "	"&viewImg(IMG_CONTENT&"/aris01.jpg",780,3000,"")&""
						PRINT TABS(1)& "	</div>"
					Case Else : Call ALERTS("존재하지 않는 페이지입니다.","back","")
				End Select
			Case "2"  
				Select Case sview
					Case "1"
						PRINT TABS(1)& "	"&viewImg(IMG_CONTENT&"/aris02_01.jpg",780,690,"")&""
						PRINT TABS(1)& "	</div>"
					Case "2"
						PRINT TABS(1)& "	"&viewImg(IMG_CONTENT&"/aris02_02.jpg",780,700,"")&""
						PRINT TABS(1)& "	</div>"
					Case "3"
						PRINT TABS(1)& "	"&viewImg(IMG_CONTENT&"/aris02_03.jpg",780,450,"")&""
						PRINT TABS(1)& "	</div>"
					Case Else : Call ALERTS("존재하지 않는 페이지입니다.","back","")
				End Select

		End Select
	%>
</div>

<!--#include virtual = "/_include/copyright.asp"-->
