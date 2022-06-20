<%
	TOP_BTN_LINE		= "<li class=""top-btn-line""></li>" & VbCrLf
	TOP_BTN_HOME		= "<li><a href=""/main/index.asp"">"&LNG_HEADER_HOME&"</a></li>" & VbCrLf
	TOP_BTN_LOGIN		= "<li><a href=""/common/member_login.asp"">"&LNG_HEADER_LOGIN&"</a></li>" & VbCrLf
	TOP_BTN_LOGOUT		= "<li><a href=""/common/member_logout.asp"">"&LNG_TEXT_LOGOUT&"</a></li>" & VbCrLf
	'TOP_BTN_JOIN		= TOP_BTN_LINE & "<li><a href=""/common/joinStep01_nation.asp"">"&LNG_HEADER_JOIN&"</a></li>" & VbCrLf
	TOP_BTN_JOIN		= TOP_BTN_LINE & "<li><a href=""/common/joinStep01.asp"">"&LNG_HEADER_JOIN&"</a></li>" & VbCrLf
	TOP_BTN_SEARCH_IDPW	= TOP_BTN_LINE & "<li><a href=""/common/member_idpw.asp"">"&LNG_HEADER_SEARCH_IDPW&"</a></li>" & VbCrLf
	TOP_BTN_DELIVERY	= TOP_BTN_LINE & "<li><a href=""/mypage/order_List.asp"">"&LNG_HEADER_DELIVERY&"</a></li>" & VbCrLf
	LNG_BTN_CSORDER		= TOP_BTN_LINE & "<li><a href=""/myoffice/buy/order_list.asp"">"&LNG_HEADER_CSORDER&"</a></li>" & VbCrLf
	TOP_BTN_MYPAGE		= TOP_BTN_LINE & "<li><a href=""/mypage/member_info.asp"">"&LNG_HEADER_MYPAGE&"</a></li>" & VbCrLf
	TOP_BTN_ADMIN		= TOP_BTN_LINE & "<li class=""admin""><a href=""/admin"">"&LNG_HEADER_ADMIN&"</a></li>" & VbCrLf
	TOP_BTN_ADMIN2		= TOP_BTN_LINE & "<li class=""admin""><a href=""/seller_admin"">"&LNG_HEADER_ADMIN2&"</a></li>" & VbCrLf
	TOP_BTN_CSCENTER	= TOP_BTN_LINE & "<li><a href=""/cboard/board_list.asp?bname=notice"">"&LNG_HEADER_CSCENTER&"</a></li>" & VbCrLf
	TOP_BTN_NOTICE		= TOP_BTN_LINE & "<li><a href=""/cboard/board_list.asp?bname=notice"">"&LNG_HEADER_NOTICE&"</a></li>" & VbCrLf
	TOP_BTN_CART		= TOP_BTN_LINE & "<li><a href=""/shop/cart.asp"">"&LNG_HEADER_CART&"</a></li>" & VbCrLf
	TOP_BTN_MYOFFICE	= TOP_BTN_LINE & "<li><a href=""/myoffice/buy/order_list.asp"">"&LNG_HEADER_MYOFFICE&"</a></li>" & VbCrLf
	TOP_BTN_SHOP		= TOP_BTN_LINE & "<li><a href=""/shop"">"&LNG_SHOP_HEADER_TXT_01&"</a></li>" & VbCrLf

	If PG_EXAM_MODE = "T" Then TOP_BTN_MYOFFICE = "" 'PG�ɻ��� ����

	Select Case DK_MEMBER_TYPE
		Case "MEMBER"
			TOP_BTN_SET = TOP_BTN_LOGOUT & TOP_BTN_MYPAGE
		Case "ADMIN","OPERATOR"
			TOP_BTN_SET = TOP_BTN_LOGOUT & TOP_BTN_CART & TOP_BTN_MYPAGE & TOP_BTN_MYOFFICE & TOP_BTN_ADMIN
		Case "SELLER"
			TOP_BTN_SET = TOP_BTN_LOGOUT & TOP_BTN_MYPAGE & TOP_BTN_ADMIN2
		Case "COMPANY"
			If DK_MEMBER_STYPE = "0" Then
			TOP_BTN_SET = TOP_BTN_LOGOUT & TOP_BTN_CART & TOP_BTN_MYPAGE & TOP_BTN_MYOFFICE
			Else
			TOP_BTN_SET = TOP_BTN_LOGOUT & TOP_BTN_CART & TOP_BTN_MYPAGE & TOP_BTN_MYOFFICE
			End If
		Case "GUEST"
			TOP_BTN_SET = TOP_BTN_LOGIN & TOP_BTN_JOIN & TOP_BTN_SEARCH_IDPW & TOP_BTN_MYOFFICE
	End Select
%>
