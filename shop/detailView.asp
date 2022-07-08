<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	PAGE_SETTING = "SHOP"
	ISSUBPADDING = "F"
	ISLEFT = "F"
	ISSUBTOP = "T"
	ISSUBVISUAL = "T"

	Call ONLY_BUSINESS_MEMBER(DK_MEMBER_LEVEL,1)

	GoodsIDX = gRequestTF("gIDX",True)


	arrParams = Array(_
		Db.makeParam("@intIDX",adInteger,adParamInput,0,GoodsIDX) _
	)
'	Set DKRS = Db.execRs("DKP_GOODS_DETAILVIEW_E",DB_PROC,arrParams,Nothing)		'자체상품
	Set DKRS = Db.execRs("DKP_GOODS_DETAILVIEW",DB_PROC,arrParams,Nothing)
	If Not DKRS.BOF And Not DKRS.EOF Then
		DKRS_intIDX						= DKRS("intIDX")
		DKRS_Category					= DKRS("Category")
		DKRS_DelTF						= DKRS("DelTF")
		DKRS_GoodsType					= DKRS("GoodsType")
		DKRS_GoodsName					= DKRS("GoodsName")
		DKRS_GoodsComment				= DKRS("GoodsComment")
		DKRS_GoodsSearch				= DKRS("GoodsSearch")
		DKRS_GoodsPrice					= DKRS("GoodsPrice")
		DKRS_GoodsCustomer				= DKRS("GoodsCustomer")
		DKRS_GoodsCost					= DKRS("GoodsCost")
		DKRS_GoodsStockType				= DKRS("GoodsStockType")
		DKRS_GoodsStockNum				= DKRS("GoodsStockNum")
		DKRS_GoodsPoint					= DKRS("GoodsPoint")
		DKRS_GoodsMade					= DKRS("GoodsMade")
		DKRS_GoodsProduct				= DKRS("GoodsProduct")
		DKRS_GoodsBrand					= DKRS("GoodsBrand")
		DKRS_GoodsModels				= DKRS("GoodsModels")
		DKRS_GoodsDate					= DKRS("GoodsDate")
		DKRS_GoodsViewTF				= DKRS("GoodsViewTF")
		DKRS_flagBest					= DKRS("flagBest")
		DKRS_flagNew					= DKRS("flagNew")
		DKRS_FlagVote					= DKRS("FlagVote")
		DKRS_GoodsContent				= DKRS("GoodsContent")
		DKRS_GoodsDeliveryType			= DKRS("GoodsDeliveryType")
		DKRS_GoodsDeliveryFee			= DKRS("GoodsDeliveryFee")
		DKRS_GoodsDeliveryLimit			= DKRS("GoodsDeliveryLimit")
		DKRS_GoodsDeliPolicyType		= DKRS("GoodsDeliPolicyType")
		DKRS_GoodsDeliPolicy			= DKRS("GoodsDeliPolicy")
		DKRS_ClickCnt					= DKRS("ClickCnt")
		DKRS_RegID						= DKRS("RegID")
		DKRS_RegDate					= DKRS("RegDate")
		DKRS_RegHost					= DKRS("RegHost")
		DKRS_OptionVal					= DKRS("OptionVal")
		DKRS_GoodsBanner				= DKRS("GoodsBanner")
		DKRS_GoodsNote					= DKRS("GoodsNote")
		DKRS_GoodsNoteColor				= DKRS("GoodsNoteColor")
		DKRS_isCSGoods					= DKRS("isCSGoods")
		DKRS_CSGoodsCode				= DKRS("CSGoodsCode")
		DKRS_intSort					= DKRS("intSort")
		DKRS_flagMain					= DKRS("flagMain")
		DKRS_GoodsMaterial				= DKRS("GoodsMaterial")
		DKRS_GoodsCarton				= DKRS("GoodsCarton")
		DKRS_GoodsSize					= DKRS("GoodsSize")
		DKRS_GoodsColor					= DKRS("GoodsColor")
		DKRS_isShopType					= DKRS("isShopType")
		DKRS_strShopID					= DKRS("strShopID")
		DKRS_isAccept					= DKRS("isAccept")
		DKRS_Img1Ori					= DKRS("Img1Ori")
		DKRS_Img2Ori					= DKRS("Img2Ori")
		DKRS_Img3Ori					= DKRS("Img3Ori")
		DKRS_Img4Ori					= DKRS("Img4Ori")
		DKRS_Img5Ori					= DKRS("Img5Ori")
		DKRS_ImgList					= DKRS("ImgList")
		DKRS_ImgThum					= DKRS("ImgThum")
		DKRS_ImgRelation				= DKRS("ImgRelation")
		DKRS_ImgBanner					= DKRS("ImgBanner")
		DKRS_isViewMemberNot			= DKRS("isViewMemberNot")
		DKRS_isViewMemberAuth			= DKRS("isViewMemberAuth")
		DKRS_isViewMemberDeal			= DKRS("isViewMemberDeal")
		DKRS_isViewMemberVIP			= DKRS("isViewMemberVIP")
		DKRS_intPriceNot				= DKRS("intPriceNot")
		DKRS_intPriceAuth				= DKRS("intPriceAuth")
		DKRS_intPriceDeal				= DKRS("intPriceDeal")
		DKRS_intPriceVIP				= DKRS("intPriceVIP")
		DKRS_intMinNot					= DKRS("intMinNot")
		DKRS_intMinAuth					= DKRS("intMinAuth")
		DKRS_intMinDeal					= DKRS("intMinDeal")
		DKRS_intMinVIP					= DKRS("intMinVIP")
		DKRS_intPointNot				= DKRS("intPointNot")
		DKRS_intPointAuth				= DKRS("intPointAuth")
		DKRS_intPointDeal				= DKRS("intPointDeal")
		DKRS_intPointVIP				= DKRS("intPointVIP")
		DKRS_isImgType					= DKRS("isImgType")

		DKRS_strNationCode				= DKRS("strNationCode")

	Else
		Call ALERTS(LNG_SHOP_DETAILVIEW_01,"BACK","")
	End If
	Call closeRs(DKRS)

	If DKRS_strNationCode <> DK_MEMBER_NATIONCODE Then Call ALERTS(LNG_ALERT_WRONG_ACCESS,"BACK","")	'▣국가코드, 상품국가코드 비교


	'##################################################################
	' 회원레벨별 상품가격 변경
	'################################################################## START
	Select Case DK_MEMBER_LEVEL
		Case 0,1 '비회원, 일반회원
			DKRS_GoodsPrice = DKRS_intPriceNot
			DKRS_GoodsPoint = DKRS_intPointNot
			DKRS_intMinimum = DKRS_intMinNot
			If DKRS_isViewMemberNot = "F" Then Call ALERTS(LNG_SHOP_DETAILVIEW_02,"BACK","")
		Case 2 '인증회원
			DKRS_GoodsPrice = DKRS_intPriceAuth
			DKRS_GoodsPoint = DKRS_intPointAuth
			DKRS_intMinimum = DKRS_intMinAuth
			If DKRS_isViewMemberAuth = "F" Then Call ALERTS(LNG_SHOP_DETAILVIEW_02,"BACK","")
		Case 3 '딜러회원
			DKRS_GoodsPrice = DKRS_intPriceDeal
			DKRS_GoodsPoint = DKRS_intPointDeal
			DKRS_intMinimum = DKRS_intMinDeal
			If DKRS_isViewMemberDeal = "F" Then Call ALERTS(LNG_SHOP_DETAILVIEW_02,"BACK","")
		Case 4,5 'VIP 회원
			DKRS_GoodsPrice = DKRS_intPriceVIP
			DKRS_GoodsPoint = DKRS_intPointVIP
			DKRS_intMinimum = DKRS_intMinVIP
			If DKRS_isViewMemberVIP = "F" Then Call ALERTS(LNG_SHOP_DETAILVIEW_02,"BACK","")
		Case 9,10,11
			DKRS_GoodsPrice = DKRS_intPriceVIP
			DKRS_GoodsPoint = DKRS_intPointVIP
			DKRS_intMinimum = DKRS_intMinVIP
	End Select
	'##################################################################	END

	'##################################################################
	' 상품 재고상태 확인
	'################################################################## START
	If DKRS_DelTF = "T" Then Call ALERTS(LNG_SHOP_ORDER_WISHLIST_TEXT03 & LNG_STRTEXT_TEXT02,"BACK","")
	If DKRS_isAccept <> "T" Then Call ALERTS(LNG_SHOP_ORDER_DIRECT_06 & LNG_STRTEXT_TEXT02,"BACK","")
	If DKRS_GoodsViewTF <> "T" Then Call ALERTS(LNG_SHOP_ORDER_DIRECT_05 & LNG_STRTEXT_TEXT02,"BACK","")

	If DKRS_intMinimum = 0 Then DKRS_intMinimum = 1
	'##################################################################	END


	'##################################################################
	' 이미지 / 아이콘정보 확인
	'################################################################## START
	If DKRS_isImgType = "S" Then
		imgPath = VIR_PATH("Goods/img1")&"/"&backword(DKRS_Img1Ori)
		imgPath2 = VIR_PATH("Goods/img2")&"/"&backword(DKRS_Img2Ori)
		imgPath3 = VIR_PATH("Goods/img3")&"/"&backword(DKRS_Img3Ori)
		imgPath4 = VIR_PATH("Goods/img4")&"/"&backword(DKRS_Img4Ori)
		imgPath5 = VIR_PATH("Goods/img5")&"/"&backword(DKRS_Img5Ori)

		newimgWidth = 0
		newimgHeight = 0

		NEW_LENGTH = 400
		Call imgInfoNew(imgPath,newimgWidth,newimgHeight,"",NEW_LENGTH)

		imgPaddingW = (NEW_LENGTH - newimgWidth)/2
		imgPaddingH = (NEW_LENGTH - newimgHeight)/2
		liMarginTop = (450 - newimgHeight) / 2

		sImgs = 75		'작은썸네일크기 css .inSimg 과 매칭

	Else
		imgPath = BACKWORD(DKRS_Img1Ori)
		imgPath2 = BACKWORD(DKRS_Img2Ori)
		imgPath3 = BACKWORD(DKRS_Img3Ori)
		imgPath4 = BACKWORD(DKRS_Img4Ori)
		imgPath5 = BACKWORD(DKRS_Img5Ori)

		newimgWidth = upImgWidths_Default
		newimgHeight = upImgHeight_Default

		liMarginTop = (450 - newimgHeight) / 2

		sImgs = 75		'작은썸네일크기 css .inSimg 과 매칭

	End If

	If DKRS_flagBest	= "T" Then flagBest =  "<span class=""icons"">"&viewImg(IMG_ICON&"/i_bestT.gif",31,11,"")&"</span>"
	If DKRS_flagNew		= "T" Then flagNew = "<span class=""icons"">"&viewImg(IMG_ICON&"/i_newT.gif",31,11,"")&"</span>"
	If DKRS_flagVote	= "T" Then flagVote = "<span class=""icons"">"&viewImg(IMG_ICON&"/i_voteT.gif",31,11,"")&"</span>"
	If DK_MEMBER_TYPE = "COMPANY" Or DK_MEMBER_TYPE ="ADMIN" Then
		'If DKRS_isCSGoods	= "T" Then flagCS = "<span class=""icons"">"&viewImg(IMG_ICON&"/i_csgoodsT.gif",50,11,"")&"</span>"
	End If
	'################################################################## END


	'##################################################################
	' CS회원인 경우 PV값 / 상품판매가 확인
	'################################################################## START
	vipPrice = 0	'COSMICO
	If DKRS_isCSGoods = "T" Then
	'▣CS상품정보
		arrParams = Array(_
			Db.makeParam("@ncode",adVarChar,adParamInput,20,DKRS_CSGoodsCode) _
		)
		Set DKRS = Db.execRs("HJP_CSGOODS_PRICE_INFO",DB_PROC,arrParams,DB3)
		If Not DKRS.BOF And Not DKRS.EOF Then
			RS_ncode		= DKRS("ncode")
			RS_price		= DKRS("price")
			RS_price2		= DKRS("price2")
			RS_price4		= DKRS("price4")
			RS_price5		= DKRS("price5")
			RS_price6		= DKRS("price6")		'COSMICO VIP 가
			RS_price7		= DKRS("price7")		'COSMICO 셀러 가
			RS_price8		= DKRS("price8")		'COSMICO 매니저 가
			RS_price9		= DKRS("price9")		'COSMICO 지점장 가
			RS_price10		= DKRS("price10")	'COSMICO 본부장 가

			RS_SellCode		= DKRS("SellCode")
			RS_SellTypeName	= DKRS("SellTypeName")

			'COSMICO VIP 매출가
			Select Case nowGradeCnt
				Case "20"	vipPrice = RS_price6
				Case "30"	vipPrice = RS_price7
				Case "40"	vipPrice = RS_price8
				Case "50"	vipPrice = RS_price9
				Case "60"	vipPrice = RS_price10
				Case Else vipPrice = 0
			End Select

		End If
		Call closeRs(DKRS)

		'▣소비자 가격, 쇼핑몰가/CS가 비교
		If CONST_CS_SOBIJA_PRICE_USE_TF = "T" Then
			If DK_MEMBER_STYPE = "1" Then
				DKRS_GoodsPrice = DKRS_GoodsCustomer
				RS_price2	    = RS_price
			End If
		End If

		'If DK_MEMBER_LEVEL > 0 Then
			viewPrice = DKRS_GoodsPrice
			viewPV = RS_price4
			viewBV = RS_price5
		'Else
		'	viewPrice = 0
		'	viewPV = 0
		'End If

	End If
	'################################################################## END

	'##################################################################
	' 옵션확인
	'################################################################## START
	If DKRS_OPTIONVAL = "T" Then
		SQL = "SELECT * FROM [DK_GOODS_OPTION] WITH(NOLOCK) WHERE [GoodsIDX] = ? AND [isUse] = 'T' ORDER BY [sort] ASC"
		arrParams = Array(_
			Db.makeParam("@GoodsIDX",adInteger,adParamInput,0,GoodsIDX) _
		)
		arrList = Db.execRsList(SQL,DB_TEXT,arrParams,listLen,Nothing)

		If IsArray(arrList) Then
			PrintOption = ""
			For i = 0 To listLen
				optionTitle = Trim(arrList(2,i))
				optionItem = Trim(arrList(3,i))
				arrOptItem = Split(optionItem,"\")
				TOTAL_OPTION_CNT = listLen + 1

				PrintOption = PrintOption & "<tr>"
				PrintOption = PrintOption & "	<th class=""option"">"&optionTitle&"</th>"
				PrintOption = PrintOption & "	<td class=""option"">"
				PrintOption = PrintOption & "		<select name=""goodsOption"" class=""select"" title="""&optionTitle&""">"
				PrintOption = PrintOption & "			<option value="""">"&LNG_SHOP_DETAILVIEW_03&"</option>"
					For j = 0 To UBound(arrOptItem)
						optionTxt = Trim(arrOptItem(j))
						optionPay = 0
						arrOptionTxt = Split(optionTxt,":")
						'print optionTxt
						optionTxt = Trim(arrOptionTxt(0))
						'print arrOptionTxt(0)
						'print arrOptionTxt(1)
						'print arrOptionTxt(2)

						If UBound(arrOptionTxt) = 2 Then
							optPrice = Int(arrOptionTxt(1))
							optPrice2 = Int(arrOptionTxt(2))
							'print optPrice
							If optPrice > 0 Then
								optionTxts = optionTxt &" (+"& FormatNumber(Int(optPrice),0) &" "&Chg_CurrencyISO&")"
							ElseIf optPrice < 0 Then
								optionTxts = optionTxt &" (-"& FormatNumber(Int(optPrice),0) &" "&Chg_CurrencyISO&")"
							ElseIf optPrice = 0 Then
								optionTxts = optionTxt
							End If
						End If
						optValue = optionTitle & ":" & optionTxt &"\" &optPrice & "\" & optPrice2
						PrintOption = PrintOption & "<option value="""&backword(optValue)&""">"&backword(optionTxts)&"</option>"
					Next
				PrintOption = PrintOption & "		</select>"
				PrintOption = PrintOption & "		</td>"
				PrintOption = PrintOption & "</tr>"
			Next
		End If

	End If
	'################################################################## END

	'##################################################################
	' 배송비 확인
	'################################################################## START
	Select Case DKRS_GoodsDeliveryType
		Case "SINGLE"
			txt_DeliveryFeeType = LNG_SHOP_ORDER_DIRECT_TABLE_08	'단독배송
			txt_self_DeliveryFee = DKRS_GoodsDeliveryFee
			txt_DeliveryFee = "<span class=""font18px"" id=""deliveryFee_txt"">"&num2cur(txt_self_DeliveryFee)& "</span>"&Chg_CurrencyISO&" ("&txt_DeliveryFeeType&")"

			DKRS2_intDeliveryFee = DKRS_GoodsDeliveryFee

		Case "BASIC"
			'▣ 국가별 배송비 설정
			arrParams2 = Array(_
				Db.makeParam("@strNationCode",adVarChar,adParamInput,6,UCase(DK_MEMBER_NATIONCODE)) _
			)
			Set DKRS2 = DB.execRs("HJP_GLOBAL_DELIVERY_FEE_VIEW",DB_PROC,arrParams2,Nothing)
			If Not DKRS2.BOF And Not DKRS2.EOF Then
				DKRS2_intDeliveryFee		= DKRS2("intDeliveryFee")
				DKRS2_intDeliveryFeeLimit	= DKRS2("intDeliveryFeeLimit")
			Else
				Response.Write LNG_SHOP_DETAILVIEW_22
			End If
			Call closeRS(DKRS2)

			txt_DeliveryFeeType = LNG_SHOP_ORDER_DIRECT_TABLE_10
			txt_self_DeliveryFee = DKRS2_intDeliveryFee

			If DKRS2_intDeliveryFee = 0 Then
				PRINT LNG_SHOP_ORDER_DIRECT_TABLE_10	'무료배송
			Else
				If UCase(DK_MEMBER_NATIONCODE) = "KR" Then
					txt_DeliveryFee = "<span class=""font18px"">"&num2cur(txt_self_DeliveryFee)& "</span>"&Chg_CurrencyISO&" ("&num2cur(DKRS2_intDeliveryFeeLimit)&LNG_SHOP_DETAILVIEW_21&")"
				Else
					txt_DeliveryFee = "<span class=""font18px"">"&num2cur(txt_self_DeliveryFee)& "</span>"&Chg_CurrencyISO&" ("&LNG_SHOP_DETAILVIEW_21&num2cur(DKRS2_intDeliveryFeeLimit)& " " &Chg_CurrencyISO&")"
				End If
			End If

	End Select
	'################################################################## END
%>
<%
	'##################################################################
	' 오늘본상품 저장
	'################################################################## START
		Sub ToDayGoodsSet(SG_CODE,SG_IMG,SG_NAME,SG_PRICE)
			C_Goods = Request.Cookies("TodayGcode")
			C_Count = Request.Cookies("TodayGcode").count
			If C_Goods = "" OR C_Count = "" Then C_Count = 0
			If C_Count > 11 Then C_Count = 11 '20개까지 저장을 의미

			For c_cnt = 1 To C_Count Step 1  ' 중복 데이터 체크하여 추가 안함.
				If Request.Cookies("TodayGcode")("G" & c_cnt) = SG_CODE Then
					Exit sub
				End If
			Next

			If InStr(C_Goods, "=" & SG_CODE) = 0 Then '저장된게 없으면 기존것은 배열에서 1씩 뒤로저장
				For c_cnt = C_Count To 1 Step -1
				Response.Cookies("TodayGcode")("G" & c_cnt + 1) = Request.Cookies("TodayGcode")("G" & c_cnt)
				Response.Cookies("TodayImg")("G" & c_cnt + 1) = Request.Cookies("TodayImg")("G" & c_cnt)
				Response.Cookies("TodayName")("G" & c_cnt + 1) = Request.Cookies("TodayName")("G" & c_cnt)
				Response.Cookies("TodayPrice")("G" & c_cnt + 1) = Request.Cookies("TodayPrice")("G" & c_cnt)
				Next

				'첫번째 배열에 신규상품 저장
				Response.Cookies("TodayGcode")("G1") = SG_CODE
				Response.Cookies("TodayImg")("G1") = SG_IMG
				Response.Cookies("TodayName")("G1") = SG_NAME
				Response.Cookies("TodayPrice")("G1") = SG_PRICE
			End If

			'쿠기 expires(만기)일 및 사용허용 도메인설정 만기일설정은 1일로 함
			NewDate = DateAdd("d", 1, Now())
			Response.Cookies("TodayGcode").expires = NewDate
			Response.Cookies("TodayGcode").path = "/"
			Response.Cookies("TodayGcode").Domain = Request.SERVERVARIABLES("SERVER_NAME")
			Response.Cookies("TodayImg").expires = NewDate
			Response.Cookies("TodayImg").path = "/"
			Response.Cookies("TodayImg").Domain = Request.SERVERVARIABLES("SERVER_NAME")

			Response.Cookies("TodayName").expires = NewDate
			Response.Cookies("TodayName").path = "/"
			Response.Cookies("TodayName").Domain = Request.SERVERVARIABLES("SERVER_NAME")
			Response.Cookies("TodayPrice").expires = NewDate
			Response.Cookies("TodayPrice").path = "/"
			Response.Cookies("TodayPrice").Domain = Request.SERVERVARIABLES("SERVER_NAME")
		End Sub

		ToDayGoodsSet DKRS_intIDX, DKRS_ImgThum , Left(DKRS_GoodsName,14), DKRS_GoodsPrice   '함수호출 상품코드, 상품이미지
	'##################################################################	END
%>

<!--#include virtual = "/_include/document.asp"-->
<link rel="stylesheet" href="/css/shop_order_style.css?v0" />
<script type="text/javascript">

	//제품상세정보 이미지조정
	$(document).ready(function() {
		var detailView_width = $("#contain.layout_inner").width();
		var inContent_imgwidth = $(".inContent img").width();

		if (inContent_imgwidth > detailView_width)	{
			$('.inContent img').css({"width":+detailView_width+"px"});
		}

		sumPrice();
	});

	// 폼 체크
	function check_frm(method) {
		var f = document.cartFrm;
		var i, len;
		<%if DKRS_GoodsStockType = "S" then%>
			alert("<%=LNG_SHOP_DETAILVIEW_04%>");
			return;
		<%end if%>
		<%if DKRS_GoodsStockType = "N" and DKRS_GoodsStockNum = 0 then%>
			alert("<%=LNG_SHOP_DETAILVIEW_05%>");
			return;
		<%end if%>
		<%if DKRS_GoodsStockType = "N" and DKRS_GoodsStockNum <> 0 then%>
			if (f.ea.value > <%=DKRS_GoodsStockNum%>)	{
				alert("<%=LNG_SHOP_DETAILVIEW_06%>");
				f.ea.focus();
				return;
			}
		<%end if%>

		<%if DKRS_intMinimum > 0 THEN%>
			//if (f.ea.value < <%=DKRS_intMinimum%>) {
			if (f.ea.value < <%=DKRS_intMinimum%> && method == 'direct') {		//직접구매만
				alert("<%=LNG_SHOP_DETAILVIEW_07%>");
				f.ea.focus();
				return;
			}
		<%END IF%>

		if (f.Gidx.value == "")	{
			alert("<%=LNG_SHOP_DETAILVIEW_08%>");
			return;
		}
		if (chkEmpty(f.ea)||f.ea.value=="0") {
			alert("<%=LNG_SHOP_DETAILVIEW_09%>")
			f.ea.focus();
			return;
		}
		<%if DK_MEMBER_LEVEL < 1 THEN%>
			var msg = "<%=LNG_SHOP_DETAILVIEW_10%>";
			if(confirm(msg)) {
				document.location.href="/common/member_login.asp?backURL=<%=ThisPageURL%>";
				return;
			}else{
				return;
			}
		<%END IF%>
		<%If DKRS_OPTIONVAL = "T" THEN%>
			<%If TOTAL_OPTION_CNT > 1 THEN%>
				len = f.goodsOption.length;
				//alert(len);
				for (i=0; i<len; i++) {
					objItem = f.goodsOption[i];
					if (objItem.value=='') {
						alert("<%=LNG_SHOP_DETAILVIEW_11%>"+eval((i+1)));
						objItem.focus();
						return;
					}
				}
			<%ELSE%>
				if (f.goodsOption.value == ""){
					alert("<%=LNG_SHOP_DETAILVIEW_12%>");
					f.goodsOption.focus();
					return;
				}
			<%END IF%>
		<%END IF%>
	eval(method+"();");
	}

	// 관심리스트
	function wish() {
		var f = document.cartFrm;
		<%IF DK_MEMBER_TYPE = "SELLER" THEN%>
			alert("<%=LNG_SHOP_DETAILVIEW_13%>");
			return;
		<%else%>
		openPopup("/hiddens.asp", "Wishs", 300, 200, "left=350, top=350");

		f.mode.value = "ADD";
		f.target = "Wishs";
		f.action = "wishlist.asp";
		f.submit();
		<%END IF%>
	}

	// 바로구매
	function direct() {
		var f = document.cartFrm;
		//alert("현재는 장바구니 기능만 동작하고 있습니다.");
		<%IF DK_MEMBER_TYPE = "SELLER" THEN%>
			alert("<%=LNG_SHOP_DETAILVIEW_13%>");
		<%ELSE%>
			f.target = "_self";
			f.action = "/shop/cart_direct.asp";			//주문통합
			f.submit();
		<%END IF%>
	}

	// 장바구니담기
	function cart() {
		var f = document.cartFrm;
		<%IF DK_MEMBER_TYPE = "SELLER" THEN%>
			alert("<%=LNG_SHOP_DETAILVIEW_13%>");
			return;
		<%ELSE%>
			/*
			f.mode.value = "ADD";
			f.target = "_self";
			f.action = "/shop/cart_handler.asp";
			f.submit();
			*/
			ajaxConfirmCart();
		<%END IF%>
	}

	//이미 담긴 장바구니 수량과 현재 주문갯수 합쳐서 재고와 비교
	function ajaxConfirmCart() {
		const formData = $("#cartFrm").serialize();
		$.ajax({
			type: "POST"
			,url: "/shop/cart_handler_ajax.asp"
			,cache : false
			,data: formData
			//,async : false
			,success: function(data) {
				//console.log(data);
				const json = $.parseJSON(data);
				if (json.result == "success") {
					confirmCartDialog(json.message+"<br /><br /><%=LNG_SHOP_CART_JS_MOVE_TO_CART%>");
					//confirmCart(json.message+"\n\n<%=LNG_SHOP_CART_JS_MOVE_TO_CART%>");
				}else{
					alert(json.message);
					return false;
				}
			}
			,error:function(data) {
				alert("<%=LNG_AJAX_ERROR_MSG%> : "+data.status+" "+data.statusText+" "+data.responseText);
			}
		});
		function confirmCartDialog(message) {
			$(".message").html(message);
			$(".dialog-confirm").click();
			return false;
		}
		function confirmCart(message) {
			if(confirm(message)){
				location.href='cart.asp';
			} else {
				return false;
			}
		}
	}

	//수량 직접 입력
	$(document).on("keyup","input[name=ea]",function() {
		let good_ea_id = $(this);
		stockCheck(good_ea_id,'');
	});

	function eaUpDown(ud) {
		let good_ea_id = $("input[name=ea]");
		stockCheck(good_ea_id,ud);
	}

	//재고,최소구매수량 체크
	function stockCheck(good_ea_id,ud) {
		let good_ea_val = good_ea_id.val() * 1;
		let GoodsStockType = $("input[name=GoodsStockType]").val();
		let GoodsStockNum = $("input[name=GoodsStockNum]").val() * 1;
		let intMinimum = $("input[name=intMinimum]").val() * 1;

		let chg_good_ea_val = 0;
		if (ud == '') chg_good_ea_val = good_ea_val;
		if (ud == 'up') chg_good_ea_val = (good_ea_val + 1);
		if (ud == 'down') chg_good_ea_val = (good_ea_val - 1);

		if(isNaN(chg_good_ea_val) == true || chg_good_ea_val == "" || chg_good_ea_val < 1) {
			if (intMinimum < 1) intMinimum = 1;
			good_ea_id.val(intMinimum);
			return false;
		}

		chkintMinimum();
		chkStockNum();

		good_ea_id.val(chg_good_ea_val);
		sumPrice();

		//1.최소구매수량 확인
		function chkintMinimum() {
			if (parseInt(chg_good_ea_val,10) < parseInt(intMinimum,10))	{
				alert("<%=LNG_SHOP_DETAILVIEW_07%>("+intMinimum+")");
				chg_good_ea_val = intMinimum;
				return false;
			}
		}

		//2.재고비교
		function chkStockNum() {
			if (GoodsStockType == 'N' && GoodsStockNum > 0)
			{
				if (chg_good_ea_val > GoodsStockNum) {
					alert("<%=LNG_SHOP_DETAILVIEW_06%>");
					chg_good_ea_val = GoodsStockNum;
				}
			}
		}
	}

	function sumPrice() {
		let basePrice_val = $("#basePrice").val();
		let basePV_val = $("#basePV").val();
		let baseBV_val = $("#baseBV").val();
		let good_ea_val	= $("input[name=ea]").val();
		let DeliveryType = $("input[name=DeliveryType]").val();
		let BASIC_DeliveryFeeLimit = $("input[name=BASIC_DeliveryFeeLimit]").val() * 1;
		let BASIC_DeliveryFee = $("input[name=BASIC_DeliveryFee]").val() * 1;

		let sumPrice = formatComma(basePrice_val * good_ea_val,3) ;
		let sumPV = formatComma(basePV_val * good_ea_val,3) ;
		let sumBV = formatComma(baseBV_val * good_ea_val,3) ;

		if (DeliveryType == "SINGLE") {
			BASIC_DeliveryFee = formatComma(BASIC_DeliveryFee * good_ea_val,3);
		}
		//console.log(good_ea_val,DeliveryType ,BASIC_DeliveryFee);

		$("#sumPrice_txt").text(sumPrice);
		$("#sumPV_txt").text(sumPV);
		$("#sumBV_txt").text(sumBV);
		$("#deliveryFee_txt").text(BASIC_DeliveryFee);
	}

</script>
<script type="text/javascript" src="detailView.js" /></script>
</head>
<body>
<!--#include virtual = "/_include/header.asp"-->
<div id="detailView" class="cleft">
	<div class="cleft width100 infowrap">
		<div class="fleft imgArea" style="">
			<div id="bImg" class="bImg"><img src="<%=imgPath%>" width="<%=newimgWidth%>" height="<%=newimgHeight%>" alt="" id="bImgCon" style="margin-top:<%=liMarginTop%>px" /></div>
			<!-- <div class="zoomImg"><%=aImg("javascript:openImgB('"&GoodsIDX&"')",IMG_SHOP&"/zoomImg.jpg","",13,"")%></div> -->
			<%'#modal%>
			<div class="zoomImg"><a name="modal" id="" href="/shop/imgView.asp?idv=<%=GoodsIDX%>" title="<%=LNG_SHOP_DETAILVIEW_IMAGE_DETAIL%>"><img src="/images_kr/shop/zoomImg.jpg" alt="" /></a></div>
			<div class="sImg">
				<%If DKRS_Img2Ori <> "" And Not IsNull(DKRS_Img2Ori) Then%><div class="inSimg mr5"><img src="<%=imgPath2%>" width="<%=sImgs%>" height="<%=sImgs%>" alt="" class="cp" onmouseover="document.getElementById('bImgCon').src='<%=imgPath2%>';" onmouseout="document.getElementById('bImgCon').src='<%=imgPath%>';" /></div><%End If%>
				<%If DKRS_Img3Ori <> "" And Not IsNull(DKRS_Img3Ori) Then%><div class="inSimg mr5"><img src="<%=imgPath3%>" width="<%=sImgs%>" height="<%=sImgs%>" alt="" class="cp" onmouseover="document.getElementById('bImgCon').src='<%=imgPath3%>';" onmouseout="document.getElementById('bImgCon').src='<%=imgPath%>';" /></div><%End If%>
				<%If DKRS_Img4Ori <> "" And Not IsNull(DKRS_Img4Ori) Then%><div class="inSimg mr5"><img src="<%=imgPath4%>" width="<%=sImgs%>" height="<%=sImgs%>" alt="" class="cp" onmouseover="document.getElementById('bImgCon').src='<%=imgPath4%>';" onmouseout="document.getElementById('bImgCon').src='<%=imgPath%>';" /></div><%End If%>
				<%If DKRS_Img5Ori <> "" And Not IsNull(DKRS_Img5Ori) Then%><div class="inSimg">    <img src="<%=imgPath5%>" width="<%=sImgs%>" height="<%=sImgs%>" alt="" class="cp" onmouseover="document.getElementById('bImgCon').src='<%=imgPath5%>';" onmouseout="document.getElementById('bImgCon').src='<%=imgPath%>';" /></div><%End If%>
			</div>
		</div>
		<div id="detailInfo">
			<div class="fleft width100 GoodsSubject_R"><span><%=DKRS_GoodsName%></span></div>
			<%If DKRS_GoodsComment <> "" Then%>
			<div class="fleft width100 GoodsComment_R"><span><%=DKRS_GoodsComment%></span></div>
			<%End If%>
			<%
				If DKRS_GoodsPrice < DKRS_GoodsCustomer  And DK_MEMBER_LEVEL > 0 Then
				DisCountPercent = 100 - Round((DKRS_GoodsPrice/DKRS_GoodsCustomer) * 100)
			%>
			<div class="price_dis_bg"><div><span><%=DisCountPercent%>%</span></div></div>
			<%End If%>
			<form name="cartFrm" id="cartFrm" method="post" action="">
				<input type="hidden" name="Gidx" value="<%=GoodsIDX%>" />
				<input type="hidden" name="mode" value="ADD" />
				<input type="hidden" name="strShopID" value="<%=DKRS_strShopID%>" />
				<input type="hidden" name="isShopType" value="<%=DKRS_isShopType%>" />
				<input type="hidden" name="GoodsDeliveryType" value="<%=DKRS_GoodsDeliveryType%>" />

				<div class="GoodsCustomer fleft width100"><%=flagBest%><%=flagNew%><%=flagVote%><%=flagCS%></div>
				<%If DK_MEMBER_STYPE = "1" Then%>
					<%If CONST_CS_SOBIJA_PRICE_USE_TF = "T" Then	'소비자회원 소비자가%>
						<div class="GoodsPrice"><%=LNG_SHOP_DETAILVIEW_16%> : <span class="GoodsNumber"><%=num2cur(DKRS_GoodsCustomer)%></span> <%=Chg_CurrencyISO%></div>
					<%Else%>
						<div class="GoodsCustomer"><%=LNG_SHOP_DETAILVIEW_15%> : <span class="GoodsNumber"><%=num2cur(DKRS_GoodsCustomer)%></span> <%=Chg_CurrencyISO%></div>
						<div class="GoodsPrice"><%=LNG_SHOP_DETAILVIEW_16%> : <span class="GoodsNumber"><%=num2cur(DKRS_GoodsPrice)%></span> <%=Chg_CurrencyISO%></div>
					<%End If%>
				<%Else%>
					<div class="GoodsCustomer"><%=LNG_SHOP_DETAILVIEW_15%> : <span class="GoodsNumber"><%=num2cur(DKRS_GoodsCustomer)%></span> <%=Chg_CurrencyISO%></div>
					<div class="GoodsPrice"><%=LNG_SHOP_DETAILVIEW_16%> : <span class="GoodsNumber"><%=num2cur(DKRS_GoodsPrice)%></span> <%=Chg_CurrencyISO%></div>
				<%End If%>
				<%If nowGradeCnt >= 20 And vipPrice > 0 Then 'COSMICO%>
					<div class="GoodsPrice"><%=LNG_VIP_PRICE%> : <span class="GoodsNumber"><%=num2cur(vipPrice)%></span> <%=Chg_CurrencyISO%></div>
				<%End If%>

				<table <%=tableatt%> class="width100">
					<col width="135" />
					<col width="*" />
					<%If RS_SellTypeName <> "" Then %>
					<tr>
						<td class="GoodsGV"><%=LNG_TEXT_SALES_TYPE%></td>
						<td class="GoodsGV"><span class="GoodsNumber tweight"><%=RS_SellTypeName%></span></td>
					</tr>
					<%End If%>
					<% If DKRS_GoodsPoint <> 0 Then%>
						<tr>
							<td class="point"><%=LNG_SHOP_DETAILVIEW_17%></td>
							<td class="point"><span class="GoodsNumber tweight"><%=num2cur(DKRS_GoodsPoint)%> <%=SHOP_POINT%></span></td>
						</tr>
					<%End If%>
					<tr>
						<th><%=LNG_SHOP_DETAILVIEW_18%></td>
						<td><%=txt_DeliveryFee%></td>
					</tr>
					<tr>
						<th><%=LNG_TEXT_CSGOODS_CODE%></td>
						<td><%=RS_ncode%></td>
					</tr>
					<% If DKRS_GoodsNote <> "" Then%>
						<tr>
							<th><%=LNG_SHOP_DETAILVIEW_23%></td>
							<td><%=DKRS_GoodsNote%></td>
						</tr>
					<%End If%>
					<% If DKRS_GoodsMade <> "" Or DKRS_GoodsProduct <> "" Then%>
					<%
						If DKRS_GoodsMade <> "" Then txt_GoodsMade = LNG_SHOP_DETAILVIEW_24
						If DKRS_GoodsProduct <> "" Then txt_GoodsProduct = LNG_SHOP_DETAILVIEW_25
					%>
						<tr>
							<th><%=txt_GoodsMade%> / <%=txt_GoodsProduct%></th>
							<td><%=DKRS_GoodsMade%> / <%=DKRS_GoodsProduct%></td>
						</tr>
					<%End If%>
					<% If DKRS_GoodsBrand <> "" Or DKRS_GoodsModels <> "" Then%>
					<%
						If DKRS_GoodsBrand <> "" Then txt_GoodsBrand = LNG_SHOP_DETAILVIEW_26
						If DKRS_GoodsModels <> "" Then txt_GoodsModels = LNG_SHOP_DETAILVIEW_27
					%>
						<tr>
							<th><%=txt_GoodsBrand%> / <%=txt_GoodsModels%></th>
							<td><%=DKRS_GoodsBrand%> / <%=DKRS_GoodsModels%></td>
						</tr>
					<%End If%>
					<% If DKRS_GoodsMaterial <> "" Or DKRS_GoodsCarton <> "" Then%>
					<%
						If DKRS_GoodsMaterial <> "" Then txt_GoodsMaterial = LNG_SHOP_DETAILVIEW_28
						If DKRS_GoodsCarton <> "" Then txt_GoodsCarton = LNG_SHOP_DETAILVIEW_29
					%>
						<tr>
							<th><%=txt_GoodsMaterial%> / <%=txt_GoodsCarton%></th>
							<td><%=DKRS_GoodsMaterial%> / <%=txt_GoodsCarton%></td>
						</tr>
					<%End If%>
					<% If DKRS_GoodsSize <> "" Or DKRS_GoodsColor <> "" Then%>
					<%
						If DKRS_GoodsSize <> "" Then txt_GoodsSize = LNG_SHOP_DETAILVIEW_30
						If DKRS_GoodsColor <> "" Then txt_GoodsColor = LNG_SHOP_DETAILVIEW_31
					%>
						<tr>
							<th><%=txt_GoodsSize%> / <%=txt_GoodsColor%></td>
							<td><%=DKRS_GoodsSize%> / <%=DKRS_GoodsColor%></td>
						</tr>
					<%End If%>
					<tr>
						<th><span class=""><%=LNG_TOTAL_PAY_PRICE%></span></th>
						<td class="GoodsPriceTot"><span id="sumPrice_txt" class="GoodsNumber"><%=num2cur(viewPrice)%></span>&nbsp;<span class=""><%=Chg_CurrencyISO%></span></td>
					</tr>
					<%If PV_VIEW_TF = "T" Then%>
					<tr>
						<th class=""><%=CS_PV%></th>
						<td class="GoodsPV"><span id="sumPV_txt" class="GoodsNumber"><%=num2cur(RS_price4)%></span>&nbsp;<span class=""><%=CS_PV%></span></td>
					</tr>
					<%End If%>
					<%If BV_VIEW_TF = "T" Then%>
					<tr>
						<th class=""><%=CS_PV2%></th>
						<td class="GoodsGV"><span id="sumBV_txt" class="GoodsNumber"><%=num2cur(RS_price5)%></span>&nbsp;<span class=""><%=CS_PV2%></span></td>
					</tr>
					<%End IF%>
					<tr>
						<th class="vmiddle"><%=LNG_SHOP_DETAILVIEW_32%></th>
						<%If DKRS_GoodsStockType = "S" then%>
						<td><%=LNG_SHOP_DETAILVIEW_33%></td>
							<input type="hidden" name="ea" value="<%=DKRS_intMinimum%>" readonly="readonly">
						<%Else%>
						<td>
							<span class="ea_bg"><a href="javascript:eaUpDown('down');">-</a></span><input type="text" name="ea" value="<%=DKRS_intMinimum%>" class="input_text_ea vmiddle tcenter" style="width:28px;" <%=onlyKeys%> /><span class="ea_bg"><a href="javascript: eaUpDown('up');">+</a></span>
							<%If DKRS_intMinimum > 1 Then%>
								<span style="padding-left: 8px;">(<%=LNG_SHOP_DETAILVIEW_34%> : <span class="tweight"><%=DKRS_intMinimum%></span>)</span>
							<%End If%>
							<%If DKRS_GoodsStockType = "N" and DKRS_GoodsStockNum >= 0 Then%>
								<span style="padding-left: 8px;">(<%=LNG_SHOP_CART_TXT_STOCK%> : <span class="tweight"><%=DKRS_GoodsStockNum%></span>)</span>
							<%End If%>
						</td>
						<%End If%>
					</tr>
					<%=PrintOption%>
				</table>
				<input type="hidden" name="intMinimum" value="<%=DKRS_intMinimum%>" readonly="readonly"/>
				<input type="hidden" name="GoodsStockType" value="<%=DKRS_GoodsStockType%>" />
				<input type="hidden" name="GoodsStockNum" value="<%=DKRS_GoodsStockNum%>" />
				<input type="hidden" name="basePrice" id="basePrice" value="<%=viewPrice%>" readonly="readonly" />
				<input type="hidden" name="basePV" id="basePV" value="<%=viewPV%>" readonly="readonly" />
				<input type="hidden" name="baseBV" id="baseBV" value="<%=viewBV%>" readonly="readonly" />
				<input type="hidden" name="DeliveryType" value="<%=DKRS_GoodsDeliveryType%>" readonly="readonly" />
				<input type="hidden" name="BASIC_DeliveryFeeLimit" value="<%=DKRS2_intDeliveryFeeLimit%>" readonly="readonly" />
				<input type="hidden" name="BASIC_DeliveryFee" value="<%=DKRS2_intDeliveryFee%>" readonly="readonly" />
			</form>

			<div class="cleft ShopBtnZone width100">
				<%If DKRS_isCSGoods = "T" And (RS_price2 <> DKRS_GoodsPrice) Then	%>
					<span><input type="button" class="txtBtnC large red2" onclick="javascript:alert('<%=LNG_SHOP_DETAILVIEW_JS_DIFFERENT_PRICE%>');" value="<%=LNG_SHOP_DETAILVIEW_BTN_CANNOT%>"/></span>
				<%Else%>
					<%If DKRS_GoodsStockType = "N" And DKRS_GoodsStockNum = 0 Then%>
						<span><input type="button" class="txtBtnC large red2" onclick="javascript:alert('<%=LNG_SHOP_DETAILVIEW_05%>');" value="<%=LNG_SHOP_DETAILVIEW_BTN_SOLDOUT%>"/></span>
					<%Else%>
						<%If DKRS_GoodsPrice < 1 Then	%>
							<span><input type="button" class="txtBtnC large red2" onclick="javascript:alert('<%=LNG_SHOP_DETAILVIEW_JS_NO_PRICE%>');" value="<%=LNG_SHOP_DETAILVIEW_BTN_CANNOT%>"/></span>
						<%Else%>

							<span><input type="button" class="txtBtnC large green" onclick="check_frm('direct');" value="<%=LNG_SHOP_DETAILVIEW_BTN_01%>"/></span>
							<span class="pL10"><input type="button" class="txtBtnC large gray border1" onclick="check_frm('cart');" value="<%=LNG_SHOP_DETAILVIEW_BTN_02%>"/></span>
							<!-- <span class="pL10"><input type="button" class="txtBtnC large gray border1" onclick="check_frm('wish');" value="<%=LNG_SHOP_DETAILVIEW_BTN_03%>"/></span> -->

							<span class="dialog-confirm" title="<%=LNG_TEXT_CART%>"></span>
							<%DIALOG_CONFIRM_URL = MOB_PATH&"/shop/cart.asp"%>
						<%End If%>
					<%End If%>
				<%End If%>
			</div>
		</div>
	</div>

	<div class="detailView_btn" style="">
		<p class="tit" id="tablocation1" name="tablocation1"><%=LNG_SHOP_DETAILVIEW_35%></p>
		<ul class="inul">
			<li><a href="#tablocation1"><%=LNG_SHOP_DETAILVIEW_35%></a></li>
			<li class="lines"><img src="<%=IMG_SHOP%>/detailView_btn_line.gif" width="2" height="13" alt="" style="margin-top:10px;" /></li>
			<li><a href="#tablocation4"><%=LNG_SHOP_DETAILVIEW_36%></a></li>
		</ul>
	</div>
	<div class="inContent" style="padding:30px 0px;"><%=BACKWORD_TAG(DKRS_GoodsContent)%></div>

	<%
		Select Case DKRS_isShopType
			Case "E"
				If DKRS_GoodsDeliPolicyType = "B" Then
					SQL = "SELECT [policyContent] FROM [DK_POLICY] WITH(NOLOCK) WHERE [delTF] = 'F' AND [policyType] = ? AND [strNationCode] = ?"
					arrParams = Array(_
						Db.makeParam("@policyType",adVarChar,adParamInput,20,"delivery"), _
						Db.makeParam("@strNationCode",adVarChar,adParamInput,6,DK_MEMBER_NATIONCODE) _
					)
					THIS_DELI_CONTENT = Db.execRsData("DKPC_POLICY_CONTENT",DB_PROC,arrParams,Nothing)
					'THIS_DELI_CONTENT = Db.execRsData("DKSP_POLICY_CONTENT",DB_PROC,arrParams,Nothing)
					THIS_DELI_CONTENT = BACKWORD_TAG(THIS_DELI_CONTENT)
				Else
					THIS_DELI_CONTENT = BACKWORD_TAG(DKRS_GoodsDeliPolicy)
				End If
			Case "S"
				If DKRS_GoodsDeliPolicyType = "B" Then
					arrParams = Array(_
						Db.makeParam("@strShopID",adVarChar,adParamInput,20,DKRS_strShopID) _
					)
					THIS_DELI_CONTENT = Db.execRsData("DKPD_VENDOR_DELIVERY",DB_PROC,arrParams,Nothing)
					THIS_DELI_CONTENT = BACKWORD_TAG(THIS_DELI_CONTENT)
				Else
					THIS_DELI_CONTENT = BACKWORD_TAG(DKRS_GoodsDeliPolicy)
				End If
		End Select
	%>

	<%'If DK_MEMBER_LEVEL > 0 Then %>
	<div class="detailView_btn">
		<p class="tit" id="tablocation4" name="tablocation4"><%=LNG_SHOP_DETAILVIEW_36%></p>
		<ul class="inul">
			<li><a href="#tablocation1"><%=LNG_SHOP_DETAILVIEW_35%></a></li>
			<li class="lines"><img src="<%=IMG_SHOP%>/detailView_btn_line.gif" width="2" height="13" alt="" style="margin-top:10px;" /></li>
			<li><a href="#tablocation4"><%=LNG_SHOP_DETAILVIEW_36%></a></li>
		</ul>
	</div>
	<div class="inContent" style=" padding-top:30px;"><%=THIS_DELI_CONTENT%></div>
	<%'End If%>

</div>
<%
	'상품 이미지 크게보기 설정
	imgWidth = 550
	imgHeight = 550

	RightSideImgWidth = 60
	RightSideImgWidthPop = 20
	If DKRS_Img2Ori <> "" Or DKRS_Img3Ori <> "" Or DKRS_Img4Ori <> "" Or DKRS_Img5Ori <> "" Then
		RightSideImgWidth = 180
		RightSideImgWidthPop = 180
	End If

	MODAL_CONTENT_WIDTH = imgWidth + RightSideImgWidth
	MODAL_CONTENT_HEIGHT = imgHeight + 260
%>
<script>
	function openImgB(idv) {
		let popWidth = <%=imgWidth%> + <%=RightSideImgWidthPop%>;
		let popHeight = <%=imgHeight%> + 260;
		openPopup('imgView.asp?idv='+idv, 'imgView', 'top=100px,left=200px,width='+popWidth+',height='+popHeight+',resizable=no,status=no,toolbar=no,menubar=no,scrollbars=no');
	}
</script>
<!--#include virtual="/_include/modal_config.asp" -->
<!--#include virtual = "/_include/copyright.asp"-->
