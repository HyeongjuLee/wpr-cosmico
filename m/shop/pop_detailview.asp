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
		Call alerts(LNG_SHOP_DETAILVIEW_01,"close_p_modal","")
	End If
	Call closeRs(DKRS)

%>
<!--#include virtual = "/m/_include/document.asp"-->
<link rel="stylesheet" type="text/css" href="shop.css" />
<script type="text/javascript">
</script>
</head>
<body>
<div id="shop" class="detailView porel" style="padding: 0;">
	<div id="goodsTitle" class="width100 tcenter text_noline" >
		<%=DKRS_GoodsName%>
		<!-- <div id="goodsNote" class="tleft" ><%=DKRS_GoodsComment%></div> -->
	</div>
	<%
		DKRS_GOODSCONTENT = backword_area(DKRS_GOODSCONTENT)
		DKRS_GOODSCONTENT = Replace(DKRS_GOODSCONTENT,"<img ","<img width=""100%""")
		DKRS_GOODSCONTENT = Replace(DKRS_GOODSCONTENT,"<IMG ","<IMG width=""100%""")
		DKRS_GOODSCONTENT = RegExpReplace2("(width=(?:|'|""))((^[0-9]))((?:|'|""))",DKRS_GOODSCONTENT,"width=""100%""")
		print DKRS_GOODSCONTENT
	%>
	</div>
</div>
