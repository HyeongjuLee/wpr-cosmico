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
			// if ($('.header-all ul').css('display') !== '') {
			// 	$('html').click(function(e){
			// 		if(!$(e.target).is($('.header-all ul'))) {
			// 			$('.header-all ul').fadeOut();
			// 		}
			// 	});
			// }
		});
	</script>
	<!-- header S-->
	<header>
		<div id="header" class="header">
			<article>
				<div id="logo"><a href="/index.asp"><img src="/images/share/logo(1).svg?v0" alt="" /></a></div>
				<nav id="nav" class="nav">
					<ul class="nav-main">
						<!--#include virtual = "/navi/company.asp"-->
						<!--#include virtual = "/navi/business.asp"-->
						<!--#include virtual = "/navi/brand.asp"-->
						<!--#include virtual = "/navi/shop.asp"-->
						<!--#include virtual = "/navi/customer.asp"-->
					</ul>
				</nav>
				<div class="header-all">
					<div class="icon-menu">
						<span></span>
						<span></span>
						<span></span>
					</div>
					<ul>
						<%=TOP_BTN_SET%>
					</ul>
				</div>
				<!--#include virtual = "/_include/header_Lang.asp"-->
				<!--include virtual = "/_include/header_search.asp"-->
			</article>
			<span class="nav-bg"></span>

			<script type="text/javascript">
				$(document).ready(function() {

					// .nav-sub 중 가장 높은 높이값과 전체 높이값 동일하게 조절
					var maxHeight 	= -1,
						$header		= $('#header'),
						$main		= $('.nav-main'),
						$sub		= $('.nav-sub'),
						$bg			= $('.nav-bg');

					$main.find('li.main .icon-right-open-big')
					.remove();					
					
					//hover시 smenu보임
					$main.hover(function(){
						setTimeout(function() {
							//return false;
							maxHeight = maxHeight > $sub.outerHeight() ? maxHeight : $sub.outerHeight();
							//$bg.height(maxHeight + 100);
							$bg.animate({height: maxHeight + 100});
						}, 300);
					},
					function(){
						$('.nav-main, .nav-sub, .nav-bg').removeClass('hover');
						$bg.animate({height: 0});
						//$bg.height('auto');
					});
				});
			</script>
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