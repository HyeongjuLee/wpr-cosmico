<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	PAGE_SETTING = "GALLERY"
	PAGE_SETTING2 = "SUBPAGE"
	ISLEFT = "T"
	ISSUBTOP = "T"

	view = gRequestTF("view",True)
	'sview = gRequestTF("sview",True)
	mNum = 8
	sNum = view
	sVar = sNum

%>
<!--#include virtual = "/m/_include/document.asp"-->
<!--#include virtual = "/m/_include/jqueryload.asp"-->
<script src="/jscript/swiper-bundle.js"></script>
<link rel="stylesheet" href="/m/css/swiper-bundle.css">
<link rel="stylesheet" href="/m/css/gallery.css?v0">
</head>
<body>
<!--#include virtual = "/m/_include/header.asp"-->
<%Select Case view%>
	<%Case "1"%>
		<div id="gallery">
			<h6><span><%=LNG_GALLERY_01%></span>&nbsp;<%=LNG_GALLERY_02%></h6>
			<div class="swiper-container">
				<div class="swiper-wrapper">
					<div class="swiper-slide"><img src="/images/gallery/v01-min.jpg" alt=""></div>
					<div class="swiper-slide"><img src="/images/gallery/v02-min.jpg" alt=""></div>
					<div class="swiper-slide"><img src="/images/gallery/v03-min.jpg" alt=""></div>
					<div class="swiper-slide"><img src="/images/gallery/v04-min.jpg" alt=""></div>
					<div class="swiper-slide"><img src="/images/gallery/v05-min.jpg" alt=""></div>
				</div>
				<!-- <div class="swiper-inner">
					<div class="swiper-button prev" data-ripplet><i class="icon-left-open-1"></i></div>
					<div class="swiper-button next" data-ripplet><i class="icon-right-open-1"></i></div>
				</div> -->

				<script type="text/javascript">
					var swiper = new Swiper('.swiper-container', {
						centeredSlides: true,
						effect: 'slide',
						loop: true,
						//simulateTouch: false,
						//slidesPerGroup: 1,
						//slidesPerView: 1,
						//spaceBetween: 0;
						speed: 300,
						grabCursor: true,

						navigation: {
							nextEl: '.swiper-button.next',
							prevEl: '.swiper-button.prev',
						},

						pagination: {
							// el: '.swiper-pagination',
							// type: 'bullets',
							// type: 'fraction',
							// type: 'progressbar',
							// type: 'custom',
						},

						// scrollbar: {
						// 	el: '.swiper-scrollbar',
						// },

						autoplay: {
							delay: 3000,
							disableOnInteraction: false,
						}
					});
				</script>
			</div>
		</div>

	<%Case Else Call ALERTS(LNG_PAGE_ALERT01,"BACK","")%>
<%End Select%>

<!--#include virtual = "/m/_include/copyright.asp"-->