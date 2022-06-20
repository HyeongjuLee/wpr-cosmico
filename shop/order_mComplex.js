

$(document).ready(function() {
	
	//초기화
	var f = document.orderFrm;			//OFOFFKOREA

	//f.gopaymethod.value = ""

	f.useCmoney.value	 = 0;

	calcSettlePrice();

	//CheckBox,Radio Btn 해제
	if ($("#gopaymethod").val() == "mComplex")	
	{
		$("input:checked").each(function() {
			$(this).prop("checked",false);
		});
	}

	//복합결제 초기화
	resetAllmComplexInfo();		


	//$(document).on("click",".CardAdd",function(){
	$("#CardAdd").on("click", function(){

		var option2 = '<option value="00">일시불</option>';
		var thisLeng = $("#mComplexInfo .CardInfo").length;
		if (thisLeng >= 3)
		{
			alert("카드는 최대 3개까지만 선택할 수 있습니다");
			return false;
		} else {
			var divs = $("#mComplexInfo").find("div.CardInfo:last");
			divs.clone().insertAfter(divs).find("input[type=text], input[type=password], input[type=hidden], select").val('');		//카드입력(복제)추가, value = ""
			
			//추가된 카드번호 표기   (카드#1, 카드 #2 ...)
			var spanAddNum = $("#mComplexInfo").find("div.CardInfo:last span.cardAddNum");
			$("#mComplexInfo").find("div.CardInfo:last select[name=mQuotabase]").html(option2);
			spanAddNum.text($("#mComplexInfo .CardInfo").length);
			

			//앞카드 [금액적용] → [재적용] 후 [카드추가시],  [재적용]버튼 text,css변경 to [금액적용]
			var addDivs = $("#mComplexInfo").find("div.CardInfo:last");
			addDivs.find("input[name=CardVld]").val('F');
			addDivs.find("a.a_submit").removeClass("design2 r_submitPrice_Card").addClass("design3 submitPrice_Card").text("금액적용");
			addDivs.find("input[name=CardPrice]").removeClass("readonly").attr("readonly",false);

		}
	});


	// 마지막카드 삭제버튼 액션
		$(document).on("click",".CardRmv",function(){

			var thisLeng = $("#mComplexInfo .CardInfo").length;
			if (thisLeng < 2) {
				alert("카드가 1개 이하입니다. 카드결제는 최소 1개 이상의 카드정보가 필요합니다.");
				return false;
			} else {
				$("#mComplexInfo").find("div.CardInfo:last").remove();

				//금액적용된 전체 결제수단 계산
				calc_mComplexTotalPrice();
			}

		});


	// 카드 금액적용 버튼 액션
		$(document).on("click",".submitPrice_Card",function(){
			var option1 = '<option value="00">일시불</option><option value="02">2개월</option><option value="03">3개월</option><option value="04">4개월</option><option value="05">5개월</option><option value="06">6개월</option><option value="07">7개월</option><option value="08">8개월</option><option value="09">9개월</option><option value="10">10개월</option><option value="11">11개월</option><option value="12">12개월</option>';
			var option2 = '<option value="00">일시불</option>';
			var quotabaseChg		= $(this).closest("table").find("select[name=mQuotabase]");
			var priceCheck			= $(this).closest("td").find("input[name=CardPrice]");
			var CardVld				= $(this).closest("td").find("input[name=CardVld]");
			var mComplexTotalPrice	= $("#mComplexInfo input[name=mComplexTotalPrice]").val() * 1;			//결제할 금액
			var mCardTotal	 = 0;			
			var mBankTotal	 = 0;
			var mCashTotal	 = 0;
			var mComplexTotal= 0;

			if ((priceCheck.val() * 1) < 1000 || priceCheck.val() == '') {
				alert("카드결제는 1000원이하를 결제할 수 없습니다. 금액을 입력후 확인을 해주세요.");
				return false;
			} else {

				$("#mComplexInfo .CardInfo input[name=CardPrice]").each(function() {
					if ($.trim($(this).val()) == '') {
						$(this).val(0);
					}
					mCardTotal = mCardTotal + ($(this).val() * 1);
				});
				mBankTotal = ($("#mComplexInfo input[name=BankPrice]").val() * 1);					
				mCashTotal = ($("#mComplexInfo input[name=CashPrice]").val() * 1);					

				var mComplexTotal = (mCardTotal + mBankTotal + mCashTotal);

				if (mComplexTotal > mComplexTotalPrice) {
					alert("결제하실 금액보다 많은 금액을 입력하셨습니다");
					priceCheck.val(0);
					CardVld.val('F');	
				} else {
					CardVld.val('T');
					if ((priceCheck.val() *1) > 49999) {
						quotabaseChg.html(option1);
					} else {
						quotabaseChg.html(option2);
					}
					$(this).removeClass("design3 submitPrice_Card").addClass("design2 r_submitPrice_Card").text("재적용");
					priceCheck.addClass("readonly").attr("readonly",true);
				}

				//금액적용된 전체 결제수단 계산
				calc_mComplexTotalPrice();

			}
		});


	//★무통장 금액적용
		$(document).on("click",".submitPrice_Bank",function(){

			var priceCheck	= $("#mComplexInfo input[name=BankPrice]")
			var BankVld		= $("#mComplexInfo input[name=BankVld]")
			var mComplexTotalPrice	= $("#mComplexInfo input[name=mComplexTotalPrice]").val() * 1;			//결제할 금액
			var mCardTotal	 = 0;			
			var mBankTotal	 = 0;
			var mCashTotal	 = 0;
			var mComplexTotal= 0;

			if ((priceCheck.val() * 1) < 500 || priceCheck.val() == '') {
				alert("무통장 결제는 500원이하를 결제할 수 없습니다. 금액을 입력후 확인을 해주세요.");
				return false;
			} else {
				
				var BankPrice	= ($("#mComplexInfo input[name=BankPrice]").val() * 1);	
				var mCardTotal	= ($("#mComplexInfo input[name=mCardTotal]").val() * 1);		
				var mCashTotal	= ($("#mComplexInfo input[name=mCashTotal]").val() * 1);		

				mBankTotal = BankPrice;
				
				var mComplexTotal = (mCardTotal + mBankTotal + mCashTotal);

				if (mComplexTotal > mComplexTotalPrice) {
					alert("결제하실 금액보다 많은 금액을 입력하셨습니다");
					priceCheck.val(0);
					BankVld.val('F');
				} else {
					BankVld.val('T');
					$(this).removeClass("design3 submitPrice_Bank").addClass("design2 r_submitPrice_Bank").text("재적용");
					priceCheck.addClass("readonly").attr("readonly",true);
				}

				//금액적용된 전체 결제수단 계산
				calc_mComplexTotalPrice();

			}
		});


	//★현금 금액적용
		$(document).on("click",".submitPrice_Cash",function(){

			var priceCheck	= $("#mComplexInfo input[name=CashPrice]")
			var CashVld		= $("#mComplexInfo input[name=CashVld]")
			var mComplexTotalPrice	= $("#mComplexInfo input[name=mComplexTotalPrice]").val() * 1;			//결제할 금액
			var mCardTotal	 = 0;			
			var mBankTotal	 = 0;
			var mCashTotal	 = 0;
			var mComplexTotal= 0;

			if ((priceCheck.val() * 1) < 500 || priceCheck.val() == '') {
				alert("현금 결제는 500원이하를 결제할 수 없습니다. 금액을 입력후 확인을 해주세요.");
				return false;
			} else {				

				var CashPrice	= ($("#mComplexInfo input[name=CashPrice]").val() * 1);	
				var mCardTotal	= ($("#mComplexInfo input[name=mCardTotal]").val() * 1);		
				var mBankTotal	= ($("#mComplexInfo input[name=mBankTotal]").val() * 1);		

				mCashTotal = CashPrice;
				
				var mComplexTotal = (mCardTotal + mBankTotal + mCashTotal);

				if ((mComplexTotal) > mComplexTotalPrice) {
					alert("결제하실 금액보다 많은 금액을 입력하셨습니다");
					priceCheck.val(0);
					CashVld.val('F');
				} else {
					CashVld.val('T');
					$(this).removeClass("design3 submitPrice_Cash").addClass("design2 r_submitPrice_Cash").text("재적용");
					priceCheck.addClass("readonly").attr("readonly",true);
				}

				//금액적용된 전체 결제수단 계산
				calc_mComplexTotalPrice();

			}
		});


	// 금액 재적용 버튼 액션(Card, Bank, Cash)
		$(document).on("click",".r_submitPrice_Card",function(){
			var priceCheck = $(this).closest("td").find("input[name=CardPrice]");
			var CardVld = $(this).closest("td").find("input[name=CardVld]");

			CardVld.val('F');
			$(this).removeClass("design2 r_submitPrice_Card").addClass("design3 submitPrice_Card").text("금액적용");
			priceCheck.removeClass("readonly").attr("readonly",false);

			calc_mComplexTotalPrice();
		});

		$(document).on("click",".r_submitPrice_Bank",function(){
			var priceCheck	= $("#mComplexInfo input[name=BankPrice]")
			var BankVld		= $("#mComplexInfo input[name=BankVld]")

			BankVld.val('F');
			$(this).removeClass("design2 r_submitPrice_Bank").addClass("design3 submitPrice_Bank").text("금액적용");
			priceCheck.removeClass("readonly").attr("readonly",false);
			
			calc_mComplexTotalPrice();
		});

		$(document).on("click",".r_submitPrice_Cash",function(){
			var priceCheck	= $("#mComplexInfo input[name=CashPrice]")
			var CashVld		= $("#mComplexInfo input[name=CashVld]")

			CashVld.val('F');
			$(this).removeClass("design2 r_submitPrice_Cash").addClass("design3 submitPrice_Cash").text("금액적용");
			priceCheck.removeClass("readonly").attr("readonly",false);

			calc_mComplexTotalPrice();
		});


		//다중복합결제의 결제수단 보임 /초기화 처리
		$("#BankChk").change(function() {
			if ($("#BankChk").is(":checked")){
				$("#mComplexInfo .BankInfo").show();
			} else {
				if (confirm("※선택 해제시 입력된 정보는 모두 초기화 됩니다."))				{
					resetAllBankInfo();
					$("#mComplexInfo .BankInfo").hide();
				} else {
					$("input:checkbox[name='BankChk']").attr("checked", true)
				}
			}
		});
		$("#CashChk").change(function(){
			if ($("#CashChk").is(":checked")){
				$("#mComplexInfo .CashInfo").show();
			} else {
				if (confirm("※선택 해제시 입력된 정보는 모두 초기화 됩니다!"))
				{
					resetAllCashInfo();
					$("#mComplexInfo .CashInfo").hide();
				} else {
					$("input:checkbox[name='CashChk']").attr("checked", true)
				}
			}
		});
				

});


