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
							<li><a href="/m/page/brand.asp?view=1"><%=LNG_BRAND_01%></a></li>
							<li><a href="/m/page/brand.asp?view=2"><%=LNG_BRAND_02%></a></li>
							<li><a href="/m/page/brand.asp?view=3"><%=LNG_BRAND_03%></a></li>

						<%' "PRODUCT"%>
						<li class="Label"><a><%=LNG_PRODUCT%></a></li>
							<li><a href="/m/page/product.asp?view=1"><%=LNG_PRODUCT_01%></a></li>
							<li><a href="/m/page/product.asp?view=2"><%=LNG_PRODUCT_02%></a></li>

						<%' "BUSINESS"%>
						<li class="Label"><a><%=LNG_BUSINESS%></a></li>
							<li><a href="/m/page/business.asp?view=1"><%=LNG_BUSINESS_01%></a></li>
							<li><a href="/m/page/business.asp?view=2"><%=LNG_BUSINESS_02%></a></li>
							<li><a href="/m/page/business.asp?view=3"><%=LNG_BUSINESS_03%></a></li>
							<li><a href="/m/page/business.asp?view=4"><%=LNG_BUSINESS_04%></a></li>
							<li><a href="/m/page/business.asp?view=5"><%=LNG_BUSINESS_05%></a></li>

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
							<li><a href="javascript:alert('준비중입니다');"><%=LNG_COMMUNITY_01%></a></li>
							<li><a href="javascript:alert('준비중입니다');"><%=LNG_COMMUNITY_02%></a></li>

						<%' "CUSTOMER"%>
						<li class="Label"><a><%=LNG_CUSTOMER%></a></li>
							<li><a href="/m/cboard/board_list.asp?bname=notice"><%=LNG_NOTICE%></a></li>
							<li><a href="/m/faq/faq_list.asp"><%=LNG_FAQ%></a></li>
							<li><a href="/m/counsel/1on1_list.asp"><%=LNG_1ON1%></a></li>
							<li><a href="/m/cboard/board_list.asp?bname=pds"><%=LNG_PDS%></a></li>
					</ul>

				</nav>
				<nav id="menu-right" class="mm-offcanvas">
					<ul>
						<%If DK_MEMBER_LEVEL > 0 Then%>
							<%If DK_MEMBER_STYPE = "0" Then%>
								<li class="Label" class="tweight" style="background-color: #ffffff; padding:10px 10px; line-height:30px;font-size:15px;margin-top:-20px;">
									<p><strong>Member Infomation</strong></p>
									<p><%=LNG_LEFT_MEM_INFO_NAME%> : <%=DK_MEMBER_NAME%></p>
									<p><%=LNG_LEFT_MEM_INFO_MEMID%> : <%=DK_MEMBER_ID1%> - <%=Right("0000000000000"&DK_MEMBER_ID2,MBID2_LEN)%></p>
									<%If DK_MEMBER_STYPE = "0" Then%>
									<p><%=LNG_LEFT_MEM_INFO_CENTER%> : <%=RS_BusinessName%></p>
									<p><%=LNG_TEXT_POSITION%> : <%=nowGrade%></p>
									<%End If%>
								</li>
								<li class="Label"><a><%=LNG_HEADER_LOGIN_M%></a></li>
									<li><a href="/m/common/member_logout.asp"><%=LNG_TEXT_LOGOUT%></a></li>
								<li class="Label"><a><%=LNG_MYOFFICE_BOARD%></a></li>
									<li><a href="/m/cboard/board_list.asp?bname=myoffice"><%=LNG_MYOFFICE_NOTICE%></a></li>
								<li class="Label"><a><%=LNG_MYPAGE%></a></li>
									<li><a href="/m/mypage/member_info.asp"><%=LNG_MYPAGE_01%></a></li>
									<!-- <li><a href="/m/counsel/1on1_list.asp"><%=LNG_MYPAGE_06%></a></li> -->
								<li class="Label"><a><%=LNG_MYOFFICE_MEMBER%></a></li>
									<%If NOM_MENU_USING Then%><li><a href="/m/member/member_UnderInfo.asp?sc=v"><%=LNG_MYOFFICE_MEMBER_02%></a></li><%End If%>
									<%If SAVE_MENU_USING Then%><li><a href="/m/member/member_UnderInfo.asp?sc=s"><%=LNG_MYOFFICE_MEMBER_01%></a></li><%End If%>
									<%If 1=2 Then%>
										<%If NOM_MENU_USING Then%><li><a href="/m/member/memberVote.asp"><%=LNG_MYOFFICE_MEMBER_02%></a></li><%End If%>
										<%If SAVE_MENU_USING Then%><li><a href="/m/member/memberSponsor.asp"><%=LNG_MYOFFICE_MEMBER_01%></a></li><%End If%>
									<%End If%>
									<%If NOM_MENU_USING Then%><li><a href="/m/orgm/t_tree_vt_v10.asp" target="_blank"><%=LNG_MYOFFICE_CHART_02%></a></li><%End If%>
									<%If SAVE_MENU_USING Then%><li><a href="/m/orgm/t_tree_ss_v10.asp" target="_blank"><%=LNG_MYOFFICE_CHART_01%></a></li><%End If%>
									<%If 1=2 Then%>
									<li><a href="/m/member/member_UnderInfo.asp"><%=LNG_MYOFFICE_MEMBER_06%></a></li>
									<%If SAVE_MENU_USING Then%><li><a href="/m/member/member_UnderSpon.asp"><%=LNG_MYOFFICE_MEMBER_07%></a></li><%End If%>
									<%End If%>

								<li class="Label"><a><%=LNG_MYOFFICE_BUY%></a></li>
									<li><a href="/m/buy/order_list.asp"><%=LNG_MYOFFICE_BUY_01%></a></li>
									<%If NOM_MENU_USING Then%><li><a href="/m/buy/underPurchase.asp?u=v"><%=LNG_MYOFFICE_BUY_03%></a></li><%End If%>
									<%If SAVE_MENU_USING Then%><li><a href="/m/buy/underPurchase.asp?u=s"><%=LNG_MYOFFICE_BUY_02%></a></li><%End If%>

								<%If 1=2 Then%>
								<li class="Label"><a><%=LNG_MYOFFICE_ORDER%></a></li>
									<li><a href="/m/buy/goodslist.asp"><%=LNG_MYOFFICE_ORDER_01%></a></li>
									<li><a href="/m/buy/cart.asp"><%=LNG_MYPAGE_03%></a></li>
								<%End If%>

								<li class="Label"><a><%=LNG_MYOFFICE_BONUS%></a></li>
									<li><a href="/m/pay/pay01.asp"><%=LNG_MYOFFICE_BONUS_01%></a></li>
									<li><a href="/m/pay/pay03.asp"><%=LNG_MYOFFICE_BONUS_03%></a></li>
								<%If 1=222 Then%>
								<li class="Label"><a><%=LNG_MYOFFICE_AUTOSHIP%></a></li>
									<li><a href="/m/autoship/order_list_CMS.asp"><%=LNG_MYOFFICE_AUTOSHIP_01%></a></li>
									<li><a href="/m/autoship/order_list_CMS_reg.asp"><%=LNG_MYOFFICE_AUTOSHIP_02%></a></li>
								<%End If%>

								<%If isSHOP_POINTUSE = "T" And 1=1 Then%>
								<li class="Label"><a><%=SHOP_POINT%></a></li>
									<li><a href="/m/point/point_list.asp?mn=1"><%=LNG_HEADERDATA_CS_POINT_TEXT01_1%></a></li>
									<li><a href="/m/point/point_transfer.asp?mn=1"><%=LNG_MYOFFICE_POINT_02%></a></li>
									<li><a href="/m/point/point_withdraw.asp?mn=1"><%=LNG_MYOFFICE_POINT_03%></a></li>
								<%End If%>
								<%If DK_BUSINESS_CNT > 0 Then%>
									<li class="Label"><a><%=LNG_MYOFFICE_BCENTER%></a></li>
										<li><a href="/m/business/business_member.asp"><%=LNG_MYOFFICE_BCENTER_01%></a></li>
										<li><a href="/m/business/business_purchase.asp"><%=LNG_MYOFFICE_BCENTER_02%></a></li>
								<%End If%>

							<%Else  ' 소비자회원%>
								<li class="Label" class="tweight" style="background-color: #ffffff; padding:10px 10px; line-height:30px;font-size:15px;margin-top:-20px;">
									<p class="tcenter"><strong>Member Infomation</strong></p>
									<p>성&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;명 : <%=DK_MEMBER_NAME%></p>
									<p>회원번호 : <%=DK_MEMBER_ID1%> - <%=Right("0000000000000"&DK_MEMBER_ID2,MBID2_LEN)%></p>
									<!-- <p>소&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;속 : <%=RS_BusinessName%></p> -->
								</li>
								<li class="Label"><a><%=LNG_HEADER_LOGIN_M%></a></li>
									<li><a href="/m/common/member_logout.asp"><%=LNG_HEADER_LOGOUT%></a></li>
								<li class="Label"><a><%=LNG_MYPAGE_01%></a></li>
									<li><a href="/m/mypage/member_info.asp"><%=LNG_MYPAGE_01%></a></li>
								<li class="Label"><a><%=LNG_MYOFFICE_BUY%></a></li>
									<li><a href="/m/buy/order_list.asp"><%=LNG_MYOFFICE_BUY_01%></a></li>

								<!-- <li class="Label" ><a><%=LNG_MYOFFICE_AUTOSHIP%></a></li>
									<li><a href="/m/autoship/order_list_CMS.asp"><%=LNG_MYOFFICE_AUTOSHIP_01%></a></li>
									<li><a href="/m/autoship/order_list_CMS_reg.asp"><%=LNG_MYOFFICE_AUTOSHIP_02%></a></li> -->

							<%End If%>
							
							<li class="Label" ><a><%=LNG_MARKETING_PLAN%></a></li>
								<li><a href="/m/business/marketing_plan.asp"><%=LNG_MARKETING_PLAN%></a></li>
								
						<%Else%>

							<li class="Label"><a><%=LNG_HEADER_LOGIN_M%></a></li>
								<li><a href="/m/common/member_login.asp"><%=LNG_HEADER_LOGIN%></a></li>
								<li><a href="/m/common/joinStep01.asp"><%=LNG_HEADER_JOIN%></a></li>
						<%End If%>

					</ul>
				</nav>
			</div>
		</header>
		<%' 원본 header 코드 E %>
		
		<%End If%>
	<%End Select%>

	<%
		Select Case PAGE_SETTING
			Case "COMPANY" 		NAVI_P_NUM = 1
			Case "BRAND"		NAVI_P_NUM = 2
			Case "PRODUCT"		NAVI_P_NUM = 3
			Case "BUSINESS" 	NAVI_P_NUM = 4
			Case "GUIDE"		NAVI_P_NUM = 5
			Case "SHOP"			NAVI_P_NUM = 6
			Case "COMMUNITY"	NAVI_P_NUM = 7
			Case "CUSTOMER"		NAVI_P_NUM = 8
			Case "SNS"			NAVI_P_NUM = 9
			'Case "MYPAGE"		NAVI_P_NUM = 6
			Case "MYOFFICE","MY_BUY","MY_MEMBER","PAY","MY_POINT" NAVI_P_NUM = 10
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
