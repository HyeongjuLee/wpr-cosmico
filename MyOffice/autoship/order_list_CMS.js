
	$(document).ready(function() {

		//체크박스 해제
		$("input[type=checkbox]:checked").each(function() {
			$(this).prop("checked",false);
		});

		//$('#regItemCount').val("");			//오토쉽 등록상품 갯수 초기화

		$("select[name=A_CardType]").change(function(event) {
			//event.preventDefault();
			var thisVal = $(this).val();
			console.log(thisVal);
			if (thisVal == '0') {
				$(".A_CardType_txt_1").hide();
				$(".A_CardType_txt_0").show();
				$("input[name=A_Birth]").attr({maxlength: "6", placeholder: "YYMMDD"}).val("");
				$("input[name=A_Birth]").attr({maxlength: "6", placeholder: "YYMMDD"}).val("");
			} else {
				$(".A_CardType_txt_0").hide();
				$(".A_CardType_txt_1").show();
				$("input[name=A_Birth]").attr({maxlength: "10", placeholder: "사업자번호"}).val("");
			}

		});
	});

	//카드인증
	function join_cardCheck() {
		var f = document.cfrm;

		if (chkEmpty(f.A_CardCode)) {
			alert("카드명을 선택해주세요!");
			f.A_CardCode.focus();
			return false;
		}

		//카드인증ajax 버튼 누를 때만 체크!!
		if (chkEmpty(f.A_CardNumber1) || chkEmpty(f.A_CardNumber2) || chkEmpty(f.A_CardNumber3) || chkEmpty(f.A_CardNumber4)) {
			alert("카드번호를 입력해주세요.");
			f.A_CardNumber1.focus();
			return false;
		}

		var sumCardNumber = "";
		sumCardNumber = f.A_CardNumber1.value + f.A_CardNumber2.value + f.A_CardNumber3.value + f.A_CardNumber4.value;

		if (sumCardNumber.length < 15) {
			alert("정확한 카드번호를 입력해주세요.");
			f.A_CardNumber1.focus();
			return false;
		}

		if (f.A_Period1.value == '')
		{
			alert("카드유효기간 중 \'년\' 을 입력해주세요!");
			f.A_Period1.focus();
			return false;
		}
		if (f.A_Period2.value == '')
		{
			alert("카드유효기간 중 \'월\' 을 입력해주세요!");
			f.A_Period2.focus();
			return false;
		}
		if (chkEmpty(f.A_Card_Name_Number)) {
			alert("카드 소유자명을 입력해주세요!");
			f.A_Card_Name_Number.focus();
			return false;
		}
			if (f.PGCOMPANY.value == "PAYTAG") {
				if (chkEmpty(f.A_CardPass)) {					//PAYTAG
					alert("비번번호 앞 2자리를 입력해셍세요.!");
					f.A_CardPass.focus();
					return false;
				}
			}
		if (!checkkorText(f.A_Card_Name_Number.value,2)) {
			alert("정확한 소유자명을 입력해 주세요!");
			f.A_Card_Name_Number.focus();
			return false;
		}

		if (f.PGCOMPANY.value == "ONOFFKOREA") {
			if (f.A_CardType.value == '0') {
				if (f.A_Birth.value.length != 6) {
					alert("개인카드의 경우 생년월일 6자리를 입력하셔야합니다");
					f.A_Birth.focus();
					return false;
				}
			}
			if (f.A_CardType.value == '1') {
				if (f.A_Birth.value.length != 10) {
					alert("법인카드의 경우 사업자번호 10자리를 입력하셔야합니다");
					f.A_Birth.focus();
					return false;
				}
			}
		}else{
			if (chkEmpty(f.A_Birth)) {
				alert("생년월일을 6자리를 입력해 주세요!");
				f.A_Birth.focus();
				return false;
			}
		}

		let ajax_url = "";
		let PGCOMPANY = f.PGCOMPANY.value;

		if (PGCOMPANY == "DAOU") {
			ajax_url = "/PG/DAOU_AUTO/CardKeyGen_ajax_web.asp"

		} else if (PGCOMPANY == "PAYTAG") {
			ajax_url = "/PG/PAYTAG/CardKeyGen_ajax_web.asp"

		} else if (PGCOMPANY == "ONOFFKOREA") {
			ajax_url = "/PG/ONOFFKOREA/CardKeyGen_ajax_web.asp"

		} else {
			alert("등록되지 않은 PG사입니다. PG사 설정확인!");
			return false;
		}

		$("#loadingsA").show();
		$.ajax({
			type: "POST"
			,url: ajax_url
			,data : {
				"A_CardType"			: f.A_CardType.value,
				"A_CardCode"			: f.A_CardCode.value,
				"A_CardNumber"	: sumCardNumber,
				"A_Period1"	: f.A_Period1.value,
				"A_Period2"	: f.A_Period2.value,
				"A_Card_Name_Number"	: f.A_Card_Name_Number.value,
				"A_Birth"		: f.A_Birth.value,
				"A_CardPass"	: f.A_CardPass.value,					//PAYTAG
				"A_CardPhoneNum"		: f.A_CardPhoneNum.value	//ONOFFKOREA
			}
			,success: function(data) {
				//console.log(ariixTxt.data.error);
				//var dataSplit = data.split("|")
				//alert(dataSplit[0]);
				//alert(dataSplit[1]);
				document.getElementById("cardCheckSpan").innerHTML = data;
				$("#loadingsA").hide();
			}
			,error:function(data) {
				alert("ajax 처리 중 에러가 발생하였습니다.ERROR CODE : "+data.status+" "+data.statusText+" "+data.responseText);
				$("#loadingsA").hide();
			}
		});
	}


	//상품 추가 버튼 (reg/mod 공통)
	function insertThisValue3(obj, idx){

		var objOption = obj.options[obj.selectedIndex];
		var value = objOption.value;
		var thisPrice	= objOption.getAttribute('thisattr');		//price2
		var thisNcode	= objOption.getAttribute('thisattr2');	//ncode
		var thisPV	= objOption.getAttribute('thisattr3');	//pv
		var thisSellCode = objOption.getAttribute('thisattr4');	//SellCode
		var thisBV	= objOption.getAttribute('thisattr5');	//bv

		var innerTable = $(".innerTable tbody");
		var tr = innerTable.children().eq((idx-1));
		var td = tr.children();

		td.find("#thisNcode").text(thisNcode);
		td.find("#thisPrice").text(formatComma(thisPrice));
		td.find("#thisPV").text(formatComma(thisPV));
		td.find("#thisBV").text(formatComma(thisBV));

		calculateSum();
	}

	//합계 재계산 (reg/mod 공통)
	function calculateSum(){
		var innerTable = $(".innerTable tbody");
		var tr = innerTable.children();
		var sumPrice = 0;
		var sumPV = 0;
		var sumBV = 0;

		tr.each(function(){
			var td = $(this).children();
			var ea = td.find("input[name=regItemCount]").val().replace(/[^0-9]/g,"");
			var price = td.find("#thisPrice").text().replace(/[^0-9]/g,"");
			var pv = td.find("#thisPV").text().replace(/[^0-9]/g,"");
			var bv = td.find("#thisBV").text().replace(/[^0-9]/g,"");

			sumPrice += parseInt(ea * price);
			sumPV += parseInt(ea * pv);
			sumBV += parseInt(ea * bv);
		});

		$("#totalPrice").text(formatComma(sumPrice));
		$("#totalPV").text(formatComma(sumPV));
		$("#totalBV").text(formatComma(sumBV));

	}

	//CMS 상품 추가
	function addThis(){
		var cloneTable = $("#cloneTable .cloneTr").clone();

		$(".innerTable > tbody:last").append(cloneTable);
	}

	//추가된 상품 제거
	function delAddTable(idx){
		$(".innerTable tbody tr").eq((idx-1)).remove();
		calculateSum();
	}


	function getLocalUrl(mypage)
	{
		var myloc = location.href;
		return myloc.substring(0, myloc.lastIndexOf('/')) + '/' + mypage;
	}



	////// KSNET popup//////
	//PC
	function submitAuth2()
	{
		//document.cfrm.returnUrl.value = getLocalUrl('return.jsp');
		document.cfrm.returnUrl.value = getLocalUrl('return_KSPaySimple.asp');

		var width_  = 500;
		var height_ = 460;
		var left_   = screen.width;
		var top_    = screen.height;

		left_ = left_/2 - (width_/2);
		top_ = top_/2 - (height_/2);

		op = window.open('about:blank','FrmUp','height='+height_+',width='+width_+',status=yes,scrollbars=no,resizable=no,left='+left_+',top='+top_+'');

		if (op == null)
		{
			alert("팝업이 차단되어 결제를 진행할 수 없습니다.");
			return false;
		}
		document.cfrm.target = 'FrmUp';
		document.cfrm.action ='http://210.181.28.134/store/KSPaySimple/KSPayMain.jsp'; // Test Server
		//document.cfrm.action ='https://kspay.ksnet.to/store/KSPaySimple/KSPayMain.jsp'; // Real Server
		document.cfrm.submit();
	}
