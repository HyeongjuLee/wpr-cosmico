//SHOP 쇼핑몰구매
var pointTXT = "포인트";		//마일리지,포인트
var ThisMileage;
ThisMileage = false;


function loadings() {
	$("#loadingPro").show();
}


var doubleSubmit
doubleSubmit = false;


$(document).ready(function() {
	$('form input').keydown(function() {
		if (event.keyCode === 13) {
			event.preventDefault();
		}
	});

});


function orderSubmit(f) {

	//doubleSubmit 체크
	if (!doubleSubmit) {
		doubleSubmit = true;
	} else {

		loadings();
		$("input[type=submit]").attr("disabled",true);
		alert("결제처리가 진행중입니다. 잠시 기다려주세요.");
		return false;
	}

	if (f.useCmoney.value == "")
	{
		f.useCmoney.value = 0;
	}

	if (f.useCmoney.value != "0")
	{
		checkUseCmoney();
	}

	if (chkEmpty(f.strName))
	{
		alert("주문자 성함이 비어있습니다");
		f.strName.focus();
		doubleSubmit = false;
		return false;
	}

	if (chkEmpty(f.strMobile)) {
		alert("주문자의 휴대폰번호가 비어있습니다");
		f.strMobile.focus();
		doubleSubmit = false;
		return false;
	} else {
		if (!chkMob(f.strMobile.value)) {
			alert("정확한 휴대전화번호를 입력해 주세요");
			f.strMobile.focus();
			doubleSubmit = false;
			return false;
		}
	}

	if (chkEmpty(f.strEmail)) {

		alert("이메일 주소를 입력해 주세요.");
		f.strEmail.focus();
		doubleSubmit = false;
		return false;

	} else {
		if (!checkEmail(f.strEmail.value)) {
			alert("형식에 맞지 않는 이메일 주소입니다.\n\n이메일 주소를 정확하게 입력해 주세요.");
			f.strEmail.focus();
			doubleSubmit = false;
			return false;
		}
	}

	//if (chkEmpty(f.strZip) || chkEmpty(f.strADDR1)) {
	if (chkEmpty(f.strZip) || chkEmpty(f.strADDR1) || chkEmpty(f.strADDR2)) {
		alert("주문자 주소가 비어있습니다");
		f.strZip.focus();
		doubleSubmit = false;
		return false;
	}

	if (chkEmpty(f.takeName)) {
		alert("받는분의 성함이 비어있습니다.");
		f.takeName.focus();
		doubleSubmit = false;
		return false;
	}


	if (chkEmpty(f.takeMobile)) {
		alert("받는분의 연락처가 비어있습니다");
		f.takeMobile.focus();
		doubleSubmit = false;
		return false;
	} else {
		if (!chkMob(f.takeMobile.value)) {
			alert("받는분의 정확한 휴대전화번호를 입력해 주세요");
			f.takeMobile.focus();
			doubleSubmit = false;
			return false;
		}
	}

	//if (chkEmpty(f.takeZip) || chkEmpty(f.takeADDR1))
	if (chkEmpty(f.takeZip) || chkEmpty(f.takeADDR1) || chkEmpty(f.takeADDR2))
	{
		alert("받는분의 주소가 비어있습니다");
		f.takeZip.focus();
		doubleSubmit = false;
		return false;
	}

	//CS연동상품선택시
	if (f.isComSell.value == 'T') {
		if (f.v_SellCode.value == '')
		{
			alert("구매종류를 선택해주세요.");
			f.v_SellCode.focus();
			doubleSubmit = false;
			return false;
		}
	}

	if (f.gopaymethod.value == '')
	{
		alert("결제할 방식을 선택해주세요.");
		doubleSubmit = false;
		return false;
	}

	if (f.gAgreement.checked == false)
	{
		alert("정보제공에 동의하셔야합니다.");
		f.gAgreement.focus();
		doubleSubmit = false;
		return false;
	}

	//▣ 가상결제 + 마일리지/포인트결제 불가
	if (f.gopaymethod.value == 'vBank' && parseInt(f.useCmoney.value, 10) > 0){
		alert("가상계좌 결제시 포인트를 사용할 수 없습니다!");
		f.useCmoney.value = 0;
		calcSettlePrice();
		doubleSubmit = false;
		return false;
	}
	//▣ 무통장 + 마일리지/포인트결제 불가
	if (f.gopaymethod.value == 'inBank' && parseInt(f.useCmoney.value, 10) > 0){
		alert("무통장 결제시 포인트를 사용할 수 없습니다  ");
		f.useCmoney.value = 0;
		calcSettlePrice();
		doubleSubmit = false;
		return false;
	}
	if (f.gopaymethod.value == 'inBank')
	{
		//마일리지단독결제취소후 무통장선택시 체크
		if (f.totalPrice.value < 1)	{
			alert(pointTXT + "사용금액을 확인해주세요.")
			f.useCmoney.value = 0;
			calcSettlePrice();
			doubleSubmit = false;
			return false;
		}
		if ($("input[name=bankidx]:checked").length == 0)
		{
			alert("온라인 입금시 결제 은행을 선택해주셔야합니다.");
			//f.bankidx.focus();
			doubleSubmit = false;
			return false;
		}
		if (f.bankingName.value == '')
		{
			alert("온라인 입금시 입금자명을 입력해 주셔야합니다.");
			f.bankingName.focus();
			doubleSubmit = false;
			return false;
		}
		if (f.memo1.value =='')
		{
			alert("온라인 입금시 입금예정일을 입력하셔야합니다.");
			f.memo1.focus();
			doubleSubmit = false;
			return false;
		}

		//현금영수증 발행
		/*
		if ($("input[name=MEMBER_NATIONCODE]").val() == 'KR') {

			if ($("input[name=C_HY_TF]:checked").length == 0) {
				alert("현금영수증 발행여부를 선택해주세요.");
				doubleSubmit = false;
				return false;
			}
			var CHYCHK = $("input[name=C_HY_TF]:checked").val();
			if (CHYCHK == "1")
			{
				if (f.C_HY_SendNum.value == '')
				{
					alert("[소득공제용] 현금영수증 발행시 휴대폰 번호를 입력해 주셔야합니다.");
					f.C_HY_SendNum.focus();
					doubleSubmit = false;
					return false;
				}
				if (!chkMob(f.C_HY_SendNum.value)) {
					alert("정확한 휴대폰 번호를 입력해 주셔야합니다.");
					f.C_HY_SendNum.focus();
					doubleSubmit = false;
					return false;
				}

			}
			if (CHYCHK == "2")
			{
				if (f.C_HY_SendNum.value == '')
				{
					alert("[지출증빙용] 현금영수증 발행시 사업자등록번호를 입력해 주셔야합니다.");
					f.C_HY_SendNum.focus();
					doubleSubmit = false;
					return false;
				}
				if (f.C_HY_SendNum.value.length < 10)
				{
					alert("정확한 사업자등록번호를 입력해 주셔야합니다.");
					f.C_HY_SendNum.focus();
					doubleSubmit = false;
					return false;
				}
				if (chkBusinessNo(f.C_HY_SendNum.value) == false) {
					alert("정확한 사업자등록번호 10자리를 입력해주세요.");
					f.C_HY_SendNum.focus();
					doubleSubmit = false;
					return false;
				}
			}

		}
		*/

		loadings();
		$("input[type=submit]").attr("disabled",true);			//double submit check
		f.target = "_self";
		f.action = "/PG/inBank_Result.asp";

	}


	//▣마일리지 단독 결제▣
	if (f.gopaymethod.value == 'point')
	{
		var orgSettlePrice = parseInt(f.orgSettlePrice.value, 10);
		f.useCmoney.value = formatComma(orgSettlePrice);
		checkUseCmoney();

		if (f.useCmoneyTF.value == 'F')
		{
			f.useCmoney.value = 0;
			calcSettlePrice();
			doubleSubmit = false;
			return false;
		}

		if (ThisMileage)
		{
			f.useCmoney.value = stripComma(f.useCmoney.value);
			f.target = "_self";
			loadings();
			$("input[type=submit]").attr("disabled",true);			//double submit check
			f.action = "/PG/point_Result.asp";
		} else {
			doubleSubmit = false;
			return false;
		}
	}

	if (f.gopaymethod.value == 'CardAPI')
	{
		if (f.pAgreement01.checked == false)
		{
			alert("전자 금융거래 이용약관에 동의하셔야합니다.");
			f.pAgreement01.focus();
			$(".ya01").css("background","yellow");
			doubleSubmit = false;
			return false;
		}
		if (f.pAgreement02.checked == false)
		{
			alert("개인정보 취급방침에 동의하셔야합니다.");
			f.pAgreement02.focus();
			$(".ya02").css("background","yellow");
			doubleSubmit = false;
			return false;
		}
		if (f.pAgreement03.checked == false)
		{
			alert("서비스 이용약관에 동의하셔야합니다.");
			f.pAgreement03.focus();
			$(".ya03").css("background","yellow");
			doubleSubmit = false;
			return false;
		}

		if (f.totalPrice.value < 1000){
			alert("카드 결제시 결제금액이 최소 1000원 이상이어야 합니다!");
			f.useCmoney.value = 0;
			calcSettlePrice();
			doubleSubmit = false;
			return false;
		}
		for (i=1; i<=4; i++) {
			objItem = eval("f.cardNo"+i);
			if (chkEmpty(objItem)) {
				alert("카드번호 중 "+i+" 필드를 입력해 주세요.");
				objItem.focus();
				doubleSubmit = false;
				return false;
			}
		}
		if (f.card_mm.value == '')
		{
			alert("카드유효기간 중 \'월\' 을 입력해주세요.");
			f.card_mm.focus();
			doubleSubmit = false;
			return false;
		}
		if (f.card_yy.value == '')
		{
			alert("카드유효기간 중 \'년\' 을 입력해주세요.");
			f.card_yy.focus();
			doubleSubmit = false;
			return false;
		}
		//카드구분
		var str = $("input[name=cardKind]:checked").val();
		if (str == 'P')	{
			if (chkEmpty(f.birthYY) || chkEmpty(f.birthMM) || chkEmpty(f.birthDD)) {
				alert("생년월일을 입력해 주세요.");
				f.birthYY.focus();
				doubleSubmit = false;
				return false;
			}
		}
		else if (str == 'C')
		{
			if (chkEmpty(f.CorporateNumber)) {
				alert("사업자등록번호 10자리를 입력해 주세요.");
				f.CorporateNumber.focus();
				doubleSubmit = false;
				return false;
			}
			if (f.CorporateNumber.value.length < 10) {
				alert("사업자등록번호 10자리를 입력해 주세요!");
				f.CorporateNumber.focus();
				doubleSubmit = false;
				return false;
			}
		}
		else if (str == 'I')
		{
			if (chkEmpty(f.birthYY) || chkEmpty(f.birthMM) || chkEmpty(f.birthDD)) {
				alert("생년월일을 입력해 주세요.");
				f.birthYY.focus();
				doubleSubmit = false;
				return false;
			}
		}
		else {
			alert("카드구분을 선택해주세요!");
			doubleSubmit = false;
			return false;
		}

		if (f.CardPass.value == '')
		{
			alert("카드비밀번호 앞2자리를 입력해주세요.");
			f.CardPass.focus();
			doubleSubmit = false;
			return false;
		}
		if (f.quotabase.value == '')
		{
			alert("할부정보를 입력해주세요.");
			f.quotabase.focus();
			doubleSubmit = false;
			return false;
		}

		loadings();
		$("input[type=submit]").attr("disabled",true);			//double submit check
		f.target = "_self";
		f.action = "/PG/PAYTAG/payResult_KeyIn.asp";
	}

	if (f.gopaymethod.value == 'vBank')
	{
		if (f.totalPrice.value < 1)	{
			alert(pointTXT + "사용금액을 확인해주세요.")
			f.useCmoney.value = 0;
			calcSettlePrice();
			doubleSubmit = false;
			return false;
		}
		if (f.vBankCode.value == '')
		{
			alert("가상계좌를 발급받으실 은행을 선택해 주세요.");
			f.vBankCode.focus();
			doubleSubmit = false;
			return false;
		}
		if (f.vBankDepName.value == '')
		{
			alert("가상계좌 입금자명을 입력해 주셔야합니다.");
			f.vBankDepName.focus();
			doubleSubmit = false;
			return false;
		}

		loadings();
		$("input[type=submit]").attr("disabled",true);
		f.target = "_self";
		//f.action = "/PG/PAYTAG/vBankRequest.asp";

	}


	//일반카드
	if (f.gopaymethod.value == 'Card')
	{
		if (f.totalPrice.value < 1000){
			alert("카드 결제시 결제금액이 최소 1000원 이상이어야 합니다!");
			f.useCmoney.value = 0;
			calcSettlePrice();
			doubleSubmit = false;
			return false;
		}


		/*
			PAYTAG 일반 카드결제
		*/


		doubleSubmit = false;
		return false;
	}


	// mComplex 복합결제 S //
	if (f.gopaymethod.value == 'mComplex')
	{

		//포인트 입력부 readonly
		//$("input[name=useCmoney]").addClass("readonly").attr("readonly",true);

		var thisResult = 0;
		/*
		//모두 선택값일 때
		if ($("input[name=CardChk]:checked").val() != "T" && $("input[name=BankChk]:checked").val() != "T" && $("input[name=CashChk]:checked").val() != "T")
		{
			alert("다중복합결제의 결제수단을 선택해주세요");
			doubleSubmit = false;
			thisResult = 1;
			doubleSubmit = false;
			return false;
		}
		*/
		if (f.totalPrice.value < 1)	{
			alert(pointTXT + "사용금액을 확인해주세요.")
			f.useCmoney.value = 0;
			calcSettlePrice();
			doubleSubmit = false;
			thisResult = 1;
			return false;
		}

		$("#mComplexInfo .CardInfo").each(function() {

			//var cardAddNum = $(this).closest('div.CardInfo').find('span.cardAddNum').html()
			var cardAddNum  = $(this).find('span.cardAddNum').text()
			var cardNumText = "<카드#" +cardAddNum+ ">\n"

			var CardPrice = $(this).find("input[name=CardPrice]");
			if (CardPrice.val() == "") {
				alert(cardNumText + "카드 결제금액을 입력해주세요.");
				CardPrice.focus();
				doubleSubmit = false;
				thisResult = 1;
				return false;
			} else {
				if (CardPrice.val() < 1000) {
					alert(cardNumText + "카드 결제시 결제금액이 최소 1000원 이상이어야 합니다!");
					CardPrice.focus();
					doubleSubmit = false;
					thisResult = 1;
					return false;
				}
			}

			var CardVld = $(this).find("input[name=CardVld]");
			if ($.trim(CardVld.val()) == '' || $.trim(CardVld.val()) == 'F') {
				alert(cardNumText + "카드 금액이 적용되지 않았습니다. 금액적용을 해주세요!!");
				CardVld.focus();
				doubleSubmit = false;
				thisResult = 1;
				return false;
			}

			for (i=1; i<=4; i++) {
				var mCardNo = $(this).find("input[name=mCardNo"+i+"]");

				if (mCardNo.val() == "") {
					alert(cardNumText + "카드번호 중 "+i+" 번째 칸을 입력해 주세요.");
					mCardNo.focus();
					doubleSubmit = false;
					thisResult = 1;
					return false;
				}
			}

			var mCardMM = $(this).find("select[name=mCardMM]");
			if (mCardMM.val() == "") {
				alert(cardNumText + "카드유효기간 중 \'월\' 을 입력해주세요.");
				mCardMM.focus();
				doubleSubmit = false;
				thisResult = 1;
				return false;
			}

			var mCardYY = $(this).find("select[name=mCardYY]");
			if (mCardYY.val() == "") {
				alert(cardNumText + "카드유효기간 중 \'년\' 을 입력해주세요.");
				mCardYY.focus();
				doubleSubmit = false;
				thisResult = 1;
				return false;
			}

			var mCardBirth = $(this).find("input[name=mCardBirth]");
			if (mCardBirth.val() == "") {
				alert(cardNumText + "생년월일을 8자리를 입력해주세요.\n ex)19630516 (yyyymmdd형식) \n\n※법인사업자는 사업자번호 10자리");
				mCardBirth.focus();
				doubleSubmit = false;
				thisResult = 1;
				return false;
			} else {
				if (mCardBirth.val().length < 8) {
					alert(cardNumText + "정확한 자릿수를 입력해주세요.\n(생년월일8자리 또는 사업자등록번호10자리)");
					mCardBirth.focus();
					doubleSubmit = false;
					thisResult = 1;
					return false;
				} else {

					if (mCardBirth.val().length == 8) {
						//생년월일 유효성
						if (chkValidBirthDate(mCardBirth.val()) == false) {
							alert(cardNumText + "정확한 생년월일 8자리를 입력해주세요. (yyyymmdd)");
							mCardBirth.focus();
							doubleSubmit = false;
							thisResult = 1;
							return false;
						}
					} else if (mCardBirth.val().length == 10) {
						//사업자등록번호 유효성
						if (chkBusinessNo(mCardBirth.val()) == false) {
							alert(cardNumText + "정확한 사업자등록번호 10자리를 입력해주세요.");
							mCardBirth.focus();
							doubleSubmit = false;
							thisResult = 1;
							return false;
						}
					} else {
						alert(cardNumText + "정확한 자릿수를 입력해주세요.\n(생년월일8자리 또는 사업자등록번호10자리)");
						mCardBirth.focus();
						doubleSubmit = false;
						thisResult = 1;
						return false;
					}

				}

			}

			var mCardPass = $(this).find("input[name=mCardPass]");
			if (mCardPass.val() == "") {
				alert(cardNumText + "카드비밀번호 앞2자리를 입력해주세요.");
				mCardPass.focus();
				doubleSubmit = false;
				thisResult = 1;
				return false;
			} else {
				if (mCardPass.val().length < 2){
					alert(cardNumText + "정확한 카드비밀번호 앞2자리를 입력해주세요.");
					mCardBirth.focus();
					doubleSubmit = false;
					thisResult = 1;
					return false;
				}
			}

			var mQuotabase = $(this).find("select[name=mQuotabase]");
			if (mQuotabase.val() == "") {
				alert(cardNumText + "할부정보를 입력해주세요.");
				mQuotabase.focus();
				doubleSubmit = false;
				thisResult = 1;
				return false;
			}

		});
		if (thisResult == 1) {
			doubleSubmit = false;
			return false;
		}

		if ($("#BankChk").is(":checked"))
		{
			var BankPrice = $("#mComplexInfo input[name=BankPrice]");
			if (BankPrice.val() == "") {
				alert("무통장 결제금액을 입력해주세요.");
				BankPrice.focus();
				doubleSubmit = false;
				thisResult = 1;
				return false;
			} else {
				if (BankPrice.val() < 1000) {
					alert("무통장 결제시 결제금액이 최소 1000원 이상이어야 합니다!");
					BankPrice.focus();
					doubleSubmit = false;
					thisResult = 1;
					return false;
				}
			}

			var BankVld = $("#mComplexInfo input[name=BankVld]").val();
			if ($.trim(BankVld) == '' || $.trim(BankVld) == 'F') {
				alert("무통장 금액이 적용되지 않았습니다. 금액적용을 해주세요!!");
				doubleSubmit = false;
				thisResult = 1;
				return false;
			}
			if ($("input[name=mBankidx]:checked").length == 0)
			{
				alert("온라인 입금시 결제 은행을 선택해주셔야합니다.");
				doubleSubmit = false;
				return false;
			}
			if (f.mBankingName.value == '')
			{
				alert("온라인 입금시 입금자명을 입력해 주셔야합니다.");
				f.mBankingName.focus();
				doubleSubmit = false;
				return false;
			}
			if (f.mMemo1.value =='')
			{
				alert("온라인 입금시 입금예정일을 입력하셔야합니다.");
				f.mMemo1.focus();
				doubleSubmit = false;
				return false;
			}
		}
		if (thisResult == 1) {
			doubleSubmit = false;
			return false;
		}

		if ($("#CashChk").is(":checked"))
		{
			var CashPrice = $("#mComplexInfo input[name=CashPrice]");
			if (CashPrice.val() == "") {
				alert("현금 결제금액을 입력해주세요.");
				CashPrice.focus();
				doubleSubmit = false;
				thisResult = 1;
				return false;
			} else {
				if (CashPrice.val() < 500) {
					alert("현금 결제시 결제금액이 최소 500원 이상이어야 합니다!");
					CashPrice.focus();
					doubleSubmit = false;
					thisResult = 1;
					return false;
				}
			}

			var CashVld = $("#mComplexInfo input[name=CashVld]").val();
			if ($.trim(CashVld) == '' || $.trim(CashVld) == 'F') {
				alert("현금 금액이 적용되지 않았습니다. 금액적용을 해주세요!!");
				doubleSubmit = false;
				thisResult = 1;
				return false;
			}
		}


		if (thisResult == 1) {
			doubleSubmit = false;
			return false;
		}

		if ((f.mComplexTotalPrice.value * 1) != (f.mComplexTotal.value * 1) || (f.totalPrice.value * 1) != (f.mComplexTotal.value * 1)) {
			alert("결제해야할 금액과 결제금액이 맞지 않습니다. 금액을 확인해주세요.");
			doubleSubmit = false;
			return false;
		}

		loadings();
		$("input[type=submit]").attr("disabled",true);			//double submit check
		f.target = "_self";
		//f.action = "/PG/PAYTAG/mComplexResult.asp";

	}
	// mComplex 복합결제 E //



}




