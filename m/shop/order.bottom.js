
	//shop구매, myoffice구매 공통

	$(document).ready(function(){
		let SHOP_ORDERINFO_VIEW_TF = $("input[name=SHOP_ORDERINFO_VIEW_TF]").val();
		if (SHOP_ORDERINFO_VIEW_TF == 'F') {
			$("#orderInfo").hide();
			fillEmptyOrdererInfo();
		}
		let DIRECT_PICKUP_USE_TF = $("input[name=DIRECT_PICKUP_USE_TF]").val();
		if (DIRECT_PICKUP_USE_TF == 'T') {
			chgDelivery(DtoD);
		}
	});

	function chgDelivery(DtoD) {
		var price = $("input[name=ori_price]").val() * 1;
		var deliFee = $("input[name=ori_delivery]").val() * 1;
		var usePoint = $("input[name=useCmoney]").val() * 1;
		let SHOP_ORDERINFO_VIEW_TF = $("input[name=SHOP_ORDERINFO_VIEW_TF]").val();

		if (SHOP_ORDERINFO_VIEW_TF == 'T') {
		}else{
			$("#orderInfo").hide();
			fillEmptyOrdererInfo();
		}




		//다카드 + DtoD 추가
		let paymethod = $("input[name=gopaymethod]").val();
		if (paymethod == 'mComplex') {
			alert("※수령방식 변경 시 입력된 다카드결제정보는 모두 초기화 됩니다!");
			resetAllmComplexInfo();		//복합결제 초기화
		}

		if (DtoD == 'F')		//현장수령
		{
			let getPrice = (price - deliFee - usePoint) * 1;
			$("input[name=totalPrice], input[name=mComplexTotalPrice]").val(getPrice);		//다카드 추가
			$("input[name=totalDelivery]").val(0);

			$("#priTXT").text(NumberFormatter.format(0));
			$("#lastTXT, #payArea").text(NumberFormatter.format(getPrice));
			$("#mCardPrice_TXT, #mComplexTotal_TXT").text(NumberFormatter.format(getPrice));			//다카드 추가

			//$("#deliveryInfo").hide();
			if (SHOP_ORDERINFO_VIEW_TF == 'T') {
				$("#orderInfo").hide();
				fillEmptyOrdererInfo();
			}
			$("#deliveryInfo").show();
			$(".directpickup").hide();
			$(".directpickupTitle").show();

		} else {
			let getPrice = (price - usePoint) * 1;
			$("input[name=totalPrice], input[name=mComplexTotalPrice]").val(getPrice);
			$("input[name=totalDelivery]").val(deliFee);

			$("#priTXT").text(NumberFormatter.format(deliFee));
			$("#lastTXT, #payArea").text(NumberFormatter.format(getPrice));
			$("#mCardPrice_TXT, #mComplexTotal_TXT").text(NumberFormatter.format(getPrice));			//다카드 추가

			//$("#deliveryInfo").show();

			if (SHOP_ORDERINFO_VIEW_TF == 'T') {
				$("#orderInfo").show();
				oriOrdererInfo();
			}
			$("#deliveryInfo").show();
			$(".directpickup").show();
			$(".directpickupTitle").hide();

		}

	}

	//배송지선택
	let takeName = $("input[name=takeName]");
	let takeTel = $("input[name=takeTel]");
	let takeMobile = $("input[name=takeMobile]");
	let takeZip = $("input[name=takeZip]");
	let takeADDR1 = $("input[name=takeADDR1]");
	let takeADDR2 = $("input[name=takeADDR2]");

	let strName = $("input[name=strName]");
	let strTel = $("input[name=strTel]");
	let strMobile = $("input[name=strMobile]");
	let strZip = $("input[name=strZip]");
	let strADDR1 = $("input[name=strADDR1]");
	let strADDR2 = $("input[name=strADDR2]");

	let ori_strName = $("input[name=ori_strName]");
	let ori_strTel = $("input[name=ori_strTel]");
	let ori_strMobile = $("input[name=ori_strMobile]");
	let ori_strZip = $("input[name=ori_strZip]");
	let ori_strADDR1 = $("input[name=ori_strADDR1]");
	let ori_strADDR2 = $("input[name=ori_strADDR2]");

	//빈값처리
	function fillEmptyOrdererInfo() {
		if (strName.val() == "") strName.val('strName');
		if (strTel.val() == "") strTel.val('00');
		if (strMobile.val() == "") strMobile.val('010');
		if (strZip.val() == "") strZip.val('00000');
		if (strADDR1.val() == "") strADDR1.val('strADDR1');
		if (strADDR2.val() == "") strADDR2.val('strADDR2');
	}

	function oriOrdererInfo() {
		emptyDeliveryInfo();
		$('input:radio[name=dInfoType]').eq(0).attr("checked", true);
		strName.val(ori_strName.val());
		strTel.val(ori_strTel.val());
		strMobile.val(ori_strMobile.val());
		strZip.val(ori_strZip.val());
		strADDR1.val(ori_strADDR1.val());
		strADDR2.val(ori_strADDR2.val());
	}

	function insertThisAddress(v1,v2,v3,v4,v5,v6) {
		takeName.val(v1).addClass("readonly").attr("readonly",true);
		takeTel.val(v5).addClass("readonly").attr("readonly",true);
		takeMobile.val(v6).addClass("readonly").attr("readonly",true);
		takeZip.val(v2);
		takeADDR1.val(v3);
		takeADDR2.val(v4).addClass("readonly").attr("readonly",true);
		$("#takeZipBtn").hide();
	}

	function ordererDeliveryInfo() {		//shop order
		emptyDeliveryInfo();
		$('input:radio[name=dInfoType]').eq(0).attr("checked", true);
		takeName.val(strName.val());
		takeTel.val(strTel.val());
		takeMobile.val(strMobile.val());
		takeZip.val(strZip.val());
		takeADDR1.val(strADDR1.val());
		takeADDR2.val(strADDR2.val());
	}

	function baseDeliveryInfo() {		//myoffice order
		emptyDeliveryInfo();
		$('input:radio[name=dInfoType]').eq(0).attr("checked", true);
		takeName.val(ori_strName.val());
		takeTel.val(ori_strTel.val());
		takeMobile.val(ori_strMobile.val());
		takeZip.val(ori_strZip.val());
		takeADDR1.val(ori_strADDR1.val());
		takeADDR2.val(ori_strADDR2.val());
	}

	function emptyDeliveryInfo() {
		takeName.val("").removeClass("readonly").removeAttr("readonly");
		takeTel.val("").removeClass("readonly").removeAttr("readonly");
		takeMobile.val("").removeClass("readonly").removeAttr("readonly");
		takeZip.val("");
		takeADDR1.val("");
		takeADDR2.val("").removeClass("readonly").removeAttr("readonly");
		$("#takeZipBtn").show();
	}

	function openDeliveryInfo() {
		$("#deliveryInfoModal").trigger('click');
	}
