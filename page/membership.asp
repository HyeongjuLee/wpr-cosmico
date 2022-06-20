<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	PAGE_SETTING = "MEMBERSHIP"
	ISLEFT = "T"
	ISSUBTOP = "T"
	ISSUBVISUAL = "T"

	view = gRequestTF("view",True)

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
				Db.makeParam("@policyType",adVarChar,adParamInput,10,"policy01") _
			)
			viewContent = Db.execRsData("DKP_POLICY_CONTENT",DB_PROC,arrParams2,Nothing)

			tops = viewImg(IMG_CONTENT&"/membership_01_tit.jpg",780,45,"")
		Case "2"
			arrParams2 = Array(_
				Db.makeParam("@policyType",adVarChar,adParamInput,10,"policy02") _
			)
			viewContent = Db.execRsData("DKP_POLICY_CONTENT",DB_PROC,arrParams2,Nothing)

			tops = viewImg(IMG_CONTENT&"/membership_02_tit.jpg",780,45,"")
		Case "3"
			arrParams2 = Array(_
				Db.makeParam("@policyType",adVarChar,adParamInput,10,"policy03") _
			)
			viewContent = Db.execRsData("DKP_POLICY_CONTENT",DB_PROC,arrParams2,Nothing)

			tops = viewImg(IMG_CONTENT&"/membership_03_tit.jpg",780,45,"")
		'영업지침
		Case "4"
			arrParams2 = Array(_
				Db.makeParam("@policyType",adVarChar,adParamInput,10,"policy04") _
			)
			viewContent = Db.execRsData("DKP_POLICY_CONTENT",DB_PROC,arrParams2,Nothing)

			tops = viewImg(IMG_CONTENT&"/membership_04_tit.jpg",780,45,"")

	End Select



%>
<!--#include virtual = "/_include/document.asp"-->
</head>
<body>
<!--#include virtual = "/_include/header.asp"-->
<div id="pages">
	<%
			PRINT TABS(1)& "	<div class=""titleLine"">"
			PRINT TABS(1)& "		<div class=""fleft"">"&tops&"</div>"
			PRINT TABS(1)& "	</div>"
	%>
	<div style="margin-top:50px; padding-bottom:30px;">
		<div class="agree_box"><div class="agree_content1"><%=backword(viewContent)%></div></div>
	</div>
</div>
<!--#include virtual = "/_include/copyright.asp"-->
