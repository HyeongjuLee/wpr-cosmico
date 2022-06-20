<%' pc/mob 공통%>
<script type="text/javascript" >

	/// fixed calc menu ///
	function sumAllPrice(thisIdx) {
		let sumAllPrice = 0;
		let sumAllCase = 0;
		const arraySellCode = [];
		const arrayShopID = [];

		//판매처별 금액
		if (thisIdx != 'ALL') {
			calcAmountByShopID(thisIdx);
		}

		//순회체크
		$("input:checkbox[name=chkCart]:checked").each(function() {
			let idx = $("input:checkbox[name=chkCart]").index(this);
			let SellCode = $(this).attr("attrCode");
			let strShopID = $(this).attr("attrShopID");

			//판매처별 금액(전체선택 시)
			if (thisIdx == 'ALL') {
				//console.log(idx);
				calcAmountByShopID(idx);
			}

			if (SellCode != "") {
				if ($.inArray(SellCode, arraySellCode) == -1) {
					arraySellCode.push(SellCode);
				}
			}
			++sumAllCase;
		});

		//동시구매 체크
		if (arraySellCode.length > 1) {
			alert("<%=LNG_CS_CART_JS04%>");
			$("#chkCart"+thisIdx).prop("checked", false);

			if(document.cartFrm.checklist.checked){
				$("input[type=checkbox]").prop("checked", false);
				calcMenuHide();
			}
			return;
		}
		//fixed 합계금 표기
		sumByShopID('sumPriceShopID_');
		sumByShopID('deliveryFeeShopID_');
		sumByShopID('orderPriceShopID_');
		sumByShopID('sumPvShopID_');
		sumByShopID('sumBvShopID_');
		$("#sumAllCase_txt").text(formatComma(sumAllCase,3));

		//모바일
		let sumAllorderPrice_txt = stripComma($("#sumAllorderPrice_txt").text()) * 1;
		let res = "<span class='sPrice'>"+sumAllCase+"</span><span class='pUnit'>" +'건 '+ "</span>";
		res = res + "<span class='sPrice'> "+formatComma(sumAllorderPrice_txt,3)+"</span><span class='pUnit'>"+' 원 '+ "</span>";
		$("#selectOrderBtn").html(res);

		$("#cate2").html("<option value=''><%=LNG_TEXT_CHOOSE_DEGREE%></option>");


		//개별체크 확인 -> 전체체크 설정
		let chkCartLength = $("input[name=chkCart]").length - $( "input[name=chkCart]:disabled").length;	//disbled제외
		if (chkCartLength != $("input[name=chkCart]:checked").length) {
			$("input[name=checklist]").prop("checked", false);
		}else{
			if (chkCartLength > 0) {
				$("input[name=checklist]").prop("checked", true);
			}
		}

		//fix_menu 전체체크연동
		if(document.cartFrm.checklist.checked) {
			$("input:checkbox[name=checklist_calc]").prop("checked", true);
		}else{
			$("input:checkbox[name=checklist_calc]").prop("checked", false);
		}

		sumAllPrice = stripComma($("#sumAllPrice_txt").text()) * 1;
		if (sumAllPrice > 0) {
			calcMenuShow();
		}else{
			calcMenuHide();
		}

		function calcMenuShow() {
			$("#fix_menu").show();
			$("#bottom_wrap").hide();
			$("#bottom_wrap2").show();  //mob
		}
		function calcMenuHide() {
			$("#fix_menu").hide();
			$("#bottom_wrap").show();
			$("#bottom_wrap2").hide();  //mob

			$("#sumAllPrice_txt").text(formatComma(0,3));
			$("#sumAllPV_txt").text(formatComma(0,3));
			$("#sumAllBV_txt").text(formatComma(0,3));
			$("#sumAllCase_txt").text(formatComma(0,3));
		}

	}

	// 판매처별 총금액 / 배송비
	function calcAmountByShopID(idx) {
		let strShopID = $("#chkCart"+idx).attr("attrShopID");	//SINGLE, BASIC 구분

		if (typeof strShopID != "undefined") {
			//상품가,PV, BV
			let basePrice_val = $("input[name=basePrice]").eq(idx).val() * 1;
			let basePV_val = $("input[name=basePV]").eq(idx).val() * 1;
			let baseBV_val = $("input[name=baseBV]").eq(idx).val() * 1;
			let good_ea_val = $("input[name=ea]").eq(idx).val() * 1;

			let sumPriceShopID = "#sumPriceShopID_"+strShopID
			let sumPvShopID = "#sumPvShopID_"+strShopID
			let sumBvShopID = "#sumBvShopID_"+strShopID
			let sumPriceShopID_val = $(sumPriceShopID).val()* 1;
			let sumPvShopID_val = $(sumPvShopID).val()* 1;
			let sumBvShopID_val = $(sumBvShopID).val()* 1;

			let self_GoodsPrice = basePrice_val * good_ea_val;
			let self_PV = basePV_val * good_ea_val;
			let self_BV = baseBV_val * good_ea_val;
			if ($("#chkCart"+idx).is(":checked") == true) {
				$(sumPriceShopID).val(sumPriceShopID_val + self_GoodsPrice);
				$(sumPvShopID).val(sumPvShopID_val + self_PV);
				$(sumBvShopID).val(sumBvShopID_val + self_BV);
			}else{
				$(sumPriceShopID).val(sumPriceShopID_val - self_GoodsPrice);
				$(sumPvShopID).val(sumPvShopID_val - self_PV);
				$(sumBvShopID).val(sumBvShopID_val - self_BV);
			}

			//배송비
			let DeliveryType = $("input[name=DeliveryType]").eq(idx).val();
			let BASIC_DeliveryFeeLimit = $("input[name=BASIC_DeliveryFeeLimit]").eq(idx).val() * 1;
			let BASIC_DeliveryFee = $("input[name=BASIC_DeliveryFee]").eq(idx).val() * 1;

			let sumPriceShopID_val_total = $(sumPriceShopID).val()* 1;	//클릭한 업체별 배송비
			let BASIC_DeliveryFee_TOTAL = 0;
			let deliveryFeeShopID = "#deliveryFeeShopID_"+strShopID;
			let deliveryFeeShopClass = ".deliveryFeeShopClass_"+strShopID;			//모바일! : 묶음배송비 / 단독배송비 표기


			if (DeliveryType == "SINGLE") {
				if (sumPriceShopID_val_total > 0) {
					BASIC_DeliveryFee = BASIC_DeliveryFee * good_ea_val;
					$(deliveryFeeShopID).val(BASIC_DeliveryFee);
					$(deliveryFeeShopClass).text('<%=LNG_SHOP_ORDER_DIRECT_TABLE_08%> '+formatComma(BASIC_DeliveryFee)+'<%=Chg_currencyISO%>');
				}else{
					$(deliveryFeeShopID).val(0);
					$(deliveryFeeShopClass).text(0);
				}
			}
			if (DeliveryType == "BASIC") {
				if (sumPriceShopID_val_total >= BASIC_DeliveryFeeLimit) {
					$(deliveryFeeShopID).val(0);
					$(deliveryFeeShopClass).text('<%=LNG_SHOP_ORDER_DIRECT_TABLE_10%>');
				}else{
					if (sumPriceShopID_val_total < 1) {
						$(deliveryFeeShopID).val(0);
						$(deliveryFeeShopClass).text('<%=LNG_SHOP_ORDER_DIRECT_TABLE_10%>');
					}else{
						BASIC_DeliveryFee_TOTAL += parseFloat(BASIC_DeliveryFee);
						$(deliveryFeeShopID).val(BASIC_DeliveryFee_TOTAL);
						$(deliveryFeeShopClass).text(formatComma(BASIC_DeliveryFee_TOTAL)+'<%=Chg_currencyISO%>');
					}
				}
			}

			//총 상품금액(상품가+배송비)
			let getSumPriceShopID_val = $(sumPriceShopID).val()* 1;
			let getDeliveryFeeShopID_val = $(deliveryFeeShopID).val()* 1;
			$("#orderPriceShopID_"+strShopID).val(getSumPriceShopID_val + getDeliveryFeeShopID_val);

			//업체별 총 금액, 총 배송비, 총pv(SINGLE + BASIC)
			let TOTShopID = $("#chkCart"+idx).attr("attrShopIdTOT");		//업체별 shopID
			//console.log(TOTShopID);
			sumByShopID('sumPriceShopID_'+TOTShopID);
			sumByShopID('deliveryFeeShopID_'+TOTShopID);
			sumByShopID('orderPriceShopID_'+TOTShopID);
			sumByShopID('sumPvShopID_'+TOTShopID);
			sumByShopID('sumBvShopID_'+TOTShopID);
		}

	}

	//업체별 금액 계산 초기화
	function initAmountByShopID(strShopID) {
		if (typeof strShopID != "undefined") {
			$("#sumPriceShopID_"+strShopID).val(0);
			$("#deliveryFeeShopID_"+strShopID).val(0);
			$("#orderPriceShopID_"+strShopID).val(0);
			$("#sumPvShopID_"+strShopID).val(0);
		}else{
			//[mob] ajaxEaChgCart success
			$("input[name=sumPriceShopID").val(0);
			$("input[name=deliveryFeeShopID").val(0);
			$("input[name=orderPriceShopID").val(0);
			$("input[name=sumPvShopID").val(0);
			$("input[name=sumBvShopID").val(0);
			$('.sumCartShop .pPrice').text(0);

			//class초기화
			$("span[class^=TOTsumPriceShopID_]").text(0);
			$("span[class^=TOTdeliveryFeeShopID_]").text(0);
			$("span[class^=TOTorderPriceShopID_]").text(0);
			$("span[class^=TOTsumPvShopID_]").text(0);
			$("span[class^=TOTsumBvShopID_]").text(0);
		}
	}

	//업체별 금액 계산, 총 금액 계산
	function sumByShopID(ids) {
		let sum = 0;
		$('input[id^="'+ids+'"]').each(function() {
			if(isNaN(parseFloat(this.value))) return 0;
			sum += parseFloat(this.value);
		});
		//업체별 총금액 표기
		$(".TOT"+ids+'_txt').text(formatComma(sum,3));

		//fixed 전체 총 금액 표기
		if (ids == 'sumPriceShopID_') $("#sumAllPrice_txt").text(formatComma(sum,3));
		if (ids == 'deliveryFeeShopID_') $("#sumAlldeliveryFee_txt").text(formatComma(sum,3));
		if (ids == 'orderPriceShopID_') $("#sumAllorderPrice_txt").text(formatComma(sum,3));
		if (ids == 'sumPvShopID_') $("#sumAllPV_txt").text(formatComma(sum,3));
		if (ids == 'sumBvShopID_') $("#sumAllBV_txt").text(formatComma(sum,3));
	}


	function SelectAll_calc() {
		$('input:checkbox[name=checklist]').trigger('click');
	}

	//BFCache로 브라우저가 로딩될 경우 혹은 브라우저 뒤로가기 했을 경우
	window.onpageshow = function(event) {
		if (event.persisted) {
			//window.location.reload();
		}
	}
	/*
	if ($("input:checkbox[name=chkCart]:checked").length < 1) {
		initAmountByShopID();
	}
	*/
</script>
