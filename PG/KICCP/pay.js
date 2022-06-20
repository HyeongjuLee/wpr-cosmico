
	/* 플러그인 설치(확인) */
	StartSmartInstall();

	/* 입력 자동 Setting */
	function f_init(){
		var frm_pay = document.frm_pay;

		var today = new Date();
		var year  = today.getFullYear();
		var month = today.getMonth() + 1;
		var date  = today.getDate();
		var time  = today.getTime();

		if(parseInt(month) < 10) {
			month = "0" + month;
		}

		if(parseInt(date) < 10) {
			date = "0" + date;
		}

//        frm_pay.EP_mall_pwd.value = "1111";
//        frm_pay.EP_vacct_end_date.value = "" + year + month + date;               //가상계좌입금만료일
//        frm_pay.EP_order_no.value = "ORDER_" + year + month + date + time;   //가맹점주문번호
//        frm_pay.EP_user_id.value = "USER_" + time;                           //고객ID
//        frm_pay.EP_user_nm.value = "길라임";
//        frm_pay.EP_user_mail.value = "test@kicc.co.kr";
//		frm_pay.EP_user_phone1.value = "0212344567";
//		frm_pay.EP_user_phone2.value = "01012344567";
//		frm_pay.EP_user_addr.value = "서울 금천구 가산동 459-9 ";
//		frm_pay.EP_product_nm.value = "☆테스트상품☆";
//		frm_pay.EP_product_amt.value = "1004";




	}

	function f_submit() {
		var frm_pay = document.frm_pay;
		var f = document.frm_pay;


		frm_pay.EP_user_mail.value = f.strEmail.value;
		frm_pay.EP_user_phone1.value = f.strTel1.value + f.strTel2.value + f.strTel3.value;
		frm_pay.EP_user_phone2.value = f.strMob1.value + f.strMob2.value + f.strMob3.value;
		frm_pay.EP_user_addr.value = f.strADDR1.value + f.strADDR2.value;
		frm_pay.EP_product_amt.value = f.totalPrice.value;


		//alert(f.action);

		if (f.gAgreement.checked == false)
		{
			alert("정보제공에 동의하셔야합니다.");
			f.gAgreement.focus();
			return false;
		}


		if(document.frm_pay.EP_product_nm.value == "")  // 필수항목 체크 (상품명, 상품가격)
		{
			alert("상품명이 빠졌습니다. 필수항목입니다.");
			return false;
		}
		else if (chkEmpty(f.strName))
		{
			alert("주문자 성함이 비어있습니다");
			f.strName.focus();
			return false;
		}

		else if (chkEmpty(f.strTel1) || chkEmpty(f.strTel2) || chkEmpty(f.strTel3))
		{
			alert("주문자 연락처가 비어있습니다");
			f.strTel1.focus();
			return false;
		}

		else if (chkEmpty(f.strEmail)) {
			alert("이메일 주소를 입력해 주세요.");
			f.strEmail.focus();
			return false;
		}
		else if (!checkEmail(f.strEmail.value)) {
			alert("형식에 맞지 않는 이메일 주소입니다.\n\n이메일 주소를 정확하게 입력해 주세요.");
			f.strEmail.focus();
			return false;
		}

		else if (chkEmpty(f.strZip) || chkEmpty(f.strADDR1) || chkEmpty(f.strADDR2))
		{
			alert("주문자 주소가 비어있습니다");
			f.strZip.focus();
			return false;
		}

		else if (chkEmpty(f.takeName))
		{
			alert("받는분의 성함이 비어있습니다");
			f.takeName.focus();
			return false;
		}
	/*	if (chkEmpty(f.takeTel1) || chkEmpty(f.takeTel2) || chkEmpty(f.takeTel3))
		{
			alert("받는분의 연락처가 비어있습니다");
			f.takeTel1.focus();
			return false;
		}
	*/

		else if (chkEmpty(f.takeZip) || chkEmpty(f.takeADDR1) || chkEmpty(f.takeADDR2))
		{
			alert("받는분의 주소가 비어있습니다");
			f.takeZip.focus();
			return false;
		}
		else if (f.gopaymethod.value=='inbank')
		{
			if (f.bankidx.value=='')
			{
				alert("온라인 입금시 결제 은행을 선택해주셔야합니다.");
				f.bankidx.focus();
				return false;
			}
			if (f.bankingName.value=='')
			{
				alert("온라인 입금시 입금자명을 입력해 주셔야합니다.");
				f.bankingName.focus();
				return false;
			}

		}
		if (f.gopaymethod.value == 'inbank')
		{
			f.action='/PG/inbank_Result.asp';
			f.submit();
			return false;
		}


		var bRetVal = false;

		/* 가맹점사용카드리스트 */
		var usedcard_code = "";
		for( var i=0; i < frm_pay.usedcard_code.length; i++) {
			if (frm_pay.usedcard_code[i].checked) {
				usedcard_code += frm_pay.usedcard_code[i].value + ":";
			}
		}
		frm_pay.EP_usedcard_code.value = usedcard_code;

		/* 가상계좌은행리스트 */
		var vacct_bank = "";
		for( var i=0; i < frm_pay.vacct_bank.length; i++) {
			if (frm_pay.vacct_bank[i].checked) {
				vacct_bank += frm_pay.vacct_bank[i].value + ":";
			}
		}
		frm_pay.EP_vacct_bank.value = vacct_bank;

		/* Easypay Plugin 실행 */
		if ( StartPayment( frm_pay ) == true ) {
			if ( frm_pay.EP_res_cd.value == "0000" ) {
				bRetVal = true;
			} else {

				/* 실패 메시지 */
				alert( "응답코드:"   + frm_pay.EP_res_cd.value + "]\n" +
					   "응답메시지:" + frm_pay.EP_res_msg.value + "]\n" );
			}
		}

		if( frm_pay.EP_tax_flg.value == "TG01" )
		{
			if( !frm_pay.EP_com_tax_amt.value ) {
				alert("과세 승인 금액을 입력하세요.!!");
				frm_pay.EP_com_tax_amt.focus();
				return false;
			}

			if( !frm_pay.EP_com_free_amt.value ) {
				alert("비과세 승인 금액을 입력하세요.!!");
				frm_pay.EP_com_free_amt.focus();
				return false;
			}

			if( !frm_pay.EP_com_vat_amt.value ) {
				alert("부가세 금액을 입력하세요.!!");
				frm_pay.EP_com_vat_amt.focus();
				return false;
			}
		}

		if ( bRetVal ) {
			return;
		} else {
			return false;
		}
	}




