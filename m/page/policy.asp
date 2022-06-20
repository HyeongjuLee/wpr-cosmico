<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	PAGE_SETTING = "POLICY"
	PAGE_SETTING2 = "SUBPAGE"

	ISLEFT = "T"
	ISSUBTOP = "T"

	view = gRequestTF("view",True)
	mNum = 6
	sNum = view
	sVar = sNum


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

			'tops = viewImg(IMG_CONTENT&"/membership_03_tit.jpg",780,45,"")
		Case Else
			Call ALERTS("잘못된 설정입니다.","BACK","")
	End Select

	viewContent = Replace(viewContent,"OOO",LNG_SITE_TITLE)


%>
<!--#include virtual = "/m/_include/document.asp"-->
<!--#include virtual = "/m/_include/jqueryload.asp"-->

<script src="/m/js/icheck/icheck.min.js"></script>

</head>
<body onunload="">
<!--#include virtual = "/m/_include/header.asp"-->
<div class="policy">
	<div class="agree_box">
		<div class="agree_content"><%=backword_tag(viewContent)%></div>
	</div>
</div>
<!--#include virtual = "/m/_include/copyright.asp"-->