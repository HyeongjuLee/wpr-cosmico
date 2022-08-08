<%If ISLEFT = "T" Then%>

		<%If PAGE_SETTING = "MYOFFICE" Then %>
		<%Else%>

		<link rel="stylesheet" type="text/css" href="/css/nav-left.css">
		
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

		<%Select Case PAGE_SETTING%>
		<%Case "SNS"%>
		<article class="nav-left sns"> <%' sns left 상단에 보더값 주기 위함%>
		<%Case Else%>
		<article class="nav-left">
		<%End Select%>
			<ul>
				<li class="home"><a href="/index.asp" data-ripplet><i class="icon-home-1"></i><i class="right icon-right-open-big"></i></a></li>
				<li class="depth1">
					<ol>
						<!--#include virtual = "/navi/depth1.asp"-->
					</ol>
				</li>
				<li class="depth2">
					<ol>
						<%Select Case PAGE_SETTING%>
						<%Case "COMPANY"%>
						<!--#include virtual = "/navi/company.asp"-->
						<%Case "BRAND"%>
						<!--#include virtual = "/navi/brand.asp"-->
						<%Case "BUSINESS"%>
						<!--#include virtual = "/navi/business.asp"-->
						<%Case "GUIDE"%>
						<!--#include virtual = "/navi/guide.asp"-->
						<%Case "SHOP"%>
						<!--#include virtual = "/navi/shop.asp"-->
						<%Case "COMMUNITY"%>
						<!--#include virtual = "/navi/community.asp"-->
						<%Case "CUSTOMER"%>
						<!--#include virtual = "/navi/customer.asp"-->
						<%Case "MYPAGE"%>
						<!--#include virtual = "/navi/mypage.asp"-->
						<%Case "POLICY"%>
						<!--#include virtual = "/navi/policy.asp"-->
						<%Case "SNS"%>
						<!--#include virtual = "/navi/sns.asp"-->
						<%End Select%>
					</ol>
				</li>
				<%If sub_title_d4 <> "" Then %>
					<li class="depth3">
						<ol>
							<%Select Case PAGE_SETTING%>
							<%Case "BRAND"%>
							<!--#include virtual = "/navi/brand.asp"-->
							<%End Select%>
						</ol>
					</li>
				<%End If%>
			</ul>
		</article>
		
		<script type="text/javascript">
			$('.nav-left').each(function(){
				var right = '<i class="right icon-right-open-big"></i>';
				$('li.main:last').addClass('view');
				$('li.main.view').children().not('.nav-sub').remove();
				$('.depth2 .nav-sub2').remove();

				$('#left').attr('id', '');

				$('.nav-left .depth1').each(function(){
					var main = $('.depth1 li.main');
					var depth = main.eq(<%=NAVI_P_NUM%> - 1);

					depth.addClass('depth');
					main.not(depth).find('i').remove();
				});

				$('.nav-left .depth2').each(function(){
					var main = $('.depth2 ul li');
					var depth = main.eq(<%=view%> - 1);
					var navSub = $('.depth2 .nav-sub').not('.nav-sub2');

					$('.depth2 ol').html(navSub.find('li'));

					depth.addClass('depth');
				});

				$('.nav-left .depth3').each(function(){
					var main = $('.depth3 ul li');
					var depth = main.eq(<%=sview%> - 0);
					var navSub = $('.depth3 .nav-sub2');

					$('.depth3 ol').html(navSub.find('li'));
					depth.addClass('depth');
				});

				$('.depth').each(function(){
					$('.depth1 ol').before($('.depth1 li.depth').html());
					$('.depth1 > a').append(right).attr('href', '#;').addClass('depth');
					$('.depth1 ol').find('.depth');

					$('.depth2 ol').before($('.depth2 li.depth').html());
					$('.depth2 > a').append(right).attr('href', '#;').addClass('depth');
					$('.depth2 ol').find('.depth');
					$('.depth2 a.depth').attr('data-ripplet', '');
					// return false;

					$('.depth3 ol').before($('.depth3 li.depth').html());
					$('.depth3 > a').append(right).attr('href', '#;').addClass('depth');
					$('.depth3 ol').find('.depth');
					$('.depth3 a.depth').attr('data-ripplet', '');
					return false;

				});

				$('.depth1, .depth2, .depth3').each(function(){
					$(this).click(function(){
						if (!$(this).hasClass('view')) {
							!$(this).removeClass('view')
							$(this).addClass('view');
							$('li ol').addClass('view');
						}else{
							$(this).removeClass('view');
							$('li ol').removeClass('view');
						}
					});

					$(this).mouseleave(function(){
						setTimeout(function(){
							$('.depth1, .depth2, .depth3').removeClass('view');
							$('li ol').removeClass('view');
						}, 0);
					});

				});

				if ($('.depth3').length > 0) {
					$('.depth2').addClass('none');
				}

				console.log('<%=PAGE_SETTING%>', ' NAVI_P_NUM:' + '<%=NAVI_P_NUM%>', ' view : ' + '<%=view%>', ' mNum:' + '<%=mNum%>', ' sNum:' + '<%=sNum%>', ' sVar:' + '<%=sVar%>');
				console.log('sub_title_d2 : ' + '<%=sub_title_d2%>', ' sub_title_d3 : ' + '<%=sub_title_d3%>', ' sview:' + '<%=sview%>', ' sub_title_d4 : ' + '<%=sub_title_d4%>');

			});
		</script>

			<div id="LeftMenu" style="display: none;">
				<div id="left_navi">
					<div class="left_home" data-ripplet><a href="/index.asp"><i class="icon-home"></i></a></div>
					<ul class="left_navi">
						<%Select Case PAGE_SETTING%>
							<%Case "COMPANY"%>
							asdf
								<!--include virtual = "/subTitle/depth1.asp"-->
								<!--include virtual = "/subTitle/company.asp"-->
							<%Case "BUSINESS"%>
								<!--#include virtual = "/subTitle/depth1.asp"-->
								<!--#include virtual = "/subTitle/business.asp"-->
							<%Case "BRAND"%>
								<!--#include virtual = "/subTitle/depth1.asp"-->
								<!--#include virtual = "/subTitle/brand.asp"-->
							<%Case "CUSTOMER"%>
								<!--#include virtual = "/subTitle/depth1.asp"-->
								<!--#include virtual = "/subTitle/customer.asp"-->
							<%Case "POLICY"%>
							<!--#include virtual = "/subTitle/depth1_policy.asp"-->
							<!--#include virtual = "/subTitle/policy.asp"-->

							<%Case "MYPAGE"%>
								<!--#include virtual = "/subTitle/mypage.asp"-->
					<%
							Case "MEMBERSHIP"
					%>
							<!-- <li class="LEFT_main" ><a href="/salesman/salesman.asp"><%=LNG_MEMBERSHIP_SALESMAN_SEARCH%></a></li> -->
							<%If DK_MEMBER_ID = "GUEST" Then%>
								<li class="LEFT_main w2 first" ><a href="/common/joinStep01_nation.asp"><%=LNG_MEMBERSHIP_JOIN%></a></li>
								<li class="LEFT_main w2" ><a href="/common/member_idpw.asp"><%=LNG_MEMBERSHIP_IDPW_FIND%></a></li>
							<%End If%>

							<!-- <li class="LEFT_main" ><a href="/mypage/member_info.asp"><img src="<%=IMG_LEFT%>/mypage_01_off.png" alt=""/></a></li>
							<li class="LEFT_main" ><a href="/mypage/wish_list.asp"><img src="<%=IMG_LEFT%>/mypage_02_off.png" alt=""/></a></li>
							<li class="LEFT_main" ><a href="/shop/cart.asp"><img src="<%=IMG_LEFT%>/mypage_03_off.png" alt=""/></a></li>
							<li class="LEFT_main" ><a href="/mypage/order_list.asp"><img src="<%=IMG_LEFT%>/mypage_04_off.png" alt=""/></a></li> -->

					<%
						End Select
					%>
					</ul>
				</div>
			</div>
		<%End If%>

<%End If%>


<%If sview = "" Or IsNull(sview) Then sview = "null" %>

<%If PAGE_SETTING = "MYOFFICE" Then%>
		<script type="text/javascript">
		<!--
			$('#left_navi').DB_navi2DV({
				key:'',					//라이센스키
				pageNum:<%=view%>,		//페이지인식(메인)
				subNum:<%=sview%>,		//페이지인식(서브)
				motionSpeed:200,		//모션속도(밀리초) 200
				moveSpeed:300,			//모션속도(밀리초)	300
				delayTime:1500,			//클릭아웃시 딜레이시간(페이지인식인경우)	1500
				delayTime2:0,			//클릭아웃시 딜레이시간(페이지인식인경우)
				menuHeight:39
			});
		// -->
		</script>
<%End If%>

