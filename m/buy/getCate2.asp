<!--#include virtual = "/_lib/strFunc.asp"-->
<%

	Response.CharSet = "UTF-8"
	Response.AddHeader "Pragma","no-cache"
	Response.AddHeader "Expires","0"


	Dim styleValue,mode
		mode = Request("mode")
		cate = Request("cate") '값 받아오기
		view = UCase(Request("view"))
		If view = "" Then view = "T"

		parent_cate = cate


		'PRINT MODE
		PRINT parent_cate
		'PRINT view

		Select Case view
			Case "T"
				Select Case mode
					Case "category2" : SQL =  "SELECT [ItemCode],[ItemName],[UpitemCode],[UpitemName],[recordid],[recordtime] FROM [tbl_MakeItemCode2] WHERE [UpitemCode] = ?"
				End Select
		End Select




		arrParams = Array( _
			Db.makeParam("@STRPARENT",adVarChar,adParamInput,20,parent_cate) _
		)
		arrList = Db.execRsList(SQL,DB_TEXT,arrParams,listLen,DB3)

		If IsArray(arrList) Then
			Response.Write "<option value="""">카테고리를 선택해주세요.</option>"
			For i = 0 To listLen
				Response.Write "<option value="""&arrList(0,i)&""">"&arrList(1,i)&"</option>"
			Next
		Else
			Response.Write "disabled"
		End If
%>
