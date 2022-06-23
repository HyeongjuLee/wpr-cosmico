<div id="all">
	<!--#include virtual = "/jscript/LayerPopup.asp"-->
	<!--#include virtual = "/_include/headerData_cs.asp"-->

	<!-- <script type="text/javascript">
		//top_wrap 고정
		$(document).ready(function() {
			//On Scroll Functionality
			$(window).on('scroll', function(){
				var windowTop = $(window).scrollTop();
				windowTop > 100 ? $('nav').addClass('navFixed') : $('nav').removeClass('navFixed');
				//windowTop > 100 ? $('ul').css('top','100px') : $('ul').css('top','160px');
			});

		});
	</script> -->

	<script type="text/javascript">
		$(function(){
			$('.sub-title').append($('.board-title'));
		})
	</script>

	<link rel="stylesheet" type="text/css" href="/css/myoffice-basic.css?">

	<div id="contain_wrap" class="layout_wrap">
		<div id="sub-header" class="sub-header">
			<div class="layout_inner">
				<article class="sub-header-txt">
					<!--#include virtual = "/_include/sub_header_text.asp"-->
				</article>
				<article class="myoffice-top-btn">
					<!-- <a class="home" href="/main/index.asp"><%=LNG_HEADER_HOME%></a> -->
					<a class="home" href="/index.asp"><%=LNG_HEADER_HOME%></a>
					<a class="logout" href="/common/member_logout.asp"><%=LNG_TEXT_LOGOUT%></a>
				</article>
			</div>
		</div>

		<div id="contain_M" class="layout_inner">
			<!--#include virtual = "/_include/nav_myoffice.asp"-->
			<div id="content">
				<div class="sub-title"><%=MAP_DEPTH3%></div>