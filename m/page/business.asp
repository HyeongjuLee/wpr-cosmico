<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	PAGE_SETTING = "BUSINESS"
	PAGE_SETTING2 = "SUBPAGE"
	ISLEFT = "T"
	ISSUBTOP = "T"

	view = gRequestTF("view",True)
	'sview = gRequestTF("sview",True)
	mNum = 5
	sNum = view
	sVar = sNum

	If PG_EXAM_MODE = "T" Then Call ALERTS(LNG_PAGE_ALERT01,"back","")		'PG

	If view= 1 Then
		'CALL ONLY_BUSINESS_MEMBER(DK_MEMBER_LEVEL,1)
	End If
	If view= 2 Then
		CALL ONLY_BUSINESS_MEMBER(DK_MEMBER_LEVEL,1)
	End If

	'Select Case view
	'	Case "3"
	'		Call ALERTs(LNG_MEMBER_LOGIN_ALERT01,"BACK","")
	'End Select

	'If view= 2 Then
	'	Call FNC_ONLY_CS_MEMBER
	'End If
%>
<!--#include virtual = "/m/_include/document.asp"-->
<!--#include virtual = "/m/_include/jqueryload.asp"-->

</head>
<body>
<!--#include virtual = "/m/_include/header.asp"-->

<%Select Case view%>
<%Case "1"%>
	<div class="location">
	<div class="location-info">
		<h5><%=LNG_COPYRIGHT_COMPANY%> &nbsp;<%=LNG_COMPANY_05%>&nbsp;<%=LNG_BUSINESS_info%></h5>
		<ul class="info">
			<li>
				<h6><%=LNG_COPYRIGHT_TITLE_ADDRESS%></h6>
				<span><%=LNG_BUSINESS_info_ADDRESS%></span>
			</li>
			<li>
				<h6><%=LNG_COPYRIGHT_TITLE_TEL%></h6>
				<span><%=LNG_COPYRIGHT_TEL%></span>
			</li>
			<li>
				<h6><%=LNG_COPYRIGHT_TITLE_EMAIL%></h6>
				<span><%=LNG_COPYRIGHT_EMAIL%></span>
			</li>
			<!-- <li>
				<h6><%=LNG_COPYRIGHT_TITLE_FAX%></h6>
				<span><%=LNG_COPYRIGHT_FAX%></span>
			</li> -->
		</ul>
		<a href="http://kko.to/RH5xH2LrT" target="_blank"><%=LNG_LOCATION_SEARCH%><span><i class="icon-angle-right"></i></span></a>
	</div>
	
	<!-- * 카카오맵 - 지도퍼가기 -->
	<!-- 1. 지도 노드 -->
	<div id="daumRoughmapContainer1655801920796" class="root_daum_roughmap root_daum_roughmap_landing"></div>

	<!--
		2. 설치 스크립트
		* 지도 퍼가기 서비스를 2개 이상 넣을 경우, 설치 스크립트는 하나만 삽입합니다.
	-->
	<script charset="UTF-8" class="daum_roughmap_loader_script" src="https://ssl.daumcdn.net/dmaps/map_js_init/roughmapLoader.js"></script>

	<!-- 3. 실행 스크립트 -->
	<script charset="UTF-8">
		new daum.roughmap.Lander({
			"timestamp" : "1655801920796",
			"key" : "2aox6",
			"mapWidth" : "",
			"mapHeight" : ""
		}).render();
	</script>
</div>
<%Case "2"%>
	<div class="ready">
		<div><img src="/images/content/maintenance-line.svg" alt=""></div>
		<p><%=LNG_READY_02_01%></p>
	</div>
<%Case "3"%>
	<div class="ready">
		<div><img src="/images/content/maintenance-line.svg" alt=""></div>
		<p><%=LNG_READY_02_01%></p>
	</div>
<%Case "4"%>
	<div class="ready">
		<div><img src="/images/content/maintenance-line.svg" alt=""></div>
		<p><%=LNG_READY_02_01%></p>
	</div>
<%Case "5"%>
	<div class="ready">
		<div><img src="/images/content/maintenance-line.svg" alt=""></div>
		<p><%=LNG_READY_02_01%></p>
	</div>

	<%Case Else Call ALERTS(LNG_PAGE_ALERT01,"BACK","")%>
<%End Select%>

<!--#include virtual = "/m/_include/copyright.asp"-->