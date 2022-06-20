<!--#include virtual="/_lib/strFunc.asp" -->
<%
	PAGE_SETTING = "MEMBERSHIP"
	ISLEFT = "T"
	ISSUBTOP = "T"
	ISSUBVISUAL = "T"
	view = 3
	sview = 1


%>
<!--#include virtual="/_include/document.asp" -->
<link rel="stylesheet" href="/css/join.css" />
<script type="text/javascript" src="/jscript/join.js"></script>
</head>
<body>
<!--#include virtual="/_include/header.asp" -->
<!--#include virtual = "/_include/sub_title.asp"-->

<iframe src="/hiddens.asp" name="hidden" frameborder="0" border="0" width="0" height="0" style="display:none;"></iframe>
<!-- <p><%=viewImg(IMG_JOIN&"/join_title.jpg",780,130,"")%></p> -->
<div id="join" style="margin-top:40px;">
	<div class="joinInner1">
		<form name="agreeFrm" method="post" action="joinStep02.asp" onSubmit="return chkAgree(this);">
			<!-- <p><%=viewImg(IMG_JOIN&"/join_type_top.gif",670,100,"")%></p> -->
			<p class="fleft" style="margin-top:40px;"><%=aImg2("http://fottn.w-pro.kr/",IMG_BTN&"/go_myoffice01.jpg",315,65,"")%></p>
			<p class="fright" style=" margin-top:40px;"><%=aImg2("http://fottn2nd.w-pro.kr/",IMG_BTN&"/go_myoffice02.jpg",315,65,"")%></p>
		</form>
	</div>
</div>
<!--#include virtual="/_include/copyright.asp" -->
