<!--#include virtual = "/_lib/strFunc.asp"-->
<%IF CONST_MOBILE_ONLY = "T" Then%>
<!--#include virtual="/admin/_inc/adminPath.asp" -->
<%End If%>
<%

	Call ONLY_MEMBER(DK_MEMBER_LEVEL)
	bIDX = gRequestTF("idv",True)

		popWidth = 430
		popHeight = 210


	SQL = "SELECT COUNT(*) FROM [DK_NBOARD_VOTE] WHERE [strUserID] = ? AND [bIDX] = ? AND [mode] = 'alert'"
	arrParams = Array(_
		Db.makeParam("@strUserID",adVarChar,adParamInput,20,DK_MEMBER_ID),_
		Db.makeParam("@bIDX",adInteger,adParamInput,0,bIDX) _
	)
	MyScrapCnt = CInt(Db.execRsData(SQL,DB_TEXT,arrParams,Nothing))

	If MyScrapCnt > 0 Then
		id_oks = False
	Else
		id_oks = True
		arrParams = Array(_
			Db.makeParam("@bIDX",adInteger,adParamInput,0,bIDX), _
			Db.makeParam("@strUserID",adVarChar,adParamInput,20,DK_MEMBER_ID),_
			Db.makeParam("@mode",adVarChar,adParamInput,10,"alert")_
		)
		Call Db.exec("DKP_NBOARD_VOTE_UPDATE",DB_PROC,arrParams,Nothing)
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
</head>
<body>
<div id="zip_top"><img src="./images/pop_title_alert.gif" width="250" height="40" alt="아이디 중복검사 이미지" /></div>
<div id="contents1">

<%If id_oks Then%>
	<p style="font-weight:bold; color:#FF9900; text-align:center;">해당 게시물을 신고 하였습니다.</p>
	<p style="font-weight:bold;text-align:center;margin-top:15px;">3초 후 자동으로 창이 닫힙니다.</p>
<%else%>
	<p style="font-weight:bold; color:#FF9900; text-align:center;">이미 신고한 게시물입니다.</p>
	<p style="font-weight:bold;text-align:center;margin-top:15px;">3초 후 자동으로 창이 닫힙니다.</p>
<%End If%>
</div>
	<script type="text/javascript">
	<!--
		 setTimeout('self.close()',3000);
	//-->
	</script>

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
