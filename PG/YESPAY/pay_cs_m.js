//마이오피스 본인 구매
var pointTXT = "마일리지";		//마일리지,포인트
var ThisMileage;
ThisMileage = false;


function orderSubmit(f) {
	//alert(document.charset);

	if (chkEmpty(f.cuidx)) {
		alert("주문상품 정보가 올바르지 않습니다.");
		return false;
	}
	if (chkEmpty(f.takeName))
	{
		alert("받는분의 성함이 비어있습니다");
		f.takeName.focus();
		return false;
	}

	//택배수령일경우만 체크
	//if ($("input[name=DtoD]:checked").val() != 'F')	{
		if (chkEmpty(f.takeZip) || chkEmpty(f.takeADDR1) || chkEmpty(f.takeADDR2))
		{
			alert("받는분의 주소가 비어있습니다");
			f.takeZip.focus();
			return false;
		}
		if (chkEmpty(f.strEmail)) {
			alert("이메일 주소를 입력해 주세요.");
			f.strEmail.focus();
			return false;
		} else {
			if (!checkEmail(f.strEmail.value)) {
				alert("형식에 맞지 않는 이메일 주소입니다.\n\n이메일 주소를 정확하게 입력해 주세요.");
				f.strEmail.focus();
				return false;
			} 
		}
		if (chkEmpty(f.takeMob))
		{
			alert("주문자 연락처가 비어있습니다");
			f.takeMob.focus();
			return false;
		}
		/*
		if (chkEmpty(f.takeTel)) {
			alert("받는분의 연락처가 비어있습니다");
			f.takeTel.focus();
			return false;
		} else {
			f.TELNO2.value = f.takeTel.value;
		}
		*/
	//}

	if (chkEmpty(f.v_SellCode)) {
		alert("구매종류를 선택해주세요.");
		f.v_SellCode.focus();
		return false;
	}

	//파인애플 추가
	if (f.agreement.checked == false)
	{
		alert("제품구매약관에 동의하셔야합니다.");
		f.agreement.focus();
		return false;
	}


	if (f.gopaymethod.value == '')
	{
		alert("결제할 방식을 선택해주세요.");
		return false;
	}
	//alert(f.gopaymethod.value);
	//return false;

	if (f.gopaymethod.value == 'inBank')
	{		
		//마일리지단독결제취소후 무통장선택시 체크
		if (f.totalPrice.value < 1)	{
			alert(pointTXT + "사용금액을 확인해주세요.")
			f.useCmoney.value = 0;
			calcSettlePrice();
			return false;
		}
		if (f.C_codeName.value =='')
		{
			alert("무통장입금 방식의 경우 입금은행을 선택하셔야합니다.");
			f.C_codeName.focus();
			return false;
		}
		if (f.C_NAME2.value =='')
		{
			alert("무통장입금 방식의 경우 입금자 이름을 입력하셔야합니다.");
			f.C_NAME2.focus();
			return false;
		}
		if (f.memo1.value =='')
		{
			alert("무통장입금 방식의 경우 입금예정일을 입력하셔야합니다.");
			f.memo1.focus();
			return false;
		}

		f.action = "/PG/inBank_Result_cs.asp";				//shop,mobile 통합
	}

	//▣마일리지 단독 결제▣
	if (f.gopaymethod.value == 'point')
	{
		var orgSettlePrice = parseInt(f.orgSettlePrice.value, 10);
		//수령방식
		var oriDelivery = parseInt(f.ori_delivery.value, 10);
		if ($("input[name=DtoD]:checked").val() == 'F')	{
			orgSettlePrice = orgSettlePrice - oriDelivery;
		}else{
			orgSettlePrice = orgSettlePrice;	
		}

		f.useCmoney.value = formatComma(orgSettlePrice);
		checkUseCmoney();

		if (ThisMileage)
		{
			f.useCmoney.value = stripComma(f.useCmoney.value);
			f.target = "_self";
			document.charset = "UTF-8";			

			if (confirm(pointTXT + " 단독결제를 진행하시겠습니까?")) {
				f.action = "/PG/point_Result_cs.asp";
			} else {
				return false;
			}
		} else {
			return false;
		}
	}

	if (f.gopaymethod.value == 'card' || f.gopaymethod.value == 'Card' || f.gopaymethod.value == 'vBank' || f.gopaymethod.value == 'dBank')
	{
		var valData = ""
		// 데이터 스플릿을 위해 특수문자 제거
		//f.strName.value = f.strName.value.replaceAll(':','')
		
		if (f.gopaymethod.value == 'Card')
		{
			for (i=1; i<=3; i++) {
				objItem = eval("f.cardNo"+i);
				if (chkEmpty(objItem)) {
					alert("카드번호 중 "+i+" 필드를 입력해 주세요.");
					objItem.focus();
					return false;
				}
			}
			if (f.card_mm.value == '')
			{
				alert("카드유효기간 중 \'월\' 을 입력해주세요.");
				f.card_mm.focus();
				return false;
			}
			if (f.card_yy.value == '')
			{
				alert("카드유효기간 중 \'년\' 을 입력해주세요.");
				f.card_yy.focus();
				return false;
			}
			if (f.quotabase.value == '')
			{
				alert("할부정보를 입력해주세요.");
				f.quotabase.focus();
				return false;
			}



		}



	
		if (f.totalPrice.value < 1000){
			var msg;

			if (f.gopaymethod.value == 'card' || f.gopaymethod.value == 'Card'){			
				msg ="카드";
			} else if (f.gopaymethod.value == 'vBank'){
				msg = "가상계좌";
			} else if (f.gopaymethod.value == 'dBank'){
				msg = "실시간계좌이체";
			}
			alert(msg+" 결제시 결제금액이 최소 1000원 이상이어야 합니다!!");
			f.useCmoney.value = 0;
			calcSettlePrice();
			return false;
		}


	}




}


