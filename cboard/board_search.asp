<%
	If isSearch = "T" Then
%>
<div id="bbs_search">
	<form action="" method="post" name="search">
		<select class="" name="searchterm">
			<option value="strSubject"<%If SEARCHTERM = "strSubject" Then%> selected="selected"<%End If%>><%=LNG_TEXT_TITLE%></option>
			<option value="strContent"<%If SEARCHTERM = "strContent" Then%> selected="selected"<%End If%>><%=LNG_TEXT_CONTENT%></option>
		</select>
		<input type="text" class="input_text" name="SEARCHSTR" value="<%=convSql(SEARCHSTR)%>" /></td>
		<button type="submit" class="input_submit design2" /><i class="fas fa-search"></i></button>
	</form>
</div>
<%End If%>