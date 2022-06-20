<!--#include virtual = "/_lib/strFunc.asp"-->
<%

	Response.CharSet = "UTF-8"
	Response.AddHeader "Pragma","no-cache"
	Response.AddHeader "Expires","0"


	Dim styleValue,mode
		mode			= pRequestTF_AJAX("mode",True)
		strCateParent	= pRequestTF_AJAX("cate",True) '값 받아오기
		strCodeNation	= pRequestTF_AJAX("strNationCode",True)


		Select Case mode
			Case "category1" : SQL =  "SELECT [strCatecode],[strCateName],[isView] FROM [DK_SHOP_CATEGORY] WHERE [intCateDepth] = 1 AND [strCateParent] = ? AND [strNationCode] = ? ORDER"
			Case "category2" : SQL =  "SELECT [strCatecode],[strCateName],[isView] FROM [DK_SHOP_CATEGORY] WHERE [intCateDepth] = 2 AND [strCateParent] = ? AND [strNationCode] = ? "
			Case "category3" : SQL =  "SELECT [strCatecode],[strCateName],[isView] FROM [DK_SHOP_CATEGORY] WHERE [intCateDepth] = 3 AND [strCateParent] = ? AND [strNationCode] = ? "
		End Select

		Select Case mode
			Case "category1" : intCateDepth = 1
			Case "category2" : intCateDepth = 2
			Case "category3" : intCateDepth = 3
		End Select


'		PRINT SQL

		arrParams = Array( _
			Db.makeParam("@intCateDepth",adInteger,adParamInput,4,intCateDepth), _
			Db.makeParam("@strCodeNation",adVarChar,adParamInput,6,strCodeNation), _
			Db.makeParam("@strCateParent",adVarChar,adParamInput,20,strCateParent) _
		)
		arrList = Db.execRsList("DKSP_SHOP_CATEGORY_LIST_AJAX",DB_PROC,arrParams,listLen,Nothing)


		If IsArray(arrList) Then
			Response.Write "<option value="""">카테고리를 선택해주세요.</option>"
			For i = 0 To listLen
				If arrList(2,i) = "F" Then thisView = "[노출숨김] " Else thisView = "" End If
				Response.Write "<option value="""&arrList(0,i)&""">"&thisView&arrList(1,i)&"</option>"
			Next
		Else
			Response.Write "<option value="""">하위 카테고리가 없습니다.</option>"
		End If

'	If Not IsArray(arrList) Then
'		Response.Write "["
'		Response.Write "{value:'',caption:'하위 카테고리가 없습니다.'}"
'		Response.Write "]"
'	Else
'		Response.Write "["
'		Response.Write "{value:'',caption:'선택해주세요'},"
'		For i = 0 To listLen
'			Response.Write "{value:'"&arrList(0,i)&"',caption:'"&arrList(1,i) &"'}"
'			If i <> listLen Then
'			Response.Write ","
'			Else
'			Response.Write "]"
'			End If
'		Next
'
'	End If



%>
