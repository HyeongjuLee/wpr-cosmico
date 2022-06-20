<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	PAGE_SETTING = "SHOP"

	Call FN_NationCurrency(DK_MEMBER_NATIONCODE,Chg_CurrencyName,Chg_CurrencyISO)


	CATEGORY		= gRequestTF("cate",False)
	CATE_MODE		= gRequestTF("cm",False)

	If CATE_MODE = "" Then CATE_MODE = "all"			'●카테고리 기본페이지


	'============================================================
	'#1 POST
 	Dim CATE_MODE1		:	CATE_MODE1 = pRequestTF("cm1",False)

	'#POST값 있는경우 CATE_MODE 치환
	If CATE_MODE1 <> "" Then CATE_MODE = CATE_MODE1
	'============================================================
	CATE_MODE_ORI	= CATE_MODE


	Page			= Request("Page")
	Pagesize		= 20
	Dim tSEARCHTERM		:	tSEARCHTERM = pRequestTF("tSEARCHTERM",False)
	Dim tSEARCHSTR		:	tSEARCHSTR = pRequestTF("tSEARCHSTR",False)
	Dim minPrice		:	minPrice = pRequestTF("minPrice",False)
	Dim maxPrice		:	maxPrice = pRequestTF("maxPrice",False)

	If tSEARCHTERM = ""	Then tSEARCHTERM = "" End If
	If tSEARCHSTR = ""	Then tSEARCHSTR = "" End if
	If PAGE = ""		Then PAGE = 1 End If

	If minPrice = "" Then minPrice = ""
	If maxPrice = "" Then maxPrice = ""



	''PCONF_TOPCNT = 4 '페이지 사이즈에 맞춘 상품 나열 갯수 하단의 PCONF_LINECNT 의 제곱으로 나가야함
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

	Select Case UCase(CATE_MODE)
		Case "BA"	'베스트
			GOODS_SEARCH_TOTAL_PROC = "HJSP_CATEGORY_GOODS_SEARCH_TOTAL_BVNE"		'상품리스트 (flag)
			PCONF_isBest = "T"
		Case "NA"	'신상품
			GOODS_SEARCH_TOTAL_PROC = "HJSP_CATEGORY_GOODS_SEARCH_TOTAL_BVNE"		'상품리스트 (flag)
			PCONF_isNew = "T"

		Case "EA"	'이벤트
			GOODS_SEARCH_TOTAL_PROC = "HJSP_CATEGORY_GOODS_SEARCH_TOTAL_BVNE"		'상품리스트 (flag)
			PCONF_isEvent = "T"

	End Select


%>
<%
	'==============================================================================
		'카테고리 검색기능(POST + GET)
		'#1 POST
		Dim CATEGORYS1		:	CATEGORYS1 = pRequestTF("cate1",False)
		Dim CATEGORYS2		:	CATEGORYS2 = pRequestTF("cate2",False)
		Dim CATEGORYS3		:	CATEGORYS3 = pRequestTF("cate3",False)

			'#2 GET
			If Len(CATEGORY) = 3 Then
				CATEGORYS1 = CATEGORY
			End If
			If Len(CATEGORY) = 6 Then
				CATEGORYS1 = Left(CATEGORY,3)
				CATEGORYS2 = CATEGORY
			End If
			If Len(CATEGORY) = 9 Then
				CATEGORYS1 = Left(CATEGORY,3)
				CATEGORYS2 = Left(CATEGORY,6)
				CATEGORYS3 = CATEGORY
			End If

		'#3 POST
		If CATEGORYS1 <> "" Then CATEGORY = CATEGORYS1
		If CATEGORYS2 <> "" Then CATEGORY = CATEGORYS2
		If CATEGORYS3 <> "" Then CATEGORY = CATEGORYS3
		If CATEGORYS1 = "" Then	CATEGORY = ""

	'	Call ResRW(CATEGORY,"CATEGORY")
	'	Call ResRW(CATEGORYS1,"CATEGORYS1")
	'	Call ResRW(CATEGORYS2,"CATEGORYS2")
	'	Call ResRW(CATEGORYS3,"CATEGORYS3")
	'============================================================================
