<!--#include virtual = "/_lib/strFunc.asp"-->
<%

	PAGE_SETTING = "JOIN"



''	If DK_MEMBER_LEVEL > 0 Then Response.Redirect "/m/index.asp"
''	If Not checkRef(houUrl &"/m/common/joinStep01.asp") Then Call alerts("잘못된 접근입니다.","go","/m/common/joinStep01.asp")

	Call ONLY_BUSINESS_MEMBER(DK_MEMBER_LEVEL,2)

	If CDbl(DKRSG_Down_Month_Count) < 100 Then Call ALERTS(LNG_JS_NO_DUPLICATE_MEMBER_JOIN,"back","")		'gng 다구좌등록 (= 후원 소실적 누적PV 라인 인원 50명 이상)


	'▣▣▣GNG 후원인선택 (추천인의 후원조직중 선택, 20170512)▣▣▣
	arrParams2 = Array(_
		Db.makeParam("@mbid",adVarChar,adParamInput,20,DK_MEMBER_ID1), _
		Db.makeParam("@mbid2",adInteger,adParamInput,0,DK_MEMBER_ID2) _
	)
	Set DKRS = Db.execRs("DKP_MEMBER_INFO",DB_PROC,arrParams2,DB3)
	If Not DKRS.BOF And Not DKRS.EOF Then
		RS_M_Name			= DKRS("M_Name")
		RS_BirthDay			= DKRS("BirthDay")
		RS_BirthDay_M		= DKRS("BirthDay_M")
		RS_BirthDay_D		= DKRS("BirthDay_D")
	Else
		Call ALERTS(LNG_JS_MEMBERINFO_FAIL,"back","")
	End If
	Call closeRS(DKRS)

	'▣ CS 이름 + 생년월일 중복체크
	SQL = "SELECT COUNT([mbid]) FROM [tbl_memberinfo] WHERE [M_Name] = ? And [BirthDay] = ? And [BirthDay_M] = ? And [BirthDay_D] = ? "		'→ 전체회원중복체크
	SQL = SQL & "  AND NOT ( mbid = ? AND mbid2 = ?)"																						'	본인제외
	arrParams = Array(_
		Db.makeParam("@M_Name",adVarWchar,adParamInput,100,RS_M_Name), _
		Db.makeParam("@BirthDay",adVarchar,adParamInput,4,RS_BirthDay), _
		Db.makeParam("@BirthDay_M",adVarchar,adParamInput,2,RS_BirthDay_M), _
		Db.makeParam("@BirthDay_D",adVarchar,adParamInput,2,RS_BirthDay_D), _
			Db.makeParam("@mbid1",adVarChar,adParamInput,20,DK_MEMBER_ID1), _
			Db.makeParam("@mbid2",adInteger,adParamInput,0,DK_MEMBER_ID2) _
	)
	DbCheckMember = CInt(Db.execRsData(SQL,DB_TEXT,arrParams,DB3))

	If CDbl(DbCheckMember) >= 2 Then
		'Call alerts("다구좌 회원등록 최대인원을 초과하였습니다.","BACK","")
		Call alerts(LNG_JS_OVER_DUPLICATE_MEMBER,"BACK","")
	End If









	'국가정보
	''R_NationCode = gRequestTF("cnd",True)
	R_NationCode = DK_MEMBER_NATIONCODE		'소속 국가코드
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
		Db.makeParam("@policyType",adVarChar,adParamInput,10,"policy01"),_
		Db.makeParam("@strNation",adVarChar,adParamInput,10,R_NationCode) _
	)
	policyContent1 = Db.execRsData("DKP_POLICY_CONTENT",DB_PROC,arrParams1,Nothing)

	If IsNull(policyContent1) Or policyContent1 = "" Then policyContent1 = LNG_JOINSTEP02_U_TEXT01 &"("&DKRS_nationNameEn&")"

	arrParams2 = Array(_
		Db.makeParam("@policyType",adVarChar,adParamInput,10,"policy02"),_
		Db.makeParam("@strNation",adVarChar,adParamInput,10,R_NationCode) _
	)
	policyContent2 = Db.execRsData("DKP_POLICY_CONTENT",DB_PROC,arrParams2,Nothing)

	If IsNull(policyContent2) Or policyContent2 = "" Then policyContent2 = LNG_JOINSTEP02_U_TEXT02 &"("&DKRS_nationNameEn&")"

	arrParams3 = Array(_
		Db.makeParam("@policyType",adVarChar,adParamInput,10,"policy03"),_
		Db.makeParam("@strNation",adVarChar,adParamInput,10,R_NationCode) _
	)
	policyContent3 = Db.execRsData("DKP_POLICY_CONTENT",DB_PROC,arrParams3,Nothing)

	If IsNull(policyContent3) Or policyContent3 = "" Then policyContent3 = LNG_JOINSTEP02_U_TEXT03 &"("&DKRS_nationNameEn&")"



