<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<!--#include virtual = "/admin/_inc/document.asp"-->
<%
	ADMIN_LEFT_MODE = "ORDERS"
	INFO_MODE = "ORDERS1-1"

	mode = pRequestTF("mode",True)
	intIDX = pRequestTF("intIDX",True)

'	Call ResRW(intIDX,"intIDX")
'	Response.End

	arrParams = Array(_
		Db.makeParam("@intIDX",adInteger,adParamInput,4,intIDX), _
		Db.makeParam("@regID",adVarChar,adParamInput,30,DK_MEMBER_ID), _
		Db.makeParam("@regIP",adVarChar,adParamInput,30,getUserIP), _
		Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
	)
	Select Case MODE
		Case "go101"	:	Call Db.exec("DKPA_ORDER_CHG_101",DB_PROC,arrParams,Nothing)
		Case "go102"	:	Call Db.exec("DKPA_ORDER_CHG_102",DB_PROC,arrParams,Nothing)
		Case "back101"	:	Call Db.exec("DKPA_ORDER_CHG_101BACK",DB_PROC,arrParams,Nothing)
		Case "back102"	:	Call Db.exec("DKPA_ORDER_CHG_102BACK",DB_PROC,arrParams,Nothing)
	End Select

	OUTPUT_VALUE = arrParams(Ubound(arrParams))(4)

'	Select Case mode
'		Case "go101"
'			SQL = " UPDATE [DK_ORDER] SET [status] = '101', [status101Date] = getdate() WHERE [intIDX] = ?"
'		Case "go102"
'			SQLS = "SELECT * FROM [DK_ORDER_GOODS] WHERE [orderIDX] = ?"
'			arrParams = Array(_
'				Db.makeParam("@intIDX",adInteger,adParamInput,0,intIDX) _
'			)
'			arrList = Db.execRsList(SQLS,DB_TEXT,arrParams,listLen,Nothing)
'
'			If IsArray(arrList) Then
'				For i = 0 To listLen
'					arrDtoD = arrList(5,i)
'					arrDtoDDate = arrList(7,i)
'					If arrDtoD = "" Or IsNull(arrDtoD) Or arrDtoDDate = "" Or IsNull(arrDtoDDate) Then
'						If Not Db Is Nothing Then Set Db = Nothing
'						Call alerts("배송정보중 빈 값이 있습니다.\n\n배송정보를 입력하신 후 시도해주세요.","p_reloada","/hiddens.asp")
'					End If
'				Next
'			End If
'			SQL = "UPDATE [DK_ORDER] SET [status] = '102', [status102Date] = getdate() WHERE [intIDX] = ?"
'
'
'
'		Case "go103"
'			SQL = " UPDATE [DK_ORDER] SET [status] = '103', [status103Date] = getdate() WHERE [intIDX] = ?"
'		Case "go105"
'			SQL = " UPDATE [DK_ORDER] SET [status] = '105', [status5Date] = getdate() WHERE [intIDX] = ?"
'
'		Case "back100"
'			SQL = " UPDATE [DK_ORDER] SET [status] = '100', [status101Date] = null WHERE [intIDX] = ?"
'		Case "back101"
'			SQL = " UPDATE [DK_ORDER] SET [status] = '101', [status102Date] = null, [DtoDCode] = null,[DtoDNumber] = null,[DtoDDate] = null WHERE [intIDX] = ?"
'		Case "back102"
'			SQL = " UPDATE [DK_ORDER] SET [status] = '102', [status103Date] = null WHERE [intIDX] = ?"
'
'		Case "backc100"
'			SQL = " UPDATE [DK_ORDER] SET [status] = '100', [status101Date] = null, [status102Date] = null, [status103Date] = null, [status104Date] = null, [status201Date] = null, [status301Date] = null, [status302Date] = null, [DtoDCode] = null,[DtoDNumber] = null,[DtoDDate] = null WHERE [intIDX] = ?"
'		Case "backc101"
'			SQL = " UPDATE [DK_ORDER] SET [status] = '101', [status102Date] = null, [status103Date] = null, [status104Date] = null, [status201Date] = null, [status301Date] = null, [status302Date] = null, [DtoDCode] = null,[DtoDNumber] = null,[DtoDDate] = null WHERE [intIDX] = ?"
'		Case "backc102"
'			SQL = " UPDATE [DK_ORDER] SET [status] = '102', [status103Date] = null, [status104Date] = null, [status201Date] = null, [status301Date] = null, [status302Date] = null, [DtoDCode] = null,[DtoDNumber] = null,[DtoDDate] = null WHERE [intIDX] = ?"
'	End Select
'
'	If MODE = "go102" Then
'		SQLS = "SELECT * FROM [DK_ORDER_GOODS] WHERE [orderIDX] = ?"
'		arrParams = Array(_
'			Db.makeParam("@intIDX",adInteger,adParamInput,0,intIDX) _
'		)
'		arrList = Db.execRsList(SQLS,DB_TEXT,arrParams,listLen,Nothing)
'
'		If IsArray(arrList) Then
'			For i = 0 To listLen
'				arrDtoD = arrList(5,i)
'				arrDtoDDate = arrList(7,i)
'				If arrDtoD = "" Or IsNull(arrDtoD) Or arrDtoDDate = "" Or IsNull(arrDtoDDate) Then
'					If Not Db Is Nothing Then Set Db = Nothing
'					Call alerts("배송정보중 빈 값이 있습니다.\n\n배송정보를 입력하신 후 시도해주세요.","p_reloada","/hiddens.asp")
'				End If
'			Next
'		End If
'	End If
'
'	arrParams = Array(_
'		Db.makeParam("@intIDX",adInteger,adParamInput,0,intIDX), _
'		Db.makeParam("@MODE",adVarChar,adParamInput,10,mode), _
'		Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
'	)
'	Call Db.exec("DKPA_ORDER_CANCEL_HANDLER",DB_PROC,arrParams,Nothing)


Select Case OUTPUT_VALUE
	Case "FINISH" : Call ALERTS(DBFINISH,"GO","order_list.asp")
	Case "ERROR" : Call ALERTS(DBERROR,"BACK","")
End Select
%>

</head>
<body>


<!--#include virtual = "/admin/_inc/header.asp"-->


<!--#include virtual = "/admin/_inc/copyright.asp"-->
