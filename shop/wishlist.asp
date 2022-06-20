<!--#include virtual = "/_lib/strFunc.asp"-->
<!--#include virtual = "/_include/document.asp"-->
<%



	Call ONLY_MEMBER(DK_MEMBER_LEVEL)

	popWidth = 340
	popHeight = 240

	mode = Request.Form("mode")

	goodsIDX = Request.Form("Gidx")
	strDomain = strHostA
	strUserID = DK_MEMBER_ID
	goodsOption = goodsOption

'	Call ResRW(goodsIDX,"상품번호")
'	Call ResRW(strDomain,"도메인")
'	Call ResRW(strUserID,"유저아이디")
'	Call ResRW(goodsOption,"상품옵션")



	SQL = "SELECT COUNT(*) FROM [DK_WISHLIST] WHERE [goodsIDX] = ? AND [strUserID] = ?"
	arrParams = Array(_
		Db.makeParam("@goodsIDX",adInteger,adParamInput,0,goodsIDX), _
		Db.makeParam("@strUserID",adVarChar,adParamInput,20,DK_MEMBER_ID) _
	)
	WishCnt = Db.execRsData(SQL,DB_TEXT,arrParams,Nothing)


	If Int(WishCnt) > 0 Then
		Call alerts(LNG_SHOP_ORDER_WISHLIST_JS01,"close","")
	Else


	Call Db.beginTrans(Nothing)
		SQL = "INSERT INTO [DK_WISHLIST]([strDomain],[strUserID],[goodsIDX]) VALUES (?,?,?)"
		arrParams = Array(_
			Db.makeParam("@strDomain",adVarChar,adParamInput,50,strDomain), _
			Db.makeParam("@strUserID",adVarChar,adParamInput,30,strUserID), _
			Db.makeParam("@goodsIDX",adInteger,adParamInput,0,goodsIDX) _
		)
		Call Db.exec(SQL,DB_TEXT,arrParams,Nothing)


	Call Db.finishTrans(Nothing)


	If Err.Number <> 0 Then
		Call alerts(LNG_ALERT_UPDATE_ERROR,"close","")
	Else

%>

<script type="text/javascript">
<!--
	function gowishs() {
		opener.location.href = '/mypage/wish_list.asp';
		self.close();
	}
//-->
</script>
<style type="text/css">
	.text {height:50px; width:340px; text-align:center;margin-top:20px;border-bottom:1px solid #828282;line-height:120%;color:#787878;}
	.btns {height:80px; width:340px; text-align:center;margin-top:10px;}

	.bgtitle {
		width:100%;padding:10px 10px;margin:0px auto;
		background: #256615;
		background: -moz-linear-gradient(#31861c 20%, #256615 80%);
		background: -webkit-gradient(linear, left top, left bottom, color-stop(20%, #31861c), color-stop(80%, #256615));
		background: -webkit-linear-gradient(#31861c 20%, #256615 80%);
		background: linear-gradient(#31861c 20%, #256615 80%);
	}
	.bgtitle .bgFont{
		font-size:20px;color:#eee;font-family:malgun gothic;Arial,verdana;
	}
</style>
</head>
<body>
<!-- <div style="background:url(/images/pop/pop_title_bg.gif) 0 0 repeat-x;"><img src="<%=IMG_POP%>/tit_wishlist.gif" width="250" height="40" alt="" /></div> -->
<div class="bgtitle tweight">
	<span class="bgFont"><%=LNG_MYPAGE_02%></span>
</div>
<div class="text"><%=LNG_SHOP_ORDER_WISHLIST_TEXT01%><br /><%=LNG_SHOP_ORDER_WISHLIST_TEXT02%></div>
<div class="btns">
	<!-- <a href="javascript:gowishs();"><img src="<%=IMG_SHOP%>/btn57_submit.gif" width="57" height="24" alt="위시리스트로 이동" /></a>
	<a href="javascript:self.close();"><img src="<%=IMG_SHOP%>/btn57_close.gif" width="57" height="24" alt="창닫기" /></a> -->
	<input type="button" class="txtBtnC Small shadow1 border1 radius3 fGray tweight" style="width:52px;margin-top:20px;" onclick="javascript:gowishs();" value="<%=LNG_TEXT_CONFIRM%>"/>
	<input type="button" class="txtBtnC Small shadow1 border1 radius3 fGray tweight" style="width:52px;margin-top:20px;" onclick="javascript:self.close();" value="<%=LNG_TEXT_WINDOW_CLOSE%>"/>
</div>
<script type="text/javascript">
<!--
resizePopupWindow(parseInt("<%=popWidth%>", 10), parseInt("<%=popHeight%>", 10));
//-->
</script>
</body>
</html>
<%	End If%>
<%	End If %>
