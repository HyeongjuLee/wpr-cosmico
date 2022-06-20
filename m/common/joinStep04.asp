<!--#include virtual = "/_lib/strFunc.asp"-->
<!--#include virtual="/_lib/md5.asp" -->
<%
	PAGE_SETTING = "JOIN"
	view = 1
	sview = 6
	ISSUBTOP = "T"

	IS_LANGUAGESELECT = "F"
	NO_MEMBER_REDIRECT = "F"


	If DK_MEMBER_LEVEL > 0 Then Response.Redirect "/m/index.asp"

	CENTER_SELECT_TF = "T"		'센터선택 기본값
	IF CS_NOMIN_CENTER_0_TF = "T" Then CENTER_SELECT_TF = "F" '판매원센터따라가기


	Agree01				= pRequestTF("agree01",True)
	Agree02				= pRequestTF("agree02",True)
	Agree03				= pRequestTF("agree03",True)

	If Agree01 <> "T" Then Call ALERTS(""&LNG_ALERT_WRONG_ACCESS&"","go","joinStep01.asp")
	If Agree02 <> "T" Then Call ALERTS(""&LNG_ALERT_WRONG_ACCESS&"","go","joinStep01.asp")
	If Agree03 <> "T" Then Call ALERTS(""&LNG_ALERT_WRONG_ACCESS&"","go","joinStep01.asp")

	ajaxTF				= pRequestTF("ajaxTF",True)

	strBankCodeCHK		= pRequestTF("strBankCodeCHK",True)
	strBankNumCHK		= pRequestTF("strBankNumCHK",True)
	strBankOwnerCHK		= pRequestTF("strBankOwnerCHK",True)
	'strSSH1CHK			= pRequestTF("strSSH1CHK",True)
	'strSSH2CHK			= pRequestTF("strSSH2CHK",True)
	birthYYCHK			= pRequestTF("birthYYCHK",True)		'생년월일체크 YYYY
	birthMMCHK			= pRequestTF("birthMMCHK",True)		'생년월일체크 MM
	birthDDCHK			= pRequestTF("birthDDCHK",True)		'생년월일체크 DD
	TempDataNum			= pRequestTF("TempDataNum",True)

	strBankCode			= pRequestTF("strBankCode",True)
	strBankNum			= pRequestTF("strBankNum",True)
	strBankOwner		= pRequestTF("strBankOwner",True)
	'strSSH1				= pRequestTF("strSSH1",True)
	'strSSH2				= pRequestTF("strSSH2",True)
	birthYY				= pRequestTF("birthYY",True)		'생년월일 YYYY
	birthMM				= pRequestTF("birthMM",True)		'생년월일 MM
	birthDD				= pRequestTF("birthDD",True)		'생년월일 DD

	If ajaxTF <> "T" Then Call ALERTS("본인인증을 확인하셔야합니다.","back","")

	If strBankCodeCHK	<> strBankCode		Then Call ALERTS("데이터에 변조가 있었습니다.다시 진행해주세요.1","go","joinStep01.asp")
	If strBankNumCHK	<> strBankNum		Then Call ALERTS("데이터에 변조가 있었습니다.다시 진행해주세요.2","go","joinStep01.asp")
	If strBankOwnerCHK	<> strBankOwner		Then Call ALERTS("데이터에 변조가 있었습니다.다시 진행해주세요.3","go","joinStep01.asp")
	'If strSSH1CHK		<> strSSH1			Then Call ALERTS("데이터에 변조가 있었습니다.다시 진행해주세요.4","go","joinStep01.asp")
	'If strSSH2CHK		<> strSSH2			Then Call ALERTS("데이터에 변조가 있었습니다.다시 진행해주세요.5","go","joinStep01.asp")
	If birthYYCHK		<> birthYY			Then Call ALERTS("데이터에 변조가 있었습니다.다시 진행해주세요.6","go","joinStep01.asp")
	If birthMMCHK		<> birthMM			Then Call ALERTS("데이터에 변조가 있었습니다.다시 진행해주세요.6","go","joinStep01.asp")
	If birthDDCHK		<> birthDD			Then Call ALERTS("데이터에 변조가 있었습니다.다시 진행해주세요.6","go","joinStep01.asp")

	birthYYMMDD	= Right(birthYY,2)&birthMM&birthDD			'생년월일체크 YYMMDD

