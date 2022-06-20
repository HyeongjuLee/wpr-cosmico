<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	PAGE_SETTING = "JOIN"
	view = 2
	sview = 1
	ISSUBTOP = "T"

	IS_LANGUAGESELECT = "F"
	NO_MEMBER_REDIRECT = "F"

	If DK_MEMBER_LEVEL > 0 Then Response.Redirect "/m/index.asp"

	'▣판매원,소비자 통합
	S_SellMemTF = pRequestTF("S_SellMemTF",True)
	sns_authID = pRequestTF("sns_authID",False) : If sns_authID = "" Then sns_authID = ""
	Select Case S_SellMemTF
		Case 0
			If NICE_MOBILE_CONFIRM_TF = "T" OR NICE_BANK_CONFIRM_TF = "T" Then Call ALERTS(LNG_MEMBER_LOGINOK_ALERT02,"BACK","")
			sview = 2
			LNG_TEXT_BUSINESS_MEMBER = LNG_TEXT_BUSINESS_MEMBER
		Case 1
			sview = 1
			LNG_TEXT_BUSINESS_MEMBER = LNG_TEXT_NORMAL_MEMBER
		Case Else
			Call ALERTS(LNG_MEMBER_LOGINOK_ALERT02,"BACK","")
	End Select


'	Select Case UCase(LANG)
'		Case "KR","MN"
'			If Not checkRef(houUrl &"/m/common/joinStep01.asp") Then	Call alerts(LNG_ALERT_WRONG_ACCESS,"back","")
'		Case Else
'			Call alerts(LNG_ALERT_WRONG_ACCESS,"back","")
'	End Select

	'국가정보
	'R_NationCode = gRequestTF("cnd",True)
	'R_NationCode = Lang

	R_NationCode = LangGLB

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
	If IsNull(policyContent1) Or policyContent1 = "" Then policyContent1 = LNG_JOINSTEP02_U_TEXT01 &"("&DKRS_nationNameEn&")"

	arrParams2 = Array(_
		Db.makeParam("@policyType",adVarChar,adParamInput,10,"policy02"), _
		Db.makeParam("@strNation",adVarChar,adParamInput,10,UCase(R_NationCode)) _
	)
	policyContent2 = Db.execRsData("DKP_POLICY_CONTENT",DB_PROC,arrParams2,Nothing)
	policyContent2 = Replace(policyContent2,"OOO",LNG_SITE_TITLE)
	If IsNull(policyContent2) Or policyContent2 = "" Then policyContent2 = LNG_JOINSTEP02_U_TEXT02 &"("&DKRS_nationNameEn&")"


	arrParams3 = Array(_
		Db.makeParam("@policyType",adVarChar,adParamInput,10,"policy03"), _
		Db.makeParam("@strNation",adVarChar,adParamInput,10,UCase(R_NationCode)) _
	)
	policyContent3 = Db.execRsData("DKP_POLICY_CONTENT",DB_PROC,arrParams3,Nothing)
	policyContent3 = Replace(policyContent3,"OOO",LNG_SITE_TITLE)
	If IsNull(policyContent3) Or policyContent3 = "" Then policyContent3 = LNG_JOINSTEP02_U_TEXT03 &"("&DKRS_nationNameEn&")"



%>
<!--#include virtual = "/m/_include/document.asp"-->
<!--#include virtual = "/m/_include/jqueryload.asp"-->

