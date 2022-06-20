<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	Session.CodePage = 65001
	Response.CharSet = "UTF-8"
	Response.AddHeader "Pragma","no-cache"
	Response.AddHeader "Expires","0"

	'Metac21 메인index ajax 2022-03-25
	Call FN_NationCurrency(DK_MEMBER_NATIONCODE,Chg_CurrencyName,Chg_CurrencyISO)

	CATEGORY  = pRequestTF("cate",True)

	If CATEGORY = "ALL" then CATEGORY =""
'print CATEGORY

	Page			= Request("Page")
	Pagesize		= 4
	Dim tSEARCHTERM		:	tSEARCHTERM = pRequestTF("tSEARCHTERM",False)
	Dim tSEARCHSTR		:	tSEARCHSTR = pRequestTF("tSEARCHSTR",False)
	Dim minPrice		:	minPrice = pRequestTF("minPrice",False)
	Dim maxPrice		:	maxPrice = pRequestTF("maxPrice",False)

	If tSEARCHTERM = ""	Then tSEARCHTERM = "" End If
	If tSEARCHSTR = ""	Then tSEARCHSTR = "" End if
	If PAGE = ""		Then PAGE = 1 End If

	If minPrice = "" Then minPrice = ""
	If maxPrice = "" Then maxPrice = ""

	PCONF_LINECNT = 4 '페이지 사이즈에 맞춘 상품 나열 갯수 (베스트, 추천, 새상품)

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

	'PRINT CATEGORY
%>

				<div id="">
					<!--#include virtual = "/_include/header_shop_category.asp"-->
					<!-- 카테고리 일반상품 S -->
					<div class="wrap">
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

									imgPath = VIR_PATH("goods/list")&"/"&arrList_imgList
									goodsImg = "<img src="""&imgPath&""" alt="""" />"

									RS_price4 = 0
									If arrList_isCSGoods = "T" Then
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
										End If
										Call closeRs(DKRS)
									End If
						%>
						<div class="goods">
							<%If DK_MEMBER_LEVEL > 0 Then%>
							<a href="/shop/detailView.asp?gidx=<%=arrList_intIDX%>">
							<%Else%>
							<a href="javascript: check_frm();">
							<%End If %>
								<div class="img"><%=goodsImg%></div>
								<div class="txt">
									<p class="p01"><%=arrList_goodsName%></p>
									<p class="p02"><%=arrList_GoodsComment%></p>
									<%If DK_MEMBER_LEVEL > 0 Then%>
									<div class="price">
										<%If CONST_CS_SOBIJA_PRICE_USE_TF = "T" And DK_MEMBER_STYPE = 1 Then	'소비자회원 소비자가%>
											<div><span><%=num2cur(arrList_GoodsCustomer)%></span><%=Chg_CurrencyISO%></div>
										<%Else%>
											<p class="p01 mline"><span><%=num2cur(arrList_GoodsCustomer)%></span><%=Chg_CurrencyISO%></p>
											<p class="p01"><span><%=num2cur(notPrice)%></span><%=Chg_CurrencyISO%></p>
											<%If RS_price4 <> "" And DK_MEMBER_LEVEL > 0 And DK_MEMBER_STYPE <> "1" Then %>
											<p class="pv"><span><%=num2cur(RS_price4)%></span><%=CS_PV%></p>
											<p class="bv"><span><%=num2cur(RS_price5)%></span><%=CS_PV2%></p>
											<%End If%>
										<%End If%>
									</div>
									<%End If%>
								</div>
							</a>
						</div>
						<%
								Next
							Else
						%>
						<div class="width100 nodata"><%=LNG_SHOP_NOT_DATA_TXT_01%></div>
						<%
							End If
						%>
					<!-- 카테고리 일반상품 E -->
					</div>
				</div>

