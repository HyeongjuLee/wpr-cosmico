<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<!--#include virtual = "/admin/_inc/document.asp"-->
<%

	MODE = pRequestTF("mode",True)




	Select Case MODE
		Case "CANCEL"
			intIDX = pRequestTF("intIDX",True)
			CancelCause = pRequestTF("CancelCause",False)


			arrParams = Array(_
				Db.makeParam("@intIDX",adInteger,adParamInput,0,intIDX),_
				Db.makeParam("@CancelCause",adVarChar,adParamInput,800,CancelCause) ,_

				Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
			)
'			Call Db.exec("DKPA_ORDER_CANCEL",DB_PROC,arrParams,Nothing)
			Call Db.exec("DKPA_ORDER_CANCEL2",DB_PROC,arrParams,Nothing)

			OUTPUT_VALUE = arrParams(UBound(arrParams))(4)
		Case "UCANCEL"
			intIDX = pRequestTF("intIDX",True)


			arrParams = Array(_
				Db.makeParam("@intIDX",adInteger,adParamInput,0,intIDX),_

				Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
			)
			Call Db.exec("DKP_ORDER_CANCEL_ADMIN_U",DB_PROC,arrParams,Nothing)

			OUTPUT_VALUE = arrParams(UBound(arrParams))(4)

		Case Else : PRINT "Undefined"
	End Select



	Select Case OUTPUT_VALUE
		Case "ERROR" : Call ALERTS(DBERROR,"back","")
		Case "FINISH" : Call ALERTS(DBFINISH,"o_reloada","")
		Case Else : PRINT "Undefined"
	End Select
	Call ResRW(intIDX,"intIDX")
	Call ResRW(CancelCause,"CancelCause")

%>
