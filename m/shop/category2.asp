<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	Call FN_NationCurrency(DK_MEMBER_NATIONCODE,Chg_CurrencyName,Chg_CurrencyISO)

	PAGE_SETTING = "SHOP"



	CATEGORY		= gRequestTF("cate",False)
	Page			= Request("Page")
	Pagesize		= Request("Pagesize")
	'Pagesize		= 10

	'▣PushState (AJAX SUCCESS, detailView  Back) ==============================
	strUrlPath = houUrl&Request.ServerVariables("URL")
	PushState_TF	= gRequestTF("psh",False)
	If PushState_TF = "T" Then
		Page = 1
	End If
	If PushState_TF = "" Then PushState_TF = "F"

	psa				= Request("psa")				'AJAX에서 넘어온 PageSize
	If psa <> "" Then
		Pagesize = psa
		Set StrCipher = Server.CreateObject("Hoyasoft.StrCipher")
			Pagesize = Trim(StrCipher.Decrypt(Pagesize,EncTypeKey1,EncTypeKey2))
		Set StrCipher = Nothing
	End If
	'▣==========================================================================

	Dim tSEARCHTERM		:	tSEARCHTERM = pRequestTF("tSEARCHTERM",False)
	Dim tSEARCHSTR		:	tSEARCHSTR = pRequestTF("tSEARCHSTR",False)

	If tSEARCHTERM = ""	Then tSEARCHTERM = "" End If
	If tSEARCHSTR = ""	Then tSEARCHSTR = "" End if
	If PAGE = ""		Then PAGE = 1 End If

	Df_Pagesize = 10	'defalt			'▣PushState
	If Pagesize = ""	Then Pagesize = Df_Pagesize End If

	If minPrice = "" Then minPrice = ""
	If maxPrice = "" Then maxPrice = ""



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

	SUM_CATENAME = ""

	If CATEGORY <> "" Then

		'기능 확인
		SQL = "SELECT [isView],[isBest],[isVote],[isNew],[strCateName]"
		SQL = SQL & " FROM [DK_SHOP_CATEGORY] WHERE [strCateCode] = ? AND [strNationCode] = ? "
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
			DKRS_strCateName = DKRS("strCateName")
		Else
			DKRS_isView		= "F"
			DKRS_isBest		= "F"
			DKRS_isVote		= "F"
			DKRS_isNew		= "F"
		End If
		Call closeRS(DKRS)

		If DKRS_isView = "F" Then Call ALERTS(LNG_SHOP_CATEGORY_JS01,"BACK","")

		SUM_CATENAME = DKRS_strCateName

		If Len(CATEGORY) > 3 then
			'기능 확인
			SQL = "SELECT [isView],[isBest],[isVote],[isNew],[strCateName]"
			SQL = SQL & " FROM [DK_SHOP_CATEGORY] WHERE [strCateCode] = ? AND [strNationCode] = ? "
			arrParams = Array(_
				Db.makeParam("@strCateCode",adVarChar,adParamInput,20,CATEGORY), _
				Db.makeParam("@strNationCode",adVarChar,adParamInput,6,UCase(DK_MEMBER_NATIONCODE)) _
			)
			Set DKRS = Db.execRs(SQL,DB_TEXT,arrParams,Nothing)
			If Not DKRS.BOF And Not DKRS.EOF Then
				DKRS_isView			= DKRS("isView")
				DKRS_strCateName	= DKRS("strCateName")
			Else
				DKRS_isView		= "F"
			End If
			Call closeRS(DKRS)

			If DKRS_isView = "F" Then Call ALERTS(LNG_SHOP_CATEGORY_JS01,"BACK","")

			SUM_CATENAME = SUM_CATENAME &"&gt;"& DKRS_strCateName
		End If

		If Len(CATEGORY) > 6 then
			'기능 확인
			SQL = "SELECT [isView],[isBest],[isVote],[isNew],[strCateName]"
			SQL = SQL & " FROM [DK_SHOP_CATEGORY] WHERE [strCateCode] = ? AND [strNationCode] = ? "
			arrParams = Array(_
				Db.makeParam("@strCateCode",adVarChar,adParamInput,20,CATEGORY), _
				Db.makeParam("@strNationCode",adVarChar,adParamInput,6,UCase(DK_MEMBER_NATIONCODE)) _
			)
			Set DKRS = Db.execRs(SQL,DB_TEXT,arrParams,Nothing)
			If Not DKRS.BOF And Not DKRS.EOF Then
				DKRS_isView		= DKRS("isView")
				DKRS_strCateName= DKRS("strCateName")
			Else
				DKRS_isView		= "F"
			End If
			Call closeRS(DKRS)

			If DKRS_isView = "F" Then Call ALERTS(LNG_SHOP_CATEGORY_JS01,"BACK","")

			SUM_CATENAME = SUM_CATENAME &"&gt;"& DKRS_strCateName

		End If

	End If