function chgPay(str){
	var f = document.orderFrm;
	f.gopaymethod.value = str;
	//console.log(str);

	$("#PG_POLICY_AREA").css({"display":"none"});

	switch (str)
	{
		case "inBank" : {
			$("#CardInfo").css({"display":"none"});
			$("#BankInfo").css({"display":"block"});
			$("#vBankInfo").css({"display":"none"});
			//$("#mComplexInfo").css({"display":"none"});
			//$("#TOTAL_PV").text($("#ori_TOTAL_PV").val());
			break;
		}
		case "CardAPI" : {
			$("#BankInfo").css({"display":"none"});
			$("#CardInfo").css({"display":"block"});
			$("#vBankInfo").css({"display":"none"});
			//$("#mComplexInfo").css({"display":"none"});
			//$("#TOTAL_PV").text($("#ori_TOTAL_PV").val());
			$("#PG_POLICY_AREA").css({"display":"block"});		//policy
			break;
		}
		case "Card" : {
			$("#BankInfo").css({"display":"none"});
			$("#CardInfo").css({"display":"none"});
			$("#vBankInfo").css({"display":"none"});
			//$("#mComplexInfo").css({"display":"none"});
			//$("#TOTAL_PV").text($("#ori_TOTAL_PV").val());
			break;
		}
		case "point" : {
			$("#BankInfo").css({"display":"none"});
			$("#CardInfo").css({"display":"none"});
			$("#vBankInfo").css({"display":"none"});
			//$("#mComplexInfo").css({"display":"none"});
			//$("#TOTAL_PV").text("0");
			break;
		}
		case "inCash" : {
			$("#BankInfo").css({"display":"none"});
			$("#CardInfo").css({"display":"none"});
			$("#vBankInfo").css({"display":"none"});
			//$("#mComplexInfo").css({"display":"none"});
			//$("#TOTAL_PV").text($("#ori_TOTAL_PV").val());		//PV=0
			break;
		}
		case "vBank" : {
			$("#BankInfo").css({"display":"none"});
			$("#CardInfo").css({"display":"none"});
			$("#vBankInfo").css({"display":"block"});
			//$("#mComplexInfo").css({"display":"none"});
			//$("#TOTAL_PV").text($("#ori_TOTAL_PV").val());
			break;
		}
		case "dBank" : {
			$("#BankInfo").css({"display":"none"});
			$("#CardInfo").css({"display":"none"});
			$("#vBankInfo").css({"display":"none"});
			//$("#mComplexInfo").css({"display":"none"});
			//$("#TOTAL_PV").text($("#ori_TOTAL_PV").val());
			break;
		}

		//mComplex 복합결제
		/*
		case "mComplex" : {
			alert("※다른 결제수단으로 변경 시 입력된 다카드결제정보는 모두 초기화 됩니다!");
			$("#CardInfo").css({"display":"none"});
			$("#BankInfo").css({"display":"none"});
			$("#vBankInfo").css({"display":"none"});
			$("#mComplexInfo").css({"display":"block"});
			$("#TOTAL_PV").text($("#ori_TOTAL_PV").val());
			$("#gopaymethod").val('mComplex');
			$("#PG_POLICY_AREA").css({"display":"block"});		//policy
			break;
		}
		*/
	}
	//resetAllmComplexInfo();		//복합결제 초기화
}



