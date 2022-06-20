<!--#include virtual="/_lib/strFunc.asp" -->
<%
	pT = gRequestTF("pt",False)
	If pt = "" Then pt = ""

	If pT = "shop" Then
		PAGE_SETTING = "SHOP_MEMBERSHIP"
		ptshop = "?pt=shop"
	Else
		PAGE_SETTING = "MEMBERSHIP"
		ptshop = ""
	End If

'	If UCase(LANG) <> "KR" Then
'		Response.Redirect "joinStep02_u.asp"
'	End If


	'PAGE_SETTING = "MEMBERSHIP"
	ISLEFT = "T"
	ISSUBTOP = "T"
	ISSUBVISUAL = "T"
	view = 1
	sview = 4

	If DK_MEMBER_LEVEL > 0 Then Response.Redirect "/index.asp"

	'If Not checkRef(houUrl &"/common/joinStep01_nation.asp") Then Call alerts("잘못된 접근입니다.","go","/common/joinStep01.asp")
	If Not checkRef(houUrl &"/common/joinStep01.asp") Then Call alerts("잘못된 접근입니다.","go","/common/joinStep01.asp")

	'국가정보
	R_NationCode = gRequestTF("cnd",True)
	arrParams = Array(_
		Db.makeParam("@nationCode",adVarChar,adParamInput,20,R_NationCode) _
	)
	Set DKRS = Db.execRs("DKP_MEMBER_JOIN_CHK_NATION",DB_PROC,arrParams,DB3)
	If Not DKRS.BOF And Not DKRS.EOF Then
		DKRS_nationNameEn	= DKRS("nationNameEn")
		DKRS_nationCode		= DKRS("nationCode")
		DKRS_className		= DKRS("className")
	Else
		Call ALERTS("We are sorry. The country code is not valid.","back","")
	End If



	arrParams1 = Array(_
		Db.makeParam("@policyType",adVarChar,adParamInput,10,"policy01"), _
		Db.makeParam("@strNation",adVarChar,adParamInput,10,UCase(R_NationCode)) _
	)
	policyContent1 = Db.execRsData("DKP_POLICY_CONTENT",DB_PROC,arrParams1,Nothing)
	policyContent1 = Replace(policyContent1,"OOO",LNG_SITE_TITLE)
	If IsNull(policyContent1) Or policyContent1 = "" Then policyContent1 = "사이트 이용약관이 등록되지 않았습니다."

	arrParams2 = Array(_
		Db.makeParam("@policyType",adVarChar,adParamInput,10,"policy02"), _
		Db.makeParam("@strNation",adVarChar,adParamInput,10,UCase(R_NationCode)) _
	)
	policyContent2 = Db.execRsData("DKP_POLICY_CONTENT",DB_PROC,arrParams2,Nothing)
	policyContent2 = Replace(policyContent2,"OOO",LNG_SITE_TITLE)
	If IsNull(policyContent2) Or policyContent2 = "" Then policyContent2 = "개인정보취급방침이 등록되지 않았습니다."


	arrParams3 = Array(_
		Db.makeParam("@policyType",adVarChar,adParamInput,10,"policy03"), _
		Db.makeParam("@strNation",adVarChar,adParamInput,10,UCase(R_NationCode)) _
	)
	policyContent3 = Db.execRsData("DKP_POLICY_CONTENT",DB_PROC,arrParams3,Nothing)
	policyContent3 = Replace(policyContent3,"OOO",LNG_SITE_TITLE)
	If IsNull(policyContent3) Or policyContent3 = "" Then policyContent3 = "사업자회원 가입약관이 등록되지 않았습니다."


%>
<!--#include virtual="/_include/document.asp" -->
<link rel="stylesheet" href="/css/join.css" />
<script type="text/javascript" src="/jscript/joinStep02_c.js"></script>
</head>
<body>
<!--#include virtual="/_include/header.asp" -->
<!--#include virtual = "/_include/sub_title.asp"-->
<!-- <p><%=viewImg(IMG_JOIN&"/join_title.jpg",780,130,"")%></p> -->

