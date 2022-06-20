<!--#include virtual = "/_lib/strFunc.asp"-->
<!--#include virtual = "/_include/document.asp"-->
<%
	Call ONLY_CS_MEMBER()

	ea	  = pRequestTF("ea",True)
	ncode = pRequestTF("ncode",True)
	mid1  = pRequestTF("mid1",True)		'하선구매
	mid2  = pRequestTF("mid2",True)		'하선구매

	If Not IsNumeric(ea) Then Call ALERTS("수량이 숫자가 아닙니다","BACK","")

	arrParams = Array(_
		Db.makeParam("@MBID",adVarChar,adParamInput,20,DK_MEMBER_ID1),_
		Db.makeParam("@MBID2",adInteger,adParamInput,0,DK_MEMBER_ID2),_
		Db.makeParam("@NCODE",adVarChar,adParamInput,20,NCODE),_
		Db.makeParam("@EA",adInteger,adParamInput,0,EA), _
		Db.makeParam("@DOWN_MBID",adVarChar,adParamInput,20,mid1),_
		Db.makeParam("@DOWN_MBID2",adInteger,adParamInput,0,mid2),_
		Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
	)
	Call Db.exec("HJP_CART4DOWN_INSERT",DB_PROC,arrParams,DB3)
	OUTPUT_VALUE = arrParams(UBound(arrParams))(4)


	Select Case OUTPUT_VALUE
		Case "ERROR" : Call ALERTS(DBERROR,"BACK","")
		'Case "FINISH" : Call ALERTS(DBFINISH,"CLOSE","")
		Case "FINISH" : Call ALERTS(DBFINISH,"o_reload_go","/myoffice/buy/cart_4_downMember.asp?mid1="&mid1&"&mid2="&mid2)
		Case "FINISH2" : Call ALERTS(LNG_CS_POPCARTHANDLER_ALERT02,"CLOSE","")
		'Case "FINISH2" : Call ALERTS("이미 장바구니에 존재하는 상품이라 수량 추가 하였습니다","CLOSE","")
		Case Else : PRINT OUTPUT_VALUE 'Call ALERTS(DBUNDEFINED,"BACK","")
	End Select



%>
