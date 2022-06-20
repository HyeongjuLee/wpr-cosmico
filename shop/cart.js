
function SelectAll(){
	var f = document.cartFrm;

  initAmountByShopID();

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
	}
	sumAllPrice('ALL');
}

function allOrders(f,txt1) {
	if (typeof f.cuidx == "undefined") {
		alert(txt1);
		return false;
	}
	f.target = "_self";
	f.action = "/shop/order.asp";
}

function selectOrder(txt1,txt2,txt3,txt4) {
	var f = document.cartFrm
	var i,len;
	var objCbList = f.chkCart;
	var objCart = f.cuidx;
	var objEa = f.ea;
	var selCnt = 0;
	var chgGoodsCnt = 0;
	var attr;

	//CS상품 구매종류가 같은 상품만 넘김s
	var attrResult = [];									// 배열선언
	$("input[name=chkCart]:checked").each(function(){
		var vs = $(this).attr("attrCode");
		if (vs != "")
		{
			if ($.inArray(vs,attrResult) == -1)		// 배열과 비교해서 기존에 없는 값인 경우
			{
				attrResult.push(vs);								// 배열에 저장
			}
		}
	});
	var attrReCount = attrResult.length;

	if (attrReCount > 1)									// 배열의 갯수가 1개 이상인 경우 (일반상품 제외vs에서 걸렀음)
	{
		alert(txt4);
		//alert("구매종류가 다른 상품은 같이 구매할 수 없습니다.");
		return ;
	}
	//CS상품 구매종류가 같은 상품만 넘김e


	if (typeof objCart == "undefined") {
		alert(txt1);
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
				if (attr == 'T')
				{
					++chgGoodsCnt;
				}
			}
		}
	}

	if (selCnt == 0) {
		alert(txt2);
		return;
	}
	if (chgGoodsCnt > 0) {
		alert(txt3);
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

	f.target = "_self";
	f.action = "/shop/order.asp";
	f.submit();
}


function delAll(txt1) {
	var f= document.cartFrm;
	if (typeof f.cuidx == "undefined") return;

	//if (confirm('장바구니를 전체 삭제하시겠습니까?'))
	if (confirm(txt1))
	{
		f.mode.value = "DELALL";
		f.target = "_self";
		f.action = "cart_handler.asp";
		f.submit();
	}
}


function selDEl(txt1,txt2) {
	var f = document.cartFrm
	var i,len;
	var objCbList = f.chkCart;
	var objCart = f.cuidx;
	var objEa = f.ea;
	var selCnt = 0;

	if (typeof f.cuidx == "undefined") {
		//alert("장바구니가 비어있습니다.");
		alert(txt1);
		return;
	}
	if (typeof f.chkCart.length == "undefined") {
		if (f.chkCart.checked) ++selCnt;
	}
	else {
		for (i=0, len=f.chkCart.length; i<len; i++) {
			if (f.chkCart[i].checked) ++selCnt;
		}
	}

	if (selCnt == 0) {
		//alert("삭제하실 상품을 선택해 주세요.");
		alert(txt2);
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

	f.mode.value = "SELDEL";
	f.target = "_self";
	f.action = "cart_handler.asp";
	f.submit();
}


function cartDelThis(idx,txt1) {
	var f = document.dFrm;
	if (confirm(txt1)) {
		f.mode.value = 'DELTHIS';
		f.cartIDX.value = idx;
		f.submit();
	}
}

function popup_chg_ea(idx) {openPopup('cart_pop_ea.asp?idx='+idx, 'cartpopea', 'top=100px,left=200px,width=600,height=600,resizable=no,status=no,toolbar=no,menubar=no,scrollbars=yes');}
function popup_chg_option(idx) {openPopup('cart_pop_option.asp?idx='+idx, 'popup_chg_option', 'top=100px,left=200px,width=600,height=700,resizable=no,status=no,toolbar=no,menubar=no,scrollbars=yes');}
