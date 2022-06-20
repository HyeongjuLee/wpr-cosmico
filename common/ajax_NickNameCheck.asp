<!--#include virtual = "/_lib/strFunc.asp"-->
<%

	Session.CodePage = 65001
	Response.CharSet = "UTF-8"
	Response.AddHeader "Pragma","no-cache"
	Response.AddHeader "Expires","0"

	strUserID = pRequestTF("ids",True)


	arrParams = Array(_
		Db.makeParam("@strUserID",adVarChar,adParamInput,50,strUserID) _
	)
	Set DKRS = Db.execRs("DKP_NICKCHECK",DB_PROC,arrParams,Nothing)

	' 차단 아이디 확인
		arrParams1 = Array(_
			Db.makeParam("@strSiteID",adVarchar,adParamInput,20,"www") _
		)
		Set DKRS1 = Db.execRs("DKP_BLOCKID",DB_PROC,arrParams1,Nothing)
		BLOCKID = ""
		If Not DKRS1.BOF And Not DKRS1.EOF Then
			BLOCKID = DKRS1(0)
		End If
		Call closeRS(DKRS1)

		'print BLOCKID

	If Not DKRS.BOF And Not DKRS.EOF Then
		RS_strUserID = DKRS("strNickName")
		PRINT "<span style=""color:red;font-weight:bold"">"&LNG_AJAX_NICKNAMECHECK_TEXT01&"</span>"
		PRINT "<input type=""hidden"" name=""Nickcheck"" value=""F"" readonly=""readonly"" /><input type=""hidden"" name=""chkNick"" value="""&strUserID&""" readonly=""readonly"" />"
	Else
		If InStr(","& BLOCKID &",",","& strUserID &",") > 0 Then
			PRINT "<span style=""color:red;font-weight:bold"">"&LNG_AJAX_NICKNAMECHECK_TEXT01&"</span>"
			PRINT "<input type=""hidden"" name=""Nickcheck"" value=""F"" readonly=""readonly"" /><input type=""hidden"" name=""chkNick"" value="""&strUserID&""" readonly=""readonly"" />"
		Else
			PRINT "<span style=""color:blue;font-weight:bold"">"&LNG_AJAX_NICKNAMECHECK_TEXT02&"</span>"
			PRINT "<input type=""hidden"" name=""Nickcheck"" value=""T"" readonly=""readonly"" /><input type=""hidden"" name=""chkNick"" value="""&strUserID&""" readonly=""readonly"" />"
		End If
	End If



	Call closeRs(DKRS)
'print TempCnt

%>
