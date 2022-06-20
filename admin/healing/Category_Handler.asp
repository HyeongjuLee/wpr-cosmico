<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<!--#include virtual = "/admin/_inc/document.asp"-->
<%

	MaxFileAbort = 2 * 1024 * 1024 ' 최대파일 크기 업로드 거부(각 파일 별 공통 사항 / 하단의 파일 업로드 사이즈중 가장 큰 값으로 설정)
	MaxDataSize1 = 2 * 1024 * 1024 ' 실제 Data1의 업로드 시킬 파일 사이즈



	mode = pRequestTF("mode",True)





	Select Case mode
		Case "INSERT"
			strNationCode	= pRequestTF("strNationCode",True)
			strTitle		= pRequestTF("strTitle",True)
			isView			= pRequestTF("isView",True)

			arrParams = Array( _
				Db.makeParam("@strNationCode",adVarChar,adParamInput,6,strNationCode), _
				Db.makeParam("@strCateName",adVarWChar,adParamInput,30,strTitle), _
				Db.makeParam("@isView",adChar,adParamInput,1,isView), _

				Db.makeParam("@OUTPUT_VALUE",adVarchar,adParamOutput,20,"ERROR")_
			)
			Call Db.exec("DKSP_HEALING_CATE_INSERT",DB_PROC,arrParams,Nothing)
		Case "UPDATE"
			intIDX			= pRequestTF("intIDX",True)
			isView			= pRequestTF("isView",True)
			strTitle		= pRequestTF("strTitle",True)
			strNationCode	= pRequestTF("strNationCode",True)

			arrParams = Array( _
				Db.makeParam("@intIDX",adInteger,adParamInput,4,intIDX), _
				Db.makeParam("@strTitle",adVarWChar,adParamInput,30,strTitle), _
				Db.makeParam("@isView",adChar,adParamInput,1,isView), _

				Db.makeParam("@OUTPUT_VALUE",adVarchar,adParamOutput,20,"")_
			)
			Call Db.exec("DKSP_HEALING_CATE_UPDATE",DB_PROC,arrParams,Nothing)
		Case "DELETE"
			intIDX			= pRequestTF("intIDX",True)
			strNationCode	= pRequestTF("strNationCode",True)

			arrParams = Array( _
				Db.makeParam("@intIDX",adInteger,adParamInput,4,intIDX), _
				Db.makeParam("@strNationCode",adVarChar,adParamInput,6,strNationCode), _
				Db.makeParam("@OUTPUT_VALUE",adVarchar,adParamOutput,20,"")_
			)
			Call Db.exec("DKSP_HEALING_CATE_DELETE",DB_PROC,arrParams,Nothing)

		Case "SORTUP"
			intIDX			= pRequestTF("intIDX",True)
			strNationCode	= pRequestTF("strNationCode",True)

			arrParams = Array( _
				Db.makeParam("@intIDX",adInteger,adParamInput,4,intIDX), _
				Db.makeParam("@strNationCode",adVarChar,adParamInput,6,strNationCode), _
				Db.makeParam("@sortMode",adVarchar,adParamInput,8,"SORTUP"), _
				Db.makeParam("@OUTPUT_VALUE",adVarchar,adParamOutput,20,"ERROR")_

			)
			Call Db.exec("DKSP_HEALING_CATEGORY_SORT",DB_PROC,arrParams,Nothing)
			'Call Db.exec("DKPA_SHOP_CATEGORY_SORT",DB_PROC,arrParams,Nothing)
		Case "SORTDOWN"
			intIDX			= pRequestTF("intIDX",True)
			strNationCode	= pRequestTF("strNationCode",True)

			arrParams = Array( _
				Db.makeParam("@intIDX",adInteger,adParamInput,4,intIDX), _
				Db.makeParam("@strNationCode",adVarChar,adParamInput,6,strNationCode), _
				Db.makeParam("@sortMode",adVarchar,adParamInput,8,"SORTDOWN"), _
				Db.makeParam("@OUTPUT_VALUE",adVarchar,adParamOutput,20,"ERROR")_

			)
			Call Db.exec("DKSP_HEALING_CATEGORY_SORT",DB_PROC,arrParams,Nothing)
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
			Call alerts("처리되었습니다.","GO","Category.asp?nc="&strNationCode)
	End Select
%>
