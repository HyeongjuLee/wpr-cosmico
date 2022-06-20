<!--#include virtual = "/_lib/strFunc.asp"-->
<!--#include virtual="/_lib/md5.asp" -->
<%
	PAGE_SETTING = "JOIN"



''	If DK_MEMBER_LEVEL > 0 Then Response.Redirect "/index.asp"
''	If Not checkRef(houUrl &"/m/common/joinStep02_c.asp") Then Call alerts("잘못된 접근입니다.","go","/m/common/joinStep01.asp")

	Call ONLY_BUSINESS_MEMBER(DK_MEMBER_LEVEL,2)

	If Not checkRef(houUrl &"/m/member/underJoin01.asp") Then Call ALERTS(LNG_ALERT_WRONG_ACCESS,"back","")

	If CDbl(DKRSG_Down_Month_Count) < 100 Then Call ALERTS(LNG_JS_NO_DUPLICATE_MEMBER_JOIN,"back","")		'gng 다구좌등록 (= 후원 소실적 누적PV 라인 인원 50명 이상)


	strName	= Trim(pRequestTF("name",True))
	birthYY	= Trim(pRequestTF("birthYY",True))
	birthMM	= Trim(pRequestTF("birthMM",True))
	birthDD	= Trim(pRequestTF("birthDD",True))
	'strSSH1 = Trim(pRequestTF("ssh1",True))
	'strSSH2 = Trim(pRequestTF("ssh2",True))
	strSSH1  = Right(birthYY,2)&birthMM&birthDD
	strSSH2  = "0000000"

	If UCase(DK_MEMBER_NATIONCODE) = "KR" Then
		strName = Replace(strName," ","")			'KR 이름공백제거
	End If


	'▣ CS 이름 + 생년월일 중복체크
	SQL = "SELECT COUNT([mbid]) FROM [tbl_memberinfo] WHERE [M_Name] = ? And [BirthDay] = ? And [BirthDay_M] = ? And [BirthDay_D] = ? "		'→ 전체회원중복체크
	SQL = SQL & "  AND NOT ( mbid = ? AND mbid2 = ?)"																						'	본인제외
	arrParams = Array(_
		Db.makeParam("@M_Name",adVarWchar,adParamInput,100,strName), _
		Db.makeParam("@BirthDay",adVarchar,adParamInput,4,birthYY), _
		Db.makeParam("@BirthDay_M",adVarchar,adParamInput,2,birthMM), _
		Db.makeParam("@BirthDay_D",adVarchar,adParamInput,2,birthDD), _
			Db.makeParam("@mbid1",adVarChar,adParamInput,20,DK_MEMBER_ID1), _
			Db.makeParam("@mbid2",adInteger,adParamInput,0,DK_MEMBER_ID2) _
	)
	DbCheckMember = CInt(Db.execRsData(SQL,DB_TEXT,arrParams,DB3))

	If CDbl(DbCheckMember) >= 2 Then
		'Call alerts("다구좌 회원등록 최대인원을 초과하였습니다.","BACK","")
		Call alerts(LNG_JS_OVER_DUPLICATE_MEMBER,"BACK","")
	End If





	agreement = pRequestTF("agreement",False)
	gather = pRequestTF("gather",False)
	company = pRequestTF("company",False)

	If agreement = "" Then agreement = "F"
	If gather = "" Then gather = "F"

	agreement = "T"
	gather	  = "T"
	company	  = "T"

	If agreement <> "T" Then Call ALERTS(LNG_JS_POLICY01,"back","")
	If gather <> "T" Then Call ALERTS(LNG_JS_POLICY02,"back","")
	If company <> "T" Then Call ALERTS(LNG_JS_POLICY03,"back","")



	'주민번호 암호화입력

	Set objEncrypter = Server.CreateObject("Hyeongryeol.StringEncrypter")
		objEncrypter.Key = con_EncryptKey
		objEncrypter.InitialVector = con_EncryptKeyIV
		If strSSH1		<> "" Then Enc_strSSH1		= objEncrypter.Encrypt(strSSH1)
		If strSSH2		<> "" Then Enc_strSSH2		= objEncrypter.Encrypt(strSSH2)
	Set objEncrypter = Nothing


	Set XTEncrypt = new XTclsEncrypt
	'RChar = XTEncrypt.MD5(RandomChar(10))
	RChar = makeMemTempNum&RandomChar(10)

	arrParams = Array(_
		Db.makeParam("@strName",adVarChar,adParamInput,20,strName),_
		Db.makeParam("@strSSH1",adVarChar,adParamInput,50,Enc_strSSH1),_
		Db.makeParam("@strSSH2",adVarChar,adParamInput,50,Enc_strSSH2),_
		Db.makeParam("@TempDataNum",adVarChar,adParamInput,50,RChar),_
		Db.makeParam("@Idnum",adInteger,adParamOutput,0,0) _
	)
	Call Db.exec("DKP_MEMBER_JOIN_TEMP",DB_PROC,arrParams,DB3)

