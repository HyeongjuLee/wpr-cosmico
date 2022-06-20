<!--#include virtual = "/_lib/strFunc.asp"-->
<%

	Session.CodePage = 949
	Response.CharSet = "euc-kr"
	Response.AddHeader "Pragma","no-cache"
	Response.AddHeader "Expires","0"

	strMob1 = gRequestTF("mbs1",True)
	strMob2 = gRequestTF("mbs2",True)
	strMob3 = gRequestTF("mbs3",True)

	strMobile = strMob1&strMob2&strMob3

	Set objEncrypter = Server.CreateObject ("Hyeongryeol.StringEncrypter")
		objEncrypter.Key = con_EncryptKey
		objEncrypter.InitialVector = con_EncryptKeyIV
		On Error Resume Next
			If strMobile  <> "" Then strMobile	= objEncrypter.Encrypt(strMobile)
		On Error GoTo 0
	Set objEncrypter = Nothing

	'print strMobile

	'CS체크
	SQL = "SELECT [hptel] FROM [tbl_Memberinfo] WHERE [hptel] = ?"
	arrParams = Array(_
		Db.makeParam("@hptel",adVarChar,adParamInput,100,strMobile) _
	)
	Set DKRS = Db.execRs(SQL,DB_TEXT,arrParams,DB3)

	If Not DKRS.BOF And Not DKRS.EOF Then
		PRINT "<span style=""color:red;font-weight:bold"">이미 CS에 등록된 휴대전화번호입니다.</span>"
		PRINT "<input type=""hidden"" name=""MobCheck"" value=""F"" readonly=""readonly"" />"
		PRINT "<input type=""hidden"" name=""chkMobNum1"" value="""&strMob1&""" readonly=""readonly"" />"
		PRINT "<input type=""hidden"" name=""chkMobNum2"" value="""&strMob2&""" readonly=""readonly"" />"
		PRINT "<input type=""hidden"" name=""chkMobNum3"" value="""&strMob3&""" readonly=""readonly"" />"
	Else
		PRINT "<span style=""color:blue;font-weight:bold"">등록가능한 휴대전화입니다. </span>"
		PRINT "<input type=""hidden"" name=""MobCheck"" value=""T"" readonly=""readonly"" />"
		PRINT "<input type=""hidden"" name=""chkMobNum1"" value="""&strMob1&""" readonly=""readonly"" />"
		PRINT "<input type=""hidden"" name=""chkMobNum2"" value="""&strMob2&""" readonly=""readonly"" />"
		PRINT "<input type=""hidden"" name=""chkMobNum3"" value="""&strMob3&""" readonly=""readonly"" />"
	End If

	Call closeRs(DKRS)

%>

