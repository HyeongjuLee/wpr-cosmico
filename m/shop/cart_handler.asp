<!--#include virtual="/_lib/strFunc.asp" -->
<%
	Call ONLY_MEMBER(DK_MEMBER_LEVEL)

	MODE	= Trim(pRequestTF("mode",True))
	'Call resRW(mode,"Mode")

	' 값 설정
	If DK_MEMBER_ID = "" Then DK_MEMBER_ID = ""

	Select Case MODE
		Case "ADD"
			Gidx	= Trim(pRequestTF("Gidx",False))
			Gopt	= Trim(pRequestTF("goodsOption",False))
			ea		= Trim(pRequestTF("ea",True))
			strShopID = trim(pRequestTF("strShopID",False))
			isShopType = trim(pRequestTF("isShopType",False))
			GoodsDeliveryType = trim(pRequestTF("GoodsDeliveryType",False))
			'Call resRW(Gidx,"Gidx")
			'Call resRW(Gopt,"Gopt")
			'Call resRW(ea,"ea")

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
				Call alerts(LNG_SHOP_CART_JS_NO_DIVIDER,"back","")
			End If

			'*** CartCnt : 장바구니에상품이 있는지cnt → 현재상품 갯수가져오기
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
					Call alerts("최소 구매수량("&DKRS_intMinimum&"보다 재고가("&DKRS_GoodsStockNum&") 부족합니다.","back","")
				End If

				'1.최소구매수량 확인
				If Int(ea) < MIN_ORDERCNT_WITHOUT_CART Then
					'MISSING_EA = (DKRS_intMinimum - All_EA)
					If Int(CartCnt) > 0 Then
						minimumTxt = "\n\n※ 장바구니 합산 수량 : "&All_EA
					End If
					Call alerts(LNG_SHOP_DETAILVIEW_07&minimumTxt,"back","")
				END IF

				'2.재고비교
				If DKRS_GoodsStockType = "N" And DKRS_GoodsStockNum > 0 Then
					If Int(All_EA) > Int(DKRS_GoodsStockNum) Then
						Call alerts(LNG_SHOP_DETAILVIEW_06&" (장바구니 갯수 합산)","back","")
					End If
				End If
			'################################################################## END


			If Int(CartCnt) > 0 Then
				'	Db.makeParam("@strDomain",adVarChar,adParamInput,50,strHostA), _
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
				'Call alerts("이미 등록된 상품입니다.기존 장바구니에서 수량을 추가하였습니다. 장바구니로 이동합니다.","go","/shop/cart.asp")
				Call alerts(LNG_CS_POPCARTHANDLER_ALERT02,"go","/shop/cart.asp")
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
					Call alerts(LNG_SHOP_CART_JS_CART_ERROR01&LNG_SHOP_CART_JS_CART_ERROR02,"back","")
				Else
					Call gotoUrl("/m/shop/cart.asp")
				End If
			End If


		Case "DELTHIS"		'"DELETE"
			cartIDX = pRequestTF("cartIDX",True)

			SQL = " UPDATE [DK_CART] SET [DelTF] = 'T' ,[DeleteDate] = Getdate() WHERE [intIDX] = ?"
			arrParams = Array(_
				Db.makeParam("@intIDX",adInteger,adParaminput,4,cartIDX) _
			)
			Call Db.exec(SQL,DB_TEXT,arrParams,Nothing)
			If Err.Number <> 0 Then
				'Call alerts("장바구니 상품 삭제중 오류가 발생하였습니다. 지속적인 오류가 발생하시면 관리자에게 문의해주세요","back","")
				Call alerts(LNG_SHOP_CART_JS_CART_ERROR03&LNG_SHOP_CART_JS_CART_ERROR02,"back","")
			Else
				Call gotoUrl("/m/shop/cart.asp")
			End If

		Case "EACHG"
			cartIDX	= pRequestTF("cartIDX",True)
			cartEa	= pRequestTF("cartEa",True)
			eaORG	= pRequestTF("eaORG",True)		'▣추가 org
			gIDX	= pRequestTF("gIDX",True)		'▣추가

			If cartEa < 1 Then Call ALERTS(LNG_CS_CART_JS08,"back","")

			'갯수변경 로그 (Mob)2018-10-19
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
				Call alerts(LNG_SHOP_CART_JS_CART_ERROR04&LNG_SHOP_CART_JS_CART_ERROR02,"back","")
			Else
				Call gotoUrl("/m/shop/cart.asp")
			End If

		End Select

%>