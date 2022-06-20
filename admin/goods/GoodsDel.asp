<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<!--#include virtual = "/admin/_inc/document.asp"-->
<%

	intIDX = gRequestTF("gIDX",True)

	'strNationCode = Request("nc")
	strNationCode = viewAdminLangCode


	arrParams = Array(_
		Db.makeParam("@strNationCode",adVarChar,adParamInput,6,strNationCode),_
		Db.makeParam("@intIDX",adInteger,adParamInput,0,intIDX), _
		Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
	)
	Call Db.exec("DKPA_GOODS_DELETE",DB_PROC,arrParams,Nothing)
	OUTPUT_VALUE = arrParams(UBound(arrParams))(4)


	Select Case OUTPUT_VALUE
		Case "ERROR" : Call ALERTS(DBERROR,"BACK","")
		Case "FINISH" : Call ALERTS(DBFINISH,"go","goods_list.asp?nc="&strNationCode)
		Case "ALREADY" : Call ALERTS("이미 삭제된 상품입니다.","BACK","")
		Case Else : Call ALERTS(DBUNDEFINED,"BACK","")
	End Select

%>
