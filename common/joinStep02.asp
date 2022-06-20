<!--#include virtual="/_lib/strFunc.asp" -->
<%
'*****************************************
If webproIP <> "T" Then
	'Call ALERTS("준비중입니다","BACK","")
End If
'****************************************
	PAGE_SETTING = "COMMON"

	ISLEFT = "F"
	ISSUBTOP = "T"
	ISSUBVISUAL = "F"
	IS_LANGUAGESELECT = "F"
	NO_MEMBER_REDIRECT = "F"

	view = 4
	sview = 8

	mnType = "2"

	If DK_MEMBER_LEVEL > 0 Then Response.Redirect "/index.asp"

	If Not checkRef(houUrl &"/common/joinStep01.asp") Then Call alerts("잘못된 접근입니다.","go","/common/joinStep01.asp")

	arrParams = Array(_
		Db.makeParam("@PolicyType",adVarChar,adParamInput,10,"policy01"), _
		Db.makeParam("@strNation",adVarChar,adParamInput,10,UCase(LANG)) _
	)
	Agree_Content01 = Db.execRsData("DKP_POLICY_CONTENT",DB_PROC,arrParams,Nothing)
	Agree_Content01 = Replace(Agree_Content01,"OOO",LNG_SITE_TITLE)

	arrParams = Array(_
		Db.makeParam("@PolicyType",adVarChar,adParamInput,10,"policy02"), _
		Db.makeParam("@strNation",adVarChar,adParamInput,10,UCase(LANG)) _
	)
	Agree_Content02 = Db.execRsData("DKP_POLICY_CONTENT",DB_PROC,arrParams,Nothing)
	Agree_Content02 = Replace(Agree_Content02,"OOO",LNG_SITE_TITLE)

	arrParams = Array(_
		Db.makeParam("@PolicyType",adVarChar,adParamInput,10,"policy03"), _
		Db.makeParam("@strNation",adVarChar,adParamInput,10,UCase(LANG)) _
	)
	Agree_Content03 = Db.execRsData("DKP_POLICY_CONTENT",DB_PROC,arrParams,Nothing)
	Agree_Content03 = Replace(Agree_Content03,"OOO",LNG_SITE_TITLE)

	arrParams = Array(_
		Db.makeParam("@PolicyType",adVarChar,adParamInput,10,"policy04"), _
		Db.makeParam("@strNation",adVarChar,adParamInput,10,UCase(LANG)) _
	)
	Agree_Content04 = Db.execRsData("DKP_POLICY_CONTENT",DB_PROC,arrParams,Nothing)
	Agree_Content04 = Replace(Agree_Content04,"OOO",LNG_SITE_TITLE)

	If IsNull(Agree_Content01) Or Agree_Content01 = "" Then Agree_Content01 = "사이트 이용약관이 등록되지 않았습니다."
	If IsNull(Agree_Content02) Or Agree_Content02 = "" Then Agree_Content02 = "개인정보 취급방침이 등록되지 않았습니다."
	If IsNull(Agree_Content03) Or Agree_Content03 = "" Then Agree_Content03 = "사업자 회원가입 약관이 등록되지 않았습니다."
'	If IsNull(Agree_Content03) Or Agree_Content03 = "" Then Agree_Content03 = "방문판매등에관한법률이 등록되지 않았습니다."
	If IsNull(Agree_Content04) Or Agree_Content04 = "" Then Agree_Content04 = "전자금융거래 이용약관이 등록되지 않았습니다."

%>
<%If NICE_BANK_WITH_MOBILE_USE = "T" Then%>
<!--#include virtual="/MOBILEAUTH/mobileAuth.asp" -->
<%End If%>

<!--#include virtual="/_include/document.asp" -->
<link rel="stylesheet" type="text/css" href="/css/common.css?v0" />
<script type="text/javascript" src="joinStep.js?v1"></script>
</head>
<body>
<!--#include virtual="/_include/header.asp" -->
<iframe src="/hiddens.asp" name="hidden" frameborder="0" border="0" width="0" height="0" style="display:none;"></iframe>

<div id="joinStep" class="common joinStep2">
	<!-- <form name="jfrm" method="post" action="joinStep03.asp" onsubmit="return chkAgree(this);"> -->
	<form name="agreeFrm" method="post" action="joinStep03.asp" onsubmit="return chkAgree(this);">
		<%If NICE_BANK_WITH_MOBILE_USE = "T" Then%>
		<input type="hidden" name="sRequestNO" value="<%=sRequestNO%>" readonly="readonly" />
		<%End If%>
		<section class="all">
			<label>
				<input type="checkbox" id="allAgree" onclick="allCheckAgree()" name="allAgree" value="T" />
				<i class="icon-ok"></i>
				<span><%=LNG_JOINSTEP02_U_TEXT07%></span>
			</label>
		</section>
		<section>
			<div class="title">
				<h3><%=LNG_POLICY_01%></h3>
				<label>
					<input type="checkbox" id="agree01Chk" name="agree01" value="T" />
					<i class="icon-ok"></i>
					<span><%=LNG_TEXT_I_AGREE%></span>
				</label>
			</div>
			<div class="agree_box">
				<div class="agree_content"><%=backword_tag(Agree_Content01)%></div>
			</div>
		</section>
		<section>
			<div class="title">
				<h3><%=LNG_POLICY_02%></h3>
				<label>
					<input type="checkbox" id="agree02Chk" name="agree02" value="T" />
					<i class="icon-ok"></i>
					<span><%=LNG_TEXT_I_AGREE%></span>
				</label>
			</div>
			<div class="agree_box">
				<div class="agree_content"><%=backword_tag(Agree_Content02)%></div>
			</div>
		</section>

		<section>
			<div class="title">
				<h3><%=LNG_TEXT_BUSINESS_MEMBER%>&nbsp;<%=LNG_JOINSTEP02_U_TEXT09%></h3>
				<label>
					<input type="checkbox" id="agree03Chk" name="agree03" value="T" />
					<i class="icon-ok"></i>
					<span><%=LNG_TEXT_I_AGREE%></span>
				</label>
			</div>
			<div class="agree_box">
				<div class="agree_content"><%=backword_tag(Agree_Content03)%></div>
			</div>
		</section>
		<%If NICE_BANK_WITH_MOBILE_USE <> "T" Then%>
		<article class="privacy">
			<div class="btnZone">
				<input type="button" class="cancel" onclick="javascript:history.go(-1);" value="<%=LNG_JOINSTEP02_U_TEXT15%>"/>
				<input type="submit" class="promise" value="<%=LNG_JOINSTEP02_U_TEXT16%>" />
			</div>
		</article>
		<%End If%>
	</form>

	<%If NICE_BANK_WITH_MOBILE_USE = "T" Then		'NICE 계좌인증 + 휴대폰 인증%>
		<article class="privacy">
			<div class="btnZone">
				<input type="button" class="cancel" onclick="javascript:history.go(-1);" value="<%=LNG_JOINSTEP02_U_TEXT15%>"/>
				<input type="submit" class="promise" value="휴대폰 본인 인증" onclick="fnPopup();" />
			</div>
		</article>
		<form name="form_chk" method="post">
			<input type="hidden" name="m" value="checkplusSerivce">
			<input type="hidden" name="EncodeData" value="<%= sEncData %>">
		</form>
	<%End If%>

</div>
<!--#include virtual="/_include/copyright.asp" -->