'	Call ResRW(birthYYMMDD,"birthYYMMDD")
'	Call ResRW(strSSH1,"strSSH1")
'	Call ResRW(strSSH2,"strSSH1")
'	Call ResRW(birthYY,"birthYY")
'	Call ResRW(birthMM,"birthMM")
'	Call ResRW(birthDD,"birthDD")
'	Call ResRW(strBankCodeCHK,"strBankCodeCHK")
'	Call ResRW(strBankNumCHK,"strBankNumCHK")
'	Call ResRW(strBankOwnerCHK,"strBankOwnerCHK")
'	Call ResRW(strSSH1CHK,"strSSH1CHK")
'	Call ResRW(strSSH2CHK,"strSSH2CHK")
'	Call ResRW(strBankCode,"strBankCode")
'	Call ResRW(strBankNum,"strBankNum")
'	Call ResRW(strBankOwner,"strBankOwner")


	'▣암호화후 템프테이블데이터와 비교
	Set objEncrypter = Server.CreateObject("Hyeongryeol.StringEncrypter")
		objEncrypter.Key = con_EncryptKey
		objEncrypter.InitialVector = con_EncryptKeyIV
		If strSSH1		<> "" Then Enc_strSSH1		= objEncrypter.Encrypt(strSSH1)
		If strSSH2		<> "" Then Enc_strSSH2		= objEncrypter.Encrypt(strSSH2)
		If birthYYMMDD	<> "" Then Enc_birthYYMMDD		= objEncrypter.Encrypt(birthYYMMDD)			'생년월일 암호화(YYMMDD)
	Set objEncrypter = Nothing


		'Db.makeParam("@strSSH1",adChar,adParamInput,50,Enc_strSSH1),_
		'Db.makeParam("@strSSH2",adChar,adParamInput,50,Enc_strSSH2)_
	arrParams = Array(_
		Db.makeParam("@TempDataNum",adVarChar,adParamInput,50,TempDataNum),_
		Db.makeParam("@strSSH1",adChar,adParamInput,50,Enc_birthYYMMDD),_
		Db.makeParam("@strSSH2",adChar,adParamInput,50,Enc_birthYYMMDD)_
	)
	Set DKRS = Db.execRs("DKP_MEMBER_JOIN_BANK_VIEW",DB_PROC,arrParams,DB3)

	If Not DKRS.BOF And Not DKRS.EOF Then
		DKRS_intIDX				= DKRS("intIDX")
		DKRS_TempDataNum		= DKRS("TempDataNum")
		DKRS_strName			= DKRS("strName")
		DKRS_strSSH1			= DKRS("strSSH1")			'생년월일 YYMMDD
		DKRS_strSSH2			= DKRS("strSSH2")			'생년월일 YYMMDD
		DKRS_strCenterName		= DKRS("strCenterName")
		DKRS_strCenterCode		= DKRS("strCenterCode")
		DKRS_strBankCode		= DKRS("strBankCode")
		DKRS_strBankNum			= DKRS("strBankNum")
		DKRS_strBankOwner		= DKRS("strBankOwner")
		DKRS_strOrderNum		= DKRS("strOrderNum")
	Else
		Call ALERTS("데이터베이스에 없는 데이터입니다. 다시 시도해주세요.","BACK","")
	End If
	Call closeRs(DKRS)

	'▣템프테이블 데이터 복호화후 비교
	Set objEncrypter = Server.CreateObject("Hyeongryeol.StringEncrypter")
		objEncrypter.Key = con_EncryptKey
		objEncrypter.InitialVector = con_EncryptKeyIV
		If DKRS_strBankNum		<> "" Then DKRS_strBankNum	= objEncrypter.Decrypt(DKRS_strBankNum)
		If DKRS_strSSH1			<> "" Then DKRS_strSSH1		= objEncrypter.Decrypt(DKRS_strSSH1)
		If DKRS_strSSH2			<> "" Then DKRS_strSSH2		= objEncrypter.Decrypt(DKRS_strSSH2)
	Set objEncrypter = Nothing

	If DKRS_strBankCode		<>	strBankCode			Then Call ALERTS("데이터에 변조가 있었습니다.다시 진행해주세요.6","go","joinStep01.asp")
	If DKRS_strBankNum		<>	strBankNum			Then Call ALERTS("데이터에 변조가 있었습니다.다시 진행해주세요.7","go","joinStep01.asp")
	If DKRS_strBankOwner	<>	strBankOwner		Then Call ALERTS("데이터에 변조가 있었습니다.다시 진행해주세요.8","go","joinStep01.asp")
	'If DKRS_strSSH1			<>	strSSH1				Then Call ALERTS("데이터에 변조가 있었습니다.다시 진행해주세요.9","go","joinStep01.asp")
	'If DKRS_strSSH2			<>	strSSH2				Then Call ALERTS("데이터에 변조가 있었습니다.다시 진행해주세요.10","go","joinStep01.asp")
	If DKRS_TempDataNum		<>	TempDataNum			Then Call ALERTS("데이터에 변조가 있었습니다.다시 진행해주세요.11","go","joinStep01.asp")
	If DKRS_strSSH1			<>	birthYYMMDD			Then Call ALERTS("데이터에 변조가 있었습니다.다시 진행해주세요.12","go","joinStep01.asp")
	If DKRS_strSSH2			<>	birthYYMMDD			Then Call ALERTS("데이터에 변조가 있었습니다.다시 진행해주세요.13","go","joinStep01.asp")

	If DK_MEMBER_VOTER_ID <> "" Then
		Set objEncrypter = Server.CreateObject ("Hyeongryeol.StringEncrypter")
			objEncrypter.Key = con_EncryptKey
			objEncrypter.InitialVector = con_EncryptKeyIV
			'DK_MEMBER_VOTER_ID	 = objEncrypter.Encrypt(DK_MEMBER_VOTER_ID)


		SQLVI = "SELECT [MBID],[MBID2],[M_NAME],[WebID] FROM [tbl_MemberInfo] WHERE [webID] = ? "
		arrParamsVI = Array(_
			Db.makeParam("@WebID",adVarWChar,adParamInput,100,DK_MEMBER_VOTER_ID) _
		)
		Set DKRSVI = Db.execRs(SQLVI,DB_TEXT,arrParamsVI,DB3)
		If Not DKRSVI.BOF And Not DKRSVI.EOF Then
			DKRSVI_MBID1		= DKRSVI("MBID")
			DKRSVI_MBID2		= DKRSVI("MBID2")
			DKRSVI_MNAME		= DKRSVI("M_NAME")
			DKRSVI_CHECK		= "T"
			DKRSVI_WEBID		= DKRSVI("WebID")
			'DKRSVI_WEBID		= objEncrypter.DEcrypt(DKRSVI_WEBID)
		Else
			DKRSVI_MBID1		= ""
			DKRSVI_MBID2		= ""
			DKRSVI_MNAME		= ""
			DKRSVI_CHECK		= "F"
			DKRSVI_WEBID		= ""
		End If

		Set objEncrypter = Nothing
	End If


	Select Case Left(strSSH2,1)
		Case "1"
			birthYY = "19"
			isSex = "M"
		Case "2"
			birthYY = "19"
			isSex = "F"
		Case "3"
			birthYY = "20"
			isSex = "M"
		Case "4"
			birthYY = "20"
			isSex = "F"
	End Select

	'birthYYYY = birthYY & Left(strSSH1,2)
	'birthMM = Mid(strSSH1,3,2)
	'birthDD = Right(strSSH1,2)

	birthYYYY = birthYY
	birthMM = birthMM
	birthDD = birthDD

	'If isSex = "M" Then viewSex = "남성" Else viewSex = "여성" End If



