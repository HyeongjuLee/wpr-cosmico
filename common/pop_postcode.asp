<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual = "/_include/document.asp"-->
<%
	zipType = gRequestTF("z",false)				'oris, takes, ''
	If zipType = "" Then zipType = ""
%>
<script src="https://ssl.daumcdn.net/dmaps/map_js_init/postcode.v2.js"></script>
<script src="/jscript/daumPostCode.js"></script>
<style>
	#loadingPro {position: fixed; z-index: 99999; width: 100%; height: 100%; top: 0px; left: 0px; }
	#loadingPro .loadingImg {position: relative; top: 40%; text-align: center;}
</style>
</head>
<body onload="execDaumPostcode_modal('<%=zipType%>');">
	<div id="loadingPro">
		<div class="loadingImg" ><img src="<%=IMG%>/159.gif" width="40" alt="loadingImg" /></div>
	</div>
	<div id="wrap"></div>
	<script src="/jscript/daumPostCode_modal.js"></script>
</body>
</html>
