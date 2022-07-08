<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	Call FN_NationCurrency(DK_MEMBER_NATIONCODE,Chg_CurrencyName,Chg_CurrencyISO)
	Call ONLY_BUSINESS_MEMBER(DK_MEMBER_LEVEL,1)

	'장바구니
	PAGE_SETTING = "SHOP"
	SHOP_ORDER_PAGE_TYPE = "CART"

%>
<!--#include virtual = "/m/_include/document.asp"-->
<!--#include virtual = "/m/_include/jqueryload.asp"-->

<link rel="stylesheet" href="/m/css/shop_order_style.css?v0" />
<script type="text/javascript">

	function SelectAll(){
		var f = document.cartFrm;

		initAmountByShopID();

		if(f.checklist.checked){
			if (typeof f.chkCart.length == "undefined") {
				if (f.chkCart.disabled != true)
					{
						f.chkCart.checked = true;
					}
			} else {
				for (i=0, len=f.chkCart.length; i<len; i++) {
					if (f.chkCart[i].disabled != true)
					{
						f.chkCart[i].checked = true;
					}
				}
			}
		} else {
			if (typeof f.chkCart.length == "undefined") {
				f.chkCart.checked = false;
			} else {
				for (i=0, len=f.chkCart.length; i<len; i++) {
					if (f.chkCart[i].disabled != true)
					{
						f.chkCart[i].checked = false;
					}
				}
			}
		}
		sumAllPrice('ALL');
	}

	function cartDelThis(idx) {
		var f = document.dFrm;
		if (confirm('<%=LNG_SHOP_CART_JS_DELETE%>'))
		{
			f.mode.value = 'DELTHIS';
			f.cartIDX.value = idx;
			f.submit();
		}
	}

	function chgCartEa(idx) {		//XXX
		const f = document.mFrm;

		let cuidx = $("input[name=cuidx]").eq(idx).val() * 1;
		let eaORG = $("input[name=eaORG]").eq(idx).val() * 1;
		let gIDX = $("input[name=gIDX]").eq(idx).val() * 1;
		let intMinimum = $("input[name=intMinimum]").eq(idx).val() * 1;
		let setEa = $("input[name=setEa]").eq(idx).val() * 1;

		if (setEa == "" || parseInt(setEa,10) < parseInt(intMinimum,10)) {
			alert("<%=LNG_SHOP_DETAILVIEW_14%>");
			return;
		}

		if (setEa < 1 )	{
			alert("수량값은 최소 1이상입니다.");
			//alert("<%=LNG_CS_CART_JS08%>");
			f.setEa.value=1;
			return;
		}

		f.mode.value = 'EACHG';
		f.cartIDX.value = cuidx;
		f.cartEa.value = setEa;
		f.eaORG.value	= eaORG;
		f.gIDX.value	= gIDX;
		f.submit();
	}

	function selectOrder() {
		var f = document.cartFrm;
		var i,len;
		var objCbList = f.chkCart;
		var objCart = f.cuidx;
		var objEa = f.ea;
		var selCnt = 0;
		var chgGoodsCnt = 0;
		var attr;

		//CS상품 구매종류가 같은 상품만 넘김s
		var attrResult = [];
		$("input[name=chkCart]:checked").each(function(){
			var vs = $(this).attr("attrCode");
			if (vs != "")
			{
				if ($.inArray(vs,attrResult) == -1)		// 배열과 비교해서 기존에 없는 값인 경우
				{
					attrResult.push(vs);								// 배열에 저장
				}
			}
		});
		var attrReCount = attrResult.length;

		if (attrReCount > 1)									// 배열의 갯수가 1개 이상인 경우 (일반상품 제외vs에서 걸렀음)
		{
			alert("<%=LNG_CS_CART_JS04%>");
			return ;
		}

		if (typeof objCart == "undefined") {
			alert("<%=LNG_SHOP_CART_JS_01%>");
			return;
		}

		if (typeof f.chkCart.length == "undefined") {
			if (f.chkCart.checked) ++selCnt;
		}
		else {
			for (i=0, len=f.chkCart.length; i<len; i++) {
				if (f.chkCart[i].checked){
					++selCnt;
					attr = f.chkCart[i].getAttribute('attrCG');
					if (attr == 'T')
					{
						++chgGoodsCnt;
					}
				}
			}
		}

		if (selCnt == 0) {
			alert("<%=LNG_SHOP_CART_JS_02%>");
			return;
		}
		if (chgGoodsCnt > 0) {
			alert("<%=LNG_SHOP_CART_JS_03%>");
			return;
		}

		if (typeof f.chkCart.length == "undefined") {
			if (f.chkCart.checked) {
				objCart.disabled = false;
				objEa.disabled = false;
			}
			else {
				objCart.disabled = true;
				objEa.disabled = true;
			}
		}
		else {
			for (i=0, len=f.chkCart.length; i<len; i++) {
				if (f.chkCart[i].checked) {
					objCart[i].disabled = false;
					objEa[i].disabled = false;
				}
				else {
					objCart[i].disabled = true;
					objEa[i].disabled = true;
				}
			}
		}

		f.target = "_self";
		f.action = "/m/shop/order.asp";
		f.submit();
	}


	//수량 직접 입력
	$(document).on("blur","input[name=setEa]",function() {
		let good_ea_id = $(this);
		let idx = $("input[name=setEa]").index(this);
		let readonlyChk = good_ea_id.prop("readonly");
		if (readonlyChk) return false;	//readonly stop!
		stockCheck(good_ea_id,'',idx);
	});

	function eaUpDown(ud,idx) {
		let good_ea_id = $("#good_ea"+idx);
		stockCheck(good_ea_id,ud,idx);
	}

	function stockCheck(good_ea_id,ud,idx) {
		let good_ea_val = good_ea_id.val() * 1;		//=setEa
		let chkCart_idx = $("#chkCart"+idx);
		let GoodsStockType = $("input[name=GoodsStockType]").eq(idx).val();
		let GoodsStockNum = $("input[name=GoodsStockNum]").eq(idx).val() * 1;
		let intMinimum = $("input[name=intMinimum]").eq(idx).val() * 1;
		let ea = $("input[name=ea]").eq(idx).val() * 1;

		let chg_good_ea_val = 0;
		if (ud == '') chg_good_ea_val = good_ea_val;	//추가
		if (ud == 'up') chg_good_ea_val = (good_ea_val + 1);
		if (ud == 'down') chg_good_ea_val = (good_ea_val - 1);

		if(isNaN(chg_good_ea_val) == true || chg_good_ea_val == "" || chg_good_ea_val < 1) {
			if (intMinimum < 1) intMinimum = 1;
			//alert("<%=LNG_SHOP_DETAILVIEW_14%>");
			good_ea_id.val(intMinimum);
			return false;
		}

		chkintMinimumStockNum();
		chkintMinimum();
		chkStockNum();

		if (ud == '') {		//직접입력
			if (good_ea_val == ea) return false;					// 변동 없으면 멈추자!
			$("input[name=eaORG]").eq(idx).val(ea);				// ea → eaOrg
			$("input[name=setEa]").eq(idx).val(chg_good_ea_val);
			$("input[name=ea]").eq(idx).val(chg_good_ea_val);	// setEa → ea
		} else {
			$("input[name=eaORG]").eq(idx).val(good_ea_val);
			$("input[name=setEa]").eq(idx).val(chg_good_ea_val);
			$("input[name=ea]").eq(idx).val(chg_good_ea_val);
		}

		chkCart_idx.prop("checked", true);
		sumEachPrice(idx);

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
				alert("<%=LNG_SHOP_DETAILVIEW_07%>("+intMinimum+")dd");
				chg_good_ea_val = intMinimum;
			}
		}
		//2.재고비교
		function chkStockNum() {
			if (GoodsStockType == 'N' && GoodsStockNum > 0)	{
				if (chg_good_ea_val > GoodsStockNum) {
					alert("<%=LNG_SHOP_DETAILVIEW_06%>");
					chg_good_ea_val = GoodsStockNum;
				}
			}
		}

	}

	//각 상품별 합계 계산
	function sumEachPrice(idx) {
		let basePrice_val = $("input[name=basePrice]").eq(idx).val() * 1;
		let basePV_val = $("input[name=basePV]").eq(idx).val() * 1;
		let baseBV_val = $("input[name=baseBV]").eq(idx).val() * 1;
		let good_ea_val = $("input[name=setEa]").eq(idx).val() * 1;

		let result_price = formatComma(basePrice_val * good_ea_val, 3);
		let result_pv = formatComma(basePV_val * good_ea_val, 3);
		let result_bv = formatComma(baseBV_val * good_ea_val, 3);

		$("#sumEachPrice_txt"+idx).text(result_price);
		$("#sumEachPV_txt"+idx).text(result_pv);
		$("#sumEachBV_txt"+idx).text(result_bv);

		//sumAllPrice();
		ajaxEaChgCart(idx);
	}

	function ajaxEaChgCart(idx) {
		const f = document.mFrm;
		let cuidx = $("input[name=cuidx]").eq(idx).val();
		let good_ea_val = $("input[name=setEa]").eq(idx).val() * 1;
		let eaORG = $("input[name=eaORG]").eq(idx).val();
		let gIDX = $("input[name=gIDX]").eq(idx).val();
		let DELICNT = $("input[name=DELICNT]").eq(idx).val();
		let txt_DeliveryFeeEach = $("#txt_DeliveryFeeEach"+idx);		//각 배송비

		$.ajax({
			type: "POST"
			,url: "/m/shop/cart_handler_ajax.asp"		//모바일 추가,소스 정리 후 shop통합하자
			,cache : false
			//,data: formData
			,data: {
				"mode" : 'EACHG'
				,"cartIDX" : cuidx
				,"cartEa" : good_ea_val
				,"eaORG" : eaORG
				,"gIDX" : gIDX
				,"DELICNT" : DELICNT
			}
			//,async : true
			,beforeSend: function(){
				$('#loadingPro').show();
			}
			,complete : function(){
				$('#loadingPro').hide();
			}
			,success: function(data) {
				//console.log(data);
				let json = $.parseJSON(data);
				if (json.result == "success") {
					//alert(json.message);

					//배송비 표기, 배송비 재계산
					$(txt_DeliveryFeeEach).html(json.message2);
					initAmountByShopID();							//shop 금액 초기화!!!
					sumAllPrice('ALL')
					//$(".message").html(json.message+"<br /><%=LNG_SHOP_CART_JS_MOVE_TO_CART%>");
					//return false;
				}else{
					alert(json.message);
					//console.log(json.message);
					return false;
				}
			}
			,error:function(data) {
				alert("<%=LNG_AJAX_ERROR_MSG%> : "+data.status+" "+data.statusText+" "+data.responseText);
			}
		});
	}

	//판매처 결제금 상세보기
	$(function(){
		$(".shopPrices-toggle").on('click', function(eve){
				eve.preventDefault();
				$(this).toggleClass("down");
		});
	});