%>
<%
	If NICE_BANK_WITH_MOBILE_USE = "T" Then

		'#####################################
		'	NICE 본인인증(핸드폰)
		'#####################################

		sRequestNO = pRequestTF("sRequestNO",True)

		If session("REQ_SEQ") <> sRequestNO Then Call ALERTS("세션값이 다릅니다. 올바른 경로로 접근하시기 바랍니다","go", MOB_PATH&"/common/joinStep01.asp")

		'▣ 인증 데이터 확인 S
			Set XTEncrypt = new XTclsEncrypt
			'RChar = XTEncrypt.MD5(RandomChar(10))
			RChar = makeMemTempNum&RandomChar(10)

			sResponseNumber = SESSION("sResponseNumber")
			If sResponseNumber = "" Then sResponseNumber = ""

			'PRINT sRequestNO & " <br />"
			'print sResponseNumber
			'Response.End

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

				'NICE 휴대전화 리턴값 신청해야함!!!
				If DKRSM_sMobileNo = "" Then
					Call ALERTS("휴대폰정보가 없습니다..","GO", MOB_PATH&"/common/joinStep01.asp")
				End If

				'CS회원 중복체크
				SQL_CK = "SELECT MBID,MBID2,M_NAME,WebID FROM [tbl_memberInfo] (nolock) WHERE [hptel] = ? AND [hptel] <> '' "
				arrParams_CK = Array(_
					Db.makeParam("@mobileAuth",adVarChar,adParamInput,88,DKRSM_sMobileNo) _
				)
				Set DKRSM = Db.execRs(SQL_CK,DB_TEXT,arrParams_CK,DB3)
				If Not DKRSM.BOF And Not DKRSM.EOF Then
					Call ALERTS("이미 등록된 회원입니다.","GO", MOB_PATH&"/common/member_login.asp")
				Else

					Set objEncrypter = Server.CreateObject("Hyeongryeol.StringEncrypter")
						objEncrypter.Key = con_EncryptKey
						objEncrypter.InitialVector = con_EncryptKeyIV
						On Error Resume Next
							If DKRSM_sMobileNo		<> "" Then DKRSM_sMobileNo		= objEncrypter.Decrypt(DKRSM_sMobileNo)
							If RChar				<> "" Then RChar				= objEncrypter.Encrypt(RChar)
						On Error GoTo 0
					Set objEncrypter = Nothing

					arrParams = Array(_
						Db.makeParam("@TempDataNum",adVarChar,adParamInput,50,RChar), _
						Db.makeParam("@sRequestNO",adVarChar,adParamInput,30,sRequestNO), _
						Db.makeParam("@sResponseNumber",adVarChar,adParamInput,24,sResponseNumber), _
						Db.makeParam("@sDupInfo",adVarChar,adParamInput,64,DKRSM_sDupInfo) _
					)
					Call Db.exec("DKSP_MEMBER_JOIN_TEMP_INSERT",DB_PROC,arrParams,Nothing)
					SESSION("dataNum") = RChar

				End If
			Else
				Call ALERTS("본인인증 데이터가 존재하지 않습니다. 본인인증을 다시 하셔야합니다.","GO", MOB_PATH&"/common/joinStep01.asp")
			End If
			Call closeRs(DKRSM)

			'print RChar
		'▣ 인증 데이터 확인 E

		'Call ResRW(SESSION("dataNum"),"SESSION(dataNum)")
		'Call ResRW(SESSION("sResponseNumber"),"SESSION(sResponseNumber)")
		'Call ResRW(SESSION("REQ_SEQ"),"SESSION(REQ_SEQ)")

	End If
