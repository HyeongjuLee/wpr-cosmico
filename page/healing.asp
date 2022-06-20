<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	PAGE_SETTING = "NATURE"
	ISLEFT = "T"
	ISSUBTOP = "T"

	intIDX = gRequestTF("view",False)


	If intIDX = "" Then
		arrParams = Array(_
			Db.makeParam("@strNationCode",adVarChar,adParamInput,6,LANG) _
		)
		intIDX = Db.execRsData("DKSP_HEALING_CONTENT_TOP1",DB_PROC,arrParams,Nothing)
		If IsNull(intIDX) Then Call ALERTS("데이터가 없습니다.","BACK","")
	End If



	arrParams = Array(_
		Db.makeParam("@intIDX",adInteger,adParamInput,4,intIDX), _
		Db.makeParam("@strNationCode",adVarChar,adParamInput,6,LANG) _
	)
	Set DKRS = Db.execRs("DKSP_HEALING_CONTENT_VIEW",DB_PROC,arrParams,Nothing)

	If Not DKRS.BOF And Not DKRS.EOF Then
		H_DKRS_ROWNUM			= DKRS("ROWNUM")
		H_DKRS_intIDX			= DKRS("intIDX")
		H_DKRS_FK_IDX			= DKRS("FK_IDX")
		H_DKRS_strNationCode	= DKRS("strNationCode")
		H_DKRS_isDel			= DKRS("isDel")
		H_DKRS_isView			= DKRS("isView")
		H_DKRS_intSort			= DKRS("intSort")
		H_DKRS_strSubject		= DKRS("strSubject")
		H_DKRS_strContent		= DKRS("strContent")
		H_DKRS_regDate			= DKRS("regDate")
	Else
		Call ALERTS("없는 데이터입니다.","BACK","")
	End If
	'print H_DKRS_FK_IDX
	'print H_DKRS_ROWNUM

	arrParams = Array(_
		Db.makeParam("@intIDX",adInteger,adParamInput,4,H_DKRS_FK_IDX), _
		Db.makeParam("@strNationCode",adVarChar,adParamInput,6,LANG) _
	)
	Set DKRS2 = Db.execRs("DKSP_HEALING_CATE_VIEW",DB_PROC,arrParams,Nothing)
	If Not DKRS2.BOF And Not DKRS2.EOF Then
		H_DKRS2_ROWNUM			= DKRS2("ROWNUM")
		H_DKRS2_intIDX			= DKRS2("intIDX")
		H_DKRS2_strNationCode	= DKRS2("strNationCode")
		H_DKRS2_isDel			= DKRS2("isDel")
		H_DKRS2_isView			= DKRS2("isView")
		H_DKRS2_intSort			= DKRS2("intSort")
		H_DKRS2_strTitle		= DKRS2("strTitle")
	Else
		Call ALERTS("없는 데이터입니다.","BACK","")
	End If

	view  = H_DKRS2_ROWNUM
	sView = H_DKRS_ROWNUM


%>
<!--#include virtual = "/_include/document.asp"-->
</head>
<body>
<!--#include virtual = "/_include/header.asp"-->
<!--#include virtual = "/_include/sub_title.asp"-->
<div id="pages">
<div style="height:32px; line-height:32px; font-weight:bold; background-color:#f4f4f4; text-align:center; border-top:1px solid #ccc; border-bottom:1px solid #ccc;"><%=H_DKRS_strSubject%></div>
<div style="margin-top:15px;">
<%=BACKWORD(H_DKRS_strContent)%>
</div>
</div>
<!--#include virtual = "/_include/copyright.asp"-->




