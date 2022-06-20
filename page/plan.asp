<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	PAGE_SETTING = "PLAN"
	ISLEFT = "T"
	ISSUBTOP = "T"

	view = gRequestTF("view",True)
	sview = gRequestTF("sview",True)
	mNum = 4


%>
<!--#include virtual = "/_include/document.asp"-->
</head>
<body>
<!--#include virtual = "/_include/header.asp"-->
<!--#include virtual = "/_include/sub_title.asp"-->
	<div id="pages">
	<%
		Select Case view
			Case "1" '
				Select Case sview
					Case "1"
				PRINT TABS(1)& "	"&viewImg(IMG_CONTENT&"/plan01.jpg",780,700,"")&""
					Case "2"
				PRINT TABS(1)& "	"&viewImg(IMG_CONTENT&"/plan02.jpg",780,600,"")&""
					Case "3"
				PRINT TABS(1)& "	"&viewImg(IMG_CONTENT&"/plan03.jpg",780,600,"")&""
					Case "4"
				PRINT TABS(1)& "	"&viewImg(IMG_CONTENT&"/plan04.jpg",780,4450,"")&""
					Case "5"
				PRINT TABS(1)& "	"&viewImg(IMG_CONTENT&"/plan05.jpg",780,650,"")&""
				PRINT TABS(1)& "	<div id=""movie"" class=""fleft"" style=""margin:40px 0px 0px 0px; height:240;""><iframe width=""780"" height=""400"" src=""https://www.youtube.com/embed/6ZDlixn-Zh8?feature=player_detailpage"" frameborder=""0"" allowfullscreen></iframe></div>"
				PRINT TABS(1)& "	<div id=""movie"" class=""fleft"" style=""margin:40px 0px 0px 0px; height:240;""><iframe width=""780"" height=""400"" src=""https://www.youtube.com/embed/l_lH6zD_oPI?feature=player_detailpage"" frameborder=""0"" allowfullscreen></iframe></div>"
				PRINT TABS(1)& "	<div id=""movie"" class=""fleft"" style=""margin:40px 0px 0px 0px; height:240;""><iframe width=""780"" height=""400"" src=""https://www.youtube.com/embed/jw9G5kX5ito?feature=player_detailpage"" frameborder=""0"" allowfullscreen></iframe></div>"
					Case "6"
				PRINT TABS(1)& "	"&viewImg(IMG_CONTENT&"/plan06.jpg",780,650,"")&""
				PRINT TABS(1)& "	<div id=""movie"" class=""fleft"" style=""margin:40px 0px 0px 0px; height:240;""><iframe width=""780"" height=""400"" src=""https://www.youtube.com/embed/xNuZcUmVJJU?feature=player_detailpage"" frameborder=""0"" allowfullscreen></iframe></div>"
					Case "7"
				PRINT TABS(1)& "	"&viewImg(IMG_CONTENT&"/plan07.jpg",780,650,"")&""
					Case "8"
				PRINT TABS(1)& "	"&viewImg(IMG_CONTENT&"/plan08.jpg",780,650,"")&""
				PRINT TABS(1)& "	<div id=""movie"" class=""fleft"" style=""margin:40px 0px 0px 0px; height:240;""><iframe width=""780"" height=""400"" src=""https://www.youtube.com/embed/HOEHVR3rSSs?feature=player_detailpage"" frameborder=""0"" allowfullscreen></iframe></div>"
					Case "9"
				PRINT TABS(1)& "	"&viewImg(IMG_CONTENT&"/plan09.jpg",780,650,"")&""
					Case "10"
				PRINT TABS(1)& "	"&viewImg(IMG_CONTENT&"/plan10.jpg",780,900,"")&""
				PRINT TABS(1)& "	<div id=""movie"" class=""fleft"" style=""margin:40px 0px 0px 0px; height:240;""><iframe width=""780"" height=""400"" src=""https://www.youtube.com/embed/LyysMsixlkA?feature=player_detailpage"" frameborder=""0"" allowfullscreen></iframe></div>"
			Case Else : Call ALERTS(LNG_PAGE_ALERT01,"back","")
				End Select
		End Select
	%>
</div>
<!--#include virtual = "/_include/copyright.asp"-->




