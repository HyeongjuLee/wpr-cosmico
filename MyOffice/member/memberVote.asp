<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	PAGE_SETTING = "MYOFFICE"
	INFO_MODE	 = "MEMBER1-2"

	ISLEFT = "T"
	ISSUBTOP = "T"

	Call ONLY_CS_MEMBER()

	Response.Redirect "/myoffice/member/member_UnderInfo.asp?sc=v"
%>
<!--#include virtual = "/_include/document.asp"-->
<link rel="stylesheet" href="/myoffice/css/style_cs.css" />
<link rel="stylesheet" href="/myoffice/css/layout_cs.css" />
</head>
<body>
<!--#include virtual = "/_include/header.asp"-->
<div id="member" class="member_vote">
<%
	SQL = "SELECT [mbid],[mbid2],[M_Name],[Regtime],[hptel],[WebID],[BirthDay],[BirthDay_M],[BirthDay_D],[Sell_Mem_TF] FROM [tbl_memberinfo] WHERE [NOMINID] = ? AND [NOMINID2] = ? ORDER BY [N_LineCnt]"
	arrParams = Array(_
		Db.makeParam("@mbid",adVarChar,adParamInput,20,DK_MEMBER_ID1), _
		Db.makeParam("@mbid2",adInteger,adParamInput,0,DK_MEMBER_ID2) _
	)
	arrList = Db.execRsList(SQL,DB_TEXT,arrParams,listLen,DB3)
%>
	<table <%=tableatt%> class="userCWidth">
		<col width="60" />
		<col width="" />
		<col width="" />
		<col width="*" />
		<tr>
			<th><%=LNG_TEXT_NUMBER%></th>
			<th><%=LNG_TEXT_MEMID%></th>
			<th><%=LNG_TEXT_NAME%></th>
			<!-- <th><%=LNG_TEXT_WEBID%></th> -->
			<!-- <th><%=LNG_TEXT_CONTACT_NUMBER%></th> -->
			<th><%=LNG_TEXT_REGTIME%></th>
			<!-- <th><%=LNG_TEXT_BIRTH%></th> -->
			<!-- <th><%=LNG_MEMBER_LOGIN_TEXT12%></th> -->
		</tr>
		<%
			If IsArray(arrList) Then
			Set objEncrypter = Server.CreateObject ("Hyeongryeol.StringEncrypter")
				objEncrypter.Key = con_EncryptKey
				objEncrypter.InitialVector = con_EncryptKeyIV
				For i = 0 To listLen
					arrList_mbid			= arrList(0,i)
					arrList_mbid2			= arrList(1,i)
					arrList_M_Name			= arrList(2,i)
					arrList_Regtime			= arrList(3,i)
					arrList_hptel			= arrList(4,i)
					arrList_WebID			= arrList(5,i)
					arrList_BirthDay			= arrList(6,i)
					arrList_BirthDay_M			= arrList(7,i)
					arrList_BirthDay_D			= arrList(8,i)
					arrList_Sell_Mem_TF			= arrList(9,i)

					On Error Resume Next
					If arrList_hptel <> "" And DKCONF_SITE_ENC = "T" Then
						arrList_hptel = objEncrypter.Decrypt(arrList_hptel)
					Else
						arrList_hptel = arrList_hptel
					End if
					On Error Goto 0

					Select Case arrList_Sell_Mem_TF
						Case 0
							arrList_Sell_Mem_TF = "판매원"
						Case 1
							arrList_Sell_Mem_TF = "소비자"
					End Select

					PRINT TABS(1) & "	<tr>"
					PRINT TABS(1) & "		<td>"&i+1&"</td>"
					PRINT TABS(1) & "		<td>"&arrList_mbid&"-"&Fn_MBID2(arrList_mbid2)&"</td>"
					PRINT TABS(1) & "		<td>"&arrList_M_Name&"</td>"
					'PRINT TABS(1) & "		<td>"&arrList_WebID&"</td>"
					PRINT TABS(1) & "		<td>"&date8to10(arrList_Regtime)&"</td>"
					'PRINT TABS(1) & "		<td>"&arrList_BirthDay&arrList_BirthDay_M&"</td>"
					'PRINT TABS(1) & "		<td>"&arrList_Sell_Mem_TF&"</td>"
					PRINT TABS(1) & "	</tr>"
				Next
			Set objEncrypter = Nothing
			Else
					PRINT TABS(1) & "	<tr>"
					PRINT TABS(1) & "		<td colspan=""4"" class=""notData"">"&LNG_CS_MEMBERVOTE_TEXT08&"</td>"
					PRINT TABS(1) & "	</tr>"
			End If
		%>

	</table>
</div>
<!--#include virtual = "/_include/copyright.asp"-->
