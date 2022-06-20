<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<!--#include virtual = "/admin/_inc/document.asp"-->
<%
	Call noCache



	mode = pRequestTF("mode",True)


'	Function upImgInfo(ByVal keys,ByVal ThPath1,ByRef imgWidth, ByRef imgHeight)


	Select Case MODE
		Case "INSERT"
			strTag				= pRequestTF("strTag",False)
			If strTag = "" Then strTag = ""


			arrParams = Array(_
				Db.makeParam("@strTag",adVarWChar,adParamInput,400,strTag), _

				Db.makeParam("@regID",adVarChar,adParamInput,20,DK_MEMBER_ID), _
				Db.makeParam("@regIP",adVarChar,adParamInput,30,getUserIP()), _

				Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
			)

			Call Db.exec("DKP_DESIGN_TAG_INSERT_ADMIN",DB_PROC,arrParams,Nothing)

			OUTPUT_VALUE = arrParams(Ubound(arrParams))(4)

		Case Else : Call ALERTS("모드값이 올바르지 않습니다.","BACK","")
	End Select


	Select Case OUTPUT_VALUE
		Case "ERROR"	: Call ALERTS(DBERROR,"BACK","")
		Case "FINISH"	: Call ALERTS(DBFINISH,"GO","tag.asp")
		Case Else		: Call ALERTS(DBUNDEFINED,"BACK","")
	End Select
%>



