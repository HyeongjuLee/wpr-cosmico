<!--#include virtual = "/_lib/strFunc.asp"-->
<%






	Call FN_NationCurrency(DK_MEMBER_NATIONCODE,Chg_CurrencyName,Chg_CurrencyISO)


	PAGE_SETTING = "INDEX"

'	CATEGORY	= gRequestTF("cate",True)


	Dim tSEARCHTERM		:	tSEARCHTERM = pRequestTF("tSEARCHTERM",False)
	Dim tSEARCHSTR		:	tSEARCHSTR = pRequestTF("tSEARCHSTR",False)
	Dim minPrice		:	minPrice = pRequestTF("minPrice",False)
	Dim maxPrice		:	maxPrice = pRequestTF("maxPrice",False)

	If tSEARCHTERM = ""	Then tSEARCHTERM = "" End If
	If tSEARCHSTR = ""	Then tSEARCHSTR = "" End if

	If minPrice = "" Then minPrice = ""
	If maxPrice = "" Then maxPrice = ""

	If CATEGORY = "" Then CATEGORY = "101"



	PCONF_TOPCNT = 4 '페이지 사이즈에 맞춘 상품 나열 갯수 하단의 PCONF_LINECNT 의 제곱으로 나가야함
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

%>
<!--#include virtual = "/m/_include/document.asp"-->
<!--#include virtual = "/m/_include/jqueryload.asp"-->
<link rel="stylesheet" href="/m/js/swiper/swiper.min.css" />
<script type="text/javascript" src="/m/js/swiper/swiper.min.js"></script>
<script type="text/javascript">
<!--

	//index BEST AJAX
	function chgGoodsIndex(cate) {
		$.ajax({
			type: "POST"
			,url: "/m/chgGoodsIndex.asp"
			,data : {
				"cate"  : cate
			}
			,success: function(data) {
				document.getElementById("chgIndexContent").innerHTML = data;
				//document.getElementsByClassName("chgIndexContent")[0].innerHTML = data;
			}
			,error:function(data) {
				alert("ajax 처리 중 에러가 발생하였습니다.ERROR CODE : "+data.status+" "+data.statusText+" "+data.responseText);
			}
		});
	}


