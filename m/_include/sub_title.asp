<%
	Select Case PAGE_SETTING
		Case "COMPANY"
			sub_title_d2 = LNG_COMPANY& ""
			Select Case view
				Case "1"
					sub_title_d3 = LNG_COMPANY_01
				Case "2"
					sub_title_d3 = LNG_COMPANY_02
				Case "3"
					sub_title_d3 = LNG_COMPANY_03
				Case "4"
					sub_title_d3 = LNG_COMPANY_04
				Case "5"
					sub_title_d3 = LNG_COMPANY_05
			End Select

		Case "BRAND"
			sub_title_d2 = LNG_BRAND& ""
			Select Case view
				Case "1"
					sub_title_d3 = LNG_BRAND_01
				Case "2"
					sub_title_d3 = LNG_BRAND_02
				Case "3"
					sub_title_d3 = LNG_BRAND_03
				Case "4"
					sub_title_d3 = LNG_BRAND_04
				Case "5"
					sub_title_d3 = LNG_BRAND_05
			End Select

		Case "BUSINESS"
			sub_title_d2 = LNG_BUSINESS&""
			Select Case view
				Case "1"
					sub_title_d3 = LNG_BUSINESS_01
				Case "2"
					sub_title_d3 = LNG_BUSINESS_02
				Case "3"
					sub_title_d3 = LNG_BUSINESS_03
				Case "4"
					sub_title_d3 = LNG_BUSINESS_04
					Select Case sview
						Case "1"
							sub_title_d4 = LNG_BUSINESS_04_01
						Case "2"
							sub_title_d4 = LNG_BUSINESS_04_02
						Case "3"
							sub_title_d4 = LNG_BUSINESS_04_03
					End Select

				Case "5"
					sub_title_d3 = LNG_BUSINESS_05
				Case "6"
					sub_title_d3 = LNG_BUSINESS_06
				Case "7"
					sub_title_d3 = LNG_BUSINESS_07
			End Select
		Case "CUSTOMER"
			sub_title_d2 = LNG_CUSTOMER&""
			Select Case view
				Case "1"
					sub_title_d3 = LNG_CUSTOMER_01
				Case "2"
					sub_title_d3 = LNG_CUSTOMER_02
				Case "3"
					sub_title_d3 = LNG_CUSTOMER_03
				Case "4"
					sub_title_d3 = LNG_CUSTOMER_04
				Case "5"
					sub_title_d3 = LNG_CUSTOMER_05
				Case "6"
					sub_title_d3 = LNG_CUSTOMER_06
				Case "7"
					sub_title_d3 = LNG_LEFT_TEXT16
				Case Else
			End Select

		Case "MEMBERSHIP","SHOP_MEMBERSHIP"
			sub_title_d2 = LNG_MEMBERSHIP&""
			Select Case view
				Case "1"
					Select Case sview
						Case "1"
							sub_title_d3 = LNG_SUBTITLE_TEXT25
						Case "2"
							sub_title_d3 = LNG_SUBTITLE_TEXT26
						Case "3"
							sub_title_d3 = LNG_SUBTITLE_TEXT27
						Case "4"
							sub_title_d3 = LNG_SUBTITLE_TEXT28
						Case "5"
							sub_title_d3 = LNG_SUBTITLE_TEXT29
						Case "6"
							sub_title_d3 = LNG_SUBTITLE_TEXT30
						Case "7"
							sub_title_d3 = LNG_SUBTITLE_SELECT_NATION
						Case Else
							sub_title_d3 = LNG_TEXT_JOIN
					End Select
				Case "2"
					sub_title_d3 = LNG_MEMBERSHIP_IDPW_FIND
				Case "3"
					sub_title_d3 = LNG_MEMBERSHIP_SALESMAN_SEARCH
				Case "4"
					sub_title_d3 = LNG_HEADER_MYOFFICE
				Case Else
			End Select
		Case "POLICY"
			sub_title_d2 = LNG_POLICY&""
			Select Case view
				Case "1"
					sub_title_d3 = LNG_POLICY_01
				Case "2"
					sub_title_d3 = LNG_POLICY_02
				Case "3"
					sub_title_d3 = LNG_POLICY_03
				Case Else
			End Select
		Case "MYPAGE","SHOP_MYPAGE"
			sub_title_d2 = LNG_MYPAGE&""
			Select Case view
				Case "1"
					sub_title_d3 = LNG_MYPAGE_01
				Case "2"
					sub_title_d3 = LNG_MYPAGE_02
				Case "3"
					sub_title_d3 = LNG_MYPAGE_03
				Case "4"
					Select Case sView
						Case "1" : sub_title_d3 = LNG_MYPAGE_04_1
						Case "2" : sub_title_d3 = LNG_MYPAGE_04_2
					End Select
				Case "5"
					sub_title_d3 = LNG_MEDIA

				Case Else
			End Select


	End Select
%>


<% If PAGE_SETTING <> "INDEX" Then%>
<% If PAGE_SETTING <> "SHOP" Then%>
	<div id="subVisualWrap">
		<div id="subVisuals">
			<div class="txt"><%=sub_title_d3%></div>
			<div class="images">
				<%Select Case PAGE_SETTING%>
				<%Case "COMPANY"%>
					<img src="/images/index/sub_visual01.jpg" alt="" />
				<%Case "BUSINESS"%>
					<img src="/images/index/sub_visual01.jpg" alt="" />
				<%Case "PRODUCT"%>
					<img src="/images/index/sub_visual01.jpg" alt="" />
				<%Case "CUSTOMER"%>
					<img src="/images/index/sub_visual01.jpg" alt="" />
				<%Case "MYOFFICE"%>
					<img src="/images/index/sub_visual01.jpg" alt="" />
				<%Case Else%>
					<img src="/images/index/sub_visual01.jpg" alt="" />
				<%End Select%>
			</div>
		</div>
	</div>

<%End If%>
<%End If%>