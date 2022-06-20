<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	PAGE_MODE = "HOME"
	PAGE_SETTING = "INDEX"

	ISLEFT = "F"
	ISFULLPAGE = "T"
%>
<%
	Call FN_NationCurrency(DK_MEMBER_NATIONCODE,Chg_CurrencyName,Chg_CurrencyISO)



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

<!--#include virtual = "/_include/document.asp"-->
<!--#include virtual = "/_include/header.asp"-->
<!--#include virtual="/popup.asp" -->
<script src="/jscript/swiper-bundle.js"></script>
<link rel="stylesheet" href="/css/swiper-bundle.css">
<!-- <script src="/jscript/rgbPixel.js"></script> -->
 <script>
	function check_frm(){
		<%If DK_MEMBER_LEVEL < 1 THEN%>
			var msg = "<%=LNG_SHOP_DETAILVIEW_10%>";
			if(confirm(msg)){
				document.location.href="/common/member_login.asp?backURL=<%=ThisPageURL%>";
				return;
			}else{
				return;
			}
		<%END IF%>
	}

	function chgGoodsIndex(cate) {
		$.ajax({
			type: "POST"
			,url: "/ajax/chgGoodsIndex.asp"
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

	function autoplaying(video) {
		var $video = $('video')[0];

		if ($video.autoplay = false) {
			$video.autoplay = true;
		}
		$video.play();
		//$video.playbackRate = 10;
	}
</script>
</head>
<body>
<!--#include virtual="/popupLayer.asp" -->

<div id="index" class="layout_wrap">
	<div class="main-visual swiper-container">
		<div class="swiper-wrapper">
			<%
				arrParams = Array(_
					Db.makeParam("@TOPCNT",adInteger,adParamInput,4,4), _
					Db.makeParam("@strArea",adVarChar,adParamInput,20,"n01_a01"), _
					Db.makeParam("@strNationCode",adVarChar,adParamInput,6,UCase(LangGLB)) _
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
							linkF = "<a href="""&arrList_strLink&""" "&targets&" class=""btn01"">"
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
		<div class="swiper-inner">
			<div class="swiper-button prev" data-ripplet><i class="icon-play"></i></div>
			<div class="swiper-button next" data-ripplet><i class="icon-play"></i></div>
			<div class="swiper-pagination"></div>
		</div>

		<script type="text/javascript">
			var swiper = new Swiper('.main-visual', {
				centeredSlides: true,
				effect: 'fade',
				loop: true,
				simulateTouch: false,
				//slidesPerGroup: 1,
				//slidesPerView: 1,
				//spaceBetween: 0;
				speed: 1000,

				navigation: {
					nextEl: '.swiper-button.next',
					prevEl: '.swiper-button.prev',
				},

				pagination: {
					el: '.swiper-pagination',
					type: 'bullets',
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
	</div>
</div>
