<!--#include virtual = "/_lib/strFunc.asp"-->
<!--#include virtual = "/_include/document.asp"-->
<%


	intIDX = gRequestTF("idv",True)


	arrParams = Array(_
		Db.makeParam("@intIDX",adInteger,adParamInput,0,intIDX) _
	)
	Set DKRS = Db.execRs("DKP_GOODS_REVIEW_VIEW",DB_PROC,arrParams,Nothing)
	If Not DKRS.BOF And Not DKRS.EOF Then
		DKRS_intIDX			= DKRS("intIDX")
		DKRS_goodsIDX		= DKRS("goodsIDX")
		DKRS_strUserID		= DKRS("strUserID")
		DKRS_strGrade		= DKRS("strGrade")
		DKRS_strSubject		= DKRS("strSubject")
		DKRS_strContent		= DKRS("strContent")
		DKRS_ReadCnt		= DKRS("ReadCnt")
		DKRS_regDate		= DKRS("regDate")
		DKRS_imgThum		= DKRS("imgThum")
		DKRS_GoodsName		= DKRS("GoodsName")
		DKRS_strOption		= DKRS("strOption")
	Else
		Call ALERTS("상품정보,주문내역,리뷰글 중 하나가 데이터베이스에서 삭제되었거나 운영자에 의해서 블라인드 처리된 리뷰입니다.","close","")
	End If

	ThisIDLen = Len(DKRS_strUserID)
	ThisWriterID = Left(Left(DKRS_strUserID,3)&"********************",ThisIDLen)

	imgPath = VIR_PATH("Goods/thum")&"/"&backword(DKRS_imgThum)
	imgWidth = 0
	imgHeight = 0
	Call imgInfo(imgPath,imgWidth,imgHeight,"")

%>

<style type="text/css">
div#pop_top {clear:both;width:100%; height:40px;background:url(/images/pop/popAll1_bg.gif) 0 0 repeat-x;overflow:hidden;}
.input_text {height:16px; padding-top:2px;border:1px solid #ccc;}
.input_area {border:1px solid #ccc; width:350px; height:200px;}
div#close {height:30px;text-align:center;margin-top:20px; padding-bottom:20px;}
.line1 {height:1px; background-color:#dedede;}
.line2 {height:2px; background-color:#f4f4f4;}



	.phone td, .phone th {border-bottom:1px dotted #ccc;border-top:1px dotted #ccc;}

	.phone td {padding-left:10px;}
	.phone th {background-color:#eee;}


	.review td, .review th {border:1px dotted #ccc; padding:5px 0px;}
	.review td {padding-left:10px;}
	.review th {background-color:#eee;}
</style>
</head>
<body>
<div id="pop_top"><img src="<%=IMG_POP%>/tit_ReviewView.gif" width="250" height="40" alt="" /></div>
<table <%=tableatt%> style="width:770px;" class="phone">
	<colgroup>
		<col width="120" />
		<col width="110" />
		<col width="*" />
	</colgroup><tr>
		<td rowspan="5" class="tcenter" style="padding:10px 0px;"><%=viewImg(imgPath,imgWidth,imgHeight,"")%></td>
		<th>상품명</th>
		<td><strong><%=DKRS_GoodsName%></strong></td>
	</tr><tr>
		<th>구입옵션</th>
		<td>
		<%
			If DKRS_strOption <> "" Then
				arrOpt = Split(DKRS_strOption,",")
				For z = 0 To UBound(arrOpt)
					arrOptTxt = Split(arrOpt(z),"\")
					print arrOptTxt(0) & "<br />"
				Next
			End If
		%>
		</td>
	</tr>
</table>
<p style="padding:10px 0px; text-align:center;"><%=viewImg(IMG_POP&"/review_pop_tit03.gif",700,35,"")%></p>

<table <%=tableatt%> style="width:770px;" class="review">
	<colgroup>
		<col width="110" />
		<col width="*" />
	</colgroup>
	<tr>
		<th>추 천 도</th>
		<td><%=viewImg(IMG_SHOP&"/review_icon0"&DKRS_strGrade&".gif",55,16,"")%></td>
	</tr><tr>
		<th>리뷰제목</th>
		<td><strong><%=DKRS_strSubject%></strong></td>
	</tr><tr>
		<th>내&nbsp;&nbsp;&nbsp;&nbsp;용</th>
		<td style="min-height:130px;" class="lheight160" valign="top"><%=DKRS_strContent%></td>
	</tr><tr>
		<th>작 성 일</th>
		<td><%=DKRS_regDate%> 에 <%=ThisWriterID%> 님이 작성하신 리뷰입니다.</td>
	</tr>
</table>

<div id="close">
	<div class="line1"></div>
	<div class="line2"></div>
	<img src="<%=IMG_JOIN%>/btn_close01.gif" width="52" height="23" alt="창 닫기" style="margin-top:4px;cursor:pointer;" onclick="self.close();" />
</div>


</body>
</html>
