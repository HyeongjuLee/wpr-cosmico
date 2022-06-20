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
	Set DKRS = Db.execRs("DKP_GOODS_DETAILVIEW_E",DB_PROC,arrParams,Nothing)		'자체상품
	'Set DKRS = Db.execRs("DKP_GOODS_DETAILVIEW",DB_PROC,arrParams,Nothing)
	If Not DKRS.BOF And Not DKRS.EOF Then
		DKRS_intIDX				= DKRS("intIDX")
		DKRS_IMG1				= backword(DKRS("Img1Ori"))
		DKRS_IMG2				= backword(DKRS("Img2Ori"))
		DKRS_IMG3				= backword(DKRS("Img3Ori"))
		DKRS_IMG4				= backword(DKRS("Img4Ori"))
		DKRS_IMG5				= backword(DKRS("Img5Ori"))

		DKRS_flagBest			= DKRS("flagBest")
		DKRS_flagNew			= DKRS("flagNew")
		DKRS_flagVote			= DKRS("flagVote")

		DKRS_GoodsName			= DKRS("GoodsName")
		DKRS_GoodsComment		= DKRS("GoodsComment")


		DKRS_GoodsCustomer		= DKRS("GoodsCustomer")
		DKRS_GoodsPrice			= DKRS("GoodsPrice")
		DKRS_GoodsPoint			= DKRS("GoodsPoint")
		DKRS_MADE				= DKRS("GoodsMade")
		DKRS_PRODUCT			= DKRS("GoodsProduct")
		DKRS_BRAND				= DKRS("GoodsBrand")
		DKRS_MODEL				= DKRS("GoodsModels")
		DKRS_DATE				= DKRS("GoodsDate")

		DKRS_OPTIONVAL			= DKRS("OptionVal")

		DKRS_GOODSCONTENT		= DKRS("GoodsContent")

		DKRS_GOODSBANNER		= DKRS("GoodsBanner")
		DKRS_GoodsStockType		= DKRS("GoodsStockType")
		DKRS_GoodsStockNum		= DKRS("GoodsStockNum")

		DKRS_isCSGoods			= DKRS("isCSGoods")
		DKRS_CSGoodsCode		= DKRS("CSGoodsCode")

		DKRS_IMG_RELATION		= DKRS("ImgRelation")

		DKRS_isViewMemberNot	= DKRS("isViewMemberNot")
		DKRS_isViewMemberAuth	= DKRS("isViewMemberAuth")
		DKRS_isViewMemberDeal	= DKRS("isViewMemberDeal")
		DKRS_isViewMemberVIP	= DKRS("isViewMemberVIP")

		DKRS_intPriceNot		= DKRS("intPriceNot")
		DKRS_intPriceAuth		= DKRS("intPriceAuth")
		DKRS_intPriceDeal		= DKRS("intPriceDeal")
		DKRS_intPriceVIP		= DKRS("intPriceVIP")

		DKRS_intMinNot			= DKRS("intMinNot")
		DKRS_intMinAuth			= DKRS("intMinAuth")
		DKRS_intMinDeal			= DKRS("intMinDeal")
		DKRS_intMinVIP			= DKRS("intMinVIP")

		DKRS_intPointNot		= DKRS("intPointNot")
		DKRS_intPointAuth		= DKRS("intPointAuth")
		DKRS_intPointDeal		= DKRS("intPointDeal")
		DKRS_intPointVIP		= DKRS("intPointVIP")



		DKRS_GoodsDeliveryType		= DKRS("GoodsDeliveryType")
		DKRS_GoodsDeliveryFee		= DKRS("GoodsDeliveryFee")
		DKRS_GoodsDeliveryLimit		= DKRS("GoodsDeliveryLimit")
		DKRS_GoodsDeliPolicyType	= DKRS("GoodsDeliPolicyType")
		DKRS_GoodsDeliPolicy		= DKRS("GoodsDeliPolicy")

		DKRS_strShopID				= DKRS("strShopID")
		DKRS_isShopType				= DKRS("isShopType")

		DKRS_strNationCode			= DKRS("strNationCode")


		Select Case DK_MEMBER_LEVEL
			Case 0,1 '비회원, 일반회원
				DKRS_GoodsPrice = DKRS_intPriceNot
				DKRS_GoodsPoint = DKRS_intPointNot
			Case 2 '인증회원
				DKRS_GoodsPrice = DKRS_intPriceAuth
				DKRS_GoodsPoint = DKRS_intPointAuth
			Case 3 '딜러회원
				DKRS_GoodsPrice = DKRS_intPriceDeal
				DKRS_GoodsPoint = DKRS_intPointDeal
			Case 4,5 'VIP 회원
				DKRS_GoodsPrice = DKRS_intPriceVIP
				DKRS_GoodsPoint = DKRS_intPointVIP
			Case 9,10,11
				DKRS_GoodsPrice = DKRS_intPriceVIP
				DKRS_GoodsPoint = DKRS_intPointVIP
		End Select




	Else
		Call ALERTS(LNG_SHOP_DETAILVIEW_01,"BACK","")
	End If

	Call closeRs(DKRS)


	If DKRS_strNationCode <> DK_MEMBER_NATIONCODE Then Call ALERTS(LNG_ALERT_WRONG_ACCESS,"BACK","")	'▣국가코드, 상품국가코드 비교


	If DKRS_isCSGoods = "T" Then
		'▣CS상품사용여부체크
		isUseCSGoods_CNT = 0
		SQLCS = "SELECT COUNT(*) FROM [tbl_Goods] WHERE [GoodUse] = 0 AND [ncode] = ? "
		arrParamsCS = Array(_
			Db.makeParam("@ncode",adVarchar,adParamInput,20,DKRS_CSGoodsCode) _
		)
		isUseCSGoods_CNT = Db.execRsData(SQLCS,DB_TEXT,arrParamsCS,DB3)
		If isUseCSGoods_CNT = 0 Then
			isUseCSGoods_TXT = "<span class=""red tweight""> "&LNG_SHOP_DETAILVIEW_01&" (CS)</span>"
		Else
			isUseCSGoods_TXT = ""
		End If
	End If


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





	If DKRS_flagBest	= "T" Then flagBest		= viewImg(M_IMG&"/i_bestT.gif",31,11,"")&"<br />"
	If DKRS_flagNew		= "T" Then flagNew		= viewImg(M_IMG&"/i_newT.gif",31,11,"")&"<br />"
	If DKRS_flagVote	= "T" Then FlagVote		= viewImg(M_IMG&"/i_voteT.gif",31,11,"")&"<br />"
	If DKRS_isCSGoods	= "T" Then FlagCS		= viewImg(M_IMG&"/i_csgoodsT.gif",50,11,"")&"<br />"

