<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<!--#include virtual = "/admin/_inc/document.asp"-->
<%
	ADMIN_LEFT_MODE = "WEBPRO"
	INFO_MODE = "WEBPRO1-1"



	intCate			= pRequestTF("intCate",True)
	strAticle		= pRequestTF("strAticle",True)
	strSubject		= pRequestTF("strSubject",True)
	strContent		= pRequestTF("strContent",True)




	arrParams = Array(_
		Db.makeParam("@intCate",adInteger,adParamInput,4,intCate), _
		Db.makeParam("@strAticle",adVarWChar,adParamInput,30,strAticle), _
		Db.makeParam("@strSubject",adVarWChar,adParamInput,200,strSubject), _
		Db.makeParam("@strContent",adVarWChar,adParamInput,Len(strContent),strContent), _
		Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
	)
	Call Db.exec("DKPA_PYRAMID_INSERT",DB_PROC,arrParams,Nothing)
	OUTPUT_VALUE = arrParams(Ubound(arrParams))(4)



	Select Case OUTPUT_VALUE
		Case "ERROR"	: Call ALRETS(DBERROR,"BACK","")
		Case "FINISH"	: Call ALRETS(DBFINISH,"GO","pyramid.asp")
		Case Else		: Call ALERTS(DBUNDEFINED,"BACK","")
	End Select

%>