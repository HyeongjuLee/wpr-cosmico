<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	Call ONLY_CS_MEMBER()


	Session.CodePage = 65001
	Response.CharSet = "UTF-8"
	Response.AddHeader "Pragma","no-cache"
	Response.AddHeader "Expires","0"

	mode	= Request.form("modes")
	eavalue = Request.form("eavalue")
	idvalue = Request.form("idvalue")

	mid1 = Request.form("mid1")
	mid2 = Request.form("mid2")


'	Response.write eavalue &" "
'	Response.write mode &" "
'	Response.write mid1 &" "
'	Response.write mid2 &" "
'	Response.write idvalue
'Response.end

	If Not IsNumeric(eavalue) Then
		'Response.write "수량이 숫자가 아닙니다. 장바구니에 담기지 않았습니다"
		Response.write LNG_CS_CART_AJAX_ALERT01
		Response.End
	End If

	Select Case LCase(MODE)
		Case "regist"
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
		Case "modify"
			arrParams = Array(_
				Db.makeParam("@MBID",adVarChar,adParamInput,20,DK_MEMBER_ID1),_
				Db.makeParam("@MBID2",adInteger,adParamInput,0,DK_MEMBER_ID2),_
				Db.makeParam("@NCODE",adVarChar,adParamInput,20,idvalue),_
				Db.makeParam("@EA",adInteger,adParamInput,4,eavalue), _
				Db.makeParam("@DOWN_MBID",adVarChar,adParamInput,20,mid1),_
				Db.makeParam("@DOWN_MBID2",adInteger,adParamInput,0,mid2),_
				Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
			)
			Call Db.exec("HJP_CART4DOWN_MODIFY",DB_PROC,arrParams,DB3)
			OUTPUT_VALUE = arrParams(UBound(arrParams))(4)
		Case "delete"
			arrParams = Array(_
				Db.makeParam("@MBID",adVarChar,adParamInput,20,DK_MEMBER_ID1),_
				Db.makeParam("@MBID2",adInteger,adParamInput,0,DK_MEMBER_ID2),_
				Db.makeParam("@NCODE",adVarChar,adParamInput,20,idvalue),_
				Db.makeParam("@DOWN_MBID",adVarChar,adParamInput,20,mid1),_
				Db.makeParam("@DOWN_MBID2",adInteger,adParamInput,0,mid2),_
				Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
			)
			Call Db.exec("HJP_CART4DOWN_DELETE",DB_PROC,arrParams,DB3)
			OUTPUT_VALUE = arrParams(UBound(arrParams))(4)
		Case Else
			OUTPUT_VALUE = "MODE HANDLER EMPTY"
	End Select

	Select Case OUTPUT_VALUE
		Case "ERROR"
			Response.WRITE DBERROR
			Response.End
		Case "FINISH"
			'Response.WRITE "수량값 변경이 "&DBFINISH
			Response.WRITE LNG_CS_CART_AJAX_ALERT02
			Response.End
		Case "FINISH2"
			'Response.WRITE "이미 장바구니에 존재하는 상품이라 수량 추가 하였습니다"
			Response.WRITE LNG_CS_CART_AJAX_ALERT03
			Response.End
		Case "FINISH3"
			'Response.WRITE "장바구니에 없는 물품이라 장바구니에 추가하였습니다."
			Response.WRITE LNG_CS_CART_AJAX_ALERT04
			Response.End
		Case Else
			'Response.WRITE "에러가 발생하였습니다. 코드 - "&OUTPUT_VALUE
			Response.WRITE LNG_CS_CART_AJAX_ALERT05 & OUTPUT_VALUE
			Response.End
	End Select


%>