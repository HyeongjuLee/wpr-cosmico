<!--#include virtual = "/_lib/strFunc.asp"-->
<!--#include virtual = "/_include/document.asp"-->
<%
	Call FN_NationCurrency(DK_MEMBER_NATIONCODE,Chg_CurrencyName,Chg_CurrencyISO)

	'jQuery Modal Dialog방식변경
	If Not (checkRef(houUrl &"/shop/cart_pop_ea.asp") _
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

	If DKRS_intMinimum = 0 Then DKRS_intMinimum = 1

	'▣소비자 가격
	If CONST_CS_SOBIJA_PRICE_USE_TF = "T" Then
		If DK_MEMBER_STYPE = "1" And DKRS_isCSGoods = "T" Then
			DKRS_GoodsPrice = DKRS_GoodsCustomer
		End If
	End If

	printGoodsIcon = ""
	'Select Case DKRS_isShopType
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

%>
<link rel="stylesheet" href="/shop/cart_pop.css" />
</head>
<body>
<!-- <div class="bgtitle tweight">
	<span class="bgFont"><%=LNG_SHOP_CART_TXT_CHG_EA%></span>
</div> -->
<div id="pop_content">
	<div class="tit_title"><span class="tit_title_sub"><%=LNG_SHOP_CART_TXT_GOODS_INFO%></span></div>
	<table <%=tableatt%> class="width100 cart">
		<col width="100" />
		<col width="*" />
		<col width="120" />
		<input type="hidden" name="intMinimum" value="<%=DKRS_intMinimum%>" readonly="readonly"/>
		<input type="hidden" name="GoodsStockType" value="<%=DKRS_GoodsStockType%>" />
		<input type="hidden" name="GoodsStockNum" value="<%=DKRS_GoodsStockNum%>" />
		<input type="hidden" name="basePrice" id="basePrice" value="<%=DKRS_GoodsPrice%>" readonly="readonly" />
		<input type="hidden" name="basePV" id="basePV" value="<%=RS_price4%>" readonly="readonly" />
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
				<!-- <p><%=printGoodsIcon%></p> -->
				<p>
					<%
						SQL = "SELECT [strComName] FROM [DK_VENDOR] WITH(NOLOCK) WHERE [strShopID] = ?"
						arrParams2 = Array(Db.makeParam("@strUserID",adVarChar,adParamInput,30,DKRS_strShopID))
						txt_strComName = Db.execRsData(SQL,DB_TEXT,arrParams2,Nothing)
						If DKRS_strShopID = "company" Then txt_strComName = DKCONF_SITE_TITLE
						PRINT "<span class=""strComName"">"&txt_strComName&"</span>"
					%>
				</p>
				<p class="goodsName"><span><%=backword(DKRS_GoodsName)%></span></p>
				<p class="goodsComment"><span><%=backword(DKRS_GoodsComment)%></span></p>
				<%If DK_MEMBER_TYPE = "COMPANY" Then%>
					<p><%=arr_CS_SellTypeName%></p>
				<%End If%>
				<%If StockText <> "" Then%>
					<p class="font13px"><%=StockText%></p>
				<%End If%>
			</td>
			<td class="tcenter lheight16px">
				<span class="color_ff6600"><%=num2cur(DKRS_GoodsPrice)%> <%=Chg_CurrencyISO%></span><br />
			</td>
		</tr>
	</table>

	<div class="tit_title" style="margin-top: 20px;"><span class="tit_title_sub"><%=LNG_SHOP_CART_TXT_CHG_EA%></span></div>
	<form name="eaFrm" method="post" action="cart_pop_ea_handler.asp" onsubmit="return chkEa(this);">
		<input type="hidden" name="idx" value="<%=DKRS2_intIDX%>" />
		<input type="hidden" name="eaORG" value="<%=DKRS2_orderEa%>" />
		<input type="hidden" name="gIDX" value="<%=DKRS_intIDX%>" />
		<table <%=tableatt%> class="width100 cart">
			<col width="150" />
			<col width="*" />
			<tr>
				<th><%=LNG_SHOP_CART_TXT_03%></th>
				<td class="">
					<span class="ea_bg"><a href="javascript:eaUpDown('down');">-</a></span><input type="text" name="ea" value="<%=DKRS2_orderEa%>" class="input_text_ea vmiddle tcenter" <%=onlyKeys%> /><span class="ea_bg"><a href="javascript: eaUpDown('up');">+</a></span>
					<%If DKRS_intMinimum > 1 Then%>
						<span style="padding-left: 8px;">(<%=LNG_SHOP_DETAILVIEW_34%> : <span class="tweight"><%=DKRS_intMinimum%></span>)</span>
					<%End If%>
					<%If DKRS_GoodsStockType = "N" and DKRS_GoodsStockNum > 0 Then%>
						<span style="padding-left: 8px;">(<%=LNG_SHOP_CART_TXT_STOCK%> : <span class="tweight"><%=DKRS_GoodsStockNum%></span>)</span>
					<%End If%>
				</td>
			</tr>
			<tr>
				<th><%=LNG_TOTAL_PAY_PRICE%></th>
				<td><span class="font18px" id="sumPrice_txt"><%=num2cur(DKRS_GoodsPrice*DKRS2_orderEa)%> </span><%=Chg_CurrencyISO%></td>
			</tr>
			<!-- <tr>
				<td colspan="2" class="tcenter" style="padding:15px 0px;"><%=DK_MEMBER_NAME%>님의 현재 상품의 최소 구매수량은 <%=DKRS_intMinimum%>개입니다.</td>
			</tr> -->
		</table>
		<div class="popBtnArea width100">
			<div class="porel clear" style="overflow: hidden;">
				<div><input type="button" class="popBtn gray fleft" onclick="closePop();" value="<%=LNG_TEXT_POINT_CANCEL%>"/></div>
				<div><input type="button" class="popBtn green fright" onclick="chkEaSubmit();" value="<%=LNG_TEXT_CONFIRM%>"/></div>
			</div>
		</div>
	</form>
</div>

<script type="text/javascript">

	function closePop() {
		//self.close();
		parent.$("#modal_view").dialog("close");
	}

	function chkEa(f) {
		if (f.ea.value == "" || f.ea.value < <%=DKRS_intMinimum%>)
		{
			//alert("수량은 <%=DKRS_intMinimum%>보다 커야합니다.");
			alert("<%=LNG_SHOP_DETAILVIEW_14%>");
			f.ea.focus();
			return false;
		}
	}

	//수량 직접 입력
	$(document).on("keyup","input[name=ea]",function() {
		let good_ea_id = 	$(this);
		stockCheck(good_ea_id,'');
	});

	function eaUpDown(ud) {
		let good_ea_id = $("input[name=ea]");
		stockCheck(good_ea_id,ud);
	}

	//재고,최소구매수량 체크
	function stockCheck(good_ea_id,ud) {
		let good_ea_val = good_ea_id.val() * 1;
		let GoodsStockType = $("input[name=GoodsStockType]").val();
		let GoodsStockNum = $("input[name=GoodsStockNum]").val() * 1;
		let intMinimum = $("input[name=intMinimum]").val() * 1;

		let chg_good_ea_val = 0;
		if (ud == '') chg_good_ea_val = good_ea_val;
		if (ud == 'up') chg_good_ea_val = (good_ea_val + 1);
		if (ud == 'down') chg_good_ea_val = (good_ea_val - 1);

		if(isNaN(chg_good_ea_val) == true || chg_good_ea_val == "" || chg_good_ea_val < 1) {
			if (intMinimum < 1) intMinimum = 1;
			good_ea_id.val(intMinimum);
			return false;
		}

		chkintMinimumStockNum();
		chkintMinimum();
		chkStockNum();

		good_ea_id.val(chg_good_ea_val);
		sumPrice();

		//0.최소구매수량 / 재고량 비교
		function chkintMinimumStockNum() {
			if (GoodsStockType == 'N' && intMinimum > GoodsStockNum) {
				alert("최소 구매수량("+intMinimum+")보다 재고가("+GoodsStockNum+") 부족합니다.");
				chg_good_ea_val = intMinimum;
			}
		}
		//1.최소구매수량 확인
		function chkintMinimum() {
			if (chg_good_ea_val < intMinimum) {
				alert("<%=LNG_SHOP_DETAILVIEW_07%>("+intMinimum+")");
				chg_good_ea_val = intMinimum;
			}
		}
		//2.재고비교
		function chkStockNum() {
			if (GoodsStockType == 'N' && GoodsStockNum > 0) {
				if (chg_good_ea_val > GoodsStockNum) {
					alert("<%=LNG_SHOP_DETAILVIEW_06%>");
					chg_good_ea_val = GoodsStockNum;
				}
			}
		}

	}

	function sumPrice(){
		let basePrice_val	= $("#basePrice").val();
		let basePV_val = $("#basePV").val();
		let good_ea_val		= $("input[name=ea]").val();

		let sumPrice = formatComma(basePrice_val * good_ea_val,3) ;
		let sumPV = formatComma(basePV_val * good_ea_val,3) ;
		$("#sumPrice_txt").text(sumPrice);
		$("#sumPV_txt").text(sumPV);
	}

	function chkEaSubmit() {
		let f = document.eaFrm;
		let good_ea_val = $("input[name=ea]").val();

		<%if DKRS_GoodsStockType = "N" and DKRS_GoodsStockNum <> 0 then%>
			if (good_ea_val > <%=DKRS_GoodsStockNum%>)	{
				alert("<%=LNG_SHOP_DETAILVIEW_06%>");
				return false;
			}
		<%end if%>

		<%if DKRS_intMinimum > 0 THEN%>
			if (f.ea.value < <%=DKRS_intMinimum%>)
			{
				alert("<%=LNG_SHOP_DETAILVIEW_07%>");
				f.ea.focus();
				return false;
			}
		<%END IF%>

		f.submit();
	}
</script>
</body>
</html>
