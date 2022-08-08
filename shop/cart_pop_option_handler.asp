<!--#include virtual = "/_lib/strFunc.asp"-->
<!--#include virtual = "/_include/document.asp"-->

<%
	Call ONLY_MEMBER(DK_MEMBER_LEVEL)

	intIDX = pRequestTF("idx",True)
	goodsOption = pRequestTF("goodsOption",True)


'	print goodsOption

'	Response.End
	arrParams = Array(_
		Db.makeParam("@intIDX",adInteger,adParamInput,4,intIDX), _
		Db.makeParam("@strUserID",adVarChar,adParamInput,20,DK_MEMBER_ID), _
		Db.makeParam("@goodsOption",adVarWChar,adParamInput,512,goodsOption), _
		Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
	)
	Call Db.exec("DKP_CART_UPDATE_ONE_OPTION",DB_PROC,arrParams,Nothing)
	OUTPUT_VALUE = arrParams(Ubound(arrParams))(4)

	Select Case OUTPUT_VALUE
		Case "FINISH" : Call ALERTS(DBFINISH,"o_reloada","")
		Case "ERROR" : Call ALERTS(DBERROR,"back","")
		Case Else : Call ALERTS(DBUNDEFINED,"BACK","")
	End Select

%>

</head>
<body>


</body>
</html>
