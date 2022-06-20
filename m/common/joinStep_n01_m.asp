<!--#include virtual = "/_lib/strFunc.asp"-->
<%
'Call WRONG_ACCESS()

	PAGE_SETTING = "JOIN"

	IS_LANGUAGESELECT = "F"

	If DK_MEMBER_LEVEL > 0 Then Response.Redirect "/m/index.asp"

	'▣판매원,소비자 통합
	'S_SellMemTF = pRequestTF("S_SellMemTF",True)
	S_SellMemTF = 0									'판매원만 핸드폰인증
	Select Case S_SellMemTF
		Case 0
			'sview = 4
			LNG_TEXT_BUSINESS_MEMBER = LNG_TEXT_BUSINESS_MEMBER
	'	Case 1
	'		'sview = 2
	'		LNG_TEXT_BUSINESS_MEMBER = LNG_TEXT_NORMAL_MEMBER
		Case Else
			Call ALERTS(LNG_MEMBER_LOGINOK_ALERT02,"BACK","")
	End Select


	Select Case UCase(LANG)
		Case "KR"
			If Not checkRef(houUrl &"/m/common/joinStep01.asp") Then	Call alerts(LNG_ALERT_WRONG_ACCESS,"back","")
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
<%

	'*************************************************************************************************************

		'NICE평가정보 Copyright(c) KOREA INFOMATION SERVICE INC. ALL RIGHTS RESERVED

		'서비스명 :  체크플러스 - 안심본인인증 서비스
		'페이지명 :  체크플러스 - 메인 호출 페이지
		'보안을 위해 제공해드리는 샘플페이지는 서비스 적용 후 서버에서 삭제해 주시기 바랍니다.

	'*************************************************************************************************************

		Dim clsCPClient
		Dim iRtn, sEncData, sPlainData
		Dim sRequestNO, sSiteCode, sSitePassword , sReturnUrl , sErrorUrl, popgubun, GENDER

		SET clsCPClient  = SERVER.CREATEOBJECT("CPClient.Kisinfo")

		sSiteCode       = NICE_MOBILE_AUTH_ID		'NICE로부터 부여받은 사이트 코드			 '본스타 2018-09-27~ "BN158"
		sSitePassword   = NICE_MOBILE_AUTH_PWD		'NICE로부터 부여받은 사이트 패스워드

		sAuthType = "M"		'없으면 기본 선택화면, M: 핸드폰, C: 카드, X: 공인인증서		'공인인증서 인증 [한국전자인증, 한국정보인증, 코스콤] 개인 범용 공인인증서만 가능, 은행권(yessingCA..등은X)

		popgubun 	= "N"			'Y : 취소버튼 있음, N : 취소버튼 없음

		sGender = "" 				'없으면 기본 선택 값, 0 : 여자, 1 : 남자

		'CheckPlus(본인인증) 처리 후, 결과 데이타를 리턴 받기위해 다음예제와 같이 http부터 입력합니다.
		'리턴url은 인증 전 인증페이지를 호출하기 전 url과 동일해야 합니다. ex) 인증 전 url : http://www.~ 리턴 url : http://www.~
		sReturnUrl	= NICE_MOBILE_AUTH_URL&"/joinAuth_s.asp?dvc=m"	'성공시 이동될 URL
		sErrorUrl	= NICE_MOBILE_AUTH_URL&"/joinAuth_f.asp"	'실패시 이동될 URL

		'sRequestNO = makeOrderNo()'"REQ0000000001"			'요청 번호, 이는 성공/실패후에 같은 값으로 되돌려주게 되므로
											'업체에 적절하게 변경하여 쓰거나, 아래와 같이 생성한다.
		iRtn = clsCPClient.fnRequestNO(sSiteCode)

		'Call ResRW(sRequestNO,"sRequestNO")

		IF iRtn = 0 THEN
			sRequestNO = clsCPClient.bstrRandomRequestNO
			session("REQ_SEQ") = sRequestNO		'해킹등의 방지를 위하여 세션을 사용한다면, 세션에 요청번호를 넣는다.
			session("MO_CHECK") = "ok"			'only Mobile(MOBILEAUTH 분기)
		END IF
		'Call ResRW(sRequestNO,"sRequestNO")
		'Call ResRW(iRtn,"iRtn")
		'PRINT sRequestNO & " <br />"
		sPlainData = fnGenPlainData(sRequestNO, sSiteCode, sAuthType, sReturnUrl, sErrorUrl, popgubun, sGender)

		'실제적인 암호화
		iRtn = clsCPClient.fnEncode(sSiteCode, sSitePassword, sPlainData)

		IF iRtn = 0 THEN
			sEncData = clsCPClient.bstrCipherData
		ELSE
			RESPONSE.WRITE "요청정보_암호화_오류:" & iRtn & "<br>"
			' -1 : 암호화 시스템 에러입니다.
			' -2 : 암호화 처리오류입니다.
			' -3 : 암호화 데이터 오류입니다.
			' -4 : 입력 데이터 오류입니다.
		END IF

		Set clsCPClient = Nothing
	'**************************************************************************************
	'문자열 생성
	'**************************************************************************************
	Function fnGenPlainData(aRequestNO, aSiteCode, aAuthType, aReturnUrl, aErrorUrl, popgubun, GENDER)

		'입력 파라미터로 plaindata 생성
		retPlainData  = "7:REQ_SEQ" & fnGetDataLength(aRequestNO) & ":" & aRequestNO & _
						"8:SITECODE" & fnGetDataLength(aSiteCode) & ":" & aSiteCode & _
						"9:AUTH_TYPE" & fnGetDataLength(aAuthType) & ":" & aAuthType & _
						"7:RTN_URL" & fnGetDataLength(aReturnUrl) & ":" & aReturnUrl & _
						"7:ERR_URL" & fnGetDataLength(aErrorUrl) & ":" & aErrorUrl	& _
						"11:POPUP_GUBUN" & fnGetDataLength(popgubun) & ":" & popgubun & _
						"6:GENDER" & fnGetDataLength(sGender) & ":" & sGender
		fnGenPlainData = retPlainData

	End Function

	'**************************************************************************************
	'입력파라미터의 문자열길이 추출
	'**************************************************************************************
	Function fnGetDataLength(aData)
		Dim iData_len
		if (len(aData) > 0) then
			for i = 1 to len(aData)
				if (ASC(mid(aData,i,1)) < 0) then	'한글인경우
					iData_len = iData_len + 2
				else			'한글이아닌경우
					iData_len = iData_len + 1
				end if
			next
		else
			iData_len = 0
		end if

		fnGetDataLength = iData_len
	End Function

