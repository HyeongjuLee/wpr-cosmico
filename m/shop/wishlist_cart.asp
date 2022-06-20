<!--#include virtual="/_lib/strFunc.asp" -->
<%

	'한글
		Session.CodePage = 65001
		Response.CharSet = "UTF-8"
		Response.AddHeader "Pragma","no-cache"
		Response.AddHeader "Expires","0"



		Gopt = Trim(pRequestTF("goodsOption",False))
		uidx = Trim(pRequestTF("uidx",False))
		cuidx = Trim(pRequestTF("cuidx",False))
		suidx = trim(pRequestTF("chkCart",False))



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

				SQL = "SELECT COUNT([intIDX]) "
				SQL = SQL & " FROM [DK_CART] "
				SQL = SQL & " WHERE [strMemID] = ? "
				SQL = SQL & " AND [GoodIDX] = ? "
				SQL = SQL & " AND [strOption] = ? AND [isDirect] = 'F'"
				arrParams = Array(_
					Db.makeParam("@Uid",adVarChar,adParamInput,50,DK_MEMBER_ID), _
					Db.makeParam("@GoodIDX",adInteger,adParamInput,0,GoodsIDX), _
					Db.makeParam("@strOption",adVarChar,adParamInput,512,Gopt) _

				)
				CartCnt = Db.execRsData(SQL,DB_TEXT,arrParams,Nothing)
				'PRINT CARTCNT

				If Int(CartCnt) > 0 Then
					SQL = "UPDATE [DK_CART] SET [orderEa] = [orderEa] + ? "
					SQL = SQL & " WHERE [strMemID] = ? "
					SQL = SQL & " AND [strDomain] = ? "
					SQL = SQL & " AND [GoodIDX] = ?  AND [isDirect] = 'F'"
					arrParams = Array(_
						Db.makeParam("@orderEa",adInteger,adParamInput,0,ea), _
						Db.makeParam("@Uid",adVarChar,adParamInput,50,DK_MEMBER_ID), _
						Db.makeParam("@strDomain",adVarChar,adParamInput,50,strHostA), _
						Db.makeParam("@GoodIDX",adInteger,adParamInput,0,GoodsIDX) _

					)
					Call Db.exec(SQL,DB_TEXT,arrParams,Nothing)
				Else
					SQL = ""
					SQL = SQL & " INSERT INTO [DK_CART]( "
					SQL = SQL & " [strDomain],[strMemID],[GoodIDX],[strOption],[orderEa] "
					SQL = SQL & " ) VALUES ( "
					SQL = SQL & " ?,?,?,?,?)"
					arrParams = Array( _
						Db.makeParam("@strDomain",adVarChar,adParamInput,50,strHostA), _
						Db.makeParam("@strMemID",adVarChar,adParamInput,20,DK_MEMBER_ID), _
						Db.makeParam("@GoodIDX",adInteger,adParamInput,0,GoodsIDX), _
						Db.makeParam("@strOption",adVarChar,adParamInput,512,Gopt), _
						Db.makeParam("@orderEa",adInteger,adParamInput,0,ea) _
					)
					Call Db.exec(SQL,DB_TEXT,arrParams,Nothing)
				End If

			Next
		Call Db.finishTrans(Nothing)
		If Err.Number = 0 Then Call gotoUrl("cart.asp")


%>