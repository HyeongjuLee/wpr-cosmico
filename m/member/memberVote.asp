<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	PAGE_SETTING = "MY_MEMBER"

	Call FNC_ONLY_CS_MEMBER()

	Response.Redirect "/m/member/member_UnderInfo.asp?sc=v"
%>
<!--#include virtual = "/m/_include/document.asp"-->
<!--#include virtual = "/m/_include/jqueryload.asp"-->

</head>
<body>
<!--#include virtual = "/m/_include/header.asp"-->
<!--#include virtual = "/m/_include/sub_header.asp"-->
<link rel="stylesheet" href="member.css" />

<script type="text/javascript">
 $(document).ready(
	function() {
		$("tbody.htbody tr:last-child td").css("border-bottom", "2px solid #000");
	});
</script>
<div id="subTitle" class="width100 tcenter text_noline" ><%=LNG_MYOFFICE_MEMBER_02%></div>

<div id="member" class="member_vote">
<%
	SQL = "SELECT [mbid],[mbid2],[M_Name],[Regtime],[cpno],[hptel],[BirthDay],[WebID],[BirthDay_M],[BirthDay_D],[Sell_Mem_TF] FROM [tbl_memberinfo] WITH(NOLOCK) WHERE [NOMINID] = ? AND [NOMINID2] = ? ORDER BY [N_LineCnt]"
	arrParams = Array(_
		Db.makeParam("@mbid",adVarChar,adParamInput,20,DK_MEMBER_ID1), _
		Db.makeParam("@mbid2",adInteger,adParamInput,0,DK_MEMBER_ID2) _
	)
	arrList = Db.execRsList(SQL,DB_TEXT,arrParams,listLen,DB3)
%>
	<table <%=tableatt%> class="width100">
		<col width="40" />
		<col width="30%" />
		<col width="25%" />
		<col width="*" />
		<tr>
			<th><%=LNG_TEXT_NUMBER%></th>
			<th><%=LNG_TEXT_MEMID%></th>
			<th><%=LNG_TEXT_NAME%></th>
			<!-- <th><%=LNG_TEXT_WEBID%></th -->
			<th><%=LNG_BTN_DETAIL%></th>
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

					WebID = arrList(7,i)

					V_Sell_Mem_TF = arrList(10,i)

					Select Case V_Sell_Mem_TF
						Case 0
							V_Sell_Mem_TF = "판매원"
						Case 1
							V_Sell_Mem_TF = "소비자"
					End Select

'					If arrList(5,i) <> "" Then arrList_Tel = objEncrypter.Decrypt(arrList(5,i)) Else arrList_Tel = arrList(5,i) End If
'					If arrList(4,i) <> "" Then arrList_ssn1 = objEncrypter.Decrypt(arrList(4,i)) Else arrList_Tel = arrList(4,i) End If

					PRINT TABS(1) & "	<tr>"
					PRINT TABS(1) & "		<td class=""tcenter"">"&i+1&"</td>"
					PRINT TABS(1) & "		<td class=""tcenter"">"&arrList(0,i)&"-"&Fn_MBID2(arrList(1,i))&"</td>"
					'PRINT TABS(1) & "		<td class=""tcenter"">"&WebID&"</td>"
					PRINT TABS(1) & "		<td class=""tcenter"">"&arrList(2,i)&"</td>"
					PRINT TABS(1) & "		<td><a class=""btn_a"" onclick=""toggle_tbody('tbody"&i&"');"">"&LNG_BTN_DETAIL&"</a></td>"
					PRINT TABS(1) & "	</tr>"
					PRINT TABS(1) & "	<tbody id=""tbody"&i&""" class=""htbody"" style=""display:none;"">"
					'PRINT TABS(1) & "		<tr>"
					'PRINT TABS(1) & "			<td colspan=""2"" class=""tright"">"&LNG_TEXT_CONTACT_NUMBER&"</td>"
					'PRINT TABS(1) & "			<td colspan=""2"" class=""pad_l15"">"&hptel&"</td>"
					'PRINT TABS(1) & "		</tr>"
					PRINT TABS(1) & "		<tr>"
					PRINT TABS(1) & "			<td colspan=""2"" class=""tright"">"&LNG_TEXT_REGTIME&"</td>"
					PRINT TABS(1) & "			<td colspan=""2"" class=""pad_l15"">"&date8to10(arrList(3,i))&"</td>"
					PRINT TABS(1) & "		</tr>"
					PRINT TABS(1) & "		<tr>"
					''PRINT TABS(1) & "			<td colspan=""2"" class=""tright"">"&LNG_TEXT_BIRTH&"</td>"
					'PRINT TABS(1) & "			<td colspan=""2"" class=""pad_l15"">"&arrList(6,i)&arrList(8,i)&"</td>"
					'PRINT TABS(1) & "		</tr>"
					'PRINT TABS(1) & "		<tr>"
					'PRINT TABS(1) & "			<td colspan=""2"" class=""tright"">회원구분</td>"
					'PRINT TABS(1) & "			<td colspan=""2"" class=""pad_l15"">"&V_Sell_Mem_TF&"</td>"
					'PRINT TABS(1) & "		</tr>"
					PRINT TABS(1) & "	</tbody>"
				Next
			Set objEncrypter = Nothing
			Else
				PRINT TABS(1) & "	<tr>"
					PRINT TABS(1) & "		<td colspan=""4"" class=""notData"">"&LNG_CS_MEMBERVOTE_TEXT08&"</td>"
				PRINT TABS(1) & "	</tr>"
			End If		%>

	</table>
</div>

<!--#include virtual = "/m/_include/copyright.asp"-->