'	If webproIP = "T" then
'		sRequestNO = "BH140_20180628180752216"
'		session("REQ_SEQ") = sRequestNO
'		session("sResponseNumber") = "MBH140201806282031912397"
'	end if

%>
<!--#include virtual = "/m/_include/document.asp"-->
<!--#include virtual = "/m/_include/jqueryload.asp"-->

<script type="text/javascript" src="/m/js/ajax.js"></script>
<!-- <script type="text/javascript" src="joinStep.js"></script>
<script type="text/javascript" src="joinStep02_c.js"></script> -->
<script type="text/javascript">

	var agent = navigator.userAgent.toLowerCase();

	function fnPopup(){

		if (agent.indexOf('cordova') > -1) {

			if ($("input[name=agreement]:checked").val() != 'T')
			{
				alert("약관에 동의하셔야합니다");
				f.agreement[0].focus();
				return false;
			}

			if (window.popupBridge && window.popupBridge.open) {
				var href = window.location.href;
				var url = href.substring(0, href.lastIndexOf("/"))+'/appAuth.asp' +
				'?popupBridgeReturnUrlPrefix=' + window.popupBridge.getReturnUrlPrefix();

				window.popupBridge.open(url);

				window.popupBridge.onComplete = function (err, payload) {
					if (err != null) {
						alert("서버 통신 중 오류가 발생했습니다. 다시 시도 바랍니다.");
						return false;
					} else if (payload != null) {
						$("input[name=sRequestNO]").val(payload.queryItems.sRequestNO);
						$("input[name=sResponseNumber]").val(payload.queryItems.sResponseNumber);
						$("input[name=sCheckKey]").val(payload.queryItems.sCheckKey);
						document.agreeFrm.submit();
					}
				}
			}
		} else {
			window.name ="Parent_window";

			if ($("input[name=agreement]:checked").val() != 'T')
			{
				alert("약관에 동의하셔야합니다");
				f.agreement[0].focus();
				return false;
			}

			window.open('', 'popupChk', 'width=500, height=550, top=100, left=100, fullscreen=no, menubar=no, status=no, toolbar=no, titlebar=yes, location=no, scrollbar=no');
			document.form_chk.action = "https://nice.checkplus.co.kr/CheckPlusSafeModel/checkplus.cb";
			document.form_chk.target = "popupChk";
			document.form_chk.submit();
		}
	}

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
	<div class="stit"><%=LNG_JOINSTEP02_U_STITLE01%></div>

	<iframe src="/hiddens.asp" name="hidden" frameborder="0" border="0" width="0" height="0" style="display:none;"></iframe>

	<div id="joinStep02_Zone" class="list">
		<form name="agreeFrm" id="agreeFrm" method="post" action="joinStep_n02_m.asp" onsubmit="">
			<input type="hidden" name="sRequestNO" value="<%=sRequestNO%>" readonly="readonly" />
			<input type="hidden" name="sResponseNumber" value="" readonly="readonly" />
			<input type="hidden" name="sCheckKey" value="" readonly="readonly" />
			<input type="hidden" name="S_SellMemTF" value="<%=S_SellMemTF%>" readonly />
			<ul>
				<li>
					<h3 onclick="toggle_ee('ag01');"><p><%=LNG_POLICY_01%></p>
						<span><i class="i01"></i><i class="i02"></i></span></a>
					</h3>
					<div id="ag01" class="agArea" style="display:none;"><%=backword_tag(policyContent1)%></div>
				</li>
				<li>
					<h3 onclick="toggle_ee('ag02');"><p><%=LNG_POLICY_02%></p>
						<span><i class="i01"></i><i class="i02"></i></span></a>
					</h3>
					<div id="ag02" class="agArea" style="display:none;"><%=backword_tag(policyContent2)%></div>
				</li>
				<%If S_SellMemTF = 0 Then%>
				<li>
					<h3 onclick="toggle_ee('ag03');"><p><%=LNG_POLICY_03%></p>
						<span><i class="i01"></i><i class="i02"></i></span></a>
					</h3>
					<div id="ag03" class="agArea" style="display:none;"><%=backword_tag(policyContent3)%></div>
				</li>
				<%End If%>
			</ul>
			<div class="porel" id="agree" style="height:40px; margin-top:20px; border-bottom:1px solid #eee;padding-bottom:10px;">
				<%
					'red / green / blue / aero / grey / orange / yellow / pink / purple
					RColor01 = "red"
					RColor02 = "grey"
				%>
				<div class="fleft" style="width:100%; ">
					<div class="skin-<%=RColor01%>"><input type="radio" name="agreement" value="T"/><label><%=LNG_JOINSTEP02_U_TEXT07%></label></div>
				</div>
			</div>
		</form>

		<div id="" class="width100" style="margin-top:10px">
			<div class="porel clear" style=" margin:0px 10px 0px 10px; overflow:hidden;">
				<div><input type="button" class="joinBtn jBtn2 fleft" style="width:49%" onclick="javascript:history.go(-1);" value="동의하지 않습니다"/></div>
				<div><input type="submit" class="joinBtn jBtn1 fright" style="width:49%" onclick="javascript:return fnPopup();" value="동의 - 본인인증"/></div>
				<form name="form_chk" method="post">
					<input type="hidden" name="m" value="checkplusSerivce">
					<input type="hidden" name="EncodeData" value="<%= sEncData %>">
				</form>
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
</div>
<!--#include virtual = "/m/_include/copyright.asp"-->