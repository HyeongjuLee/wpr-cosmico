<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	Call FN_NationCurrency(DK_MEMBER_NATIONCODE,Chg_CurrencyName,Chg_CurrencyISO)


	PAGE_SETTING = "INDEX"



'상품 리스트 표기
	PCONF_isNOTS = "F"
	PCONF_isAUTH = "F"
	PCONF_isDEAL = "F"
	PCONF_isVIPS = "F"
	PCONF_isALLS = "F"

	Select Case DK_MEMBER_LEVEL
		Case 0,1		: PCONF_isNOTS = "T"
		Case 2			: PCONF_isAUTH = "T"
		Case 3			: PCONF_isDEAL = "T"
		Case 4,5		: PCONF_isVIPS = "T"
		Case 9,10,11	: PCONF_isALLS = "T"
	End Select


%>
<!--#include virtual = "/m/_include/document.asp"-->
<!--#include virtual = "/m/_include/jqueryload.asp"-->
<link rel="stylesheet" href="/m/js/swiper/swiper.min.css" />
<script type="text/javascript" src="/m/js/swiper/swiper.min.js"></script>
<script type="text/javascript" src="/m/jquery/jquery.100.visuals.js"></script>
<!-- <script type="text/javascript" src="/jscript/jquery-ui.min_custom_draggable.js"></script>
<script type="text/javascript" src="/jscript/jquery.ui.touch-punch.min.js"></script> -->
<script type="text/javascript">
<!--
// -->
</script>
<link rel="stylesheet" type="text/css" href="/m/css/index1.css" />
<style type="text/css">

	.swiper-button-next,
	.swiper-button-prev {
		background-color: white;
		background-color: #DCDCDC;
		right:10px;
		padding: 10px;
		color: #000 !important;
		fill: black !important;
		stroke: black !important;

		width:40px;
		height:40px;
		border-top-left-radius: 100px;
		border-top-right-radius: 100px;
		border-bottom-left-radius: 100px;
		border-bottom-right-radius: 100px;
	}
	.swiper-button-prev {
		background-size:60% 60%;

	}
	.swiper-button-next {
		background-size:60% 60%;
	}

	.swiper-container div span i {position: absolute; width: 20px; height: 1px; background: #676767;}
	.swiper-container .swiper-button-prev .i01 {transform: rotate(-45deg); top: 23px; left: 18px;}
	.swiper-container .swiper-button-prev .i02 {transform: rotate(45deg); bottom: 22px; left: 18px;}
	.swiper-container .swiper-button-next .i01 {transform: rotate(45deg); top: 22px; right: 18px;}
	.swiper-container .swiper-button-next .i02 {transform: rotate(-45deg); bottom: 23px; right: 18px;}

</style>

</head>
<body onUnload="">
<!--#include virtual = "/m/_include/header.asp"-->
<!--#include virtual = "/m/_include/sub_header.asp"-->
<!--'include virtual="/popupLayer_m.asp" -->
<div id="index">
	<div class="index_vote porel width100">
		<!-- 모바일 Swipe배너 S -->
		<div class="clear swiper-container2" style=" display:block;">
			<div class="swiper-wrapper">
			<!-- <div class="swiper-slide">
				<a href="#"><img src="<%=M_IMG%>/main_visual01.jpg" alt="" /></a>
			</div>
			<div class="swiper-slide">
				<a href="#"><img src="<%=M_IMG%>/main_visual01.jpg" alt="" /></a>
			</div> -->
			<%
				arrParams = Array(_
					Db.makeParam("@TOPCNT",adInteger,adParamInput,4,5), _
					Db.makeParam("@strArea",adVarChar,adParamInput,20,"m01_a01"), _
					Db.makeParam("@strNationCode",adVarChar,adParamInput,6,UCase(DK_MEMBER_NATIONCODE)) _
				)
				arrList = Db.execRsList("DKSP_SHOP_DESIGN_BANNERS_LIST_TOP",DB_PROC,arrParams,listLen,Nothing)
				If IsArray(arrList) Then
					totalRowCnt = listLen + 1
					For i = 0 To listLen
						arrList_intIDX          = arrList(0,i)
						arrList_strArea         = arrList(1,i)
						arrList_intSort         = arrList(2,i)
						arrList_isUse           = arrList(3,i)
						arrList_isDel           = arrList(4,i)
						arrList_strTitle        = arrList(5,i)
						arrList_isLink          = arrList(6,i)
						arrList_isLinkTarget    = arrList(7,i)
						arrList_strLink         = BACKWORD(arrList(8,i))
						arrList_strImg          = BACKWORD(arrList(9,i))
						arrList_regDate         = arrList(10,i)
						arrList_regID           = arrList(11,i)
						arrList_regIP			= arrList(12,i)

						Select Case arrList_isLinkTarget
							Case "S" : targets = "target=""_self"""
							Case "B" : targets = "target=""_blank"""
						End Select
						If arrList_isLink = "T" Then
							linkF = "<a href="""&arrList_strLink&""" "&targets&" class=""btn01"">"
							linkL = "</a>"
						Else
							linkF = ""
							linkL = ""
						End If

			%>
			<div class="swiper-slide" id="swiper-slide-main"><%=linkF%><img src="<%=VIR_PATH("shop_design_Banner_T")%>/<%=arrList_strImg%>" class="width100" alt="" /><%=linkL%></div>
			<%
					Next
				End If
			%>
			</div>
			<!-- <div class="swiper-button-prev"><span><i class="i01"></i><i class="i02"></i></div>
			<div class="swiper-button-next"><span><i class="i01"></i><i class="i02"></i></div> -->

			<div class="swiper-pagination swiper-pagination-black"></div>

		</div>
		<script>
			var swiper = new Swiper('.swiper-container2', {
				pagination: '.swiper-pagination',
				effect: 'slide', /*넘김효과*/
				paginationClickable: true,
				centeredSlides: true,
				autoplay: 2500,
				spaceBetween: 0,
				autoplayDisableOnInteraction: false,
			});

		</script>
		<style type="text/css">
			.swiper-slide img {width: 100%;}

			/* swiper-pagination custom */
			.swiper-pagination{text-align:center;margin-left:-20px;}

			.swiper-container-horizontal>.swiper-pagination-bullets, .swiper-pagination-custom, .swiper-pagination-fraction {bottom: 20px;}
			.swiper-container-horizontal>.swiper-pagination-bullets .swiper-pagination-bullet {margin: 0 2.5px;}

			/* other pagination */
			.swiper-pagination .swiper-pagination-bullet {
			  width:10px;
			  height:10px;
			  background-color: #fff;
			  border-radius: 10px;
			  opacity: 1;
			}
			/* active pagination */
			.swiper-pagination .swiper-pagination-bullet-active {
			  background-color: #efff81;
			}
		</style>
	</div>

	<div class="clear swiper-container" style="display:block;">
		<div class="swiper-wrapper">
		<%
			arrParams2 = Array(_
				Db.makeParam("@TOPCNT",adInteger,adParamInput,4,5), _
				Db.makeParam("@strArea",adVarChar,adParamInput,20,"m02_a01"), _
				Db.makeParam("@strNationCode",adVarChar,adParamInput,6,UCase(DK_MEMBER_NATIONCODE)) _
			)
			arrList2 = Db.execRsList("DKSP_SHOP_DESIGN_BANNERS_LIST_TOP",DB_PROC,arrParams2,listLen2,Nothing)
			If IsArray(arrList2) Then
				For i = 0 To listLen2
					arrList2_intIDX          = arrList2(0,i)
					arrList2_strArea         = arrList2(1,i)
					arrList2_intSort         = arrList2(2,i)
					arrList2_isUse           = arrList2(3,i)
					arrList2_isDel           = arrList2(4,i)
					arrList2_strTitle        = arrList2(5,i)
					arrList2_isLink          = arrList2(6,i)
					arrList2_isLinkTarget    = arrList2(7,i)
					arrList2_strLink         = BACKWORD(arrList2(8,i))
					arrList2_strImg          = BACKWORD(arrList2(9,i))
					arrList2_regDate         = arrList2(10,i)
					arrList2_regID           = arrList2(11,i)
					arrList2_regIP			= arrList2(12,i)

					Select Case arrList2_isLinkTarget
						Case "S" : targets = "target=""_self"""
						Case "B" : targets = "target=""_blank"""
					End Select
					If arrList2_isLink = "T" Then
						linkF = "<a href="""&arrList2_strLink&""" "&targets&" class=""btn01"">"
						linkL = "</a>"
					Else
						linkF = ""
						linkL = ""
					End If

					listLen2CNT = listLen2
		%>
		<div class="swiper-slide" id="swiper-slide-main"><%=linkF%><img src="<%=VIR_PATH("shop_design_Banner_T")%>/<%=arrList2_strImg%>" class="width100" alt="" /><%=linkL%></div>
		<%
				Next
			End If
		%>
		</div>
		<%If listLen2CNT > 0 Then %>
		<div class="swiper-button-prev"><span><i class="i01"></i><i class="i02"></i></div>
		<div class="swiper-button-next"><span><i class="i01"></i><i class="i02"></i></div>
		<%End If%>
		<!-- <div class="swiper-pagination swiper-pagination-black"></div> -->
	</div>
	<script>
		var swiper = new Swiper('.swiper-container', {
			//pagination: '.swiper-pagination',
			effect: 'fade', /*넘김효과*/
			//paginationClickable: true,
			centeredSlides: true,
			autoplay: false,
			spaceBetween: 0,
			autoplayDisableOnInteraction: false,

			nextButton: '.swiper-button-next',
			prevButton: '.swiper-button-prev'
		});
	</script>
	<!-- <div id="index_bn">
		<p class="prev"><span><i class="i01"></i><i class="i02"></i></span></p>
		<p class="next"><span><i class="i01"></i><i class="i02"></i></span></p>
		<ul>
			<li><a href="#"><img src="<%=M_IMG%>/brand_visual01.jpg" alt="" /></a></li>
			<li><a href="#"><img src="<%=M_IMG%>/brand_visual01.jpg" alt="" /></a></li>
			<li><a href="#"><img src="<%=M_IMG%>/brand_visual01.jpg" alt="" /></a></li>
		</ul>
	</div> -->

	<div id="index_btn">
		<ul class="inner">
			<li><a href="#">
				<img src="/m/images/index_btn01.jpg" alt="" />
				<p>
					<span class="s01">Brand Core Value</span>
					<span class="s02">사람을 먼저 생각하여 최적의<br />원료를 바탕으로 신뢰할 수 있는<br />제품을 제공합니다.</span>
				</p>
			</a></li>
			<li><a href="#">
				<img src="/m/images/index_btn02.jpg" alt="" />
				<p>
					<span class="s01">Brand Vision</span>
					<span class="s02">Stellar S&P는 인간 본연의 빛나는<br />아름다움을 찾기 위한 도전을<br />멈추지 않겠습니다.</span>
				</p>
			</a></li>
			<li><a href="#">
				<img src="/m/images/index_btn03.jpg" alt="" />
				<p>
					<span class="s01">Notice</span>
					<span class="s02">주식회사 스킨파워의 정보와 소식<br />그리고 궁금하신 사항을 확인하실<br />수 있습니다.</span>
				</p>
			</a></li>
			<li><a href="#">
				<img src="/m/images/index_btn04.jpg" alt="" />
				<p>
					<span class="s01">My Office</span>
					<span class="s02">판매원 정보 및 수당내역, 회원정보<br />등을 마이오피스에서 조회/확인<br />하실 수 있습니다.</span>
				</p>
			</a></li>
		</ul>
	</div>
</div>



<script src="/m/jquerymobile/jquery.rwdImageMaps.min.js"></script>
<script>
$(document).ready(function(e) {
	$('img[usemap]').rwdImageMaps();
/*
	$('area').on('click', function() {
		alert($(this).attr('alt') + ' clicked');
	});
*/
});

</script>
<!--#include virtual = "/m/_include/copyright.asp"--></body>
</html>