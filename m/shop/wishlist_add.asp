<!--#include virtual="/_lib/strFunc.asp" -->
<%

	'한글
		Session.CodePage = 65001
		Response.CharSet = "UTF-8"
		Response.AddHeader "Pragma","no-cache"
		Response.AddHeader "Expires","0"


		goodsIDX = Request.form("goodsIDX")



		SQL = "SELECT COUNT(*) FROM [DK_WISHLIST] WHERE [goodsIDX] = ? AND [strUserID] = ?"
		arrParams = Array(_
			Db.makeParam("@goodsIDX",adInteger,adParamInput,0,goodsIDX), _
			Db.makeParam("@strUserID",adVarChar,adParamInput,20,DK_MEMBER_ID) _
		)
		WishCnt = Db.execRsData(SQL,DB_TEXT,arrParams,Nothing)

		If cInt(WishCnt) > 0 Then
			Response.Write "ALREADY"
			Response.End
		Else

			Call Db.beginTrans(Nothing)


			SQL = "INSERT INTO [DK_WISHLIST]([strDomain],[strUserID],[goodsIDX]) VALUES (?,?,?)"
			arrParams = Array(_
				Db.makeParam("@strDomain",adVarChar,adParamInput,50,strHostA), _
				Db.makeParam("@strUserID",adVarChar,adParamInput,30,DK_MEMBER_ID), _
				Db.makeParam("@goodsIDX",adInteger,adParamInput,4,goodsIDX) _
			)
			Call Db.exec(SQL,DB_TEXT,arrParams,Nothing)
			Call Db.finishTrans(Nothing)

			If Err.Number = 0 Then
				Response.Write "ADD"
				Response.End
			Else
				Response.Write "ERROR"
				Response.End
			End If

		End If


%>