%>
<!--#include virtual = "/m/_include/document.asp"-->
<!--#include virtual = "/m/_include/jqueryload.asp"-->
<script type="text/javascript">
<!--
	/*
	$(document).ready(function() {
		$('.index_v_goods').click(function(e) {				// = $('#btnArea input').on('click', function(e) {
			id = $(this).attr('id');				// 클릭한 버튼의(input) ID값
			document.location.hash = "#" + id;;		//hash값 이동
		});

	});
	*/
	function PrintNextGoods(pages) {
		$(".nextGoods").css({"display":"none"})
		$.ajax({
			type: "POST"
			,url: "category_goods_ajax.asp"
			,data : {
				 "CATEGORY" : "<%=CATEGORY%>"
				,"PAGESIZE" : "<%=PAGESIZE %>"
				,"PAGE" : pages
				,"tSEARCHSTR" : "<%=tSEARCHSTR%>"
				,"tSEARCHTERM" : "<%=tSEARCHTERM%>"
				,"PushState_TF"	: "<%=PushState_TF%>"			//PushState
				,"Df_Pagesize"	: "<%=Df_Pagesize%>"			//Df_Pagesize	'10
			}
			,error:function() {alert("<%=LNG_AJAX_ERROR_MSG%>");}
			,success: function(data) {
				var results = data.split("||");
				//$("#oGoods").append(data);
				$("#oGoods").append(results[0]);

				/* PushState */
				PageSize_AJAX = results[1]				//AJAX에서 넘어온 PageSize
				Page_AJAX	  = results[2]				//AJAX에서 넘어온 Page값
				//alert(Page_AJAX +"page, ~"+ PageSize_AJAX+"ea");

				$('.index_v_goods').click(function(e) {
					id = $(this).attr('id');			// 클릭한 버튼의(input) ID값
					//alert(id);

					<%If CATEGORY <> "" Then%>
						history.pushState("", "", "http://<%=strUrlPath%>?cate=<%=CATEGORY%>&psh=T&psa="+PageSize_AJAX);	//뒤로가기 push + cate
					<%Else%>
						history.pushState("", "", "http://<%=strUrlPath%>?psh=T&psa="+PageSize_AJAX);						//뒤로가기 push
						//history.pushState("", "", "https://<%=strUrlPath%>?psh=T&psa="+PageSize_AJAX+"#"+ id);				//뒤로가기 push + hash id
					<%End If%>

				});

			}
		});

	}

