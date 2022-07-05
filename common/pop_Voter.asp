<!--#include virtual="/_lib/strFunc.asp" -->
<%
	NO_MEMBER_REDIRECT = "F"
%>
<!--#include virtual="/_include/document.asp" -->
<%
	'Response.Redirect "/common/pop_VoterSFV.asp"		'후원인은 추천인의 후원조직산하에 존재하는 회원 2021-08-17

	'jQuery Modal Dialog방식변경
	If Not (checkRef(houUrl &"/common/pop_voter.asp") _
			Or checkRef(houUrl &"/common/joinStep03.asp")) Then
		Call alerts(LNG_ALERT_WRONG_ACCESS,"close_p_modal","")
	End If

	'바이럴 추천인 자동호출
	DKRSVI_MBID1	= ""
	DKRSVI_MBID2	= ""
	DKRSVI_MNAME	= ""
	DKRSVI_CHECK	= "F"
	DKRSVI_WEBID	= ""
	If VIRAL_USE_TF = "T" Then
		If DK_MEMBER_VOTER_ID <> "" Then
			Set objEncrypter = Server.CreateObject ("Hyeongryeol.StringEncrypter")
				objEncrypter.Key = con_EncryptKey
				objEncrypter.InitialVector = con_EncryptKeyIV

				SQLVI = "SELECT [MBID],[MBID2],[M_NAME],[WebID] FROM [tbl_MemberInfo] WITH(NOLOCK) WHERE [webID] = ? "
				arrParamsVI = Array(_
					Db.makeParam("@WebID",adVarWChar,adParamInput,100,DK_MEMBER_VOTER_ID) _
				)
				Set DKRSVI = Db.execRs(SQLVI,DB_TEXT,arrParamsVI,DB3)
				If Not DKRSVI.BOF And Not DKRSVI.EOF Then
					DKRSVI_MBID1		= DKRSVI("MBID")
					DKRSVI_MBID2		= DKRSVI("MBID2")
					DKRSVI_MNAME		= DKRSVI("M_NAME")
					DKRSVI_CHECK		= "T"
					DKRSVI_WEBID		= DKRSVI("WebID")
					'DKRSVI_WEBID		= objEncrypter.DEcrypt(DKRSVI_WEBID)
				Else
					DKRSVI_MBID1		= ""
					DKRSVI_MBID2		= ""
					DKRSVI_MNAME		= ""
					DKRSVI_CHECK		= "F"
					DKRSVI_WEBID		= ""
				End If

			Set objEncrypter = Nothing
		End If
	End If
%>
<%

	'MEMBER_SEARCH_PROC = "DKP_MEMBER_SEARCH"
	MEMBER_SEARCH_PROC = "HJP_MEMBER_SEARCH_COSMMICO"			'COSMICO

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

'	PAGESUM = (PAGESIZE * (PAGE-1))

	'바이럴 추천인 자동호출
	If DKRSVI_MNAME <> "" AND strID = "" Then
		arrParams = Array(_
			Db.makeParam("@MBID",adVarChar,adParamInput,20,DKRSVI_MBID1), _
			Db.makeParam("@MBID2",adInteger,adParamInput,0,DKRSVI_MBID2) _
		)
		arrList = Db.execRsList("HJP_MEMBER_SEARCH_MBID12",DB_PROC,arrParams,listLen,DB3)
	Else
		arrParams = Array(_
			Db.makeParam("@PAGESIZE",adInteger,adParamInput,0,PAGESIZE), _
			Db.makeParam("@PAGE",adInteger,adParamInput,0,PAGE), _
			Db.makeParam("@M_name",adVarWChar,adParamInput,100,strID), _
			Db.makeParam("@All_Count",adInteger,adParamOutput,0,0) _
		)
		'arrList = Db.execRsList("DKP_MEMBER_SEARCH",DB_PROC,arrParams,listLen,DB3)
		arrList = Db.execRsList(MEMBER_SEARCH_PROC,DB_PROC,arrParams,listLen,DB3)
		ALL_COUNT = arrParams(UBound(arrParams))(4)
	End If
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
<link rel="stylesheet" href="/css/modal.css?" />
<script type="text/javascript">

	//modal
	function insertThisValue(fvalue,fvalue1,fvalue2,fvalue3)
	{
		parent.document.cfrm.NominID1.value = fvalue;
		parent.document.cfrm.NominID2.value = fvalue1;
		parent.document.cfrm.NominWebID.value = fvalue2;
		parent.document.cfrm.voter.value = fvalue3;
		parent.document.cfrm.NominChk.value = 'T';
		parent.document.cfrm.NominCom.value = 'F';
		parent.$("#modal_view").dialog("close");
	}

