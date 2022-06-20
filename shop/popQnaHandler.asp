<!--#include virtual = "/_lib/strFunc.asp"-->
<%

	Call Only_Member(DK_MEMBER_LEVEL)

	goodsIDX		= pRequestTF("goodsIDX",True)
	strSubject		= pRequestTF("strSubject",True)
	strQuestion		= pRequestTF("strQuestion",True)
	strType			= pRequestTF("strType",True)


	arrParams = Array(_
		Db.makeParam("@GoodsIDX",adInteger,adParamInput,0,goodsIDX),_
		Db.makeParam("@strDomain",adVarChar,adParamInput,50,strHostA), _
		Db.makeParam("@strUserID",adVarChar,adParamInput,20,DK_MEMBER_ID), _
		Db.makeParam("@strType",adVarChar,adParamInput,50,strType), _
		Db.makeParam("@strSubject",adVarChar,adParamInput,100,strSubject), _
		Db.makeParam("@strQuestion",adVarChar,adParamInput,4000,strQuestion), _
		Db.makeParam("@hostIP",adVarChar,adParamInput,4000,getUserIP()), _
		Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
	)
	Call Db.exec("DKP_GOODS_QNA_WRITE",DB_PROC,arrParams,Nothing)

	OUTPUT_VALUE = arrParams(UBound(arrParams))(4)

	'print OUTPUT_VALUE
	Select Case OUTPUT_VALUE
		Case "ERROR"	: Call ALERTS("데이터베이스 연결 중 오류가 발생하였습니다.새로고침 후 다시 시도해주세요.","back","")
		Case "FINISH"	: Call ALERTS("입력되었습니다.","o_reloadA","")
	End Select



%>