//복합결제 reset
function resetAllmComplexInfo() {

	var resetInput = $("#mComplexInfo");	

	resetInput.find("input[type=text], input[type=password], select").val('');
	resetInput.find("input[name=CardVld]").val('F');
	resetInput.find("input[name=BankVld]").val('F');
	resetInput.find("input[name=CashVld]").val('F');
	resetInput.find("input[name=mCardTotal]").val(0);
	resetInput.find("input[name=mBankTotal]").val(0);
	resetInput.find("input[name=mCashTotal]").val(0);
	resetInput.find("input[name=mComplexTotal]").val(0);

	//다른결제수단에서 복합결제 클릭시 초기화	(복합결제 -> 타결제 -> 복합결제)
	resetInput.find("input[name=CardPrice]").removeClass("readonly").attr("readonly",false);
	resetInput.find("input[name=BankPrice]").removeClass("readonly").attr("readonly",false);
	resetInput.find("input[name=CashPrice]").removeClass("readonly").attr("readonly",false);

	$("#mComplexInfo .CardInfo").find("a.a_submit").removeClass("design2 r_submitPrice_Card").addClass("design3 submitPrice_Card").text("금액적용");
	$("#mComplexInfo .BankInfo").find("a.a_submit").removeClass("design2 r_submitPrice_Bank").addClass("design3 submitPrice_Bank").text("금액적용");
	$("#mComplexInfo .CashInfo").find("a.a_submit").removeClass("design2 r_submitPrice_Cash").addClass("design3 submitPrice_Cash").text("금액적용");


	var mComplexTotalPrice	= $("#mComplexInfo input[name=mComplexTotalPrice]").val() * 1;			//결제할 금액

	$("#mCardTotal_TXT").text(formatComma(mComplexTotalPrice));					
	$("#mComplexTotal_TXT").text(formatComma(mComplexTotalPrice));				
	$("#mComplexInfo div.CardInfo:not(:first)").remove();

	$("#mComplexInfo .BankInfo").hide();
	$("#mComplexInfo .CashInfo").hide();
	$("input:checkbox[name='BankChk']").attr("checked", false)
	$("input:checkbox[name='CashChk']").attr("checked", false)

	calcSettlePrice();
}



