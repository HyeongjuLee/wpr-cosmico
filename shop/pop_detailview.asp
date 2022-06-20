<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	PAGE_SETTING = "SHOP"

	GoodsIDX = gRequestTF("gIDX",True)

	arrParams = Array(_
		Db.makeParam("@intIDX",adInteger,adParamInput,0,GoodsIDX) _
	)
	Set DKRS = Db.execRs("HJP_GOODS_GOODSCONTENT",DB_PROC,arrParams,Nothing)
	If Not DKRS.BOF And Not DKRS.EOF Then
		DKRS_intIDX					= DKRS("intIDX")
		DKRS_GoodsName			= DKRS("GoodsName")
		DKRS_GoodsComment		= DKRS("GoodsComment")
		DKRS_GoodsContent		= DKRS("GoodsContent")
	Else
		Call alerts(LNG_ALERT_WRONG_ACCESS,"close_p_modal","")
	End If
	Call closeRs(DKRS)

%>
<!--#include virtual = "/_include/document.asp"-->
<script type="text/javascript">
	//제품상세정보 이미지조정
	$(document).ready(function() {
		let detailInfo_width = $("#detailInfo").width();
    $('.inContent img').css({"width":+detailInfo_width+"px"});
	});
</script>
</head>
<body>
<div id="detailView" class="cleft" style="margin-top: 0px;">
	<div class="cleft width100 infow rap">
		<div id="detailInfo" style="margin-left: 0px;">
			<div class="fleft width100 GoodsSubject_R"><span><%=DKRS_GoodsName%></span></div>
		</div>
	</div>
	<div class="detailView_btn">
		<p class="tit" id="tablocation1" name="tablocation1" style="font-size: 18px; font-weight: 500;"><%=LNG_SHOP_DETAILVIEW_35%></p>
	</div>
	<div class="inContent" style="padding:30px 0px;"><%=backword_area(DKRS_GoodsContent)%></div>
</div>

