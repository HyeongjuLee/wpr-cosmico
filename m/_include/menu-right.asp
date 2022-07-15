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
					<!-- <li><a href="/m/pay/pay01.asp"><%=LNG_MYOFFICE_BONUS_01%></a></li> -->
					<li><a href="/m/pay/pay02.asp"><%=LNG_MYOFFICE_BONUS_02%></a></li>
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
						<li><a href="/m/pay/pay100.asp"><%=LNG_MYOFFICE_BONUS_100%></a></li>
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