<%' pc/mob 공통%>
<script type="text/javascript">

	function check_frm(){
		<%If DK_MEMBER_LEVEL < 1 THEN%>
			let msg = "<%=LNG_SHOP_DETAILVIEW_10%>";
			if(confirm(msg)){
				document.location.href=mob_path()+"/common/member_login.asp?backURL=<%=ThisPageURL%>";
				return;
			}else{
				return;
			}
		<%END IF%>
	}



	function quickOrderChk(f) {
		if(f.checkQuickOrder.checked){
			f.QUICK_ORDER_TF.value = "T";
		}else{
			f.QUICK_ORDER_TF.value = "F";
		}
		$("#loadingPro").show();

		f.action = thisPageUrl();
		f.submit();
	}

	function quickCartChk() {
		let f = document.cartFrm;
		if(f.checkCart.checked){
			$("#selectOrderBtn").val("<%=LNG_TEXT_CART%>").css({"background":"#7f7b7b"});
		}else{
			$("#selectOrderBtn").val("<%=LNG_TEXT_PURCHASE%>").css({"background":"#2d9421"});
		}
	}

	function SelectAll(){
		const f = document.cartFrm;
		if(f.checklist.checked){
			if (typeof f.chkCart.length == "undefined") {
				if (f.chkCart.disabled != true)
					{
						f.chkCart.checked = true;
					}
			} else {
				for (i=0, len=f.chkCart.length; i<len; i++) {
					if (f.chkCart[i].disabled != true)
					{
						f.chkCart[i].checked = true;
					}
				}
			}
		} else {
			if (typeof f.chkCart.length == "undefined") {
				f.chkCart.checked = false;
			} else {
				for (i=0, len=f.chkCart.length; i<len; i++) {
					if (f.chkCart[i].disabled != true)
					{
						f.chkCart[i].checked = false;
					}
				}
			}
			loadingReload();
		}
		sumAllPrice();
	}

	//체크 해제시 초기화
	function loadingReload() {
		$("#loadingPro").show();
		location.reload();
	}

	function selectOrder() {
		const f = document.cartFrm;
		let i,len;
		let objCart = f.cuidx;
		let objEa = f.ea;
		let selCnt = 0;
		let chgGoodsCnt = 0;
		let attr;

		const attrResult = [];
		$("input[name=chkCart]:checked").each(function() {
			let vs = $(this).attr("attrCode");
			if (vs != "")	{
				if ($.inArray(vs,attrResult) == -1)	{
					attrResult.push(vs);
				}
			}
		});
		let attrReCount = attrResult.length;

		if (attrReCount > 1) {
			alert("<%=LNG_CS_CART_JS04%>");
			return ;
		}

		if (typeof objCart == "undefined") {
			alert("<%=LNG_SHOP_CART_JS_01%>");
			return;
		}

		if (typeof f.chkCart.length == "undefined") {
			if (f.chkCart.checked) ++selCnt;
		}
		else {
			for (i=0, len=f.chkCart.length; i<len; i++) {
				if (f.chkCart[i].checked){
					++selCnt;
					attr = f.chkCart[i].getAttribute('attrCG');
					if (attr == 'T') {
						++chgGoodsCnt;
					}
				}
			}
		}
		if (selCnt == 0) {
			alert("<%=LNG_SHOP_CART_JS_02%>");
			return;
		}
		if (chgGoodsCnt > 0) {
			alert("<%=LNG_SHOP_CART_JS_03%>");
			return;
		}

		if (typeof f.chkCart.length == "undefined") {
			if (f.chkCart.checked) {
				objCart.disabled = false;
				objEa.disabled = false;
			}
			else {
				objCart.disabled = true;
				objEa.disabled = true;
			}
		}
		else {
			for (i=0, len=f.chkCart.length; i<len; i++) {
				if (f.chkCart[i].checked) {
					objCart[i].disabled = false;
					objEa[i].disabled = false;
				}
				else {
					objCart[i].disabled = true;
					objEa[i].disabled = true;
				}
			}
		}
		if(f.checkQuickOrder.checked) {
			f.target = "_self";

			if(f.checkCart.checked) {
				f.mode.value = "Q_CART";
			}else{
				f.mode.value = "Q_ORDER";
			}
			quickOrderOrCart(f);
		}
	}

	function quickOrderOrCart(f) {
		mode	= f.mode.value;
		cuidx	= f.arr_cuidx.value;
		ea		= f.arr_ea.value;

		$.ajax({
			type: "POST",
			url: "/shop/quickOrder_ajax.asp",
			data : {
				"mode" : mode,
				"ea" : ea,
				"cuidx" : cuidx
			},
			beforeSend: function() {
				$("#loadingPro").show();
			},
			success: function(data) {
				const json = $.parseJSON(data);
				if (json.result == "success") {
					if (mode == "Q_ORDER") {
						quickOrder(json.cuidx);
					}
					if (mode == "Q_CART") {
						quickCart(json.message);
					}
				} else {
					alert(json.message);
					$("#loadingPro").hide();
				}
			},
			error:function(data) {
				alert("ajax error! .ERROR CODE : "+data.status+" "+data.statusText+" "+data.responseText);
				$("#loadingPro").hide();
			}
		});
	}
	function quickOrder(cuidx) {
		let f = document.quickOrderFrm;
		f.action = "order.asp";
		f.cuidx.value = cuidx;
		f.submit();
	}
	function quickCart(message) {
		if(confirm(message)){
			$("#loadingPro").show();
			location.href='cart.asp';
		} else {
			$("#loadingPro").hide();
			return false;
		}
	}

	function eaUpDown(unitNum,idx,ud) {
		let good_ea_id = $("#good_ea"+idx);
		let good_ea_val = parseInt(good_ea_id.val());
		let chkCart_idx = $("#chkCart"+idx);

		if($(chkCart_idx).is(':disabled')) {
			//alert('구매불가')
			return false;
		}
		if (ud == 'up') {
			good_ea_id.val(good_ea_val + unitNum);
		}
		if (ud == 'down') {
			if ((good_ea_val - unitNum) <= 0) {
				alert("<%=LNG_SHOP_DETAILVIEW_14%>");
				good_ea_id.val(1);
			}else{
				good_ea_id.val(good_ea_val - unitNum);
			}
		}
		chkCart_idx.prop("checked", true);
		sumEachPrice(idx);
	}

	//각 상품별 합계 계산
	function sumEachPrice(idx) {
		let basePrice_val =	parseInt($("#basePrice"+idx).val());
		let basePV_val = parseInt($("#basePV"+idx).val());
		let good_ea_val = parseInt($("#good_ea"+idx).val());
		let result_price = formatComma(basePrice_val * good_ea_val, 3);
		let result_pv = formatComma(basePV_val * good_ea_val, 3);

		$("#sumEachPrice_txt"+idx).text(result_price);
		$("#sumEachPV_txt"+idx).text(result_pv);
		sumAllPrice();
	}

	function sumAllPrice() {
		let sumAllPrice = 0;
		let sumAllPV = 0;
		let sumAllCase = 0;
		const arr_cuidx = [];
		const arr_ea = [];

		$("input:checkbox[name=chkCart]:checked").each(function() {
			let idx = $("input:checkbox[name=chkCart]").index(this);
			let f = document.cartFrm;
			if(f.checkQuickOrder.checked) {
				chkCart_Checked(idx);
			}
			let basePrice_val = $("input[name=basePrice]").eq(idx).val() * 1;
			let basePV_val = $("input[name=basePV]").eq(idx).val() * 1;
			let cuidx_val	= $(".cuidx input[name=cuidx]").eq(idx).val() * 1;
			let good_ea_val	= $("input[name=ea]").eq(idx).val() * 1;

			sumAllPrice += (parseInt(basePrice_val) * parseInt(good_ea_val));
			sumAllPV += (parseInt(basePV_val) * parseInt(good_ea_val));
			++sumAllCase;

			arr_cuidx.push(cuidx_val);
			arr_ea.push(good_ea_val);
		});
		$("#sumAllPrice_txt").text(formatComma(sumAllPrice,3));
		$("#sumAllPV_txt").text(formatComma(sumAllPV,3));
		$("#sumAllCase_txt").text(formatComma(sumAllCase,3));
		$("input[name=arr_cuidx]").val(arr_cuidx);
		$("input[name=arr_ea]").val(arr_ea);
	}

	function sumEachDirectInput(idx) {
		let good_ea_id = $("#good_ea"+idx);
		let good_ea_val = parseInt(good_ea_id.val());
		let chkCart_idx = $("#chkCart"+idx);

		if($(chkCart_idx).is(':disabled')) {
			good_ea_id.val(1);
			return false;
		}
		if(isNaN(good_ea_val) == true){
			//console.log("숫자 X");
			good_ea_id.val(1);
			return false;
		}
		if(good_ea_val <= 0 || good_ea_val == "") {
			//alert("<%=LNG_SHOP_DETAILVIEW_14%>");
			good_ea_id.val(1);
			return false;
		}
		chkCart_idx.prop("checked", true);
		sumEachPrice(idx);
	}

	$(document).ready(function() {
		//실시간 입력 계산
		let eaEach = "input[name=ea]"
		$(eaEach).keyup(function() {
			let idx = $(eaEach).index(this);
			sumEachDirectInput(idx);
		});
		/*
		$(eaEach).blur(function() {
			let idx = $(eaEach).index(this);
			sumEachDirectInput(idx);
		});
		*/
		$("input[name=chkCart]").change(function() {
			let idx = $("input:checkbox[name=chkCart]").index(this);
			if($(this).is(":checked")){
				chkCart_Checked(idx);
			}else{
				chkCart_NotChecked(idx); 		//체크 해제시 초기화
			}
		});


		//모바일
		if (mob_path() == "/m") {
			//가상키보드 밀림 해제
			$(function() {
				$("#window_ori").css('height',window.innerHeight-55);
			});
		}

	});

	function chkCart_Checked(idx) {
		$("#goodsName"+idx).css({"background":"#ffe1b3"});
		$("#price_txt"+idx).text("<%=LNG_CS_ORDERS_TOTAL_PRICE%>");
		$("#pv_txt"+idx).text("<%=LNG_CS_ORDERS_TOTAL_PV%>");
	}
	function chkCart_NotChecked(idx) {
		$("#goodsName"+idx).css({"background":"white"});
		$("#price_txt"+idx).text("<%=LNG_TEXT_PAY_PRICE%>");
		$("#pv_txt"+idx).text("PV");
		$("input[name=ea]").eq(idx).val(1);
		sumEachPrice(idx);
	}

	//BFCache로 브라우저가 로딩될 경우 혹은 브라우저 뒤로가기 했을 경우
	window.onpageshow = function(event) {
		$("input:checkbox[name=checklist]").prop('checked',false);
		$("input:checkbox[name=checkCart]").prop('checked',false);
		$("input:checkbox[name=chkCart]").each(function() {
				$("input[name=ea]").val(1);
				$(this).prop('checked',false);
		});
	}

</script>