<!--#include virtual = "/_lib/strFunc.asp"-->
<%IF CONST_MOBILE_ONLY = "T" Then%>
<!--#include virtual="/admin/_inc/adminPath.asp" -->
<%End If%>
<%

	Call ONLY_MEMBER(DK_MEMBER_LEVEL)
	bIDX = gRequestTF("idv",True)




	SQL = "SELECT COUNT(*) FROM [DK_SCRAP] WHERE [strUserID] = ? AND [bIDX] = ?"
	arrParams = Array(_
		Db.makeParam("@strUserID",adVarChar,adParamInput,20,DK_MEMBER_ID),_
		Db.makeParam("@bIDX",adInteger,adParamInput,0,bIDX) _
	)
	MyScrapCnt = CInt(Db.execRsData(SQL,DB_TEXT,arrParams,Nothing))

	If MyScrapCnt > 0 Then
		id_oks = False
		popWidth = 430
		popHeight = 210
	Else
		id_oks = True
		popWidth = 430
		popHeight = 260
	End If

	If id_oks Then
		SQL = "SELECT [strSubject],[strBoardName] FROM [DK_NBOARD_CONTENT] WHERE [intIDX] = ?"
		arrParams = Array(_
			Db.makeParam("@bIDX",adInteger,adParamInput,0,bIDX) _
		)
		Set DKRS = Db.execRs(SQL,DB_TEXT,arrParams,Nothing)

		If Not DKRS.BOF And Not DKRS.EOF Then
			strSubject = DKRS("strSubject")
			strBoardName = DKRS("strBoardName")
		Else
			Call ALERTS("존재하지 않는 게시물입니다.","close","")
		End If
	End If


%>
<%IF CONST_MOBILE_ONLY = "T" Then%>
<!--#include virtual = "/admin/_inc/document.asp"-->
<%Else%>
<!--#include virtual = "/_include/document.asp"-->
<%End If%>
<style type="text/css">
	div#zip_top {clear:both; float:left;width:100%; height:40px;background:url(/images/join/pop_title_bg.jpg) 0 0 repeat-x;overflow:hidden;}

	div#close {height:30px;text-align:center;margin-top:13px;}
	.line1 {height:1px; background-color:#dedede;}
	.line2 {height:2px; background-color:#f4f4f4;}
	div#contents {clear:both;color:#555;width:100%;height:120px;overflow:hidden;}
	div#contents1 {clear:both;color:#555;width:100%;padding:30px 0px;overflow:hidden;}
	th {background-color:#e3e3e3;height:30px;}
	th,td {border:1px solid #ccc;}
	td {padding-left:8px;}
	td.btns {padding:10px 0px; text-align:center; border:0px none;}
	.input_text {border:1px solid #ccc; height:16px; padding-top:2px;}
</style>
<script type="text/javascript">
<!--
	function chkScrap(f) {
		var msg = "해당 게시물을 스크랩 하시겠습니까??";
		if(confirm(msg)){
			return true;
		}else{
			return false;
		}
	}
//-->
</script>
</head>
<body>
<div id="zip_top"><img src="./images/pop_title_scrap.gif" width="250" height="40" alt="아이디 중복검사 이미지" /></div>
<%If id_oks Then%>
<div id="contents">
	<form name="scrapFrm" action="boardFncHandler.asp" method="post" onsubmit="return chkScrap(this)">
	<input type="hidden" name="mode" value="SCRAP" />
	<input type="hidden" name="strBoardName" value="<%=strBoardName%>" />
	<input type="hidden" name="bidx" value="<%=bIDX%>" />
	<input type="hidden" name="strSubject" value="<%=strSubject%>" />
	<table <%=tableatt%> style="width:100%;">
		<colgroup>
			<col width="90" />
			<col width="*" />
		</colgroup>
		<tr>
			<th>게시물 제목</th>
			<td><%=strSubject%></td>
		</tr><tr>
			<th>스크랩 메모</th>
			<td><input type="text" name="strMemo" class="input_text" style="width:280px;" /></td>
		</tr><tr>
			<td colspan="2" class="btns"><input type="image" src="./images/btn_scrap_submit.gif" /></td>
		</tr>
	</table>
	</form>
</div>
<%else%>
<div id="contents1">
	<p style="font-weight:bold; color:#FF9900; text-align:center;">이미 스크랩된 게시물입니다.
	<p style="font-weight:bold;text-align:center;margin-top:15px;">3초 후 자동으로 창이 닫힙니다.</p>
	<script type="text/javascript">
	<!--
		  setTimeout('self.close()',3000);
	//-->
	</script>
</div>
<%End If%>

<div id="close">
<div class="line1"></div>
<div class="line2"></div>
<img src="<%=IMG_JOIN%>/btn_close01.gif" width="52" height="23" alt="창 닫기" style="margin-top:4px; cursor:pointer;" onclick="self.close();"/>
</div>
<script type="text/javascript">
<!--
resizePopupWindow(parseInt("<%=popWidth%>", 10), parseInt("<%=popHeight%>", 10));
//-->
</script>
</body>
</html>
