<style type="text/css">
/*SHOP 플로팅-오늘 본 상품*/
	#floating_toDayG {width:90px; overflow-x:hidden;}
	#floating_toDayG .goTop {background-color:#3e4961; color:#adb2c7;  font-weight:bold; text-align:center;}
	#floating_toDayG .goTop a {display:block;padding:7px 0px; color:#adb2c7;}
	#floating_toDayG .goTop a:hover {color:#fff;}

	#floating_toDayG .todayG {width:88px; border:1px solid #acb4c7; border-top:0px none; border-bottom:0px none;}
	#floating_toDayG .todayG>p {font-family:"돋움",dotum, sans-serif; font-size:11px; letter-spacing:-1px; text-align:center; padding:12px 0px 0px 0px; font-weight:bold;}
	#floating_toDayG .todayG .goods {height:270px; overflow-y:hidden; font-family:"돋움",dotum, sans-serif; font-size:12px; letter-spacing:-1px; text-align:center; line-height:16px;}
	#floating_toDayG .todayG .goods a.imgLinks {width:70px; height:70px; overflow:hidden; display:block; border:1px solid #eee;  margin:0px auto;margin-top:8px;}
	#floating_toDayG .todayG .goods .goodsArea {height:240px;}
	#floating_toDayG .todayG p.nots {font-size:12px;padding:75px 0px;}

	#floating_toDayG .toCart {width:88px; height:66px;  border:1px solid #acb4c7; border-top:0px none;}
	#floating_toDayG .toCart>p {font-family:"돋움",dotum, sans-serif; font-size:11px; letter-spacing:-1px; text-align:center; }
	#floating_toDayG .toCart>p a {display:block; height:66px;background:url(/images_kr/cart_bg.png) 50% 5px no-repeat;}
	#floating_toDayG .toCart>p a span {display:block;padding-top:50px; font-weight:bold;}

	#floating_toDayG .goLogin {background-color:#3e4961; color:#adb2c7;  font-weight:bold; text-align:center;}
	#floating_toDayG .goLogin a {display:block;padding:7px 0px; color:#adb2c7;}
	#floating_toDayG .goLogin a:hover {color:#fff;}
</style>
<%
	T_Goods = Request.Cookies("TodayGcode")
	T_Count = Request.Cookies("TodayGcode").count
	If T_Goods = "" OR T_Count = "" Then T_Count = 0
	If T_Count > 12 Then T_Count = 12


	If T_Count / 3 <= 1 Then
		T_Count_page = 1
	Else
		If CInt(T_Count mod 3) = 0 Then
			T_Count_page =  CInt(T_Count / 3)
		Else
			T_Count_page =  CInt(T_Count / 3) + 1
		End If
	End If

%>
<div class="cleft width100">
	<div class="cleft width100 goTop"><a href="#goTop">TOP</a></div>
	<div class="cleft width100 toCart"><p><a href="/shop/cart.asp"><span><%=LNG_HEADER_CART%></span></a></p></div>
	<div class="cleft width100 todayG">
		<p>오늘 본 상품</p>
		<div class="goods" id="todayGoods">
			<div class="goodsArea">
			<%
				If T_Count > 0 Then
					For g_cnt = 1 To 3 ' 3개까지 노출
						TodayGcode = Request.Cookies("TodayGcode")("G" & g_cnt)
						TodayImg = Request.Cookies("TodayImg")("G" & g_cnt)
						'TodayUrl = Request.Cookies("TodayUrl")("G" & g_cnt)
						If TodayGcode <> "" Then
							tGInt = 0
							If InStr(TodayImg,"http://") > 0 Then tGInt = tGInt + 1
							If InStr(TodayImg,"https://") > 0 Then tGInt = tGInt + 1
							If tGInt > 0 Then
								TodayImg = TodayImg
							Else
								TodayImg = VIR_PATH("goods/thum")&"/"&TodayImg
							End If
					%>
					<a href="/shop/detailView.asp?gidx=<%=TodayGcode%>" class="imgLinks"><img src="<%=TodayImg%>" width="70" /></a>
					<%
						End If
					Next
				Else
			%>
				<p class="nots">등록된<br /> 오늘 본 상품이<br /> 없습니다.</p>
			<%
				End If
			%>
			</div>
			<%If T_Count_page = 1 Then%>
			<div style="text-align:center;"><a href="#"><span style="float:left;padding:6px;padding-top:0;">◀</span></a>1 / <%=T_Count_page%><a href="#"><span style="float:right;padding:6px;padding-top:0;">▶</span></a></div>
			<%Else%>
			<div style="text-align:center;"><a href="#"><span style="float:left;padding:6px;padding-top:0;">◀</span></a>1 / <%=T_Count_page%><a href="javascript:fnGetTodayGoods(2);"><span style="float:right;padding:6px;padding-top:0;">▶</span></a></div>
			<%End If%>

		</div>
	</div>
	<%If DK_MEMBER_LEVEL > 0 Then%>
	<div class="cleft width100 goLogin"><a href="/common/member_logout.asp">LOGOUT</a></div>
	<%Else%>
	<div class="cleft width100 goLogin"><a href="/common/member_login.asp?backURL=<%=ThisPageURL%>">LOGIN</a></div>
	<%End If%>
</div>


<%

%>
<script type="text/javascript">
<!--
    function fnGetTodayGoods(page)
    {
        $.ajax({
            type: "POST",
            dataType: "html",
            url: "/shop/toDayG.asp",
            data: { mode : "TODAYGOODS" , page : page },
            success: function(toDayGoods){
				//alert(toDayGoods);
                $("#todayGoods").html(toDayGoods);
            }
            ,error: function(toDayGoods){
				//alert(toDayGoods);
            }
        });
    }
//-->
</script>