</script>
<!--#include virtual = "/shop/cartCalc.js.asp"-->

</head>
<body>
<!--#include virtual = "/m/_include/header.asp"-->
<div id="loadingPro">
	<div class="loadingImg"><img src="<%=IMG%>/159.gif" width="30" alt="loadingImg" /></div>
</div>
<!-- <div id="Cart" class="width100 cleft"> -->
<div id="order" class="width100">
	<!-- <div id="subTitle" class="width100 tcenter text_noline" ><%=LNG_HEADER_CART%></div> -->
	<form name="cartFrm" method="post" onsubmit="return allOrders(this);">
		<div>
			<div id="cartChk"><label><input type="checkbox" name="checklist" onClick="SelectAll()" /> <span class="checkall" ><%=LNG_CS_CART_BTN01%></span></label></div>
			<%
				If DK_MEMBER_ID <> "" Then
					cart_id = DK_MEMBER_ID
					cart_method = "MEMBER"
				Else
					cart_id = DK_MEMBER_IDX
					cart_method = "NOTMEM"
				End If

				k = 0
				arrParams = Array(_
					Db.makeParam("@cart_method",adVarChar,adParamInput,10,cart_method), _
					Db.makeParam("@MEMTYPE",adVarChar,adParamInput,50,cart_id), _
					Db.makeParam("@strNationCode",adVarChar,adParamInput,6,DK_MEMBER_NATIONCODE) _
				)
				'arrList = Db.execRsList("DKSP_CART_LIST",DB_PROC,arrParams,listLen,Nothing)
				arrList = Db.execRsList("DKP_CART_LIST",DB_PROC,arrParams,listLen,Nothing)		'기존 순서 변경(2021-10-28) arrList_GoodsContent

				If IsArray(arrList) Then
					For i = 0 To listLen
						totalOptionPrice = 0
						totalPrice = 0

						arrList_intIDX				= arrList(0,i)
						arrList_strDomain			= arrList(1,i)
						arrList_strMemID			= arrList(2,i)
						arrList_strIDX				= arrList(3,i)
						arrList_GoodIDX				= arrList(4,i)
						arrList_strOption			= arrList(5,i)
						arrList_orderEa				= arrList(6,i)
						arrList_RegistDate			= arrList(7,i)
						arrList_BintIDX				= arrList(8,i)
						arrList_Category			= arrList(9,i)
						arrList_GoodsName			= arrList(10,i)
						arrList_GoodsComment		= arrList(11,i)
						arrList_FlagVote			= arrList(12,i)
						arrList_flagBest			= arrList(13,i)
						arrList_GoodsStockNum		= arrList(14,i)
						arrList_GoodsStockType		= arrList(15,i)
						arrList_GoodsMade			= arrList(16,i)
						arrList_GoodsProduct		= arrList(17,i)
						arrList_GoodsCost			= arrList(18,i)
						arrList_GoodsPrice			= arrList(19,i)
						arrList_GoodsCustomer		= arrList(20,i)
						arrList_GoodsPoint			= arrList(21,i)
						arrList_GoodsViewTF			= arrList(22,i)
						arrList_imgThum				= arrList(23,i)
						arrList_strShopID			= arrList(24,i)
						arrList_isShopType			= arrList(25,i)
						arrList_flagNew				= arrList(26,i)
						arrList_isCSGoods			= arrList(27,i)
						arrList_GoodsDeliveryType	= arrList(28,i)
						arrList_GoodsDeliveryFee	= arrList(29,i)
						arrList_SHOPCNT				= Int(arrList(30,i))
						arrList_DELICNT				= Int(arrList(31,i))

						arrList_intPriceNot			= arrList(32,i)
						arrList_intPriceAuth		= arrList(33,i)
						arrList_intPriceDeal		= arrList(34,i)
						arrList_intPriceVIP			= arrList(35,i)
						arrList_intMinNot			= arrList(36,i)
						arrList_intMinAuth			= arrList(37,i)
						arrList_intMinDeal			= arrList(38,i)
						arrList_intMinVIP			= arrList(39,i)
						arrList_intPointNot			= arrList(40,i)
						arrList_intPointAuth		= arrList(41,i)
						arrList_intPointDeal		= arrList(42,i)
						arrList_intPointVIP			= arrList(43,i)

						arrList_isImgType			= arrList(44,i)
						arrList_imgList				= arrList(45,i)
						arrList_CSGoodsCode			= arrList(46,i)
						arrList_GoodsNote			= arrList(47,i)
						arrList_isDirect			= arrList(48,i)
						arrList_DelTF				= arrList(49,i)
						arrList_isAccept			= arrList(50,i)

						arrList_TOTAL_SHOPCNT		= arrList(51,i)	'add

						arrList_OPTIONCNT			= arrList(52,i)		'cart
						arrList_isChgGoods			= arrList(53,i)	'cart



						'##################################################################
						' 회원레벨별 상품가격 변경
						'################################################################## START
						Select Case DK_MEMBER_LEVEL
							Case 0,1 '비회원, 일반회원
								arrList_GoodsPrice = arrList_intPriceNot
								arrList_GoodsPoint = arrList_intPointNot
								arrList_intMinimum = arrList_intMinNot
							Case 2 '인증회원
								arrList_GoodsPrice = arrList_intPriceAuth
								arrList_GoodsPoint = arrList_intPointAuth
								arrList_intMinimum = arrList_intMinAuth
							Case 3 '딜러회원
								arrList_GoodsPrice = arrList_intPriceDeal
								arrList_GoodsPoint = arrList_intPointDeal
								arrList_intMinimum = arrList_intMinDeal
							Case 4,5 'VIP 회원
								arrList_GoodsPrice = arrList_intPriceVIP
								arrList_GoodsPoint = arrList_intPointVIP
								arrList_intMinimum = arrList_intMinVIP
							Case 9,10,11
								arrList_GoodsPrice = arrList_intPriceVIP
								arrList_GoodsPoint = arrList_intPointVIP
								arrList_intMinimum = arrList_intMinVIP
						End Select
						'##################################################################	END


						'##################################################################
						' 상품 재고상태 확인
						'################################################################## START
						goodsAlert = ""
						StockText = ""
						EA_Display = ""
						If arrList_DelTF = "T" Then goodsAlert = LNG_SHOP_ORDER_WISHLIST_TEXT03
						If arrList_isAccept <> "T" Then goodsAlert = LNG_SHOP_ORDER_DIRECT_06
						If arrList_GoodsViewTF <> "T" Then goodsAlert =	LNG_SHOP_ORDER_DIRECT_05
						If goodsAlert <> "" Then checkBox_Disabled = " disabled=""disabled"" "

						Select Case arrList_GoodsStockType
							Case "I" '무제한
								checkBox_Disabled = ""
								StockStatusText = ""
								StockStatusAlert = ""
							Case "N" '재고
								StockText = LNG_SHOP_CART_TXT_STOCK&":"&arrList_GoodsStockNum
								If arrList_GoodsStockNum < arrList_orderEa Then
									checkBox_Disabled = " disabled=""disabled"" "
									StockStatusText = "<span class=""icon-red"">"&LNG_SHOP_CART_TXT_NO_STOCK&"</span> "
									StockStatusAlert = LNG_SHOP_CART_TXT_OVER_STOCK &" ("&LNG_SHOP_CART_TXT_STOCK&":"&arrList_GoodsStockNum&")"
								End If
							Case "S" '품절
								checkBox_Disabled = " disabled=""disabled"" "
								StockStatusText = "<span class=""icon-red"">"&LNG_SHOP_DETAILVIEW_33&"</span> "
								StockStatusAlert = LNG_SHOP_DETAILVIEW_04
							Case Else '재고이상
								checkBox_Disabled = " disabled=""disabled"" "
								StockStatusText = "<span class=""icon-red"">"&LNG_JS_INVALID_DATA&"</span> "
								StockStatusAlert = LNG_SHOP_CART_TXT_STOCK_ERROR
						End Select

						'1.최소구매수량 확인
						intMinimumText = ""
						intMinimumAlert = ""
						If Int(arrList_orderEa) < Int(arrList_intMinimum)Then
							intMinimumText = "<span class=""icon-red"">"&LNG_SHOP_DETAILVIEW_34&"</span> "
							intMinimumAlert = LNG_SHOP_DETAILVIEW_07 &" ("&LNG_SHOP_DETAILVIEW_34&":"&arrList_intMinimum&")"
							checkBox_Disabled = " disabled=""disabled"" "
						End If
						'##################################################################	END


						'##################################################################
						' 이미지 / 아이콘정보 확인
						'################################################################## START
						If arrList_isImgType = "S" Then
							imgPath = VIR_PATH("goods/thum")&"/"&backword(arrList_imgThum)
							imgWidth = 0
							imgHeight = 0
							Call ImgInfo(imgPath,imgWidth,imgHeight,"")
							thumbMargin = 10
							imgPaddingH = (upImgHeight_Thum + thumbMargin - imgHeight) / 2
						Else
							imgPath = BACKWORD(arrList_imgThum)
							imgWidth = upImgWidths_Thum
							imgHeight = upImgHeight_Thum
							imgPaddingH = 0
						End If

						printGoodsIcon = ""

						If arrList_flagBest	= "T" Then printGoodsIcon = printGoodsIcon & "<span class=""icons"">"&viewImg(IMG_ICON&"/i_bestT.gif",31,11,"")&"</span>"
						If arrList_flagNew	= "T" Then printGoodsIcon = printGoodsIcon & "<span class=""icons"">"&viewImg(IMG_ICON&"/i_newT.gif",31,11,"")&"</span>"
						If arrList_FlagVote	= "T" Then printGoodsIcon = printGoodsIcon & "<span class=""icons"">"&viewImg(IMG_ICON&"/i_voteT.gif",31,11,"")&"</span>"
						If DK_MEMBER_TYPE = "COMPANY" Or DK_MEMBER_TYPE ="ADMIN" Then
							'If arrList_isCSGoods	= "T" Then printGoodsIcon = printGoodsIcon & "<span class=""icons"">"&viewImg(IMG_ICON&"/i_csgoodsT.gif",50,11,"")&"</span>"
						End If
						'################################################################## END

						'##################################################################
						' 루프내 가격 초기화
						'################################################################## START
							self_GoodsOptionPrice = 0
							self_PV = 0
							self_GV = 0

							sum_optionPrice = 0
						'################################################################## END


						'##################################################################
						' CS회원인 경우 PV값 / 상품판매가 확인
						'################################################################## START
						arr_CS_price4 = 0
						arr_CS_SELLCODE		= ""
						arr_CS_SellTypeName = ""
						vipPrice = 0	'COSMICO

						If arrList_isCSGoods = "T" Then
							'▣CS상품정보 변동정보 통합
								'Db.makeParam("@Na_Code",adVarChar,adParamInput,50,UCase(DK_MEMBER_NATIONCODE)), _
							arrParams = Array(_
								Db.makeParam("@ncode",adVarChar,adParamInput,20,arrList_CSGoodsCode) _
							)
							Set DKRS = Db.execRs("HJP_CSGOODS_PRICE_INFO",DB_PROC,arrParams,DB3)
							'Set DKRS = Db.execRs("HJP_CSGOODS_PRICE_INFO_GLOBAL",DB_PROC,arrParams,DB3)
							If Not DKRS.BOF And Not DKRS.EOF Then
								arr_CS_ncode		= DKRS("ncode")
								arr_CS_price		= DKRS("price")
								arr_CS_price2		= DKRS("price2")
								arr_CS_price4		= DKRS("price4")
								arr_CS_price5		= DKRS("price5")
								arr_CS_price6		= DKRS("price6")		'COSMICO VIP 가
								arr_CS_price7		= DKRS("price7")		'COSMICO 셀러 가
								arr_CS_price8		= DKRS("price8")		'COSMICO 매니저 가
								arr_CS_price9		= DKRS("price9")		'COSMICO 지점장 가
								arr_CS_price10		= DKRS("price10")	'COSMICO 본부장 가

								arr_CS_SellCode		= DKRS("SellCode")
								arr_CS_SellTypeName	= DKRS("SellTypeName")
								If arr_CS_SellTypeName <> "" Then
									arr_CS_SellTypeName = LNG_SHOP_ORDER_DIRECT_PAY_04&" : "&arr_CS_SellTypeName
								End If

								'COSMICO VIP 매출가
								Select Case nowGradeCnt
									Case "20"	vipPrice = arr_CS_price6
									Case "30"	vipPrice = arr_CS_price7
									Case "40"	vipPrice = arr_CS_price8
									Case "50"	vipPrice = arr_CS_price9
									Case "60"	vipPrice = arr_CS_price10
									Case Else vipPrice = 0
								End Select

							End If
							Call closeRs(DKRS)

							'▣ 소비자 가격
							If CONST_CS_SOBIJA_PRICE_USE_TF = "T" Then
								If DK_MEMBER_STYPE = "1" And arrList_isCSGoods = "T" Then
									arrList_GoodsPrice = arrList_GoodsCustomer
									arr_CS_price2 = arr_CS_price
								End If
							End If

							'▣ CS판매금액과 쇼핑몰등록된 CS판매금 비교
							DIFFERENT_GOODS_INFO_TXT = ""
							If arrList_isCSGoods = "T" And (arr_CS_price2 <> arrList_GoodsPrice) Then
								DIFFERENT_GOODS_INFO_TXT = "관리프로그램과 쇼핑몰 등록정보가 다릅니다.(구입불가)"
							End If

							'▣CS판매중지, 가격정보 체크
							If DIFFERENT_GOODS_INFO_TXT <> "" Or (arrList_GoodsPrice < 1) Or (arr_CS_price2 < 1) Then
								checkBox_Disabled = " disabled=""disabled"" "
							End If

						End If
						'################################################################## END


						'##################################################################
						' 옵션확인
						'################################################################## START
						arrResult = Split(CheckSpace(arrList_strOption),",")
						printOPTIONS = ""
						For j = 0 To UBound(arrResult)
							arrOption = Split(Trim(arrResult(j)),"\")
							arrOptionTitle = Split(arrOption(0),":")
							If arrOption(1) > 0 Then
								OptionPrice = " / + " & num2cur(arrOption(1)) &" "&Chg_CurrencyISO&""
							ElseIf arrOption(1) < 0 Then
								OptionPrice = "/ - " & num2cur(arrOption(1)) &" "&Chg_CurrencyISO&""
							ElseIf arrOption(1) = 0 Then
								OptionPr ice = ""
							End If

							printOPTIONS = printOPTIONS & "<span style='font-size:8pt;color:#9e9e9e;'>["&LNG_SHOP_ORDER_DIRECT_TABLE_06&"] "& arrOptionTitle(0) & " : " & arrOptionTitle(1) & OptionPrice & "</span><br />"
							sum_optionPrice = CDbl(sum_optionPrice) + CDbl(arrOption(1))
						Next
						'################################################################## END

						'##################################################################
						' 상품별 금액/적립금 확인
						'################################################################## START
						self_GoodsPrice = Int(arrList_orderEa) * CDbl(arrList_GoodsPrice)
						self_GoodsPoint = Int(arrList_orderEa) * Int(arrList_GoodsPoint)
						self_GoodsOptionPrice = Int(arrList_orderEa) * CDbl(sum_optionPrice)
						self_TOTAL_PRICE = self_GoodsPrice + self_GoodsOptionPrice
						self_PV = Int(arrList_orderEa) * Int(arr_CS_price4)
						self_GV = Int(arrList_orderEa) * Int(arr_CS_price5)
						'################################################################## END

						'##################################################################
						' 배송비 확인
						'################################################################## START
						Select Case arrList_GoodsDeliveryType
							Case "SINGLE"
								self_DeliveryFee = Int(arrList_orderEa) * CDbl(arrList_GoodsDeliveryFee)
								txt_DeliveryFeeType = LNG_SHOP_ORDER_DIRECT_TABLE_08	'단독배송
								txt_self_DeliveryFee = " "&num2cur(self_DeliveryFee)&" "&Chg_currencyISO
								txt_DeliveryFee = "<span class=""tweight"">"&txt_DeliveryFeeType& "<br />"&txt_self_DeliveryFee&"</span>"
								'mob
								txt_DeliveryCondition = ""

								'*상품별 배송비
								txt_DeliveryFeeEach = "<span class=""deliveryeach"">("&LNG_CS_ORDERS_DELIVERY_PRICE&" "&num2cur(self_DeliveryFee)&" "&Chg_currencyISO&")</span>"
								'DKRS2_intDeliveryFee = self_DeliveryFee		'BASIC_DeliveryFee
								DKRS2_intDeliveryFee = arrList_GoodsDeliveryFee		'BASIC_DeliveryFee (each)

								arrList_DELICNT = 1

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

								If arrList_DELICNT > 1 Then
									arrParams3 = Array(_
										Db.makeParam("@cart_method",adVarChar,adParamInput,10,cart_method), _
										Db.makeParam("@MEMTYPE",adVarChar,adParamInput,50,cart_id), _
										Db.makeParam("@strShopID",adVarChar,adParamInput,30,arrList_strShopID), _
										Db.makeParam("@GoodsDeliveryType",adVarChar,adParamInput,6,arrList_GoodsDeliveryType) _
									)
									arrList3 = Db.execRsList("DKSP_CART_DELIVERY_CALC",DB_PROC,arrParams3,listLen3,Nothing)
									self_TOTAL_PRICE = 0
									If IsArray(arrList3) Then
										For z = 0 To listLen3
											arrList3_GoodsPrice		= arrList3(0,z)
											arrList3_OrderEa		= arrList3(1,z)
											arrList3_strOption		= arrList3(2,z)

											'내부 옵션 가격 확인
											calc_optionPrice = 0
											arrResult3 = Split(CheckSpace(arrList3_strOption),",")

											For y = 0 To UBound(arrResult3)
												arrOption3 = Split(Trim(arrResult3(y)),"\")
												calc_optionPrice = CDbl(calc_optionPrice) + CDbl(arrOption3(1))
											Next
											self_TOTAL_PRICE = self_TOTAL_PRICE + (calc_optionPrice * arrList3_OrderEa) + (arrList3_GoodsPrice*arrList3_OrderEa)
										Next
									End If
								End If

								If self_TOTAL_PRICE >= DKRS2_intDeliveryFeeLimit Then
									self_DeliveryFee = "0"
									txt_DeliveryFeeType = LNG_SHOP_ORDER_DIRECT_TABLE_10
									txt_self_DeliveryFee = ""
								Else
									self_DeliveryFee = DKRS2_intDeliveryFee
									txt_DeliveryFeeType = ""	'LNG_SHOP_ORDER_DIRECT_TABLE_07	'선결제
									txt_self_DeliveryFee = " "&num2cur(self_DeliveryFee)&" "&Chg_currencyISO
								End If

								If UCase(DK_MEMBER_NATIONCODE) = "KR" Then
									'mob
									txt_DeliveryFee = "<span class=""tweight"">"&txt_DeliveryFeeType&txt_self_DeliveryFee&"</span>"
									txt_DeliveryCondition = "<span class=""deliverytotal"">("&num2cur(DKRS2_intDeliveryFeeLimit)&LNG_SHOP_DETAILVIEW_21&")</span>"
								Else
									'mob
									txt_DeliveryFee = "<span class=""tweight"">"&txt_DeliveryFeeType&txt_self_DeliveryFee&"</span>"
									txt_DeliveryCondition = "<span class=""deliverytotal"">"&LNG_SHOP_DETAILVIEW_21&" ("&num2cur(DKRS2_intDeliveryFeeLimit)&" "&Chg_currencyISO&")</span>"
								End If

								'*상품별 배송비
								If self_GoodsPrice >= DKRS2_intDeliveryFeeLimit Then
									txt_DeliveryFeeEach = "<span class=""deliveryeach"">("&LNG_SHOP_ORDER_DIRECT_TABLE_10&")</span>"		'무료배송
								Else
									txt_DeliveryFeeEach = "<span class=""deliveryeach"">("&LNG_CS_ORDERS_DELIVERY_PRICE&" "&num2cur(DKRS2_intDeliveryFee)&" "&Chg_currencyISO&")</span>"
								End If

						End Select
						'################################################################## END


						If arrList_ShopCNT = 1 Then
							k = 1
						Else
							If k = 0 Then
								k = 1
							Else
								k = k
							End If
						End If



						'재고Flag
						If StockStatusText <> "" Then
							txt_DeliveryFee = "-"
							txt_DeliveryFeeEach = "<span class=""tweight"">"&LNG_SHOP_DETAILVIEW_BTN_CANNOT&"<span>"
							EA_Display = "display:none;"

							If arrList_GoodsStockType = "N" And arrList_GoodsStockNum > 0 Then
								txt_DeliveryFeeEach = ""
								EA_Display = ""
							End If
						End If

						txt_DeliveryFeeEach = Replace(txt_DeliveryFeeEach,"(","")
						txt_DeliveryFeeEach = Replace(txt_DeliveryFeeEach,")","")
			%>
			<%
					'판매자명(mob)
					If k = 1 Then
						SQL = "SELECT [strComName] FROM [DK_VENDOR] WITH(NOLOCK) WHERE [strShopID] = ?"
						arrParams2 = Array(Db.makeParam("@strUserID",adVarChar,adParamInput,30,arrList_strShopID))
						txt_strComName = Db.execRsData(SQL,DB_TEXT,arrParams2,Nothing)
						If arrList_strShopID = "company" Then txt_strComName = DKCONF_SITE_TITLE

						If txt_strComName <> "" Then
							txt_strComName = "<span class=""tright font_size08em""> ("&txt_strComName&")</span>"
						End If
			%>
			<div class="cart_title b_radius_top">
				<%=LNG_SHOP_ORDER_DIRECT_TABLE_01%><%=txt_strComName%>
			</div>
			<% 	End If%>
			<%
				'판매처별 라운딩
				If arrList_ShopCNT = 1 Or arrList_ShopCNT = k Then	'마지막상품 하단 라운딩
					shopAmountResultView = "T"
					b_radius_bottom = "b_radius_bottom"
					goodsInfo_mb = ""
				Else
					shopAmountResultView = ""
					b_radius_bottom = "b_radius_bottom_0"
					goodsInfo_mb ="mb"
				End If

				sIDX = i
			%>
			<%
				attrShopIdTOT = arrList_strShopID
				'attrShopID 설정 (단독배송비 구분)
				If arrList_GoodsDeliveryType = "SINGLE" Then
					attrShopID = arrList_strShopID&"_S"&i
				Else
					attrShopID = arrList_strShopID
				End If
			%>
			<div class="goodsInfo_wrap <%=b_radius_bottom%>" id="chkboxArea<%=sIDX%>">
				<div class="goodsInfo <%=goodsInfo_mb%>">
					<div class="goodsNameArea text_noline" >
						<input type="hidden" name="mode" value="EACHG" />
						<input type="hidden" name="cuidx" value="<%=arrList_intIDX%>" readonly="readonly" />
						<input type="hidden" name="isChgGoods" value="<%=arrList_isChgGoods%>" readonly="readonly" />
						<input type="hidden" name="ea" value="<%=arrList_orderEa%>" readonly="readonly" />
						<input type="hidden" name="eaORG" value="<%=arrList_orderEa%>" readonly="readonly" />
						<input type="hidden" name="gIDX" value="<%=arrList_GoodIDX%>" readonly="readonly" />
						<input type="hidden" name="DELICNT" value="<%=arrList_DELICNT%>" readonly="readonly" />
						<input type="hidden" name="GoodsStockType" value="<%=arrList_GoodsStockType%>" />
						<input type="hidden" name="GoodsStockNum" value="<%=arrList_GoodsStockNum%>" />
						<input type="hidden" name="intMinimum" value="<%=arrList_intMinimum%>" readonly="readonly"/>

						<label class="cp">
							<input type="checkbox" name="chkCart" id="chkCart<%=i%>" <%=checkBox_Disabled%> attrCG="<%=arrList_isChgGoods%>" attrCode="<%=arr_CS_SELLCODE%>" attrShopID="<%=attrShopID%>" attrShopIdTOT="<%=attrShopIdTOT%>" value="<%=arrList_intIDX%>" onclick="sumAllPrice('<%=i%>');" />
							<span class="goodsName"><%=arrList_goodsName%></span>
						</label>
						<div class="goodDelBtnWrap">
							<a href="javascript: cartDelThis('<%=arrList_intIDX%>');" class="goodDelBtn">X</a>
						</div>
					</div>
					<div class="goodsArea" >
						<div class="goodsBox">
							<div class="ImgArea">
								<div class="" style="padding:<%=imgPaddingH%>px 0px;">
									<a href="/m/shop/detailView.asp?gidx=<%=arrList_GoodIDX%>" ><%=viewImg(imgPath,imgWidth,imgHeight,"")%></a>
								</div>
							</div>
							<div class="goodsInfoArea">
								<%If printOPTIONS <> "" Then%>
									<p class="text_noline optionTxtArea"><%=printOPTIONS%></p>
								<%Else%>
									<!-- <p class="text_noline optionTxtArea">옵션없음</p> -->
								<%End If%>
								<%If printGoodsIcon <> "" Then%>
									<!-- <p><%=printGoodsIcon%></p> -->
								<%End If%>
								<%If DIFFERENT_GOODS_INFO_TXT <> "" Then%>
									<p><%=DIFFERENT_GOODS_INFO_TXT%></p>
								<%End If%>
								<p><span class="goodsNote"><%=backword(arrList_GoodsNote)%></span></p>
								<%If DK_MEMBER_TYPE = "COMPANY" Then %>
									<p><span class="selltypeName"><%=arr_CS_SellTypeName%></span></p>
								<%End If%>

								<%'상품금액%>
								<p><span class="price"><%=num2cur(self_GoodsPrice/arrList_orderEa)%></span><span class="pUnit"><%=Chg_currencyISO%></span></p>
								<%If nowGradeCnt >= 20 And vipPrice > 0 Then 'COSMICO%>
									<p><span class="blue2 tweight"><%=LNG_VIP%></span> :  <span class="price"><%=num2cur(vipPrice)%></span><span class="pUnit"><%=Chg_currencyISO%></span></p>
								<%End If%>
								<%If PV_VIEW_TF = "T" Then%>
								<p><span class="pv"><%=num2curINT(self_PV/arrList_orderEa)%></span><span class="pvUnit"><%=CS_PV%></span></p>
								<%End If%>
								<%If BV_VIEW_TF = "T" Then%>
								<p><span class="cv"><%=num2curINT(self_GV/arrList_orderEa)%></span><span class="cvUnit"><%=CS_PV2%></span></p>
								<%End If%>
								<p id="txt_DeliveryFeeEach<%=i%>"><%=txt_DeliveryFeeEach%></p>

								<%If StockText <> "" Then	'재고%>
									<p><%=StockText%></p>
								<%End If%>
								<%If arrList_intMinimum > 1 Then	'최소구매수량%>
									<p><%=LNG_SHOP_DETAILVIEW_34%> : <%=arrList_intMinimum%></p>
								<%End If%>

								<input type="hidden" name="basePrice" value="<%=arrList_GoodsPrice%>" readonly="readonly" />
								<input type="hidden" name="basePV" value="<%=arr_CS_price4%>" readonly="readonly" />
								<input type="hidden" name="baseBV" value="<%=arr_CS_price5%>" readonly="readonly" />
								<input type="hidden" name="DeliveryType" value="<%=arrList_GoodsDeliveryType%>" readonly="readonly" />
								<input type="hidden" name="BASIC_DeliveryFeeLimit" value="<%=DKRS2_intDeliveryFeeLimit%>" readonly="readonly" />
								<input type="hidden" name="BASIC_DeliveryFee" value="<%=DKRS2_intDeliveryFee%>" readonly="readonly" />

								<p class="eaArea">
									<span class="ea_bg"><a href="javascript: eaUpDown('down','<%=sIDX%>');"  class="minus">-</a></span><input type="tel" name="setEa" id="good_ea<%=sIDX%>" value="<%=arrList_orderEa%>" class="input_text_ea vmiddle tcenter readonly" maxlength="2" onkeyup="this.value=this.value.replace(/[^0-9]/g,'');" readonly="readonly" /><span class="ea_bg"><a href="javascript: eaUpDown('up','<%=sIDX%>');" class="plus">+</a></span>
								</p>
								<%If checkBox_Disabled = "" And 1=2 Then%>
								<input type="button" class="vmiddle cartEaChg" value="<%=LNG_CS_CART_BTN04%>" onclick="chgCartEa('<%=sIDX%>');" />
								<%End If%>
							</div>
						</div>
						<div class="eachPriceInfo" style="display: none;" >
							<table <%=tableatt%> class="width100">
								<col width="" />
								<col width="" />
								<tr>
									<td class="title"><%=LNG_SHOP_ORDER_DIRECT_TABLE_04%></td>
									<td class="tright"><span id="sumEachPrice_txt<%=sIDX%>"><%=num2cur(self_GoodsPrice)%></span><span class="pUnit"><%=Chg_CurrencyISO%></span></td>
								</tr>
								<%If PV_VIEW_TF = "T" Then%>
								<tr>
									<td class="title"><%=CS_PV%></td>
									<td class="tright"><span id="sumEachPV_txt<%=sIDX%>" class="pv"><%=num2curINT(self_PV)%></span><span class="pvUnit"><%=CS_PV%></span></td>
								</tr>
								<%End If%>
								<%If BV_VIEW_TF = "T" Then%>
								<tr>
									<td class="title"><%=CS_BV%></td>
									<td class="tright"><span id="sumEachBV_txt<%=sIDX%>" class="bv"><%=num2curINT(self_GV)%></span><span class="bvUnit"><%=CS_PV2%></span></td>
								</tr>
								<%End If%>
							</table>
						</div>
					</div>
					<%
						'모바일 업체별, 단독배송 표기
						l = 0
						If arrList_DELICNT = k Or arrList_GoodsDeliveryType = "SINGLE" Then
							l = 1
						End If

						If l = 1 Then
							BUNDLE_DELIVERY_TXT = ""
							If arrList_DELICNT > 1 Then
								BUNDLE_DELIVERY_TXT = arrList_DELICNT&"건 묶음 배송비<br />"
							End If
							txt_DeliveryFee = Replace(txt_DeliveryFee,"<br />"," ")
					%>
						<!-- <div class="txt_DeliveryFee">
							<div class="inner"><span class="blue2"><%=BUNDLE_DELIVERY_TXT%></span><%=txt_DeliveryFee%></div>
						</div> -->
						<div class="txt_DeliveryFee" >
							<div class="inner">
								<%=LNG_CS_ORDERS_DELIVERY_PRICE%> : <span class="blue2"><%=BUNDLE_DELIVERY_TXT%></span>
								<span class="tweight"><span class="deliveryFeeShopClass_<%=attrShopID%>"><%=txt_DeliveryFee%></span></span> <%=txt_DeliveryCondition%>
							</div>
						</div>
						<!-- <div class="txt_DeliveryFee">
							<div class="inner">
								<%=LNG_CS_ORDERS_DELIVERY_PRICE%> : <span class="blue2"><%=BUNDLE_DELIVERY_TXT%></span>
								<span class="TOTdeliveryFeeShopID_<%=attrShopIdTOT%>_txt"><%=txt_DeliveryFee%></span>
							</div>
						</div> -->
						<input type="hidden" name="sumPriceShopID" id="sumPriceShopID_<%=attrShopID%>" value="0" readonly="readonly"/>
						<input type="hidden" name="deliveryFeeShopID" id="deliveryFeeShopID_<%=attrShopID%>" class="deliveryFeeShopID" value="0" readonly="readonly"/>
						<input type="hidden" name="orderPriceShopID" id="orderPriceShopID_<%=attrShopID%>" value="0" readonly="readonly"/>
						<input type="hidden" name="sumPvShopID" id="sumPvShopID_<%=attrShopID%>" value="0" readonly="readonly"/>
						<input type="hidden" name="sumBvShopID" id="sumBvShopID_<%=attrShopID%>" value="0" readonly="readonly"/>
					<%
						End If
					%>
					<%If shopAmountResultView = "T" Then	'업체별 주문합계%>
						<div class="eachPriceInfo total" style="display: none;" >
							<table <%=tableatt%> class="width100">
								<col width="" />
								<col width="" />
								<col width="20" />
								<tbody id="shopPrices<%=sIDX%>" onclick="toggle_shopPrices('shopPrices<%=sIDX%>')" style="display: none;" >
									<tr>
										<td class="title sub"><%=LNG_SHOP_ORDER_FINISH_09%></td>
										<td class="tright"><span class="TOTsumPriceShopID_<%=attrShopIdTOT%>_txt">0</span><span class="pUnit"><%=Chg_CurrencyISO%></span></td>
										<td class="tright"><span class="shopPrices-up"></span></td>
									</tr>
									<tr>
										<td class="title sub"><%=LNG_CS_ORDERS_DELIVERY_PRICE%></td>
										<td class="tright"><span class="TOTdeliveryFeeShopID_<%=attrShopIdTOT%>_txt">0</span><span class="pUnit"><%=Chg_CurrencyISO%></span></td>
										<td></td>
									</tr>
								</tbody>
								<tr onclick="toggle_shopPrices('shopPrices<%=sIDX%>')">
									<td class="title top"><%=LNG_CS_ORDERS_TOTAL_PRICE%></td>
									<td class="tright top_price"><span class="TOTorderPriceShopID_<%=attrShopIdTOT%>_txt">0</span><span class="pUnit"><%=Chg_CurrencyISO%></span></td>
									<td class="tright"><span class="shopPrices-down"></span></td>
								</tr>
								<%If PV_VIEW_TF = "T" Then%>
								<tr>
									<td class="title sub"><%=LNG_CS_ORDERS_TOTAL_PV%></td>
									<td class="tright"><span class="TOTsumPvShopID_<%=attrShopIdTOT%>_txt pv">0</span><span class="pvUnit"><%=CS_PV%></span></td>
									<td></td>
								</tr>
								<%End If%>
								<%If BV_VIEW_TF = "T" Then%>
								<tr>
									<td class="title sub">총 BV</td>
									<td class="tright"><span class="TOTsumBvShopID_<%=attrShopIdTOT%>_txt bv">0</span><span class="bvUnit"><%=CS_PV2%></span></td>
									<td></td>
								</tr>
								<%End If%>
							</table>
						</div>
					<%End If%>
				</div>
			</div>
			<%
						If arrList_ShopCNT = 1 Or arrList_ShopCNT = k Then
							k = 0
						Else
							k = k + 1
						End If

					Next
				Else
			%>
			<div class="noData"><%=LNG_CS_CART_TEXT08%></div>
			<%
				End If
			%>
		</div>
		<div class="cart_order">
			<a class="goshop" onclick="location.href='/m/shop/index.asp';"><%=LNG_SHOP_CART_TXT_07%></a>
			<a class="buys" onclick="selectOrder(); return false;"><%=LNG_SHOP_CART_TXT_06%></a>
		</div>

		<%If DK_MEMBER_LEVEL > 0 and 1=2 Then%>
			<div id="fix_menu" class="display-none">
				<div class="inner">
					<!-- <div class="all">
						<label class="fleft">
							<input type="checkbox" name="checklist_calc" onClick="SelectAll_calc()" />
							<span><%=LNG_CS_CART_BTN01%></span>
						</label>
					</div> -->
					<div class="sumCart">
						<!-- <div class="sumCart01">
							<span class="pStitle">건수</span>
							<span class="pISO" id="sumAllCase_txt">0</span>
							<span class="pPrice">건</span>
							<i></i>
						</div> -->
						<div class="sumCart02">
							<span class="pStitle"><%=LNG_SHOP_ORDER_FINISH_09%></span>
							<span class="pISO" id="sumAllPrice_txt">0</span>
							<span class="pPrice"><%=Chg_CurrencyISO%></span>
							<i></i>
						</div>
						<div class="priceArea sumCart02">
							<span class="pStitle sWidth"><%=LNG_CS_ORDERS_DELIVERY_PRICE%></span>
							<span class="pISO sPrice" id="sumAlldeliveryFee_txt">0</span>
							<span class="pUnit"><%=Chg_CurrencyISO%></span>
						</div>
						<div class="priceArea sumCart03" style="display: none;">
							<span class="pStitle"><%=LNG_TOTAL_PAY_PRICE%></span>
							<span class="pPriceT" id="sumAllorderPrice_txt">0</span>
							<span class="pUnit"><%=Chg_CurrencyISO%></span>
						</div>
					</div>
					<div class="sumCart sumCart03s">
						<%If PV_VIEW_TF = "T" Then%>
						<div class="sumCart03">
							<span class="pStitle"><%=LNG_CS_ORDERS_TOTAL_PV%></span>
							<span class="pISO" id="sumAllPV_txt">0</span>
							<span class="pPrice"><%=CS_PV%></span>
							<i></i>
						</div>
						<%End If%>
						<%If BV_VIEW_TF = "T" Then%>
						<div class="sumCart03">
							<span class="pStitle">총 BV</span>
							<span class="pISO" id="sumAllBV_txt">0</span>
							<span class="pPrice"><%=CS_PV2%></span>
						</div>
						<%End If%>
					</div>
					<div class="addCart">
						<!-- <label>
							<input type="button" name="" id="selectOrderBtn" onclick="javascript: selectOrder();" value="<%=LNG_TEXT_PURCHASE%>">
						</label> -->
						<label>
							<div class="selectOrderBtn" onclick="selectOrder();"><span id="selectOrderBtn"></span><%=LNG_TEXT_PURCHASE%></div>
						</label>
					</div>
				</div>
			</div>
		<%End If%>

	</form>

	<form name="dFrm" method="post" action="cart_handler.asp">
		<input type="hidden" name="mode" value="" />
		<input type="hidden" name="cartIDX" value="" />
	</form>

	<form name="mFrm" method="post" action="cart_handler.asp">
		<input type="hidden" name="mode" value="" />
		<input type="hidden" name="cartIDX" value="" />
		<input type="hidden" name="cartEa" value="" />
		<input type="hidden" name="eaORG" value="" />
		<input type="hidden" name="gIDX" value="" />
	</form>

</div>
<!--#include virtual = "/m/_include/copyright.asp"-->
