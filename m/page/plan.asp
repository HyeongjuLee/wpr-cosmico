<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	PAGE_SETTING = "PLAN"

	view = gRequestTF("view",True)
	sview = gRequestTF("sview",True)

%>
<!--#include virtual = "/m/_include/document.asp"-->
<!--#include virtual = "/m/_include/jqueryload.asp"-->
<script type="text/javascript">
	$(window).scroll(function(){

			if ($(this).scrollTop() < ($('#tabArea').offset().top)/4) {
				$('.detailViewZoom').hide();
			}
			if ($(this).scrollTop() >= ($('#tabArea').offset().top)/4) {
				$('.detailViewZoom').show();
			}
	});
</script>
</head>
<body>
<!--#include virtual = "/m/_include/header.asp"-->
<!--#include virtual = "/m/_include/sub_header.asp"-->
<div class="detailViewZoom" style="display:none;">
	<a href="popView.asp?ps=<%=PAGE_SETTING%>&view=<%=view%>&sview=<%=sview%>" >
		<div style="margin-top:7px;"><img src="<%=M_IMG%>/zoom_icon.png" alt="" /></div>
		<div style="margin-top:5px;"><%=LNG_M_BTN_ZOOMIN%></div>
	</a>
</div>
<div id=" content" class="cleft">
	<div class="product" id="tabArea" style="border:0px;margin-top:0px;">
	<%
		Select Case sview
			Case "1"
				PRINT viewImgOpt(IMG_CONTENT&"/plan01.jpg","100%","","","")&"</div>"
			Case "2"
				PRINT viewImgOpt(IMG_CONTENT&"/plan02.jpg","100%","","","")&"</div>"
			Case "3"
				PRINT viewImgOpt(IMG_CONTENT&"/plan03.jpg","100%","","","")&"</div>"
			Case "4"
				PRINT viewImgOpt(IMG_CONTENT&"/plan04.jpg","100%","","","")&"</div>"
			Case "5"
				PRINT viewImgOpt(IMG_CONTENT&"/plan05.jpg","100%","","","")&"</div>"
			Case "6"
				PRINT viewImgOpt(IMG_CONTENT&"/plan06.jpg","100%","","","")&"</div>"
			Case "7"
				PRINT viewImgOpt(IMG_CONTENT&"/plan07.jpg","100%","","","")&"</div>"
			Case "8"
				PRINT viewImgOpt(IMG_CONTENT&"/plan08.jpg","100%","","","")&"</div>"
			Case "9"
				PRINT viewImgOpt(IMG_CONTENT&"/plan09.jpg","100%","","","")&"</div>"
			Case "10"
				PRINT viewImgOpt(IMG_CONTENT&"/plan10.jpg","100%","","","")&"</div>"
			Case Else : Call ALERTS(LNG_PAGE_ALERT01,"back","")
		End Select
	%>
    </div>

</div>
<!--#include virtual = "/m/_include/copyright.asp"-->