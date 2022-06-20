<!--#include virtual = "/_lib/strFunc.asp"-->
<%

	PAGE_SETTING = "SHOP"



	GoodsIDX = gRequestTF("gIDX",True)


	arrParams = Array(_
		Db.makeParam("@intIDX",adInteger,adParamInput,0,GoodsIDX) _
	)
'	Set DKRS = Db.execRs("DKP_GOODS_DETAILVIEW2",DB_PROC,arrParams,Nothing)
	Set DKRS = Db.execRs("DKP_SHOP_CATEGORY_GOODS_DETAILVIEW",DB_PROC,arrParams,Nothing)
	If Not DKRS.BOF And Not DKRS.EOF Then
		RS_IMG1				= backword(DKRS("Img1Ori"))
		RS_IMG2				= backword(DKRS("Img2Ori"))
		RS_IMG3				= backword(DKRS("Img3Ori"))
		RS_IMG4				= backword(DKRS("Img4Ori"))
		RS_IMG5				= backword(DKRS("Img5Ori"))

		RS_FLAG_BEST		= DKRS("flagBest")
		RS_FLAG_NEW			= DKRS("flagNew")
		RS_FLAG_VOTE		= DKRS("flagVote")

		RS_GOODS_NAME		= DKRS("GoodsName")
		RS_GOODS_COMMENT	= DKRS("GoodsComment")


		RS_COST				= DKRS("GoodsCustomer")
		RS_PRICE			= DKRS("GoodsPrice")
		RS_POINT			= DKRS("GoodsPoint")
		RS_MADE				= DKRS("GoodsMade")
		RS_PRODUCT			= DKRS("GoodsProduct")
		RS_BRAND			= DKRS("GoodsBrand")
		RS_MODEL			= DKRS("GoodsModels")
		RS_DATE				= DKRS("GoodsDate")

		RS_OPTIONVAL		= DKRS("OptionVal")

		RS_GOODSCONTENT		= DKRS("GoodsContent")

		RS_GOODSBANNER		= DKRS("GoodsBanner")
		RS_GoodsStockType	= DKRS("GoodsStockType")
		RS_GoodsStockNum	= DKRS("GoodsStockNum")
		isCSGoods			= DKRS("isCSGoods")
		CSGoodsCode			= DKRS("CSGoodsCode")

		RS_IMG_RELATION		= DKRS("ImgRelation")

		RS_isViewMemberNot	= DKRS("isViewMemberNot")
		RS_isViewMemberAuth	= DKRS("isViewMemberAuth")
		RS_isViewMemberDeal	= DKRS("isViewMemberDeal")
		RS_isViewMemberVIP	= DKRS("isViewMemberVIP")
		RS_intPriceNot		= DKRS("intPriceNot")
		RS_intPriceAuth		= DKRS("intPriceAuth")
		RS_intPriceDeal		= DKRS("intPriceDeal")
		RS_intPriceVIP		= DKRS("intPriceVIP")
		RS_intMinNot		= DKRS("intMinNot")
		RS_intMinAuth		= DKRS("intMinAuth")
		RS_intMinDeal		= DKRS("intMinDeal")
		RS_intMinVIP		= DKRS("intMinVIP")
		RS_intPointNot		= DKRS("intPointNot")
		RS_intPointAuth		= DKRS("intPointAuth")
		RS_intPointDeal		= DKRS("intPointDeal")
		RS_intPointVIP		= DKRS("intPointVIP")


	Else
		Call ALERTS(LNG_SHOP_DETAILVIEW_01,"BACK","")
	End If

	Call closeRs(DKRS)

	If DK_MEMBER_ID1 <> "" And DK_MEMBER_ID2 <> "" Then
		RS_GoodsPrice = RS_intPriceNot
		RS_GoodsPoint = RS_intPointNot
		RS_intMinimum = RS_intMinNot
	End If


	If RS_FLAG_BEST = "T" Then ICON_BEST = viewImg(IMG_ICON&"/i_bestT.gif",31,11,"")
	If RS_FLAG_NEW	= "T" Then ICON_NEW  = viewImg(IMG_ICON&"/i_newT.gif",31,11,"")
	If RS_FLAG_VOTE = "T" Then ICON_VOTE = viewImg(IMG_ICON&"/i_voteT.gif",31,11,"")
	If isCSGoods	= "T" Then FlagCS	 = viewImg(IMG_ICON&"/i_csgoodsT.gif",50,11,"")





%>

<!doctype html>
<html lang="ko">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1.0,minimum-scale=1.0, user-scalable=yes">
<meta http-equiv="Cache-Control" content="no-cache">
<meta http-equiv="Pragma" content="no-cache">
<title><%=DKCONF_SITE_TITLE%></title>
<style>
	body {font-size:12px;color:#606060;}
	a {color:606060; text-decoration:none;}
	.detailViewBack {width:48px; height:48px; background:url(/m/images/zoom.png) 0 0 no-repeat; position:fixed; bottom:40px; right:10px; max-width:48px;}
	.detailViewBack a {display:block; text-align:center;}
	#goodsTitle {font-size:15px; line-height:36px; height:36px; border-top:1px solid #878787; border-bottom:1px solid #878787; background:#6d6d6d; color:#fff;text-align:center;}
</style>
</head>
<body>

<div class="detailViewBack">
	<a href="detailView.asp?gidx=<%=GoodsIDX%>">
		<div style="margin-top:7px;"><img src="<%=M_IMG%>/zoom_back.png" alt="" /></div>
		<div style="margin-top:5px;"><%=LNG_M_BTN_PREVIOUS%></div>
	</a>
</div>
<div id="goodsTitle" class="width100" ><%=RS_GOODS_NAME%></div>
	<div class="width95a">
	<%
		RS_GOODSCONTENT = backword_tag(RS_GOODSCONTENT)
		RS_GOODSCONTENT = Replace(RS_GOODSCONTENT,"<img ","<img width=""100%""")
		RS_GOODSCONTENT = Replace(RS_GOODSCONTENT,"<IMG ","<IMG width=""100%""")
		RS_GOODSCONTENT = RegExpReplace2("(width=(?:|'|""))((^[0-9]))((?:|'|""))",RS_GOODSCONTENT,"width=""100%""")
		PRINT RS_GOODSCONTENT

	%>
	</div>

</body>
</html>