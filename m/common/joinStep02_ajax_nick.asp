<!--#include virtual = "/_lib/strFunc.asp"-->
<%

	Session.CodePage = 65001
	Response.CharSet = "UTF-8"
	Response.AddHeader "Pragma","no-cache"
	Response.AddHeader "Expires","0"


	strNickName = Trim(Request("strNickName"))


	arrParams = Array(_
		Db.makeParam("@strUserID",adVarChar,adParamInput,50,strNickName) _
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

'		print BLOCKID

	If Not DKRS.BOF And Not DKRS.EOF Then
		PRINT strNickName&"&F&사용불가 별칭 (재확인)"
	Else
		If InStr(","& BLOCKID &",",","& strNickName &",") > 0 Then
			PRINT strNickName&"&F&사용불가 별칭 (재확인)"
		Else
			PRINT strNickName&"&T&사용가능 별칭"
		End If
	End If



	Call closeRs(DKRS)


%>