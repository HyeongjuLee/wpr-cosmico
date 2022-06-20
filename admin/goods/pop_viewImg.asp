<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<!--#include virtual = "/admin/_inc/document.asp"-->
<%
' ===================================================================
' 게시판 변수 받아오기(설정)
' ===================================================================


	Dim IDV
		MODE = gRequestTF("mode",True)
		IDV = gRequestTF("idv",True)





	Select Case MODE
		Case "subBanner"
			SQL = "SELECT [strFile] FROM [DK_DETAIL_BANNER] WHERE [intIDX] = ?"
			arrParams = Array(_
				Db.makeParam("@intIDX",adInteger,adParamInput,0,IDV) _
			)
			ThisImg = Db.execRsData(SQL,DB_TEXT,arrParams,Nothing)

			If ThisImg = "" Or IsNull(ThisImg) Then
				Call ALERTS("해당 이미지가 삭제되었거나 없는 이미지입니다","close","")
			Else
				imgPath = VIR_PATH("indexSlide")&"/"&ThisImg
				imgWidth = 0
				imgHeight = 0
				Call ImgInfo(imgPath,imgWidth,imgHeight,0)
			End If
		Case Else : ThisImg = "Undefined(ERROR)"
	End Select


	Dim popWidth,popHeight
		popWidth = imgWidth + 20
		popHeight = imgHeight + 170



%>
<link rel="stylesheet" href="/admin/css/popStyle.css" />
</head>
<body>
<div id="popAll1">
	<div class="top"><%=viewImg(IMG_POP&"/pop_viewImg.gif",250,40,"")%></div>
	<p style="padding:10px"><%=viewImg(imgPath,imgWidth,imgHeight,"")%></p>
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