//카드종류구분
function chgCardKind(str){
	var f = document.orderFrm;
	switch (str)
	{
		case "P" : {						//일반신용
			$("#CardKind01").css({"display":"block"});
			$("#CardKind02").css({"display":"none"});
			//$("#CardKind03").css({"display":"none"});
			f.CorporateNumber.value = '';
			break;
		}
		case "C" : {
			$("#CardKind01").css({"display":"none"});
			$("#CardKind02").css({"display":"block"});
			//$("#CardKind03").css({"display":"none"});
			f.birthYY.value = '';
			f.birthMM.value = '';
			f.birthDD.value = '';
			break;
		}
		case "I" : {						//일반신용
			$("#CardKind01").css({"display":"block"});
			$("#CardKind02").css({"display":"none"});
			//$("#CardKind03").css({"display":"none"});
			f.CorporateNumber.value = '';
			break;
		}
		/*
		case "I" : {									//DAOU API 수기결제
			$("#CardKind01").css({"display":"none"});
			$("#CardKind02").css({"display":"none"});
			$("#CardKind03").css({"display":"block"});
			f.birthYY.value = '';
			f.birthMM.value = '';
			f.birthDD.value = '';
			f.CorporateNumber.value = '';
			break;
		}
		*/
		//default :{
		//}
	}

}



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
	openPopup("/common/pop_Zipcode.asp?target="+target, "Zipcode", 100, 100, "left=200, top=200");
}

