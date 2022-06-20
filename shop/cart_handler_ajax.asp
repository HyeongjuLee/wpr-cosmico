<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	Response.CharSet = "UTF-8"
	Response.AddHeader "Pragma","no-cache"
	Response.AddHeader "Expires","0"

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

	End Select

%>
