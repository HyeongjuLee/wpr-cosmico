<!--#include virtual ="/_lib/strFunc.asp" -->
<!--#include virtual ="/m/_include/document.asp" -->
<!--#include virtual = "/m/_include/jqueryload.asp"-->
<%
	'jQuery Modal Dialog
	'member_UnderInfo  산하회원정보
	'member_UnderSpon  후원산하정보
	If Not (checkRef(houUrl &"/m/member/member_UnderInfo.asp") _
			Or checkRef(houUrl &"/m/member/member_UnderSpon.asp") _
			Or checkRef(houUrl &"/m/member/pop_underMember.asp") _
			Or checkRef(houUrl &"/m/buy/underPurchase.asp") ) Then
		Call alerts(LNG_ALERT_WRONG_ACCESS,"close_p_modal","")
	End If

	Dim underType		:	underType = gRequestTF("u",False)
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
	If PAGESIZE = "" Then PAGESIZE = 10
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
<link type="text/css" rel="stylesheet" href="/jquerymobile/jquery.mobile-1.3.2.min.css" />
<link rel="stylesheet" href="/m/css/modal.css?v0">
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
<div id="pop_search" class="width100">
	<form name="pfrm" action="" method="post">
		<div id="searchs">
			<input type="text" name="user_id" value="<%=strID%>" class="<%=imes%>"/>
			<label class="search">
				<input type="submit" value="<%=LNG_TEXT_SEARCH%>" class="button" />
				<i class="icon-search-sharp"></i>
			</label>
		</div>
	</form>
	<div class="tables">
		<p class="tright">Page : <%=PAGE%> of <%=PAGECOUNT%></p>
		<table <%=tableatt1%> class="width100">
			<colgroup>
				<col width="" />
				<col width="" />
				<col width="" />
				<col width="" />
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
					<%If strID = "" Then%>
						<span class="tweight lightBlue" ><%=LNG_TEXT_INPUT_SEARCH_WORD%></span>
					<%Else%>
						<span class="tweight red2"><%=LNG_TEXT_NO_SEARCHED_MEMBER%></span>
					<%End If%>
				</td>
			</tr>
			<%
				End If
			%>
		</table>
	</div>
	<div class="pagingArea pagingMob5n"><% Call pageListMob5n(PAGE,PAGECOUNT)%></div>

	<!-- <div class="close width100 tcenter" style="margin:5px 0px 30px 0px;">
		<input type="button" value="<%=LNG_TEXT_WINDOW_CLOSE%>" onclick="self.close();" class="popClose" />
	</div> -->

</div>


	<form name="frm" method="post" action="">
		<input type="hidden" name="PAGE" value="<%=PAGE%>" />
		<input type="hidden" name="user_id" value="<%=strID%>" />
	</form>

</body>
</html>
