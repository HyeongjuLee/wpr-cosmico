<%
	If W1200 = "T" Then
		INNER_WIDTH = "layout_inner2"
		CONTENT_WIDTH = "layout_content2"
	Else
		INNER_WIDTH = "layout_inner1"
		CONTENT_WIDTH = "layout_content1"
	End If

	Function FNC_ADMIN_MENU_HOVER(valThisPage, valThisPage2)
		If (valThisPage) = (valThisPage2) Then
			FNC_ADMIN_MENU_HOVER = "hover"
		Else
			FNC_ADMIN_MENU_HOVER = ""
		End If
	End Function

%>
<div id="all">
	<div id="top_wrap" class="layout_wrap">
		<div id="top_line" class="layout_wrap">
			<div class="top_text <%=INNER_WIDTH%>">Webpro Administration Mode</div>
		</div>
		<div id="top_menu" class="<%=INNER_WIDTH%>">
			<ul>
				<li><a href="/admin/basic/default.asp"><p class="setting"><span class="<%=FNC_ADMIN_MENU_HOVER(ADMIN_LEFT_MODE,"CONFIG")%>">기본설정</span></p></a></li>
				<li><a href="/admin/member/member_list.asp"><p class="member"><span class="<%=FNC_ADMIN_MENU_HOVER(ADMIN_LEFT_MODE,"MEMBER")%>">회원관리</span></p></a></li>
				<li><a href="/admin/goods/default.asp"><p class="goods"><span class="<%=FNC_ADMIN_MENU_HOVER(ADMIN_LEFT_MODE,"GOODS")%>">상품관리</span></p></a></li>
				<li><a href="/admin/manage/default.asp"><p class="manage"><span class="<%=FNC_ADMIN_MENU_HOVER(ADMIN_LEFT_MODE,"MANAGE")%>">운영관리</span></p></a></li>
				<%IF CONST_MOBILE_ONLY = "T" Then%>
				<li><a href="/admin/cboard/default.asp"><p class="myoffice"><span class="<%=FNC_ADMIN_MENU_HOVER(ADMIN_LEFT_MODE,"CBOARD")%>">게시판</span></p></a></li>
				<%End If%>
				<%If UCase(DK_MEMBER_ID) = "WEBPRO" Then%>
					<li>|<br />|<br />|<br />|<br />|</li>
					<li><a href="/admin/design/default.asp"><p class="design"><span class="<%=FNC_ADMIN_MENU_HOVER(ADMIN_LEFT_MODE,"DESIGN")%>">디자인</span></p></a></li>
					<li><a href="/admin/myoffice/default.asp"><p class="myoffice"><span class="<%=FNC_ADMIN_MENU_HOVER(ADMIN_LEFT_MODE,"MYOFFICE")%>">마이오피스</span></p></a></li>
					<li><a href="/admin/order/default.asp"><p class="order"><span class="<%=FNC_ADMIN_MENU_HOVER(ADMIN_LEFT_MODE,"ORDERS")%>">주문관리</span></p></a></li>

					<li><a href="/admin/webpro/forumList.asp"><img src="<%=IMG_ADMIN_TOP%>/top_btn_webpro.png" alt="" /></a></li>
					<!-- <li><a href="/admin/submall/default.asp"><img src="<%=IMG_ADMIN_TOP%>/top_btn_submall.png" alt="" /></a></li> -->
				<%End If%>
			</ul>
		</div>

	</div>
	<div id="contain_wrap" class="layout_wrap">
		<div id="contain" class="<%=INNER_WIDTH%> contain_padding">
			<div id="leftmenu"><!--#include virtual="/admin/_inc/left.asp" --></div>
			<div id="content" class="<%=CONTENT_WIDTH%>"><!--#include virtual="/admin/_inc/headerData.asp" -->
