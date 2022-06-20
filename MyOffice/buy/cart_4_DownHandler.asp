<!--#include virtual = "/_lib/strFunc.asp"-->
<!--#include virtual = "/_include/document.asp"-->
<%

	Call ONLY_CS_MEMBER()
	Call ONLY_BUSINESS(BUSINESS_CODE)				'센타장전용

	ncode = pRequestTF("ncode",False)
	mode  = pRequestTF("mode",True)

	mid1  = pRequestTF("DownMemID1",True)
	mid2  = pRequestTF("DownMemID2",True)



'	PRINT ncode
'	PRINT mode
'	PRINT DownMemID1
'	PRINT DownMemID2
'	Response.end



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
				Call Db.exec("HJP_CART4DOWN_SELDEL",DB_PROC,arrParams,DB3)
				OUTPUT_VALUE = arrParams(UBound(arrParams))(4)

				If OUTPUT_VALUE = "ERROR" Then
					ThisChkCart = arrChkCart(i)
					Exit For
				End If
			Next

		Case "DELALL"
			arrParams = Array(_
				Db.makeParam("@MBID",adVarChar,adParamInput,20,DK_MEMBER_ID1),_
				Db.makeParam("@MBID2",adInteger,adParamInput,0,DK_MEMBER_ID2),_
				Db.makeParam("@DOWN_MBID",adVarChar,adParamInput,20,mid1),_
				Db.makeParam("@DOWN_MBID2",adInteger,adParamInput,0,mid2),_
				Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
			)
			Call Db.exec("HJP_CART4DOWN_DELALL",DB_PROC,arrParams,DB3)
			OUTPUT_VALUE = arrParams(UBound(arrParams))(4)
	End Select


	Select Case OUTPUT_VALUE
		Case "ERROR" : Call ALERTS(DBERROR,"BACK","")
		Case "FINISH" : Call ALERTS(DBFINISH,"go","/myoffice/buy/cart_4_downMember.asp?mid1="&mid1&"&mid2="&mid2)
		Case Else : PRINT OUTPUT_VALUE 'Call ALERTS(DBUNDEFINED,"BACK","")
	End Select



%>