// -->
</script>
<link rel="stylesheet" type="text/css" href="shop.css" />
<script type="text/javascript" src="shop.js"></script>
<style type="text/css">

	@media all and (min-width:1px) and (max-width:480px) {
		#goods_wrap .index_v_goods {float:left; width:44%; margin-top:10px; background-color:#fff;margin-left:4%;}
		#goods_wrap .index_v_goods2 {float:left; width:44%;margin-left:4%; margin-top:10px; background-color:#fff;margin-right:4%;}
	}
	@media all and (min-width:481px) {
		#goods_wrap .index_v_goods {float:left; width:44%; margin-top:10px; background-color:#fff;margin-left:4%;}
		#goods_wrap .index_v_goods2 {float:left; width:44%;margin-left:4%; margin-top:10px; background-color:#fff;margin-right:4%;}
	}

	#goods_wrap .gArea {text-align: left; position: relative; font-weight: 400;  background-color: #fff; border-bottom:0px solid #ccc;border-radius: 10px;overflow: hidden;
		 box-shadow:		1px 1px 10px 0 rgba(0,0,0,0.1);
		-webkit-box-shadow: 1px 1px 10px 0 rgba(0,0,0,0.1);
		-mozbox-shadow:		1px 1px 10px 0 rgba(0,0,0,0.1);
	}
	#goods_wrap .gArea:hover {box-shadow: 1px 3px 15px 0 rgba(0,0,0,0.3); }
	#goods_wrap .gArea a {display:block;}

	#goods_wrap .gArea .img {position:relative;height:0;overflow:hidden; border: 0px solid #dadada;border-bottom:none;}
	#goods_wrap .gArea .img p {width: 32px; height: 37px; position: absolute; top: 8px; left: 10px; background-image: url(/m/images/mall_icon.svg); background-size: 32px; color: #fff; font-size: 10px; line-height: 37px; text-align: center; font-weight: 300;z-index:9;}

	#goods_wrap .gArea .textArea {padding:0px 10px;border: 0px solid #dadada; border-top:1px solid #ffffff;}

	#goods_wrap .gArea .comment {color: #a1a1a1; font-size: 11px;line-height:20px;height:20px;}
	#goods_wrap .gArea .goodsName {color: #535353; font-size: 14px; font-weight: 500; text-align: center; padding: 2px 5px; color: #535353;overflow: hidden;  }
	#goods_wrap .gArea .priceArea {margin-top:15px;margin-bottom:10px;  height:50px; }
	#goods_wrap .gArea .priceInArea {}

	#goods_wrap .gArea .sellPrice {float: left; font-size:13px; color:#242424; line-height:10px; letter-spacing:-1px;}
	#goods_wrap .gArea .textArea .sale {color: #f36465; font-size: 10px; float: right; margin-top: 25px; padding: 0 5px;	 position: absolute; bottom: 10px; right: 10px;}
	#goods_wrap .gArea .textArea .sale span {font-size: 22px; font-weight: 600;}

	#goods_wrap .textArea .gTable {margin-top:4px;}
	#goods_wrap .textArea .gTable td {padding:0px 0px;}
	#goods_wrap .textArea .gTable td.price {color: #818181; font-size: 12px; line-height: 10px;}
	#goods_wrap .textArea .gTable td.price2 {color: #656565; font-size: 16px; line-height: 16px; margin-top: 5px; padding-top: 5px; text-align: center;}
	#goods_wrap .textArea .gTable td.PV {font-size: 11px; color: #656565;font-weight:normal;}

	#goods_wrap .more {width: auto; height: 35px; background: #fff; border: 1px solid #e3e3e3; line-height: 35px; position: relative; cursor: pointer;}



	/* 인덱스 */

	#goods_wrap .gArea2 {text-align: left; position: relative; font-weight: 400;  background-color: #fff; border-bottom:0px solid #ccc;}

	#goods_wrap .gArea2 a {display:block;}
	#goods_wrap .gArea2 .img {position:relative;height:0;overflow:hidden;border: 1px solid #dadada;}
	#goods_wrap .gArea2 .img p {width: 32px; height: 37px; position: absolute; top: 8px; left: 10px; background-image: url(/m/images/mall_icon.svg); background-size: 32px; color: #fff; font-size: 10px; line-height: 37px; text-align: center; font-weight: 300;z-index:9;}

	#goods_wrap .gArea2 .textArea {padding:5px 4px;border: 0px solid #dadada; border-top:1px solid #ffffff; background:#fbf8ef;overflow: hidden;}

	#goods_wrap .gArea2 .comment {color: #a1a1a1; font-size: 11px;line-height:20px;height:20px;}
	#goods_wrap .gArea2 .goodsName {color: #535353; font-size: 14px; font-weight: 500; text-align: left; padding: 2px 0px; color: #535353;overflow: hidden;  }
	#goods_wrap .gArea2 .priceArea {margin-top:15px;margin-bottom:10px;  height:50px; }
	#goods_wrap .gArea2 .priceInArea {}
	#goods {width:100%; background:#eeeeee;; overflow: hidden; }

	#goods_wrap .gArea2 .sellPrice {float: left; font-size:13px; color:#242424; line-height:10px; letter-spacing:-1px;}

	#goods_wrap .gArea2 .textArea .sale {color: #f36465; font-size: 10px; float: right; margin-top: 25px; padding: 0 5px;	 position: absolute; bottom: 5px; right: 10px;}
	#goods_wrap .gArea2 .textArea .sale span {font-size: 22px; font-weight: 600;}

	#goods_wrap .textArea .gTable {margin-top:4px;}
	#goods_wrap .textArea .gTable td {padding:0px 0px;}


