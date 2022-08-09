<%
	If PAGE_SETTING = "SHOP" Then
		'Response.Redirect "/m/index.asp"	'FACITE 쇼핑몰X
	End If

	If PAGE_SETTING = "MYOFFICE" Then %>
	<!--#include virtual = "/_include/headerData_cs.asp"-->
	<!-- <link rel="stylesheet" type="text/css" href="/m/css/myoffice-basic.css"> -->
	<%End If
%>
<div data-role="page" id="page">
	<%' 모바일 height 100vh %>
	<!--#include virtual = "/m/_include/mobile-height.asp"-->

	<%Select Case PAGE_SETTING%>

		<%Case "JOIN"%>
		<header>
			<div id="header" class="header join">
				<!--#include virtual = "/m/_include/header_join.asp"-->
			</div>
		</header>

		<%Case "MYOFFICE"%>
		<header>
			<div id="header" class="header">
				<!--#include virtual = "/m/_include/header_myoffice.asp"-->
			</div>
			<!--#include virtual = "/m/_include/menu-right.asp"--><%'마이오피스 단독 사용 위해 menu-right 분리%>
		</header>
	<%Case Else%>

		<!--#include virtual = "/m/_include/header_shop.asp"-->

		<%If SHOP_ORDER_PAGE_TYPE <> "" Then%> <%'shop page 에서 header 코드 중복 방지%>
		<%Else%>

		<%' 원본 header 코드 S %>
		<header>
			<div id="header" class="header">
				<article>
					<div class="navi-left">
						<a href="#menu"><i class="icon-menu"></i></a>
					</div>
					<div id="logo"><a href="/m/index.asp"><img src="/images/share/logo.svg" alt="" /></a></div>
					<!--include virtual = "/_include/header_Lang.asp"-->
					<div class="member">
						<a href="/m/buy/order_list.asp" title="<%=LNG_HEADER_MYOFFICE%>"><i class="icon-member-1"></i></a>
					</div>
					<div class="navi-right">
						<a href="#menu-right"><i class="icon-menu"></i></a>
					</div>
				</article>
				<!-- <article class="top_menu">
					<ul>
						<% If PAGE_SETTING = "SHOP" Then %>
							<li class="main"><a href="/shop/category.asp"><span><%=LNG_SHOP_COMMON_TXT_01%></span></a></li>
							<% '1차 카테고리 나열
							arrParams_C1 = Array(_
								Db.makeParam("@strNationCode",adVarChar,adParamInput,6,UCase(DK_MEMBER_NATIONCODE)) _
							)
							arrList_C1 = Db.execRsList("DKSP_SHOP_CATEGORY_1DEPTH",DB_PROC,arrParams_C1,listLen_C1,Nothing)
							If IsArray(arrList_C1) Then
								For C1 = 0 To listLen_C1
									arrList_C1_strCateCode	= arrList_C1(1,C1)
									arrList_C1_strCateName	= arrList_C1(2,C1)

									''현재카테고리 타게팅CSS처리
									If Left(CATEGORY,3) = arrList_C1_strCateCode Then
										CM_BG_CSS = " mainLi2"
										CM_NM_CSS = "color:#0D5EA2;"
									Else
										CM_BG_CSS = ""
										CM_NM_CSS = ""
									End If
							%>
							<li class="main"><a href="/shop/category.asp?cm=<%=CATE_MODE%>&amp;cate=<%=arrList_C1_strCateCode%>"><span><%=arrList_C1_strCateName%></span></a></li>
							<%
								Next
							End If
							%>
							<script type="text/javascript">
								var categoryDepth = function(){
									var catename = $('.top_menu li.main').find('span:contains(<%=SUM_CATENAME%>)');
									console.log('<%=SHOP_ORDER_PAGE_TYPE%>');
									if (catename.text() > 0) {
										catename.closest('li.main').addClass('select');
									}
								};

								$(function(){
									categoryDepth();
								});
							</script>
						<%Else%>-->
						<!--include virtual = "/navi/company.asp"-->
						<!--include virtual = "/navi/cosmetic.asp"-->
						<!--include virtual = "/navi/enter.asp"-->
						<!--include virtual = "/navi/shop.asp"-->
						<!--include virtual = "/navi/customer.asp"-->
						<!--<%End If%>
					</ul>
				</article> -->

				<nav id="menu">
					<ul>
						<%' "COMPANY"%>
						<li class="Label"><a><%=LNG_COMPANY%></a></li>
							<li><a href="/m/page/company.asp?view=1"><%=LNG_COMPANY_01%></a></li>
							<li><a href="/m/page/company.asp?view=2"><%=LNG_COMPANY_02%></a></li>
							<li><a href="/m/page/company.asp?view=3"><%=LNG_COMPANY_03%></a></li>
							<li><a href="/m/page/company.asp?view=4"><%=LNG_COMPANY_04%></a></li>
							<li><a href="/m/page/location.asp"><%=LNG_LOCATION%></a></li>

						<%' "BRAND"%>
						<li class="Label"><a><%=LNG_BRAND%></a></li>
							<li><a href="/m/page/brand.asp?view=1&sview=1"><%=LNG_BRAND_01%></a>
								<ul>
									<li><a href="/m/page/brand.asp?view=1&sview=1"><%=LNG_BRAND_01_01%></a></li>
									<li><a href="/m/page/brand.asp?view=1&sview=2"><%=LNG_BRAND_01_02%></a></li>
								</ul>
							</li>
							<li><a href="/m/page/brand.asp?view=2&sview=1"><%=LNG_BRAND_02%></a></li>

						<%' "BUSINESS"%>
						<li class="Label"><a><%=LNG_BUSINESS%></a></li>
							<li><a href="/m/page/business.asp?view=1"><%=LNG_BUSINESS_01%></a></li>
							<!-- <li><a href="/m/salesman/salesmanSearch.asp"><%=LNG_BUSINESS_04%></a></li> -->

						<%' "GUIDE"%>
						<li class="Label"><a><%=LNG_GUIDE%></a></li>
							<li><a href="/m/page/guide.asp?view=1"><%=LNG_GUIDE_01%></a></li>
							<li><a href="/m/page/guide.asp?view=2"><%=LNG_GUIDE_02%></a></li>

						<%' "SHOP"%>
						<li class="Label"><a><%=LNG_SHOP%></a></li>
							<li><a href="/m/shop/category.asp"><%=LNG_SHOP_COMMON_TXT_01%></a>
							<!-- <%
								arrParams_S = Array(_
									Db.makeParam("@strCateParent",adVarChar,adParamInput,20,"000") _
								)
								SQL_S = "SELECT [intIDX],[strCateCode],[strCateName] FROM [DK_SHOP_CATEGORY] WHERE [intCateDepth] = 1 AND [isView] = 'T' AND [strCateParent] = ? AND [strNationCode] = '"&DK_MEMBER_NATIONCODE&"' ORDER BY [intCateSort] ASC"
								arrList_S = Db.execRsList(SQL_S,DB_TEXT,arrParams_S,listLen_S,Nothing)

								If IsArray(arrList_S) Then
									For i_s = 0 To listLen_S
										'1차
										PRINT "<li><a href=""/m/shop/category.asp?cm=all&cate="&arrList_S(1,i_s)&""">"&arrList_S(2,i_s)&"</a>"

										arrParams_S2 = Array(_
											Db.makeParam("@strCateParent",adVarChar,adParamInput,20,arrList_S(1,i_s)) _
										)
										SQL_S2 = "SELECT [intIDX],[strCateCode],[strCateName] FROM [DK_SHOP_CATEGORY] WHERE [intCateDepth] = 2 AND [isView] = 'T' AND [strCateParent] = ?  AND [strNAtionCode] = '"&DK_MEMBER_NATIONCODE&"' ORDER BY [intCateSort] ASC"
										arrList_S2 = Db.execRsList(SQL_S2,DB_TEXT,arrParams_S2,listLen_S2,Nothing)
										If IsArray(arrList_S2) Then
											PRINT "<ul class=""subCate"">"
											For i_s2 = 0 To listLen_S2
												'2차
												PRINT "<li><a href=""/m/shop/category.asp?cm=all&cate="&arrList_S2(1,i_s2)&""">"&arrList_S2(2,i_s2)&"</a>"

												arrParams_S3 = Array(_
													Db.makeParam("@strCateParent",adVarChar,adParamInput,20,arrList_S2(1,i_s2)) _
												)
												SQL_S3 = "SELECT [intIDX],[strCateCode],[strCateName] FROM [DK_SHOP_CATEGORY] WHERE [intCateDepth] = 3 AND [isView] = 'T' AND [strCateParent] = ?  AND [strNAtionCode] = '"&DK_MEMBER_NATIONCODE&"' ORDER BY [intCateSort] ASC"
												arrList_S3 = Db.execRsList(SQL_S3,DB_TEXT,arrParams_S3,listLen_S3,Nothing)
												If IsArray(arrList_S3) Then
													PRINT "<ul class=""subCate2"">"
													For i_s3 = 0 To listLen_S3
														'3차
														PRINT "<li><a href=""/m/shop/category.asp?cm=all&cate="&arrList_S3(1,i_s3)&""">"&arrList_S3(2,i_s3)&"</a></li>"

													Next
													PRINT "</ul>"

												Else
												PRINT "</li>"	'2차
												End If

											Next
											PRINT "</ul>"

										End If
										PRINT "</li>"	'1차

									Next
								End If
							%>
							<li><a href="/m/shop/cart.asp"><%=LNG_MYPAGE_03%></a></li> -->

						<%' "COMMUNITY"%>
						<li class="Label"><a><%=LNG_COMMUNITY%></a></li>
							<li><a href="/m/cboard/board_list.asp?bname=magazine"><%=LNG_COMMUNITY_01%></a></li>
							<li><a href="/m/cboard/board_list.asp?bname=technology"><%=LNG_COMMUNITY_02%></a></li>
							<li><a href="/m/cboard/board_list.asp?bname=movie">동영상게시판</a></li>

						<%' "CUSTOMER"%>
						<li class="Label"><a><%=LNG_CUSTOMER%></a></li>
							<li><a href="/m/cboard/board_list.asp?bname=notice"><%=LNG_NOTICE%></a></li>
							<li><a href="/m/faq/faq_list.asp"><%=LNG_FAQ%></a></li>
							<li><a href="/m/counsel/1on1_list.asp"><%=LNG_1ON1%></a></li>
							<li><a href="/m/cboard/board_list.asp?bname=pds"><%=LNG_PDS%></a></li>

						<%' "SNS"%>
						<li class="Label"><a><%=LNG_SNS%> COSMICOKOREA</a></li>
							<li><a href="/m/page/sns.asp"><span><%=LNG_SNS%></span></a></li>
							<!-- <li><a href="/m/cboard/board_list.asp?bname=sns_i"><span><%=LNG_SNS_02%></span></a></li>
							<li><a href="/m/cboard/board_list.asp?bname=sns_f"><span><%=LNG_SNS_03%></span></a></li> -->
					</ul>

				</nav>
				<!--#include virtual = "/m/_include/menu-right.asp"--><%'마이오피스 단독 사용 위해 menu-right 분리%>
			</div>
		</header>
		<%' 원본 header 코드 E %>

		<%End If%>
	<%End Select%>

	<%
		Select Case PAGE_SETTING
			Case "COMPANY" 		NAVI_P_NUM = 1
			Case "BRAND"		NAVI_P_NUM = 2
			Case "BUSINESS" 	NAVI_P_NUM = 3
			Case "GUIDE"		NAVI_P_NUM = 4
			Case "SHOP"			NAVI_P_NUM = 5
			Case "COMMUNITY"	NAVI_P_NUM = 6
			Case "CUSTOMER"		NAVI_P_NUM = 7
			Case "SNS"			NAVI_P_NUM = 8
			'Case "MYPAGE"		NAVI_P_NUM = 6
			Case "MYOFFICE","MY_BUY","MY_MEMBER","PAY","MY_POINT" NAVI_P_NUM = 9
			Case Else
				NAVI_P_NUM = 0
		End Select
	%>

	<script type="text/javascript">
		var	scrolled = false;
		var header = $('header').outerHeight();

		$( window ).scroll( function() {
			if ($( document ).scrollTop() > header && !scrolled) {
				$( '.top_menu' ).addClass( 'jbFixed' );
				//$('.top_menu').css({height: $('.top_menu').outerHeight() + 'px'});
				scrolled = true;
			}
			if ($( document ).scrollTop() < header && scrolled) {
				$( '.top_menu' ).removeClass( 'jbFixed' );
				// $('#top_menu').css({height: $('.top_menu').height() + 2 + 'px'});
				scrolled = false;
			}
		});

		var topMenu = function(){
			$('.top_menu li').removeClass('on');
			<%If NAVI_P_NUM < 1 Then%>
			<%Else%>
			var $li = $('.top_menu li').eq(<%=NAVI_P_NUM%> - 1);
			$li.addClass('on');
			<%End If%>

			<%If NAVI_P_NUM = 1 OR NAVI_P_NUM < 1 Then%>
				$(".top_menu ul").scrollLeft(0);
			<%Else%>
				<%If NAVI_P_NUM <> "7" Then%>
					$(".top_menu ul").scrollLeft($li.position().left - 100);
				<%End If%>
			<%End If%>
		};

		var linkval = function(){
			$('.top_menu .main').each(function(){
				var $link = $(this).find('a').attr('href');
				$(this).find('a').attr('href', '/m' + $link);
			});
			$('.nav-sub').remove();
		};

		$(function(){
			if ($('.top_menu').length > 0) {
				linkval();
				topMenu();
			}
		});

		console.log('<%=PAGE_SETTING%>', ' view : ' + '<%=view%>', ' sview : ' + '<%=sview%>', ' mNum:' + '<%=mNum%>', ' NAVI_P_NUM:' + '<%=NAVI_P_NUM%>');
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
	<%Case Else%>
	<%End Select%>

	<%Select Case PAGE_SETTING%>
	<%Case "COMMON"%>
		<link rel="stylesheet" type="text/css" href="/m/css/common.css?" />
	<%Case "JOIN"%>
		<link rel="stylesheet" type="text/css" href="/m/css/join.css?" />
	<%Case "SHOP"%>
		<link rel="stylesheet" type="text/css" href="/m/css/shop_style.css?">
	<%Case "MYOFFICE","MY_MEMBER","MY_BUY","PAY"%>
		<link rel="stylesheet" type="text/css" href="/m/css/myoffice.css?">
	<%Case Else%>
	<%End Select%>

	<div data-role="content" id="contain_wrap" >
	<%If PAGE_SETTING2 = "SUBPAGE" Then%>
	<%sub_header_height = ""
	If PAGE_SETTING <> "COMMON" Then sub_header_height = " narrow"%>
	<div id="sub-header" class="sub-header <%=sub_header_height%>">
			<article class="sub-header-img">
				<%Select Case PAGE_SETTING%>
				<%Case "COMPANY"%>
					<img src="/images/top/s01.jpg" alt="" />
				<%Case "BRAND"%>
					<img src="/images/top/s02.jpg" alt="" />
				<%Case "PRODUCT"%>
					<img src="/images/top/s03.jpg" alt="" />
				<%Case "BUSINESS"%>
					<img src="/images/top/s04.jpg" alt="" />
				<%Case "GUIDE"%>
					<img src="/images/top/s05.jpg" alt="" />
				<%Case "COMMUNITY"%>
					<img src="/images/top/s06.jpg" alt="" />
				<%Case "CUSTOMER"%>
					<img src="/images/top/s07.jpg" alt="" />
				<%Case "MYOFFICE"%>
				<%Case "COMMON"%>
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
	<%
		If PAGE_SETTING <> "INDEX" Then
		If PAGE_SETTING <> "SHOP" Then
		If PAGE_SETTING2 <> "SUBPAGE" Then

	%>
	<div class="content">
		<!--include virtual = "/_include/sub_header_text.asp"-->
	<%
		Else
	%>
		<!--include virtual = "/m/_include/mobile-height.asp"-->
		<!--#include virtual = "/m/_include/left.asp"-->
		<link rel="stylesheet" type="text/css" href="/m/css/nav-left.css?">
		<div class="content">

	<%
		End If
		End If
		End If
	%>