<script type="text/javascript" src="/m/js/ajax.js"></script>
<!-- <script type="text/javascript" src="joinStep.js"></script>
<script type="text/javascript" src="joinStep02_c.js"></script> -->
<script type="text/javascript">


	function nameChk2(f) {

		if (chkEmpty(f.M_Name_Last)) {
			alert("<%=LNG_JS_FAMILY_NAME%>");
			f.M_Name_Last.focus();
			return false;
		}
		if (chkEmpty(f.M_Name_First)) {
			alert("<%=LNG_JS_GIVEN_NAME%>");
			f.M_Name_First.focus();
			return false;
		}
		if( /[\s]/g.test( f.M_Name_Last.value) == true){
			alert("<%=LNG_JS_NO_SPACE%>(<%=LNG_TEXT_FAMILY_NAME%>)");
			f.M_Name_Last.value=f.M_Name_Last.value.replace(/(\s*)/g,'');
			return false;
		}
		if( /[\s]/g.test( f.M_Name_First.value) == true){
			alert("<%=LNG_JS_NO_SPACE%>(<%=LNG_TEXT_GIVEN_NAME%>)");
			f.M_Name_First.value=f.M_Name_First.value.replace(/(\s*)/g,'');
			return false;
		}

		<%IF Ucase(R_NationCode) = "KR" Then%>
			if (!checkkorText(f.M_Name_Last.value,1)) {
				alert("정확한 한글 성을 입력해 주세요.");
				f.M_Name_Last.focus();
				return false;
			}
			if (!checkkorText(f.M_Name_First.value,1)) {
				alert("정확한 한글 이름을 입력해 주세요.");
				f.M_Name_First.focus();
				return false;
			}
		<%End If%>

		if (!checkSCharNum(f.M_Name_Last.value)) {
			alert("<%=LNG_JS_SPCECIALC_NUM_FORMCHECK%>(<%=LNG_TEXT_FAMILY_NAME%>)");
			f.M_Name_Last.value="";
			f.M_Name_Last.focus();
			return false;
		}
		if (!checkSCharNum(f.M_Name_First.value)) {
			alert("<%=LNG_JS_SPCECIALC_NUM_FORMCHECK%>(<%=LNG_TEXT_GIVEN_NAME%>)");
			f.M_Name_First.value="";
			f.M_Name_First.focus();
			return false;
		}
		if (chkEmpty(f.birthYY) || chkEmpty(f.birthMM) || chkEmpty(f.birthDD)) {
			alert("<%=LNG_JS_BIRTH%>");
			f.birthYY.focus();
			return false;
		}
		if (!checkMinorBirth(f.birthYY, f.birthMM , f.birthDD)) return false;		// 미성년자체크(생년월일)

		/*
		f.target = "hidden";
		f.action = "/common/joinCheck_nc_g.asp";		//PC공통
		*/
		$.ajax({
			type: "POST"
			,async : false
			,url: "/common/ajax_joinCheck_nc_g.asp"
			,data: {
				 "M_Name_Last"	: f.M_Name_Last.value
				,"M_Name_First"	: f.M_Name_First.value
				,"birthYY"		: f.birthYY.value
				,"birthMM"		: f.birthMM.value
				,"birthDD"		: f.birthDD.value
			}
			,success: function(jsonData) {
				//console.log(jsonData);
				var json = $.parseJSON(jsonData);

				if (json.result == "success") {
					alert(json.message);
					$("#agreeFrm input[name=name]").val(json.datas.name);
					$("#agreeFrm input[name=M_Name_Last]").val(json.datas.M_Name_Last);
					$("#agreeFrm input[name=M_Name_First]").val(json.datas.M_Name_First);
					$("#agreeFrm input[name=birthYY]").val(json.datas.birthYY);
					$("#agreeFrm input[name=birthMM]").val(json.datas.birthMM);
					$("#agreeFrm input[name=birthDD]").val(json.datas.birthDD);
				} else {
					alert(json.message);
				}
			}
			,error:function(jsonData) {
				alert("<%=LNG_AJAX_ERROR_MSG%> "+jsonData.status+" "+jsonData.statusText+" "+jsonData.responseText);
			}

		});
		return false;

	}


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

	function checkAgree() {
		var f = document.agreeFrm;
		var g = document.nfrm;
		//var move_agree = $('#agree').offset().top;

		if ($("input[name=agreement]:checked").val() != 'T')
		{
			alert("<%=LNG_JS_POLICY01%>");
			//f.agreement[0].focus();
			//$('html, body').animate( { scrollTop : move_agree }, 400 );
			f.agreement.focus();
			return false;
		}
		if (chkEmpty(g.M_Name_Last)) {
			alert("<%=LNG_JS_FAMILY_NAME%>");
			g.M_Name_Last.focus();
			return false;
		}
		if (chkEmpty(g.M_Name_First)) {
			alert("<%=LNG_JS_GIVEN_NAME%>");
			g.M_Name_First.focus();
			return false;
		}
		if( /[\s]/g.test( g.M_Name_Last.value) == true){
			alert("<%=LNG_JS_NO_SPACE%>(<%=LNG_TEXT_FAMILY_NAME%>)");
			g.M_Name_Last.value=g.M_Name_Last.value.replace(/(\s*)/g,'');
			return false;
		}
		if( /[\s]/g.test( g.M_Name_First.value) == true){
			alert("<%=LNG_JS_NO_SPACE%>(<%=LNG_TEXT_GIVEN_NAME%>)");
			g.M_Name_First.value=g.M_Name_First.value.replace(/(\s*)/g,'');
			return false;
		}

		<%IF Ucase(R_NationCode) = "KR" Then%>
			if (!checkkorText(g.M_Name_Last.value,1)) {
				alert("정확한 한글 성을 입력해 주세요.");
				g.M_Name_Last.focus();
				return false;
			}
			if (!checkkorText(g.M_Name_First.value,1)) {
				alert("정확한 한글 이름을 입력해 주세요.");
				g.M_Name_First.focus();
				return false;
			}
		<%End If%>

		if (!checkSCharNum(g.M_Name_Last.value)) {
			alert("<%=LNG_JS_SPCECIALC_NUM_FORMCHECK%>(<%=LNG_TEXT_FAMILY_NAME%>)");
			g.M_Name_Last.value="";
			g.M_Name_Last.focus();
			return false;
		}
		if (!checkSCharNum(g.M_Name_First.value)) {
			alert("<%=LNG_JS_SPCECIALC_NUM_FORMCHECK%>(<%=LNG_TEXT_GIVEN_NAME%>)");
			g.M_Name_First.value="";
			g.M_Name_First.focus();
			return false;
		}

		if (chkEmpty(g.birthYY) || chkEmpty(g.birthMM) || chkEmpty(g.birthDD)) {
			alert("<%=LNG_JS_BIRTH%>");
			g.birthYY.focus();
			return false;
		}
		if (!checkMinorBirth(g.birthYY, g.birthMM , g.birthDD)) return false;		// 미성년자체크(생년월일)


		if (chkEmpty(f.name)) {
			alert("<%=LNG_JS_DUPLICATION_CHECK%>");
			g.name.focus();
			return false;
		}

		if (chkEmpty(f.birthYY) || chkEmpty(f.birthMM) || chkEmpty(f.birthDD)) {
			alert("<%=LNG_JS_DUPLICATION_CHECK%>!");
			f.birthYY.focus();
			return false;
		}
		if (!checkMinorBirth(f.birthYY, f.birthMM , f.birthDD)) return false;		// 미성년자체크(생년월일)

		if (f.M_Name_Last.value != g.M_Name_Last.value)
		{
			alert("<%=LNG_JS_DUPLICATE_NAME_CHANGE%>(<%=LNG_TEXT_FAMILY_NAME%>)\n<%=LNG_JS_DUPLICATION_CHECK%>");
			g.M_Name_Last.focus();
			return false;
		}
		if (f.M_Name_First.value != g.M_Name_First.value)
		{
			alert("<%=LNG_JS_DUPLICATE_NAME_CHANGE%>(<%=LNG_TEXT_GIVEN_NAME%>)\n<%=LNG_JS_DUPLICATION_CHECK%>");
			g.M_Name_First.focus();
			return false;
		}
		if (f.birthYY.value != g.birthYY.value || f.birthMM.value != g.birthMM.value || f.birthDD.value != g.birthDD.value)
		{
			alert("<%=LNG_JS_DUPLICATE_BIRTH_CHANGE%>\n<%=LNG_JS_DUPLICATION_CHECK%>");
			g.birthYY.value='';
			g.birthMM.value='';
			g.birthDD.value='';
			g.birthYY.focus();
			return false;
		}
		f.submit();

	}



