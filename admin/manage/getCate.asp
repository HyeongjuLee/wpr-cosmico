<!--#include virtual = "/_lib/strFunc.asp"-->
<%

	Response.CharSet = "utf-8"
	Response.AddHeader "Pragma","no-cache"
	Response.AddHeader "Expires","0"


	Dim styleValue,mode
		mode = Request("mode")
		styleValue = Request("style") '값 받아오기
		view = UCase(Request("view"))
		If view = "" Then view = "T"

		parent_cate = styleValue


'		PRINT MODE
'		PRINT parent_cate

		Select Case mode
			Case "category1" : SQL =  "SELECT [strCatecode],[strCateName] FROM [DK_BRANCH_CODE] WHERE [strCateDepth] = 1 AND [strCateParent] = ?"
			Case "category2" : SQL =  "SELECT [strCatecode],[strCateName] FROM [DK_BRANCH_CODE] WHERE [strCateDepth] = 2 AND [strCateParent] = ?"
			Case "category3" : SQL =  "SELECT [strCatecode],[strCateName] FROM [DK_BRANCH_CODE] WHERE [strCateDepth] = 3 AND [strCateParent] = ?"
		End Select

'		PRINT SQL

		arrParams = Array( _
			Db.makeParam("@STRPARENT",adVarChar,adParamInput,20,parent_cate) _
		)
		arrList = Db.execRsList(SQL,DB_TEXT,arrParams,listLen,Nothing)


	If Not IsArray(arrList) Then
		Response.Write "["
		Response.Write "{value:'',caption:'하위 카테고리가 없습니다.'}"
		Response.Write "]"
	Else
		Response.Write "["
		Response.Write "{value:'',caption:'선택해주세요'},"
		For i = 0 To listLen
			Response.Write "{value:'"&arrList(0,i)&"',caption:'"&arrList(1,i) &"'}"
			If i <> listLen Then
			Response.Write ","
			Else
			Response.Write "]"
			End If
		Next

	End If



%>