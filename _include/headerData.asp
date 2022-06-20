<%
	' 인기 검색어
		arrParams = Array(_
			Db.makeParam("@strSiteID",adVarChar,adParamInput,20,DK_SITE_PK)_
		)
		Set DKRS = Db.execRs("DKP_CONFIG",DB_PROC,arrParams,Nothing)
		If Not DKRS.BOF And Not DKRS.EOF Then
			printPopular = DKRS("strPopular")
			printPopular = cutString(printPopular,40)
		Else
			printPopular = "인기검색어가 없습니다."
		End If
		Call closeRS(DKRS)


	' 레프트 관련 데이터
		Select Case LEFTFLASHS
			Case "MYPAGE"
				LeftMenuTopImg = "mypage_top.gif"
				LeftMenuXmlUrl = "xmlURL=/xml/mypage.asp"
				flashFile = "etcmenu"
				DesignModeValue = "mypage"
				LFWIDTH = "220"
				LFHEIGHT = "400"

			Case "COMPANY"
				LeftMenuTopImg = "company_top.gif"
				LeftMenuXmlUrl = "xmlURL=/xml/company.asp"
				flashFile = "etcmenu"
				DesignModeValue = "company"
			Case "CSCENTER"
				LeftMenuTopImg = "cscenter_top.gif"
				LeftMenuXmlUrl = "xmlURL=/xml/cscenter.asp"
				flashFile = "etcmenu"
				DesignModeValue = "cscenter"
				LFWIDTH = "220"
				LFHEIGHT = "400"
			Case "COMMUNITY"
				LeftMenuTopImg = "community_top.gif"
				LeftMenuXmlUrl = "xmlURL=/xml/community.asp"
				flashFile = "etcmenu"
				DesignModeValue = "cscenter"
				LFWIDTH = "220"
				LFHEIGHT = "400"
			Case Else
				LeftMenuTopImg = "category_top.gif"
				LeftMenuXmlUrl = "xmlURL=/xml/category.asp"
				flashFile = "category"
				DesignModeValue = "categoryHeight"
				LFWIDTH = "100%"
				LFHEIGHT = "100%"
		End Select


		arrParams = Array(_
			Db.makeParam("@mode",adVarChar,adParamInput,30,DesignModeValue) _
		)
		Set DKRS = Db.execRs("DKP_DESIGN_01",DB_PROC,arrParams,Nothing)

		If Not DKRS.BOF And Not DKRS.EOF Then
			THISMODEHEIGHT = DKRS("Value01")
		Else
			THISMODEHEIGHT = 0
		End If
		Call closeRs(DKRS)


	' 레프트 배너 확인
		LeftBanner = ""

		leftBanner = leftBanner & Tabs(0) & "" &VbCrlf

'		Select Case PAGE_SETTING
'			Case "INDEX" : LBANNER_WHERE = " AND [indexTF] = 'T' "
'			Case "COMPANY" : LBANNER_WHERE = " AND [companyTF] = 'T' "
'			Case "CSCENTER" : LBANNER_WHERE = " AND [cscenterTF] = 'T' "
'			Case "MYPAGE" : LBANNER_WHERE = " AND [mypageTF] = 'T' "
'			Case Else : LBANNER_WHERE = " AND [shopTF] = 'T'"
'		End Select
'
'
'		SQL = "SELECT * FROM [DK_LEFTBANNER_TF] WHERE [viewTF] = 'T'"
'		SQL = SQL & LBANNER_WHERE
'		SQL = SQL & " ORDER BY [intSort] ASC"
'		arrList = Db.execRsList(SQL,DB_TEXT,Nothing,listLen,Nothing)
'
'		If IsArray(arrList) Then
'			For i = 0 To listLen
'				strBName = arrList(1,i)
'				cssName = arrList(10,i)
'				marginTop = arrList(9,i)
'
'
'				SQL = "SELECT * FROM [DK_LEFTBANNER_CONTENT] WHERE [strName] = ? AND [viewTF] = 'T' ORDER BY [intSort] ASC"
'				arrParams = Array(_
'					Db.makeParam("@strName",adVarChar,adParamInput,50,strBName) _
'				)
'				arrList1 = Db.execRsList(SQL,DB_TEXT,arrParams,listLen1,Nothing)
'
'				leftBanner = leftBanner & Tabs(4) & "<div class="""&cssName&""" style=""margin-top:"&marginTop&"px;"">" &VbCrlf
'				If IsArray(arrList1) Then
'					leftBanner = leftBanner & Tabs(4) & "	<ul>" &VbCrlf
'					For j = 0 To listLen1
'						jlinkTF = arrList1(3,j)
'						jlinkURL = arrList1(4,j)
'						jlinkTarget = arrList1(5,j)
'						jimgURL = arrList1(6,j)
'						jimgWidth = arrList1(7,j)
'						jimgHeight = arrList1(8,j)
'						jimgAlt = arrList1(9,j)
'						jmarginTop = arrList1(10,j)
'
'						leftBanner = leftBanner & Tabs(4) & "		<li style=""margin-top:"&jmarginTop&"px;"">"
'						If jlinkTF = "T" Then
'							If jlinkTarget = "BLANK" Then jlinkTarget = " target=""_blank"""
'							leftBanner = leftBanner & "<a href="""&jlinkURL&""" "&jlinkTarget&">"&viewImg(VIR_PATH("left")&"/"&jimgURL,jimgWidth,jimgHeight,jimgAlt)&"</a>"
'						Else
'							leftBanner = leftBanner & viewImgST(VIR_PATH("left")&"/"&jimgURL,jimgWidth,jimgHeight,jimgAlt,"","vtop")
'						End If
'						leftBanner = leftBanner & "</li>" & VbCrlf
'					Next
'					leftBanner = leftBanner & Tabs(4) & "	</ul>" &VbCrlf
'				End If
'				leftBanner = leftBanner & Tabs(4) & "</div>" &VbCrlf
'
'
'				leftBanner = leftBanner & Tabs(0) & "" &VbCrlf
'			Next
'		End If



	' 레프트 베스트 상품
		LeftBanner = "<div class=""clear"">"&viewFlash(IMG_FLASH&"/left_best.swf","xmlURL=/xml/left_best.asp",220,260)&"</div>"

	'CS CENTER
		LeftCsBank = "<div class=""clear""  style=""margin-top:20px;"">"&viewImg(IMG_SHARE&"/left_cs_bank.gif",220,240,"")&"</div>"
	' 레프트 배너
		LeftBanner01 = "<div class=""clear"" style=""margin-top:20px;"">"&viewFlash(IMG_FLASH&"/leftBanner01.swf","xmlURL=/xml/leftBanner01.asp",220,320)&"</div>"

	' 레프트 배너들 확인
		Select Case PAGE_SETTING
			Case "CSCENTER","COMMUNITY"
				'LeftBanners = LeftBanner & LeftBanner01 & LeftCsBank
				LeftBanners = LeftCsBank
			Case Else
				LeftBanners = LeftBanner & LeftBanner01 & LeftCsBank
		End Select




	' 레프트 관련 데이터
		LeftArea = ""
		LeftArea = LeftArea & Tabs(4)& "" & VbCrlf
