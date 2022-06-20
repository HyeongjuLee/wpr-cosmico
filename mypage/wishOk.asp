<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	Call ONLY_MEMBER(DK_MEMBER_LEVEL)

	pT = gRequestTF("pt",False)
	If pt = "" Then pt = ""

	If pT = "shop" Then
		PAGE_SETTING = "SHOP_MYPAGE"
		ptshop = "?pt=shop"
	Else
		PAGE_SETTING = "MYPAGE"
		ptshop = ""
	End If

	mode = Trim(pRequestTF("mode",False))
	Gidx = Trim(pRequestTF("Gidx",False))
	Gopt = Trim(pRequestTF("goodsOption",False))
	uidx = Trim(pRequestTF("uidx",False))
	cuidx = Trim(pRequestTF("cuidx",False))
	suidx = trim(pRequestTF("chkCart",False))

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


	Select Case mode
'==================================================================================================
		Case "DELALL"
			Call Db.beginTrans(Nothing)
				SQL = "DELETE FROM [DK_WISHLIST] WHERE [strUserID] = ?"
				arrParams = Array(_
					Db.makeParam("@strMemID",adVarChar,adParamInput,30,DK_MEMBER_ID) _
				)
				Call Db.exec(SQL,DB_TEXT,arrParams,Nothing)
			Call Db.finishTrans(Nothing)
			If Err.Number = 0 Then
				Call alerts(LNG_SHOP_ORDER_WISHLIST_JS05,"go","wish_list.asp"&ptshop)
			Else
				Call alerts(LNG_SHOP_ORDER_WISHLIST_JS06,"back","")
			End If
'==================================================================================================
		Case "SELDEL"
			arrUidx = Split(suidx,",")
			Call Db.beginTrans(Nothing)
				For i = 0 To UBound(arrUIDX)
					SQL =  "DELETE FROM [DK_WISHLIST] WHERE [intIDX] = ?"
					arrParams = Array(_
						Db.makeParam("@intIDX",adInteger,adParaminput,0,Trim(arrUidx(i))) _
					)
					Call Db.exec(SQL,DB_TEXT,arrParams,Nothing)
				Next
			Call Db.finishTrans(Nothing)
			If Err.Number = 0 Then Call gotoUrl("wish_list.asp")
'==================================================================================================
		Case "DEL"
			Call Db.beginTrans(Nothing)
				SQL = "DELETE FROM [DK_WISHLIST] WHERE [intIDX] = ? AND [strUserID] = ?"
				arrParams = Array(_
					Db.makeParam("@intIDX",adInteger,adParaminput,0,uidx), _
					Db.makeParam("@strMemID",adVarChar,adParaminput,30,DK_MEMBER_ID) _
				)
				Call Db.exec(SQL,DB_TEXT,arrParams,Nothing)
			Call Db.finishTrans(Nothing)
			If Err.Number = 0 Then
				Call alerts(LNG_SHOP_ORDER_WISHLIST_JS07,"go","wish_list.asp"&ptshop)

			Else
				Call alerts(LNG_SHOP_ORDER_WISHLIST_JS06,"back","")
			End If
'==================================================================================================
		Case "CART"
			If ea < 1 Or ea = "" Then ea = 1
			If Gopt = ""  Then Gopt = ""
			arrUidx = Split(cuidx,",")
			Call Db.beginTrans(Nothing)
				For i = 0 To UBound(arrUIDX)
					SQL = "SELECT [goodsIDX] FROM [DK_WISHLIST] WHERE [intIDX] = ?"
					arrParams = Array(_
						Db.makeParam("@intIDX",adInteger,adParamInput,0,Trim(arrUidx(i))) _
					)
					GoodsIDX = Db.execRsData(SQL,DB_TEXT,arrParams,Nothing)

					SQL = ""
					SQL = SQL & " INSERT INTO [DK_CART]( "
					SQL = SQL & " [strDomain],[strMemID],[strIDX],[GoodIDX],[strOption],[orderEa] "
					SQL = SQL & " ) VALUES ( "
					SQL = SQL & " ?,?,?,?,?,?)"
					arrParams = Array( _
						Db.makeParam("@strDomain",adVarChar,adParamInput,50,strHostA), _
						Db.makeParam("@strMemID",adVarChar,adParamInput,20,DK_MEMBER_ID), _
						Db.makeParam("@strIDX",adVarChar,adParamInput,50,DK_MEMBER_IDX), _
						Db.makeParam("@GoodIDX",adInteger,adParamInput,0,GoodsIDX), _
						Db.makeParam("@strOption",adVarChar,adParamInput,512,Gopt), _
						Db.makeParam("@orderEa",adInteger,adParamInput,0,ea) _
					)
					Call Db.exec(SQL,DB_TEXT,arrParams,Nothing)
					'print arrUidx(i)

				Next
			Call Db.finishTrans(Nothing)
			If Err.Number = 0 Then Call gotoUrl("/shop/cart.asp")



'==================================================================================================
		Case Else : Call alerts(LNG_SHOP_ORDER_WISHLIST_JS08,"back","")
	End Select





%>
