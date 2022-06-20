
<!-- <div id="bbs_search" class="cleft" style="width:100%;margin-bottom:15px;">
	<form action="" method="post" name="search">
		<div class="fleft" style="width:20%">
			<select name="searchterm" style="width:100%;height:30px;">
				<option value="strSubject"<%If SEARCHTERM = "strSubject" Then%> selected="selected"<%End If%>><%=LNG_TEXT_TITLE%></option>
				<option value="strContent"<%If SEARCHTERM = "strContent" Then%> selected="selected"<%End If%>><%=LNG_TEXT_CONTENT%></option>
			</select>
		</div>
		<div class="fleft" style="width:60%"><input type="search" style="padding:6px 0px;margin-top:0px;width:99%;height:30px;" name="SEARCHSTR" placeholder="" value="<%=convSql(SEARCHSTR)%>" /></div>
		<div class="fleft" style="width:20%;"><input type="submit" value="<%=LNG_BOARD_BTN_SEARCH%>" data-theme="w" style="width:100%;height:30px;"/></div>
	</form>
</div> -->
	<div id="bbs_search">
		<form name="search" action="" method="post" >
			<select class="searchterm" name="searchterm">
				<option value="strSubject"<%If SEARCHTERM = "strSubject" Then%> selected="selected"<%End If%>><%=LNG_TEXT_TITLE%></option>
				<option value="strContent"<%If SEARCHTERM = "strContent" Then%> selected="selected"<%End If%>><%=LNG_TEXT_CONTENT%></option>
			</select>
			<div class="search">
				<input type="text" name="SEARCHSTR" value="<%=convSql(SEARCHSTR)%>" title="검색어 입력" placeholder="" >
				<input type="hidden" name="cate" value="<%=CATEGORY%>" />
				<button type="submit" title="">
					<i class="icon-search-sharp"></i>
				</button>
			</div>
		</form>
	</div>




























