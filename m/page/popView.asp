<!--#include virtual = "/_lib/strFunc.asp"-->
<%

	PAGE_SETTING = gRequestTF("ps",True)
	view		 = gRequestTF("view",True)
	sview		 = gRequestTF("sview",False)

	'print PAGE_SETTING

%>

<!doctype html>
<html lang="ko">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1.0,minimum-scale=1.0, user-scalable=yes">
<meta http-equiv="Cache-Control" content="no-cache">
<meta http-equiv="Pragma" content="no-cache">
<title><%=DKCONF_SITE_TITLE%></title>
<style>
	body {font-size:12px;color:#606060;}
	a {color:606060; text-decoration:none;}
	.detailViewBack {width:48px; height:48px; background:url(/m/images/zoom.png) 0 0 no-repeat; position:fixed; bottom:40px; right:10px; max-width:48px;}
	.detailViewBack a {display:block; text-align:center;}
</style>
</head>
<body>
<div class="detailViewBack">
	<a href="javascript:history.back()">
		<div style="margin-top:7px;"><img src="<%=M_IMG%>/zoom_back.png" alt="" /></div>
		<div style="margin-top:5px;"><%=LNG_M_BTN_PREVIOUS%></div>
	</a>
</div>
	<div class="width95a">
	<%
		Select Case PAGE_SETTING

			Case "COMPANY"
				Select Case view
	%>
					<%Case "1"%>
						<p><img src="<%=IMG_CONTENT%>/company01.jpg" width="100%" alt="" /></p>
					<%Case "2"%>
						<p><img src="<%=IMG_CONTENT%>/company02.jpg" width="100%" alt="" /></p>
					<%Case "3"%>
						<p><img src="<%=IMG_CONTENT%>/company03.jpg" width="100%" alt="" /></p>
					<%Case "4"%>
						<p><img src="<%=IMG_CONTENT%>/ready.jpg" width="100%" alt="" /></p>
					<%Case "5"%>
						<p><img src="<%=IMG_CONTENT%>/company05.jpg" width="100%" alt="" /></p>
					<%Case "6"%>
						<p><img src="<%=IMG_CONTENT%>/ready.jpg" width="100%" alt="" /></p>
					<%Case "7"%>
						<p><img src="<%=IMG_CONTENT%>/company07.jpg" width="100%" alt="" /></p>
					<%Case "8"%>
						<p><img src="<%=IMG_CONTENT%>/company08.jpg" width="100%" alt="" /></p>
					<%Case "9"%>
						<p><img src="<%=IMG_CONTENT%>/company09.jpg" width="100%" alt="" /></p>
					<%Case "10"%>
						<p><img src="<%=IMG_CONTENT%>/ready.jpg" width="100%" alt="" /></p>
					<%Case "11"%>
						<p><img src="<%=IMG_CONTENT%>/company11.jpg" width="100%" alt="" /></p>
					<%Case "12"%>
						<p><img src="<%=IMG_CONTENT%>/company12.jpg" width="100%" alt="" /></p>
					<%Case Else Call ALERTS(LNG_PAGE_ALERT01,"BACK","")%>
	<%
				End Select
	%>
	<%
			Case "PRODUCT"
				Select Case view
					Case "1"
						Select Case sview
							Case "1"
								PRINT viewImgOpt(IMG_CONTENT&"/product01.jpg","100%","","","usemap=""#pro01""")&"</div>"
							Case Else : Call ALERTS(LNG_PAGE_ALERT01,"back","")
						End Select
					Case "2"
						Select Case sview
							Case "1"
								PRINT viewImg(IMG_CONTENT&"/product02.jpg","100%","","")&"</div>"
							Case Else : Call ALERTS(LNG_PAGE_ALERT01,"back","")
						End Select
					'Case "3"
					Case "4"
						Select Case sview
							Case "1"
								PRINT viewImg(IMG_CONTENT&"/product03_01.jpg","100%","","")
								PRINT viewImgOpt(IMG_CONTENT&"/product03_02.jpg","100%","","","usemap=""#pro03""")&"</div>"
							Case "2"
								PRINT viewImg(IMG_CONTENT&"/product03.jpg","100%","","")&"</div>"
							Case Else : Call ALERTS(LNG_PAGE_ALERT01,"back","")
						End Select
					Case "5"
						Select Case sview
							Case "1"
								PRINT viewImg(IMG_CONTENT&"/product04_01.jpg","100%","","")
								PRINT viewImgOpt(IMG_CONTENT&"/product04_02.jpg","100%","","","usemap=""#pro04""")&"</div>"
							Case "2"
								PRINT viewImg(IMG_CONTENT&"/product03.jpg","100%","","")&"</div>"
							Case Else : Call ALERTS(LNG_PAGE_ALERT01,"back","")
						End Select
					Case "6"
						Select Case sview
							Case "1"
								PRINT viewImg(IMG_CONTENT&"/product05_01.jpg","100%","","")
								PRINT viewImgOpt(IMG_CONTENT&"/product05_02.jpg","100%","","","usemap=""#pro05""")&"</div>"
							Case "2"
								PRINT viewImg(IMG_CONTENT&"/product03.jpg","100%","","")&"</div>"
					Case Else : Call ALERTS(LNG_PAGE_ALERT01,"back","")
						End Select
					Case "7"
						Select Case sview
							Case "1"
								PRINT viewImg(IMG_CONTENT&"/product06_01.jpg","100%","","")&"</div>"
								PRINT viewImg(IMG_CONTENT&"/product06_02.jpg","100%","","")&"</div>"
							Case "2"
								PRINT viewImg(IMG_CONTENT&"/product03.jpg","100%","","")&"</div>"
					Case Else : Call ALERTS(LNG_PAGE_ALERT01,"back","")
						End Select
					Case "8"
						Select Case sview
							Case "1"
								PRINT viewImg(IMG_CONTENT&"/product07_01.jpg","100%","","")&"</div>"
								PRINT viewImg(IMG_CONTENT&"/product07_02.jpg","100%","","")&"</div>"
							Case "2"
								PRINT viewImg(IMG_CONTENT&"/product03.jpg","100%","","")&"</div>"
					Case Else : Call ALERTS(LNG_PAGE_ALERT01,"back","")
						End Select

				End Select
	%>
	<%
			Case "BUSINESS"
				Select Case view
	%>
					<%Case "1"%>
						<p><img src="<%=IMG_CONTENT%>/business01.jpg" width="100%" alt="" /></p>
					<%Case "2"%>
						<p><img src="<%=IMG_CONTENT%>/business02.jpg" width="100%" alt="" /></p>
					<%Case "3"%>
						<p><img src="<%=IMG_CONTENT%>/business03.jpg" width="100%" alt="" /></p>
					<%Case "4"%>
						<p><img src="<%=IMG_CONTENT%>/business04.jpg" width="100%" alt="" /></p>
					<%Case "5"%>
						<p><img src="<%=IMG_CONTENT%>/business05.jpg" width="100%" alt="" /></p>
					<%Case "6"%>
						<p><img src="<%=IMG_CONTENT%>/business06.jpg" width="100%" alt="" /></p>
					<%Case Else Call ALERTS(LNG_PAGE_ALERT01,"BACK","")%>
	<%
				End Select
	%>



	<%End Select%>
	</div>

</body>
</html>