%>
<!--#include virtual = "/m/_include/document.asp"-->
<!--#include virtual = "/m/_include/jqueryload.asp"-->

<script type="text/javascript" src="joinStep04.js?v4"></script>
<link rel="stylesheet" href="/m/css/joinstep.css?v0" />
<link rel="stylesheet" href="/m/js/icheck/skin/line/_all.css" />
<script type="text/javascript" src="/m/js/check.js"></script>
<script src="/m/js/icheck/icheck.min.js"></script>
<script type="text/javascript">
	$(document).ready(function(){
		<%If DK_MEMBER_VOTER_ID = "" Then%>
			$("input[name=voter]").val("");
		<%End IF%>
		$("input[name=sponsor]").val("");
	});
</script>
</head>
<body onunload="">
<!--#include virtual = "/m/_include/header.asp"-->
<div id="join03" class="joinstep joinstep4">
	<form name="cfrm" method="post" action="joinStep04Handler.asp" onsubmit="return chkSubmit(this);">
		<input type="hidden" name="intIDX" value="<%=DKRS_intIDX%>" />
		<input type="hidden" name="dataNum" value="<%=TempDataNum%>" />
		<input type="hidden" name="agree01" value="<%=Agree01%>" />
		<input type="hidden" name="agree02" value="<%=Agree02%>" />
		<input type="hidden" name="agree03" value="<%=Agree03%>" />

		<input type="hidden" name="centerName" value="<%=DKRS_ncode%>" />
		<input type="hidden" name="centerCode" value="<%=DKRS_M_Reg_Code%>" />

		<input type="hidden" name="strBankCode" value="<%=DKRS_strBankCode%>" />
		<input type="hidden" name="strBankNum" value="<%=DKRS_strBankNum%>" />
		<input type="hidden" name="strBankOwner" value="<%=DKRS_strBankOwner%>" />

		<input type="hidden" name="NominID1" value="" readonly="readonly" />
		<input type="hidden" name="NominID2" value="" readonly="readonly" />
		<input type="hidden" name="NominWebID" value="" readonly="readonly" />
		<input type="hidden" name="NominChk" value="F" readonly="readonly" />

		<input type="hidden" name="SponID1" value="" readonly="readonly" />
		<input type="hidden" name="SponID2" value="" readonly="readonly" />
		<input type="hidden" name="SponIDWebID" value="" readonly="readonly" />
		<input type="hidden" name="SponIDChk" value="F" readonly="readonly" />
		<input type="hidden" name="joinType" value="COMPANY" readonly="readonly" />
		<input type="hidden" name="NominCom" value="F" readonly="readonly" />
		<input type="hidden" readonly="readonly" id="isSolar" name="isSolar" value="S" />
		<input type="hidden" name="NICE_BANK_WITH_MOBILE_USE" value="<%=NICE_BANK_WITH_MOBILE_USE%>" readonly="readonly" /><%'핸드폰인증용%>
		<input type="hidden" name="CS_AUTO_WEBID_TF" value="<%=CS_AUTO_WEBID_TF%>" readonly="readonly" /><%'회원 자동 아이디 생성%>
		<input type="hidden" name="CENTER_SELECT_TF" value="<%=CENTER_SELECT_TF%>" readonly="readonly" /><%'추천센터선택%>

		<div class="wrap">
			<h6><%=LNG_TEXT_MEMBER_BASIC_INFO%></h6>
			<table <%=tableatt%> class="width100">
				<col width="85" />
				<col width="*" />
				<tr>
					<th>이름</th>
					<td><b><%=DKRS_strName%></b> <!-- (<%=viewSex%>) --></td>
				</tr><!-- <tr>
					<th>주민번호</th>
					<td><%=DKRS_strSSH1%> - *******</td>
				</tr> -->
				<tr>
					<th>은행정보</td>
					<td>[<%=Fnc_bankname(DKRS_strBankCode)%>] <%=DKRS_strBankNum%></td>
				</tr><tr>
					<th>예금주</td>
					<td><%=DKRS_strBankOwner%></td>
				</tr>
				<tr class="id">
					<th>아이디</th>
					<td>
						<%If CS_AUTO_WEBID_TF = "T" Then%>
							<b>아이디는 회원가입 후 발급됩니다.</b>
						<%Else%>
							<input type="text" name="strID" class="imes input_text" onkeyup="this.value=this.value.replace(/[^a-zA-Z0-9]/g,'');" />
							<input type="button" name="" onclick="join_idcheck();" class="button" value="<%=LNG_TEXT_DOUBLE_CHECK%>" /></div>
							<p class="summary" id="idCheck"><%=LNG_JOINSTEP03_U_TEXT04%>
								<input type="hidden" name="idcheck" value="F" readonly="readonly" />
								<input type="hidden" name="chkID" value="" readonly="readonly" />
							</p>
						<%End If%>
					</td>
				</tr><tr>
					<th>비밀번호</th>
					<td><input type="password" name="strPass" class="input_text" /></td>
				</tr><tr>
					<th>비밀번호확인</th>
					<td><input type="password" name="strPass2" class="input_text" /></td>
				</tr>
			</table>
		</div>

		<div class="wrap">
			<h6>사업자회원 부가정보</h6>
			<table <%=tableatt%> class="width100">
				<col width="85" />
				<col width="*" />
				<%If CENTER_SELECT_TF = "T" Then%>
				<tr>
					<th>센터 <%=starText%></th>
					<td>
						<select name="businessCode" class="input_select">
							<option value="">::: 센터 선택 :::</option>
						<%
							SQL = "SELECT * FROM [tbl_Business] WHERE [Na_Code] = 'KR' AND [U_TF] = 0 ORDER BY [ncode] ASC"
							arrList = Db.execRsList(SQL,DB_TEXT,Nothing,listLen,DB3)
							If IsArray(arrList) Then
								For i = 0 To listLen
									PRINT TABS(5)& "	<option value="""&arrList(0,i)&""">"&arrList(1,i)&"</option>"
								Next
							Else
								PRINT TABS(5)& "	<option value="""">센터가 존재하지 않습니다.</option>"
							End If
						%>
						</select>
						<p class="summary">* 센터를 모르시는 경우 추후에 본사로 연락하여 센터 변경을 할 수 있습니다.</p>
					</td>
				</tr>
				<%End If%>
				<%
					'※후원인선택 : 추천인의 후원산하로만(형제라인 지정불가) pop_VoterSFV.asp → pop_SponsorSFV.asp
				%>
				<tr class="voter">
					<th><%=CS_NOMIN%> <%=starText%></th>
					<td>
						<%'#modal dialog%>
						<input type="text" name="voter" class="input_text" value="<%=DKRSVI_MNAME%>" readonly="readonly" />
						<%If DKRSVI_CHECK <> "T" Then%>
						<a name="modal" class="button" id="popVoter" href="/m/common/pop_voter.asp" title="<%=CS_NOMIN%>&nbsp;<%=LNG_TEXT_SEARCH%>"><%=LNG_TEXT_SEARCH%></a>
						<%End If%>
					</td>
				</tr>
				<%if 1=2 then%>
				<tr class="voter">
					<th><%=CS_SPON%> <%=starText%></th>
					<td >
						<%'#modal dialog%>
						<input type="text" name="sponsor" class="input_text" value="" readonly="readonly" /><a name="modal" class="button" id="popSponsor" href="/m/common/pop_sponsor.asp" title="<%=CS_SPON%>&nbsp;<%=LNG_TEXT_SEARCH%>"><%=LNG_TEXT_SEARCH%></a>
					</td>
				</tr>
				<%End If%>
			</table>
		</div>
		<div class="wrap">
			<h6>회원 부가정보</h6>
			<table <%=tableatt%> class="width100">
				<col width="85" />
				<col width="*" />
				<tr class="radio">
					<th>성별 <%=starText%></th>
					<td>
						<label><input type="radio" name="isSex" value="M" checked="checked" /><i class="icon-ok"></i><span>남성</span></label>
						<label><input type="radio" name="isSex" value="F" /><i class="icon-ok"></i><span>여성</span></label>
					</td>
				</tr>
				<tr class="address">
					<th rowspan="3"><%=LNG_TEXT_ADDRESS1%>&nbsp;<%=starText_ADDRESS1%></th>
					<td>
						<input type="text" name="strZip" id="strZipDaum" class="input_text" readonly="readonly" maxlength="7" />
						<a name="modal" href="/m/common/pop_postcode.asp" id="pop_postcode" title="<%=LNG_JOINSTEP04_03%>"><input type="button" class="button" value="<%=LNG_JOINSTEP04_03%>" style="width: 80px;"/></a>
					</td>
				</tr><tr>
					<td><input type="text" name="strADDR1" id="strADDR1Daum" class="input_text" maxlength="500" readonly="readonly" /></td>
				</tr><tr>
					<td><input type="text" name="strADDR2" id="strADDR2Daum" class="input_text" maxlength="500" /></td>
				</tr>
				<tr class="mobile">
					<th>휴대전화 <%=starText%></th>
					<td>
						<%If NICE_BANK_WITH_MOBILE_USE = "T" Then%>
							<input type="hidden" name="strMobile" value="<%=DKRSM_sMobileNo%>" readonly="readonly" />
							<%=FN_SPLIT_MOBILE(DKRSM_sMobileNo)%>
						<%Else%>
							<input type="tel" name="strMobile" maxlength="15" class="input_text" <%=onLyKeys%> oninput="maxLengthCheck(this)" /><input type="button" name="" onclick="join_MobileCheck();" class="button" value="<%=LNG_TEXT_DOUBLE_CHECK%>" />
							<p class="summary tweight" id="mobileCheckTXT"></p>
							<input type="hidden" name="mobileCheck" value="F" readonly="readonly" />
							<input type="hidden" name="chkMobile" value="" readonly="readonly" />
							<p class="summary"><%=LNG_JOINSTEP03_U_TEXT24%></p>
						<%End If%>
					</td>
				</tr><tr>
					<th>전화번호</th>
					<td>
						<input type="tel" name="strTel" maxlength="15" class="input_text" <%=onLyKeys%> oninput="maxLengthCheck(this)" />
					</td>
				</tr><tr>
					<th>이메일 <%=starText%></th>
					<td>
						<input type="email" name="strEmail" class="input_text imes" maxlength="200" />
						<input type="button" name="" onclick="join_emailCheck();" class="button" value="<%=LNG_TEXT_DOUBLE_CHECK%>" /></div>
						<p class="summary" id="emailCheckTXT"><%=LNG_JOINSTEP03_U_TEXT29%></p>
						<input type="hidden" name="emailCheck" value="F" readonly="readonly" />
						<input type="hidden" name="chkEmail" value="" readonly="readonly" />
					</td>
				</tr>
				<tr class="radio birth">
					<th>생일 <%=starText%></th>
					<td>
						<div class="inputs">
							<input type="text" name="birthYY" class="input_text" maxlength="4"  value="<%=birthYYYY%>" readonly="readonly" placeholder="년" />
							<input type="text" name="birthMM" class="input_text" maxlength="2" value="<%=birthMM%>" readonly="readonly" placeholder="월" />
							<input type="text" name="birthDD" class="input_text" maxlength="2" value="<%=birthDD%>" readonly="readonly" placeholder="일" />
						</div>
						<label><input type="radio" name="isSolar" value="S" checked="checked" /><i class="icon-ok"></i><span>양력</span></label>
						<label><input type="radio" name="isSolar" value="M" /><i class="icon-ok"></i><span>음력</span></label>
					</td>
				</tr>
			</table>

			<div class="btnZone">
				<input type="submit" class="promise" onclick="" value="<%=LNG_TEXT_JOIN%>"/>
			</div>

		</div>

	</form>
</div>

<%'▣ 추천/후원인 선택 modal▣%>
<!--#include virtual="/m/_include/modal_config.asp" -->

<!--#include virtual = "/m/_include/copyright.asp"-->