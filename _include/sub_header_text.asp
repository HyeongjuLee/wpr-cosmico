<%
	If ISSUBTOP = "T" Then
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
						sub_title_d3 = LNG_LOCATION
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
								sub_title_d4 = LNG_BUSINESS_05_01
							Case "2"
								sub_title_d4 = LNG_BUSINESS_05_02
							Case "3"
								sub_title_d4 = LNG_BUSINESS_05_03
						End Select
					Case "5"
						sub_title_d3 = LNG_BUSINESS_05
					Case "6"
						sub_title_d3 = LNG_MEMBERSHIP_SALESMAN_SEARCH
				End Select
			Case "PRODUCT"
				sub_title_d2 = LNG_PRODUCT&""
				Select Case view
					Case "1"
						sub_title_d3 = LNG_PRODUCT_01
					Case "2"
						sub_title_d3 = LNG_PRODUCT_02
					Case "3"
						sub_title_d3 = LNG_PRODUCT_03
					Case "4"
						sub_title_d3 = LNG_PRODUCT_04
					Case "5"
						sub_title_d3 = LNG_PRODUCT_05
					Case "6"
						sub_title_d3 = LNG_PRODUCT_06
					Case "7"
						sub_title_d3 = LNG_PRODUCT_07
						Select Case sview
							Case "1"
								sub_title_d4 = LNG_PRODUCT_07_01
							Case "2"
								sub_title_d4 = LNG_PRODUCT_07_02
						End Select
				End SELECT
			Case "BRAND"
				sub_title_d2 = LNG_BRAND& ""
				Select Case view
					Case "1"
						sub_title_d3 = LNG_BRAND_01
						Select Case sview
							Case "1"
								sub_title_d4 = LNG_BRAND_01_01
							Case "2"
								sub_title_d4 = LNG_BRAND_01_02
							Case Else
						End Select
					Case "2"
						sub_title_d3 = LNG_BRAND_02
					Case "3"
						sub_title_d3 = LNG_BRAND_03
					Case "4"
						sub_title_d3 = LNG_BRAND_04
				End Select
			Case "GUIDE"
				sub_title_d2 = LNG_GUIDE& ""
				Select Case view
					Case "1"
						sub_title_d3 = LNG_GUIDE_01
					Case "2"
						sub_title_d3 = LNG_GUIDE_02
					Case "3"
						sub_title_d3 = LNG_GUIDE_03
					Case "4"
						sub_title_d3 = LNG_GUIDE_04
				End Select
			Case "SNS"
				' sub_title_d2 = LNG_SNS& ""
				sub_title_d3 = "<div style=""color: #000;""><b>SNS</b> "&LNG_COPYRIGHT_COMPANY_INC&"</div><p style=""color: #9e9e9e; font-size: 1.5rem;"">Share your moment and meet the light of "&LNG_COPYRIGHT_COMPANY_INC&"</p>"
				Select Case view
					Case "1"
						'sub_title_d3 = LNG_SNS_01
					Case "2"
						'sub_title_d3 = LNG_SNS_02
					Case "3"
						'sub_title_d3 = LNG_SNS_03
					Case "4"
						sub_title_d3 = LNG_SNS_04
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
						' sub_title_d3 = LNG_CUSTOMER_04
					Case "4"
						sub_title_d3 = LNG_CUSTOMER_04
						' sub_title_d3 = LNG_CUSTOMER_05
					Case "5"
						sub_title_d3 = LNG_CUSTOMER_05
					Case "6"
						sub_title_d3 = LNG_CUSTOMER_06
					Case "7"
						sub_title_d3 = LNG_CUSTOMER_07
					Case "8"
						sub_title_d3 = LNG_CUSTOMER_08
					Case "9"
						sub_title_d3 = LNG_CUSTOMER_09
					Case "10"
						'sub_title_d3 = LNG_CUSTOMER_10
						Select Case sview
							Case "1"
								sub_title_d3 = LNG_CUSTOMER_10_01
							Case "2"
								sub_title_d3 = LNG_CUSTOMER_10_02
							Case "3"
								sub_title_d3 = LNG_CUSTOMER_10_03
							Case Else
						End Select
					Case "11"
						sub_title_d3 = LNG_CUSTOMER_11
					Case Else
				End Select
			Case "COMMUNITY"
				sub_title_d2 = LNG_COMMUNITY&""
				Select Case view
					Case "1"
						sub_title_d3 = LNG_COMMUNITY_01
					Case "2"
						sub_title_d3 = LNG_COMMUNITY_02
					Case "3"
						sub_title_d3 = LNG_COMMUNITY_03
					Case "4"
						sub_title_d3 = LNG_COMMUNITY_04
					Case "5"
						sub_title_d3 = LNG_COMMUNITY_05
				End Select

			Case "COMMON"
				Select Case view
					Case "1"
						sub_title_d3 = LNG_MEMBER_LOGIN_TEXT10
					Case "2"
						sub_title_d3 = LNG_TEXT_FIND_IDPASSWORD
					Case "3"
						sub_title_d3 = LNG_TEXT_FIND_PASSWORD
					Case "4"
						Select Case sview
							Case "1"
								sub_title_d3 = LNG_SUBTITLE_TEXT25
							Case "2"
								sub_title_d3 = LNG_TEXT_NORMAL_MEMBER
							Case "3"
								sub_title_d3 = LNG_SUBTITLE_TEXT27
							Case "4"
								sub_title_d3 = LNG_TEXT_BUSINESS_MEMBER
							Case "5"
								sub_title_d3 = LNG_SUBTITLE_TEXT29
							Case "6"
								sub_title_d3 = LNG_SUBTITLE_TEXT30
							Case "7"
								sub_title_d3 = LNG_SUBTITLE_SELECT_NATION
							Case "8"
								sub_title_d3 = LNG_TEXT_BUSINESS_MEMBER &" "&LNG_SUBTITLE_TEXT26
							Case "9"
								sub_title_d3 = LNG_TEXT_BUSINESS_MEMBER &" "&LNG_CERTIFY
							Case Else
								sub_title_d3 = LNG_TEXT_JOIN
						End Select
				End Select

			Case "CSCENTER"
				sub_title_d2 = LNG_CUSTOMER& ""
				Select Case view
					Case "1"
						sub_title_d3 = LNG_CUSTOMER_01
					Case "2"
						sub_title_d3 = LNG_CUSTOMER_02
				End Select

			Case "GALLERY"
				sub_title_d2 = LNG_GALLERY_01& ""
				Select Case view
					Case "1"
						sub_title_d3 = LNG_GALLERY_02
					Case "2"
						sub_title_d3 = LNG_BRAND_02
					Case "3"
						sub_title_d3 = LNG_BRAND_03
					Case "4"
						sub_title_d3 = LNG_BRAND_04
				End Select

			Case "MEMBERSHIP","SHOP_MEMBERSHIP"
				sub_title_d2 = LNG_MEMBERSHIP&""
				Select Case view
					Case "1"
						Select Case sview
							Case "1"
								sub_title_d3 = LNG_SUBTITLE_TEXT25
							Case "2"
								sub_title_d3 = LNG_TEXT_JOIN_CONSUMER_MEMBER
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
			Case "JOIN"
				Select Case view
					Case "1"
						sub_title_d2 = LNG_TEXT_JOIN&""
						Select Case sview
							Case "1"
								sub_title_d3 = LNG_POLICY_01
							Case "2"
								sub_title_d3 = LNG_JOINSTEP03_U_BTITLE
							Case "3"
								sub_title_d3 = LNG_JOINSTEP03_U_BTITLE
							Case "4"
								sub_title_d3 = LNG_TEXT_JOIN_BUSINESS_MEMBER
							Case "5"
								sub_title_d3 = LNG_SUBTITLE_TEXT29
							Case "6"
								sub_title_d3 = LNG_SUBTITLE_TEXT30
							Case "7"
								sub_title_d3 = LNG_SUBTITLE_SELECT_NATION
							Case Else
								'sub_title_d3 = LNG_TEXT_JOIN
						End Select
					Case "2"
						sub_title_d3 = LNG_POLICY_01&"" '사이트 이용약관(소제목)
						Select Case sview
							Case "1"
							sub_title_d2 = LNG_TEXT_JOIN_CONSUMER_MEMBER '소비자 회원가입(대제목)
							Case "2"
							sub_title_d2 = LNG_TEXT_JOIN_BUSINESS_MEMBER '사업자 회원가입(대제목) 이라서 sub_title_d2, sub_title_d3 순서 변경.
							Case Else
						End Select
					Case "3"
						sub_title_d3 = LNG_JOINSTEP03_U_BTITLE&"" '위와 동일
						Select Case sview
							Case "1"
							sub_title_d2 = LNG_TEXT_JOIN_CONSUMER_MEMBER
							Case "2"
							sub_title_d2 = LNG_TEXT_JOIN_BUSINESS_MEMBER
							Case Else
						End Select
					Case "4"
						sub_title_d3 = LNG_SUBTITLE_TEXT31
						Select Case sview
							Case "1"
							sub_title_d2 = LNG_TEXT_JOIN_CONSUMER_MEMBER
							Case "2"
							sub_title_d2 = LNG_TEXT_JOIN_BUSINESS_MEMBER
							Case Else
						End Select
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
					'Case "2"
					'	sub_title_d3 = LNG_MYPAGE_02
					Case "2"
						sub_title_d3 = LNG_MYPAGE_03
					Case "3"
						sub_title_d3 = LNG_MYPAGE_05
					Case "4"
						Select Case sView
							Case "1" : sub_title_d3 = LNG_MYPAGE_04_1
							Case "2" : sub_title_d3 = LNG_MYPAGE_04_2
						End Select
					Case "5"
						sub_title_d3 = LNG_MEDIA
					Case Else
				End Select


		'	Case "SHOP"			'2차카테고리
		'		sub_title_d3  = "상품전체보기"
		'		If CATEGORY <> ""  Then
		'			SQL = "SELECT [strCateName] FROM [DK_SHOP_CATEGORY] WHERE [strCateCode] = ?"
		'			arrParams = Array(_
		'				Db.makeParam("@strCateCode",adVarChar,adParamInput,20,CATEGORY) _
		'			)
		'			CateName = Db.execRsData(SQL,DB_TEXT,arrParams,Nothing)
		'			If Len(CATEGORY) = 3  Then
		'				sub_title_d2  = CateName &" >"
		'				sub_title_d3  = " 전체보기"
		'			ElseIf Len(CATEGORY) = 6 Then
		'				PARENT_CATE = LEFT(CATEGORY,3)
		'				SQL = "SELECT [strCateName] FROM [DK_SHOP_CATEGORY] WHERE [strCateCode] = ?"
		'				arrParams2 = Array(_
		'					Db.makeParam("@strCateCode",adVarChar,adParamInput,20,PARENT_CATE) _
		'				)
		'				ParentCateName = Db.execRsData(SQL,DB_TEXT,arrParams2,Nothing)
		'				sub_title_d2  = ParentCateName &" > "
		'				sub_title_d3  = CateName
		'			End If
		'		End If

			Case "SHOP"		'3차카테고리

				If CATEGORY <> ""  Then

					SQL = "SELECT [strCateName] FROM [DK_SHOP_CATEGORY] WHERE [strCateCode] = ? AND [strNationCode] = '"&UCase(DK_MEMBER_NATIONCODE)&"' "
					arrParams = Array(_
						Db.makeParam("@strCateCode",adVarChar,adParamInput,20,CATEGORY) _
					)
					CateName = Db.execRsData(SQL,DB_TEXT,arrParams,Nothing)

					If Len(CATEGORY) = 3  Then
						sub_title_d2  = CateName '&" >"
						sub_title_d4  = LNG_SHOP_HEADER_TXT_02		'" 전체보기"

					ElseIf Len(CATEGORY) = 6 Then
						PARENT_CATE = LEFT(CATEGORY,3)
						SQL = "SELECT [strCateName] FROM [DK_SHOP_CATEGORY] WHERE [strCateCode] = ? AND [strNationCode] = '"&UCase(DK_MEMBER_NATIONCODE)&"' "
						arrParams1 = Array(_
							Db.makeParam("@strCateCode",adVarChar,adParamInput,20,PARENT_CATE) _
						)
						ParentCateName1 = Db.execRsData(SQL,DB_TEXT,arrParams1,Nothing)

						sub_title_d2  = ParentCateName1 '&" > "
						sub_title_d3  = CateName '&" >"
						sub_title_d4  = LNG_SHOP_HEADER_TXT_03		'" 카테고리 전체보기"

					ElseIf Len(CATEGORY) = 9 Then
						PARENT_CATE = LEFT(CATEGORY,3)
						SQL = "SELECT [strCateName] FROM [DK_SHOP_CATEGORY] WHERE [strCateCode] = ? AND [strNationCode] = '"&UCase(DK_MEMBER_NATIONCODE)&"' "
						arrParams1 = Array(_
							Db.makeParam("@strCateCode",adVarChar,adParamInput,20,PARENT_CATE) _
						)
						ParentCateName1 = Db.execRsData(SQL,DB_TEXT,arrParams1,Nothing)

						PARENT_CATE2 = LEFT(CATEGORY,6)
						SQL = "SELECT [strCateName] FROM [DK_SHOP_CATEGORY] WHERE [strCateCode] = ? AND [strNationCode] = '"&UCase(DK_MEMBER_NATIONCODE)&"' "
						arrParams2 = Array(_
							Db.makeParam("@strCateCode",adVarChar,adParamInput,20,PARENT_CATE2) _
						)
						ParentCateName2 = Db.execRsData(SQL,DB_TEXT,arrParams2,Nothing)

						sub_title_d2  = ParentCateName1 '&" > "
						sub_title_d3  = ParentCateName2 '&" > "
						sub_title_d4  = CateName
					End If

				End If

			Case Else
		End Select
		Select Case PAGE_SETTING2
			Case "ADMIN"
				sub_title_d3 = LNG_MEMBER_LOGIN_TEXT14
			Case "MYPAGE", "MY_MEMBER"
				sub_title_d4 = LNG_MYPAGE
				sub_title_d3 = LNG_MYPAGE_01
				MAP_DEPTH2 	= LNG_MYPAGE_01
				Select Case view
					Case "0"
						MAP_DEPTH3 = LNG_MEBERINFO_CONFIRM
					Case "1"
						MAP_DEPTH3 = LNG_MYPAGE_01
					Case "7"
						MAP_DEPTH3 = LNG_WALLET_ADDRESS_CHANGE
					Case "8"
						MAP_DEPTH3 = LNG_INFO_CHANGE_PIN_CHANGE
					Case "9"
						MAP_DEPTH3 = LNG_MONEY_OUTPUT_PIN_CHANGE
					Case "10"
						MAP_DEPTH3 = "OTP" & LNG_TEXT_INITIALIZATION
					Case "11"
						MAP_DEPTH3 = LNG_MONEY_OUTPUT_PIN_RESET
					Case "12"
						MAP_DEPTH3 = LNG_INFO_CHANGE_PIN_RESET
					Case "13"
						MAP_DEPTH3 = LNG_TEXT_WEBID_CHANGE
					Case "14"
						MAP_DEPTH3 = LNG_TEXT_WEBID_CHANGE
					End Select
			Case "CUSTOMER"
				'sub_title_d4 = LNG_CUSTOMER_02
				MAP_DEPTH2 	= LNG_MYOFFICE_BOARD
				'MAP_DEPTH3 	= LNG_CUSTOMER_02
				Select Case view
					Case "1"
						MAP_DEPTH3 = LNG_CUSTOMER_01
					Case "2"
						MAP_DEPTH3 = LNG_CUSTOMER_02
					Case "3"
						MAP_DEPTH3 = LNG_CUSTOMER_02
					Case "4"
						MAP_DEPTH3 = LNG_CUSTOMER_02
					Case "5"
						MAP_DEPTH3 = LNG_CUSTOMER_05
					End Select
			Case Else
		End Select
