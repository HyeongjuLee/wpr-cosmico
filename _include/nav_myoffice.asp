<%
	'WEBID		= "<div><span>"&LNG_TEXT_WEBID&"</span><p>"&DK_MEMBER_WEBID&"</p></div>" & VbCrLf
	'MEMID		= "<div><span>"&LNG_TEXT_MEMID&"</span><p>"&DK_MEMBER_ID1&" - "&Fn_MBID2(DK_MEMBER_ID2)&"</p></div>" & VbCrLf
	'CENTER		= "<div><span>"&LNG_LEFT_MEM_INFO_CENTER&"</span><p>"&RS_BusinessName&"</p></div>" & VbCrLf
	POSITION	= "<div><span>"&LNG_TEXT_POSITION&"</span><p>"&nowGrade&"</p></div>" & VbCrLf
	REGTIME		= "<div><span>"&LNG_TEXT_REGTIME&"</span><p>"&date8to10(DKRSG_regTime)&"</p></div>" & VbCrLf

	Function Fnc_leftmenu_color(valThisPage, valThisPage2, valText)
		If valThisPage = valThisPage2 Then
			Fnc_leftmenu_color = "<p class=""select"">"&valText&"</p>"
		Else
			Fnc_leftmenu_color = "<p>"&valText&"</p>"
		End If
	End Function
	Function Fnc_leftmenu_color2(valThisPage, valThisPage2, valThisPage3, valText)
		If valThisPage = valThisPage2 or valThisPage = valThisPage3 Then
			Fnc_leftmenu_color2 = "<p class=""select"">"&valText&"</p>"
		Else
			Fnc_leftmenu_color2 = "<p>"&valText&"</p>"
		End If
	End Function

	'print SAVE_MENU_USING	'후원인메뉴 사용
	'print NOM_MENU_USING	'추천인메뉴 사용
%>
<script type="text/javascript" src="/jscript/hoverslippery.js"></script>

