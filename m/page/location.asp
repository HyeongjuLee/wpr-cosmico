<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	'Response.Redirect "/m/page/location_google.asp"

	PAGE_SETTING = "COMPANY"
	PAGE_SETTING2 = "SUBPAGE"
	ISLEFT = "T"
	ISSUBTOP = "T"

	view = 4
	mNum = 1

%>
<!--#include virtual = "/m/_include/document.asp"-->
<!--#include virtual = "/m/_include/jqueryload.asp"-->
</head>
<body onLoad="initialize()">
<!--#include virtual = "/m/_include/header.asp"-->
<div class="location">
	<div class="location-info">
		<h5><i class="icon-location"></i><%=LNG_COPYRIGHT_COMPANY%> &nbsp;<%=LNG_COMPANY_05%></h5>
		<ul class="info">
			<li>
				<h6><%=LNG_COPYRIGHT_TITLE_ADDRESS%></h6>
				<span><%=LNG_COPYRIGHT_ADDRESS%></span>
			</li>
			<li>
				<h6><%=LNG_COPYRIGHT_TITLE_TEL%></h6>
				<span><%=LNG_COPYRIGHT_TEL%></span>
			</li>
			<li>
				<h6><%=LNG_COPYRIGHT_TITLE_FAX%></h6>
				<span><%=LNG_COPYRIGHT_FAX%></span>
			</li>
		</ul>
		<a href="http://kko.to/N9HFUymov" target="_blank"><%=LNG_LOCATION_SEARCH%><span><i class="icon-angle-right"></i></span></a>
	</div>

	<!-- * 카카오맵 - 지도퍼가기 -->
	<!-- 1. 지도 노드 -->
	<div id="daumRoughmapContainer1647495153332" class="root_daum_roughmap root_daum_roughmap_landing"></div>

	<!--
		2. 설치 스크립트
		* 지도 퍼가기 서비스를 2개 이상 넣을 경우, 설치 스크립트는 하나만 삽입합니다.
	-->
	<script charset="UTF-8" class="daum_roughmap_loader_script" src="https://ssl.daumcdn.net/dmaps/map_js_init/roughmapLoader.js"></script>

	<!-- 3. 실행 스크립트 -->
	<script charset="UTF-8">
		new daum.roughmap.Lander({
			"timestamp" : "1647495153332",
			"key" : "29hsf",
			"mapWidth" : "",
			"mapHeight" : ""
		}).render();
	</script>
</div>
<!--#include virtual = "/m/_include/copyright.asp"-->

