<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	PAGE_SETTING = "JOIN"
	view = 2
	sview = 2
	ISSUBTOP = "T"

	IS_LANGUAGESELECT = "F"
	NO_MEMBER_REDIRECT = "F"


	If DK_MEMBER_LEVEL > 0 Then Response.Redirect "/m/index.asp"


	R_NationCode = LangGLB

	arrParams1 = Array(_
		Db.makeParam("@policyType",adVarChar,adParamInput,10,"policy01") ,_
		Db.makeParam("@strNation",adVarChar,adParamInput,10,UCase(R_NationCode)) _
	)
	policyContent1 = Db.execRsData("DKP_POLICY_CONTENT",DB_PROC,arrParams1,Nothing)
	policyContent1 = Replace(policyContent1,"OOO",LNG_SITE_TITLE)
	If IsNull(policyContent1) Or policyContent1 = "" Then policyContent1 = "사이트 이용약관이 등록되지 않았습니다."

	arrParams2 = Array(_
		Db.makeParam("@policyType",adVarChar,adParamInput,10,"policy02") ,_
		Db.makeParam("@strNation",adVarChar,adParamInput,10,UCase(R_NationCode)) _
	)
	policyContent2 = Db.execRsData("DKP_POLICY_CONTENT",DB_PROC,arrParams2,Nothing)
	policyContent2 = Replace(policyContent2,"OOO",LNG_SITE_TITLE)
	If IsNull(policyContent2) Or policyContent2 = "" Then policyContent2 = "개인정보취급방침이 등록되지 않았습니다."

	arrParams3 = Array(_
		Db.makeParam("@policyType",adVarChar,adParamInput,10,"policy03") ,_
		Db.makeParam("@strNation",adVarChar,adParamInput,10,UCase(R_NationCode)) _
	)
	policyContent3 = Db.execRsData("DKP_POLICY_CONTENT",DB_PROC,arrParams3,Nothing)
	policyContent3 = Replace(policyContent3,"OOO",LNG_SITE_TITLE)
	If IsNull(policyContent3) Or policyContent3 = "" Then policyContent3 = "사업자회원 가입약관이 등록되지 않았습니다."



%>
<%If NICE_BANK_WITH_MOBILE_USE = "T" Then%>
<!--#include virtual="/MOBILEAUTH/mobileAuth.asp" -->
<%
	IF iRtn = 0 THEN
		session("MO_CHECK") = "ok"			'only Mobile(MOBILEAUTH 분기)
	END IF
%>
<%End If%>
<!--#include virtual = "/m/_include/document.asp"-->
<!--#include virtual = "/m/_include/jqueryload.asp"-->

<script type="text/javascript" src="/m/js/ajax.js"></script>
<script type="text/javascript" src="joinStep.js?v1"></script>

<link rel="stylesheet" href="/m/css/joinstep.css?v2" />
<script src="/m/js/icheck/icheck.min.js"></script>
<script>
	function allCheckAgree() {
		if (document.getElementById("allAgree").checked == true)
		{
			document.getElementById("agree01Chk").checked = true;
			document.getElementById("agree02Chk").checked = true;
			<%If S_SellMemTF = 0 Then%>
				document.getElementById("agree03Chk").checked = true;
			<%End If%>
		} else if (document.getElementById("allAgree").checked == false)	{
			document.getElementById("agree01Chk").checked = false;
			document.getElementById("agree02Chk").checked = false;
			<%If S_SellMemTF = 0 Then%>
				document.getElementById("agree03Chk").checked = false;
			<%End If%>
		}
	}
</script>
</head>
<body onunload="">
<!--#include virtual = "/m/_include/header.asp"-->

<div id="join02" class="joinstep">
	<!-- <form name="jFrm02" method="post" action="joinStep03.asp" > -->
	<form name="agreeFrm" method="post" action="joinStep03.asp" >
		<%If NICE_BANK_WITH_MOBILE_USE = "T" Then%>
		<input type="hidden" name="sRequestNO" value="<%=sRequestNO%>" readonly="readonly" />
		<%End If%>
		<section class="all">
			<label>
				<input type="checkbox" id="allAgree" onclick="allCheckAgree()" name="allAgree" value="T" />
				<span><%=LNG_JOINSTEP02_U_TEXT07%></span>
			</label>
		</section>

		<section>
			<div class="agree_tit">
				<h6><%=LNG_POLICY_01%></h6>
				<label>
					<input type="checkbox" id="agree01Chk" name="agree01" value="T" />
					<span><%=LNG_TEXT_I_AGREE%></span>
				</label>
			</div>
			<div class="agree_box">
				<div class="agree_content"><%=backword_tag(policyContent1)%></div>
			</div>
		</section>
		<section>
			<div class="agree_tit">
				<h6><%=LNG_POLICY_02%></h6>
				<label>
					<input type="checkbox" id="agree02Chk" name="agree02" value="T" />
					<span><%=LNG_TEXT_I_AGREE%></span>
				</label>
			</div>
			<div class="agree_box">
				<div class="agree_content"><%=backword_tag(policyContent2)%></div>
			</div>
		</section>
		<%If S_SellMemTF = 0 Then%>
		<section>
			<div class="agree_tit">
				<h6><%=LNG_TEXT_BUSINESS_MEMBER%> 약관</h6>
				<label>
					<input type="checkbox" id="agree03Chk" name="agree03" value="T" />
					<span><%=LNG_TEXT_I_AGREE%></span>
				</label>
			</div>
			<div class="agree_box">
				<div class="agree_content"><%=backword_tag(policyContent3)%></div>
			</div>
		</section>
		<%End If%>
		<%If NICE_BANK_WITH_MOBILE_USE <> "T" Then%>
		<div class="btnZone">
			<input type="button" class="cancel" data-ripplet onclick="javascript:history.go(-1);" value="<%=LNG_TEXT_PREVIOUS_STEP%>"/>
			<input type="button" class="promise" onclick="javascript: chkjFrm02();" value="<%=LNG_TEXT_NEXT_STEP%>" />
		</div>
		<%End If%>
	</form>

	<%If NICE_BANK_WITH_MOBILE_USE = "T" Then		'NICE 계좌인증 + 휴대폰 인증%>
		<article class="privacy">
			<div class="btnZone">
				<input type="button" class="cancel" data-ripplet onclick="javascript:history.go(-1);" value="<%=LNG_TEXT_PREVIOUS_STEP%>"/>
				<input type="submit" class="promise" value="휴대폰 본인 인증" onclick="fnPopup();" />
			</div>
		</article>
		<form name="form_chk" method="post">
			<input type="hidden" name="m" value="checkplusSerivce">
			<input type="hidden" name="EncodeData" value="<%= sEncData %>">
		</form>
	<%End If%>

</div>

<!--#include virtual = "/m/_include/copyright.asp"-->