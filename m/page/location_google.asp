<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	PAGE_SETTING = "COMPANY"
	ISLEFT = "T"
	ISSUBTOP = "T"

	view = 4
	sview = 1
	mNum = 1

%>
<!--#include virtual = "/m/_include/document.asp"-->
<!--#include virtual = "/m/_include/jqueryload.asp"-->
<script src="https://maps.googleapis.com/maps/api/js?key=<%=G_BROWSER_KEY%>"></script>
<script>
	function initialize() {
		var myLatlng = new google.maps.LatLng(36.080170,128.321247);
		var mapOptions = {
			zoom: 17,
			center: myLatlng,
			mapTypeId: google.maps.MapTypeId.ROADMAP
			}
		var map = new google.maps.Map(document.getElementById('map_canvas'), mapOptions);

		var marker = new google.maps.Marker({
			position: myLatlng,
			map: map,
			title:"클릭하세요!"
		});

		google.maps.event.addListener(marker, 'click', function() {
		var infowindow = new google.maps.InfoWindow(
			{
				content: '<h3><%=LNG_COPYRIGHT_ADDRESS1%></h3>',
			//	maxWidth: 500
				size: new google.maps.Size(100,100)
			})
			infowindow.open(map, marker);
		});
	}
</script>
</head>
<body onLoad="initialize()">
<!--#include virtual = "/m/_include/header.asp"-->
<!--#include virtual = "/m/_include/sub_header.asp"-->
<div id="content">
	<div class="map_area">
		<div id="map_canvas"></div>
		<div class="add">
			<p><%=LNG_COPYRIGHT_ADDRESS1%></p>
		</div>
	</div>
</div>
<!--#include virtual = "/m/_include/copyright.asp"-->

