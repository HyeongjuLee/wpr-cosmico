<script type="text/javascript">

	$(document).ready(function(){

		$(document).on('keyup', '.regItemCount', function(){
			calculateSum();
		});

		var now = new Date();
		var lastDay;
		if (now.getDate() > 25 ) {
			lastDay = new Date(now.getFullYear(), now.getMonth()+3, 0);
		} else {
			lastDay = new Date(now.getFullYear(), now.getMonth()+2, 0);
		}

		$( ".datepicker" ).datepicker({
			dateFormat			: "yy-mm-dd",
			changeMonth			: false,
			changeYear			: false,
			yearRange			: "c-5:c+5",
			showAnim			: "slideDown",
			minDate				: "<%=DateAdd("d",2,nowDate)%>",	//금일 이후정기결제부터 신청가능(HJ)
			maxDate				: lastDay,												//2달 후 까지
			showMonthAfterYear	: true,
			yearSuffix			: "년",
			monthNames			: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'],
			dayNamesMin			: ['일', '월', '화', '수', '목', '금', '토'],
			beforeShowDay: ableAllTheseDays,
			onSelect: function(date) {
				$("#A_Month_Date").css({"color":"green","font-size":"16px"}).text(date.substr(8,2));	//매월 결제일
			},
		});
		$('.ui-datepicker').css('font-size', '18px');								//font대비 달력크기조정(기본 13px)
		//가운데정렬
		$(document).on("click",".datepicker",function(){
			getCenterDatepicker();
		});

		//월 결제일 선택
		let abledDays = [<%=AUTOSHIP_PAYABLE_DAYS%>];

		function ableAllTheseDays(date) {
			let d = date.getDate();
			//console.log(d);
			for (i = 0; i < abledDays.length; i++) {
				if($.inArray(d, abledDays) != -1) {
					return [true, 'boldedClass'];
				}
			}
			return [false];
		}

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
		if (!checkkorText(f.A_Card_Name_Number.value,2)) {
			alert("정확한 소유자명을 입력해 주세요!");
			f.A_Card_Name_Number.focus();
			return false;
		}
		if (f.PGCOMPANY.value == "PAYTAG") {
			if (chkEmpty(f.A_CardPass)) {					//PAYTAG
				alert("비밀번호 앞 2자리를 입력해셍세요.!");
				f.A_CardPass.focus();
				return false;
			}
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



	// //상품 등록 정보 호출_NEW
	function insertThisValue3(item, idx) {
		var objOption = item.options[item.selectedIndex];
		var value = objOption.value;

		var thisattr = objOption.getAttribute('thisattr');		//price2
		var thisattr2 = objOption.getAttribute('thisattr2');	//ncode
		var thisattr3 = objOption.getAttribute('thisattr3');	//pv
		var thisattr4 = objOption.getAttribute('thisattr4');	//SellCode
		var thisattr5	= objOption.getAttribute('thisattr5');	//bv

		if (value == ""){
			thisattr = 0;
			thisattr2 = '';
			thisattr3 = 0;
			thisattr4 = '';
			thisattr5 = 0;
		}
		$("#selItemPrice_"+idx).text(formatComma(thisattr));
		$("#selItemCode_"+idx).text(thisattr2);
		$("#selItemPV_"+idx).text(formatComma(thisattr3));
		$("#selItemBV_"+idx).text(formatComma(thisattr5));

		calculateSum();
	}

	//합계 재계산
	function calculateSum(){

		var countArray = [];
		var priceArray = [];
		var pvArray = [];
		var bvArray = [];

		$(".innerTable .regItemCount").each(function(){
			var conutVal = $(this).val().replace(/[^0-9]/g,"");
			if (conutVal == ""){
				countArray.push(0);
			} else {
				countArray.push(conutVal);
			}
		});

		$(".innerTable .selItemPrice").each(function(){
			priceArray.push($(this).text().replace(/[^0-9]/g,""));
		});

		$(".innerTable .selItemPV").each(function(){
			pvArray.push($(this).text().replace(/[^0-9]/g,""));
		});
		$(".innerTable .selItemBV").each(function(){
			bvArray.push($(this).text().replace(/[^0-9]/g,""));
		});

		var sumPrice = 0;
		var sumPV = 0;
		var sumBV = 0;
		for (var i=0;i<countArray.length;i++){
			sumPrice += (parseInt(countArray[i]) * parseInt(priceArray[i]));
			sumPV += (parseInt(countArray[i]) * parseInt(pvArray[i]));
			sumBV += (parseInt(countArray[i]) * parseInt(bvArray[i]));
		}

		$("#totalPrice").text(formatComma(sumPrice));
		$("#totalPV").text(formatComma(sumPV));
		$("#totalBV").text(formatComma(sumBV));

	}

	//CMS 상품 추가
	function addThis(mode){
		var cloneTable = $("#cloneTable .cloneTr").clone();

		var lastIndex = 0;
		$(".innerTable .selItemIndex").each(function(){
			if (parseInt($(this).val()) > lastIndex) {
				lastIndex = parseInt($(this).val());
			}
		});
		lastIndex++;

		if (mode == 'mod'){
			cloneTable.find(".selItemIndex").val('');
		}else{
			cloneTable.find(".selItemIndex").val(lastIndex);
		}
		cloneTable.find("#addCount").attr("id", "ItemCount_"+(lastIndex));
		cloneTable.find("#addCode").attr("onchange", "insertThisValue3(this, "+lastIndex+");");
		cloneTable.find("#addCode").attr("id", "ItemCode_"+(lastIndex));
		cloneTable.find("#addItemCode").attr("id", "selItemCode_"+(lastIndex));
		cloneTable.find("#addItemPrice").attr("id", "selItemPrice_"+(lastIndex));
		cloneTable.find("#addItemPV").attr("id", "selItemPV_"+(lastIndex));
		cloneTable.find("#addItemBV").attr("id", "selItemBV_"+(lastIndex));
		cloneTable.find("#addBtn").attr("onclick", "addedRemove(this);");

		$(".innerTable > tbody:last").append(cloneTable);
		$(".noTable").css("display", "none");
	}

	//추가된 상품 제거
	function addedRemove(obj){
		var selectObj = obj.parentNode.parentNode.parentNode.parentNode;
		selectObj.nextSibling.remove();
		selectObj.remove();

		if ($(".innerTable .selItemIndex").length < 1) {
			$(".noTable").css("display", "");
		}

		calculateSum();
	}

	function getLocalUrl(mypage)
	{
		var myloc = location.href;
		return myloc.substring(0, myloc.lastIndexOf('/')) + '/' + mypage;
	}


	////// KSNET //////
	//MOB
	function submitAuth()
	{
		$("#KSPFRAME").show().height(500);
		document.cfrm.returnUrl.value = getLocalUrl('return_KSPaySimple_mob.asp');
		document.cfrm.target = 'KSPFRAME';
		document.cfrm.action ='http://210.181.28.134/store/KSPaySimple/KSPayMain.jsp'; //Test
		//document.cfrm.action ='https://kspay.ksnet.to/store/KSPaySimple/KSPayMain.jsp'; //Real		모바일 웹페이지와 프로토콜 맞춰주야 응답값 제대로 옴!!!
		document.cfrm.submit();
	}



	//datepicker가운데정렬
	function getCenterDatepicker(){
		var viewportwidth = $(window).width();
		var datepickerwidth = $("#ui-datepicker-div").width();
		var leftpos = (viewportwidth - datepickerwidth)/2; //Standard centering method
		$("#ui-datepicker-div").css({left: leftpos,position:'absolute'});
	}

</script>
