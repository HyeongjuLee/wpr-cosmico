<!--
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
/*
	oEditors[0].exec("UPDATE_CONTENTS_FIELD", []);
	f.GoodsContent.value = document.getElementById("ir1").value;

	oEditors[1].exec("UPDATE_CONTENTS_FIELD", []);
	f.GoodsDeliPolicy.value = document.getElementById("ir2").value;
*/
	oEditors.getById["ir1"].exec("UPDATE_CONTENTS_FIELD", []);
	oEditors2.getById["ir2"].exec("UPDATE_CONTENTS_FIELD", []);

//CS상품만 등록시
	if (f.CSGoodsCode.value=='')
	{
		alert("CS상품코드를 입력해 주세요.");
		//openCSGoodsSearch();
		f.CSGoodsCode.focus();
		return false;
	}


/*
	if (f.isCSGoods[0].checked == true) {
		if (f.CSGoodsCode.value =='') {
			alert("CS상품선택시 상품코드를 입력해 주세요.");
			//openCSGoodsSearch();
			return false;
		}
	}
*/
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
	if (f.strShopID.value == '')
	{
		alert("유통사를 선택해주세요");
		f.GoodsProduct.focus();
		return false;
	}

	//var num_pattern = /^[0-9]*$/i;
	var num_pattern = /^(?:\d{1,3}(,\d{3})*(\.\d+)?|\d{1,3}(\.\d{3})*(,\d+)?)$/;	//통화표기

	if (f.GoodsCost.value=='')
	{
		alert("공급가격을 입력해주세요");
		f.GoodsCost.focus();
		return false;
	}
	if(!num_pattern.test(f.GoodsCost.value))	{
		alert("공급가격은 숫자만 입력 가능합니다.");
		f.GoodsCost.focus();
		return false;
	}

	if (f.intPriceNot.value=='')
	{
		alert("판매가를 지정해주세요");
		f.intPriceNot.focus();
		return false;
	}
	if(!num_pattern.test(f.intPriceNot.value))	{
		alert("판매가는 숫자만 입력 가능합니다.");
		f.intPriceNot.focus();
		return false;
	}

	if (f.Img1Ori.value=='')
	{
		alert("기본이미지를 선택해주세요");
		f.Img1Ori.focus();
		return false;
	} else {
		if (!checkFileName(f.Img1Ori)) return false;
		if (!checkFileExt(f.Img1Ori, "jpg,gif,png", "이미지(jpg, gif,png) 파일만 선택해 주세요.")) return false;
	}
	if (f.Img2Ori.value != '') {
		if (!checkFileName(f.Img2Ori)) return false;
		if (!checkFileExt(f.Img2Ori, "jpg,gif,png", "이미지(jpg, gif,png) 파일만 선택해 주세요.")) return false;
	}
	if (f.Img3Ori.value != '') {
		if (!checkFileName(f.Img3Ori)) return false;
		if (!checkFileExt(f.Img3Ori, "jpg,gif,png", "이미지(jpg, gif,png) 파일만 선택해 주세요.")) return false;
	}
	if (f.Img4Ori.value != '') {
		if (!checkFileName(f.Img4Ori)) return false;
		if (!checkFileExt(f.Img4Ori, "jpg,gif,png", "이미지(jpg, gif,png) 파일만 선택해 주세요.")) return false;
	}
	if (f.Img5Ori.value != '') {
		if (!checkFileName(f.Img5Ori)) return false;
		if (!checkFileExt(f.Img5Ori, "jpg,gif,png", "이미지(jpg, gif,png) 파일만 선택해 주세요.")) return false;
	}
	if (f.ImgList.value != '') {
		if (!checkFileName(f.ImgList)) return false;
		if (!checkFileExt(f.ImgList, "jpg,gif,png", "이미지(jpg, gif,png) 파일만 선택해 주세요.")) return false;
	}
	/*
	if (f.imgMobMain.value=='')
	{
		alert("모바일 메인이미지를 선택해주세요");
		f.imgMobMain.focus();
	} else {
		if (!checkFileName(f.imgMobMain)) return false;
		if (!checkFileExt(f.imgMobMain, "jpg,gif,png", "이미지(jpg, gif,png) 파일만 선택해 주세요.")) return false;
	}
	*/
	var GoodsDeliveryTypeVal = $("input[name=GoodsDeliveryType]:checked").val();

	if (GoodsDeliveryTypeVal == 'BASIC')
	{
		f.GoodsDeliveryFee.value = 0;
	} else {
		if (f.GoodsDeliveryFee.value != '')
		{
			if(!num_pattern.test(f.GoodsDeliveryFee.value))	{
				alert("단독배송비 기입 시 숫자만 입력 가능합니다.");
				f.GoodsPrice.focus();
				return false;
			}
		}
	}

	if (checkDataImages(f.GoodsContent.value)) {
		alert("문자형이미지(드래그 이미지)는 사용할 수 없습니다.");
		return false;
	}
	if (checkDataImages(f.GoodsDeliPolicy.value)) {
		alert("문자형이미지(드래그 이미지)는 사용할 수 없습니다2");
		return false;
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

	//CS상품정보 고정
	if (document.gform.isCSGoods.value == 'T')
//	if (document.gform.isCSGoods[0].checked == true)		//배열인경우 (Radio btn)
	{
		$("#isCSGoods_toggle").css({"display":"table-row"});
		//document.gform.GoodsName.readOnly = true;
		document.gform.GoodsCustomer.readOnly = true;
		document.gform.GoodsCost.readOnly = true;
		document.gform.intPriceNot.readOnly = true;
		//document.gform.intCSPrice6.readOnly = true;			//VIP 가 (엘라이프)
		//document.gform.intCSPrice7.readOnly = true;			//GOLD가 (엘라이프)
	}

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
		f.GoodsCost.readOnly	 = true;
		f.intPriceNot.readOnly	 = true;
		//f.intCSPrice6.readOnly   = true;
		//f.intCSPrice7.readOnly   = true;
		//f.GoodsCustomer.value = '';
		//f.GoodsCost.value = '';
		//f.intPriceNot.value = '';
		document.getElementById("viewonly1").innerHTML = '수정불가';
		document.getElementById("viewonly2").innerHTML = '수정불가';
		document.getElementById("viewonly3").innerHTML = '수정불가';
		//document.getElementById("viewonly6").innerHTML = '수정불가';
		//document.getElementById("viewonly7").innerHTML = '수정불가';
	} else {
		$("#isCSGoods_toggle").css({"display":"none"});
		//f.GoodsName.readOnly = false;
		f.GoodsCustomer.readOnly = false;		//소비자가
		f.GoodsCost.readOnly	 = false;			//공급가
		f.intPriceNot.readOnly	 = false;			//판매가
		//f.intCSPrice6.readOnly   = false;
		//f.intCSPrice7.readOnly   = false;
		//f.GoodsCustomer.value = '';
		//f.GoodsCost.value = '';
		//f.intPriceNot.value = '';
		document.getElementById("viewonly1").innerHTML = '';
		document.getElementById("viewonly2").innerHTML = '';
		document.getElementById("viewonly3").innerHTML = '';
		//document.getElementById("viewonly6").innerHTML = '';
		//document.getElementById("viewonly7").innerHTML = '';
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


