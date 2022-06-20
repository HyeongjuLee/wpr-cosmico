<!--#include virtual="/_lib/strFunc.asp" -->
<%
	NO_MEMBER_REDIRECT = "F"
%>
<!--#include virtual="/_include/document.asp" -->
<%
	'jQuery Modal Dialog방식변경
	If Not (checkRef(houUrl &"/myoffice/point/pop_memberSearch.asp") _
			Or checkRef(houUrl &"/myoffice/point/point_transfer.asp")) Then
		Call alerts(LNG_ALERT_WRONG_ACCESS,"close_p_modal","")
	End If
%>
<%
	strID = pRequestTF("user_id",False)
	If strID <> "" Then
		strID = Replace(Replace(strID,"%",""),"_","")
		If Not checkNameSearch(strID, 2, 20) Then
			'Call ALERTS(LNG_JS_NAME_FORM_CHECK,"back","")
			LNG_TEXT_NO_SEARCHED_MEMBER = LNG_JS_NAME_FORM_CHECK
		End If
	End If

	Dim popWidth : popWidth = 550
	Dim popHeight : popHeight = 600
	Dim PAGESIZE	:	PAGESIZE = pRequestTF("PAGESIZE",False)
	Dim PAGE		:	PAGE = pRequestTF("PAGE",False)
	If PAGESIZE = "" Then PAGESIZE = 10
	If PAGE = "" Then PAGE = 1

	arrParams = Array(_
		Db.makeParam("@PAGESIZE",adInteger,adParamInput,0,PAGESIZE), _
		Db.makeParam("@PAGE",adInteger,adParamInput,0,PAGE), _
		Db.makeParam("@M_name",adVarChar,adParamInput,50,strID), _
		Db.makeParam("@MBID1",adVarChar,adParamInput,20,DK_MEMBER_ID1), _
		Db.makeParam("@MBID2",adInteger,adParamInput,4,DK_MEMBER_ID2), _
		Db.makeParam("@strNationCode",adVarChar,adParamInput,6,UCase(DK_MEMBER_NATIONCODE)), _
		Db.makeParam("@All_Count",adInteger,adParamOutput,0,0) _
	)
	arrList = Db.execRsList("DKP_MEMBER_SEARCH_POINT",DB_PROC,arrParams,listLen,DB3)
	'arrList = Db.execRsList("HJP_MEMBER_SEARCH_POINT_ALL_NACODE",DB_PROC,arrParams,listLen,DB3)		'전 국가 허용
	ALL_COUNT = arrParams(UBound(arrParams))(4)

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
<link rel="stylesheet" href="/css/popStyle.css" />
<script type="text/javascript">

	//modal
	function insertThisValue(fvalue,fvalue1,fvalue2,fvalue3)
	{
		parent.document.cfrm.NominID1.value = fvalue;
		parent.document.cfrm.NominID2.value = fvalue1;
		parent.document.cfrm.NominWebID.value = fvalue2;
		parent.document.cfrm.targetName.value = fvalue3;
		parent.document.cfrm.NominChk.value = 'T';
		parent.$("#modal_view").dialog("close");
	}

</script>
</head>
<body onload="document.pfrm.user_id.focus();">
<div id="pop_search">
	<!-- <div class="bgtitle">
		<span class="bgFont"><%=CS_NOMIN%>&nbsp;<%=LNG_TEXT_SEARCH%></span>
	</div> -->
	<div class="content" style="width:100%;">
		<form name="pfrm" action="" method="post">
		<p class="tcenter">
			<span class="searchText vmiddle font13px" style="margin-top:12px;"><%=LNG_TEXT_NAME%></span>&nbsp;
			<input type="text" name="user_id" value="<%=strID%>" class="input_text vtop" style="padding:2px 5px;" tabindex="1" />
			<input type="submit" class="txtBtn j_medium" value="<%=LNG_TEXT_SEARCH%>"  />
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
				<!-- <th><%=LNG_TEXT_BIRTH%></th> -->
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
						arrList_cpno			= arrList(3,i)
						arrList_mbid			= arrList(4,i)
						arrList_mbid2			= arrList(5,i)

						arrList_Sell_Mem_Type	= arrList(6,i)

						arrList_BirthDay		= arrList(7,i)
						arrList_BirthDay_M		= arrList(8,i)
						arrList_BirthDay_D		= arrList(9,i)

						Birth = arrList_BirthDay&arrList_BirthDay_M


						Tr_OnclickMsg = "insertThisValue('"&arrList_mbid&"','"&arrList_mbid2&"','"&arrList_WebID&"','"&arrList_M_Name&"')"
						bgcol = ""

			%>
			<tr class="tron cp" onclick="<%=Tr_OnclickMsg%>" style="<%=bgcol%>">
				<td><%=arrList_RowNum%></td>
				<td>
					<%If DKRSVI_MNAME <> "" And DKRSVI_MBID1 = arrList_mbid And DKRSVI_MBID2 = arrList_mbid2 Then%>
						<span class="tweight red2">※ <%=LNG_VIRAL_VOTER%></span><br />
						<span class="tweight blue2"><%=arrList_M_Name%></span>
					<%Else%>
						<%=arrList_M_Name%>
					<%End If%>
				</td>
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
						PRINT "<span class=""red2"">"&LNG_TEXT_NO_SEARCHED_MEMBER&"</span>"
					End If%>
				</td>
			</tr>
			<%
				End If
			%>
		</table>
		</form>
		<div class="pagingNew"><%Call pageListNew(PAGE,PAGECOUNT)%></div>
	</div>
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
