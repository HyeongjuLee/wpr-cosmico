
		<script type="text/javascript" src="/jscript/jquery.shop.menu.js"></script>
		<div id="shopCategory" class="layout_inner">
			<div id="nav" class="nav">
				<%
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
				%>
				<ul>
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
									CATE_BG_CSS = " mainLi2"
									CATE_NM_CSS = "color:#fff"
								Else
									CATE_BG_CSS = ""
									CATE_NM_CSS = ""
								End If
					%>
					<!-- <li class="mainLi <%=CATE_BG_CSS%>"><a href="/shop/category.asp?cate=<%=arrList_H1_strCateCode%>"><span style="<%=CATE_NM_CSS%>"><%=arrList_H1_strCateNameKor%></span></a> -->
					<li class="mainLi <%=CATE_BG_CSS%>"><a href="javascript:chgGoodsIndex02('<%=arrList_H1_strCateCode%>')"><span style="<%=CATE_NM_CSS%>"><%=arrList_H1_strCateNameKor%></span></a>
					</li>
					<%
							Next
						End If
					%>
				</ul>
			</div>
		</div>
		<script type="text/javascript">
			<!-- //790
				$('#nav').d_navi2DLine({
					pageNum:null,            //메인메뉴 페이지인식 (1~)
					motionType:'slide',      //모션타입(none,fade,slide)
					motionSpeed:200,         //모션속도(1000=1초)
					lineSpeed:150            //상단라인속도(1000=1초)
				});
			//-->
		</script>