<!--

function chkGFrm(f) {

	oEditors[0].exec("UPDATE_CONTENTS_FIELD", []);
	f.content1.value = document.getElementById("ir1").value;


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
	if (f.Img1Ori.value=='')
	{
		alert("기본이미지를 선택해주세요");
		f.Img1Ori.focus();
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


//Jquery 종료
});




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


