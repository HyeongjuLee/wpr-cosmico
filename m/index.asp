<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	Call FN_NationCurrency(DK_MEMBER_NATIONCODE,Chg_CurrencyName,Chg_CurrencyISO)


	PAGE_SETTING = "INDEX"


	pm = gRequestTF("pm",False)
	backUrl = gRequestTF("backUrl",False)

	If pm = "dv" And backUrl <> "" Then
		Set objEncrypter = Server.CreateObject ("Hyeongryeol.StringEncrypter")
			objEncrypter.Key = con_EncryptKey
			objEncrypter.InitialVector = con_EncryptKeyIV
			If backUrl	<> "" Then backUrl	 = objEncrypter.Decrypt(backUrl)
		Set objEncrypter = Nothing

		Response.Redirect backUrl
		Response.End

	End If
%>
<%
	CATEGORY		= ""

	Page			= Request("Page")
	Pagesize		= 4
	Dim tSEARCHTERM		:	tSEARCHTERM = pRequestTF("tSEARCHTERM",False)
	Dim tSEARCHSTR		:	tSEARCHSTR = pRequestTF("tSEARCHSTR",False)
	Dim minPrice		:	minPrice = pRequestTF("minPrice",False)
	Dim maxPrice		:	maxPrice = pRequestTF("maxPrice",False)

	If tSEARCHTERM = ""	Then tSEARCHTERM = "" End If
	If tSEARCHSTR = ""	Then tSEARCHSTR = "" End if
	If PAGE = ""		Then PAGE = 1 End If

	If minPrice = "" Then minPrice = ""
	If maxPrice = "" Then maxPrice = ""

	PCONF_LINECNT = 4 '페이지 사이즈에 맞춘 상품 나열 갯수 (베스트, 추천, 새상품)

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

	'플래그 초기화
	PCONF_isBest	= "F"
	PCONF_isVote	= "F"
	PCONF_isNew		= "F"
	PCONF_isEvent	= "F"

	GOODS_SEARCH_TOTAL_PROC = "HJSP_CATEGORY_GOODS_SEARCH_TOTAL"

	'PRINT CATEGORY
%>
<!--#include virtual = "/m/_include/document.asp"-->
<!--#include virtual = "/m/_include/jqueryload.asp"-->
<link rel="stylesheet" href="/m/css/swiper-bundle.css?v0">
<script src="/jscript/swiper-bundle.js"></script>
<script >
	function chgGoodsIndex(cate) {
		$.ajax({
			type: "POST"
			,url: "chgGoodsIndex.asp"
			,data : {
				"cate"  : cate
			}
			,success: function(data) {
				document.getElementById("chgIndexContent").innerHTML = data;
			}
			,error:function(data) {
				alert("ajax 처리 중 에러가 발생하였습니다.ERROR CODE : "+data.status+" "+data.statusText+" "+data.responseText);
			}
		});
	}
	function check_frm(){
		<%If DK_MEMBER_LEVEL < 1 THEN%>
			var msg = "<%=LNG_SHOP_DETAILVIEW_10%>";
			if(confirm(msg)){
				document.location.href="/m/common/member_login.asp?backURL=<%=ThisPageURL%>";
				return;
			}else{
				return;
			}
		<%END IF%>
	}
</script>
<style>
	#header {color: #fff; margin-bottom: -13rem;}
	.header #logo img {filter: brightness(10) contrast(10);}
