<link rel="stylesheet" href="/css/search.css?">
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