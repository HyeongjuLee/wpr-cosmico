<!--#include virtual = "/_include/header_top_btn.asp"-->

<script type="text/javascript" src="/jscript/topPopup.js"></script>

<div id="all">
	<img src="/images/main4.jpg" alt="" style="position: absolute; top: 0; left: 50%; transform: translateX(-50%); z-index: 999; opacity: 0.5; display: none;">
	<!--#include virtual = "/jscript/LayerPopup.asp"-->

	<%
		'Top Menu Targeting
		Function Fnc_TopMenu_ON(valThisPage, valThisPage2)
			If valThisPage = valThisPage2 Then
				Fnc_TopMenu_ON = "class=""on"""
			Else
				Fnc_TopMenu_ON = ""
			End If
		End Function
	%>

	<!-- header S-->

	<script type="text/javascript">
		$(function() {
			//On Scroll Functionality
			$('#header').removeClass('fixed');
			$(window).on({
				scroll: function(){
					var windowTop = $(window).scrollTop();
					windowTop > 80 ? $('#header').addClass('fixed') : $('#header').removeClass('fixed');
					//debugger;
				},
				each: function(){
					var offset = $(window).offset.top;
					offset > 80 ? $('#header').addClass('fixed') : $('#header').removeClass('fixed');
				}
			});
			

			$('.nav-main').hover(function(){
				$('#header').addClass('hover');
			}, function(){
				$('#header').removeClass('hover');
			});

			var $clickLi = $('#header .header-top-btn .menu');
			$clickLi.click(function(){
				$click($(this));
			});
			
			var $click = function(obj){
				$(obj).toggleClass('active');
				$(obj).find('ol').fadeToggle();
				$('.active').not($(obj)).removeClass('active');
				event.stopPropagation();
				// debugger;
				if ($clickLi.hasClass('active')) {
					$(obj).find('ol').fadeIn();
					$('html').click(function(e){
						if(!$(e.target).is($(obj).find('*'))) {
							$(obj).removeClass('active');
							$(obj).find('ol').fadeOut();
						}
					});
				}
			};
		});
	</script>

	<!-- header S-->
	<%Select Case PAGE_SETTING%>
	<%Case "INDEX"%>
		<header class="index">
	<%Case "COMMON", "JOIN"%>
		<header class="commons">
	<%Case Else%>
		<header>
	<%End Select%>
		<div id="header" class="header">
			<article>
				<div id="logo"><a href="/index.asp"><img src="/images/share/logo.svg?" alt="" /></a></div>
				<nav id="nav" class="nav">
					<ul class="nav-main">
						<!--#include virtual = "/navi/company.asp"-->
						<!--#include virtual = "/navi/brand.asp"-->
						<!--#include virtual = "/navi/business.asp"-->
						<!--#include virtual = "/navi/guide.asp"-->
						<!--#include virtual = "/navi/shop.asp"-->
						<!--#include virtual = "/navi/community.asp"-->
						<!--#include virtual = "/navi/customer.asp"-->
						<!--#include virtual = "/navi/sns.asp"-->
					</ul>
				</nav>
				<div class="header-top-btn">
					<div class="member">
						<a href="/myoffice/buy/order_list.asp" title="<%=LNG_HEADER_MYOFFICE%>"><i class="icon-member-1"></i></a>
					</div>
					<div class="searchs">
						<i class="icon-search-1"></i>
					</div>
					<div class="menu">
						<span></span>
						<span></span>
						<span></span>
						<ol>
							<%=TOP_BTN_SET%>
						</ol>
					</div>
				</div>
				<div class="search-wrap">
					<!--#include virtual = "/_include/header_search.asp"-->
				</div>
				<!--include virtual = "/_include/header_Lang.asp"-->
			</article>
			<span class="nav-bg"></span>
		</div>
	</header>



	<script type="text/javascript">
		/*
		//현재 화면에서 다른 페이지로 이동할 때 부드럽게 스크롤
		// to top right away
		if ( window.location.hash ) scroll(0,0);
		// void some browsers issue
		setTimeout( function() { scroll(0,0); }, 1);

		$(function() {

			// your current click function
			$('a[href*=#]').on('click', function(event){
				////event.preventDefault();
				$('html,body').animate({scrollTop:$(this.hash).offset().top-150}, 500);
			});

			// *only* if we have anchor on the url
			if(window.location.hash) {

				// smooth scroll to the anchor id
				$('html, body').animate({
					scrollTop: $(window.location.hash).offset().top-150
				}, 1000, 'swing');
			}

		});
		*/
	</script>
	<%Select Case PAGE_SETTING%>
	<%Case "COMMON", "JOIN"%>
		<script type="text/javascript">
			var $focus = function(){
				var $input = $('.input-wrap input');
				$input.on('focus blur', toggleFocus);

				function toggleFocus(e){
					if (e.type == 'focus') {
						$(this).parent('label').addClass('focus');
					}else {
						$(this).parent('label').removeClass('focus');
					}
				}
			};
			$(function(){
				$focus();
			});
		</script>
		<link rel="stylesheet" type="text/css" href="/css/common.css?" />
	<%Case Else%>
	<%End Select%>
	
	<div id="contain_wrap" class="layout_wrap <%=cw_class%>">
	<% If PAGE_SETTING <> "INDEX" Then%>
		<div id="sub-header" class="sub-header">
			<article class="sub-header-img">
				<%Select Case PAGE_SETTING%>
				<%Case "COMPANY"%>
					<img src="/images/top/s01.jpg" alt="" />
				<%Case "BRAND"%>
					<img src="/images/top/s02_2.jpg" alt="" />
				<%Case "PRODUCT"%>
					<img src="/images/top/s03.jpg" alt="" />
				<%Case "BUSINESS"%>
					<img src="/images/top/s04.jpg" alt="" />
				<%Case "GUIDE"%>
					<img src="/images/top/s05_2.jpg" alt="" />
				<%Case "COMMUNITY"%>
					<img src="/images/top/s06.jpg" alt="" />
				<%Case "CUSTOMER"%>
					<img src="/images/top/s07.jpg" alt="" />
				<%Case "MYOFFICE"%>
				<%Case "COMMON"%>
				<%Case "MEMBERSHIP"%>
				<%Case "SNS"%>
				<%Case Else%>
					<img src="/images/top/s07.jpg" alt="" />
				<%End Select%>
			</article>
			<article class="sub-header-txt">
				<!--#include virtual = "/_include/sub_header_text.asp"-->
			</article>
		</div>

	<%End If%>
		<%	If ISLEFT = "T" Then%>
		<%If PAGE_SETTING <> "MYOFFICE" Then%>
		<!--#include virtual = "/_include/left.asp"-->
		<%Else%>
		<%End If%>
		<div id="contain" class="layout_inner">
			<%If PAGE_SETTING = "MYOFFICE" Then%>
				<!--#include virtual = "/_include/nav_myoffice.asp"-->
				<div id="content_M">

				<script type="text/javascript">
					$(document).ready(function(){
						$(".userCWidth, .userCWidth2").css("width", "950px");
					});
				</script>

			<%Else%>
			<%End If%>
		<%	Else %>

			<!-- <div id="contain" class="layout_inner"> -->
			<div id="contentFull">
		<%	End If%>