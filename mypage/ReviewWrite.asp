<!--#include virtual = "/_lib/strFunc.asp"-->
<!--#include virtual = "/_include/document.asp"-->
<%

	Call Only_Member(DK_MEMBER_LEVEL)


	intIDX = gRequestTF("idv",True)


	arrParams = Array(_
		Db.makeParam("@intIDX",adInteger,adParamInput,0,intIDX) _
	)
'	Set DKRS = Db.execRs("DKP_REVIEW_WRITE_INFO",DB_PROC,arrParams,Nothing)
	Set DKRS = Db.execRs("DKP2_REVIEW_WRITE_INFO",DB_PROC,arrParams,Nothing)
	If Not DKRS.BOF And Not DKRS.EOF Then
		DKRS_gIDX				= DKRS("gIDX")
		DKRS_ReViewTF			= DKRS("ReViewTF")
		DKRS_strOption			= DKRS("strOption")
		DKRS_strUserID			= DKRS("strUserID")
		DKRS_status				= DKRS("status")
		DKRS_GoodsName			= DKRS("GoodsName")
		DKRS_goodsPrice			= DKRS("goodsPrice")
		DKRS_imgThum			= backword(DKRS("imgThum"))
		DKRS_Category			= DKRS("Category")
	Else
		Call ALERTS("주문정보가 올바르지 않습니다.","CLOSE","")
	End If

	If DKRS_status <> "103" Then Call ALERTS("수취확인된 주문에 대해서만 리뷰작성이 가능합니다.","CLOSE","")
	If DKRS_ReViewTF = "T" Then Call ALERTS("이미 리뷰를 작성한 상품입니다.","CLOSE","")
	If DKRS_strUserID <> DK_MEMBER_ID Then Call ALERTS("주문자와 리뷰작성자가 틀립니다.","CLOSE","")

'	imgPath = VIR_PATH("goods/thum")&"/"&DKRS_imgThum
	imgPath = VIR_PATH("goods2/thum")&"/"&DKRS_imgThum
	imgWidth = 0
	imgHeight = 0
	Call imgInfo(imgPath,imgWidth,imgHeight,"")
	imgMarginH = (65 - imgHeight) / 2

%>
<script type="text/javascript">
<!--
	function chkRfrm(f) {
			oEditors.getById["ir1"].exec("UPDATE_CONTENTS_FIELD", []);
		if (f.intIDX.value=="")
		{
			alert("리뷰를 할 상품의 고유값이 로드되지 못했습니다.");
			f.intIDX.focus();
			return false;
		}

		var i,len,totalCnt;
		totalCnt = 0
		for (i=0; i < f.strGrade.length ;i++ )
		{
			if (f.strGrade[i].checked == true) {
				totalCnt = totalCnt + 1;
			} else {
				totalCnt = totalCnt;
			}
		}
		if (totalCnt == 0)
		{
			alert("추천도를 선택해주세요.");
			return false;
		}


		if (f.strSubject.value=="")
		{
			alert("제목을 입력해주세요.");
			f.strSubject.focus();
			return false;
		}
		if (f.content1.value=="")
		{
			alert("내용을 입력해주세요.");
			return false;
		}

		if (checkDataImages(f.content1.value)) {
			alert("문자형이미지(드래그 이미지)는 사용할 수 없습니다.");
			return false;
		}

	}