<%If ISLEFT = "T" Then%>
<div class="nav-myoffice">
	<article class="nav-left">
		<div class="nav-top">
			<div class="logo"><img src="/images/share/logo(1).svg" alt="" height="42"></div>
			<%If DK_MEMBER_TYPE = "ADMIN" Then%>
			<div class="info admin">
					<div class="name">ADMIN</div>
				</div>
			<%Else%>
			<div class="info">
				<div class="name">
					<h1><%=DK_MEMBER_NAME%></h1>
					<span><%=DK_MEMBER_ID1%> - <%=Fn_MBID2(DK_MEMBER_ID2)%></span>
					<a href="/mypage/member_info.asp"><i class="icon-cog-1"></i></a>
				</div>
				<!-- <div class="user">
					<%=INFO_SET%>
				</div> -->
			</div>
			<%End If%>
		</div>
		<div class="nav-menu">
			<%
			Select Case DK_MEMBER_STYPE
			%>
			<%Case "9"	'관리자%>
				<%'고객센터%>
				<div class="list">
					<div class="menu">
						<i class="icon-list"></i>
						<p><%=LNG_CUSTOMER%></p>
						<span></span>
					</div>
					<ul>
						<li><a href="/cboard/board_list.asp?bname=myoffice"><%=Fnc_leftmenu_color(INFO_MODE,"NOTICE1-1",LNG_MYOFFICE_NOTICE)%></a></li>
						<!-- <li><a href="/faq/faq_list.asp"><%=Fnc_leftmenu_color(INFO_MODE,"NOTICE1-2",LNG_CUSTOMER_02)%></a></li> -->
						<li><a href="/counsel/1on1_list.asp"><%=Fnc_leftmenu_color(INFO_MODE,"NOTICE1-3",LNG_CUSTOMER_05)%></a></li>
					</ul>
				</div>

			<%Case "1"	'소비자%>
				<div class="list">
					<%If isMACCO = "T" Then%>
					<a href="/myoffice/buy/order_list_macco.asp">
						<i class="icon-news-paper"></i>
						<%=Fnc_leftmenu_color(INFO_MODE,"BUY1-1",LNG_MYOFFICE_BUY_01)%>
						<span></span>
					</a>
					<%Else%>
					<a href="/myoffice/buy/order_list.asp">
						<i class="icon-news-paper"></i>
						<%=Fnc_leftmenu_color(INFO_MODE,"BUY1-1",LNG_MYOFFICE_BUY_01)%>
						<span></span>
					</a>
					<%End IF%>
				</div>

			<%Case "0"	'판매원%>
				<%'대시보드%>
				<%If false then%>
				<div class="list">
					<a href="/myoffice/dashboard/index.asp"><i class="icon-th-large"></i>
						<%=Fnc_leftmenu_color(INFO_MODE,"DASHBOARD",LNG_MYOFFICE_DASHBOARD)%>
						<span></span>
					</a>
				</div>
				<%End If%>

				<%'고객센터%>
				<div class="list">
					<div class="menu">
						<i class="icon-list"></i>
						<p><%=LNG_CUSTOMER%></p>
						<span></span>
					</div>
					<ul>
						<li><a href="/cboard/board_list.asp?bname=myoffice"><%=Fnc_leftmenu_color(INFO_MODE,"NOTICE1-1",LNG_MYOFFICE_NOTICE)%></a></li>
						<li><a href="/faq/faq_list.asp"><%=Fnc_leftmenu_color(INFO_MODE,"NOTICE1-2",LNG_CUSTOMER_02)%></a></li>
						<li><a href="/counsel/1on1_list.asp"><%=Fnc_leftmenu_color(INFO_MODE,"NOTICE1-3",LNG_CUSTOMER_05)%></a></li>
					</ul>
				</div>

				<%'산하회원정보%>
				<div class="list">
					<div class="menu">
						<i class="icon-person"></i>
						<p><%=LNG_MYOFFICE_MEMBER%></p>
						<span></span>
					</div>
					<ul>
						<%If NOM_MENU_USING Then%><li><a href="/myoffice/member/member_UnderInfo.asp?sc=v"><%=Fnc_leftmenu_color(INFO_MODE,"MEMBER1-2",LNG_MYOFFICE_MEMBER_02)%></a></li><%End If%>
						<%If SAVE_MENU_USING Then%><li><a href="/myoffice/member/member_UnderInfo.asp?sc=s"><%=Fnc_leftmenu_color(INFO_MODE,"MEMBER1-1",LNG_MYOFFICE_MEMBER_01)%></a></li><%End If%>
						<%If 1=2 Then%>
							<%If NOM_MENU_USING Then%><li><a href="/myoffice/member/memberVote.asp"><%=Fnc_leftmenu_color(INFO_MODE,"MEMBER1-2",LNG_MYOFFICE_MEMBER_02)%></a></li><%End If%>
							<%If SAVE_MENU_USING Then%><li><a href="/myoffice/member/memberSponsor.asp"><%=Fnc_leftmenu_color(INFO_MODE,"MEMBER1-1",LNG_MYOFFICE_MEMBER_01)%></a></li><%End If%>
							<%If NOM_MENU_USING Then%><li><a href="/myoffice/member/memberVoteAll.asp"><%=Fnc_leftmenu_color(INFO_MODE,"MEMBER1-2",LNG_MYOFFICE_MEMBER_02&"(전체)")%></a></li><%End If%>
							<%If SAVE_MENU_USING Then%><li><a href="/myoffice/member/memberSponsorAll.asp"><%=Fnc_leftmenu_color(INFO_MODE,"MEMBER1-1",LNG_MYOFFICE_MEMBER_01&"(전체)")%></a></li><%End If%>
						<%End If%>
						<%If NOM_MENU_USING Then%><li><a onclick='window.open("/myoffice/org/T_tree_vt_V11.asp","","");'><p><%=LNG_MYOFFICE_CHART_02%></p></a></li><%End If%>
						<%If SAVE_MENU_USING Then%><li><a onclick='window.open("/myoffice/org/T_tree_ss_V11.asp","","");'><p><%=LNG_MYOFFICE_CHART_01%></p></a></li><%End If%>
						<%If NOM_MENU_USING Then%><li><a onclick='window.open("/myoffice/member/P1_E_Tree_vt.asp","","");'><p><%=LNG_MYOFFICE_CHART_06%></p></a></li><%End If%>
						<%If SAVE_MENU_USING Then%><li><a onclick='window.open("/myoffice/member/P1_E_Tree_ss.asp","","");'><p><%=LNG_MYOFFICE_CHART_05%></p></a></li><%End If%>

						<%if 1=1 then%>
						<!-- <li><a href="/myoffice/member/member_UnderInfo.asp"><%=Fnc_leftmenu_color(INFO_MODE,"MEMBER1-6",LNG_MYOFFICE_MEMBER_06)%></a></li> -->
						<%If SAVE_MENU_USING Then%><li><a href="/myoffice/member/member_UnderSpon.asp"><%=Fnc_leftmenu_color(INFO_MODE,"MEMBER1-7",LNG_MYOFFICE_MEMBER_07)%></a></li><%End If%>
						<%End If%>
					</ul>
				</div>

				<%'주문신청%>
				<%If 1=2 Then%>
				<div class="list">
					<div class="menu">
						<i class="icon-shopping-cart1"></i>
						<p><%=LNG_MYOFFICE_ORDER_01%></p>
						<span></span>
					</div>
					<ul>
						<li><a href="/myoffice/buy/goodsList.asp"><%=Fnc_leftmenu_color(INFO_MODE,"ORDER1-2",LNG_MYOFFICE_ORDER_01)%></a></li>
						<li><a href="/myoffice/buy/cart.asp"><%=Fnc_leftmenu_color(INFO_MODE,"ORDER1-3",LNG_MYOFFICE_ORDER_02)%></a></li>
					</ul>
				</div>
				<%End If%>

				<%'주문내역%>
				<div class="list">
					<div class="menu">
						<i class="icon-news-paper"></i>
						<p><%=LNG_MYOFFICE_BUY%></p>
						<span></span>
					</div>
					<ul>
						<%If isMACCO = "T" Then%>
							<li><a href="/myoffice/buy/order_list_macco.asp"><%=Fnc_leftmenu_color(INFO_MODE,"BUY1-1",LNG_MYOFFICE_BUY_01)%></a></li>
						<%Else%>
							<li><a href="/myoffice/buy/order_list.asp"><%=Fnc_leftmenu_color(INFO_MODE,"BUY1-1",LNG_MYOFFICE_BUY_01)%></a></li>
						<%End IF%>
							<%If NOM_MENU_USING Then%><li><a href="/myoffice/buy/underPurchase.asp?u=v"><%=Fnc_leftmenu_color(INFO_MODE,"BUY1-3",LNG_MYOFFICE_BUY_03)%></a></li><%End If%>
							<%If SAVE_MENU_USING Then%><li><a href="/myoffice/buy/underPurchase.asp?u=s"><%=Fnc_leftmenu_color(INFO_MODE,"BUY1-2",LNG_MYOFFICE_BUY_02)%></a></li><%End If%>
					</ul>
				</div>

				<%'보너스 내역%>
				<div class="list">
					<div class="menu">
						<i class="icon-wallet"></i>
						<p><%=LNG_MYOFFICE_BONUS%></p>
						<span></span>
					</div>
					<ul>
						<li><a href="/myoffice/pay/pay03.asp"><%=Fnc_leftmenu_color(INFO_MODE,"BONUS1-3",LNG_MYOFFICE_BONUS_03)%></a></li>
					</ul>
				</div>

				<%'오토쉽 내역%>
				<div class="list">
					<div class="menu">
						<i class="icon-wallet"></i>
						<p><%=LNG_MYOFFICE_AUTOSHIP%></p>
						<span></span>
					</div>
					<ul>
						<li><a href="/myoffice/autoship/order_list_CMS.asp"><%=Fnc_leftmenu_color(INFO_MODE,"AUTOSHIP1-1",LNG_MYOFFICE_AUTOSHIP_01)%></a></li>
						<li><a href="/myoffice/autoship/order_list_CMS_reg.asp"><%=Fnc_leftmenu_color(INFO_MODE,"AUTOSHIP1-2",LNG_MYOFFICE_AUTOSHIP_02)%></a></li>
					</ul>
				</div>

				<%'포인트%>
				<%If isSHOP_POINTUSE = "T" And 1=1 Then%>
				<div class="list">
					<div class="menu">
						<i class="icon-coin-dollar"></i>
						<p><%=SHOP_POINT%></p>
						<span></span>
					</div>
					<ul>
						<li><a href="/myoffice/point/point_list.asp?mn=1"><%=Fnc_leftmenu_color(INFO_MODE,"POINT1-1",LNG_HEADERDATA_CS_POINT_TEXT01_1)%></a></li>
						<li><a href="/myoffice/point/point_transfer.asp?mn=1"><%=Fnc_leftmenu_color(INFO_MODE,"POINT1-3",LNG_MYOFFICE_POINT_02)%></a></li>
						<li><a href="/myoffice/point/point_withdraw.asp?mn=1"><%=Fnc_leftmenu_color(INFO_MODE,"POINT1-4",LNG_MYOFFICE_POINT_03)%></a></li>
						<%If 1=2 Then%>
						<li><a href="/myoffice/point/point_list.asp?mn=2"><%=Fnc_leftmenu_color(INFO_MODE,"POINT2-1",LNG_HEADERDATA_CS_POINT_TEXT01_1)%></a></li>
						<li><a href="/myoffice/point/point_transfer.asp?mn=2"><%=Fnc_leftmenu_color(INFO_MODE,"POINT2-3",LNG_MYOFFICE_POINT_02)%></a></li>
						<li><a href="/myoffice/point/point_withdraw.asp?mn=2"><%=Fnc_leftmenu_color(INFO_MODE,"POINT2-4",LNG_MYOFFICE_POINT_03)%></a></li>
						<%End If%>
					</ul>
				</div>
				<%End If%>

				<%If DK_BUSINESS_CNT > 0 Then	'센터장%>
				<div class="list">
					<div class="menu">
						<i class="icon-news-paper"></i>
						<p><%=LNG_MYOFFICE_BCENTER%></p>
						<span></span>
					</div>
					<ul>
						<li><a href="/myoffice/business/business_member.asp"><%=Fnc_leftmenu_color(INFO_MODE,"BCENTER1-1",LNG_MYOFFICE_BCENTER_01)%></a></li>
						<li><a href="/myoffice/business/business_purchase.asp"><%=Fnc_leftmenu_color(INFO_MODE,"BCENTER1-2",LNG_MYOFFICE_BCENTER_02)%></a></li>
					</ul>
				</div>
				<%End If%>

				<%If 1=2 Then%>
				<%'코인 주문신청%>
				<div class="list">
					<div class="menu">
						<i class="icon-shopping-cart1"></i>
						<p><%=LNG_MYOFFICE_ORDER%></p>
						<span></span>
					</div>
					<%
						if webproIP = "T" THEN
							ThisLinked1 = "/myoffice/cshop/goodsList.asp"
							ThisLinked2 = "/myoffice/cshop/cart.asp"
						else
							ThisLinked1 = "javascript:alert('준비중입니다.');"
							ThisLinked2 = "javascript:alert('준비중입니다.');"
						end if
					%>
					<ul>
						<li><a href="<%=ThisLinked1%>"><%=Fnc_leftmenu_color(INFO_MODE,"CSHOP1-2",LNG_MYOFFICE_ORDER_01)%></a></li>
						<li><a href="<%=ThisLinked2%>"><%=Fnc_leftmenu_color(INFO_MODE,"CSHOP1-3",LNG_MYOFFICE_ORDER_02)%></a></li>
					</ul>
				</div>
				<%End If%>
			<%
			End Select
			%>
		</div>
	</article>
