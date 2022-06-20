<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	PAGE_WRAPPER_TF = "T"	'header 세팅!!

	PAGE_SETTING = "SHOP"

	Call FN_NationCurrency(DK_MEMBER_NATIONCODE,Chg_CurrencyName,Chg_CurrencyISO)






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
  if QUICK_ORDER_TF = "T" then Pagesize		= 100

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
	'==============================================================================
		'카테고리 검색기능(POST + GET)
		'#1 POST
		Dim CATEGORYS1		:	CATEGORYS1 = pRequestTF("cate1",False)
		Dim CATEGORYS2		:	CATEGORYS2 = pRequestTF("cate2",False)
		Dim CATEGORYS3		:	CATEGORYS3 = pRequestTF("cate3",False)

			'#2 GET
			If Len(CATEGORY) = 3 Then
				CATEGORYS1 = CATEGORY
			End If
			If Len(CATEGORY) = 6 Then
				CATEGORYS1 = Left(CATEGORY,3)
				CATEGORYS2 = CATEGORY
			End If
			If Len(CATEGORY) = 9 Then
				CATEGORYS1 = Left(CATEGORY,3)
				CATEGORYS2 = Left(CATEGORY,6)
				CATEGORYS3 = CATEGORY
			End If

		'#3 POST
		If CATEGORYS1 <> "" Then CATEGORY = CATEGORYS1
		If CATEGORYS2 <> "" Then CATEGORY = CATEGORYS2
		If CATEGORYS3 <> "" Then CATEGORY = CATEGORYS3
		If CATEGORYS1 = "" Then	CATEGORY = ""

	'	Call ResRW(CATEGORY,"CATEGORY")
	'	Call ResRW(CATEGORYS1,"CATEGORYS1")
	'	Call ResRW(CATEGORYS2,"CATEGORYS2")
	'	Call ResRW(CATEGORYS3,"CATEGORYS3")
	'============================================================================
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


	If CATEGORY = ""  And CATE_MODE = "all" Then SUM_CATENAME = "전체상품보기"


%>
<!--#include virtual = "/m/_include/document.asp"-->
<!--#include virtual = "/m/_include/jqueryload.asp"-->
<link rel="stylesheet" href="/m/css/category.css?v1.5" />
<link rel="stylesheet" href="/m/css/shopN.css">
<!--#include virtual = "/shop/quickOrder.js.asp"-->
</head>
<body>
<!--#include virtual = "/m/_include/header.asp"-->
<!--#include virtual = "/m/_include/sub_header.asp"-->
<!--'include virtual="/popupLayer_m.asp" -->
<div id="loadingPro" style="position:fixed; z-index:99999; width:100%; height:100%; top:0px; left:0px; background:url(/images_kr/loading_bg70.png) 0 0 repeat; display:none;">
	<div style="position:relative; top:40%; text-align:center;">
		<img src="<%=IMG%>/159.gif" width="30" alt="" />
	</div>
