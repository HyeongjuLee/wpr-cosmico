<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	PAGE_SETTING = "POLICY"
	agree_box_WIDTH = "1200"
	content1_WIDTH	=" "&agree_box_WIDTH - 6

	ISLEFT = "T"
	ISSUBTOP = "T"
	ISSUBVISUAL = "T"

	view = gRequestTF("view",True)
	mNum = 6
	sNum = view
	sVar = sNum
'	Select Case view
'		Case "1"
'			SUB_TOP_IMG = IMG_CONTENT&"/about_sub_top_01.gif"
'		Case "2"
'			SUB_TOP_IMG = IMG_CONTENT&"/about_sub_top_02.gif"
'		Case "3"
'			SUB_TOP_IMG = IMG_CONTENT&"/company_sub_top_03.gif"
'		Case "4"
'			SUB_TOP_IMG = IMG_CONTENT&"/company_sub_top_04.gif"
'		Case Else Call ALERTS("존재하지 않는 페이지입니다.","BACK","")
'	End Select



	Select Case view
		Case "1"
			arrParams2 = Array(_
				Db.makeParam("@policyType",adVarChar,adParamInput,10,"policy01") ,_
				Db.makeParam("@strNation",adVarChar,adParamInput,10,UCase(LANG)) _
			)
			viewContent = Db.execRsData("DKP_POLICY_CONTENT",DB_PROC,arrParams2,Nothing)
			If IsNull(viewContent) Or viewContent = "" Then viewContent = LNG_JOINSTEP02_U_TEXT01 &"("&LANG&")"

		Case "2"
			arrParams2 = Array(_
				Db.makeParam("@policyType",adVarChar,adParamInput,10,"policy02") ,_
				Db.makeParam("@strNation",adVarChar,adParamInput,10,UCase(LANG)) _
			)
			viewContent = Db.execRsData("DKP_POLICY_CONTENT",DB_PROC,arrParams2,Nothing)
			If IsNull(viewContent) Or viewContent = "" Then viewContent = LNG_JOINSTEP02_U_TEXT02 &"("&LANG&")"

		Case "3"
			If PG_EXAM_MODE = "T" Then Call ALERTS("준비중입니다.","back","")

			arrParams2 = Array(_
				Db.makeParam("@policyType",adVarChar,adParamInput,10,"policy03") ,_
				Db.makeParam("@strNation",adVarChar,adParamInput,10,UCase(LANG)) _
			)
			viewContent = Db.execRsData("DKP_POLICY_CONTENT",DB_PROC,arrParams2,Nothing)
			If IsNull(viewContent) Or viewContent = "" Then viewContent = LNG_JOINSTEP02_U_TEXT03 &"("&LANG&")"

		Case Else
			Call ALERTS("잘못된 설정입니다.","BACK","")
	End Select

	viewContent = Replace(viewContent,"OOO",LNG_SITE_TITLE)

%>
<!--#include virtual = "/_include/document.asp"-->
</head>
<body>
<!--#include virtual = "/_include/header.asp"-->
<div class="policy">
	<div class="agree_box">
		<div class="agree_content"><%=backword_tag(viewContent)%></div>
	</div>
</div>
<!--#include virtual = "/_include/copyright.asp"-->
