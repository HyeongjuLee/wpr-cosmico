<!--#include virtual = "/_lib/strFunc.asp"-->
<%

	Call ONLY_CSMEMBER_CLOSE()
	Session.CodePage = 65001
	Response.CharSet = "UTF-8"
	Response.AddHeader "Pragma","no-cache"
	Response.AddHeader "Expires","0"


		sname = gRequestTF("sname",True)


'		DK_MEMBER_ID1 = "00"
'		DK_MEMBER_ID2 = 1010749
		arrParams = Array(_
			Db.makeParam("@DK_MEMBER_ID",adVarChar,adParamInput,20,DK_MEMBER_ID1),_
			Db.makeParam("@DK_MEMBER_ID2",adInteger,adParamInput,0,DK_MEMBER_ID2),_
			Db.makeParam("@SNAME",adVarWChar,adParamInput,20,sname)_
		)
		arrList = Db.execRsList("DKP_VOTER_DOWN_LIST",DB_PROC,arrParams,listLen,DB3)

		PRINT "<div class=""listscroll"">"
		PRINT "<table "&tableatt&" style=""width:100%;"" class=""sTable"">"
		PRINT "<col width=""30%"">"
		PRINT "<col width=""50%"">"
		PRINT "<col width=""20%"">"
		PRINT "	<tr><th colspan=""3"" align=""center"">"&LNG_TEXT_SEARCH_RESULT&"</th></tr>"
		PRINT "	<tr><th>"&LNG_TEXT_MEMID&"</th><th>"&LNG_TEXT_NAME&"</th><th>"&viewImg(IMG&"/tree/tree_select.png",18,18,"")&"</th></tr>"
		If IsArray(arrList) Then
			For i = 0 To listLen
				PRINT "	<tr><td style=""padding:3px 0px;"">"&arrList(0,i)&"-"&Fn_MBID2(arrList(1,i))&"</td><td>"&arrList(2,i)&"</td><td><a href=""?sid1="&arrList(0,i)&"&amp;sid2="&arrList(1,i)&""">선택</a></td></tr>"
			Next
		Else
			Select Case UCase(lang)
				Case "","KR"
					PRINT "<tr><td colspan=""3"" class=""notData"">"&sname&"로 검색된 하위 회원이 없습니다</td></tr>"
				Case "EN"
					PRINT "<tr><td colspan=""3"" class=""notData"">No sub-member is searched by the name of "&sname&"</td></tr>"
				Case "CN"
					PRINT "<tr><td colspan=""3"" class=""notData"">没有通过所输入的关键词搜索到的会员。</td></tr>"
				Case "ID"
					PRINT "<tr><td colspan=""3"" class=""notData"">Downline yang dicari dengan "&sname&" tidak dapat ditemukan.</td></tr>"
				Case "TH"
					PRINT "<tr><td colspan=""3"" class=""notData"">ไม่พบสมาชิกระดับล่างที่ทำการค้นหาโดย "&sname&"</td></tr>"
			End Select		End If
		PRINT "</table>"
		PRINT "</div>"
%>
