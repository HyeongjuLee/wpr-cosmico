<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/_include/document.asp" -->
<%


	policyType = gRequestTF("pt",True)

	If policyType <> "" Then
        arrParams2 = Array(_
            Db.makeParam("@policyType",adVarChar,adParamInput,10,policyType), _
            Db.makeParam("@strNation",adVarChar,adParamInput,10,"KR") _
        )
        policyContent1 = Db.execRsData("DKP_POLICY_CONTENT",DB_PROC,arrParams2,Nothing)
        If IsNull(policyContent1) Or policyContent1 = "" Then policyContent1 = ""
	End If

%>
</head>
<body>
    <div style="padding: 5px 10px;"><%=backword_tag(policyContent1)%></div>
</body>
</html>
