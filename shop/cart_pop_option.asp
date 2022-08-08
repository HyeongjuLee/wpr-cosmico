<!--#include virtual = "/_lib/strFunc.asp"-->
<!--#include virtual = "/_include/document.asp"-->

<%
	Call FN_NationCurrency(DK_MEMBER_NATIONCODE,Chg_CurrencyName,Chg_CurrencyISO)

	'jQuery Modal Dialog방식변경
	If Not (checkRef(houUrl &"/shop/cart_pop_option.asp") _
			Or checkRef(houUrl &"/shop/cart.asp")) Then
		Call alerts(LNG_ALERT_WRONG_ACCESS,"close_p_modal","")
	End If

	If DK_MEMBER_LEVEL < 1 Then	Call alerts(LNG_MEMBER_LOGOUT_ALERT01,"p_reload","")	'세션로그아웃시!!

	Call ONLY_MEMBER(DK_MEMBER_LEVEL)

	intIDX = gRequestTF("idx",True)


	arrParams2 = Array(_
		Db.makeParam("@intIDX",adInteger,adParamInput,4,intIDX) _
	)
	Set DKRS2 = Db.execRs("DKP_CART_INFO_ONE",DB_PROC,arrParams2,Nothing)

	If Not DKRS2.BOF And Not DKRS2.EOF Then
		DKRS2_intIDX				= DKRS2("intIDX")
		DKRS2_strDomain				= DKRS2("strDomain")
		DKRS2_strMemID				= DKRS2("strMemID")
		DKRS2_strIDX				= DKRS2("strIDX")
		DKRS2_GoodIDX				= DKRS2("GoodIDX")
		DKRS2_strOption				= DKRS2("strOption")
		DKRS2_orderEa				= DKRS2("orderEa")
		DKRS2_RegistDate			= DKRS2("RegistDate")
		DKRS2_isShopType			= DKRS2("isShopType")
		DKRS2_strShopID				= DKRS2("strShopID")
		DKRS2_GoodsDeliveryType		= DKRS2("GoodsDeliveryType")
		DKRS2_ordersTF				= DKRS2("ordersTF")
		DKRS2_isChgGoods			= DKRS2("isChgGoods")
	Else
		Call ALERTS(LNG_TEXT_NO_DATA,"o_reloada","")
	End If

	Call closeRS(DKRS2)

	arrParams = Array(_
		Db.makeParam("@intIDX",adInteger,adParamInput,4,DKRS2_GoodIDX) _
	)
	Set DKRS = Db.execRs("DKP_GOODS_DETAILVIEW",DB_PROC,arrParams,Nothing)
	If Not DKRS.BOF And Not DKRS.EOF Then
		DKRS_intIDX						= DKRS("intIDX")
		DKRS_Category					= DKRS("Category")
		DKRS_DelTF						= DKRS("DelTF")
		DKRS_GoodsType					= DKRS("GoodsType")
		DKRS_GoodsName					= DKRS("GoodsName")
		DKRS_GoodsComment				= DKRS("GoodsComment")
		DKRS_GoodsSearch				= DKRS("GoodsSearch")
		DKRS_GoodsPrice					= DKRS("GoodsPrice")
		DKRS_GoodsCustomer				= DKRS("GoodsCustomer")
		DKRS_GoodsCost					= DKRS("GoodsCost")
		DKRS_GoodsStockType				= DKRS("GoodsStockType")
		DKRS_GoodsStockNum				= DKRS("GoodsStockNum")
		DKRS_GoodsPoint					= DKRS("GoodsPoint")
		DKRS_GoodsMade					= DKRS("GoodsMade")
		DKRS_GoodsProduct				= DKRS("GoodsProduct")
		DKRS_GoodsBrand					= DKRS("GoodsBrand")
		DKRS_GoodsModels				= DKRS("GoodsModels")
		DKRS_GoodsDate					= DKRS("GoodsDate")
		DKRS_GoodsViewTF				= DKRS("GoodsViewTF")
		DKRS_flagBest					= DKRS("flagBest")
		DKRS_flagNew					= DKRS("flagNew")
		DKRS_FlagVote					= DKRS("FlagVote")
		DKRS_GoodsContent				= DKRS("GoodsContent")
		DKRS_GoodsDeliveryType			= DKRS("GoodsDeliveryType")
		DKRS_GoodsDeliveryFee			= DKRS("GoodsDeliveryFee")
		DKRS_GoodsDeliveryLimit			= DKRS("GoodsDeliveryLimit")
		DKRS_GoodsDeliPolicyType		= DKRS("GoodsDeliPolicyType")
		DKRS_GoodsDeliPolicy			= DKRS("GoodsDeliPolicy")
		DKRS_ClickCnt					= DKRS("ClickCnt")
		DKRS_RegID						= DKRS("RegID")
		DKRS_RegDate					= DKRS("RegDate")
		DKRS_RegHost					= DKRS("RegHost")
		DKRS_OptionVal					= DKRS("OptionVal")
		DKRS_GoodsBanner				= DKRS("GoodsBanner")
		DKRS_GoodsNote					= DKRS("GoodsNote")
		DKRS_GoodsNoteColor				= DKRS("GoodsNoteColor")
		DKRS_isCSGoods					= DKRS("isCSGoods")
		DKRS_CSGoodsCode				= DKRS("CSGoodsCode")
		DKRS_intSort					= DKRS("intSort")
		DKRS_flagMain					= DKRS("flagMain")
		DKRS_GoodsMaterial				= DKRS("GoodsMaterial")
		DKRS_GoodsCarton				= DKRS("GoodsCarton")
		DKRS_GoodsSize					= DKRS("GoodsSize")
		DKRS_GoodsColor					= DKRS("GoodsColor")
		DKRS_isShopType					= DKRS("isShopType")
		DKRS_strShopID					= DKRS("strShopID")
		DKRS_isAccept					= DKRS("isAccept")
		DKRS_Img1Ori					= DKRS("Img1Ori")
		DKRS_Img2Ori					= DKRS("Img2Ori")
		DKRS_Img3Ori					= DKRS("Img3Ori")
		DKRS_Img4Ori					= DKRS("Img4Ori")
		DKRS_Img5Ori					= DKRS("Img5Ori")
		DKRS_ImgList					= DKRS("ImgList")
		DKRS_ImgThum					= DKRS("ImgThum")
		DKRS_ImgRelation				= DKRS("ImgRelation")
		DKRS_ImgBanner					= DKRS("ImgBanner")
		DKRS_isViewMemberNot			= DKRS("isViewMemberNot")
		DKRS_isViewMemberAuth			= DKRS("isViewMemberAuth")
		DKRS_isViewMemberDeal			= DKRS("isViewMemberDeal")
		DKRS_isViewMemberVIP			= DKRS("isViewMemberVIP")
		DKRS_intPriceNot				= DKRS("intPriceNot")
		DKRS_intPriceAuth				= DKRS("intPriceAuth")
		DKRS_intPriceDeal				= DKRS("intPriceDeal")
		DKRS_intPriceVIP				= DKRS("intPriceVIP")
		DKRS_intMinNot					= DKRS("intMinNot")
		DKRS_intMinAuth					= DKRS("intMinAuth")
		DKRS_intMinDeal					= DKRS("intMinDeal")
		DKRS_intMinVIP					= DKRS("intMinVIP")
		DKRS_intPointNot				= DKRS("intPointNot")
		DKRS_intPointAuth				= DKRS("intPointAuth")
		DKRS_intPointDeal				= DKRS("intPointDeal")
		DKRS_intPointVIP				= DKRS("intPointVIP")

	Else
		Call ALERTS(LNG_SHOP_DETAILVIEW_01,"o_reloada","")
	End If
	Call closeRs(DKRS)

	Select Case DK_MEMBER_LEVEL
		Case 0,1 '비회원, 일반회원
			DKRS_GoodsPrice = DKRS_intPriceNot
			DKRS_GoodsPoint = DKRS_intPointNot
			DKRS_intMinimum = DKRS_intMinNot
		Case 2 '인증회원
			DKRS_GoodsPrice = DKRS_intPriceAuth
			DKRS_GoodsPoint = DKRS_intPointAuth
			DKRS_intMinimum = DKRS_intMinAuth
		Case 3 '딜러회원
			DKRS_GoodsPrice = DKRS_intPriceDeal
			DKRS_GoodsPoint = DKRS_intPointDeal
			DKRS_intMinimum = DKRS_intMinDeal
		Case 4,5 'VIP 회원
			DKRS_GoodsPrice = DKRS_intPriceVIP
			DKRS_GoodsPoint = DKRS_intPointVIP
			DKRS_intMinimum = DKRS_intMinVIP
		Case 9,10,11
			DKRS_GoodsPrice = DKRS_intPriceVIP
			DKRS_GoodsPoint = DKRS_intPointVIP
			DKRS_intMinimum = DKRS_intMinVIP
	End Select

	'▣소비자 가격
	If CONST_CS_SOBIJA_PRICE_USE_TF = "T" Then
		If DK_MEMBER_STYPE = "1" And DKRS_isCSGoods = "T" Then
			DKRS_GoodsPrice = DKRS_GoodsCustomer
		End If
	End If

	printGoodsIcon = ""
	'Select Case arrList_isShopType
	'	Case "S" : printGoodsIcon = printGoodsIcon &"<span class=""icons"">"&viewImg(IMG_ICON&"/icon_sshop.gif",49,11,"")&"</span>"
	'	Case "E" : printGoodsIcon = printGoodsIcon &"<span class=""icons"">"&viewImg(IMG_ICON&"/icon_eshop.gif",49,11,"")&"</span>"
	'	Case Else  : printGoodsIcon = printGoodsIcon
	'End Select
	If DKRS_flagBest	= "T" Then printGoodsIcon = printGoodsIcon & "<span class=""icons"">"&viewImg(IMG_ICON&"/i_bestT.gif",31,11,"")&"</span>"
	If DKRS_flagNew		= "T" Then printGoodsIcon = printGoodsIcon & "<span class=""icons"">"&viewImg(IMG_ICON&"/i_newT.gif",31,11,"")&"</span>"
	If DKRS_FlagVote	= "T" Then printGoodsIcon = printGoodsIcon & "<span class=""icons"">"&viewImg(IMG_ICON&"/i_voteT.gif",31,11,"")&"</span>"


	imgPath = VIR_PATH("goods/thum")&"/"&backword(DKRS_ImgThum)
	imgWidth = 0
	imgHeight = 0
	Call ImgInfo(imgPath,imgWidth,imgHeight,"")
	imgPaddingH = (upImgHeight_Thum - imgHeight) / 2


	StockText = ""
	Select Case DKRS_GoodsStockType
		Case "N" '재고부족
			StockText = LNG_SHOP_CART_TXT_STOCK&":"&DKRS_GoodsStockNum
		Case "I" '무제한'
		Case "S" '품절'
		Case Else '재고이상
	End Select


	SQL = "SELECT * FROM [DK_GOODS_OPTION] WITH(NOLOCK) WHERE [GoodsIDX] = ? AND [isUse] = 'T' ORDER BY [sort] ASC"
	arrParams = Array(_
		Db.makeParam("@GoodsIDX",adInteger,adParamInput,4,DKRS_intIDX) _
	)
	arrList = Db.execRsList(SQL,DB_TEXT,arrParams,listLen,Nothing)

		If IsArray(arrList) Then
			PrintOption = ""
			For i = 0 To listLen
				optionTitle = Trim(arrList(2,i))
				optionItem = Trim(arrList(3,i))
				arrOptItem = Split(optionItem,"\")
				TOTAL_OPTION_CNT = listLen + 1

				' PrintOption
				PrintOption = PrintOption & "<tr>"
				PrintOption = PrintOption & "	<th class=""tcenter"">"&optionTitle&"</th>"
				PrintOption = PrintOption & "	<td style=""padding:8px 0px; text-indent:12px;"">"
				PrintOption = PrintOption & "		<select name=""goodsOption"" class=""select"" title="""&optionTitle&""">"
				PrintOption = PrintOption & "			<option value="""">"&LNG_SHOP_DETAILVIEW_03&"</option>"
					For j = 0 To UBound(arrOptItem)
						optionTxt = Trim(arrOptItem(j))
						optionPay = 0
						arrOptionTxt = Split(optionTxt,":")
						'print optionTxt
						optionTxt = Trim(arrOptionTxt(0))

						If UBound(arrOptionTxt) = 2 Then
							optPrice = Int(arrOptionTxt(1))
							optPrice2 = Int(arrOptionTxt(2))
							If optPrice > 0 Then
								optionTxts = optionTxt &" (+"& FormatNumber(Int(optPrice),0) &" "&Chg_CurrencyISO&")"
							ElseIf optPrice < 0 Then
								optionTxts = optionTxt &" (-"& FormatNumber(Int(optPrice),0) &" "&Chg_CurrencyISO&")"
							ElseIf optPrice = 0 Then
								optionTxts = optionTxt
							End If
						End If
						optValue = optionTitle & ":" & optionTxt & "\" &optPrice &"\" &optPrice2
						PrintOption = PrintOption & "<option value="""&backword(optValue)&""">"&backword(optionTxts)&"</option>"
					Next
				PrintOption = PrintOption & "		</select>"
				PrintOption = PrintOption & "	</td>"
				If i = 0 Then
				'PrintOption = PrintOption & "	<td class=""tcenter"" rowspan="""&TOTAL_OPTION_CNT&"""><input type=""image"" src="""&IMG_BTN&"/btn_chg_option.gif"" class=""vmiddle""  /></td>"
				PrintOption = PrintOption & "	<td class=""tcenter"" rowspan="""&TOTAL_OPTION_CNT&"""><input type=""submit"" class=""txtBtnC small gray radius3"" style=""color:#bf2222;padding:3px 5px;"" value="""&LNG_CS_CART_BTN_CHANGE_OPTION&"""></td>"
				End If
				PrintOption = PrintOption & "</tr>"
			Next
		End If

%>
<link rel="stylesheet" href="/shop/cart_pop.css" />
<script type="text/javascript">

	function chkOption(f) {

		<%if DKRS_OPTIONVAL = "T" THEN%>
			<%if TOTAL_OPTION_CNT > 1 THEN%>
				len = f.goodsOption.length;
				//alert(len);
				for (i=0; i<len; i++) {
					objItem = f.goodsOption[i];
					if (objItem.value=='') {
						//alert(eval((i+1))+"번째 옵션값을 선택해 주세요.");
						alert("<%=LNG_SHOP_DETAILVIEW_11%>"+eval((i+1)));
						objItem.focus();
						return false;
					}
				}
			<%ELSE%>
				if (f.goodsOption.value == ""){
					//alert("옵션값을 선택해 주세요.");
					alert("<%=LNG_SHOP_DETAILVIEW_12%>");
					f.goodsOption.focus();
					return false;
				}
			<%END IF%>
		<%END IF%>

	}

</script>
</head>
<body>
<!-- <div class="bgtitle tweight">
	<span class="bgFont"><%=LNG_SHOP_CART_TXT_CHG_OPTION%></span>
</div> -->
<div id="pop_content">
	<div class="tit_title"><span class="tit_title_sub"><%=LNG_SHOP_CART_TXT_GOODS_INFO%></span></div>
	<table <%=tableatt%> class="width100 cart">
		<col width="100" />
		<col width="*" />
		<col width="120" />
		<thead>
			<tr>
				<th colspan="2"><%=LNG_SHOP_ORDER_DIRECT_TABLE_01%></th>
				<th><%=LNG_SHOP_ORDER_DIRECT_TABLE_02%></th>
			</tr>
		</thead>
		<tr>
			<td class="tcenter">
				<div class="thumImg" style="padding:<%=imgPaddingH%>px 0px;"><%=viewImg(imgPath,imgWidth,imgHeight,"")%></div>
			</td>
			<td class="vtop">
				<p><%=printGoodsIcon%></p>
				<p class="goodsName"><strong><%=backword(DKRS_GoodsName)%></strong></p>
				<p class="goodsComment"><strong><%=backword(DKRS_GoodsComment)%></strong></p>
			</td>
			<td class="tcenter lheight16px">
				<span class="color_ff6600 tweight"><%=num2cur(DKRS_GoodsPrice)%> <%=Chg_CurrencyISO%></span><br />
				<%=viewImgSt(IMG_SHOP&"/icon_point_green.gif",13,15,"","","vmiddle")%>&nbsp;<%=num2cur(DKRS_GoodsPoint)%> <%=Chg_CurrencyISO%>
			</td>
		</tr>
	</table>

	<div class="tit_title" style="margin-top:50px;"><span class="tit_title_sub"><%=LNG_SHOP_CART_TXT_CHG_OPTION%></span></div>
	<form name="eaFrm" method="post" action="cart_pop_option_handler.asp" onsubmit="return chkOption(this);">
	<input type="hidden" name="idx" value="<%=DKRS2_intIDX%>" />
	<table <%=tableatt%> class="width100 chg" style="margin-top:15px;">
		<col width="150" />
		<col width="*" />
		<%=PrintOption%>
	</table>
	</form>

</div>
<div id="pop_close">
	<!-- <div><span class="button medium tweight" style="margin-top:20px;"><a onclick="self.close();"><%=LNG_TEXT_WINDOW_CLOSE%></a></span></div>	 -->
</div>

</body>
</html>
