<!--#include virtual = "/_lib/strFunc.asp"-->
<%

	Session.CodePage = 65001
	Response.CharSet = "UTF-8"
	Response.AddHeader "Pragma","no-cache"
	Response.AddHeader "Expires","0"


	strName = Trim(Request("strName"))
	strSSH1 = Trim(Request("strSSH1"))
	strSSH2 = Trim(Request("strSSH2"))







'	Call ResRW(strName,"이름")
'	Call ResRW(strSSH1,"주민1")
'	Call ResRW(strSSH2,"주민2")
'	Response.End
'WEB 주민번호중복체크
	SQL = "SELECT COUNT([strUserID]) " & _
			" FROM [DK_MEMBER_ADDINFO] WHERE [strSSH1] = ? AND [strSSH2] = ? "
	arrParams = Array(_
		Db.makeParam("@strSSH1",adVarchar,adParamInput,6,strSSH1), _
		Db.makeParam("@strSSH2",adVarchar,adParamInput,7,strSSH2) _
	)
	WebDBJoinCnt = Db.execRsData(SQL,DB_TEXT,arrParams,Nothing)

'=======================================================================================
'CS 주민번호중복체크 : 암호화 & 비교
	strSSH = strSSH1&strSSH2

'	Set objEncrypter = Server.CreateObject("Hyeongryeol.StringEncrypter")
'		objEncrypter.Key = con_EncryptKey
'		objEncrypter.InitialVector = con_EncryptKeyIV

'		If strSSH		<> "" Then strSSH		= objEncrypter.Encrypt(strSSH)
'	Set objEncrypter = Nothing
'=======================================================================================
	SQL = "SELECT COUNT([mbid]) " & _
			" FROM [tbl_memberinfo] WHERE [cpno] = ?"
	arrParams = Array(_
		Db.makeParam("@strSSH1",adVarchar,adParamInput,100,strSSH) _
	)
	CSDBJoinCnt = Db.execRsData(SQL,DB_TEXT,arrParams,DB3)

	flagRs1 = False
	flagRs2 = False

	If Int(WebDBJoinCnt) > 0 Then flagRs1 = True
	If Int(CSDBJoinCnt) > 0 Then flagRs2 = True

'	print WebDBJoinCnt
'	print CSDBJoinCnt



	If flagRs1 Then
		print "1"
		Response.End
	End If

	If flagRs2 Then
		print "2"
		Response.End
	End If


	print "3&T&"&strName&"&"&strSSH1&"&"&strSSH2

'	Chked = Chked1
'
'	print Chked


%>