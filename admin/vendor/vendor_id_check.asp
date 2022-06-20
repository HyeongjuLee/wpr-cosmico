<!--#include virtual = "/_lib/strFunc.asp"-->
<%

	Session.CodePage = 65001
	Response.CharSet = "UTF-8"
	Response.AddHeader "Pragma","no-cache"
	Response.AddHeader "Expires","0"

	strShopID = gRequestTF("ids",True)

	arrParams = Array(_
		Db.makeParam("@strShopID",adVarChar,adParamInput,30,strShopID) _
	)
	ID_CNT = Db.execRsData("DKPA_TOTAL_ID_CHECK",DB_PROC,arrParams,Nothing)

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

		'print BLOCKID

	If ID_CNT > 0  Then
		PRINT "<span style=""color:red;font-weight:bold"">사용불가능한 아이디입니다.</span>"
		PRINT "<input type=""hidden"" name=""idcheck"" value=""F"" readonly=""readonly"" /><input type=""hidden"" name=""chkID"" value="""&strShopID&""" readonly=""readonly"" />"
	Else
		If InStr(","& BLOCKID &",",","& strShopID &",") > 0 Then
			PRINT "<span style=""color:red;font-weight:bold"">사용불가능한 아이디입니다. </span>"
			PRINT "<input type=""hidden"" name=""idcheck"" value=""F"" readonly=""readonly"" /><input type=""hidden"" name=""chkID"" value="""&strShopID&""" readonly=""readonly"" />"
		Else
			PRINT "<span style=""color:blue;font-weight:bold"">사용가능한 아이디입니다. </span>"
			PRINT "<input type=""hidden"" name=""idcheck"" value=""T"" readonly=""readonly"" /><input type=""hidden"" name=""chkID"" value="""&strShopID&""" readonly=""readonly"" />"
		End If

	End If



'print TempCnt

%>