</div>
<div id="window_ori" style="position:fixed;top:0px;left:0px;width:100%;height:100%;"></div><%'가상키보드 밀림 해제%>
<div id="index" class="porel category">
<%If 1=1 Then%>
	<div id="cateName" class="tcenter">&nbsp;<%=SUM_CATENAME%></div>
	<%'쇼핑몰 카테고리%>
	<div style="margin: 0 calc(5px + 1vw);">
		<div class="shop_depth_cate">
			<form name="searchform" action="<%=ThisPageURL%>" method="post">
				<input type="hidden" name="tSEARCHTERM" value="<%=tSEARCHTERM%>" />
				<input type="hidden" name="tSEARCHSTR" value="<%=tSEARCHSTR%>" />
				<input type="hidden" name="cm1" value="<%=CATE_MODE_ORI%>" />
				<table <%=tableatt%> class="width100">
					<colgroup>
						<col width="" />
						<col width="55" />
					</colgroup>
					<tbody>
						<tr>
							<td class="selects tleft" style="padding-l eft:2px;" >
								<div class="fleft">
									<div class="fleft" style="paddi ng:2px 2px;">
										<select id="cate1" name="cate1" class="select"  >
											<option value="">전체</option>
											<%
												SQL = "SELECT [intIDX],[strCateCode],[strCateName],[strCateParent]"
												SQL = SQL & " FROM [DK_SHOP_CATEGORY] WHERE [strCateParent] = ? AND [strNationCode] = ? AND [isView] = 'T' ORDER BY [intCateSort] ASC "
												arrParams1C = Array(_
													Db.makeParam("@strCateParent",adVarChar,adParamInput,20,"000"), _
													Db.makeParam("@strNationCode",adVarChar,adParamInput,6,UCase(DK_MEMBER_NATIONCODE)) _
												)
												arrList1C = Db.execRsList(SQL,DB_TEXT,arrParams1C,listLen1C,Nothing)
												If Not IsArray(arrList1C) Then
													PRINT "<option value="""">메뉴가 없습니다.</option>"
												Else
													For j = 0 To listLen1C
														arrList1C_intIDX			= arrList1C(0,j)
														arrList1C_strCateCode		= arrList1C(1,j)
														arrList1C_strCateName		= arrList1C(2,j)
														arrList1C_strCateParent		= arrList1C(3,j)

														PRINT "<option value="""&arrList1C_strCateCode&""" "&isSelect(CATEGORYS1,arrList1C_strCateCode)&">"&arrList1C_strCateName&"</option>"
													Next
												End If
											%>
										</select>
									</div>
									<%
										'▣쇼핑몰 2차카테고리 CNT
									'	SQL_SUB2 = "SELECT COUNT([intIDX]) FROM [DK_SHOP_CATEGORY] WHERE [strCateParent] = ? AND [strNationCode] = ? AND [isView] = 'T' "
									'	arrParams_H = Array(_
									'		Db.makeParam("@strCateCode",adVarChar,adParamInput,20,Left(CATEGORY,3)), _
									'		Db.makeParam("@strNationCode",adVarChar,adParamInput,6,UCase(DK_MEMBER_NATIONCODE)) _
									'	)
									'	CATEGORY_SUB2_CNT = Db.execRsData(SQL_SUB2,DB_TEXT,arrParams_H,Nothing)
									'	If CATEGORY_SUB2_CNT > 0 Then
									%>
									<div class="fleft" style="padd ing:2px 2px;">
										<select name="cate2" id="cate2" class="select" disabled="disabled">
											<option value="">전체<!-- 상위 카테고리를 선택해주세요. --></option>
										</select>
									</div>
									<%
									'	End If
									%>
									<%
										'▣쇼핑몰 3차카테고리 CNT
										SQL_SUB3 = "SELECT COUNT([intIDX]) FROM [DK_SHOP_CATEGORY] WHERE [isView] = 'T' AND [intCateDepth] = 3 AND [strCateParent] = ? AND [strNationCode] = ? "
										arrParams_H3 = Array(_
											Db.makeParam("@strCateCode",adVarChar,adParamInput,20,Left(CATEGORY,6)), _
											Db.makeParam("@strNationCode",adVarChar,adParamInput,6,UCase(DK_MEMBER_NATIONCODE)) _
										)
										CATEGORY_SUB3_CNT = Db.execRsData(SQL_SUB3,DB_TEXT,arrParams_H3,Nothing)

										'print CATEGORY_SUB3_CNT
										If CATEGORY_SUB3_CNT > 0 Then
									%>
									<div class="fleft" style="padding:2px 2px;">
										<select name="cate3" id="cate3" class="select" disabled="disabled" >
											<option value=""><!-- 전체 --><!-- 상위 카테고리를 선택해주세요.2 --></option>
										</select>
									</div>
									<%
										End If
									%>
								</div>
							</td>
							<td class="fright" style="paddi ng-top:2px;">
								<input type="submit" class="txtBtn s_medium vtop" value="검색"/>
							</td>
						</tr>

					</tbody>
				</table>
			</form>
		</div>
	</div>
<%End If %>
	<form name="cartFrm" method="post" >
		<input type="hidden" name="mode" readonly="readonly" />
		<input type="hidden" name="QUICK_ORDER_TF"  value="<%=QUICK_ORDER_TF%>" readonly="readonly" />
		<input type="hidden" name="arr_cuidx"  value="" readonly="readonly" />
		<input type="hidden" name="arr_ea"  value="" readonly="readonly" />
		<%If DK_MEMBER_TYPE = "COMPANY" Or DK_MEMBER_TYPE ="ADMIN" Then%>
		<div id="checkBtn">
			<div class="inner">
				<label><input type="checkbox" name="checkQuickOrder" onClick="javascript: quickOrderChk(this.form);" <%=isChecked(QUICK_ORDER_TF,"T")%> ><span style="font-size:15px;"> 빠른주문</span></label>
			</div>
		</div>
		<%End If%>

		<!-- GOODS LIST START -->
		<div id="goodsArea">
			<div class="goodsAreaW">
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
						'arrList = Db.execRsList("HJSP_CATEGORY_GOODS_SEARCH_TOTAL",DB_PROC,arrParams,listLen,Nothing)
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

								' URL 이미지 링크
								If arrList_isImgType = "S" Then
									imgPath = VIR_PATH("goods/list")&"/"&arrList_imgList
									goodsImg = "<img src="""&imgPath&""" alt="""" >"
								Else
									goodsImg = "<img src="""&backword(arrList_imgList)&""" alt="""" />"
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

								If notPrice < arrList_GoodsCustomer And DK_MEMBER_LEVEL > 0 And checkBox_Disabled = "" And QUICK_ORDER_TF = "T" Then
									DisCountPercent = 100 - Round((notPrice/arrList_GoodsCustomer) * 100)
									If DisCountPercent > 0 Then
										DisCountPercent_view = "<div class=""sale"" style=""""><span>"&DisCountPercent&"</span>%</div>"
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
					<div class="goodsSeperate">
						<div class="img">
							<%=DisCountPercent_view%>
							<div class="soldout"><%=Soldoutflag%></div>
							<%If DK_MEMBER_LEVEL > 0 Then%>
								<%If QUICK_ORDER_TF = "T" Then%>
									<%'#modal dialog%>
									<a name="modal" href="pop_detailview.asp?gidx=<%=arrList_intIDX%>" title="<%=LNG_BTN_DETAIL%>"><%=goodsImg%></a>
								<%Else%>
									<a href="/m/shop/detailView.asp?gidx=<%=arrList_intIDX%>"><%=goodsImg%></a>
								<%End If%>
							<%Else%>
								<a href="javascript: check_frm();"><%=goodsImg%></a>
							<%End If %>
						</div>
						<div class="textArea fleft" >
							<div class="goodsName">
								<%If QUICK_ORDER_TF = "T" And DK_MEMBER_LEVEL > 0 Then%>
									<span class="cuidx"><input type="hidden" name="cuidx" value="<%=arrList_intIDX%>" readonly="readonly" /></span>
									<label class="cp"><input type="checkbox" name="chkCart" id="chkCart<%=sIDX%>" <%=checkBox_Disabled%> attrCode="<%=RS_SellCode%>" value="<%=arrList_intIDX%>" class="cp vbottom" onclick="sumAllPrice();" /><span id="goodsName<%=sIDX%>">(<%=i+1%>)<%=arrList_goodsName%></span></label>
								<%Else%>
									<%=arrList_goodsName%>
								<%End If%>
							</div>
							<div class="text_noline comment fleft"><%=arrList_GoodsComment%></div>
							<div class="price">
								<%If DK_MEMBER_LEVEL > 0 Then%>
								<table <%=tableatt%> class="width100">
									<col width="" />
									<col width="" />
									<%If QUICK_ORDER_TF = "T" Then '상품별금액계산%>
									<tr>
										<td class=""><span><%=LNG_TEXT_ITEM_NUMBER%></span></td>
										<td class="tright">
											<%If Soldoutflag <> "" Then%>
											<span class="soldoutTxt2"><%=LNG_SHOP_DETAILVIEW_33%></span>
											<%End If%>
											<span style="<%=EA_Display%>">
												<span class="ea_bg"><a href="javascript: eaUpDown(1,'<%=sIDX%>','down');"  class="minus">-</a></span><input type="tel" name="ea" id="good_ea<%=sIDX%>" value="1" class="input_text_ea vmiddle tcenter" maxlength="2" <%=onlyKeys%> readonly="readonly"/><span class="ea_bg"><a href="javascript: eaUpDown(1,'<%=sIDX%>','up');" class="plus">+</a></span>
											</span>
											<input type="hidden" name="basePrice" id="basePrice<%=sIDX%>" value="<%=notPrice%>" readonly="readonly" />
											<input type="hidden" name="basePV" id="basePV<%=sIDX%>" value="<%=RS_price4%>" readonly="readonly" />
										</td>
									</tr>
									<%End If%>
									<%If CONST_CS_SOBIJA_PRICE_USE_TF = "T" And DK_MEMBER_STYPE = 1 Then	'소비자회원 소비자가%>
										<tr class="">
											<td class=""><span><%=LNG_TEXT_CONSUMER_PRICE%></span></td>
											<td class="tright">
												<%=spansID(num2cur(arrList_GoodsCustomer),"#222222","11","400","sumEachPrice_txt"&sIDX)%><%=spans(""&Chg_currencyISO&"","#222222","11","400")%>
											</td>
										</tr>
									<%Else%>
										<%If QUICK_ORDER_TF <> "T" Then%>
										<tr class="">
											<td class=""><span><%=LNG_TEXT_CONSUMER_PRICE%></span></td>
											<td class="tright mline">
												<%=spans(num2cur(arrList_GoodsCustomer),"#222222","11","400")%><%=spans(""&Chg_currencyISO&"","#222222","11","400")%>
											</td>
										</tr>
										<%End If%>
										<tr class="">
											<td class=""><span id="price_txt<%=sIDX%>"><%=LNG_TEXT_SELLING_PRICE%></span></td>
											<td class="tright">
												<%=spansID(num2cur(notPrice),"#222222","11","400","sumEachPrice_txt"&sIDX)%><%=spans(""&Chg_currencyISO&"","#222222","11","400")%>
											</td>
										</tr>
										<%If RS_price4 <> "" And DK_MEMBER_LEVEL > 0 And DK_MEMBER_STYPE <> "1" And QUICK_ORDER_TF = "T" Then %>
										<tr class="">
											<td class=""><span id="pv_txt<%=sIDX%>"><%=CS_PV%></span></td>
											<td class="tright">
												<%=spansID(num2curINT(RS_price4),"#ff3300","10","400","sumEachPV_txt"&sIDX)%><%=spans(""&CS_PV&"","#ff3300","8","400")%>
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
					</div>
					<%
							Next
					%>
					<div class="pagingMob5n"><% Call pageListMob5n(PAGE,PAGECOUNT)%></div>
					<%
						Else
					%>
					<div class="cleft width100" style="text-align:center; padding:50px 0px;"><%=LNG_SHOP_NOT_DATA_TXT_01%></div>
					<%
						End If
					%>
				</div>
			</div>
		</div>
		<!-- GOODS LIST END -->

		<%If DK_MEMBER_LEVEL > 0 And QUICK_ORDER_TF = "T" Then%>
		<div id="fix_menu">
			<div class="inner">
				<div class="all">
					<label class="fleft" style="width: 49%;">
						<input type="checkbox" name="checklist" onClick="SelectAll()" />
						<span><%=LNG_CS_CART_BTN01%></span>
					</label>
					<label class="fright" style="width: 49%;">
						<input type="checkbox" name="checkCart" onClick="quickCartChk()" />
						<span><%=LNG_HEADER_CART%></span>
					</label>
				</div>
				<div class="sumCart">
					<div class="sumCart01">
						<span class="pStitle">건수</span>
						<span class="pISO" id="sumAllCase_txt">0</span>
						<span class="pPrice">건</span>
						<i></i>
					</div>
					<div class="sumCart02">
						<span class="pStitle"><%=LNG_TOTAL_PAY_PRICE%></span>
						<span class="pISO" id="sumAllPrice_txt">0</span>
						<span class="pPrice"><%=Chg_CurrencyISO%></span>
						<i></i>
					</div>
					<div class="sumCart03">
						<span class="pStitle"><%=LNG_CS_ORDERS_TOTAL_PV%></span>
						<span class="pISO" id="sumAllPV_txt">0</span>
						<span class="pPrice"><%=CS_PV%></span>
					</div>
				</div>
				<div class="addCart">
					<label>
						<input type="button" name="" id="selectOrderBtn" onclick="javascript: selectOrder();" value="<%=LNG_TEXT_PURCHASE%>">
					</label>
				</div>
			</div>
		</div>
		<style type="text/css">
			#bottom_wrap {padding-bottom: calc(180px + 10vw);}
		</style>
		<%End If%>
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

	<form name="quickOrderFrm" method="post" action="/m/shop/order.asp">
		<input type="hidden" name="cuidx" value="<%=ALL_IDENTITIES%>" readonly="readonly" />
	</form>

</div>

<!--#include virtual="/m/_include/modal_config.asp" -->

<!--#include virtual = "/m/_include/copyright.asp"-->