// -->
</script>
<style>
	.index_vote {clear:both;}

		.index_v_goods {width:100%; margin-top:10px; background-color:#fff; border-bottom:1px solid #ccc;}
		.goodsArea {border-bottom:1px solid #eee;}
		.sellPrice {font-size:20px; color:#222; font-weight:bold; line-height:20px; letter-spacing:-1px;}

		.PvPrice {font-size:15px; color:#d43f05; font-weight:bold; line-height:20px; letter-spacing:-1px;}

</style>
</head>
<body onUnload="">
<!--#include virtual = "/m/_include/header.asp"-->
<!--#include virtual = "/m/_include/sub_header.asp"-->
<div class="index_vote width100 cleft">
	<div class="cate_tit">식품</div>
	<div class="cate_list">
		<ul>
			<li class="on"><a href="#">쌀 / 혼합곡 / 잡곡</a></li>
			<li><a href="#">과일 / 견과류 / 건과일</a></li>
			<li><a href="#">채소 / 야채 / 나물류</a></li>
			<li><a href="#">소고기 / 돼지고기 / 가공육류</a></li>
			<li><a href="#">닭고기 / 오리고기 / 기타</a></li>
			<li><a href="#">생선 / 해산물 / 수산가공식품</a></li>
			<li><a href="#">건어물 / 김 / 해초류</a></li>
			<li><a href="#">김치 / 반찬류 / 기타 가공식품</a></li>
			<li><a href="#">된장 / 고추장 / 오일류 / 소스류</a></li>
			<li><a href="#">설탕 / 소금 / 조미료 / 양념</a></li>
			<li><a href="#">라면 / 면류 / 전분</a></li>
			<li><a href="#">업소용 식자재</a></li>
		</ul>
	</div>
	<p class="stit">쌀/혼합곡/잡곡</p>
	<div id="oGoods">

		<%
				arrParams = Array(_
					Db.makeParam("@CATEGORY",adVarChar,adParamInput,21,CATEGORY), _
					Db.makeParam("@PAGESIZE",adInteger,adParamInput,0,PAGESIZE),_
					Db.makeParam("@PAGE",adInteger,adParamInput,0,PAGE),_
					Db.makeParam("@tSEARCHSTR",adVarChar,adParamInput,30,tSEARCHSTR), _
					Db.makeParam("@tSEARCHTERM",adVarChar,adParamInput,30,tSEARCHTERM), _

					Db.makeParam("@isNOTS",adChar,adParamInput,1,PCONF_isNOTS), _
					Db.makeParam("@isAUTH",adChar,adParamInput,1,PCONF_isAUTH), _
					Db.makeParam("@isDEAL",adChar,adParamInput,1,PCONF_isDEAL), _
					Db.makeParam("@isVIPS",adChar,adParamInput,1,PCONF_isVIPS), _
					Db.makeParam("@isALLS",adChar,adParamInput,1,PCONF_isALLS), _
					Db.makeParam("@strNationCode",adVarChar,adParamInput,6,UCase(DK_MEMBER_NATIONCODE)), _

					Db.makeParam("@All_Count",adInteger,adParamOutput,0,0) _
				)
				arrList = Db.execRsList("DKPM_CATEGORY_GOODS_GLOBAL",DB_PROC,arrParams,listLen,Nothing)
			'	arrList = Db.execRsList("DKPM_CATEGORY_GOODS",DB_PROC,arrParams,listLen,Nothing)
			'	arrList = Db.execRsList("DKP_CATEGORY_GOODS_SEARCH_TOTAL",DB_PROC,arrParams,listLen,Nothing)
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
						arrList_intIDX					= arrList(1,i)
						arrList_GoodsName				= BACKWORD(arrList(2,i))
						arrList_GoodsComment			= BACKWORD(arrList(3,i))
						arrList_GoodsPrice				= arrList(4,i)
						arrList_GoodsCustomer			= arrList(5,i)
						arrList_GoodsCost				= arrList(6,i)
						arrList_GoodsModels				= arrList(7,i)
						arrList_GoodsBrand				= arrList(8,i)
						arrList_GoodsMaterial			= arrList(9,i)
						arrList_imgList					= BACKWORD(arrList(10,i))
						arrList_isCSGoods				= arrList(11,i)
						arrList_CSGoodsCode				= arrList(12,i)
						arrList_GoodsStockType			= arrList(13,i)
						arrList_GoodsPoint				= arrList(14,i)
						arrList_intPriceNot				= arrList(15,i)
						arrList_intPriceAuth			= arrList(16,i)
						arrList_intPriceDeal			= arrList(17,i)
						arrList_intPriceVIP				= arrList(18,i)
						arrList_intMinNot				= arrList(19,i)
						arrList_intMinAuth				= arrList(20,i)
						arrList_intMinDeal				= arrList(21,i)
						arrList_intMinVIP				= arrList(22,i)
						arrList_intPointNot				= arrList(23,i)
						arrList_intPointAuth			= arrList(24,i)
						arrList_intPointDeal			= arrList(25,i)
						arrList_intPointVIP				= arrList(26,i)
						arrList_isImgType				= arrList(27,i)

						arrList_GoodsDeliveryType		= arrList(28,i)
						arrList_GoodsDeliveryFee		= arrList(29,i)
						arrList_GoodsDeliveryLimit		= arrList(30,i)
						arrList_strShopID				= arrList(31,i)
						arrList_isShopType				= arrList(32,i)
						arrList_GoodsStockNum			= arrList(33,i)

						notPrice = arrList_intPriceNot

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

				'▣ 소비자 가격(2017-05-16)
				If DK_MEMBER_STYPE = "1" And arrList_isCSGoods = "T" Then
					arrList_GoodsPrice = arrList_GoodsCustomer
				End If

						' URL 이미지 링크
						If arrList_isImgType = "S" Then
							imgPath = VIR_PATH("goods/list")&"/"&arrList_imgList
							goodsImg = "<img src="""&imgPath&""" width=""100%"" height=""125"" alt="""" />"
						Else
							goodsImg = "<img src="""&backword(arrList_imgList)&""" width=""100%"" height=""125"" alt="""" />"
						End If

						If arrList_GoodsCost > 0 Then
							arrList_GoodsCost = num2cur(arrList_GoodsCost)
						Else
							arrList_GoodsCost = ""
						End If

						If arrList_GoodsStockType	= "S" Then
							Soldoutflag = viewImg(IMG_INDEX&"/soldout.png",40,50,"")
						Else
							Soldoutflag = ""
						End If

					stockOn = "<div class=""sellPrice""><span class=""va2px"">"&num2cur(arrList_GoodsPrice)&"</span><span class=""font_size08em""> "&Chg_CurrencyISO&"</span></div>"
					stockOff = "<div class=""sellPrice""><span class=""va2px"" style=""text-decoration:line-through"">"&num2cur(arrList_GoodsPrice)&"</span><span class=""font_size08em""> "&Chg_CurrencyISO&" <span class=""red"">("&LNG_SHOP_DETAILVIEW_33&")</span></span></div>"
					Select Case arrList_GoodsStockType
						Case "I"
							printGoodsPrice = stockOn
						Case "S"
							printGoodsPrice = stockOff
						Case "N"
							If arrList_GoodsStockNum > 0 Then
								printGoodsPrice = stockOn
							Else
								printGoodsPrice = stockOff
							End If
					End Select

		%>

			<div>
				<a href="/m/shop/detailView.asp?gidx=<%=arrList_intIDX%>">
					<div class="index_v_goods porel">
						<div class="porel goodsArea">
							<div class="poabs" style="width:125px; height:125px;"><%=goodsImg%></div>
							<div class="tleft tweight" style="position:absolute; width:100%; height:100%;left:0;top:0;color:#858585;"><%=i+1%></div>
							<div class="porel" style="margin-left:136px; height:125px;">
								<div style="padding-left:10px; padding-top:10px; ">
									<div style="width:100%; font-size:18px; color:#444; line-height:25px;" class="tweight text_noline"><%=arrList_goodsName%></div>
									<%If arrList_goodsComment <> "" Then%>
										<div style="width:95%; font-size:11px; color:#999; line-height:11px; margin-top:7px;" class="text_noline"><%=arrList_goodsComment%></div>
									<%Else%>
										<div class="text_noline noteLine">&nbsp;</div>
									<%End If%>


									<div class="porel" style="margin-top:20px; ">
										<%If arrList_GoodsPrice = arrList_GoodsCustomer Or arrList_GoodsPrice > arrList_GoodsCustomer Or arrList_GoodsCustomer = 0 Then%>
										<div class="fleft" style="mar gin-left:12px;">

										<%Else%>
										<!-- <div class="fleft"><span style="font-size:35px; color:#dd1500; font-weight:bold; line-height:35px; letter-spacing:-1px;">15</span><span   style="font-size:18px; color:#dd1500; font-weight:bold; line-height:18px; letter-spacing:-1px;">%</span></div> -->
										<div class="fleft" style="mar gin-left:12px;">
											<%If DK_MEMBER_LEVEL > 0 Then%>
											<div style="font-size:12px; color:#999; text-decoration:line-through; line-height:12px; letter-spacing:-1px;"><span style="vertical-align:-1px"><%=num2cur(arrList_GoodsCustomer)%></span>&nbsp;<%=Chg_CurrencyISO%></div>
											<%End If%>
										<%End If%>
											<%If DK_MEMBER_LEVEL > 0 Then%>
												<%=printGoodsPrice%>
											<%End If%>

											<%If (DK_MEMBER_TYPE = "COMPANY" And DK_MEMBER_STYPE = "0" And arrList_isCSGoods = "T") Or DK_MEMBER_TYPE = "ADMIN" Then%>
											<%
												arr_CS_price4 = 0
												'▣CS상품정보 변동정보 통합
												arrParams = Array(_
													Db.makeParam("@Na_Code",adVarChar,adParamInput,50,UCase(DK_MEMBER_NATIONCODE)), _
													Db.makeParam("@ncode",adVarChar,adParamInput,20,arrList_CSGoodsCode) _
												)
												Set DKRS = Db.execRs("HJP_CSGOODS_PRICE_INFO_GLOBAL",DB_PROC,arrParams,DB3)
												'Set DKRS = Db.execRs("HJP_CSGOODS_PRICE_INFO",DB_PROC,arrParams,DB3)
												If Not DKRS.BOF And Not DKRS.EOF Then
													arr_CS_ncode		= DKRS("ncode")
													arr_CS_price2		= DKRS("price2")
													arr_CS_price4		= DKRS("price4")
													arr_CS_price5		= DKRS("price5")
													arr_CS_price6		= DKRS("price6")
													arr_CS_SellCode		= DKRS("SellCode")
													arr_CS_SellTypeName	= DKRS("SellTypeName")
												Else
													arr_CS_SELLCODE		= ""
													arr_CS_SellTypeName = ""
												End If
												Call closeRs(DKRS)
											%>
											<div class="PvPrice">
												<!-- <span class="va2px"><%=CS_PV%> : <%=num2cur(arr_CS_price4)%></span> -->
												<!-- <%If arr_CS_SellTypeName <> "" Then%>
												 / <span class="va2px" style="color:green;font-size:13px;"><%=arr_CS_SellTypeName%></span>
												 <%End If%> -->
											</div>
											<%End If%>
										</div>
									</div>
								</div>
							</div>
						</div>
						<%'If DK_MEMBER_LEVEL  >0 Then%>
						<div class="porel" style="padding:7px 0px;">
							<div style="line-height:25px;padding-left:10px;">
								<!--
								<%If arrList_GoodsDeliveryType = "SINGLE" Then%><span class="tweight"><%=num2cur(arrList_GoodsDeliveryFee)%></span> 원 (묶음배송 안됨)<%End If%>
								<%If arrList_GoodsDeliveryType = "AFREE" Then%><span class="delivery">무료배송</span><%End If%> -->
								<%If arrList_GoodsDeliveryType = "SINGLE" Then%><span class="tweight"><%=num2cur(arrList_GoodsDeliveryFee)%></span> <%=Chg_CurrencyISO%>&nbsp;<%=LNG_SHOP_DETAILVIEW_19%><%End If%>
								<%If arrList_GoodsDeliveryType = "AFREE" Then%><span class="delivery"><%=LNG_SHOP_DETAILVIEW_20%></span><%End If%>
								<%
									If arrList_GoodsDeliveryType = "BASIC" Then
										arrParams2 = Array(_
											Db.makeParam("@strShopID",adVarChar,adParamInput,30,arrList_strShopID) _
										)
										Set DKRS2 = DB.execRs("DKP_DELIVERY_FEE_VIEW",DB_PROC,arrParams2,Nothing) 'DKPA_DELIVEY_FEE_VIEW
										If Not DKRS2.BOF And Not DKRS2.EOF Then
											DKRS2_FeeType			= DKRS2("FeeType")
											DKRS2_intFee			= DKRS2("intFee")
											DKRS2_intLimit			= DKRS2("intLimit")

											'PRINT printDeli(DKRS2_FeeType)

											Select Case LCase(DKRS2_FeeType)
												Case "free"
								%>
								<span class="delivery"><%=LNG_STRTEXT_TEXT19_3%></span>

								<%
												Case "prev"
								%>
								<!--
								<span style="background-color:#f2f2f2; padding:4px 6px; letter-spacing:-1px;">선불결제 <%=num2cur(DKRS2_intFee)%> 원</span>
								<span class="deliType"><%=num2cur(DKRS2_intLimit)%> 이상 무료</span> -->
								<span style="background-color:#f2f2f2; padding:4px 6px; letter-spacing:-1px;"><%=LNG_STRTEXT_TEXT19_2%>&nbsp;<%=num2cur(DKRS2_intFee)%>&nbsp;<%=Chg_CurrencyISO%></span>
								<span class="deliType"><%=LNG_SHOP_DETAILVIEW_21&num2cur(DKRS2_intLimit) &" "&Chg_CurrencyISO%></span>
								<%
												Case "next"
								%>
								<!--
								<span style="background-color:#eee; padding:4px 6px; letter-spacing:-1px;">착불결제 <%=num2cur(DKRS2_intFee)%> 원</span>
								<span class="deliType"><%=num2cur(DKRS2_intLimit)%> 이상 무료</span> -->
								<span style="background-color:#eee; padding:4px 6px; letter-spacing:-1px;"><%=LNG_STRTEXT_TEXT19_1%>&nbsp;<%=num2cur(DKRS2_intFee)%>&nbsp;<%=Chg_CurrencyISO%></span>
								<span class="deliType"><%=LNG_SHOP_DETAILVIEW_21&num2cur(DKRS2_intLimit) &" "&Chg_CurrencyISO%></span>
								<%
											End Select



										Else
											'Response.Write "(기본배송비정책이 입력되지 않았습니다)"
											Response.Write LNG_SHOP_DETAILVIEW_22
										End If
										Call closeRS(DKRS2)

									End If
								%>



								<!--<span style="width:70px; background-color:#d41400; padding:4px 6px; letter-spacing:-1px; color:#fff; margin-left:7px;"><%=LNG_STRTEXT_TEXT19_3%></span>
								<span style="margin-top:12px; letter-spacing:-1px;">50,000원 이상</span>

								<span style="background-color:#eee; padding:4px 6px; letter-spacing:-1px;">선불배송</span><br />
								<span style="background-color:#eee; padding:4px 6px; letter-spacing:-1px;">후불배송</span><br />
								<span style="background-color:#eee; padding:4px 6px; letter-spacing:-1px;">조건부무료</span><br /> -->
							</div>
						</div>
						<%'End If%>
					</div>
				</a>
			</div>
		<%
			Next
					If CDbl(ALL_COUNT) > CDbl(PAGESIZE) Then

						PAGE_ORI = 2
						'▣PushState
						If PushState_TF = "T" Then
							PAGE_ORI = (PAGESIZE / Df_Pagesize) + 1
						End If
		%>
			<!-- <a href="javascript:PrintNextGoods('2');" class="nextGoods">다음 <%=PAGESIZE%> 개 상품보기</a> -->
			<a href="javascript:PrintNextGoods('<%=PAGE_ORI%>');" class="nextGoods"><%=LNG_SHOP_COMMON_MORE%></a>
		<%
					End If

		Else

		%>
			<div class="tweight tcenter" style="background-color:#fff; padding:120px 0px;font-size:16px; line-height:25px;"><%=LNG_SHOP_NOT_DATA_TXT_01%></div>
		<%

		End If
	%>

	</div>

</div>




<!--#include virtual = "/m/_include/copyright.asp"-->