</style>
</head>
<body>
<!--#include virtual = "/m/_include/header_shop.asp"-->
<div id="shopIndex">
	<!-- 모바일 Swipe배너 S -->
		<div class="clear shop swiper-container" style=" display:block;">
			<div class="swiper-wrapper">
				<%
					arrParams = Array(_
						Db.makeParam("@TOPCNT",adInteger,adParamInput,4,4), _
						Db.makeParam("@strArea",adVarChar,adParamInput,20,"ms1_a01"), _
						Db.makeParam("@strNationCode",adVarChar,adParamInput,6,UCase(DK_MEMBER_NATIONCODE)) _
					)
					arrList = Db.execRsList("DKSP_SHOP_DESIGN_BANNERS_LIST_TOP",DB_PROC,arrParams,listLen,Nothing)
					If IsArray(arrList) Then
						totalRowCnt = listLen + 1
						For i = 0 To listLen
							arrList_intIDX          = arrList(0,i)
							arrList_strArea         = arrList(1,i)
							arrList_intSort         = arrList(2,i)
							arrList_isUse           = arrList(3,i)
							arrList_isDel           = arrList(4,i)
							arrList_strTitle        = arrList(5,i)
							arrList_isLink          = arrList(6,i)
							arrList_isLinkTarget    = arrList(7,i)
							arrList_strLink         = BACKWORD(arrList(8,i))
							arrList_strImg          = BACKWORD(arrList(9,i))
							arrList_regDate         = arrList(10,i)
							arrList_regID           = arrList(11,i)
							arrList_regIP			= arrList(12,i)

							Select Case arrList_isLinkTarget
								Case "S" : targets = "target=""_self"""
								Case "B" : targets = "target=""_blank"""
							End Select
							If arrList_isLink = "T" Then
								linkF = "<a href="""&arrList_strLink&""" "&targets&" class=""btn01"">"
								linkL = "</a>"
							Else
								linkF = ""
								linkL = ""
							End If
				%>
				<div class="swiper-slide"><%=linkF%><img src="<%=VIR_PATH("shop_design_Banner_T")%>/<%=arrList_strImg%>" class="width100" alt="" /><%=linkL%></div>
				<%
						Next
					End If
				%>
			</div>
		<!-- <div class="swiper-wrapper">
				<div class="swiper-slide">
					<img src="<%=M_IMG_SHOP%>/shop_visual01.jpg" alt="" />
				</div>
				<div class="swiper-slide">
					<img src="<%=M_IMG_SHOP%>/shop_visual01.jpg" alt="" />
				</div>
				<div class="swiper-slide">
					<img src="<%=M_IMG_SHOP%>/shop_visual01.jpg" alt="" />
				</div>
				<div class="swiper-slide">
					<img src="<%=M_IMG_SHOP%>/shop_visual01.jpg" alt="" />
				</div>
			</div> -->

			<div class="swiper-pagination swiper-pagination-black"></div>
			<script>
				var swiper = new Swiper('.shop.swiper-container', {
					pagination: '.swiper-pagination',
					effect: 'fade', /*넘김효과*/
					paginationClickable: true,
					centeredSlides: true,
					autoplay: 2500,
					spaceBetween: 0,
					autoplayDisableOnInteraction: false,
					loop: true,
				});
			</script>
		</div>

	<!-- index 베스트상품 S -->
	<div id="chgIndexContent">

		<div id="goods_wrap" class="index_best">
			<div class="inner">
				<div class="tit">BEST PRODUCT</div>
				<div class="tab">
					<ul>
						<%
							SQL_H2 = "SELECT [intCateSort] FROM [DK_SHOP_CATEGORY]"
							SQL_H2 = SQL_H2 & " WHERE [intCateDepth] = 1 AND [isView] = 'T' AND [strCateCode] = ? AND [strNationCode] = ? ORDER BY [intCateSort] ASC"
							arrParams_H2 = Array(_
								Db.makeParam("@CATEGORY",adVarChar,adParamInput,3,Left(CATEGORY,3)), _
								Db.makeParam("@strNationCode",adVarChar,adParamInput,6,UCase(DK_MEMBER_NATIONCODE)) _
							)
							Set HJRS = Db.execRs(SQL_H2,DB_TEXT,arrParams_H2,nothing)
							If Not HJRS.BOF And Not HJRS.EOF Then
								HJRS_intCateSort = HJRS(0)
							Else
								HJRS_intCateSort = 0
							End If
							Call CloseRS(HJRS)
						%>
						<%
							arrParams_H1 = Array(_
								Db.makeParam("@strNationCode",adVarChar,adParamInput,6,UCase(DK_MEMBER_NATIONCODE)) _
							)
							arrList_H1 = Db.execRsList("DKSP_SHOP_CATEGORY_1DEPTH",DB_PROC,arrParams_H1,listLen_H1,Nothing)
							If IsArray(arrList_H1) Then
								For H1 = 0 To listLen_H1
									arrList_H1_strCateCode		= arrList_H1(1,H1)
									arrList_H1_strCateNameKor	= arrList_H1(2,H1)

									If HJRS_intCateSort = H1+1 Then
										CATE_BG_CSS = " on"
										CATE_COL_CSS = " color: #ffffff"
									Else
										CATE_BG_CSS = ""
										CATE_COL_CSS = ""
									End If
						%>
						<li class=" <%=CATE_BG_CSS%>"><p><a href="javascript: chgGoodsIndex('<%=arrList_H1_strCateCode%>')" style="<%=CATE_COL_CSS%>"><%=arrList_H1_strCateNameKor%><i></i></p></a></li>
						<%
								Next
							End If
						%>
					</ul>
				</div>
				<%
					arrParams1 = Array(_
						Db.makeParam("@TOPCNT",adInteger,adParamInput,4,PCONF_TOPCNT ), _
						Db.makeParam("@tSEARCHSTR",adVarWChar,adParamInput,30,tSEARCHSTR), _
						Db.makeParam("@tSEARCHTERM",adVarChar,adParamInput,30,tSEARCHTERM), _
						Db.makeParam("@GoodsPrice1",adInteger,adParamInput,50,minPrice), _
						Db.makeParam("@GoodsPrice2",adInteger,adParamInput,50,maxPrice), _

						Db.makeParam("@isBest",adChar,adParamInput,1,"T"), _
						Db.makeParam("@isVote",adChar,adParamInput,1,"F"), _
						Db.makeParam("@isNew",adChar,adParamInput,1,"F"), _

						Db.makeParam("@isNOTS",adChar,adParamInput,1,PCONF_isNOTS), _
						Db.makeParam("@isAUTH",adChar,adParamInput,1,PCONF_isAUTH), _
						Db.makeParam("@isDEAL",adChar,adParamInput,1,PCONF_isDEAL), _
						Db.makeParam("@isVIPS",adChar,adParamInput,1,PCONF_isVIPS), _
						Db.makeParam("@isALLS",adChar,adParamInput,1,PCONF_isALLS), _

						Db.makeParam("@CATEGORY",adVarChar,adParamInput,20,CATEGORY), _
						Db.makeParam("@strNationCode",adVarChar,adParamInput,6,UCase(DK_MEMBER_NATIONCODE)) _
					)
					arrList1 = Db.execRsList("DKSP_CATEGORY_GOODS_SEARCH_TOTAL_BVN",DB_PROC,arrParams1,listLen1,Nothing)
					If IsArray(arrList1) Then
						For x = 0 To listLen1
							arrList1_intIDX				= arrList1(0,x)
							arrList1_GoodsName			= BACKWORD(arrList1(1,x))
							arrList1_GoodsComment		= BACKWORD(arrList1(2,x))
							arrList1_GoodsPrice			= arrList1(3,x)
							arrList1_GoodsCustomer		= arrList1(4,x)
							arrList1_GoodsCost			= arrList1(5,x)
							arrList1_GoodsModels		= arrList1(6,x)
							arrList1_GoodsBrand			= arrList1(7,x)
							arrList1_GoodsMaterial		= arrList1(8,x)
							arrList1_imgList			= BACKWORD(arrList1(9,x))
							arrList1_isCSGoods			= arrList1(10,x)
							arrList1_CSGoodsCode		= arrList1(11,x)
							arrList1_GoodsStockType		= arrList1(12,x)
							arrList1_GoodsPoint			= arrList1(13,x)
							arrList1_intPriceNot		= arrList1(14,x)
							arrList1_intPriceAuth		= arrList1(15,x)
							arrList1_intPriceDeal		= arrList1(16,x)
							arrList1_intPriceVIP		= arrList1(17,x)
							arrList1_intMinNot			= arrList1(18,x)
							arrList1_intMinAuth			= arrList1(19,x)
							arrList1_intMinDeal			= arrList1(20,x)
							arrList1_intMinVIP			= arrList1(21,x)
							arrList1_intPointNot		= arrList1(22,x)
							arrList1_intPointAuth		= arrList1(23,x)
							arrList1_intPointDeal		= arrList1(24,x)
							arrList1_intPointVIP		= arrList1(25,x)
							arrList1_isImgType			= arrList1(26,x)
							arrList1_OptionVal			= arrList1(27,x)
							arrList1_isShopType			= arrList1(28,x)
							arrList1_strShopID			= arrList1(29,x)
							arrList1_intCSPrice4		= arrList1(30,x)
							arrList1_intCSPrice5		= arrList1(31,x)
							arrList1_intCSPrice6		= arrList1(32,x)
							arrList1_intCSPrice7		= arrList1(33,x)
							arrList1_flagBest			= arrList1(34,x)
							arrList1_flagNew			= arrList1(35,x)
							arrList1_flagVote			= arrList1(36,x)

							notPrice = arrList1_intPriceNot

							Select Case DK_MEMBER_LEVEL
								Case 0,1 '비회원, 일반회원
									arrList1_GoodsPrice = arrList1_intPriceNot
									arrList1_GoodsPoint = arrList1_intPointNot
								Case 2 '인증회원
									arrList1_GoodsPrice = arrList1_intPriceAuth
									arrList1_GoodsPoint = arrList1_intPointAuth
								Case 3 '딜러회원
									arrList1_GoodsPrice = arrList1_intPriceDeal
									arrList1_GoodsPoint = arrList1_intPointDeal
								Case 4,5 'VIP 회원
									arrList1_GoodsPrice = arrList1_intPriceVIP
									arrList1_GoodsPoint = arrList1_intPointVIP
								Case 9,10,11
									arrList1_GoodsPrice = arrList1_intPriceVIP
									arrList1_GoodsPoint = arrList1_intPointVIP
							End Select


							If (x + 1) Mod 2 = 0 Then
								classNames = "index_v_goods2"
							Else
								classNames = "index_v_goods"
							End If
							'PRINT arrList1_isCSGoods
							'PRINT arrList1_CSGoodsCode


							If arrList1_isCSGoods = "T" Then
								'▣CS상품정보 변동정보 통합
								arrParams = Array(_
									Db.makeParam("@ncode",adVarChar,adParamInput,20,arrList1_CSGoodsCode) _
								)
								Set DKRS = Db.execRs("HJP_CSGOODS_PRICE_INFO",DB_PROC,arrParams,DB3)
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

							' URL 이미지 링크
							If arrList1_isImgType = "S" Then
								imgPath = VIR_PATH("goods/list")&"/"&arrList1_imgList
								imgWidth = 0
								imgHeight = 0
								Call ImgInfo(imgPath,imgWidth,imgHeight,"")

								'▣가로세로 비율고정 반응형 DIV 박스
								BOX_RATIO_H = 100		'이미지 Div박스 가로세로 높이비율 (100 : BOX_RATIO_H) 	padding-bottom:(70~100)
								IMG_RATIO   = 90		'박스내 이미지 비율

								If imgPath <> "" And imgHeight > 0 And imgWidth > 0 Then
									If imgHeight > imgWidth Then

										IMG_RATIO_W = IMG_RATIO * (imgWidth / imgHeight)
										imgWidth	= IMG_RATIO_W
										TOP_RATIO	= (100 - (IMG_RATIO   / (BOX_RATIO_H / 100))) / 2

									ElseIf imgHeight < imgWidth Then

										IMG_RATIO_W = IMG_RATIO * (imgHeight / imgWidth)
										imgWidth	= IMG_RATIO
										TOP_RATIO	= (100 - (IMG_RATIO_W / (BOX_RATIO_H / 100))) / 2

									ElseIf imgHeight = imgWidth Then

										IMG_RATIO_W = IMG_RATIO * (imgHeight / imgWidth)
										imgWidth	= IMG_RATIO
										TOP_RATIO	= (100 - (IMG_RATIO_W / (BOX_RATIO_H / 100))) / 2
									End if
								End If

								goodsImg = "<img src="""&imgPath&""" width="""&imgWidth&"%"" alt="""" />"

							Else
								goodsImg = "<img src="""&backword(arrList1_imgList)&""" width="""&upImgWidths_List&""" height="""&upImgHeight_List&""" alt="""" />"
								imgPaddingW = 15
								imgPaddingH = 15
							End If
				%>
				<div class="gArea <%=classNames%>" id="gid<%=i+1%>">
					<%'▣가로세로 비율고정 반응형 DIV 박스%>
					<a href="/m/shop/detailView.asp?gidx=<%=arrList_intIDX%>" id="link">
						<div class="img" style="padding-bottom:<%=BOX_RATIO_H%>%;" >
							<div class="tcenter" style="position:absolute; width:100%; height:100%;left:0;top:<%=TOP_RATIO%>%;">
								<%If DK_MEMBER_LEVEL > 0 Then%>
									<a href="detailView.asp?gidx=<%=arrList1_intIDX%>"><%=goodsImg%></a>
								<%Else%>
									<a href="javascript:check_frm();"><%=goodsImg%></a>
								<%End If%>
							</div>
						</div>
					</a>
					<div class="textArea" >
						<%'If DK_MEMBER_LEVEL > 0 Then%>
						<%
							If notPrice < arrList1_GoodsCustomer Then
								DisCountPercent = 100 - Round((notPrice/arrList1_GoodsCustomer) * 100)
						%>
						<!-- <div class="sale">
							<span><%=DisCountPercent%></span>%
						</div> -->
						<%	End If %>
						<%'End If %>
						<%If arrList1_GoodsComment <> "" Then %>
						<div class="text_noline comment"><%=arrList1_GoodsComment%></div>
						<%End If %>
						<div class="text_noline goodsName"><%=arrList1_goodsName%><br></div>
						<div style="padding-bottom:20px;">
							<table <%=tableatt%> class="width100 gTable" style="width:95%;">
								<col width="" />
								<col width="" />
								<%
									If DK_MEMBER_LEVEL > 0 Then		'삭제요청

										PRINT "<tr>"
										'PRINT "		<td class=""price fleft mline""><span>"&num2cur(arrList1_GoodsCustomer)&"</span>"&Chg_CurrencyISO&"</td>"
										'PRINT "		<td class=""th""></td>"
										'PRINT "</tr><tr>"
										PRINT "		<td class=""price2""><span>"&num2cur(notPrice)&"</span>"&Chg_CurrencyISO&"</td>"
										PRINT "		<td class=""th""></td>"
										PRINT "</tr>"

									'	If DK_MEMBER_STYPE = "0" Then
									'	PRINT "<tr>"
									'	PRINT "		<td class=""PV fright""><span>"&num2cur(RS_price4)&"</span>"&CS_PV&"</td>"
									'	PRINT "		<td class=""th""></td>"
									'	PRINT "</tr>"
									'	End If

									End If
								%>
							</table>
						</div>
					</div>
				</div>
				<%
						Next
				%>
				<!-- <div class="width100 clear" style="padding-top:20px;">
					<div class="more" style="margin:10px 10px;">
						<a href="/m/shop/category.asp?cm=ba&cate=<%=CATEGORY%>" align="center"><p><%=LNG_SHOP_COMMON_MORE%></p></a>
						<i></i>
					</div>
				</div> -->
				<%
					Else
				%>
				<div class="tcenter" style="background-color:#fff; padding:120px 0px;font-size:16px; line-height:25px;"><%=LNG_SHOP_NOT_DATA_TXT_01%></div>
				<%
					End If
				%>
			</div>
		</div>

	</div>
	<!-- index 베스트상품 E -->

	<div id="index_bn">
		<div class="bn">
			<a href="#">
				<img src="<%=M_IMG_SHOP%>/index_bn01.jpg" alt="" />
			</a>
		</div>
		<div class="in">
			<div class="bn bn01">
				<a href="#">
					<img src="<%=M_IMG_SHOP%>/index_bn02.jpg" alt="" />
				</a>
			</div>
			<div class="bn bn02">
				<a href="#">
					<img src="<%=M_IMG_SHOP%>/index_bn03.jpg" alt="" />
				</a>
			</div>
		</div>
	</div>


	<%'NEW PRODUCT S%>
	<div id="goods_wrap" class="index_best">
		<div class="inner">
			<div class="tit">NEW PRODUCT</div>
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

					Db.makeParam("@CATEGORY",adVarChar,adParamInput,20,""), _
					Db.makeParam("@strNationCode",adVarChar,adParamInput,6,UCase(DK_MEMBER_NATIONCODE)) _
				)
				arrList2 = Db.execRsList("DKSP_CATEGORY_GOODS_SEARCH_TOTAL_BVN",DB_PROC,arrParams2,listLen2,Nothing)
				If IsArray(arrList2) Then
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
						arrList2_GoodsPoint			= arrList2(13,z)		'조합원적립금
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

						If (z + 1) Mod 2 = 0 Then
							classNames = "index_v_goods2"
						Else
							classNames = "index_v_goods"
						End If
						'PRINT arrList1_isCSGoods
						'PRINT arrList1_CSGoodsCode


						If arrList1_isCSGoods = "T" Then
							'▣CS상품정보 변동정보 통합
							arrParams = Array(_
								Db.makeParam("@ncode",adVarChar,adParamInput,20,arrList2_CSGoodsCode) _
							)
							Set DKRS = Db.execRs("HJP_CSGOODS_PRICE_INFO",DB_PROC,arrParams,DB3)
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

						' URL 이미지 링크
						If arrList2_isImgType = "S" Then
							imgPath = VIR_PATH("goods/list")&"/"&arrList2_imgList
							imgWidth = 0
							imgHeight = 0
							Call ImgInfo(imgPath,imgWidth,imgHeight,"")

							'▣가로세로 비율고정 반응형 DIV 박스
							BOX_RATIO_H = 100		'이미지 Div박스 가로세로 높이비율 (100 : BOX_RATIO_H) 	padding-bottom:(70~100)
							IMG_RATIO   = 90		'박스내 이미지 비율

							If imgPath <> "" And imgHeight > 0 And imgWidth > 0 Then
								If imgHeight > imgWidth Then

									IMG_RATIO_W = IMG_RATIO * (imgWidth / imgHeight)
									imgWidth	= IMG_RATIO_W
									TOP_RATIO	= (100 - (IMG_RATIO   / (BOX_RATIO_H / 100))) / 2

								ElseIf imgHeight < imgWidth Then

									IMG_RATIO_W = IMG_RATIO * (imgHeight / imgWidth)
									imgWidth	= IMG_RATIO
									TOP_RATIO	= (100 - (IMG_RATIO_W / (BOX_RATIO_H / 100))) / 2

								ElseIf imgHeight = imgWidth Then

									IMG_RATIO_W = IMG_RATIO * (imgHeight / imgWidth)
									imgWidth	= IMG_RATIO
									TOP_RATIO	= (100 - (IMG_RATIO_W / (BOX_RATIO_H / 100))) / 2
								End if
							End If

							goodsImg = "<img src="""&imgPath&""" width="""&imgWidth&"%"" alt="""" />"

						Else
							goodsImg = "<img src="""&backword(arrList2_imgList)&""" width="""&upImgWidths_List&""" height="""&upImgHeight_List&""" alt="""" />"
							imgPaddingW = 15
							imgPaddingH = 15
						End If
			%>
			<div class="gArea2 <%=classNames%>" id="gid<%=i+1%>">
				<%'▣가로세로 비율고정 반응형 DIV 박스%>
				<a href="/m/shop/detailView.asp?gidx=<%=arrList_intIDX%>" id="link">
					<div class="img" style="padding-bottom:<%=BOX_RATIO_H%>%;" >
						<div class="tcenter" style="position:absolute; width:100%; height:100%;left:0;top:<%=TOP_RATIO%>%;">
							<%If DK_MEMBER_LEVEL > 0 Then%>
								<a href="detailView.asp?gidx=<%=arrList2_intIDX%>"><%=goodsImg%></a>
							<%Else%>
								<a href="javascript:check_frm();"><%=goodsImg%></a>
							<%End If%>
						</div>
					</div>
				</a>
				<div class="textArea" >
					<%'If DK_MEMBER_LEVEL > 0 Then%>
					<%
						If notPrice < arrList2_GoodsCustomer Then
							DisCountPercent = 100 - Round((notPrice/arrList2_GoodsCustomer) * 100)
					%>
					<!-- <div class="sale">
						<span><%=DisCountPercent%></span>%
					</div> -->
					<%	End If %>
					<%'End If %>
					<%If arrList2_GoodsComment <> "" Then %>
					<div class="text_noline comment"><%=arrList2_GoodsComment%></div>
					<%End If %>
					<div class="text_noline goodsName"><%=arrList2_goodsName%><br></div>
					<div style="padding-bottom:20px;">
						<table <%=tableatt%> class="width100 gTable" style="width:95%;">
							<col width="" />
							<col width="" />
							<%
								If DK_MEMBER_LEVEL > 0 Then		'삭제요청

									PRINT "<tr>"
									'PRINT "		<td class=""price fleft mline""><span>"&num2cur(arrList2_GoodsCustomer)&"</span>"&Chg_CurrencyISO&"</td>"
									'PRINT "		<td class=""th""></td>"
									'PRINT "</tr><tr>"
									PRINT "		<td class=""price2 fleft""><span>"&num2cur(notPrice)&"</span>"&Chg_CurrencyISO&"</td>"
									PRINT "		<td class=""th""></td>"
									PRINT "</tr>"

								'	If DK_MEMBER_STYPE = "0" Then
								'	PRINT "<tr>"
								'	PRINT "		<td class=""PV fright""><span>"&num2cur(RS_price4)&"</span>"&CS_PV&"</td>"
								'	PRINT "		<td class=""th""></td>"
								'	PRINT "</tr>"
								'	End If

								End If
							%>
						</table>
					</div>
				</div>
			</div>
			<%
					Next
			%>
			<!-- <div class="width100 clear" style="padding-top:20px;">
				<div class="more" style="margin:10px 10px;">
					<a href="/m/shop/category.asp?cm=na&cate=<%=CATEGORY%>" align="center"><p><%=LNG_SHOP_COMMON_MORE%></p></a>
					<i></i>
				</div>
			</div> -->
			<%
				Else
			%>
			<div class="tcenter" style="background-color:#fff; padding:120px 0px;font-size:16px; line-height:25px;"><%=LNG_SHOP_NOT_DATA_TXT_01%></div>
			<%
				End If
			%>
		</div>
	</div>
	<%'NEW PRODUCT E%>

	<div id="shop_bn">
		<em></em>
		<div class="bg">
			<i></i>
			<span></span>
		</div>
		<div class="txt">
			<div><%=LNG_SHOP_BN_01%></div>
			<p class="p01"><%=LNG_SHOP_BN_02%></p>
			<p class="p02"><%=LNG_SHOP_BN_03%></p>
		</div>
	</div>

	<form name="frm" method="post" action="">
		<input type="hidden" name="PAGESIZE" value="<%=PAGESIZE%>" />
		<input type="hidden" name="PAGE" value="<%=PAGE%>" />
	</form>
</div>
<!--#include virtual = "/m/_include/copyright.asp"-->