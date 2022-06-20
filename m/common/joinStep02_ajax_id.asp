<!--#include virtual = "/_lib/strFunc.asp"-->
<%

	Session.CodePage = 65001
	Response.CharSet = "UTF-8"
	Response.AddHeader "Pragma","no-cache"
	Response.AddHeader "Expires","0"


	strUserID = Trim(Request("strUserID"))


' 차단 아이디 확인
	SQL1 = " SELECT [strBlockID] FROM [DK_SITE_CONFIG] WHERE [strSiteID] = ?"
	arrParams1 = Array(_
		Db.makeParam("@strSiteID",adVarchar,adParamInput,20,"www") _
	)
	Set DKRS1 = Db.execRs(SQL1,DB_TEXT,arrParams1,Nothing)
	BLOCKID = ""
	If Not DKRS1.BOF And Not DKRS1.EOF Then
		BLOCKID = DKRS1(0)
	End If
	Call closeRS(DKRS1)




	arrParams = Array(_
		Db.makeParam("@strUserID",adVarChar,adParamInput,20,strUserID) _
	)
	Set DKRS = Db.execRs("DKP_IDCHECK",DB_PROC,arrParams,Nothing)			' 쇼핑몰 아이디 확인
	Set DKRS2 = Db.execRs("DKP_IDCHECK",DB_PROC,arrParams,DB3)		' CS 웹 아이디 확인


	If Not DKRS.BOF And Not DKRS.EOF Then
		PRINT strUserID&"&F&사용불가(WEB) 아이디 (재확인)"
	Else
		If Not DKRS2.BOF And Not DKRS2.EOF Then
			PRINT strUserID&"&F&사용불가(CS) 아이디 (재확인)"
		Else
			If InStr(","& BLOCKID &",",","& strUserID &",") > 0 Then
				PRINT strUserID&"&F&사용불가(CS) 아이디 (재확인)"
			Else
				Response.WRITE strUserID&"&T&사용가능 아이디"
			End If
		End If
	End If

	Call closeRs(DKRS)
	Call closeRs(DKRS2)


%>