<iframe src="/hiddens.asp" name="hidden" frameborder="0" border="0" width="0" height="0" style="display:none;"></iframe>
<div id="join" style="">
	<div class="joinInner userCWidth2">
		<form name="agreeFrm" method="post" action="joinStep03_c.asp<%=ptshop%>" onsubmit="return chkAgree(this);">
			<input type="hidden" name="cnd" value="<%=R_NationCode%>" readonly />
			<input type="hidden" name="name" value="" readonly="readonly" />
			<input type="hidden" name="ssh1" value="" readonly="readonly" />
			<input type="hidden" name="ssh2" value="" readonly="readonly" />
			<p class="sub_desc"><%=viewImg("/images_"&R_NationCode&"/join/joinStep02_title.gif",360,70,"")%></p>
			<p style="margin-top:20px;"><%=viewImg("/images_"&R_NationCode&"/join/join_agree_tit_01.gif",215,33,"")%></p>
			<div class="agree_box"><%=backword_tag(policyContent1)%></div>
			<p class="agreeArea"><label><input type="checkbox" name="agreement" value="T" id="agree01Chk" class="input_chk3" /> 이용약관에 동의합니다.</label>
			<p><%=viewImg("/images_"&R_NationCode&"/join/join_agree_tit_03.gif",215,33,"")%></p>
			<div class="agree_box"><%=backword_tag(policyContent3)%></div>
			<p class="agreeArea"><label><input type="checkbox" name="company" value="T" id="agree02Chk" class="input_chk3" /> 사업자회원 가입약관에 동의합니다.</label>
			<p><%=viewImg("/images_"&R_NationCode&"/join/join_agree_tit_02.gif",215,33,"")%></p>
			<div class="agree_box"><%=backword_tag(policyContent2)%></div>
			<p class="agreeArea"><label><input type="checkbox" name="gather" value="T" id="agree03Chk" class="input_chk3" /> 개인정보취급방침에 동의합니다.</label>
		</form>
		<div class="clear allAgree"><label><input type="checkbox" name="allAgree" id="allAgree" value="T" class="input_chk3" onclick="allCheckAgree();" /> 모든 약관에 동의합니다.</label></div>

		<p style="margin:0 auto;margin-top:50px;margin-bottom:20px; font-weight:bold; line-height:18px; width:80%; padding:20px; border:1px solid #ccc; background-color:#eee;text-align:center;">
		<%=DKCONF_SITE_TITLE%>은 회원의 소중한 개인정보를 안전하게 보호하고 있으며 개인정보 보호 정책을 준수합니다.<br />
		<!-- <br />
		<%=DKCONF_SITE_TITLE%>은 <span style="color:#444;">“방문판매 등에 관한 법률 시행규칙”</span>의 <span style="color:#444;">“제15조(다단계판매원의 등록신청) 1항”</span>에 따라 회원(판매원) 가입시 주민등록번호를	수집하고 있으며 <span style="color:#444;">“동조 2항”</span>에 따른 <span style="color:#444;">“전자서명법 제2조 제3호”</span>에 따른 공인전자서명 또는 이에 준하는 암호화 기술을 통하여 주민등록번호를 수집, 전송하고 있습니다. -->
		</p>

		<div class="chkArea clear">
			<div class="join_area02">
				<form name="nfrm" method="post" action="joinCheck_c.asp" onSubmit="return nameChk(this)"  />
				<div class="check_area">
					<ul>
						<li class="li_first"><%=viewImg(IMG_JOIN&"/join02_name.gif",38,23,"")%></li>
						<li><input type="text" name="name" class="input_text imes_kr" value="" style="width:120px;" /></li>
						<li class="ssh"><%=viewImg(IMG_JOIN&"/join02_ssh.gif",76,23,"")%></li>
						<li><input type="text" name="ssh1" class="input_text" style="width:80px;" value="" maxlength="6" onkeyup="numberOnly(this); goNextFocusChk(this, 6, this.form.ssh2);" onblur="numberOnly(this)" /> - <input type="password" name="ssh2" class="input_text" style="width:90px;" value="" maxlength="7"  onkeyup="numberOnly(this)" onblur="numberOnly(this)" /></li>
						<li class="li_last"><input type="image" src="<%=IMG_JOIN%>/join02_btn_submit.gif" style="width:85px;height:23px;" class="block" /></li>
					</ul>
				</div>
				</form>
				<!-- <p><%=viewImgSt(IMG_JOIN&"/join02_alert.gif",650,57,"","margin-top:20px;","")%></p> -->
			</div>
		</div>
		<div class="tcenter" style="margin-top:40px;height:80px;">
			<!-- <%=viewImgStJS(IMG_JOIN&"/btn_agreeSubmit.gif",99,40,"","margin-top:20px;","cp","onclick=""checkAgree();""")%>
			<%=viewImgOpt(IMG_JOIN&"/btn_agreeCancel.gif",169,40,"","style=""margin-left:6px;""")%> -->
			<span><input type="submit" class="txtBtnC large radius10 blue" onclick="checkAgree();" value="가입동의"/></span>
			<span class="pL10"><input type="button" class="txtBtnC large radius10 gray" onclick="javascript:history.go(-1);" value="동의하지 않습니다"/></span>
		</div>

	</div>

</div>
<!--#include virtual="/_include/copyright.asp" -->
