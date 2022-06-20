<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<!--#include virtual = "/admin/_inc/document.asp"-->
<%
' ===================================================================
' 게시판 변수 받아오기(설정)
' ===================================================================

	Dim IDV
		IDV = gRequestTF("idv",True)


	arrParams = Array(_
		Db.makeParam("@intIDX",adInteger,adParamInput,0,IDV),_

		Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
	)
'	Call Db.exec("DKPA_ORDER_CANCEL_U",DB_PROC,arrParams,Nothing)
	Call Db.exec("DKPA_ORDER_CANCEL_U2",DB_PROC,arrParams,Nothing)

	OUTPUT_VALUE = arrParams(UBound(arrParams))(4)

	Select Case OUTPUT_VALUE
		Case "ERROR" : Call ALERTS(DBERROR,"back","")
		Case "FINISH" : Call ALERTS(DBFINISH,"o_reloada","")
		Case Else : PRINT "Undefined"
	End Select
%>

</head>
<body>


</body>
</html>
