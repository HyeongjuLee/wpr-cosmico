<li class="LEFT_main"><a href="/mypage/member_info.asp"><%=LNG_MYPAGE%></a>
	<div class="depth1_arrow"><i class="fas fa-chevron-right"></i></div>
</li>

<%Select Case sNum%>
<%Case "1"%><li class="LEFT_main"><a href="/mypage/member_info.asp"><%=LNG_MYPAGE_01%></a>
<%Case "2"%><li class="LEFT_main"><a href="/shop/cart.asp"><%=LNG_MYPAGE_03%></a>
<%Case "3"%><li class="LEFT_main"><a href="/counsel/1on1.asp"><%=LNG_MYPAGE_06%></a>
<%End Select%>
	<div class="depth1_arrow"><i class="fas fa-chevron-down"></i></div>

	<ul>
		<li><a href="/mypage/member_info.asp"><%=LNG_MYPAGE_01%></a></li>
		<li><a href="/shop/cart.asp"><%=LNG_MYPAGE_03%></a></li>
		<li><a href="/counsel/1on1.asp"><%=LNG_MYPAGE_06%></a></li>
		<li class="bg"></li>
	</ul>
</li>