%>
<%
	arrParams = Array(_
		Db.makeParam("@mbid",adVarChar,adParamInput,20,DK_MEMBER_ID1), _
		Db.makeParam("@mbid2",adInteger,adParamInput,0,DK_MEMBER_ID2) _
	)
	Set DKRS = Db.execRs("DKP_MEMBER_INFO",DB_PROC,arrParams,DB3)
	If Not DKRS.BOF And Not DKRS.EOF Then
		DKRS_M_Name			= DKRS("M_Name")
		DKRS_BirthDay		= DKRS("BirthDay")
		DKRS_BirthDay_M		= DKRS("BirthDay_M")
		DKRS_BirthDay_D		= DKRS("BirthDay_D")
	Else
		Call ALERTS(LNG_JS_MEMBERINFO_FAIL,"BACK","")
	End If
	Call closeRS(DKRS)
%>
<!--#include virtual = "/m/_include/document.asp"-->
<!--#include virtual = "/m/_include/jqueryload.asp"-->
<style type="text/css">
	#join_c .stit {font-size: 18px;}
	#join_c div.list {width: 100%; overflow: hidden;}
	#join_c div.list ul {margin: 25px auto; width: 94%;}
	#join_c div.list h3 {position: relative; overflow: hidden; background-color: #2cb6b9; margin-bottom: 1px; cursor: pointer; text-align: left; padding: 10px 15px;}
	#join_c div.list h3 p {color: #fff; font-weight: 400; font-size: 15px; line-height: 26px; width: 92%; float: left;}
	#join_c div.list h3 span {position: absolute; width: 20px; height: 20px; border-radius: 20px; border: 1px solid #fff; top: 50%; margin-top: -10px; right: 15px;}
	#join_c div.list h3 span i {position: absolute; background-color: #fff; width: 6px; height: 1px; top: 50%;}
	#join_c div.list h3 span i.i01 {transform: rotate(40deg); left: 5px;}
	#join_c div.list h3 span i.i02 {transform: rotate(-40deg); right: 5px;}
	#join_c div.list h3 span.on {width: 30px;}

	#join_c div.list .agArea {background: #fff; padding: 15px; margin-bottom: 10px; overflow-y: scroll; height: 300px; font-size: 13px; margin-top: -1px; border-top: 10px solid #fff; border-bottom: 10px solid #fff;}

	#join_c .join_btn {width: 100%; margin: 15px 0;}
	#join_c .join_btn input {border: none; background: #2c8cca; color: #fff; padding: 12px; width: 100%;border-radius: 3px;}
	#join_c .join_btn .inner {width: 95%; overflow: hidden;}
	#join_c .join_btn .inner div {width: 49%;}
	#join_c .join_btn .fleft input {background: #777;}
	#join_c .join_btn .fright input {background: #ad0d0d;}
</style>

