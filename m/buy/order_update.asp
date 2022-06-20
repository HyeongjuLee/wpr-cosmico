<!--#include virtual = "/_lib/strFunc.asp"-->
<%

	Session.CodePage = 65001
	Response.CharSet = "UTF-8"
	Response.AddHeader "Pragma","no-cache"
	Response.AddHeader "Expires","0"


	P_UNAME				= Request.Form("P_UNAME")
	strAddr1			= Request.Form("strAddr1")
	strAddr2			= Request.Form("strAddr2")
	strTel				= Request.Form("strTel")
	P_MOBILE			= Request.Form("P_MOBILE")
	P_EMAIL				= Request.Form("P_EMAIL")
	paymethod			= Request.Form("paymethod")
	P_OID				= Request.Form("P_OID")
	P_AMT				= Request.Form("P_AMT")
	LAST_DELIVERY		= Request.Form("LAST_DELIVERY")
	TOTAL_PRICE			= Request.Form("TOTAL_PRICE")
	OIDX				= Request.Form("OIDX")


	If paymethod = "wcard" Then payKind = "card"

'	Response.Write P_UNAME				& "||"
'	Response.Write strAddr1				& "||"
'	Response.Write strAddr2				& "||"
'	Response.Write strTel				& "||"
'	Response.Write P_MOBILE				& "||"
'	Response.Write P_EMAIL				& "||"
'	Response.Write paymethod			& "||"
'	Response.Write P_OID				& "||"
'	Response.Write P_AMT				& "||"
'	Response.Write LAST_DELIVERY		& "||"
'	Response.Write TOTAL_PRICE			& "||"
'	Response.Write paymethod			& "||"

	arrParams = Array(_
		Db.makeParam("@intIDX",adInteger,adParamInput,0,OIDX), _
		Db.makeParam("@OrderNum",adVarChar,adParamInput,20,P_OID), _
		Db.makeParam("@totalPrice",adInteger,adParamInput,0,TOTAL_PRICE), _
		Db.makeParam("@takeName",adVarWChar,adParamInput,100,P_UNAME), _
		Db.makeParam("@takeZip",adVarChar,adParamInput,10,""), _
		Db.makeParam("@takeADDR1",adVarWChar,adParamInput,512,strAddr1), _
		Db.makeParam("@takeADDR2",adVarWChar,adParamInput,512,strAddr2), _
		Db.makeParam("@takeMob",adVarChar,adParamInput,50,P_MOBILE), _
		Db.makeParam("@takeTel",adVarChar,adParamInput,50,strTel), _
		Db.makeParam("@orderType",adVarChar,adParamInput,20,"01"), _
		Db.makeParam("@deliveryFee",adInteger,adParamInput,0,LAST_DELIVERY), _
		Db.makeParam("@payType",adVarChar,adParamInput,20,paymethod), _

		Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
	)
	Call Db.exec("DKP_ORDER_CARD_INFO_UPDATE2",DB_PROC,arrParams,DB3)
	OUTPUT_VALUE = arrParams(Ubound(arrParams))(4)

%>
<%=OUTPUT_VALUE%>