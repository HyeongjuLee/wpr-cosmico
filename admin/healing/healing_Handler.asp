<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<!--#include virtual = "/admin/_inc/document.asp"-->
<%


	mode = pRequestTF("mode",True)


	Select Case mode
		Case "INSERT"
			strNationCode	= pRequestTF("strNationCode",True)

			FK_IDX			= pRequestTF("fIDX",True)
			isView			= pRequestTF("isView",True)
			strSubject		= pRequestTF("strSubject",True)
			strContent		= pRequestTF("strContent",True)

			'base64 문자형 이미지 체크
			If checkDataImages(strContent) Then Call ALERTS("문자형이미지(드래그 이미지)는 사용할 수 없습니다.","back","")

			arrParams = Array( _
				Db.makeParam("@strNationCode",adVarChar,adParamInput,6,strNationCode), _
				Db.makeParam("@FK_IDX",adInteger,adParamInput,4,FK_IDX), _
				Db.makeParam("@isView",adChar,adParamInput,1,isView), _

				Db.makeParam("@strSubject",adVarWChar,adParamInput,30,strSubject), _
				Db.makeParam("@strContent",adVarWChar,adParamInput,MAX_LENGTH,strContent), _

				Db.makeParam("@OUTPUT_VALUE",adVarchar,adParamOutput,20,"ERROR")_
			)
			Call Db.exec("DKSP_HEALING_CONTENT_INSERT",DB_PROC,arrParams,Nothing)
		Case "MODIFY"
			strNationCode	= pRequestTF("strNationCode",True)
			intIDX			= pRequestTF("intIDX",True)

			FK_IDX			= pRequestTF("fIDX",True)
			isView			= pRequestTF("isView",True)
			strSubject		= pRequestTF("strSubject",True)
			strContent		= pRequestTF("strContent",True)

			'base64 문자형 이미지 체크
			If checkDataImages(strContent) Then Call ALERTS("문자형이미지(드래그 이미지)는 사용할 수 없습니다.","back","")

			arrParams = Array( _
				Db.makeParam("@intIDX",adInteger,adParamInput,4,intIDX), _
				Db.makeParam("@FK_IDX",adInteger,adParamInput,4,FK_IDX), _
				Db.makeParam("@isView",adChar,adParamInput,1,isView), _

				Db.makeParam("@strSubject",adVarWChar,adParamInput,30,strSubject), _
				Db.makeParam("@strContent",adVarWChar,adParamInput,MAX_LENGTH,strContent), _
				Db.makeParam("@strNationCode",adVarChar,adParamInput,6,strNationCode), _

				Db.makeParam("@OUTPUT_VALUE",adVarchar,adParamOutput,20,"ERROR")_
			)
			Call Db.exec("DKSP_HEALING_CONTENT_MODIFY",DB_PROC,arrParams,Nothing)
		Case "DELETE"
			intIDX			= pRequestTF("intIDX",True)
			strNationCode	= pRequestTF("strNationCode",True)

			arrParams = Array( _
				Db.makeParam("@intIDX",adInteger,adParamInput,4,intIDX), _
				Db.makeParam("@OUTPUT_VALUE",adVarchar,adParamOutput,20,"")_
			)
			Call Db.exec("DKSP_HEALING_CONTENT_DELETE",DB_PROC,arrParams,Nothing)

		Case "SORTUP"
			intIDX			= pRequestTF("intIDX",True)
			strNationCode	= pRequestTF("strNationCode",True)

			arrParams = Array( _
				Db.makeParam("@intIDX",adInteger,adParamInput,4,intIDX), _
				Db.makeParam("@sortMode",adVarchar,adParamInput,8,"SORTUP"), _
				Db.makeParam("@OUTPUT_VALUE",adVarchar,adParamOutput,20,"ERROR")_

			)
			Call Db.exec("DKSP_HEALING_CONTENT_SORT",DB_PROC,arrParams,Nothing)
			'Call Db.exec("DKPA_SHOP_CATEGORY_SORT",DB_PROC,arrParams,Nothing)
		Case "SORTDOWN"
			intIDX			= pRequestTF("intIDX",True)
			strNationCode	= pRequestTF("strNationCode",True)

			arrParams = Array( _
				Db.makeParam("@intIDX",adInteger,adParamInput,4,intIDX), _
				Db.makeParam("@sortMode",adVarchar,adParamInput,8,"SORTDOWN"), _
				Db.makeParam("@OUTPUT_VALUE",adVarchar,adParamOutput,20,"ERROR")_

			)
			Call Db.exec("DKSP_HEALING_CONTENT_SORT",DB_PROC,arrParams,Nothing)
			'Call Db.exec("DKPA_SHOP_CATEGORY_SORT",DB_PROC,arrParams,Nothing)
	End Select


	OUTPUT_VALUE = arrParams(UBound(arrParams))(4)



	Select Case OUTPUT_VALUE
		Case "ERROR"
			Call alerts("카테고리 수정에 문제가 발생했습니다.","back","")
		Case "NODATA"
			Call alerts("처리할 데이터가 없습니다.","back","")
		Case "BEGIN"
			Call alerts("더이상 올릴 수 없습니다.","back","")
		Case "LAST"
			Call alerts("더이상 내릴 수 없습니다.","back","")
		Case "FINISH"
			Call alerts("처리되었습니다.","GO","healing_list.asp?nc="&strNationCode)
	End Select
%>
