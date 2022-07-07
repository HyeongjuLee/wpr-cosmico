<%If SHOP_ORDER_PAGE_TYPE <> "" Then%>
	
	<%Select Case SHOP_ORDER_PAGE_TYPE%>

	<%Case "DETAIL"%>
		<header>
			<div id="header" class="header shop detail">
			<!--#include virtual = "/m/_include/header_detail.asp"-->
			</div>
		</header>

	<%Case "ORDER"%>
		<header>
			<div id="header" class="header shop order">
			<!--#include virtual = "/m/_include/header_order.asp"-->
			</div>
		</header>

	<%Case "CART"%>
		<header>
			<div id="header" class="header shop cart">
			<!--#include virtual = "/m/_include/header_cart.asp"-->
			</div>
		</header>

	<%Case Else%>
	<%End Select%>

<%Else%>
<%End If%>