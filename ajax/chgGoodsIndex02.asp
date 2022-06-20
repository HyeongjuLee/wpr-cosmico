<!--#include virtual = "/_lib/strFunc.asp"-->
<%

	Session.CodePage = 65001
	Response.CharSet = "UTF-8"
	Response.AddHeader "Pragma","no-cache"
	Response.AddHeader "Expires","0"

	'/index.asp  BEST/NEW & 카테고리 ajax

	Call FN_NationCurrency(DK_MEMBER_NATIONCODE,Chg_CurrencyName,Chg_CurrencyISO)


	'CATEGORY = gRequestTF("cate",True)
	CATEGORY  = pRequestTF("cate",True)
	'SORTORDER = pRequestTF("sn",True)

	If CATEGORY = "" Then CATEGORY = "101"

	tSEARCHSTR = ""
	tSEARCHTERM = ""
	minPrice = ""
	maxPrice = ""

	PCONF_TOPCNT = 8 '페이지 사이즈에 맞춘 상품 나열 갯수 하단의 PCONF_LINECNT 의 제곱으로 나가야함
	PCONF_LINECNT = 4 '페이지 사이즈에 맞춘 상품 나열 갯수 (베스트, 추천, 새상품)

	' 총 WIDTH 값에서 상품갯수에 맞춰 LEFT-MARGIN 값 설정
	' 상품 넓이는 border 를 포함하여 2를 더해준다
	GoodsLeftMargin = Int((1050 - (250*PCONF_LINECNT)) / (PCONF_LINECNT-1))
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

	'상품정렬순서에
'	Select Case SORTORDER
'		Case "S1"
'			BestTF = "T"
'			VoteTF = "F"
'			NewTF  = "F"
'		Case "S2"
'			BestTF = "F"
'			VoteTF = "F"
'			NewTF  = "T"
'		Case ELSE
'			BestTF = "T"
'			VoteTF = "F"
'			NewTF  = "F"
'	End Select

%>

