<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	Call ONLY_MEMBER(DK_MEMBER_LEVEL)


	intIDX	= pRequestTF("intIDX",True)
	mode	= pRequestTF("mode",True)

	FINISH_URL = Request.ServerVariables("HTTP_REFERER")

	Select Case mode
		Case "DELETE"
			arrParams = Array(_
				Db.makeParam("@intIDX",adInteger,adParamInput,0,intIDX),_
				Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
			)
			Call Db.exec("DKP_SCRAP_DELETE",DB_PROC,arrParams,Nothing)

			OUTPUT_VALUE = arrParams(UBound(arrParams))(4)

	End Select


	Select Case OUTPUT_VALUE
		Case "ERROR" : Call ALERTS("처리중 에러가 발생하였습니다.","BACK","")
		Case "FINISH" :	Call ALERTS("처리되었습니다.","GO",FINISH_URL)
	End Select

%>