</script>
<link rel="stylesheet" href="/m/js/icheck/skin/line/_all.css" />
<script src="/m/js/icheck/icheck.min.js"></script>
<script type="text/javascript" src="joinStep.js"></script>
<style type="text/css">
</style>
<script type="text/javascript">
	$(document).ready(function(){
		$('.list li').click(function(){
			$(this).toggleClass('on');
		});
	});
</script>
</head>
<body onunload="">
<!--#include virtual = "/m/_include/header.asp"-->
<iframe src="/hiddens.asp" name="hidden" frameborder="0" border="0" width="0" height="0" style="display:none;"></iframe>
<div id="join02" class="joinstep">
	<form name="agreeFrm" id="agreeFrm" method="post" action="joinStep_n03_g.asp<%=ptshop%>" onsubmit="">
		<input type="hidden" name="S_SellMemTF" value="<%=S_SellMemTF%>" readonly />
		<input type="hidden" name="cnd" value="<%=R_NationCode%>" readonly />
		<input type="hidden" name="name" value="" readonly="readonly" />
		<input type="hidden" name="M_Name_Last" value="" readonly="readonly" />
		<input type="hidden" name="M_Name_First" value="" readonly="readonly" />
		<input type="hidden" name="birthYY" value="" readonly="readonly" />
		<input type="hidden" name="birthMM" value="" readonly="readonly" />
		<input type="hidden" name="birthDD" value="" readonly="readonly" />
		<input type="hidden" name="For_Kind_TF" value="1" readonly="readonly" />
		<input type="hidden" name="sns_authID" value="<%=sns_authID%>" readonly="readonly" />

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
					<input type="checkbox" id="agree01Chk" name="agreement" value="T" />
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
					<input type="checkbox" id="agree02Chk" name="gather" value="T" />
					<span><%=LNG_TEXT_I_AGREE%></span>
				</label>
			</div>
			<div class="agree_box">
				<div class="agree_content"><%=backword_tag(policyContent2)%></div>
			</div>
		</section>
		<%If S_SellMemTF = 0 Then%>
		<section>
			<h6><%=LNG_POLICY_03%></h6>
			<label>
				<input type="checkbox" id="agree03Chk" name="company" value="T" />
				<span><%=LNG_TEXT_I_AGREE%></span>
			</label>
			<div class="agree_box">
				<div class="agree_content"><%=backword_tag(policyContent3)%></div>
			</div>
		</section>
		<%End IF%>
	</form>

	<article class="privacy">
		<h6><%=LNG_TEXT_MEMBER_REGIST_CHECK%><p><%=LNG_TEXT_CLASS_P%></p></h6>
		<div class="info">
			<%
				If UCase(R_NationCode) = "KR" Then
					IMES_MODE = " ime-mode:active;"
			%>
			<p><span class="e"><%=DKCONF_SITE_TITLE%></span>은 회원의 소중한 개인정보를 안전하게 보호하고 있으며 개인정보 보호 정책을 준수합니다.</p>
			<%
				Else
					IMES_MODE = " ime-mode:disabled;"
				End If
			%>

			<form name="nfrm" method="post" action="joinCheck_nc2.asp" onSubmit="return nameChk2(this)"  />
				<table <%=tableatt%>>
					<col width="60" />
					<col width="" />
					<col width="60" />
					<col width="" />
					<tr>
						<th><%=LNG_TEXT_FAMILY_NAME%>&nbsp;<%=starText%></th>
						<td><input type="text" name="M_Name_Last" style="<%=IMES_MODE%>" placeholder="<%=LNG_TEXT_FAMILY_NAME%>"/></td>
						<th><%=LNG_TEXT_GIVEN_NAME%>&nbsp;<%=starText%></th>
						<td><input type="text" name="M_Name_First" style="<%=IMES_MODE%>" placeholder="<%=LNG_TEXT_GIVEN_NAME%>"/></td>
					</tr>
					<tr>
						<th><%=LNG_TEXT_BIRTH%> <%=starText%></th>
						<td class="middleTD" colspan="4">
							<select name = "birthYY">
								<option value=""></option>
								<%For i = MIN_YEAR To MAX_YEAR%>
									<option value="<%=i%>" ><%=i%></option>
								<%Next%>
							</select>
							<select name = "birthMM">
								<option value=""></option>
								<%For j = 1 To 12%>
									<%jsmm = Right("0"&j,2)%>
									<option value="<%=jsmm%>" ><%=jsmm%></option>
								<%Next%>
							</select>
							<select name = "birthDD">
								<option value=""></option>
								<%For k = 1 To 31%>
									<%ksdd = Right("0"&k,2)%>
									<option value="<%=ksdd%>" ><%=ksdd%></option>
								<%Next%>
							</select>
							<!-- <span>(yyyy/mm/dd)</span> -->
						</td>
					</tr>
					<tr>
						<td colspan="4" class="tcenter"><input type="submit" class="button" value="<%=LNG_TEXT_DOUBLE_CHECK%>" /></td>
					</tr>
				</table>
			</form>
		</div>

		<div class="btnZone">
			<input type="button" class="cancel" data-ripplet onclick="javascript:history.go(-1);" value="<%=LNG_TEXT_PREVIOUS_STEP%>"/>
			<input type="button" class="promise" onclick="javascript: checkAgree();" value="<%=LNG_TEXT_NEXT_STEP%>" />
		</div>
	</article>
</div>
<!--#include virtual = "/m/_include/copyright.asp"-->