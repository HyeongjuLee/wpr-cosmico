<!--#include virtual = "/_lib/strFunc.asp"-->
<%

	Call Only_Member(DK_MEMBER_LEVEL)
	popWidth = 500
	popHeight = 480

	goodsIDX = gRequestTF("idv",True)


%>
<!--#include virtual = "/_include/document.asp"-->
<script type="text/javascript">
<!--
	function chkQfrm(f) {
		if (f.strType.value=="")
		{
			alert("문의유형을 선택해주세요");
			f.strType.focus();
			return false;
		}
		if (f.strSubject.value=="")
		{
			alert("제목을 입력해주세요.");
			f.strSubject.focus();
			return false;
		}
		if (f.strQuestion.value=="")
		{
			alert("내용을 입력해주세요.");
			f.strQuestion.focus();
			return false;
		}
	}
//-->
</script>
<style type="text/css">
div#pop_top {clear:both; float:left;width:<%=popWidth%>px; height:40px;background:url(/images/pop/popAll1_bg.gif) 0 0 repeat-x;overflow:hidden;}
.input_text {height:16px; padding-top:2px;border:1px solid #ccc;}
.input_area {border:1px solid #ccc; width:350px; height:200px;}

div#close {height:30px;text-align:right;margin-top:13px;}
.line1 {height:1px; background-color:#dedede;}
.line2 {height:2px; background-color:#f4f4f4;}
td,th {border:1px dotted #ccc; padding:5px 0px;}
td {padding-left:10px;}
th {background-color:#eee;}
</style>
</head>
<body>
<div id="pop_top"><img src="<%=IMG_POP%>/tit_detailQna.gif" width="250" height="40" alt="" /></div>
<p><%=viewImg(IMG_POP&"/qna_pop_tit01.gif",426,17,"")%></p>
<form name="qfrm" action="popQnaHandler.asp" method="post" onsubmit="return chkQfrm(this)">
<input type="hidden" name="goodsIDX" value="<%=goodsIDX%>" />
<table <%=tableatt%> style="width:<%=popWidth%>px;">
	<colgroup>
		<col width="110" />
		<col width="*" />
	</colgroup>
	<tr>
		<th><%=viewImg(IMG_POP&"/qna_pop_th01.gif",46,16,"")%></th>
		<td>
			<select name="strType">
				<option value="">문의유형을 선택해주세요</option>
				<option value="구매관련">구매관련</option>
				<option value="상품관련">상품관련</option>
				<option value="반품관련">반품관련</option>
				<option value="교환관련">교환관련</option>
				<option value="배송관련">배송관련</option>
				<option value="기타">기타</option>
			</select>
		</td>
	</tr><tr>
		<th><%=viewImg(IMG_POP&"/qna_pop_th02.gif",46,16,"")%></th>
		<td><input type="text" name="strSubject" class="input_text" style="width:350px;" /></td>
	</tr><tr>
		<th><%=viewImg(IMG_POP&"/qna_pop_th03.gif",46,16,"")%></th>
		<td><textarea name="strQuestion" cols="30" rows="10" class="input_area"></textarea></td>
	</tr>
</table>
<p style="text-align:center;padding:7px 0px;"><%=viewImg(IMG_POP&"/qna_pop_tit02.gif",350,35,"")%></p>
<p class="tcenter"><input type="image" src="<%=IMG_POP%>/qna_pop_write.gif" /></p>
</form>
<div id="close">
	<div class="line1"></div>
	<div class="line2"></div>
	<img src="<%=IMG_JOIN%>/btn_close01.gif" width="52" height="23" alt="창 닫기" style="margin-top:4px;cursor:pointer;" onclick="self.close();" />
</div>

<script type="text/javascript">
<!--
resizePopupWindow(parseInt("<%=popWidth%>", 10), parseInt("<%=popHeight%>", 10));
//-->
</script>
</body>
</html>
