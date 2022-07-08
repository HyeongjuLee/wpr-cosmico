<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	Call FN_NationCurrency(DK_MEMBER_NATIONCODE,Chg_CurrencyName,Chg_CurrencyISO)

	PAGE_SETTING = "SHOP"
	SHOP_ORDER_PAGE_TYPE = "DETAIL"

	Call ONLY_BUSINESS_MEMBER(DK_MEMBER_LEVEL,1)


	GoodsIDX = gRequestTF("gIDX",True)


	arrParams = Array(_
		Db.makeParam("@intIDX",adInteger,adParamInput,0,GoodsIDX) _
	)
	'Set DKRS = Db.execRs("DKP_GOODS_DETAILVIEW_E",DB_PROC,arrParams,Nothing)		'자체상품
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
		DKRS_isImgType					= DKRS("isImgType")

		DKRS_strNationCode				= DKRS("strNationCode")

	Else
		Call ALERTS(LNG_SHOP_DETAILVIEW_01,"BACK","")
	End If
	Call closeRs(DKRS)

	If DKRS_strNationCode <> DK_MEMBER_NATIONCODE Then Call ALERTS(LNG_ALERT_WRONG_ACCESS,"BACK","")	'▣국가코드, 상품국가코드 비교

	'##################################################################
	' 회원레벨별 상품가격 변경
	'################################################################## START
	Select Case DK_MEMBER_LEVEL
		Case 0,1 '비회원, 일반회원
			DKRS_GoodsPrice = DKRS_intPriceNot
			DKRS_GoodsPoint = DKRS_intPointNot
			DKRS_intMinimum = DKRS_intMinNot
			If DKRS_isViewMemberNot = "F" Then Call ALERTS(LNG_SHOP_DETAILVIEW_02,"BACK","")
		Case 2 '인증회원
			DKRS_GoodsPrice = DKRS_intPriceAuth
			DKRS_GoodsPoint = DKRS_intPointAuth
			DKRS_intMinimum = DKRS_intMinAuth
			If DKRS_isViewMemberAuth = "F" Then Call ALERTS(LNG_SHOP_DETAILVIEW_02,"BACK","")
		Case 3 '딜러회원
			DKRS_GoodsPrice = DKRS_intPriceDeal
			DKRS_GoodsPoint = DKRS_intPointDeal
			DKRS_intMinimum = DKRS_intMinDeal
			If DKRS_isViewMemberDeal = "F" Then Call ALERTS(LNG_SHOP_DETAILVIEW_02,"BACK","")
		Case 4,5 'VIP 회원
			DKRS_GoodsPrice = DKRS_intPriceVIP
			DKRS_GoodsPoint = DKRS_intPointVIP
			DKRS_intMinimum = DKRS_intMinVIP
			If DKRS_isViewMemberVIP = "F" Then Call ALERTS(LNG_SHOP_DETAILVIEW_02,"BACK","")
		Case 9,10,11
			DKRS_GoodsPrice = DKRS_intPriceVIP
			DKRS_GoodsPoint = DKRS_intPointVIP
			DKRS_intMinimum = DKRS_intMinVIP
	End Select
	'##################################################################	END

	'##################################################################
	' 상품 재고상태 확인
	'################################################################## START
	If DKRS_DelTF = "T" Then Call ALERTS(LNG_SHOP_ORDER_WISHLIST_TEXT03 & LNG_STRTEXT_TEXT02,"BACK","")
	If DKRS_isAccept <> "T" Then Call ALERTS(LNG_SHOP_ORDER_DIRECT_06 & LNG_STRTEXT_TEXT02,"BACK","")
	If DKRS_GoodsViewTF <> "T" Then Call ALERTS(LNG_SHOP_ORDER_DIRECT_05 & LNG_STRTEXT_TEXT02,"BACK","")

	If DKRS_intMinimum = 0 Then DKRS_intMinimum = 1
	'##################################################################	END

	'##################################################################
	' 이미지 / 아이콘정보 확인
	'################################################################## START
	If DKRS_flagBest	= "T" Then flagBest		= viewImg(M_IMG&"/i_bestT.gif",31,11,"")&"<br />"
	If DKRS_flagNew		= "T" Then flagNew		= viewImg(M_IMG&"/i_newT.gif",31,11,"")&"<br />"
	If DKRS_flagVote	= "T" Then flagVote		= viewImg(M_IMG&"/i_voteT.gif",31,11,"")&"<br />"
	If DK_MEMBER_TYPE = "COMPANY" Or DK_MEMBER_TYPE ="ADMIN" Then
		'If DKRS_isCSGoods	= "T" Then flagCS		= viewImg(M_IMG&"/i_csgoodsT.gif",50,11,"")&"<br />"
	End If
	'################################################################## END


	'##################################################################
	' CS회원인 경우 PV값 / 상품판매가 확인
	'################################################################## START
	vipPrice = 0	'COSMICO
	If DKRS_isCSGoods = "T" Then
	'▣CS상품정보
		arrParams = Array(_
			Db.makeParam("@ncode",adVarChar,adParamInput,20,DKRS_CSGoodsCode) _
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

		End If
		Call closeRs(DKRS)

    '▣예상결제금액
    '	▣소비자 가격, 쇼핑몰가/CS가 비교(2018-05-18)
    If CONST_CS_SOBIJA_PRICE_USE_TF = "T" Then
      If DK_MEMBER_STYPE = "1" Then
        DKRS_GoodsPrice = DKRS_GoodsCustomer
        RS_price2	    = RS_price
      End If
    End If


  '	If DK_MEMBER_LEVEL > 0 Then
      viewPrice = DKRS_GoodsPrice
      viewPV = RS_price4
  '	Else
  '		viewPrice = 0
  '		viewPV = 0
  '	End If

	End If
	'################################################################## END

	'##################################################################
	' 옵션확인  '현재 옵션 사용 안함
	'################################################################## START
	If DKRS_OPTIONVAL = "T" Then
		SQL = "SELECT * FROM [DK_GOODS_OPTION] WITH(NOLOCK) WHERE [GoodsIDX] = ? AND [isUse] = 'T' ORDER BY [sort] ASC"
		arrParams = Array(_
			Db.makeParam("@GoodsIDX",adInteger,adParamInput,0,GoodsIDX) _
		)
		arrList = Db.execRsList(SQL,DB_TEXT,arrParams,listLen,Nothing)

		If IsArray(arrList) Then
			PrintOption = ""
			PrintOption = PrintOption & "<div class=""porel"" id=""optionArea"" style=""margin:10px 0px 0px 15px;"">"
			PrintOption = PrintOption & "	<ul style=""display:block"">"

			For i = 0 To listLen
				optionTitle = Trim(arrList(2,i))
				optionItem = Trim(arrList(3,i))
				arrOptItem = Split(optionItem,"\")
				TOTAL_OPTION_CNT = listLen + 1

				PrintOption = PrintOption & "<li><span class=""price_text"">"&optionTitle&"</span>"
				PrintOption = PrintOption & "<span class=""price1"">"
				PrintOption = PrintOption & "	<span class=""sline""></span>"
				PrintOption = PrintOption & "	<span class=""s_won""><select name=""goodsOption"" class=""select"" title="""&optionTitle&"""><option value="""">"&LNG_SHOP_DETAILVIEW_03&"</option>"
					For j = 0 To UBound(arrOptItem)
						optionTxt = Trim(arrOptItem(j))
						optionPay = 0
						arrOptionTxt = Split(optionTxt,":")
						'print optionTxt
						optionTxt = Trim(arrOptionTxt(0))
						'print arrOptionTxt(0)
						'print arrOptionTxt(1)
						'print arrOptionTxt(2)

						If UBound(arrOptionTxt) = 2 Then
							optPrice = Int(arrOptionTxt(1))
							optPrice2 = Int(arrOptionTxt(2))
							'print optPrice
							If optPrice > 0 Then
								optionTxts = optionTxt &" (+"& FormatNumber(Int(optPrice),0) &" "&Chg_CurrencyISO&")"
							ElseIf optPrice < 0 Then
								optionTxts = optionTxt &" (-"& FormatNumber(Int(optPrice),0) &" "&Chg_CurrencyISO&")"
							ElseIf optPrice = 0 Then
								optionTxts = optionTxt
							End If
						End If
						optValue = optionTitle & ":" & optionTxt &"\" &optPrice & "\" & optPrice2
						PrintOption = PrintOption & "<option value="""&backword(optValue)&""">"&backword(optionTxts)&"</option>"
					Next
				PrintOption = PrintOption & "		</select>"
				PrintOption = PrintOption & "	</span>"
				PrintOption = PrintOption & "</span>"
				PrintOption = PrintOption & "</li>"
			Next
			PrintOption = PrintOption & "</ul>"
			PrintOption = PrintOption & "</div>"
		End If

	End If
	'################################################################## END

	'##################################################################
	' 배송비 확인
	'################################################################## START
	Select Case DKRS_GoodsDeliveryType
		Case "SINGLE"
			txt_DeliveryFeeType = LNG_SHOP_ORDER_DIRECT_TABLE_08	'단독배송
			txt_self_DeliveryFee = DKRS_GoodsDeliveryFee
			txt_DeliveryFee = "<span id=""deliveryFee_txt"">"&num2cur(txt_self_DeliveryFee)& "</span>"&Chg_CurrencyISO&" ("&txt_DeliveryFeeType&")"

			DKRS2_intDeliveryFee = DKRS_GoodsDeliveryFee

		Case "BASIC"
			'▣ 국가별 배송비 설정
			arrParams2 = Array(_
				Db.makeParam("@strNationCode",adVarChar,adParamInput,6,UCase(DK_MEMBER_NATIONCODE)) _
			)
			Set DKRS2 = DB.execRs("HJP_GLOBAL_DELIVERY_FEE_VIEW",DB_PROC,arrParams2,Nothing)
			If Not DKRS2.BOF And Not DKRS2.EOF Then
				DKRS2_intDeliveryFee		= DKRS2("intDeliveryFee")
				DKRS2_intDeliveryFeeLimit	= DKRS2("intDeliveryFeeLimit")
			Else
				Response.Write LNG_SHOP_DETAILVIEW_22
			End If
			Call closeRS(DKRS2)

			txt_DeliveryFeeType = LNG_SHOP_ORDER_DIRECT_TABLE_10
			txt_self_DeliveryFee = DKRS2_intDeliveryFee

			If DKRS2_intDeliveryFee = 0 Then
				PRINT LNG_SHOP_ORDER_DIRECT_TABLE_10	'무료배송
			Else
				If UCase(DK_MEMBER_NATIONCODE) = "KR" Then
					txt_DeliveryFee = "<span class=""font18px"">"&num2cur(txt_self_DeliveryFee)& Chg_CurrencyISO&"</span> ("&num2cur(DKRS2_intDeliveryFeeLimit)&LNG_SHOP_DETAILVIEW_21&")"
				Else
					txt_DeliveryFee = "<span class=""font18px"">"&num2cur(txt_self_DeliveryFee)& Chg_CurrencyISO&"</span> ("&LNG_SHOP_DETAILVIEW_21&num2cur(DKRS2_intDeliveryFeeLimit)& " " &Chg_CurrencyISO&")"
				End If
			End If

	End Select
	'################################################################## END

	'If DK_MEMBER_LEVEL < 1 Then
	'	DKRS_GoodsCustomer = 0
	'	DKRS_GoodsPrice = 0
	'End If
%>
<!--#include virtual = "/m/_include/document.asp"-->
<!--#include virtual = "/m/_include/jqueryload.asp"-->
<link rel="stylesheet" type="text/css" href="shop.css" />
<script type="text/javascript" src="/m/js/check.js"></script>
<script type="text/javascript">

	//총 주문금액
	$(document).ready(function() {
		sumPrice();
	});

	$(window).scroll(function(){
		if ($(this).scrollTop() < $('#tabArea .detail1').offset().top) {
			$('.detailViewZoom').hide();
		}
		if ($(this).scrollTop() >= $('#tabArea .detail1').offset().top) {
			$('.detailViewZoom').show();
		}
	});

	function SoldOut() {
		alert("<%=LNG_SHOP_DETAILVIEW_JS_SOLDOUT%>");
	}

	//wish, directl, cart 공통
	function stockAndOptionCheck(method) {
		var f = document.cartFrm;
		var i, len;

		<%if DKRS_GoodsStockType = "S" then%>
			alert("<%=LNG_SHOP_DETAILVIEW_04%>");
			return false;
		<%end if%>
		<%if DKRS_GoodsStockType = "N" and DKRS_GoodsStockNum = 0 then%>
			alert("<%=LNG_SHOP_DETAILVIEW_05%>");
			return false;
		<%end if%>
		<%if DKRS_GoodsStockType = "N" and DKRS_GoodsStockNum <> 0 then%>
			if (f.ea.value > <%=DKRS_GoodsStockNum%>)	{
				alert("<%=LNG_SHOP_DETAILVIEW_06%>");
				f.ea.focus();
				return false;
			}
		<%end if%>
		<%if DKRS_intMinimum > 0 THEN%>
			//if (f.ea.value < <%=DKRS_intMinimum%>) {
			if (f.ea.value < <%=DKRS_intMinimum%> && method == 'direct') {		//직접구매만
				alert("<%=LNG_SHOP_DETAILVIEW_07%>");
				f.ea.focus();
				return false;
			}
		<%END IF%>

		if (f.Gidx.value == "")	{
			alert("<%=LNG_SHOP_DETAILVIEW_08%>");
			return false;
		}
		if (chkEmpty(f.ea)||f.ea.value=="0") {
			alert("<%=LNG_SHOP_DETAILVIEW_09%>");
			f.ea.focus();
			return false;
		}
		<%if DK_MEMBER_LEVEL < 1 THEN%>
			var msg = "<%=LNG_SHOP_DETAILVIEW_10%>";
			if(confirm(msg)) {
				document.location.href="/m/common/member_login.asp?backURL=<%=ThisPageURL%>";
				return false;
			}else{
				return false;
			}
		<%END IF%>
		<%If DKRS_OPTIONVAL = "T" THEN%>
			<%If TOTAL_OPTION_CNT > 1 THEN%>
				len = f.goodsOption.length;
				//alert(len);
				for (i=0; i<len; i++) {
					objItem = f.goodsOption[i];
					if (objItem.value=='') {
						alert("<%=LNG_SHOP_DETAILVIEW_11%>"+eval((i+1)));
						objItem.focus();
						return false;
					}
				}
			<%ELSE%>
				if (f.goodsOption.value == ""){
					alert("<%=LNG_SHOP_DETAILVIEW_12%>");
					f.goodsOption.focus();
					return false;
				}
			<%END IF%>
		<%END IF%>

		return true;
	}

	function wishGo(idx) {
		var f = document.cartFrm;

		if (!stockAndOptionCheck('wish')) return false;

		<%IF DK_MEMBER_ID <> "GUEST" THEN%>
		if (confirm("<%=LNG_SHOP_DETAILVIEW_JS_TO_WISHLIST%>"))
		{
			$.ajax({
				type: "POST"
				,url: "wishlist_add.asp"
				,data: {
					"goodsIDX"		: idx
				}
				,success: function(data) {
					if (data == 'ADD'){
						if (confirm('<%=LNG_SHOP_DETAILVIEW_JS_MOVE_TO_WISHLIST%>')) {
							document.location.href='wishlist.asp';
						}
					} else if (data == 'ERROR'){
						alert('<%=LNG_SHOP_DETAILVIEW_JS_ERROR%>');
					} else {
						if (confirm('<%=LNG_SHOP_DETAILVIEW_JS_ALREADY_REGISTED%>')) {
							document.location.href='wishlist.asp';
						}
					}
				}
				,error:function(data) {
					alert("<%=LNG_SHOP_DETAILVIEW_JS_ERROR%>" + "ERROR CODE : "+data.status+" "+data.statusText+" "+data.responseText);
				}
			});
		}
		<%ELSE%>
			if (confirm('<%=LNG_SHOP_DETAILVIEW_10%>'))	{
				document.location.href = '/m/common/member_login.asp';
			}
		<%END IF%>
	}

	// 바로구매
	function directOrder() {
		var f = document.cartFrm;

		if (!stockAndOptionCheck('direct')) return false;

		<%IF DK_MEMBER_TYPE = "SELLER" THEN%>
			alert("<%=LNG_SHOP_DETAILVIEW_13%>");
			return;
		<%ELSE%>
			f.target = "_self";
			//f.action = "/m/shop/order_direct.asp";
			f.action = "/m/shop/cart_direct.asp";//주문통합
			f.submit();
		<%END IF%>
	}

	// 장바구니담기
	function cartADD() {
		var f = document.cartFrm;

		if (!stockAndOptionCheck('cart')) return false;

		<%IF DK_MEMBER_TYPE = "SELLER" THEN%>
			alert("<%=LNG_SHOP_DETAILVIEW_13%>");
			return false;
		<%ELSE%>
			/*
			f.mode.value = "ADD";
			f.target = "_self";
			f.action = "/m/shop/cart_handler.asp";
			f.submit();
			*/
			ajaxConfirmCart();
		<%END IF%>
	}

	//이미 담긴 장바구니 수량과 현재 주문갯수 합쳐서 재고와 비교
	function ajaxConfirmCart() {
		const formData = $("#cartFrm").serialize();
		$.ajax({
			type: "POST"
			,url: "/m/shop/cart_handler_ajax.asp"
			,cache : false
			,data: formData
			,success: function(data) {
				//console.log(data);
				const json = $.parseJSON(data);
				if (json.result == "success") {
					//confirmCartDialog(json.message+"<br /><br /><%=LNG_SHOP_CART_JS_MOVE_TO_CART%>");
					confirmCart(json.message+"\n\n<%=LNG_SHOP_CART_JS_MOVE_TO_CART%>");
				}else{
					alert(json.message);
					return false;
				}
			}
			,error:function(data) {
				alert("<%=LNG_AJAX_ERROR_MSG%> : "+data.status+" "+data.statusText+" "+data.responseText);
			}
		});
		function confirmCartDialog(message) {
			$(".message").html(message);
			$(".dialog-confirm").click();
			return false;
		}
		function confirmCart(message) {
			if(confirm(message)){
				location.href='cart.asp';
			} else {
				return false;
			}
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

	//재고, 최소구매수량 체크
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

		chkintMinimum();
		chkStockNum();

		good_ea_id.val(chg_good_ea_val);
		sumPrice();

		//1.최소구매수량 확인
		function chkintMinimum() {
			if (parseInt(chg_good_ea_val,10) < parseInt(intMinimum,10))	{
				alert("<%=LNG_SHOP_DETAILVIEW_07%>("+intMinimum+")");
				chg_good_ea_val = intMinimum;
				return false;
			}
		}

		//2.재고비교
		function chkStockNum() {
			if (GoodsStockType == 'N' && GoodsStockNum > 0)
			{
				if (chg_good_ea_val > GoodsStockNum) {
					alert("<%=LNG_SHOP_DETAILVIEW_06%>");
					chg_good_ea_val = GoodsStockNum;
				}
			}
		}
	}

	function sumPrice() {
		let basePrice_val = $("#basePrice").val();
		let basePV_val = $("#basePV").val();
		let good_ea_val	= $("input[name=ea]").val();
		let DeliveryType = $("input[name=DeliveryType]").val();
		let BASIC_DeliveryFeeLimit = $("input[name=BASIC_DeliveryFeeLimit]").val() * 1;
		let BASIC_DeliveryFee = $("input[name=BASIC_DeliveryFee]").val() * 1;

		let sumPrice = formatComma(basePrice_val * good_ea_val,3) ;
		let sumPV = formatComma(basePV_val * good_ea_val,3) ;
		if (DeliveryType == "SINGLE") {
			BASIC_DeliveryFee = formatComma(BASIC_DeliveryFee * good_ea_val,3);
		}
		//console.log(good_ea_val,DeliveryType ,BASIC_DeliveryFee);

		$("#sumPrice_txt").text(sumPrice);
		$("#sumPV_txt").text(sumPV);
		$("#deliveryFee_txt").text(BASIC_DeliveryFee);
	}


	// 상품상세정보 Tab
	function detail1on() {
		$(".detail1").addClass("on");
		$(".detail2").removeClass("on");
		$(".detail3").removeClass("on");
		$("#detail_info1").css({"display":"block"});
		$("#detail_info2").css({"display":"none"});
		$("#detail_info3").css({"display":"none"});
	}
	function detail2on() {
		$(".detail1").removeClass("on");
		$(".detail2").addClass("on");
		$(".detail3").removeClass("on");
		$("#detail_info1").css({"display":"none"});
		$("#detail_info2").css({"display":"block"});
		$("#detail_info3").css({"display":"none"});
	}
	function detail3on() {
		$(".detail1").removeClass("on");
		$(".detail2").removeClass("on");
		$(".detail3").addClass("on");
		$("#detail_info1").css({"display":"none"});
		$("#detail_info2").css({"display":"none"});
		$("#detail_info3").css({"display":"block"});
		//$('.detailViewZoom').show();		//확대X
		$('.detailViewZoom').hide();
	}

</script>
</head>
<body>
<!--#include virtual = "/m/_include/header.asp"-->
<!--#include virtual = "/m/_include/sub_header.asp"-->
<div class="detailViewZoom" style="display:none;">
	<a href="popView.asp?gidx=<%=GoodsIDX%>" >
		<div style="margin-top:7px;"><img src="<%=M_IMG%>/zoom_icon.png" alt="" /></div>
		<div style="margin-top:5px;"><%=LNG_M_BTN_ZOOMIN%></div>
	</a>
</div>

<div id="detailView" class="shopPage detailView">
	<form name="cartFrm" id="cartFrm" method="post" action="">
		<input type="hidden" name="Gidx" value="<%=GoodsIDX%>" />
		<input type="hidden" name="mode" value="ADD" />
		<input type="hidden" name="strShopID" value="<%=DKRS_strShopID%>" />
		<input type="hidden" name="isShopType" value="<%=DKRS_isShopType%>" />
		<input type="hidden" name="GoodsDeliveryType" value="<%=DKRS_GoodsDeliveryType%>" />

		<div class="goodsImg">
			<img src="<%=VIR_PATH("goods/img1")%>/<%=DKRS_Img1Ori%>" width="100%" alt="" />
		</div>
		<div class="goodsTitle">
			<h2><%=DKRS_GoodsName%></h2>
			<p class="goodsNote"><%=DKRS_GoodsComment%></p>
		</div>

		<%
			'할인율 표시
			DisCountPercent = 0
			If DKRS_GoodsCustomer > 0  Then	DisCountPercent = 100 - Round((DKRS_GoodsPrice/DKRS_GoodsCustomer) * 100)
			If DisCountPercent > 0 Then
				DisCountPercent_view = "<div class=""sale""><span>"&DisCountPercent&"</span>%</div>"
			End If
		%>
		<div class="goodsTxt">
			<%If DKRS_isCSGoods = "T" And (RS_price2 <> DKRS_GoodsPrice) Then%>
				<li><span><%=LNG_SHOP_DETAILVIEW_JS_DIFFERENT_PRICE%></li>
			<%Else%>
				<div class="flags">
					<%=flagBest%><%=flagNew%><%=FlagVote%><%=FlagCS%>
				</div>
				<div class="price-summary">
					<%=DisCountPercent_view%>
				</div>
				<ul class="price">
					<%If DK_MEMBER_STYPE = "1" Then%>
						<%If CONST_CS_SOBIJA_PRICE_USE_TF = "T" Then	'소비자회원 소비자가%>
							<li class="price-customer">
								<h6><%=LNG_SHOP_DETAILVIEW_16%></h6>
								<span><strong><%=num2cur(DKRS_GoodsCustomer)%></strong><%=Chg_CurrencyISO%></span>
							</li>
						<%Else%>
							<li class="price-default">
								<h6><%=LNG_SHOP_DETAILVIEW_15%></h6>
								<span><strong><%=num2cur(DKRS_GoodsCustomer)%></strong><%=Chg_CurrencyISO%></span>
							</li>
							<li class="price-customer">
								<h6><%=LNG_SHOP_DETAILVIEW_16%></h6>
								<span><strong><%=num2cur(DKRS_GoodsPrice)%></strong><%=Chg_CurrencyISO%></span>
							</li>
						<%End If%>
					<%Else%>
						<li class="price-default">
							<h6><%=LNG_SHOP_DETAILVIEW_15%></h6>
							<span><strong><%=num2cur(DKRS_GoodsCustomer)%></strong><%=Chg_CurrencyISO%></span>
						</li>
						<li class="price-customer">
							<h6><%=LNG_SHOP_DETAILVIEW_16%></h6>
							<span><strong><%=num2cur(DKRS_GoodsPrice)%></strong><%=Chg_CurrencyISO%></span>
						</li>
					<%End If%>

					<%If nowGradeCnt >= 20 And vipPrice > 0 Then 'COSMICO%>
						<li class="price-customer">
							<h6><%=LNG_VIP_PRICE%></h6>
							<span><strong><%=num2cur(vipPrice)%></strong><%=Chg_CurrencyISO%></span>
						</li>
					<%End If%>

					<%If PV_VIEW_TF = "T" Then%>
					<li class="price-cs">
						<h6><%=CS_PV%></h6>
						<span><strong><%=num2curINT(RS_price4)%></strong><%=CS_PV%></span>
					</li>
					<%End If%>
					<%If BV_VIEW_TF = "T" Then%>
					<li class="price-bv">
						<h6><%=CS_PV2%></h6>
						<span><strong><%=num2curINT(RS_price5)%></strong><%=CS_PV2%></span>
					</li>
					<%End If%>
					<%If RS_SellTypeName <> "" Then%>
					<li class="price-type">
						<h6><%=LNG_TEXT_SALES_TYPE%></h6>
						<span><%=RS_SellTypeName%></span>
					</li>
					<%End If%>
				</ul>
			<%End If%>

		<%=PrintOption%>
			<input type="hidden" name="intMinimum" value="<%=DKRS_intMinimum%>" readonly="readonly"/>
			<input type="hidden" name="GoodsStockType" value="<%=DKRS_GoodsStockType%>" />
			<input type="hidden" name="GoodsStockNum" value="<%=DKRS_GoodsStockNum%>" />
			<input type="hidden" name="basePrice" id="basePrice" value="<%=viewPrice%>" readonly="readonly" />
			<input type="hidden" name="basePV" id="basePV" value="<%=viewPV%>" readonly="readonly" />
			<input type="hidden" name="DeliveryType" value="<%=DKRS_GoodsDeliveryType%>" readonly="readonly" />
			<input type="hidden" name="BASIC_DeliveryFeeLimit" value="<%=DKRS2_intDeliveryFeeLimit%>" readonly="readonly" />
			<input type="hidden" name="BASIC_DeliveryFee" value="<%=DKRS2_intDeliveryFee%>" readonly="readonly" />

			<ul class="fee">
				<li class="fee-delivery">
					<h6><%=LNG_SHOP_DETAILVIEW_18%></h6><!-- 배송비 -->
					<div>
						<span class="tweight purple"><%=txt_DeliveryFee%></span>
					</div>
				</li>
				<li class="fee-delivery">
					<h6><%=LNG_TEXT_CSGOODS_CODE%></h6>
					<div>
						<span class="tweight"><%=RS_ncode%></span>
					</div>
				</li>
				<li class="fee-ea">
					<h6><%=LNG_SHOP_ORDER_DIRECT_TABLE_03%></h6>
					<span>
						<%
							If DKRS_intMinimum = 0 Then
								ThisMins = 1
							Else
								ThisMins = DKRS_intMinimum
							End If
						%>
						<a href="javascript:eaUpDown('down');" class="minus"><i class="icon-minus-1"></i></a>
						<input type="tel" name="ea" value="<%=ThisMins%>" <%=onlyKeys%> />
						<a href="javascript:eaUpDown('up');" class="plus"><i class="icon-plus-1"></i></a>
					</span>
					<%If DKRS_GoodsStockType = "N" and DKRS_GoodsStockNum >= 0 Then%>
						<span>(<%=LNG_SHOP_CART_TXT_STOCK%> : <span class="tweight"><%=DKRS_GoodsStockNum%></span>)</span>
					<%End If%>
				</li>
				<li class="fee-total">
					<h6><%=LNG_TOTAL_PAY_PRICE%></h6>
					<div>
						<span><strong id="sumPrice_txt"><%=num2cur(viewPrice)%></strong><i><%=Chg_CurrencyISO%></i></span>
						<!-- <span><strong id="sumPV_txt"><%=num2curINT(RS_price4)%></strong><i><%=CS_PV%></i></span> -->
					</div>
				</li>
			</ul>
		</div>
		<div id="buyBtn" class="goodsBuy">
			<%
				Select Case DKRS_GoodsStockType
					Case "S"
						orderBtn = "<a class=""sout"" href=""javascript:SoldOut('"&DKRS_intIDX&"');"">"&LNG_SHOP_DETAILVIEW_BTN_SOLDOUT&"</a>"
					Case "N"
						If DKRS_GoodsStockNum > 0 Then
							orderBtn = "<a class=""buys"" href=""javascript:directOrder('"&DKRS_intIDX&"');"">"&LNG_SHOP_DETAILVIEW_BTN_01&"</a>"
						Else
							orderBtn = "<a class=""sout"" href=""javascript:SoldOut('"&DKRS_intIDX&"');"">"&LNG_SHOP_DETAILVIEW_BTN_SOLDOUT&"</a>"
						End If
					Case "I"
						orderBtn = "<a class=""buys"" href=""javascript:directOrder('"&DKRS_intIDX&"');"">"&LNG_SHOP_DETAILVIEW_BTN_01&"</a>"
				End Select

			%>

			<%If DKRS_isCSGoods = "T" And (RS_price2 <> DKRS_GoodsPrice) Then%>
				<a class="sout" href="javascript:alert('<%=LNG_SHOP_DETAILVIEW_JS_DIFFERENT_PRICE%>')"><%=LNG_SHOP_DETAILVIEW_BTN_CANNOT%></a>
			<%Else%>
				<%If DKRS_GoodsPrice < 1 Then	'상품가 0원일 경우%>
					<a class="sout" href="javascript:alert('<%=LNG_SHOP_DETAILVIEW_JS_NO_PRICE%>')"><%=LNG_SHOP_DETAILVIEW_BTN_CANNOT%></a>
				<%Else%>
					<a class="cart" href="javascript:cartADD('<%=DKRS_intIDX%>');"><%=LNG_SHOP_COMMON_TXT_07%></a>
					<%=orderBtn%>
				<%End If%>
			<%End If%>
		</div>
		<div id="tabArea" class="detail">
			<a href="javascript:detail1on();" class="detail1 on"><span><%=LNG_SHOP_DETAILVIEW_35%></span></a>
			<!-- <a href="javascript:detail2on();" class="detail2"><span>상품평</span></a> -->
			<a href="javascript:detail3on();" class="detail3"><span><%=LNG_SHOP_DETAILVIEW_36%></span></a>
		</div>

		<div id="detail_info1" class="detail_info">
		<%
			DKRS_GOODSCONTENT = backword_tag(DKRS_GOODSCONTENT)
			DKRS_GOODSCONTENT = Replace(DKRS_GOODSCONTENT,"<img ","<img width=""100%""")
			DKRS_GOODSCONTENT = Replace(DKRS_GOODSCONTENT,"<IMG ","<IMG width=""100%""")
			DKRS_GOODSCONTENT = RegExpReplace2("(width=(?:|'|""))((^[0-9]))((?:|'|""))",DKRS_GOODSCONTENT,"width=""100%""")
			print DKRS_GOODSCONTENT

		%>
		</div>
		<div id="detail_info2" class="detail_info">
			상품평
		</div>
		<div id="detail_info3" class="detail_info">
			<%
				Select Case DKRS_isShopType
					Case "E"
						If DKRS_GoodsDeliPolicyType = "B" Then
							SQL = "SELECT [policyContent] FROM [DK_POLICY] WHERE [delTF] = 'F' AND [policyType] = ? AND [strNationCode] = ?"
							arrParams = Array(_
								Db.makeParam("@policyType",adVarChar,adParamInput,20,"delivery"), _
								Db.makeParam("@strNationCode",adVarChar,adParamInput,6,DK_MEMBER_NATIONCODE) _
							)
							THIS_DELI_CONTENT = Db.execRsData("DKPC_POLICY_CONTENT",DB_PROC,arrParams,Nothing)
							'THIS_DELI_CONTENT = Db.execRsData("DKSP_POLICY_CONTENT",DB_PROC,arrParams,Nothing)
							THIS_DELI_CONTENT = backword_tag(THIS_DELI_CONTENT)
						Else
							THIS_DELI_CONTENT = backword_tag(DKRS_GoodsDeliPolicy)
						End If
					Case "S"
						If DKRS_GoodsDeliveryType = "BASIC" Then
							arrParams = Array(_
								Db.makeParam("@strShopID",adVarChar,adParamInput,20,DKRS_strShopID) _
							)
							THIS_DELI_CONTENT = Db.execRsData("DKPD_VENDOR_DELIVERY",DB_PROC,arrParams,Nothing)
							THIS_DELI_CONTENT = backword_tag(THIS_DELI_CONTENT)
						Else
							THIS_DELI_CONTENT = backword_tag(DKRS_GoodsDeliPolicy)
						End If
				End Select


				If isNull(THIS_DELI_CONTENT) = False Then
					THIS_DELI_CONTENT = backword_tag(THIS_DELI_CONTENT)
					THIS_DELI_CONTENT = Replace(THIS_DELI_CONTENT,"<img ","<img width=""100%"" height=""100%""")
					THIS_DELI_CONTENT = Replace(THIS_DELI_CONTENT,"<IMG ","<IMG width=""100%"" height=""100%""")
					THIS_DELI_CONTENT = Replace(THIS_DELI_CONTENT,"style=","st=")
					THIS_DELI_CONTENT = RegExpReplace2("(width=(?:|'|""))((^[0-9]))((?:|'|""))",THIS_DELI_CONTENT,"width=""100%""")
				Else
					THIS_DELI_CONTENT = ""
				End If

				print THIS_DELI_CONTENT
			%>

		</div>
	</form>
	<form name="frm" method="post" action="">
		<input type="hidden" name="PAGESIZE" value="<%=PAGESIZE%>" />
		<input type="hidden" name="PAGE" value="<%=PAGE%>" />
	</form>
</div>
<!--#include virtual = "/m/_include/copyright.asp"-->