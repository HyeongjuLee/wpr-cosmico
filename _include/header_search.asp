<link rel="stylesheet" href="/css/search.css?">
<script type="text/javascript">
	$(function(){
		$('#header .searchs').each(function(){
			var $this = $('#header .searchs');
			$this.find('i').click(function(){
				$this.toggleClass('active');
				$('#header').toggleClass('searchs');

				if ($this.hasClass('active')) {
					// $this.find('.searchWrap').css({visibility:"visible",opacity:1}).fadeIn(0);
					$('.search-wrap').addClass('active').css({
						visibility: 'visible',
						height: '250px',
						opacity: 1,
					});
					// $('.search-wrap').animate({
					// 	height: '250px',
					// 	opacity: 1,
					// }, 1000);
				}else{
					// $('.search-wrap').removeClass('active').slideUp().fadeOut(0);
					$('.search-wrap').removeClass('active').css({
						visibility: 'hidden',
						height: '0',
						opacity: 0,
					});
				}
			});

			$('.search').find('.close', '.close i').click(function(){
				// $('.search-wrap').removeClass('active').slideUp().fadeOut(0);
				$this.removeClass('active');
				$('.search-wrap').removeClass('active').css({
					visibility: 'hidden',
					height: '0',
					opacity: 0,
				});
				// $('.nav-main:after').
				setTimeout(function(){
					$('#header').removeClass('searchs');
				}, 0);
			});
		});
	})
</script>
<div class="search">
	<form name="search" action="/shop/category.asp" method="post" onsubmit="return searchfrmChk(this)">
		<input type="hidden" name="tSEARCHTERM" value="GoodsName">
		<div class="form-outline">
			<input type="search" name="tSEARCHSTR" value="" class="input-search" title="<%=LNG_TEXT_SEARCH%>" placeholder="<%=LNG_TEXT_SEARCH%>">
		</div>
		<button type="submit"><i class="icon-search-1"></i></button>
	</form>
	<div class="close">
		<i class="icon-close-outline"></i>
	</div>
</div>