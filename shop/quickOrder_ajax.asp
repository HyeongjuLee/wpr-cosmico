<!--#include virtual = "/_lib/strFunc.asp"-->
<!--#include virtual = "/_lib/json2.asp" -->

<%



	Call ONLY_MEMBER(DK_MEMBER_LEVEL)

	mode	= Trim(pRequestTF_JSON("mode",True))
	cuidx	= Trim(pRequestTF_JSON("cuidx",True))
	ea		= Trim(pRequestTF_JSON("ea",True))
 	Gidx  = cuidx
  Gopt = ""
  strShopID = ""
  isShopType = ""
  GoodsDeliveryType = ""

	arrGidx = Split(Gidx,",")
	arrEA	= Split(ea,",")
	ALL_IDENTITIES = ""

	If DK_MEMBER_ID = "" Then DK_MEMBER_ID = ""

	Call Db.beginTrans(Nothing)
	For i = 0 To UBound(arrGidx)

		If arrEA(i) < 1 Or arrEA(i) = "" Then arrEA(i) = 1

		SQL_I = "SELECT [GoodsDeliveryType],[isShopType],[strShopID],[GoodsStockType],[GoodsStockNum] FROM [DK_GOODS] WITH(NOLOCK) "
		SQL_I = SQL_I & " WHERE [intIDX] = ? AND [delTF] = 'F' AND [GoodsViewTF] = 'T' AND [isAccept] = 'T' "
		arrParams = Array(_
			Db.makeParam("@intIDX",adInteger,adParamInput,0,arrGidx(i)) _
		)
		Set DKRS = Db.execRs(SQL_I,DB_TEXT,arrParams,Nothing)
		If Not DKRS.BOF And Not DKRS.EOF Then
			arrRS_GoodsDeliveryType	= DKRS("GoodsDeliveryType")
			arrRS_isShopType = DKRS("isShopType")
			arrRS_strShopID = DKRS("strShopID")
			arrRS_GoodsStockType = DKRS("GoodsStockType")
			arrRS_GoodsStockNum = DKRS("GoodsStockNum")

			Select Case arrRS_GoodsStockType
				Case "N" '수량
					If CDbl(CStr(arrRS_GoodsStockNum)) < CDbl(CStr(arrEA(i))) Then
						PRINT "{""result"":""error"",""message"":"""&LNG_SHOP_DETAILVIEW_06&"""}" : Call Db.finishTrans(Nothing) : Response.End
					End If
				Case "I" '무제한
				Case "S" '품절
					PRINT "{""result"":""error"",""message"":"""&LNG_SHOP_DETAILVIEW_04&"""}" : Call Db.finishTrans(Nothing) : Response.End

				Case Else
					PRINT "{""result"":""error"",""message"":"""&LNG_JS_INVALID_DATA&"""}" : Call Db.finishTrans(Nothing) : Response.End
			End Select

		Else
			PRINT "{""result"":""error"",""message"":"""&LNG_SHOP_DETAILVIEW_01&"""}" : Call Db.finishTrans(Nothing) : Response.End
		End If
		Call closeRs(DKRS)

		Gidx = arrGidx(i)
		ea = arrEA(i)
		isShopType = arrRS_isShopType
		strShopID = arrRS_strShopID

		isDirect = ""
		Select Case UCase(mode)
			Case "Q_CART"
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
						PRINT "{""result"":""error"",""message"":"""&LNG_SHOP_CART_JS_NO_DIVIDER&"""}" : Call Db.finishTrans(Nothing) : Response.End
					End If

					SQL = "SELECT COUNT([intIDX]) "
					SQL = SQL & " FROM [DK_CART] WITH (NOLOCK) "
					SQL = SQL & WHERES
					SQL = SQL & " AND [strDomain] = ? "
					SQL = SQL & " AND [GoodIDX] = ? "
					SQL = SQL & " AND [strOption] = ? AND [isDirect] = 'F' AND [strNationCode] = ? AND [DelTF] = 'F' "
					arrParams = Array(_
						Db.makeParam("@Uid",adVarChar,adParamInput,50,cart_id), _
						Db.makeParam("@strDomain",adVarChar,adParamInput,50,strHostA), _
						Db.makeParam("@GoodIDX",adInteger,adParamInput,0,Gidx), _
						Db.makeParam("@strOption",adVarChar,adParamInput,512,Gopt) ,_
						Db.makeParam("@strNationCode",adVarChar,adParamInput,6,UCase(DK_MEMBER_NATIONCODE)) _
					)
					CartCnt = Db.execRsData(SQL,DB_TEXT,arrParams,Nothing)

					ALREADY_CART_CNT = 0
					If Int(CartCnt) > 0 Then
						SQL = "UPDATE [DK_CART] SET [orderEa] = [orderEa] + ? "
						SQL = SQL & WHERES
						SQL = SQL & " AND [strDomain] = ? "
						SQL = SQL & " AND [GoodIDX] = ?  AND [isDirect] = 'F' AND [strNationCode] = ? AND [DelTF] = 'F' "
						arrParams = Array(_
							Db.makeParam("@orderEa",adInteger,adParamInput,0,ea), _
							Db.makeParam("@Uid",adVarChar,adParamInput,50,cart_id), _
							Db.makeParam("@strDomain",adVarChar,adParamInput,50,strHostA), _
							Db.makeParam("@GoodIDX",adInteger,adParamInput,0,Gidx), _
							Db.makeParam("@strNationCode",adVarChar,adParamInput,6,UCase(DK_MEMBER_NATIONCODE)) _
						)
						Call Db.exec(SQL,DB_TEXT,arrParams,Nothing)
						ALREADY_CART_CNT = ALREADY_CART_CNT + 1
					Else
						isDirect = "F"
					End If

			Case "Q_ORDER"
					isDirect = "Q"

		End Select

		If isDirect = "F" Or isDirect = "Q" Then		'F(Cart), Q(빠른주문)


			arrParams = Array( _
				Db.makeParam("@strDomain",adVarChar,adParamInput,50,strHostA), _
				Db.makeParam("@strMemID",adVarChar,adParamInput,20,DK_MEMBER_ID), _
				Db.makeParam("@strIDX",adVarChar,adParamInput,50,DK_SES_MEMBER_IDX), _
				Db.makeParam("@GoodIDX",adInteger,adParamInput,0,Gidx), _
				Db.makeParam("@strOption",adVarChar,adParamInput,512,Gopt), _
				Db.makeParam("@orderEa",adInteger,adParamInput,0,ea), _
				Db.makeParam("@isShopType",adChar,adParamInput,1,isShopType), _
				Db.makeParam("@strShopID",adVarChar,adParamInput,30,strShopID), _
				Db.makeParam("@isDirect",adChar,adParamInput,1,isDirect), _
				Db.makeParam("@strNationCode",adVarChar,adParamInput,6,UCase(DK_MEMBER_NATIONCODE)), _
				Db.makeParam("@IDENTITY",adInteger,adParamOutput,4,0) _
			)
			Call Db.exec("DKSP_CART_DIRECT",DB_PROC,arrParams,Nothing)
			IDENTITY = arrParams(Ubound(arrParams))(4)

			If i = 0 Then
				ALL_IDENTITIES = IDENTITY
			Else
				ALL_IDENTITIES = ALL_IDENTITIES &","&IDENTITY
			End If

		End If

	Next

	Call Db.finishTrans(Nothing)
	If Err.Number <> 0 Then
		PRINT "{""result"":""error"",""message"":"""&LNG_SHOP_CART_JS_CART_ERROR01 & LNG_SHOP_CART_JS_CART_ERROR02&"""}" : Response.End
	End If

	If UCase(mode) = "Q_ORDER" Then
		PRINT "{""result"":""success"",""cuidx"":"""&ALL_IDENTITIES&"""}" : Call Db.finishTrans(Nothing) : Response.End
	Else
		If ALREADY_CART_CNT > 0 Then
			PRINT "{""result"":""success"",""message"":""선택한 상품중 이미 등록된 상품은 수량을 추가하였습니다.\n장바구니로 이동하시겠습니까?""}" : Response.End
		ElSe
			PRINT "{""result"":""success"",""message"":""선택한 상품이 장바구니에 저장되었습니다.\n장바구니로 이동하시겠습니까?""}" : Response.End
		End If
	End If
%>
