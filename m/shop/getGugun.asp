<!--#include virtual = "/_lib/strFunc.asp"-->
<%

	Response.CharSet = "UTF-8"
	Response.AddHeader "Pragma","no-cache"
	Response.AddHeader "Expires","0"


	Dim styleValue,mode
		mode = Request("mode")
		cate = Request("cate")

		parent_cate = cate

		SQL2 = "SELECT [SiDo_Name_2] FROM [tbl_SiDo_Code] WHERE [SiDo_Name] = ?"

		arrParams = Array(_
			Db.makeParam("@SIDO_NAME_KR",adVarchar,adParamInput,20,parent_cate) _
		)
		Set HJRS = Db.execRs(SQL2,DB_TEXT,arrParams,DB2)
		If Not HJRS.BOF And Not HJRS.EOF Then
			SIDO_NAME = HJRS(0)
		End If



		Select Case mode
			Case "category2" : SQL = "SELECT [gugun] FROM [ZIPCODE_SIDO_GUGUN] WHERE [SiDo_Name] = ?"
'			Case "category2" : SQL = "SELECT DISTINCT [gugun] FROM "&SIDO_NAME&" WHERE [sido] = ?"

		End Select


		arrParams = Array( _
			Db.makeParam("@STRPARENT",adVarWChar,adParamInput,255,parent_cate) _
		)
		arrList = Db.execRsList(SQL,DB_TEXT,arrParams,listLen,DB2)

		If IsArray(arrList) Then
			Response.Write "<option value="""">구/군을 선택해주세요.</option>"
			For i = 0 To listLen
				Response.Write "<option value="""&arrList(0,i)&""">"&arrList(0,i)&"</option>"
			Next
		Else
			If parent_cate = "" Then
				Response.Write "<option value="""">시/도를 선택해주세요.</option>"
			Else
				Response.Write "<option value="""">해당 시도에 등록된 구/군이 없습니다.</option>"
			End If
		End If

%>
