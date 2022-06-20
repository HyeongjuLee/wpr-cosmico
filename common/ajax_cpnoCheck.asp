<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	'cpno 중복체크
	Session.CodePage = 65001
	Response.CharSet = "UTF-8"

	Response.AddHeader "Pragma","no-cache"
	Response.AddHeader "Expires","0"

	strSSH1		= Request.form("ssh1")
	strSSH2		= Request.form("ssh2")

	strSSH  = strSSH1&strSSH2

	Set objEncrypter = Server.CreateObject ("Hyeongryeol.StringEncrypter")
		objEncrypter.Key = con_EncryptKey
		objEncrypter.InitialVector = con_EncryptKeyIV
		On Error Resume Next
			If strSSH  <> "" Then strSSH = objEncrypter.Encrypt(strSSH)
		On Error GoTo 0
	Set objEncrypter = Nothing

	'print strSSH

	SQL = "SELECT [cpno] FROM [tbl_Memberinfo] WHERE [cpno] = ?"
	arrParams = Array(_
		Db.makeParam("@cpno",adVarChar,adParamInput,100,strSSH) _
	)
	Set DKRS = Db.execRs(SQL,DB_TEXT,arrParams,DB3)

	If Not DKRS.BOF And Not DKRS.EOF Then
		PRINT "IMPOSSIBLE||"
		PRINT "<span style=""color:red;font-weight:bold"">이미 CS에 등록된 주민번호입니다.</span>"
		'cpnoCheck / chk_CpnoNum1 / chk_CpnoNum1 처리
		'PRINT "<input type=""hidden"" name=""cpnoCheck"" value=""F"" readonly=""readonly"" />"
		'PRINT "<input type=""hidden"" name=""chkCpnoNum1"" value="""&strSSH1&""" readonly=""readonly"" />"
		'PRINT "<input type=""hidden"" name=""chkCpnoNum2"" value="""&strSSH2&""" readonly=""readonly"" />"

	Else
		PRINT "POSSIBLE||"
		PRINT "<span style=""color:blue;font-weight:bold"">등록가능한 주민번호입니다.</span>"
		'PRINT "<input type=""hidden"" name=""cpnoCheck"" value=""T"" readonly=""readonly"" />"
		'PRINT "<input type=""hidden"" name=""chkCpnoNum1"" value="""&strSSH1&""" readonly=""readonly"" />"
		'PRINT "<input type=""hidden"" name=""chkCpnoNum2"" value="""&strSSH2&""" readonly=""readonly"" />"

	End If

	Call closeRs(DKRS)

%>