'	ThisIdentity = arrParams(3)(4)

	If DK_MEMBER_VOTER <> "" Then
		arrParams = Array(_
			Db.makeParam("@strUserID",adVarChar,adParamInput,20,DK_MEMBER_VOTER) _
		)
		VOTERCHK = Db.execRsData("DKP_JOIN_VOTER_CHK",DB_PROC,arrParams,Nothing)
		If VOTERCHK > 0 Then
			LINKVOTER = "T"
		End If
	End If

	'바이럴 추천인 체크
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



'	ThisMd51 = Left(Rchar,16)
'	ThisMd52 = Right(Rchar,16)

'	ThisTempNum = ThisMd51 & ThisIdentity & ThisMd52


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

'	birthYYYY = birthYY & Left(strSSH1,2)
'	birthMM = Mid(strSSH1,3,2)
'	birthDD = Right(strSSH1,2)
	birthYYYY = birthYY
	birthMM = birthMM
	birthDD = birthDD


	'국가정보
	''R_NationCode = Trim(pRequestTF("cnd",True))
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

%>
<%

	arrParams = Array(_
		Db.makeParam("@mbid",adVarChar,adParamInput,20,DK_MEMBER_ID1), _
		Db.makeParam("@mbid2",adInteger,adParamInput,0,DK_MEMBER_ID2) _
	)
	Set DKRS = Db.execRs("DKP_MEMBER_INFO",DB_PROC,arrParams,DB3)
	If Not DKRS.BOF And Not DKRS.EOF Then
		DKRS_mbid				= DKRS("mbid")
		DKRS_mbid2				= DKRS("mbid2")
		DKRS_M_Name				= DKRS("M_Name")
		DKRS_E_name				= DKRS("E_name")
		DKRS_Email				= DKRS("Email")
		DKRS_cpno				= DKRS("cpno")
		DKRS_Addcode1			= DKRS("Addcode1")
		DKRS_Address1			= DKRS("Address1")
		DKRS_Address2			= DKRS("Address2")
		DKRS_Address3			= DKRS("Address3")
		DKRS_reqtel				= DKRS("reqtel")
		DKRS_officetel			= DKRS("officetel")
		DKRS_hometel			= DKRS("hometel")
		DKRS_hptel				= DKRS("hptel")
		DKRS_LineCnt			= DKRS("LineCnt")
		DKRS_N_LineCnt			= DKRS("N_LineCnt")
		DKRS_Recordid			= DKRS("Recordid")
		DKRS_Recordtime			= DKRS("Recordtime")
		DKRS_businesscode		= DKRS("businesscode")
		DKRS_bankcode			= DKRS("bankcode")
		DKRS_banklocal			= DKRS("banklocal")
		DKRS_bankaccnt			= DKRS("bankaccnt")
		DKRS_bankowner			= DKRS("bankowner")
		DKRS_Regtime			= DKRS("Regtime")
		DKRS_Saveid				= DKRS("Saveid")
		DKRS_Saveid2			= DKRS("Saveid2")
		DKRS_Nominid			= DKRS("Nominid")
		DKRS_Nominid2			= DKRS("Nominid2")
		DKRS_RegDocument		= DKRS("RegDocument")
		DKRS_CpnoDocument		= DKRS("CpnoDocument")
		DKRS_BankDocument		= DKRS("BankDocument")
		DKRS_Remarks			= DKRS("Remarks")
		DKRS_LeaveCheck			= DKRS("LeaveCheck")
		DKRS_LineUserCheck		= DKRS("LineUserCheck")
		DKRS_LeaveDate			= DKRS("LeaveDate")
		DKRS_LineUserDate		= DKRS("LineUserDate")
		DKRS_LeaveReason		= DKRS("LeaveReason")
		DKRS_LineDelReason		= DKRS("LineDelReason")
		DKRS_WebID				= DKRS("WebID")
		DKRS_WebPassWord		= DKRS("WebPassWord")
		DKRS_BirthDay			= DKRS("BirthDay")
		DKRS_BirthDay_M			= DKRS("BirthDay_M")
		DKRS_BirthDay_D			= DKRS("BirthDay_D")
		DKRS_BirthDayTF			= DKRS("BirthDayTF")
		DKRS_Ed_Date			= DKRS("Ed_Date")
		'DKRS_Ed_TF				= DKRS("Ed_TF")				'신버전삭제
		DKRS_PayStop_Date		= DKRS("PayStop_Date")
		DKRS_PayStop_TF			= DKRS("PayStop_TF")
		DKRS_For_Kind_TF		= DKRS("For_Kind_TF")
		DKRS_Sell_Mem_TF		= DKRS("Sell_Mem_TF")
		DKRS_CurGrade			= DKRS("CurGrade")
		DKRS_Remarks			= DKRS("Remarks")			'비고
		DKRS_Sex				= DKRS("Sex")			'비고
	Else
		Call ALERTS(LNG_JS_MEMBERINFO_FAIL,"BACK","")
	End If
	Call closeRS(DKRS)

	Set objEncrypter = Server.CreateObject ("Hyeongryeol.StringEncrypter")
		objEncrypter.Key = con_EncryptKey
		objEncrypter.InitialVector = con_EncryptKeyIV
		On Error Resume Next
			If DKRS_Address1		<> "" Then DKRS_Address1	= objEncrypter.Decrypt(DKRS_Address1)
			If DKRS_Address2		<> "" Then DKRS_Address2	= objEncrypter.Decrypt(DKRS_Address2)
			If DKRS_Address3		<> "" Then DKRS_Address3	= objEncrypter.Decrypt(DKRS_Address3)
			If DKRS_hometel			<> "" Then DKRS_hometel		= objEncrypter.Decrypt(DKRS_hometel)
			If DKRS_hptel			<> "" Then DKRS_hptel		= objEncrypter.Decrypt(DKRS_hptel)
			If DKRS_bankaccnt		<> "" Then DKRS_bankaccnt	= objEncrypter.Decrypt(DKRS_bankaccnt)
			If DKRS_Email		<> "" Then DKRS_Email		= objEncrypter.Decrypt(DKRS_Email)
			'If DKRS_WebID		<> "" Then DKRS_WebID		= objEncrypter.Decrypt(DKRS_WebID)
		On Error GoTo 0
	Set objEncrypter = Nothing

	'성별 치환
	If DKRS_Sex = 1 Then
		TEXT_SEX		= LNG_TEXT_MALE
		TEXT_SEX_VALUE	= "M"
	Else
		TEXT_SEX = LNG_TEXT_FEMALE
		TEXT_SEX_VALUE	= "F"
	End If

	'양력/음력 치환
	If DKRS_BirthDayTF = 1 Then
		isSolar = "S"
	Else
		isSolar = "M"
	End If