%>
<%Select Case PAGE_SETTING%>
<%Case "SHOP"%>
	<div id="subTitle" class="layout_inner">
		<div class="sub_title">
			<!-- <div class="fleft maps_title"><%=sub_title_img%></div> -->
			<%If Len(CATEGORY) = 3  Then%>
				<div class="maps_title"><%=sub_title_d2%></div>
				<div class="fright maps_navi">
					<span class="first_navi"><!-- <img src="<%=IMG_NAVI%>/subtit_home.png" alt="home" /> >  -->SHOP</span><span class="arrow"> ></span>
					<span class="last_navi"><%=sub_title_d4%></span>
				</div>
			<%ElseIf Len(CATEGORY) = 6 Then%>
				<div class="maps_title"><%=sub_title_d3%></div>
				<div class="fright maps_navi">
					<span class="first_navi"><!-- <img src="<%=IMG_NAVI%>/subtit_home.png" alt="home" /> >  -->SHOP</span><span class="arrow"> ></span>
					<span class="center_navi"><%=sub_title_d2%></span><span class="arrow"> ></span>
					<span class="last_navi"><%=sub_title_d3%></span>
				</div>
			<%ElseIf Len(CATEGORY) = 9 Then%>
				<div class="maps_title"><%=sub_title_d4%></div>
				<div class="fright maps_navi">
					<span class="first_navi"><!-- <img src="<%=IMG_NAVI%>/subtit_home.png" alt="home" /> >  -->SHOP</span><span class="arrow"> ></span>
					<span class="center_navi"><%=sub_title_d2%></span><span class="arrow"> > </span><%=sub_title_d3%><span class="arrow"> ></span>
					<span class="last_navi"><%=sub_title_d4%></span>
				</div>
			<%End If%>
		</div>
	</div>

<%Case Else%>
	<%If PAGE_SETTING <> "MYOFFICE" Then %>
		<%If sub_title_d4 <> "" Then %>
			<div class="maps_title"><%=sub_title_d4%></div>
		<%ElseIf PAGE_SETTING <> "JOIN" Then%>
			<div class="maps_title"><%=sub_title_d3%></div>
		<%End If%>
		<%If PAGE_SETTING = "JOIN" Then %>
			<div class="maps_title"><%=sub_title_d2%></div>
			<div class="sub_title"><%=sub_title_d3%></div>
		<%End If%>
	<%End If%>

	<%If PAGE_SETTING = "MYOFFICE" Then %>
		<%If sub_title_d4 <> "" Then %>
			<div class="maps_title"><%=sub_title_d4%></div>
		<%Else%>
			<div class="maps_title"><%=MAP_DEPTH2%></div>
		<%End If%>
	<%End If%>
<%End Select%>

<%
	End If
%>

