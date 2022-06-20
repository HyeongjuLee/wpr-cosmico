<!--#include virtual="/_lib/strFunc.asp" -->
<%

	'한글
		Session.CodePage = 65001
		Response.CharSet = "UTF-8"
		Response.AddHeader "Pragma","no-cache"
		Response.AddHeader "Expires","0"


		goodsIDX = Request.form("cartIDX")



		Call Db.beginTrans(Nothing)
			SQL = "DELETE FROM [DK_WISHLIST] WHERE [intIDX] = ? AND [strUserID] = ?"
			arrParams = Array(_
				Db.makeParam("@intIDX",adInteger,adParaminput,0,goodsIDX), _
				Db.makeParam("@strMemID",adVarChar,adParaminput,30,DK_MEMBER_ID) _
			)
			Call Db.exec(SQL,DB_TEXT,arrParams,Nothing)
		Call Db.finishTrans(Nothing)
		If Err.Number = 0 Then
			'Call alerts("삭제되었습니다","go","wishlist.asp")
			Call alerts(LNG_SHOP_ORDER_WISHLIST_JS07,"go","wishlist.asp")
		Else
			'Call alerts("삭제중 오류가 발생하였습니다.","back","")
			Call alerts(LNG_SHOP_ORDER_WISHLIST_JS06,"back","")
		End If


%>