<!--#include virtual = "/_lib/strFunc.asp"-->
<% 'On Error Resume Next

Response.Redirect "/shop/category.asp"

	PAGE_SETTING = "SHOP"
	ISLEFT = "F"
	ISCATEGORY = "T"
	ISSUBVISUAL = "T"

	IS_SHOPLIST = "T"		'header_shop.asp 체크
	'CATEGORY		= gRequestTF("cate",False)

	Page			= Request("Page")
	Pagesize		= 16
	Dim tSEARCHTERM		:	tSEARCHTERM = pRequestTF("tSEARCHTERM",False)
	Dim tSEARCHSTR		:	tSEARCHSTR = pRequestTF("tSEARCHSTR",False)
	Dim minPrice		:	minPrice = pRequestTF("minPrice",False)
	Dim maxPrice		:	maxPrice = pRequestTF("maxPrice",False)

	If tSEARCHTERM = ""	Then tSEARCHTERM = "" End If
	If tSEARCHSTR = ""	Then tSEARCHSTR = "" End if
	If minPrice = "" Then minPrice = ""
	If maxPrice = "" Then maxPrice = ""

	If PAGE = ""		Then PAGE = 1 End If

	If CATEGORY = "" Then CATEGORY = ""


	PCONF_TOPCNT = 2 '페이지 사이즈에 맞춘 상품 나열 갯수 하단의 PCONF_LINECNT 의 제곱으로 나가야함
	PCONF_LINECNT = 4 '페이지 사이즈에 맞춘 상품 나열 갯수 (베스트, 추천, 새상품)

	' 총 WIDTH 값에서 상품갯수에 맞춰 LEFT-MARGIN 값 설정
	' 상품 넓이는 border 를 포함하여 2를 더해준다
	GoodsLeftMargin = Int((1200 - (290*PCONF_LINECNT)) / (PCONF_LINECNT-1))		'1200 - (35 * 2)

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