/*
function payKindSelect(values) {
	if (values == 'inBank') {
		document.getElementById("inBankInfo").style.display = ""
	}else{
		document.getElementById("inBankInfo").style.display = "none"
	}
	var f = document.frmConfirm;
	f.gopaymethod.value = values;
}
*/

//결제방식에따른 필수값 구분처리: 실시간계좌이체(2015-09-03)
function payKindSelect(str){
	var f = document.orderFrm;
	f.gopaymethod.value = str;
	//alert(str);
	switch (str)
	{
		case "inBank" : {
			$("#inBankInfo").css({"display":""});
			$("#CardInfo").css({"display":"none"});
			break;
		}
		case "Card" : {
			$("#inBankInfo").css({"display":"none"});
			$("#CardInfo").css({"display":""});

			break;
		}
		case "vBank" : {
			$("#inBankInfo").css({"display":"none"});
			$("#CardInfo").css({"display":"none"});
		}
		case "dBank" : {
			$("#inBankInfo").css({"display":"none"});
			$("#CardInfo").css({"display":"none"});
		}
		case "point" : {
			$("#inBankInfo").css({"display":"none"});
			$("#CardInfo").css({"display":"none"});
			break;
		}
//		default :{
//			$("#inBankInfo").css({"display":"none"});	
//		}
	}
}


	$(document).ready(function(){	

		//수령방식
		$("input[name=DtoD]").click(function(){
			//alert($("input[name=DtoD]:checked").val());
			var str		= $("input[name=DtoD]:checked").val();
			var price	= $("input[name=ori_price]").val() * 1;
			var deliFee = $("input[name=ori_delivery]").val() * 1;

			if (str == 'F') {												//현장수령
				$("input[name=totalPrice]").val((price - deliFee) * 1);
				//$("input[name=AMOUNT]").val((price - deliFee) * 1);			//다우 결제금액
				$("input[name=totalDelivery]").val(0);
				$("#delTXT").text('현장수령으로 배송비 미부과');
				$("#priTXT").text(0);	
				document.getElementById("totalTXT").innerHTML = formatComma((price - deliFee) * 1);		//결제금액
				document.getElementById("lastTXT").innerHTML = formatComma((price - deliFee) * 1);		//최종결제금액
				//$("#lastTXT").text((price - deliFee) * 1);									//최종결제금액
				$("input[name=useCmoney]").val(0);							//마일리지 초기화
				$("#DtoD_toggle").css({"display":"none"});					//배송정보 안보임
			} else {
				$("input[name=totalPrice]").val(price);
				//$("input[name=AMOUNT]").val(price);							//다우 결제금액
				$("input[name=totalDelivery]").val(deliFee);
				$("#delTXT").text($("#oriTXT1").text());
				$("#priTXT").text($("#oriTXT2").text());
				$("#totalTXT").text($("#oriTXT3").text());					//결제금액
				$("#lastTXT").text($("#oriTXT3").text());					//최종결제금액
				$("input[name=useCmoney]").val(0);							//마일리지 초기화
				$("#DtoD_toggle").css({"display":""});						//▣배송정보 노출
				//$("#DtoD_toggle").css({"display":"table-row"});			//table잘림
				//$("#DtoD_toggle").css({"display":"table-row-group"});
			}
		});

	
	});



function trim(txt) {
	while (txt.indexOf(' ') >= 0) {
		txt = txt.replace(' ','');
	}
	return txt;
}

function getTimeStamp() {
	var d = new Date();
	var month = d.getMonth() + 1;
	var date = d.getDate();
	var hour = d.getHours();
	var minute = d.getMinutes();
	var second = d.getSeconds();

	month = (month < 10 ? "0" : "") + month;
	date = (date < 10 ? "0" : "") + date;
	hour = (hour < 10 ? "0" : "") + hour;
	minute = (minute < 10 ? "0" : "") + minute;
	second = (second < 10 ? "0" : "") + second;

	var s = d.getFullYear() + month + date + hour + minute + second;

	return s;
}

function getByteLen(p_val) {
	var onechar;
	var tcount = 0;

	for(i = 0; i < p_val.length; i++) {
		onechar = p_val.charAt(i);
		if(escape(onechar).length > 4)
			tcount += 2;
		else if(onechar != '\r')
			tcount++;
	}
	return tcount;
}

