<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	PAGE_SETTING = "NOTICE"
	ISLEFT = "T"
	ISSUBTOP = "T"

	view = gRequestTF("view",True)
	mNum = 3


%>
<!--#include virtual = "/_include/document.asp"-->
</head>
<body>
<!--#include virtual = "/_include/header.asp"-->
	<div id="pages">
	<%
		Select Case view
			Case "1"
				PRINT TABS(1)& "	"&viewImg(IMG_CONTENT&"/notice_01_tit.jpg",780,40,"")&""
				PRINT TABS(1)& "	"&viewImg(IMG_CONTENT&"/ready.jpg",780,600,"")&""
			Case "2"
				PRINT TABS(1)& "	"&viewImg(IMG_CONTENT&"/notice_02_tit.jpg",780,40,"")&""
				PRINT TABS(1)& "	"&viewImg(IMG_CONTENT&"/ready.jpg",780,600,"")&""
			Case "3"
				PRINT TABS(1)& "	"&viewImg(IMG_CONTENT&"/notice_03_tit.jpg",780,40,"")&""
				PRINT TABS(1)& "	"&viewImg(IMG_CONTENT&"/ready.jpg",780,600,"")&""
			Case "4"
				PRINT TABS(1)& "	"&viewImg(IMG_CONTENT&"/notice_04_tit.jpg",780,40,"")&""
				PRINT TABS(1)& "	"&viewImg(IMG_CONTENT&"/ready.jpg",780,600,"")&""
			Case "5"
				PRINT TABS(1)& "	"&viewImg(IMG_CONTENT&"/notice_05_tit.jpg",780,40,"")&""
				PRINT TABS(1)& "	"&viewImg(IMG_CONTENT&"/ready.jpg",780,600,"")&""
		End Select
	%>
	</div>


<!--#include virtual = "/_include/copyright.asp"-->
