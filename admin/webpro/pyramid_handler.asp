<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<!--#include virtual = "/admin/_inc/document.asp"-->
<%
	ADMIN_LEFT_MODE = "WEBPRO"
	INFO_MODE = "WEBPRO1-1"


	MODE			= pRequestTF("mode",True)


	Select Case MODE
		Case "REGIST"
			intCate			= pRequestTF("intCate",True)
			strAticle		= pRequestTF("strAticle",True)
			strSubject		= pRequestTF("strSubject",True)
			strContent		= pRequestTF("strContent",True)

			'base64 문자형 이미지 체크
			If checkDataImages(strContent) Then Call ALERTS("문자형이미지(드래그 이미지)는 사용할 수 없습니다.","back","")

			'Response.write Len(strContent)


			arrParams = Array(_
				Db.makeParam("@intCate",adInteger,adParamInput,4,intCate), _
				Db.makeParam("@strAticle",adVarWChar,adParamInput,30,strAticle), _
				Db.makeParam("@strSubject",adVarWChar,adParamInput,200,strSubject), _
				Db.makeParam("@strContent",adVarWChar,adParamInput,Len(strContent),strContent), _
				Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
			)
			Call Db.exec("DKPA_PYRAMID_INSERT",DB_PROC,arrParams,Nothing)
			OUTPUT_VALUE = arrParams(Ubound(arrParams))(4)
			GO_URL = "pyramid_regist.asp"
		Case "MODIFY"
			intIDX			= pRequestTF("intIDX",True)
			intCate			= pRequestTF("intCate",True)
			strAticle		= pRequestTF("strAticle",True)
			strSubject		= pRequestTF("strSubject",True)
			strContent		= pRequestTF("strContent",True)

			'base64 문자형 이미지 체크
			If checkDataImages(strContent) Then Call ALERTS("문자형이미지(드래그 이미지)는 사용할 수 없습니다.","back","")

			'Response.write Len(strContent)


			arrParams = Array(_
				Db.makeParam("@intIDX",adInteger,adParamInput,4,intIDX), _
				Db.makeParam("@intCate",adInteger,adParamInput,4,intCate), _
				Db.makeParam("@strAticle",adVarWChar,adParamInput,30,strAticle), _
				Db.makeParam("@strSubject",adVarWChar,adParamInput,200,strSubject), _
				Db.makeParam("@strContent",adVarWChar,adParamInput,Len(strContent),strContent), _
				Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
			)
			Call Db.exec("DKPA_PYRAMID_MODIFY",DB_PROC,arrParams,Nothing)
			OUTPUT_VALUE = arrParams(Ubound(arrParams))(4)
			GO_URL = "pyramid_modify.asp?view="&intIDX
		Case "DELETE"
			intIDX			= pRequestTF("intIDX",True)
			intCate			= pRequestTF("intCate",True)
			arrParams = Array(_
				Db.makeParam("@intIDX",adInteger,adParamInput,4,intIDX), _
				Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
			)
			Call Db.exec("DKPA_PYRAMID_DELETE",DB_PROC,arrParams,Nothing)
			OUTPUT_VALUE = arrParams(Ubound(arrParams))(4)
			GO_URL = "pyramid.asp?cate="&intCate
		Case "SORTUP"

			intIDX			= pRequestTF("intIDX",True)
			intCate			= pRequestTF("intCate",True)

			arrParams = Array( _
				Db.makeParam("@sortMode",adVarchar,adParamInput,8,"SORTUP"), _
				Db.makeParam("@intIDX",adInteger,adParamInput,4,intIDX), _
				Db.makeParam("@OUTPUT_VALUE",adVarchar,adParamOutput,20,"ERROR")_

			)
			Call Db.exec("DKP_PYRAMID_SORT",DB_PROC,arrParams,Nothing)
			OUTPUT_VALUE = arrParams(Ubound(arrParams))(4)
			GO_URL = "pyramid.asp?cate="&intCate
		Case "SORTDOWN"
			intIDX			= pRequestTF("intIDX",True)
			intCate			= pRequestTF("intCate",True)

			arrParams = Array( _
				Db.makeParam("@sortMode",adVarchar,adParamInput,8,"SORTDOWN"), _
				Db.makeParam("@intIDX",adInteger,adParamInput,4,intIDX), _
				Db.makeParam("@OUTPUT_VALUE",adVarchar,adParamOutput,20,"ERROR")_

			)
			Call Db.exec("DKP_PYRAMID_SORT",DB_PROC,arrParams,Nothing)
			OUTPUT_VALUE = arrParams(Ubound(arrParams))(4)
			GO_URL = "pyramid.asp?cate="&intCate



		Case Else : Call ALERTS("모드가 올바르지 않습니다.","BACK","")
	End Select

	Select Case OUTPUT_VALUE
		Case "ERROR"	: Call ALERTS(DBERROR,"BACK","")
		Case "FINISH"	: Call ALERTS(DBFINISH,"GO",GO_URL)
		Case Else		: Call ALERTS(DBUNDEFINED,"BACK","")
	End Select

%>