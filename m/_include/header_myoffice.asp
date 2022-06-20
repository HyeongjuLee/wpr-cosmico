<script type="text/javascript">
	$(function(){
		$headerMyoffice();
	});
	var $headerMyoffice = function(){
		var mapsTitle = $('.maps_title').text();
		//var mapsTitle = $('.maps_title').text();
		var contain = '<div class="contain"></div>';
		var subTitle = '<%=MAP_DEPTH3%>';
		var $removeEl = $('.header-top, .top_menu, .navi-left, .navi-right, .navi-back, .navi-close, #logo'); //이 페이지에서 삭제할 요소들
		$('#header').find($removeEl).remove() && $('#header').addClass('myoffice');

		var $title = $('<h1>'+mapsTitle+'</h1>'); //회원가입 타이틀
		var $stitle = $('<div class="sub-title">'+subTitle+'</div>'); //소제목
		$('.content').prepend($stitle);
		$stitle.nextAll().wrapAll(contain);

		console.log('<%=PAGE_SETTING%>', ' sub_title_d4 : ' + '<%=sub_title_d4%>', ' sub_title_d3 : ' + '<%=sub_title_d3%>', ' MAP_DEPTH2:' + '<%=MAP_DEPTH2%>', 'MAP_DEPTH3:' + '<%=MAP_DEPTH3%>', ' NAVI_P_NUM:' + '<%=NAVI_P_NUM%>');
	};
</script>
<link rel="stylesheet" type="text/css" href="/m/css/myoffice.css?v1">
<div id="sub-header" class="sub-header">
	<div class="layout_inner">
		<!--#include virtual = "/_include/sub_header_text.asp"-->
		<!--include virtual = "/m/_include/header_Lang.asp"-->
		<div class="navi-right2">
			<a href="/m/index.asp"><i class="icon-home"></i></a>
			<a href="#menu-right"><i class="icon-menu"></i></a>
		</div>
	</div>
</div>