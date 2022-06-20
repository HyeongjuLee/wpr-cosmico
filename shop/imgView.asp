<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	'jQuery Modal Dialog방식변경
	If Not (checkRef(houUrl &"/shop/imgView.asp") _
			Or checkRef(houUrl &"/shop/detailView.asp")) Then
		Call alerts(LNG_ALERT_WRONG_ACCESS,"close_p_modal","")
	End If

	gIDX = gRequestTF("idv",True)
	arrParams = Array(_
		Db.makeParam("@intIDX",adInteger,adParamInput,0,gIDX) _
	)
	Set DKRS = Db.execRs("DKP_GOODS_DETAILVIEW",DB_PROC,arrParams,Nothing)
	If Not DKRS.BOF And Not DKRS.EOF Then
		RS_IMG1				= DKRS("Img1Ori")
		RS_IMG2				= DKRS("Img2Ori")
		RS_IMG3				= DKRS("Img3Ori")
		RS_IMG4				= DKRS("Img4Ori")
		RS_IMG5				= DKRS("Img5Ori")
		RS_isImgType		= DKRS("isImgType")
	Else
		'Call ALERTS(LNG_SHOP_DETAILVIEW_01,"BACK","")
		Call ALERTS(LNG_SHOP_DETAILVIEW_01,"p_reloada","")	'Modal Dialog
	End If
	Call closeRs(DKRS)
'print RS_isImgType

	RightSideImgView = ""
	If RS_IMG2 = "" And RS_IMG3 = "" And RS_IMG4 = "" And RS_IMG5 = "" Then RightSideImgView = "display: none;"

