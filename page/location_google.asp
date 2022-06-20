<!--#include virtual = "/_lib/strFunc.asp"-->
<!--#include virtual = "/_include/document.asp"-->
<%
	PAGE_SETTING = "COMPANY"
	ISLEFT = "T"
	ISSUBTOP = "T"

	view = 4
	mNum = 1

%>
<script src="https://maps.googleapis.com/maps/api/js?key=<%=G_BROWSER_KEY%>"></script>
<script>
	function initialize() {
		var myLatlng = new google.maps.LatLng(36.080170,128.321247);
		var mapOptions = {
			zoom: 16,
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
				maxWidth: 500
			//	size: new google.maps.Size(200,200)
			})
			infowindow.open(map, marker);
		});
	}




</script>
</head>
<body onload="initialize()">
<!--#include virtual = "/_include/header.asp"-->
<div id="pages">
	<div id="map_canvas" class="map"></div>
	<div class="add">
		<i></i>
		<p><%=LNG_COPYRIGHT_ADDRESS1%></p>
	</div>
</div>

<!--#include virtual = "/_include/copyright.asp"-->