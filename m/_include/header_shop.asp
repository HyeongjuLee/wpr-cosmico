<%Select Case SHOP_ORDER_PAGE_TYPE%>
<%Case "DETAIL"%>
<!--#include virtual = "/m/_include/header_detail.asp"-->
<%Case "ORDER"%>
<!--#include virtual = "/m/_include/header_order.asp"-->
<%Case "CART"%>
<!--#include virtual = "/m/_include/header_cart.asp"-->
<%Case Else%>
<%End Select%>