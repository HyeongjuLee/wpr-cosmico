<!--#include virtual = "/_lib/strFunc.asp"-->
<!--#include virtual = "/m/_include/document.asp"-->

<%
	strName = Trim(pRequestTF("name",True))
	strSSH1 = Trim(pRequestTF("ssh1",True))
	strSSH2 = Trim(pRequestTF("ssh2",True))

'	Call ResRW(strName,"이름")
'	Call ResRW(strSSH1,"주민1")
'	Call ResRW(strSSH2,"주민2")
'	Response.End


'WEB 주민번호중복체크
'	SQL = "SELECT COUNT([strUserID]) " & _
'			" FROM [DK_MEMBER_ADDINFO] WITH(NOLOCK) WHERE [strSSH1] = ? AND [strSSH2] = ? "
'	arrParams = Array(_
'		Db.makeParam("@strSSH1",adVarchar,adParamInput,6,strSSH1), _
'		Db.makeParam("@strSSH2",adVarchar,adParamInput,7,strSSH2) _
'	)
'	WebDBJoinCnt = Db.execRsData(SQL,DB_TEXT,arrParams,Nothing)

'=======================================================================================
'CS 주민번호중복체크 : 암호화 & 비교
	strSSH = strSSH1&strSSH2
	If DKCONF_SITE_ENC = "T" Then
		Set objEncrypter = Server.CreateObject("Hyeongryeol.StringEncrypter")
			objEncrypter.Key = con_EncryptKey
			objEncrypter.InitialVector = con_EncryptKeyIV
			If strSSH	<> "" Then strSSH	= objEncrypter.Encrypt(strSSH)
		Set objEncrypter = Nothing
	End If
'=======================================================================================
	SQL = "SELECT COUNT([mbid]) " & _
			" FROM [tbl_memberinfo] WITH(NOLOCK) WHERE [cpno] = ? AND [LeaveCheck] = 1 "
	arrParams = Array(_
		Db.makeParam("@strSSH1",adVarchar,adParamInput,100,strSSH) _
	)
	CSDBJoinCnt = Db.execRsData(SQL,DB_TEXT,arrParams,DB3)


	'▣다나 : 탈퇴일 30일 이후 회원가입허용(2016-05-16)
	SQL3 = "SELECT COUNT([mbid]) " & _
			" FROM [tbl_memberinfo] WITH(NOLOCK) WHERE [cpno] = ? AND DATEADD(D,30,LeaveDate) > LEFT(GETDATE(),10) AND [LeaveCheck] = 0"
	arrParams3 = Array(_
		Db.makeParam("@strSSH1",adVarchar,adParamInput,100,strSSH) _
	)
	CSDBJoinCnt3 = Db.execRsData(SQL3,DB_TEXT,arrParams3,DB3)


	flagRs1 = False
	flagRs2 = False
	flagRs3 = False

	If Int(WebDBJoinCnt) > 0 Then flagRs1 = True
	If Int(CSDBJoinCnt) > 0 Then flagRs2 = True
	If Int(CSDBJoinCnt3) > 0 Then flagRs3 = True



	If flagRs1 Then	Call alerts("이미 웹에 가입된 주민등록번호 입니다.\n다시한번 확인해주세요.","back","")
	If flagRs2 Then	Call alerts("이미 CS에 가입된 주민등록번호 입니다.\n다시한번 확인해주세요. ","back","")
	If flagRs3 Then	Call alerts("탈퇴회원은 탈퇴 후 30일동안 회원가입을 할 수 없습니다.","back","")

%>
<script type="text/javascript">
<!--

function gosubmit(){
	var f = document.frmgi;
	if (f.strName.value=="") {
		alert("이름을 입력해 주세요.");
		f.strName.focus();
		return false;
	}

	var objItem;
	for (var i=1; i<=2; i++) {
		objItem = eval('f.strSSH'+i);
		if (chkEmpty(objItem)) {
			alert("주민등록번호를 입력해 주세요.");
			objItem.focus();
			return false;
		}
	}

	if (!checkSSH(f.strSSH1, f.strSSH2)) return false;
	if (!checkMinor2(f.strSSH1, f.strSSH2)) return false;

	alert("회원 등록이 가능합니다.");

	var k = parent.document.agreeFrm;
	k.name.value = '<%=strName%>';
	k.ssh1.value = '<%=strSSH1%>';
	k.ssh2.value = '<%=strSSH2%>';

	location.href='/hiddens.asp';

//	f.submit();

}

//-->
</script>
</head>
<body onload="gosubmit();">
<form name="frmgi" method="post"  target="_parent" action="member_agree.asp">
	<input type="hidden" name="strName" value="<%=strName%>" readonly="readonly" />
	<input type="hidden" name="strSSH1" value="<%=strSSH1%>" readonly="readonly" />
	<input type="hidden" name="strSSH2" value="<%=strSSH2%>" readonly="readonly" />
</form>
<script type="text/javascript"><!-- gosubmit(); //--></script>
</body>
</html>
