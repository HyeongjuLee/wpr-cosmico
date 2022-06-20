<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<!--#include virtual = "/admin/_inc/document.asp"-->
<%
	ADMIN_LEFT_MODE = "ORDERS"
	INFO_MODE = "ORDERS1-1"


	intIDX = Request.Form("intIDX")

	Call ResRW(intIDX,"intIDX")


	'배송정보 유무 확인
'		SQL = "SELECT * FROM [DK_ORDER_GOODS] WHERE [orderIDX] = ?"
		SQL = "SELECT * FROM [DK_ORDER2_GOODS] WHERE [orderIDX] = ?"
		arrParams = Array(_
			Db.makeParam("@intIDX",adInteger,adParamInput,0,intIDX) _
		)
		arrList = Db.execRsList(SQL,DB_TEXT,arrParams,listLen,Nothing)

		If IsArray(arrList) Then
			For i = 0 To listLen
				arrDtoD = arrList(5,i)
				arrDtoDv = arrList(6,i)
				If arrDtoD = "" Or IsNull(arrDtoD) Or arrDtoDv = "" Or IsNull(arrDtoDv) Then
					If Not Db Is Nothing Then Set Db = Nothing
					Call alerts("배송정보중 빈 값이 있습니다.\n\n배송정보를 입력하신 후 시도해주세요.","go","/hiddens.asp")
				End If
			Next
		End If

'		SQL = " UPDATE [DK_ORDER] SET [state] = '102', [isDelivery] = 'T', [DeliveryDate] = getdate() WHERE [intIDX] = ?"
		SQL = " UPDATE [DK_ORDER2] SET [state] = '102', [isDelivery] = 'T', [DeliveryDate] = getdate() WHERE [intIDX] = ?"
		arrParams = Array(_
			Db.makeParam("@intIDX",adInteger,adParamInput,0,intIDX) _
		)
		Call Db.exec(SQL,DB_TEXT,arrParams,Nothing)

%>
<script type='text/javascript'>
<!--
	parent.location.reload();
//-->
</script>


</head>
<body>


<!--#include virtual = "/admin/_inc/header.asp"-->


<!--#include virtual = "/admin/_inc/copyright.asp"-->
