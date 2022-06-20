<!--#include virtual = "/_lib/strFunc.asp"-->
<%
'On Error Resume Next

	'빠른주문
	If webproIP <> "T" Then Response.Redirect "/index.asp"

	PAGE_SETTING = "SHOP"
	ISLEFT = "F"
	ISCATEGORY = "T"
	ISSUBVISUAL = "T"
	ISSUBTOP = "T"

	QUICK_ORDER_TF = pRequestTF("QUICK_ORDER_TF",False)
	If QUICK_ORDER_TF = "" Or DK_MEMBER_LEVEL = 0 Then QUICK_ORDER_TF = "F"

	CATEGORY		= gRequestTF("cate",False)
	CATE_MODE		= gRequestTF("cm",False)

	If CATE_MODE = "" Then CATE_MODE = "all"			'●카테고리 기본페이지


	'============================================================
	'#1 POST
	Dim CATE_MODE1		:	CATE_MODE1 = pRequestTF("cm1",False)

	'#POST값 있는경우 CATE_MODE 치환
	If CATE_MODE1 <> "" Then CATE_MODE = CATE_MODE1
	'============================================================
	CATE_MODE_ORI	= CATE_MODE

	Page			= Request("Page")
	Pagesize		= 20
  if QUICK_ORDER_TF = "T" then Pagesize	= 100

	Dim tSEARCHTERM		:	tSEARCHTERM = pRequestTF("tSEARCHTERM",False)
	Dim tSEARCHSTR		:	tSEARCHSTR = pRequestTF("tSEARCHSTR",False)
	Dim minPrice		:	minPrice = pRequestTF("minPrice",False)
	Dim maxPrice		:	maxPrice = pRequestTF("maxPrice",False)

	If tSEARCHTERM = ""	Then tSEARCHTERM = "" End If
	If tSEARCHSTR = ""	Then tSEARCHSTR = "" End if
	If PAGE = ""		Then PAGE = 1 End If

	If minPrice = "" Then minPrice = ""
	If maxPrice = "" Then maxPrice = ""


	'상품 리스트 표기
	PCONF_isNOTS = "F"
	PCONF_isAUTH = "F"
	PCONF_isDEAL = "F"
	PCONF_isVIPS = "F"
	PCONF_isALLS = "F"


	Select Case DK_MEMBER_LEVEL
		Case 0,1		: PCONF_isNOTS = "T"
		Case 2			: PCONF_isAUTH = "T"
		Case 3			: PCONF_isDEAL = "T"
		Case 4,5		: PCONF_isVIPS = "T"
		Case 9,10,11	: PCONF_isALLS = "T"
	End Select


	'플래그 초기화
	PCONF_isBest	= "F"
	PCONF_isVote	= "F"
	PCONF_isNew		= "F"
	PCONF_isEvent	= "F"

	GOODS_SEARCH_TOTAL_PROC = "HJSP_CATEGORY_GOODS_SEARCH_TOTAL"

	Select Case UCase(CATE_MODE)
		Case "BA"	'베스트
			GOODS_SEARCH_TOTAL_PROC = "HJSP_CATEGORY_GOODS_SEARCH_TOTAL_BVNE"		'상품리스트 (flag)
			PCONF_isBest = "T"
		Case "NA"	'신상품
			GOODS_SEARCH_TOTAL_PROC = "HJSP_CATEGORY_GOODS_SEARCH_TOTAL_BVNE"		'상품리스트 (flag)
			PCONF_isNew = "T"

		Case "EA"	'이벤트
			GOODS_SEARCH_TOTAL_PROC = "HJSP_CATEGORY_GOODS_SEARCH_TOTAL_BVNE"		'상품리스트 (flag)
			PCONF_isEvent = "T"

	End Select