// 받는분 정보 복사
function infoCopy(item) {
	var f = document.orderFrm;

	//alert(f.strName.value);

	if (item.checked) {
		f.takeName.value = f.strName.value;
		f.takeTel.value = f.strTel.value;
		f.takeMobile.value = f.strMobile.value;
		f.takeZip.value = f.strZip.value;
		f.takeADDR1.value = f.strADDR1.value;
		f.takeADDR2.value = f.strADDR2.value;
	} else {
		f.takeName.value = '';
		f.takeTel.value = '';
		f.takeMobile.value = '';
		f.takeZip.value = '';
		f.takeADDR1.value = '';
		f.takeADDR2.value = '';
	}
}


//$(document).on("keyup","input[name=useCmoney]",function () {		// data I/O XX
//	checkUseCmoney(this);
//});


// # 적립금 사용 : 시작 ######################################################################
function checkUseCmoney(item){
	var f = document.orderFrm;
	var msg = '';

	//alert(f.ownCmoney.value);

	/*
	if (!f.isUseCmoney.checked){
		item.value = "";
		alert("적립금 사용을 먼저 체크해주세요.");
		return false;
	}
	*/
	var cmoneyUseLimit = parseInt(f.cmoneyUseLimit.value, 10);
	var cmoneyUseMin = parseInt(f.cmoneyUseMin.value, 10);
	var cmoneyUseMax = parseInt(f.cmoneyUseMax.value, 10);
	var ownCmoney = parseInt(f.ownCmoney.value, 10);
	var orgSettlePrice = parseInt(f.orgSettlePrice.value, 10);
	var settlePrice = orgSettlePrice;
	var isUseCmoney = false;
	var useCmoney = (chkEmpty(f.useCmoney)) ? 0 : parseInt(stripComma(f.useCmoney.value), 10);
	var TOTAL_POINTUSE_MAX = (chkEmpty(f.TOTAL_POINTUSE_MAX)) ? 0 : parseInt(stripComma(f.TOTAL_POINTUSE_MAX.value), 10);		// 최대 포인트사용가능 금액 (웰니스)
	//var MIN_POINTUSE_POSSESION = (chkEmpty(f.MIN_POINTUSE_POSSESION)) ? 0 : parseInt(stripComma(f.MIN_POINTUSE_POSSESION.value), 10);	// 포인트사용에 필요한 최소보유포인트(GNT)

	if (useCmoney > 0) {

		//GNT - 포인트 는 10,000 Point 이상  소지 시 사용 가능, 사용 시 금액 한도 없이 사용가능
		//if (ownCmoney < MIN_POINTUSE_POSSESION) {
		//	msg = pointTXT +" 는 "+formatComma(MIN_POINTUSE_POSSESION) + pointTXT + " 이상  소지시 사용 가능합니다.";
		//}

		if (ownCmoney < cmoneyUseLimit) {
			msg = pointTXT +" 사용 금액은 "+formatComma(cmoneyUseLimit)+" 원 이상부터 사용 가능합니다.";
		}
		if (useCmoney < cmoneyUseMin) {
			msg = pointTXT +"는 최소 "+formatComma(cmoneyUseMin)+" 원 이상부터 사용 가능합니다.";
		}
		if (useCmoney > ownCmoney) {
			msg = "보유 하신 "+ pointTXT +"보다 많은 금액을 입력하셨습니다.";
		}
		if (useCmoney > settlePrice) {
			msg = "결제금액보다 많이 입력하셨습니다.";
		}
		/*
		if (useCmoney > TOTAL_POINTUSE_MAX) {
			msg = "결제가능한 포인트보다 많이 입력하셨습니다!\n(최대 "+formatComma(TOTAL_POINTUSE_MAX)+ " 포인트)";
		}
		*/
		if (msg == ''){
			isUseCmoney = true;
		}
		if (isUseCmoney) {
			calcSettlePrice();
			ThisMileage = true;
		} else {
			alert(msg);
			f.useCmoney.value = 0;
			calcSettlePrice();

				f.useCmoneyTF.value = 'F';		//point_check

			ThisMileage = false;
			doubleSubmit = false;
			return false;
		}

	} else {
		f.useCmoney.value = 0;
		calcSettlePrice();
		ThisMileage = false;
		doubleSubmit = false;
		return false;
	}
}