function fnNumCheck() {
	if(event.keyCode >= 48 && event.keyCode <= 57)
		event.returnValue = true;
	else
		event.returnValue = false;
}


function openzip(target) {
	openPopup("/m/common/pop_Zipcode.asp?target="+target, "Zipcode", 0, 0, "");
}






//마일리지 금액 입력시 체크이벤트
function checkUseCmoney(item){
	var f = document.frmConfirm;
	var msg;
	//alert(f.ownCmoney.value);
	var cmoneyUseLimit = parseInt(f.cmoneyUseLimit.value, 10);
	var cmoneyUseMin = parseInt(f.cmoneyUseMin.value, 10);
	var cmoneyUseMax = parseInt(f.cmoneyUseMax.value, 10);
	var ownCmoney = parseInt(f.ownCmoney.value, 10);
	var orgSettlePrice = parseInt(f.orgSettlePrice.value, 10);
	//수령방식
	var oriDelivery = parseInt(f.ori_delivery.value, 10);
	if ($("input[name=DtoD]:checked").val() == 'F')	{
		orgSettlePrice = orgSettlePrice - oriDelivery;
	}else{
		orgSettlePrice = orgSettlePrice;	
	}
	var settlePrice = orgSettlePrice;
	var isUseCmoney = false;
	var useCmoney = (chkEmpty(f.useCmoney)) ? 0 : parseInt(stripComma(f.useCmoney.value), 10);
	//alert(useCmoney);

	if (useCmoney <= 0) {
		msg = "사용할 "+ pointTXT +"를 입력해 주세요.";
	}
	else if (ownCmoney < cmoneyUseLimit) {
		msg = pointTXT +" 사용 금액은 "+formatComma(cmoneyUseLimit)+" 원 이상부터 사용 가능합니다.";
	}
	else if (useCmoney < cmoneyUseMin) {
		msg = pointTXT +"는 최소 "+formatComma(cmoneyUseMin)+" 원 이상부터 사용 가능합니다.";
	}
/*
	else if (useCmoney > cmoneyUseMax) {
		msg = "적립금은 최대 "+formatComma(cmoneyUseMax)+" 원 이하까지 사용가능합니다.";
	}
*/
	//▣카드결제시 카드결제최소금액 체크▣
	else if ((useCmoney > cmoneyUseMax) && (f.gopaymethod.value == 'card' || f.gopaymethod.value == 'vBank' || f.gopaymethod.value == 'dBank')) {
		msg = "카드/가상계좌/실시간계좌이체 결제시 결제금액이 최소 1000원 이상이어야 합니다.";
		//msg = "적립금은 최대 "+formatComma(cmoneyUseMax-50)+" 원 이하까지 사용가능합니다.";
	}
	else if (useCmoney > ownCmoney) {
		msg = "보유 하신 "+ pointTXT +"보다 많은 금액을 입력하셨습니다.";
	}
	else if (useCmoney > settlePrice) {
		msg = "결제금액보다 많이 입력하셨습니다.";
	}
	else {
		isUseCmoney = true;
	}
	if (isUseCmoney) {
		calcSettlePrice();
		ThisMileage = true;
	}
	else {
		alert(msg);
		f.useCmoney.value = 0;
		calcSettlePrice();
		ThisMileage = false;
		return false;
	}

}


// 결제금액 계산
function calcSettlePrice() {
	var f = document.frmConfirm;
	var totalCouponDiscountPrice, useCmoney, remainCmoney;
	var orgSettlePrice = parseInt(f.orgSettlePrice.value, 10);
	//수령방식
	var oriDelivery = parseInt(f.ori_delivery.value, 10);
	if ($("input[name=DtoD]:checked").val() == 'F')	{
		orgSettlePrice = orgSettlePrice - oriDelivery;
	}else{
		orgSettlePrice = orgSettlePrice;	
	}
	var ownCmoney = parseInt(f.ownCmoney.value, 10);

	if (f.useCmoney) {
		useCmoney = (f.useCmoney.disabled || chkEmpty(f.useCmoney)) ? 0 : parseInt(stripComma(f.useCmoney.value), 10);
	}
	var settlePrice  = orgSettlePrice - useCmoney;
	var remainCmoney = ownCmoney - useCmoney;
//	alert(settlePrice);
//	f.Amt.value = settlePrice;
	f.totalPrice.value = settlePrice;
	//f.AMOUNT.value = settlePrice;
	document.getElementById("lastTXT").innerHTML = formatComma(settlePrice);	//최종 결제금
	//$("#LastArea").text(formatComma(settlePrice));
	//document.getElementById("RemainArea").innerHTML = formatComma(remainCmoney);		//마일리지 잔액
	//document.getElementById("payArea").innerHTML = formatComma(settlePrice);
	//document.getElementById("PointArea").innerHTML = formatComma(useCmoney);
	//document.getElementById("viewPoint").innerHTML = formatComma(useCmoney);
}


