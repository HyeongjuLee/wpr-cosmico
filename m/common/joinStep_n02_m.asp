<!--#include virtual = "/_lib/strFunc.asp"-->
<%
'Call WRONG_ACCESS()

	PAGE_SETTING = "JOIN"

	IS_LANGUAGESELECT = "F"

	If DK_MEMBER_LEVEL > 0 Then Response.Redirect "/m/index.asp"

	'▣판매원,소비자 통합
	S_SellMemTF = pRequestTF("S_SellMemTF",True)
	Select Case S_SellMemTF
		Case 0
			sview = 6
			LNG_TEXT_BUSINESS_MEMBER = LNG_TEXT_BUSINESS_MEMBER
		Case 1
			sview = 3
			LNG_TEXT_BUSINESS_MEMBER = LNG_TEXT_NORMAL_MEMBER
		Case Else
			Call ALERTS(LNG_MEMBER_LOGINOK_ALERT02,"BACK","")
	End Select

	Select Case UCase(LANG)
		Case "KR"
			If Not checkRef(houUrl &"/m/common/joinStep_n01_m.asp") Then Call alerts(LNG_ALERT_WRONG_ACCESS,"back","")
		Case Else
			Call alerts(LNG_ALERT_WRONG_ACCESS,"back","")
	End Select

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

%>
<%
'#####################################
'	NICE 본인인증(핸드폰)
'#####################################

	sRequestNO = pRequestTF("sRequestNO",True)
	sResponseNumber = pRequestTF("sResponseNumber",False)
	sCheckKey = pRequestTF("sCheckKey",False)

	If sCheckKey = "cordova" Then	'앱에서 넘어온 값이라면 session 변경
		session("REQ_SEQ") = sRequestNO
		SESSION("sResponseNumber") = sResponseNumber
	End If

	If session("REQ_SEQ") <> sRequestNO Then Call ALERTS("세션값이 다릅니다. 올바른 경로로 접근하시기 바랍니다","go","/m/common/joinStep01.asp")


	'▣ 인증 데이터 확인 S

		sResponseNumber = SESSION("sResponseNumber")

		If sResponseNumber = "" Then sResponseNumber = ""

'		PRINT sRequestNO & " <br />"
'		print sResponseNumber
'		Response.End

		SQLM = "SELECT * FROM [DKT_MEMBER_MOBILE_AUTH] WITH(NOLOCK) WHERE [sRequestNumber] = ? AND [sType] = 'JOIN' AND [sResponseNumber] = ?"
		arrParamsM = Array(_
			Db.makeParam("@sRequestNO",adVarChar,adParamInput,30,sRequestNO), _
			Db.makeParam("@sResponseNumber",adVarChar,adParamInput,30,sResponseNumber) _
		)
		Set DKRSM = Db.execRs(SQLM,DB_TEXT,arrParamsM,Nothing)

		If Not DKRSM.BOF And Not DKRSM.EOF Then

			DKRSM_intIDX			= DKRSM("intIDX")
			DKRSM_sType				= DKRSM("sType")
			DKRSM_sCipherTime		= DKRSM("sCipherTime")
			DKRSM_sRequestNumber	= DKRSM("sRequestNumber")
			DKRSM_sResponseNumber	= DKRSM("sResponseNumber")
			DKRSM_sAuthType			= DKRSM("sAuthType")
			DKRSM_sName				= DKRSM("sName")
			DKRSM_sGender			= DKRSM("sGender")
			DKRSM_sBirthDate		= DKRSM("sBirthDate")
			DKRSM_sNationalInfo		= DKRSM("sNationalInfo")
			DKRSM_sDupInfo			= DKRSM("sDupInfo")				'중복가입 확인값 (DI_64 byte)
			DKRSM_sConnInfo			= DKRSM("sConnInfo")
			DKRSM_sMobileNo			= DKRSM("sMobileNo")
			DKRSM_sMobileCo			= DKRSM("sMobileCo")
			DKRSM_regTime			= DKRSM("regTime")

			If DKRSM_sNationalInfo = "1" Then					'외국인 이름 비교
				DKRSM_sName = UCase(Replace(DKRSM_sName," ",""))
			End If

			'CS회원 중복체크
			SQL_CK = "SELECT MBID,MBID2,M_NAME,WebID FROM [tbl_memberInfo] (nolock) WHERE [hptel] = ? AND [hptel] <> '' "
			arrParams_CK = Array(_
				Db.makeParam("@mobileAuth",adVarChar,adParamInput,88,DKRSM_sMobileNo) _
			)
			Set DKRSM = Db.execRs(SQL_CK,DB_TEXT,arrParams_CK,DB3)
			If Not DKRSM.BOF And Not DKRSM.EOF Then
				Call ALERTS("이미 등록된 회원입니다.","GO","/common/member_login.asp")
			End If
		Else
			Call ALERTS("본인인증 데이터가 존재하지 않습니다. 본인인증을 다시 하셔야합니다.","GO","joinStep01.asp")
		End If
		Call closeRs(DKRSM)

		If Len(DKRSM_sBirthDate) = 8  Then
			strBirthYY = Left(DKRSM_sBirthDate,4)
			strBirthMM = Mid(DKRSM_sBirthDate,5,2)
			strBirthDD = Right(DKRSM_sBirthDate,2)
		Else
			Call ALERTS("생년월일 데이터가 존재하지 않습니다. 본인인증을 다시 하셔야합니다.","GO","joinStep01.asp")
		End If

	'▣ 인증 데이터 확인 E

