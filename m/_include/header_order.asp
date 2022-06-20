<script>
	//제품 상세보기 페이지 헤더
	var $headerOrder = function(){
		var $back = $('.navi-back'); //뒤로가기
		var $title = $('<h1><%=LNG_SHOP_ORDER_DIRECT_TITLE_01%></h1>'); //상세보기 타이틀
		var $removeEl = $('.header-top, .top_menu, .navi-left, .navi-back, #logo'); //이 페이지에서 삭제할 요소들
		$('#header').find($removeEl).remove() && $('#header').addClass('shop order');
		$('article').prepend($title).prepend($back);
	};

	$(function(){
		$headerOrder();
	});
</script>
<div class="navi-back">
	<a href="javascript:history.back();"><i class="icon-angle-left"></i></a>
</div>
<style type="text/css">
	.footer { height: auto!important; padding-bottom: 8rem; }
</style>