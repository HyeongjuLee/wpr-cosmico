$(document).ready(function(){
	$(':radio[name="pays"]').click(function(){

		var viewVar = $(':radio[name="pays"]:checked').val()
		if (viewVar == "Card1" || viewVar == "Card2")
		{
			$("#pays1view").css("cssText","display:table-row-group;");
			$("#pays2view").css("cssText","display:none;");
			$("#pays3view").css("cssText","display:none;");
			if (viewVar == "Card1")
			{
//				$("#mid").val("INIpayTest");
				$("#mid").val("healthyli4");
			} else if (viewVar == "Card2")
			{
//				$("#mid").val("INIBillTst");
				$("#mid").val("healthyli5");
			}
			$("#paysKind").val("Card");

		}
		if (viewVar == "inCash")
		{
			$("#pays1view").css("cssText","display:none;");
			$("#pays2view").css("cssText","display:table-row-group;");
			$("#pays3view").css("cssText","display:none;");
			$("#paysKind").val("inCash");
		}
		if (viewVar == "inBank")
		{
			$("#pays1view").css("cssText","display:none;");
			$("#pays2view").css("cssText","display:none;");
			$("#pays3view").css("cssText","display:table-row-group;");
			$("#paysKind").val("inBank");
		}

	});



});

function openzip() {
	openPopup("/common/pop_Zipcode.asp?target=ori", "Zipcodes", 0, 0, "");
}




var openwin;

function pay()
{

	var f = document.ini;


	if (f.strName.value == "")
	{
		alert("받으시는 분이 비어있습니다.");
		f.strName.focus();
		return false;
	}
	if (f.strZip.value == "")
	{
		alert("우편번호가 비어있습니다.");
		f.strZip.focus();
		return false;
	}
	if (f.strAddr1.value == "")
	{
		alert("주소가 비어있습니다.");
		f.strAddr1.focus();
		return false;
	}
	if (f.strAddr2.value == "")
	{
		alert("상세주소가 비어있습니다.");
		f.strAddr2.focus();
		return false;
	}
	/*
	if (f.strTel.value == "")
	{
		alert("전화번호가 비어있습니다.");
		f.strTel.focus();
		return false;
	}*/
	if (f.strMobile.value == "")
	{
		alert("휴대폰번호가 비어있습니다.");
		f.strMobile.focus();
		return false;
	}

	if (!checkEmail(f.strEmail.value)) {
		alert("형식에 맞지 않는 이메일 주소입니다.\n\n이메일 주소를 정확하게 입력해 주세요.");
		f.strEmail.focus();
		return false;
	}

	if (f.v_SellCode.value=='')
	{
		alert("구매종류를 선택해주세요.");
		f.v_SellCode.focus();
		return false;
	}
/*
	if (f.v_Receive_Method.value=='')
	{
		alert("배송구분을 선택해주세요.");
		f.v_Receive_Method.focus();
		return false;
	}
*/
	if (f.paysKind.value=='')
	{
		alert("결제방식을 선택해주세요.");
		f.pays[0].focus();
		return false;
	}





	if (f.paysKind.value == "Card" || f.paysKind.value == "Card"){
		f.buyername.value = f.strName.value;
		f.buyertel.value = f.strMobile.value;
		f.buyeremail.value = f.strEmail.value;
		f.cardnumber.value = f.cardNm1.value + f.cardNm2.value + f.cardNm3.value + f.cardNm4.value;

		if(f.goodname.value == "")
		{
			alert("상품명이 빠졌습니다. 필수항목입니다.");
			return false;
		}
		else if(f.price.value == "")
		{
			alert("결제금액이 빠졌습니다. 필수항목입니다.");
			return false;
		}
		else if(f.buyername.value == "")
		{
			alert("구매자명이 빠졌습니다. 필수항목입니다.");
			return false;
		}
		else if(f.buyeremail.value == "")
		{
			alert("구매자 이메일주소가 빠졌습니다. 필수항목입니다.");
			return false;
		}
		else if(f.buyertel.value == "")
		{
			alert("구매자 연락처가 빠졌습니다. 필수항목입니다.");
			return false;
		}
		else if(f.cardnumber.value == "")
		{
			alert("신용카드 번호가 빠졌습니다. 필수항목입니다.");
			return false;
		}
		else if(f.authfield1.value == "")
		{
			alert("주민등록번호가 빠졌습니다. 필수항목입니다.");
			return false;
		}
		else if(f.authfield2.value == "")
		{
			alert("카드비밀번호 앞 2자리가 빠졌습니다. 필수항목입니다.");
			return false;
		}

		if(confirm("결제하시겠습니까?"))
		{
			f.action = "orders_ing_card.asp";
			disable_click();
			openwin = window.open("/PG/INICIS_FORMPAY/childwin.html","childwin","");
			f.submit();
		} else {
			return false;
		}


	} else if (f.paysKind.value == "inCash"){

		if (confirm("현장에서 결제하시겠습니까?"))
		{
			f.action = "orders_ing_etc.asp";
		}else{
			f.action = "orders_ing_card.asp";
			return false;
		}
	} else if (f.paysKind.value == "inBank"){
		if (f.C_codeName.value == "")
		{
			alert("무통장 입금거래서 입금하실 은행을 선택하셔야합니다.");
			f.C_codeName.focus();
			return false;
		}
		if (f.C_NAME2.value == "")
		{
			alert("무통장 입금거래서 입금하실 분의 이름을 입력하셔야 합니다.");
			f.C_NAME2.focus();
			return false;
		}
		if (f.memo1.value == "")
		{
			alert("무통장 입금거래서 입금하실 일자를 선택하셔야합니다.");
			f.memo1.focus();
			return false;
		}

		if (confirm("무통장입금으로 결제를 진행하시겠습니까?"))
		{
			f.action = "orders_ing_etc.asp";
		}else{
			f.action = "orders_ing_card.asp";
			return false;
		}

		f.submit();
	}

/*
	f.buyername.value = f.strName.value;
	f.buyertel.value = f.strMobile.value;
	f.buyeremail.value = f.strEmail.value;
	f.cardnumber.value = f.cardNm1.value + f.cardNm2.value + f.cardNm3.value + f.cardNm4.value


	return false;










	if(f.goodname.value == "")
	{
		alert("상품명이 빠졌습니다. 필수항목입니다.");
		return false;
	}
	else if(f.price.value == "")
	{
		alert("결제금액이 빠졌습니다. 필수항목입니다.");
		return false;
	}
	else if(f.buyername.value == "")
	{
		alert("구매자명이 빠졌습니다. 필수항목입니다.");
		return false;
	}
	else if(f.buyeremail.value == "")
	{
		alert("구매자 이메일주소가 빠졌습니다. 필수항목입니다.");
		return false;
	}
	else if(f.buyertel.value == "")
	{
		alert("구매자 연락처가 빠졌습니다. 필수항목입니다.");
		return false;
	}
	else if(f.cardnumber.value == "")
	{
		alert("신용카드 번호가 빠졌습니다. 필수항목입니다.");
		return false;
	}


	// 더블클릭으로 인한 중복승인을 방지하려면 반드시 confirm()을
	// 사용하십시오.
	if(confirm("결제하시겠습니까?"))
	{
		disable_click();
		openwin = window.open("childwin.html","childwin","width=299,height=149");
		return true;
	}
	else
	{
		return false;
	}
	*/
}

function enable_click()
{
	document.ini.clickcontrol.value = "enable"
}

function disable_click()
{
	document.ini.clickcontrol.value = "disable"
}

function focus_control()
{
	if(document.ini.clickcontrol.value == "disable")
		openwin.focus();
}