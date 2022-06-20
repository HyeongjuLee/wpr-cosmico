<style type="text/css">
	.left_navi ,.left_navi ul,.left_navi li{margin:0;padding:0;list-style:none}
	.left_navi img{border:0}

	.left_navi {position:relative;width:170px;}
	.left_navi .LEFT_main {position:relative;z-index:1; margin-top:0px; border-bottom:1px solid #eee;}
	.left_navi .LEFT_main a {display:block; height:39px; line-height:39px;font-family:"맑은 고딕","malgun gothic"; font-size:14px; font-weight:bold; text-indent:14px; letter-spacing:-1px;}
	.left_navi .LEFT_main a:hover {color:#fff;/*wi dth:140px;*/}
	.left_navi .LEFT_main ul {padding:10px 20px; display:inline;width:150px; background-color:#f5f5f5;} /*display:none;   width 추가*/
	.left_navi .LEFT_main ul li a {display:block; height:28px; line-height:28px; padding-top:0px; padding-left:10px;background:url('/images/left/icon.gif') no-repeat 0 11px; border-bottom:1px solid #ddd; font-size:13px; text-indent:0px;}
	.left_navi .LEFT_main ul li a:hover {color:red;}
	#left_navi {position:relative;}
	#left_navi .left_Follow {position:absolute;margin-top:2px;z-index:0;}
	#left_navi .DB_select {background:url(/images/left/follow.png) 0px 2px no-repeat; color:#fff;}
	#left_navi .DB_select a {}
	#left_navi .DB_select2 {color:red;}
</style>
<%
If ISLEFT = "T" Then

	SUBCATEGORY = gRequestTF("cate",false)

	If Len(SUBCATEGORY) > 2 Then
		subCateDepth = 2
		subCateParent = Left(SUBCATEGORY,3)
	Else
		subCateDepth = 1
		subCateParent = "000"
	End If


	SQL = "SELECT [strCateName] FROM [DK_SHOP_CATEGORY] WHERE [strCateCode] = ? AND [strNationCode] = '"&UCase(DK_MEMBER_NATIONCODE)&"' "
	subParams = Array(_
		Db.makeParam("@subCateParent",adVarChar,adParamInput,20,Left(SUBCATEGORY,3)) _
	)
	subCateName = Db.execRsData(SQL,DB_TEXT,subParams,Nothing)

	subParams = Array(_
		Db.makeParam("@subCateDepth",adInteger,adParamInput,4,subCateDepth), _
		Db.makeParam("@subCateParent",adVarChar,adParamInput,20,subCateParent) _
	)
	SQL = "SELECT [intIDX]"
	SQL = SQL & ",[strCateCode],[strCateName]"
	SQL = SQL & " FROM [DK_SHOP_CATEGORY] WHERE [isView] = 'T' AND [intCateDepth] = ? and [strCateParent] = ? AND [strNationCode] = '"&UCase(DK_MEMBER_NATIONCODE)&"' ORDER BY [intCateSort] ASC"

	subList = Db.execRsList(SQL,DB_TEXT,subParams,subLen,Nothing)


%>
<%	'If SHOP_MYPAGE = "T" Then %>
<%	If PAGE_SETTING = "SHOP_MYPAGE" Then%>
		<div id="ShopMenu">
			<div class="sub2Depth"><!-- 쇼핑몰 --><%=LNG_MYPAGE%></div>
			<ul>
				<li class="s2depth <%=shop_left_hover%>"><a href="/mypage/member_info.asp?pt=shop" class="dpblock"><%=Fnc_leftmenu_color(view,1,LNG_MYPAGE_01)%></a></a>
				<!-- <li class="s2depth <%=shop_left_hover%>"><a href="/mypage/wish_list.asp?pt=shop" class="dpblock"><%=Fnc_leftmenu_color(view,2,LNG_MYPAGE_02)%></a></a>
				<li class="s2depth <%=shop_left_hover%>"><a href="/shop/cart.asp" class="dpblock"><%=Fnc_leftmenu_color(view,3,LNG_MYPAGE_03)%></a></a>
				<li class="s2depth <%=shop_left_hover%>"><a href="/mypage/order_list.asp?pt=shop" class="dpblock"><%=Fnc_leftmenu_color(view,4,LNG_MYPAGE_04)%></a></a> -->
			</ul>
		</div>
<%	Else%>

		<div id="ShopMenu">
			<!-- <div class="sub2Depth"><%=subCateName%></div> -->
			<div class="sub2Depth"><a href="/shop/category.asp?cate=<%=Left(CATEGORY,3)%>"><span style="color:#f3f3f3;"><%=subCateName%></span></a></div>
			<ul>
				<%
					If IsArray(subList) Then
						For s = 0 To subLen
							If Left(CATEGORY,6) = Left(subList(1,s),6) Then shop_left_hover = "slc_hover" Else shop_left_hover = "" End If
				%>
				<li class="s2depth <%=shop_left_hover%>"><a href="/shop/category.asp?cate=<%=Left(subList(1,s),6)%>" class="dpblock"><%=subList(2,s)%></a>
					<ul class="s2depthUL">
						<li class="s3depth">1</li>
						<li class="s3depth">2</li>
						<li class="s3depth">3</li>
						<li class="s3depth">4</li>
					</ul>
				</li>
				<%		Next%>
				<%	End If%>
			</ul>
		</div>
<%	End If%>

<%End If%>
