
	<%
		'메타21 2022-03-25

		SQL_H2 = "SELECT [intCateSort] FROM [DK_SHOP_CATEGORY]"
		SQL_H2 = SQL_H2 & " WHERE [intCateDepth] = 1 AND [isView] = 'T' AND [strCateCode] = ? AND [strNationCode] = ? ORDER BY [intCateSort] ASC"
		arrParams_H2 = Array(_
			Db.makeParam("@CATEGORY",adVarChar,adParamInput,3,Left(CATEGORY,3)), _
			Db.makeParam("@strNationCode",adVarChar,adParamInput,6,UCase(DK_MEMBER_NATIONCODE)) _
		)
		Set HJRS = Db.execRs(SQL_H2,DB_TEXT,arrParams_H2,nothing)
		If Not HJRS.BOF And Not HJRS.EOF Then
			HJRS_intCateSort = HJRS(0)
		Else
			HJRS_intCateSort = 0
		End If
		Call CloseRS(HJRS)

		If CATEGORY = "ALL" Or CATEGORY = "" Then
			CATE_CLASS_ALL = " on"
		Else
			CATE_CLASS_ALL = ""
		End If
	%>
	<div class="tab_wrap">
		<ul>
			<li class="<%=CATE_CLASS_ALL%>"><a href="javascript: chgGoodsIndex('ALL')"><span>ALL</span></a></li>
			<%
				arrParams_H1 = Array(_
					Db.makeParam("@strNationCode",adVarChar,adParamInput,6,UCase(DK_MEMBER_NATIONCODE)) _
				)
				arrList_H1 = Db.execRsList("DKSP_SHOP_CATEGORY_1DEPTH",DB_PROC,arrParams_H1,listLen_H1,Nothing)
				If IsArray(arrList_H1) Then
					For H1 = 0 To listLen_H1
						arrList_H1_strCateCode		= arrList_H1(1,H1)
						arrList_H1_strCateNameKor	= arrList_H1(2,H1)

						If H1 = listLen_H1 Then
							ulClass ="subUL subUL_last"
						Else
							ulClass ="subUL"
						End If

						If HJRS_intCateSort = H1+1 Then
							CATE_CLASS = " on"
						Else
							CATE_CLASS = ""
						End If
			%>
			<li class="<%=CATE_CLASS%>"><a href="javascript: chgGoodsIndex('<%=arrList_H1_strCateCode%>')"><span><%=arrList_H1_strCateNameKor%></span></a></li>
			<%
					Next
				End If
			%>
		</ul>
	</div>

