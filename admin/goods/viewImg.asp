<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<!--#include virtual = "/admin/_inc/document.asp"-->
<%

		goodsIDX = gRequestTF("Gidx",True)
		filePath = gRequestTF("fp",True)


		SQL = "SELECT * FROM [DK_GOODS] WHERE [intIDX] = ?"
		arrParams = Array(_
			Db.makeParam("@intIDX",adInteger,adParamInput,4,goodsIDX) _
		)
		Set DKRS = Db.execRs(SQL,DB_TEXT,arrParams,Nothing)
		If Not DKRS.BOF And Not DKRS.EOF Then
			DKRS_ImgType = DKRS("isImgType")
			DKRS_Img1Ori = DKRS("Img1Ori")
			DKRS_Img2Ori = DKRS("Img2Ori")
			DKRS_Img3Ori = DKRS("Img3Ori")
			DKRS_Img4Ori = DKRS("Img4Ori")
			DKRS_Img5Ori = DKRS("Img5Ori")
			DKRS_ImgList = DKRS("ImgList")
			DKRS_ImgThum = DKRS("ImgThum")
			DKRS_imgMobMain = DKRS("imgMobMain")
		Else
			Call ALERTS("존재하지 않는 상품입니다.","CLOSE","")
		End If
		Call closeRS(DKRS)

		Select Case filePath
			Case "img1" : thisImg = DKRS_Img1Ori
			Case "img2" : thisImg = DKRS_Img2Ori
			Case "img3" : thisImg = DKRS_Img3Ori
			Case "img4" : thisImg = DKRS_Img4Ori
			Case "img5" : thisImg = DKRS_Img5Ori
			Case "list" : thisImg = DKRS_ImgList
			Case "thum" : thisImg = DKRS_ImgThum
			Case "mobMain" : thisImg = DKRS_imgMobMain
		End Select

	If DKRS_ImgType = "S" Then
		imgPath = VIR_PATH("goods")&"/"&filePath&"/"&backword(thisImg)
		imgWidth = 0
		imgHeight = 0

		Call imgInfo(imgPath,imgWidth,imgHeight,"")
		popWidth = imgWidth
		popHeight = imgHeight + 150
	Else


		imgPath = thisImg
		popWidth = 550
		popHeight = 700
	End If




%>
<style type="text/css">
	html {overflow:hidden}	/*크롬 스크롤바 생성 방지*/
	.bgtitle {
		width:100%;padding:10px 10px;margin:0px auto;
		background: #2a5ebf;
	}
	.bgtitle .bgFont{
		font-size:20px;color:#eee;font-family:malgun gothic;Arial,verdana;
	}
	.btn_area {text-align:center;}
	.area1 {text-align:center; border-bottom:1px solid #ccc;padding:10px 0px;}
</style>
</head>
<body>
<div id="pop_all">
	<!-- <div class="top"><%=viewImg(IMG_POP&"/tit_goodsViewImg.gif",250,40,"")%></div> -->
	<div class="bgtitle tweight">
		<span class="bgFont">이미지보기</span>
	</div>
	<div class="area1"><img src="<%=imgPath%>" alt="" /></div>
	<div class="btn_area"><%=aImgSt("javascript:self.close();",IMG_BTN&"/btn_close_01.gif",52,23,"","margin-top:20px;margin-right:20px;","")%></div>
</div>

<script type="text/javascript">
<!--
	resizePopupWindow(parseInt("<%=popWidth%>", 10), parseInt("<%=popHeight%>", 10));
//-->
</script>
</body>
</html>