//복합결제(무통장) reset
function resetAllBankInfo() {
	var resetInput = $("#mComplexInfo .BankInfo");	

	resetInput.find("input[type=text], input[type=password], select check").val('');
	resetInput.find("input[name=BankVld]").val('F');
	resetInput.find("input[name=mBankTotal]").val(0);
	resetInput.find("a.a_submit").removeClass("design2 r_submitPrice_Bank").addClass("design3 submitPrice_Bank").text("금액적용");
	resetInput.find("input[name=BankPrice]").removeClass("readonly").attr("readonly",false);
	resetInput.find("input:radio[name=mBankidx]:checked").attr("checked", false);

	var mComplexTotalPrice	= $("#mComplexInfo input[name=mComplexTotalPrice]").val() * 1;			//결제할 금액

	$("#mCardTotal_TXT").text(formatComma(mComplexTotalPrice));					
	$("#mComplexTotal_TXT").text(formatComma(mComplexTotalPrice));				

	calc_mComplexTotalPrice();
}

//복합결제(현금) reset
function resetAllCashInfo() {
	var resetInput = $("#mComplexInfo .CashInfo");	

	resetInput.find("input[type=text], input[type=password], select check").val('');
	resetInput.find("input[name=CashVld]").val('F');
	resetInput.find("input[name=mCashTotal]").val(0);
	resetInput.find("a.a_submit").removeClass("design2 r_submitPrice_Cash").addClass("design3 submitPrice_Cash").text("금액적용");
	resetInput.find("input[name=CashPrice]").removeClass("readonly").attr("readonly",false);
	
	var mComplexTotalPrice	= $("#mComplexInfo input[name=mComplexTotalPrice]").val() * 1;			//결제할 금액

	$("#mCardTotal_TXT").text(formatComma(mComplexTotalPrice));					
	$("#mComplexTotal_TXT").text(formatComma(mComplexTotalPrice));				

	calc_mComplexTotalPrice();
}