%>
<!--#include virtual = "/_include/document.asp"-->
<script type="text/javascript">

	//index BEST AJAX
	function chgGoodsIndex(cate) {
		$.ajax({
			type: "POST"
			,url: "/ajax/chgGoodsIndex.asp"
			,data : {
				"cate"  : cate
			}
			,success: function(data) {
				document.getElementById("chgIndexContent").innerHTML = data;
			}
			,error:function(data) {
				alert("ajax 처리 중 에러가 발생하였습니다.ERROR CODE : "+data.status+" "+data.statusText+" "+data.responseText);
			}
		});
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
<!--#include virtual = "/_include/header.asp"-->
<script type="text/javascript" src="/jscript/jquery.mainVisual_02.js"></script>
<style type="text/css">
	#bottom_shop {margin-top: -70px;}
</style>
</head>
<body>

<div id="shopVisual_Wrap" class="layout_wrap">
	<div id="shopVisual" class="layout_inner">
		<div id="shopVisual_a" class="shopVisual_a">
			<ul class="visual_img">
				<%
'					arrParams = Array(_
'						Db.makeParam("@TOPCNT",adInteger,adParamInput,4,3), _
'						Db.makeParam("@strArea",adVarChar,adParamInput,20,"n02_a01"), _
'						Db.makeParam("@strNationCode",adVarChar,adParamInput,6,UCase(DK_MEMBER_NATIONCODE)) _
'					)

					arrParams = Array(_
						Db.makeParam("@TOPCNT",adInteger,adParamInput,4,3), _
						Db.makeParam("@strArea",adVarChar,adParamInput,20,"s01_a01"), _
						Db.makeParam("@strNationCode",adVarChar,adParamInput,6,UCase(Lang)) _
					)
					arrList = Db.execRsList("DKSP_SHOP_DESIGN_BANNERS_LIST_TOP",DB_PROC,arrParams,listLen,Nothing)

					If IsArray(arrList) Then

						ImgHtml = ""
						TabHtml = ""

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


							ImgHtml = ImgHtml & "<li>"&linkF&"<img src="""&VIR_PATH("shop_design_Banner_T")&"/"&arrList_strImg&""" alt="""" />"&linkL&"</li>"
							TabHtml = TabHtml & "<td>"&arrList_strTitle&"</td>"
						Next
					End If
				%>
				<%=ImgHtml%>
			</ul>

			<div class="menu layout_inner">
				<table id="visual_menu">
					<tr class="visual_menu">
						<%=TabHtml%>
					</tr>
				</table>

				<span class="visual_dir visual_prev"><img src="/images/shop/shop_visual_prev.jpg" alt="" /></span>
				<span class="visual_dir visual_next"><img src="/images/shop/shop_visual_next.jpg" alt="" /></span>
			</div>

			<script type="text/javascript">
				$('#shopVisual_a').DB_tabArrowSlideMove({
					motionType:'x',			//모션타입('none','x','y','fade')
					motionSpeed:300,
					autoRollingTime:5000,	//자동롤링속도(밀리초)
					menuVisible:true		//메뉴보이기(true,false)
				})
			</script>
		</div>
	</div>
</div><!--mainVisual_Wrap E-->

<div id="shopIndex" class="layout_inner">
	<div class="shop_bn">
		<div class="bn01">
			<%
				arrParams = Array(_
					Db.makeParam("@TOPCNT",adInteger,adParamInput,4,1), _
					Db.makeParam("@strArea",adVarChar,adParamInput,20,"s02_a01"), _
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
							linkF = "<a href="""&arrList_strLink&""" "&targets&">"
							linkL = "</a>"
						Else
							linkF = ""
							linkL = ""
						End If
			%>
			<%=linkF%><img src="<%=VIR_PATH("shop_design_Banner_T")%>/<%=arrList_strImg%>" alt="" /><%=linkL%>
			<%
					Next
				End If
			%>
		</div>
		<div class="bn02">
			<%
				arrParams = Array(_
					Db.makeParam("@TOPCNT",adInteger,adParamInput,4,1), _
					Db.makeParam("@strArea",adVarChar,adParamInput,20,"s02_a02"), _
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
							linkF = "<a href="""&arrList_strLink&""" "&targets&">"
							linkL = "</a>"
						Else
							linkF = ""
							linkL = ""
						End If
			%>
			<%=linkF%><img src="<%=VIR_PATH("shop_design_Banner_T")%>/<%=arrList_strImg%>" alt="" /><%=linkL%>
			<%
					Next
				End If
			%>

		</div>
		<div class="bn03">
			<%
				arrParams = Array(_
					Db.makeParam("@TOPCNT",adInteger,adParamInput,4,1), _
					Db.makeParam("@strArea",adVarChar,adParamInput,20,"s02_a03"), _
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
							linkF = "<a href="""&arrList_strLink&""" "&targets&">"
							linkL = "</a>"
						Else
							linkF = ""
							linkL = ""
						End If
			%>
			<%=linkF%><img src="<%=VIR_PATH("shop_design_Banner_T")%>/<%=arrList_strImg%>" alt="" /><%=linkL%>
			<%
					Next
				End If
			%></div>
		<div class="bn04">
			<%
				arrParams = Array(_
					Db.makeParam("@TOPCNT",adInteger,adParamInput,4,1), _
					Db.makeParam("@strArea",adVarChar,adParamInput,20,"s02_a04"), _
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
							linkF = "<a href="""&arrList_strLink&""" "&targets&">"
							linkL = "</a>"
						Else
							linkF = ""
							linkL = ""
						End If
			%>
			<%=linkF%><img src="<%=VIR_PATH("shop_design_Banner_T")%>/<%=arrList_strImg%>" alt="" /><%=linkL%>
			<%
					Next
				End If
			%>
		</div>


	</div>
	<div id="goods_wrap">
		<p class="tit"><%=LNG_SHOP_COMMON_TXT_09%></p>
		<p class="stit">SEANOL BEST ITEMS</p>
		<div class="inner">
			<%
				arrParams = Array(_
					Db.makeParam("@TOPCNT",adInteger,adParamInput,0,8),_
					Db.makeParam("@SEARCHSTR",adVarChar,adParamInput,30,""), _
					Db.makeParam("@SEARCHTERM",adVarChar,adParamInput,30,""), _

					Db.makeParam("@GoodsPrice1",adInteger,adParamInput,0,0), _
					Db.makeParam("@GoodsPrice2",adInteger,adParamInput,0,0), _

					Db.makeParam("@isBest",adChar,adParamInput,1,"T"), _
					Db.makeParam("@isVote",adChar,adParamInput,1,"F"), _
					Db.makeParam("@isNew",adChar,adParamInput,1,"F"), _

					Db.makeParam("@isNOTS",adChar,adParamInput,1,PCONF_isNOTS), _
					Db.makeParam("@isAUTH",adChar,adParamInput,1,PCONF_isAUTH), _
					Db.makeParam("@isDEAL",adChar,adParamInput,1,PCONF_isDEAL), _
					Db.makeParam("@isVIPS",adChar,adParamInput,1,PCONF_isVIPS), _
					Db.makeParam("@isALLS",adChar,adParamInput,1,PCONF_isALLS), _

					Db.makeParam("@CATEGORY",adVarChar,adParamInput,21,CATEGORY), _
					Db.makeParam("@strNationCode",adVarChar,adParamInput,6,UCase(DK_MEMBER_NATIONCODE)) _
				)

				arrList = Db.execRsList("DKSP_CATEGORY_GOODS_SEARCH_TOTAL_BVN",DB_PROC,arrParams,listLen,Nothing)

				If IsArray(arrList) Then
					For i = 0 To listLen
						arrList_intIDX				= arrList(0,i)
						arrList_GoodsName			= BACKWORD(arrList(1,i))
						arrList_GoodsComment		= BACKWORD(arrList(2,i))
						arrList_GoodsPrice			= arrList(3,i)
						arrList_GoodsCustomer		= arrList(4,i)
						arrList_GoodsCost			= arrList(5,i)
						arrList_GoodsModels			= arrList(6,i)
						arrList_GoodsBrand			= arrList(7,i)
						arrList_GoodsMaterial		= arrList(8,i)
						arrList_imgList				= BACKWORD(arrList(9,i))
						arrList_isCSGoods			= arrList(10,i)
						arrList_CSGoodsCode			= arrList(11,i)
						arrList_GoodsStockType		= arrList(12,i)
						arrList_GoodsPoint			= arrList(13,i)
						arrList_intPriceNot			= arrList(14,i)
						arrList_intPriceAuth		= arrList(15,i)
						arrList_intPriceDeal		= arrList(16,i)
						arrList_intPriceVIP			= arrList(17,i)
						arrList_intMinNot			= arrList(18,i)
						arrList_intMinAuth			= arrList(19,i)
						arrList_intMinDeal			= arrList(20,i)
						arrList_intMinVIP			= arrList(21,i)
						arrList_intPointNot			= arrList(22,i)
						arrList_intPointAuth		= arrList(23,i)
						arrList_intPointDeal		= arrList(24,i)
						arrList_intPointVIP			= arrList(25,i)
						arrList_isImgType			= arrList(26,i)
						arrList_OptionVal			= arrList(27,i)
						arrList_isShopType			= arrList(28,i)
						arrList_strShopID			= arrList(29,i)
						arrList_intCSPrice4			= arrList(30,i)
						arrList_intCSPrice5			= arrList(31,i)
						arrList_intCSPrice6			= arrList(32,i)
						arrList_intCSPrice7			= arrList(33,i)
						arrList_flagBest			= arrList(34,i)
						arrList_flagNew				= arrList(35,i)
						arrList_flagVote			= arrList(36,i)

						notPrice = arrList_intPriceNot

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

						If arrList_intPriceNot < arrList_GoodsCustomer Then
							DisCountPercent = 100 - Round((arrList_intPriceNot/arrList_GoodsCustomer) * 100)
						Else
							DisCountPercent = 0
						End If

						' URL 이미지 링크
						If arrList_isImgType = "S" Then
							imgPath = VIR_PATH("goods/list")&"/"&arrList_imgList
							newimgWidth = 0
							newimgHeight = 0

							NEW_LENGTH = 250
							Call imgInfoNew(imgPath,newimgWidth,newimgHeight,"",NEW_LENGTH)

							imgPaddingW = (NEW_LENGTH - newimgWidth)/2
							imgPaddingH = (NEW_LENGTH - newimgHeight)/2
							liMarginTop = (250 - newimgHeight) / 2
							goodsImg = "<img src="""&imgPath&""" width="""&newimgWidth&""" height="""&newimgHeight&""" alt="""" style=""margin-top:"&liMarginTop&"px"" />"
						Else
							goodsImg = "<img src="""&backword(arrList_imgList)&""" width="""&upImgWidths_List&""" height="""&upImgHeight_List&""" alt="""" />"
							imgPaddingW = 0
							imgPaddingH = 0
						End If

						If arrList_GoodsStockType	= "S" Then
							'Soldoutflag = viewImg(IMG_INDEX_KR&"/i_soldN.gif",50,11,"")
							Soldoutflag = "<span class=""soldoutTxt"">"&LNG_SHOP_DETAILVIEW_33&"</span>"		'Text 품절
						Else
							Soldoutflag = ""
						End If

						'If DK_MEMBER_STYPE = "0" And arrList_isCSGoods = "T" Then
						'▣CS상품정보 변동정보 통합
						arrParams = Array(_
							Db.makeParam("@ncode",adVarChar,adParamInput,20,arrList_CSGoodsCode) _
						)
						Set DKRS = Db.execRs("HJP_CSGOODS_PRICE_INFO",DB_PROC,arrParams,DB3)
						If Not DKRS.BOF And Not DKRS.EOF Then
							RS_ncode		= DKRS("ncode")
							RS_price		= DKRS("price")
							RS_price2		= DKRS("price2")
							RS_price3		= DKRS("price3")
							RS_price4		= DKRS("price4")
							RS_price5		= DKRS("price5")
							RS_price6		= DKRS("price6")
							RS_SellCode		= DKRS("SellCode")
							RS_SellTypeName	= DKRS("SellTypeName")
						End If
						Call closeRs(DKRS)
						'End If


						'If CONST_CS_SOBIJA_PRICE_USE_TF = "T" Then
						'	If DK_MEMBER_STYPE = "1" Then
						'		DKRS_GoodsPrice = DKRS_GoodsCustomer
						'		RS_price2	    = RS_price
						'	End If
						'End If


						If RS_price3 = "" Then RS_price3 = 0
						If DK_MEMBER_LEVEL > 0 Then
							Select Case DK_MEMBER_STYPE
								Case "0"
									ThisPrice = num2cur(RS_price2)
								Case Else
									ThisPrice = num2cur(RS_price)
							End Select
						Else
							ThisPrice = num2cur(RS_price)
						End If
						If ThisPrice = "" Then ThisPrice = 0

						PRINT "	<div class=""goods"">"
						PRINT "		<a href=""/shop/detailView.asp?gidx="&arrList_intIDX&""">"
						PRINT "			<div class=""img"">"
						PRINT "			<i></i>"
						PRINT "			"&goodsImg
						PRINT "			</div>"
						PRINT " 		<div class=""txt"">"
						'PRINT "				<p>"&arrList_GoodsName&"</p>"
						PRINT "				<p class=""p01"">"&arrList_GoodsName&"</p>"
						PRINT "				<p class=""p02"">"&arrList_GoodsComment&"</p>"
						PRINT "			</div>"
						If DK_MEMBER_LEVEL > 0 Then
						PRINT "			<div class=""price"">"
						PRINT "				<p class=""one mline"">"&num2cur(RS_price)&" "&Chg_CurrencyISO&"</p>"
						PRINT "				<p>"&num2cur(ThisPrice)&" "&Chg_CurrencyISO&"</p>"
						'	If API_VIEW_SYNCO() > 0 Then
						'		syncoPrice = round(ThisPrice / API_VIEW_SYNCO(), 8)
						'	Else
						'		syncoPrice = 0
						'	End If
						'PRINT "				<p>≒ "&syncoPrice&" <span style=""font-size:14px;"">SYNCO<span></p>"
						PRINT "			</div>"
						End If
						PRINT "		</a>"
						PRINT "	</div>"
					Next
				Else
					PRINT "<div class=""wrapNotDataAll"">등록된 베스트 상품이 없습니다</div>"
				End If

				'<div class="goods">
				'	<a href="#">
				'		<div class="img">
				'			<i></i>
				'			<img src="/images/shop/goods02.jpg" alt="" />
				'		</div>
				'		<div class="txt">
				'			<p class="p01">페이셜 트리트먼트 마스크 팩</p>
				'			<p class="p02">바다가 준 선물 씨놀 미백/주름개선/진정보습</p>
				'		</div>
				'		<div class="price">
				'			<p>128,400원</p>
				'		</div>
				'	</a>
				'</div>
			%>
		</div>
	</div>
</div>

<!--#include virtual = "/_include/copyright.asp"-->