'		LeftArea = LeftArea & Tabs(4)& LeftLoginArea & VbCrlf
		LeftArea = LeftArea & Tabs(4)& CateArea & VbCrlf
		LeftArea = LeftArea & Tabs(4)& LeftBanners & VbCrlf








	Select Case ContainMode
		Case "LEFT_F"
			InnerContain = "<div id=""contentF"">" & VbCrLf
		Case "LEFT_T"
			InnerContain = "<div id=""left"">" & VbCrlf
			InnerContain = InnerContain & LeftArea
			InnerContain = InnerContain & Tabs(3)& "</div>" & VbCrLf
			InnerContain = InnerContain & Tabs(3)&"<div id=""contentT"">" & VbCrLf
	End Select


	TOP_BTNS = ""


	btn_cart = "<a href=""/shop/cart.asp"">장바구니</a>"
	btn_cscenter = "<a href=""/board/board_list.asp?bname=notice"">고객센터</a>"
	btn_join = "<a href=""/common/member_join.asp"">회원가입</a>"
	btn_login = "<a href=""javascript:popLogin();"">로그인</a>"
	btn_logout = "<a href=""/common/member_logout.asp"">로그아웃</a>"
	btn_mypage = "<a href=""/mypage/default.asp"">마이페이지</a>"
	btn_order = "<a href=""/mypage/order_list.asp"">주문/배송</a>"
	btn_admin = "<a href=""/admin"">관리자</a>"


	'TOP_AREA02_01 BTN
		top_area02_01btn = aImg("/page/company.asp?view=1",IMG_SHARE&"/top_area02_01_btn01.gif",51,14,"")
		top_area02_01btn = top_area02_01btn & aImg("/board/board_list.asp?bname=review",IMG_SHARE&"/top_area02_01_btn02.gif",54,14,"")
		top_area02_01btn = top_area02_01btn & aImg("/board/board_list.asp?bname=notice",IMG_SHARE&"/top_area02_01_btn03.gif",53,14,"")


'로그인 | 회원가입 | 장바구니 | 고객센터

	If DK_MEMBER_LEVEL > 0 Then
		TOP_BTNS = TOP_BTNS & btn_logout & " | "
		TOP_BTNS = TOP_BTNS & btn_mypage & " | "
		TOP_BTNS = TOP_BTNS & btn_cart & " | "
		TOP_BTNS = TOP_BTNS & btn_order & " | "
		TOP_BTNS = TOP_BTNS & btn_cscenter
	Else
		TOP_BTNS = TOP_BTNS & btn_login & " | "
		TOP_BTNS = TOP_BTNS & btn_join & " | "
		TOP_BTNS = TOP_BTNS & btn_cscenter
	End If
	If DK_MEMBER_LEVEL >= 10 Then
		TOP_BTNS = TOP_BTNS & " | " & btn_admin
	End If

%>
