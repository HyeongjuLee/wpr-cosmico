<%If ISLEFT = "T" Then%>

		<%If PAGE_SETTING = "MYOFFICE" Then %>
			<div id="LeftMenu_M">
				<%If DK_MEMBER_TYPE = "ADMIN" Then%>
					<div id="left_anchor_admin">
						<div class="addr">ADMIN MODE</div>
					</div>
				<%Else%>
					<div id="left_anchor">
						<div class="bors addr">Member Infomation</div>
						<div class="clear left_info">
							<%If UCase(Lang) = "KR" Then%>
							<ul>
								<li><span class="stitle">성&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;명</span> : <%=DK_MEMBER_NAME%></li>
								<!-- <li><span class="stitle">웹아이디</span> : <%=DK_MEMBER_WEBID%></li> -->
								<li><span class="stitle">회원번호</span> : <%=DK_MEMBER_ID1%> - <%=Fn_MBID2(DK_MEMBER_ID2)%></li>
								<%If DK_MEMBER_STYPE = "0" Then%>
								<li><span class="stitle">소&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;속</span> : <%=RS_BusinessName%></li>
								<li><span class="stitle">직&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;급</span> : <%=nowGrade%></li>
								<!-- <li><span class="stitle">가&nbsp;&nbsp;입&nbsp;&nbsp;일</span> : <%=date8to10(DKRSG_regTime)%></li> -->
								<%End If%>
							</ul>
							<%Else%>
							<ul>
								<li><span class="stitle"><%=LNG_LEFT_MEM_INFO_NAME%></span> : <%=DK_MEMBER_NAME%></li>
								<!-- <li><span class="stitle"><%=LNG_LEFT_MEM_INFO_WEBID%></span> : <%=DK_MEMBER_WEBID%></li> -->
								<!-- <li><span class="stitle"><%=LNG_LEFT_MEM_INFO_GRADE%></span> : <%=nowGrade%></li> -->
								<li><span class="stitle"><%=LNG_LEFT_MEM_INFO_MEMID%></span> : <%=DK_MEMBER_ID1%> - <%=Fn_MBID2(DK_MEMBER_ID2)%></li>
								<li><span class="stitle"><%=LNG_LEFT_MEM_INFO_CENTER%></span> : <%=RS_BusinessName%></li>
								<li><span class="stitle"><%=LNG_LEFT_MEM_INFO_REGDATE%></span> : <%=date8to10(DKRSG_regTime)%></li>
							</ul>
							<%End If%>
						<!-- <div class="addr" style="margin-top:10px;"><span class="button medium vmiddle"><a href="/myoffice/member/member_pass_change.asp"><%=LNG_TEXT_PASSWORD_MANAGE%></a></span></div> -->
						</div>
					</div>
				<%End If%>
				<%
					Function Fnc_leftmenu_color(valThisPage, valThisPage2, valText)
						If valThisPage = valThisPage2 Then
							Fnc_leftmenu_color = "<span class=""tweight"" style=""color:#9b8671;"">"&valText&"</span>"
						Else
							Fnc_leftmenu_color = "<span>"&valText&"</span>"
						End If
					End Function

					mNum = 4

					If DK_MEMBER_STYPE = "1" Then			'▣ 소비자회원
						If Left(INFO_MODE,3) = "BUY" Then	'구매내역
							view = 1
						End If

					Else

						If Left(INFO_MODE,6) = "NOTICE" Then '공지사항
							view = 1
						ElseIf Left(INFO_MODE,6) = "MEMBER" Then	'산하회원정보
							view = 2
						ElseIf Left(INFO_MODE,3) = "BUY" Then	'구매내역
							view = 3
						ElseIf Left(INFO_MODE,5) = "BONUS" Then	'수당내역
							view = 4
						ElseIf Left(INFO_MODE,5) = "POINT" Then	'마일리지
							view = 5
						'ElseIf Left(INFO_MODE,8) = "AUTOSHIP" Then
						'	view = 5
						'ElseIf Left(INFO_MODE,7) = "BCENTER" Then	'센터장
						'	view = 7
						ElseIf Left(INFO_MODE,5) = "ORDER" Then	'제품구매
							view = 6
						End If

					End If

					If DK_MEMBER_TYPE = "ADMIN" Then
						If Left(INFO_MODE,6) = "NOTICE" Then view = 1
					End If

				%>
				<div id="left_navi">
					<ul class="left_navi">

					<%If DK_MEMBER_STYPE = "1" Then	'▣소비자회원 %>
						<li class="LEFT_main" >

							<a><%=LNG_MYOFFICE_BUY%></a>

							<ul>
								<%If isMACCO = "T" Then%>
								<li class="myoffice"><a href="/myoffice/buy/order_list_macco.asp"><%=Fnc_leftmenu_color(INFO_MODE,"BUY1-1",LNG_MYOFFICE_BUY_01)%></a></li>
								<%Else%>
								<li class="myoffice"><a href="/myoffice/buy/order_list.asp"><%=Fnc_leftmenu_color(INFO_MODE,"BUY1-1",LNG_MYOFFICE_BUY_01)%></a></li>
								<%End IF%>
							</ul>
						</li>

					<%Else%>
						<%If DK_MEMBER_TYPE <> "ADMIN" And 1=2 Then%>
						<li class="LEFT_main" style="border-top: 1px solid #d3d3d3;" >
							<a href="/myoffice/dashboard/dashboard.asp">대쉬보드</a>
						</li>
						<%End If%>

						<!-- <li class="LEFT_main" style="border-top:1px solid #d3d3d3;" ><a href="/myoffice/cboard/board_list.asp?bname=myoffice"><%=LNG_MYOFFICE_BOARD%></a> -->
						<li class="LEFT_main" style="border-top:1px solid #d3d3d3;" ><a><%=LNG_MYOFFICE_BOARD%></a><%'CBOARD 통합%>
							<ul>
								<!-- <li class="myoffice"><a href="/myoffice/cboard/board_list.asp?bname=myoffice"><%=Fnc_leftmenu_color(INFO_MODE,"NOTICE1-1",LNG_MYOFFICE_NOTICE)%></a></li> -->
								<li class="myoffice"><a href="/cboard/board_list.asp?bname=myoffice"><%=Fnc_leftmenu_color(INFO_MODE,"NOTICE1-1",LNG_MYOFFICE_NOTICE)%></a></li><%'CBOARD 통합%>
							</ul>
						</li>

						<%If DK_MEMBER_STYPE = "0" Then%>
						<li class="LEFT_main" ><a><%=LNG_MYOFFICE_MEMBER%></a>
							<ul>
								<li class="myoffice"><a href="/myoffice/member/memberVote.asp"><%=Fnc_leftmenu_color(INFO_MODE,"MEMBER1-2",LNG_MYOFFICE_MEMBER_02)%></a></li>
								<li class="myoffice"><a href="/myoffice/member/memberSponsor.asp"><%=Fnc_leftmenu_color(INFO_MODE,"MEMBER1-1",LNG_MYOFFICE_MEMBER_01)%></a></li>
								<li class="myoffice"><a href="/myoffice/member/memberVoteAll.asp"><%=Fnc_leftmenu_color(INFO_MODE,"MEMBER1-2",LNG_MYOFFICE_MEMBER_02&"(전체)")%></a></li>
								<li class="myoffice"><a href="/myoffice/member/memberSponsorAll.asp"><%=Fnc_leftmenu_color(INFO_MODE,"MEMBER1-1",LNG_MYOFFICE_MEMBER_01&"(전체)")%></a></li>
								<!-- <li class="myoffice"><a href="/myoffice/member/T_tree_vt_V5.asp" target="_blank"><%=LNG_MYOFFICE_CHART_02%></a></li>
								<li class="myoffice"><a href="/myoffice/member/T_tree_ss_V5.asp" target="_blank"><%=LNG_MYOFFICE_CHART_01%></a></li> -->
								<li class="myoffice"><a href="/myoffice/org/T_tree_vt_V10.asp" target="_blank"><%=LNG_MYOFFICE_CHART_02%></a></li>
								<li class="myoffice"><a href="/myoffice/org/T_tree_ss_V10.asp" target="_blank"><%=LNG_MYOFFICE_CHART_01%></a></li>
								<li class="myoffice"><a href="/myoffice/member/P1_E_Tree_vt.asp" target="_blank"><%=LNG_MYOFFICE_CHART_06%></a></li>
								<li class="myoffice"><a href="/myoffice/member/P1_E_Tree_ss.asp" target="_blank"><%=LNG_MYOFFICE_CHART_05%></a></li>
								<li class="myoffice"><a href="/myoffice/member/member_UnderInfo.asp"><%=Fnc_leftmenu_color(INFO_MODE,"MEMBER1-6",LNG_MYOFFICE_MEMBER_06)%></a></li>
								<li class="myoffice"><a href="/myoffice/member/member_UnderSpon.asp"><%=Fnc_leftmenu_color(INFO_MODE,"MEMBER1-7",LNG_MYOFFICE_MEMBER_07)%></a></li>
							</ul>
						</li>
						<li class="LEFT_main" ><a><%=LNG_MYOFFICE_BUY%></a>
							<ul>
								<%If isMACCO = "T" Then%>
								<li class="myoffice"><a href="/myoffice/buy/order_list_macco.asp"><%=Fnc_leftmenu_color(INFO_MODE,"BUY1-1",LNG_MYOFFICE_BUY_01)%></a></li>
								<%Else%>
								<li class="myoffice"><a href="/myoffice/buy/order_list.asp"><%=Fnc_leftmenu_color(INFO_MODE,"BUY1-1",LNG_MYOFFICE_BUY_01)%></a></li>
								<%End IF%>
								<li class="myoffice"><a href="/myoffice/buy/underPurchase.asp?u=v"><%=Fnc_leftmenu_color(INFO_MODE,"BUY1-3",LNG_MYOFFICE_BUY_03)%></a></li>
								<li class="myoffice"><a href="/myoffice/buy/underPurchase.asp?u=s"><%=Fnc_leftmenu_color(INFO_MODE,"BUY1-2",LNG_MYOFFICE_BUY_02)%></a></li>
							</ul>
						</li>
						<li class="LEFT_main" ><a><%=LNG_MYOFFICE_BONUS%></a>
							<ul>
								<li class="myoffice"><a href="/myoffice/pay/pay01.asp"><%=Fnc_leftmenu_color(INFO_MODE,"BONUS1-1",LNG_MYOFFICE_BONUS_01)%></a></li>
								<!-- <li class="myoffice"><a href="/myoffice/pay/pay03.asp"><%=Fnc_leftmenu_color(INFO_MODE,"BONUS1-3",LNG_MYOFFICE_BONUS_03)%></a></li> -->
								<%If DK_BUSINESS_CNT > 0 then%>
								<%End If %>
							</ul>
						</li>

						<!-- <li class="LEFT_main" >
							<a href="/myoffice/autoship/order_list_CMS.asp"><%=LNG_MYOFFICE_AUTOSHIP%></a>
							<ul>
								<li class="myoffice"><a href="/myoffice/autoship/order_list_CMS.asp"><%=Fnc_leftmenu_color(INFO_MODE,"AUTOSHIP1-1",LNG_MYOFFICE_AUTOSHIP_01)%></a></li>
								<li class="myoffice"><a href="/myoffice/autoship/order_list_CMS_reg.asp"><%=Fnc_leftmenu_color(INFO_MODE,"AUTOSHIP1-2",LNG_MYOFFICE_AUTOSHIP_02)%></a></li>
							</ul>
						</li> -->
						<%If isSHOP_POINTUSE = "T" And 1=1 Then%>
						<li class="LEFT_main" ><a><%=SHOP_POINT%></a>
							<ul>
								<li class="myoffice"><a href="/myoffice/point/point.asp"><%=Fnc_leftmenu_color(INFO_MODE,"POINT1-1",SHOP_POINT)%></a></li>
								<li class="myoffice"><a href="/myoffice/point/point_transfer.asp"><%=Fnc_leftmenu_color(INFO_MODE,"POINT1-3",LNG_MYOFFICE_POINT_02)%></a></li>
								<li class="myoffice"><a href="/myoffice/point/point_transfer2Cash.asp"><%=Fnc_leftmenu_color(INFO_MODE,"POINT1-4",LNG_MYOFFICE_POINT_03)%></a></li>
								<!-- <li class="myoffice"><a href="/myoffice/point/point2.asp"><%=Fnc_leftmenu_color(INFO_MODE,"POINT1-2",SHOP_POINT2)%></a></li> -->
							</ul>
						</li>
						<%End If%>
						<li class="LEFT_main" ><a><%=LNG_MYOFFICE_ORDER%></a>
							<ul>
								<li class="myoffice"><a href="/myoffice/buy/goodsList.asp"><%=Fnc_leftmenu_color(INFO_MODE,"ORDER1-2",LNG_MYOFFICE_ORDER_01)%></a></li>
								<li class="myoffice"><a href="/myoffice/buy/cart.asp"><%=Fnc_leftmenu_color(INFO_MODE,"ORDER1-3",LNG_MYOFFICE_ORDER_02)%></a></li>
							</ul>
						</li>
						<%If DK_BUSINESS_CNT > 0 And 1=2 Then%>
							<li class="LEFT_main" >
								<a href="/myoffice/business/business_member.asp"><%=LNG_MYOFFICE_BCENTER%></a>
								<ul>
									<li class="myoffice"><a href="/myoffice/business/business_member.asp"><%=Fnc_leftmenu_color(INFO_MODE,"BCENTER1-1",LNG_MYOFFICE_BCENTER_01)%></a></li>
									<li class="myoffice"><a href="/myoffice/business/business_purchase.asp"><%=Fnc_leftmenu_color(INFO_MODE,"BCENTER1-2",LNG_MYOFFICE_BCENTER_02)%></a></li>
								</ul>
							</li>
						<%End If%>

						<%End If%>
					</ul>
					<%End If%>

				</div>
			</div>

		<%Else%>

			<div id="LeftMenu">
				<div id="left_navi">
					<div class="left_home" data-ripplet><a href="/index.asp"><i class="icon-home"></i></a></div>
					<ul class="left_navi">
						<%Select Case PAGE_SETTING%>
							<%Case "COMPANY"%>
								<!--#include virtual = "/subTitle/depth1.asp"-->
								<!--#include virtual = "/subTitle/company.asp"-->
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