<!-- 카테고리 신상품 S -->
	<div class="g_wrap layout_wrap fleft" id="" style="margin-bottom:-80px;">
		<div id="goods_wrap" class="index layout_inner">
			<div class="tit">
				<p class="p01">열우물 신상품</p>
				<p class="p02">열우물에서 가장 인기많은 상품들을 소개합니다.</p>
			</div>
			<!--#include virtual = "/_include/header_shop_category02.asp"-->
			<div class="wrap">
				<%
					arrParams2 = Array(_
						Db.makeParam("@TOPCNT",adInteger,adParamInput,4,PCONF_TOPCNT), _
						Db.makeParam("@tSEARCHSTR",adVarWChar,adParamInput,30,tSEARCHSTR), _
						Db.makeParam("@tSEARCHTERM",adVarChar,adParamInput,30,tSEARCHTERM), _
						Db.makeParam("@GoodsPrice1",adInteger,adParamInput,50,minPrice), _
						Db.makeParam("@GoodsPrice2",adInteger,adParamInput,50,maxPrice), _

						Db.makeParam("@isBest",adChar,adParamInput,1,"F"), _
						Db.makeParam("@isVote",adChar,adParamInput,1,"F"), _
						Db.makeParam("@isNew",adChar,adParamInput,1,"T"), _

						Db.makeParam("@isNOTS",adChar,adParamInput,1,PCONF_isNOTS), _
						Db.makeParam("@isAUTH",adChar,adParamInput,1,PCONF_isAUTH), _
						Db.makeParam("@isDEAL",adChar,adParamInput,1,PCONF_isDEAL), _
						Db.makeParam("@isVIPS",adChar,adParamInput,1,PCONF_isVIPS), _
						Db.makeParam("@isALLS",adChar,adParamInput,1,PCONF_isALLS), _

						Db.makeParam("@CATEGORY",adVarChar,adParamInput,20,CATEGORY), _
						Db.makeParam("@strNationCode",adVarChar,adParamInput,6,UCase(DK_MEMBER_NATIONCODE)) _
					)
					arrList2 = Db.execRsList("DKSP_CATEGORY_GOODS_SEARCH_TOTAL_BVN",DB_PROC,arrParams2,listLen2,Nothing)
					If IsArray(arrList2) Then
				%>
				<div id="productWrap">
					<div id="productSlide_AJAX02" style="visibility:hidden;opacity:0">
					<%
						For z = 0 To listLen2
							arrList2_intIDX				= arrList2(0,z)
							arrList2_GoodsName			= BACKWORD(arrList2(1,z))
							arrList2_GoodsComment		= BACKWORD(arrList2(2,z))
							arrList2_GoodsPrice			= arrList2(3,z)
							arrList2_GoodsCustomer		= arrList2(4,z)
							arrList2_GoodsCost			= arrList2(5,z)
							arrList2_GoodsModels		= arrList2(6,z)
							arrList2_GoodsBrand			= arrList2(7,z)
							arrList2_GoodsMaterial		= arrList2(8,z)
							arrList2_imgList			= BACKWORD(arrList2(9,z))
							arrList2_isCSGoods			= arrList2(10,z)
							arrList2_CSGoodsCode		= arrList2(11,z)
							arrList2_GoodsStockType		= arrList2(12,z)
							arrList2_GoodsPoint			= arrList2(13,z)
							arrList2_intPriceNot		= arrList2(14,z)
							arrList2_intPriceAuth		= arrList2(15,z)
							arrList2_intPriceDeal		= arrList2(16,z)
							arrList2_intPriceVIP		= arrList2(17,z)
							arrList2_intMinNot			= arrList2(18,z)
							arrList2_intMinAuth			= arrList2(19,z)
							arrList2_intMinDeal			= arrList2(20,z)
							arrList2_intMinVIP			= arrList2(21,z)
							arrList2_intPointNot		= arrList2(22,z)
							arrList2_intPointAuth		= arrList2(23,z)
							arrList2_intPointDeal		= arrList2(24,z)
							arrList2_intPointVIP		= arrList2(25,z)
							arrList2_isImgType			= arrList2(26,z)
							arrList2_OptionVal			= arrList2(27,z)
							arrList2_isShopType			= arrList2(28,z)
							arrList2_strShopID			= arrList2(29,z)
							arrList2_intCSPrice4		= arrList2(30,z)
							arrList2_intCSPrice5		= arrList2(31,z)
							arrList2_intCSPrice6		= arrList2(32,z)
							arrList2_intCSPrice7		= arrList2(33,z)
							arrList2_flagBest			= arrList2(34,z)
							arrList2_flagNew			= arrList2(35,z)
							arrList2_flagVote			= arrList2(36,z)

							notPrice = arrList2_intPriceNot

							Select Case DK_MEMBER_LEVEL
								Case 0,1 '비회원, 일반회원
									arrList2_GoodsPrice = arrList2_intPriceNot
									arrList2_GoodsPoint = arrList2_intPointNot
								Case 2 '인증회원
									arrList2_GoodsPrice = arrList2_intPriceAuth
									arrList2_GoodsPoint = arrList2_intPointAuth
								Case 3 '딜러회원
									arrList2_GoodsPrice = arrList2_intPriceDeal
									arrList2_GoodsPoint = arrList2_intPointDeal
								Case 4,5 'VIP 회원
									arrList2_GoodsPrice = arrList2_intPriceVIP
									arrList2_GoodsPoint = arrList2_intPointVIP
								Case 9,10,11
									arrList2_GoodsPrice = arrList2_intPriceVIP
									arrList2_GoodsPoint = arrList2_intPointVIP
							End Select

							' URL 이미지 링크
							If arrList2_isImgType = "S" Then
								imgPath = VIR_PATH("goods/list")&"/"&arrList2_imgList

								newimgWidth = 0
								newimgHeight = 0

								NEW_LENGTH = 250
								Call imgInfoNew(imgPath,newimgWidth,newimgHeight,"",NEW_LENGTH)

								imgPaddingW = (NEW_LENGTH - newimgWidth)/2
								imgPaddingH = (NEW_LENGTH - newimgHeight)/2
								liMarginTop = (250 - newimgHeight) / 2
								goodsImg = "<img src="""&imgPath&""" width="""&newimgWidth&""" height="""&newimgHeight&""" alt="""" style=""margin-top:"&liMarginTop&"px""/>"
							Else
								goodsImg = "<img src="""&backword(arrList2_imgList)&""" width="""&upImgWidths_List&""" height="""&upImgHeight_List&""" alt="""" />"
								imgPaddingW = 15
								imgPaddingH = 15
							End If

							If arrList2_GoodsStockType	 = "S" Then
								Soldoutflag = "<span class=""soldoutTxt"">"&LNG_SHOP_DETAILVIEW_33&"</span>"		'Text 품절
							Else
								Soldoutflag = ""
							End If

							If DK_MEMBER_STYPE = "0" And arrList2_isCSGoods = "T" Then
								'▣CS상품정보 변동정보 통합
								arrParams = Array(_
									Db.makeParam("@Na_Code",adVarChar,adParamInput,50,UCase(DK_MEMBER_NATIONCODE)), _
									Db.makeParam("@ncode",adVarChar,adParamInput,20,arrList2_CSGoodsCode) _
								)
								Set DKRS = Db.execRs("HJP_CSGOODS_PRICE_INFO_GLOBAL",DB_PROC,arrParams,DB3)
								'Set DKRS = Db.execRs("HJP_CSGOODS_PRICE_INFO",DB_PROC,arrParams,DB3)
								If Not DKRS.BOF And Not DKRS.EOF Then
									RS_ncode		= DKRS("ncode")
									RS_price2		= DKRS("price2")
									RS_price4		= DKRS("price4")
									RS_price5		= DKRS("price5")
									RS_price6		= DKRS("price6")
									RS_SellCode		= DKRS("SellCode")
									RS_SellTypeName	= DKRS("SellTypeName")
								End If
								Call closeRs(DKRS)
							End If

							'If notPrice < arrList2_GoodsCustomer And DK_MEMBER_STYPE = "0" Then
							If notPrice < arrList2_GoodsCustomer Then		'피키요청 2017-12-07~
								DisCountPercent = 100 - Round((notPrice/arrList2_GoodsCustomer) * 100)
							Else
								DisCountPercent = 0
							End If

					%>
						<div class="goodsN" style="margin: 0 0px;">
							<%If DK_MEMBER_LEVEL > 0 Then%>
							<a href="/shop/detailView.asp?gidx=<%=arrList2_intIDX%>">
							<%Else%>
							<a href="javascript:check_frm();">
							<%End If %>
								<%If DisCountPercent > 0 And DK_MEMBER_LEVEL > 0 Then%>
								<p class="sale"><span><%=DisCountPercent%></span>%</p>
								<%End If%>
								<div class="images fright" style="width:248px; height:248px;"><%=goodsImg%></div>
								<div class="txt fleft width100">
									<!-- <span class="s01"><%=cutString2(arrList2_GoodsComment,38)%></span> -->
									<span class="s02"><%=arrList2_GoodsName%></span>
								</div>
							</a>
							<%If DK_MEMBER_LEVEL > 0 Then%>
							<div class="fleft width100" style="margin-top:30px;">
								<table <%=tableatt%> class="width100 gTable">
									<col width="85" />
									<col width="*" />
										<tr>
											<td class="th"><!-- <%=LNG_SHOP_DETAILVIEW_15%> --></td>
											<td class="pricelt tright mline"><span><%=num2cur(arrList2_GoodsCustomer)%></span><%=Chg_CurrencyISO%></td>
										</tr><tr>
											<td class="th"><!-- <%=LNG_SHOP_DETAILVIEW_16%> --></td>
											<td class="price tright"><span><%=num2cur(notPrice)%></span><%=Chg_CurrencyISO%></td>
										</tr>
								</table>
							</div>
							<%Else%>
							<!-- <div class="search">
								<a href="javascript:check_frm();">
									<span class="txt">회원전용 가격확인</span>
									<span class="img"><img src="<%=IMG_SHOP%>/goods_btn.png" alt="" class="off" /><img src="<%=IMG_SHOP%>/goods_btn_on.png" alt="" class="on" /></span>
								</a>
							</div> -->
							<%End If%>
						</div>
					<%
						Next
					%>
					</div>
					<%If listLen2 > 3 then%>
						<span><a href="#" id="prevBtn02AJ"><img src="/images_kr/index/goods_arrow_left.png" alt="이전 버튼" /></a></span>
						<span><a href="#" id="nextBtn02AJ"><img src="/images_kr/index/goods_arrow_right.png" alt="다음 버튼" /></a></span>
					<%End If%>
				</div>
				<%
					Else
				%>
				<div class="width100 tcenter" style="height:313px;line-height:290px;">
					<div class="nodata" >등록된 상품이 없습니다.</div>
				</div>
				<%
					End If
				%>
			</div>
		</div>
	</div>
	<!-- 카테고리 신상품 E -->






