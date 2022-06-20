<!--
function openzip(target) {
	openPopup("/common/pop_Zipcode.asp?target="+target, "Zipcode", 100, 100, "left=200, top=200");
}

// 받는분 정보 복사
function infoCopy(item) {
	var f = document.frm;

	if (item.checked) {
		f.takeName.value = f.strName.value;
		f.takeTel1.value = f.strTel1.value;
		f.takeTel2.value = f.strTel2.value;
		f.takeTel3.value = f.strTel3.value;
		f.takeMob1.value = f.strMob1.value;
		f.takeMob2.value = f.strMob2.value;
		f.takeMob3.value = f.strMob3.value;
		f.takeZip.value = f.strZip.value;
		f.takeADDR1.value = f.strADDR1.value;
		f.takeADDR2.value = f.strADDR2.value;
	}
	else {
		f.takeName.value = '';
		f.takeTel1.value = '';
		f.takeTel2.value = '';
		f.takeTel3.value = '';
		f.takeMob1.value = '';
		f.takeMob2.value = '';
		f.takeMob3.value = '';
		f.takeZip.value = '';
		f.takeADDR1.value = '';
		f.takeADDR2.value = '';
	}
}



// 결제금액 계산
function calcSettlePrice() {
	var f = document.frm;
	var totalCouponDiscountPrice, useCmoney;

	var orgSettlePrice = parseInt(f.orgSettlePrice.value, 10);

	if (f.useCmoney) {
		useCmoney = (f.useCmoney.disabled || chkEmpty(f.useCmoney)) ? 0 : parseInt(stripComma(f.useCmoney.value), 10);
	}
	var settlePrice = orgSettlePrice - useCmoney;

	f.Amt.value = settlePrice;
	document.getElementById("showSettlePrice").innerHTML = formatComma(settlePrice);
}


// # 적립금 사용 : 시작 ######################################################################
function changeUseCmoney(item) {
	var f = document.frm;

	var cmoneyUseLimit = parseInt(f.cmoneyUseLimit.value, 10);
	var cmoneyUseMin = parseInt(f.cmoneyUseMin.value, 10);
	var ownCmoney = parseInt(f.ownCmoney.value, 10);

	if (ownCmoney < cmoneyUseLimit) {
		alert("적립금 사용 금액은 "+formatComma(cmoneyUseLimit)+" 원 이상부터 사용 가능합니다.");
		item.checked = false;
	}
	else if (ownCmoney < cmoneyUseMin) {
		alert("적립금은 최소 "+formatComma(cmoneyUseMin)+" 원 이상부터 사용 가능합니다.");
		item.checked = false;
	}

	if (item.checked) {
		f.useCmoney.disabled = false;
		f.useCmoney.style.backgroundColor = "#FFFFFF";
	}
	else {
		f.useCmoney.value = "";
		f.useCmoney.style.backgroundColor = "#F0F0F0";
		f.useCmoney.disabled = true;

		resetUseCmoney();
	}

	calcSettlePrice();
}

function checkUseCmoney(item){
	var f = document.frm;
	var msg;

	if (!f.isUseCmoney.checked){
		item.value = "";
		alert("적립금 사용을 먼저 체크해주세요.");
		return false;
	}

	var cmoneyUseLimit = parseInt(f.cmoneyUseLimit.value, 10);
	var cmoneyUseMin = parseInt(f.cmoneyUseMin.value, 10);
	var cmoneyUseMax = parseInt(f.cmoneyUseMax.value, 10);
	var ownCmoney = parseInt(f.ownCmoney.value, 10);
	var orgSettlePrice = parseInt(f.orgSettlePrice.value, 10);
	var settlePrice = orgSettlePrice;

	var isUseCmoney = false;
	var useCmoney = (chkEmpty(f.useCmoney)) ? 0 : parseInt(stripComma(f.useCmoney.value), 10);

	if (useCmoney <= 0) {
		msg = "사용할 적립금을 입력해 주세요.";
	}
	else if (ownCmoney < cmoneyUseLimit) {
		msg = "적립금 사용 금액은 "+formatComma(cmoneyUseLimit)+" 원 이상부터 사용 가능합니다.";
	}
	else if (useCmoney < cmoneyUseMin) {
		msg = "적립금은 최소 "+formatComma(cmoneyUseMin)+" 원 이상부터 사용 가능합니다.";
	}
	else if (useCmoney > cmoneyUseMax) {
		msg = "적립금은 최대 "+formatComma(cmoneyUseMax)+" 원 이하까지 사용가능합니다.";
	}
	else if (useCmoney > ownCmoney) {
		msg = "보유 하신 적립금보다 많은 금액을 입력하셨습니다.";
	}
	else if (useCmoney > settlePrice) {
		msg = "결제금액보다 많이 입력하셨습니다.";
	}
	else {
		isUseCmoney = true;
	}

	if (isUseCmoney) {
		document.getElementById("showTotalCmoney").innerHTML = "-"+formatComma(useCmoney);
	}
	else {
		alert(msg);
		item.value = "0";

		resetUseCmoney();
	}

	calcSettlePrice();
}

function resetUseCmoney() {
	var f = document.frm;

	document.getElementById("showTotalCmoney").innerHTML = "0";
}
// # 적립금 사용 : 끝 ######################################################################


//-->