'	Call ResRW(SESSION("dataNum"),"SESSION(dataNum)")
'	Call ResRW(SESSION("sResponseNumber"),"SESSION(sResponseNumber)")
'	Call ResRW(SESSION("REQ_SEQ"),"SESSION(REQ_SEQ)")

%>
<!--#include virtual = "/m/_include/document.asp"-->
<!--#include virtual = "/m/_include/jqueryload.asp"-->

<script type="text/javascript" src="/m/js/ajax.js"></script>
<!-- <script type="text/javascript" src="joinStep.js"></script>
<script type="text/javascript" src="joinStep02_c.js"></script> -->
<script type="text/javascript">
<!--

	function nameChk2(f) {

		var f = document.nfrm;

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
			if (checkEng(f.M_Name_Last.value)) {
				//console.log("영어만");
				if (f.M_Name_Last.value.length < 2 ) {
					alert("정확한 성 입력해 주세요!");
					f.M_Name_Last.focus();
					return false;
				}
				if (f.M_Name_First.value.length < 2 ) {
					alert("정확한 이름을 입력해 주세요!");
					f.M_Name_First.focus();
					return false;
				}
			} else {
				//console.log("영어외 글자 포함");
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

		//핸드폰인증된 이름과 비교
		if (f.name.value != f.M_Name_Last.value+f.M_Name_First.value)
		{
			alert("정확한 본인의 이름을 입력해주세요.");
			f.M_Name_First.focus();
			return false;
		}

		if (!checkMinorBirth(f.birthYY, f.birthMM , f.birthDD)) return false;		// 미성년자체크(생년월일)

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
					//alert(json.message);
					$("#agreeFrm input[name=name]").val(json.datas.name);
					$("#agreeFrm input[name=M_Name_Last]").val(json.datas.M_Name_Last);
					$("#agreeFrm input[name=M_Name_First]").val(json.datas.M_Name_First);
					$("#agreeFrm input[name=birthYY]").val(json.datas.birthYY);
					$("#agreeFrm input[name=birthMM]").val(json.datas.birthMM);
					$("#agreeFrm input[name=birthDD]").val(json.datas.birthDD);

					checkAgree();

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


	function checkAgree() {
		var f = document.agreeFrm;
		var g = document.nfrm;

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
			if (checkEng(f.M_Name_Last.value)) {
				if (g.M_Name_Last.value.length < 2 ) {
					alert("정확한 성 입력해 주세요.");
					g.M_Name_Last.focus();
					return false;
				}
				if (g.M_Name_First.value.length < 2 ) {
					alert("정확한 이름을 입력해 주세요.");
					g.M_Name_First.focus();
					return false;
				}
			} else {
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

		//핸드폰인증된 이름과 비교
		if (g.name.value != g.M_Name_Last.value+g.M_Name_First.value)
		{
			alert("정확한 본인의 이름을 입력해주세요.");
			g.M_Name_First.focus();
			return false;
		}
		if (f.name.value != g.name.value)
		{
			alert("가입확인한 이름과 현재 기입된 이름이 틀립니다. 가입확인을 다시 해주세요.");
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
<link rel="stylesheet" href="/m/css/membership.css?v2" />
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
<div id="join_c" class="memberWrap">
	<div class="tit"><!-- 회원가입 --><%=LNG_TEXT_BUSINESS_MEMBER%><i></i></div>
	<div class="stit"><%=LNG_SUBTITLE_TEXT30%></div>

	<iframe src="/hiddens.asp" name="hidden" frameborder="0" border="0" width="0" height="0" style="display:none;"></iframe>

	<div id="joinStep02_Zone" class="list">
		<form name="agreeFrm" id="agreeFrm" method="post" action="joinStep_n03_m.asp" onsubmit="">
			<input type="hidden" name="sRequestNO" value="<%=sRequestNO%>" readonly="readonly" />

			<input type="hidden" name="S_SellMemTF" value="<%=S_SellMemTF%>" readonly />
			<input type="hidden" name="cnd" value="<%=R_NationCode%>" readonly />
			<input type="hidden" name="name" value="" readonly="readonly" />
			<input type="hidden" name="M_Name_Last" value="" readonly="readonly" />
			<input type="hidden" name="M_Name_First" value="" readonly="readonly" />
			<input type="hidden" name="birthYY" value="" readonly="readonly" />
			<input type="hidden" name="birthMM" value="" readonly="readonly" />
			<input type="hidden" name="birthDD" value="" readonly="readonly" />
			<input type="hidden" name="For_Kind_TF" value="1" readonly="readonly" />
		</form>

       	<form name="nfrm" method="post" action="joinCheck_nc_g.asp" onSubmit="return nameChk2(this)"  />
            <div class="join_area02" style="margin-top:20px; border:1px solid #cdcdcd; width: 98%;">
                <input type="hidden" name="name" value="<%=DKRSM_sName%>" readonly="readonly" ><%'핸드폰인증된 이름과 비교%>

                <div id="" class="join">
                    <table <%=tableatt%> class="width100 infoForm">
                        <col width="105" />
                        <col width="*" />
                        <tr>
                            <th colspan="2" style="background:#ccc;"><%=LNG_SUBTITLE_TEXT30%></th>
                        </tr>
                        <%
                            If UCase(R_NationCode) = "KR" Then
                                IMES_MODE = " ime-mode:active;"
                        %>
                        <tr>
                            <td colspan="2" style="padding-left:0px;">
                                <div class="in_content width100"><div class="alert3"><%=DKCONF_SITE_TITLE%>는 회원의 소중한 개인정보를 안전하게 보호하고 있으며 개인정보 보호 정책을 준수합니다.	</div></div>
                            </td>
                        </tr>
                        <%
                            Else
                                IMES_MODE = " ime-mode:disabled;"
                            End If
                        %>
                        <tr>
                            <th><%=LNG_TEXT_FAMILY_NAME%>&nbsp;<%=starText%></th>
                            <td><input type="text" class="input_text" name="M_Name_Last" class="input_text" style="width:90%;text-transform: uppercase; <%=IMES_MODE%>" onKeyUP="this.value = this.value.toUpperCase();" placeholder="<%=LNG_TEXT_FAMILY_NAME%>" /></td>
                        </tr><tr>
                            <th><%=LNG_TEXT_GIVEN_NAME%>&nbsp;<%=starText%></th>
                            <td><input type="text" class="input_text" name="M_Name_First" class="input_text" style="width:90%;text-transform: uppercase; <%=IMES_MODE%>" onKeyUP="this.value = this.value.toUpperCase();" placeholder="<%=LNG_TEXT_GIVEN_NAME%>" /></td>
                        </tr><tr>
                            <th><%=LNG_TEXT_BIRTH%> <%=starText%></th>
                            <td class="middleTD">
                                <input type="hidden" name="birthYY" value="<%=strBirthYY%>" readonly="readonly" >
                                <input type="hidden" name="birthMM" value="<%=strBirthMM%>" readonly="readonly" >
                                <input type="hidden" name="birthDD" value="<%=strBirthDD%>" readonly="readonly" >
                                <%=strBirthYY%>년 <%=strBirthMM%> 월 <%=strBirthDD%>일
                                <!-- <select name = "birthYY" class="vmiddle input_select" style="width:60px;">
                                    <option value=""></option>
                                    <%For i = MIN_YEAR To MAX_YEAR%>
                                        <option value="<%=i%>" ><%=i%></option>
                                    <%Next%>
                                </select>
                                <select name = "birthMM" class="vmiddle input_select" style="width:45px;">
                                    <option value=""></option>
                                    <%For j = 1 To 12%>
                                        <%jsmm = Right("0"&j,2)%>
                                        <option value="<%=jsmm%>" ><%=jsmm%></option>
                                    <%Next%>
                                </select>
                                <select name = "birthDD" class="vmiddle input_select" style="width:45px;">
                                    <option value=""></option>
                                    <%For k = 1 To 31%>
                                        <%ksdd = Right("0"&k,2)%>
                                        <option value="<%=ksdd%>" ><%=ksdd%></option>
                                    <%Next%>
                                </select> <br />(yyyy/mm/dd) -->
                            </td>
                        </tr>
                    </table>
                    <!-- <div id="" class="width100" style="margin:15px 0px;">
                        <div class="joinBtn jBtn3 tcenter">
                            <input type="button" value="<%=LNG_TEXT_DOUBLE_CHECK%>" onclick="nameChk2();" />
                        </div>
                    </div> -->
                </div>
            </div>
            <div id="" class="width100" style="margin-top:30px">
			<div class="porel clear">
			    <span><input type="submit" class="joinBtn jBtn1" style="min-width:120px;" value="<%=LNG_TEXT_CONFIRM%>" /></span>
			</div>
		</form>

		<!-- <div id="" class="width100" style="margin-top:10px">
			<div class="porel clear" style=" margin:0px 10px 0px 10px; overflow:hidden;">
				<div class="joinBtn jBtn2 fleft"><input type="button" onclick="javascript:history.go(-1);" value="<%=LNG_TEXT_PREVIOUS_STEP%>"/></div>
				<div class="joinBtn jBtn1 fright"><input type="submit" onclick="javascript:return checkAgree();" value="<%=LNG_TEXT_NEXT_STEP%>"/></div>
			</div>
		</div> -->

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
</div>
<!--#include virtual = "/m/_include/copyright.asp"-->