%>
<%
	'▣1차 카테고리 이름 & view(타게팅) for header_shop.asp, left_shop.asp ==================================================================================
	SQL_CATE = "SELECT [strCateName],[intCateSort] FROM [DK_SHOP_CATEGORY] WHERE [strCateCode] = ? AND [strNationCode] = ? "
	subParams = Array(_
		Db.makeParam("@subCateParent",adVarChar,adParamInput,20,Left(CATEGORY,3)) ,_
		Db.makeParam("@strNationCode",adVarChar,adParamInput,6,UCase(DK_MEMBER_NATIONCODE)) _
	)
	Set HJRS_CATE = Db.execRs(SQL_CATE,DB_TEXT,subParams,Nothing)
	If Not HJRS_CATE.BOF And Not HJRS_CATE.EOF Then
		HJRS_CATE_strCateName = HJRS_CATE("strCateName")	'1차 카테고리 이름
	Else
		HJRS_CATE_strCateName = ""
	End If
	Call CloseRS(HJRS_CATE)

	SUM_CATENAME = ""

	If tSEARCHSTR <> "" Then
		SUM_CATENAME = "<span style=""color:#F64D00"">'"&tSEARCHSTR&"'</span>&nbsp;&nbsp;<span style=""font-size:17px;"">검색 결과</span>"
	Else
		If CATEGORY <> "" Then
		'기능 확인
			SQL = "SELECT [isView],[isBest],[isVote],[isNew]"
			SQL = SQL & " FROM [DK_SHOP_CATEGORY] WHERE [strCateCode] = ? AND [strNationCode] = ?"
			arrParams = Array(_
				Db.makeParam("@strCateCode",adVarChar,adParamInput,20,CATEGORY), _
				Db.makeParam("@strNationCode",adVarChar,adParamInput,6,UCase(DK_MEMBER_NATIONCODE)) _
			)
			Set DKRS = Db.execRs(SQL,DB_TEXT,arrParams,Nothing)
			If Not DKRS.BOF And Not DKRS.EOF Then
				DKRS_isView		= DKRS("isView")
				DKRS_isBest		= DKRS("isBest")
				DKRS_isVote		= DKRS("isVote")
				DKRS_isNew		= DKRS("isNew")
			Else
				DKRS_isView		= "F"
				DKRS_isBest		= "F"
				DKRS_isVote		= "F"
				DKRS_isNew		= "F"
			End If

			If DKRS_isView = "F" Then Call ALERTS(LNG_SHOP_CATEGORY_JS01,"BACK","")

		End If

		Select Case SHOP_ORDER_PAGE_TYPE
			Case "DETAIL"
				SUM_CATENAME = DKRS_GoodsName
			Case "CART"
				SUM_CATENAME = LNG_MYPAGE_03
			Case "ORDER"
				SUM_CATENAME = LNG_SHOP_CART_TXT_06
			Case "WISHLIST"
				SUM_CATENAME = LNG_MYPAGE_02
			Case "FINISH"
				SUM_CATENAME = LNG_SHOP_ORDER_FINISH_04
			Case Else

				Select Case UCase(CATE_MODE)
					Case "BA"
						If CATEGORY = "" Then
							SUM_CATENAME = "베스트"
						Else
							SUM_CATENAME = "베스트 - <span style=""font-size:20px;"">"&HJRS_CATE_strCateName&"</span>"
						End If
					Case "NA"
						If CATEGORY = "" Then
							SUM_CATENAME = "신상품"
						Else
							SUM_CATENAME = "신상품 - <span style=""font-size:20px;"">"&HJRS_CATE_strCateName&"</span>"
						End If

					Case "EA"
						If CATEGORY = "" Then
							SUM_CATENAME = "기획전"
						Else
							SUM_CATENAME = "기획전 - <span style=""font-size:20px;"">"&HJRS_CATE_strCateName&"</span>"
						End If

					Case Else
						SUM_CATENAME =  HJRS_CATE_strCateName
				End Select


		End Select

	End If


	If CATEGORY = ""  And CATE_MODE = "all" Then SUM_CATENAME = "전체상품보기"

