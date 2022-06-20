<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	PAGE_SETTING = "RESEARCH"
	view = gRequestTF("view",True)
%>
<!--#include virtual = "/m/_include/document.asp"-->
<!--#include virtual = "/m/_include/jqueryload.asp"-->
<script type="text/javascript">
	$(window).scroll(function(){

			if ($(this).scrollTop() < ($('#tabArea').offset().top)/40) {
				$('.detailViewZoom').hide();
			}
			if ($(this).scrollTop() >= ($('#tabArea').offset().top)/40) {
				$('.detailViewZoom').show();
			}
	});
</script>
</head>
<body>
<!--#include virtual = "/m/_include/header.asp"-->
<!--#include virtual = "/m/_include/sub_header.asp"-->
<%
	If view=2 Then
		displayNone = ""
	Else
		displayNone = "display:none;"
	End If

%>
<div class="detailViewZoom" style="<%=displayNone%>">
	<a href="popView.asp?ps=<%=PAGE_SETTING%>&view=<%=view%>" >
		<div style="margin-top:7px;"><img src="<%=M_IMG%>/zoom_icon.png" alt="" /></div>
		<div style="margin-top:5px;">확 대</div>
	</a>
</div>
<div id=" content" class="cleft">
	<div class="company"  id="tabArea" style="border:0px;margin-top:0px;">
	<%Select Case view%>
		<%Case "1"%>
			<p><img src="<%=M_IMG%>/research01.png" width="100%" alt="" /></p>
		<%Case "2"%>
			<p><img src="<%=M_IMG%>/research02.png" width="100%" alt="" /></p>

		<%Case Else Call ALERTS("존재하지 않는 페이지입니다","BACK","")%>
	<%End Select%>
    </div>
	<!-- <p style="padding:10px 10px; text-align:right;"><img src="<%=M_IMG%>/company_02.png" alt="" /></p> -->

</div>
<!--#include virtual = "/m/_include/copyright.asp"-->