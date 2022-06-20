<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<!--#include virtual = "/admin/_inc/document.asp"-->
</head>
<body>
<%
	ADMIN_LEFT_MODE = "MEMBER"
	INFO_MODE = "MEMBER2-1"


	blockID = pRequestTF("blockID",True)

	arrParams = Array(_
		Db.makeParam("@strBlockID",adVarChar,adParamInput,MAX_LENGTH,blockID),_
		Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
	)
	Call Db.exec("DKPA_NBOARD_BLOCK_WRITER_INSERT",DB_PROC,arrParams,Nothing)
	OUTPUT_VALUE = arrParams(UBound(arrParams))(4)



	Select Case OUTPUT_VALUE
		Case "ERROR"	: Call ALERTS(DBERROR,"back","")
		Case "FINISH"	: Call ALERTS(DBFINISH,"go","blockID.asp")
		Case Else		: Call ALERTS(DBUNDEFINED,"back","")
	End Select


%>
<!--#include virtual = "/admin/_inc/header.asp"-->
<%


%>
<!--#include virtual = "/admin/_inc/copyright.asp"-->
