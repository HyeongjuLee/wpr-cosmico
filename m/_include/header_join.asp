<script>
	//회원가입 페이지 헤더
	$(function(){
		$headerJoin();
	});
	
	var $headerJoin = function(){
		var mapsTitle = $('.maps_title').text();
		var subTitle = $('.sub_title').text();
		//debugger;
		var $back = $('.navi-back'); //뒤로가기
		var $close = $('.navi-close'); //끄기
		var $title = $('<h1>'+mapsTitle+'</h1>'); //회원가입 타이틀
		var $stitle = $('<h2>'+subTitle+'</h2>'); //소제목
		var $removeEl = $('.header-top, .top_menu, .navi-left, .navi-right, .navi-back, .navi-close, #logo'); //이 페이지에서 삭제할 요소들
		$('#header').find($removeEl).remove() && $('.sub-header').remove() && $('#header').addClass('join');
		$('#header article').prepend($close).prepend($title).prepend($back);
		//$('.joinstep').prepend($stitle);
		//console.log(mapsTitle);
		//console.log(subTitle);
	};

</script>
<div class="navi-back">
	<a href="javascript:history.back();"><i class="icon-angle-left"></i></a>
</div>
<div class="navi-close">
	<a href="/m/index.asp"><i class="icon-close-outline"></i></a>
</div>
<style type="text/css">
	.footer { height: auto!important; padding-bottom: 8rem; }
</style>