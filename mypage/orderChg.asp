<!--#include virtual = "/_lib/strFunc.asp"-->
<%

	Response.CharSet = "UTF-8"
	Response.AddHeader "Pragma","no-cache"
	Response.AddHeader "Expires","0"


	orderNum = pRequestTF("orderNum",True)
	mode = pRequestTF("mode",True)



	Select Case UCase(MODE)
		Case "FINISH"
			arrParams = Array(_
				Db.makeParam("@orderNum",adVarChar,adParamInput,20,orderNum), _
				Db.makeParam("@strUserID",adVarChar,adParamInput,20,DK_MEMBER_ID), _
				Db.makeParam("@regIP",adVarChar,adParamInput,30,getUserIP), _

				Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,11,"ERROR") _
			)
			Call Db.exec("DKP_ORDER_FINISH",DB_PROC,arrParams,Nothing)
			OUTPUT_VALUE = arrParams(Ubound(arrParams))(4)
			Response.Write OUTPUT_VALUE
	End Select



'	Select Case UCase(MODE)
'		Case "FINISH"
'			arrParams = Array(_
'				Db.makeParam("@orderNum",adVarChar,adParamInput,20,orderNum), _
'				Db.makeParam("@strUserID",adVarChar,adParamInput,20,DK_MEMBER_ID), _
'				Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,11,"ERROR") _
'			)
'			Call Db.exec("DKP2_ORDER_FINISH",DB_PROC,arrParams,Nothing)
'			OUTPUT_VALUE = arrParams(Ubound(arrParams))(4)
'			Response.Write OUTPUT_VALUE
'	End Select





%>