%>
<!--#include virtual = "/m/_include/document.asp"-->
<!--#include virtual = "/m/_include/jqueryload.asp"-->
<!-- <link rel="stylesheet" href="/m/css/index.css" /> -->
<link rel="stylesheet" href="/m/css/category.css?v1" />
<link rel="stylesheet" href="/m/css/shopN.css">
<script type="text/javascript">
<!--

	function check_frm(){
		<%if DK_MEMBER_LEVEL < 1 THEN%>
			 var msg = "<%=LNG_SHOP_DETAILVIEW_10%>";
			 if(confirm(msg)){
				document.location.href="/m/common/member_login.asp?backURL=<%=ThisPageURL%>";
				return;
			 }else{
				return;
			 }
		<%END IF%>
	}

	$(document).ready(function(){
		$('#cate1').change(function(){chg_category('category2');}).change();
		$('#cate2').change(function(){chg_category('category3');});
	});
	function chg_category(mode) {
		//mode = "category2";
		var cate
		var cateVal
		var cateID
		if (mode == 'category2')
		{
			cate = $('#cate1').val();
			cateVal = '<%=CATEGORYS2%>'
			cateID = '#cate2'
		} else if (mode == 'category3')
		{
			cate = $('#cate2').val();
			cateVal = '<%=CATEGORYS3%>'
			cateID = '#cate3'
		}
		//alert(mode);
		if (cate.length == 0)
		{
			$(cateID).attr("disabled",true);
			$(cateID).html("<option value=''>--</option>");
		} else {
			$.ajax({
				type: "POST"
				,url: "/shop/Category_d2.asp"
				,data: {
					 "mode"				: mode
					,"cate"				: cate
					,"strNationCode"	: '<%=UCASE(DK_MEMBER_NATIONCODE)%>'
				}
				,success: function(data) {
					var FormErrorChk = data.split(",");
					if (FormErrorChk[0] == "FORMERROR")
					{
						alert("필수값:"+FormErrorChk[1]+"가 넘어오지 않았습니다.\n다시 시도해주세요");
						//loadings();
					} else {
						$(cateID).attr("disabled",false);
						$(cateID).html(data);
						//console.log(data);
						//console.log(cateVal);
						if (cateVal != ''){$(cateID).val(cateVal);};

						$(cateID).change();
					}
				}
				,error:function(data) {
					//loadings();
					//alert("ajax 처리 중 에러가 발생하였습니다.ERROR CODE : "+data.status+" "+data.statusText+" "+data.responseText);
				}
			});

		}
	}
// -->
</script>

