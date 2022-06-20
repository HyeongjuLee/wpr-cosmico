<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	PAGE_SETTING = "COMPANY"
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
						PRINT viewImg(IMG_CONTENT&"/company01.jpg",870,650,"")&"</div>"
			Case Else : Call ALERTS("존재하지 않는 페이지입니다.","back","")
				End Select
			Case "2" '
				Select Case sview
					Case "1"
						PRINT viewImg(IMG_CONTENT&"/company02.jpg",870,540,"")&"</div>"
			Case Else : Call ALERTS("존재하지 않는 페이지입니다.","back","")
				End Select
			Case "3" '
				Select Case sview
					Case "1"
						PRINT viewImg(IMG_CONTENT&"/company03_01.jpg",870,700,"")&"</div>"
					Case "2"
						PRINT viewImg(IMG_CONTENT&"/company03_02.jpg",870,900,"")&"</div>"
					Case "3"
						PRINT viewImg(IMG_CONTENT&"/company03_03.jpg",870,3000,"")&"</div>"
					Case "4"
						PRINT viewImg(IMG_CONTENT&"/company03_04.jpg",870,800,"")&"</div>"
			Case Else : Call ALERTS("존재하지 않는 페이지입니다.","back","")
				End Select
			Case "4" '
				Select Case sview
					Case "1"
						PRINT viewImg(IMG_CONTENT&"/company04.jpg",870,1950,"")&"</div>"
			Case Else : Call ALERTS("존재하지 않는 페이지입니다.","back","")
				End Select
			Case "5" '
				Select Case sview
					Case "1"
						PRINT viewImg(IMG_CONTENT&"/ready.jpg",870,500,"")&"</div>"
			Case Else : Call ALERTS("존재하지 않는 페이지입니다.","back","")
				End Select
			Case "6" '
				Select Case sview
					Case "1"
						PRINT viewImg(IMG_CONTENT&"/ready.jpg",870,500,"")&"</div>"
			Case Else : Call ALERTS("존재하지 않는 페이지입니다.","back","")
				End Select
			Case "7" '
				Select Case sview
					Case "1"
						PRINT viewImg(IMG_CONTENT&"/company07.jpg",870,900,"")&"</div>"
			Case Else : Call ALERTS("존재하지 않는 페이지입니다.","back","")
				End Select
			Case "8" '
				Select Case sview
					Case "1"
						PRINT viewImg(IMG_CONTENT&"/company08.jpg",870,950,"")&"</div>"
			Case Else : Call ALERTS("존재하지 않는 페이지입니다.","back","")
				End Select
			Case "9" '
				Select Case sview
					Case "1"
						PRINT viewImg(IMG_CONTENT&"/company09_01.jpg",870,1100,"")&"</div>"
					Case "2"
						PRINT viewImg(IMG_CONTENT&"/company09_02.jpg",870,1200,"")&"</div>"
					Case "3"
						PRINT viewImg(IMG_CONTENT&"/company09_03.jpg",870,850,"")&"</div>"
					Case "4"
						PRINT viewImg(IMG_CONTENT&"/company09_04.jpg",870,680,"")&"</div>"
					Case "5"
						PRINT viewImg(IMG_CONTENT&"/company09_05.jpg",870,750,"")&"</div>"
					Case "6"
						PRINT viewImg(IMG_CONTENT&"/company09_06.jpg",870,800,"")&"</div>"
					Case "7"
						PRINT viewImg(IMG_CONTENT&"/company09_07.jpg",870,800,"")&"</div>"
					Case "8"
						PRINT viewImg(IMG_CONTENT&"/company09_08.jpg",870,800,"")&"</div>"
					Case "9"
						PRINT viewImg(IMG_CONTENT&"/company09_09.jpg",870,800,"")&"</div>"
			Case Else : Call ALERTS("존재하지 않는 페이지입니다.","back","")
				End Select
			Case "10" '
				Select Case sview
					Case "1"
						PRINT viewImg(IMG_CONTENT&"/ready.jpg",870,500,"")&"</div>"
			Case Else : Call ALERTS("존재하지 않는 페이지입니다.","back","")
				End Select
			Case "11" '
				Select Case sview
					Case "1"
						PRINT viewImg(IMG_CONTENT&"/ready.jpg",870,500,"")&"</div>"
			Case Else : Call ALERTS("존재하지 않는 페이지입니다.","back","")
				End Select
		End Select
	%>
</div>
<!--#include virtual = "/_include/copyright.asp"-->




