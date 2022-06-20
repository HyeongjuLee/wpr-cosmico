<li class="main"><a href="/shop/category.asp"><p><%=LNG_SHOP%></p><i><%=LNG_SHOP_OVER%></i></a>
	<ul class="nav-sub">
		<!-- <li><a href="/shop/category.asp"><span><%=LNG_SHOP_HEADER_TXT_01%></span></a></li> -->
		<%
			'대카테고리
			arrParams_H1 = Array(_
				Db.makeParam("@strNationCode",adVarChar,adParamInput,6,UCase(DK_MEMBER_NATIONCODE)), _
				Db.makeParam("@strCateParent",adVarChar,adParamInput,20,"000") _
			)
			arrList_H1 = Db.execRsList("DKP_SHOP_CATEGORY_LIST",DB_PROC,arrParams_H1,listLen_H1,Nothing)
			If IsArray(arrList_H1) Then
				For H1 = 0 To listLen_H1
					arrList_H1_strCateCode		= arrList_H1(1,H1)
					arrList_H1_strCateNameKor	= arrList_H1(2,H1)
		%>
		<li><a href="/shop/category.asp?cm=all&cate=<%=arrList_H1_strCateCode%>"><span><%=arrList_H1_strCateNameKor%></span></a>
			<%
				'중카테고리
				arrParams_H2 = Array(_
					Db.makeParam("@strNationCode",adVarChar,adParamInput,6,UCase(DK_MEMBER_NATIONCODE)), _
					Db.makeParam("@strCateParent",adVarChar,adParamInput,20,arrList_H1_strCateCode) _
				)
				arrList_H2 = Db.execRsList("DKP_SHOP_CATEGORY_LIST",DB_PROC,arrParams_H2,listLen_H2,Nothing)
				If IsArray(arrList_H2) Then
			%>
			<ol>
				<%
					For H2 = 0 To listLen_H2
						arrList_H2_strCateCode		= arrList_H2(1,H2)
						arrList_H2_strCateNameKor	= arrList_H2(2,H2)
				%>
				<li><a href="/shop/category.asp?cate=<%=arrList_H2_strCateCode%>"><span><%=arrList_H2_strCateNameKor%></span></a></li>
				<%Next%>
			</ol>
			<%End If%>
		</li>
		<%
				Next
			End If
		%>
	</ul>
</li>