%>
<!--#include virtual = "/m/_include/document.asp"-->
<!--#include virtual = "/m/_include/jqueryload.asp"-->

<link rel="stylesheet" href="/m/css/common.css" />
<link rel="stylesheet" href="/m/js/icheck/skin/line/_all.css" />
<script type="text/javascript" src="/m/js/check.js"></script>
<script src="/m/js/icheck/icheck.min.js"></script>
<script src="https://spi.maps.daum.net/imap/map_js_init/postcode.v2.js"></script>
<script src="/jscript/daumPostCode.js"></script>
<script type="text/javascript">
<!--
	function join_idcheck() {
		var ids = document.cfrm.strID;
		if (ids.value == '')
		{
			alert("<%=LNG_JS_ID%>");
			ids.focus();
			return false;
		}
	/*
		if (/(\w)\1\1/.test(ids.value)){
			alert("동일 숫자나 영문은 3번이상 연속으로 사용할 수 없습니다.");
			return false;
		}
	*/
	/*
		if (ids.value.search('dana')>-1 || ids.value.search('DANA')>-1) {
			alert('아이디에 dana는 포함할 수 없습니다.')
			return false;
		}
		if (checkID_CSID(ids.value.trim())){
			alert("아이디 앞에 특정단어로 시작하는 아이디는 사용할 수 없습니다.\n\n예외처리 단어 : test, cs_");
			ids.value = "";
			ids.focus();
			return false;
		}
	*/
		if (!checkID(ids.value.trim(), 4, 20)){
			alert("<%=LNG_JS_ID_FORM_CHECK%>");
			ids.focus();
			return false;
		}
		$.ajax({
			type: "POST"
			,url: "/m/common/joinChk_id.asp"
			,data: {
				 "ids"		: ids.value
			}
			//,contentType: "application/json; charset=utf-8"
			,success: function(data) {
				$("#idCheck").html(data);
				//loadings();

				//alert($("."+DivGoods).parent().tagName);


			}
			,error:function(data) {
				alert(LNG_AJAX_ERROR_MSG&". ERROR CODE : "+data.status+" "+data.statusText+" "+data.responseText);
			}
		});
	}


	function openzip() {
		//openPopup("/m/common/pop_Zipcode.asp", "Zipcodes", 0, 0,"");
		openPopup("/m/common/pop_Zipcode.asp", "Zipcodes");
	}
	function vote_idcheck() {
		openPopup("/m/common/pop_voter.asp", "vote_idcheck");
	}
	function spon_idcheck() {
		openPopup("pop_sponsor.asp", "spon_idcheck");
	}


	function chkSubmit() {
		var f = document.cfrm;
		var objItem;

	/*
		if (chkEmpty(f.dataNum)) {
			alert("데이터값이 없습니다. 다시 시도해주세요.");
			f.strID.focus();
			return false;
		}
	*/
		if (f.agreement.value != 'T')
		{
			alert("<%=LNG_JS_POLICY01%>");
			document.location.href = '/m/member/underJoin01.asp';
			return false;
		}
		if (f.gather.value != 'T')
		{
			alert("<%=LNG_JS_POLICY02%>");
			document.location.href = '/m/member/underJoin01.asp';
			return false;
		}
		if (f.company.value != 'T')
		{
			alert("<%=LNG_JS_POLICY03%>");
			document.location.href = '/m/member/underJoin01.asp';
			return false;
		}


		if (f.strID.value == "")
		{
			alert("<%=LNG_JS_ID%>");
			f.strID.focus();
			return false;
		} else {
			if (!checkID(f.strID.value, 4, 20)){
				alert("<%=LNG_JS_ID_FORM_CHECK%>");
				f.strID.focus();
				return false;
			}
			if (f.idcheck.value == 'F'){
				alert("<%=LNG_JS_ID_DOUBLE_CHECK%>");
				f.strID.focus();
				return false;
			}
			if (f.strID.value != f.chkID.value){
				alert("<%=LNG_JS_ID_DOUBLE_CHECK2%>");
				f.strID.focus();
				return false;
			}
		}

		if (chkEmpty(f.strPass)) {
			alert("<%=LNG_JS_PASSWORD%>");
			f.strPass.focus();
			return false;
		}

		if (!checkPass(f.strPass.value, 6, 20) || !checkEngNum(f.strPass.value)){
			alert("<%=LNG_JS_PASSWORD_FORM_CHECK%>");
			f.strPass.focus();
			return false;
		}
		if (f.idcheck.value == f.strPass.value){
			alert("<%=LNG_JS_PASSWORD_FORM_CHECK2%>");
			f.strPass.focus();
			return false;
		}
		if (chkEmpty(f.strPass2)) {
			alert("<%=LNG_JS_PASSWORD_CONFIRM%>");
			f.strPass2.focus();
			return false;
		}

		if (f.strPass.value != f.strPass2.value){
			alert("<%=LNG_JS_PASSWORD_CHECK%>");
			f.strPass2.focus();
			return false;
		}

		if (chkEmpty(f.businessCode)) {
			alert("<%=LNG_JS_CENTER%>");
			f.businessCode.focus();
			return false;
		}

		if (chkEmpty(f.voter) || chkEmpty(f.NominID1) || chkEmpty(f.NominID2) || f.NominChk.value == 'F') {
			alert("<%=LNG_JS_VOTER%>");
			f.voter.focus();
			//vote_idcheck();
			return false;
		}

		if (chkEmpty(f.sponsor) || chkEmpty(f.SponID1) || chkEmpty(f.SponID2) || f.SponIDChk.value == 'F') {
			alert("<%=LNG_JS_SPONSOR%>");
			f.sponsor.focus();
			//spon_idcheck();
			return false;
		}


		if (chkEmpty(f.strZip) || chkEmpty(f.strADDR1)) {
			alert("<%=LNG_JS_ADDRESS1%>");
			f.strZip.focus();
			//openzip();
			return false;
		}

		if (chkEmpty(f.strADDR2)) {
			alert("<%=LNG_JS_ADDRESS2%>");
			f.strADDR2.focus();
			return false;
		}
		for (i=1; i<=3; i++) {
			objItem = eval("f.mob_num"+i);
			if (chkEmpty(objItem)) {
				alert("<%=LNG_JS_MOBILE%>");
				objItem.focus();
				return false;
			}
		}

	/*
		if (!checkEmail(f.strEmail.value)) {
			alert("<%=LNG_JS_EMAIL_CONFIRM%>");
			f.strEmail.focus();
			return false;
		}
	*/
		if (chkEmpty(f.birthYY) || chkEmpty(f.birthMM) || chkEmpty(f.birthDD)) {
			alert("<%=LNG_JS_BIRTH%>");
			f.birthYY.focus();
			return false;
		}



		//if (confirm("<%=LNG_JOINSTEP03_U_JS28%>")) {
			f.target = "_self";
			return;
		//} else {
		//	return false;
		//}

}



