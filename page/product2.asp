<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	PAGE_SETTING = "PRODUCT"
	ISLEFT = "T"
	ISSUBTOP = "T"

	mNum = 2



	intIDX = gRequestTF("view",False)

	If intIDX = "" Then
		SQL = "SELECT [intIDX] FROM [DK_GOODS2] WHERE [delTF] = 'F' AND [isView] = 'T' ORDER BY [intSort] ASC"
		intIDX = Db.execRsData(SQL,DB_TEXT,Nothing,Nothing)
	End If


	arrParams = Array(_
		Db.makeParam("@intIDX",adInteger,adParamInput,0,intIDX)_
	)
	Set DKRS = Db.execRs("DKP_PRODUCT_VIEW",DB_PROC,arrParams,Nothing)
	If Not DKRS.BOF And Not DKRS.EOF Then
		VIEW = DKRS("rownum")
		ContentValue = DKRS("strContent")
	Else
		Call ALERTS("존재하지 않는 페이지입니다.","BACK","")
	End If




%>
<!--#include virtual = "/_include/document.asp"-->
</head>
<body>
<!--#include virtual = "/_include/header.asp"-->
	<div id="pages">
	<%=BACKWORD(ContentValue)%>
	</div>


<!--#include virtual = "/_include/copyright.asp"-->