<script type="text/javascript" src="/m/js/ajax.js"></script>
<script type="text/javascript" src="/m/common/joinStep.js"></script>
<script type="text/javascript">
<!--
	//이름, 생년월일 중복체크

	function nameChk2(f) {
		if (chkEmpty(f.name)) {
			alert("<%=LNG_JS_NAME%>");
			f.name.focus();
			return false;
		}
		if( /[\s]/g.test( f.name.value) == true){
			alert("<%=LNG_JS_NO_SPACE%>");
			f.name.value=f.name.value.replace(/(\s*)/g,'');
			return false;
		}
		<%IF Ucase(R_NationCode) = "KR" Then%>
			if (!checkkorText(f.name.value,2)) {
				alert("정확한 한글 이름을 입력해 주세요.");
				f.name.focus();
				return false;
			}
		<%End If%>
		if (!checkSCharNum(f.name.value)) {
			alert("<%=LNG_JS_SPCECIALC_NUM_FORMCHECK%>");
			f.name.value="";
			f.name.focus();
			return false;
		}
		if (chkEmpty(f.birthYY) || chkEmpty(f.birthMM) || chkEmpty(f.birthDD)) {
			alert("<%=LNG_JS_BIRTH%>");
			f.birthYY.focus();
			return false;
		}
		if (!checkMinorBirth(f.birthYY, f.birthMM , f.birthDD)) return false;		// 미성년자체크(생년월일)

		f.target = "hidden";
		f.action = "uderJoinCheck.asp";
	}


	function allCheckAgree() {
		if (document.getElementById("allAgree").checked == true)
		{
			document.getElementById("agree01Chk").checked = true;
			document.getElementById("agree02Chk").checked = true;
			document.getElementById("agree03Chk").checked = true;
	//		document.getElementById("agree04Chk").checked = true;
		} else if (document.getElementById("allAgree").checked == false)	{
			document.getElementById("agree01Chk").checked = false;
			document.getElementById("agree02Chk").checked = false;
			document.getElementById("agree03Chk").checked = false;
	//		document.getElementById("agree04Chk").checked = false;
		}
	}


	function checkAgree() {
		var f = document.agreeFrm;
		var g = document.nfrm;

		if ($("input[name=agreement]:checked").val() != 'T')
		{
			alert("<%=LNG_JS_POLICY01%>");
			f.agreement[0].focus();
			return false;
		}

		if (chkEmpty(g.name)) {
			alert("<%=LNG_JS_NAME%>");
			g.name.focus();
			return false;
		}
		<%IF Ucase(R_NationCode) = "KR" Then%>
			if (!checkkorText(g.name.value,2)) {
				alert("정확한 한글 이름을 입력해 주세요");
				g.name.focus();
				return false;
			}
		<%End If%>
		if( /[\s]/g.test( g.name.value) == true){
			alert("<%=LNG_JS_NO_SPACE%>");
			g.name.value=g.name.value.replace(/(\s*)/g,'');
			return false;
		}
		if (!checkSCharNum(g.name.value)) {
			alert("<%=LNG_JS_SPCECIALC_NUM_FORMCHECK%>");
			g.name.value="";
			g.name.focus();
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
			alert("<%=LNG_JS_DUPLICATION_CHECK%>");
			f.birthYY.focus();
			return false;
		}
		if (!checkMinorBirth(f.birthYY, f.birthMM , f.birthDD)) return false;		// 미성년자체크(생년월일)


		if (f.name.value != g.name.value)
		{
				alert("<%=LNG_JS_DUPLICATE_NAME_CHANGE%>\n<%=LNG_JS_DUPLICATION_CHECK%>");
				g.name.focus();
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


//-->
</script>
<link rel="stylesheet" href="/m/css/common.css" />
<link rel="stylesheet" href="/m/js/icheck/skin/line/_all.css" />
<link rel="stylesheet" href="/m/css/membership.css" />
<script src="/m/js/icheck/icheck.min.js"></script>
</head>
<body onunload="">
<!--#include virtual = "/m/_include/header.asp"-->
<div id="join_c" class="memberWrap">
	<div class="tit"><!-- 회원가입 --><%=LNG_MYOFFICE_MEMBER_05%><i></i></div>
	<div class="stit"><%=LNG_JOINSTEP02_U_STITLE01%></div>

	<iframe src="/hiddens.asp" name="hidden" frameborder="0" border="0" width="0" height="0" style="display:none;"></iframe>



	<div class="list">
		<form name="agreeFrm" method="post" action="underJoin02.asp<%=ptshop%>" onsubmit="">
			<input type="hidden" name="cnd" value="<%=R_NationCode%>" readonly />
			<input type="hidden" name="name" value="" readonly="readonly" />
			<!-- <input type="hidden" name="ssh1" value="" readonly="readonly" />
			<input type="hidden" name="ssh2" value="" readonly="readonly" /> -->
			<input type="hidden" name="birthYY" value="" readonly="readonly" />
			<input type="hidden" name="birthMM" value="" readonly="readonly" />
			<input type="hidden" name="birthDD" value="" readonly="readonly" />
			<ul>
				<li>
					<h3 onclick="toggle_ee('ag01');"><p><%=LNG_JOINSTEP02_U_TEXT04%></p>
						<span><i class="i01"></i><i class="i02"></i></span>
					</h3>
					<div id="ag01" class="agArea" style="display:none;"><%=policyContent1%></div>
				</li>
				<li>
					<h3 onclick="toggle_ee('ag03');"><p><%=LNG_JOINSTEP02_U_TEXT05%></p>
						<span><i class="i01"></i><i class="i02"></i></span>
					</h3>
					<div id="ag03" class="agArea" style="display:none;"><%=policyContent3%></div>
				</li>
				<li>
					<h3 onclick="toggle_ee('ag02');"><p><%=LNG_JOINSTEP02_U_TEXT06%></p>
						<span><i class="i01"></i><i class="i02"></i></span>
					</h3>
					<div id="ag02" class="agArea" style="display:none;"><%=policyContent2%></div>
				</li>
			</ul>
			<div class="porel" style="height:40px; margin:20px 10px 0px 10px; border-bottom:1px solid #eee;padding-bottom:10px;">
				<%
					'red / green / blue / aero / grey / orange / yellow / pink / purple
					RColor01 = "red"
					RColor02 = "grey"
				%>
				<div class="fleft" style="width:100%; ">
					<div class="skin-<%=RColor01%>"><input type="radio" name="agreement" value="T"/><label><%=LNG_JOINSTEP02_U_STITLE01%></label></div>
				</div>
				<!-- <div class="fright" style="width:49%;">
					<div class="skin-<%=RColor02%>"><input type="radio" name="agreement" value="F" /><label>약관 미동의</label></div>
				</div> -->
			</div>
		</form>
		<%If UCase(DK_MEMBER_NATIONCODE) = "KR" Then %>
		<div class="in_content"><div class="alert3">
			<%=DKCONF_SITE_TITLE%>는 회원의 소중한 개인정보를 안전하게 보호하고 있으며 개인정보 보호 정책을 준수합니다.
		</div>
		<%End If%>
		</div>

		<script type="text/javascript">
		<!--
			$(document).ready(function() {
				//Select readOnly
				$("#birthYY option[value!=<%=DKRS_BirthDay%>]").remove();
				$("#birthMM option[value!=<%=DKRS_BirthDay_M%>]").remove();
				$("#birthDD option[value!=<%=DKRS_BirthDay_D%>]").remove();
			});
		// -->
		</script>
		<div class="join_area02 width95a">
			<form name="nfrm" method="post" action="joinCheck_nc.asp" onSubmit="return nameChk2(this)"  />
				<div class="join">
					<table <%=tableatt%> class="width100 infoForm">
						<col width="105" />
						<col width="*" />
						<tr>
							<th><%=LNG_TEXT_NAME%></th>
							<td><input type="text" class="input_text readonly" name="name" value="<%=DKRS_M_Name%>" style="width:90%;" readonly="readonly" /></td>
						</tr><tr>
							<th><%=LNG_TEXT_BIRTH%></th>
							<td style="line-height:36px;">
								<select name = "birthYY" id="birthYY" class="vmiddle readonly" style="width:60px;">
									<option value=""></option>
									<%For i = MIN_YEAR To MAX_YEAR%>
										<option value="<%=i%>" <%=isSelect(i,DKRS_BirthDay)%> ><%=i%></option>
									<%Next%>
								</select> <!-- 년 -->
								<select name = "birthMM" id="birthMM" class="vmiddle readonly" style="width:45px;">
									<option value=""></option>
									<%For j = 1 To 12%>
										<%jsmm = Right("0"&j,2)%>
										<option value="<%=jsmm%>" <%=isSelect(jsmm,DKRS_BirthDay_M)%>><%=jsmm%></option>
									<%Next%>
								</select> <!-- 월 -->
								<select name = "birthDD" id="birthDD" class="vmiddle readonly" style="width:45px;">
									<option value=""></option>
									<%For k = 1 To 31%>
										<%ksdd = Right("0"&k,2)%>
										<option value="<%=ksdd%>"<%=isSelect(ksdd,DKRS_BirthDay_D)%>><%=ksdd%></option>
									<%Next%>
								</select> <!-- 일 -->

								<!-- 앞자리 : <input type="password" name="strSSH1" maxlength="6" class="input_text" placeholder="앞자리" value="" /><br />
								뒷자리 : <input type="password" name="strSSH2" value="" maxlength="7" class="input_text" placeholder="뒤 7자리" /> -->
							</td>
						</tr>
						<!-- <tr>
							<th>주민등록번호</th>
							<td style="line-height:36px;">
								앞자리 : <input type="password" name="ssh1" maxlength="6" class="input_text" placeholder="앞자리" value="" /><br />
								뒷자리 : <input type="password" name="ssh2" value="" maxlength="7" class="input_text" placeholder="뒤 7자리" />
							</td>
						</tr> -->
					</table>
					<div class="join_btn" >
						<input type="submit" value="<%=LNG_TEXT_DOUBLE_CHECK%>" onclick="" />
					</div>
				</div>
			</form>
		</div>
		<!-- <div class="in_content"><div class="alert">2006년 9월 24일 개정된 주민등록법 개정에 따라 타인의 주민등록번호를 도용하여 온라인 사이트에 가입을 하는 행위 등 다른 사람의 주민등록번호를 부정 사용하는 자는 3년 이하의 징역 또는 1천만원 이하의 벌금형에 처해질 수 있습니다.</div></div> -->

		<div class="join_btn">
			<div class="inner">
				<!-- <div class="fleft"><input type="button" onclick="javascript:history.go(-1);" value="동의하지 않습니다"/></div> -->
				<div class="fright" style="width:100%;"><input type="submit" onclick="javascript:return checkAgree();" value="<%=LNG_TEXT_NEXT_STEP%>"/></div>
			</div>
		</div>

		<script>
			$(document).ready(function(){
				$('.skin-<%=RColor01%> input').each(function(){
					var self = $(this),
					label = self.next(),
					label_text = label.text();

					label.remove();
					self.iCheck({
						checkboxClass: 'icheckbox_line-<%=RColor01%>',
						radioClass: 'iradio_line-<%=RColor01%>',
						insert: '<div class="icheck_line-icon"></div>' + label_text
					});
				});

				$('.skin-<%=RColor02%> input').each(function(){
					var self = $(this),
					label = self.next(),
					label_text = label.text();

					label.remove();
					self.iCheck({
						checkboxClass: 'icheckbox_line-<%=RColor02%>',
						radioClass: 'iradio_line-<%=RColor02%>',
						insert: '<div class="icheck_line-icon"></div>' + label_text
					});
				});
			});
		</script>
	</div>
<!--#include virtual = "/m/_include/copyright.asp"-->