%>
<%
	'▣1차 카테고리 이름 & view(타게팅) for header_shop.asp, left_shop.asp ==================================================================================
	SQL_CATE = "SELECT [strCateName],[intCateSort] FROM [DK_SHOP_CATEGORY] WHERE [strCateCode] = ? AND [strNationCode] = ? "
	subParams = Array(_
		Db.makeParam("@subCateParent",adVarChar,adParamInput,20,Left(CATEGORY,3)) ,_
		Db.makeParam("@strNationCode",adVarChar,adParamInput,6,UCase(DK_MEMBER_NATIONCODE)) _
	)
	Set HJRS_CATE = Db.execRs(SQL_CATE,DB_TEXT,subParams,Nothing)
	If Not HJRS_CATE.BOF And Not HJRS_CATE.EOF Then
		HJRS_CATE_strCateName = HJRS_CATE("strCateName")	'1차 카테고리 이름
	Else
		HJRS_CATE_strCateName = ""
	End If
	Call CloseRS(HJRS_CATE)

	SUM_CATENAME = ""

	If tSEARCHSTR <> "" Then
		SUM_CATENAME = "<span style=""color:#F64D00"">'"&tSEARCHSTR&"'</span>&nbsp;&nbsp;<span style=""font-size:17px;"">검색 결과</span>"
	Else
		If CATEGORY <> "" Then
		'기능 확인
			SQL = "SELECT [isView],[isBest],[isVote],[isNew]"
			SQL = SQL & " FROM [DK_SHOP_CATEGORY] WHERE [strCateCode] = ? AND [strNationCode] = ?"
			arrParams = Array(_
				Db.makeParam("@strCateCode",adVarChar,adParamInput,20,CATEGORY), _
				Db.makeParam("@strNationCode",adVarChar,adParamInput,6,UCase(DK_MEMBER_NATIONCODE)) _
			)
			Set DKRS = Db.execRs(SQL,DB_TEXT,arrParams,Nothing)
			If Not DKRS.BOF And Not DKRS.EOF Then
				DKRS_isView		= DKRS("isView")
				DKRS_isBest		= DKRS("isBest")
				DKRS_isVote		= DKRS("isVote")
				DKRS_isNew		= DKRS("isNew")
			Else
				DKRS_isView		= "F"
				DKRS_isBest		= "F"
				DKRS_isVote		= "F"
				DKRS_isNew		= "F"
			End If
			Call closeRS(DKRS)

			If DKRS_isView = "F" Then Call ALERTS(LNG_SHOP_CATEGORY_JS01,"BACK","")

		End If

		Select Case SHOP_ORDER_PAGE_TYPE
			Case "DETAIL"
				SUM_CATENAME = DKRS_GoodsName
			Case "CART"
				SUM_CATENAME = LNG_MYPAGE_03
			Case "ORDER"
				SUM_CATENAME = LNG_SHOP_CART_TXT_06
			Case "WISHLIST"
				SUM_CATENAME = LNG_MYPAGE_02
			Case "FINISH"
				SUM_CATENAME = LNG_SHOP_ORDER_FINISH_04
			Case Else

				Select Case UCase(CATE_MODE)
					Case "BA"
						If CATEGORY = "" Then
							SUM_CATENAME = "베스트"
						Else
							SUM_CATENAME = "베스트 - <span style=""font-size:20px;"">"&HJRS_CATE_strCateName&"</span>"
						End If
					Case "NA"
						If CATEGORY = "" Then
							SUM_CATENAME = "신상품"
						Else
							SUM_CATENAME = "신상품 - <span style=""font-size:20px;"">"&HJRS_CATE_strCateName&"</span>"
						End If

					Case "EA"
						If CATEGORY = "" Then
							SUM_CATENAME = "기획전"
						Else
							SUM_CATENAME = "기획전 - <span style=""font-size:20px;"">"&HJRS_CATE_strCateName&"</span>"
						End If

					Case Else
						SUM_CATENAME =  HJRS_CATE_strCateName
				End Select


		End Select

	End If


	If CATEGORY = "" And GOODSMALL = "" And CATE_MODE = "" Then SUM_CATENAME = "전체상품보기"

%>
<!--#include virtual = "/_include/document.asp"-->
<!--#include virtual = "/shop/quickOrder.js.asp"-->
<style type="text/css">
	.grid-container {
		display: grid;
		grid-template-columns: repeat(4, 1fr);
	}
	.grid-column-span {
		grid-column :span 5;
  }
</style>
</head>
<body>
<!--#include virtual = "/_include/header.asp"-->
<div id="loadingPro" style="position:fixed; z-index:99999; width:100%; height:100%; top:0px; left:0px; background:url(/images_kr/loading_bg70.png) 0 0 repeat; display:none;">
	<div style="position:relative; top:40%; text-align:center;">
		<img src="<%=IMG%>/159.gif" width="50" alt="" />
	</div>
