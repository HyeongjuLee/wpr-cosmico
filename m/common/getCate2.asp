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


'		PRINT MODE
'		PRINT parent_cate

		Select Case view
			Case "T"
				Select Case mode
					Case "category2" : SQL =  "SELECT [ItemCode],[ItemName],[UpitemCode],[UpitemName],[recordid],[recordtime] FROM [tbl_MakeItemCode2] WHERE [UpitemCode] = ?"
				End Select
		End Select

'		PRINT SQL

		arrParams = Array( _
			Db.makeParam("@STRPARENT",adVarChar,adParamInput,20,parent_cate) _
		)
		arrList = Db.execRsList(SQL,DB_TEXT,arrParams,listLen,DB4)

		If IsArray(arrList) Then
			Response.Write "<option value="""">"&LNG_CS_GETCATE2_TEXT01&"</option>"
			For i = 0 To listLen
				Response.Write "<option value="""&arrList(0,i)&""">"&arrList(1,i)&"</option>"
			Next
		Else
			Response.Write "<option value="""">"&LNG_CS_GETCATE2_TEXT02&"</option>"
		End If



%>
