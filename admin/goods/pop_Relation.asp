<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<!--#include virtual = "/admin/_inc/document.asp"-->
<%
' ===================================================================
' 게시판 변수 받아오기(설정)
' ===================================================================
	Dim popWidth,popHeight
		popWidth = 400
		popHeight = 300

	Dim IDV
		IDV = gRequestTF("idv",False)

	arrParams = Array(_
		Db.makeParam("@intIDX",adInteger,adParamInput,0,IDV) _
	)
	Set DKRS = Db.execRs("DKPA_RELATION_GOODS",DB_PROC,arrParams,Nothing)

	If Not DKRS.BOF And Not DKRS.EOF Then
		RS_Img1Ori			= DKRS("Img1Ori")
		RS_Category			= DKRS("Category")
		RS_GOODSNAME		= DKRS("GoodsName")
	Else
		Call ALERTS("상품이 삭제 되었거나 잘못된 상품 번호입니다.","close","")
	End If



%>
<link rel="stylesheet" href="/admin/css/popStyle.css" />
</head>
<body>
<div id="popAll1">
	<div class="top"><%=viewImg(IMG_POP&"/pop_Relation.gif",250,40,"")%></div>
	<div id="Relation">
		<table <%=tableatt1%> style="width:100%;">
			<colgroup>
				<col width="120" />
				<col width="80" />
				<col width="*" />
			</colgroup>
			<tr>
				<%
					imgWidth = 0
					imgHeight = 0
					Call ImgInfo(VIR_PATH("Goods/thum")&"/"&RS_Img1Ori,imgWidth,imgHeight,"")
				%>
				<th rowspan="2"><%=viewImg(VIR_PATH("Goods/thum")&"/"&RS_Img1Ori,imgWidth,imgHeight,"")%></th>
				<td class="tcenter">카테고리</td>
				<td><strong><%=PrintCate(Left(RS_Category,3),Left(RS_Category,6))%></strong></td>
			</tr><tr>
				<td class="tcenter">상품명</td>
				<td><strong><%=RS_GOODSNAME%></strong></td>
			</tr>
		</table>
		<p class="titles">등록된 관련 상품 목록</p>
		<%

			If PAGESIZE = "" Then PAGESIZE = 5
			If PAGE = "" Then PAGE = 1

			arrParams = Array(_
				Db.makeParam("@intIDX",adInteger,adParamInput,0,IDV),_
				Db.makeParam("@PAGE",adInteger,adParamInput,0,PAGE),_
				Db.makeParam("@PAGESIZE",adInteger,adParamInput,0,PAGESIZE),_
				Db.makeParam("@ALL_COUNT",adInteger,adParamOutput,0,0)_
			)
			arrList = Db.execRsList("DKPA_RELATION_LIST",DB_PROC,arrParams,listLen,Nothing)
			ALL_COUNT = arrParams(UBound(arrParams))(4)
			' ===================================================================
				Dim PAGECOUNT,CNT
				PAGECOUNT = Int((CCur(All_Count) - 1 ) / CInt(PAGESIZE) ) + 1
				IF CCur(PAGE) = 1 Then
					CNT = All_Count
				Else
					CNT = All_Count - ((CCur(PAGE)-1)*CInt(PAGESIZE)) '
				End If

			If IsArray(arrList) Then
				For i = 0 To listLen
					imgWidth = 0
					imgHeight = 0
					Call ImgInfo(VIR_PATH("Goods/thum")&"/"&RS_Img1Ori,imgWidth,imgHeight,"")
					PRINT tabs(2)&"	<p style=""padding:5px"">"&viewImg(VIR_PATH("Goods/thum")&"/"&RS_Img1Ori,imgWidth,imgHeight,"")&"</p>"

				Next
			Else
				PRINT tabs(2)&"	<p style=""width:100%""></p>"&VbCrLf
			End If




		%>

	</div>
	<div class="bottom">
		<div class="info"><%=viewImg(IMG_POP&"/pop_bottom_info.gif",160,60,"")%></div>
		<div class="btn_area"><%=aImgSt("javascript:self.close()",IMG_BTN&"/btn_close_01.gif",52,23,"","margin-top:20px;margin-right:20px;","")%></div>
	</div>
</div>

<script type="text/javascript">
<!--
resizePopupWindow(parseInt("<%=popWidth%>", 10), parseInt("<%=popHeight%>", 10));
//-->
</script>


</body>
</html>