%>
<!--#include virtual = "/_include/document.asp"-->
<script type="text/javascript">
</script>
<style type="text/css">
	/* html {overflow:hidden} */
	.bgtitle {width:100%;padding:10px 10px;margin:0px auto;	background: #256615;}
	.bgtitle .bgFont{font-size:20px;color:#eee;font-family:malgun gothic;Arial,verdana;}

	div#pop_top {clear:both; float:left;width:100%; height:40px;background:url(/images/pop/pop_title_bg.gif) 0 0 repeat-x;overflow:hidden;}
	div#close {height:30px;text-align:center;margin-top:13px;}
	.line1 {height:1px; background-color:#dedede;}
	.line2 {height:2px; background-color:#f4f4f4;}

	#detailImgView table td,th {border:1px dotted #ccc; padding:5px; text-align:center;}
	#detailImgView table th {background-color:#eee;}
	#detailImgView table td.sub {height:90px;}
	#detailImgView .bImg {width: 550px; height: 550px; overflow: hidden; text-align: center;}
</style>
</head>
<body>
<!-- <div class="bgtitle tweight">
	<span class="bgFont"><%=LNG_SHOP_DETAILVIEW_IMAGE_DETAIL%></span>
</div> -->
<div id="detailImgView">
	<table <%=tableatt%>>
		<colgroup>
			<col width="" />
			<col width="160" />
		</colgroup>
		<%If RS_isImgType = "S" Then
			imgPath = VIR_PATH("Goods\img1")&"/"&backword(RS_IMG1)
			imgWidth = 0
			imgHeight = 0
			Call imgInfo(imgPath,imgWidth,imgHeight,"")

			If imgWidth > 550 Then imgWidth = 550
			If imgHeight > 550 Then imgHeight = 550

			liMarginTop = (550 - imgHeight) / 2
		%>
		<tr>
			<td rowspan="4">
				<!-- <img src="<%=VIR_PATH("Goods\img1")%>/<%=RS_IMG1%>" width="<%=imgWidth%>" alt="" id="bImgCon" /> -->
				<div class="bImg"><img src="<%=imgPath%>" width="<%=imgWidth%>" height="<%=imgHeight%>" alt="" id="bImgCon" style="margin-top:<%=liMarginTop%>px" /></div>
			</td>
			<td class="sub" style="<%=RightSideImgView%>">
				<%If RS_IMG2 <> "" And Not IsNull(RS_IMG2) Then%><div class="inSimg"><img src="<%=VIR_PATH("Goods/img2")%>/<%=RS_IMG2%>" width="80" alt="" class="cp" onmouseover="document.getElementById('bImgCon').src='<%=VIR_PATH("Goods/img2")%>/<%=RS_IMG2%>';" onmouseout="document.getElementById('bImgCon').src='<%=VIR_PATH("Goods/img1")%>/<%=RS_IMG1%>';" /></div><%End If%>
			</td>
		</tr>
		<%Else%>
		<tr>
			<td rowspan="4"><img src="<%=BACKWORD(RS_IMG1)%>" width="350" height="" alt="350" id="bImgCon"/></td>
			<td class="sub"><%If RS_IMG2 <> "" And Not IsNull(RS_IMG2) Then%><div class="inSimg"><img src="<%=VIR_PATH("Goods/img2")%>/<%=RS_IMG2%>" width="80" alt="" class="cp" onmouseover="document.getElementById('bImgCon').src='<%=VIR_PATH("Goods/img2")%>/<%=RS_IMG2%>';" onmouseout="document.getElementById('bImgCon').src='<%=VIR_PATH("Goods/img1")%>/<%=RS_IMG1%>';" /></div><%End If%></td>
		</tr>
		<%End If%>
		<tr>
			<td class="sub"  style="<%=RightSideImgView%>"
				<%If RS_IMG3 <> "" And Not IsNull(RS_IMG3) Then%><div class="inSimg"><img src="<%=VIR_PATH("Goods/img3")%>/<%=RS_IMG3%>" width="80" alt="" class="cp" onmouseover="document.getElementById('bImgCon').src='<%=VIR_PATH("Goods/img3")%>/<%=RS_IMG3%>';" onmouseout="document.getElementById('bImgCon').src='<%=VIR_PATH("Goods/img1")%>/<%=RS_IMG1%>';" /></div><%End If%>
			</td>
		</tr><tr>
			<td class="sub"  style="<%=RightSideImgView%>"
				<%If RS_IMG4 <> "" And Not IsNull(RS_IMG4) Then%><div class="inSimg"><img src="<%=VIR_PATH("Goods/img4")%>/<%=RS_IMG4%>" width="80" alt="" class="cp" onmouseover="document.getElementById('bImgCon').src='<%=VIR_PATH("Goods/img4")%>/<%=RS_IMG4%>';" onmouseout="document.getElementById('bImgCon').src='<%=VIR_PATH("Goods/img1")%>/<%=RS_IMG1%>';" /></div><%End If%>
			</td>
		</tr><tr>
			<td class="sub"  style="<%=RightSideImgView%>"
				<%If RS_IMG5 <> "" And Not IsNull(RS_IMG5) Then%><div class="inSimg"><img src="<%=VIR_PATH("Goods/img5")%>/<%=RS_IMG5%>" width="80" alt="" class="cp" onmouseover="document.getElementById('bImgCon').src='<%=VIR_PATH("Goods/img5")%>/<%=RS_IMG5%>';" onmouseout="document.getElementById('bImgCon').src='<%=VIR_PATH("Goods/img1")%>/<%=RS_IMG1%>';" /></div><%End If%>
			</td>
		</tr>
	</table>
</div>
<div id="close">
	<div class="line1"></div>
	<div class="line2"></div>
	<!-- <div><span class="button medium tweight" style="margin-top:20px;"><a onclick="self.close();"><%=LNG_TEXT_WINDOW_CLOSE%></a></span></div> -->
	<!-- <img src="<%=IMG_JOIN%>/btn_close01.gif" width="52" height="23" alt="창 닫기" style="margin-top:4px;cursor:pointer;" onclick="self.close();" /> -->
</div>

</body>
</html>
