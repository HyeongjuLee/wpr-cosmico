<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/_include/document.asp" -->
<%
	'jQuery Modal Dialog
	'member_UnderInfo  산하회원정보
	'member_UnderSpon  후원산하정보
	If Not (checkRef(houUrl &"/myoffice/member/member_UnderInfo.asp") _
			Or checkRef(houUrl &"/myoffice/member/member_UnderSpon.asp") _
			Or checkRef(houUrl &"/myoffice/member/pop_underMember.asp") _
			Or checkRef(houUrl &"/myoffice/buy/underPurchase.asp") ) Then
		Call alerts(LNG_ALERT_WRONG_ACCESS ,"close_p_modal","")
	End If

	Dim underType		:	underType = gRequestTF("u",False)
	'print underType
%>
<%

	strID = pRequestTF("user_id",False)
	If strID <> "" Then
	'	strID = Replace(Replace(strID,"%",""),"_","")
		If Not checkNameSearch(strID, 2, 20) Then
			'Call ALERTS(LNG_JS_NAME_FORM_CHECK,"close_p_modal","")
			LNG_TEXT_NO_SEARCHED_MEMBER = LNG_JS_NAME_FORM_CHECK
		End If
	End If

	Dim popWidth : popWidth = 550
	Dim popHeight : popHeight = 600
	Dim PAGESIZE	:	PAGESIZE = pRequestTF("PAGESIZE",False)
	Dim PAGE		:	PAGE = pRequestTF("PAGE",False)
	If PAGESIZE = "" Then PAGESIZE = 20
	If PAGE = "" Then PAGE = 1

	Select Case underType
		Case "s"
			UNDER_INFOS_PROC = "HJP_MEMBER_SEARCH_UNDER_SPON"			'[후원하선]
		Case "v"
			UNDER_INFOS_PROC = "HJP_MEMBER_SEARCH_UNDER_VOTER"			'[추천하선])
		Case "a"
			UNDER_INFOS_PROC = "HJP_MEMBER_SEARCH_UNDER_VOTER_OR_SPON"			'[추천하선], [후원하선] 전체검색(중복제거)
		Case Else
			Call alerts(LNG_ALERT_WRONG_ACCESS,"close_p_modal","")
	End Select

	arrParams = Array(_
		Db.makeParam("@PAGESIZE",adInteger,adParamInput,0,PAGESIZE), _
		Db.makeParam("@PAGE",adInteger,adParamInput,0,PAGE), _
		Db.makeParam("@MBID",adVarChar,adParamInput,20,DK_MEMBER_ID1), _
		Db.makeParam("@MBID2",adInteger,adParamInput,0,DK_MEMBER_ID2), _
		Db.makeParam("@M_name",adVarWChar,adParamInput,100,strID), _
		Db.makeParam("@All_Count",adInteger,adParamOutput,0,0) _
	)
	arrList = Db.execRsList(UNDER_INFOS_PROC,DB_PROC,arrParams,listLen,DB3)
	ALL_COUNT = arrParams(UBound(arrParams))(4)
	'print All_Count

	Dim PAGECOUNT,CNT
	PAGECOUNT = Int(((All_Count) - 1 ) / CInt(PAGESIZE)) + 1
	IF PAGE = 1 Then
		CNT = All_Count
	Else
		CNT = All_Count - (((PAGE)-1)*CInt(PAGESIZE)) '
	End If

	If UCase(Lang) = "KR" Then
		imes = " imes_kr"
	Else
		imes = " imes"
	End If
%>
<link rel="stylesheet" href="/css/popStyle.css?v0.1" />
<script type="text/javascript">
	//modal
	function insertThisValue(fvalue,fvalue1,fvalue2,fvalue3,Enc_mbid,Enc_mbid2)
	{
		parent.document.dateFrm.UnderID1.value = Enc_mbid;
		parent.document.dateFrm.UnderID2.value = Enc_mbid2;
		//parent.document.dateFrm.UnderName.value = fvalue3;
		parent.document.dateFrm.UnderName.value = fvalue3+' ('+fvalue+'-'+fvalue1+')';
		parent.$("#modal_view").dialog("close");
	}
