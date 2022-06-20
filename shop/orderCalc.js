
	/* order, order_finish 공통 */

	$(document).ready(function() {
		sumAllPrice();			//  → order.bottom.js   chgDelivery 하단 추가(업체별 택배수령, 현장수령 배송비 변경)
	});

	//판매처별 금액계산
	function sumAllPrice() {
		$("input[name=shopIdTOT]").each(function() {
			let idx = $("input[name=shopIdTOT]").index(this);
			calcAmountByShopID(idx);
		});
	}

	// 판매처별 총금액 / 배송비
	function calcAmountByShopID(idx) {
		let strShopID = $("#shopIdTOT"+idx).attr("attrShopID");	//SINGLE, BASIC 구분

		if (typeof strShopID != "undefined") {
			//상품가,PV
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

			
			//장바구니 상품체크시 실시간 계산 사용			
			$(sumPriceShopID).val(sumPriceShopID_val + self_GoodsPrice);
			$(sumPvShopID).val(sumPvShopID_val + self_PV);
			$(sumBvShopID).val(sumBvShopID_val + self_BV);


			//배송비
			let DeliveryType = $("input[name=DeliveryType]").eq(idx).val();
			let BASIC_DeliveryFeeLimit = $("input[name=BASIC_DeliveryFeeLimit]").eq(idx).val() * 1;
			let BASIC_DeliveryFee = $("input[name=BASIC_DeliveryFee]").eq(idx).val() * 1;

			let sumPriceShopID_val_total = $(sumPriceShopID).val()* 1;	//클릭한 업체별 배송비
			let BASIC_DeliveryFee_TOTAL = 0;
			let deliveryFeeShopID = "#deliveryFeeShopID_"+strShopID;

			if (DeliveryType == "SINGLE") {
				if (sumPriceShopID_val_total > 0) {
					BASIC_DeliveryFee = BASIC_DeliveryFee * good_ea_val;
					$(deliveryFeeShopID).val(BASIC_DeliveryFee);
				}else{
					$(deliveryFeeShopID).val(0);
				}
			}
			if (DeliveryType == "BASIC") {
				if (sumPriceShopID_val_total >= BASIC_DeliveryFeeLimit) {
					$(deliveryFeeShopID).val(0);
				}else{
					if (sumPriceShopID_val_total < 1) {
						$(deliveryFeeShopID).val(0);
					}else{
						BASIC_DeliveryFee_TOTAL += parseFloat(BASIC_DeliveryFee);
						$(deliveryFeeShopID).val(BASIC_DeliveryFee_TOTAL);
					}
				}
			}

			//현장수령 배송비 0
			if ( $("#DtoD").val() == "F")	{
				$(deliveryFeeShopID).val(0);
			}

			//총 상품금액(상품가+배송비)
			let getSumPriceShopID_val = $(sumPriceShopID).val()* 1;
			let getDeliveryFeeShopID_val = $(deliveryFeeShopID).val()* 1;
			$("#orderPriceShopID_"+strShopID).val(getSumPriceShopID_val + getDeliveryFeeShopID_val);

			//업체별 총 금액, 총 배송비, 총pv(SINGLE + BASIC)
			let TOTShopID = $("#shopIdTOT"+idx).attr("attrShopIdTOT");		//업체별 shopID
			//console.log(TOTShopID);
			sumByShopID('sumPriceShopID_'+TOTShopID);
			sumByShopID('deliveryFeeShopID_'+TOTShopID);
			sumByShopID('orderPriceShopID_'+TOTShopID);
			sumByShopID('sumPvShopID_'+TOTShopID);
			sumByShopID('sumBvShopID_'+TOTShopID);
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
	}
