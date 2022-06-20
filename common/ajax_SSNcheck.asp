<!--#include virtual = "/_lib/strFunc.asp"-->
<%

	Session.CodePage = 65001
	Response.CharSet = "UTF-8"
	Response.AddHeader "Pragma","no-cache"
	Response.AddHeader "Expires","0"

	strSSH	 = gRequestTF("ids",True)	'암호화용
	strSSH_D = strSSH


	'CS 주민번호중복체크 : 암호화 & 비교
	If DKCONF_SITE_ENC = "T" Then
		Set objEncrypter = Server.CreateObject("Hyeongryeol.StringEncrypter")
			objEncrypter.Key = con_EncryptKey
			objEncrypter.InitialVector = con_EncryptKeyIV

			If strSSH		<> "" Then strSSH		= objEncrypter.Encrypt(strSSH)
		Set objEncrypter = Nothing
	End If


	SQL = "SELECT COUNT([mbid]) FROM [tbl_memberinfo] WITH(NOLOCK) WHERE [cpno_Global] = ? AND [Na_Code] = ? "
	arrParams = Array(_
		Db.makeParam("@strSSH1",adVarchar,adParamInput,100,strSSH), _
		Db.makeParam("@Na_Code",adVarwchar,adParamInput,50,DK_MEMBER_NATIONCODE) _
	)
	SSH_CNT = Db.execRsData(SQL,DB_TEXT,arrParams,DB3)

	If SSH_CNT > 0 Then
		'RS_strUserID = DKRS("strUserID")
		PRINT "<span style=""color:red;font-weight:bold"">This SSN Number is not available, please enter the another Number.</span>"
		PRINT "<input type=""hidden"" name=""SSNcheck"" value=""F"" readonly=""readonly"" /><input type=""hidden"" name=""chkSSN"" value="""&strSSH_D&""" readonly=""readonly"" />"
	Else
		PRINT "<span style=""color:blue;font-weight:bold"">This SSN Number is available, input next field.</span>"
		PRINT "<input type=""hidden"" name=""SSNcheck"" value=""T"" readonly=""readonly"" /><input type=""hidden"" name=""chkSSN"" value="""&strSSH_D&""" readonly=""readonly"" />"
	End If




'	Call closeRs(DKRS)
'print TempCnt

%>
