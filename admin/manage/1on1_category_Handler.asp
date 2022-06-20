<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<!--#include virtual = "/admin/_inc/document.asp"-->
<%
	mode = pRequestTF("mode",True)


	Select Case mode
		Case "INSERT"
			'strNationCode	= pRequestTF("strNationCode",True)
			strNationCode	= viewAdminLangCode
			strCateName		= pRequestTF("strCateName",True)
			strCateParent	= pRequestTF("strCateParent",True)
			intCateDepth	= pRequestTF("intCateDepth",True)
			isView			= pRequestTF("isView",True)
			strBaseText		= pRequestTF("strBaseText",False)

			arrParams = Array( _
				Db.makeParam("@strNationCode",adVarChar,adParamInput,6,strNationCode), _
				Db.makeParam("@strCateName",adVarWChar,adParamInput,100,strCateName), _
				Db.makeParam("@strCateParent",adVarChar,adParamInput,20,strCateParent), _
				Db.makeParam("@intCateDepth",adInteger,adParamInput,4,int(intCateDepth)), _

				Db.makeParam("@isView",adChar,adParamInput,1,isView), _

				Db.makeParam("@strBaseText",adVarWChar,adParamInput,2000,strBaseText), _


				Db.makeParam("@OUTPUT_VALUE",adVarchar,adParamOutput,20,"ERROR")_
			)
			Call Db.exec("[DKSP_COUNSEL_1ON1_CATEGORY_INSERT]",DB_PROC,arrParams,Nothing)
		Case "UPDATE"
			strCateCode		= pRequestTF("strCateCode",True)
			strCateParent	= pRequestTF("strCateParent",True)

			strCateName		= pRequestTF("strCateName",True)
			isView			= pRequestTF("isView",True)

			strBaseText		= pRequestTF("strBaseText",False)
			strNationCode	= viewAdminLangCode


			arrParams = Array( _
				Db.makeParam("@strNationCode",adVarChar,adParamInput,6,strNationCode), _
				Db.makeParam("@CateCode",adVarchar,adParamInput,20,strCateCode), _

				Db.makeParam("@strCateName",adVarWChar,adParamInput,100,strCateName), _
				Db.makeParam("@isView",adChar,adParamInput,1,isView), _

				Db.makeParam("@strBaseText",adVarWChar,adParamInput,2000,strBaseText), _

				Db.makeParam("@OUTPUT_VALUE",adVarchar,adParamOutput,20,"")_
			)
			Call Db.exec("[DKSP_COUNSEL_1ON1_CATEGORY_UPDATE]",DB_PROC,arrParams,Nothing)
		Case "DELETE"
			strCateCode		= pRequestTF("strCateCode",True)
			strCateParent	= pRequestTF("strCateParent",True)
			strNationCode	= viewAdminLangCode

			arrParams = Array( _
				Db.makeParam("@strNationCode",adVarChar,adParamInput,6,strNationCode), _
				Db.makeParam("@CateCode",adVarchar,adParamInput,20,strCateCode), _
				Db.makeParam("@OUTPUT_VALUE",adVarchar,adParamOutput,20,"")_

			)
			Call Db.exec("DKSP_COUNSEL_1ON1_CATEGORY_DELETE",DB_PROC,arrParams,Nothing)


		Case "SORTUP"
			strCateCode		= pRequestTF("strCateCode",True)
			strCateParent	= pRequestTF("strCateParent",True)
			strNationCode	= viewAdminLangCode

			arrParams = Array( _
				Db.makeParam("@strNationCode",adVarChar,adParamInput,6,strNationCode), _
				Db.makeParam("@sortMode",adVarchar,adParamInput,8,"SORTUP"), _
				Db.makeParam("@CateCode",adVarchar,adParamInput,20,strCateCode), _
				Db.makeParam("@OUTPUT_VALUE",adVarchar,adParamOutput,20,"ERROR")_

			)
			Call Db.exec("[DKSP_COUNSEL_1ON1_CATEGORY_SORT]",DB_PROC,arrParams,Nothing)
			'Call Db.exec("DKPA_SHOP_CATEGORY_SORT",DB_PROC,arrParams,Nothing)
		Case "SORTDOWN"
			strCateCode		= pRequestTF("strCateCode",True)
			strCateParent	= pRequestTF("strCateParent",True)
			strNationCode	= viewAdminLangCode

			arrParams = Array( _
				Db.makeParam("@strNationCode",adVarChar,adParamInput,6,strNationCode), _
				Db.makeParam("@sortMode",adVarchar,adParamInput,8,"SORTDOWN"), _
				Db.makeParam("@CateCode",adVarchar,adParamInput,20,strCateCode), _
				Db.makeParam("@OUTPUT_VALUE",adVarchar,adParamOutput,20,"ERROR")_

			)
			Call Db.exec("[DKSP_COUNSEL_1ON1_CATEGORY_SORT]",DB_PROC,arrParams,Nothing)
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
		Call alerts("정상처리되었습니다","go","1on1_category.asp")
	End Select
%>