</script>
</head>
<body onload="document.pfrm.user_id.focus();">
<div id="pop_search">
	<div class="content" style="width:100%;">
		<form name="pfrm" action="" method="post">
		<p class="tcenter">
			<span class="searchText vmiddle font13px" style="margin-top:12px;"><%=LNG_TEXT_NAME%></span>&nbsp;
			<input type="text" name="user_id" value="<%=strID%>" class="input_text vtop" style="padding:2px 5px;" tabindex="1" />
			<input type="submit" class="txtBtn small2 radius3" value="<%=LNG_TEXT_SEARCH%>" />

		<p class="tright">Page : <%=PAGE%> of <%=PAGECOUNT%></p>
		<table <%=tableatt1%> class="search_table" >
			<colgroup>
				<col width="12%" />
				<col width="34%" />
				<col width="30%" />
				<col width="24%" />
			</colgroup>
			<tr>
				<th><%=LNG_TEXT_NUMBER%></th>
				<th><%=LNG_TEXT_NAME%></th>
				<th><%=LNG_TEXT_ID%></th>
				<th><%=LNG_TEXT_MEMID%></th>
			</tr>
			<%
				If IsArray(arrList) Then
					Set objEncrypter = Server.CreateObject("Hyeongryeol.StringEncrypter")
						objEncrypter.Key = con_EncryptKey
						objEncrypter.InitialVector = con_EncryptKeyIV

					For i = 0 To listLen
						Nums = All_Count - (PAGESIZE*PAGE) + PAGESIZE - i

						arrList_RowNum			= arrList(0,i)
						arrList_M_Name			= arrList(1,i)
						arrList_WebID			= arrList(2,i)
						arrList_lvl				= arrList(3,i)
						arrList_mbid			= arrList(4,i)
						arrList_mbid2			= arrList(5,i)

						'하선회원 외 검색 방지 암호화
						On Error Resume Next
						Set StrCipher = Server.CreateObject("Hoyasoft.StrCipher")
							If arrList_mbid	<> "" Then Enc_mbid = Trim(StrCipher.Encrypt(arrList_mbid,EncTypeKey1,EncTypeKey2))
							If arrList_mbid2<> "" Then Enc_mbid2 = Trim(StrCipher.Encrypt(arrList_mbid2,EncTypeKey1,EncTypeKey2))
						Set StrCipher = Nothing
						On Error GoTo 0

						'Enc_mbid = arrList_mbid
						'Enc_mbid2 = arrList_mbid2

						Tr_OnclickMsg = "insertThisValue('"&arrList_mbid&"','"&arrList_mbid2&"','"&arrList_WebID&"','"&arrList_M_Name&"','"&Enc_mbid&"','"&Enc_mbid2&"')"
						bgcol = ""

			%>
			<tr class="tron cp" onclick="<%=Tr_OnclickMsg%>" style="<%=bgcol%>">
				<td><%=Nums%></td>
				<td><%=arrList_M_Name%></td>
				<td><%=arrList_WebID%></td>
				<td><%=arrList_mbid%> - <%=Fn_MBID2(arrList_mbid2)%></td>
			</tr>
			<%
					Next
					Set objEncrypter = Nothing
				Else
			%>
			<tr>
				<td colspan="5" style="padding:30px 0px;">
					<%If strID = "" Then
						PRINT LNG_TEXT_INPUT_SEARCH_WORD
					Else
						PRINT LNG_TEXT_NO_SEARCHED_MEMBER
					End If%>
				</td>
			</tr>
			<%
				End If
			%>
		</table>
		</form>
		<div class="pagingNew3"><%Call pageListNew3(PAGE,PAGECOUNT)%></div>
	</div>
	<!-- <div class="close">
		<span class="button medium tweight" style="margin-top:10px;"><a onclick="self.close();"><%=LNG_TEXT_WINDOW_CLOSE%></a></span>
	</div> -->
</div>
<form name="frm" method="post" action="">
	<input type="hidden" name="PAGE" value="<%=PAGE%>" />
	<input type="hidden" name="user_id" value="<%=strID%>" />
</form>


<script type="text/javascript">
resizePopupWindow(parseInt("<%=popWidth%>", 10), parseInt("<%=popHeight%>", 10));
</script>
</body>
</html>
