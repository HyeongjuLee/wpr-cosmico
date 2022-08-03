<!--#include virtual = "/_lib/strFunc.asp"-->
<%
'On Error Resume Next

	PAGE_SETTING = "SHOP"
	ISLEFT = "F"
	ISCATEGORY = "T"
	ISSUBVISUAL = "T"
	ISSUBTOP = "T"

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
	Dim tSEARCHTERM		:	tSEARCHTERM = pRequestTF("tSEARCHTERM",False)
	Dim tSEARCHSTR		:	tSEARCHSTR = pRequestTF("tSEARCHSTR",False)
	Dim minPrice		:	minPrice = pRequestTF("minPrice",False)
	Dim maxPrice		:	maxPrice = pRequestTF("maxPrice",False)

	If tSEARCHTERM = ""	Then tSEARCHTERM = "" End If
	If tSEARCHSTR = ""	Then tSEARCHSTR = "" End if
	If PAGE = ""		Then PAGE = 1 End If

	If minPrice = "" Then minPrice = ""
	If maxPrice = "" Then maxPrice = ""



	''PCONF_TOPCNT = 4 '페이지 사이즈에 맞춘 상품 나열 갯수 하단의 PCONF_LINECNT 의 제곱으로 나가야함
	PCONF_LINECNT = 3 '페이지 사이즈에 맞춘 상품 나열 갯수 (베스트, 추천, 새상품)

	' 총 WIDTH 값에서 상품갯수에 맞춰 LEFT-MARGIN 값 설정
	' 상품 넓이는 border 를 포함하여 2를 더해준다
	GoodsLeftMargin = Int((1200 - (380*PCONF_LINECNT)) / (PCONF_LINECNT-1))		'1200 - (35 * 2)
	'print GoodsLeftMargin


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

	'PRINT CATEGORY
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
		ArrowMode = "F"
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


	If CATEGORY = "" And GOODSMALL = "" And CATE_MODE = "all" Then
		SUM_CATENAME = LNG_SHOP_COMMON_TXT_01
		ArrowMode = "F"
	End If

%>
<!--#include virtual = "/_include/document.asp"-->
<script type="text/javascript">

	function cart() {
		var f = document.dfrm;
		<%IF DK_MEMBER_TYPE = "SELLER" THEN%>
			alert("<%=LNG_SHOP_DETAILVIEW_13%>");
			return;
		<%else%>
		//if (confirm("장바구니에 추가하시겠습니까?")){
		if (confirm("<%=LNG_SHOP_CATEGORY_JS02%>")){
			return;
		} else {
			return false;
		}
		<%END IF%>
	}

	function check_frm(){
		<%If DK_MEMBER_LEVEL < 1 THEN%>
			 var msg = "<%=LNG_SHOP_DETAILVIEW_10%>";
			 if(confirm(msg)){
				document.location.href="/common/member_login.asp?backURL=<%=ThisPageURL%>";
				return;
			 }else{
				return;
			 }
		<%END IF%>
	}


