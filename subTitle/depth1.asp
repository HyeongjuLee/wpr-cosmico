<%Select Case mNum%>
<%Case "1"%><li class="LEFT_main"><a href="/page/company.asp?view=1"><%=LNG_COMPANY%></a>
<%Case "2"%><li class="LEFT_main"><a href="/page/business.asp?view=1"><%=LNG_BUSINESS%></a>
<%Case "3"%><li class="LEFT_main"><a href="/page/brand.asp?view=1">기타기능</a>
<%Case "4"%><li class="LEFT_main"><a href="/shop/category.asp"><%=LNG_SHOP%></a>
<%Case "5"%><li class="LEFT_main"><a href="/cboard/board_list.asp?bname=notice"><%=LNG_CUSTOMER%></a>
<%End Select%>
	<div class="depth1_arrow"><i class="fas fa-chevron-right"></i></div>
	<ul>
		<li><a href="/page/company.asp?view=1"><%=LNG_COMPANY%></a></li>
		<li><a href="/page/business.asp?view=1"><%=LNG_BUSINESS%></a></li>
		<li><a href="/page/brand.asp?view=1">기타기능</a></li>
		<li><a href="/shop/category.asp"><%=LNG_SHOP%></a></li>
		<li><a href="/cboard/board_list.asp?bname=notice"><%=LNG_CUSTOMER%></a></li>
		<li class="bg"></li>
	</ul>
</li>