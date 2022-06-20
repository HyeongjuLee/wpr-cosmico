<!--#include virtual = "/_lib/strFunc.asp"-->
<!--#include virtual="/_include/document.asp" -->
</head>
<body>
<%


	Call ONLY_MEMBER(DK_MEMBER_LEVEL)
	mode	= Trim(pRequestTF("mode",True))								'detailView : ADD

	Gidx	= Trim(pRequestTF("Gidx",False))							'detailView : ADD
	Gopt	= Trim(pRequestTF("goodsOption",False))				'detailView : 빈값
	ea		= Trim(pRequestTF("ea",True))									'detailView : ADD
	'uidx	= Trim(pRequestTF("uidx",False))							'"DEL","MODIFY"		cart_del?  XXX			cartMod.asp?
	cuidx	= Trim(pRequestTF("cuidx",False))							'"DELALL"  delAll(   )
	suidx	= trim(pRequestTF("chkCart",False))						'"SELDEL"		selDEl(   )  , thisDel( 상품직접삭제, mode="SELDEL" )  = cartDel(모바일상품직접삭제, mode="DELETE")

	strShopID = trim(pRequestTF("strShopID",False))			'detailView  : ADD
	isShopType = trim(pRequestTF("isShopType",False))		'detailView  : ADD
	GoodsDeliveryType = trim(pRequestTF("GoodsDeliveryType",False))	'detailView  : ADD


'	Call resRW(mode,"Mode")
'	Call resRW(Gidx,"Gidx")
'	Call resRW(Gopt,"Gopt")
'	Call resRW(ea,"ea")
'	Call resRW(DK_MEMBER_ID,"세션아이디")
'	Call resRW(DK_MEMBER_IDX,"세션고유값")
'	Call resRW(strHostA,"호스트")
'	Call resRW(uidx,"삭제고유값")
'	Call resRW(cuidx,"삭제고유값")
'	Call resRW(suidx,"삭제고유값")


	' 값 설정
	If DK_MEMBER_ID = "" Then DK_MEMBER_ID = ""
	If Gopt = ""  Then Gopt = ""


	If mode = "ADD" Then					'detailView : ADD
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

			If DKRS_GoodsStockType = "N" And DKRS_GoodsStockNum > 0 Then
				If (Int(CartCnt) + Int(ea)) > Int(DKRS_GoodsStockNum) Then
					Call alerts(LNG_SHOP_DETAILVIEW_06&" (장바구니 갯수 합산)","back","")
				End If
			End If

			'	Db.makeParam("@strDomain",adVarChar,adParamInput,50,strHostA), _
			SQL = "UPDATE [DK_CART] SET [orderEa] = [orderEa] + ? "
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
				Call alerts(LNG_SHOP_CART_JS_CART_ERROR01 & LNG_SHOP_CART_JS_CART_ERROR02,"back","")
			Else
				Call gotoUrl("/shop/cart.asp")
			End If
		End If
	ElseIf mode = "MODIFY"	Then
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
			Call alerts(LNG_SHOP_CART_JS_CART_ERROR04 & LNG_SHOP_CART_JS_CART_ERROR02,"back","")
		Else
			Call alerts("","o_relaod","")
		End If
	ElseIf mode = "DELALL" Then
		arrUidx = Split(cuidx,",")
		intResult = 0
		For i = 0 To UBound(arrUIDX)
			If intResult = 0 Then
				Call Db.beginTrans(Nothing)
			''	SQL =  "DELETE FROM [DK_CART] WHERE [intIDX] = ?"
				SQL = " UPDATE [DK_CART] SET [DelTF] = 'T' ,[DeleteDate] = Getdate() WHERE [intIDX] = ?"			'◆Cart DelTF(2018-09-18)
				arrParams = Array(_
					Db.makeParam("@intIDX",adInteger,adParaminput,0,Trim(arrUidx(i))) _
				)
				Call Db.exec(SQL,DB_TEXT,arrParams,Nothing)
				Call Db.finishTrans(Nothing)
			Else
				'Call alerts("장바구니 삭제중 오류가 발생하였습니다. 지속적인 오류가 발생하시면 관리자에게 문의해주세요","back","")
				Call alerts(LNG_SHOP_CART_JS_CART_ERROR03 & LNG_SHOP_CART_JS_CART_ERROR02,"back","")
				Set DB = Nothing
				Response.End
			End If
		Next
		If Err.Number = 0 Then Call gotoUrl("/shop/cart.asp")

	ElseIf mode = "SELDEL" Then						' PC 선택상품 및, 현재상품 삭제	, 모바일(DELETE)
		delIdx	= trim(pRequestTF("delIdx",False))
		If delIdx <> "" Then suidx = delIdx

		arrUidx = Split(suidx,",")
		intResult = 0
		For i = 0 To UBound(arrUIDX)
			If intResult = 0 Then
				Call Db.beginTrans(Nothing)
			''	SQL =  "DELETE FROM [DK_CART] WHERE [intIDX] = ?"
				SQL = " UPDATE [DK_CART] SET [DelTF] = 'T' ,[DeleteDate] = Getdate() WHERE [intIDX] = ?"			'◆Cart DelTF(2018-09-18)
				arrParams = Array(_
					Db.makeParam("@intIDX",adInteger,adParaminput,0,Trim(arrUidx(i))) _
				)
				Call Db.exec(SQL,DB_TEXT,arrParams,Nothing)
				Call Db.finishTrans(Nothing)
			Else
				'Call alerts("장바구니 삭제중 오류가 발생하였습니다. 지속적인 오류가 발생하시면 관리자에게 문의해주세요","back","")
				Call alerts(LNG_SHOP_CART_JS_CART_ERROR03 & LNG_SHOP_CART_JS_CART_ERROR02,"back","")
				Set DB = Nothing
				Response.End
			End If
		Next
		If Err.Number = 0 Then Call gotoUrl("/shop/cart.asp")


	ElseIf mode = "DEL" Then			'DELETE (delIdx) 이용하자)
		Call Db.beginTrans(Nothing)
	''	SQL =  "DELETE FROM [DK_CART] WHERE [intIDX] = ?"
		SQL = " UPDATE [DK_CART] SET [DelTF] = 'T' ,[DeleteDate] = Getdate() WHERE [intIDX] = ?"			'◆Cart DelTF(2018-09-18)
		arrParams = Array(_
			Db.makeParam("@intIDX",adInteger,adParaminput,0,Uidx) _
		)
		Call Db.exec(SQL,DB_TEXT,arrParams,Nothing)
		If Err.Number <> 0 Then
			'Call alerts("장바구니 담기중 오류가 발생하였습니다. 지속적인 오류가 발생하시면 관리자에게 문의해주세요","back","")
			Call alerts(LNG_SHOP_CART_JS_CART_ERROR01 & LNG_SHOP_CART_JS_CART_ERROR02,"back","")
		Else
			Call gotoUrl("/shop/cart.asp")
		End If

	End If

'Call ResRw(intResult,"처리결과")

%>