</div>

<script type="text/javascript">
	$(function(){
		$('p.select').closest('.list').addClass('select') && $('p.select').closest('li').addClass('select');
		$('.nav-menu .list ul').closest('.list').find('.menu span').append("<i class='icon-plus-1'></i><i class='icon-minus-1'></i>");

		$('.nav-menu .list').click(function(){
			var $list = 54;
			var $ul = $(this).children('ul').height();

			$(this).toggleClass('select');

			$(this).each(function(){
				if ($('.nav-menu .list').not($(this)).hasClass('select')) {
					$('.nav-menu .list').not($(this)).removeClass('select');
				}

			});

			// if ($(this).hasClass('select')) {
			// 	$(this).height($list + $ul);
			// }else{
			// 	$(this).height($list);
			// }
		});
		<%If PAGE_SETTING2 <> "MYPAGE" Then%>

		// var $el, topPos, newHeight, $main = $('.nav-menu');
		// $main.append("<i class='icon-angle-right'></i>");
		// var $dot = $('.icon-angle-right');

		// $dot
		// 	.css('top', $('.nav-menu').children('.list').position().top + 17)
		// 	.data('dotTop', $dot.position().top);
		// $('.nav-menu .list').hover(function(){
		// 	$el = $(this);
		// 	topPos = $el.position().top + 17;
		// 	$dot.stop().animate({
		// 		top: topPos
		// 	});
		// }, function(){
		// 	$dot.stop().animate({
		// 		top: $('.nav-menu .list.select').position().top + 17
		// 	});
		// });

		// setInterval(function(){
		// 	$(document).each(function(){
		// 		if ($('.icon-angle-right').position().top != $('.nav-menu .list.select').position().top + 17) {
		// 			$('.icon-angle-right').stop().animate({
		// 				top: $('.nav-menu .list.select').position().top + 17
		// 			});
		// 		}
		// 	});
		// },5000);

		<%End If%>
	});
</script>
<link rel="stylesheet" type="text/css" href="/css/nav-myoffice.css?v1">

<%End If%>

