<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	'strHostA 조건 삭제 : 같은회원아이디로 같은 상품 주문지 strHostA가 다를 경우(www, 127,) 장바구니에 따로 저장됨.

	Response.CharSet = "UTF-8"
	Response.AddHeader "Pragma","no-cache"
	Response.AddHeader "Expires","0"

	If DK_MEMBER_LEVEL < 1 Then Response.End

	MODE	= Trim(pRequestTF_JSON("mode",True))

	' 값 설정
	If DK_MEMBER_ID = "" Then DK_MEMBER_ID = ""
	If Gopt = ""  Then Gopt = ""

Select Case MODE
  Case "ADD","CHANGE"     	'장바구니 수량변경 추가 CHANGE   , EACHG
		Gidx	= Trim(pRequestTF_JSON("Gidx",False))
		Gopt	= Trim(pRequestTF_JSON("goodsOption",False))
		ea		= Trim(pRequestTF_JSON("ea",True))
		'uidx	= Trim(pRequestTF_JSON("uidx",False))
		'cuidx	= Trim(pRequestTF_JSON("cuidx",False))
		'suidx	= trim(pRequestTF_JSON("chkCart",False))

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


		'*** CartCnt : 장바구니에상품이 있는지cnt → 현재상품 갯수가져오기
		'	Db.makeParam("@strDomain",adVarChar,adParamInput,50,strHostA), _
		'SQL = "SELECT COUNT([intIDX]) "

		SQL = "SELECT [orderEa] "
		SQL = SQL & " FROM [DK_CART] WITH (NOLOCK) "
		SQL = SQL & WHERES
		'SQL = SQL & " AND [strDomain] = ? "
		SQL = SQL & " AND [GoodIDX] = ? "
		SQL = SQL & " AND [strOption] = ? AND [isDirect] = 'F' AND [strNationCode] = ? AND [DelTF] = 'F' "		'◆Cart DelTF(2018-09-18)
		arrParams = Array(_
			Db.makeParam("@Uid",adVarChar,adParamInput,50,cart_id), _

			Db.makeParam("@GoodIDX",adInteger,adParamInput,0,Gidx), _
			Db.makeParam("@strOption",adVarChar,adParamInput,512,Gopt) ,_
			Db.makeParam("@strNationCode",adVarChar,adParamInput,6,UCase(DK_MEMBER_NATIONCODE)) _

		)
		CartCnt = Db.execRsData(SQL,DB_TEXT,arrParams,Nothing)

		If Int(CartCnt) > 0 Then
			'* 이미 담긴 장바구니 수량과(CartCnt)
			'  현재 주문갯수를(ea) 합쳐서 (CartCnt + ea)
			'  재고량과 비교하는 부분 추가해야함.

			arrParams = Array(_
				Db.makeParam("@intIDX",adInteger,adParamInput,0,Gidx) _
			)
			Set DKRS = Db.execRs("DKP_GOODS_DETAILVIEW",DB_PROC,arrParams,Nothing)
			If Not DKRS.BOF And Not DKRS.EOF Then
				DKRS_GoodsStockType	= DKRS("GoodsStockType")
				DKRS_GoodsStockNum	= DKRS("GoodsStockNum")
			End If
			Call closeRs(DKRS)

			If mode = "CHANGE" Then
				All_EA = Int(ea)
			Else
				All_EA = Int(CartCnt) + Int(ea)
			End If

			If DKRS_GoodsStockType = "N" And DKRS_GoodsStockNum > 0 Then
				If (All_EA) > Int(DKRS_GoodsStockNum) Then
					PRINT "{""result"":""error"",""message"":"""&LNG_SHOP_DETAILVIEW_06&" (장바구니 갯수 합산)""}" : Response.End
					'PRINT "{""result"":""error"",""message"":"""&LNG_SHOP_DETAILVIEW_06&"_"&CartCnt&"_"&ea&"_"&DKRS_GoodsStockNum&"""}" : Response.End
				End If
			End If

			'	Db.makeParam("@strDomain",adVarChar,adParamInput,50,strHostA), _
			If mode = "CHANGE" Then		'장바구니 수량 변경
				SQL = "UPDATE [DK_CART] SET [orderEa] =  ? "
				LNG_CS_POPCARTHANDLER_ALERT02 = "수량이 변경되었습니다~~~"
			Else
				SQL = "UPDATE [DK_CART] SET [orderEa] = [orderEa] + ? "
			End If
			SQL = SQL & WHERES
			'SQL = SQL & " AND [strDomain] = ? "
			SQL = SQL & " AND [GoodIDX] = ?  AND [isDirect] = 'F' AND [strNationCode] = ? AND [DelTF] = 'F' "	'◆Cart DelTF(2018-09-18)
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

	Case "MODIFY"
		Gopt	= Trim(pRequestTF_JSON("goodsOption",False))
		ea		= Trim(pRequestTF_JSON("ea",True))
		uidx	= Trim(pRequestTF_JSON("uidx",False))

		If ea < 1 Or ea = "" Then ea = 1
		SQL = " UPDATE [DK_CART] SET [strOption] = ? ,[orderEa] = ? WHERE [intIDX] = ? AND [DelTF] = 'F' "		'◆Cart DelTF(2018-09-18)
		arrParams = Array( _
			Db.makeParam("@strOption",adVarChar,adParamInput,512,Gopt), _
			Db.makeParam("@orderEa",adInteger,adParamInput,0,ea), _
			Db.makeParam("@uidx",adInteger,adParamInput,0,uidx) _
		)
		Call Db.exec(SQL,DB_TEXT,arrParams,Nothing)
		Call Db.finishTrans(Nothing)
		If Err.Number <> 0 Then
			'Call alerts("주문수정 중 오류가 발생하였습니다. 지속적인 오류가 발생하시면 관리자에게 문의해주세요","back","")
			PRINT "{""result"":""error"",""message"":"""&LNG_SHOP_CART_JS_CART_ERROR04 & LNG_SHOP_CART_JS_CART_ERROR02&"""}" : Response.End

		Else
			'Call alerts("","o_relaod","")
			PRINT "{""result"":""success"",""message"":"""&LNG_CS_CART_AJAX_ALERT02&"""}" : Response.End
		End If

	Case "DELALL"
		cuidx	= Trim(pRequestTF_JSON("cuidx",False))

		arrUidx = Split(cuidx,",")
		intResult = 0
		For i = 0 To UBound(arrUIDX)
			If intResult = 0 Then
				Call Db.beginTrans(Nothing)
				SQL = " UPDATE [DK_CART] SET [DelTF] = 'T' ,[DeleteDate] = Getdate() WHERE [intIDX] = ?"			'◆Cart DelTF(2018-09-18)
				arrParams = Array(_
					Db.makeParam("@intIDX",adInteger,adParaminput,0,Trim(arrUidx(i))) _
				)
				Call Db.exec(SQL,DB_TEXT,arrParams,Nothing)
				Call Db.finishTrans(Nothing)
			Else
				'Call alerts("장바구니 삭제중 오류가 발생하였습니다. 지속적인 오류가 발생하시면 관리자에게 문의해주세요","back","")
				PRINT "{""result"":""error"",""message"":"""&LNG_SHOP_CART_JS_CART_ERROR03 & LNG_SHOP_CART_JS_CART_ERROR02&"""}" : Response.End
				Set DB = Nothing
				Response.End
			End If
		Next
		'If Err.Number = 0 Then Call gotoUrl("/shop/cart.asp")
		If Err.Number = 0 Then PRINT "{""result"":""success"",""message"":""정상적으로 삭제처리되었습니다.""}" : Response.End

	Case "SELDEL"
		suidx	= trim(pRequestTF_JSON("chkCart",False))

		arrUidx = Split(suidx,",")
		intResult = 0
		For i = 0 To UBound(arrUIDX)
			If intResult = 0 Then
				Call Db.beginTrans(Nothing)
				SQL = " UPDATE [DK_CART] SET [DelTF] = 'T' ,[DeleteDate] = Getdate() WHERE [intIDX] = ?"			'◆Cart DelTF(2018-09-18)
				arrParams = Array(_
					Db.makeParam("@intIDX",adInteger,adParaminput,0,Trim(arrUidx(i))) _
				)
				Call Db.exec(SQL,DB_TEXT,arrParams,Nothing)
				Call Db.finishTrans(Nothing)
			Else
				'Call alerts("장바구니 삭제중 오류가 발생하였습니다. 지속적인 오류가 발생하시면 관리자에게 문의해주세요","back","")
				PRINT "{""result"":""error"",""message"":"""&LNG_SHOP_CART_JS_CART_ERROR03 & LNG_SHOP_CART_JS_CART_ERROR02&"""}" : Response.End

				Set DB = Nothing
				Response.End
			End If
		Next
		'If Err.Number = 0 Then Call gotoUrl("/shop/cart.asp")
		If Err.Number = 0 Then PRINT "{""result"":""success"",""message"":""정상적으로 삭제처리되었습니다.""}" : Response.End

	Case "DEL"
		Uidx	= Trim(pRequestTF_JSON("uidx",False))

		Call Db.beginTrans(Nothing)
		SQL = " UPDATE [DK_CART] SET [DelTF] = 'T' ,[DeleteDate] = Getdate() WHERE [intIDX] = ?"			'◆Cart DelTF(2018-09-18)
		arrParams = Array(_
			Db.makeParam("@intIDX",adInteger,adParaminput,0,Uidx) _
		)
		Call Db.exec(SQL,DB_TEXT,arrParams,Nothing)
		If Err.Number <> 0 Then
			'Call alerts("장바구니 담기중 오류가 발생하였습니다. 지속적인 오류가 발생하시면 관리자에게 문의해주세요","back","")
			PRINT "{""result"":""error"",""message"":"""&LNG_SHOP_CART_JS_CART_ERROR01 & LNG_SHOP_CART_JS_CART_ERROR02&"""}" : Response.End
		Else
			'Call gotoUrl("/shop/cart.asp")
			PRINT "{""result"":""success"",""message"":""정상적으로 삭제처리되었습니다.""}" : Response.End
		End If




	Case "EACHG"				'추가 from cart_handler.asp(mob)
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

		SQL = "UPDATE [DK_CART] SET [orderEa] = ? WHERE [intIDX] = ? AND [DelTF] = 'F' "			'◆Cart DelTF(2018-09-18)
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
			PRINT "{""result"":""success"",""message"":""정상적으로 변경되었습니다.""}" : Response.End
		End If



	End Select





%>