function openzip(target) {
	openPopup("/common/pop_Zipcode.asp?target="+target, "Zipcode", 100, 100, "left=200, top=200");
}

// 받는분 정보 복사
function infoCopy(item) {
	var f = document.frm_pay;

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



function chgPay(str){
	var f = document.frm_pay;
	f.gopaymethod.value = str;
	switch (str)
	{
		case "inbank" : {
			$("#CardInfo").css({"display":"none"});
			$("#BankInfo").css({"display":"block"});
			break;
		}
		case "card" : {
			$("#BankInfo").css({"display":"none"});
			$("#CardInfo").css({"display":"block"});
			break;
		}

	}

}


// 받는분 정보 복사
function infoCopy(item) {
	var f = document.frm_pay;

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
	var f = document.frm_pay;
	var totalCouponDiscountPrice, useCmoney;

	var orgSettlePrice = parseInt(f.orgSettlePrice.value, 10);

	if (f.useCmoney) {
		useCmoney = (f.useCmoney.disabled || chkEmpty(f.useCmoney)) ? 0 : parseInt(stripComma(f.useCmoney.value), 10);
	}
	var settlePrice = orgSettlePrice - useCmoney;

	f.totalPrice.value = settlePrice;
	document.getElementById("LastArea").innerHTML = formatComma(settlePrice);
	document.getElementById("payArea").innerHTML = formatComma(settlePrice);
		document.getElementById("PointArea").innerHTML = formatComma(useCmoney);
		document.getElementById("viewPoint").innerHTML = formatComma(useCmoney);
}



// # 적립금 사용 : 시작 ######################################################################

function checkUseCmoney(item){
	var f = document.frm_pay;
	var msg;
	var cmoneyUseLimit = parseInt(f.cmoneyUseLimit.value, 10);
	var cmoneyUseMin = parseInt(f.cmoneyUseMin.value, 10);
	var cmoneyUseMax = parseInt(f.cmoneyUseMax.value, 10);
	var ownCmoney = parseInt(f.ownCmoney.value, 10);
	var orgSettlePrice = parseInt(f.orgSettlePrice.value, 10);
	var settlePrice = orgSettlePrice;

	var isUseCmoney = false;
	var useCmoney = (chkEmpty(f.useCmoney)) ? 0 : parseInt(stripComma(f.useCmoney.value), 10);
	alert(useCmoney);

	if (useCmoney < 0) {
		msg = "사용할 적립금은 마이너스로 기입할 수 없습니다.";
	}
	else if (ownCmoney < cmoneyUseLimit) {
		msg = "적립금은 적립금이 "+formatComma(cmoneyUseLimit)+" 원 이상 보유 시 부터 사용 가능합니다.";
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
	} else {
		isUseCmoney = true;
	}

	if (isUseCmoney) {
		calcSettlePrice();
	}
	else {
		alert(msg);
		f.useCmoney.value = 0;
		calcSettlePrice();
		return false;
	}


}


// # 적립금 사용 : 끝 ######################################################################