'현재 옵션 사용 안함

	If DKRS_OPTIONVAL = "T" Then
		SQL = "SELECT * FROM [DK_GOODS_OPTION] WHERE [GoodsIDX] = ? AND [isUse] = 'T' ORDER BY [sort] ASC"
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


'	If DK_MEMBER_LEVEL < 1 Then
'		DKRS_GoodsCustomer = 0
'		DKRS_GoodsPrice = 0
'	End If

%>
<!--#include virtual = "/m/_include/document.asp"-->
<!--#include virtual = "/m/_include/jqueryload.asp"-->
<link rel="stylesheet" type="text/css" href="shop.css" />
<script type="text/javascript" src="/m/js/check.js"></script>
<script type="text/javascript">

	//총 주문금액
	$(document).ready(function() {
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
		//alert("현재 상품이 품절입니다.");
		alert("<%=LNG_SHOP_DETAILVIEW_JS_SOLDOUT%>");
	}
	function wishGo(idx) {
		var f = document.cartFrm;
		var i, len;
		<%if DKRS_GoodsStockType = "S" then%>
			//alert("품절된 상품입니다");
			alert("<%=LNG_SHOP_DETAILVIEW_04%>");
			return;
		<%end if%>
		<%if DKRS_GoodsStockType = "N" and DKRS_GoodsStockNum = 0 then%>
			//alert("재고가 없는 상품입니다");
			alert("<%=LNG_SHOP_DETAILVIEW_05%>");
			return;
		<%end if%>
		<%if DKRS_GoodsStockType = "N" and DKRS_GoodsStockNum <> 0 then%>
			if (f.ea.value > <%=DKRS_GoodsStockNum%>)
			{
				//alert("주문수량이 재고 수량보다 많습니다.");
				alert("<%=LNG_SHOP_DETAILVIEW_06%>");
				f.ea.focus();
				return;
			}
		<%end if%>
		<%if DKRS_intMinimum > 0 THEN%>
			if (f.ea.value < <%=DKRS_intMinimum%>)
			{
				//alert("주문수량이 최소구매수량 보다 적습니다.");
				alert("<%=LNG_SHOP_DETAILVIEW_07%>");
				f.ea.focus();
				return;
			}
		<%END IF%>

		<%IF DK_MEMBER_ID <> "GUEST" THEN%>
		//if (confirm('이 상품을 찜바구니에 담으시겠습니까?'))
		if (confirm("<%=LNG_SHOP_DETAILVIEW_JS_TO_WISHLIST%>"))
		{
			$.ajax({
				type: "POST"
				,url: "wishlist_add.asp"
				,data: {
					"goodsIDX"		: idx
				}
				,success: function(data) {
					//alert(data);
					if (data == 'ADD'){
						//if (confirm('상품이 추가되었습니다. 찜바구니로 이동하시겠습니까?'))
						if (confirm('<%=LNG_SHOP_DETAILVIEW_JS_MOVE_TO_WISHLIST%>'))
						{
							document.location.href='wishlist.asp';
						}
					} else if (data == 'ERROR'){
						//alert('동작 처리 중 에러가 발생하였습니다.');
						alert('<%=LNG_SHOP_DETAILVIEW_JS_ERROR%>');
					} else {
						//if (confirm('이미 등록된 상품입니다. 찜바구니로 이동하시겠습니까?'))
						if (confirm('<%=LNG_SHOP_DETAILVIEW_JS_ALREADY_REGISTED%>'))
						{
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
			//if (confirm('찜바구니는 회원 전용 기능입니다. 로그인 하시겠습니까?'))
			if (confirm('<%=LNG_SHOP_DETAILVIEW_10%>'))
			{
				document.location.href = '/m/common/member_login.asp';
			}
		<%END IF%>
	}

	$(document).on("keyup","input[name=ea]",function () {
		let good_ea_id = 	$(this);
		let good_ea_val = parseInt(good_ea_id.val());

		if(isNaN(good_ea_val) == true || good_ea_val == "" || good_ea_val < 1) {
			good_ea_id.val(1);
			return false;
		}
		<%if DKRS_GoodsStockType = "N" and DKRS_GoodsStockNum <> 0 then%>
			if (good_ea_val > <%=DKRS_GoodsStockNum%>)	{
				alert("<%=LNG_SHOP_DETAILVIEW_06%>");
				good_ea_id.val(1);
			}
		<%end if%>
		sumPrice();
	});

	function eaUpDown(unitNum,ud) {
		let good_ea_id = $("input[name=ea]");
		let good_ea_val = parseInt(good_ea_id.val());
		if (ud == 'up') {
			<%if DKRS_GoodsStockType = "N" and DKRS_GoodsStockNum <> 0 then%>
				if (good_ea_val + unitNum > <%=DKRS_GoodsStockNum%>)
				{
					alert("<%=LNG_SHOP_DETAILVIEW_06%>");
					good_ea_id.focus();
					return false;
				}
			<%end if%>
			good_ea_id.val(good_ea_val + unitNum);
		}
		if (ud == 'down') {
			if ((good_ea_val - unitNum) <= 0) {
				alert("<%=LNG_SHOP_DETAILVIEW_14%>");
				good_ea_id.val(1);
			}else{
				good_ea_id.val(good_ea_val - unitNum);
			}
		}
		sumPrice();
	}

	function sumPrice(){
		let f = document.cartFrm;
		basePrice_val	= $("#basePrice").val();
		basePV_val = $("#basePV").val();
		good_ea_val		= f.ea.value;

		let sumPrice = formatComma(parseInt(basePrice_val) * parseInt(good_ea_val),3) ;
		let sumPV = formatComma(parseInt(basePV_val) * parseInt(good_ea_val),3) ;
		$("#sumPrice_txt").text(sumPrice);
		$("#sumPV_txt").text(sumPV);
	}


	function cartADD() {
		var f = document.cartFrm;
		var i, len;
		<%if DKRS_GoodsStockType = "S" then%>
			//alert("품절된 상품입니다");
			alert("<%=LNG_SHOP_DETAILVIEW_04%>");
			return;
		<%end if%>
		<%if DKRS_GoodsStockType = "N" and DKRS_GoodsStockNum = 0 then%>
			//alert("재고가 없는 상품입니다");
			alert("<%=LNG_SHOP_DETAILVIEW_05%>");
			return;
		<%end if%>
		<%if DKRS_GoodsStockType = "N" and DKRS_GoodsStockNum <> 0 then%>
			if (f.ea.value > <%=DKRS_GoodsStockNum%>)
			{
				//alert("주문수량이 재고 수량보다 많습니다.");
				alert("<%=LNG_SHOP_DETAILVIEW_06%>");
				f.ea.focus();
				return;
			}
		<%end if%>


		<%if DKRS_intMinimum > 0 THEN%>
			if (f.ea.value < <%=DKRS_intMinimum%>)
			{
				//alert("주문수량이 최소구매수량 보다 적습니다.");
				alert("<%=LNG_SHOP_DETAILVIEW_07%>");
				f.ea.focus();
				return;
			}
		<%END IF%>
		if (f.Gidx.value == "")
		{
			//alert("상품고유값이 없습니다. 새로고침 혹은 사이트를 재접속 해주시기 바랍니다");
			alert("<%=LNG_SHOP_DETAILVIEW_08%>");
			return;
		}
		if (chkEmpty(f.ea)||f.ea.value=="0")
		{
			//alert("제품 주문수량을 입력해주세요.")
			alert("<%=LNG_SHOP_DETAILVIEW_09%>");
			f.ea.focus();
			return;
		}
		<%if DK_MEMBER_LEVEL < 1 THEN%>
			 //var msg = "회원전용 기능입니다. 로그인하시겠습니까?";
			var msg = "<%=LNG_SHOP_DETAILVIEW_10%>";
			if(confirm(msg)){
				document.location.href="/m/common/member_login.asp?backURL=<%=ThisPageURL%>";
				return;
			}else{
				return;
			}
		<%END IF%>
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
						return;
					}
				}
			<%ELSE%>
				if (f.goodsOption.value == ""){
					//alert("옵션값을 선택해 주세요.");
					alert("<%=LNG_SHOP_DETAILVIEW_12%>");
					f.goodsOption.focus();
					return;
				}
			<%END IF%>
		<%end if%>

		<%IF DK_MEMBER_TYPE = "SELLER" THEN%>
			//alert("판매자 아이디로는 구입할 수 없습니다.");
			alert("<%=LNG_SHOP_DETAILVIEW_13%>");
			return;
		<%else%>
		//***이미 담긴 장바구니 수량과 현재 주문갯수 합쳐서 재고량과 비교하는 부분 추가해야함.
			var f = document.cartFrm;
			f.mode.value = "ADD";
			const formData = $("#cartFrm").serialize();
			$.ajax({
				type: "POST"
				,url: "/shop/cartOk_ajax.asp"
				,cache : false
				,data: formData
				,async : false
				,success: function(data) {
					//console.log(data);
					let json = $.parseJSON(data);
					if (json.result == "success") {
						$(".message").html(json.message+"<br /><%=LNG_SHOP_CART_JS_MOVE_TO_CART%>");
						//$(".dialog-confirm").click();
						//return false;

						quickCart(json.message+"\n\n<%=LNG_SHOP_CART_JS_MOVE_TO_CART%>");
						return false;
					}else{
						alert(json.message);
						return false;
					}
				}
				,error:function(data) {
					alert("<%=LNG_AJAX_ERROR_MSG%> : "+data.status+" "+data.statusText+" "+data.responseText);
				}
			});

		//f.mode.value = "ADD";
		//f.target = "_self";
		//f.action = "/m/shop/cart_handler.asp";
		//f.submit();
		<%END IF%>

	}

	function quickCart(message) {
		if(confirm(message)){
			location.href='cart.asp';
		} else {
			return false;
		}
	}


	function directOrder() {
		var f = document.cartFrm;
		var i, len;
		<%if DKRS_GoodsStockType = "S" then%>
			//alert("품절된 상품입니다");
			alert("<%=LNG_SHOP_DETAILVIEW_04%>");
			return;
		<%end if%>
		<%if DKRS_GoodsStockType = "N" and DKRS_GoodsStockNum = 0 then%>
			//alert("재고가 없는 상품입니다");
			alert("<%=LNG_SHOP_DETAILVIEW_05%>");
			return;
		<%end if%>
		<%if DKRS_GoodsStockType = "N" and DKRS_GoodsStockNum <> 0 then%>
			if (f.ea.value > <%=DKRS_GoodsStockNum%>)
			{
				//alert("주문수량이 재고 수량보다 많습니다.");
					alert("<%=LNG_SHOP_DETAILVIEW_06%>");
				f.ea.focus();
				return;
			}
		<%end if%>


		<%if DKRS_intMinimum > 0 THEN%>
			if (f.ea.value < <%=DKRS_intMinimum%>)
			{
				//alert("주문수량이 최소구매수량 보다 적습니다.");
				alert("<%=LNG_SHOP_DETAILVIEW_07%>");
				f.ea.focus();
				return;
			}
		<%END IF%>
		if (f.Gidx.value == "")
		{
			//alert("상품고유값이 없습니다. 새로고침 혹은 사이트를 재접속 해주시기 바랍니다");
			alert("<%=LNG_SHOP_DETAILVIEW_08%>");
			return;
		}
		if (chkEmpty(f.ea)||f.ea.value=="0")
		{
			//alert("제품 주문수량을 입력해주세요.")
			alert("<%=LNG_SHOP_DETAILVIEW_09%>")
			f.ea.focus();
			return;
		}
		<%if DK_MEMBER_LEVEL < 1 THEN%>
			 //var msg = "회원전용 기능입니다. 로그인하시겠습니까?";
			var msg = "<%=LNG_SHOP_DETAILVIEW_10%>";
			if(confirm(msg)){
				document.location.href="/m/common/member_login.asp?backURL=<%=ThisPageURL%>";
				return;
			}else{
				return;
			}
		<%END IF%>
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
						return;
					}
				}
			<%ELSE%>
				if (f.goodsOption.value == ""){
					//alert("옵션값을 선택해 주세요.");
					alert("<%=LNG_SHOP_DETAILVIEW_12%>");
					f.goodsOption.focus();
					return;
				}
			<%END IF%>
		<%end if%>

		<%IF DK_MEMBER_TYPE = "SELLER" THEN%>
			//alert("판매자 아이디로는 구입할 수 없습니다.");
			alert("<%=LNG_SHOP_DETAILVIEW_13%>");
			return;
		<%else%>
		f.target = "_self";
		//f.action = "/m/shop/order_direct.asp";
		f.action = "/m/shop/cart_direct.asp";//주문통합
		f.submit();
		<%END IF%>



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
		<input type="hidden" name="mode" value="" />
		<input type="hidden" name="strShopID" value="<%=DKRS_strShopID%>" />
		<input type="hidden" name="isShopType" value="<%=DKRS_isShopType%>" />
		<input type="hidden" name="GoodsDeliveryType" value="<%=DKRS_GoodsDeliveryType%>" />

		<div class="goodsImg">
			<img src="<%=VIR_PATH("goods/img1")%>/<%=DKRS_IMG1%>" width="100%" alt="" />
		</div>
		<div class="goodsTitle">
			<h2><%=DKRS_GoodsName%></h2>
			<p class="goodsNote"><%=DKRS_GoodsComment%></p>
		</div>
		<%
			If DKRS_isCSGoods = "T" Then
				'▣CS상품정보
				arrParams = Array(_
					Db.makeParam("@ncode",adVarChar,adParamInput,20,DKRS_CSGoodsCode) _
				)
				Set DKRS = Db.execRs("HJP_CSGOODS_PRICE_INFO",DB_PROC,arrParams,DB3)
				If Not DKRS.BOF And Not DKRS.EOF Then
					RS_ncode		= DKRS("ncode")
					RS_price		= DKRS("price")				'소비자가
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

		<%
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


			'할인율 표시
			DisCountPercent = 100 - Round((DKRS_GoodsPrice/DKRS_GoodsCustomer) * 100)
			If DisCountPercent > 0 Then
				DisCountPercent_view = "<div class=""sale""><span>"&DisCountPercent&"</span>%</div>"
			End If
		%>


		<div class="goodsTxt">
			<%If DKRS_isCSGoods = "T" And (RS_price2 <> DKRS_GoodsPrice) Then%>
				<li><span><%=LNG_SHOP_DETAILVIEW_JS_DIFFERENT_PRICE%><%=isUseCSGoods_TXT%></li>
			<%Else%>
				<div class="flags">
					<%=flagBest%><%=flagNew%><%=FlagVote%><%=FlagCS%>
				</div>
				<!-- <div class="price-summary">
					<%=DisCountPercent_view%>
					<div class="customer">
						<span><strong><%=num2cur(DKRS_GoodsPrice)%></strong><%=Chg_CurrencyISO%></span>
					</div>
					<div class="default">
						<span><strong><%=num2cur(DKRS_GoodsCustomer)%></strong><%=Chg_CurrencyISO%></span>
					</div>
				</div> -->
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
					<%If PV_VIEW_TF = "T" Then%>
					<li class="price-cs">
						<h6><%=CS_PV%></h6>
						<span><strong><%=num2curINT(RS_price4)%></strong><%=CS_PV%></span>
					</li>
						<%If RS_SellTypeName <> "" Then%>
						<li class="price-type">
							<h6><%=LNG_TEXT_SALES_TYPE%></h6>
							<span><%=RS_SellTypeName%></span>
						</li>
						<%End If%>
					<%End If%>
				</ul>
			<%End If%>

		<%=PrintOption%>
		<input type="hidden" name="basePrice" id="basePrice" value="<%=viewPrice%>" readonly="readonly" />
		<input type="hidden" name="basePV" id="basePV" value="<%=viewPV%>" readonly="readonly" />

			<ul class="fee">
				<li class="fee-delivery">
					<h6><%=LNG_SHOP_DETAILVIEW_18%></h6><!-- 배송비 -->
					<div>
						<!--
						<%If DKRS_GoodsDeliveryType = "SINGLE" Then%><span class="tweight"><%=num2cur(DKRS_GoodsDeliveryFee)%></span> 원 (묶음배송 안됨)<%End If%>
						<%If DKRS_GoodsDeliveryType = "AFREE" Then%><span class="tweight purple">무료배송 상품</span><%End If%> -->
						<%If DKRS_GoodsDeliveryType = "SINGLE" Then%><span class="tweight"><%=num2cur(DKRS_GoodsDeliveryFee)%></span> <%=Chg_CurrencyISO%>&nbsp;<%=LNG_SHOP_DETAILVIEW_19%><%End If%>
						<%If DKRS_GoodsDeliveryType = "AFREE" Then%><span class="tweight purple"><%=LNG_SHOP_DETAILVIEW_20%></span><%End If%>
						<%
							If DKRS_GoodsDeliveryType = "BASIC" Then

								arrParams2 = Array(_
									Db.makeParam("@strNationCode",adVarChar,adParamInput,6,LANG) _
								)
								Set DKRS2 = DB.execRs("HJP_GLOBAL_DELIVERY_FEE_VIEW",DB_PROC,arrParams2,Nothing) 'DKPA_DELIVEY_FEE_VIEW
								If Not DKRS2.BOF And Not DKRS2.EOF Then
									DKRS2_intDeliveryFee			= DKRS2("intDeliveryFee")
									DKRS2_intDeliveryFeeLimit		= DKRS2("intDeliveryFeeLimit")

									If DKRS2_intDeliveryFee = 0 Then
										PRINT "<span class=""free"">"&LNG_SHOP_ORDER_DIRECT_TABLE_10&"</span>"		'무료배송
									Else
										If UCase(DK_MEMBER_NATIONCODE) = "KR" Then
											PRINT "<span><strong>" & num2curINT(DKRS2_intDeliveryFee) & Chg_CurrencyISO & "</strong></span>"
											PRINT "<span>" & num2curINT(DKRS2_intDeliveryFeeLimit)&LNG_SHOP_DETAILVIEW_21 & "</span>"
										Else
											PRINT "<span><strong>" & num2curINT(DKRS2_intDeliveryFee) & Chg_CurrencyISO & "</strong></span>"
											PRINT "<span>" & LNG_SHOP_DETAILVIEW_21&num2curINT(DKRS2_intDeliveryFeeLimit)&Chg_CurrencyISO & "</span>"
										End If
									End If

								Else
									Response.Write LNG_SHOP_DETAILVIEW_22
								End If
								Call closeRS(DKRS2)

							''	arrParams2 = Array(_
							''		Db.makeParam("@strShopID",adVarChar,adParamInput,30,DKRS_strShopID) _
							''	)
							''	Set DKRS2 = DB.execRs("DKP_DELIVERY_FEE_VIEW",DB_PROC,arrParams2,Nothing) 'DKPA_DELIVEY_FEE_VIEW
							''	If Not DKRS2.BOF And Not DKRS2.EOF Then
							''		DKRS2_FeeType			= DKRS2("FeeType")
							''		DKRS2_intFee			= DKRS2("intFee")
							''		DKRS2_intLimit			= DKRS2("intLimit")
							''
							''		'PRINT printDeli(DKRS2_FeeType)
							''		If  LCase(DKRS2_FeeType) <> "free" Then
							''			'PRINT num2cur(DKRS2_intFee) & "원 <span class=""price3"">("&num2cur(DKRS2_intLimit) &"원 이상 무료배송)</span>"
							''			PRINT num2cur(DKRS2_intFee) & Chg_CurrencyISO&" ("&LNG_SHOP_DETAILVIEW_21&num2cur(DKRS2_intLimit) &" "&Chg_CurrencyISO&")"
							''		End If
							''	Else
							''		'Response.Write "(기본배송비정책이 입력되지 않았습니다)"
							''		Response.Write LNG_SHOP_DETAILVIEW_22
							''	End If
							''	Call closeRS(DKRS2)

							End If
						%>

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
						<a href="javascript:eaUpDown(1,'down');" class="minus"><i class="icon-minus-1"></i></a>
						<input type="tel" name="ea" value="<%=ThisMins%>" <%=onlyKeys%> />
						<a href="javascript:eaUpDown(1,'up');" class="plus"><i class="icon-plus-1"></i></a>
					</span>
				</li>
				<li class="fee-total">
					<h6><%=LNG_TOTAL_PAY_PRICE%></h6>
					<div>
						<span><strong id="sumPrice_txt"><%=num2cur(viewPrice)%></strong><i><%=Chg_CurrencyISO%></i></span>
						<span><strong id="sumPV_txt"><%=num2curINT(RS_price4)%></strong><i><%=CS_PV%></i></span>
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