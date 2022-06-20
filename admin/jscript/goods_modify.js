<!--
//제조사ID Input
function insertThisValue(item) {
	
	var f = document.gform;

	var objOption = item.options[item.selectedIndex];
	var value = objOption.value;
	var thisattr = objOption.getAttribute('thisattr');

	if (thisattr != "")	{
		f.strShopID.value = thisattr;
	} else {
		f.strShopID.value = "";	
	}
}

function chkGFrm(f) {

//	oEditors.getById["ir1"].exec("UPDATE_IR_FIELD", []); -->

	oEditors[0].exec("UPDATE_CONTENTS_FIELD", []);
	f.GoodsContent.value = document.getElementById("ir1").value;

	oEditors[1].exec("UPDATE_CONTENTS_FIELD", []);
	f.GoodsDeliPolicy.value = document.getElementById("ir2").value;


	if (f.cate1.value=='')
	{
		alert("카테고리를 선택해주세요");
		f.cate1.focus();
		return false;
	}
	if (f.GoodsName.value=='')
	{
		alert("상품명을 기록해주세요");
		f.GoodsName.focus();
		return false;
	}
	if (f.GoodsPrice.value=='')
	{
		alert("판매가를 지정해주세요");
		f.GoodsPrice.focus();
		return false;
	}

	
	var GoodsDeliveryTypeVal = $("input[name=GoodsDeliveryType]:checked").val();

	if (GoodsDeliveryTypeVal == 'BASIC')
	{
		f.GoodsDeliveryFee.value = 0;
	} else {
		if (f.GoodsDeliveryFee.value != '')
		{
			if(!num_pattern.test(f.GoodsDeliveryFee.value))	{
				alert("단독배송비 기입 시 숫자만 입력 가능합니다.");
				f.GoodsDeliveryFee.focus();
				return false;
			}
		}
	}
	 var msg = "등록하시겠습니까?";
	 if(confirm(msg)){
		return true;
	 }else{
		return false;
	 }



}
function checkOptionKind(vies) {
	var f = document.w_form;

		if (vies == "T") {
			document.getElementById("optionDispT").style.display = "";
		}
		else {
			document.getElementById("optionDispT").style.display = "none";
		}
	}


$(document).ready(function(){
/*
	$('#cate1')
	  .change(function(){
		chgCate1s();
	  })
*/




// 바이트 체크 (상품명)
	$('input[name=GoodsName]').keyup(function() {
		_cnt = $(this).val().bytes();


		if (_cnt > 100) {
			alert("100바이트를 넘기셨습니다.");
			$(this).val(cutString($(this).val(), 100));
		}

		_cnt = $(this).val().bytes();
		$('span.GoodsName_cnt').html(_cnt);
	});
// 바이트체크(상품설명)
	$('input[name=GoodsComment]').keyup(function() {
		_cnt = $(this).val().bytes();


		if (_cnt > 200) {
			alert("200바이트를 넘기셨습니다.");
			$(this).val(cutString($(this).val(), 200));
		}

		_cnt = $(this).val().bytes();
		$('span.GoodsComment_cnt').html(_cnt);
	});


/*
	$('input[name=Gpoint]').keyup(function(){
		var nums = $(this).val();
		var p_type = $('select[name=PointType]').val();
		var price = $('input[name=GoodsPrice]').val();


		if (p_type == 'f') {$('input[name=GoodsPoint]').val(nums);}
		else if (p_type == 'p') {$('input[name=GoodsPoint]').val((price * nums / 100));}
	})
*/
	$("input[name=GoodsStockType]").ready(function(event){

			var str = $("input[name=GoodsStockType]:checked").val();
			if (str == 'I')
			{
				$("input[name=GoodsStockNum]")
					.attr("readonly","readonly")
					.val("0")
					.css("background-color","#d1d1d1");
			}
			else if (str == 'N')
			{
				$("input[name=GoodsStockNum]")
					.removeAttr("readonly")
					.css("background-color","#f4f4f4");
			}
			else if (str == 'S')
			{
				$("input[name=GoodsStockNum]")
					.attr("readonly","readonly")
					.val("0")
					.css("background-color","#d1d1d1");
			}



	});
	$("input[name=GoodsStockType]").click(function(event){

			var str = $("input[name=GoodsStockType]:checked").val();
			if (str == 'I')
			{
				$("input[name=GoodsStockNum]")
					.attr("readonly","readonly")
					.val("0")
					.css("background-color","#d1d1d1");
			}
			else if (str == 'N')
			{
				$("input[name=GoodsStockNum]")
					.removeAttr("readonly")
					.css("background-color","#f4f4f4");
			}
			else if (str == 'S')
			{
				$("input[name=GoodsStockNum]")
					.attr("readonly","readonly")
					.val("0")
					.css("background-color","#d1d1d1");
			}

	});
	/* 배송 타입 토글 */
		$("input[name=GoodsDeliveryType]").ready(function(event){
			var values = $("input[name=GoodsDeliveryType]:checked").val();
			GoodsDeliveryToggle(values);
		});
		$("input[name=GoodsDeliveryType]").click(function(event){
			var values = $("input[name=GoodsDeliveryType]:checked").val();
			GoodsDeliveryToggle(values);
		});


//Jquery 종료
});

function GoodsDeliveryToggle(values) {
	if (values == 'SINGLE')
	{
		$("#delivery_toggle").css({"display":"table-row"});
	} else {
		$("#delivery_toggle").css({"display":"none"});
	}
}


String.prototype.bytes = function() {
    var l = 0;
    for (var i = 0; i < this.length; i++) {
        l += (this.charCodeAt(i) > 128) ? 2 : 1;
    }
    return l;
};
var cutString = function(str, len) {
	var l = 0;
	for (var i = 0; i < str.length; i++) {
		l += (str.charCodeAt(i) > 128) ? 2 : 1;
		if (l > len) {
			return str.substring(0, i);
		}
	}
	return str;
};
