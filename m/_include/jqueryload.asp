<%
	NEW_SIDE_MENU_TF = "T"	'New사이드메뉴TF
%>



<%If NEW_SIDE_MENU_TF = "T" Then%>
	<%'White%>

	<!-- <script type="text/javascript" src="/m/jquerymobile/jquery-1.9.1.min.js"></script> -->
	<script src='https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js' integrity='sha512-894YE6QWD5I59HgZOGReFYm4dnWc1Qt5NtvYSaNcOP+u1T9qYdvdihz0PPSiiqn/+/3e7Jo4EaG7TubfWGUrMQ==' crossorigin='anonymous'></script>

	<link type="text/css" rel="stylesheet" href="/m/jquerymobile/jqm-datebox-1.4.0.min.css" />
	<link type="text/css" rel="stylesheet" href="/m/css/docs.css?v1" />
	<link type="text/css" rel="stylesheet" href="/m/js/mmenu/jquery.mmenu.all_New.css" /><%'추가%>
	<link type="text/css" rel="stylesheet" href="/m/js/mmenu/jquery.mmenu.custom.css" /><%'추가%>

	<script type="text/javascript" src="/m/js/left_nav_New.js"></script><%'좌우메뉴 설정%>
	<script type="text/javascript" src="/m/js/mmenu/jquery.mmenu.all.min.js"></script><%'추가%>
	<script type="text/javascript" src="/m/jquerymobile/jquery.hammer.min.js"></script>

<%Else%>
	<%'Black%>

	<!-- <script type="text/javascript" src="/m/jquerymobile/jquery-1.9.1.min.js"></script> -->
	<script src='https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js' integrity='sha512-894YE6QWD5I59HgZOGReFYm4dnWc1Qt5NtvYSaNcOP+u1T9qYdvdihz0PPSiiqn/+/3e7Jo4EaG7TubfWGUrMQ==' crossorigin='anonymous'></script>

	<link type="text/css" rel="stylesheet" href="/m/jquerymobile/jqm-datebox-1.4.0.min.css" />
	<link type="text/css" rel="stylesheet" href="/m/css/docs.css?v1" />
	<link type="text/css" rel="stylesheet" href="/m/js/mmenu/jquery.mmenu.all.css" />

	<script type="text/javascript" src="/m/js/left_nav.js"></script>
	<script type="text/javascript" src="/m/js/mmenu/jquery.mmenu.min.all.js"></script>
	<script type="text/javascript" src="/m/jquerymobile/jquery.hammer.min.js"></script>
	<script type="text/javascript" src="/m/jquery/jquery.easing.1.3.js"></script>

<%End If%>






