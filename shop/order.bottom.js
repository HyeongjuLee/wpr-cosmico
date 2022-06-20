
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
		let price = $("input[name=ori_price]").val() * 1;
		let deliFee = $("input[name=ori_delivery]").val() * 1;
		let usePoint = $("input[name=useCmoney]").val() * 1;
		let SHOP_ORDERINFO_VIEW_TF = $("input[name=SHOP_ORDERINFO_VIEW_TF]").val();

		if (SHOP_ORDERINFO_VIEW_TF == 'T') {
			$("#orderInfo").css("width","100%");
			$("#deliveryInfo").css("width","100%");
		}else{
			$("#orderInfo").hide();
			$("#deliveryInfo").css("width","100%");
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
			$("input[name=totalPrice], input[name=mComplexTotalPrice]").val(getPrice);			//다카드 추가

			$("input[name=totalDelivery]").val(0);

			$("#DeliveryAreaID, #DeliveryAreaID2").text(NumberFormatter.format(0));
			$("#LastAreaID, #payArea").text(NumberFormatter.format(getPrice));
			$("#mCardPrice_TXT, #mComplexTotal_TXT").text(NumberFormatter.format(getPrice));			//다카드 추가

			if (SHOP_ORDERINFO_VIEW_TF == 'T') {
				$("#orderInfo").hide();
				$("#deliveryInfo").css("width","100%");
				fillEmptyOrdererInfo();
			}
			$("#deliveryInfo").show();
			$(".directpickup").hide();
			$(".directpickupTitle").show();

		} else {
			let getPrice = (price - usePoint) * 1;
			$("input[name=totalPrice], input[name=mComplexTotalPrice]").val(getPrice);

			$("input[name=totalDelivery]").val(deliFee);

			$("#DeliveryAreaID, #DeliveryAreaID2").text(NumberFormatter.format(deliFee));
			$("#LastAreaID, #payArea").text(NumberFormatter.format(getPrice));
			$("#mCardPrice_TXT, #mComplexTotal_TXT").text(NumberFormatter.format(getPrice));			//다카드 추가

			if (SHOP_ORDERINFO_VIEW_TF == 'T') {
				$("#orderInfo").show();
				$("#deliveryInfo").css("width","100%");
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

	//빈값처리
	function fillEmptyOrdererInfo() {
		if (strName.val() == "") strName.val('strName');
		if (strTel.val() == "") strTel.val('00');
		if (strMobile.val() == "") strMobile.val('010');
		if (strZip.val() == "") strZip.val('00000');
		if (strADDR1.val() == "") strADDR1.val('strADDR1');
		if (strADDR2.val() == "") strADDR2.val('strADDR2');
	}

	function oriOrdererInfo(f) {
		emptyDeliveryInfo();
		if (typeof f == "undefined"){
			f=window.document.forms[0];
			f.dInfoType[0].checked = true;
		}
		strName.val(f.ori_strName.value);
		strTel.val(f.ori_strTel.value);
		strMobile.val(f.ori_strMobile.value);
		strZip.val(f.ori_strZip.value);
		strADDR1.val(f.ori_strADDR1.value);
		strADDR2.val(f.ori_strADDR2.value);
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

	function ordererDeliveryInfo(f) {		//shop order
		emptyDeliveryInfo();
		if (typeof f == "undefined"){
			f=window.document.forms[0];
			f.dInfoType[0].checked = true;
		}
		takeName.val(f.strName.value);
		takeTel.val(f.strTel.value);
		takeMobile.val(f.strMobile.value);
		takeZip.val(f.strZip.value);
		takeADDR1.val(f.strADDR1.value);
		takeADDR2.val(f.strADDR2.value);
	}

	function baseDeliveryInfo(f) {		//myoffice order
		emptyDeliveryInfo();
		if (typeof f == "undefined"){
			f=window.document.forms[0];
			f.dInfoType[0].checked = true;
		}
		takeName.val(f.ori_strName.value);
		takeTel.val(f.ori_strTel.value);
		takeMobile.val(f.ori_strMobile.value);
		takeZip.val(f.ori_strZip.value);
		takeADDR1.val(f.ori_strADDR1.value);
		takeADDR2.val(f.ori_strADDR2.value);
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

	function openDeliveryInfo(paams) {
		$("#deliveryInfoModal").trigger('click');
	}