//금액적용된 전체 결제수단 계산
function calc_mComplexTotalPrice() {

	var mCardTotal = 0;
	var mBankTotal = 0;
	var mCashTotal = 0;
	var mComplexTotal = 0;
	var mComplexTotalPrice = 0;

	$("#mComplexInfo .CardInfo input[name=CardPrice]").each(function() {
		var CardVld = $(this).closest("td").find("input[name=CardVld]");	
		if (CardVld.val() == "T") {																	
			if ($.trim($(this).val()) == '') {
				$(this).val(0);
			}
			mCardTotal = mCardTotal + ($(this).val() * 1);
		}			
	});

	var BankVld = $("#mComplexInfo input[name=BankVld]")		
	if (BankVld.val() == "T") {	
		mBankTotal = ($("#mComplexInfo input[name=BankPrice]").val() * 1);	
	}

	var CashVld	= $("#mComplexInfo input[name=CashVld]")		
	if (CashVld.val() == "T") {	
		mCashTotal = ($("#mComplexInfo input[name=CashPrice]").val() * 1);	
	}

	mComplexTotal = (mCardTotal + mBankTotal + mCashTotal);
	//console.log(mComplexTotal);

	$("#mComplexInfo input[name=mCardTotal]").val(mCardTotal);
	$("#mComplexInfo input[name=mBankTotal]").val(mBankTotal);
	$("#mComplexInfo input[name=mCashTotal]").val(mCashTotal);
	$("#mComplexInfo input[name=mComplexTotal]").val(mComplexTotal);

	var mComplexTotalPrice	= $("#mComplexInfo input[name=mComplexTotalPrice]").val() * 1;		//결제할 금액
	$("#mComplexTotal_TXT").text(formatComma(mComplexTotalPrice - mComplexTotal));				//남은 결제 금액

}