</style>
</head>
<body onUnload="">
<!--#include virtual = "/m/_include/header.asp"-->
<!--#include virtual="/popupLayer_m.asp" -->
<div id="index">
	<!-- 모바일 Swipe배너 S -->
	<div class="main-visual swiper-container">
		<div class="swiper-wrapper">
			<%
				arrParams = Array(_
					Db.makeParam("@TOPCNT",adInteger,adParamInput,4,5), _
					Db.makeParam("@strArea",adVarChar,adParamInput,20,"m01_a01"), _
					Db.makeParam("@strNationCode",adVarChar,adParamInput,6,UCase(LangGLB)) _
				)
				arrList = Db.execRsList("DKSP_SHOP_DESIGN_BANNERS_LIST_TOP",DB_PROC,arrParams,listLen,Nothing)
				If IsArray(arrList) Then

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
						arrList_strScontent     = arrList(16,i)

						Select Case arrList_isLinkTarget
							Case "S" : targets = "target=""_self"""
							Case "B" : targets = "target=""_blank"""
						End Select
						If arrList_isLink = "T" Then
							linkF = "<a href="""&arrList_strLink&""" "&targets&">"
							linkL = "</a>"
						Else
							linkF = ""
							linkL = ""
						End If
			%>
			<div class="swiper-slide"><%=linkF%>
				<img src="<%=VIR_PATH("shop_design_Banner_T")%>/<%=arrList_strImg%>" alt="" /><%=linkL%>
			</div>
			<%
						listLenCNT = listLen

						If i = 0 Then arr_TITLE01 = arrList_strTitle
						If i = 1 Then arr_TITLE02 = arrList_strTitle
						If i = 2 Then arr_TITLE03 = arrList_strTitle
						If i = 3 Then arr_TITLE04 = arrList_strTitle
					Next
				End If
			%>
		</div>
		<div class="swiper-pagination"></div>

		<script type="text/javascript">
			var swiper = new Swiper('.main-visual', {
				centeredSlides: true,
				effect: 'slide',
				loop: true,
				// simulateTouch: false,
				// allowTouchMove: false,
				//slidesPerGroup: 1,
				//slidesPerView: 1,
				//spaceBetween: 0;
				speed: 300,

				// navigation: {
				// 	nextEl: '.swiper-button-next',
				// 	prevEl: '.swiper-button-prev',
				// },

				pagination: {
					el: '.main-visual .swiper-pagination',
					type: 'bullets',
					//type: 'fraction',
					// type: 'progressbar',
					// type: 'custom',
				},

				// scrollbar: {
				// 	el: '.swiper-scrollbar',
				// },

				autoplay: {
					delay: 5000,
					disableOnInteraction: false,
				}
			});
		</script>
	</div>

	<div class="index-best">
		<div class="title"><b>BEST</b> PRODUCT</div>
		<%'=============상품 category ajaxing S ===============%>
		<div id="chgIndexContent" class="layout_inner">
			<!--include virtual = "/_include/header_shop_category.asp"-->
			<!-- 카테고리 베스트 상품 S -->
			<div class="wrap">
				<%
					arrParams = Array(_
						Db.makeParam("@CATEGORY",adVarChar,adParamInput,21,CATEGORY), _
						Db.makeParam("@PAGESIZE",adInteger,adParamInput,0,PAGESIZE),_
						Db.makeParam("@PAGE",adInteger,adParamInput,0,PAGE),_
						Db.makeParam("@tSEARCHSTR",adVarChar,adParamInput,30,tSEARCHSTR), _
						Db.makeParam("@tSEARCHTERM",adVarChar,adParamInput,30,tSEARCHTERM), _
						Db.makeParam("@GoodsPrice1",adInteger,adParamInput,50,minPrice), _
						Db.makeParam("@GoodsPrice2",adInteger,adParamInput,50,maxPrice), _

						Db.makeParam("@isBest",adChar,adParamInput,1,PCONF_isBest), _
						Db.makeParam("@isVote",adChar,adParamInput,1,PCONF_isVote), _
						Db.makeParam("@isNew",adChar,adParamInput,1,PCONF_isNew), _
						Db.makeParam("@isEvent",adChar,adParamInput,1,PCONF_isEvent), _

						Db.makeParam("@isNOTS",adChar,adParamInput,1,PCONF_isNOTS), _
						Db.makeParam("@isAUTH",adChar,adParamInput,1,PCONF_isAUTH), _
						Db.makeParam("@isDEAL",adChar,adParamInput,1,PCONF_isDEAL), _
						Db.makeParam("@isVIPS",adChar,adParamInput,1,PCONF_isVIPS), _
						Db.makeParam("@isALLS",adChar,adParamInput,1,PCONF_isALLS), _
						Db.makeParam("@strNationCode",adVarChar,adParamInput,6,UCase(DK_MEMBER_NATIONCODE)), _

						Db.makeParam("@All_Count",adInteger,adParamOutput,0,0) _
					)
					arrList = Db.execRsList(GOODS_SEARCH_TOTAL_PROC,DB_PROC,arrParams,listLen,Nothing)
					If IsArray(arrList) Then
						For i = 0 To listLen
							arrList_intIDX				= arrList(1,i)
							arrList_GoodsName			= BACKWORD(arrList(2,i))
							arrList_GoodsComment		= BACKWORD(arrList(3,i))
							arrList_GoodsPrice			= arrList(4,i)
							arrList_GoodsCustomer		= arrList(5,i)
							arrList_GoodsCost			= arrList(6,i)
							arrList_GoodsModels			= arrList(7,i)
							arrList_GoodsBrand			= arrList(8,i)
							arrList_GoodsMaterial		= arrList(9,i)
							arrList_imgList				= BACKWORD(arrList(10,i))
							arrList_isCSGoods			= arrList(11,i)
							arrList_CSGoodsCode			= arrList(12,i)
							arrList_GoodsStockType		= arrList(13,i)
							arrList_GoodsPoint			= arrList(14,i)
							arrList_intPriceNot			= arrList(15,i)
							arrList_intPriceAuth		= arrList(16,i)
							arrList_intPriceDeal		= arrList(17,i)
							arrList_intPriceVIP			= arrList(18,i)
							arrList_intMinNot			= arrList(19,i)
							arrList_intMinAuth			= arrList(20,i)
							arrList_intMinDeal			= arrList(21,i)
							arrList_intMinVIP			= arrList(22,i)

							arrList_intPointNot			= arrList(23,i)
							arrList_intPointAuth		= arrList(24,i)
							arrList_intPointDeal		= arrList(25,i)
							arrList_intPointVIP			= arrList(26,i)
							arrList_isImgType			= arrList(27,i)

							notPrice = arrList_intPriceNot

							'▣ 소비자 가격
							If CONST_CS_SOBIJA_PRICE_USE_TF = "T" Then
								If DK_MEMBER_STYPE = "1" And arrList_isCSGoods = "T" Then
									notPrice = arrList_GoodsCustomer
								End If
							End If

							Select Case DK_MEMBER_LEVEL
								Case 0,1 '비회원, 일반회원
									arrList_GoodsPrice = arrList_intPriceNot
									arrList_GoodsPoint = arrList_intPointNot
								Case 2 '인증회원
									arrList_GoodsPrice = arrList_intPriceAuth
									arrList_GoodsPoint = arrList_intPointAuth
								Case 3 '딜러회원
									arrList_GoodsPrice = arrList_intPriceDeal
									arrList_GoodsPoint = arrList_intPointDeal
								Case 4,5 'VIP 회원
									arrList_GoodsPrice = arrList_intPriceVIP
									arrList_GoodsPoint = arrList_intPointVIP
								Case 9,10,11
									arrList_GoodsPrice = arrList_intPriceVIP
									arrList_GoodsPoint = arrList_intPointVIP
							End Select

							imgPath = VIR_PATH("goods/list")&"/"&arrList_imgList
							goodsImg = "<img src="""&imgPath&""" alt="""" />"

							RS_price4 = 0
							If arrList_isCSGoods = "T" Then
								arrParams = Array(_
									Db.makeParam("@ncode",adVarChar,adParamInput,20,arrList_CSGoodsCode) _
								)
								Set DKRS = Db.execRs("HJP_CSGOODS_PRICE_INFO",DB_PROC,arrParams,DB3)
								If Not DKRS.BOF And Not DKRS.EOF Then
									RS_ncode		= DKRS("ncode")
									RS_price		= DKRS("price")
									RS_price2		= DKRS("price2")
									RS_price4		= DKRS("price4")
									RS_price5		= DKRS("price5")
									RS_price6		= DKRS("price6")
									RS_SellCode		= DKRS("SellCode")
									RS_SellTypeName	= DKRS("SellTypeName")
								End If
								Call closeRs(DKRS)
							End If
				%>
				<div class="goods">
					<%If DK_MEMBER_LEVEL > 0 Then%>
					<a href="/m/shop/detailView.asp?gidx=<%=arrList_intIDX%>">
					<%Else%>
					<!-- <a href="javascript: check_frm();"> -->
					<a href="/m/shop/detailView.asp?gidx=<%=arrList_intIDX%>">
					<%End If %>
						<div class="img"><%=goodsImg%></div>
						<div class="txt">
							<p class="name"><%=arrList_goodsName%></p>
							<p class="comment"><%=arrList_GoodsComment%></p>
							<%If DK_MEMBER_LEVEL > 0 Then%>
								<div class="price">
									<%If CONST_CS_SOBIJA_PRICE_USE_TF = "T" And DK_MEMBER_STYPE = 1 Then	'소비자회원 소비자가%>
										<div><span><%=num2cur(arrList_GoodsCustomer)%></span><%=Chg_CurrencyISO%></div>
									<%Else%>
										<p class="line"><span><%=num2cur(arrList_GoodsCustomer)%></span><!-- <%=Chg_CurrencyISO%> --></p>
										<div><span><%=num2cur(notPrice)%></span><%=Chg_CurrencyISO%></div>
										<%If RS_price4 <> "" And DK_MEMBER_LEVEL > 0 And DK_MEMBER_STYPE <> "1" Then %>
										<p class="pv"><span><%=num2cur(RS_price4)%></span><%=CS_PV%></p>
										<!--<p class="bv"><span><%=num2cur(RS_price5)%></span><%=CS_PV2%></p>-->
										<%End If%>
									<%End If%>
								</div>
							<%Else%>
								<div class="price" style="margin-bottom: 40px;">
									<div><span><%=num2cur(arrList_GoodsCustomer)%></span><%=Chg_CurrencyISO%></div>
								</div>
							<%End If%>
						</div>
					</a>
				</div>
				<%
						Next
					Else
				%>
					<div class="layout_inner tcenter">
						<div class="width100 nodata"><%=LNG_SHOP_NOT_DATA_TXT_01%></div>
					</div>
				<%
					End If
				%>

			</div>
		<!-- 카테고리 베스트 상품 E -->
		</div>
		<%'=============상품 category ajaxing E ===============%>
	</div>

	<div class="index-list">
		<div class="swiper-container layout_inner">
			<div class="swiper-wrapper">
				<%
					arrParamsB = Array(_
						Db.makeParam("@TOPCNT",adInteger,adParamInput,4,10), _
						Db.makeParam("@strArea",adVarChar,adParamInput,20,"n02_a01"), _
						Db.makeParam("@strNationCode",adVarChar,adParamInput,6,UCase(DK_MEMBER_NATIONCODE)) _
					)
					arrListB = Db.execRsList("DKSP_SHOP_DESIGN_BANNERS_LIST_TOP",DB_PROC,arrParamsB,listLenB,Nothing)
					If IsArray(arrListB) Then
						For i = 0 To listLenB
							arrListB_intIDX          = arrListB(0,i)
							arrListB_strArea         = arrListB(1,i)
							arrListB_intSort         = arrListB(2,i)
							arrListB_isUse           = arrListB(3,i)
							arrListB_isDel           = arrListB(4,i)
							arrListB_strTitle        = arrListB(5,i)
							arrListB_isLink          = arrListB(6,i)
							arrListB_isLinkTarget    = arrListB(7,i)
							arrListB_strLink         = BACKWORD(arrListB(8,i))
							arrListB_strImg          = BACKWORD(arrListB(9,i))
							arrListB_regDate         = arrListB(10,i)
							arrListB_regID           = arrListB(11,i)
							arrListB_regIP			 = arrListB(12,i)
							arrListB_strLink2   	 = arrListB(13,i)
							arrListB_strNation  	 = arrListB(14,i)
							arrListB_strSubtitle	 = arrListB(15,i)
							arrListB_strScontent	 = arrListB(16,i)

							Select Case arrListB_isLinkTarget
								Case "S" : targets = "target=""_self"""
								Case "B" : targets = "target=""_blank"""
							End Select
							If arrListB_isLink = "T" Then
								linkF = "<a href="""&arrListB_strLink&""" "&targets&" class=""btn"">자세히 보기"
								linkL = "</a>"
							Else
								linkF = ""
								linkL = ""
							End If
				%>
				<div class="swiper-slide">
					<div class="img">
						<img src="<%=VIR_PATH("shop_design_Banner_T")%>/<%=arrListB_strImg%>" style="max-width:440px; max-height:440px;" alt="" />
					</div>
					<div class="txt">
						<span>NEW PRODUCT</span>
						<div><%=arrListB_strTitle%></div>
						<i></i>
						<p><%=arrListB_strScontent%></p>
						<%=linkF%><%=linkL%>
					</div>
				</div>
				<%
						Next
					End If
				%>
			</div>
			<div class="swiper-inner">
				<div class="swiper-button prev" data-ripplet><i class="icon-left"></i></div>
				<div class="swiper-button next" data-ripplet><i class="icon-right"></i></div>
				<!-- <div class="swiper-pagination"></div> -->
			</div>

			<script type="text/javascript">
				var swiper2 = new Swiper('.index-list .swiper-container', {
					centeredSlides: true,
					effect: 'slide',
					loop: true,
					// simulateTouch: false,
					//slidesPerGroup: 1,
					// slidesPerView: 5,
					//spaceBetween: 0;
					speed: 500,
					slideToClickedSlide: false,

					navigation: {
						nextEl: '.swiper-button.next',
						prevEl: '.swiper-button.prev',
					},

					pagination: {
						el: '.index-list .swiper-pagination',
						//type: 'bullets',
						// type: 'fraction',
						// type: 'progressbar',
						// type: 'custom',
					},

					// scrollbar: {
					// 	el: '.swiper-scrollbar',
					// },

					autoplay: {
						delay: 3000,
						disableOnInteraction: false,
					}

					// on: {
					// 	slideChange: function(){
					// 		//$('.swiper-slide-active').width(400);
					// 	}
					// }
				});
			</script>
		</div>
	</div>

	<div class="index-bn">
		<div class="bg"></div>
		<div class="layout_inner">
			<div class="dn-logo"><img src="/images/share/dn8_logo.svg?"></div>
			<i></i>
			<p><b>과학</b>이 주는 <b>최고</b>의 <b>선물</b></p>
		</div>
	</div>

	<div class="index-skills layout_inner">
		<div class="title"><b>Dn.8</b> Technical Skills</div>
		<ul>
			<li>
				<div class="img"><img src="/images/index/index-btn01.jpg" alt=""></div>
				<div class="txt">
					<div>EWG 100% All Green Grade</div>
					<p>미국 환경 연구단체 EWG에서 유해성을 기준으로 분류한 화장품 원료 등급으로서, ‘그린’ 등급이 가장 안전한 단계 입니다.</p>
				</div>
			</li>
			<li>
				<div class="img"><img src="/images/index/index-btn02.jpg" alt=""></div>
				<div class="txt">
					<div>Remedy Of ROS-Material</div>
					<p>Remedy Of ROS-Material 물질이 들어있는 항산화 화장품으로 피부 노화를 억제로 안티에이징을 실현할 수 있습니다.</p>
				</div>
			</li>
		</ul>
	</div>

	<%'동영상 팝업%>
	<link rel="stylesheet" href="/m/css/type_video_popup.css?">
	<script type="text/javascript" src="/jscript/youtubepopup/youtubePopup.jquery.js"></script>
	<script type="text/javascript">
		$(function(){
			$("a").YouTubePopUp();
		});
	</script>
	<div class="index-video layout_inner">
		<div class="title"><b>COSMICOKOREA</b> in Videos</div>
		<div class="video-visual swiper-container">
			<div class="swiper-wrapper">

				<%
					arrParams = Array( _
						Db.makeParam("@strBoardName",adVarChar,adParamInput,50,"movie"), _
						Db.makeParam("@strNation",adVarChar,adParamInput,50,UCase(DK_MEMBER_NATIONCODE)), _
						Db.makeParam("@TOP",adInteger,adParamInput,4,6) _
					)
					arrList = Db.execRsList("HJSP_NBOARD_MOVIE_MAIN_TOP",DB_PROC,arrParams,listLen,Nothing)
					If IsArray(arrList) Then
						totalRowCnt = listLen + 1
						For i = 0 To listLen
							arrList_intIDX				= arrList(0,i)
							arrList_strUserID			= arrList(1,i)
							arrList_strName				= arrList(2,i)
							arrList_regDate				= arrList(3,i)
							arrList_readCnt				= arrList(4,i)
							arrList_strSubject			= arrList(5,i)
							arrList_strPic				= arrList(6,i)
							arrList_TOTALSCORE			= arrList(7,i)
							arrList_TOTALVOTE			= arrList(8,i)
							arrList_movieType			= arrList(9,i)
							arrList_movieURL			= arrList(10,i)
							arrList_regDate = Replace(Left(arrList_regDate,10),"-",".")

							imgPath = VIR_PATH("board/thum")&"/"&backword(arrList_strPic)
				%>
				<div class="swiper-slide">
					<%'If DK_MEMBER_LEVEL < 1 Then%>
						<!-- <a href="<%="/m/common/member_login.asp?backURL="&ThisPageURL%>">
							<div class="img"><i class="icon-play"></i><img src="<%=imgPath%>" width="365.079365079365" height="230" alt="" style=""></div>
						</a> -->
					<%'Else%>
						<a href="<%=arrList_movieURL%>">
							<div class="img"><i class="icon-play"></i><img src="<%=imgPath%>" width="365.079365079365" height="230" alt="" style=""></div>
							<div class="txt">
								<p><%=backword_title(cutString(arrList_strSubject,15))%></p>
							</div>
						</a>
					<%'End If%>
				</div>
				<%
						Next
					End If
				%>

			</div>
		</div>
		<!-- <div class="swiper-inner">
			<div class="swiper-button prev" data-ripplet><i class="icon-angle-left"></i></div>
			<div class="swiper-button next" data-ripplet><i class="icon-angle-right"></i></div>
			<div class="swiper-pagination"></div>
		</div> -->

		<script type="text/javascript">
			var swiper3 = new Swiper('.video-visual', {
				// centeredSlides: true,
				effect: 'slide',
				loop: true,
				// simulateTouch: false,
				//slidesPerGroup: 1,
				slidesPerView: 2,
				//spaceBetween: 0;
				speed: 1000,

				navigation: {
					// nextEl: '.swiper-button.next',
					// prevEl: '.swiper-button.prev',
				},

				pagination: {
					el: '.video-visual .swiper-pagination',
					// type: 'bullets',
					// type: 'fraction',
					// type: 'progressbar',
					// type: 'custom',
				},

				// scrollbar: {
				// 	el: '.swiper-scrollbar',
				// },

				autoplay: {
					delay: 3000,
					disableOnInteraction: false,
				}
			});
		</script>

		<div class="more">
			<a href="/m/cboard/board_list.asp?bname=movie" class="link" target="_blank">MORE<i class="icon-visual-right"></i></a>
		</div>
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
<!--#include virtual = "/m/_include/copyright.asp"-->
</body>
