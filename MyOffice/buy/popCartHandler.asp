<!--#include virtual = "/_lib/strFunc.asp"-->
<!--#include virtual = "/_include/document.asp"-->
<%
	Call ONLY_CS_MEMBER()

	ea = pRequestTF("ea",True)
	ncode = pRequestTF("ncode",True)

	If Not IsNumeric(ea) Then Call ALERTS("수량이 숫자가 아닙니다","BACK","")

	arrParams = Array(_
		Db.makeParam("@MBID",adVarChar,adParamInput,20,DK_MEMBER_ID1),_
		Db.makeParam("@MBID2",adInteger,adParamInput,0,DK_MEMBER_ID2),_
		Db.makeParam("@NCODE",adVarChar,adParamInput,20,NCODE),_
		Db.makeParam("@EA",adInteger,adParamInput,0,EA), _
		Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
	)
	Call Db.exec("DKP_CART_INSERT",DB_PROC,arrParams,DB3)
	OUTPUT_VALUE = arrParams(UBound(arrParams))(4)


	Select Case OUTPUT_VALUE
		Case "ERROR" : Call ALERTS(DBERROR,"BACK","")
		'Case "FINISH" : Call ALERTS(DBFINISH,"CLOSE","")
		Case "FINISH" : Call ALERTS(DBFINISH,"o_reload_go","/myoffice/buy/cart.asp")
		Case "FINISH2" : Call ALERTS(LNG_CS_POPCARTHANDLER_ALERT02,"CLOSE","")
		'Case "FINISH2" : Call ALERTS("이미 장바구니에 존재하는 상품이라 수량 추가 하였습니다","CLOSE","")
		Case Else : PRINT OUTPUT_VALUE 'Call ALERTS(DBUNDEFINED,"BACK","")
	End Select



%>