//-->
</script>
<style type="text/css">
div#pop_top {clear:both; float:left;width:770px; height:40px;background:url(/images/pop/popAll1_bg.gif) 0 0 repeat-x;overflow:hidden;}
.input_text {height:16px; padding-top:2px;border:1px solid #ccc;}
.input_area {border:1px solid #ccc; width:350px; height:200px;}

div#close {height:30px;text-align:right;margin-top:13px;}
.line1 {height:1px; background-color:#dedede;}
.line2 {height:2px; background-color:#f4f4f4;}
.goods td,.goods th {border:1px dotted #ccc; padding:5px 0px;}
.goods td.pl10 {padding-left:10px;}
.goods th {background-color:#eee;}

.write td {border:1px solid #ccc; padding:5px 0px;}
.write th {border:1px solid #ccc; padding:5px 0px;}
.write td.pl10 {padding-left:10px;}
.write th {background-color:#eee;}
.write td label {float:left; display:block; margin-right:10px;}
.input_check {margin:0px 0px 0px 0px;vertical-align:middle;}
.border_not_left {border-left:0px none !important;}
.border_not_right {border-right:0px none !important;}
 .thumImg {border:1px solid #ccc; width:65px; height:65px; margin:0px auto;}

</style>
<%=CONST_SmartEditor_JS%>
</head>
<body>
<div id="pop_top"><img src="<%=IMG_POP%>/tit_Review.gif" width="250" height="40" alt="" /></div>
<div id="pop_content">
	<p><%=viewImg(IMG_POP&"/review_pop_tit01.gif",344,20,"")%></p>
	<form name="qfrm" action="ReviewWriteHandler.asp" method="post" onsubmit="return chkRfrm(this)">
	<input type="hidden" name="intIDX" value="<%=intIDX%>" />
	<p style="margin-top:10px;"><%=viewImg(IMG_POP&"/review_pop_stit01.gif",150,18,"")%></p>
	<table <%=tableatt%> style="width:770px;" class="goods">
		<col width="120" />
		<col width="70" />
		<col width="" />
		<tr>
			<td rowspan="2" class="tcenter"><div class="thumImg tcenter" style=""><%=viewImgOPT(imgPath,imgWidth,imgHeight,"","style=""margin-top:"&imgMarginH&"px;""")%></div></td>

			<td class="pl10 text_8pt color_b0b0b0 border_not_right">구입상품 :</td>
			<td class="pl10 border_not_left tweight"><%=DKRS_GoodsName%></td>
		</tr><tr>
			<td class="pl10 text_8pt color_b0b0b0 border_not_right lheight160 " valign="top">선택옵션 :</td>
			<td class="pl10 text_8pt color_b0b0b0 border_not_left lheight160" valign="top">
				<%
					If DKRS_strOption <> "" Then
						arrOpt = Split(DKRS_strOption,",")
						For z = 0 To UBound(arrOpt)
							arrOptTxt = Split(arrOpt(z),"\")
							print arrOptTxt(0)&" (+"&num2cur(arrOptTxt(1)) & " 원)<br />"
						Next
					End If

				%>
			</td>
		</tr>
	</table>
	<p style="margin-top:30px;"><%=viewImg(IMG_POP&"/review_pop_stit02.gif",150,18,"")%></p>
	<table <%=tableatt%> style="width:770px;" class="write">
		<col width="100" />
		<col width="*" />
		<tr>
			<td class="tcenter"><%=viewImg(IMG_POP&"/review_pop_th01.gif",51,16,"")%></td>
			<td class="pl10">
				<label><input type="radio" name="strGrade" value="1" class="input_check" /><%=viewImgOpt(IMG_SHOP&"/review_icon01.gif",55,16,"","class=""vmiddle cp"" onclick=""document.qfrm.strGrade[0].checked=true;"" ")%></label>
				<label><input type="radio" name="strGrade" value="2" class="input_check" /><%=viewImgOpt(IMG_SHOP&"/review_icon02.gif",55,16,"","class=""vmiddle cp"" onclick=""document.qfrm.strGrade[1].checked=true;"" ")%></label>
				<label><input type="radio" name="strGrade" value="3" class="input_check" /><%=viewImgOpt(IMG_SHOP&"/review_icon03.gif",55,16,"","class=""vmiddle cp"" onclick=""document.qfrm.strGrade[2].checked=true;"" ")%></label>
				<label><input type="radio" name="strGrade" value="4" class="input_check" /><%=viewImgOpt(IMG_SHOP&"/review_icon04.gif",55,16,"","class=""vmiddle cp"" onclick=""document.qfrm.strGrade[3].checked=true;"" ")%></label>
			</td>
		</tr><tr>
			<td class="tcenter"><%=viewImg(IMG_POP&"/review_pop_th02.gif",51,16,"")%></td>
			<td class="pl10"><input type="text" name="strSubject" class="input_text" style="width:540px;" /></td>
		</tr><tr>
			<td colspan="2" style="padding:0px">
				<input type="hidden" id="WYG_MOD" name="WYG_MOD" value="T" />
				<textarea name="content1" id="ir1" style="width:100%;height:450px;min-width:610px;display:none;" cols="50" rows="10"></textarea>
				<input type="hidden" name="firstChk" value="T" />
				<%=FN_Print_SmartEditor("ir1","review",UCase(DK_MEMBER_NATIONCODE),"","","")%>
			</td>
		</tr>
	</table>
	<p style="text-align:center;padding:7px 0px;"><%=viewImg(IMG_POP&"/review_pop_tit02.gif",770,63,"")%></p>
	<p class="tcenter"><input type="image" src="<%=IMG_POP%>/qna_pop_write.gif" /></p>
	</form>
</div>
<div id="close">
	<div class="line1"></div>
	<div class="line2"></div>
	<img src="<%=IMG_JOIN%>/btn_close01.gif" width="52" height="23" alt="창 닫기" style="margin-top:4px;cursor:pointer;" onclick="self.close();" />
</div>


</body>
</html>