</script>
</head>
<body onload="document.pfrm.user_id.focus();">
<div id="pop_search" class="pop_voter">
	<form name="pfrm" action="" method="post">
		<div class="searchs">
			<span class="searchText"><%=LNG_TEXT_NAME%></span>
			<input type="text" name="user_id" value="<%=strID%>" class="input_text vtop" tabindex="1" />
			<label class="search">
				<input type="submit" class="button" value="<%=LNG_TEXT_SEARCH%>" />
				<i class="icon-search-sharp"></i>
			</label>
		</div>
		<div class="tables">
			<p class="tright">Page : <%=PAGE%> of <%=PAGECOUNT%></p>
			<table <%=tableatt1%> class="width100" >
				<!-- <colgroup>
					<col width="12%" />
					<col width="34%" />
					<col width="30%" />
					<col width="24%" />
				</colgroup> -->
				<thead>
					<tr>
						<!-- <th><%=LNG_TEXT_NUMBER%></th> -->
						<th><%=LNG_TEXT_NAME%></th>
						<th><%=LNG_TEXT_ID%></th>
						<!-- <th><%=LNG_TEXT_BIRTH%></th> -->
						<th><%=LNG_TEXT_MEMID%></th>
						<th><%=LNG_TEXT_CENTER%></th>
					</tr>
				</thead>
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

							arrList_CurGrade		= arrList(10,i)
							arrList_centerName		= arrList(11,i)

							Birth = arrList_BirthDay&arrList_BirthDay_M


							'▣ 승인매출 체크
							'arrParamsSC = Array(_
							'	Db.makeParam("@mbid",adVarChar,adParamInput,20,arrList_mbid), _
							'	Db.makeParam("@mbid2",adInteger,adParamInput,0,arrList_mbid2) _
							')
							'arrMEMBER_ORDER_CHK = Db.execRsData("HJP_TOTAL_SALES_COUNT_APPROVED",DB_PROC,arrParamsSC,DB3)
							'
							'If arrMEMBER_ORDER_CHK > 0 Then
	    					'	Tr_OnclickMsg = "insertThisValue('"&arrList_mbid&"','"&arrList_mbid2&"','"&arrList_WebID&"','"&arrList_M_Name&"')"
							'	bgcol = ""
							'Else
							'	Tr_OnclickMsg = "alert('"&LNG_POP_CANNOT_REGIST_MEM&"');"
							'	bgcol = "background:#999999;"
							'End If

							''Tr_OnclickMsg = "insertThisValue('"&arrList_mbid&"','"&arrList_mbid2&"','"&arrList_WebID&"','"&arrList_M_Name&"')"



							Tr_OnclickMsg = "insertThisValue('"&arrList_mbid&"','"&arrList_mbid2&"','"&arrList_WebID&"','"&arrList_M_Name&"')"
							bgcol = ""

				%>
				<tr class="tron cp" onclick="<%=Tr_OnclickMsg%>" style="<%=bgcol%>">
					<!-- <td><%=Nums%></td> -->
					<td>
						<%If DKRSVI_MNAME <> "" And DKRSVI_MBID1 = arrList_mbid And DKRSVI_MBID2 = arrList_mbid2 Then%>
							<span class="tweight red2">※ <%=LNG_VIRAL_VOTER%></span><br />
							<span class="tweight blue2"><%=arrList_M_Name%></span>
						<%Else%>
							<%=arrList_M_Name%>
						<%End If%>
					</td>
					<td><%=arrList_WebID%></td>
					<!-- <td><%=Birth%></td> -->
					<td><%=arrList_mbid%> - <%=Fn_MBID2(arrList_mbid2)%></td>
					<td><%=arrList_centerName%></td>
					<!-- <td><%=arrMEMBER_ORDER_CHK%></td> -->
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
		<div class="pagingNew3"><%Call pageListNew(PAGE,PAGECOUNT)%></div>
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