</div>

	<%
		'▣쇼핑몰 1차카테고리 CNT, /header_shop.asp
	%>
		<!-- <div id="shop_subVisual">
			<div class="shop_subVisual">
				<div class="txt">
					<p class="p01"><%=SUM_CATENAME%></p>
					<%Select Case UCase(DK_MEMBER_NATIONCODE)%>
					<%Case "KR"%>
					<p class="p02"><%=DKCONF_SITE_TITLE%><%=LNG_SHOP_HEADER_TXT_06%></p>
					<%Case "CN"%>
					<p class="p02"><%=DKCONF_SITE_TITLE%><%=LNG_SHOP_HEADER_TXT_06%></p>
					<%Case "US"%>
					<p class="p02"><%=LNG_SHOP_HEADER_TXT_06%><%=DKCONF_SITE_TITLE%></p>
					<%Case Else%>
					<p class="p02"><%=DKCONF_SITE_TITLE%><%=LNG_SHOP_HEADER_TXT_06%></p>
					<%End Select%>
				</div>
				<img src="/images/shop/sub_visual01.jpg" alt="" />
			</div>
		</div> -->
	<%
		'▣쇼핑몰 2차카테고리 CNT
		SQL_SUB2 = "SELECT COUNT([intIDX]) FROM [DK_SHOP_CATEGORY] WHERE [strCateParent] = ? AND [strNationCode] = ? AND [isView] = 'T' "
		arrParams_H = Array(_
			Db.makeParam("@strCateCode",adVarChar,adParamInput,20,Left(CATEGORY,3)), _
			Db.makeParam("@strNationCode",adVarChar,adParamInput,6,UCase(DK_MEMBER_NATIONCODE)) _
		)
		CATEGORY_SUB2_CNT = Db.execRsData(SQL_SUB2,DB_TEXT,arrParams_H,Nothing)
		If CATEGORY_SUB2_CNT > 0 Then
	%>

			<div id="shop_2depth_cate">
				<!-- <div class="cate_tit"><%=SUM_CATENAME%></div> -->
				<div class="cate_wrap">
					<ul>
						<%
							arrParams_C1 = Array(_
								Db.makeParam("@strNationCode",adVarChar,adParamInput,6,UCase(DK_MEMBER_NATIONCODE)), _
								Db.makeParam("@strCateParent",adVarChar,adParamInput,20,Left(CATEGORY,3)) _
							)
							arrList_C1 = Db.execRsList("DKP_SHOP_CATEGORY_LIST",DB_PROC,arrParams_C1,listLen_C1,Nothing)
							If IsArray(arrList_C1) Then
								For C1 = 0 To listLen_C1
									If C1 = 0 Then DB_first = "DB_first" Else DB_first = "" End If
									arr_C1_strCateCode = arrList_C1(1,C1)
									arr_C1_strCateName = arrList_C1(2,C1)

									If Left(CATEGORY,6) = arr_C1_strCateCode Then
										CATE_NM_CSS = "color:#e22813;"
									Else
										CATE_NM_CSS = ""
									End If
						%>
						<li class="<%=DB_first%>" ><a href="/shop/category.asp?cm=<%=CATE_MODE%>&cate=<%=arr_C1_strCateCode%>"><span style="<%=CATE_NM_CSS%>"><%=arr_C1_strCateName%></span></a></li>
						<%
								Next
							End If
						%>
					</ul>
				</div>
			</div>
	<%	End If%>
	<%
		'▣쇼핑몰 3차카테고리 CNT
		SQL_SUB3 = "SELECT COUNT([intIDX]) FROM [DK_SHOP_CATEGORY] WHERE [isView] = 'T' AND [intCateDepth] = 3 AND [strCateParent] = ? AND [strNationCode] = ? "
		arrParams_H3 = Array(_
			Db.makeParam("@strCateCode",adVarChar,adParamInput,20,Left(CATEGORY,6)), _
			Db.makeParam("@strNationCode",adVarChar,adParamInput,6,UCase(DK_MEMBER_NATIONCODE)) _
		)
		CATEGORY_SUB3_CNT = Db.execRsData(SQL_SUB3,DB_TEXT,arrParams_H3,Nothing)
		If CATEGORY_SUB3_CNT > 0 Then

			If Len(CATEGORY) >= 6 Then
				mParent = Left(CATEGORY,6)

				SQLM = "SELECT [intIDX]"
				SQLM = SQLM & ",[strCateCode],[strCateName]"
				SQLM = SQLM & " FROM [DK_SHOP_CATEGORY] WHERE [isView] = 'T' AND [intCateDepth] = ? AND [strCateParent] = ? AND [strNationCode] = ? ORDER BY [intCateSort] ASC"
				arrParamsM = Array(_
					Db.makeParam("@intCateDepth",adInteger,adParamInput,4,3), _
					Db.makeParam("@strCateCode",adVarChar,adParamInput,20,mParent), _
					Db.makeParam("strNationCode",adVarChar,adParamInput,6,UCase(DK_MEMBER_NATIONCODE)) _
				)
				arrListM = Db.execRsList(SQLM,DB_TEXT,arrParamsM,listLenM,Nothing)

			'기능 확인
				SQL = "SELECT [strCateName]"
				SQL = SQL & " FROM [DK_SHOP_CATEGORY] WHERE [strCateCode] = ? AND [strNationCode] = ?"
				arrParamsM = Array(_
					Db.makeParam("@strCateCode",adVarChar,adParamInput,20,CATEGORY), _
					Db.makeParam("@strNationCode",adVarChar,adParamInput,6,UCase(DK_MEMBER_NATIONCODE)) _
				)
				upCateName = Db.execRsData(SQL,DB_TEXT,arrParamsM,Nothing)

	%>
	<div id="shop_3depth_cate" class="cleft">
		<%
			If Len(CATEGORY) = 6 Then lihover = "hover" Else lihover = "" End If

			'line1_ul = "<li class="""&lihover&"""><a href=""category.asp?cate="&mParent&""" class="""&lihover&"""><span>"&LNG_SHOP_HEADER_TXT_03&"</span></a><li>"
			line1_ul = ""
			line2_ul = ""
			line3_ul = ""
			line4_ul = ""
			line5_ul = ""
			line6_ul = ""
			line7_ul = ""
			line8_ul = ""


			If IsArray(arrListM) Then
				For m = 0 To listLenM
					't = m + 2
					t = m + 1
					If CATEGORY = arrListM(1,m) Then lihover = "hover" Else lihover = "" End If
					Select Case t Mod 6
						Case 1 : line1_ul = line1_ul & "<li class="""&lihover&"""><a href=""category.asp?cm="&CATE_MODE&"&cate="&arrListM(1,m)&""" class="""&lihover&"""><span>•&nbsp;&nbsp;"&arrListM(2,m)&"</span></a></li>"
						Case 2 : line2_ul = line2_ul & "<li class="""&lihover&"""><a href=""category.asp?cm="&CATE_MODE&"&cate="&arrListM(1,m)&""" class="""&lihover&"""><span>•&nbsp;&nbsp;"&arrListM(2,m)&"</span></a></li>"
						Case 3 : line3_ul = line3_ul & "<li class="""&lihover&"""><a href=""category.asp?cm="&CATE_MODE&"&cate="&arrListM(1,m)&""" class="""&lihover&"""><span>•&nbsp;&nbsp;"&arrListM(2,m)&"</span></a></li>"
						Case 4 : line4_ul = line4_ul & "<li class="""&lihover&"""><a href=""category.asp?cm="&CATE_MODE&"&cate="&arrListM(1,m)&""" class="""&lihover&"""><span>•&nbsp;&nbsp;"&arrListM(2,m)&"</span></a></li>"
						Case 5 : line5_ul = line5_ul & "<li class="""&lihover&"""><a href=""category.asp?cm="&CATE_MODE&"&cate="&arrListM(1,m)&""" class="""&lihover&"""><span>•&nbsp;&nbsp;"&arrListM(2,m)&"</span></a></li>"
						Case 0 : line6_ul = line6_ul & "<li class="""&lihover&"""><a href=""category.asp?cm="&CATE_MODE&"&cate="&arrListM(1,m)&""" class="""&lihover&"""><span>•&nbsp;&nbsp;"&arrListM(2,m)&"</span></a></li>"
					End Select
				Next
			End If
		%>
		<ul class="fleft"><%=line1_ul%></ul>
		<ul class="fleft"><%=line2_ul%></ul>
		<ul class="fleft"><%=line3_ul%></ul>
		<ul class="fleft"><%=line4_ul%></ul>
		<ul class="fleft"><%=line5_ul%></ul>
		<ul class="fleft"><%=line6_ul%></ul>
	</div>
	<%		End If%>
	<%	End If%>

	<form name="cartFrm" method="post" >
		<input type="hidden" name="mode" readonly="readonly" />
		<input type="hidden" name="QUICK_ORDER_TF" value="<%=QUICK_ORDER_TF%>" readonly="readonly" />
		<input type="hidden" name="arr_cuidx" value="" readonly="readonly" />
		<input type="hidden" name="arr_ea" value="" readonly="readonly" />
		<div id="goods_wrap">
			<div class="tit">
				<p class="p01"><%=SUM_CATENAME%></p>
				<p class="p02"><%=DKCONF_SITE_TITLE%>에서 준비한 상품을 만나보세요.</p>
			</div>
			<%If DK_MEMBER_TYPE = "COMPANY" Or DK_MEMBER_TYPE ="ADMIN" Then%>
				<div class="quickOrder_btn">
					<label class="cp">
						<input type="checkbox" name="checkQuickOrder" class="input_chk20" onClick="javascript: quickOrderChk(this.form);" <%=isChecked(QUICK_ORDER_TF,"T")%> >
						<i></i><span>빠른주문</span><div class="bg"></div></label>
				</div>
			<%End If%>
			<div id="shopN" class="category">
				<!-- 카테고리 일반상품 S -->
				<div id="shop_goods3" class="cleft layout_inner">
					<div class="wrap grid-container">
						<%
							arrParams = Array(_
								Db.makeParam("@CATEGORY",adVarChar,adParamInput,21,CATEGORY), _
								Db.makeParam("@PAGESIZE",adInteger,adParamInput,0,PAGESIZE),_
								Db.makeParam("@PAGE",adInteger,adParamInput,0,PAGE),_
								Db.makeParam("@tSEARCHSTR",adVarChar,adParamInput,30,tSEARCHSTR), _
								Db.makeParam("@tSEARCHTERM",adVarChar,adParamInput,30,tSEARCHTERM), _
								Db.makeParam("@GoodsPrice1",adInteger,adParamInput,50,minPrice), _
								Db.makeParam("@GoodsPrice2",adInteger,adParamInput,50,maxPrice), _

								Db.makeParam("@isBest",adChar,adParamInput,1,PCONF_isBest), _
								Db.makeParam("@isVote",adChar,adParamInput,1,PCONF_isVote), _
								Db.makeParam("@isNew",adChar,adParamInput,1,PCONF_isNew), _
								Db.makeParam("@isEvent",adChar,adParamInput,1,PCONF_isEvent), _

								Db.makeParam("@isNOTS",adChar,adParamInput,1,PCONF_isNOTS), _
								Db.makeParam("@isAUTH",adChar,adParamInput,1,PCONF_isAUTH), _
								Db.makeParam("@isDEAL",adChar,adParamInput,1,PCONF_isDEAL), _
								Db.makeParam("@isVIPS",adChar,adParamInput,1,PCONF_isVIPS), _
								Db.makeParam("@isALLS",adChar,adParamInput,1,PCONF_isALLS), _
								Db.makeParam("@strNationCode",adVarChar,adParamInput,6,UCase(DK_MEMBER_NATIONCODE)), _

								Db.makeParam("@All_Count",adInteger,adParamOutput,0,0) _
							)
							arrList = Db.execRsList(GOODS_SEARCH_TOTAL_PROC,DB_PROC,arrParams,listLen,Nothing)
							'arrList = Db.execRsList("DKSP_CATEGORY_GOODS_SEARCH_TOTAL",DB_PROC,arrParams,listLen,Nothing)
							All_Count = arrParams(UBound(arrParams))(4)

							Dim PAGECOUNT,CNT
							PAGECOUNT = int((ccur(All_Count) - 1 ) / CInt(PAGESIZE) ) + 1
							IF CCur(PAGE) = 1 Then
								CNT = All_Count
							Else
								CNT = All_Count - ((CCur(PAGE)-1)*CInt(PAGESIZE)) '
							End If

							If IsArray(arrList) Then
								For i = 0 To listLen
									arrList_intIDX				= arrList(1,i)
									arrList_GoodsName			= BACKWORD(arrList(2,i))
									arrList_GoodsComment		= BACKWORD(arrList(3,i))
									arrList_GoodsPrice			= arrList(4,i)
									arrList_GoodsCustomer		= arrList(5,i)
									arrList_GoodsCost			= arrList(6,i)
									arrList_GoodsModels			= arrList(7,i)
									arrList_GoodsBrand			= arrList(8,i)
									arrList_GoodsMaterial		= arrList(9,i)
									arrList_imgList				= BACKWORD(arrList(10,i))
									arrList_isCSGoods			= arrList(11,i)
									arrList_CSGoodsCode			= arrList(12,i)
									arrList_GoodsStockType		= arrList(13,i)
									arrList_GoodsPoint			= arrList(14,i)
									arrList_intPriceNot			= arrList(15,i)
									arrList_intPriceAuth		= arrList(16,i)
									arrList_intPriceDeal		= arrList(17,i)
									arrList_intPriceVIP			= arrList(18,i)
									arrList_intMinNot			= arrList(19,i)
									arrList_intMinAuth			= arrList(20,i)
									arrList_intMinDeal			= arrList(21,i)
									arrList_intMinVIP			= arrList(22,i)
									arrList_intPointNot			= arrList(23,i)
									arrList_intPointAuth		= arrList(24,i)
									arrList_intPointDeal		= arrList(25,i)
									arrList_intPointVIP			= arrList(26,i)
									arrList_isImgType			= arrList(27,i)
									arrList_OptionVal			= arrList(28,i)
									arrList_isShopType			= arrList(29,i)
									arrList_strShopID			= arrList(30,i)
									arrList_strShopID			= arrList(30,i)
									arrList_intCSPrice4			= arrList(31,i)
									arrList_intCSPrice5			= arrList(32,i)
									arrList_intCSPrice6			= arrList(33,i)
									arrList_intCSPrice7			= arrList(34,i)
									arrList_flagBest			= arrList(35,i)
									arrList_flagNew				= arrList(36,i)
									arrList_flagVote			= arrList(37,i)
									arrList_ImgThum			= arrList(38,i)
									arrList_GoodsStockNum		= arrList(39,i)

									notPrice = arrList_intPriceNot

									'▣ 소비자 가격
									If CONST_CS_SOBIJA_PRICE_USE_TF = "T" Then
										If DK_MEMBER_STYPE = "1" And arrList_isCSGoods = "T" Then
											notPrice = arrList_GoodsCustomer
										End If
									End If

									Select Case DK_MEMBER_LEVEL
										Case 0,1 '비회원, 일반회원
											arrList_GoodsPrice = arrList_intPriceNot
											arrList_GoodsPoint = arrList_intPointNot
										Case 2 '인증회원
											arrList_GoodsPrice = arrList_intPriceAuth
											arrList_GoodsPoint = arrList_intPointAuth
										Case 3 '딜러회원
											arrList_GoodsPrice = arrList_intPriceDeal
											arrList_GoodsPoint = arrList_intPointDeal
										Case 4,5 'VIP 회원
											arrList_GoodsPrice = arrList_intPriceVIP
											arrList_GoodsPoint = arrList_intPointVIP
										Case 9,10,11
											arrList_GoodsPrice = arrList_intPriceVIP
											arrList_GoodsPoint = arrList_intPointVIP
									End Select

									If arrList_isImgType = "S" Then
										imgPath = VIR_PATH("goods/list")&"/"&arrList_imgList
										newimgWidth = 0
										newimgHeight = 0

										NEW_LENGTH = 250
										Call imgInfoNew(imgPath,newimgWidth,newimgHeight,"",NEW_LENGTH)

										imgPaddingW = (NEW_LENGTH - newimgWidth)/2
										imgPaddingH = (NEW_LENGTH - newimgHeight)/2
										liMarginTop = (250 - newimgHeight) / 2
										goodsImg = "<img src="""&imgPath&""" width="""&newimgWidth&""" height="""&newimgHeight&""" alt="""" style=""margin-top:"&liMarginTop&"px""/>"

									Else
										goodsImg = "<img src="""&backword(arrList_imgList)&""" width="""&upImgWidths_List&""" height="""&upImgHeight_List&""" alt="""" />"
										imgPaddingW = 15
										imgPaddingH = 15
									End If

									If arrList_GoodsCost > 0 Then
										arrList_GoodsCost = num2cur(arrList_GoodsCost)
									Else
										arrList_GoodsCost = ""
									End If

									Select Case arrList_GoodsStockType
										Case "N" '수량'
											If arrList_GoodsStockNum < arrList_orderEa Then
												checkBox_Disabled = " disabled=""disabled"" style=""display: none;"" "
												Soldoutflag = ""
												EA_Display = ""
											End If
										Case "I" '무제한'
											checkBox_Disabled = ""
											Soldoutflag = ""
											EA_Display = ""

										Case "S" '품절'
											checkBox_Disabled = " disabled=""disabled"" style=""display: none;"" "
											Soldoutflag = "<span class=""soldoutTxt"">"&LNG_SHOP_DETAILVIEW_33&"</span>"
											EA_Display = "display:none;"

										Case Else '이상제품
											checkBox_Disabled = " disabled=""disabled"" style=""display: none;"" "
											Soldoutflag = ""
											EA_Display = ""
									End Select

									If arrList_isCSGoods = "T" Then
										'▣CS상품정보 변동정보 통합
										arrParams = Array(_
											Db.makeParam("@ncode",adVarChar,adParamInput,20,arrList_CSGoodsCode) _
										)
										Set DKRS = Db.execRs("HJP_CSGOODS_PRICE_INFO",DB_PROC,arrParams,DB3)
										If Not DKRS.BOF And Not DKRS.EOF Then
											RS_ncode		= DKRS("ncode")
											RS_price		= DKRS("price")
											RS_price2		= DKRS("price2")
											RS_price4		= DKRS("price4")
											RS_price5		= DKRS("price5")
											RS_price6		= DKRS("price6")
											RS_SellCode		= DKRS("SellCode")
											RS_SellTypeName	= DKRS("SellTypeName")
										Else
											RS_price4 = 0
										End If
										Call closeRs(DKRS)
									End If

									If notPrice < 1 Or RS_price2 < 1 Then
										checkBox_Disabled = " disabled=""disabled"" style=""display: none;"" "
										readonly = "readonly=""readonly"" "
									Else
										readonly = ""
									End If

									If notPrice < arrList_GoodsCustomer And DK_MEMBER_LEVEL > 0 And checkBox_Disabled = "" Then
										DisCountPercent = 100 - Round((notPrice/arrList_GoodsCustomer) * 100)
										If DisCountPercent > 0 Then
											DisCountPercent_view = "<div class=""sale""><span>"&DisCountPercent&"</span>%</div>"
										End If
									Else
										DisCountPercent = 0
										DisCountPercent_view = ""
									End If

									sIDX = i

									'▣소비자 PV
									If DK_MEMBER_STYPE= 1 Then RS_price4 = 0

									If QUICK_ORDER_TF = "T" Then LNG_TEXT_SELLING_PRICE = LNG_TEXT_PAY_PRICE
						%>
						<div class="goods" >
							<%=DisCountPercent_view%>
							<div class="soldout"><%=Soldoutflag%></div>
							<%If DK_MEMBER_LEVEL > 0 Then%>
								<%If QUICK_ORDER_TF = "T" Then%>
									<%'#modal dialog%>
									<a name="modal" href="pop_detailview.asp?gidx=<%=arrList_intIDX%>" title="<%=LNG_BTN_DETAIL%>"><div class="img fleft"><i></i><%=goodsImg%></div></a>
								<%Else%>
									<a href="detailView.asp?gidx=<%=arrList_intIDX%>"><div class="img"><i></i><%=goodsImg%></div></a>
								<%End If%>
							<%Else%>
								<a href="javascript:check_frm();"><div class="img"><i></i><%=goodsImg%></div></a>
							<%End If %>
							<div class="txt">
								<p class="p01 goodsName" title="<%=arrList_goodsName%>" >
									<%If QUICK_ORDER_TF = "T" And DK_MEMBER_LEVEL > 0 Then%>
										<span class="cuidx"><input type="hidden" name="cuidx" value="<%=arrList_intIDX%>" readonly="readonly" /></span>
										<label class="cp"><input type="checkbox" name="chkCart" id="chkCart<%=sIDX%>" <%=checkBox_Disabled%> attrCode="<%=RS_SellCode%>" value="<%=arrList_intIDX%>" class="vbottom" onclick="sumAllPrice();"/><span id="goodsName<%=sIDX%>" >(<%=i+1%>)<%=arrList_goodsName%></span></label>
									<%Else%>
										<%=arrList_goodsName%>
									<%End If%>
								</p>
								<p class="p02"><%=cutString2(arrList_GoodsComment,38)%></p>
							</div>
							<div class="price">
								<%If DK_MEMBER_LEVEL > 0 Then%>
								<table <%=tableatt%> class="width100">
									<col width="100">
									<col width="*">
									<%If QUICK_ORDER_TF = "T" Then '상품별금액계산%>
									<tr>
										<td class=""><span><%=LNG_TEXT_ITEM_NUMBER%></span></td>
										<td class="tright">
											<%If Soldoutflag <> "" Then%>
											<span class="red"><%=LNG_SHOP_DETAILVIEW_33%></span>
											<%End If%>
											<div style="<%=EA_Display%>">
												<span class="ea_bg"><a href="javascript: eaUpDown(1,'<%=sIDX%>','down');" class="minus">-</a></span><input type="text" name="ea" id="good_ea<%=sIDX%>" value="1" class="input_text_ea vmiddle tcenter" style="width:40px;" maxlength="3" <%=onlyKeys%> <%=readonly%> /><span class="ea_bg"><a href="javascript: eaUpDown(1,'<%=sIDX%>','up');" class="plus">+</a></span>
											</div>
											<input type="hidden" name="basePrice" id="basePrice<%=sIDX%>" value="<%=notPrice%>" readonly="readonly" />
											<input type="hidden" name="basePV" id="basePV<%=sIDX%>" value="<%=RS_price4%>" readonly="readonly" />
										</td>
									</tr>
									<%End If%>
									<%If CONST_CS_SOBIJA_PRICE_USE_TF = "T" And DK_MEMBER_STYPE = 1 Then	'소비자회원 소비자가%>
										<tr class="tr01">
											<td class="td01"><%=LNG_TEXT_CONSUMER_PRICE%></td>
											<td class="td02 tright">
												<%=spansID(num2cur(arrList_GoodsCustomer),"#222222","13","400","sumEachPrice_txt"&sIDX)%>&nbsp;<%=spans(""&Chg_currencyISO&"","#222222","13","400")%>
											</td>
										</tr>
									<%Else%>
										<%If QUICK_ORDER_TF <> "T" Then%>
										<tr class="tr01">
											<td class="td01"><%=LNG_TEXT_CONSUMER_PRICE%></td>
											<td class="td02 tright mline">
												<%=spans(num2cur(arrList_GoodsCustomer),"#222222","13","400")%>&nbsp;<%=spans(""&Chg_currencyISO&"","#222222","13","400")%>
											</td>
										</tr>
										<%End If%>
										<tr class="tr01">
											<td class="td01"><span id="price_txt<%=sIDX%>"><%=LNG_TEXT_SELLING_PRICE%></span></td>
											<td class="td02 tright">
												<%=spansID(num2cur(notPrice),"#222222","13","400","sumEachPrice_txt"&sIDX)%>&nbsp;<%=spans(""&Chg_currencyISO&"","#222222","13","400")%>
											</td>
										</tr>
										<%If RS_price4 <> "" And DK_MEMBER_LEVEL > 0 And DK_MEMBER_STYPE <> "1" Then %>
										<tr class="tr01">
											<td class="td02"><span id="pv_txt<%=sIDX%>"><%=CS_PV%></span></td>
											<td class="td02 tright">
												<%=spansID(num2curINT(RS_price4),"#ff3300","12","400","sumEachPV_txt"&sIDX)%><%=spans(""&CS_PV&"","#ff3300","11","400")%>
											</td>
										</tr>
										<%End If%>
									<%End If%>
									<%If RS_SellCode <> "" And DK_MEMBER_LEVEL > 0 Then%>
									<tr class="tr01">
										<td class="td02"><%=LNG_TEXT_SALES_TYPE%></td>
										<td class="td02 tright">
											<%=RS_SellTypeName%>
										</td>
									</tr>
									<%End If%>
								</table>
								<%End If%>
							</div>
						</div>
						<%
								Next
							Else
						%>
						<div class="cleft width100 grid-column-span" style="margin-top:15px;text-align:center; padding:90px 0px;"><%=LNG_SHOP_NOT_DATA_TXT_01%></div>
						<%
							End If
						%>
					</div>
					<div class="cleft tcenter width100">
						<div class="pagingArea pagingNew3"><% Call pageListNew3(PAGE,PAGECOUNT)%></div>
					</div>
				</div>
				<!-- 카테고리 일반상품 E -->
			</div>

			<%If DK_MEMBER_LEVEL > 0 And QUICK_ORDER_TF = "T" Then%>
			<div id="fix_menu" class="layout_wrap">
				<div class="layout_inner">
					<div class="all">
						<label>
							<input type="checkbox" name="checklist" onClick="SelectAll()" />
							<span><%=LNG_CS_CART_BTN01%></span>
						</label>
						<br />
						<label>
							<input type="checkbox" name="checkCart" onClick="quickCartChk()" />
							<span><%=LNG_HEADER_CART%></span>
						</label>
					</div>
					<div class="sumCart">
						<div class="flexColumn">
							<div class="sumCart01">
								<span class="pStitle">건수</span>
								<span class="pISO" id="sumAllCase_txt">0</span>
								<span class="pPrice">건</span>
							</div>
						</div>
						<i></i>
						<div class="flexColumn">
							<div class="sumCart02">
								<span class="pStitle"><%=LNG_TOTAL_PAY_PRICE%></span>
								<span class="pISO" id="sumAllPrice_txt">0</span>
								<span class="pPrice"><%=Chg_CurrencyISO%></span>
							</div>
						</div>
						<i></i>
						<div class="flexColumn">
							<div class="sumCart03">
								<span class="pStitle"><%=LNG_CS_ORDERS_TOTAL_PV%></span>
								<span class="pISO" id="sumAllPV_txt">0</span>
								<span class="pPrice"><%=CS_PV%></span>
							</div>
						</div>
					</div>
					<div class="addCart">
						<label><input type="button" name="" id="selectOrderBtn" onclick="javascript: selectOrder();" value="<%=LNG_TEXT_PURCHASE%>"></label>
					</div>
				</div>
			</div>
			<%End If%>
		</div>
	</form>

	<form name="frm" method="post" action="">
		<input type="hidden" name="PAGESIZE" value="<%=PAGESIZE%>" />
		<input type="hidden" name="PAGE" value="<%=PAGE%>" />
		<input type="hidden" name="tSEARCHTERM" value="<%=tSEARCHTERM%>" />
		<input type="hidden" name="tSEARCHSTR" value="<%=tSEARCHSTR%>" />
		<input type="hidden" name="minPrice" value="<%=minPrice%>" />
		<input type="hidden" name="maxPrice" value="<%=maxPrice%>" />
		<input type="hidden" name="cate1" value="<%=CATEGORYS1%>" />
		<input type="hidden" name="cate2" value="<%=CATEGORYS2%>" />
		<input type="hidden" name="cate3" value="<%=CATEGORYS3%>" />
		<input type="hidden" name="cate" value="<%=CATEGORY%>" />
		<input type="hidden" name="cm" value="<%=CATE_MODE%>" />
	</form>

	<form name="quickOrderFrm" method="post" action="/shop/order.asp">
		<input type="hidden" name="cuidx" value="<%=ALL_IDENTITIES%>" readonly="readonly" />
	</form>


<%
  'modal width, height 설정
  MODAL_CONTENT_WIDTH = "780"
  MODAL_CONTENT_HEIGHT = "wh * 0.8"
%>
<!--#include virtual="/_include/modal_config.asp" -->

<!--#include virtual = "/_include/copyright.asp"-->
