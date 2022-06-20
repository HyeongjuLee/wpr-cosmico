<!--#include virtual = "/_lib/strFunc.asp"-->
<!--#include virtual = "/_include/document.asp"-->
<%

	Call Only_Member(DK_MEMBER_LEVEL)


	intIDX			= pRequestTF("intIDX",True)
	CancelCause		= pRequestTF("CancelCause",True)

'	Call ResRW(intIDX			,"intIDX")
'	Call ResRW(strGrade			,"strGrade")
'	Call ResRW(strSubject		,"strSubject")
'	Call ResRW(content1			,"content1")



	arrParams = Array(_
		Db.makeParam("@intIDX",adInteger,adParamInput,0,intIDX), _
		Db.makeParam("@CancelCause",adVarChar,adParamInput,800,CancelCause), _
		Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
	)
'	Call Db.execRs("DKP_ORDER_CANCEL",DB_PROC,arrParams,Nothing)
	Call Db.execRs("DKP_ORDER_CANCEL2",DB_PROC,arrParams,Nothing)
	OUTPUT_VALUE = arrParams(UBound(arrParams))(4)

	Select Case OUTPUT_VALUE
		Case "ERROR"	: Call ALERTS(DBERROR,"back","")
		Case "FINISH"	: Call ALERTS(DBFINISH,"o_reloada","")
		Case Else		: Call ALERTS(DBUNDEFINED,"back","")
	End Select



%>
</head>
<body>


</body>
</html>
