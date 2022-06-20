<!--#include virtual = "/_lib/strFunc.asp"-->
<%

	Response.Redirect "/m/shop/category.asp"





	Call FN_NationCurrency(DK_MEMBER_NATIONCODE,Chg_CurrencyName,Chg_CurrencyISO)

	PAGE_SETTING = "SHOP"

'	CATEGORY	= gRequestTF("cate",True)


	Dim tSEARCHTERM		:	tSEARCHTERM = pRequestTF("tSEARCHTERM",False)
	Dim tSEARCHSTR		:	tSEARCHSTR = pRequestTF("tSEARCHSTR",False)
	Dim minPrice		:	minPrice = pRequestTF("minPrice",False)
	Dim maxPrice		:	maxPrice = pRequestTF("maxPrice",False)

	If tSEARCHTERM = ""	Then tSEARCHTERM = "" End If
	If tSEARCHSTR = ""	Then tSEARCHSTR = "" End if

	If minPrice = "" Then minPrice = ""
	If maxPrice = "" Then maxPrice = ""

	If CATEGORY = "" Then CATEGORY = "101"



	PCONF_TOPCNT = 4 '페이지 사이즈에 맞춘 상품 나열 갯수 하단의 PCONF_LINECNT 의 제곱으로 나가야함
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

%>
<!--#include virtual = "/m/_include/document.asp"-->
<!--#include virtual = "/m/_include/jqueryload.asp"-->
<link rel="stylesheet" href="/m/js/swiper/swiper.min.css" />
<script type="text/javascript" src="/m/js/swiper/swiper.min.js"></script>
<script type="text/javascript">
<!--

	//index BEST AJAX
	function chgGoodsIndex(cate) {
		$.ajax({
			type: "POST"
			,url: "/m/chgGoodsIndex.asp"
			,data : {
				"cate"  : cate
			}
			,success: function(data) {
				document.getElementById("chgIndexContent").innerHTML = data;
				//document.getElementsByClassName("chgIndexContent")[0].innerHTML = data;
			}
			,error:function(data) {
				alert("ajax 처리 중 에러가 발생하였습니다.ERROR CODE : "+data.status+" "+data.statusText+" "+data.responseText);
			}
		});
	}


// -->
</script>
<link rel="stylesheet" type="text/css" href="shop.css?v1" />
<script type="text/javascript" src="shop.js"></script>
<style type="text/css">



