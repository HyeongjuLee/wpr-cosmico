<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	Response.CharSet = "UTF-8"
	Response.AddHeader "Pragma","no-cache"
	Response.AddHeader "Expires","0"

	Call ONLY_MEMBER(DK_MEMBER_LEVEL)
	Call FN_NationCurrency(DK_MEMBER_NATIONCODE,Chg_CurrencyName,Chg_CurrencyISO)

	If DK_MEMBER_LEVEL < 1 Then Response.End

	MODE	= Trim(pRequestTF_JSON("mode",True))

	' 값 설정
	If DK_MEMBER_ID = "" Then DK_MEMBER_ID = ""
	If Gopt = ""  Then Gopt = ""

	Select Case MODE
		Case "ADD"			'detailView
			Gidx	= Trim(pRequestTF_JSON("Gidx",False))
			Gopt	= Trim(pRequestTF_JSON("goodsOption",False))
			ea		= Trim(pRequestTF_JSON("ea",True))
			strShopID = trim(pRequestTF_JSON("strShopID",False))
			isShopType = trim(pRequestTF_JSON("isShopType",False))
			GoodsDeliveryType = trim(pRequestTF_JSON("GoodsDeliveryType",False))

			If ea < 1 Or ea = "" Then ea = 1

			If DK_MEMBER_ID <> "" Then
				cart_id = DK_MEMBER_ID
				cart_method = "MEMBER"
			Else
				cart_id = DK_MEMBER_IDX
				cart_method = "NOTMEM"
			End If

			If cart_method = "MEMBER" Then
				WHERES = "WHERE [strMemID] = ?"
			ElseIf cart_method = "NOTMEM" Then
				WHERES = "WHERE [strIDX] = ?"
			Else
				'Call alerts("구분자가 존재하지 않습니다. 관리자에게 문의해주세요.","back","")
				PRINT "{""result"":""error"",""message"":"""&LNG_SHOP_CART_JS_NO_DIVIDER&"""}" : Response.End
			End If

			'*** CartCnt : 장바구니에상품이 있는지cnt → 현재상품 갯수가져오기 ***
			'	strHostA 조건 삭제 : 같은회원아이디로 같은상품 주문 시 strHostA가 다를 경우(www, 127,) 장바구니에 따로 저장됨.
			'	Db.makeParam("@strDomain",adVarChar,adParamInput,50,strHostA), _

			'SQL = "SELECT COUNT([intIDX]) "
			SQL = "SELECT ISNULL(MAX([orderEa]),0)"
			SQL = SQL & " FROM [DK_CART] WITH (NOLOCK) "
			SQL = SQL & WHERES
			SQL = SQL & " AND [GoodIDX] = ? "
			SQL = SQL & " AND [strOption] = ? AND [isDirect] = 'F' AND [strNationCode] = ? AND [DelTF] = 'F' "
			arrParams = Array(_
				Db.makeParam("@Uid",adVarChar,adParamInput,50,cart_id), _
				Db.makeParam("@GoodIDX",adInteger,adParamInput,0,Gidx), _
				Db.makeParam("@strOption",adVarChar,adParamInput,512,Gopt) ,_
				Db.makeParam("@strNationCode",adVarChar,adParamInput,6,UCase(DK_MEMBER_NATIONCODE)) _
			)
			CartCnt = Db.execRsData(SQL,DB_TEXT,arrParams,Nothing)
			If CartCnt = "" Then CartCnt = 0

			'##################################################################
			'	최소구매수량 / 재고량 비교
			'	이미 담긴 장바구니 수량과 현재 주문갯수를 합쳐서 재고와 비교
			'################################################################## START
				arrParams = Array(_
					Db.makeParam("@intIDX",adInteger,adParamInput,0,Gidx) _
				)
				Set DKRS = Db.execRs("DKP_GOODS_DETAILVIEW",DB_PROC,arrParams,Nothing)
				If Not DKRS.BOF And Not DKRS.EOF Then
					DKRS_GoodsStockType	= DKRS("GoodsStockType")
					DKRS_GoodsStockNum	= DKRS("GoodsStockNum")
					DKRS_intMinNot			= DKRS("intMinNot")
					DKRS_intMinAuth			= DKRS("intMinAuth")
					DKRS_intMinDeal			= DKRS("intMinDeal")
					DKRS_intMinVIP			= DKRS("intMinVIP")
				End If
				Call closeRs(DKRS)

				Select Case DK_MEMBER_LEVEL
					Case 0,1 '비회원, 일반회원
						DKRS_intMinimum = DKRS_intMinNot
					Case 2 '인증회원
						DKRS_intMinimum = DKRS_intMinAuth
					Case 3 '딜러회원
						DKRS_intMinimum = DKRS_intMinDeal
					Case 4,5 'VIP 회원
						DKRS_intMinimum = DKRS_intMinVIP
					Case 9,10,11
						DKRS_intMinimum = DKRS_intMinVIP
				End Select

				If DKRS_intMinimum = 0 Then DKRS_intMinimum = 1

				All_EA = Int(CartCnt) + Int(ea)

				MIN_ORDERCNT_WITHOUT_CART = Int(DKRS_intMinimum) - Int(CartCnt)			'카트수량 제외한 최소 구매수량
				minimumTxt = ""

				'//0.최소구매수량 / 재고량 비교
				If DKRS_GoodsStockType = "N" And MIN_ORDERCNT_WITHOUT_CART > DKRS_GoodsStockNum Then
					PRINT "{""result"":""error"",""message"":""최소 구매수량("&DKRS_intMinimum&"보다 재고가("&DKRS_GoodsStockNum&") 부족합니다.""}" : Response.End
				End If

				'1.최소구매수량 확인
				If Int(ea) < MIN_ORDERCNT_WITHOUT_CART Then
					'MISSING_EA = (DKRS_intMinimum - All_EA)
					If Int(CartCnt) > 0 Then
						minimumTxt = "\n\n※ 장바구니 합산 수량 : "&All_EA
					End If
					PRINT "{""result"":""error"",""message"":"""&LNG_SHOP_DETAILVIEW_07& minimumTxt&"""}" : Response.End
				END IF

				'2.재고비교
				If DKRS_GoodsStockType = "N" And DKRS_GoodsStockNum > 0 Then
					If Int(All_EA) > Int(DKRS_GoodsStockNum) Then
						PRINT "{""result"":""error"",""message"":"""&LNG_SHOP_DETAILVIEW_06&" (장바구니 갯수 합산)""}" : Response.End
					End If
				End If
			'################################################################## END

			If Int(CartCnt) > 0 Then
					'Db.makeParam("@strDomain",adVarChar,adParamInput,50,strHostA), _
				SQL = "UPDATE [DK_CART] SET [orderEa] = [orderEa] + ? "
				SQL = SQL & WHERES
				SQL = SQL & " AND [GoodIDX] = ?  AND [isDirect] = 'F' AND [strNationCode] = ? AND [DelTF] = 'F' "
				arrParams = Array(_
					Db.makeParam("@orderEa",adInteger,adParamInput,0,ea), _
					Db.makeParam("@Uid",adVarChar,adParamInput,50,cart_id), _
					Db.makeParam("@GoodIDX",adInteger,adParamInput,0,Gidx), _
					Db.makeParam("@strNationCode",adVarChar,adParamInput,6,UCase(DK_MEMBER_NATIONCODE)) _
				)
				Call Db.exec(SQL,DB_TEXT,arrParams,Nothing)
				'Call alerts("이미 장바구니에 존재하는 상품이라 수량 추가 하였습니다.","go","/shop/cart.asp")
				PRINT "{""result"":""success"",""message"":"""&LNG_CS_POPCARTHANDLER_ALERT02&"""}" : Response.End
			Else
				Call Db.beginTrans(Nothing)
				SQL = ""
				SQL = SQL & " INSERT INTO [DK_CART]( "
				SQL = SQL & " [strDomain],[strMemID],[strIDX],[GoodIDX],[strOption],[orderEa],[isShopType],[strShopID],[strNationCode] "
				SQL = SQL & " ) VALUES ( "
				SQL = SQL & " ?,?,?,?,?,?,?,?,?)"
				arrParams = Array( _
					Db.makeParam("@strDomain",adVarChar,adParamInput,50,strHostA), _
					Db.makeParam("@strMemID",adVarChar,adParamInput,20,DK_MEMBER_ID), _
					Db.makeParam("@strIDX",adVarChar,adParamInput,50,DK_MEMBER_IDX), _
					Db.makeParam("@GoodIDX",adInteger,adParamInput,0,Gidx), _
					Db.makeParam("@strOption",adVarChar,adParamInput,512,Gopt), _
					Db.makeParam("@orderEa",adInteger,adParamInput,0,ea), _
					Db.makeParam("@isShopType",adChar,adParamInput,1,isShopType), _
					Db.makeParam("@strShopID",adVarChar,adParamInput,30,strShopID), _
					Db.makeParam("@strNationCode",adVarChar,adParamInput,6,UCase(DK_MEMBER_NATIONCODE)) _
				)
				Call Db.exec(SQL,DB_TEXT,arrParams,Nothing)
				Call Db.finishTrans(Nothing)
				If Err.Number <> 0 Then
					'Call alerts("장바구니 담기중 오류가 발생하였습니다. 지속적인 오류가 발생하시면 관리자에게 문의해주세요","back","")
					PRINT "{""result"":""error"",""message"":"""&LNG_SHOP_CART_JS_CART_ERROR01 & LNG_SHOP_CART_JS_CART_ERROR02&"""}" : Response.End
				Else
					'Call gotoUrl("/shop/cart.asp")
					PRINT "{""result"":""success"",""message"":"""&LNG_CS_CART_AJAX_ALERT04&"""}" : Response.End
				End If
			End If

		Case "EACHG"				'추가 from cart_handler.asp(mob)
			cartIDX	= pRequestTF("cartIDX",True)
			cartEa	= pRequestTF("cartEa",True)
			eaORG	= pRequestTF("eaORG",True)
			gIDX	= pRequestTF("gIDX",True)
			DELICNT	= pRequestTF("DELICNT",True)

			'If cartEa < 1 Then Call ALERTS(LNG_CS_CART_JS08,"back","")
			If cartEa < 1 Then PRINT "{""result"":""error"",""message"":"""&LNG_CS_CART_JS08&"""}" : Response.End
			'1.최소구매수량 확인, 2. 재고비교는 stockCheck()에서 체크
%>
<%
			'##################################################################
			'	배송비처리
			'################################################################## START
				DKRS_orderEa = cartEa
				DKRS_DELICNT = DELICNT

				arrParams = Array(_
					Db.makeParam("@intIDX",adInteger,adParamInput,0,gIDX) _
				)
				Set DKRS = Db.execRs("DKP_GOODS_DETAILVIEW",DB_PROC,arrParams,Nothing)
				If Not DKRS.BOF And Not DKRS.EOF Then
					DKRS_GoodsStockType	= DKRS("GoodsStockType")
					DKRS_GoodsStockNum	= DKRS("GoodsStockNum")
					DKRS_OptionVal	= DKRS("OptionVal")

					DKRS_GoodsPrice	= DKRS("GoodsPrice")
					DKRS_GoodsCustomer	= DKRS("GoodsCustomer")

					DKRS_strShopID	= DKRS("strShopID")
					DKRS_isCSGoods	= DKRS("isCSGoods")
					DKRS_GoodsDeliveryType	= DKRS("GoodsDeliveryType")
					DKRS_GoodsDeliveryFee	= DKRS("GoodsDeliveryFee")

					DKRS_intPriceNot			= DKRS("intPriceNot")
					DKRS_intPriceAuth			= DKRS("intPriceAuth")
					DKRS_intPriceDeal			= DKRS("intPriceDeal")
					DKRS_intPriceVIP			= DKRS("intPriceVIP")

					DKRS_intMinNot			= DKRS("intMinNot")
					DKRS_intMinAuth			= DKRS("intMinAuth")
					DKRS_intMinDeal			= DKRS("intMinDeal")
					DKRS_intMinVIP			= DKRS("intMinVIP")
				End If
				Call closeRs(DKRS)

				Select Case DK_MEMBER_LEVEL
					Case 0,1 '비회원, 일반회원
						DKRS_GoodsPrice = DKRS_intPriceNot
						DKRS_intMinimum = DKRS_intMinNot
					Case 2 '인증회원
						DKRS_GoodsPrice = DKRS_intPriceAuth
						DKRS_intMinimum = DKRS_intMinAuth
					Case 3 '딜러회원
						DKRS_GoodsPrice = DKRS_intPriceDeal
						DKRS_intMinimum = DKRS_intMinDeal
					Case 4,5 'VIP 회원
						DKRS_GoodsPrice = DKRS_intPriceVIP
						DKRS_intMinimum = DKRS_intMinVIP
					Case 9,10,11
						DKRS_GoodsPrice = DKRS_intPriceVIP
						DKRS_intMinimum = DKRS_intMinVIP
				End Select

				'▣ 소비자 가격
				If CONST_CS_SOBIJA_PRICE_USE_TF = "T" Then
					If DK_MEMBER_STYPE = "1" And DKRS_isCSGoods = "T" Then
						DKRS_GoodsPrice = DKRS_GoodsCustomer
					End If
				End If

				If DKRS_OptionVal = "T" Then
					SQL = "SELECT * FROM [DK_GOODS_OPTION] WITH(NOLOCK) WHERE [GoodsIDX] = ? AND [isUse] = 'T' ORDER BY [sort] ASC"
					arrParams = Array(_
						Db.makeParam("@GoodsIDX",adInteger,adParamInput,0,gIDX) _
					)
					arrList = Db.execRsList(SQL,DB_TEXT,arrParams,listLen,Nothing)
					If IsArray(arrList) Then
						PrintOption = ""
						For i = 0 To listLen
							optionItem = Trim(arrList(3,i))
							arrOptItem = Split(optionItem,"\")
							For j = 0 To UBound(arrOptItem)
								optionTxt = Trim(arrOptItem(j))
								optionPay = 0
								arrOptionTxt = Split(optionTxt,":")
								optionTxt = Trim(arrOptionTxt(0))
								If UBound(arrOptionTxt) = 2 Then
									optPrice = Int(arrOptionTxt(1))
								End If
							Next
						Next
					End If
				End If

				'상품별 금액/적립금 확인
				self_GoodsPrice = Int(DKRS_orderEa) * Int(DKRS_GoodsPrice)
				self_TOTAL_PRICE = self_GoodsPrice + optPrice

				If DK_MEMBER_ID <> "" Then
					cart_id = DK_MEMBER_ID
					cart_method = "MEMBER"
				Else
					cart_id = DK_MEMBER_IDX
					cart_method = "NOTMEM"
				End If

				'배송비 확인
					Select Case DKRS_GoodsDeliveryType
						Case "SINGLE"
							self_DeliveryFee = Int(DKRS_orderEa) * Int(DKRS_GoodsDeliveryFee)
							txt_DeliveryFeeType = LNG_SHOP_ORDER_DIRECT_TABLE_08	'단독배송
							txt_self_DeliveryFee = " "&num2cur(self_DeliveryFee)&" "&Chg_currencyISO
							txt_DeliveryFee = "<span class='tweight'>"&txt_DeliveryFeeType& "<br />"&txt_self_DeliveryFee&"</span>"
							'*상품별 배송비
							txt_DeliveryFeeEach = "<span class='deliveryeach'>("&LNG_CS_ORDERS_DELIVERY_PRICE&" "&num2cur(self_DeliveryFee)&" "&Chg_currencyISO&")</span>"

							DKRS_DELICNT = 1

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

							If DKRS_DELICNT > 1 Then
								arrParams3 = Array(_
									Db.makeParam("@cart_method",adVarChar,adParamInput,10,cart_method), _
									Db.makeParam("@MEMTYPE",adVarChar,adParamInput,50,cart_id), _
									Db.makeParam("@strShopID",adVarChar,adParamInput,30,DKRS_strShopID), _
									Db.makeParam("@GoodsDeliveryType",adVarChar,adParamInput,6,DKRS_GoodsDeliveryType) _
								)
								arrList3 = Db.execRsList("DKSP_CART_DELIVERY_CALC",DB_PROC,arrParams3,listLen3,Nothing)
								self_TOTAL_PRICE = 0
								If IsArray(arrList3) Then
									For z = 0 To listLen3
										arrList3_GoodsPrice		= arrList3(0,z)
										arrList3_OrderEa		= arrList3(1,z)
										arrList3_strOption		= arrList3(2,z)

										'내부 옵션 가격 확인
										calc_optionPrice = 0
										arrResult3 = Split(CheckSpace(arrList3_strOption),",")

										For y = 0 To UBound(arrResult3)
											arrOption3 = Split(Trim(arrResult3(y)),"\")
											calc_optionPrice = Int(calc_optionPrice) + Int(arrOption3(1))
										Next
										self_TOTAL_PRICE = self_TOTAL_PRICE + (calc_optionPrice * DKRS_orderEa) + (DKRS_GoodsPrice*DKRS_orderEa)
									Next
								End If
							End If

							If self_TOTAL_PRICE >= DKRS2_intDeliveryFeeLimit Then
								self_DeliveryFee = "0"
								txt_DeliveryFeeType = LNG_SHOP_ORDER_DIRECT_TABLE_10
								txt_self_DeliveryFee = ""
							Else
								self_DeliveryFee = DKRS2_intDeliveryFee
								txt_DeliveryFeeType = ""	'LNG_SHOP_ORDER_DIRECT_TABLE_07	'선결제
								txt_self_DeliveryFee = " "&num2cur(self_DeliveryFee)&" "&Chg_currencyISO
							End If

							If UCase(DK_MEMBER_NATIONCODE) = "KR" Then
								txt_DeliveryFee = "<span class='tweight'>"&txt_DeliveryFeeType&txt_self_DeliveryFee&"</span><br /><span class='deliverytotal'>("&num2cur(DKRS2_intDeliveryFeeLimit)&LNG_SHOP_DETAILVIEW_21&")</span>"
							Else
								txt_DeliveryFee = "<span class='tweight'>"&txt_DeliveryFeeType&txt_self_DeliveryFee&"</span><br /><span class='deliverytotal'>"&LNG_SHOP_DETAILVIEW_21&" <br />("&num2cur(DKRS2_intDeliveryFeeLimit)&" "&Chg_currencyISO&")</span>"
							End If

							'If DKRS_DELICNT = 1 And self_DeliveryFee = "0" Then
							'	txt_DeliveryFee = "<span class='tweight'>"&txt_DeliveryFeeType&"</span>"
							'End If

							'*상품별 배송비
							If self_GoodsPrice >= DKRS2_intDeliveryFeeLimit Then
								txt_DeliveryFeeEach = "<span class='deliveryeach'>("&LNG_SHOP_ORDER_DIRECT_TABLE_10&")</span>"		'무료배송
							Else
								txt_DeliveryFeeEach = "<span class='deliveryeach'>("&LNG_CS_ORDERS_DELIVERY_PRICE&" "&num2cur(DKRS2_intDeliveryFee)&" "&Chg_currencyISO&")</span>"
							End If

					End Select

					txt_DeliveryFeeEach = Replace(txt_DeliveryFeeEach,"(","")
					txt_DeliveryFeeEach = Replace(txt_DeliveryFeeEach,")","")
%>
<%
				'PRINT "{""result"":""error"",""message"":"""&txt_DeliveryFeeEach&"_"&eaORG&"_"&cartEa&"_"&chgStatus&"    ""}" : Response.End

			'갯수변경 로그 (Mob)
			Function Fnc_CART_Compare(ByVal FK_IDX, ByVal COMPARE1, ByVal COMPARE2,  ByVal COMPARETYPE,ByRef RESULT_CNT)
				If COMPARE1 <> COMPARE2 Then

					arrParams = Array(_
						Db.makeParam("@FK_IDX",adInteger,adParamInput,4,FK_IDX), _
						Db.makeParam("@strComName",adVarWChar,adParamInput,100,DK_MEMBER_ID),_
						Db.makeParam("@GoodIDX",adInteger,adParamInput,4,gIDX),_
						Db.makeParam("@strFieldName",adVarChar,adParamInput,50,COMPARETYPE), _
						Db.makeParam("@strFieldORG",adVarWChar,adParamInput,MAX_LENGTH,COMPARE1), _
						Db.makeParam("@strFieldCHG",adVarWChar,adParamInput,MAX_LENGTH,COMPARE2), _
						Db.makeParam("@regID",adVarChar,adParamInput,20,DK_MEMBER_ID), _
						Db.makeParam("@HostIP",adVarChar,adParamInput,20,getUserIP), _
						Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
					)
					Call Db.exec("HJPA_CART_CHG_LOG_INSERT",DB_PROC,arrParams,Nothing)
					OUTPUT_VALUE = arrParams(Ubound(arrParams))(4)
					If OUTPUT_VALUE = "FINISH" Then
						RESULT_CNT = RESULT_CNT
						'PRINT COMPARETYPE
					Else
						RESULT_CNT = RESULT_CNT + 1
					End If

				End If

			End Function
			Call Fnc_CART_Compare(cartIDX,CDbl(eaORG)	,CDbl(cartEa)	,"orderEa_MOB",RESULT_CNT)


			SQL = "UPDATE [DK_CART] SET [orderEa] = ? WHERE [intIDX] = ? AND [DelTF] = 'F' "
			arrParams = Array(_
				Db.makeParam("2cartEa",adInteger,adParaminput,4,cartEa), _
				Db.makeParam("@intIDX",adInteger,adParaminput,4,cartIDX) _
			)
			Call Db.exec(SQL,DB_TEXT,arrParams,Nothing)
			If Err.Number <> 0 Then
				'Call alerts("장바구니 상품 수량변경중 오류가 발생하였습니다. 지속적인 오류가 발생하시면 관리자에게 문의해주세요","back","")
				'Call alerts(LNG_SHOP_CART_JS_CART_ERROR04&LNG_SHOP_CART_JS_CART_ERROR02,"back","")
				PRINT "{""result"":""error"",""message"":"""&LNG_SHOP_CART_JS_CART_ERROR04 & LNG_SHOP_CART_JS_CART_ERROR02&"""}" : Response.End
			Else
				'Call gotoUrl("/m/shop/cart.asp")
				PRINT "{""result"":""success"",""message"":""정상적으로 변경되었습니다."",""message2"":"""&txt_DeliveryFeeEach&"""}" : Response.End
			End If

	End Select

%>
