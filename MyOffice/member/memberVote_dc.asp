<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	PAGE_SETTING = "MYOFFICE"
	INFO_MODE	 = "MEMBER1-3"

	ISLEFT = "T"
	ISSUBTOP = "T"

	Call ONLY_CS_MEMBER()

%>
<!--#include virtual = "/_include/document.asp"-->
<link rel="stylesheet" href="/myoffice/css/style_cs.css" />
<link rel="stylesheet" href="/myoffice/css/layout_cs.css" />
</head>
<body>
<!--#include virtual = "/_include/header.asp"-->
<div id="member" class="member_vote">
<%
'	SQL = "SELECT [mbid],[mbid2],[M_Name],[Regtime],[cpno],[hptel],[BirthDay],[WebID] FROM [tbl_memberinfo] WHERE [NOMINID] = ? AND [NOMINID2] = ? ORDER BY [N_LineCnt]"
	SQL = "SELECT [mbid],[mbid2],[M_Name],[Regtime],[cpno],[hptel],[BirthDay],[WebID] FROM [tbl_memberinfo] WHERE [NOMINID] = ? AND [NOMINID2] = ? AND [Sell_Mem_TF] = 1 ORDER BY [N_LineCnt]"
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
		<col width="" />
		<col width="" />
		<col width="*" />
		<tr>
			<th>번호</th>
			<th>회원고유값</th>
			<th>성명</th>
			<th>등록된 연락처</th>
			<th>등록일</th>
			<th>생년월일</th>
		</tr>
		<%
			If IsArray(arrList) Then

			Set objEncrypter = Server.CreateObject ("Hyeongryeol.StringEncrypter")
				objEncrypter.Key = con_EncryptKey
				objEncrypter.InitialVector = con_EncryptKeyIV
				For i = 0 To listLen
					If arrList(5,i) <> "" And DKCONF_SITE_ENC = "T" Then
						hptel = objEncrypter.Decrypt(arrList(5,i))
					Else
						hptel = arrList(5,i)
					End if
					'hptel = Left(hptel,4)&"****"&Right(hptel,5)

					PRINT TABS(1) & "	<tr>"
					PRINT TABS(1) & "		<td>"&i+1&"</td>"
					PRINT TABS(1) & "		<td>"&arrList(0,i)&"-"&Fn_MBID2(arrList(1,i))&"</td>"
					PRINT TABS(1) & "		<td>"&arrList(2,i)&"</td>"
					PRINT TABS(1) & "		<td>"&hptel&"</td>"
					PRINT TABS(1) & "		<td>"&date8to10(arrList(3,i))&"</td>"
					PRINT TABS(1) & "		<td>"&date8to10(arrList(6,i))&"</td>"
					PRINT TABS(1) & "	</tr>"
				Next
			Set objEncrypter = Nothing
			Else
					PRINT TABS(1) & "	<tr>"
					PRINT TABS(1) & "		<td colspan=""6"" class=""notData"">추천인 정보가 없습니다.</td>"
					PRINT TABS(1) & "	</tr>"
			End If
		%>

	</table>
</div>
<!--#include virtual = "/_include/copyright.asp"-->
