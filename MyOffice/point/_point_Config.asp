<%
'If webproIP <> "T" Then Call ALERTS(LNG_READY_02_01,"back","")

	If isSHOP_POINTUSE <> "T" Then Call ALERTS(LNG_ALERT_WRONG_ACCESS,"BACK","")

	'▣사용자/이체 비번 체크
	SQL_PASS = "SELECT [WebPassword],[SendPassWord],[bankcode],[bankaccnt],[bankowner] "
	SQL_PASS = SQL_PASS& " FROM [tbl_MemberInfo] WITH(NOLOCK) WHERE [mbid] = ? AND [mbid2] = ?"
	arrParams = Array(_
		Db.makeParam("@mbid",adVarChar,adParamInput,20,DK_MEMBER_ID1), _
		Db.makeParam("@mbid2",adInteger,adParamInput,0,DK_MEMBER_ID2) _
	)
	Set HJRS = Db.execRs(SQL_PASS,DB_TEXT,arrParams,DB3)
	If Not HJRS.BOF And Not HJRS.EOF Then
		CONFIG_WebPassword	= HJRS("WebPassword")
		CONFIG_SendPassWord	= HJRS("SendPassWord")
		CONFIG_bankcode	= HJRS("bankcode")
		CONFIG_bankaccnt	= HJRS("bankaccnt")
		CONFIG_bankowner	= HJRS("bankowner")
	End If
	Call closeRS(HJRS)

	CONFIG_CPNO_OK = ""
	If UCase(DK_MEMBER_NATIONCODE) = "KR" And F_CPNO_CHANGE_TF = "T" Then
		CONFIG_CPNO_OK = "F"
	End If

	CONFIG_BANKINFO = "T"
	If CONFIG_bankcode = "" Or CONFIG_bankaccnt = "" Or CONFIG_bankowner = "" Then
		CONFIG_BANKINFO = "F"
	End If


	If MOB_PATH = "/m" Then
		chgPath = "/m"
	Else
		chgPath = "/myoffice"
	End If

	'초기화
	RESET_TO_MAIL = "T"
	RESET_TO_MOBILE = "F"

%>
