<!--
$(document).ready(function(){
	$('input[name=intPriceNot]').keyup(function() {
		var pWon = document.gform.intPriceNot.value;
		if (pWon == ''){$("#viewKorWon1").html("0 원");}else{numtokorean(pWon,"#viewKorWon1");}
	});
	$('input[name=intPriceNot]').ready(function(){
		//alert("dd");
		var pWon = document.gform.intPriceNot.value;
		if (pWon == ''){$("#viewKorWon1").html("0 원");}else{numtokorean(pWon,"#viewKorWon1");}

	});


	if ($("input[name=isImgType]:checked").val() == 'S') {
		$("#isImgType_V").css({"display":"none"})
		$("#isImgType_S tr").css({"display":"table-row"})

	}
	else if ($("input[name=isImgType]:checked").val() == 'V')
	{
		$("#isImgType_S").css({"display":"none"})
		$("#isImgType_V tr").css({"display":"table-row"})
	}

	$("input[name=isImgType]").click(function(event){
		var str = $("input[name=isImgType]:checked").val();
		if (str == 'S') {
			$("#isImgType_V").css({"display":"none"})
			$("#isImgType_S").css({"display":""})

		}
		else if (str == 'V')
		{
				alert(str);
			$("#isImgType_S").css({"display":"none"})
			$("#isImgType_V").css({"display":""})
		}
	});



});


/* CS연동상품등록 */
function openCSGoodsSearch_vendor() {
	openPopup("pop_CSGoodsSearch_vendor.asp", "CSGoodsSearch", 100, 100, "left=200, top=200, scrollbars=yes");
}


function numtokorean(obj,htmlID) {
	if (obj != '')
	{
		var won  = (obj+"").replace(/,/g, "");
		var arrWon  = ["원", "만 ", "억 ", "조 ", "경 ", "해 ", "자 ", "양 ", "구 ", "간 ", "정 "];
		var changeWon = "";
		var pattern = /(-?[0-9]+)([0-9]{4})/;
		while(pattern.test(won)) {
			won = won.replace(pattern,"$1,$2");
		}
		var arrCnt = won.split(",").length-1;
		for(var ii=0; ii<won.split(",").length; ii++) {
			if(arrWon[arrCnt] == undefined) {
				alert("값의 수가 너무 큽니다.");
				break;
			}
			changeWon += won.split(",")[ii]+arrWon[arrCnt];
			arrCnt--;
		}

		$(htmlID).html(changeWon);
	}

}




function chkGFrm(f) {

	oEditors.getById["ir1"].exec("UPDATE_CONTENTS_FIELD", []);
	oEditors2.getById["ir2"].exec("UPDATE_CONTENTS_FIELD", []);

	if (f.isCSGoods[0].checked == true) {
		if (f.CSGoodsCode.value =='') {
			alert("CS상품선택시 상품코드를 입력해 주세요.");
			openCSGoodsSearch();
			return false;
		}
	}

	if (f.cate1.value=='')
	{
		alert("카테고리를 선택해주세요");
		f.cate1.focus();
		return;
	}
	if (f.GoodsName.value=='')
	{
		alert("상품명을 기록해주세요");
		f.GoodsName.focus();
		return;
	}


	var num_pattern = /^[0-9]*$/i;


	if (f.intPriceNot.value=='')
	{
		alert("판매가를 입력해주세요");
		f.intPriceNot.focus();
		return;
	}
	if(!num_pattern.test(f.intPriceNot.value))	{
		alert("판매가는 숫자만 입력 가능합니다.");
		f.intPriceNot.focus();
		return;
	}

	var msg = "단순히 데이터만 수정하시겠습니까?";
	if(confirm(msg)){
		f.submit();
	}else{
		return;
	}

}

function AcceptFrm(f) {

	oEditors.getById["ir1"].exec("UPDATE_CONTENTS_FIELD", []);
	oEditors2.getById["ir2"].exec("UPDATE_CONTENTS_FIELD", []);




	if (f.cate1.value=='')
	{
		alert("카테고리를 선택해주세요");
		f.cate1.focus();
		return;
	}
	if (f.GoodsName.value=='')
	{
		alert("상품명을 기록해주세요");
		f.GoodsName.focus();
		return;
	}


	var num_pattern = /^[0-9]*$/i;


	if (f.intPriceNot.value=='')
	{
		alert("판매가를 입력해주세요");
		f.intPriceNot.focus();
		return;
	}
	if(!num_pattern.test(f.intPriceNot.value))	{
		alert("판매가는 숫자만 입력 가능합니다.");
		f.intPriceNot.focus();
		return;
	}


	if (f.intPriceNot.value== 0)
	{
		var msg = "판매가가 0원입니다. 해당 상품의 판매를 승인하시겠습니까?";

	} else {
		var msg = " 해당 상품의 판매를 승인하시겠습니까?";
	}
	if(confirm(msg)){
		f.chgMode.value = 'accept'

		f.submit();
	}else{
		return;
	}

}

function ReturnFrm(f) {


	oEditors.getById["ir1"].exec("UPDATE_CONTENTS_FIELD", []);
	oEditors2.getById["ir2"].exec("UPDATE_CONTENTS_FIELD", []);




	if (f.cate1.value=='')
	{
		alert("카테고리를 선택해주세요");
		f.cate1.focus();
		return;
	}
	if (f.GoodsName.value=='')
	{
		alert("상품명을 기록해주세요");
		f.GoodsName.focus();
		return;
	}

	if (checkDataImages(f.GoodsContent.value)) {
		alert("문자형이미지(드래그 이미지)는 사용할 수 없습니다.");
		return false;
	}
	if (checkDataImages(f.GoodsDeliPolicy.value)) {
		alert("문자형이미지(드래그 이미지)는 사용할 수 없습니다2");
		return false;
	}

	var num_pattern = /^[0-9]*$/i;


	if (f.strReturnCause.value=='')
	{
		alert("반려시에는 반려 사유를 적어야합니다.");
		f.strReturnCause.focus();
		return;
	}


	var msg = "해당 상품을 승인반려 하시겠습니까?";
	if(confirm(msg)){
		f.chgMode.value = 'return'
		f.submit();
	}else{
		return;
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
	/* 배송 정보 토글 */


		/* CS상품 토글 */
		$("input[name=isCSGoods]").ready(function(event){
			var values = $("input[name=isCSGoods]:checked").val();
			isCSGoodsToggle(values);
		});
		$("input[name=isCSGoods]").click(function(event){
			var values = $("input[name=isCSGoods]:checked").val();
			isCSGoodsToggle(values);
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

function isCSGoodsToggle(values) {
	var f = document.gform;

	if (values == 'T')
	{
		$("#isCSGoods_toggle").css({"display":"table-row"});
		//f.GoodsName.readOnly = true;
		f.GoodsCustomer.readOnly = true;
		f.GoodsCost.readOnly = true;
		f.intPriceNot.readOnly = true;
	} else {
		$("#isCSGoods_toggle").css({"display":"none"});
		//f.GoodsName.readOnly = false;
		f.GoodsCustomer.readOnly = false;		//소비자가
		f.GoodsCost.readOnly = false;			//공급가
		f.intPriceNot.readOnly = false;			//판매가
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
