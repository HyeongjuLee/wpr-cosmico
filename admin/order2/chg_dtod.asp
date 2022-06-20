<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<!--#include virtual = "/admin/_inc/document.asp"-->
</head>
<body>
<%

	intIDX = Request.Form("ChgIDX")
	DtoD = Request.Form("dtod")
	DtoDNum = Request.Form("dtodnum")
	DtoDDate = Request.Form("dtoddate")


	If DtoD = "date" Then
		DtoD = "0"
		DtoDNum = ""
	End If


	If DtoDDate = "" Or IsNull(DtoDdate) Then
		DtoDDate = Left(Now,10)
	Else
		If IsDate(DtoDDate) Then
			DtoDDate = DtoDDate
		Else
			Call alerts("입력하신 날자는 처리할 수 없는 형식입니다. \n 형식을 2010-01-01 형식으로 입력해주세요","go","/hiddens.asp")
		End If
	End If



'	Call ResRW(intIDX,"intIDX")
'	Call ResRW(DtoD,"DtoD")
'	Call ResRW(DtoDNum,"DtoDNum")
'	Call ResRW(DtoDDate,"DtoDDate")

'	SQL = " UPDATE [DK_ORDER_GOODS] SET  [orderDtoD] = ? ,[orderDtoDValue] = ?,[orderDtoDDate] = ? WHERE [intIDX] = ?"
	SQL = " UPDATE [DK_ORDER2_GOODS] SET  [orderDtoD] = ? ,[orderDtoDValue] = ?,[orderDtoDDate] = ? WHERE [intIDX] = ?"
	arrParams = Array(_
		Db.makeParam("@DtoD",adInteger,adParamInput,0,DtoD), _
		Db.makeParam("@DtoDNum",adVarChar,adParamInput,30,DtoDNum), _
		Db.makeParam("@DtoDDate",adDBTimeStamp,adParamInput,30,DtoDDate), _
		Db.makeParam("@intIDX",adInteger,adParamInput,0,intIDX) _

	)
	Call Db.exec(SQL,DB_TEXT,arrParams,Nothing)

%>
<script type='text/javascript'>
<!--
	alert("수정되었습니다.");
	parent.location.reload();
//-->
</script>
</body>
</html>