</head>
<body onUnload="">
<!--#include virtual = "/m/_include/header.asp"-->
<!--#include virtual = "/m/_include/sub_header.asp"-->
<div id="index" class="porel category">
	<div id="cateName" class="tcenter">&nbsp;<%=SUM_CATENAME%></div>
	<%'쇼핑몰 카테고리%>
	<div style="width:95%;margin:0 auto;">
		<div class="shop_depth_cate">
			<form name="searchform" action="category.asp" method="post">
				<input type="hidden" name="tSEARCHTERM" value="<%=tSEARCHTERM%>" />
				<input type="hidden" name="tSEARCHSTR" value="<%=tSEARCHSTR%>" />
				<input type="hidden" name="cm1" value="<%=CATE_MODE_ORI%>" />
				<table <%=tableatt%> class="width100">
					<colgroup>
						<col width="" />
						<col width="55" />
					</colgroup>
					<tbody>
						<tr>
							<td class="tleft" style="padding-left:2px;" >
								<div class="fleft">
									<div class="fleft" style="padding:2px 2px;">
										<select id="cate1" name="cate1" class="select"  >
											<option value="">전체</option>
											<%
												SQL = "SELECT [intIDX],[strCateCode],[strCateName],[strCateParent]"
												SQL = SQL & " FROM [DK_SHOP_CATEGORY] WHERE [strCateParent] = ? AND [strNationCode] = ? AND [isView] = 'T' ORDER BY [intCateSort] ASC "
												arrParams1C = Array(_
													Db.makeParam("@strCateParent",adVarChar,adParamInput,20,"000"), _
													Db.makeParam("@strNationCode",adVarChar,adParamInput,6,UCase(DK_MEMBER_NATIONCODE)) _
												)
												arrList1C = Db.execRsList(SQL,DB_TEXT,arrParams1C,listLen1C,Nothing)
												If Not IsArray(arrList1C) Then
													PRINT "<option value="""">메뉴가 없습니다.</option>"
												Else
													For j = 0 To listLen1C
														arrList1C_intIDX			= arrList1C(0,j)
														arrList1C_strCateCode		= arrList1C(1,j)
														arrList1C_strCateName		= arrList1C(2,j)
														arrList1C_strCateParent		= arrList1C(3,j)

														PRINT "<option value="""&arrList1C_strCateCode&""" "&isSelect(CATEGORYS1,arrList1C_strCateCode)&">"&arrList1C_strCateName&"</option>"
													Next
												End If
											%>
										</select>
									</div>
									<%
										'▣쇼핑몰 2차카테고리 CNT
									'	SQL_SUB2 = "SELECT COUNT([intIDX]) FROM [DK_SHOP_CATEGORY] WHERE [strCateParent] = ? AND [strNationCode] = ? AND [isView] = 'T' "
									'	arrParams_H = Array(_
									'		Db.makeParam("@strCateCode",adVarChar,adParamInput,20,Left(CATEGORY,3)), _
									'		Db.makeParam("@strNationCode",adVarChar,adParamInput,6,UCase(DK_MEMBER_NATIONCODE)) _
									'	)
									'	CATEGORY_SUB2_CNT = Db.execRsData(SQL_SUB2,DB_TEXT,arrParams_H,Nothing)
									'	If CATEGORY_SUB2_CNT > 0 Then
									%>
									<div class="fleft" style="padding:2px 2px;">
										<select name="cate2" id="cate2" class="select" disabled="disabled">
											<option value="">전체<!-- 상위 카테고리를 선택해주세요. --></option>
										</select>
									</div>
									<%
									'	End If
									%>
									<%
										'▣쇼핑몰 3차카테고리 CNT
										SQL_SUB3 = "SELECT COUNT([intIDX]) FROM [DK_SHOP_CATEGORY] WHERE [isView] = 'T' AND [intCateDepth] = 3 AND [strCateParent] = ? AND [strNationCode] = ? "
										arrParams_H3 = Array(_
											Db.makeParam("@strCateCode",adVarChar,adParamInput,20,Left(CATEGORY,6)), _
											Db.makeParam("@strNationCode",adVarChar,adParamInput,6,UCase(DK_MEMBER_NATIONCODE)) _
										)
										CATEGORY_SUB3_CNT = Db.execRsData(SQL_SUB3,DB_TEXT,arrParams_H3,Nothing)

										'print CATEGORY_SUB3_CNT
										If CATEGORY_SUB3_CNT > 0 Then
									%>
									<div class="fleft" style="padding:2px 2px;">
										<select name="cate3" id="cate3" class="select" disabled="disabled" >
											<option value=""><!-- 전체 --><!-- 상위 카테고리를 선택해주세요.2 --></option>
										</select>
									</div>
									<%
										End If
									%>
								</div>
							</td>
							<td class="fright" style="padding-top:2px;">
								<input type="submit" class="txtBtn s_medium vtop" value="검색"/>
							</td>
						</tr>

					</tbody>
				</table>
			</form>
		</div>
	</div>

	<!-- GOODS LIST START -->
		<div id="goodsArea">
			<div class="goodsAreaW">
				<div class="goods_wrap">
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
						'arrList = Db.execRsList("HJSP_CATEGORY_GOODS_SEARCH_TOTAL",DB_PROC,arrParams,listLen,Nothing)
						All_Count = arrParams(UBound(arrParams))(4)

						Dim PAGECOUNT,CNT
						PAGECOUNT = int((ccur(All_Count) - 1 ) / CInt(PAGESIZE) ) + 1
						IF CCur(PAGE) = 1 Then
							CNT = All_Count
						Else
							CNT = All_Count - ((CCur(PAGE)-1)*CInt(PAGESIZE)) '
						End If

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
								arrList_OptionVal			= arrList(28,i)
								arrList_isShopType			= arrList(29,i)
								arrList_strShopID			= arrList(30,i)
								arrList_strShopID			= arrList(30,i)
								arrList_intCSPrice4			= arrList(31,i)
								arrList_intCSPrice5			= arrList(32,i)
								arrList_intCSPrice6			= arrList(33,i)
								arrList_intCSPrice7			= arrList(34,i)
								arrList_flagBest			= arrList(35,i)
								arrList_flagNew				= arrList(36,i)
								arrList_flagVote			= arrList(37,i)

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

								If arrList_isCSGoods = "T" Then
									'▣CS상품정보 변동정보 통합
									arrParams = Array(_
										Db.makeParam("@ncode",adVarChar,adParamInput,20,arrList_CSGoodsCode) _
									)
									Set DKRS = Db.execRs("HJP_CSGOODS_PRICE_INFO",DB_PROC,arrParams,DB3)
									If Not DKRS.BOF And Not DKRS.EOF Then
										RS_ncode		= DKRS("ncode")
										RS_price2		= DKRS("price2")
										RS_price4		= DKRS("price4")
										RS_price5		= DKRS("price5")
										RS_price6		= DKRS("price6")
										RS_SellCode		= DKRS("SellCode")
										RS_SellTypeName	= DKRS("SellTypeName")
									End If
									Call closeRs(DKRS)
								End If

								' URL 이미지 링크
								If arrList_isImgType = "S" Then
									imgPath = VIR_PATH("goods/list")&"/"&arrList_imgList
									goodsImg = "<img src="""&imgPath&""" alt="""" >"
								Else
									goodsImg = "<img src="""&backword(arrList_imgList)&""" alt="""" />"
								End If

					%>
					<div class="goodsSeperate">
						<div class="img">
							<%If DK_MEMBER_LEVEL > 0 Then%>
								<a href="/m/shop/detailView.asp?gidx=<%=arrList_intIDX%>"><%=goodsImg%></a>
							<%Else%>
								<a href="javascript: check_frm();"><%=goodsImg%></a>
							<%End If %>
						</div>
						<div class="textArea fleft" >
							<%'If DK_MEMBER_LEVEL > 0 Then%>
							<%
								If notPrice < arrList_GoodsCustomer Then
									DisCountPercent = 100 - Round((notPrice/arrList_GoodsCustomer) * 100)
							%>
							<!-- <div class="sale">
								<span><%=DisCountPercent%></span>%
							</div> -->
							<%	End If %>
							<%'End If %>
							<div class="text_noline goodsName"><%=arrList_goodsName%>asdfasdf<br></div>
							<div class="text_noline comment fleft"><%=arrList_GoodsComment%></div>
							 <div class="price">
								<table <%=tableatt%> class="width100 gT able" style="width:100%;">
									<col width="" />
									<col width="" />
									<%Select Case DK_MEMBER_STYPE%>
									<%	Case 0, 9 %>
										<tr>
											<td class="price1 fleft"><span><%=num2cur(arrList_GoodsCustomer)%></span><%=Chg_CurrencyISO%></td>
										</tr>
										<tr>
											<td class="price2 fleft"><span><%=num2cur(notPrice)%></span><%=Chg_CurrencyISO%></td>
										</tr>
										<%If RS_price4 <> "" Then %>
										<div class="pv"><%=num2cur(RS_price4)%> <%=CS_PV%></div>
										<%End If%>
									<%	Case 1 %>
										<%If CONST_CS_SOBIJA_PRICE_USE_TF = "T" Then	'소비자회원 소비자가%>
											<tr>
												<td class="price2 fleft"><span><%=num2cur(arrList_GoodsCustomer)%></span><%=Chg_CurrencyISO%></td>
											</tr>
										<%Else%>
											<tr>
												<td class="price1 fleft"><span><%=num2cur(arrList_GoodsCustomer)%></span><%=Chg_CurrencyISO%></td>
											</tr>
											<tr>
												<td class="price2 fleft"><span><%=num2cur(notPrice)%></span><%=Chg_CurrencyISO%></td>
											</tr>
										<%End If%>
									<%End Select%>
								</table>
								<%If DK_MEMBER_STYPE = "0" Then%>
								<div class="pv"><%=num2cur(RS_price4)%><%=CS_PV%></div>
								<%End If%>
							</div>

						</div>

					</div>

					<%
							Next
						Else
					%>

					<%
						End If
					%>
				</div>
			</div>
		</div>


	<!-- GOODS LIST END -->

	<form name="frm" method="post" action="">
		<input type="hidden" name="PAGESIZE" value="<%=PAGESIZE%>" />
		<input type="hidden" name="PAGE" value="<%=PAGE%>" />
		<input type="hidden" name="tSEARCHTERM" value="<%=tSEARCHTERM%>" />
		<input type="hidden" name="tSEARCHSTR" value="<%=tSEARCHSTR%>" />
		<input type="hidden" name="minPrice" value="<%=minPrice%>" />
		<input type="hidden" name="maxPrice" value="<%=maxPrice%>" />
		<input type="hidden" name="cate1" value="<%=CATEGORYS1%>" />
		<input type="hidden" name="cate2" value="<%=CATEGORYS2%>" />
		<input type="hidden" name="cate3" value="<%=CATEGORYS3%>" />
		<input type="hidden" name="cate" value="<%=CATEGORY%>" />
		<input type="hidden" name="cm" value="<%=CATE_MODE%>" />
	</form>

</div>

<!--#include virtual = "/m/_include/copyright.asp"-->