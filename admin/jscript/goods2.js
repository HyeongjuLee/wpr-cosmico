<!--

function chkGFrm(f) {

	oEditors.getById["ir1"].exec("UPDATE_IR_FIELD", []);
	f.content1.value = document.getElementById("ir1").value;


	if (f.GoodsName.value=='')
	{
		alert("상품명을 기록해주세요");
		f.GoodsName.focus();
		return false;
	}
	 var msg = "등록하시겠습니까?";
	 if(confirm(msg)){
		return true;
	 }else{
		return false;
	 }



}
function delOk(ids) {

	var f = document.dfrm;
	var msg = "삭제하시겠습니까?";
	if(confirm(msg)) {
		f.mode.value = "DELETE";
		f.intIDX.value = ids;
		if (f.intIDX.value=='')
		{
			alert("필수값이 없습니다. 새로고침 후 다시 시도해주세요.");
			return;
		}
		f.submit();
	}else{
		return;
	}
}
function sortUp(uidx){
	var f = document.dfrm;

		f.mode.value = 'SORTUP';
		f.intIDX.value = uidx;
		f.submit();

	}


function sortDown(uidx){
	var f = document.dfrm;

		f.mode.value = 'SORTDOWN';
		f.intIDX.value = uidx;
		f.submit();

	}


$(document).ready(function(){
	$('#cate1')
	  .change(function(){
		chgCate1s();
	  })





// 바이트 체크 (상품명)
	$('input[name=GoodsName]').keyup(function() {
		_cnt = $(this).val().bytes();


		if (_cnt > 50) {
			alert("50바이트를 넘기셨습니다.");
			$(this).val(cutString($(this).val(), 50));
		}

		_cnt = $(this).val().bytes();
		$('span.GoodsName_cnt').html(_cnt);
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


