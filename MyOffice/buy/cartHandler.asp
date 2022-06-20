<!--#include virtual = "/_lib/strFunc.asp"-->
<!--#include virtual = "/_include/document.asp"-->
<%

	Call ONLY_CS_MEMBER()

	ncode = pRequestTF("ncode",False)
	mode  = pRequestTF("mode",True)



'	PRINT ncode
'	PRINT mode


	Select Case MODE
		Case "SELDEL"
			chkCart = pRequestTF("chkCart",True)
			arrChkCart = Split(chkCart,",")
			For i = 0 To UBound(arrChkCart)
				arrParams = Array(_
					Db.makeParam("@MBID",adVarChar,adParamInput,20,DK_MEMBER_ID1),_
					Db.makeParam("@MBID2",adInteger,adParamInput,0,DK_MEMBER_ID2),_
					Db.makeParam("@intIDX",adInteger,adParamInput,0,Trim(arrChkCart(i))),_
					Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
				)
				Call Db.exec("DKP_CART_SELDEL",DB_PROC,arrParams,DB3)
				OUTPUT_VALUE = arrParams(UBound(arrParams))(4)

				If OUTPUT_VALUE = "ERROR" Then
					ThisChkCart = arrChkCart(i)
					Exit For
				End If
			Next
			Select Case OUTPUT_VALUE
				'Case "ERROR" : Call ALERTS(ThisChkCart&"번의 삭제 중 오류가 발생하였습니다.새로고침 후 다시 시도해주세요.","back","")
				Case "ERROR" : Call ALERTS(LNG_CS_CARTHANDLER_ALERT01,"back","")
				Case "FINISH" : Call ALERTS(DBFINISH,"go","cart.asp")
				Case Else : PRINT OUTPUT_VALUE
			End Select

		Case "DELALL"
			arrParams = Array(_
				Db.makeParam("@MBID",adVarChar,adParamInput,20,DK_MEMBER_ID1),_
				Db.makeParam("@MBID2",adInteger,adParamInput,0,DK_MEMBER_ID2),_
				Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
			)
			Call Db.exec("DKP_CART_DELALL",DB_PROC,arrParams,DB3)
			OUTPUT_VALUE = arrParams(UBound(arrParams))(4)
	End Select


	Select Case OUTPUT_VALUE
		Case "ERROR" : Call ALERTS(DBERROR,"BACK","")
		Case "FINISH" : Call ALERTS(DBFINISH,"go","cart.asp")
		Case Else : PRINT OUTPUT_VALUE 'Call ALERTS(DBUNDEFINED,"BACK","")
	End Select



%>