</style>
</head>
<body>
<!--#include virtual = "/m/_include/header.asp"-->
<div id="shopIndex">
	<!-- 모바일 Swipe배너 S -->
	<div class="clear shop swiper-container" style=" display:block;">
		<div class="swiper-wrapper">
			<%
				arrParams = Array(_
					Db.makeParam("@TOPCNT",adInteger,adParamInput,4,4), _
					Db.makeParam("@strArea",adVarChar,adParamInput,20,"ms1_a01"), _
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
			<div class="swiper-slide"><%=linkF%><img src="<%=VIR_PATH("shop_design_Banner_T")%>/<%=arrList_strImg%>" class="width100" alt="" /><%=linkL%></div>
			<%
					Next
				End If
			%>
		</div>
		<!-- <div class="swiper-pagination swiper-pagination-black"></div> -->
		<script>
			var swiper = new Swiper('.shop.swiper-container', {
				pagination: '.swiper-pagination',
				effect: 'x', /*넘김효과*/
				paginationClickable: true,
				centeredSlides: true,
				autoplay: 2500,
				spaceBetween: 0,
				autoplayDisableOnInteraction: false,
				loop: true,
			});
		</script>
	</div>

	<div id="index_top">
		<div class="left">
			<div id="goods_wrap" class="goods_left_top">
				<div class="wrap">
					<div class="goods">
						<a href="#">
							<div class="img"><img src="/images/shop/goods01.jpg" alt="" /></div>
							<div class="txt">
								<p class="p01">남성의시크릿존, 보습과 쿨링감을 선사합니다.</p>
								<p class="p02">매너맨 워시 젤 바이 질경이</p>
							</div>
							<div class="price">
								<table>
									<tr class="tr01">
										<td class="td01">소비자가</td>
										<td class="td02"><span>486,000</span>원</td>
									</tr>
									<tr class="tr02">
										<td class="td01">회 원 가</td>
										<td class="td02"><span>326,000</span>원</td>
									</tr>
								</table>
							</div>
							<div class="pv">471PV</div>
						</a>
					</div>
					<div class="goods">
						<a href="#">
							<div class="img"><img src="/images/shop/goods01.jpg" alt="" /></div>
							<div class="txt">
								<p class="p01">남성의시크릿존, 보습과 쿨링감을 선사합니다.</p>
								<p class="p02">매너맨 워시 젤 바이 질경이</p>
							</div>
							<div class="price">
								<table>
									<tr class="tr01">
										<td class="td01">소비자가</td>
										<td class="td02"><span>486,000</span>원</td>
									</tr>
									<tr class="tr02">
										<td class="td01">회 원 가</td>
										<td class="td02"><span>326,000</span>원</td>
									</tr>
								</table>
							</div>
							<div class="pv">471PV</div>
						</a>
					</div>
				</div>
			</div>
			<div id="index_bn">
				<a href="#"><img src="/images/shop/shop_bn01.jpg" alt="" /></a>
			</div>
		</div>

		<div class="right">
			<div id="goods_wrap" class="goods_right_bottom">
				<div class="wrap">
					<div class="goods">
						<a href="#">
							<div class="img"><img src="/images/shop/goods01.jpg" alt="" /></div>
							<div class="txt">
								<p class="p01">남성의시크릿존, 보습과 쿨링감을 선사합니다.</p>
								<p class="p02">매너맨 워시 젤 바이 질경이</p>
							</div>
							<div class="price">
								<table>
									<tr class="tr01">
										<td class="td01">소비자가</td>
										<td class="td02"><span>486,000</span>원</td>
									</tr>
									<tr class="tr02">
										<td class="td01">회원가</td>
										<td class="td02"><span>326,000</span>원</td>
									</tr>
								</table>
								<div class="pv">471PV</div>
							</div>
						</a>
					</div>
					<div class="goods">
						<a href="#">
							<div class="img"><img src="/images/shop/goods01.jpg" alt="" /></div>
							<div class="txt">
								<p class="p01">남성의시크릿존, 보습과 쿨링감을 선사합니다.</p>
								<p class="p02">매너맨 워시 젤 바이 질경이</p>
							</div>
							<div class="price">
								<table>
									<tr class="tr01">
										<td class="td01">소비자가</td>
										<td class="td02"><span>486,000</span>원</td>
									</tr>
									<tr class="tr02">
										<td class="td01">회원가</td>
										<td class="td02"><span>326,000</span>원</td>
									</tr>
								</table>
								<div class="pv">471PV</div>
							</div>
						</a>
					</div>
				</div>
			</div>
			<div id="index_bn">
				<a href="#"><img src="/images/shop/shop_bn02.jpg" alt="" /></a>
			</div>
		</div>
		
	</div>

	<div class="index_goods">
		<div id="goods_wrap">
			<div class="wrap">
				<div class="goods">
					<a href="#">
						<div class="img"><img src="/images/shop/goods01.jpg" alt="" /></div>
						<div class="txt">
							<p class="p01">남성의시크릿존, 보습과 쿨링감을 선사합니다.</p>
							<p class="p02">매너맨 워시 젤 바이 질경이</p>
						</div>
						<div class="price">
							<table>
								<tr class="tr01">
									<td class="td01">소비자가</td>
									<td class="td02"><span>486,000</span>원</td>
								</tr>
								<tr class="tr02">
									<td class="td01">회원가</td>
									<td class="td02"><span>326,000</span>원</td>
								</tr>
							</table>
							<div class="pv">471PV</div>
						</div>
					</a>
				</div>
				<div class="goods">
					<a href="#">
						<div class="img"><img src="/images/shop/goods01.jpg" alt="" /></div>
						<div class="txt">
							<p class="p01">남성의시크릿존, 보습과 쿨링감을 선사합니다.</p>
							<p class="p02">매너맨 워시 젤 바이 질경이</p>
						</div>
						<div class="price">
							<table>
								<tr class="tr01">
									<td class="td01">소비자가</td>
									<td class="td02"><span>486,000</span>원</td>
								</tr>
								<tr class="tr02">
									<td class="td01">회원가</td>
									<td class="td02"><span>326,000</span>원</td>
								</tr>
							</table>
							<div class="pv">471PV</div>
						</div>
					</a>
				</div>
				<div class="goods">
					<a href="#">
						<div class="img"><img src="/images/shop/goods01.jpg" alt="" /></div>
						<div class="txt">
							<p class="p01">남성의시크릿존, 보습과 쿨링감을 선사합니다.</p>
							<p class="p02">매너맨 워시 젤 바이 질경이</p>
						</div>
						<div class="price">
							<table>
								<tr class="tr01">
									<td class="td01">소비자가</td>
									<td class="td02"><span>486,000</span>원</td>
								</tr>
								<tr class="tr02">
									<td class="td01">회원가</td>
									<td class="td02"><span>326,000</span>원</td>
								</tr>
							</table>
							<div class="pv">471PV</div>
						</div>
					</a>
				</div>
				<div class="goods">
					<a href="#">
						<div class="img"><img src="/images/shop/goods01.jpg" alt="" /></div>
						<div class="txt">
							<p class="p01">남성의시크릿존, 보습과 쿨링감을 선사합니다.</p>
							<p class="p02">매너맨 워시 젤 바이 질경이</p>
						</div>
						<div class="price">
							<table>
								<tr class="tr01">
									<td class="td01">소비자가</td>
									<td class="td02"><span>486,000</span>원</td>
								</tr>
								<tr class="tr02">
									<td class="td01">회원가</td>
									<td class="td02"><span>326,000</span>원</td>
								</tr>
							</table>
							<div class="pv">471PV</div>
						</div>
					</a>
				</div>
			
				<div class="goods">
					<a href="#">
						<div class="img"><img src="/images/shop/goods01.jpg" alt="" /></div>
						<div class="txt">
							<p class="p01">남성의시크릿존, 보습과 쿨링감을 선사합니다.</p>
							<p class="p02">매너맨 워시 젤 바이 질경이</p>
						</div>
						<div class="price">
							<table>
								<tr class="tr01">
									<td class="td01">소비자가</td>
									<td class="td02"><span>486,000</span>원</td>
								</tr>
								<tr class="tr02">
									<td class="td01">회원가</td>
									<td class="td02"><span>326,000</span>원</td>
								</tr>
							</table>
							<div class="pv">471PV</div>
						</div>
					</a>
				</div>
				<div class="goods">
					<a href="#">
						<div class="img"><img src="/images/shop/goods01.jpg" alt="" /></div>
						<div class="txt">
							<p class="p01">남성의시크릿존, 보습과 쿨링감을 선사합니다.</p>
							<p class="p02">매너맨 워시 젤 바이 질경이</p>
						</div>
						<div class="price">
							<table>
								<tr class="tr01">
									<td class="td01">소비자가</td>
									<td class="td02"><span>486,000</span>원</td>
								</tr>
								<tr class="tr02">
									<td class="td01">회원가</td>
									<td class="td02"><span>326,000</span>원</td>
								</tr>
							</table>
							<div class="pv">471PV</div>
						</div>
					</a>
				</div>
				<div class="goods">
					<a href="#">
						<div class="img"><img src="/images/shop/goods01.jpg" alt="" /></div>
						<div class="txt">
							<p class="p01">남성의시크릿존, 보습과 쿨링감을 선사합니다.</p>
							<p class="p02">매너맨 워시 젤 바이 질경이</p>
						</div>
						<div class="price">
							<table>
								<tr class="tr01">
									<td class="td01">소비자가</td>
									<td class="td02"><span>486,000</span>원</td>
								</tr>
								<tr class="tr02">
									<td class="td01">회원가</td>
									<td class="td02"><span>326,000</span>원</td>
								</tr>
							</table>
							<div class="pv">471PV</div>
						</div>
					</a>
				</div>
				<div class="goods">
					<a href="#">
						<div class="img"><img src="/images/shop/goods01.jpg" alt="" /></div>
						<div class="txt">
							<p class="p01">남성의시크릿존, 보습과 쿨링감을 선사합니다.</p>
							<p class="p02">매너맨 워시 젤 바이 질경이</p>
						</div>
						<div class="price">
							<table>
								<tr class="tr01">
									<td class="td01">소비자가</td>
									<td class="td02"><span>486,000</span>원</td>
								</tr>
								<tr class="tr02">
									<td class="td01">회원가</td>
									<td class="td02"><span>326,000</span>원</td>
								</tr>
							</table>
							<div class="pv">471PV</div>
						</div>
					</a>
				</div>
				
				<div class="goods">
					<a href="#">
						<div class="img"><img src="/images/shop/goods01.jpg" alt="" /></div>
						<div class="txt">
							<p class="p01">남성의시크릿존, 보습과 쿨링감을 선사합니다.</p>
							<p class="p02">매너맨 워시 젤 바이 질경이</p>
						</div>
						<div class="price">
							<table>
								<tr class="tr01">
									<td class="td01">소비자가</td>
									<td class="td02"><span>486,000</span>원</td>
								</tr>
								<tr class="tr02">
									<td class="td01">회원가</td>
									<td class="td02"><span>326,000</span>원</td>
								</tr>
							</table>
							<div class="pv">471PV</div>
						</div>
					</a>
				</div>
				<div class="goods">
					<a href="#">
						<div class="img"><img src="/images/shop/goods01.jpg" alt="" /></div>
						<div class="txt">
							<p class="p01">남성의시크릿존, 보습과 쿨링감을 선사합니다.</p>
							<p class="p02">매너맨 워시 젤 바이 질경이</p>
						</div>
						<div class="price">
							<table>
								<tr class="tr01">
									<td class="td01">소비자가</td>
									<td class="td02"><span>486,000</span>원</td>
								</tr>
								<tr class="tr02">
									<td class="td01">회원가</td>
									<td class="td02"><span>326,000</span>원</td>
								</tr>
							</table>
							<div class="pv">471PV</div>
						</div>
					</a>
				</div>
				<div class="goods">
					<a href="#">
						<div class="img"><img src="/images/shop/goods01.jpg" alt="" /></div>
						<div class="txt">
							<p class="p01">남성의시크릿존, 보습과 쿨링감을 선사합니다.</p>
							<p class="p02">매너맨 워시 젤 바이 질경이</p>
						</div>
						<div class="price">
							<table>
								<tr class="tr01">
									<td class="td01">소비자가</td>
									<td class="td02"><span>486,000</span>원</td>
								</tr>
								<tr class="tr02">
									<td class="td01">회원가</td>
									<td class="td02"><span>326,000</span>원</td>
								</tr>
							</table>
							<div class="pv">471PV</div>
						</div>
					</a>
				</div>
				<div class="goods">
					<a href="#">
						<div class="img"><img src="/images/shop/goods01.jpg" alt="" /></div>
						<div class="txt">
							<p class="p01">남성의시크릿존, 보습과 쿨링감을 선사합니다.</p>
							<p class="p02">매너맨 워시 젤 바이 질경이</p>
						</div>
						<div class="price">
							<table>
								<tr class="tr01">
									<td class="td01">소비자가</td>
									<td class="td02"><span>486,000</span>원</td>
								</tr>
								<tr class="tr02">
									<td class="td01">회원가</td>
									<td class="td02"><span>326,000</span>원</td>
								</tr>
							</table>
							<div class="pv">471PV</div>
						</div>
					</a>
				</div>
			</div>
			
			<div class="more">
				<p><span><%=LNG_SHOP_INDEX_TXT_02%></span><i></i></p>
			</div>
		</div>
	</div>

	<form name="frm" method="post" action="">
		<input type="hidden" name="PAGESIZE" value="<%=PAGESIZE%>" />
		<input type="hidden" name="PAGE" value="<%=PAGE%>" />
	</form>
</div>
<!--#include virtual = "/m/_include/copyright.asp"-->