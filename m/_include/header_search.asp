<div class="search">
	<form name="search" action="/shop/category.asp" method="post" onsubmit="return searchfrmChk(this)">
		<input type="hidden" name="tSEARCHTERM" value="GoodsName">
		<div class="form-outline">
			<input type="search" name="tSEARCHSTR" value="" class="input-search" title="<%=LNG_TEXT_SEARCH%>">
			<label class="form-label"><%=LNG_TEXT_SEARCH%></label>
		</div>
		<button type="submit"><i class="icon-search"></i></button>
	</form>
</div>