//-->

</script>
</head>
<body onunload="">
<!--#include virtual = "/m/_include/header.asp"-->
<div id="subTitle" class="width100 tcenter text_noline" >회원가입 : <%=LNG_MYOFFICE_MEMBER_05%> 정보입력</div>

<form name="cfrm" method="post" action="underJoinFinish.asp" onsubmit="return chkSubmit(this);">
	<input type="hidden" name="cnd" value="<%=R_NationCode%>" readonly />
	<input type="hidden" name="agreement" value="<%=agreement%>" />
	<input type="hidden" name="gather" value="<%=gather%>" />
	<input type="hidden" name="company" value="<%=company%>" />

	<input type="hidden" name="SponID1" value="" readonly="readonly" />
	<input type="hidden" name="SponID2" value="" readonly="readonly" />
	<input type="hidden" name="SponIDWebID" value="" readonly="readonly" />
	<input type="hidden" name="SponIDChk" value="F" readonly="readonly" />
	<input type="hidden" name="dataNum" value="<%=RChar%>" readonly="readonly" />
	<input type="hidden" name="joinType" value="COMPANY" readonly="readonly" />

	<%'If DKRSVI_WEBID = "" Then%>
		<input type="hidden" name="NominID1" value="<%=DK_MEMBER_ID1%>" readonly="readonly" />
		<input type="hidden" name="NominID2" value="<%=DK_MEMBER_ID2%>" readonly="readonly" />
		<input type="hidden" name="NominWebID" value="<%=DK_MEMBER_WEBID%>" readonly="readonly" />
		<input type="hidden" name="NominChk" value="T" readonly="readonly" />
		<input type="hidden" name="voter" value="<%=DK_MEMBER_NAME%>" readonly="readonly" />
	<%'Else%>
		<!-- <input type="hidden" name="NominID1" value="<%=DKRSVI_MBID1%>" readonly="readonly" />
		<input type="hidden" name="NominID2" value="<%=DKRSVI_MBID2%>" readonly="readonly" />
		<input type="hidden" name="NominWebID" value="<%=DKRSVI_WEBID%>" readonly="readonly" />
		<input type="hidden" name="NominChk" value="<%=DKRSVI_CHECK%>" readonly="readonly" />
		<input type="hidden" name="voter" value="<%=DKRSVI_MNAME%>" readonly="readonly" /> -->
	<%'End If%>


	<div id="joinStep03_Zone">
		<table <%=tableatt%> class="width100">
			<col width="95" />
			<col width="*" />
			<tr>
				<th colspan="2" style="background-color:#ececec;padding:7px 0px; text-indent:7px;">회원기본정보</th>
			</tr><!-- <tr>
				<th>국가코드</th>
				<td><strong>[<%=DKRS_nationCode%>] <%=DKRS_nationNameEn%></strong><br /><!-- <span class="">(The country code is based on ISO 3166-1 alpha-2 codes)</span></td>
			</tr> --><tr>
				<th>이름</th>
				<td><%=strName%></td>
			</tr><!-- <tr>
				<th>주민번호</th>
				<td><%=strSSH1%> - *******</td>
			</tr> --><tr>
				<th>아이디 <%=starText%></th>
				<td>
					<div style="width:57%;"><input type="text" name="strID" class="imes input_text width100" onkeyup="this.value=this.value.replace(/[^a-zA-Z0-9]/g,'');" /></div><div class="tcenter" style="width:3%;"></div><div style="width:40%;"><input type="button" name="" onclick="join_idcheck();" class="input_btn width100" value="아이디체크" /></div>
					<div id="idCheck" class="summary" style="padding-top:4px;">띄어쓰기 없는 영문,숫자 4~20자
					<input type="hidden" name="idcheck" value="F" readonly="readonly" />
					<input type="hidden" name="chkID" value="" readonly="readonly" />
					</div>
				</td>
			</tr><tr>
				<th>비밀번호 <%=starText%></th>
				<td><input type="password" name="strPass" class="input_text width95a" /><br /><span class="summary" style="padding-top:4px;">영문,숫자 6~20자</span></td>
			</tr><tr>
				<th>비밀번호확인 <%=starText%></th>
				<td><input type="password" name="strPass2" class="input_text width95a"  /></td>
			</tr>
		</table>

		<table <%=tableatt%> class="width100" style="margin-top:25px;">
			<col width="95" />
			<col width="*" />
			<tr>
				<th colspan="2" style="background-color:#ececec;padding:7px 0px; text-indent:7px;">회원부가정보</th>
			</tr>
			<!-- <tr>
				<th style="height:30px;"><span class="red"> 판매원 구분</span><%=starText%></th>
				<td>
					<label><input type="radio" name="Bus_FLAG" value="F" class="input_radio" checked="checked" /> 개인회원</span></label>
					<label style="margin-left:7px;"><input type="radio" name="Bus_FLAG" value="T" class="input_radio" /> 사업자회원</label>
				</td>
			</tr><tr id="Bus_FLAG_toggle" style="display:none;">
				<th></th>
				<td>
					<span class="tweight"> 사업자 명 : &nbsp;&nbsp; </span><input type="text" name="Bus_Name" class="input_text" style="width:180px;" placeholder="사업자명 " /><br />
					<span class="tweight"> 사업자번호 : </span><input type="text" name="Bus_Number" class="input_text" style="width:180px;" placeholder="사업자번호" />
				</td>
			</tr> -->
			<tr>
				<th>센터 <%=starText%></th>
				<td>
					<!-- <select name="businessCode">
						<option value="">::: 센터 선택 :::</option>
					<%
						SQL = "SELECT * FROM [tbl_Business] WHERE [Na_Code] = '"&R_NationCode&"' AND [U_TF] = 0 ORDER BY [ncode] ASC"
						arrList = Db.execRsList(SQL,DB_TEXT,Nothing,listLen,DB3)
						If IsArray(arrList) Then
							For i = 0 To listLen
								PRINT TABS(5)& "	<option value="""&arrList(0,i)&""">"&arrList(1,i)&"</option>"
							Next
						Else
							PRINT TABS(5)& "	<option value="""">센터가 존재하지 않습니다.</option>"
						End If
					%>
					</select> -->
					<%
						arrParams = Array(_
							Db.makeParam("@mbid1",adVarChar,adParamInput,20,DK_MEMBER_ID1), _
							Db.makeParam("@mbid2",adInteger,adParamInput,0,DK_MEMBER_ID2) _
						)
						Set DKRS = Db.execRs("DKP_MEMBER_BUSINESS_CODE",DB_PROC,arrParams,DB3)
						If Not DKRS.BOF And Not DKRS.EOF Then
							BASE_BUSINESS_CODE = DKRS(0)
							BASE_BUSINESS_NAME = DKRS(1)
						Else
							Call ALERTS("추천인(본인)의 센터가 없습니다. 본사에 문의해주세요!","BACK","")
						End If
						Call closeRS(DKRS)

						If BASE_BUSINESS_CODE = "없음" Then Call ALERTS("추천인(본인)의 센터가 없습니다. 본사에 문의해주세요!","BACK","")
					%>
					<input type="hidden" name="businessCode" readonly="readonly" value="<%=BASE_BUSINESS_CODE%>" /><%=BASE_BUSINESS_NAME%>
				</td>
			</tr><tr>
				<th><%=CS_NOMIN%> <%=starText%></th>
				<!-- <%If DKRSVI_WEBID = "" Then%>
				<td>
					<div style="width:57%;"><input type="text" name="voter" class="input_text width95a" readonly="readonly" style="background-color:#efefef;" /></div><div class="tcenter" style="width:3%;"></div><div style="width:40%;"><input type="button" name="" class="input_btn width95a" value="검색"  onclick="vote_idcheck();" /></div>
				</td>
				<%Else%>
				<td><%=DKRSVI_MNAME%>(<%=DKRSVI_MBID1%>-<%=DKRSVI_MBID2%>)</td>
				<%End If%> -->
				<td><%=DK_MEMBER_NAME%> (<%=DK_MEMBER_ID1%>-<%=Fn_MBID2(DK_MEMBER_ID2)%>)</td>
			</tr>
			<tr>
				<th><%=CS_SPON%> <%=starText%></th>
				<td >
					<div style="width:57%;"><input type="text" name="sponsor" class="input_text width95a" readonly="readonly" style="background-color:#efefef;" /></div><div class="tcenter" style="width:3%;"></div><div style="width:40%;">
					<input type="button" name="" class="input_btn width95a" value="검색"  onclick="spon_idcheck();" /></div>
				</td>
			</tr>
			<tr>
				<th>은행</th>
				<td>
					<!-- <select name="bankCode">
						<option value="">은행을 선택해주세요</option>
						<%
							SQL = "SELECT [ncode],[BankName] FROM [tbl_Bank] WHERE [Na_Code] = '"&R_NationCode&"' ORDER BY [nCode] ASC"
							arrList = Db.execRsList(SQL,DB_TEXT,Nothing,listLen,DB3)
							If IsArray(arrList) Then
								For i = 0 To listLen
									PRINT Tabs(5)& "	<option value="""&arrList(0,i)&""">"&arrList(1,i)&"</option>"
								Next
							Else
								PRINT Tabs(5)& "	<option value="""">등록된 계좌코드가 없습니다.</option>"
							End If
						%>
					</select> -->
					<input type="hidden" name="bankCode" value="<%=DKRS_bankcode%>">
					<%
						SQL = "SELECT [ncode],[BankName] FROM [tbl_Bank] WHERE [Na_Code] = ? AND [ncode] = ? "

						arrParams = Array(_
							Db.makeParam("@Na_Code",adVarWChar,adParamInput,50,DK_MEMBER_NATIONCODE), _
							Db.makeParam("@ncode",adVarWChar,adParamInput,50,DKRS_bankcode) _
						)
						Set DKRS = Db.execRs(SQL,DB_TEXT,arrParams,DB3)
						If Not DKRS.BOF And Not DKRS.EOF Then
							DKRS_BankName = DKRS(1)
						End If
						Call closeRS(DKRS)
					%>
					<%=DKRS_BankName%>
				</td>
			</tr><tr>
				<th>계좌번호</th>
				<td>
					<!-- <input type="text" name="BankNumber" class="input_text vmiddle" style="width:180px;" /> -->
					<input type="hidden" name="BankNumber" value="<%=DKRS_bankaccnt%>">
					<%=DKRS_bankaccnt%>
				</td>
			</tr><tr>
				<th>예금주</th>
				<td>
					<!-- <input type="text" name="bankOwner" class="input_text vmiddle" style="width:120px;" /> -->
					<input type="hidden" name="bankOwner" value="<%=DKRS_bankowner%>">
					<%=DKRS_bankowner%>
				</td>
			</tr>
		</table>

		<table <%=tableatt%> class="width100" style="margin-top:25px;">
			<col width="95" />
			<col width="*" />
			<tr>
				<th colspan="2" style="background-color:#ececec;padding:7px 0px; text-indent:7px;">회원 부가정보</th>
			</tr><tr>
				<th>성별</th>
				<td>
					<!-- <div class="skin-grey2"><input type="radio" name="isSex" value="M"  checked="checked"/><label>남성</label></div>
					<div class="skin-grey2"><input type="radio" name="isSex" value="F" /><label>여성</label></div> -->
					<input type="hidden" name="isSex" value="<%=TEXT_SEX_VALUE%>" readonly="readonly" />
					<%=TEXT_SEX%>
				</td>
			</tr><tr>
				<th rowspan="3">주소</th>
				<td style="border-bottom:0px none;">
					<!-- <div style="width:57%;"><input type="text" name="strZip" id="strZipDaum" class="input_text width95a" readonly="readonly" style="background-color:#efefef;" maxlength="7" /></div><div class="tcenter" style="width:3%;"></div><div style="width:40%;"><input type="button" name="" class="input_btn width95a" value="우편번호입력"  onclick="execDaumPostcode('oris');" /></div> -->
					<input type="hidden" name="strZip" value="<%=DKRS_Addcode1%>" readonly="readonly" />
					<%=DKRS_Addcode1%>
				</td>
			</tr><tr>
				<td style="border-bottom:0px none; padding:0px;">
					<!-- <input type="text" name="strADDR1" id="strADDR1Daum" class="input_text width95a" style="background-color:#efefef;" readonly="readonly" /> -->
					<input type="hidden" name="strADDR1" value="<%=DKRS_Address1%>" readonly="readonly" />
					<%=DKRS_Address1%>
				</td>
			</tr><tr>
				<td>
					<!-- <input type="text" name="strADDR2" id="strADDR2Daum" class="input_text width95a" /> -->
					<input type="hidden" name="strADDR2" value="<%=DKRS_Address2%>" readonly="readonly" />
					<%=DKRS_Address2%>
				</td>
			</tr><tr>
				<th>휴대전화</th>
				<td>
					<!-- <input type="tel" name="mob_num1" maxlength="5" class="input_text" style="width:25%;" <%=onlyKeys%> /> -
					<input type="tel" name="mob_num2" maxlength="4" class="input_text" style="width:25%;" <%=onlyKeys%> /> -
					<input type="tel" name="mob_num3" maxlength="4" class="input_text" style="width:25%;" <%=onlyKeys%> /> -->
					<input type="hidden" name="strMobile" value="<%=DKRS_hptel%>" readonly="readonly" />
					<%=DKRS_hptel%>
				</td>
			</tr><tr>
				<th>전화번호</th>
				<td>
					<!-- <input type="tel" name="tel_num1" maxlength="5" class="input_text" style="width:25%;" <%=onlyKeys%> /> -
					<input type="tel" name="tel_num2" maxlength="4" class="input_text" style="width:25%;" <%=onlyKeys%> /> -
					<input type="tel" name="tel_num3" maxlength="4" class="input_text" style="width:25%;" <%=onlyKeys%> /> -->
					<input type="hidden" name="strTel" value="<%=DKRS_hometel%>" readonly="readonly" />
					<%=DKRS_hometel%>
				</td>
			</tr><tr>
				<th>이메일</th>
				<td>
					<!-- <input type="email" name="strEmail" class="input_text width95a" /> -->
					<input type="hidden" name="strEmail" value="<%=DKRS_Email%>" readonly="readonly" />
					<%=DKRS_Email%>
				</td>
			</tr><tr>
				<th>생일</th>
				<td>
					<input type="hidden" name="birthYY" value="<%=birthYYYY%>" readonly="readonly" />
					<input type="hidden" name="birthMM" value="<%=birthMM%>" readonly="readonly" />
					<input type="hidden" name="birthDD" value="<%=birthDD%>" readonly="readonly" />
					<%=birthYYYY%>-<%=birthMM%>-<%=birthDD%>
					<!-- <select name = "birthYY" class="vmiddle" style="width:60px;">
						<option value=""></option>
						<%For i = MIN_YEAR To MAX_YEAR%>
							<option value="<%=i%>" <%=isSelect(i,birthYYYY)%>><%=i%></option>
						<%Next%>
					</select> 년
					<select name = "birthMM" class="vmiddle" style="width:45px;">
						<option value=""></option>
						<%For j = 1 To 12%>
							<%jsmm = Right("0"&j,2)%>
							<option value="<%=jsmm%>" <%=isSelect(jsmm,birthMM)%>><%=jsmm%></option>
						<%Next%>
					</select> 월
					<select name = "birthDD" class="vmiddle" style="width:45px;">
						<option value=""></option>
						<%For k = 1 To 31%>
							<%ksdd = Right("0"&k,2)%>
							<option value="<%=ksdd%>"<%=isSelect(ksdd,birthDD)%>><%=ksdd%></option>
						<%Next%>
					</select> 일
					<br /> -->
					<!-- <p style="margin-top:7px;">
						<div class="skin-grey2"><input type="radio" name="isSolar" value="S"  checked="checked" /><label> 양력</label></div>
						<div class="skin-grey2"><input type="radio" name="isSolar" value="M" /><label> 음력</label></div>
					</p> -->
					<input type="hidden" name="isSolar" value="<%=DKRS_BirthDayTF%>" readonly="readonly" />
				</td>
			</tr>
		</table>

		<div id="" class="width100" style="margin-top:10px">
			<div class="porel clear" style=" margin:0px 10px 0px 10px; overflow:hidden;">
				<!-- <div><input type="button" class="joinBtn jBtn2 fleft" style="width:49%" onclick="javascript:history.go(-1);" value="회원가입취소"/></div> -->
				<div><input type="submit" class="joinBtn jBtn1 tcenter" style="width:49%" onclick="" value="회원가입"/></div>
			</div>
		</div>

	</div>

	<script>
		$(document).ready(function(){
			$('.skin-grey2 input').each(function(){
				var self = $(this),
				label = self.next(),
				label_text = label.text();

				label.remove();
				self.iCheck({
					checkboxClass: 'icheckbox_line-grey',
					radioClass: 'iradio_line-grey',
					insert: '<div class="icheck_line-icon" ></div>' + label_text
				});
			});

		});
	</script>
</form>
<!--#include virtual = "/m/_include/copyright.asp"-->