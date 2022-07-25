<%Call FN_NationCurrency(DK_MEMBER_NATIONCODE,Chg_CurrencyName,Chg_CurrencyISO)%>
<!--#include virtual = "/_include/header_top_btn.asp"-->

<script type="text/javascript">
<!--
	function frmChk(f) {
		if(!chkNull(f.tSEARCHSTR, "상품명을 입력해 주세요")) return false;
	}
// -->
</script>
<div id="all">
	<script type="text/javascript">
		$(function() {
			//On Scroll Functionality
			$('#header').removeClass('fixed');
			$(window).on({
				scroll: function(){
					var windowTop = $(window).scrollTop();
					windowTop > 80 ? $('#header').addClass('fixed') : $('#header').removeClass('fixed');
					//debugger;
				},
				each: function(){
					var offset = $(window).offset.top;
					offset > 80 ? $('#header').addClass('fixed') : $('#header').removeClass('fixed');
				}
			});
			
			$('.nav-main').hover(function(){
				$('#header').addClass('hover');
			}, function(){
				$('#header').removeClass('hover');
			});

			var $clickLi = $('#header .header-top-btn .menu');
			$clickLi.click(function(){
				$click($(this));
			});
			
			var $click = function(obj){
				$(obj).toggleClass('active');
				$(obj).find('ol').fadeToggle();
				$('.active').not($(obj)).removeClass('active');
				event.stopPropagation();
				// debugger;
				if ($clickLi.hasClass('active')) {
					$(obj).find('ol').fadeIn();
					$('html').click(function(e){
						if(!$(e.target).is($(obj).find('*'))) {
							$(obj).removeClass('active');
							$(obj).find('ol').fadeOut();
						}
					});
				}
			};
		});
	</script>
	<!-- header S-->
	<header class="shop">
		<div id="header" class="header">
			<article>
				<div id="logo"><a href="/index.asp"><img src="/images/share/logo.svg?" alt="" /></a></div>
				<nav id="nav" class="nav">
					<ul class="nav-main">
						<!--#include virtual = "/navi/company.asp"-->
						<!--#include virtual = "/navi/brand.asp"-->
						<!--#include virtual = "/navi/business.asp"-->
						<!--#include virtual = "/navi/guide.asp"-->
						<!--#include virtual = "/navi/shop.asp"-->
						<!--#include virtual = "/navi/community.asp"-->
						<!--#include virtual = "/navi/customer.asp"-->
						<!--#include virtual = "/navi/sns.asp"-->
					</ul>
				</nav>
				<div class="header-top-btn">
					<div class="member">
						<a href="/myoffice/buy/order_list.asp" title="<%=LNG_HEADER_MYOFFICE%>"><i class="icon-member-1"></i></a>
					</div>
					<div class="searchs">
						<i class="icon-search-1"></i>
					</div>
					<div class="menu">
						<span></span>
						<span></span>
						<span></span>
						<ol>
							<%=TOP_BTN_SET%>
						</ol>
					</div>
				</div>
				<div class="search-wrap">
					<!--#include virtual = "/_include/header_search.asp"-->
				</div>
				<!--include virtual = "/_include/header_Lang.asp"-->
			</article>
			<span class="nav-bg"></span>
		</div>
	</header>

	<%
		If ISSUBPADDING = "F" Then
			indexMargin = "cw_index"
		End If
	%>

	<div id="contain_wrap" class="layout_wrap <%=indexMargin%>">
	<%If IS_SHOPLIST = "T" Then 'wellmade shop index 2018-02-08%>
		<div id="contain">
	<%Else%>
		<div id="contain" class="layout_inner">
	<%End If%>
		<%	If ISLEFT = "T" Then%>
			<div id="left" class="wShopL"><!--#include virtual = "/_include/left_shop.asp"--></div>
			<div id="content" class="wShopC">
		<%	Else %>
			<div id="contentFull" <%=cw_style%>>
		<%	End If%>


		<%If IS_SHOPLIST <> "T" Then '1차 카테고리 (/index.asp 외)%>
			<!-- <div id="shop_cate" class="layout_inner">
				<div class="shopMenuAll over"><a href="/shop/category.asp?cm=all"><span class="over">전체</span></a></div>
				<div id="nav" class="nav">
					<ul>
						<% '1차 카테고리 나열(DK_SHOP_CATEGORY, HJ_SHOP_CATEGORY01, HJ_SHOP_CATEGORY02)
							arrParams_C1 = Array(_
								Db.makeParam("@strNationCode",adVarChar,adParamInput,6,UCase(DK_MEMBER_NATIONCODE)) _
							)
							arrList_C1 = Db.execRsList("DKSP_SHOP_CATEGORY_1DEPTH",DB_PROC,arrParams_C1,listLen_C1,Nothing)
							If IsArray(arrList_C1) Then
								For C1 = 0 To listLen_C1
									arrList_C1_strCateCode	= arrList_C1(1,C1)
									arrList_C1_strCateName	= arrList_C1(2,C1)

									If C1 = listLen_C1 Then
										ulClass ="subUL subUL_last"
									Else
										ulClass ="subUL"
									End If
									''현재카테고리 타게팅CSS처리
									If Left(CATEGORY,3) = arrList_C1_strCateCode Then
										CM_BG_CSS = " mainLi2"
										CM_NM_CSS = "color:#2cb6b9;font-weight:bold;"
									Else
										CM_BG_CSS = ""
										CM_NM_CSS = ""
									End If
						%>
						<li class="mainLi <%=CM_BG_CSS%>"><a href="/shop/category.asp?cm=<%=CATE_MODE%>&cate=<%=arrList_C1_strCateCode%>"><span style="<%=CM_NM_CSS%>"><%=arrList_C1_strCateName%></span></a></li>
						<%
								Next
							End If
						%>
					</ul>
				</div>
			</div> -->
		<%End If%>