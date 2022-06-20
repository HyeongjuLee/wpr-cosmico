<!--#include virtual = "/_lib/strFunc.asp"-->
<!--#include virtual = "/_include/document.asp"-->

<%
	strName = Trim(pRequestTF("name",True))
	strSSH1 = Trim(pRequestTF("ssh1",True))
	strSSH2 = Trim(pRequestTF("ssh2",True))

'	Call ResRW(strName,"이름")
'	Call ResRW(strSSH1,"주민1")
'	Call ResRW(strSSH2,"주민2")
'	Response.End

	SQL = "SELECT [strUserID],[strName] " & _
			" FROM [DK_MEMBER] WHERE [strSSH1] = ? AND [strSSH2] = ? "
	arrParams = Array(_
		Db.makeParam("@strSSH1",adVarchar,adParamInput,6,strSSH1), _
		Db.makeParam("@strSSH2",adVarchar,adParamInput,7,strSSH2) _
	)
	Set DKRS = Db.execRs(SQL,DB_TEXT,arrParams,Nothing)

	flagRs = False
	If Not DKRS.BOF Or Not DKRS.EOF Then
		flagRs = True
		rsID = Trim(DKRS("strUserID"))
		rsName = Trim(DKRS("strName"))
	End If

	If flagRs Then	Call alerts("이미 가입된 주민등록번호 입니다.\n아이디/패스워드 찾기를 이용해주세요.","back","")
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

	alert("회원 등록이 가능합니다.");

	var k = parent.document.jfrm;
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
