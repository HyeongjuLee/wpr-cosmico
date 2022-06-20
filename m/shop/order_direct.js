/*한글 */


	function checkpayType() {
		var payKind = $("input[name=paykind]:checked").val();
		var DtoD = $("input[name=DtoD]:checked").val();

		if (payKind == 'Card')
		{
			$("#CardInfo").css({"display":"none"});
			$("#BankInfo").css({"display":"none"});
			$("#gopaymethod").val('Card');
			$("#PayMethod").val('CARD');
				$("input[name=useCmoney]").addClass("readonly").attr("readonly",true);
				$("input[name=useCmoney2]").removeClass("readonly").attr("readonly",false);
				//$("#pointTXT").text('');
				////$("#Fwon").text('원');
		}
		if (payKind == 'CardAPI')
		{
			$("#CardInfo").css({"display":"block"});
			$("#BankInfo").css({"display":"none"});
			$("#gopaymethod").val('CardAPI');			//CardAPI
			$("#PayMethod").val('CARD');
				$("input[name=useCmoney]").addClass("readonly").attr("readonly",true);
				$("input[name=useCmoney2]").removeClass("readonly").attr("readonly",false);		
		}
		if (payKind == 'inBank')
		{
			$("#CardInfo").css({"display":"none"});
			$("#BankInfo").css({"display":"block"});
			$("#gopaymethod").val('inBank');
			$("#PayMethod").val('INBANK');
				$("input[name=useCmoney]").addClass("readonly").attr("readonly",true).val(0);		
				$("input[name=useCmoney2]").addClass("readonly").attr("readonly",true).val(0);		
				//$("#pointTXT").text('');
				////$("#Fwon").text('원');
				//calcSettlePrice();
		}
		if (payKind == 'point')
		{

			$("#BankInfo").css({"display":"none"});
			$("#CardInfo").css({"display":"none"});
			$("#gopaymethod").val('point');
			$("#PayMethod").val('POINT');
				$("input[name=useCmoney]").addClass("readonly").attr("readonly",true).val(0);		
				$("input[name=useCmoney2]").removeClass("readonly").attr("readonly",false);			
				calcSettlePrice();
		}	
		if (payKind == 'point2')
		{

			$("#BankInfo").css({"display":"none"});
			$("#CardInfo").css({"display":"none"});
			$("#gopaymethod").val('point2');
			$("#PayMethod").val('POINT2');
				$("input[name=useCmoney]").addClass("readonly").attr("readonly",true).val(0);		
				$("input[name=useCmoney2]").removeClass("readonly").attr("readonly",false);				
				calcSettlePrice();
		}	
		if (payKind == 'vBank')
		{

			$("#CardInfo").css({"display":"none"});
			$("#BankInfo").css({"display":"none"});
			$("#gopaymethod").val('vBank');
			$("#PayMethod").val('VBANK');
				$("input[name=useCmoney]").addClass("readonly").attr("readonly",true).val(0);		
				$("input[name=useCmoney2]").addClass("readonly").attr("readonly",true).val(0);		
				//$("#pointTXT").text('');
				////$("#Fwon").text('원');
		}
		if (payKind == 'Bank')		//실시간계좌이체
		{

			$("#CardInfo").css({"display":"none"});
			$("#BankInfo").css({"display":"none"});
			$("#gopaymethod").val('Bank');
			$("#PayMethod").val('BANK');
				$("input[name=useCmoney]").removeClass("readonly").attr("readonly",false);
				$("input[name=useCmoney2]").removeClass("readonly").attr("readonly",false);
				//$("#pointTXT").text('');
				////$("#Fwon").text('원');
		}
	/*
		var useCmoney = $("input[name=ori_price]").val() * 1;
		//var price = $("input[name=ori_price]").val() * 1;
		var price = $("#Amt").val() * 1;							//NICEPAY!!!
		var deliFee = $("input[name=ori_delivery]").val() * 1;
		if (DtoD == 'F')
		{
			$("input[name=totalPrice]").val((price - deliFee) * 1);
			$("input[name=totalDelivery]").val(0);
			$("#delTXT").text('현장수령으로 배송비 미부과');
			$("#priTXT").text(0);
			$("#lastTXT").text(formatComma((price - deliFee) * 1));
		} else {
			$("input[name=totalPrice]").val(price);
			$("input[name=totalDelivery]").val(deliFee);
			$("#delTXT").text("");
			$("#priTXT").text(deliFee);
			$("#lastTXT").text(formatComma(price));
		}
	*/

	}





	//카드종류구분
	function chgCardKind(str){
		var f = document.frmConfirm;
		switch (str)
		{
			case "P" : {						//일반신용
				$("#CardKind01").css({"display":"block"});
				$("#CardKind02").css({"display":"none"});
				//$("#CardKind03").css({"display":"none"});
				f.CorporateNumber.value = '';
				//f.ssh1.value = '';
				//f.ssh2.value = '';
				break;
			}
			case "C" : {
				$("#CardKind01").css({"display":"none"});
				$("#CardKind02").css({"display":"block"});
				//$("#CardKind03").css({"display":"none"});
				f.birthYY.value = '';
				f.birthMM.value = '';
				f.birthDD.value = '';
				//f.ssh1.value = '';
				//f.ssh2.value = '';
				break;
			}
			case "I" : {						//일반신용
				$("#CardKind01").css({"display":"block"});
				$("#CardKind02").css({"display":"none"});
				//$("#CardKind03").css({"display":"none"});
				f.CorporateNumber.value = '';
				//f.ssh1.value = '';
				//f.ssh2.value = '';
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