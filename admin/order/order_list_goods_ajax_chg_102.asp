<!--#include virtual="/_lib/strFunc.asp" -->
<%

	'한글
		Session.CodePage = 65001
		Response.CharSet = "UTF-8"
		Response.AddHeader "Pragma","no-cache"
		Response.AddHeader "Expires","0"

		intIDX = pRequestTF_AJAX("intIDX",True)


		arrParams = Array(_
			Db.makeParam("@intIDX",adInteger,adParamInput,4,intIDX), _
			Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"MISS") _
		)
		Call Db.exec("DKP_CHK_ORDER_103",DB_PROC,arrParams,Nothing)
		OUTPUT_VALUE = arrParams(Ubound(arrParams))(4)

		If OUTPUT_VALUE <> "OK" Then


		Else


		End If

%>