</script>
</head>
<body>
<!--#include virtual = "/_include/header.asp"-->
	<!-- <div class="cleft titles width100">
		<div class="fleft"><img src="<%=IMG_SHOP%>/tit_category.png" alt="" /></div>
		<div class="map_navi fright">> <span class="tweight" style="color:#047f63;">쇼핑몰</span></div>
	</div> -->

	<%
		'▣쇼핑몰 1차카테고리 CNT, /header_shop.asp
	%>

	<%
		'▣쇼핑몰 2차카테고리 CNT
		'▣쇼핑몰 2차카테고리 CNT
		'1 SQL_SUB2 = "SELECT COUNT([intIDX]) FROM [DK_SHOP_CATEGORY] WHERE [strCateParent] = ? AND [strNationCode] = ? AND [isView] = 'T' "
		'1 arrParams_H = Array(_
		'1 	Db.makeParam("@strCateCode",adVarChar,adParamInput,20,Left(CATEGORY,3)), _
		'1 	Db.makeParam("@strNationCode",adVarChar,adParamInput,6,UCase(DK_MEMBER_NATIONCODE)) _
		'1 )
		'1 CATEGORY_SUB2_CNT = Db.execRsData(SQL_SUB2,DB_TEXT,arrParams_H,Nothing)
		'1 If CATEGORY_SUB2_CNT > 0 Then

		DIM arrParams1
		arrParams1 = array(_
			Db.makeParam("@strCateCode",adVarChar,adParamInput,20,CATEGORY), _
			Db.makeParam("@strNationCode",adVarChar,adParamInput,6,UCase(DK_MEMBER_NATIONCODE)) _
		)
		SET DKRS1 = Db.execRs("DKSP_CATEGORY_MOVE_NP",DB_PROC,arrParams1,Nothing)
		IF NOT DKRS1.BOF AND NOT DKRS1.EOF THEN
			DKRS1_PREV_CATE		= DKRS1("PREV_CATE")
			DKRS1_NEXT_CATE		= DKRS1("NEXT_CATE")

			DKRS1_PREV_CATE = Left(DKRS1_PREV_CATE,3)
			DKRS1_NEXT_CATE = Left(DKRS1_NEXT_CATE,3)
		ELSE
			ArrowMode = "F"
		END IF
	%>
			<div id="shop_2depth_cate" class="category">
				<%if ArrowMode <> "F" then%>
				<div class="main_cate">
				<%else%>
				<div class="main_cate center">
				<%end if%>
					<%if ArrowMode <> "F" then%><a class="arrow left" href="/shop/category.asp?cm=<%=CATE_MODE%>&cate=<%=DKRS1_PREV_CATE%>"><i class="icon-left-open-mini"></i></a><%end if%>
					<div class="cate_tit"><%=SUM_CATENAME%></div>
					<%if ArrowMode <> "F" then%><a class="arrow right" href="/shop/category.asp?cm=<%=CATE_MODE%>&cate=<%=DKRS1_NEXT_CATE%>"><i class="icon-right-open-mini"></i></a><%end if%>
				</div>
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
	<%	'1 End If%>
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
	<%	End If%>
	<%End If%>

	<!-- 카테고리 일반상품 S -->
	<div class="goods_wrap">
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

					' URL 이미지 링크
					If arrList_isImgType = "S" Then
					'	imgPath = VIR_PATH("goods/list")&"/"&arrList_imgList
					'	imgWidth = 0
					'	imgHeight = 0
					'	Call imgInfo(imgPath,imgWidth,imgHeight,"")
					'	goodsImg = "<img src="""&imgPath&""" width="""&imgWidth&""" height="""&imgHeight&""" alt="""" />"

					'	imgPaddingW = (180 -imgWidth)/2
					'	imgPaddingH = (180 -imgHeight)/2

						imgPath = VIR_PATH("goods/list")&"/"&arrList_imgList
						newimgWidth = 0
						newimgHeight = 0

						NEW_LENGTH = 390
						Call imgInfoNew(imgPath,newimgWidth,newimgHeight,"",NEW_LENGTH)

						imgPaddingW = (NEW_LENGTH - newimgWidth)/2
						imgPaddingH = (NEW_LENGTH - newimgHeight)/2
						liMarginTop = (390 - newimgHeight) / 2
						goodsImg = "<img src="""&imgPath&""" alt="""" />"

					Else
						goodsImg = "<img src="""&backword(arrList_imgList)&""" width="""&upImgWidths_List&""" height="""&upImgHeight_List&""" alt="""" />"
						imgPaddingW = 15
						imgPaddingH = 15
					End If

					isFirst = ""
					If (i) Mod PCONF_LINECNT = 0 Or i = 0 Then
						'PRINT "<div class=""cleft  width100"">"	'isFirst = "cleft"
					Else
						'isFirst = " style=""margin-left:"&GoodsLeftMargin&"px"" "
					End If

					isSecond = ""

					If arrList_GoodsCost > 0 Then
						arrList_GoodsCost = num2cur(arrList_GoodsCost)
					Else
						arrList_GoodsCost = ""
					End If

					If arrList_GoodsStockType	= "S" Then
						'Soldoutflag = viewImg(IMG_INDEX_KR&"/i_soldN.gif",50,11,"")
						Soldoutflag = "<span class=""soldoutTxt"">"&LNG_SHOP_DETAILVIEW_33&"</span>"		'Text 품절
					Else
						Soldoutflag = ""
					End If

					'If DK_MEMBER_STYPE = "0" And arrList_isCSGoods = "T" Then
					vipPrice = 0		'COSMICO
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
							RS_price6		= DKRS("price6")		'COSMICO VIP 가
							RS_price7		= DKRS("price7")		'COSMICO 셀러 가
							RS_price8		= DKRS("price8")		'COSMICO 매니저 가
							RS_price9		= DKRS("price9")		'COSMICO 지점장 가
							RS_price10		= DKRS("price10")	'COSMICO 본부장 가
							RS_SellCode		= DKRS("SellCode")
							RS_SellTypeName	= DKRS("SellTypeName")

							'COSMICO VIP 매출가
							Select Case nowGradeCnt
								Case "20"	vipPrice = RS_price6
								Case "30"	vipPrice = RS_price7
								Case "40"	vipPrice = RS_price8
								Case "50"	vipPrice = RS_price9
								Case "60"	vipPrice = RS_price10
								Case Else vipPrice = 0
							End Select

						Else
							RS_price4 = 0
						End If
						Call closeRs(DKRS)
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
		%>
		<div class="goods">
			<%If DK_MEMBER_LEVEL > 0 Then%>
			<a href="/shop/detailView.asp?gidx=<%=arrList_intIDX%>">
			<%Else%>
			<!-- <a href="javascript: check_frm();"> -->
			<a href="/shop/detailView.asp?gidx=<%=arrList_intIDX%>">
			<%End If %>
				<%=DisCountPercent_view%>
				<div class="soldout"><%=Soldoutflag%></div>
				<div class="img"><%=goodsImg%></div>
				<div class="txt">
					<p class="name"><%=arrList_goodsName%></p>
					<p class="comment"><%=arrList_GoodsComment%></p>
					<%If DK_MEMBER_LEVEL > 0 Then%>
						<div class="price">
							<%If CONST_CS_SOBIJA_PRICE_USE_TF = "T" And DK_MEMBER_STYPE = 1 Then	'소비자회원 소비자가%>
								<div><span><%=num2cur(arrList_GoodsCustomer)%></span><%=Chg_CurrencyISO%></div>
							<%Else%>
								<p class="line"><span><%=num2cur(arrList_GoodsCustomer)%></span><%=Chg_CurrencyISO%></p>
								<div><span><%=num2cur(notPrice)%></span><%=Chg_CurrencyISO%></div>

								<%If nowGradeCnt >= 20 And vipPrice > 0 Then	'COSMICO%>
								<div class="pvs">
									<p class=""><span><%=LNG_VIP_PRICE%> : <%=num2cur(vipPrice)%></span><%=Chg_CurrencyISO%></p>
								</div>
								<%End If%>

								<%If RS_price4 <> "" And DK_MEMBER_LEVEL > 0 And DK_MEMBER_STYPE <> "1" Then %>
								<div class="pvs">
									<%If PV_VIEW_TF = "T" Then%>
										<p class="pv"><span><%=num2cur(RS_price4)%></span><%=CS_PV%></p>
									<%End If%>
									<%If BV_VIEW_TF = "T" Then%>
										<p class="bv"><span><%=num2cur(RS_price5)%></span><%=CS_PV2%></p>
									<%End If%>
								</div>
								<%End If%>
							<%End If%>
						</div>
					<%Else%>
						<div class="price" style="margin-bottom: 40px;">
							<div><span><%=num2cur(arrList_GoodsCustomer)%></span><%=Chg_CurrencyISO%></div>
						</div>
					<%End If%>
				</div>
			</a>
		</div>
		<%
						If (i + 1) Mod PCONF_LINECNT = 0 Then
		%>
		<!-- </div> -->
		<%				End If
						'If i = listLen Then print "</div>"

				Next
		%>
		<div class="pagingNew3"><% Call pageListNew3(PAGE,PAGECOUNT)%></div>

		<!--<div class="pagingNew3">
			<span class="arrow left"><a href='javascript:pagegoto(1)'><i class="icon-angle-double-left"></i></a></span>
			<span class="arrow left margin"><a href='javascript:pagegoto(1)'><i class="icon-angle-left"></i></a></span>
			<span class="currentPage">1</span>
			<span><a href="">2</a></span>
			<span><a href="">3</a></span>
			<span><a href="">4</a></span>
			<span><a href="">5</a></span>
			<span><a href="">6</a></span>
			<span><a href="">7</a></span>
			<span><a href="">8</a></span>
			<span><a href="">9</a></span>
			<span class="arrow right margin"><a href='javascript:pagegoto(1)'><i class="icon-angle-right"></i></a></span>
			<span class="arrow right"><a href='javascript:pagegoto(1)'><i class="icon-angle-double-right"></i></a></span>
		</div>//-->
		<%
			Else
		%>
		<div class="width100 nodata" style="margin-top:60px;text-align:center; padding:90px 0px;"><%=LNG_SHOP_NOT_DATA_TXT_01%></div>

		<%
			End If
		%>

		</div>
	<!-- 카테고리 일반상품 E -->
	</div>



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



<!--#include virtual = "/_include/copyright.asp"-->
