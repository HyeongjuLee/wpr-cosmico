<!--#include virtual = "/_lib/strFunc.asp"-->
<!--#include virtual = "/m/_include/document.asp"-->

<%
	strName = Trim(pRequestTF("name",True))
	birthYY = Trim(pRequestTF("birthYY",True))
	birthMM = Trim(pRequestTF("birthMM",True))
	birthDD = Trim(pRequestTF("birthDD",True))

	strSSH  = Right(birthYY,2)&birthMM&birthDD&"0000000"

	'CS 주민번호중복체크 : 암호화 & 비교
	If DKCONF_SITE_ENC = "T" Then
		Set objEncrypter = Server.CreateObject("Hyeongryeol.StringEncrypter")
			objEncrypter.Key = con_EncryptKey
			objEncrypter.InitialVector = con_EncryptKeyIV
			If strSSH	<> "" Then strSSH	= objEncrypter.Encrypt(strSSH)
		Set objEncrypter = Nothing
	End If

	'▣ CS 이름 + 주민번호(YYMMDD0000000) 중복체크(탈퇴회원 중복대상제외)
'	SQL = "SELECT COUNT([mbid]) FROM [tbl_memberinfo] WHERE [M_Name] = ? And [cpno] = ? And [LeaveCheck] = 1"
'	arrParams = Array(_
'		Db.makeParam("@M_Name",adVarWchar,adParamInput,100,strName), _
'		Db.makeParam("@cpno",adVarWchar,adParamInput,100,strSSH) _
'	)
'	CSDBJoinCnt = Db.execRsData(SQL,DB_TEXT,arrParams,DB3)

	'▣ CS 이름 + 생년월일 중복체크(탈퇴회원 중복대상제외'→ 전체회원중복체크
	SQL = "SELECT COUNT([mbid]) FROM [tbl_memberinfo] WHERE [M_Name] = ? And [BirthDay] = ? And [BirthDay_M] = ? And [BirthDay_D] = ? "		'→ 전체회원중복체크
	SQL = SQL & "  AND NOT ( mbid = ? AND mbid2 = ?)"																					'	본인제외
	arrParams = Array(_
		Db.makeParam("@M_Name",adVarWchar,adParamInput,100,strName), _
		Db.makeParam("@BirthDay",adVarchar,adParamInput,4,birthYY), _
		Db.makeParam("@BirthDay_M",adVarchar,adParamInput,2,birthMM), _
		Db.makeParam("@BirthDay_D",adVarchar,adParamInput,2,birthDD), _
			Db.makeParam("@mbid1",adVarChar,adParamInput,20,DK_MEMBER_ID1), _
			Db.makeParam("@mbid2",adInteger,adParamInput,0,DK_MEMBER_ID2) _
	)
	CSDBJoinCnt = Db.execRsData(SQL,DB_TEXT,arrParams,DB3)

	flagRs1 = False

''	If Int(CSDBJoinCnt) > 0 Then flagRs1 = True
''	If flagRs1 Then	Call alerts("동일한 이름과 생년월일로 등록된 회원이 존재합니다.\n\n본인이 회원가입을 하지 않았다면 본사로 문의해주세요. ","back","")

	If Int(CSDBJoinCnt) >= 2 Then flagRs1 = True		'GNG 다구좌 + 2명까지
	If flagRs1 Then	Call alerts(LNG_JS_OVER_DUPLICATE_MEMBER,"back","")		'다구좌 회원등록 최대인원을 초과하였습니다

%>
<script type="text/javascript">
<!--

function gosubmit(){
	var f = document.frmgi;
	if (f.strName.value=="") {
		alert("<%=LNG_JS_NAME%>");
		f.strName.focus();
		return false;
	}
	if (chkEmpty(f.birthYY) || chkEmpty(f.birthMM) || chkEmpty(f.birthDD)) {
		alert("<%=LNG_JS_BIRTH%>");		f.birthYY.focus();
		return false;
	}
	if (!checkMinorBirth(f.birthYY, f.birthMM , f.birthDD)) return false;		// 미성년자체크(생년월일)


	//alert("회원 등록이 가능합니다.");
	alert("<%=LNG_JS_MEMBER_REGIST_POSSIBLE%>");

	var k = parent.document.agreeFrm;
	k.name.value = '<%=strName%>';
	k.birthYY.value = '<%=birthYY%>';
	k.birthMM.value = '<%=birthMM%>';
	k.birthDD.value = '<%=birthDD%>';

	location.href='/hiddens.asp';

//	f.submit();

}

//-->
</script>
</head>
<body onload="gosubmit();">
<form name="frmgi" method="post"  target="_parent" action="member_agree.asp">
	<input type="hidden" name="strName" value="<%=strName%>" readonly="readonly" />
	<input type="hidden" name="birthYY" value="<%=birthYY%>" readonly="readonly" />
	<input type="hidden" name="birthMM" value="<%=birthMM%>" readonly="readonly" />
	<input type="hidden" name="birthDD" value="<%=birthDD%>" readonly="readonly" />
</form>
<script type="text/javascript"><!-- gosubmit(); //--></script>
</body>
</html>
