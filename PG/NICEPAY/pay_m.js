//SHOP 쇼핑몰구매
var pf;
var pointTXT = "C포인트";		//마일리지,포인트
var ThisMileage;
ThisMileage = false;

var pointTXT2 = "S포인트";		//GNG
var ThisMileage2;
ThisMileage2 = false;

function loadings() {
	var loadingBar = $("#loadings");

	loadingBar.toggle();
	$("#top").css({"opacity":"0.7","background-color":"#fff;"});		//모바일 상단 메뉴 안보임
	$(".header1").css({"display":"none"});

	$("#loadings").show();



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

	//var f = document.payForm;
	//doubleSubmit 체크
	if (!doubleSubmit) {		//false가 아닐때
		//alert(doubleSubmit+"-a");
		doubleSubmit = true;
		//alert(doubleSubmit+"-b");
	} else {
		//alert(doubleSubmit+"-c");
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
	if (f.useCmoney2.value == "")
	{
		f.useCmoney2.value = 0;
	}

	if (f.useCmoney2.value != "0")
	{
		checkUseCmoney2();
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
	}
	/*
	if (chkEmpty(f.strTel)) {
		alert("주문자 연락처가 비어있습니다");
		f.strTel.focus();
		doubleSubmit = false;
		return false;
	}
	*/
	if (chkEmpty(f.strZip) || chkEmpty(f.strADDR1) || chkEmpty(f.strADDR2)) {
		alert("주문자 주소가 비어있습니다");
		f.strZip.focus();
		doubleSubmit = false;
		return false;
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
		} else {
			f.BuyerEmail.value = f.strEmail.value;			//Nicepay Email
		}
	}

	if (chkEmpty(f.takeName)) {
		alert("받는분의 성함이 비어있습니다!!");
		f.takeName.focus();
		doubleSubmit = false;
		return false;
	}
	/*
	if (chkEmpty(f.takeTel)) {
		alert("받는분의 연락처가 비어있습니다");
		f.takeTel1.focus();
		doubleSubmit = false;
		return false;
	}
	*/
	if (chkEmpty(f.takeMobile)) {
		alert("받는분의 연락처가 비어있습니다");
		f.takeMobile.focus();
		doubleSubmit = false;
		return false;
	}
	if (f.DtoD.value == "T") {
		if (chkEmpty(f.takeZip) || chkEmpty(f.takeADDR1) || chkEmpty(f.takeADDR2))
		{
			alert("받는분의 주소가 비어있습니다");
			f.takeZip.focus();
			doubleSubmit = false;
			return false;
		}
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
		alert("무통장 결제시 C포인트를 사용할 수 없습니다  ");
		f.useCmoney.value = 0;
		calcSettlePrice();
		doubleSubmit = false;
		return false;
	}
	//▣ 무통장 + SP포인트결제 불가
	if (f.gopaymethod.value == 'inBank' && parseInt(f.useCmoney2.value, 10) > 0){
		alert("무통장 결제시 S포인트를 사용할 수 없습니다  ");
		f.useCmoney2.value = 0;
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
			f.useCmoney2.value = 0;
			calcSettlePrice();
			doubleSubmit = false;
			return false;
		}
		if ($("input[name=bankidx]:checked").length == 0)
		{
			alert("온라인 입금시 결제 은행을 선택해주셔야합니다.1");
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
		loadings();
		$("input[type=submit]").attr("disabled",true);			//double submit check
		f.target = "_self";
		f.action = "/PG/inBank_Result.asp";
		/*
		if (confirm("결제를 진행하시겠습니까?")) {
			loadings();
			$("input[type=submit]").attr("disabled",true);			//double submit check
			f.target = "_self";
			f.action = "/PG/inBank_Result.asp";
		} else {
			doubleSubmit = false;
			return false;
		}
		*/
	}

	//▣CP 결제▣
	if (f.gopaymethod.value == 'point')
	{

		var	ownCmoney = (f.ownCmoney.disabled || chkEmpty(f.ownCmoney)) ? 0 : parseInt(stripComma(f.ownCmoney.value), 10);
		var	ownCmoney2 = (f.ownCmoney2.disabled || chkEmpty(f.ownCmoney2)) ? 0 : parseInt(stripComma(f.ownCmoney2.value), 10);
		var	TOTAL_SP_POINTUSE_MAX = (f.TOTAL_SP_POINTUSE_MAX.disabled || chkEmpty(f.TOTAL_SP_POINTUSE_MAX)) ? 0 : parseInt(stripComma(f.TOTAL_SP_POINTUSE_MAX.value), 10);

		var	useCmoney = (f.useCmoney.disabled || chkEmpty(f.useCmoney)) ? 0 : parseInt(stripComma(f.useCmoney.value), 10);
		var useCmoney2 = (f.useCmoney2.disabled || chkEmpty(f.useCmoney2)) ? 0 : parseInt(stripComma(f.useCmoney2.value), 10);
		var orgSettlePrice = parseInt(f.orgSettlePrice.value, 10);

		//if (f.orgSettlePrice.value > f.ownCmoney.value)							//C포인트가 결제금액보다 부족할 시
		if (orgSettlePrice > ownCmoney)												//C포인트가 결제금액보다 부족할 시
		{
			f.useCmoney.value = (f.ownCmoney.value);								//C포인트 입력

			//if (f.orgSettlePrice.value - f.ownCmoney.value> f.TOTAL_SP_POINTUSE_MAX.value) { //결제가능SP포인트 부족
			if (orgSettlePrice - ownCmoney> TOTAL_SP_POINTUSE_MAX) {							//결제가능SP포인트 부족
				if (f.TOTAL_SP_POINTUSE_MAX.value > 0 ) {
					alert("결제가능한 "+pointTXT2+"가 부족합니다!!");
				} else {
					alert("결제가능한 "+pointTXT+"가 부족합니다!");
				}
				f.useCmoney.value = 0;
				f.useCmoney2.value = 0;
				checkUseCmoney();
				doubleSubmit = false;
				return false;
			}

			if (ownCmoney2 < orgSettlePrice - ownCmoney)				//SP포인트 부족
			{
				alert("포인트가 부족합니다");
				//alert(pointTXT2+"가 부족합니다");
				f.useCmoney.value = 0;
				f.useCmoney2.value = 0;
				checkUseCmoney();
				doubleSubmit = false;
				return false;
			}

			if (orgSettlePrice - useCmoney2 < ownCmoney)
			{
				f.useCmoney.value = (orgSettlePrice - useCmoney2);		//C포인트 + (SP포인트 일부) 결제시 [useCmoney 사용값]
			} else {

				if (orgSettlePrice > ownCmoney + useCmoney2)
				{
					//alert(orgSettlePrice);
					//alert(ownCmoney + useCmoney2);
					if (orgSettlePrice > ownCmoney) {
						alert("입력된"+pointTXT+"가 부족합니다\n"+pointTXT2+"값이 변경됩니다.\n("+formatComma(orgSettlePrice-ownCmoney)+")");
					}
					f.useCmoney2.value = (f.orgSettlePrice.value - f.ownCmoney.value);		//SP포인트 입력
					doubleSubmit = false;
					return false;
				}

			}
			checkUseCmoney();

		}else{
			f.useCmoney.value = (orgSettlePrice - useCmoney2);		//C포인트 + (SP포인트 일부) 결제시 [useCmoney 사용값]
			checkUseCmoney();
		}

		if (ThisMileage)
		{
			f.useCmoney.value = stripComma(f.useCmoney.value);
			f.target = "_self";
			document.charset = "UTF-8";

			if (confirm(pointTXT + " 결제를 진행하시겠습니까?")) {
				loadings();
				$("input[type=submit]").attr("disabled",true);			//double submit check
				f.target = "_self";
				f.action = "/PG/point_Result.asp";
			} else {
				f.useCmoney.value = 0;
				f.useCmoney2.value = 0;
				calcSettlePrice();
				doubleSubmit = false;
				return false;
			}

		} else {
			doubleSubmit = false;
			return false;
		}
	}

	//▣SP 단독 결제▣
	if (f.gopaymethod.value == 'point2')
	{
		var orgSettlePrice = parseInt(f.orgSettlePrice.value, 10);
		f.useCmoney2.value = formatComma(orgSettlePrice);
		checkUseCmoney();
		if (ThisMileage2)
		{
			f.useCmoney2.value = stripComma(f.useCmoney2.value);

			if (confirm(pointTXT2 + " 결제를 진행하시겠습니까?")) {
				loadings();
				$("input[type=submit]").attr("disabled",true);			//double submit check
				f.target = "_self";
				f.action = "/PG/point2_Result.asp";
			} else {
				f.useCmoney.value = 0;
				f.useCmoney2.value = 0;
				calcSettlePrice();
				doubleSubmit = false;
				return false;
			}

		} else {
			doubleSubmit = false;
			return false;
		}
	}

	/*
	if (f.gopaymethod.value == 'card' || f.gopaymethod.value == 'Card')			//NICEPAY API CARD 결제시
	{
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
		if (chkEmpty(f.birthYY) || chkEmpty(f.birthMM) || chkEmpty(f.birthDD)) {
			alert("생년월일을 입력해 주세요.");
			f.birthYY.focus();
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
		f.action = "/PG/NICEPAY/cardResult.asp";
	}
	*/

	if (f.gopaymethod.value == 'card' || f.gopaymethod.value == 'Card' || f.gopaymethod.value == 'vBank' || f.gopaymethod.value == 'Bank')
	{

		if (f.totalPrice.value < 1000){

			if (f.gopaymethod.value == 'card' || f.gopaymethod.value == 'Card'){
				msg ="카드";
			} else if (f.gopaymethod.value == 'vBank'){
				msg = "가상계좌";
			} else if (f.gopaymethod.value == 'Bank'){
				msg = "실시간계좌이체";
			}
			alert(msg+" 결제시 결제금액이 최소 1000원 이상이어야 합니다!!");
			f.useCmoney.value = 0;
			calcSettlePrice();
			doubleSubmit = false;
			return false;
		}

		if (f.gopaymethod.value == 'Card' || f.gopaymethod.value == 'card' || f.gopaymethod.value == 'vBank' || f.gopaymethod.value == 'Bank') {

			changeAmt();		//금액변경, hashString 세팅

			setTimeout(function(){
				//나이스페이 결제창오픈(모바일)
				document.charset = "euc-kr";									//나이스페이모바일 UTF-8 캐릭터셋 사용시 반드시 추가 "euc-kr"
				document.getElementById("payForm").acceptCharset = "euc-kr";	//나이스페이모바일 UTF-8 캐릭터셋 사용시 반드시 추가 "euc-kr"
				document.payForm.action= "https://web.nicepay.co.kr/smart/paySmart.jsp";
				document.payForm.submit();
			},500);

			return false;
		}

	}


	if (f.gopaymethod.value == 'CardAPI')
	{

		if (f.totalPrice.value < 1000){
			alert("카드 결제시 결제금액이 최소 1000원 이상이어야 합니다!");
			f.useCmoney.value = 0;
			f.useCmoney2.value = 0;
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
		if (chkEmpty(f.birthYY) || chkEmpty(f.birthMM) || chkEmpty(f.birthDD)) {
			alert("생년월일을 입력해 주세요.");
			f.birthYY.focus();
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
		f.action = "/PG/NICEPAY/cardResult.asp";
		/*
		if (confirm("카드결제를 진행하시겠습니까?")) {
			//document.getElementById("loadings").style.visibility="visible";
			loadings();
			$("input[type=submit]").attr("disabled",true);			//double submit check
			f.action = "/PG/NICEPAY/cardResult.asp";
		} else {
			doubleSubmit = false;
			return false;
		}
		*/

	}


//	if (parseInt(f.totalPrice.value,10) != parseInt(stripComma($("#lastTXT").text())))
//	{
//		alert("카드오류등으로 결제금액이 변동되었습니다. 새로고침 후 다시 시도해주세요");
//		return false;
//	}
	//alert(f.totalPrice.value);


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
	var f = document.payForm;

	if (item.checked) {
		f.takeName.value = f.strName.value;
		f.takeTel.value = f.strTel.value;
		f.takeMobile.value = f.strMobile.value;
		f.takeZip.value = f.strZip.value;
		f.takeADDR1.value = f.strADDR1.value;
		f.takeADDR2.value = f.strADDR2.value;
	}
	else {
		f.takeName.value = '';
		f.takeTel.value = '';
		f.takeMobile.value = '';
		f.takeZip.value = '';
		f.takeADDR1.value = '';
		f.takeADDR2.value = '';
	}
}




// # 적립금 사용 : 시작 ######################################################################
//C포인트사용  useCmoney
function checkUseCmoney(item){
	var f = document.payForm;
	var msg = '';
	//alert(f.ownCmoney.value);
	var cmoneyUseLimit = parseInt(f.cmoneyUseLimit.value, 10);
	var cmoneyUseMin = parseInt(f.cmoneyUseMin.value, 10);
	var cmoneyUseMax = parseInt(f.cmoneyUseMax.value, 10);
	var ownCmoney = parseInt(f.ownCmoney.value, 10);
	var orgSettlePrice = parseInt(f.orgSettlePrice.value, 10);
	var settlePrice = orgSettlePrice;
	var isUseCmoney = false;
	var useCmoney = (chkEmpty(f.useCmoney)) ? 0 : parseInt(stripComma(f.useCmoney.value), 10);
	var useCmoney2 = (chkEmpty(f.useCmoney2)) ? 0 : parseInt(stripComma(f.useCmoney2.value), 10);		//SP point
	var TOTAL_SP_POINTUSE_MAX = (chkEmpty(f.TOTAL_SP_POINTUSE_MAX)) ? 0 : parseInt(stripComma(f.TOTAL_SP_POINTUSE_MAX.value), 10);		// 최대 SP사용가능 금액 (애니페이)

	//alert(useCmoney + useCmoney2);
	//alert(TOTAL_SP_POINTUSE_MAX);

	if (useCmoney > 0) {

		if (ownCmoney < cmoneyUseLimit) {
			msg = pointTXT +" 사용 금액은 "+formatComma(cmoneyUseLimit)+" 원 이상부터 사용 가능합니다.";
		}
		if (useCmoney < cmoneyUseMin) {
			msg = pointTXT +"는 최소 "+formatComma(cmoneyUseMin)+" 원 이상부터 사용 가능합니다.";
		}
		//▣카드결제시 카드결제최소금액 체크▣
		if ((useCmoney + useCmoney2 > cmoneyUseMax) && (f.gopaymethod.value == 'card' || f.gopaymethod.value == 'vBank' || f.gopaymethod.value == 'dBank')) {
			msg = "카드/가상계좌 결제시 결제금액이 최소 1000원 이상이어야 합니다!";
		}
		if (useCmoney > ownCmoney) {
			msg = "보유 하신 "+ pointTXT +"보다 많은 금액을 입력하셨습니다.";
		}
		if (useCmoney > settlePrice) {
			msg = "결제금액보다 많이 입력하셨습니다.";
		}
		/*
		if ((useCmoney + useCmoney2) + TOTAL_SP_POINTUSE_MAX > settlePrice) {				//마일리지 + 포인트 최종합계금액과 비교!

			msg = "포인트 단독결제시 마일리지는 사용할 수 없습니다.";	//백낭 포인트 단독결제만 가능(2017-11-14)
			f.useCmoney.value = 0;
			f.useCmoney2.value = 0;
			calcSettlePrice();
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
			ThisMileage = false;
			return false;
		}

	} else {
		f.useCmoney.value = 0;
		calcSettlePrice();
		ThisMileage = false;
		return false;
	}


}



//S포인트사용  useCmoney2
function checkUseCmoney2(item){
	var f = document.payForm;
	var msg2 = '';
	 //alert(f.ownCmoney2.value);
	var cmoneyUseLimit = parseInt(f.cmoneyUseLimit.value, 10);
	var cmoneyUseMin = parseInt(f.cmoneyUseMin.value, 10);
	var cmoneyUseMax = parseInt(f.cmoneyUseMax.value, 10);
	var ownCmoney2 = parseInt(f.ownCmoney2.value, 10);
	var orgSettlePrice = parseInt(f.orgSettlePrice.value, 10);
	var settlePrice = orgSettlePrice;
	var isUseCmoney2 = false;
	var useCmoney2 = (chkEmpty(f.useCmoney2)) ? 0 : parseInt(stripComma(f.useCmoney2.value), 10);
	var TOTAL_SP_POINTUSE_MAX = (chkEmpty(f.TOTAL_SP_POINTUSE_MAX)) ? 0 : parseInt(stripComma(f.TOTAL_SP_POINTUSE_MAX.value), 10);		// 최대 SP사용가능 금액 (애니페이)

	//alert(TOTAL_SP_POINTUSE_MAX+useCmoney2);
	//alert(settlePrice);

	if (useCmoney2 > 0) {

		if (ownCmoney2 < cmoneyUseLimit) {
			msg2 = pointTXT2 +" 사용 금액은 "+formatComma(cmoneyUseLimit)+" 원 이상부터 사용 가능합니다.";
		}
		if (useCmoney2 < cmoneyUseMin) {
			msg2 = pointTXT2 +"는 최소 "+formatComma(cmoneyUseMin)+" 원 이상부터 사용 가능합니다.";
		}
		//▣카드결제시 카드결제최소금액 체크▣
		if ((useCmoney2  > cmoneyUseMax) && (f.gopaymethod.value == 'card' || f.gopaymethod.value == 'vBank' || f.gopaymethod.value == 'dBank')) {
			msg2 = "카드/가상계좌/실시간계좌이체 결제시 결제금액이 최소 1000원 이상이어야 합니다!!!";
		}
		if (useCmoney2 > ownCmoney2) {
			msg2 = "보유 하신 "+ pointTXT2 +"보다 많은 금액을 입력하셨습니다.";
		}
		if (useCmoney2 > TOTAL_SP_POINTUSE_MAX) {
			msg2 = "결제가능한 SP포인트보다 많이 입력하셨습니다!\n(최대 "+formatComma(TOTAL_SP_POINTUSE_MAX)+ " 포인트)";
		}
		if (useCmoney2 > settlePrice) {
			msg2 = "결제금액보다 많이 입력하셨습니다.";
		}
		/*
		if ((useCmoney2 + useCmoney) > settlePrice) {				//마일리지 + 포인트 최종합계금액과 비교!
			//msg2 = "결제금액보다 많이 입력하셨습니다.!!";
			msg2 = "포인트 단독결제시 마일리지는 사용할 수 없습니다.";	//메이저스트 포인트 단독결제만 가능(2017-02-22)
			f.useCmoney.value = 0;
			f.useCmoney2.value = 0;
			calcSettlePrice();
		}
		*/
		if (msg2 == ''){
			isUseCmoney2 = true;
		}
		if (isUseCmoney2) {
			calcSettlePrice();
			ThisMileage2 = true;
		}else {
			alert(msg2);
			f.useCmoney2.value = 0;
			calcSettlePrice();
			ThisMileage2 = false;
			return false;
		}

	} else {
		f.useCmoney2.value = 0;
		calcSettlePrice();
		ThisMileage = false;
		return false;
	}


}




// 결제금액 계산
function calcSettlePrice() {
	var f = document.payForm;
	var totalCouponDiscountPrice, useCmoney, useCmoney2;;

	//var orgSettlePrice = parseInt(f.orgSettlePrice.value, 10);
	var orgSettlePrice = parseFloat(f.orgSettlePrice.value, 10);
	var ori_delivery = parseFloat(f.ori_delivery.value, 10);

	if (f.useCmoney) {
		useCmoney = (f.useCmoney.disabled || chkEmpty(f.useCmoney)) ? 0 : parseFloat(stripComma(f.useCmoney.value), 10);
	}
	//SP포인트
	if (f.useCmoney2) {
		useCmoney2 = (f.useCmoney2.disabled || chkEmpty(f.useCmoney2)) ? 0 : parseFloat(stripComma(f.useCmoney2.value), 10);
	}

	//var settlePrice = orgSettlePrice - useCmoney;
	var settlePrice = orgSettlePrice - (useCmoney + useCmoney2);	// - (C포인트 + SP포인트)

	//직접수령
	if (f.DtoD.value == "F") {
		settlePrice = settlePrice - ori_delivery;
	}

	f.totalPrice.value = settlePrice;
	f.Amt.value		   = settlePrice;			//NICEPAY 결제금

	//document.getElementById("lastTXT").innerHTML = formatComma(settlePrice);
	document.getElementById("lastTXT").innerHTML = NumberFormatter.format(settlePrice);
	//document.getElementById("payArea").innerHTML = formatComma(settlePrice);
	//document.getElementById("PointArea").innerHTML = formatComma(useCmoney);
	//document.getElementById("viewPoint").innerHTML = formatComma(useCmoney);
}




function resetUseCmoney() {
	var f = document.payForm;

	document.getElementById("showTotalCmoney").innerHTML = "0";
}








//#################### NICEPAY ####################

	// NICEPAY 금액 변동시 ajax처리
	// 모바일 결제 시 /m/shop/order_direct.js : if (DtoD == 'F')  price 값 반드시 확인!!!

	function changeAmt() {
		//NicePayUpdate();	//Active-x 초기화 함수
		var ajaxTF = "false";

		$.ajax({
			type: "POST"
			,async : false
			,url: "/PG/NICEPAY/ajax_AmtChange.asp"
			,data: {
				 "EdiDate"	: $("#EdiDate").val()
				,"Amt"		: $("#Amt").val()
			}
			,success: function(data) {
				$("#EncryptData").val(data)
				ajaxTF = "true";
			}
			,error:function(data) {
				alert("ajax 처리 중 에러가 발생하였습니다.ERROR CODE : "+data.status+" "+data.statusText+" "+data.responseText);
			}
		});

		if (ajaxTF != "true")
		{
			doubleSubmit = false;
			return false;
		}
	}


//#################### NICEPAY ####################