// 결제금액 계산
function calcSettlePrice() {

	var f = document.orderFrm;
	var totalCouponDiscountPrice, useCmoney;

	var orgSettlePrice = parseInt(f.orgSettlePrice.value, 10);

	if (f.useCmoney) {
		useCmoney = (f.useCmoney.disabled || chkEmpty(f.useCmoney)) ? 0 : parseInt(stripComma(f.useCmoney.value), 10);
	}
	var settlePrice = orgSettlePrice - useCmoney;

	f.totalPrice.value = settlePrice;
	//f.Amt.value = settlePrice;
	//f.AMOUNT.value = settlePrice;

	if (f.gopaymethod.value == "mComplex")
	{
		f.mComplexTotalPrice.value	= settlePrice;		//♠ 복합결제 결제하실 금액
		$("input[name=useCmoney]").addClass("readonly").attr("readonly",true);
	} else {
		$("input[name=useCmoney]").removeClass("readonly").attr("readonly",false);
	}

	$("#LastAreaID, #payArea, #mComplexTotal_TXT").text(formatComma(settlePrice));		//복합결제 포인트 사용시 추가 mComplexTotal_TXT

	point_check();		//point_check

}


//포인트 check
function point_check() {
	var f = document.orderFrm;

	//값 변동시에만 체크하자
	if (f.useCmoney.value != f.ori_useCmoney.value) {

		var ajaxTF = "false";
		$.ajax({
			type: "POST"
			,async : false
			,url: "/common/ajax_usePoint_confirm.asp"
			,data: {
				 "OIDX"				: f.OIDX.value
				,"OrderNum"			: f.OrdNo.value
				,"usePoint"			: f.useCmoney.value
				,"ori_totalPrice"	: f.ori_price.value
				,"totalDelivery"	: f.totalDelivery.value
			}

			,success: function(jsonData) {
				console.log(jsonData);
				var json = $.parseJSON(jsonData);
				//alert(json.result);
				console.log(json.result);
				if (json.result == "success")
				{
					f.useCmoneyTF.value = 'T';
					ajaxTF = "true";
					//alert(formatComma(json.resultData.usePoint) + " 포인트 사용");
				} else if (json.result == "minimum") {
					alert(json.message);
					f.useCmoneyTF.value = 'F';
					return false;
				} else {
					alert(json.message);
					f.useCmoneyTF.value = 'F';
					return false;
				}
			}
			,error:function(jsonData) {
				alert("ajax 처리 중 에러가 발생하였습니다.ERROR CODE : "+jsonData.status+" "+jsonData.statusText+" "+jsonData.responseText);
			}

		});

		if (ajaxTF != "true")
		{
			doubleSubmit = false;
			return false;
		}

	}
	f.ori_useCmoney.value = f.useCmoney.value;		//ori_useCmoney추가!!
}


//현금영수증 발행용도 구분
function chgC_HY_TF(str){
	var f = document.orderFrm;
	switch (str)
	{
		case "1" : {
			$("#C_HY_SendNum").show();
			$("#C_HY_SendNum_TXT").text("※ 휴대폰번호");
			f.C_HY_SendNum.value = "";
			break;
		}
		case "2" : {
			$("#C_HY_SendNum").show();
			$("#C_HY_SendNum_TXT").text("※ 사업자등록번호");
			f.C_HY_SendNum.value = "";
			break;
		}
		case "0" : {
			$("#C_HY_SendNum").hide();
			f.C_HY_SendNum.value = "";
			break;
		}
	}

}
